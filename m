Return-Path: <linux-kernel-owner+w=401wt.eu-S1764430AbYDZAQJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764430AbYDZAQJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 20:16:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758345AbYDZAPv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 20:15:51 -0400
Received: from relay1.sgi.com ([192.48.171.29]:50628 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754875AbYDZAPu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 20:15:50 -0400
Message-Id: <20080426001549.627084000@polaris-admin.engr.sgi.com>
References: <20080426001548.829332000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Fri, 25 Apr 2008 17:15:52 -0700
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 04/11] x86: remove the static 256k node_to_cpumask_map
Content-Disposition: inline; filename=node_to_cpumask
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  * Consolidate node_to_cpumask operations and remove the 256k
    byte node_to_cpumask_map.  This is done by allocating the
    node_to_cpumask_map array after the number of possible nodes
    (nr_node_ids) is known.

  * Debug printouts when CONFIG_DEBUG_PER_CPU_MAPS is active have
    been increased.  It now shows faults when calling node_to_cpumask()
    and node_to_cpumask_ptr().

For inclusion into sched-devel/latest tree.

Based on:
	git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
    +   sched-devel/latest  .../mingo/linux-2.6-sched-devel.git

Signed-off-by: Mike Travis <travis@sgi.com>
---
 arch/x86/kernel/setup.c    |  132 +++++++++++++++++++++++++++++++++++++++++++--
 arch/x86/mm/numa_64.c      |    6 --
 include/asm-x86/topology.h |   25 +++++---
 3 files changed, 144 insertions(+), 19 deletions(-)

--- linux-2.6.sched.orig/arch/x86/kernel/setup.c
+++ linux-2.6.sched/arch/x86/kernel/setup.c
@@ -34,6 +34,16 @@ EXPORT_EARLY_PER_CPU_SYMBOL(x86_bios_cpu
 /* map cpu index to node index */
 DEFINE_EARLY_PER_CPU(int, x86_cpu_to_node_map, NUMA_NO_NODE);
 EXPORT_EARLY_PER_CPU_SYMBOL(x86_cpu_to_node_map);
+
+/* which logical CPUs are on which nodes */
+cpumask_t *node_to_cpumask_map;
+EXPORT_SYMBOL(node_to_cpumask_map);
+
+/* setup node_to_cpumask_map */
+static void __init setup_node_to_cpumask_map(void);
+
+#else
+static inline void setup_node_to_cpumask_map(void) { }
 #endif
 
 #ifdef CONFIG_HAVE_SETUP_PER_CPU_AREA
@@ -139,11 +149,15 @@ void __init setup_per_cpu_areas(void)
 	}
 
 	nr_cpu_ids = highest_cpu + 1;
-	printk(KERN_DEBUG "NR_CPUS: %d, nr_cpu_ids: %d\n", NR_CPUS, nr_cpu_ids);
+	printk(KERN_DEBUG "NR_CPUS: %d, nr_cpu_ids: %d, nr_node_ids %d\n",
+		NR_CPUS, nr_cpu_ids, nr_node_ids);
 
 	/* Setup percpu data maps */
 	setup_per_cpu_maps();
 
+	/* Setup node to cpumask map */
+	setup_node_to_cpumask_map();
+
 	/* Setup cpumask_of_cpu map */
 	setup_cpumask_of_cpu();
 }
@@ -151,6 +165,35 @@ void __init setup_per_cpu_areas(void)
 #endif
 
 #ifdef X86_64_NUMA
+
+/*
+ * Allocate node_to_cpumask_map based on number of available nodes
+ * Requires node_possible_map to be valid.
+ *
+ * Note: node_to_cpumask() is not valid until after this is done.
+ */
+static void __init setup_node_to_cpumask_map(void)
+{
+	unsigned int node, num = 0;
+	cpumask_t *map;
+
+	/* setup nr_node_ids if not done yet */
+	if (nr_node_ids == MAX_NUMNODES) {
+		for_each_node_mask(node, node_possible_map)
+			num = node;
+		nr_node_ids = num + 1;
+	}
+
+	/* allocate the map */
+	map = alloc_bootmem_low(nr_node_ids * sizeof(cpumask_t));
+
+	Dprintk(KERN_DEBUG "Node to cpumask map at %p for %d nodes\n",
+		map, nr_node_ids);
+
+	/* node_to_cpumask() will now work */
+	node_to_cpumask_map = map;
+}
+
 void __cpuinit numa_set_node(int cpu, int node)
 {
 	int *cpu_to_node_map = early_per_cpu_ptr(x86_cpu_to_node_map);
@@ -173,6 +216,8 @@ void __cpuinit numa_clear_node(int cpu)
 	numa_set_node(cpu, NUMA_NO_NODE);
 }
 
+#ifndef CONFIG_DEBUG_PER_CPU_MAPS
+
 void __cpuinit numa_add_cpu(int cpu)
 {
 	cpu_set(cpu, node_to_cpumask_map[early_cpu_to_node(cpu)]);
@@ -182,9 +227,44 @@ void __cpuinit numa_remove_cpu(int cpu)
 {
 	cpu_clear(cpu, node_to_cpumask_map[cpu_to_node(cpu)]);
 }
-#endif /* CONFIG_NUMA */
 
-#if defined(CONFIG_DEBUG_PER_CPU_MAPS) && defined(CONFIG_X86_64)
+#else /* CONFIG_DEBUG_PER_CPU_MAPS */
+
+/*
+ * --------- debug versions of the numa functions ---------
+ */
+static void __cpuinit numa_set_cpumask(int cpu, int enable)
+{
+	int node = cpu_to_node(cpu);
+	cpumask_t *mask;
+	char buf[64];
+
+	if (node_to_cpumask_map == NULL) {
+		printk(KERN_ERR "node_to_cpumask_map NULL\n");
+		dump_stack();
+		return;
+	}
+
+	mask = &node_to_cpumask_map[node];
+	if (enable)
+		cpu_set(cpu, *mask);
+	else
+		cpu_clear(cpu, *mask);
+
+	cpulist_scnprintf(buf, sizeof(buf), *mask);
+	printk(KERN_DEBUG "%s cpu %d node %d: mask now %s\n",
+		enable? "numa_add_cpu":"numa_remove_cpu", cpu, node, buf);
+ }
+
+void __cpuinit numa_add_cpu(int cpu)
+{
+	numa_set_cpumask(cpu, 1);
+}
+
+void __cpuinit numa_remove_cpu(int cpu)
+{
+	numa_set_cpumask(cpu, 0);
+}
 
 int cpu_to_node(int cpu)
 {
@@ -198,6 +278,10 @@ int cpu_to_node(int cpu)
 }
 EXPORT_SYMBOL(cpu_to_node);
 
+/*
+ * Same function as cpu_to_node() but used if called before the
+ * per_cpu areas are setup.
+ */
 int early_cpu_to_node(int cpu)
 {
 	if (early_per_cpu_ptr(x86_cpu_to_node_map))
@@ -206,9 +290,47 @@ int early_cpu_to_node(int cpu)
 	if (!per_cpu_offset(cpu)) {
 		printk(KERN_WARNING
 			"early_cpu_to_node(%d): no per_cpu area!\n", cpu);
-			dump_stack();
+		dump_stack();
 		return NUMA_NO_NODE;
 	}
 	return per_cpu(x86_cpu_to_node_map, cpu);
 }
-#endif
+
+/*
+ * Returns a pointer to the bitmask of CPUs on Node 'node'.
+ */
+cpumask_t *_node_to_cpumask_ptr(int node)
+{
+	if (node_to_cpumask_map == NULL) {
+		printk(KERN_WARNING
+			"_node_to_cpumask_ptr(%d): no node_to_cpumask_map!\n",
+			node);
+		dump_stack();
+		return &cpu_online_map;
+	}
+	return &node_to_cpumask_map[node];
+}
+EXPORT_SYMBOL(_node_to_cpumask_ptr);
+
+/*
+ * Returns a bitmask of CPUs on Node 'node'.
+ */
+cpumask_t node_to_cpumask(int node)
+{
+	if (node_to_cpumask_map == NULL) {
+		printk(KERN_WARNING
+			"node_to_cpumask(%d): no node_to_cpumask_map!\n", node);
+		dump_stack();
+		return cpu_online_map;
+	}
+	return node_to_cpumask_map[node];
+}
+EXPORT_SYMBOL(node_to_cpumask);
+
+/*
+ * --------- end of debug versions of the numa functions ---------
+ */
+
+#endif /* CONFIG_DEBUG_PER_CPU_MAPS */
+
+#endif /* X86_64_NUMA */
--- linux-2.6.sched.orig/arch/x86/mm/numa_64.c
+++ linux-2.6.sched/arch/x86/mm/numa_64.c
@@ -35,9 +35,6 @@ s16 apicid_to_node[MAX_LOCAL_APIC] __cpu
 	[0 ... MAX_LOCAL_APIC-1] = NUMA_NO_NODE
 };
 
-cpumask_t node_to_cpumask_map[MAX_NUMNODES] __read_mostly;
-EXPORT_SYMBOL(node_to_cpumask_map);
-
 int numa_off __initdata;
 unsigned long __initdata nodemap_addr;
 unsigned long __initdata nodemap_size;
@@ -561,9 +558,6 @@ void __init numa_initmem_init(unsigned l
 	node_set(0, node_possible_map);
 	for (i = 0; i < NR_CPUS; i++)
 		numa_set_node(i, 0);
-	/* cpumask_of_cpu() may not be available during early startup */
-	memset(&node_to_cpumask_map[0], 0, sizeof(node_to_cpumask_map[0]));
-	cpu_set(0, node_to_cpumask_map[0]);
 	e820_register_active_regions(0, start_pfn, end_pfn);
 	setup_node_bootmem(0, start_pfn << PAGE_SHIFT, end_pfn << PAGE_SHIFT);
 }
--- linux-2.6.sched.orig/include/asm-x86/topology.h
+++ linux-2.6.sched/include/asm-x86/topology.h
@@ -47,10 +47,16 @@ static inline int cpu_to_node(int cpu)
 }
 #define early_cpu_to_node(cpu)	cpu_to_node(cpu)
 
+/* Returns a bitmask of CPUs on Node 'node'. */
+static inline cpumask_t node_to_cpumask(int node)
+{
+	return node_to_cpumask_map[node];
+}
+
 #else /* CONFIG_X86_64 */
 
 /* Mappings between node number and cpus on that node. */
-extern cpumask_t node_to_cpumask_map[];
+extern cpumask_t *node_to_cpumask_map;
 
 /* Mappings between logical cpu number and node number */
 DECLARE_EARLY_PER_CPU(int, x86_cpu_to_node_map);
@@ -94,7 +100,6 @@ static inline cpumask_t node_to_cpumask(
 }
 
 #endif /* !CONFIG_DEBUG_PER_CPU_MAPS */
-#endif /* CONFIG_X86_64 */
 
 /* Replace default node_to_cpumask_ptr with optimized version */
 #define node_to_cpumask_ptr(v, node)		\
@@ -103,12 +108,7 @@ static inline cpumask_t node_to_cpumask(
 #define node_to_cpumask_ptr_next(v, node)	\
 			   v = _node_to_cpumask_ptr(node)
 
-/* Returns the number of the first CPU on Node 'node'. */
-static inline int node_to_first_cpu(int node)
-{
-	node_to_cpumask_ptr(mask, node);
-	return first_cpu(*mask);
-}
+#endif /* CONFIG_X86_64 */
 
 /*
  * Returns the number of the node containing Node 'node'. This
@@ -195,6 +195,15 @@ static inline int node_to_first_cpu(int 
 
 #include <asm-generic/topology.h>
 
+#ifdef CONFIG_NUMA
+/* Returns the number of the first CPU on Node 'node'. */
+static inline int node_to_first_cpu(int node)
+{
+	node_to_cpumask_ptr(mask, node);
+	return first_cpu(*mask);
+}
+#endif
+
 extern cpumask_t cpu_coregroup_map(int cpu);
 
 #ifdef ENABLE_TOPO_DEFINES

-- 
