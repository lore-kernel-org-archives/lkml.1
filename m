Return-Path: <linux-kernel-owner+w=401wt.eu-S1757555AbYD2Kb5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757555AbYD2Kb5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 06:31:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753847AbYD2Kbt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 06:31:49 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:55456 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753914AbYD2Kbs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 06:31:48 -0400
Date: Tue, 29 Apr 2008 12:31:47 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: sound: azx_get_response timeout
Message-ID: <alpine.LNX.1.10.0804291225350.21466@fbirervta.pbzchgretzou.qr>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Out of the blue, sound stops and dmesg throws:

ALSA sound/pci/hda/hda_intel.c:596: hda_intel: azx_get_response timeout, 
switching to polling mode: last cmd=0x000f0000

Kernel is 2.6.25-19-default (from opensuse 11.0beta1)
Alsamixer says:
	Card: HDA VIA VT82xx
	Chip: VIA VIA VT1708
lspci:
	02:01.0 Audio device: VIA Technologies, Inc. VIA High Definition Audio 
	Controller (rev 10)

Even restarting mplayer or anything else that writes to /dev/dsp or
the ALSA PCM devices in /dev/snd just stop. strace says its due to
this:

-ao alsa:
gettimeofday({1209471996, 635897}, NULL) = 0
nanosleep({0, 10000000}, NULL)          = 0
ioctl(5, 0x4122, 0xd696910)             = 0
ioctl(5, 0x4122, 0xbf8c0002)            = 0
ioctl(5, 0x4122, 0x1b80e3c5)            = 0
(and repeats this over and over)

-ao oss:
nanosleep({0, 10000000}, NULL)          = 0
ioctl(4, SNDCTL_DSP_GETOSPACE, 0x8907d4c) = 0

Messages from dmesg when reloading the module:
ALSA sound/pci/hda/hda_codec.c:2860: autoconfig: line_outs=4 (0x1f/0x1c/0x22/0x23/0x0)
ALSA sound/pci/hda/hda_codec.c:2864:    speaker_outs=0 (0x0/0x0/0x0/0x0/0x0)
ALSA sound/pci/hda/hda_codec.c:2868:    hp_outs=1 (0x20/0x0/0x0/0x0/0x0)
ALSA sound/pci/hda/hda_codec.c:2869:    mono: mono_out=0x0
ALSA sound/pci/hda/hda_codec.c:2877:    inputs: mic=0x1d, fmic=0x21, line=0x1e, fline=0x0, cd=0x24, aux=0x0
hda_codec: num_steps = 0 for NID=0x1f (ctl = Front Playback Volume)
hda_codec: num_steps = 0 for NID=0x1a (ctl = Center Playback Volume)
hda_codec: num_steps = 0 for NID=0x19 (ctl = Side Playback Volume)
hda_codec: num_steps = 0 for NID=0x20 (ctl = Headphone Playback Volume)
hda_codec: num_steps = 0 for NID=0x15 (ctl = Capture Volume)

The only way to get rid of the GETOSPACE=0 state is to reboot the
machine. Say, could this be due to the crappy VIA hardware?
