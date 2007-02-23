Return-Path: <linux-kernel-owner+w=401wt.eu-S1752110AbXBWBou@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752110AbXBWBou (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 20:44:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752112AbXBWBou
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 20:44:50 -0500
Received: from mga05.intel.com ([192.55.52.89]:9381 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752110AbXBWBot (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 20:44:49 -0500
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,208,1170662400"; 
   d="scan'208"; a="203158713:sNHT19194035"
Date: Thu, 22 Feb 2007 17:09:26 -0800
From: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
To: linux-kernel <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 2/5] RT kernel: HPET as clocksource
Message-ID: <20070222170926.A27475@unix-os.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.2.5.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



Use HPET address detected by quirk, when it is not listed by BIOS and
register HPET as a clocksource.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>

Index: linux-2.6.21-rc-mm/arch/x86_64/kernel/hpet.c
===================================================================
--- linux-2.6.21-rc-mm.orig/arch/x86_64/kernel/hpet.c
+++ linux-2.6.21-rc-mm/arch/x86_64/kernel/hpet.c
@@ -12,7 +12,7 @@
 #include <asm/timex.h>
 #include <asm/hpet.h>
 
-int nohpet __initdata = 1;
+int nohpet __initdata;
 
 unsigned long hpet_address;
 unsigned long hpet_period;	/* fsecs / HPET clock */
@@ -106,18 +106,21 @@ int hpet_timer_stop_set_go(unsigned long
 	return 0;
 }
 
-int hpet_arch_init(void)
+static int init_basic_hpet_done __initdata;
+
+static int __init init_basic_hpet(void)
 {
 	unsigned int id;
 
-	if (!hpet_address)
-		return -1;
+	if (init_basic_hpet_done)
+		return 0;
+
 	set_fixmap_nocache(FIX_HPET_BASE, hpet_address);
 	__set_fixmap(VSYSCALL_HPET, hpet_address, PAGE_KERNEL_VSYSCALL_NOCACHE);
 
-/*
- * Read the period, compute tick and quotient.
- */
+	/*
+	 * Read the period, compute tick and quotient.
+	 */
 
 	id = hpet_readl(HPET_ID);
 
@@ -130,6 +133,26 @@ int hpet_arch_init(void)
 
 	hpet_tick = (FSEC_PER_TICK + hpet_period / 2) / hpet_period;
 
+	printk(KERN_DEBUG "HPET: hpet_period %lu, hpet_tick %lu\n", hpet_period,
+			hpet_tick);
+
+	init_basic_hpet_done = 1;
+	return 0;
+}
+
+int __init hpet_arch_init(void)
+{
+	unsigned int id;
+	int ret;
+
+	if (!hpet_address)
+		return -1;
+
+	ret = init_basic_hpet();
+	if (ret)
+		return ret;
+
+	id = hpet_readl(HPET_ID);
 	hpet_use_timer = (id & HPET_ID_LEGSUP);
 
 	return hpet_timer_stop_set_go(hpet_tick);
@@ -451,16 +474,14 @@ __setup("nohpet", nohpet_setup);
 /* FSEC = 10^-15 NSEC = 10^-9 */
 #define FSEC_PER_NSEC	1000000
 
-static void *hpet_ptr;
-
 static cycle_t notrace read_hpet(void)
 {
-	return (cycle_t)readl(hpet_ptr);
+	return (cycle_t)hpet_readl(HPET_COUNTER);
 }
 
 static cycle_t __vsyscall_fn vread_hpet(void)
 {
-	return readl((void __iomem *)fix_to_virt(VSYSCALL_HPET) + 0xf0);
+	return readl((void __iomem *)fix_to_virt(VSYSCALL_HPET) + HPET_COUNTER);
 }
 
 struct clocksource clocksource_hpet = {
@@ -476,20 +497,8 @@ struct clocksource clocksource_hpet = {
 
 static int __init init_hpet_clocksource(void)
 {
-	unsigned long hpet_period;
-	void __iomem *hpet_base;
 	u64 tmp;
 
-	if (!hpet_address)
-		return -ENODEV;
-
-	/* calculate the hpet address: */
-	hpet_base = ioremap_nocache(hpet_address, HPET_MMAP_SIZE);
-	hpet_ptr = hpet_base + HPET_COUNTER;
-
-	/* calculate the frequency: */
-	hpet_period = readl(hpet_base + HPET_PERIOD);
-
 	/*
 	 * hpet period is in femto seconds per cycle
 	 * so we need to convert this to ns/cyc units
@@ -508,4 +517,38 @@ static int __init init_hpet_clocksource(
 	return clocksource_register(&clocksource_hpet);
 }
 
-module_init(init_hpet_clocksource);
+static int __init init_hpet_generic_timer(void)
+{
+	int ret;
+
+	if (nohpet)
+		return -ENODEV;
+
+	if (!hpet_address)
+		hpet_address = force_hpet_address;
+
+	if (!hpet_address)
+		return -ENODEV;
+
+	ret = init_basic_hpet();
+	if (ret)
+		return ret;
+
+	ret = init_hpet_clocksource();
+	if (!ret) {
+		printk(KERN_DEBUG "Successfully registered HPET clocksource\n");
+	} else {
+		printk(KERN_DEBUG "HPET clocksource init failed\n");
+	}
+
+	if (ret) {
+		unsigned int cfg;
+		cfg = hpet_readl(HPET_CFG);
+		cfg &= (~HPET_CFG_ENABLE);
+		hpet_writel(cfg, HPET_CFG);
+	}
+
+	return ret;
+}
+
+module_init(init_hpet_generic_timer);
