Return-Path: <linux-kernel-owner+w=401wt.eu-S932190AbYARR1z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932190AbYARR1z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 12:27:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761999AbYARR1V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 12:27:21 -0500
Received: from cantor.suse.de ([195.135.220.2]:53249 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761464AbYARR1T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 12:27:19 -0500
From: Andi Kleen <ak@suse.de>
References: <20080118627.198787000@suse.de>
In-Reply-To: <20080118627.198787000@suse.de>
To: mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Subject: [PATCH] [2/7] Convert some existing cpuid disable options to new generic bitmap
Message-Id: <20080118172718.644F914AAE@wotan.suse.de>
Date: Fri, 18 Jan 2008 18:27:18 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This convers nofxsr, mem=nopentium and nosep to use the new
generic cpuid disable bitmap instead of using own variables.

Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/x86/kernel/cpu/common.c |   34 ++++------------------------------
 arch/x86/kernel/setup_32.c   |    5 +----
 2 files changed, 5 insertions(+), 34 deletions(-)

Index: linux/arch/x86/kernel/cpu/common.c
===================================================================
--- linux.orig/arch/x86/kernel/cpu/common.c
+++ linux/arch/x86/kernel/cpu/common.c
@@ -60,14 +60,10 @@ EXPORT_PER_CPU_SYMBOL_GPL(gdt_page);
 __u32 cleared_cpu_caps[NCAPINTS] __cpuinitdata;
 
 static int cachesize_override __cpuinitdata = -1;
-static int disable_x86_fxsr __cpuinitdata;
 static int disable_x86_serial_nr __cpuinitdata = 1;
-static int disable_x86_sep __cpuinitdata;
 
 struct cpu_dev * cpu_devs[X86_VENDOR_NUM] = {};
 
-extern int disable_pse;
-
 static void __cpuinit default_init(struct cpuinfo_x86 * c)
 {
 	/* Not much we can do here... */
@@ -216,16 +212,8 @@ static void __cpuinit get_cpu_vendor(str
 
 static int __init x86_fxsr_setup(char * s)
 {
-	/* Tell all the other CPUs to not use it... */
-	disable_x86_fxsr = 1;
-
-	/*
-	 * ... and clear the bits early in the boot_cpu_data
-	 * so that the bootup process doesn't try to do this
-	 * either.
-	 */
-	clear_bit(X86_FEATURE_FXSR, boot_cpu_data.x86_capability);
-	clear_bit(X86_FEATURE_XMM, boot_cpu_data.x86_capability);
+	setup_clear_cpu_cap(X86_FEATURE_FXSR);
+	setup_clear_cpu_cap(X86_FEATURE_XMM);
 	return 1;
 }
 __setup("nofxsr", x86_fxsr_setup);
@@ -233,7 +221,7 @@ __setup("nofxsr", x86_fxsr_setup);
 
 static int __init x86_sep_setup(char * s)
 {
-	disable_x86_sep = 1;
+	setup_clear_cpu_cap(X86_FEATURE_SEP);
 	return 1;
 }
 __setup("nosep", x86_sep_setup);
@@ -462,19 +450,6 @@ void __cpuinit identify_cpu(struct cpuin
 	if ( tsc_disable )
 		clear_bit(X86_FEATURE_TSC, c->x86_capability);
 
-	/* FXSR disabled? */
-	if (disable_x86_fxsr) {
-		clear_bit(X86_FEATURE_FXSR, c->x86_capability);
-		clear_bit(X86_FEATURE_XMM, c->x86_capability);
-	}
-
-	/* SEP disabled? */
-	if (disable_x86_sep)
-		clear_bit(X86_FEATURE_SEP, c->x86_capability);
-
-	if (disable_pse)
-		clear_bit(X86_FEATURE_PSE, c->x86_capability);
-
 	/* If the model name is still unset, do table lookup. */
 	if ( !c->x86_model_id[0] ) {
 		char *p;
@@ -629,8 +604,7 @@ void __init early_cpu_init(void)
 	/* pse is not compatible with on-the-fly unmapping,
 	 * disable it even if the cpus claim to support it.
 	 */
-	clear_bit(X86_FEATURE_PSE, boot_cpu_data.x86_capability);
-	disable_pse = 1;
+	setup_clear_cpu_cap(X86_FEATURE_PSE);
 #endif
 }
 
Index: linux/arch/x86/kernel/setup_32.c
===================================================================
--- linux.orig/arch/x86/kernel/setup_32.c
+++ linux/arch/x86/kernel/setup_32.c
@@ -70,8 +70,6 @@
    address, and must not be in the .bss segment! */
 unsigned long init_pg_tables_end __initdata = ~0UL;
 
-int disable_pse __cpuinitdata = 0;
-
 /*
  * Machine setup..
  */
@@ -245,8 +243,7 @@ static int __init parse_mem(char *arg)
 		return -EINVAL;
 
 	if (strcmp(arg, "nopentium") == 0) {
-		clear_cpu_cap(&boot_cpu_data, X86_FEATURE_PSE);
-		disable_pse = 1;
+		setup_clear_cpu_cap(X86_FEATURE_PSE);
 	} else {
 		/* If the user specifies memory size, we
 		 * limit the BIOS-provided memory map to
