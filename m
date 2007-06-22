Return-Path: <linux-kernel-owner+w=401wt.eu-S1757312AbXFVUp4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757312AbXFVUp4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 16:45:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752120AbXFVUpr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 16:45:47 -0400
Received: from mga01.intel.com ([192.55.52.88]:24583 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751175AbXFVUpq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 16:45:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,452,1175497200"; 
   d="scan'208";a="260112617"
Date: Fri, 22 Jun 2007 13:41:24 -0700
From: Venki Pallipadi <venkatesh.pallipadi@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 4/7] ICH Force HPET: Late initialization of hpet after quirk
Message-ID: <20070622204124.GD22807@linux-os.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



Enable HPET later during boot, after the force detect in PCI quirks.
Also add a call to repeat the force enabling at resume time.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>

---
 arch/i386/kernel/hpet.c |   50 +++++++++++++++++++++++++++++++++++++++++++-----
 include/asm-i386/hpet.h |    1 
 2 files changed, 46 insertions(+), 5 deletions(-)

Index: linux-2.6.22-rc5/include/asm-i386/hpet.h
===================================================================
--- linux-2.6.22-rc5.orig/include/asm-i386/hpet.h	2007-06-17 08:52:10.000000000 +0200
+++ linux-2.6.22-rc5/include/asm-i386/hpet.h	2007-06-17 08:52:10.000000000 +0200
@@ -64,6 +64,7 @@
 
 /* hpet memory map physical address */
 extern unsigned long hpet_address;
+extern unsigned long force_hpet_address;
 extern int is_hpet_enabled(void);
 extern int hpet_enable(void);
 
Index: linux-2.6.22-rc5/arch/i386/kernel/hpet.c
===================================================================
--- linux-2.6.22-rc5.orig/arch/i386/kernel/hpet.c	2007-06-17 08:52:10.000000000 +0200
+++ linux-2.6.22-rc5/arch/i386/kernel/hpet.c	2007-06-17 08:52:10.000000000 +0200
@@ -25,6 +25,8 @@ extern struct clock_event_device *global
  */
 unsigned long hpet_address;
 
+static void __iomem * hpet_virt_address;
+
 #ifdef CONFIG_X86_64
 
 #include <asm/pgtable.h>
@@ -34,19 +36,22 @@ static inline void hpet_set_mapping(void
 {
 	set_fixmap_nocache(FIX_HPET_BASE, hpet_address);
 	__set_fixmap(VSYSCALL_HPET, hpet_address, PAGE_KERNEL_VSYSCALL_NOCACHE);
+	hpet_virt_address = (void __iomem *)fix_to_virt(FIX_HPET_BASE);
+
 }
 
 static inline void __iomem *hpet_get_virt_address(void)
 {
-	return (void __iomem *)fix_to_virt(FIX_HPET_BASE);
+	return hpet_virt_address;
 }
 
-static inline void hpet_clear_mapping(void) { }
+static inline void hpet_clear_mapping(void)
+{
+	hpet_virt_address = NULL;
+}
 
 #else
 
-static void __iomem * hpet_virt_address;
-
 static inline unsigned long hpet_readl(unsigned long a)
 {
 	return readl(hpet_virt_address + a);
@@ -173,6 +178,7 @@ static struct clock_event_device hpet_cl
 	.set_next_event = hpet_legacy_next_event,
 	.shift		= 32,
 	.irq		= 0,
+	.rating		= 50,
 };
 
 static void hpet_start_counter(void)
@@ -187,6 +193,17 @@ static void hpet_start_counter(void)
 	hpet_writel(cfg, HPET_CFG);
 }
 
+static void hpet_resume_device(void)
+{
+	ich_force_hpet_resume();
+}
+
+static void hpet_restart_counter(void)
+{
+	hpet_resume_device();
+	hpet_start_counter();
+}
+
 static void hpet_enable_legacy_int(void)
 {
 	unsigned long cfg = hpet_readl(HPET_CFG);
@@ -308,7 +325,7 @@ static struct clocksource clocksource_hp
 	.mask		= HPET_MASK,
 	.shift		= HPET_SHIFT,
 	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
-	.resume		= hpet_start_counter,
+	.resume		= hpet_restart_counter,
 #ifdef CONFIG_X86_64
 	.vread		= vread_hpet,
 #endif
@@ -372,6 +389,9 @@ int __init hpet_enable(void)
 {
 	unsigned long id;
 
+	if (hpet_get_virt_address())
+		return 0;
+
 	if (!is_hpet_capable())
 		return 0;
 
@@ -416,6 +436,26 @@ out_nohpet:
 }
 
 
+static int __init hpet_late_init(void)
+{
+	if (boot_hpet_disable)
+		return -ENODEV;
+
+	if (!hpet_address) {
+		if (!force_hpet_address)
+			return -ENODEV;
+
+		hpet_address = force_hpet_address;
+		hpet_enable();
+		if (!hpet_get_virt_address())
+			return -ENODEV;
+	}
+
+	return 0;
+}
+fs_initcall(hpet_late_init);
+
+
 #ifdef CONFIG_HPET_EMULATE_RTC
 
 /* HPET in LegacyReplacement Mode eats up RTC interrupt line. When, HPET
