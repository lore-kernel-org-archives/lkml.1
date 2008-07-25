Return-Path: <linux-kernel-owner+w=401wt.eu-S1756896AbYGYVLp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756896AbYGYVLp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 17:11:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755842AbYGYVLU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 17:11:20 -0400
Received: from relay1.sgi.com ([192.48.171.29]:58863 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755735AbYGYVLS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 17:11:18 -0400
Message-Id: <20080725211117.800839000@polaris-admin.engr.sgi.com>
References: <20080725211117.586723000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Fri, 25 Jul 2008 14:11:18 -0700
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Hugh Dickins <hugh@veritas.com>, Jack Steiner <steiner@sgi.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] x86_64: Cleanup early setup_percpu references
Content-Disposition: inline; filename=cleanup_percpu
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  * Ruggedize some calls in setup_percpu.c to prevent mishaps
    in early calls, particularly for non-critical functions.

  * Cleanup DEBUG_PER_CPU_MAPS usages and some comments.

Based on linux-2.6.tip/master with following patches applied:

	cpumask: Make cpumask_of_cpu_map generic
	cpumask: Put cpumask_of_cpu_map in the initdata section
	cpumask: Change cpumask_of_cpu_ptr to use new cpumask_of_cpu

Signed-off-by: Mike Travis <travis@sgi.com>
---
 arch/x86/kernel/setup_percpu.c |   66 +++++++++++++++++++++++++++++------------
 1 file changed, 47 insertions(+), 19 deletions(-)

--- linux-2.6.tip.orig/arch/x86/kernel/setup_percpu.c
+++ linux-2.6.tip/arch/x86/kernel/setup_percpu.c
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
@@ -90,11 +104,16 @@ static void __init setup_per_cpu_maps(vo
 static void __init setup_cpumask_of_cpu(void)
 {
 	int i;
+	cpumask_t *new_map;
 
 	/* alloc_bootmem zeroes memory */
-	cpumask_of_cpu_map = alloc_bootmem_low(sizeof(cpumask_t) * nr_cpu_ids);
+	new_map = alloc_bootmem_low(sizeof(cpumask_t) * nr_cpu_ids);
+	DBG("cpumask_of_cpu_map at %p\n", new_map);
+
 	for (i = 0; i < nr_cpu_ids; i++)
-		cpu_set(i, cpumask_of_cpu_map[i]);
+		cpu_set(i, new_map[i]);
+
+	cpumask_of_cpu_map = (const cpumask_t *)new_map;
 }
 #else
 static inline void setup_cpumask_of_cpu(void) { }
@@ -189,9 +208,10 @@ void __init setup_per_cpu_areas(void)
 		per_cpu_offset(cpu) = ptr - __per_cpu_start;
 		memcpy(ptr, __per_cpu_start, __per_cpu_end - __per_cpu_start);
 
+		DBG("PERCPU: cpu %4d %p\n", cpu, ptr);
 	}
 
-	printk(KERN_DEBUG "NR_CPUS: %d, nr_cpu_ids: %d, nr_node_ids %d\n",
+	printk(KERN_INFO "NR_CPUS: %d, nr_cpu_ids: %d, nr_node_ids: %d\n",
 		NR_CPUS, nr_cpu_ids, nr_node_ids);
 
 	/* Setup percpu data maps */
@@ -213,6 +233,7 @@ void __init setup_per_cpu_areas(void)
  * Requires node_possible_map to be valid.
  *
  * Note: node_to_cpumask() is not valid until after this is done.
+ * (Use CONFIG_DEBUG_PER_CPU_MAPS to check this.)
  */
 static void __init setup_node_to_cpumask_map(void)
 {
@@ -228,6 +249,7 @@ static void __init setup_node_to_cpumask
 
 	/* allocate the map */
 	map = alloc_bootmem_low(nr_node_ids * sizeof(cpumask_t));
+	DBG("node_to_cpumask_map at %p for %d nodes\n", map, nr_node_ids);
 
 	pr_debug(KERN_DEBUG "Node to cpumask map at %p for %d nodes\n",
 		 map, nr_node_ids);
@@ -240,17 +262,23 @@ void __cpuinit numa_set_node(int cpu, in
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
@@ -267,7 +295,7 @@ void __cpuinit numa_add_cpu(int cpu)
 
 void __cpuinit numa_remove_cpu(int cpu)
 {
-	cpu_clear(cpu, node_to_cpumask_map[cpu_to_node(cpu)]);
+	cpu_clear(cpu, node_to_cpumask_map[early_cpu_to_node(cpu)]);
 }
 
 #else /* CONFIG_DEBUG_PER_CPU_MAPS */
@@ -277,7 +305,7 @@ void __cpuinit numa_remove_cpu(int cpu)
  */
 static void __cpuinit numa_set_cpumask(int cpu, int enable)
 {
-	int node = cpu_to_node(cpu);
+	int node = early_cpu_to_node(cpu);
 	cpumask_t *mask;
 	char buf[64];
 

-- 
