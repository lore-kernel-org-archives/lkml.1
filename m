Return-Path: <linux-kernel-owner+w=401wt.eu-S1752982AbYKRALs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752982AbYKRALs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 19:11:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751371AbYKRALj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 19:11:39 -0500
Received: from mga09.intel.com ([134.134.136.24]:39031 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751327AbYKRALi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 19:11:38 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,620,1220252400"; 
   d="scan'208";a="464211020"
Date: Mon, 17 Nov 2008 16:11:37 -0800
From: Venki Pallipadi <venkatesh.pallipadi@intel.com>
To: H Peter Anvin <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: Support always running TSC on Intel CPUs
Message-ID: <20081118001137.GA12350@linux-os.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Add support for CPUID_0x80000007_Bit8 on Intel CPUs as well. This bit means
that the TSC is invariant with C/P/T states and always runs at constant
frequency.

With Intel CPUs, we have 3 classes
* CPUs where TSC runs at constant rate and does not stop n C-states
* CPUs where TSC runs at constant rate, but will stop in deep C-states
* CPUs where TSC rate will vary based on P/T-states and TSC will stop in deep
  C-states.

To cover these 3, one feature bit (CONSTANT_TSC) is not enough. So, add a
second bit (NOSTOP_TSC). CONSTANT_TSC indicates that the TSC runs at
constant frequency irrespective of P/T-states, and NOSTOP_TSC indicates
that TSC does not stop in deep C-states.

CPUID_0x8000000_Bit8 indicates both these feature bit can be set.
We still have CONSTANT_TSC _set_ and NOSTOP_TSC _not_set_ on some older Intel
CPUs, based on model checks. We can use TSC on such CPUs for time, as long as
those CPUs do not support/enter deep C-states.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>

---
 arch/x86/include/asm/cpufeature.h |    1 +
 arch/x86/kernel/cpu/amd.c         |    9 +++++++--
 arch/x86/kernel/cpu/intel.c       |   10 ++++++++++
 arch/x86/kernel/process.c         |    2 +-
 drivers/acpi/processor_idle.c     |    6 +++---
 5 files changed, 22 insertions(+), 6 deletions(-)

Index: tip/arch/x86/kernel/cpu/amd.c
===================================================================
--- tip.orig/arch/x86/kernel/cpu/amd.c	2008-11-17 12:48:08.000000000 -0800
+++ tip/arch/x86/kernel/cpu/amd.c	2008-11-17 15:49:39.000000000 -0800
@@ -283,9 +283,14 @@ static void __cpuinit early_init_amd(str
 {
 	early_init_amd_mc(c);
 
-	/* c->x86_power is 8000_0007 edx. Bit 8 is constant TSC */
-	if (c->x86_power & (1<<8))
+	/*
+	 * c->x86_power is 8000_0007 edx. Bit 8 is TSC runs at constant rate
+	 * with P/T states and does not stop in deep C-states
+	 */
+	if (c->x86_power & (1 << 8)) {
 		set_cpu_cap(c, X86_FEATURE_CONSTANT_TSC);
+		set_cpu_cap(c, X86_FEATURE_NOSTOP_TSC);
+	}
 
 #ifdef CONFIG_X86_64
 	set_cpu_cap(c, X86_FEATURE_SYSCALL32);
Index: tip/arch/x86/kernel/cpu/intel.c
===================================================================
--- tip.orig/arch/x86/kernel/cpu/intel.c	2008-11-17 12:48:08.000000000 -0800
+++ tip/arch/x86/kernel/cpu/intel.c	2008-11-17 15:49:39.000000000 -0800
@@ -41,6 +41,16 @@ static void __cpuinit early_init_intel(s
 	if (c->x86 == 15 && c->x86_cache_alignment == 64)
 		c->x86_cache_alignment = 128;
 #endif
+
+	/*
+	 * c->x86_power is 8000_0007 edx. Bit 8 is TSC runs at constant rate
+	 * with P/T states and does not stop in deep C-states
+	 */
+	if (c->x86_power & (1 << 8)) {
+		set_cpu_cap(c, X86_FEATURE_CONSTANT_TSC);
+		set_cpu_cap(c, X86_FEATURE_NOSTOP_TSC);
+	}
+
 }
 
 #ifdef CONFIG_X86_32
Index: tip/drivers/acpi/processor_idle.c
===================================================================
--- tip.orig/drivers/acpi/processor_idle.c	2008-11-17 12:48:11.000000000 -0800
+++ tip/drivers/acpi/processor_idle.c	2008-11-17 15:49:39.000000000 -0800
@@ -374,15 +374,15 @@ static int tsc_halts_in_c(int state)
 {
 	switch (boot_cpu_data.x86_vendor) {
 	case X86_VENDOR_AMD:
+	case X86_VENDOR_INTEL:
 		/*
 		 * AMD Fam10h TSC will tick in all
 		 * C/P/S0/S1 states when this bit is set.
 		 */
-		if (boot_cpu_has(X86_FEATURE_CONSTANT_TSC))
+		if (boot_cpu_has(X86_FEATURE_NOSTOP_TSC))
 			return 0;
+
 		/*FALL THROUGH*/
-	case X86_VENDOR_INTEL:
-		/* Several cases known where TSC halts in C2 too */
 	default:
 		return state > ACPI_STATE_C1;
 	}
Index: tip/arch/x86/include/asm/cpufeature.h
===================================================================
--- tip.orig/arch/x86/include/asm/cpufeature.h	2008-11-17 12:48:08.000000000 -0800
+++ tip/arch/x86/include/asm/cpufeature.h	2008-11-17 15:50:27.000000000 -0800
@@ -93,6 +93,7 @@
 #define X86_FEATURE_AMDC1E	(3*32+21) /* AMD C1E detected */
 #define X86_FEATURE_XTOPOLOGY	(3*32+22) /* cpu topology enum extensions */
 #define X86_FEATURE_TSC_RELIABLE (3*32+23) /* TSC is known to be reliable */
+#define X86_FEATURE_NOSTOP_TSC	(3*32+24) /* TSC does not stop in C states */
 
 /* Intel-defined CPU features, CPUID level 0x00000001 (ecx), word 4 */
 #define X86_FEATURE_XMM3	(4*32+ 0) /* "pni" SSE-3 */
Index: tip/arch/x86/kernel/process.c
===================================================================
--- tip.orig/arch/x86/kernel/process.c	2008-11-17 12:48:08.000000000 -0800
+++ tip/arch/x86/kernel/process.c	2008-11-17 15:49:39.000000000 -0800
@@ -286,7 +286,7 @@ static void c1e_idle(void)
 		rdmsr(MSR_K8_INT_PENDING_MSG, lo, hi);
 		if (lo & K8_INTP_C1E_ACTIVE_MASK) {
 			c1e_detected = 1;
-			if (!boot_cpu_has(X86_FEATURE_CONSTANT_TSC))
+			if (!boot_cpu_has(X86_FEATURE_NOSTOP_TSC))
 				mark_tsc_unstable("TSC halt in AMD C1E");
 			printk(KERN_INFO "System has AMD C1E enabled\n");
 			set_cpu_cap(&boot_cpu_data, X86_FEATURE_AMDC1E);
