Return-Path: <linux-kernel-owner+w=401wt.eu-S1755082AbYI2SIi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755082AbYI2SIi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 14:08:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752735AbYI2SDR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 14:03:17 -0400
Received: from relay2.sgi.com ([192.48.171.30]:36472 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753965AbYI2SCw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 14:02:52 -0400
Message-Id: <20080929180252.184795000@polaris-admin.engr.sgi.com>
References: <20080929180250.111209000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 29 Sep 2008 11:03:05 -0700
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, Yinghai Lu <yhlu.kernel@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, Jack Steiner <steiner@sgi.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 15/31] cpumask: remove node_to_cpumask_ptr
Content-Disposition: inline; filename=node_to_cpumask_ptr
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-of-by: Mike Travis <travis@sgi.com>
---
 arch/x86/kernel/setup_percpu.c |   65 +++++++++++++----------------------------
 drivers/base/node.c            |    2 -
 drivers/pci/pci-driver.c       |    7 +---
 include/asm-generic/topology.h |   13 --------
 include/asm-x86/topology.h     |   56 ++++++++++-------------------------
 include/linux/topology.h       |    3 -
 kernel/sched.c                 |   10 +++---
 mm/page_alloc.c                |    2 -
 mm/quicklist.c                 |    2 -
 mm/slab.c                      |    2 -
 mm/vmscan.c                    |    4 +-
 net/sunrpc/svc.c               |    7 ----
 12 files changed, 55 insertions(+), 118 deletions(-)

--- struct-cpumasks.orig/arch/x86/kernel/setup_percpu.c
+++ struct-cpumasks/arch/x86/kernel/setup_percpu.c
@@ -41,7 +41,7 @@ DEFINE_EARLY_PER_CPU(int, x86_cpu_to_nod
 EXPORT_EARLY_PER_CPU_SYMBOL(x86_cpu_to_node_map);
 
 /* which logical CPUs are on which nodes */
-cpumask_t *node_to_cpumask_map;
+const cpumask_t node_to_cpumask_map;
 EXPORT_SYMBOL(node_to_cpumask_map);
 
 /* setup node_to_cpumask_map */
@@ -210,7 +210,8 @@ void __init setup_per_cpu_areas(void)
 static void __init setup_node_to_cpumask_map(void)
 {
 	unsigned int node, num = 0;
-	cpumask_t *map;
+	cpumask_t *map = (cpumask_t *)&node_to_cpumask_map;
+	cpumask_t newmap;
 
 	/* setup nr_node_ids if not done yet */
 	if (nr_node_ids == MAX_NUMNODES) {
@@ -220,13 +221,13 @@ static void __init setup_node_to_cpumask
 	}
 
 	/* allocate the map */
-	map = alloc_bootmem_low(nr_node_ids * sizeof(cpumask_t));
+	newmap = alloc_bootmem_low(nr_node_ids * cpumask_size());
 
 	pr_debug(KERN_DEBUG "Node to cpumask map at %p for %d nodes\n",
-		 map, nr_node_ids);
+		 newmap, nr_node_ids);
 
 	/* node_to_cpumask() will now work */
-	node_to_cpumask_map = map;
+	*map = (cpumask_t)newmap;
 }
 
 void __cpuinit numa_set_node(int cpu, int node)
@@ -255,12 +256,16 @@ void __cpuinit numa_clear_node(int cpu)
 
 void __cpuinit numa_add_cpu(int cpu)
 {
-	cpu_set(cpu, node_to_cpumask_map[early_cpu_to_node(cpu)]);
+	cpumask_t map = (cpumask_t)node_to_cpumask(early_cpu_to_node(cpu));
+
+	cpu_set(cpu, map);
 }
 
 void __cpuinit numa_remove_cpu(int cpu)
 {
-	cpu_clear(cpu, node_to_cpumask_map[cpu_to_node(cpu)]);
+	cpumask_t map = (cpumask_t)node_to_cpumask(early_cpu_to_node(cpu));
+
+	cpu_clear(cpu, map);
 }
 
 #else /* CONFIG_DEBUG_PER_CPU_MAPS */
@@ -271,7 +276,7 @@ void __cpuinit numa_remove_cpu(int cpu)
 static void __cpuinit numa_set_cpumask(int cpu, int enable)
 {
 	int node = cpu_to_node(cpu);
-	cpumask_t *mask;
+	cpumask_t mask;
 	char buf[64];
 
 	if (node_to_cpumask_map == NULL) {
@@ -280,13 +285,13 @@ static void __cpuinit numa_set_cpumask(i
 		return;
 	}
 
-	mask = &node_to_cpumask_map[node];
+	mask = (cpumask_t)node_to_cpumask(early_cpu_to_node(cpu));
 	if (enable)
-		cpu_set(cpu, *mask);
+		cpu_set(cpu, mask);
 	else
-		cpu_clear(cpu, *mask);
+		cpu_clear(cpu, mask);
 
-	cpulist_scnprintf(buf, sizeof(buf), *mask);
+	cpulist_scnprintf(buf, sizeof(buf), mask);
 	printk(KERN_DEBUG "%s cpu %d node %d: mask now %s\n",
 		enable? "numa_add_cpu":"numa_remove_cpu", cpu, node, buf);
  }
@@ -333,54 +338,28 @@ int early_cpu_to_node(int cpu)
 
 
 /* empty cpumask */
-static const cpumask_t cpu_mask_none;
+static const cpumask_map_t cpu_mask_none;
 
 /*
  * Returns a pointer to the bitmask of CPUs on Node 'node'.
  */
-const cpumask_t *_node_to_cpumask_ptr(int node)
+const_cpumask_t node_to_cpumask(int node)
 {
 	if (node_to_cpumask_map == NULL) {
 		printk(KERN_WARNING
 			"_node_to_cpumask_ptr(%d): no node_to_cpumask_map!\n",
 			node);
 		dump_stack();
-		return (const cpumask_t *)&cpu_online_map;
+		return (const cpumask_t)cpu_online_map;
 	}
 	if (node >= nr_node_ids) {
 		printk(KERN_WARNING
 			"_node_to_cpumask_ptr(%d): node > nr_node_ids(%d)\n",
 			node, nr_node_ids);
 		dump_stack();
-		return &cpu_mask_none;
-	}
-	return &node_to_cpumask_map[node];
-}
-EXPORT_SYMBOL(_node_to_cpumask_ptr);
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
+		return (const cpumask_t)cpu_mask_none;
 	}
-	return node_to_cpumask_map[node];
+	return (const cpumask_t)&node_to_cpumask_map[node];
 }
 EXPORT_SYMBOL(node_to_cpumask);
 
--- struct-cpumasks.orig/drivers/base/node.c
+++ struct-cpumasks/drivers/base/node.c
@@ -22,7 +22,7 @@ static struct sysdev_class node_class = 
 static ssize_t node_read_cpumap(struct sys_device *dev, int type, char *buf)
 {
 	struct node *node_dev = to_node(dev);
-	node_to_cpumask_ptr(mask, node_dev->sysdev.id);
+	const cpumask_t mask = node_to_cpumask(node_dev->sysdev.id);
 	int len;
 
 	/* 2008/04/07: buf currently PAGE_SIZE, need 9 chars per 32 bits. */
--- struct-cpumasks.orig/drivers/pci/pci-driver.c
+++ struct-cpumasks/drivers/pci/pci-driver.c
@@ -183,10 +183,9 @@ static int pci_call_probe(struct pci_dri
 	cpumask_t oldmask = current->cpus_allowed;
 	int node = dev_to_node(&dev->dev);
 
-	if (node >= 0) {
-		node_to_cpumask_ptr(nodecpumask, node);
-		set_cpus_allowed(current, nodecpumask);
-	}
+	if (node >= 0)
+		set_cpus_allowed(current, node_to_cpumask(node);
+
 	/* And set default memory allocation policy */
 	oldpol = current->mempolicy;
 	current->mempolicy = NULL;	/* fall back to system default policy */
--- struct-cpumasks.orig/include/asm-generic/topology.h
+++ struct-cpumasks/include/asm-generic/topology.h
@@ -50,21 +50,10 @@
 #ifndef pcibus_to_cpumask
 #define pcibus_to_cpumask(bus)	(pcibus_to_node(bus) == -1 ? \
 					cpu_mask_all : \
-					node_to_cpumask(pcibus_to_node(bus)) \
+					node_to_cpumask(pcibus_to_node(bus) \
 				)
 #endif
 
 #endif	/* CONFIG_NUMA */
 
-/* returns pointer to cpumask for specified node */
-#ifndef node_to_cpumask_ptr
-
-#define	node_to_cpumask_ptr(v, node) 					\
-		cpumask_t _##v = node_to_cpumask(node);			\
-		const cpumask_t *v = &_##v
-
-#define node_to_cpumask_ptr_next(v, node)				\
-			  _##v = node_to_cpumask(node)
-#endif
-
 #endif /* _ASM_GENERIC_TOPOLOGY_H */
--- struct-cpumasks.orig/include/asm-x86/topology.h
+++ struct-cpumasks/include/asm-x86/topology.h
@@ -45,7 +45,7 @@
 #ifdef CONFIG_X86_32
 
 /* Mappings between node number and cpus on that node. */
-extern cpumask_t node_to_cpumask_map[];
+extern const cpumask_map_t node_to_cpumask_map[NR_CPUS];
 
 /* Mappings between logical cpu number and node number */
 extern int cpu_to_node_map[];
@@ -57,21 +57,16 @@ static inline int cpu_to_node(int cpu)
 }
 #define early_cpu_to_node(cpu)	cpu_to_node(cpu)
 
-/* Returns a bitmask of CPUs on Node 'node'.
- *
- * Side note: this function creates the returned cpumask on the stack
- * so with a high NR_CPUS count, excessive stack space is used.  The
- * node_to_cpumask_ptr function should be used whenever possible.
- */
-static inline cpumask_t node_to_cpumask(int node)
+/* Returns a bitmask of CPUs on Node 'node'. */
+static inline const cpumask_t node_to_cpumask(int node)
 {
-	return node_to_cpumask_map[node];
+	return (const cpumask_t)&node_to_cpumask_map[node];
 }
 
 #else /* CONFIG_X86_64 */
 
 /* Mappings between node number and cpus on that node. */
-extern cpumask_t *node_to_cpumask_map;
+extern const cpumask_t node_to_cpumask_map;
 
 /* Mappings between logical cpu number and node number */
 DECLARE_EARLY_PER_CPU(int, x86_cpu_to_node_map);
@@ -82,8 +77,10 @@ DECLARE_EARLY_PER_CPU(int, x86_cpu_to_no
 #ifdef CONFIG_DEBUG_PER_CPU_MAPS
 extern int cpu_to_node(int cpu);
 extern int early_cpu_to_node(int cpu);
-extern const cpumask_t *_node_to_cpumask_ptr(int node);
-extern cpumask_t node_to_cpumask(int node);
+/* XXX - "const" causes:
+ * "warning: type qualifiers ignored on function return type" */
+//extern const struct __cpumask_s *node_to_cpumask(int node);
+extern const_cpumask_t node_to_cpumask(int node);
 
 #else	/* !CONFIG_DEBUG_PER_CPU_MAPS */
 
@@ -103,26 +100,16 @@ static inline int early_cpu_to_node(int 
 }
 
 /* Returns a pointer to the cpumask of CPUs on Node 'node'. */
-static inline const cpumask_t *_node_to_cpumask_ptr(int node)
+static inline const_cpumask_t node_to_cpumask(int node)
 {
-	return &node_to_cpumask_map[node];
-}
+	char *map = (char *)node_to_cpumask_map;
 
-/* Returns a bitmask of CPUs on Node 'node'. */
-static inline cpumask_t node_to_cpumask(int node)
-{
-	return node_to_cpumask_map[node];
+	map += BITS_TO_LONGS(node * nr_cpu_ids);
+	return (const cpumask_t)map;
 }
 
 #endif /* !CONFIG_DEBUG_PER_CPU_MAPS */
 
-/* Replace default node_to_cpumask_ptr with optimized version */
-#define node_to_cpumask_ptr(v, node)		\
-		const cpumask_t *v = _node_to_cpumask_ptr(node)
-
-#define node_to_cpumask_ptr_next(v, node)	\
-			   v = _node_to_cpumask_ptr(node)
-
 #endif /* CONFIG_X86_64 */
 
 /*
@@ -186,25 +173,15 @@ extern int __node_distance(int, int);
 #define	cpu_to_node(cpu)	0
 #define	early_cpu_to_node(cpu)	0
 
-static inline const cpumask_t *_node_to_cpumask_ptr(int node)
+static inline const_cpumask_t node_to_cpumask(int node)
 {
-	return &cpu_online_map;
-}
-static inline cpumask_t node_to_cpumask(int node)
-{
-	return cpu_online_map;
+	return (const cpumask_t)cpu_online_map;
 }
 static inline int node_to_first_cpu(int node)
 {
 	return cpus_first(cpu_online_map);
 }
 
-/* Replace default node_to_cpumask_ptr with optimized version */
-#define node_to_cpumask_ptr(v, node)		\
-		const cpumask_t *v = _node_to_cpumask_ptr(node)
-
-#define node_to_cpumask_ptr_next(v, node)	\
-			   v = _node_to_cpumask_ptr(node)
 #endif
 
 #include <asm-generic/topology.h>
@@ -213,8 +190,7 @@ static inline int node_to_first_cpu(int 
 /* Returns the number of the first CPU on Node 'node'. */
 static inline int node_to_first_cpu(int node)
 {
-	node_to_cpumask_ptr(mask, node);
-	return cpus_first(*mask);
+	return cpus_first((const cpumask_t)node_to_cpumask(node));
 }
 #endif
 
--- struct-cpumasks.orig/include/linux/topology.h
+++ struct-cpumasks/include/linux/topology.h
@@ -40,8 +40,7 @@
 #ifndef nr_cpus_node
 #define nr_cpus_node(node)				\
 	({						\
-		node_to_cpumask_ptr(__tmp__, node);	\
-		cpus_weight(*__tmp__);			\
+		cpus_weight(node_to_cpumask(node));	\
 	})
 #endif
 
--- struct-cpumasks.orig/kernel/sched.c
+++ struct-cpumasks/kernel/sched.c
@@ -6147,7 +6147,7 @@ static void move_task_off_dead_cpu(int d
 
 	do {
 		/* On same node? */
-		mask = node_to_cpumask(cpu_to_node(dead_cpu));
+		mask = node_to_cpumask(cpu_to_node(dead_cpu);
 		cpus_and(mask, mask, p->cpus_allowed);
 		dest_cpu = any_online_cpu(mask);
 
@@ -7044,7 +7044,7 @@ static int find_next_best_node(int node,
 static void sched_domain_node_span(int node, cpumask_t *span)
 {
 	nodemask_t used_nodes;
-	node_to_cpumask_ptr(nodemask, node);
+	const cpumask_t nodemask = node_to_cpumask(node);
 	int i;
 
 	cpus_clear(*span);
@@ -7056,7 +7056,7 @@ static void sched_domain_node_span(int n
 	for (i = 1; i < SD_NODES_PER_DOMAIN; i++) {
 		int next_node = find_next_best_node(node, &used_nodes);
 
-		node_to_cpumask_ptr_next(nodemask, next_node);
+		nodemask = node_to_cpumask(next_node);
 		cpus_or(*span, *span, *nodemask);
 	}
 }
@@ -7155,7 +7155,7 @@ static int cpu_to_allnodes_group(int cpu
 {
 	int group;
 
-	*nodemask = node_to_cpumask(cpu_to_node(cpu));
+	nodemask = node_to_cpumask(cpu_to_node(cpu));
 	cpus_and(*nodemask, *nodemask, *cpu_map);
 	group = cpus_first(*nodemask);
 
@@ -7602,7 +7602,7 @@ static int __build_sched_domains(const c
 		for (j = 0; j < nr_node_ids; j++) {
 			SCHED_CPUMASK_VAR(notcovered, allmasks);
 			int n = (i + j) % nr_node_ids;
-			node_to_cpumask_ptr(pnodemask, n);
+			const cpumask_t pnodemask = node_to_cpumask(n);
 
 			cpus_complement(*notcovered, *covered);
 			cpus_and(*tmpmask, *notcovered, *cpu_map);
--- struct-cpumasks.orig/mm/page_alloc.c
+++ struct-cpumasks/mm/page_alloc.c
@@ -2080,7 +2080,7 @@ static int find_next_best_node(int node,
 	int n, val;
 	int min_val = INT_MAX;
 	int best_node = -1;
-	node_to_cpumask_ptr(tmp, 0);
+	const cpumask_t tmp = node_to_cpumask(0);
 
 	/* Use the local node if we haven't already */
 	if (!node_isset(node, *used_node_mask)) {
--- struct-cpumasks.orig/mm/quicklist.c
+++ struct-cpumasks/mm/quicklist.c
@@ -29,7 +29,7 @@ static unsigned long max_pages(unsigned 
 	int node = numa_node_id();
 	struct zone *zones = NODE_DATA(node)->node_zones;
 	int num_cpus_on_node;
-	node_to_cpumask_ptr(cpumask_on_node, node);
+	const cpumask_t cpumask_on_node = node_to_cpumask(node);
 
 	node_free_pages =
 #ifdef CONFIG_ZONE_DMA
--- struct-cpumasks.orig/mm/slab.c
+++ struct-cpumasks/mm/slab.c
@@ -1079,7 +1079,7 @@ static void __cpuinit cpuup_canceled(lon
 	struct kmem_cache *cachep;
 	struct kmem_list3 *l3 = NULL;
 	int node = cpu_to_node(cpu);
-	node_to_cpumask_ptr(mask, node);
+	const cpumask_t mask = node_to_cpumask(node);
 
 	list_for_each_entry(cachep, &cache_chain, next) {
 		struct array_cache *nc;
--- struct-cpumasks.orig/mm/vmscan.c
+++ struct-cpumasks/mm/vmscan.c
@@ -1687,7 +1687,7 @@ static int kswapd(void *p)
 	struct reclaim_state reclaim_state = {
 		.reclaimed_slab = 0,
 	};
-	node_to_cpumask_ptr(cpumask, pgdat->node_id);
+	const cpumask_t cpumask = node_to_cpumask(pgdat->node_id);
 
 	if (!cpus_empty(*cpumask))
 		set_cpus_allowed(tsk, cpumask);
@@ -1924,7 +1924,7 @@ static int __devinit cpu_callback(struct
 	if (action == CPU_ONLINE || action == CPU_ONLINE_FROZEN) {
 		for_each_node_state(nid, N_HIGH_MEMORY) {
 			pg_data_t *pgdat = NODE_DATA(nid);
-			node_to_cpumask_ptr(mask, pgdat->node_id);
+			const cpumask_t mask = node_to_cpumask(pgdat->node_id);
 
 			if (any_online_cpu(*mask) < nr_cpu_ids)
 				/* One of our CPUs online: restore mask */
--- struct-cpumasks.orig/net/sunrpc/svc.c
+++ struct-cpumasks/net/sunrpc/svc.c
@@ -309,17 +309,12 @@ svc_pool_map_set_cpumask(struct task_str
 
 	switch (m->mode) {
 	case SVC_POOL_PERCPU:
-	{
 		set_cpus_allowed(task, cpumask_of_cpu(node));
 		break;
-	}
 	case SVC_POOL_PERNODE:
-	{
-		node_to_cpumask_ptr(nodecpumask, node);
-		set_cpus_allowed(task, nodecpumask);
+		set_cpus_allowed(task, node_to_cpumask(node));
 		break;
 	}
-	}
 }
 
 /*

-- 
