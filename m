Return-Path: <linux-kernel-owner+w=401wt.eu-S1755010AbZB1Shm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755010AbZB1Shm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 13:37:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753292AbZB1She
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 13:37:34 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:49248 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752834AbZB1Shd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 13:37:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=aNxmEPCbS98Juu8Pz1bsMktLr1QT5Cw71LbCxfjk4d2GJfuDAT3/bZNSs1yrLTivba
         UB/GAHv5OnYFc/J2g4GuSLd4KanikoKe9XRA0OqQ03Eont7BZVlZ9/ExTOGiLqaH5pwe
         I7Rui8XKhqzSxDnZspVqDCmZgLxPwYhZx/ZLU=
Date: Sat, 28 Feb 2009 21:44:12 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: tiwai@suse.de
Cc: linux-kernel@vger.kernel.org, akpm@osdl.org, torvalds@osdl.org
Subject: No more Intel HDA soundcard
Message-ID: <20090228184412.GA2333@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following commit results in soundcard detection failing with -EBUSY

commit 34c25350acfc792747e861d1e36874abf7e73255
Author: Takashi Iwai <tiwai@suse.de>
Date:   Tue Oct 28 11:38:58 2008 +0100

    ALSA: hda - Remove old codec-probe limitation
    
    Removed the old workaround to avoid the non-existing codec slot.
    The current code should work without that workaround.  If any,
    we can add a quirk table.
    
    Signed-off-by: Takashi Iwai <tiwai@suse.de>

I fixed up this (and got sound back) but suspect the following is not right.

--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -1224,6 +1224,7 @@ static void azx_stop_chip(struct azx *chip);
 
 /* number of codec slots for each chipset: 0 = default slots (i.e. 4) */
 static unsigned int azx_max_codecs[AZX_NUM_DRIVERS] __devinitdata = {
+	[AZX_DRIVER_ICH] = 3,
 	[AZX_DRIVER_TERA] = 1,
 };
 

dmesg from fixed up kernel:

[    5.362853] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[    5.362963] HDA Intel 0000:00:1b.0: setting latency timer to 64
[    5.395164] hda_codec: Unknown model for ALC268, trying auto-probe from BIOS...
[    5.464685] ALSA device list:
[    5.464756]   #0: HDA Intel at 0xf6700000 irq 22

dmesg from broken kernel:

Advanced Linux Sound Architecture Driver Version 1.0.18a.
HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
hda_codec: Unknown model for ALC268, trying auto-probe from BIOS...
hda_codec: Unknown model for ALC268, trying auto-probe from BIOS...
hda_codec: Cannot set up configuration from BIOS.  Using base mode...
SPDIF already defined
HDA Intel 0000:00:1b.0: PCI INT A disabled
HDA Intel: probe of 0000:00:1b.0 failed with error -16
ALSA device list:
  No soundcards found.


00:1b.0 Audio device [0403]: Intel Corporation 82801H (ICH8 Family) HD Audio Controller [8086:284b] (rev 03)
	Subsystem: Toshiba America Info Systems Device [1179:ff00]
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 22
	Region 0: Memory at f6700000 (64-bit, non-prefetchable) [size=16K]
	Capabilities: <access denied>
	Kernel driver in use: HDA Intel
