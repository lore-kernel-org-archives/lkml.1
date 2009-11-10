Return-Path: <linux-kernel-owner+w=401wt.eu-S1756596AbZKJPBV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756596AbZKJPBV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 10:01:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751031AbZKJPBV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 10:01:21 -0500
Received: from winfree.gag.com ([192.133.104.8]:37293 "EHLO winfree.gag.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750830AbZKJPBU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 10:01:20 -0500
X-Greylist: delayed 464 seconds by postgrey-1.27 at vger.kernel.org; Tue, 10 Nov 2009 10:01:20 EST
To: linux-kernel@vger.kernel.org, tiwai@suse.de
Subject: problem with codec discovery on HP 2530p
Message-Id: <20091110145338.A55E719D7AD@rover.gag.com>
Date: Tue, 10 Nov 2009 09:53:38 -0500 (EST)
From: bdale@gag.com (Bdale Garbee)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I recently moved from 2.6.30.9 to the 2.6.32-rcX series on my HP EliteBook 
2530p.  Audio didn't work, and I've finally made time to track down the 
problem.  It turns out the problem actually started with 2.6.31-rc1, due
to a patch that was part of the 2.6.30-rcX series but apparently wasn't in
the 2.6.30 stable release.  

The symptom is:

HDA Intel 0000:00:1b.0: power state changed by ACPI to D0
HDA Intel 0000:00:1b.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
HDA Intel 0000:00:1b.0: irq 30 for MSI/MSI-X
HDA Intel 0000:00:1b.0: setting latency timer to 64
hda-intel: Codec #0 probe error; disabling it...
hda-intel: spurious response 0x0:0x0, last cmd=0x0f0000
hda-intel: no codecs initialized
hda-intel: spurious response 0x0:0x0, last cmd=0x0f0000
HDA Intel 0000:00:1b.0: PCI INT A disabled

The codec in this machine is an AD1984A.  Bisecting, I discovered that 
reverting this single commit fixes things for me in 2.6.32-rc6:

8174086167d43d0fd7b21928074145ae1d15bbab is the first bad commit
commit 8174086167d43d0fd7b21928074145ae1d15bbab
Author: Takashi Iwai <tiwai@suse.de>
Date:   Tue May 26 15:22:00 2009 +0200

    ALSA: hda - Allow concurrent RIRB access in single_cmd mode
    
    In the single_cmd mode, the current driver code doesn't do any update
    for RIRB just for any safety reason.  But, actually the RIRB and
    single_cmd mode don't conflict.  Unsolicited events can be delivered
    even while using the single_cmd mode.
    
    This patch allows the handling of unsolicited events with single_cmd
    mode, just always checking RIRB independent from single_cmd flag.
    
    Signed-off-by: Takashi Iwai <tiwai@suse.de>

:040000 040000 f4fa70b3ac4fe54d436c59c26c9fe6754625953e 65ff495d67e60d2cf33bf9ea994a0a828d367284 M	sound

