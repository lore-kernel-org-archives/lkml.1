Return-Path: <linux-kernel-owner+w=401wt.eu-S1753577AbYI2SJg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753577AbYI2SJg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 14:09:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754308AbYI2SDV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 14:03:21 -0400
Received: from relay1.sgi.com ([192.48.171.29]:54333 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753977AbYI2SCx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 14:02:53 -0400
Message-Id: <20080929180252.858014000@polaris-admin.engr.sgi.com>
References: <20080929180250.111209000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 29 Sep 2008 11:03:10 -0700
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, Yinghai Lu <yhlu.kernel@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, Jack Steiner <steiner@sgi.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 20/31] cpumask: clean mm files
Content-Disposition: inline; filename=clean-mm
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-of-by: Mike Travis <travis@sgi.com>
---
 include/linux/mm_types.h |    2 +-
 mm/allocpercpu.c         |   18 +++++++++---------
 mm/page_alloc.c          |    6 +++---
 mm/pdflush.c             |    6 +++---
 mm/quicklist.c           |    4 ++--
 mm/slab.c                |    4 ++--
 mm/slub.c                |    4 ++--
 mm/vmscan.c              |    8 ++++----
 mm/vmstat.c              |    6 +++---
 9 files changed, 29 insertions(+), 29 deletions(-)

--- struct-cpumasks.orig/include/linux/mm_types.h
+++ struct-cpumasks/include/linux/mm_types.h
@@ -218,7 +218,7 @@ struct mm_struct {
 
 	unsigned long saved_auxv[AT_VECTOR_SIZE]; /* for /proc/PID/auxv */
 
-	cpumask_t cpu_vm_mask;
+	cpumask_map_t cpu_vm_mask;
 
 	/* Architecture-specific MM context */
 	mm_context_t context;
--- struct-cpumasks.orig/mm/allocpercpu.c
+++ struct-cpumasks/mm/allocpercpu.c
@@ -31,10 +31,10 @@ static void percpu_depopulate(void *__pd
  * @__pdata: per-cpu data to depopulate
  * @mask: depopulate per-cpu data for cpu's selected through mask bits
  */
-static void __percpu_depopulate_mask(void *__pdata, cpumask_t *mask)
+static void __percpu_depopulate_mask(void *__pdata, const_cpumask_t mask)
 {
 	int cpu;
-	for_each_cpu(cpu, *mask)
+	for_each_cpu(cpu, mask)
 		percpu_depopulate(__pdata, cpu);
 }
 
@@ -80,15 +80,15 @@ static void *percpu_populate(void *__pda
  * Per-cpu objects are populated with zeroed buffers.
  */
 static int __percpu_populate_mask(void *__pdata, size_t size, gfp_t gfp,
-				  cpumask_t *mask)
+				  const_cpumask_t mask)
 {
-	cpumask_t populated;
+	cpumask_var_t populated;
 	int cpu;
 
 	cpus_clear(populated);
-	for_each_cpu(cpu, *mask)
+	for_each_cpu(cpu, mask)
 		if (unlikely(!percpu_populate(__pdata, size, gfp, cpu))) {
-			__percpu_depopulate_mask(__pdata, &populated);
+			__percpu_depopulate_mask(__pdata, populated);
 			return -ENOMEM;
 		} else
 			cpu_set(cpu, populated);
@@ -96,7 +96,7 @@ static int __percpu_populate_mask(void *
 }
 
 #define percpu_populate_mask(__pdata, size, gfp, mask) \
-	__percpu_populate_mask((__pdata), (size), (gfp), &(mask))
+	__percpu_populate_mask((__pdata), (size), (gfp), (mask))
 
 /**
  * percpu_alloc_mask - initial setup of per-cpu data
@@ -108,7 +108,7 @@ static int __percpu_populate_mask(void *
  * which is simplified by the percpu_alloc() wrapper.
  * Per-cpu objects are populated with zeroed buffers.
  */
-void *__percpu_alloc_mask(size_t size, gfp_t gfp, cpumask_t *mask)
+void *__percpu_alloc_mask(size_t size, gfp_t gfp, const_cpumask_t mask)
 {
 	/*
 	 * We allocate whole cache lines to avoid false sharing
@@ -137,7 +137,7 @@ void percpu_free(void *__pdata)
 {
 	if (unlikely(!__pdata))
 		return;
-	__percpu_depopulate_mask(__pdata, &cpu_possible_map);
+	__percpu_depopulate_mask(__pdata, cpu_possible_map);
 	kfree(__percpu_disguise(__pdata));
 }
 EXPORT_SYMBOL_GPL(percpu_free);
--- struct-cpumasks.orig/mm/page_alloc.c
+++ struct-cpumasks/mm/page_alloc.c
@@ -2080,7 +2080,7 @@ static int find_next_best_node(int node,
 	int n, val;
 	int min_val = INT_MAX;
 	int best_node = -1;
-	const cpumask_t tmp = node_to_cpumask(0);
+	const_cpumask_t tmp = node_to_cpumask(0);
 
 	/* Use the local node if we haven't already */
 	if (!node_isset(node, *used_node_mask)) {
@@ -2101,8 +2101,8 @@ static int find_next_best_node(int node,
 		val += (n < node);
 
 		/* Give preference to headless and unused nodes */
-		node_to_cpumask_ptr_next(tmp, n);
-		if (!cpus_empty(*tmp))
+		tmp = node_to_cpumask(n);
+		if (!cpus_empty(tmp))
 			val += PENALTY_FOR_NODE_WITH_CPUS;
 
 		/* Slight preference for less loaded node */
--- struct-cpumasks.orig/mm/pdflush.c
+++ struct-cpumasks/mm/pdflush.c
@@ -172,7 +172,7 @@ static int __pdflush(struct pdflush_work
 static int pdflush(void *dummy)
 {
 	struct pdflush_work my_work;
-	cpumask_t cpus_allowed;
+	cpumask_var_t cpus_allowed;
 
 	/*
 	 * pdflush can spend a lot of time doing encryption via dm-crypt.  We
@@ -187,8 +187,8 @@ static int pdflush(void *dummy)
 	 * This is needed as pdflush's are dynamically created and destroyed.
 	 * The boottime pdflush's are easily placed w/o these 2 lines.
 	 */
-	cpuset_cpus_allowed(current, &cpus_allowed);
-	set_cpus_allowed(current, &cpus_allowed);
+	cpuset_cpus_allowed(current, cpus_allowed);
+	set_cpus_allowed(current, cpus_allowed);
 
 	return __pdflush(&my_work);
 }
--- struct-cpumasks.orig/mm/quicklist.c
+++ struct-cpumasks/mm/quicklist.c
@@ -29,7 +29,7 @@ static unsigned long max_pages(unsigned 
 	int node = numa_node_id();
 	struct zone *zones = NODE_DATA(node)->node_zones;
 	int num_cpus_on_node;
-	const cpumask_t cpumask_on_node = node_to_cpumask(node);
+	const_cpumask_t cpumask_on_node = node_to_cpumask(node);
 
 	node_free_pages =
 #ifdef CONFIG_ZONE_DMA
@@ -42,7 +42,7 @@ static unsigned long max_pages(unsigned 
 
 	max = node_free_pages / FRACTION_OF_NODE_MEM;
 
-	num_cpus_on_node = cpus_weight(*cpumask_on_node);
+	num_cpus_on_node = cpus_weight(cpumask_on_node);
 	max /= num_cpus_on_node;
 
 	return max(max, min_pages);
--- struct-cpumasks.orig/mm/slab.c
+++ struct-cpumasks/mm/slab.c
@@ -1079,7 +1079,7 @@ static void __cpuinit cpuup_canceled(lon
 	struct kmem_cache *cachep;
 	struct kmem_list3 *l3 = NULL;
 	int node = cpu_to_node(cpu);
-	const cpumask_t mask = node_to_cpumask(node);
+	const_cpumask_t mask = node_to_cpumask(node);
 
 	list_for_each_entry(cachep, &cache_chain, next) {
 		struct array_cache *nc;
@@ -1101,7 +1101,7 @@ static void __cpuinit cpuup_canceled(lon
 		if (nc)
 			free_block(cachep, nc->entry, nc->avail, node);
 
-		if (!cpus_empty(*mask)) {
+		if (!cpus_empty(mask)) {
 			spin_unlock_irq(&l3->list_lock);
 			goto free_array_cache;
 		}
--- struct-cpumasks.orig/mm/slub.c
+++ struct-cpumasks/mm/slub.c
@@ -1972,7 +1972,7 @@ static DEFINE_PER_CPU(struct kmem_cache_
 				kmem_cache_cpu)[NR_KMEM_CACHE_CPU];
 
 static DEFINE_PER_CPU(struct kmem_cache_cpu *, kmem_cache_cpu_free);
-static cpumask_t kmem_cach_cpu_free_init_once = CPU_MASK_NONE;
+static cpumask_map_t kmem_cach_cpu_free_init_once = CPU_MASK_NONE;
 
 static struct kmem_cache_cpu *alloc_kmem_cache_cpu(struct kmem_cache *s,
 							int cpu, gfp_t flags)
@@ -3446,7 +3446,7 @@ struct location {
 	long max_time;
 	long min_pid;
 	long max_pid;
-	cpumask_t cpus;
+	cpumask_map_t cpus;
 	nodemask_t nodes;
 };
 
--- struct-cpumasks.orig/mm/vmscan.c
+++ struct-cpumasks/mm/vmscan.c
@@ -1687,9 +1687,9 @@ static int kswapd(void *p)
 	struct reclaim_state reclaim_state = {
 		.reclaimed_slab = 0,
 	};
-	const cpumask_t cpumask = node_to_cpumask(pgdat->node_id);
+	const_cpumask_t cpumask = node_to_cpumask(pgdat->node_id);
 
-	if (!cpus_empty(*cpumask))
+	if (!cpus_empty(cpumask))
 		set_cpus_allowed(tsk, cpumask);
 	current->reclaim_state = &reclaim_state;
 
@@ -1924,9 +1924,9 @@ static int __devinit cpu_callback(struct
 	if (action == CPU_ONLINE || action == CPU_ONLINE_FROZEN) {
 		for_each_node_state(nid, N_HIGH_MEMORY) {
 			pg_data_t *pgdat = NODE_DATA(nid);
-			const cpumask_t mask = node_to_cpumask(pgdat->node_id);
+			const_cpumask_t mask = node_to_cpumask(pgdat->node_id);
 
-			if (any_online_cpu(*mask) < nr_cpu_ids)
+			if (any_online_cpu(mask) < nr_cpu_ids)
 				/* One of our CPUs online: restore mask */
 				set_cpus_allowed(pgdat->kswapd, mask);
 		}
--- struct-cpumasks.orig/mm/vmstat.c
+++ struct-cpumasks/mm/vmstat.c
@@ -20,14 +20,14 @@
 DEFINE_PER_CPU(struct vm_event_state, vm_event_states) = {{0}};
 EXPORT_PER_CPU_SYMBOL(vm_event_states);
 
-static void sum_vm_events(unsigned long *ret, cpumask_t *cpumask)
+static void sum_vm_events(unsigned long *ret, const_cpumask_t cpumask)
 {
 	int cpu;
 	int i;
 
 	memset(ret, 0, NR_VM_EVENT_ITEMS * sizeof(unsigned long));
 
-	for_each_cpu(cpu, *cpumask) {
+	for_each_cpu(cpu, cpumask) {
 		struct vm_event_state *this = &per_cpu(vm_event_states, cpu);
 
 		for (i = 0; i < NR_VM_EVENT_ITEMS; i++)
@@ -43,7 +43,7 @@ static void sum_vm_events(unsigned long 
 void all_vm_events(unsigned long *ret)
 {
 	get_online_cpus();
-	sum_vm_events(ret, &cpu_online_map);
+	sum_vm_events(ret, cpu_online_map);
 	put_online_cpus();
 }
 EXPORT_SYMBOL_GPL(all_vm_events);

-- 
