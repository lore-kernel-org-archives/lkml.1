Return-Path: <linux-kernel-owner+w=401wt.eu-S1757194AbYLOVrU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757194AbYLOVrU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 16:47:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755902AbYLOVrK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 16:47:10 -0500
Received: from mga09.intel.com ([134.134.136.24]:46314 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755855AbYLOVrJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 16:47:09 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.36,226,1228118400"; 
   d="scan'208";a="371114484"
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       "hpa@zytor.com" <hpa@zytor.com>, "mingo@elte.hu" <mingo@elte.hu>,
       "tglx@linutronix.de" <tglx@linutronix.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 15 Dec 2008 13:47:52 -0800
Subject: RE: [patch 1/2] x86: Support always running TSC on Intel CPUs
Thread-Topic: [patch 1/2] x86: Support always running TSC on Intel CPUs
Thread-Index: AclPWiMUpyX58njQToCSiohKTfXZxAPpCHdw
Message-ID: <7E82351C108FA840AB1866AC776AEC464338C10B@orsmsx505.amr.corp.intel.com>
References: <20081125235751.576792000@intel.com>
 <20081125235852.402898000@intel.com>
In-Reply-To: <20081125235852.402898000@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


hpa/Ingo,

Haven't seen any comments on the patches here. Can you push it along in case there are no issues.

Thaks,
Venki

>-----Original Message-----
>From: Pallipadi, Venkatesh 
>Sent: Tuesday, November 25, 2008 3:58 PM
>To: hpa@zytor.com; mingo@elte.hu; tglx@linutronix.de
>Cc: joe.korty@ccur.com; linux-kernel@vger.kernel.org; 
>Pallipadi, Venkatesh
>Subject: [patch 1/2] x86: Support always running TSC on Intel CPUs
>
>Add support for CPUID_0x80000007_Bit8 on Intel CPUs as well. 
>This bit means
>that the TSC is invariant with C/P/T states and always runs at constant
>frequency.
>
>With Intel CPUs, we have 3 classes
>* CPUs where TSC runs at constant rate and does not stop n C-states
>* CPUs where TSC runs at constant rate, but will stop in C2/C3 states
>* CPUs where TSC rate will vary based on P/T-states and TSC 
>will stop in
>  C2/C3 states.
>
>To cover these 3, one feature bit (CONSTANT_TSC) is not 
>enough. So, add a
>second bit (ALWAYSRUNS_TSC). CONSTANT_TSC indicates that the 
>TSC runs at
>constant frequency irrespective of P/T-states, and 
>ALWAYSRUNS_TSC indicates
>that TSC does not stop in deep C-states (C2 and beyond).
>
>CPUID_0x8000000_Bit8 indicates both these feature bit can be set.
>We still have CONSTANT_TSC set and ALWAYSRUNS_TSC not set on 
>some older Intel
>CPUs, based on model checks for earlier CPUs. We can use TSC 
>on such CPUs
>for time, as long as those CPUs do not support/enter deep C-states.
>
>Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
>
>---
> arch/x86/include/asm/cpufeature.h |    1 +
> arch/x86/kernel/cpu/amd.c         |    9 +++++++--
> arch/x86/kernel/cpu/intel.c       |   10 ++++++++++
> arch/x86/kernel/process.c         |    2 +-
> drivers/acpi/processor_idle.c     |    6 +++---
> 5 files changed, 22 insertions(+), 6 deletions(-)
>
>Index: tip/arch/x86/kernel/cpu/amd.c
>===================================================================
>--- tip.orig/arch/x86/kernel/cpu/amd.c	2008-11-25 
>13:36:30.000000000 -0800
>+++ tip/arch/x86/kernel/cpu/amd.c	2008-11-25 
>13:46:06.000000000 -0800
>@@ -283,9 +283,14 @@ static void __cpuinit early_init_amd(str
> {
> 	early_init_amd_mc(c);
> 
>-	/* c->x86_power is 8000_0007 edx. Bit 8 is constant TSC */
>-	if (c->x86_power & (1<<8))
>+	/*
>+	 * c->x86_power is 8000_0007 edx. Bit 8 is TSC runs at 
>constant rate
>+	 * with P/T states and does not stop in deep C-states
>+	 */
>+	if (c->x86_power & (1 << 8)) {
> 		set_cpu_cap(c, X86_FEATURE_CONSTANT_TSC);
>+		set_cpu_cap(c, X86_FEATURE_ALWAYSRUNS_TSC);
>+	}
> 
> #ifdef CONFIG_X86_64
> 	set_cpu_cap(c, X86_FEATURE_SYSCALL32);
>Index: tip/arch/x86/kernel/cpu/intel.c
>===================================================================
>--- tip.orig/arch/x86/kernel/cpu/intel.c	2008-11-25 
>13:36:30.000000000 -0800
>+++ tip/arch/x86/kernel/cpu/intel.c	2008-11-25 
>13:46:06.000000000 -0800
>@@ -41,6 +41,16 @@ static void __cpuinit early_init_intel(s
> 	if (c->x86 == 15 && c->x86_cache_alignment == 64)
> 		c->x86_cache_alignment = 128;
> #endif
>+
>+	/*
>+	 * c->x86_power is 8000_0007 edx. Bit 8 is TSC runs at 
>constant rate
>+	 * with P/T states and does not stop in deep C-states
>+	 */
>+	if (c->x86_power & (1 << 8)) {
>+		set_cpu_cap(c, X86_FEATURE_CONSTANT_TSC);
>+		set_cpu_cap(c, X86_FEATURE_ALWAYSRUNS_TSC);
>+	}
>+
> }
> 
> #ifdef CONFIG_X86_32
>Index: tip/drivers/acpi/processor_idle.c
>===================================================================
>--- tip.orig/drivers/acpi/processor_idle.c	2008-11-25 
>13:36:30.000000000 -0800
>+++ tip/drivers/acpi/processor_idle.c	2008-11-25 
>13:46:06.000000000 -0800
>@@ -374,15 +374,15 @@ static int tsc_halts_in_c(int state)
> {
> 	switch (boot_cpu_data.x86_vendor) {
> 	case X86_VENDOR_AMD:
>+	case X86_VENDOR_INTEL:
> 		/*
> 		 * AMD Fam10h TSC will tick in all
> 		 * C/P/S0/S1 states when this bit is set.
> 		 */
>-		if (boot_cpu_has(X86_FEATURE_CONSTANT_TSC))
>+		if (boot_cpu_has(X86_FEATURE_ALWAYSRUNS_TSC))
> 			return 0;
>+
> 		/*FALL THROUGH*/
>-	case X86_VENDOR_INTEL:
>-		/* Several cases known where TSC halts in C2 too */
> 	default:
> 		return state > ACPI_STATE_C1;
> 	}
>Index: tip/arch/x86/include/asm/cpufeature.h
>===================================================================
>--- tip.orig/arch/x86/include/asm/cpufeature.h	2008-11-25 
>13:36:30.000000000 -0800
>+++ tip/arch/x86/include/asm/cpufeature.h	2008-11-25 
>13:47:09.000000000 -0800
>@@ -92,6 +92,7 @@
> #define X86_FEATURE_AMDC1E	(3*32+21) /* AMD C1E detected */
> #define X86_FEATURE_XTOPOLOGY	(3*32+22) /* cpu topology enum 
>extensions */
> #define X86_FEATURE_TSC_RELIABLE (3*32+23) /* TSC is known to 
>be reliable */
>+#define X86_FEATURE_ALWAYSRUNS_TSC (3*32+24) /* TSC does not 
>stop in C state */
> 
> /* Intel-defined CPU features, CPUID level 0x00000001 (ecx), word 4 */
> #define X86_FEATURE_XMM3	(4*32+ 0) /* "pni" SSE-3 */
>Index: tip/arch/x86/kernel/process.c
>===================================================================
>--- tip.orig/arch/x86/kernel/process.c	2008-11-25 
>13:36:30.000000000 -0800
>+++ tip/arch/x86/kernel/process.c	2008-11-25 
>13:46:06.000000000 -0800
>@@ -286,7 +286,7 @@ static void c1e_idle(void)
> 		rdmsr(MSR_K8_INT_PENDING_MSG, lo, hi);
> 		if (lo & K8_INTP_C1E_ACTIVE_MASK) {
> 			c1e_detected = 1;
>-			if (!boot_cpu_has(X86_FEATURE_CONSTANT_TSC))
>+			if (!boot_cpu_has(X86_FEATURE_ALWAYSRUNS_TSC))
> 				mark_tsc_unstable("TSC halt in 
>AMD C1E");
> 			printk(KERN_INFO "System has AMD C1E 
>enabled\n");
> 			set_cpu_cap(&boot_cpu_data, X86_FEATURE_AMDC1E);
>
>-- 
>
>