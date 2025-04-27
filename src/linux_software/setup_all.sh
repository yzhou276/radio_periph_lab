#!/bin/bash

# default values
STREAMING_APPLICATION=udpFifoStreamer2
ip=192.168.1.3
port=25344

# Read POST data -- GPT suggested this
read -n "$CONTENT_LENGTH" POST_DATA
# Parse IP and PORT from POST
ip=$(echo "$POST_DATA" | sed -n 's/.*ip=\([^&]*\).*/\1/p')
port=$(echo "$POST_DATA" | sed -n 's/.*port=\([^&]*\).*/\1/p')

killall -9 "$STREAMING_APPLICATION"

# Echo HTTP headers
echo "Content-type: text/html"
echo ""

# Echo HTML body
echo "<html><body><p><em>"
echo "Loading PL...<br>"
fpgautil -b design_1_wrapper.bit.bin
echo "</p></em><p>"

echo "Configuring Codec...<br>"
./configure_codec.sh
echo "</p>"

echo "Initializing the UDP FIFO streaming engine...<br>"
echo "UDP Destination IP address: $ip<br>"
echo "UDP Destination UDP port: $port<br>"

# Run the streaming application with user-supplied IP and PORT
./"$STREAMING_APPLICATION" -i "$ip" -p "$port" > /dev/null 2>&1 & 

echo "<p><em>All Done!</em></p>"
echo "</body></html>"