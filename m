Return-Path: <linux-kernel-owner+w=401wt.eu-S1758664AbYHZSkt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758664AbYHZSkt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 14:40:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756803AbYHZSkk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 14:40:40 -0400
Received: from mga03.intel.com ([143.182.124.21]:14801 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757086AbYHZSkj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 14:40:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,272,1217833200"; 
   d="scan'208";a="37785194"
Message-Id: <20080826183909.887903000@linux-os.sc.intel.com>
User-Agent: quilt/0.46-1
Date: Tue, 26 Aug 2008 11:38:06 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org, yhlu.kernel@gmail.com,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [patch 1/2] x2apic: use cpuid vector 0xb when available for detecting cpu topology - v2
Content-Disposition: inline; filename=cpuid_vector_b.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cpuid leaf 0xb provides extended topology enumeration. This interface provides
the 32-bit x2APIC id of the logical processor and it also provides a new
mechanism to detect SMT and core siblings (which provides increased
addressability).

v2: Fix for !SMP build

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---

Index: tip/arch/x86/kernel/cpu/addon_cpuid_features.c
===================================================================
--- tip.orig/arch/x86/kernel/cpu/addon_cpuid_features.c	2008-08-25 11:25:43.000000000 -0700
+++ tip/arch/x86/kernel/cpu/addon_cpuid_features.c	2008-08-25 12:06:46.000000000 -0700
@@ -7,6 +7,8 @@
 #include <asm/pat.h>
 #include <asm/processor.h>
 
+#include <mach_apic.h>
+
 struct cpuid_bit {
 	u16 feature;
 	u8 reg;
@@ -48,6 +50,92 @@
 	}
 }
 
+/* leaf 0xb SMT level */
+#define SMT_LEVEL	0
+
+/* leaf 0xb sub-leaf types */
+#define INVALID_TYPE	0
+#define SMT_TYPE	1
+#define CORE_TYPE	2
+
+#define LEAFB_SUBTYPE(ecx)		(((ecx) >> 8) & 0xff)
+#define BITS_SHIFT_NEXT_LEVEL(eax)	((eax) & 0x1f)
+#define LEVEL_MAX_SIBLINGS(ebx)		((ebx) & 0xffff)
+
+/*
+ * Check for extended topology enumeration cpuid leaf 0xb and if it
+ * exists, use it for populating initial_apicid and cpu topology
+ * detection.
+ */
+void __cpuinit detect_extended_topology(struct cpuinfo_x86 *c)
+{
+#ifdef CONFIG_SMP
+	unsigned int eax, ebx, ecx, edx, sub_index;
+	unsigned int ht_mask_width, core_plus_mask_width;
+	unsigned int core_select_mask, core_level_siblings;
+
+	if (c->cpuid_level < 0xb)
+		return;
+
+	cpuid_count(0xb, SMT_LEVEL, &eax, &ebx, &ecx, &edx);
+
+	/*
+	 * check if the cpuid leaf 0xb is actually implemented.
+	 */
+	if (ebx == 0 || (LEAFB_SUBTYPE(ecx) != SMT_TYPE))
+		return;
+
+	set_cpu_cap(c, X86_FEATURE_XTOPOLOGY);
+
+	/*
+	 * initial apic id, which also represents 32-bit extended x2apic id.
+	 */
+	c->initial_apicid = edx;
+
+	/*
+	 * Populate HT related information from sub-leaf level 0.
+	 */
+	core_level_siblings = smp_num_siblings = LEVEL_MAX_SIBLINGS(ebx);
+	core_plus_mask_width = ht_mask_width = BITS_SHIFT_NEXT_LEVEL(eax);
+
+	sub_index = 1;
+	do {
+		cpuid_count(0xb, sub_index, &eax, &ebx, &ecx, &edx);
+
+		/*
+		 * Check for the Core type in the implemented sub leaves.
+		 */
+		if (LEAFB_SUBTYPE(ecx) == CORE_TYPE) {
+			core_level_siblings = LEVEL_MAX_SIBLINGS(ebx);
+			core_plus_mask_width = BITS_SHIFT_NEXT_LEVEL(eax);
+			break;
+		}
+
+		sub_index++;
+	} while (LEAFB_SUBTYPE(ecx) != INVALID_TYPE);
+
+	core_select_mask = (~(-1 << core_plus_mask_width)) >> ht_mask_width;
+
+#ifdef CONFIG_X86_32
+	c->cpu_core_id = phys_pkg_id(c->initial_apicid, ht_mask_width)
+						 & core_select_mask;
+	c->phys_proc_id = phys_pkg_id(c->initial_apicid, core_plus_mask_width);
+#else
+	c->cpu_core_id = phys_pkg_id(ht_mask_width) & core_select_mask;
+	c->phys_proc_id = phys_pkg_id(core_plus_mask_width);
+#endif
+	c->x86_max_cores = (core_level_siblings / smp_num_siblings);
+
+
+	printk(KERN_INFO  "CPU: Physical Processor ID: %d\n",
+	       c->phys_proc_id);
+	if (c->x86_max_cores > 1)
+		printk(KERN_INFO  "CPU: Processor Core ID: %d\n",
+		       c->cpu_core_id);
+	return;
+#endif
+}
+
 #ifdef CONFIG_X86_PAT
 void __cpuinit validate_pat_support(struct cpuinfo_x86 *c)
 {
Index: tip/arch/x86/kernel/cpu/common_64.c
===================================================================
--- tip.orig/arch/x86/kernel/cpu/common_64.c	2008-08-25 11:25:43.000000000 -0700
+++ tip/arch/x86/kernel/cpu/common_64.c	2008-08-25 11:25:55.000000000 -0700
@@ -128,6 +128,9 @@
 	u32 eax, ebx, ecx, edx;
 	int index_msb, core_bits;
 
+	if (cpu_has(c, X86_FEATURE_XTOPOLOGY))
+		return;
+
 	cpuid(1, &eax, &ebx, &ecx, &edx);
 
 
Index: tip/arch/x86/kernel/cpu/intel_64.c
===================================================================
--- tip.orig/arch/x86/kernel/cpu/intel_64.c	2008-08-25 11:25:43.000000000 -0700
+++ tip/arch/x86/kernel/cpu/intel_64.c	2008-08-25 11:25:55.000000000 -0700
@@ -80,7 +80,10 @@
 	if (c->x86 == 6)
 		set_cpu_cap(c, X86_FEATURE_REP_GOOD);
 	set_cpu_cap(c, X86_FEATURE_LFENCE_RDTSC);
-	c->x86_max_cores = intel_num_cpu_cores(c);
+
+	detect_extended_topology(c);
+	if (!cpu_has(c, X86_FEATURE_XTOPOLOGY))
+		c->x86_max_cores = intel_num_cpu_cores(c);
 
 	srat_detect_node();
 }
Index: tip/include/asm-x86/cpufeature.h
===================================================================
--- tip.orig/include/asm-x86/cpufeature.h	2008-08-25 11:25:43.000000000 -0700
+++ tip/include/asm-x86/cpufeature.h	2008-08-25 11:25:55.000000000 -0700
@@ -81,6 +81,7 @@
 #define X86_FEATURE_LFENCE_RDTSC (3*32+18) /* Lfence synchronizes RDTSC */
 #define X86_FEATURE_11AP	(3*32+19) /* Bad local APIC aka 11AP */
 #define X86_FEATURE_NOPL	(3*32+20) /* The NOPL (0F 1F) instructions */
+#define X86_FEATURE_XTOPOLOGY	(3*32+21) /* cpu topology enum extensions */
 
 /* Intel-defined CPU features, CPUID level 0x00000001 (ecx), word 4 */
 #define X86_FEATURE_XMM3	(4*32+ 0) /* Streaming SIMD Extensions-3 */
Index: tip/include/asm-x86/processor.h
===================================================================
--- tip.orig/include/asm-x86/processor.h	2008-08-25 11:25:43.000000000 -0700
+++ tip/include/asm-x86/processor.h	2008-08-25 11:25:55.000000000 -0700
@@ -166,6 +166,7 @@
 extern unsigned int init_intel_cacheinfo(struct cpuinfo_x86 *c);
 extern unsigned short num_cache_leaves;
 
+extern void detect_extended_topology(struct cpuinfo_x86 *c);
 #if defined(CONFIG_X86_HT) || defined(CONFIG_X86_64)
 extern void detect_ht(struct cpuinfo_x86 *c);
 #else
Index: tip/arch/x86/kernel/cpu/intel.c
===================================================================
--- tip.orig/arch/x86/kernel/cpu/intel.c	2008-08-25 11:25:43.000000000 -0700
+++ tip/arch/x86/kernel/cpu/intel.c	2008-08-25 11:25:55.000000000 -0700
@@ -176,9 +176,16 @@
 	if (p)
 		strcpy(c->x86_model_id, p);
 
-	c->x86_max_cores = num_cpu_cores(c);
+	detect_extended_topology(c);
 
-	detect_ht(c);
+	if (!cpu_has(c, X86_FEATURE_XTOPOLOGY)) {
+		/*
+		 * let's use the legacy cpuid vector 0x1 and 0x4 for topology
+		 * detection.
+		 */
+		c->x86_max_cores = num_cpu_cores(c);
+		detect_ht(c);
+	}
 
 	/* Work around errata */
 	Intel_errata_workarounds(c);

-- 

