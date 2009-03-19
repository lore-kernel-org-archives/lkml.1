Return-Path: <linux-kernel-owner+w=401wt.eu-S1756987AbZCSSZ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756987AbZCSSZ3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 14:25:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754508AbZCSSZR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 14:25:17 -0400
Received: from vpnflf.ccur.com ([12.192.68.2]:36609 "EHLO gamx.iccur.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753542AbZCSSZQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 14:25:16 -0400
X-Greylist: delayed 3061 seconds by postgrey-1.27 at vger.kernel.org; Thu, 19 Mar 2009 14:25:16 EDT
Date: Thu, 19 Mar 2009 13:28:58 -0400
From: Joe Korty <joe.korty@ccur.com>
To: stable@kernel.org
Cc: "H. Peter Anvin" <hpa@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 2.6.28.7-stable] Fix misreporting of #cores as #hyperthreads for Q9550
Message-ID: <20090319172858.GA2629@tsunami.ccur.com>
Reply-To: Joe Korty <joe.korty@ccur.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix misreporting of #cores for the Intel Quad Core Q9550.

[ for 2.6.28-stable ]

For the Q9550, in x86_64 mode, /proc/cpuinfo mistakenly
thinks the #cores present is the #hyperthreads present.
i386 mode was not examined but is assumed to have the
same problem.

A backport of the following three 2.6.29-rc1 patches
fixes the problem:

  [PATCH] x86: unmask CPUID levels on Intel CPUs
  [PATCH] x86: unmask CPUID levels on Intel CPUs, fix
  [PATCH] x86: add MSR_IA32_MISC_ENABLE bits to <asm/msr-index.h>

>From the first patch: "If the CPUID limit bit in
MSR_IA32_MISC_ENABLE is set, clear it to make all CPUID
information available.  This is required for some features
to work, in particular XSAVE."

Originally-Developed-by: H. Peter Anvin <hpa@linux.intel.com>
Backported-by: Joe Korty <joe.korty@ccur.com>
Signed-off-by: Joe Korty <joe.korty@ccur.com>

Index: 2.6.28.7/arch/x86/include/asm/msr-index.h
===================================================================
--- 2.6.28.7.orig/arch/x86/include/asm/msr-index.h	2008-12-24 18:26:37.000000000 -0500
+++ 2.6.28.7/arch/x86/include/asm/msr-index.h	2009-03-19 11:16:08.000000000 -0400
@@ -200,6 +200,35 @@
 #define MSR_IA32_THERM_STATUS		0x0000019c
 #define MSR_IA32_MISC_ENABLE		0x000001a0
 
+/* MISC_ENABLE bits: architectural */
+#define MSR_IA32_MISC_ENABLE_FAST_STRING	(1ULL << 0)
+#define MSR_IA32_MISC_ENABLE_TCC		(1ULL << 1)
+#define MSR_IA32_MISC_ENABLE_EMON		(1ULL << 7)
+#define MSR_IA32_MISC_ENABLE_BTS_UNAVAIL	(1ULL << 11)
+#define MSR_IA32_MISC_ENABLE_PEBS_UNAVAIL	(1ULL << 12)
+#define MSR_IA32_MISC_ENABLE_ENHANCED_SPEEDSTEP	(1ULL << 16)
+#define MSR_IA32_MISC_ENABLE_MWAIT		(1ULL << 18)
+#define MSR_IA32_MISC_ENABLE_LIMIT_CPUID	(1ULL << 22)
+#define MSR_IA32_MISC_ENABLE_XTPR_DISABLE	(1ULL << 23)
+#define MSR_IA32_MISC_ENABLE_XD_DISABLE		(1ULL << 34)
+
+/* MISC_ENABLE bits: model-specific, meaning may vary from core to core */
+#define MSR_IA32_MISC_ENABLE_X87_COMPAT		(1ULL << 2)
+#define MSR_IA32_MISC_ENABLE_TM1		(1ULL << 3)
+#define MSR_IA32_MISC_ENABLE_SPLIT_LOCK_DISABLE	(1ULL << 4)
+#define MSR_IA32_MISC_ENABLE_L3CACHE_DISABLE	(1ULL << 6)
+#define MSR_IA32_MISC_ENABLE_SUPPRESS_LOCK	(1ULL << 8)
+#define MSR_IA32_MISC_ENABLE_PREFETCH_DISABLE	(1ULL << 9)
+#define MSR_IA32_MISC_ENABLE_FERR		(1ULL << 10)
+#define MSR_IA32_MISC_ENABLE_FERR_MULTIPLEX	(1ULL << 10)
+#define MSR_IA32_MISC_ENABLE_TM2		(1ULL << 13)
+#define MSR_IA32_MISC_ENABLE_ADJ_PREF_DISABLE	(1ULL << 19)
+#define MSR_IA32_MISC_ENABLE_SPEEDSTEP_LOCK	(1ULL << 20)
+#define MSR_IA32_MISC_ENABLE_L1D_CONTEXT	(1ULL << 24)
+#define MSR_IA32_MISC_ENABLE_DCU_PREF_DISABLE	(1ULL << 37)
+#define MSR_IA32_MISC_ENABLE_TURBO_DISABLE	(1ULL << 38)
+#define MSR_IA32_MISC_ENABLE_IP_PREF_DISABLE	(1ULL << 39)
+
 /* Intel Model 6 */
 #define MSR_P6_EVNTSEL0			0x00000186
 #define MSR_P6_EVNTSEL1			0x00000187
Index: 2.6.28.7/arch/x86/kernel/cpu/intel.c
===================================================================
--- 2.6.28.7.orig/arch/x86/kernel/cpu/intel.c	2009-03-16 11:39:55.000000000 -0400
+++ 2.6.28.7/arch/x86/kernel/cpu/intel.c	2009-03-19 11:16:08.000000000 -0400
@@ -30,6 +30,19 @@
 
 static void __cpuinit early_init_intel(struct cpuinfo_x86 *c)
 {
+	/* Unmask CPUID levels if masked: */
+	if (c->x86 == 6 && c->x86_model >= 15) {
+		u64 misc_enable;
+
+		rdmsrl(MSR_IA32_MISC_ENABLE, misc_enable);
+
+		if (misc_enable & MSR_IA32_MISC_ENABLE_LIMIT_CPUID) {
+			misc_enable &= ~MSR_IA32_MISC_ENABLE_LIMIT_CPUID;
+			wrmsrl(MSR_IA32_MISC_ENABLE, misc_enable);
+			c->cpuid_level = cpuid_eax(0);
+		}
+	}
+
 	if ((c->x86 == 0xf && c->x86_model >= 0x03) ||
 		(c->x86 == 0x6 && c->x86_model >= 0x0e))
 		set_cpu_cap(c, X86_FEATURE_CONSTANT_TSC);
