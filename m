Return-Path: <linux-kernel-owner+w=401wt.eu-S1760759AbXKAAEg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760759AbXKAAEg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 20:04:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756158AbXKAADU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 20:03:20 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:40570 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754502AbXKAADL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 20:03:11 -0400
Message-Id: <20071101000310.674476000@sgi.com>
References: <20071101000211.970501947@sgi.com>
User-Agent: quilt/0.46-1
Date: Wed, 31 Oct 2007 17:02:16 -0700
From: Christoph Lameter <clameter@sgi.com>
To: akpm@linux-foundation.org
Cc: linux-arch@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Subject: [patch 5/7] SLUB: Use allocpercpu to allocate per cpu data instead of running our own per cpu allocator
Content-Disposition: inline; filename=slub_alloc
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Using allocpercpu removes the needs for the per cpu arrays in the kmem_cache struct.
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
   logic will do it all for us.

4. Fastpath performance increases by another 20% vs. the earlier improvements.
   Instead of having fastpath with 40-50 cycles we are now in the 30-40 range.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 include/linux/slub_def.h |   11 ++--
 mm/slub.c                |  125 ++++-------------------------------------------
 2 files changed, 18 insertions(+), 118 deletions(-)

Index: linux-2.6/include/linux/slub_def.h
===================================================================
--- linux-2.6.orig/include/linux/slub_def.h	2007-10-30 16:34:41.000000000 -0700
+++ linux-2.6/include/linux/slub_def.h	2007-10-31 09:23:26.000000000 -0700
@@ -34,6 +34,12 @@ struct kmem_cache_node {
  * Slab cache management.
  */
 struct kmem_cache {
+#ifdef CONFIG_SMP
+	/* Per cpu pointer usable for any cpu */
+	struct kmem_cache_cpu *cpu_slab;
+#else
+	struct kmem_cache_cpu cpu_slab;
+#endif
 	/* Used for retriving partial slabs etc */
 	unsigned long flags;
 	int size;		/* The size of an object including meta data */
@@ -63,11 +69,6 @@ struct kmem_cache {
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
--- linux-2.6.orig/mm/slub.c	2007-10-30 22:52:24.000000000 -0700
+++ linux-2.6/mm/slub.c	2007-10-31 09:45:59.000000000 -0700
@@ -242,7 +242,7 @@ static inline struct kmem_cache_node *ge
 static inline struct kmem_cache_cpu *get_cpu_slab(struct kmem_cache *s, int cpu)
 {
 #ifdef CONFIG_SMP
-	return s->cpu_slab[cpu];
+	return percpu_ptr(s->cpu_slab, cpu);
 #else
 	return &s->cpu_slab;
 #endif
@@ -2032,119 +2032,25 @@ static void init_kmem_cache_node(struct 
 }
 
 #ifdef CONFIG_SMP
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
 static void free_kmem_cache_cpus(struct kmem_cache *s)
 {
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
+	percpu_free(s->cpu_slab);
 }
 
 static int alloc_kmem_cache_cpus(struct kmem_cache *s, gfp_t flags)
 {
 	int cpu;
 
-	for_each_online_cpu(cpu) {
-		struct kmem_cache_cpu *c = get_cpu_slab(s, cpu);
+	s->cpu_slab = alloc_percpu(struct kmem_cache_cpu);
 
-		if (c)
-			continue;
+	if (!s->cpu_slab)
+		return 0;
 
-		c = alloc_kmem_cache_cpu(s, cpu, flags);
-		if (!c) {
-			free_kmem_cache_cpus(s);
-			return 0;
-		}
-		s->cpu_slab[cpu] = c;
-	}
+	for_each_online_cpu(cpu)
+		init_kmem_cache_cpu(s, get_cpu_slab(s, cpu));
 	return 1;
 }
 
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
-
-	for_each_online_cpu(cpu)
-		init_alloc_cpu_cpu(cpu);
-  }
-
 #else
 static inline void free_kmem_cache_cpus(struct kmem_cache *s) {}
 static inline void init_alloc_cpu(void) {}
@@ -2974,8 +2880,6 @@ void __init kmem_cache_init(void)
 	int i;
 	int caches = 0;
 
-	init_alloc_cpu();
-
 #ifdef CONFIG_NUMA
 	/*
 	 * Must first have the slab cache available for the allocations of the
@@ -3035,11 +2939,12 @@ void __init kmem_cache_init(void)
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
@@ -3181,11 +3086,9 @@ static int __cpuinit slab_cpuup_callback
 	switch (action) {
 	case CPU_UP_PREPARE:
 	case CPU_UP_PREPARE_FROZEN:
-		init_alloc_cpu_cpu(cpu);
 		down_read(&slub_lock);
 		list_for_each_entry(s, &slab_caches, list)
-			s->cpu_slab[cpu] = alloc_kmem_cache_cpu(s, cpu,
-							GFP_KERNEL);
+			init_kmem_cache_cpu(s, get_cpu_slab(s, cpu));
 		up_read(&slub_lock);
 		break;
 
@@ -3195,13 +3098,9 @@ static int __cpuinit slab_cpuup_callback
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

-- 
