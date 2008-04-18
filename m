Return-Path: <linux-kernel-owner+w=401wt.eu-S1756083AbYDRBwn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756083AbYDRBwn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 21:52:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752864AbYDRBwd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 21:52:33 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:47550 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752849AbYDRBwb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 21:52:31 -0400
Subject: Re: [PATCH] make alsa use corect patch for Realtek ALC889A
From: Kasper Sandberg <lkml@metanurb.dk>
To: Takashi Iwai <tiwai@suse.de>
Cc: LKML Mailinglist <linux-kernel@vger.kernel.org>
In-Reply-To: <s5htzi1eur8.wl%tiwai@suse.de>
References: <1208017043.1514.50.camel@localhost>
	 <s5hbq4af4h3.wl%tiwai@suse.de>  <s5htzi1eur8.wl%tiwai@suse.de>
Content-Type: text/plain
Date: Fri, 18 Apr 2008 03:52:06 +0200
Message-Id: <1208483526.14146.29.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.4.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-04-16 at 16:31 +0200, Takashi Iwai wrote:
> At Wed, 16 Apr 2008 13:01:44 +0200,
> I wrote:
> > 
> > At Sat, 12 Apr 2008 18:17:23 +0200,
> > Kasper Sandberg wrote:
> > > 
> > > Hello..
> > > I have a gigabyte X48-DQ6 motherboard, specification url:
> > > http://www.gigabyte.com.tw/Products/Motherboard/Products_Spec.aspx?ClassValue=Motherboard&ProductID=2763&ProductName=GA-X48-DQ6
> > > they clearly state it uses a realtek alc 889a.
> > > 
> > > google around, it seems lots of people which has this chip gets it
> > > detected as alc885, including me.
> > > 
> > > now, audio works (atleast analog out, havent tested the rest), allthough
> > > i couldnt get the supposed feature of separate channel to front panel to
> > > work(doesent matter much to me though)
> > > 
> > > interrested in fixing this just for the sake of fixing, i ventured into
> > > patch_realtek.c, and found the structure that defined patches for hda
> > > audio.
> > > 
> > > i inspected my /proc/asound/card0/codec#2 file (only one except the id
> > > file), and found the following information:
> > > Codec: Realtek ALC885
> > > Address: 2
> > > Vendor Id: 0x10ec0885
> > > Subsystem Id: 0x1458a002
> > > Revision Id: 0x100103
> > > 
> > > i then modified patch_realtek.c to detect mine as ALC889A, and assign
> > > the correct patch to it (well, the one used for 889).
> > > 
> > > After rebuilding, it now uses patch 883 instead of 882 as it did before.
> > > i dont appear to have recieved any separate front panel channel,
> > > however, it still seems more correct now, and is probably wise to keep
> > > for when 883 is improved to support the hardware fully.
> > > 
> > > the only thing i notice has changed, is the message i get from the
> > > kernel, before i changed, it said:
> > > hda_codec: Unknown model for ALC882, trying auto-probe from BIOS...
> > > now it says:
> > > hda_codec: Unknown model for ALC883, trying auto-probe from BIOS...
> > > but i guess if it has to spew out such a line, it now spews out the
> > > correct one.
> > > 
> > > analog audio works, so thats fine..
> > > 
> > > the patch(i apologize if my mailer messes up whitespace, but its so
> > > simple that it doesent matter):
> > 
> > The change looks OK (although I'd move the line just before ALC885
I wasnt sure how it was evaluated, i dont really know alsa alot, so i
wanted to make sure my entry got evaluated first.
> > entry).  I have no datasheet of ALC889A, but rumor says that it's
> > almost compatible with ALC888.  So patch_alc883 seems to be a better
> > choice than now.
> > 
> > I'll fix it on ALSA tree now.
> 
> On the second thought, replacing to patch_alc883 may break many
> devices with preset models because patch_alc882() and patch_alc883()
> have different model tables.  So, I applied the patch below in
> addition.
> 
> BTW, could you show your codec#* files?  This will be really helpful
> to identify problems.

Yes, sorry for delay, for some reason my mail client decided not to
update the view.. weird..

You should know that this is WITH my modification..

About problems.. well.. now that you do mention it, when i play
something without a .asoundrc, i get:
ALSA lib dlmisc.c:118:(snd_dlsym_verify) unable to verify version for
symbol _snd_pcm_empty_open
ALSA lib pcm.c:2108:(snd_pcm_open_conf) symbol _snd_pcm_empty_open is
not defined inside [builtin]
No default libao driver available.

if i make a .asoundrc containing:
pcm.!default {
        type dmix
        ipc_key 1024
        slave.pcm "hw:0,0"
        slave.rate 44100
}
it works. (this is both with and without the modification to make it get
recognized as 889A). Alsa userspace 1.0.16.

root@quadstation # aplay -L
default:CARD=Intel
    HDA Intel, ALC883 Analog
    Default Audio Device
front:CARD=Intel,DEV=0
    HDA Intel, ALC883 Analog
    Front speakers
surround40:CARD=Intel,DEV=0
    HDA Intel, ALC883 Analog
    4.0 Surround output to Front and Rear speakers
surround41:CARD=Intel,DEV=0
    HDA Intel, ALC883 Analog
    4.1 Surround output to Front, Rear and Subwoofer speakers
surround50:CARD=Intel,DEV=0
    HDA Intel, ALC883 Analog
    5.0 Surround output to Front, Center and Rear speakers
surround51:CARD=Intel,DEV=0
    HDA Intel, ALC883 Analog
    5.1 Surround output to Front, Center, Rear and Subwoofer speakers
surround71:CARD=Intel,DEV=0
    HDA Intel, ALC883 Analog
    7.1 Surround output to Front, Center, Side, Rear and Woofer speakers
iec958:CARD=Intel,DEV=0
    HDA Intel, ALC883 Digital
    IEC958 (S/PDIF) Digital Audio Output
null
    Discard all samples (playback) or generate zero samples (capture)
root@quadstation # aplay -l
**** List of PLAYBACK Hardware Devices ****
card 0: Intel [HDA Intel], device 0: ALC883 Analog [ALC883 Analog]
  Subdevices: 1/1
  Subdevice #0: subdevice #0
card 0: Intel [HDA Intel], device 1: ALC883 Digital [ALC883 Digital]
  Subdevices: 1/1
  Subdevice #0: subdevice #0
root@quadstation # cat /proc/asound/{cards,devices,pcm}

 0 [Intel          ]: HDA-Intel - HDA Intel
                      HDA Intel at 0xea300000 irq 14
  2:        : timer
  3: [ 0- 2]: digital audio capture
  4: [ 0- 1]: digital audio playback
  5: [ 0- 1]: digital audio capture
  6: [ 0- 0]: digital audio playback
  7: [ 0- 0]: digital audio capture
  8: [ 0- 2]: hardware dependent
  9: [ 0]   : control
00-02: ALC883 Analog : ALC883 Analog : capture 1
00-01: ALC883 Digital : ALC883 Digital : playback 1 : capture 1
00-00: ALC883 Analog : ALC883 Analog : playback 1 : capture 1

Now as far as i know, the gigabyte site(and realteks site) says that
this ALC889A should have 7.1 surround, with 2 separate channels of
streaming for front. I connected the hd audio connector for front panel
on motherboard.. but well.. the same thing comes out, and i see no
special channels for it.. BUT, one thing i find odd is, if i play 2
channel stuff, it also comes out of all the other channels, eg the
surround channels.. :)

anyway, hope you can use some of this info, i personally dont need the
extra channels of streaming, however, i actually do have a few uses in
mind IF they can work :D

I will ofcourse provide you with all information you need about my
motherboard

Thanks for your help!

the codec file:
Codec: Realtek ALC889A
Address: 2
Vendor Id: 0x10ec0885
Subsystem Id: 0x1458a002
Revision Id: 0x100103
No Modem Function Group found
Default PCM:
    rates [0x560]: 44100 48000 96000 192000
    bits [0xe]: 16 20 24
    formats [0x1]: PCM
Default Amp-In caps: N/A
Default Amp-Out caps: N/A
GPIO: io=2, o=0, i=0, unsolicited=1, wake=0
  IO[0]: enable=0, dir=0, wake=0, sticky=0, data=0
  IO[1]: enable=0, dir=0, wake=0, sticky=0, data=0
Node 0x02 [Audio Output] wcaps 0x11: Stereo
  Converter: stream=0, channel=0
  PCM:
    rates [0x560]: 44100 48000 96000 192000
    bits [0xe]: 16 20 24
    formats [0x1]: PCM
Node 0x03 [Audio Output] wcaps 0x11: Stereo
  Converter: stream=0, channel=0
  PCM:
    rates [0x560]: 44100 48000 96000 192000
    bits [0xe]: 16 20 24
    formats [0x1]: PCM
Node 0x04 [Audio Output] wcaps 0x11: Stereo
  Converter: stream=0, channel=0
  PCM:
    rates [0x560]: 44100 48000 96000 192000
    bits [0xe]: 16 20 24
    formats [0x1]: PCM
Node 0x05 [Audio Output] wcaps 0x11: Stereo
  Converter: stream=0, channel=0
  PCM:
    rates [0x560]: 44100 48000 96000 192000
    bits [0xe]: 16 20 24
    formats [0x1]: PCM
Node 0x06 [Audio Output] wcaps 0x211: Stereo Digital
  Converter: stream=0, channel=0
  Digital:
  Digital category: 0x0
  PCM:
    rates [0x5e0]: 44100 48000 88200 96000 192000
    bits [0x1e]: 16 20 24 32
    formats [0x1]: PCM
Node 0x07 [Audio Input] wcaps 0x10011b: Stereo Amp-In
  Amp-In caps: ofs=0x10, nsteps=0x2e, stepsize=0x03, mute=1
  Amp-In vals:  [0x90 0x90]
  Converter: stream=0, channel=0
  SDI-Select: 0
  PCM:
    rates [0x560]: 44100 48000 96000 192000
    bits [0xe]: 16 20 24
    formats [0x1]: PCM
  Connection: 1
     0x24
Node 0x08 [Audio Input] wcaps 0x10011b: Stereo Amp-In
  Amp-In caps: ofs=0x10, nsteps=0x2e, stepsize=0x03, mute=1
  Amp-In vals:  [0x00 0x00]
  Converter: stream=0, channel=0
  SDI-Select: 0
  PCM:
    rates [0x560]: 44100 48000 96000 192000
    bits [0xe]: 16 20 24
    formats [0x1]: PCM
  Connection: 1
     0x23
Node 0x09 [Audio Input] wcaps 0x10011b: Stereo Amp-In
  Amp-In caps: ofs=0x10, nsteps=0x2e, stepsize=0x03, mute=1
  Amp-In vals:  [0x00 0x00]
  Converter: stream=0, channel=0
  SDI-Select: 0
  PCM:
    rates [0x560]: 44100 48000 96000 192000
    bits [0xe]: 16 20 24
    formats [0x1]: PCM
  Connection: 1
     0x22
Node 0x0a [Audio Input] wcaps 0x100391: Stereo Digital
  Converter: stream=0, channel=0
  SDI-Select: 0
  Digital:
  Digital category: 0x0
  PCM:
    rates [0x560]: 44100 48000 96000 192000
    bits [0x1e]: 16 20 24 32
    formats [0x1]: PCM
  Unsolicited: tag=00, enabled=0
  Connection: 1
     0x1f
Node 0x0b [Audio Mixer] wcaps 0x20010b: Stereo Amp-In
  Amp-In caps: ofs=0x17, nsteps=0x1f, stepsize=0x05, mute=1
  Amp-In vals:  [0x80 0x80] [0x80 0x80] [0x80 0x80] [0x80 0x80] [0x80
0x80] [0x97 0x97] [0x97 0x97] [0x97 0x97] [0x97 0x97] [0x97 0x97]
  Connection: 10
     0x18 0x19 0x1a 0x1b 0x1c 0x1d 0x14 0x15 0x16 0x17
Node 0x0c [Audio Mixer] wcaps 0x20010f: Stereo Amp-In Amp-Out
  Amp-In caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
  Amp-In vals:  [0x00 0x00] [0x00 0x00]
  Amp-Out caps: ofs=0x40, nsteps=0x40, stepsize=0x03, mute=0
  Amp-Out vals:  [0x38 0x38]
  Connection: 2
     0x02 0x0b
Node 0x0d [Audio Mixer] wcaps 0x20010f: Stereo Amp-In Amp-Out
  Amp-In caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
  Amp-In vals:  [0x00 0x00] [0x00 0x00]
  Amp-Out caps: ofs=0x40, nsteps=0x40, stepsize=0x03, mute=0
  Amp-Out vals:  [0x00 0x00]
  Connection: 2
     0x03 0x0b
Node 0x0e [Audio Mixer] wcaps 0x20010f: Stereo Amp-In Amp-Out
  Amp-In caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
  Amp-In vals:  [0x00 0x00] [0x00 0x00]
  Amp-Out caps: ofs=0x40, nsteps=0x40, stepsize=0x03, mute=0
  Amp-Out vals:  [0x38 0x38]
  Connection: 2
     0x04 0x0b
Node 0x0f [Audio Mixer] wcaps 0x20010f: Stereo Amp-In Amp-Out
  Amp-In caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
  Amp-In vals:  [0x00 0x00] [0x00 0x00]
  Amp-Out caps: ofs=0x40, nsteps=0x40, stepsize=0x03, mute=0
  Amp-Out vals:  [0x38 0x38]
  Connection: 2
     0x05 0x0b
Node 0x10 [Vendor Defined Widget] wcaps 0xf00000: Mono
Node 0x11 [Vendor Defined Widget] wcaps 0xf00000: Mono
Node 0x12 [Vendor Defined Widget] wcaps 0xf00000: Mono
Node 0x13 [Vendor Defined Widget] wcaps 0xf00000: Mono
Node 0x14 [Pin Complex] wcaps 0x40018f: Stereo Amp-In Amp-Out
  Amp-In caps: ofs=0x00, nsteps=0x03, stepsize=0x27, mute=0
  Amp-In vals:  [0x00 0x00]
  Amp-Out caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
  Amp-Out vals:  [0x00 0x00]
  Pincap 0x08373c: IN OUT HP Detect
    Vref caps: HIZ 50 GRD 80 100
  Pin Default 0x01014410: [Jack] Line Out at Ext Rear
    Conn = 1/8, Color = Green
    DefAssociation = 0x1, Sequence = 0x0
  Pin-ctls: 0x40: OUT VREF_HIZ
  Unsolicited: tag=00, enabled=0
  Connection: 5
     0x0c* 0x0d 0x0e 0x0f 0x26
Node 0x15 [Pin Complex] wcaps 0x40018f: Stereo Amp-In Amp-Out
  Amp-In caps: ofs=0x00, nsteps=0x03, stepsize=0x27, mute=0
  Amp-In vals:  [0x00 0x00]
  Amp-Out caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
  Amp-Out vals:  [0x00 0x00]
  Pincap 0x08373c: IN OUT HP Detect
    Vref caps: HIZ 50 GRD 80 100
  Pin Default 0x01011412: [Jack] Line Out at Ext Rear
    Conn = 1/8, Color = Black
    DefAssociation = 0x1, Sequence = 0x2
  Pin-ctls: 0x40: OUT VREF_HIZ
  Unsolicited: tag=00, enabled=0
  Connection: 5
     0x0c 0x0d* 0x0e 0x0f 0x26
Node 0x16 [Pin Complex] wcaps 0x40018f: Stereo Amp-In Amp-Out
  Amp-In caps: ofs=0x00, nsteps=0x03, stepsize=0x27, mute=0
  Amp-In vals:  [0x00 0x00]
  Amp-Out caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
  Amp-Out vals:  [0x00 0x00]
  Pincap 0x083c: IN OUT HP Detect
  Pin Default 0x01016411: [Jack] Line Out at Ext Rear
    Conn = 1/8, Color = Orange
    DefAssociation = 0x1, Sequence = 0x1
  Pin-ctls: 0x40: OUT
  Unsolicited: tag=00, enabled=0
  Connection: 5
     0x0c 0x0d 0x0e* 0x0f 0x26
Node 0x17 [Pin Complex] wcaps 0x40018f: Stereo Amp-In Amp-Out
  Amp-In caps: ofs=0x00, nsteps=0x03, stepsize=0x27, mute=0
  Amp-In vals:  [0x00 0x00]
  Amp-Out caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
  Amp-Out vals:  [0x00 0x00]
  Pincap 0x083c: IN OUT HP Detect
  Pin Default 0x01012414: [Jack] Line Out at Ext Rear
    Conn = 1/8, Color = Grey
    DefAssociation = 0x1, Sequence = 0x4
  Pin-ctls: 0x40: OUT
  Unsolicited: tag=00, enabled=0
  Connection: 5
     0x0c 0x0d 0x0e 0x0f* 0x26
Node 0x18 [Pin Complex] wcaps 0x40018f: Stereo Amp-In Amp-Out
  Amp-In caps: ofs=0x00, nsteps=0x03, stepsize=0x27, mute=0
  Amp-In vals:  [0x00 0x00]
  Amp-Out caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
  Amp-Out vals:  [0x80 0x80]
  Pincap 0x08373c: IN OUT HP Detect
    Vref caps: HIZ 50 GRD 80 100
  Pin Default 0x01a19c40: [Jack] Mic at Ext Rear
    Conn = 1/8, Color = Pink
    DefAssociation = 0x4, Sequence = 0x0
  Pin-ctls: 0x24: IN VREF_80
  Unsolicited: tag=00, enabled=0
  Connection: 5
     0x0c* 0x0d 0x0e 0x0f 0x26
Node 0x19 [Pin Complex] wcaps 0x40018f: Stereo Amp-In Amp-Out
  Amp-In caps: ofs=0x00, nsteps=0x03, stepsize=0x27, mute=0
  Amp-In vals:  [0x00 0x00]
  Amp-Out caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
  Amp-Out vals:  [0x80 0x80]
  Pincap 0x08373c: IN OUT HP Detect
    Vref caps: HIZ 50 GRD 80 100
  Pin Default 0x02a19c50: [Jack] Mic at Ext Front
    Conn = 1/8, Color = Pink
    DefAssociation = 0x5, Sequence = 0x0
  Pin-ctls: 0x24: IN VREF_80
  Unsolicited: tag=00, enabled=0
  Connection: 5
     0x0c* 0x0d 0x0e 0x0f 0x26
Node 0x1a [Pin Complex] wcaps 0x40018f: Stereo Amp-In Amp-Out
  Amp-In caps: ofs=0x00, nsteps=0x03, stepsize=0x27, mute=0
  Amp-In vals:  [0x00 0x00]
  Amp-Out caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
  Amp-Out vals:  [0x80 0x80]
  Pincap 0x08373c: IN OUT HP Detect
    Vref caps: HIZ 50 GRD 80 100
  Pin Default 0x0181344f: [Jack] Line In at Ext Rear
    Conn = 1/8, Color = Blue
    DefAssociation = 0x4, Sequence = 0xf
  Pin-ctls: 0x20: IN VREF_HIZ
  Unsolicited: tag=00, enabled=0
  Connection: 5
     0x0c* 0x0d 0x0e 0x0f 0x26
Node 0x1b [Pin Complex] wcaps 0x40018f: Stereo Amp-In Amp-Out
  Amp-In caps: ofs=0x00, nsteps=0x03, stepsize=0x27, mute=0
  Amp-In vals:  [0x00 0x00]
  Amp-Out caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
  Amp-Out vals:  [0x00 0x00]
  Pincap 0x08373c: IN OUT HP Detect
    Vref caps: HIZ 50 GRD 80 100
  Pin Default 0x02214c20: [Jack] HP Out at Ext Front
    Conn = 1/8, Color = Green
    DefAssociation = 0x2, Sequence = 0x0
  Pin-ctls: 0xc0: OUT HP VREF_HIZ
  Unsolicited: tag=04, enabled=1
  Connection: 5
     0x0c* 0x0d 0x0e 0x0f 0x26
Node 0x1c [Pin Complex] wcaps 0x400001: Stereo
  Pincap 0x0820: IN
  Pin Default 0x593301f0: [N/A] CD at Int ATAPI
    Conn = ATAPI, Color = Unknown
    DefAssociation = 0xf, Sequence = 0x0
    Misc = NO_PRESENCE
  Pin-ctls: 0x20: IN
Node 0x1d [Pin Complex] wcaps 0x400000: Mono
  Pincap 0x0820: IN
  Pin Default 0x4005e601: [N/A] Line Out at Ext N/A
    Conn = Optical, Color = White
    DefAssociation = 0x0, Sequence = 0x1
  Pin-ctls: 0x20: IN
Node 0x1e [Pin Complex] wcaps 0x400300: Mono Digital
  Pincap 0x0810: OUT
  Pin Default 0x014b6130: [Jack] SPDIF Out at Ext Rear
    Conn = Comb, Color = Orange
    DefAssociation = 0x3, Sequence = 0x0
    Misc = NO_PRESENCE
  Pin-ctls: 0x40: OUT
  Connection: 1
     0x06
Node 0x1f [Pin Complex] wcaps 0x400200: Mono Digital
  Pincap 0x0820: IN
  Pin Default 0x01cb7160: [Jack] SPDIF In at Ext Rear
    Conn = Comb, Color = Yellow
    DefAssociation = 0x6, Sequence = 0x0
    Misc = NO_PRESENCE
  Pin-ctls: 0x20: IN
Node 0x20 [Vendor Defined Widget] wcaps 0xf00040: Mono
  Processing caps: benign=0, ncoeff=17
Node 0x21 [Volume Knob Widget] wcaps 0x600080: Mono
  Volume-Knob: delta=0, steps=32, direct=0, val=0
  Unsolicited: tag=00, enabled=0
  Connection: 0
Node 0x22 [Audio Mixer] wcaps 0x20010b: Stereo Amp-In
  Amp-In caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
  Amp-In vals:  [0x00 0x00] [0x00 0x00] [0x00 0x00] [0x80 0x80] [0x00
0x00] [0x80 0x80] [0x80 0x80] [0x80 0x80] [0x80 0x80] [0x80 0x80] [0x80
0x80]
  Connection: 11
     0x18 0x19 0x1a 0x1b 0x1c 0x1d 0x14 0x15 0x16 0x17 0x0b
Node 0x23 [Audio Mixer] wcaps 0x20010b: Stereo Amp-In
  Amp-In caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
  Amp-In vals:  [0x00 0x00] [0x00 0x00] [0x00 0x00] [0x80 0x80] [0x00
0x00] [0x80 0x80] [0x80 0x80] [0x80 0x80] [0x80 0x80] [0x80 0x80] [0x80
0x80]
  Connection: 11
     0x18 0x19 0x1a 0x1b 0x1c 0x1d 0x14 0x15 0x16 0x17 0x0b
Node 0x24 [Audio Mixer] wcaps 0x20010b: Stereo Amp-In
  Amp-In caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
  Amp-In vals:  [0x80 0x80] [0x80 0x80] [0x80 0x80] [0x80 0x80] [0x80
0x80] [0x80 0x80] [0x80 0x80] [0x80 0x80] [0x80 0x80] [0x80 0x80] [0x80
0x80]
  Connection: 11
     0x18 0x19 0x1a 0x1b 0x1c 0x1d 0x14 0x15 0x16 0x17 0x0b
Node 0x25 [Audio Output] wcaps 0x11: Stereo
  Converter: stream=0, channel=0
  PCM:
    rates [0x560]: 44100 48000 96000 192000
    bits [0xe]: 16 20 24
    formats [0x1]: PCM
Node 0x26 [Audio Mixer] wcaps 0x20010f: Stereo Amp-In Amp-Out
  Amp-In caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
  Amp-In vals:  [0x00 0x00] [0x00 0x00]
  Amp-Out caps: ofs=0x40, nsteps=0x40, stepsize=0x03, mute=0
  Amp-Out vals:  [0x40 0x40]
  Connection: 2
     0x25 0x0b


> 
> Also, I'm still a bit suspicious whether ALC889A has really that
> vendor id.  Do you have a chance to check the chip on your board?
> 

Yes, i will do so tomorow probably. You really think gigabyte would put
up misinformation about this? i must say, i was really suspecious of it
myself..



> 
> thanks,
> 
> Takashi
> 
> ---
> diff -r e2c5d8b125b7 -r e42f262f5117 sound/pci/hda/patch_realtek.c
> --- a/sound/pci/hda/patch_realtek.c	Wed Apr 16 13:13:29 2008 +0200
> +++ b/sound/pci/hda/patch_realtek.c	Wed Apr 16 16:29:09 2008 +0200
> @@ -2579,6 +2579,7 @@ static void alc_free(struct hda_codec *c
>  		kfree(spec->kctl_alloc);
>  	}
>  	kfree(spec);
> +	codec->spec = NULL; /* to be sure */
>  }
>  
>  /*
> @@ -6336,6 +6337,8 @@ static void alc882_auto_init(struct hda_
>  		alc_sku_automute(codec);
>  }
>  
> +static int patch_alc883(struct hda_codec *codec); /* called in patch_alc882() */
> +
>  static int patch_alc882(struct hda_codec *codec)
>  {
>  	struct alc_spec *spec;
> @@ -6365,6 +6368,11 @@ static int patch_alc882(struct hda_codec
>  			board_config = ALC885_MBP3;
>  			break;
>  		default:
> +			/* ALC889A is handled better as ALC888-compatible */
> +			if (codec->revision_id == 0x100103) {
> +				alc_free(codec);
> +				return patch_alc883(codec);
> +			}
>  			printk(KERN_INFO "hda_codec: Unknown model for ALC882, "
>  		       			 "trying auto-probe from BIOS...\n");
>  			board_config = ALC882_AUTO;
> @@ -14043,7 +14051,7 @@ struct hda_codec_preset snd_hda_preset_r
>  	{ .id = 0x10ec0882, .name = "ALC882", .patch = patch_alc882 },
>  	{ .id = 0x10ec0883, .name = "ALC883", .patch = patch_alc883 },
>  	{ .id = 0x10ec0885, .rev = 0x100103, .name = "ALC889A",
> -	  .patch = patch_alc883 },
> +	  .patch = patch_alc882 }, /* should be patch_alc883() in future */
>  	{ .id = 0x10ec0885, .name = "ALC885", .patch = patch_alc882 },
>  	{ .id = 0x10ec0888, .name = "ALC888", .patch = patch_alc883 },
>  	{ .id = 0x10ec0889, .name = "ALC889", .patch = patch_alc883 },

