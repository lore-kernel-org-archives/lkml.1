Return-Path: <linux-kernel-owner+w=401wt.eu-S1756847AbYIIRla@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756847AbYIIRla (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 13:41:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755731AbYIIRlK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 13:41:10 -0400
Received: from py-out-1112.google.com ([64.233.166.176]:37842 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755279AbYIIRlI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 13:41:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=KRPlYMJEIwpqu297DBlALtost3ABqo8DL6guUKZCdISXZx83Cy/vEZnv4eiyTUmoRc
         UHrjjDPGyvnEiwPwa3OYIX3vlx6xz8ppTz5f/5rrfRj1NZeoDAhThtedj/yl1RMPyv2+
         ZFzuucqaJcoYEHmEUZ2IGvXpl5cql2+RLlY9w=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 1/3] x86: make intel.c has 64bit support code
Date: Tue,  9 Sep 2008 10:40:28 -0700
Message-Id: <1220982030-10424-1-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
---
 arch/x86/kernel/cpu/intel.c |  119 ++++++++++++++++++++++++++++++-------------
 1 files changed, 83 insertions(+), 36 deletions(-)

diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index a669895..365a008 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -15,6 +15,11 @@
 #include <asm/ds.h>
 #include <asm/bugs.h>
 
+#ifdef CONFIG_X86_64
+#include <asm/topology.h>
+#include <asm/numa_64.h>
+#endif
+
 #include "cpu.h"
 
 #ifdef CONFIG_X86_LOCAL_APIC
@@ -25,14 +30,20 @@
 
 static void __cpuinit early_init_intel(struct cpuinfo_x86 *c)
 {
-	/* Netburst reports 64 bytes clflush size, but does IO in 128 bytes */
-	if (c->x86 == 15 && c->x86_cache_alignment == 64)
-		c->x86_cache_alignment = 128;
 	if ((c->x86 == 0xf && c->x86_model >= 0x03) ||
 		(c->x86 == 0x6 && c->x86_model >= 0x0e))
 		set_cpu_cap(c, X86_FEATURE_CONSTANT_TSC);
+
+#ifdef CONFIG_X86_64
+	set_cpu_cap(c, X86_FEATURE_SYSENTER32);
+#else
+	/* Netburst reports 64 bytes clflush size, but does IO in 128 bytes */
+	if (c->x86 == 15 && c->x86_cache_alignment == 64)
+		c->x86_cache_alignment = 128;
+#endif
 }
 
+#ifdef CONFIG_X86_32
 /*
  *	Early probe support logic for ppro memory erratum #50
  *
@@ -73,6 +84,40 @@ static void __cpuinit Intel_errata_workarounds(struct cpuinfo_x86 *c)
 }
 
 
+
+#ifdef CONFIG_X86_F00F_BUG
+static void __cpuinit trap_init_f00f_bug(void)
+{
+	__set_fixmap(FIX_F00F_IDT, __pa(&idt_table), PAGE_KERNEL_RO);
+
+	/*
+	 * Update the IDT descriptor and reload the IDT so that
+	 * it uses the read-only mapped virtual address.
+	 */
+	idt_descr.address = fix_to_virt(FIX_F00F_IDT);
+	load_idt(&idt_descr);
+}
+#endif
+#endif
+
+static void __cpuinit srat_detect_node(void)
+{
+#if defined(CONFIG_NUMA) && defined(CONFIG_X86_64)
+	unsigned node;
+	int cpu = smp_processor_id();
+	int apicid = hard_smp_processor_id();
+
+	/* Don't do the funky fallback heuristics the AMD version employs
+	   for now. */
+	node = apicid_to_node[apicid];
+	if (node == NUMA_NO_NODE || !node_online(node))
+		node = first_node(node_online_map);
+	numa_set_node(cpu, node);
+
+	printk(KERN_INFO "CPU %d/%x -> Node %d\n", cpu, apicid, node);
+#endif
+}
+
 /*
  * find out the number of processor cores on the die
  */
@@ -91,20 +136,6 @@ static int __cpuinit intel_num_cpu_cores(struct cpuinfo_x86 *c)
 		return 1;
 }
 
-#ifdef CONFIG_X86_F00F_BUG
-static void __cpuinit trap_init_f00f_bug(void)
-{
-	__set_fixmap(FIX_F00F_IDT, __pa(&idt_table), PAGE_KERNEL_RO);
-
-	/*
-	 * Update the IDT descriptor and reload the IDT so that
-	 * it uses the read-only mapped virtual address.
-	 */
-	idt_descr.address = fix_to_virt(FIX_F00F_IDT);
-	load_idt(&idt_descr);
-}
-#endif
-
 static void __cpuinit init_intel(struct cpuinfo_x86 *c)
 {
 	unsigned int l2 = 0;
@@ -139,6 +170,7 @@ static void __cpuinit init_intel(struct cpuinfo_x86 *c)
 			set_cpu_cap(c, X86_FEATURE_ARCH_PERFMON);
 	}
 
+#ifdef CONFIG_X86_32
 	/* SEP CPUID bug: Pentium Pro reports SEP but doesn't have it until model 3 mask 3 */
 	if ((c->x86<<8 | c->x86_model<<4 | c->x86_mask) < 0x633)
 		clear_cpu_cap(c, X86_FEATURE_SEP);
@@ -176,18 +208,6 @@ static void __cpuinit init_intel(struct cpuinfo_x86 *c)
 	if (p)
 		strcpy(c->x86_model_id, p);
 
-	detect_extended_topology(c);
-
-	if (!cpu_has(c, X86_FEATURE_XTOPOLOGY)) {
-		/*
-		 * let's use the legacy cpuid vector 0x1 and 0x4 for topology
-		 * detection.
-		 */
-		c->x86_max_cores = intel_num_cpu_cores(c);
-		detect_ht(c);
-	}
-
-	/* Work around errata */
 	Intel_errata_workarounds(c);
 
 #ifdef CONFIG_X86_INTEL_USERCOPY
@@ -208,12 +228,10 @@ static void __cpuinit init_intel(struct cpuinfo_x86 *c)
 	}
 #endif
 
+#endif
+
 	if (cpu_has_xmm2)
 		set_cpu_cap(c, X86_FEATURE_LFENCE_RDTSC);
-	if (c->x86 == 15)
-		set_cpu_cap(c, X86_FEATURE_P4);
-	if (c->x86 == 6)
-		set_cpu_cap(c, X86_FEATURE_P3);
 	if (cpu_has_ds) {
 		unsigned int l1;
 		rdmsr(MSR_IA32_MISC_ENABLE, l1, l2);
@@ -224,6 +242,17 @@ static void __cpuinit init_intel(struct cpuinfo_x86 *c)
 		ds_init_intel(c);
 	}
 
+#ifdef CONFIG_X86_64
+	if (c->x86 == 15)
+		c->x86_cache_alignment = c->x86_clflush_size * 2;
+	if (c->x86 == 6)
+		set_cpu_cap(c, X86_FEATURE_REP_GOOD);
+#else
+	if (c->x86 == 15)
+		set_cpu_cap(c, X86_FEATURE_P4);
+	if (c->x86 == 6)
+		set_cpu_cap(c, X86_FEATURE_P3);
+
 	if (cpu_has_bts)
 		ptrace_bts_init_intel(c);
 
@@ -240,8 +269,25 @@ static void __cpuinit init_intel(struct cpuinfo_x86 *c)
 #ifdef CONFIG_X86_NUMAQ
 	numaq_tsc_disable();
 #endif
+#endif
+
+	detect_extended_topology(c);
+	if (!cpu_has(c, X86_FEATURE_XTOPOLOGY)) {
+		/*
+		 * let's use the legacy cpuid vector 0x1 and 0x4 for topology
+		 * detection.
+		 */
+		c->x86_max_cores = intel_num_cpu_cores(c);
+#ifdef CONFIG_X86_32
+		detect_ht(c);
+#endif
+	}
+
+	/* Work around errata */
+	srat_detect_node();
 }
 
+#ifdef CONFIG_X86_32
 static unsigned int __cpuinit intel_size_cache(struct cpuinfo_x86 *c, unsigned int size)
 {
 	/*
@@ -254,10 +300,12 @@ static unsigned int __cpuinit intel_size_cache(struct cpuinfo_x86 *c, unsigned i
 		size = 256;
 	return size;
 }
+#endif
 
 static struct cpu_dev intel_cpu_dev __cpuinitdata = {
 	.c_vendor	= "Intel",
 	.c_ident	= { "GenuineIntel" },
+#ifdef CONFIG_X86_32
 	.c_models = {
 		{ .vendor = X86_VENDOR_INTEL, .family = 4, .model_names =
 		  {
@@ -307,13 +355,12 @@ static struct cpu_dev intel_cpu_dev __cpuinitdata = {
 		  }
 		},
 	},
+	.c_size_cache	= intel_size_cache,
+#endif
 	.c_early_init   = early_init_intel,
 	.c_init		= init_intel,
-	.c_size_cache	= intel_size_cache,
 	.c_x86_vendor	= X86_VENDOR_INTEL,
 };
 
 cpu_dev_register(intel_cpu_dev);
 
-/* arch_initcall(intel_cpu_init); */
-
-- 
1.5.4.5

