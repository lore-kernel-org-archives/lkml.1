Return-Path: <linux-kernel-owner+w=401wt.eu-S1759321AbZAMKk6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759321AbZAMKk6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 05:40:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756065AbZAMKjS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 05:39:18 -0500
Received: from hera.kernel.org ([140.211.167.34]:51126 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755751AbZAMKjR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 05:39:17 -0500
From: Tejun Heo <tj@kernel.org>
To: ebiederm@xmission.com, cl@linux-foundation.org, rusty@rustcorp.com.au,
       mingo@elte.hu, travis@sgi.com, linux-kernel@vger.kernel.org,
       hpa@zytor.com, akpm@linux-foundation.org, steiner@sgi.com,
       hugh@veritas.com
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 03/13] x86_64: Cleanup early setup_percpu references
Date: Tue, 13 Jan 2009 19:38:07 +0900
Message-Id: <1231843097-18003-4-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1231843097-18003-1-git-send-email-tj@kernel.org>
References: <1231843097-18003-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 13 Jan 2009 10:38:31 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Travis <travis@sgi.com>

From: Mike Travis <travis@sgi.com>

  * Ruggedize some calls in setup_percpu.c to prevent mishaps
    in early calls, particularly for non-critical functions.

  * Cleanup DEBUG_PER_CPU_MAPS usages and some comments.

Based on linux-2.6.tip/master with following patches applied:

	cpumask: Make cpumask_of_cpu_map generic
	cpumask: Put cpumask_of_cpu_map in the initdata section
	cpumask: Change cpumask_of_cpu_ptr to use new cpumask_of_cpu

Signed-off-by: Mike Travis <travis@sgi.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
---
 arch/x86/kernel/setup_percpu.c |   60 ++++++++++++++++++++++++++++------------
 1 files changed, 42 insertions(+), 18 deletions(-)

diff --git a/arch/x86/kernel/setup_percpu.c b/arch/x86/kernel/setup_percpu.c
index ae0c0d3..ee55e3b 100644
--- a/arch/x86/kernel/setup_percpu.c
+++ b/arch/x86/kernel/setup_percpu.c
@@ -15,6 +15,12 @@
 #include <asm/apicdef.h>
 #include <asm/highmem.h>
 
+#ifdef CONFIG_DEBUG_PER_CPU_MAPS
+# define DBG(x...) printk(KERN_DEBUG x)
+#else
+# define DBG(x...)
+#endif
+
 #ifdef CONFIG_X86_LOCAL_APIC
 unsigned int num_processors;
 unsigned disabled_cpus __cpuinitdata;
@@ -27,31 +33,39 @@ EXPORT_SYMBOL(boot_cpu_physical_apicid);
 physid_mask_t phys_cpu_present_map;
 #endif
 
-/* map cpu index to physical APIC ID */
+/*
+ * Map cpu index to physical APIC ID
+ */
 DEFINE_EARLY_PER_CPU(u16, x86_cpu_to_apicid, BAD_APICID);
 DEFINE_EARLY_PER_CPU(u16, x86_bios_cpu_apicid, BAD_APICID);
 EXPORT_EARLY_PER_CPU_SYMBOL(x86_cpu_to_apicid);
 EXPORT_EARLY_PER_CPU_SYMBOL(x86_bios_cpu_apicid);
 
 #if defined(CONFIG_NUMA) && defined(CONFIG_X86_64)
-#define	X86_64_NUMA	1
+#define	X86_64_NUMA	1	/* (used later) */
 
-/* map cpu index to node index */
+/*
+ * Map cpu index to node index
+ */
 DEFINE_EARLY_PER_CPU(int, x86_cpu_to_node_map, NUMA_NO_NODE);
 EXPORT_EARLY_PER_CPU_SYMBOL(x86_cpu_to_node_map);
 
-/* which logical CPUs are on which nodes */
+/*
+ * Which logical CPUs are on which nodes
+ */
 cpumask_t *node_to_cpumask_map;
 EXPORT_SYMBOL(node_to_cpumask_map);
 
-/* setup node_to_cpumask_map */
+/*
+ * Setup node_to_cpumask_map
+ */
 static void __init setup_node_to_cpumask_map(void);
 
 #else
 static inline void setup_node_to_cpumask_map(void) { }
 #endif
 
-#if defined(CONFIG_HAVE_SETUP_PER_CPU_AREA) && defined(CONFIG_X86_SMP)
+#ifdef CONFIG_HAVE_SETUP_PER_CPU_AREA
 /*
  * Copy data used in early init routines from the initial arrays to the
  * per cpu data areas.  These arrays then become expendable and the
@@ -181,10 +195,12 @@ void __init setup_per_cpu_areas(void)
 #endif
 		per_cpu_offset(cpu) = ptr - __per_cpu_start;
 		memcpy(ptr, __per_cpu_start, __per_cpu_end - __per_cpu_start);
+
+		DBG("PERCPU: cpu %4d %p\n", cpu, ptr);
 	}
 
-	printk(KERN_DEBUG "NR_CPUS: %d, nr_cpu_ids: %d, nr_node_ids %d\n",
-		NR_CPUS, nr_cpu_ids, nr_node_ids);
+	printk(KERN_INFO "NR_CPUS: %d, nr_cpu_ids: %d, nr_node_ids: %d\n",
+	       NR_CPUS, nr_cpu_ids, nr_node_ids);
 
 	/* Setup percpu data maps */
 	setup_per_cpu_maps();
@@ -202,6 +218,7 @@ void __init setup_per_cpu_areas(void)
  * Requires node_possible_map to be valid.
  *
  * Note: node_to_cpumask() is not valid until after this is done.
+ * (Use CONFIG_DEBUG_PER_CPU_MAPS to check this.)
  */
 static void __init setup_node_to_cpumask_map(void)
 {
@@ -217,6 +234,7 @@ static void __init setup_node_to_cpumask_map(void)
 
 	/* allocate the map */
 	map = alloc_bootmem_low(nr_node_ids * sizeof(cpumask_t));
+	DBG("node_to_cpumask_map at %p for %d nodes\n", map, nr_node_ids);
 
 	pr_debug("Node to cpumask map at %p for %d nodes\n",
 		 map, nr_node_ids);
@@ -229,17 +247,23 @@ void __cpuinit numa_set_node(int cpu, int node)
 {
 	int *cpu_to_node_map = early_per_cpu_ptr(x86_cpu_to_node_map);
 
-	if (cpu_pda(cpu) && node != NUMA_NO_NODE)
-		cpu_pda(cpu)->nodenumber = node;
-
-	if (cpu_to_node_map)
+	/* early setting, no percpu area yet */
+	if (cpu_to_node_map) {
 		cpu_to_node_map[cpu] = node;
+		return;
+	}
 
-	else if (per_cpu_offset(cpu))
-		per_cpu(x86_cpu_to_node_map, cpu) = node;
+#ifdef CONFIG_DEBUG_PER_CPU_MAPS
+	if (cpu >= nr_cpu_ids || !per_cpu_offset(cpu)) {
+		printk(KERN_ERR "numa_set_node: invalid cpu# (%d)\n", cpu);
+		dump_stack();
+		return;
+	}
+#endif
+	per_cpu(x86_cpu_to_node_map, cpu) = node;
 
-	else
-		pr_debug("Setting node for non-present cpu %d\n", cpu);
+	if (node != NUMA_NO_NODE)
+		cpu_pda(cpu)->nodenumber = node;
 }
 
 void __cpuinit numa_clear_node(int cpu)
@@ -256,7 +280,7 @@ void __cpuinit numa_add_cpu(int cpu)
 
 void __cpuinit numa_remove_cpu(int cpu)
 {
-	cpu_clear(cpu, node_to_cpumask_map[cpu_to_node(cpu)]);
+	cpu_clear(cpu, node_to_cpumask_map[early_cpu_to_node(cpu)]);
 }
 
 #else /* CONFIG_DEBUG_PER_CPU_MAPS */
@@ -266,7 +290,7 @@ void __cpuinit numa_remove_cpu(int cpu)
  */
 static void __cpuinit numa_set_cpumask(int cpu, int enable)
 {
-	int node = cpu_to_node(cpu);
+	int node = early_cpu_to_node(cpu);
 	cpumask_t *mask;
 	char buf[64];
 
-- 
1.5.6

