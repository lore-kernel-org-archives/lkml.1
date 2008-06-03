Return-Path: <linux-kernel-owner+w=401wt.eu-S1756159AbYFCXcK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756159AbYFCXcK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 19:32:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753514AbYFCXbz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 19:31:55 -0400
Received: from saeurebad.de ([85.214.36.134]:56478 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751930AbYFCXby (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 19:31:54 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: Takashi Iwai <tiwai@suse.de>, Jaroslav Kysela <perex@suse.cz>
Subject: Longstanding bug in ac97/intel8x0 resume/init
CC: linux-kernel@vger.kernel.org
Date: Wed, 04 Jun 2008 01:31:10 +0200
Message-ID: <87hcca3xkx.fsf@saeurebad.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

my laptop has muted sound after resuming the soundcard (by
s2ram/hibernation).  The problem seems to be that the cached register
values are not written back to the device properly.

Before suspend, the registers look like this:

0:00 = 1990
0:02 = 0000
0:04 = 9f1f
0:06 = 801f
0:08 = 0000
0:0a = 801e
0:0c = 801f
0:0e = 801f
0:10 = 9f1f
0:12 = 9f1f
0:14 = 9f1f
0:16 = 9f1f
0:18 = 0b0b
0:1a = 0000
0:1c = 0000
0:1e = 0000
0:20 = 0000
0:22 = 0000
0:24 = 0000
0:26 = 000f
0:28 = 0201
0:2a = 0001
0:2c = bb80
0:2e = 0000
0:30 = 0000
0:32 = bb80
0:34 = 0000
0:36 = 0000
0:38 = 0000
0:3a = 0000
0:3c = 0000
0:3e = 0000
0:40 = 0000
0:42 = 0000
0:44 = 0000
0:46 = 0000
0:48 = 0000
0:4a = 0000
0:4c = 0000
0:4e = 0000
0:50 = 0000
0:52 = 0000
0:54 = 0000
0:56 = ffff
0:58 = 0000
0:5a = 0604
0:5c = 0000
0:5e = 0080
0:60 = 0023
0:62 = 0000
0:64 = 0000
0:66 = 0000
0:68 = 0824
0:6a = 0000
0:6c = 0000
0:6e = 0000
0:70 = 0000
0:72 = 0000
0:74 = 0000
0:76 = 0000
0:78 = 003c
0:7a = 0000
0:7c = 4352
0:7e = 5936

and right after a resume, they look like this (annotations by me):

0:00 = 1990
0:02 = 8000	! Master Volume
0:04 = 8000	! Headphone Volume
0:06 = 8000	! Master Mono Volume
0:08 = 0000
0:0a = 0000	! PC Beep Volume
0:0c = 8008	! Phone Volume
0:0e = 8008	! Mic Volume
0:10 = 8808	! Line In Volume
0:12 = 8808	! CD Volume
0:14 = 8808	! Video Volume
0:16 = 8808	! AUX Volume
0:18 = 8808	! PCM Volume
0:1a = 0000
0:1c = 8000	! Record gain
0:1e = 0000
0:20 = 0000
0:22 = 0000
0:24 = 0000
0:26 = 000f
0:28 = 0201
0:2a = 0001
0:2c = bb80
0:2e = 0000
0:30 = 0000
0:32 = bb80
0:34 = 0000
0:36 = 0000
0:38 = 0000
0:3a = 0000
0:3c = 0000
0:3e = 0000
0:40 = 0000
0:42 = 0000
0:44 = 0000
0:46 = 0000
0:48 = 0000
0:4a = 0000
0:4c = 0000
0:4e = 0000
0:50 = 0000
0:52 = 0000
0:54 = 0000
0:56 = ffff
0:58 = 0000
0:5a = 0604
0:5c = 0000
0:5e = 0080
0:60 = 0023
0:62 = 0000
0:64 = 0000
0:66 = 0000
0:68 = 0824
0:6a = 0000
0:6c = 0000
0:6e = 0000
0:70 = 0000
0:72 = 0000
0:74 = 0000
0:76 = 0000
0:78 = 003c
0:7a = 0000
0:7c = 4352
0:7e = 5936

When I run alsamixer and change around the values of Master and PCM in a
purely random way - a bit higher/lower, mute/unmute, etc. - sound comes
back to life.

I remember to `fix' this by adding more delays between waking the device
and syncing back the cache.  But I think that took up to 6 seconds,
sometimes, so there must be something else going on (see below).

The chip is the following:

0-0/0: Cirrus Logic CS4299 rev 6

PCI Subsys Vendor: 0x1014
PCI Subsys Device: 0x0222

Capabilities     : -headphone out-
DAC resolution   : 20-bit
ADC resolution   : 18-bit
3D enhancement   : Crystal Semi 3D Stereo Enhancement

Current setup
Mic gain         : +0dB [+0dB]
POP path         : pre 3D
Sim. stereo      : off
3D enhancement   : off
Loudness         : off
Mono output      : MIX
Mic select       : Mic1
ADC/DAC loopback : off
Extended ID      : codec=0 rev=0 AMAP DSA=0 VRA
Extended status  : VRA
PCM front DAC    : 48000Hz
PCM ADC          : 48000Hz
SPDIF Control    : Consumer PCM Copyright Category=0x22 Generation=1 Rate=48kHz

Something else is strange, too.  When I have the driver as a module and
unload it once, another load will succeed module-wise but the device is
unusable then.  Here is the dmesg snippet:

[ 1462.343612] ACPI: PCI interrupt for device 0000:00:1f.5 disabled
[ 1487.092547] ACPI: PCI Interrupt 0000:00:1f.5[B] -> Link [LNKB] -> GSI 11 (level, low) -> IRQ 11
[ 1487.094499] PCI: Setting latency timer of device 0000:00:1f.5 to 64
[ 1488.347180] ALSA sound/pci/ac97/ac97_codec.c:2053: AC'97 0 does not respond - RESET
[ 1488.347442] ACPI: PCI interrupt for device 0000:00:1f.5 disabled
[ 1488.347569] Intel ICH: probe of 0000:00:1f.5 failed with error -13

After another unload-load cycle, I get a working device again and this
in dmesg:

[ 2623.093209] ACPI: PCI Interrupt 0000:00:1f.5[B] -> Link [LNKB] -> GSI 11 (level, low) -> IRQ 11
[ 2623.095264] PCI: Setting latency timer of device 0000:00:1f.5 to 64
[ 2623.975121] intel8x0_measure_ac97_clock: measured 50399 usecs
[ 2623.975268] intel8x0: clocking to 48000

Please let me know if you need more information to debug this issue.
It's really annoying :/

Many thanks in advance,
	Hannes
