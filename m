Return-Path: <linux-kernel-owner+w=401wt.eu-S1764095AbXGOQLk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764095AbXGOQLk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 12:11:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762568AbXGOQFQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 12:05:16 -0400
Received: from www.osadl.org ([213.239.205.134]:42563 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762245AbXGOQFE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 12:05:04 -0400
Message-Id: <20070715155541.330638388@inhelltoy.tec.linutronix.de>
References: <20070715155510.341941668@inhelltoy.tec.linutronix.de>
User-Agent: quilt/0.46-1
Date: Sun, 15 Jul 2007 16:10:56 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <ak@suse.de>, Chris Wright <chrisw@sous-sol.org>
Subject: [patch-mm 15/33] i386: prepare sharing the hpet code with x86_64
Content-Disposition: inline; filename=i386-prepare-sharing-hpet-code.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The hpet implementations of i386 and x8664 has been mostly the same
before the clock events conversion of i386. The clock events
conversion of i386 hpet is already done. So it makes sense to share
the code for the x86_64 clock events conversion.

Abstract out the mapping functions.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>

---
 arch/i386/kernel/hpet.c |   25 +++++++++++++++++--------
 1 file changed, 17 insertions(+), 8 deletions(-)

Index: linux-2.6.22-rc6-mm/arch/i386/kernel/hpet.c
===================================================================
--- linux-2.6.22-rc6-mm.orig/arch/i386/kernel/hpet.c	2007-07-15 17:26:45.000000000 +0200
+++ linux-2.6.22-rc6-mm/arch/i386/kernel/hpet.c	2007-07-15 17:49:01.000000000 +0200
@@ -3,14 +3,14 @@
 #include <linux/errno.h>
 #include <linux/hpet.h>
 #include <linux/init.h>
+#include <linux/ioport.h>
 #include <linux/sysdev.h>
 #include <linux/pm.h>
 
 #include <asm/hpet.h>
+#include <asm/i8253.h>
 #include <asm/io.h>
 
-extern struct clock_event_device *global_clock_event;
-
 #define HPET_MASK	CLOCKSOURCE_MASK(32)
 #define HPET_SHIFT	22
 
@@ -21,7 +21,7 @@ extern struct clock_event_device *global
  * HPET address is set in acpi/boot.c, when an ACPI entry exists
  */
 unsigned long hpet_address;
-static void __iomem * hpet_virt_address;
+static void __iomem *hpet_virt_address;
 
 static inline unsigned long hpet_readl(unsigned long a)
 {
@@ -33,6 +33,17 @@ static inline void hpet_writel(unsigned 
 	writel(d, hpet_virt_address + a);
 }
 
+static inline void hpet_set_mapping(void)
+{
+	hpet_virt_address = ioremap_nocache(hpet_address, HPET_MMAP_SIZE);
+}
+
+static inline void hpet_clear_mapping(void)
+{
+	iounmap(hpet_virt_address);
+	hpet_virt_address = NULL;
+}
+
 /*
  * HPET command line enable / disable
  */
@@ -82,7 +93,7 @@ static void hpet_reserve_platform_timers
 
 	memset(&hd, 0, sizeof (hd));
 	hd.hd_phys_address = hpet_address;
-	hd.hd_address = hpet_virt_address;
+	hd.hd_address = hpet;
 	hd.hd_nirqs = nrtimers;
 	hd.hd_flags = HPET_DATA_PLATFORM;
 	hpet_reserve_timer(&hd, 0);
@@ -237,7 +248,7 @@ int __init hpet_enable(void)
 	if (!is_hpet_capable())
 		return 0;
 
-	hpet_virt_address = ioremap_nocache(hpet_address, HPET_MMAP_SIZE);
+	hpet_set_mapping();
 
 	/*
 	 * Read the period and check for a sane value:
@@ -333,13 +344,11 @@ int __init hpet_enable(void)
 	return 0;
 
 out_nohpet:
-	iounmap(hpet_virt_address);
-	hpet_virt_address = NULL;
+	hpet_clear_mapping();
 	boot_hpet_disable = 1;
 	return 0;
 }
 
-
 #ifdef CONFIG_HPET_EMULATE_RTC
 
 /* HPET in LegacyReplacement Mode eats up RTC interrupt line. When, HPET

-- 

