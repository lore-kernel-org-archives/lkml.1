Return-Path: <linux-kernel-owner+w=401wt.eu-S1760538AbYE3EH5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760538AbYE3EH5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 00:07:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755409AbYE3EAx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 00:00:53 -0400
Received: from relay2.sgi.com ([192.48.171.30]:56639 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753242AbYE3EAY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 00:00:24 -0400
Message-Id: <20080530040021.800522644@sgi.com>
References: <20080530035620.587204923@sgi.com>
User-Agent: quilt/0.46-1
Date: Thu, 29 May 2008 20:56:52 -0700
From: Christoph Lameter <clameter@sgi.com>
To: akpm@linux-foundation.org
Cc: linux-arch@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: David Miller <davem@davemloft.net>
Cc: Eric Dumazet <dada1@cosmosbay.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Mike Travis <travis@sgi.com>
Subject: [patch 32/41] cpu alloc: Use in slub
Content-Disposition: inline; filename=cpu_alloc_slub_conversion
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using cpu alloc removes the needs for the per cpu arrays in the kmem_cache struct.
These could get quite big if we have to support system of up to thousands of cpus.
The use of cpu_alloc means that:

1. The size of kmem_cache for SMP configuration shrinks since we will only
   need 1 pointer instead of NR_CPUS. The same pointer can be used by all
   processors. Reduces cache footprint of the allocator.

2. We can dynamically size kmem_cache according to the actual nodes in the
   system meaning less memory overhead for configurations that may potentially
   support up to 1k NUMA nodes.

3. We can remove the diddle widdle with allocating and releasing of
   kmem_cache_cpu structures when bringing up and shutting down cpus. The cpu
   alloc logic will do it all for us. Removes some portions of the cpu hotplug
   functionality.

4. Fastpath performance increases by 20%.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
---
 arch/x86/Kconfig         |    4 
 include/linux/slub_def.h |    6 -
 mm/slub.c                |  226 ++++++++++-------------------------------------
 3 files changed, 50 insertions(+), 186 deletions(-)

Index: linux-2.6/include/linux/slub_def.h
===================================================================
--- linux-2.6.orig/include/linux/slub_def.h	2008-05-27 23:56:24.000000000 -0700
+++ linux-2.6/include/linux/slub_def.h	2008-05-28 00:00:27.000000000 -0700
@@ -67,6 +67,7 @@
  * Slab cache management.
  */
 struct kmem_cache {
+	struct kmem_cache_cpu *cpu_slab;
 	/* Used for retriving partial slabs etc */
 	unsigned long flags;
 	int size;		/* The size of an object including meta data */
@@ -101,11 +102,6 @@
 	int remote_node_defrag_ratio;
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
--- linux-2.6.orig/mm/slub.c	2008-05-27 23:56:24.000000000 -0700
+++ linux-2.6/mm/slub.c	2008-05-28 00:00:27.000000000 -0700
@@ -258,15 +258,6 @@
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
 /* Verify that a pointer has an address that is valid within a slab page */
 static inline int check_valid_pointer(struct kmem_cache *s,
 				struct page *page, const void *object)
@@ -1120,7 +1111,7 @@
 		if (!page)
 			return NULL;
 
-		stat(get_cpu_slab(s, raw_smp_processor_id()), ORDER_FALLBACK);
+		stat(THIS_CPU(s->cpu_slab), ORDER_FALLBACK);
 	}
 	page->objects = oo_objects(oo);
 	mod_zone_page_state(page_zone(page),
@@ -1397,7 +1388,7 @@
 static void unfreeze_slab(struct kmem_cache *s, struct page *page, int tail)
 {
 	struct kmem_cache_node *n = get_node(s, page_to_nid(page));
-	struct kmem_cache_cpu *c = get_cpu_slab(s, smp_processor_id());
+	struct kmem_cache_cpu *c = THIS_CPU(s->cpu_slab);
 
 	ClearSlabFrozen(page);
 	if (page->inuse) {
@@ -1428,7 +1419,7 @@
 			slab_unlock(page);
 		} else {
 			slab_unlock(page);
-			stat(get_cpu_slab(s, raw_smp_processor_id()), FREE_SLAB);
+			stat(__THIS_CPU(s->cpu_slab), FREE_SLAB);
 			discard_slab(s, page);
 		}
 	}
@@ -1481,7 +1472,7 @@
  */
 static inline void __flush_cpu_slab(struct kmem_cache *s, int cpu)
 {
-	struct kmem_cache_cpu *c = get_cpu_slab(s, cpu);
+	struct kmem_cache_cpu *c = CPU_PTR(s->cpu_slab, cpu);
 
 	if (likely(c && c->page))
 		flush_slab(s, c);
@@ -1496,15 +1487,7 @@
 
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
@@ -1520,6 +1503,15 @@
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
 /*
  * Slow path. The lockless freelist is empty or we need to perform
  * debugging duties.
@@ -1592,7 +1584,7 @@
 		local_irq_disable();
 
 	if (new) {
-		c = get_cpu_slab(s, smp_processor_id());
+		c = __THIS_CPU(s->cpu_slab);
 		stat(c, ALLOC_SLAB);
 		if (c->page)
 			flush_slab(s, c);
@@ -1630,20 +1622,20 @@
 	unsigned long flags;
 
 	local_irq_save(flags);
-	c = get_cpu_slab(s, smp_processor_id());
-	if (unlikely(!c->freelist || !node_match(c, node)))
+	c = __THIS_CPU(s->cpu_slab);
+	object = c->freelist;
+	if (unlikely(!object || !node_match(c, node)))
 
 		object = __slab_alloc(s, gfpflags, node, addr, c);
 
 	else {
-		object = c->freelist;
 		c->freelist = object[c->offset];
 		stat(c, ALLOC_FASTPATH);
 	}
 	local_irq_restore(flags);
 
 	if (unlikely((gfpflags & __GFP_ZERO) && object))
-		memset(object, 0, c->objsize);
+		memset(object, 0, s->objsize);
 
 	return object;
 }
@@ -1677,7 +1669,7 @@
 	void **object = (void *)x;
 	struct kmem_cache_cpu *c;
 
-	c = get_cpu_slab(s, raw_smp_processor_id());
+	c = __THIS_CPU(s->cpu_slab);
 	stat(c, FREE_SLOWPATH);
 	slab_lock(page);
 
@@ -1748,7 +1740,7 @@
 	unsigned long flags;
 
 	local_irq_save(flags);
-	c = get_cpu_slab(s, smp_processor_id());
+	c = __THIS_CPU(s->cpu_slab);
 	debug_check_no_locks_freed(object, c->objsize);
 	if (!(s->flags & SLAB_DEBUG_OBJECTS))
 		debug_check_no_obj_freed(object, s->objsize);
@@ -1962,130 +1954,19 @@
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
-
-	if (cpu_isset(cpu, kmem_cach_cpu_free_init_once))
-		return;
-
-	for (i = NR_KMEM_CACHE_CPU - 1; i >= 0; i--)
-		free_kmem_cache_cpu(&per_cpu(kmem_cache_cpu, cpu)[i], cpu);
+	s->cpu_slab = CPU_ALLOC(struct kmem_cache_cpu, flags);
 
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
@@ -2446,9 +2327,8 @@
 	int node;
 
 	flush_all(s);
-
+	CPU_FREE(s->cpu_slab);
 	/* Attempt to free all objects */
-	free_kmem_cache_cpus(s);
 	for_each_node_state(node, N_NORMAL_MEMORY) {
 		struct kmem_cache_node *n = get_node(s, node);
 
@@ -2966,8 +2846,6 @@
 	int i;
 	int caches = 0;
 
-	init_alloc_cpu();
-
 #ifdef CONFIG_NUMA
 	/*
 	 * Must first have the slab cache available for the allocations of the
@@ -3027,11 +2905,12 @@
 	for (i = KMALLOC_SHIFT_LOW; i <= PAGE_SHIFT; i++)
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
@@ -3128,7 +3007,7 @@
 		 * per cpu structures
 		 */
 		for_each_online_cpu(cpu)
-			get_cpu_slab(s, cpu)->objsize = s->objsize;
+			CPU_PTR(s->cpu_slab, cpu)->objsize = s->objsize;
 
 		s->inuse = max_t(int, s->inuse, ALIGN(size, sizeof(void *)));
 		up_write(&slub_lock);
@@ -3176,11 +3055,9 @@
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
 
@@ -3190,13 +3067,9 @@
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
@@ -3687,7 +3560,7 @@
 		int cpu;
 
 		for_each_possible_cpu(cpu) {
-			struct kmem_cache_cpu *c = get_cpu_slab(s, cpu);
+			struct kmem_cache_cpu *c = CPU_PTR(s->cpu_slab, cpu);
 
 			if (!c || c->node < 0)
 				continue;
@@ -4092,7 +3965,7 @@
 		return -ENOMEM;
 
 	for_each_online_cpu(cpu) {
-		unsigned x = get_cpu_slab(s, cpu)->stat[si];
+		unsigned x = CPU_PTR(s->cpu_slab, cpu)->stat[si];
 
 		data[cpu] = x;
 		sum += x;

-- 
