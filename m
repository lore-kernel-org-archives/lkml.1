Return-Path: <linux-kernel-owner+w=401wt.eu-S1758083AbYHSXbD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758083AbYHSXbD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 19:31:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753426AbYHSXau
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 19:30:50 -0400
Received: from lucidpixels.com ([75.144.35.66]:54222 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753737AbYHSXat (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 19:30:49 -0400
Date: Tue, 19 Aug 2008 19:30:47 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: User discussion about IVTV <ivtv-users@ivtvdriver.org>
cc: Alan Piszcz <ap@solarrain.com>, linux-kernel@vger.kernel.org
Subject: Re: [ivtv-users] Hauppauge 1192 WinTV-HVR-1950: Kernel Oops :(
In-Reply-To: <alpine.DEB.1.10.0808191845320.15091@p34.internal.lan>
Message-ID: <alpine.DEB.1.10.0808191929260.18449@p34.internal.lan>
References: <alpine.DEB.1.10.0808191631030.8579@p34.internal.lan> <alpine.DEB.1.10.0808191752590.12937@p34.internal.lan> <alpine.DEB.1.10.0808191823470.15091@p34.internal.lan> <alpine.DEB.1.10.0808191845320.15091@p34.internal.lan>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 19 Aug 2008, Justin Piszcz wrote:

>
>
> On Tue, 19 Aug 2008, Justin Piszcz wrote:
>
>>
>> On Tue, 19 Aug 2008, Justin Piszcz wrote:
>>
>>> On Tue, 19 Aug 2008, Justin Piszcz wrote:
>>>
>>>> 2.6.26.2:
>>>>
>>>> [   15.745116] usbcore: registered new interface driver pvrusb2
>>>> [   16.023474] pvrusb2: Device initialization completed successfully.
>>>
>>> Closer now:
>>>
>>> [  749.791189] pvrusb2: Device initialization completed successfully.
>> Cannot seek backward in linear streams!
>> Seek failed
>> ID_VIDEO_ID=0
>> MPEG-PS file format detected.
>> ID_AUDIO_ID=0
>> VIDEO:  MPEG2  720x480  (aspect 2)  29.970 fps  8000.0 kbps (1000.0 kbyte/s)
>> ID_FILENAME=/dev/video0
>> ID_DEMUXER=mpegps
>> ID_VIDEO_FORMAT=0x10000002
>> ID_VIDEO_BITRATE=8000000
>> ID_VIDEO_WIDTH=720
>> ID_VIDEO_HEIGHT=480
>> ID_VIDEO_FPS=29.970
>> ID_VIDEO_ASPECT=0.0000
>> ID_AUDIO_FORMAT=80
>> ID_AUDIO_BITRATE=0
>> ID_AUDIO_RATE=0
>> ID_AUDIO_NCH=0
>> ID_LENGTH=0.00
>> ID_SEEKABLE=1
>> Opening video filter: [eq2]
>> ==========================================================================
>> Opening video decoder: [mpegpes] MPEG 1/2 Video passthrough
>> VDec: vo config request - 720 x 480 (preferred colorspace: Mpeg PES)
>> Could not find matching colorspace - retrying with -vf scale...
>> Opening video filter: [scale]

Ok after 2-3 hours of playing around, got it working:

$ cat video.sh

#!/bin/bash

# Set video type.
echo s-video > /sys/class/pvrusb2/*/ctl_input/cur_val
echo NTSC-M > /sys/class/pvrusb2/*/ctl_video_standard/cur_val

# The only option I need:
echo "65535" > /sys/class/pvrusb2/sn-*/ctl_volume/cur_val

# The following was found here:
# http://www.mail-archive.com/pvrusb2@isely.net/msg00306.html
#echo "10485760" > /sys/class/pvrusb2/sn-*/ctl_video_bitrate_peak/cur_val
#echo "8388608" > /sys/class/pvrusb2/sn-*/ctl_video_bitrate/cur_val
#echo "Constant Bitrate" > /sys/class/pvrusb2/sn-*/ctl_video_bitrate_mode/cur_val
#echo "224 kbps" > /sys/class/pvrusb2/sn-*/ctl_audio_bitrate/cur_val
# modify, sound is too low (max is 65535)
#echo "65535" > /sys/class/pvrusb2/sn-*/ctl_volume/cur_val
#echo "53738" > /sys/class/pvrusb2/sn-*/ctl_volume/cur_val

# Now you can mplayer /dev/video0!
# mplayer -vf yadif /dev/video0

Loaded modules:

$ lsmod
Module                  Size  Used by
nvidia               7095108  24 
s5h1411                 8900  1 
tda18271               34312  2 
tda8290                12868  2 
tuner                  26632  0 
cx25840                27404  0 
i2c_i801                8208  0 
pvrusb2               164568  1 
dvb_core               72128  1 pvrusb2
cx2341x                12100  1 pvrusb2
v4l2_common            10240  4 tuner,cx25840,pvrusb2,cx2341x
videodev               30208  3 tuner,pvrusb2
v4l1_compat            14404  2 pvrusb2,videodev
tveeprom               11972  1 pvrusb2
i2c_core               19092  10 nvidia,s5h1411,tda18271,tda8290,tuner,cx25840,i2c_i801,pvrusb2,v4l2_common,tveeprom
snd_hda_intel         350420  5 
snd_hwdep               7044  1 snd_hda_intel

Mplayer works flawlessly.

Note using USB, there is a delay ~2-3 seconds vs. the TV itself.

Justin.



