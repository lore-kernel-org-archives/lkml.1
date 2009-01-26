Return-Path: <linux-kernel-owner+w=401wt.eu-S1751768AbZAZGQN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751768AbZAZGQN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 01:16:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751332AbZAZGPj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 01:15:39 -0500
Received: from an-out-0708.google.com ([209.85.132.249]:44602 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751270AbZAZGPh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 01:15:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=kYsV+fErmPJ1js06t1syOSNjvJdb4bLVuG16fUzAIHQljcjDcDS5CzFcjf0i8mNO9T
         Imp+PDFXgXiBvYRIBAFFykGOa/v6Y2p00En4T4LHo3UGc6NNqjxA6j/7HEztz9lkJkoe
         FPUjaH3fuuQZ1KOP+Qvv9XFUp8zT8vc57kbFE=
From: Brian Gerst <brgerst@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 02/12] x86: Move 64-bit NUMA code
Date: Mon, 26 Jan 2009 01:15:22 -0500
Message-Id: <1232950532-22923-2-git-send-email-brgerst@gmail.com>
X-Mailer: git-send-email 1.6.1
In-Reply-To: <73c1f2160901252214k394d198dn815670e7f667b3ac@mail.gmail.com>
References: <73c1f2160901252214k394d198dn815670e7f667b3ac@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: Code movement, no functional change.

Move the 64-bit NUMA code from setup_percpu.c to numa_64.c

Signed-off-by: Brian Gerst <brgerst@gmail.com>
---
 arch/x86/include/asm/topology.h |    6 +
 arch/x86/kernel/setup_percpu.c  |  237 +--------------------------------------
 arch/x86/mm/numa_64.c           |  217 +++++++++++++++++++++++++++++++++++
 3 files changed, 228 insertions(+), 232 deletions(-)

diff --git a/arch/x86/include/asm/topology.h b/arch/x86/include/asm/topology.h
index 10022ed..77cfb2c 100644
--- a/arch/x86/include/asm/topology.h
+++ b/arch/x86/include/asm/topology.h
@@ -74,6 +74,8 @@ static inline const struct cpumask *cpumask_of_node(int node)
 	return &node_to_cpumask_map[node];
 }
 
+static inline void setup_node_to_cpumask_map(void) { }
+
 #else /* CONFIG_X86_64 */
 
 /* Mappings between node number and cpus on that node. */
@@ -120,6 +122,8 @@ static inline cpumask_t node_to_cpumask(int node)
 
 #endif /* !CONFIG_DEBUG_PER_CPU_MAPS */
 
+extern void setup_node_to_cpumask_map(void);
+
 /*
  * Replace default node_to_cpumask_ptr with optimized version
  * Deprecated: use "const struct cpumask *mask = cpumask_of_node(node)"
@@ -218,6 +222,8 @@ static inline int node_to_first_cpu(int node)
 	return first_cpu(cpu_online_map);
 }
 
+static inline void setup_node_to_cpumask_map(void) { }
+
 /*
  * Replace default node_to_cpumask_ptr with optimized version
  * Deprecated: use "const struct cpumask *mask = cpumask_of_node(node)"
diff --git a/arch/x86/kernel/setup_percpu.c b/arch/x86/kernel/setup_percpu.c
index d0b1476..cb6d622 100644
--- a/arch/x86/kernel/setup_percpu.c
+++ b/arch/x86/kernel/setup_percpu.c
@@ -51,32 +51,6 @@ DEFINE_EARLY_PER_CPU(u16, x86_bios_cpu_apicid, BAD_APICID);
 EXPORT_EARLY_PER_CPU_SYMBOL(x86_cpu_to_apicid);
 EXPORT_EARLY_PER_CPU_SYMBOL(x86_bios_cpu_apicid);
 
-#if defined(CONFIG_NUMA) && defined(CONFIG_X86_64)
-#define	X86_64_NUMA	1	/* (used later) */
-DEFINE_PER_CPU(int, node_number) = 0;
-EXPORT_PER_CPU_SYMBOL(node_number);
-
-/*
- * Map cpu index to node index
- */
-DEFINE_EARLY_PER_CPU(int, x86_cpu_to_node_map, NUMA_NO_NODE);
-EXPORT_EARLY_PER_CPU_SYMBOL(x86_cpu_to_node_map);
-
-/*
- * Which logical CPUs are on which nodes
- */
-cpumask_t *node_to_cpumask_map;
-EXPORT_SYMBOL(node_to_cpumask_map);
-
-/*
- * Setup node_to_cpumask_map
- */
-static void __init setup_node_to_cpumask_map(void);
-
-#else
-static inline void setup_node_to_cpumask_map(void) { }
-#endif
-
 #ifdef CONFIG_X86_64
 
 /* correctly size the local cpu masks */
@@ -163,13 +137,13 @@ void __init setup_per_cpu_areas(void)
 				early_per_cpu_map(x86_cpu_to_apicid, cpu);
 		per_cpu(x86_bios_cpu_apicid, cpu) =
 				early_per_cpu_map(x86_bios_cpu_apicid, cpu);
-#ifdef X86_64_NUMA
-		per_cpu(x86_cpu_to_node_map, cpu) =
-				early_per_cpu_map(x86_cpu_to_node_map, cpu);
-#endif
 #ifdef CONFIG_X86_64
 		per_cpu(irq_stack_ptr, cpu) =
 			per_cpu(irq_stack_union.irq_stack, cpu) + IRQ_STACK_SIZE - 64;
+#ifdef CONFIG_NUMA
+		per_cpu(x86_cpu_to_node_map, cpu) =
+				early_per_cpu_map(x86_cpu_to_node_map, cpu);
+#endif
 		/*
 		 * Up to this point, CPU0 has been using .data.init
 		 * area.  Reload %gs offset for CPU0.
@@ -184,7 +158,7 @@ void __init setup_per_cpu_areas(void)
 	/* indicate the early static arrays will soon be gone */
 	early_per_cpu_ptr(x86_cpu_to_apicid) = NULL;
 	early_per_cpu_ptr(x86_bios_cpu_apicid) = NULL;
-#ifdef X86_64_NUMA
+#if defined(CONFIG_X86_64) && defined(CONFIG_NUMA)
 	early_per_cpu_ptr(x86_cpu_to_node_map) = NULL;
 #endif
 
@@ -197,204 +171,3 @@ void __init setup_per_cpu_areas(void)
 
 #endif
 
-#ifdef X86_64_NUMA
-
-/*
- * Allocate node_to_cpumask_map based on number of available nodes
- * Requires node_possible_map to be valid.
- *
- * Note: node_to_cpumask() is not valid until after this is done.
- * (Use CONFIG_DEBUG_PER_CPU_MAPS to check this.)
- */
-static void __init setup_node_to_cpumask_map(void)
-{
-	unsigned int node, num = 0;
-	cpumask_t *map;
-
-	/* setup nr_node_ids if not done yet */
-	if (nr_node_ids == MAX_NUMNODES) {
-		for_each_node_mask(node, node_possible_map)
-			num = node;
-		nr_node_ids = num + 1;
-	}
-
-	/* allocate the map */
-	map = alloc_bootmem_low(nr_node_ids * sizeof(cpumask_t));
-	DBG("node_to_cpumask_map at %p for %d nodes\n", map, nr_node_ids);
-
-	pr_debug("Node to cpumask map at %p for %d nodes\n",
-		 map, nr_node_ids);
-
-	/* node_to_cpumask() will now work */
-	node_to_cpumask_map = map;
-}
-
-void __cpuinit numa_set_node(int cpu, int node)
-{
-	int *cpu_to_node_map = early_per_cpu_ptr(x86_cpu_to_node_map);
-
-	/* early setting, no percpu area yet */
-	if (cpu_to_node_map) {
-		cpu_to_node_map[cpu] = node;
-		return;
-	}
-
-#ifdef CONFIG_DEBUG_PER_CPU_MAPS
-	if (cpu >= nr_cpu_ids || !per_cpu_offset(cpu)) {
-		printk(KERN_ERR "numa_set_node: invalid cpu# (%d)\n", cpu);
-		dump_stack();
-		return;
-	}
-#endif
-	per_cpu(x86_cpu_to_node_map, cpu) = node;
-
-	if (node != NUMA_NO_NODE)
-		per_cpu(node_number, cpu) = node;
-}
-
-void __cpuinit numa_clear_node(int cpu)
-{
-	numa_set_node(cpu, NUMA_NO_NODE);
-}
-
-#ifndef CONFIG_DEBUG_PER_CPU_MAPS
-
-void __cpuinit numa_add_cpu(int cpu)
-{
-	cpu_set(cpu, node_to_cpumask_map[early_cpu_to_node(cpu)]);
-}
-
-void __cpuinit numa_remove_cpu(int cpu)
-{
-	cpu_clear(cpu, node_to_cpumask_map[early_cpu_to_node(cpu)]);
-}
-
-#else /* CONFIG_DEBUG_PER_CPU_MAPS */
-
-/*
- * --------- debug versions of the numa functions ---------
- */
-static void __cpuinit numa_set_cpumask(int cpu, int enable)
-{
-	int node = early_cpu_to_node(cpu);
-	cpumask_t *mask;
-	char buf[64];
-
-	if (node_to_cpumask_map == NULL) {
-		printk(KERN_ERR "node_to_cpumask_map NULL\n");
-		dump_stack();
-		return;
-	}
-
-	mask = &node_to_cpumask_map[node];
-	if (enable)
-		cpu_set(cpu, *mask);
-	else
-		cpu_clear(cpu, *mask);
-
-	cpulist_scnprintf(buf, sizeof(buf), mask);
-	printk(KERN_DEBUG "%s cpu %d node %d: mask now %s\n",
-		enable ? "numa_add_cpu" : "numa_remove_cpu", cpu, node, buf);
-}
-
-void __cpuinit numa_add_cpu(int cpu)
-{
-	numa_set_cpumask(cpu, 1);
-}
-
-void __cpuinit numa_remove_cpu(int cpu)
-{
-	numa_set_cpumask(cpu, 0);
-}
-
-int cpu_to_node(int cpu)
-{
-	if (early_per_cpu_ptr(x86_cpu_to_node_map)) {
-		printk(KERN_WARNING
-			"cpu_to_node(%d): usage too early!\n", cpu);
-		dump_stack();
-		return early_per_cpu_ptr(x86_cpu_to_node_map)[cpu];
-	}
-	return per_cpu(x86_cpu_to_node_map, cpu);
-}
-EXPORT_SYMBOL(cpu_to_node);
-
-/*
- * Same function as cpu_to_node() but used if called before the
- * per_cpu areas are setup.
- */
-int early_cpu_to_node(int cpu)
-{
-	if (early_per_cpu_ptr(x86_cpu_to_node_map))
-		return early_per_cpu_ptr(x86_cpu_to_node_map)[cpu];
-
-	if (!per_cpu_offset(cpu)) {
-		printk(KERN_WARNING
-			"early_cpu_to_node(%d): no per_cpu area!\n", cpu);
-		dump_stack();
-		return NUMA_NO_NODE;
-	}
-	return per_cpu(x86_cpu_to_node_map, cpu);
-}
-
-
-/* empty cpumask */
-static const cpumask_t cpu_mask_none;
-
-/*
- * Returns a pointer to the bitmask of CPUs on Node 'node'.
- */
-const cpumask_t *cpumask_of_node(int node)
-{
-	if (node_to_cpumask_map == NULL) {
-		printk(KERN_WARNING
-			"cpumask_of_node(%d): no node_to_cpumask_map!\n",
-			node);
-		dump_stack();
-		return (const cpumask_t *)&cpu_online_map;
-	}
-	if (node >= nr_node_ids) {
-		printk(KERN_WARNING
-			"cpumask_of_node(%d): node > nr_node_ids(%d)\n",
-			node, nr_node_ids);
-		dump_stack();
-		return &cpu_mask_none;
-	}
-	return &node_to_cpumask_map[node];
-}
-EXPORT_SYMBOL(cpumask_of_node);
-
-/*
- * Returns a bitmask of CPUs on Node 'node'.
- *
- * Side note: this function creates the returned cpumask on the stack
- * so with a high NR_CPUS count, excessive stack space is used.  The
- * node_to_cpumask_ptr function should be used whenever possible.
- */
-cpumask_t node_to_cpumask(int node)
-{
-	if (node_to_cpumask_map == NULL) {
-		printk(KERN_WARNING
-			"node_to_cpumask(%d): no node_to_cpumask_map!\n", node);
-		dump_stack();
-		return cpu_online_map;
-	}
-	if (node >= nr_node_ids) {
-		printk(KERN_WARNING
-			"node_to_cpumask(%d): node > nr_node_ids(%d)\n",
-			node, nr_node_ids);
-		dump_stack();
-		return cpu_mask_none;
-	}
-	return node_to_cpumask_map[node];
-}
-EXPORT_SYMBOL(node_to_cpumask);
-
-/*
- * --------- end of debug versions of the numa functions ---------
- */
-
-#endif /* CONFIG_DEBUG_PER_CPU_MAPS */
-
-#endif /* X86_64_NUMA */
-
diff --git a/arch/x86/mm/numa_64.c b/arch/x86/mm/numa_64.c
index 71a14f8..08d140f 100644
--- a/arch/x86/mm/numa_64.c
+++ b/arch/x86/mm/numa_64.c
@@ -20,6 +20,12 @@
 #include <asm/acpi.h>
 #include <asm/k8.h>
 
+#ifdef CONFIG_DEBUG_PER_CPU_MAPS
+# define DBG(x...) printk(KERN_DEBUG x)
+#else
+# define DBG(x...)
+#endif
+
 struct pglist_data *node_data[MAX_NUMNODES] __read_mostly;
 EXPORT_SYMBOL(node_data);
 
@@ -33,6 +39,21 @@ int numa_off __initdata;
 static unsigned long __initdata nodemap_addr;
 static unsigned long __initdata nodemap_size;
 
+DEFINE_PER_CPU(int, node_number) = 0;
+EXPORT_PER_CPU_SYMBOL(node_number);
+
+/*
+ * Map cpu index to node index
+ */
+DEFINE_EARLY_PER_CPU(int, x86_cpu_to_node_map, NUMA_NO_NODE);
+EXPORT_EARLY_PER_CPU_SYMBOL(x86_cpu_to_node_map);
+
+/*
+ * Which logical CPUs are on which nodes
+ */
+cpumask_t *node_to_cpumask_map;
+EXPORT_SYMBOL(node_to_cpumask_map);
+
 /*
  * Given a shift value, try to populate memnodemap[]
  * Returns :
@@ -640,3 +661,199 @@ void __init init_cpu_to_node(void)
 #endif
 
 
+/*
+ * Allocate node_to_cpumask_map based on number of available nodes
+ * Requires node_possible_map to be valid.
+ *
+ * Note: node_to_cpumask() is not valid until after this is done.
+ * (Use CONFIG_DEBUG_PER_CPU_MAPS to check this.)
+ */
+void __init setup_node_to_cpumask_map(void)
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
+	DBG("node_to_cpumask_map at %p for %d nodes\n", map, nr_node_ids);
+
+	pr_debug("Node to cpumask map at %p for %d nodes\n",
+		 map, nr_node_ids);
+
+	/* node_to_cpumask() will now work */
+	node_to_cpumask_map = map;
+}
+
+void __cpuinit numa_set_node(int cpu, int node)
+{
+	int *cpu_to_node_map = early_per_cpu_ptr(x86_cpu_to_node_map);
+
+	/* early setting, no percpu area yet */
+	if (cpu_to_node_map) {
+		cpu_to_node_map[cpu] = node;
+		return;
+	}
+
+#ifdef CONFIG_DEBUG_PER_CPU_MAPS
+	if (cpu >= nr_cpu_ids || !per_cpu_offset(cpu)) {
+		printk(KERN_ERR "numa_set_node: invalid cpu# (%d)\n", cpu);
+		dump_stack();
+		return;
+	}
+#endif
+	per_cpu(x86_cpu_to_node_map, cpu) = node;
+
+	if (node != NUMA_NO_NODE)
+		per_cpu(node_number, cpu) = node;
+}
+
+void __cpuinit numa_clear_node(int cpu)
+{
+	numa_set_node(cpu, NUMA_NO_NODE);
+}
+
+#ifndef CONFIG_DEBUG_PER_CPU_MAPS
+
+void __cpuinit numa_add_cpu(int cpu)
+{
+	cpu_set(cpu, node_to_cpumask_map[early_cpu_to_node(cpu)]);
+}
+
+void __cpuinit numa_remove_cpu(int cpu)
+{
+	cpu_clear(cpu, node_to_cpumask_map[early_cpu_to_node(cpu)]);
+}
+
+#else /* CONFIG_DEBUG_PER_CPU_MAPS */
+
+/*
+ * --------- debug versions of the numa functions ---------
+ */
+static void __cpuinit numa_set_cpumask(int cpu, int enable)
+{
+	int node = early_cpu_to_node(cpu);
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
+	cpulist_scnprintf(buf, sizeof(buf), mask);
+	printk(KERN_DEBUG "%s cpu %d node %d: mask now %s\n",
+		enable ? "numa_add_cpu" : "numa_remove_cpu", cpu, node, buf);
+}
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
+
+int cpu_to_node(int cpu)
+{
+	if (early_per_cpu_ptr(x86_cpu_to_node_map)) {
+		printk(KERN_WARNING
+			"cpu_to_node(%d): usage too early!\n", cpu);
+		dump_stack();
+		return early_per_cpu_ptr(x86_cpu_to_node_map)[cpu];
+	}
+	return per_cpu(x86_cpu_to_node_map, cpu);
+}
+EXPORT_SYMBOL(cpu_to_node);
+
+/*
+ * Same function as cpu_to_node() but used if called before the
+ * per_cpu areas are setup.
+ */
+int early_cpu_to_node(int cpu)
+{
+	if (early_per_cpu_ptr(x86_cpu_to_node_map))
+		return early_per_cpu_ptr(x86_cpu_to_node_map)[cpu];
+
+	if (!per_cpu_offset(cpu)) {
+		printk(KERN_WARNING
+			"early_cpu_to_node(%d): no per_cpu area!\n", cpu);
+		dump_stack();
+		return NUMA_NO_NODE;
+	}
+	return per_cpu(x86_cpu_to_node_map, cpu);
+}
+
+
+/* empty cpumask */
+static const cpumask_t cpu_mask_none;
+
+/*
+ * Returns a pointer to the bitmask of CPUs on Node 'node'.
+ */
+const cpumask_t *cpumask_of_node(int node)
+{
+	if (node_to_cpumask_map == NULL) {
+		printk(KERN_WARNING
+			"cpumask_of_node(%d): no node_to_cpumask_map!\n",
+			node);
+		dump_stack();
+		return (const cpumask_t *)&cpu_online_map;
+	}
+	if (node >= nr_node_ids) {
+		printk(KERN_WARNING
+			"cpumask_of_node(%d): node > nr_node_ids(%d)\n",
+			node, nr_node_ids);
+		dump_stack();
+		return &cpu_mask_none;
+	}
+	return &node_to_cpumask_map[node];
+}
+EXPORT_SYMBOL(cpumask_of_node);
+
+/*
+ * Returns a bitmask of CPUs on Node 'node'.
+ *
+ * Side note: this function creates the returned cpumask on the stack
+ * so with a high NR_CPUS count, excessive stack space is used.  The
+ * node_to_cpumask_ptr function should be used whenever possible.
+ */
+cpumask_t node_to_cpumask(int node)
+{
+	if (node_to_cpumask_map == NULL) {
+		printk(KERN_WARNING
+			"node_to_cpumask(%d): no node_to_cpumask_map!\n", node);
+		dump_stack();
+		return cpu_online_map;
+	}
+	if (node >= nr_node_ids) {
+		printk(KERN_WARNING
+			"node_to_cpumask(%d): node > nr_node_ids(%d)\n",
+			node, nr_node_ids);
+		dump_stack();
+		return cpu_mask_none;
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
-- 
1.6.1

