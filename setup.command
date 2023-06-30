#!/usr/bin/env bash

SCRIPT_PATH=$(dirname "$0")

# Create a duplicate of each photo, and then minify them
if [[ "$OSTYPE" == "darwin"* && -x "$(command -v sips)" ]]; then
  # sips is available
  # low res version of image
  python $SCRIPT_PATH/tools/duplicate.py min
  # sips -Z 3840 $SCRIPT_PATH/photos/**/*.min.jpeg &>/dev/null
  # sips -Z 3840 $SCRIPT_PATH/photos/**/*.min.png &>/dev/null
  # sips -Z 3840 $SCRIPT_PATH/photos/**/*.min.jpg &>/dev/null

  find $SCRIPT_PATH/photos -type f \( -name "*.min.jpeg" -o -name "*.min.png" -o -name "*.min.jpg" \) -print0 | while IFS= read -r -d $'\0' file; do
    width=$(sips -g pixelWidth "$file" | awk '/pixelWidth:/{print $2}')
    if (( width >= 2000 )); then
      sips -Z 2000 "$file" &>/dev/null
    fi
  done



  # placeholder image for lazy loading
  python $SCRIPT_PATH/tools/duplicate.py placeholder
  sips -Z 32 $SCRIPT_PATH/photos/**/*.placeholder.jpeg &>/dev/null
  sips -Z 32 $SCRIPT_PATH/photos/**/*.placeholder.png &>/dev/null
  sips -Z 32 $SCRIPT_PATH/photos/**/*.placeholder.jpg &>/dev/null
fi

if [ -n "$(uname -a | grep Ubuntu)" -a -x "$(command -v mogrify)" ]; then
  # mogrify is available
  # low res version of image
  python $SCRIPT_PATH/tools/duplicate.py min
  mogrify -resize 640x $SCRIPT_PATH/photos/**/*.min.jpeg &>/dev/null
  mogrify -resize 640x $SCRIPT_PATH/photos/**/*.min.png &>/dev/null
  mogrify -resize 640x $SCRIPT_PATH/photos/**/*.min.jpg &>/dev/null

  # placeholder image for lazy loading
  python $SCRIPT_PATH/tools/duplicate.py placeholder
  mogrify -resize 32x $SCRIPT_PATH/photos/**/*.placeholder.jpeg &>/dev/null
  mogrify -resize 32x $SCRIPT_PATH/photos/**/*.placeholder.png &>/dev/null
  mogrify -resize 32x $SCRIPT_PATH/photos/**/*.placeholder.jpg &>/dev/null
fi  

python $SCRIPT_PATH/tools/setup.py
