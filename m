Return-Path: <linux-kernel-owner+w=401wt.eu-S1754145AbYGIQv4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754145AbYGIQv4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 12:51:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751970AbYGIQvc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 12:51:32 -0400
Received: from relay1.sgi.com ([192.48.171.29]:53166 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751777AbYGIQva (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 12:51:30 -0400
Message-Id: <20080709165129.470416000@polaris-admin.engr.sgi.com>
References: <20080709165129.292635000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Wed, 09 Jul 2008 09:51:30 -0700
From: Mike Travis <travis@sgi.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org
Subject: [RFC 01/15] x86_64: Cleanup early setup_percpu references
Content-Disposition: inline; filename=cleanup_percpu
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  * Initialize the cpumask_of_cpu_map to contain a cpumask for cpu 0
    in the initdata section.  This allows references before the real
    cpumask_of_cpu_map is setup avoiding possible null pointer deref
    panics.

  * Ruggedize some other calls to prevent mishaps from early calls,
    pariticularly in non-critical functions:

  * Cleanup DEBUG_PER_CPU_MAPS usages and some comments.

Based on linux-2.6.tip/master

Signed-off-by: Mike Travis <travis@sgi.com>
---
 arch/x86/kernel/setup_percpu.c |   73 ++++++++++++++++++++++++++++-------------
 1 file changed, 51 insertions(+), 22 deletions(-)

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
 
-#if defined(CONFIG_HAVE_SETUP_PER_CPU_AREA) && defined(CONFIG_SMP)
+#ifdef CONFIG_HAVE_SETUP_PER_CPU_AREA
 /*
  * Copy data used in early init routines from the initial arrays to the
  * per cpu data areas.  These arrays then become expendable and the
@@ -81,16 +95,25 @@ static void __init setup_per_cpu_maps(vo
 }
 
 #ifdef CONFIG_HAVE_CPUMASK_OF_CPU_MAP
-cpumask_t *cpumask_of_cpu_map __read_mostly;
+/*
+ * Configure an initial cpumask_of_cpu(0) for early users
+ */
+static cpumask_t initial_cpumask_of_cpu_map __initdata = (cpumask_t) { {
+	[BITS_TO_LONGS(NR_CPUS)-1] = 1
+} };
+cpumask_t *cpumask_of_cpu_map __read_mostly =
+	(cpumask_t *)&initial_cpumask_of_cpu_map;
 EXPORT_SYMBOL(cpumask_of_cpu_map);
 
-/* requires nr_cpu_ids to be initialized */
+/* Requires nr_cpu_ids to be initialized. */
 static void __init setup_cpumask_of_cpu(void)
 {
 	int i;
 
 	/* alloc_bootmem zeroes memory */
 	cpumask_of_cpu_map = alloc_bootmem_low(sizeof(cpumask_t) * nr_cpu_ids);
+	DBG("cpumask_of_cpu_map %p\n", cpumask_of_cpu_map);
+
 	for (i = 0; i < nr_cpu_ids; i++)
 		cpu_set(i, cpumask_of_cpu_map[i]);
 }
@@ -197,9 +220,10 @@ void __init setup_per_cpu_areas(void)
 		per_cpu_offset(cpu) = ptr - __per_cpu_start;
 		memcpy(ptr, __per_cpu_start, __per_cpu_end - __per_cpu_start);
 
+		DBG("PERCPU: cpu %4d %p\n", cpu, ptr);
 	}
 
-	printk(KERN_DEBUG "NR_CPUS: %d, nr_cpu_ids: %d, nr_node_ids %d\n",
+	printk(KERN_INFO "NR_CPUS: %d, nr_cpu_ids: %d, nr_node_ids %d\n",
 		NR_CPUS, nr_cpu_ids, nr_node_ids);
 
 	/* Setup percpu data maps */
@@ -221,6 +245,7 @@ void __init setup_per_cpu_areas(void)
  * Requires node_possible_map to be valid.
  *
  * Note: node_to_cpumask() is not valid until after this is done.
+ * (Use CONFIG_DEBUG_PER_CPU_MAPS to check this.)
  */
 static void __init setup_node_to_cpumask_map(void)
 {
@@ -236,9 +261,7 @@ static void __init setup_node_to_cpumask
 
 	/* allocate the map */
 	map = alloc_bootmem_low(nr_node_ids * sizeof(cpumask_t));
-
-	Dprintk(KERN_DEBUG "Node to cpumask map at %p for %d nodes\n",
-		map, nr_node_ids);
+	DBG("node_to_cpumask_map at %p for %d nodes\n", map, nr_node_ids);
 
 	/* node_to_cpumask() will now work */
 	node_to_cpumask_map = map;
@@ -248,17 +271,23 @@ void __cpuinit numa_set_node(int cpu, in
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
-		Dprintk(KERN_INFO "Setting node for non-present cpu %d\n", cpu);
+	if (node != NUMA_NO_NODE)
+		cpu_pda(cpu)->nodenumber = node;
 }
 
 void __cpuinit numa_clear_node(int cpu)
@@ -275,7 +304,7 @@ void __cpuinit numa_add_cpu(int cpu)
 
 void __cpuinit numa_remove_cpu(int cpu)
 {
-	cpu_clear(cpu, node_to_cpumask_map[cpu_to_node(cpu)]);
+	cpu_clear(cpu, node_to_cpumask_map[early_cpu_to_node(cpu)]);
 }
 
 #else /* CONFIG_DEBUG_PER_CPU_MAPS */
@@ -285,7 +314,7 @@ void __cpuinit numa_remove_cpu(int cpu)
  */
 static void __cpuinit numa_set_cpumask(int cpu, int enable)
 {
-	int node = cpu_to_node(cpu);
+	int node = early_cpu_to_node(cpu);
 	cpumask_t *mask;
 	char buf[64];
 

-- 
