Return-Path: <linux-kernel-owner+w=401wt.eu-S1760637AbXGOMBr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760637AbXGOMBr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 08:01:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757994AbXGOMBi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 08:01:38 -0400
Received: from pxy2nd.nifty.com ([202.248.175.14]:30372 "HELO pxy2nd.nifty.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757072AbXGOMBi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 08:01:38 -0400
X-Nifty-SrcIP: [210.170.245.86]
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=pxy2nd-default; d=mbf.nifty.com;
  b=p77GB6j5ClgQdvVBFMp9J0Fya9yKKLJLV9l2uc3v2Ft+tWzT9VZxtbANxiQRCrsrG9uMYjsv/zq/iDJv7Nk+tw==  ;
Date: Sun, 15 Jul 2007 21:00:36 +0900 (JST)
Message-Id: <20070715.210036.157242351.takada@mbf.nifty.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] i386: Geode's TSC is not neccessary to mark tu unstable
From: TAKADA Yoshihito <takada@mbf.nifty.com>
X-Mailer: Mew version 5.1 on Emacs 22.1.50 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi. I reported to remove pit_latch_buggy(http://lkml.org/lkml/2007/2/10/8).
In the report, I stated that TSC was unstable.
When I installed 2.6.21, GeodeGX's TSC is stable.
It was fixed by http://bugzilla.kernel.org/show_bug.cgi?id=8027 and follow:

commit 6b3964cde70cfe6db79d35b42137431ef7d2f7e4
Author: Thomas Gleixner <tglx@linutronix.de>
Date:   Thu Mar 22 22:46:18 2007 +0100

    [PATCH] i386: clockevents fix breakage on Geode/Cyrix PIT implementations

In 2.6.22, marks unstable GeodeGX's TSC. However, it is not necessary to 
mark TSC is unstable.

Signed-off-by: TAKADA Yoshihito <takada@mbf.nifty.com>

diff -Narup a/arch/i386/kernel/cpu/cyrix.c b/arch/i386/kernel/cpu/cyrix.c
--- a/arch/i386/kernel/cpu/cyrix.c	2007-07-15 16:55:29.000000000 +0900
+++ b/arch/i386/kernel/cpu/cyrix.c	2007-07-15 20:21:11.000000000 +0900
@@ -6,7 +6,6 @@
 #include <asm/io.h>
 #include <asm/processor.h>
 #include <asm/timer.h>
-#include <asm/pci-direct.h>
 #include <asm/tsc.h>
 
 #include "cpu.h"
@@ -252,8 +251,6 @@ static void __cpuinit init_cyrix(struct 
 
 	case 4: /* MediaGX/GXm or Geode GXM/GXLV/GX1 */
 #ifdef CONFIG_PCI
-	{
-		u32 vendor, device;
 		/* It isn't really a PCI quirk directly, but the cure is the
 		   same. The MediaGX has deep magic SMM stuff that handles the
 		   SB emulation. It thows away the fifo on disable_dma() which
@@ -268,21 +265,6 @@ static void __cpuinit init_cyrix(struct 
 
 		printk(KERN_INFO "Working around Cyrix MediaGX virtual DMA bugs.\n");
 		isa_dma_bridge_buggy = 2;
-
-		/* We do this before the PCI layer is running. However we
-		   are safe here as we know the bridge must be a Cyrix
-		   companion and must be present */
-		vendor = read_pci_config_16(0, 0, 0x12, PCI_VENDOR_ID);
-		device = read_pci_config_16(0, 0, 0x12, PCI_DEVICE_ID);
-
-		/*
-		 *  The 5510/5520 companion chips have a funky PIT.
-		 */  
-		if (vendor == PCI_VENDOR_ID_CYRIX &&
-	 (device == PCI_DEVICE_ID_CYRIX_5510 || device == PCI_DEVICE_ID_CYRIX_5520))
-			/*mark_tsc_unstable("cyrix 5510/5520 detected");*/
-			printk("cyrix 5510/5520 detected\n");
-	}
 #endif
 		c->x86_cache_size=16;	/* Yep 16K integrated cache thats it */
 

