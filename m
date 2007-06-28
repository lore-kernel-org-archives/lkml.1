Return-Path: <linux-kernel-owner+w=401wt.eu-S1764228AbXF1DbN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764228AbXF1DbN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 23:31:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762536AbXF1DbE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 23:31:04 -0400
Received: from pxy2nd.nifty.com ([202.248.175.14]:22062 "HELO pxy2nd.nifty.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1759348AbXF1DbC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 23:31:02 -0400
X-Greylist: delayed 423 seconds by postgrey-1.27 at vger.kernel.org; Wed, 27 Jun 2007 23:31:01 EDT
X-Nifty-SrcIP: [220.219.62.68]
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=pxy2nd-default; d=mbf.nifty.com;
  b=kGkmU4krImrrH27ilBX8BtV+Dfc1+hRHeAj4MbxU4oKLrE2Is3Pq8ZA9Sbogovc/3JKgrKGjzVTi8zEc+16u2g==  ;
Date: Thu, 28 Jun 2007 12:22:36 +0900 (JST)
Message-Id: <20070628.122236.23008797.takada@mbf.nifty.com>
To: linux-kernel@vger.kernel.org
Subject: i386: [PATCH 1/1] remove-pit-latch-buggy
From: TAKADA Yoshihito <takada@mbf.nifty.com>
X-Mailer: Mew version 5.1 on Emacs 22.1.50 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In 2.6.18, replace times with clockevents. arch/i386/kernel/timers/ was removed.
`pit_latch_buggy' was referred in timers/timer_tsc.c, and currently removed. 
Therefore nobody refer it. It has no effect already.

Signed-off-by: TAKADA Yoshihito <takada@mbf.nifty.com>

diff -Narup a/arch/i386/kernel/cpu/cyrix.c b/arch/i386/kernel/cpu/cyrix.c
--- a/arch/i386/kernel/cpu/cyrix.c	2007-04-26 12:08:32.000000000 +0900
+++ b/arch/i386/kernel/cpu/cyrix.c	2007-06-28 12:13:13.000000000 +0900
@@ -6,7 +6,6 @@
 #include <asm/io.h>
 #include <asm/processor.h>
 #include <asm/timer.h>
-#include <asm/pci-direct.h>
 
 #include "cpu.h"
 
@@ -251,8 +250,6 @@ static void __cpuinit init_cyrix(struct 
 
 	case 4: /* MediaGX/GXm or Geode GXM/GXLV/GX1 */
 #ifdef CONFIG_PCI
-	{
-		u32 vendor, device;
 		/* It isn't really a PCI quirk directly, but the cure is the
 		   same. The MediaGX has deep magic SMM stuff that handles the
 		   SB emulation. It thows away the fifo on disable_dma() which
@@ -267,20 +264,6 @@ static void __cpuinit init_cyrix(struct 
 
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
-			pit_latch_buggy = 1;
-	}
 #endif
 		c->x86_cache_size=16;	/* Yep 16K integrated cache thats it */
 
diff -Narup a/arch/i386/kernel/time.c b/arch/i386/kernel/time.c
--- a/arch/i386/kernel/time.c	2007-04-26 12:08:32.000000000 +0900
+++ b/arch/i386/kernel/time.c	2007-06-26 10:15:34.000000000 +0900
@@ -70,8 +70,6 @@
 
 #include <asm/i8259.h>
 
-int pit_latch_buggy;              /* extern */
-
 #include "do_timer.h"
 
 unsigned int cpu_khz;	/* Detected as we calibrate the TSC */
diff -Narup a/include/asm-i386/timer.h b/include/asm-i386/timer.h
--- a/include/asm-i386/timer.h	2007-04-26 12:08:32.000000000 +0900
+++ b/include/asm-i386/timer.h	2007-06-26 10:17:02.000000000 +0900
@@ -10,7 +10,6 @@ unsigned long long native_sched_clock(vo
 unsigned long native_calculate_cpu_khz(void);
 
 /* Modifiers for buggy PIT handling */
-extern int pit_latch_buggy;
 extern int timer_ack;
 extern int no_timer_check;
 extern int no_sync_cmos_clock;
