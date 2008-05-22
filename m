Return-Path: <linux-kernel-owner+w=401wt.eu-S1758326AbYEVUcG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758326AbYEVUcG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 16:32:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758621AbYEVUbi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 16:31:38 -0400
Received: from mx1.redhat.com ([66.187.233.31]:54258 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755027AbYEVUbg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 16:31:36 -0400
Date: Thu, 22 May 2008 15:44:10 -0400
Message-Id: <200805221944.m4MJiA9g029838@gelk.kernelslacker.org>
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       hpa@zytor.com
Subject: [X86] Move the 64-bit Intel specific parts out of setup_64.c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Create a separate intel_64.c file in the cpu/ dir for
the useful parts to live in.

Signed-off-by: Dave Jones <davej@redhat.com>
---
 arch/x86/kernel/cpu/Makefile   |    1 +
 arch/x86/kernel/cpu/intel_64.c |   96 ++++++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/setup_64.c     |   93 +-------------------------------------
 3 files changed, 99 insertions(+), 91 deletions(-)
 create mode 100644 arch/x86/kernel/cpu/intel_64.c

diff --git a/arch/x86/kernel/cpu/Makefile b/arch/x86/kernel/cpu/Makefile
index ef065c1..b7a1192 100644
--- a/arch/x86/kernel/cpu/Makefile
+++ b/arch/x86/kernel/cpu/Makefile
@@ -12,6 +12,7 @@ obj-$(CONFIG_X86_32)	+= cyrix.o
 obj-$(CONFIG_X86_32)	+= centaur.o
 obj-$(CONFIG_X86_32)	+= transmeta.o
 obj-$(CONFIG_X86_32)	+= intel.o
+obj-$(CONFIG_X86_64)	+= intel_64.o
 obj-$(CONFIG_X86_32)	+= umc.o
 
 obj-$(CONFIG_X86_MCE)	+= mcheck/
diff --git a/arch/x86/kernel/cpu/intel_64.c b/arch/x86/kernel/cpu/intel_64.c
new file mode 100644
index 0000000..9b7c5f1
--- /dev/null
+++ b/arch/x86/kernel/cpu/intel_64.c
@@ -0,0 +1,96 @@
+#include <linux/init.h>
+#include <linux/smp.h>
+#include <asm/processor.h>
+#include <asm/ptrace.h>
+#include <asm/topology.h>
+#include <asm/numa_64.h>
+
+void __cpuinit early_init_intel(struct cpuinfo_x86 *c)
+{
+	if ((c->x86 == 0xf && c->x86_model >= 0x03) ||
+	    (c->x86 == 0x6 && c->x86_model >= 0x0e))
+		set_cpu_cap(c, X86_FEATURE_CONSTANT_TSC);
+}
+
+/*
+ * find out the number of processor cores on the die
+ */
+static int __cpuinit intel_num_cpu_cores(struct cpuinfo_x86 *c)
+{
+	unsigned int eax, t;
+
+	if (c->cpuid_level < 4)
+		return 1;
+
+	cpuid_count(4, 0, &eax, &t, &t, &t);
+
+	if (eax & 0x1f)
+		return ((eax >> 26) + 1);
+	else
+		return 1;
+}
+
+static void __cpuinit srat_detect_node(void)
+{
+#ifdef CONFIG_NUMA
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
+void __cpuinit init_intel(struct cpuinfo_x86 *c)
+{
+	/* Cache sizes */
+	unsigned n;
+
+	init_intel_cacheinfo(c);
+	if (c->cpuid_level > 9) {
+		unsigned eax = cpuid_eax(10);
+		/* Check for version and the number of counters */
+		if ((eax & 0xff) && (((eax>>8) & 0xff) > 1))
+			set_cpu_cap(c, X86_FEATURE_ARCH_PERFMON);
+	}
+
+	if (cpu_has_ds) {
+		unsigned int l1, l2;
+		rdmsr(MSR_IA32_MISC_ENABLE, l1, l2);
+		if (!(l1 & (1<<11)))
+			set_cpu_cap(c, X86_FEATURE_BTS);
+		if (!(l1 & (1<<12)))
+			set_cpu_cap(c, X86_FEATURE_PEBS);
+		ds_init_intel(c);
+	}
+	if (cpu_has_bts)
+		ptrace_bts_init_intel(c);
+
+	n = c->extended_cpuid_level;
+	if (n >= 0x80000008) {
+		unsigned eax = cpuid_eax(0x80000008);
+		c->x86_virt_bits = (eax >> 8) & 0xff;
+		c->x86_phys_bits = eax & 0xff;
+		/* CPUID workaround for Intel 0F34 CPU */
+		if (c->x86_vendor == X86_VENDOR_INTEL &&
+		    c->x86 == 0xF && c->x86_model == 0x3 &&
+		    c->x86_mask == 0x4)
+			c->x86_phys_bits = 36;
+	}
+
+	if (c->x86 == 15)
+		c->x86_cache_alignment = c->x86_clflush_size * 2;
+	if (c->x86 == 6)
+		set_cpu_cap(c, X86_FEATURE_REP_GOOD);
+	set_cpu_cap(c, X86_FEATURE_LFENCE_RDTSC);
+	c->x86_max_cores = intel_num_cpu_cores(c);
+
+	srat_detect_node();
+}
diff --git a/arch/x86/kernel/setup_64.c b/arch/x86/kernel/setup_64.c
index dbfbdb8..b3d25d6 100644
--- a/arch/x86/kernel/setup_64.c
+++ b/arch/x86/kernel/setup_64.c
@@ -614,97 +614,6 @@ out:
 #endif
 }
 
-/*
- * find out the number of processor cores on the die
- */
-static int __cpuinit intel_num_cpu_cores(struct cpuinfo_x86 *c)
-{
-	unsigned int eax, t;
-
-	if (c->cpuid_level < 4)
-		return 1;
-
-	cpuid_count(4, 0, &eax, &t, &t, &t);
-
-	if (eax & 0x1f)
-		return ((eax >> 26) + 1);
-	else
-		return 1;
-}
-
-static void __cpuinit srat_detect_node(void)
-{
-#ifdef CONFIG_NUMA
-	unsigned node;
-	int cpu = smp_processor_id();
-	int apicid = hard_smp_processor_id();
-
-	/* Don't do the funky fallback heuristics the AMD version employs
-	   for now. */
-	node = apicid_to_node[apicid];
-	if (node == NUMA_NO_NODE || !node_online(node))
-		node = first_node(node_online_map);
-	numa_set_node(cpu, node);
-
-	printk(KERN_INFO "CPU %d/%x -> Node %d\n", cpu, apicid, node);
-#endif
-}
-
-static void __cpuinit early_init_intel(struct cpuinfo_x86 *c)
-{
-	if ((c->x86 == 0xf && c->x86_model >= 0x03) ||
-	    (c->x86 == 0x6 && c->x86_model >= 0x0e))
-		set_cpu_cap(c, X86_FEATURE_CONSTANT_TSC);
-}
-
-static void __cpuinit init_intel(struct cpuinfo_x86 *c)
-{
-	/* Cache sizes */
-	unsigned n;
-
-	init_intel_cacheinfo(c);
-	if (c->cpuid_level > 9) {
-		unsigned eax = cpuid_eax(10);
-		/* Check for version and the number of counters */
-		if ((eax & 0xff) && (((eax>>8) & 0xff) > 1))
-			set_cpu_cap(c, X86_FEATURE_ARCH_PERFMON);
-	}
-
-	if (cpu_has_ds) {
-		unsigned int l1, l2;
-		rdmsr(MSR_IA32_MISC_ENABLE, l1, l2);
-		if (!(l1 & (1<<11)))
-			set_cpu_cap(c, X86_FEATURE_BTS);
-		if (!(l1 & (1<<12)))
-			set_cpu_cap(c, X86_FEATURE_PEBS);
-		ds_init_intel(c);
-	}
-
-
-	if (cpu_has_bts)
-		ptrace_bts_init_intel(c);
-
-	n = c->extended_cpuid_level;
-	if (n >= 0x80000008) {
-		unsigned eax = cpuid_eax(0x80000008);
-		c->x86_virt_bits = (eax >> 8) & 0xff;
-		c->x86_phys_bits = eax & 0xff;
-		/* CPUID workaround for Intel 0F34 CPU */
-		if (c->x86_vendor == X86_VENDOR_INTEL &&
-		    c->x86 == 0xF && c->x86_model == 0x3 &&
-		    c->x86_mask == 0x4)
-			c->x86_phys_bits = 36;
-	}
-
-	if (c->x86 == 15)
-		c->x86_cache_alignment = c->x86_clflush_size * 2;
-	if (c->x86 == 6)
-		set_cpu_cap(c, X86_FEATURE_REP_GOOD);
-	set_cpu_cap(c, X86_FEATURE_LFENCE_RDTSC);
-	c->x86_max_cores = intel_num_cpu_cores(c);
-
-	srat_detect_node();
-}
 
 static void __cpuinit early_init_centaur(struct cpuinfo_x86 *c)
 {
@@ -749,6 +658,8 @@ static void __cpuinit get_cpu_vendor(struct cpuinfo_x86 *c)
 // FIXME: Needs to use cpu_vendor_dev_register
 extern void __cpuinit early_init_amd(struct cpuinfo_x86 *c);
 extern void __cpuinit init_amd(struct cpuinfo_x86 *c);
+extern void __cpuinit early_init_intel(struct cpuinfo_x86 *c);
+extern void __cpuinit init_intel(struct cpuinfo_x86 *c);
 
 /* Do some early cpuid on the boot CPU to get some parameter that are
    needed before check_bugs. Everything advanced is in identify_cpu
-- 
1.5.5.1

