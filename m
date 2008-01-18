Return-Path: <linux-kernel-owner+w=401wt.eu-S1763980AbYARR2m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763980AbYARR2m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 12:28:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762645AbYARR1X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 12:27:23 -0500
Received: from mx2.suse.de ([195.135.220.15]:35692 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761848AbYARR1V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 12:27:21 -0500
From: Andi Kleen <ak@suse.de>
References: <20080118627.198787000@suse.de>
In-Reply-To: <20080118627.198787000@suse.de>
To: mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Subject: [PATCH] [4/7] Convert TSC disabling to generic cpuid disable bitmap
Message-Id: <20080118172720.86C4F14AAE@wotan.suse.de>
Date: Fri, 18 Jan 2008 18:27:20 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This cleans up quite a lot of code.

I think I test compiled all the affected variants (voyager, numaq), 
but didn't test them, but the change is pretty straight forward for 
them. 

This means NUMAQ didn't compile, but I don't think it was related
to my patches.

Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/x86/kernel/cpu/bugs.c    |    2 +-
 arch/x86/kernel/cpu/common.c  |    9 ---------
 arch/x86/kernel/numaq_32.c    |    2 +-
 arch/x86/kernel/tsc_32.c      |   14 +++-----------
 arch/x86/mach-voyager/setup.c |    2 +-
 arch/x86/xen/time.c           |    2 +-
 include/asm-x86/tsc.h         |    2 --
 7 files changed, 7 insertions(+), 26 deletions(-)

Index: linux/arch/x86/kernel/cpu/bugs.c
===================================================================
--- linux.orig/arch/x86/kernel/cpu/bugs.c
+++ linux/arch/x86/kernel/cpu/bugs.c
@@ -154,7 +154,7 @@ static void __init check_config(void)
  * If we configured ourselves for a TSC, we'd better have one!
  */
 #ifdef CONFIG_X86_TSC
-	if (!cpu_has_tsc && !tsc_disable)
+	if (!cpu_has_tsc)
 		panic("Kernel compiled for Pentium+, requires TSC feature!");
 #endif
 
Index: linux/arch/x86/kernel/cpu/common.c
===================================================================
--- linux.orig/arch/x86/kernel/cpu/common.c
+++ linux/arch/x86/kernel/cpu/common.c
@@ -446,10 +446,6 @@ void __cpuinit identify_cpu(struct cpuin
 	 * we do "generic changes."
 	 */
 
-	/* TSC disabled? */
-	if ( tsc_disable )
-		clear_bit(X86_FEATURE_TSC, c->x86_capability);
-
 	/* If the model name is still unset, do table lookup. */
 	if ( !c->x86_model_id[0] ) {
 		char *p;
@@ -650,11 +646,6 @@ void __cpuinit cpu_init(void)
 
 	if (cpu_has_vme || cpu_has_tsc || cpu_has_de)
 		clear_in_cr4(X86_CR4_VME|X86_CR4_PVI|X86_CR4_TSD|X86_CR4_DE);
-	if (tsc_disable && cpu_has_tsc) {
-		printk(KERN_NOTICE "Disabling TSC...\n");
-		/**** FIX-HPA: DOES THIS REALLY BELONG HERE? ****/
-		clear_bit(X86_FEATURE_TSC, boot_cpu_data.x86_capability);
-	}
 
 	load_idt(&idt_descr);
 	switch_to_new_gdt();
Index: linux/arch/x86/kernel/numaq_32.c
===================================================================
--- linux.orig/arch/x86/kernel/numaq_32.c
+++ linux/arch/x86/kernel/numaq_32.c
@@ -82,7 +82,7 @@ static int __init numaq_tsc_disable(void
 {
 	if (num_online_nodes() > 1) {
 		printk(KERN_DEBUG "NUMAQ: disabling TSC\n");
-		tsc_disable = 1;
+		setup_clear_cpu_cap(X86_FEATURE_TSC);
 	}
 	return 0;
 }
Index: linux/arch/x86/kernel/tsc_32.c
===================================================================
--- linux.orig/arch/x86/kernel/tsc_32.c
+++ linux/arch/x86/kernel/tsc_32.c
@@ -24,8 +24,6 @@ static int tsc_enabled;
 unsigned int tsc_khz;
 EXPORT_SYMBOL_GPL(tsc_khz);
 
-int tsc_disable;
-
 #ifdef CONFIG_X86_TSC
 static int __init tsc_setup(char *str)
 {
@@ -40,8 +38,7 @@ static int __init tsc_setup(char *str)
  */
 static int __init tsc_setup(char *str)
 {
-	tsc_disable = 1;
-
+	setup_clear_cpu_cap(X86_FEATURE_TSC);
 	return 1;
 }
 #endif
@@ -395,7 +392,7 @@ void __init tsc_init(void)
 {
 	int cpu;
 
-	if (!cpu_has_tsc || tsc_disable)
+	if (!cpu_has_tsc)
 		goto out_no_tsc;
 
 	cpu_khz = calculate_cpu_khz();
@@ -439,10 +436,5 @@ void __init tsc_init(void)
 	return;
 
 out_no_tsc:
-	/*
-	 * Set the tsc_disable flag if there's no TSC support, this
-	 * makes it a fast flag for the kernel to see whether it
-	 * should be using the TSC.
-	 */
-	tsc_disable = 1;
+	setup_clear_cpu_cap(X86_FEATURE_TSC);
 }
Index: linux/arch/x86/mach-voyager/setup.c
===================================================================
--- linux.orig/arch/x86/mach-voyager/setup.c
+++ linux/arch/x86/mach-voyager/setup.c
@@ -37,7 +37,7 @@ void __init pre_setup_arch_hook(void)
 {
 	/* Voyagers run their CPUs from independent clocks, so disable
 	 * the TSC code because we can't sync them */
-	tsc_disable = 1;
+	setup_clear_cpu_cap(X86_FEATURE_TSC);
 }
 
 void __init trap_init_hook(void)
Index: linux/arch/x86/xen/time.c
===================================================================
--- linux.orig/arch/x86/xen/time.c
+++ linux/arch/x86/xen/time.c
@@ -592,7 +592,7 @@ __init void xen_time_init(void)
 	set_normalized_timespec(&wall_to_monotonic,
 				-xtime.tv_sec, -xtime.tv_nsec);
 
-	tsc_disable = 0;
+	setup_clear_cpu_cap(X86_FEATURE_TSC);
 
 	xen_setup_timer(cpu);
 	xen_setup_cpu_clockevents();
Index: linux/include/asm-x86/tsc.h
===================================================================
--- linux.orig/include/asm-x86/tsc.h
+++ linux/include/asm-x86/tsc.h
@@ -16,8 +16,6 @@ typedef unsigned long long cycles_t;
 
 extern unsigned int cpu_khz;
 extern unsigned int tsc_khz;
-/* flag for disabling the tsc */
-extern int tsc_disable;
 
 extern void disable_TSC(void);
 
