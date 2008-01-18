Return-Path: <linux-kernel-owner+w=401wt.eu-S1764061AbYARR25@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764061AbYARR25 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 12:28:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761936AbYARR1Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 12:27:24 -0500
Received: from mail.suse.de ([195.135.220.2]:53258 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761685AbYARR1W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 12:27:22 -0500
From: Andi Kleen <ak@suse.de>
References: <20080118627.198787000@suse.de>
In-Reply-To: <20080118627.198787000@suse.de>
To: mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Subject: [PATCH] [5/7] Remove CONFIG_X86_TSC for 32bit
Message-Id: <20080118172721.96C8B14AAE@wotan.suse.de>
Date: Fri, 18 Jan 2008 18:27:21 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The config option protects so little code that it is fairly pointless.
Also a lot of its code was related to itself only (as in panicing without
TSC). And TSC less CPUs are completely handled at runtime anyways.

This makes 32bit behaviour match x86-64.

I also removed an #if defined(CONFIG_X86_GENERIC) in get_cycles. Not sure
what that was good for, it didn't make any sense.

Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/x86/Kconfig.cpu          |    4 ----
 arch/x86/kernel/cpu/bugs.c    |    8 --------
 arch/x86/kernel/tsc_32.c      |   10 ----------
 drivers/acpi/processor_idle.c |   10 +++++-----
 include/asm-x86/tsc.h         |    6 ------
 5 files changed, 5 insertions(+), 33 deletions(-)

Index: linux/arch/x86/kernel/cpu/bugs.c
===================================================================
--- linux.orig/arch/x86/kernel/cpu/bugs.c
+++ linux/arch/x86/kernel/cpu/bugs.c
@@ -151,14 +151,6 @@ static void __init check_config(void)
 #endif
 
 /*
- * If we configured ourselves for a TSC, we'd better have one!
- */
-#ifdef CONFIG_X86_TSC
-	if (!cpu_has_tsc)
-		panic("Kernel compiled for Pentium+, requires TSC feature!");
-#endif
-
-/*
  * If we were told we had a good local APIC, check for buggy Pentia,
  * i.e. all B steppings and the C2 stepping of P54C when using their
  * integrated APIC (see 11AP erratum in "Pentium Processor
Index: linux/arch/x86/kernel/tsc_32.c
===================================================================
--- linux.orig/arch/x86/kernel/tsc_32.c
+++ linux/arch/x86/kernel/tsc_32.c
@@ -24,14 +24,6 @@ static int tsc_enabled;
 unsigned int tsc_khz;
 EXPORT_SYMBOL_GPL(tsc_khz);
 
-#ifdef CONFIG_X86_TSC
-static int __init tsc_setup(char *str)
-{
-	printk(KERN_WARNING "notsc: Kernel compiled with CONFIG_X86_TSC, "
-				"cannot disable TSC.\n");
-	return 1;
-}
-#else
 /*
  * disable flag for tsc. Takes effect by clearing the TSC cpu flag
  * in cpu/common.c
@@ -41,8 +33,6 @@ static int __init tsc_setup(char *str)
 	setup_clear_cpu_cap(X86_FEATURE_TSC);
 	return 1;
 }
-#endif
-
 __setup("notsc", tsc_setup);
 
 /*
Index: linux/drivers/acpi/processor_idle.c
===================================================================
--- linux.orig/drivers/acpi/processor_idle.c
+++ linux/drivers/acpi/processor_idle.c
@@ -357,7 +357,7 @@ int acpi_processor_resume(struct acpi_de
 	return 0;
 }
 
-#if defined (CONFIG_GENERIC_TIME) && defined (CONFIG_X86_TSC)
+#if defined (CONFIG_GENERIC_TIME)
 static int tsc_halts_in_c(int state)
 {
 	switch (boot_cpu_data.x86_vendor) {
@@ -534,7 +534,7 @@ static void acpi_processor_idle(void)
 		/* Get end time (ticks) */
 		t2 = inl(acpi_gbl_FADT.xpm_timer_block.address);
 
-#if defined (CONFIG_GENERIC_TIME) && defined (CONFIG_X86_TSC)
+#if defined (CONFIG_GENERIC_TIME)
 		/* TSC halts in C2, so notify users */
 		if (tsc_halts_in_c(ACPI_STATE_C2))
 			mark_tsc_unstable("possible TSC halt in C2");
@@ -599,7 +599,7 @@ static void acpi_processor_idle(void)
 			acpi_set_register(ACPI_BITREG_ARB_DISABLE, 0);
 		}
 
-#if defined (CONFIG_GENERIC_TIME) && defined (CONFIG_X86_TSC)
+#if defined (CONFIG_GENERIC_TIME)
 		/* TSC halts in C3, so notify users */
 		if (tsc_halts_in_c(ACPI_STATE_C3))
 			mark_tsc_unstable("TSC halts in C3");
@@ -1465,7 +1465,7 @@ static int acpi_idle_enter_simple(struct
 	acpi_idle_do_entry(cx);
 	t2 = inl(acpi_gbl_FADT.xpm_timer_block.address);
 
-#if defined (CONFIG_GENERIC_TIME) && defined (CONFIG_X86_TSC)
+#if defined (CONFIG_GENERIC_TIME)
 	/* TSC could halt in idle, so notify users */
 	if (tsc_halts_in_c(cx->type))
 		mark_tsc_unstable("TSC halts in idle");;
@@ -1577,7 +1577,7 @@ static int acpi_idle_enter_bm(struct cpu
 		spin_unlock(&c3_lock);
 	}
 
-#if defined (CONFIG_GENERIC_TIME) && defined (CONFIG_X86_TSC)
+#if defined (CONFIG_GENERIC_TIME)
 	/* TSC could halt in idle, so notify users */
 	if (tsc_halts_in_c(ACPI_STATE_C3))
 		mark_tsc_unstable("TSC halts in idle");
Index: linux/include/asm-x86/tsc.h
===================================================================
--- linux.orig/include/asm-x86/tsc.h
+++ linux/include/asm-x86/tsc.h
@@ -23,14 +23,10 @@ static inline cycles_t get_cycles(void)
 {
 	unsigned long long ret = 0;
 
-#ifndef CONFIG_X86_TSC
 	if (!cpu_has_tsc)
 		return 0;
-#endif
 
-#if defined(CONFIG_X86_GENERIC) || defined(CONFIG_X86_TSC)
 	rdtscll(ret);
-#endif
 	return ret;
 }
 
@@ -40,10 +36,8 @@ static inline cycles_t vget_cycles(void)
 	 * We only do VDSOs on TSC capable CPUs, so this shouldnt
 	 * access boot_cpu_data (which is not VDSO-safe):
 	 */
-#ifndef CONFIG_X86_TSC
 	if (!cpu_has_tsc)
 		return 0;
-#endif
 	return (cycles_t) __native_read_tsc();
 }
 
Index: linux/arch/x86/Kconfig.cpu
===================================================================
--- linux.orig/arch/x86/Kconfig.cpu
+++ linux/arch/x86/Kconfig.cpu
@@ -377,10 +377,6 @@ config X86_OOSTORE
 	def_bool y
 	depends on (MWINCHIP3D || MWINCHIP2 || MWINCHIPC6) && MTRR
 
-config X86_TSC
-	def_bool y
-	depends on ((MWINCHIP3D || MWINCHIP2 || MCRUSOE || MEFFICEON || MCYRIXIII || MK7 || MK6 || MPENTIUM4 || MPENTIUMM || MPENTIUMIII || MPENTIUMII || M686 || M586MMX || M586TSC || MK8 || MVIAC3_2 || MVIAC7 || MGEODEGX1 || MGEODE_LX || MCORE2) && !X86_NUMAQ) || X86_64
-
 # this should be set for all -march=.. options where the compiler
 # generates cmov.
 config X86_CMOV
