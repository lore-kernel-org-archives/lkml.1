Return-Path: <linux-kernel-owner+w=401wt.eu-S935131AbXKPXMw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935131AbXKPXMw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 18:12:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762486AbXKPXLM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 18:11:12 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:51784 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758895AbXKPXLC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 18:11:02 -0500
Message-Id: <20071116231102.151417992@sgi.com>
References: <20071116230920.278761667@sgi.com>
User-Agent: quilt/0.46-1
Date: Fri, 16 Nov 2007 15:09:22 -0800
From: Christoph Lameter <clameter@sgi.com>
To: akpm@linux-foundation.org
Cc: linux-arch@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: David Miller <davem@davemloft.net>
Cc: Eric Dumazet <dada1@cosmosbay.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Subject: [patch 02/30] cpu alloc: Use in SLUB
Content-Disposition: inline; filename=cpu_alloc_slub_conversion
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Using cpu alloc removes the needs for the per cpu arrays in the kmem_cache struct.
These could get quite big if we have to support system of up to thousands of cpus.
The use of alloc_percpu means that:

1. The size of kmem_cache for SMP configuration shrinks since we will only
   need 1 pointer instead of NR_CPUS. The same pointer can be used by all
   processors. Reduces cache footprint of the allocator.

2. We can dynamically size kmem_cache according to the actual nodes in the
   system meaning less memory overhead for configurations that may potentially
   support up to 1k NUMA nodes.

3. We can remove the diddle widdle with allocating and releasing kmem_cache_cpu
   structures when bringing up and shuttting down cpus. The allocpercpu
   logic will do it all for us. Removes some portions of the cpu hotplug
   functionality.

4. Fastpath performance increases by another 20% vs. the earlier improvements.
   Instead of having fastpath with 45-50 cycles it is now possible to get
   below 40.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
---
 include/linux/slub_def.h |    6 -
 mm/slub.c                |  182 ++++++-----------------------------------------
 2 files changed, 25 insertions(+), 163 deletions(-)

Index: linux-2.6/include/linux/slub_def.h
===================================================================
--- linux-2.6.orig/include/linux/slub_def.h	2007-11-15 21:24:53.494154465 -0800
+++ linux-2.6/include/linux/slub_def.h	2007-11-15 21:25:07.622904866 -0800
@@ -34,6 +34,7 @@ struct kmem_cache_node {
  * Slab cache management.
  */
 struct kmem_cache {
+	struct kmem_cache_cpu *cpu_slab;
 	/* Used for retriving partial slabs etc */
 	unsigned long flags;
 	int size;		/* The size of an object including meta data */
@@ -63,11 +64,6 @@ struct kmem_cache {
 	int defrag_ratio;
 	struct kmem_cache_node *node[MAX_NUMNODES];
 #endif
-#ifdef CONFIG_SMP
-	struct kmem_cache_cpu *cpu_slab[NR_CPUS];
-#else
-	struct kmem_cache_cpu cpu_slab;
-#endif
 };
 
 /*
Index: linux-2.6/mm/slub.c
===================================================================
--- linux-2.6.orig/mm/slub.c	2007-11-15 21:24:53.502154325 -0800
+++ linux-2.6/mm/slub.c	2007-11-15 21:25:07.622904866 -0800
@@ -239,15 +239,6 @@ static inline struct kmem_cache_node *ge
 #endif
 }
 
-static inline struct kmem_cache_cpu *get_cpu_slab(struct kmem_cache *s, int cpu)
-{
-#ifdef CONFIG_SMP
-	return s->cpu_slab[cpu];
-#else
-	return &s->cpu_slab;
-#endif
-}
-
 /*
  * The end pointer in a slab is special. It points to the first object in the
  * slab but has bit 0 set to mark it.
@@ -1472,7 +1463,7 @@ static inline void flush_slab(struct kme
  */
 static inline void __flush_cpu_slab(struct kmem_cache *s, int cpu)
 {
-	struct kmem_cache_cpu *c = get_cpu_slab(s, cpu);
+	struct kmem_cache_cpu *c = CPU_PTR(s->cpu_slab, cpu);
 
 	if (likely(c && c->page))
 		flush_slab(s, c);
@@ -1487,15 +1478,7 @@ static void flush_cpu_slab(void *d)
 
 static void flush_all(struct kmem_cache *s)
 {
-#ifdef CONFIG_SMP
 	on_each_cpu(flush_cpu_slab, s, 1, 1);
-#else
-	unsigned long flags;
-
-	local_irq_save(flags);
-	flush_cpu_slab(s);
-	local_irq_restore(flags);
-#endif
 }
 
 /*
@@ -1529,7 +1512,7 @@ static noinline unsigned long get_new_sl
 	if (!page)
 		return 0;
 
-	*pc = c = get_cpu_slab(s, smp_processor_id());
+	*pc = c = THIS_CPU(s->cpu_slab);
 	if (c->page)
 		flush_slab(s, c);
 	c->page = page;
@@ -1641,25 +1624,26 @@ static void __always_inline *slab_alloc(
 	struct kmem_cache_cpu *c;
 
 #ifdef CONFIG_FAST_CMPXCHG_LOCAL
-	c = get_cpu_slab(s, get_cpu());
+	preempt_disable();
+	c = THIS_CPU(s->cpu_slab);
 	do {
 		object = c->freelist;
 		if (unlikely(is_end(object) || !node_match(c, node))) {
 			object = __slab_alloc(s, gfpflags, node, addr, c);
 			if (unlikely(!object)) {
-				put_cpu();
+				preempt_enable();
 				goto out;
 			}
 			break;
 		}
 	} while (cmpxchg_local(&c->freelist, object, object[c->offset])
 								!= object);
-	put_cpu();
+	preempt_enable();
 #else
 	unsigned long flags;
 
 	local_irq_save(flags);
-	c = get_cpu_slab(s, smp_processor_id());
+	c = THIS_CPU(s->cpu_slab);
 	if (unlikely((is_end(c->freelist)) || !node_match(c, node))) {
 
 		object = __slab_alloc(s, gfpflags, node, addr, c);
@@ -1784,7 +1768,8 @@ static void __always_inline slab_free(st
 #ifdef CONFIG_FAST_CMPXCHG_LOCAL
 	void **freelist;
 
-	c = get_cpu_slab(s, get_cpu());
+	preempt_disable();
+	c = THIS_CPU(s->cpu_slab);
 	debug_check_no_locks_freed(object, s->objsize);
 	do {
 		freelist = c->freelist;
@@ -1806,13 +1791,13 @@ static void __always_inline slab_free(st
 		}
 		object[c->offset] = freelist;
 	} while (cmpxchg_local(&c->freelist, freelist, object) != freelist);
-	put_cpu();
+	preempt_enable();
 #else
 	unsigned long flags;
 
 	local_irq_save(flags);
 	debug_check_no_locks_freed(object, s->objsize);
-	c = get_cpu_slab(s, smp_processor_id());
+	c = THIS_CPU(s->cpu_slab);
 	if (likely(page == c->page && c->node >= 0)) {
 		object[c->offset] = c->freelist;
 		c->freelist = object;
@@ -2015,130 +2000,19 @@ static void init_kmem_cache_node(struct 
 #endif
 }
 
-#ifdef CONFIG_SMP
-/*
- * Per cpu array for per cpu structures.
- *
- * The per cpu array places all kmem_cache_cpu structures from one processor
- * close together meaning that it becomes possible that multiple per cpu
- * structures are contained in one cacheline. This may be particularly
- * beneficial for the kmalloc caches.
- *
- * A desktop system typically has around 60-80 slabs. With 100 here we are
- * likely able to get per cpu structures for all caches from the array defined
- * here. We must be able to cover all kmalloc caches during bootstrap.
- *
- * If the per cpu array is exhausted then fall back to kmalloc
- * of individual cachelines. No sharing is possible then.
- */
-#define NR_KMEM_CACHE_CPU 100
-
-static DEFINE_PER_CPU(struct kmem_cache_cpu,
-				kmem_cache_cpu)[NR_KMEM_CACHE_CPU];
-
-static DEFINE_PER_CPU(struct kmem_cache_cpu *, kmem_cache_cpu_free);
-static cpumask_t kmem_cach_cpu_free_init_once = CPU_MASK_NONE;
-
-static struct kmem_cache_cpu *alloc_kmem_cache_cpu(struct kmem_cache *s,
-							int cpu, gfp_t flags)
-{
-	struct kmem_cache_cpu *c = per_cpu(kmem_cache_cpu_free, cpu);
-
-	if (c)
-		per_cpu(kmem_cache_cpu_free, cpu) =
-				(void *)c->freelist;
-	else {
-		/* Table overflow: So allocate ourselves */
-		c = kmalloc_node(
-			ALIGN(sizeof(struct kmem_cache_cpu), cache_line_size()),
-			flags, cpu_to_node(cpu));
-		if (!c)
-			return NULL;
-	}
-
-	init_kmem_cache_cpu(s, c);
-	return c;
-}
-
-static void free_kmem_cache_cpu(struct kmem_cache_cpu *c, int cpu)
-{
-	if (c < per_cpu(kmem_cache_cpu, cpu) ||
-			c > per_cpu(kmem_cache_cpu, cpu) + NR_KMEM_CACHE_CPU) {
-		kfree(c);
-		return;
-	}
-	c->freelist = (void *)per_cpu(kmem_cache_cpu_free, cpu);
-	per_cpu(kmem_cache_cpu_free, cpu) = c;
-}
-
-static void free_kmem_cache_cpus(struct kmem_cache *s)
-{
-	int cpu;
-
-	for_each_online_cpu(cpu) {
-		struct kmem_cache_cpu *c = get_cpu_slab(s, cpu);
-
-		if (c) {
-			s->cpu_slab[cpu] = NULL;
-			free_kmem_cache_cpu(c, cpu);
-		}
-	}
-}
-
 static int alloc_kmem_cache_cpus(struct kmem_cache *s, gfp_t flags)
 {
 	int cpu;
 
-	for_each_online_cpu(cpu) {
-		struct kmem_cache_cpu *c = get_cpu_slab(s, cpu);
-
-		if (c)
-			continue;
-
-		c = alloc_kmem_cache_cpu(s, cpu, flags);
-		if (!c) {
-			free_kmem_cache_cpus(s);
-			return 0;
-		}
-		s->cpu_slab[cpu] = c;
-	}
-	return 1;
-}
-
-/*
- * Initialize the per cpu array.
- */
-static void init_alloc_cpu_cpu(int cpu)
-{
-	int i;
+	s->cpu_slab = CPU_ALLOC(struct kmem_cache_cpu, flags);
 
-	if (cpu_isset(cpu, kmem_cach_cpu_free_init_once))
-		return;
-
-	for (i = NR_KMEM_CACHE_CPU - 1; i >= 0; i--)
-		free_kmem_cache_cpu(&per_cpu(kmem_cache_cpu, cpu)[i], cpu);
-
-	cpu_set(cpu, kmem_cach_cpu_free_init_once);
-}
-
-static void __init init_alloc_cpu(void)
-{
-	int cpu;
+	if (!s->cpu_slab)
+		return 0;
 
 	for_each_online_cpu(cpu)
-		init_alloc_cpu_cpu(cpu);
-  }
-
-#else
-static inline void free_kmem_cache_cpus(struct kmem_cache *s) {}
-static inline void init_alloc_cpu(void) {}
-
-static inline int alloc_kmem_cache_cpus(struct kmem_cache *s, gfp_t flags)
-{
-	init_kmem_cache_cpu(s, &s->cpu_slab);
+		init_kmem_cache_cpu(s, CPU_PTR(s->cpu_slab, cpu));
 	return 1;
 }
-#endif
 
 #ifdef CONFIG_NUMA
 /*
@@ -2452,9 +2326,8 @@ static inline int kmem_cache_close(struc
 	int node;
 
 	flush_all(s);
-
+	CPU_FREE(s->cpu_slab);
 	/* Attempt to free all objects */
-	free_kmem_cache_cpus(s);
 	for_each_node_state(node, N_NORMAL_MEMORY) {
 		struct kmem_cache_node *n = get_node(s, node);
 
@@ -2958,8 +2831,6 @@ void __init kmem_cache_init(void)
 	int i;
 	int caches = 0;
 
-	init_alloc_cpu();
-
 #ifdef CONFIG_NUMA
 	/*
 	 * Must first have the slab cache available for the allocations of the
@@ -3019,11 +2890,12 @@ void __init kmem_cache_init(void)
 	for (i = KMALLOC_SHIFT_LOW; i < PAGE_SHIFT; i++)
 		kmalloc_caches[i]. name =
 			kasprintf(GFP_KERNEL, "kmalloc-%d", 1 << i);
-
 #ifdef CONFIG_SMP
 	register_cpu_notifier(&slab_notifier);
-	kmem_size = offsetof(struct kmem_cache, cpu_slab) +
-				nr_cpu_ids * sizeof(struct kmem_cache_cpu *);
+#endif
+#ifdef CONFIG_NUMA
+	kmem_size = offsetof(struct kmem_cache, node) +
+				nr_node_ids * sizeof(struct kmem_cache_node *);
 #else
 	kmem_size = sizeof(struct kmem_cache);
 #endif
@@ -3120,7 +2992,7 @@ struct kmem_cache *kmem_cache_create(con
 		 * per cpu structures
 		 */
 		for_each_online_cpu(cpu)
-			get_cpu_slab(s, cpu)->objsize = s->objsize;
+			CPU_PTR(s->cpu_slab, cpu)->objsize = s->objsize;
 		s->inuse = max_t(int, s->inuse, ALIGN(size, sizeof(void *)));
 		up_write(&slub_lock);
 		if (sysfs_slab_alias(s, name))
@@ -3165,11 +3037,9 @@ static int __cpuinit slab_cpuup_callback
 	switch (action) {
 	case CPU_UP_PREPARE:
 	case CPU_UP_PREPARE_FROZEN:
-		init_alloc_cpu_cpu(cpu);
 		down_read(&slub_lock);
 		list_for_each_entry(s, &slab_caches, list)
-			s->cpu_slab[cpu] = alloc_kmem_cache_cpu(s, cpu,
-							GFP_KERNEL);
+			init_kmem_cache_cpu(s, CPU_PTR(s->cpu_slab, cpu));
 		up_read(&slub_lock);
 		break;
 
@@ -3179,13 +3049,9 @@ static int __cpuinit slab_cpuup_callback
 	case CPU_DEAD_FROZEN:
 		down_read(&slub_lock);
 		list_for_each_entry(s, &slab_caches, list) {
-			struct kmem_cache_cpu *c = get_cpu_slab(s, cpu);
-
 			local_irq_save(flags);
 			__flush_cpu_slab(s, cpu);
 			local_irq_restore(flags);
-			free_kmem_cache_cpu(c, cpu);
-			s->cpu_slab[cpu] = NULL;
 		}
 		up_read(&slub_lock);
 		break;
@@ -3657,7 +3523,7 @@ static unsigned long slab_objects(struct
 	for_each_possible_cpu(cpu) {
 		struct page *page;
 		int node;
-		struct kmem_cache_cpu *c = get_cpu_slab(s, cpu);
+		struct kmem_cache_cpu *c = CPU_PTR(s->cpu_slab, cpu);
 
 		if (!c)
 			continue;
@@ -3724,7 +3590,7 @@ static int any_slab_objects(struct kmem_
 	int cpu;
 
 	for_each_possible_cpu(cpu) {
-		struct kmem_cache_cpu *c = get_cpu_slab(s, cpu);
+		struct kmem_cache_cpu *c = CPU_PTR(s->cpu_slab, cpu);
 
 		if (c && c->page)
 			return 1;

-- 
