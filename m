Return-Path: <linux-kernel-owner+w=401wt.eu-S1754799AbYCSWmU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754799AbYCSWmU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 18:42:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936016AbYCSVM2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 17:12:28 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:34887 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936516AbYCSVMV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 17:12:21 -0400
Date: Wed, 19 Mar 2008 22:12:47 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Takashi Iwai <tiwai@suse.de>, kernel list <linux-kernel@vger.kernel.org>
Subject: USB-audio strange problems
Message-ID: <20080319211247.GA2659@elf.ucw.cz>
References: <20070203131014.GA4231@elf.ucw.cz> <s5htzy0y2rx.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5htzy0y2rx.wl%tiwai@suse.de>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

Ok, so it took me a year to get back to this bug. Oops.

> Yep, let's fix it.  Just to make sure (ane debugging easy atm), could
> you attach the following?
> 
> - content of /proc/asound/cards
> - content of /proc/asound/card*/stream*
> - the output of "lsusb -v"
> - the generated file via "alsactl -f store somefile"
> 
> If I remember correctly, alsamixer at least doesn't break if you build
> snd-usb-audio driver with IGNORE_CTL_ERR enabled, right?

I got the usb soundcard to work. I still have IGNORE_CTL_ERR enabled.

Problem was not mixer after all... somehow it expects me to play sound
as 8-bit, and then I can play 16-bit mono and actually hear
it. _Strange_.

So:

mplayer -ao alsa:device=hw=0 -af format=u8  KDE_Startup.wav
mplayer -ao alsa:device=hw=0 -af format=s16le -af resample=48000  -af channels=1 KDE_Logout_1.ogg

...plays both files. 

Forget about the first mplayer, and it will play nothing.

Files you asked for:

hobit:/usr/share/sounds# cat /proc/asound/cards 
 0 [U0x4fa0x4201   ]: USB-Audio - USB Device 0x4fa:0x4201
                      USB Device 0x4fa:0x4201 at usb-0000:00:1a.0-1,
full speed
hobit:/usr/share/sounds# grep . /proc/asound/card*/stream*
USB Device 0x4fa:0x4201 at usb-0000:00:1a.0-1, full speed : USB Audio
Playback:
  Status: Stop
  Interface 1
    Altset 1
    Format: 0x2
    Channels: 2
    Endpoint: 1 OUT (ASYNC)
    Rates: 44100, 48000
  Interface 1
    Altset 2
    Format: 0x2
    Channels: 1
    Endpoint: 1 OUT (ASYNC)
    Rates: 44100, 48000
  Interface 1
    Altset 3
    Format: 0x0
    Channels: 2
    Endpoint: 1 OUT (ASYNC)
    Rates: 44100, 48000
  Interface 1
    Altset 4
    Format: 0x0
    Channels: 1
    Endpoint: 1 OUT (ASYNC)
    Rates: 44100, 48000
  Interface 1
    Altset 5
    Format: 0x2
    Channels: 2
    Endpoint: 1 OUT (ADAPTIVE)
    Rates: 44100, 48000
hobit:/usr/share/sounds# 

hobit:/usr/share/sounds# lsusb
Bus 007 Device 004: ID 0db0:1967 Micro Star International Bluetooth
Dongle
Bus 007 Device 003: ID 046d:c50e Logitech, Inc. MX-1000 Cordless Mouse
Receiver
Bus 007 Device 002: ID 0451:2046 Texas Instruments, Inc. TUSB2046 Hub
Bus 007 Device 001: ID 1d6b:0001  
Bus 006 Device 001: ID 1d6b:0001  
Bus 005 Device 001: ID 1d6b:0001  
Bus 004 Device 001: ID 1d6b:0001  
Bus 003 Device 002: ID 04fa:4201 Dallas Semiconductor DS4201 Audio DAC
Bus 003 Device 001: ID 1d6b:0001  
Bus 002 Device 001: ID 1d6b:0002  
Bus 001 Device 001: ID 1d6b:0002  

lsusb -v is slightly long... here is relevant part:

Bus 003 Device 002: ID 04fa:4201 Dallas Semiconductor DS4201 Audio DAC
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               1.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0 
  bDeviceProtocol         0 
  bMaxPacketSize0         8
  idVendor           0x04fa Dallas Semiconductor
  idProduct          0x4201 DS4201 Audio DAC
  bcdDevice           83.a1
  iManufacturer           0 
  iProduct                0 
  iSerial                 0 
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength          421
    bNumInterfaces          2
    bConfigurationValue     1
    iConfiguration          0 
    bmAttributes         0xc0
      Self Powered
    MaxPower              100mA
    Interface Descriptor:
      bLength                11
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
    bNumEndpoints           0
      bInterfaceClass         1 Audio
      bInterfaceSubClass      1 Control Device
      bInterfaceProtocol      0 
      iInterface              0 
      AudioControl Interface Descriptor:
        bLength                 9
        bDescriptorType        36
        bDescriptorSubtype      1 (HEADER)
        bcdADC               1.00
        wTotalLength          114
        bInCollection           1
        baInterfaceNr( 0)       1
      AudioControl Interface Descriptor:
        bLength                12
        bDescriptorType        36
        bDescriptorSubtype      2 (INPUT_TERMINAL)
        bTerminalID             1
        wTerminalType      0x0101 USB Streaming
        bAssocTerminal          0
        bNrChannels             2
        wChannelConfig     0x0003
          Left Front (L)
          Right Front (R)
        iChannelNames           0 
        iTerminal               0 
      AudioControl Interface Descriptor:
        bLength                12
        bDescriptorType        36
        bDescriptorSubtype      2 (INPUT_TERMINAL)
        bTerminalID             2
        wTerminalType      0x0601 Analog Connector
        bAssocTerminal          0
        bNrChannels             2
        wChannelConfig     0x0003
          Left Front (L)
          Right Front (R)
        iChannelNames           0 
        iTerminal               0 
      AudioControl Interface Descriptor:
        bLength                12
        bDescriptorType        36
        bDescriptorSubtype      2 (INPUT_TERMINAL)
        bTerminalID             3
        wTerminalType      0x0601 Analog Connector
        bAssocTerminal          0
        bNrChannels             2
        wChannelConfig     0x0003
          Left Front (L)
          Right Front (R)
        iChannelNames           0 
        iTerminal               0 
      AudioControl Interface Descriptor:
        bLength                10
        bDescriptorType        36
        bDescriptorSubtype      6 (FEATURE_UNIT)
        bUnitID                 5
        bSourceID               9
        bControlSize            1
        bmaControls( 0)      0x01
          Mute
        bmaControls( 1)      0x01
          Mute
        bmaControls( 2)      0x01
          Mute
        iFeature                0 
      AudioControl Interface Descriptor:
        bLength                10
        bDescriptorType        36
        bDescriptorSubtype      6 (FEATURE_UNIT)
        bUnitID                 6
        bSourceID               2
        bControlSize            1
        bmaControls( 0)      0x01
          Mute
        bmaControls( 1)      0x01
          Mute
        bmaControls( 2)      0x01
          Mute
        iFeature                0 
      AudioControl Interface Descriptor:
        bLength                10
        bDescriptorType        36
        bDescriptorSubtype      6 (FEATURE_UNIT)
        bUnitID                 7
        bSourceID               3
        bControlSize            1
        bmaControls( 0)      0x01
          Mute
        bmaControls( 1)      0x01
          Mute
        bmaControls( 2)      0x01
          Mute
        iFeature                0 
      AudioControl Interface Descriptor:
        bLength                15
        bDescriptorType        36
        bDescriptorSubtype      4 (MIXER_UNIT)
        bUnitID                 8
        bNrInPins               3
        baSourceID( 0)          5
        baSourceID( 1)          6
        baSourceID( 2)          7
        bNrChannels             2
        wChannelConfig     0x0003
          Left Front (L)
          Right Front (R)
        iChannelNames           0 
        bmControls         0x90
        iMixer                153 
        junk at descriptor end: 00
      AudioControl Interface Descriptor:
        bLength                15
        bDescriptorType        36
        bDescriptorSubtype      8 (EXTENSION_UNIT)
        bUnitID                 9
        wExtensionCode          0
        bNrPins                 1
        baSourceID( 0)          1
        bNrChannels             2
        wChannelConfig          3
          Left Front (L)
          Right Front (R)
        iChannelNames           0 
        bControlSize            1
        bmControls( 0)       0x01
          Enable Processing
        iExtension              0 
      AudioControl Interface Descriptor:
        bLength                 9
        bDescriptorType        36
        bDescriptorSubtype      3 (OUTPUT_TERMINAL)
        bTerminalID             4
        wTerminalType      0x0304 Desktop Speaker
        bAssocTerminal          0
        bSourceID               8
        iTerminal               0 
    Interface Descriptor:
      bLength                11
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       0
      bNumEndpoints           0
      bInterfaceClass         1 Audio
      bInterfaceSubClass      2 Streaming
      bInterfaceProtocol      0 
      iInterface              0 
    Interface Descriptor:
      bLength                11
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       1
      bNumEndpoints           2
      bInterfaceClass         1 Audio
      bInterfaceSubClass      2 Streaming
      bInterfaceProtocol      0 
      iInterface              0 
      AudioStreaming Interface Descriptor:
        bLength                 7
        bDescriptorType        36
        bDescriptorSubtype      1 (AS_GENERAL)
        bTerminalLink           1
        bDelay                  1 frames
        wFormatTag              1 PCM
      AudioStreaming Interface Descriptor:
        bLength                14
        bDescriptorType        36
        bDescriptorSubtype      2 (FORMAT_TYPE)
        bFormatType             1 (FORMAT_TYPE_I)
        bNrChannels             2
        bSubframeSize           2
        bBitResolution         16
        bSamFreqType            2 Discrete
        tSamFreq[ 0]        44100
        tSamFreq[ 1]        48000
      Endpoint Descriptor:
        bLength                 9
        bDescriptorType         5
        bEndpointAddress     0x01  EP 1 OUT
        bmAttributes            5
          Transfer Type            Isochronous
          Synch Type               Asynchronous
          Usage Type               Data
        wMaxPacketSize     0x00c4  1x 196 bytes
        bInterval               1
        bRefresh                0
        bSynchAddress           2
        AudioControl Endpoint Descriptor:
          bLength                 7
          bDescriptorType        37
          bDescriptorSubtype      1 (EP_GENERAL)
          bmAttributes         0x01
            Sampling Frequency
          bLockDelayUnits         0 Undefined
          wLockDelay              0 Undefined
      Endpoint Descriptor:
        bLength                 9
        bDescriptorType         5
        bEndpointAddress     0x82  EP 2 IN
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0003  1x 3 bytes
        bInterval               1
        bRefresh                6
        bSynchAddress           0
    Interface Descriptor:
      bLength                11
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       2
      bNumEndpoints           2
      bInterfaceClass         1 Audio
      bInterfaceSubClass      2 Streaming
      bInterfaceProtocol      0 
      iInterface              0 
      AudioStreaming Interface Descriptor:
        bLength                 7
        bDescriptorType        36
        bDescriptorSubtype      1 (AS_GENERAL)
        bTerminalLink           1
        bDelay                  1 frames
        wFormatTag              1 PCM
      AudioStreaming Interface Descriptor:
        bLength                14
        bDescriptorType        36
        bDescriptorSubtype      2 (FORMAT_TYPE)
        bFormatType             1 (FORMAT_TYPE_I)
        bNrChannels             1
        bSubframeSize           2
        bBitResolution         16
        bSamFreqType            2 Discrete
        tSamFreq[ 0]        44100
        tSamFreq[ 1]        48000
      Endpoint Descriptor:
        bLength                 9
        bDescriptorType         5
        bEndpointAddress     0x01  EP 1 OUT
        bmAttributes            5
          Transfer Type            Isochronous
          Synch Type               Asynchronous
          Usage Type               Data
        wMaxPacketSize     0x0062  1x 98 bytes
        bInterval               1
        bRefresh                0
        bSynchAddress           2
        AudioControl Endpoint Descriptor:
          bLength                 7
          bDescriptorType        37
          bDescriptorSubtype      1 (EP_GENERAL)
          bmAttributes         0x01
            Sampling Frequency
          bLockDelayUnits         0 Undefined
          wLockDelay              0 Undefined
      Endpoint Descriptor:
        bLength                 9
        bDescriptorType         5
        bEndpointAddress     0x82  EP 2 IN
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0003  1x 3 bytes
        bInterval               1
        bRefresh                6
        bSynchAddress           0
    Interface Descriptor:
      bLength                11
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       3
      bNumEndpoints           2
      bInterfaceClass         1 Audio
      bInterfaceSubClass      2 Streaming
      bInterfaceProtocol      0 
      iInterface              0 
      AudioStreaming Interface Descriptor:
        bLength                 7
    bDescriptorType        36
        bDescriptorSubtype      1 (AS_GENERAL)
        bTerminalLink           1
        bDelay                  1 frames
        wFormatTag              2 PCM8
      AudioStreaming Interface Descriptor:
        bLength                14
        bDescriptorType        36
        bDescriptorSubtype      2 (FORMAT_TYPE)
        bFormatType             1 (FORMAT_TYPE_I)
        bNrChannels             2
        bSubframeSize           1
        bBitResolution          8
        bSamFreqType            2 Discrete
        tSamFreq[ 0]        44100
        tSamFreq[ 1]        48000
      Endpoint Descriptor:
        bLength                 9
        bDescriptorType         5
        bEndpointAddress     0x01  EP 1 OUT
        bmAttributes            5
          Transfer Type            Isochronous
          Synch Type               Asynchronous
          Usage Type               Data
        wMaxPacketSize     0x0062  1x 98 bytes
        bInterval               1
        bRefresh                0
        bSynchAddress           2
        AudioControl Endpoint Descriptor:
          bLength                 7
          bDescriptorType        37
          bDescriptorSubtype      1 (EP_GENERAL)
          bmAttributes         0x01
            Sampling Frequency
          bLockDelayUnits         0 Undefined
          wLockDelay              0 Undefined
      Endpoint Descriptor:
        bLength                 9
        bDescriptorType         5
        bEndpointAddress     0x82  EP 2 IN
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0003  1x 3 bytes
        bInterval               1
        bRefresh                6
        bSynchAddress           0
    Interface Descriptor:
      bLength                11
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       4
      bNumEndpoints           2
      bInterfaceClass         1 Audio
      bInterfaceSubClass      2 Streaming
      bInterfaceProtocol      0 
      iInterface              0 
      AudioStreaming Interface Descriptor:
        bLength                 7
        bDescriptorType        36
        bDescriptorSubtype      1 (AS_GENERAL)
        bTerminalLink           1
        bDelay                  1 frames
        wFormatTag              2 PCM8
      AudioStreaming Interface Descriptor:
        bLength                14
        bDescriptorType        36
        bDescriptorSubtype      2 (FORMAT_TYPE)
        bFormatType             1 (FORMAT_TYPE_I)
        bNrChannels             1
        bSubframeSize           1
        bBitResolution          8
        bSamFreqType            2 Discrete
        tSamFreq[ 0]        44100
        tSamFreq[ 1]        48000
      Endpoint Descriptor:
        bLength                 9
        bDescriptorType         5
        bEndpointAddress     0x01  EP 1 OUT
        bmAttributes            5
          Transfer Type            Isochronous
          Synch Type               Asynchronous
          Usage Type               Data
        wMaxPacketSize     0x0031  1x 49 bytes
        bInterval               1
        bRefresh                0
        bSynchAddress           2
        AudioControl Endpoint Descriptor:
          bLength                 7
          bDescriptorType        37
          bDescriptorSubtype      1 (EP_GENERAL)
          bmAttributes         0x01
            Sampling Frequency
          bLockDelayUnits         0 Undefined
          wLockDelay              0 Undefined
      Endpoint Descriptor:
        bLength                 9
        bDescriptorType         5
        bEndpointAddress     0x82  EP 2 IN
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0003  1x 3 bytes
        bInterval               1
        bRefresh                6
        bSynchAddress           0
    Interface Descriptor:
      bLength                11
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       5
      bNumEndpoints           1
      bInterfaceClass         1 Audio
      bInterfaceSubClass      2 Streaming
      bInterfaceProtocol      0 
      iInterface              0 
      AudioStreaming Interface Descriptor:
        bLength                 7
        bDescriptorType        36
        bDescriptorSubtype      1 (AS_GENERAL)
        bTerminalLink           1
        bDelay                  1 frames
        wFormatTag              1 PCM
      AudioStreaming Interface Descriptor:
        bLength                14
        bDescriptorType        36
        bDescriptorSubtype      2 (FORMAT_TYPE)
        bFormatType             1 (FORMAT_TYPE_I)
        bNrChannels             2
        bSubframeSize           2
        bBitResolution         16
        bSamFreqType            2 Discrete
        tSamFreq[ 0]        44100
        tSamFreq[ 1]        48000
      Endpoint Descriptor:
        bLength                 9
        bDescriptorType         5
        bEndpointAddress     0x01  EP 1 OUT
        bmAttributes            9
          Transfer Type            Isochronous
          Synch Type               Adaptive
          Usage Type               Data
        wMaxPacketSize     0x00c4  1x 196 bytes
        bInterval               1
        bRefresh                0
        bSynchAddress           0
        AudioControl Endpoint Descriptor:
          bLength                 7
          bDescriptorType        37
          bDescriptorSubtype      1 (EP_GENERAL)
          bmAttributes         0x01
            Sampling Frequency
          bLockDelayUnits         1 Milliseconds
          wLockDelay              0 Milliseconds
Device Status:     0x0001
  Self Powered

Bus 003 Device 001: ID 1d6b:0001  


									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
pomozte zachranit klanovicky les:  http://www.ujezdskystrom.info/
