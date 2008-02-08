Return-Path: <linux-kernel-owner+w=401wt.eu-S1759666AbYBHWsG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759666AbYBHWsG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 17:48:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757427AbYBHWrt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 17:47:49 -0500
Received: from mail.free-electrons.com ([88.191.46.45]:3306 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765180AbYBHWrq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 17:47:46 -0500
From: Michael Opdenacker <michael-lists@free-electrons.com>
Organization: Free Electrons
To: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Anvin" <hpa@zytor.com>,
       Matt Mackall <mpm@selenic.com>
Subject: [PATCH] x86 (Linux Tiny): configure out support for some processors
Date: Fri, 8 Feb 2008 23:47:24 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: linux-kernel@vger.kernel.org, Linux-tiny@selenic.com
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802082347.25364.michael-lists@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch against x86/mm tries to revive an original patch
from Matt Mackall which didn't get merged at that time. It makes
it possible to disable support code for some processors. This can
be useful to support only the exact processor type used
in a given system.

I may have made wrong assumptions with the code handling
force_mwait. As force_mwait is only declared in
arch/x86/kernel/cpu/amd.c, which is only compiled
when CONFIG_X86_32 is set, I thought it was safe
to make the code depend on CONFIG_CPU_SUP_AMD,
but I could be wrong.

Your comments are more than welcome! To make the code
cleaner, I could use empty inline functions instead
of ifdef's, as suggested in Documentation/SubmittingPatches.

Thanks for your reviews! Michael.

Signed-off-by: Michael Opdenacker <michael@free-electrons.com>
---
 arch/x86/Kconfig.cpu         |   55 ++++++++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/cpu/Makefile |   28 ++++++++++----------
 arch/x86/kernel/cpu/common.c |   20 +++++++++++++++
 arch/x86/kernel/process_32.c |    7 ++++-
 arch/x86/kernel/process_64.c |    7 ++++-
 arch/x86/mm/init_32.c        |   12 ++++++++-
 6 files changed, 112 insertions(+), 17 deletions(-)

diff --git a/arch/x86/Kconfig.cpu b/arch/x86/Kconfig.cpu
index e09a6b7..5d9c9fb 100644
--- a/arch/x86/Kconfig.cpu
+++ b/arch/x86/Kconfig.cpu
@@ -396,3 +396,58 @@ config X86_MINIMUM_CPU_FAMILY
 config X86_DEBUGCTLMSR
 	def_bool y
 	depends on !(M586MMX || M586TSC || M586 || M486 || M386)
+
+menuconfig PROCESSOR_SELECT
+	default y
+	bool "Supported processor vendors" if EMBEDDED
+	help
+	  This lets you choose what x86 vendor support code your kernel
+	  will include.
+
+config CPU_SUP_INTEL
+	default y
+	bool "Support Intel processors" if PROCESSOR_SELECT
+	help
+	  This enables extended support for Intel processors
+
+config CPU_SUP_CYRIX
+	default y
+	bool "Support Cyrix processors" if PROCESSOR_SELECT
+	help
+	  This enables extended support for Cyrix processors
+
+config CPU_SUP_NSC
+	default y
+	bool "Support NSC processors" if PROCESSOR_SELECT
+	help
+	  This enables extended support for NSC processors
+
+config CPU_SUP_AMD
+	default y
+	bool "Support AMD processors" if PROCESSOR_SELECT
+	help
+	  This enables extended support for AMD processors
+
+config CPU_SUP_CENTAUR
+	default y
+	bool "Support Centaur processors" if PROCESSOR_SELECT
+	help
+	  This enables extended support for Centaur processors
+
+config CPU_SUP_TRANSMETA
+	default y
+	bool "Support Transmeta processors" if PROCESSOR_SELECT
+	help
+	  This enables extended support for Transmeta processors
+
+config CPU_SUP_NEXGEN
+	default y
+	bool "Support NexGen processors" if PROCESSOR_SELECT
+	help
+	  This enables extended support for NexGen processors
+
+config CPU_SUP_UMC
+	default y
+	bool "Support UMC processors" if PROCESSOR_SELECT
+	help
+	  This enables extended support for UMC processors
diff --git a/arch/x86/kernel/cpu/Makefile b/arch/x86/kernel/cpu/Makefile
index a0c4d7c..a01cb67 100644
--- a/arch/x86/kernel/cpu/Makefile
+++ b/arch/x86/kernel/cpu/Makefile
@@ -2,20 +2,20 @@
 # Makefile for x86-compatible CPU details and quirks
 #
 
-obj-y			:= intel_cacheinfo.o addon_cpuid_features.o
-obj-y			+= feature_names.o
+obj-y				:= intel_cacheinfo.o addon_cpuid_features.o
+obj-y				+= feature_names.o
 
-obj-$(CONFIG_X86_32)	+= common.o proc.o bugs.o
-obj-$(CONFIG_X86_32)	+= amd.o
-obj-$(CONFIG_X86_32)	+= cyrix.o
-obj-$(CONFIG_X86_32)	+= centaur.o
-obj-$(CONFIG_X86_32)	+= transmeta.o
-obj-$(CONFIG_X86_32)	+= intel.o
-obj-$(CONFIG_X86_32)	+= nexgen.o
-obj-$(CONFIG_X86_32)	+= umc.o
+obj-$(CONFIG_X86_32)		+= common.o proc.o bugs.o
+obj-$(CONFIG_CPU_SUP_AMD)	+= amd.o
+obj-$(CONFIG_CPU_SUP_CYRIX)	+= cyrix.o
+obj-$(CONFIG_CPU_SUP_CENTAUR)	+= centaur.o
+obj-$(CONFIG_CPU_SUP_TRANSMETA)	+= transmeta.o
+obj-$(CONFIG_CPU_SUP_INTEL)	+= intel.o
+obj-$(CONFIG_CPU_SUP_NEXGEN)	+= nexgen.o
+obj-$(CONFIG_CPU_SUP_UMC)	+= umc.o
 
-obj-$(CONFIG_X86_MCE)	+= mcheck/
-obj-$(CONFIG_MTRR)	+= mtrr/
-obj-$(CONFIG_CPU_FREQ)	+= cpufreq/
+obj-$(CONFIG_X86_MCE)		+= mcheck/
+obj-$(CONFIG_MTRR)		+= mtrr/
+obj-$(CONFIG_CPU_FREQ)		+= cpufreq/
 
-obj-$(CONFIG_X86_LOCAL_APIC) += perfctr-watchdog.o
+obj-$(CONFIG_X86_LOCAL_APIC)	+= perfctr-watchdog.o
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index f86a3c4..1ed756c 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -329,12 +329,16 @@ static void __init early_cpu_detect(void)
 	get_cpu_vendor(c, 1);
 
 	switch (c->x86_vendor) {
+#ifdef CONFIG_CPU_SUP_AMD
 	case X86_VENDOR_AMD:
 		early_init_amd(c);
 		break;
+#endif
+#ifdef CONFIG_CPU_SUP_INTEL
 	case X86_VENDOR_INTEL:
 		early_init_intel(c);
 		break;
+#endif
 	}
 
 	early_get_cap(c);
@@ -625,14 +629,30 @@ cpumask_t cpu_initialized __cpuinitdata = CPU_MASK_NONE;
  */
 void __init early_cpu_init(void)
 {
+#ifdef CONFIG_CPU_SUP_INTEL
 	intel_cpu_init();
+#endif
+#ifdef CONFIG_CPU_SUP_CYRIX
 	cyrix_init_cpu();
+#endif
+#ifdef CONFIG_CPU_SUP_NSC
 	nsc_init_cpu();
+#endif
+#ifdef CONFIG_CPU_SUP_AMD
 	amd_init_cpu();
+#endif
+#ifdef CONFIG_CPU_SUP_CENTAUR
 	centaur_init_cpu();
+#endif
+#ifdef CONFIG_CPU_SUP_TRANSMETA
 	transmeta_init_cpu();
+#endif
+#ifdef CONFIG_CPU_SUP_NEXGEN
 	nexgen_init_cpu();
+#endif
+#ifdef CONFIG_CPU_SUP_UMC
 	umc_init_cpu();
+#endif
 	early_cpu_detect();
 }
 
diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index dabdbef..8f9a123 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -287,8 +287,10 @@ static void mwait_idle(void)
 
 static int __cpuinit mwait_usable(const struct cpuinfo_x86 *c)
 {
+#ifdef CONFIG_CPU_SUP_AMD
 	if (force_mwait)
 		return 1;
+#endif
 	/* Any C1 states supported? */
 	return c->cpuid_level >= 5 && ((cpuid_edx(5) >> 4) & 0xf) > 0;
 }
@@ -323,8 +325,11 @@ static int __init idle_setup(char *str)
 	if (!strcmp(str, "poll")) {
 		printk("using polling idle threads.\n");
 		pm_idle = poll_idle;
-	} else if (!strcmp(str, "mwait"))
+	}
+#ifdef CONFIG_CPU_SUP_AMD
+	else if (!strcmp(str, "mwait"))
 		force_mwait = 1;
+#endif
 	else
 		return -1;
 
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index 137a861..88e93d8 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -283,8 +283,10 @@ static void mwait_idle(void)
 
 static int __cpuinit mwait_usable(const struct cpuinfo_x86 *c)
 {
+#ifdef CONFIG_CPU_SUP_AMD
 	if (force_mwait)
 		return 1;
+#endif
 	/* Any C1 states supported? */
 	return c->cpuid_level >= 5 && ((cpuid_edx(5) >> 4) & 0xf) > 0;
 }
@@ -319,8 +321,11 @@ static int __init idle_setup(char *str)
 	if (!strcmp(str, "poll")) {
 		printk("using polling idle threads.\n");
 		pm_idle = poll_idle;
-	} else if (!strcmp(str, "mwait"))
+	}
+#ifdef CONFIG_CPU_SUP_AMD
+	else if (!strcmp(str, "mwait"))
 		force_mwait = 1;
+#endif
 	else
 		return -1;
 
diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index 347a8cd..812bfa0 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -211,12 +211,14 @@ static void __init kernel_physical_mapping_init(pgd_t *pgd_base)
 	}
 }
 
+#ifdef CONFIG_CPU_SUP_INTEL
 static inline int page_kills_ppro(unsigned long pagenr)
 {
 	if (pagenr >= 0x70000 && pagenr <= 0x7003F)
 		return 1;
 	return 0;
 }
+#endif
 
 /*
  * devmem_is_allowed() checks to see if /dev/mem access to a certain address
@@ -287,7 +289,11 @@ static void __meminit free_new_highpage(struct page *page)
 
 void __init add_one_highpage_init(struct page *page, int pfn, int bad_ppro)
 {
-	if (page_is_ram(pfn) && !(bad_ppro && page_kills_ppro(pfn))) {
+	if (page_is_ram(pfn)
+#ifdef CONFIG_CPU_SUP_INTEL
+	    && !(bad_ppro && page_kills_ppro(pfn))
+#endif
+		) {
 		ClearPageReserved(page);
 		free_new_highpage(page);
 	} else
@@ -592,7 +598,11 @@ void __init mem_init(void)
 #ifdef CONFIG_FLATMEM
 	BUG_ON(!mem_map);
 #endif
+#ifdef CONFIG_CPU_SUP_INTEL
 	bad_ppro = ppro_with_ram_bug();
+#else
+	bad_ppro = 0;
+#endif
 
 #ifdef CONFIG_HIGHMEM
 	/* check that fixmap and pkmap do not overlap */
-- 
1.5.2.5


-- 
Michael Opdenacker, Free Electrons
Free Embedded Linux Training Materials
on http://free-electrons.com/training
(More than 1500 pages!)
