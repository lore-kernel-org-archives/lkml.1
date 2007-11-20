Return-Path: <linux-kernel-owner+w=401wt.eu-S1757055AbXKTBO7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757055AbXKTBO7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 20:14:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755751AbXKTBNj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 20:13:39 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:36848 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752964AbXKTBNd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 20:13:33 -0500
Message-Id: <20071120011332.652677710@sgi.com>
References: <20071120011132.143632442@sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 19 Nov 2007 17:11:36 -0800
From: clameter@sgi.com
From: Christoph Lameter <clameter@sgi.com>
To: ak@suse.de
Cc: akpm@linux-foundation.org
Cc: travis@sgi.com
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: linux-kernel@vger.kernel.org
Subject: [rfc 04/45] cpu alloc: Use in SLUB
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

Remove the CONFIG_FAST_CMPXCHG version since this patch makes SLUB use CPU ops
instead.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
---
 arch/x86/Kconfig         |    4 
 include/linux/slub_def.h |    6 -
 mm/slub.c                |  229 ++++++++++-------------------------------------
 3 files changed, 52 insertions(+), 187 deletions(-)

Index: linux-2.6/include/linux/slub_def.h
===================================================================
--- linux-2.6.orig/include/linux/slub_def.h	2007-11-19 15:45:08.270140279 -0800
+++ linux-2.6/include/linux/slub_def.h	2007-11-19 15:53:25.869890760 -0800
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
--- linux-2.6.orig/mm/slub.c	2007-11-19 15:45:08.278140252 -0800
+++ linux-2.6/mm/slub.c	2007-11-19 15:54:10.513640214 -0800
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
@@ -1511,6 +1494,15 @@ static inline int node_match(struct kmem
 	return 1;
 }
 
+static inline int cpu_node_match(struct kmem_cache_cpu *c, int node)
+{
+#ifdef CONFIG_NUMA
+	if (node != -1 && __CPU_READ(c->node) != node)
+		return 0;
+#endif
+	return 1;
+}
+
 /* Allocate a new slab and make it the current cpu slab */
 static noinline unsigned long get_new_slab(struct kmem_cache *s,
 	struct kmem_cache_cpu **pc, gfp_t gfpflags, int node)
@@ -1529,7 +1521,7 @@ static noinline unsigned long get_new_sl
 	if (!page)
 		return 0;
 
-	*pc = c = get_cpu_slab(s, smp_processor_id());
+	*pc = c = THIS_CPU(s->cpu_slab);
 	if (c->page)
 		flush_slab(s, c);
 	c->page = page;
@@ -1554,16 +1546,18 @@ static noinline unsigned long get_new_sl
  * we need to allocate a new slab. This is slowest path since we may sleep.
  */
 static void *__slab_alloc(struct kmem_cache *s,
-		gfp_t gfpflags, int node, void *addr, struct kmem_cache_cpu *c)
+		gfp_t gfpflags, int node, void *addr)
 {
 	void **object;
 	unsigned long state;
-#ifdef CONFIG_FAST_CMPXCHG_LOCAL
+	struct kmem_cache_cpu *c;
+#ifdef CONFIG_FAST_CPU_OPS
 	unsigned long flags;
 
 	local_irq_save(flags);
 	preempt_enable_no_resched();
 #endif
+	c = THIS_CPU(s->cpu_slab);
 	if (likely(c->page)) {
 		state = slab_lock(c->page);
 
@@ -1597,7 +1591,7 @@ load_freelist:
 unlock_out:
 	slab_unlock(c->page, state);
 out:
-#ifdef CONFIG_FAST_CMPXCHG_LOCAL
+#ifdef CONFIG_FAST_CPU_OPS
 	preempt_disable();
 	local_irq_restore(flags);
 #endif
@@ -1640,26 +1634,24 @@ static void __always_inline *slab_alloc(
 	void **object;
 	struct kmem_cache_cpu *c;
 
-#ifdef CONFIG_FAST_CMPXCHG_LOCAL
-	c = get_cpu_slab(s, get_cpu());
+#ifdef CONFIG_FAST_CPU_OPS
+	c = s->cpu_slab;
 	do {
-		object = c->freelist;
-		if (unlikely(is_end(object) || !node_match(c, node))) {
-			object = __slab_alloc(s, gfpflags, node, addr, c);
-			if (unlikely(!object)) {
-				put_cpu();
+		object = __CPU_READ(c->freelist);
+		if (unlikely(is_end(object) ||
+					!cpu_node_match(c, node))) {
+			object = __slab_alloc(s, gfpflags, node, addr);
+			if (unlikely(!object))
 				goto out;
-			}
 			break;
 		}
-	} while (cmpxchg_local(&c->freelist, object, object[c->offset])
-								!= object);
-	put_cpu();
+	} while (CPU_CMPXCHG(c->freelist, object,
+			object[__CPU_READ(c->offset)]) != object);
 #else
 	unsigned long flags;
 
 	local_irq_save(flags);
-	c = get_cpu_slab(s, smp_processor_id());
+	c = THIS_CPU(s->cpu_slab);
 	if (unlikely((is_end(c->freelist)) || !node_match(c, node))) {
 
 		object = __slab_alloc(s, gfpflags, node, addr, c);
@@ -1709,7 +1701,7 @@ static void __slab_free(struct kmem_cach
 	void **object = (void *)x;
 	unsigned long state;
 
-#ifdef CONFIG_FAST_CMPXCHG_LOCAL
+#ifdef CONFIG_FAST_CPU_OPS
 	unsigned long flags;
 
 	local_irq_save(flags);
@@ -1739,7 +1731,7 @@ checks_ok:
 
 out_unlock:
 	slab_unlock(page, state);
-#ifdef CONFIG_FAST_CMPXCHG_LOCAL
+#ifdef CONFIG_FAST_CPU_OPS
 	local_irq_restore(flags);
 #endif
 	return;
@@ -1752,7 +1744,7 @@ slab_empty:
 		remove_partial(s, page);
 
 	slab_unlock(page, state);
-#ifdef CONFIG_FAST_CMPXCHG_LOCAL
+#ifdef CONFIG_FAST_CPU_OPS
 	local_irq_restore(flags);
 #endif
 	discard_slab(s, page);
@@ -1781,13 +1773,13 @@ static void __always_inline slab_free(st
 	void **object = (void *)x;
 	struct kmem_cache_cpu *c;
 
-#ifdef CONFIG_FAST_CMPXCHG_LOCAL
+#ifdef CONFIG_FAST_CPU_OPS
 	void **freelist;
 
-	c = get_cpu_slab(s, get_cpu());
+	c = s->cpu_slab;
 	debug_check_no_locks_freed(object, s->objsize);
 	do {
-		freelist = c->freelist;
+		freelist = __CPU_READ(c->freelist);
 		barrier();
 		/*
 		 * If the compiler would reorder the retrieval of c->page to
@@ -1800,19 +1792,19 @@ static void __always_inline slab_free(st
 		 * then any change of cpu_slab will cause the cmpxchg to fail
 		 * since the freelist pointers are unique per slab.
 		 */
-		if (unlikely(page != c->page || c->node < 0)) {
-			__slab_free(s, page, x, addr, c->offset);
+		if (unlikely(page != __CPU_READ(c->page) ||
+					__CPU_READ(c->node) < 0)) {
+			__slab_free(s, page, x, addr, __CPU_READ(c->offset));
 			break;
 		}
-		object[c->offset] = freelist;
-	} while (cmpxchg_local(&c->freelist, freelist, object) != freelist);
-	put_cpu();
+		object[__CPU_READ(c->offset)] = freelist;
+	} while (CPU_CMPXCHG(c->freelist, freelist, object) != freelist);
 #else
 	unsigned long flags;
 
 	local_irq_save(flags);
 	debug_check_no_locks_freed(object, s->objsize);
-	c = get_cpu_slab(s, smp_processor_id());
+	c = THIS_CPU(s->cpu_slab);
 	if (likely(page == c->page && c->node >= 0)) {
 		object[c->offset] = c->freelist;
 		c->freelist = object;
@@ -2015,130 +2007,19 @@ static void init_kmem_cache_node(struct 
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
+	s->cpu_slab = CPU_ALLOC(struct kmem_cache_cpu, flags);
 
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
-
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
@@ -2452,9 +2333,8 @@ static inline int kmem_cache_close(struc
 	int node;
 
 	flush_all(s);
-
+	CPU_FREE(s->cpu_slab);
 	/* Attempt to free all objects */
-	free_kmem_cache_cpus(s);
 	for_each_node_state(node, N_NORMAL_MEMORY) {
 		struct kmem_cache_node *n = get_node(s, node);
 
@@ -2958,8 +2838,6 @@ void __init kmem_cache_init(void)
 	int i;
 	int caches = 0;
 
-	init_alloc_cpu();
-
 #ifdef CONFIG_NUMA
 	/*
 	 * Must first have the slab cache available for the allocations of the
@@ -3019,11 +2897,12 @@ void __init kmem_cache_init(void)
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
@@ -3120,7 +2999,7 @@ struct kmem_cache *kmem_cache_create(con
 		 * per cpu structures
 		 */
 		for_each_online_cpu(cpu)
-			get_cpu_slab(s, cpu)->objsize = s->objsize;
+			CPU_PTR(s->cpu_slab, cpu)->objsize = s->objsize;
 		s->inuse = max_t(int, s->inuse, ALIGN(size, sizeof(void *)));
 		up_write(&slub_lock);
 		if (sysfs_slab_alias(s, name))
@@ -3165,11 +3044,9 @@ static int __cpuinit slab_cpuup_callback
 	switch (action) {
 	case CPU_UP_PREPARE:
 	case CPU_UP_PREPARE_FROZEN:
-		init_alloc_cpu_cpu(cpu);
 		down_read(&slub_lock);
 		list_for_each_entry(s, &slab_caches, list)
-			s->cpu_slab[cpu] = alloc_kmem_cache_cpu(s, cpu,
-							GFP_KERNEL);
+			init_kmem_cache_cpu(s, __CPU_PTR(s->cpu_slab, cpu));
 		up_read(&slub_lock);
 		break;
 
@@ -3179,13 +3056,9 @@ static int __cpuinit slab_cpuup_callback
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
@@ -3657,7 +3530,7 @@ static unsigned long slab_objects(struct
 	for_each_possible_cpu(cpu) {
 		struct page *page;
 		int node;
-		struct kmem_cache_cpu *c = get_cpu_slab(s, cpu);
+		struct kmem_cache_cpu *c = CPU_PTR(s->cpu_slab, cpu);
 
 		if (!c)
 			continue;
@@ -3724,7 +3597,7 @@ static int any_slab_objects(struct kmem_
 	int cpu;
 
 	for_each_possible_cpu(cpu) {
-		struct kmem_cache_cpu *c = get_cpu_slab(s, cpu);
+		struct kmem_cache_cpu *c = CPU_PTR(s->cpu_slab, cpu);
 
 		if (c && c->page)
 			return 1;
Index: linux-2.6/arch/x86/Kconfig
===================================================================
--- linux-2.6.orig/arch/x86/Kconfig	2007-11-19 15:53:55.529390403 -0800
+++ linux-2.6/arch/x86/Kconfig	2007-11-19 15:54:10.509139813 -0800
@@ -112,10 +112,6 @@ config GENERIC_TIME_VSYSCALL
 	bool
 	default X86_64
 
-config FAST_CMPXCHG_LOCAL
-	bool
-	default y
-
 config ZONE_DMA32
 	bool
 	default X86_64

-- 
