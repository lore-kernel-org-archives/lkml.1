Return-Path: <linux-kernel-owner+w=401wt.eu-S1757833AbXGNQDy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757833AbXGNQDy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2007 12:03:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757630AbXGNQDK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jul 2007 12:03:10 -0400
Received: from mx1.redhat.com ([66.187.233.31]:45870 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753351AbXGNQDE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2007 12:03:04 -0400
Message-Id: <20070714175840.424675000@chello.nl>
References: <20070714175733.194012000@chello.nl>
User-Agent: quilt/0.45-1
Date: Sat, 14 Jul 2007 19:57:38 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Oleg Nesterov <oleg@tv-sign.ru>, Steven Rostedt <rostedt@goodmis.org>,
       Christoph Lameter <clameter@sgi.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH -rt 5/5] slub: -rt port
Content-Disposition: inline; filename=slub-rt.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 init/Kconfig |    1 
 mm/slub.c    |  260 ++++++++++++++++++++++++++++++++++++++++++++++++-----------
 2 files changed, 214 insertions(+), 47 deletions(-)

Index: linux-2.6/mm/slub.c
===================================================================
--- linux-2.6.orig/mm/slub.c
+++ linux-2.6/mm/slub.c
@@ -20,6 +20,7 @@
 #include <linux/mempolicy.h>
 #include <linux/ctype.h>
 #include <linux/kallsyms.h>
+#include <linux/pagemap.h>
 
 /*
  * Lock order:
@@ -99,6 +100,8 @@
  * 			the fast path and disables lockless freelists.
  */
 
+#ifndef CONFIG_PREEMPT_RT
+
 #define FROZEN (1 << PG_active)
 
 #ifdef CONFIG_SLUB_DEBUG
@@ -137,6 +140,46 @@ static inline void ClearSlabDebug(struct
 	page->flags &= ~SLABDEBUG;
 }
 
+#else /* CONFIG_PREEMPT_RT */
+/*
+ * when the allocator is preemptible these operations might be concurrent with
+ * lock_page(), and hence need atomic ops.
+ */
+
+#define PG_frozen		PG_active
+#define PG_debug		PG_error
+
+static inline int SlabFrozen(struct page *page)
+{
+	return test_bit(PG_frozen, &page->flags);
+}
+
+static inline void SetSlabFrozen(struct page *page)
+{
+	set_bit(PG_frozen, &page->flags);
+}
+
+static inline void ClearSlabFrozen(struct page *page)
+{
+	clear_bit(PG_frozen, &page->flags);
+}
+
+static inline int SlabDebug(struct page *page)
+{
+	return test_bit(PG_debug, &page->flags);
+}
+
+static inline void SetSlabDebug(struct page *page)
+{
+	set_bit(PG_debug, &page->flags);
+}
+
+static inline void ClearSlabDebug(struct page *page)
+{
+	clear_bit(PG_debug, &page->flags);
+}
+#endif
+
 /*
  * Issues still to be resolved:
  *
@@ -1021,7 +1064,7 @@ static struct page *new_slab(struct kmem
 	BUG_ON(flags & ~(GFP_DMA | GFP_LEVEL_MASK));
 
 	if (flags & __GFP_WAIT)
-		local_irq_enable();
+		local_irq_enable_nort();
 
 	page = allocate_slab(s, flags & GFP_LEVEL_MASK, node);
 	if (!page)
@@ -1057,7 +1100,7 @@ static struct page *new_slab(struct kmem
 	page->inuse = 0;
 out:
 	if (flags & __GFP_WAIT)
-		local_irq_disable();
+		local_irq_disable_nort();
 	return page;
 }
 
@@ -1117,6 +1160,7 @@ static void discard_slab(struct kmem_cac
 /*
  * Per slab locking using the pagelock
  */
+#ifndef CONFIG_PREEMPT_RT
 static __always_inline void slab_lock(struct page *page)
 {
 	bit_spin_lock(PG_locked, &page->flags);
@@ -1134,6 +1178,22 @@ static __always_inline int slab_trylock(
 	rc = bit_spin_trylock(PG_locked, &page->flags);
 	return rc;
 }
+#else
+static __always_inline void slab_lock(struct page *page)
+{
+	lock_page(page);
+}
+
+static __always_inline void slab_unlock(struct page *page)
+{
+	unlock_page(page);
+}
+
+static __always_inline int slab_trylock(struct page *page)
+{
+	return !TestSetPageLocked(page);
+}
+#endif
 
 /*
  * Management of partially allocated slabs
@@ -1154,8 +1214,7 @@ static void add_partial(struct kmem_cach
 	spin_unlock(&n->list_lock);
 }
 
-static void remove_partial(struct kmem_cache *s,
-						struct page *page)
+static void remove_partial(struct kmem_cache *s, struct page *page)
 {
 	struct kmem_cache_node *n = get_node(s, page_to_nid(page));
 
@@ -1282,6 +1341,7 @@ static void unfreeze_slab(struct kmem_ca
 {
 	struct kmem_cache_node *n = get_node(s, page_to_nid(page));
 
+	BUG_ON(!SlabFrozen(page));
 	ClearSlabFrozen(page);
 	if (page->inuse) {
 
@@ -1310,29 +1370,52 @@ static void unfreeze_slab(struct kmem_ca
 	}
 }
 
+static void **get_lockless_object(struct page *page)
+{
+	void **object;
+
+again:
+	object = page->lockless_freelist;
+	if (object && __local_cmpxchg(&page->lockless_freelist,
+				object, object[page->offset]) != object)
+		goto again;
+
+	return object;
+}
+
 /*
  * Remove the cpu slab
  */
 static void deactivate_slab(struct kmem_cache *s, struct page *page, int cpu)
 {
 	/*
+	 * take away the slab page before merging the lockless free list into
+	 * the regular free list to ensure that no new entries are put on the
+	 * lockless list between the merge and removal.
+	 */
+	BUG_ON(page != s->cpu_slab[cpu]);
+	s->cpu_slab[cpu] = NULL;
+	barrier();
+
+	/*
 	 * Merge cpu freelist into freelist. Typically we get here
 	 * because both freelists are empty. So this is unlikely
 	 * to occur.
 	 */
-	while (unlikely(page->lockless_freelist)) {
+	for (;;) {
 		void **object;
 
 		/* Retrieve object from cpu_freelist */
-		object = page->lockless_freelist;
-		page->lockless_freelist = page->lockless_freelist[page->offset];
+		object = get_lockless_object(page);
+		if (likely(!object))
+			break;
 
 		/* And put onto the regular freelist */
 		object[page->offset] = page->freelist;
 		page->freelist = object;
 		page->inuse--;
 	}
-	s->cpu_slab[cpu] = NULL;
+
 	unfreeze_slab(s, page);
 }
 
@@ -1354,6 +1437,55 @@ static void __flush_cpu_slab(struct kmem
 		flush_slab(s, page, cpu);
 }
 
+#ifdef CONFIG_PREEMPT_RT
+struct slab_work_struct {
+	struct work_struct work;
+	struct kmem_cache *s;
+};
+
+static struct workqueue_struct *flush_slab_workqueue;
+static DEFINE_PER_CPU(struct slab_work_struct, slab_works);
+static DEFINE_MUTEX(flush_slab_mutex); /* XXX kill this */
+
+static int __init flush_cpu_slab_init(void)
+{
+	flush_slab_workqueue = create_workqueue("slub_flushd");
+	if (!flush_slab_workqueue)
+		panic("Failed to create slub_flushd\n");
+
+	return 0;
+}
+
+core_initcall(flush_cpu_slab_init);
+
+static void flush_cpu_slab_wq(struct work_struct *work)
+{
+	struct slab_work_struct *sw;
+	int cpu = smp_processor_id();
+
+	sw = container_of(work, struct slab_work_struct, work);
+	__flush_cpu_slab(sw->s, cpu);
+}
+
+static void flush_all(struct kmem_cache *s)
+{
+	int cpu;
+	struct workqueue_struct *wq = flush_slab_workqueue;
+
+	mutex_lock(&flush_slab_mutex);
+	for_each_online_cpu(cpu) {
+		struct slab_work_struct *sw = &per_cpu(slab_works, cpu);
+
+		INIT_WORK(&sw->work, flush_cpu_slab_wq);
+		sw->s = s;
+		queue_work_cpu(wq, &sw->work, cpu);
+	}
+	flush_workqueue(wq);
+	mutex_unlock(&flush_slab_mutex);
+}
+
+#else
+
 static void flush_cpu_slab(void *d)
 {
 	struct kmem_cache *s = d;
@@ -1374,6 +1506,7 @@ static void flush_all(struct kmem_cache 
 	local_irq_restore(flags);
 #endif
 }
+#endif
 
 /*
  * Slow path. The lockless freelist is empty or we need to perform
@@ -1396,13 +1529,24 @@ static void *__slab_alloc(struct kmem_ca
 		gfp_t gfpflags, int node, void *addr, struct page *page)
 {
 	void **object;
+	unsigned long flags;
 	int cpu = smp_processor_id();
 
+	local_irq_save_nort(flags);
+
+again:
 	if (!page)
 		goto new_slab;
 
 	slab_lock(page);
-	if (unlikely(node != -1 && page_to_nid(page) != node))
+	if (!SlabFrozen(page) || page != s->cpu_slab[cpu]) {
+		slab_unlock(page);
+		page = s->cpu_slab[cpu];
+		goto again;
+	}
+
+	if (unlikely((node != -1 && page_to_nid(page) != node) ||
+			page->lockless_freelist))  /* validate the need for this check */
 		goto another_slab;
 load_freelist:
 	object = page->freelist;
@@ -1415,7 +1559,9 @@ load_freelist:
 	page->lockless_freelist = object[page->offset];
 	page->inuse = s->objects;
 	page->freelist = NULL;
+out:
 	slab_unlock(page);
+	local_irq_restore_nort(flags);
 	return object;
 
 another_slab:
@@ -1424,40 +1570,42 @@ another_slab:
 new_slab:
 	page = get_partial(s, gfpflags, node);
 	if (page) {
-		s->cpu_slab[cpu] = page;
+		struct page *cur_page;
+
+		cur_page = __local_cmpxchg(&s->cpu_slab[cpu], NULL, page);
+		if (cur_page) {
+			/*
+			 * Someone else populated the cpu_slab while we got
+			 * preempted. We want the current one since its cache
+			 * hot
+			 */
+			unfreeze_slab(s, page);
+			page = cur_page;
+			goto again;
+		}
 		goto load_freelist;
 	}
 
 	page = new_slab(s, gfpflags, node);
 	if (page) {
-		cpu = smp_processor_id();
-		if (s->cpu_slab[cpu]) {
+		struct page *cur_page;
+
+		slab_lock(page);
+		SetSlabFrozen(page);
+		cur_page = __local_cmpxchg(&s->cpu_slab[cpu], NULL, page);
+		if (cur_page) {
 			/*
-			 * Someone else populated the cpu_slab while we
-			 * enabled interrupts, or we have gotten scheduled
-			 * on another cpu. The page may not be on the
-			 * requested node even if __GFP_THISNODE was
-			 * specified. So we need to recheck.
+			 * Someone else populated the cpu_slab while we got
+			 * preempted. We want the current one since its cache
+			 * hot
 			 */
-			if (node == -1 ||
-				page_to_nid(s->cpu_slab[cpu]) == node) {
-				/*
-				 * Current cpuslab is acceptable and we
-				 * want the current one since its cache hot
-				 */
-				discard_slab(s, page);
-				page = s->cpu_slab[cpu];
-				slab_lock(page);
-				goto load_freelist;
-			}
-			/* New slab does not fit our expectations */
-			flush_slab(s, s->cpu_slab[cpu], cpu);
+			unfreeze_slab(s, page);
+			page = cur_page;
+			goto again;
 		}
-		slab_lock(page);
-		SetSlabFrozen(page);
-		s->cpu_slab[cpu] = page;
 		goto load_freelist;
 	}
+	local_irq_restore_nort(flags);
 	return NULL;
 debug:
 	object = page->freelist;
@@ -1466,8 +1614,7 @@ debug:
 
 	page->inuse++;
 	page->freelist = object[page->offset];
-	slab_unlock(page);
-	return object;
+	goto out;
 }
 
 /*
@@ -1487,18 +1634,20 @@ static void __always_inline *slab_alloc(
 	void **object;
 	unsigned long flags;
 
-	local_irq_save(flags);
+	__local_begin(flags);
 	page = s->cpu_slab[smp_processor_id()];
 	if (unlikely(!page || !page->lockless_freelist ||
-			(node != -1 && page_to_nid(page) != node)))
+			(node != -1 && page_to_nid(page) != node))) {
 
+do_alloc:
 		object = __slab_alloc(s, gfpflags, node, addr, page);
 
-	else {
-		object = page->lockless_freelist;
-		page->lockless_freelist = object[page->offset];
+	} else {
+		object = get_lockless_object(page);
+		if (unlikely(!object))
+			goto do_alloc;
 	}
-	local_irq_restore(flags);
+	__local_end(flags);
 	return object;
 }
 
@@ -1529,7 +1678,9 @@ static void __slab_free(struct kmem_cach
 {
 	void *prior;
 	void **object = (void *)x;
+	unsigned long flags;
 
+	local_irq_save_nort(flags);
 	slab_lock(page);
 
 	if (unlikely(SlabDebug(page)))
@@ -1555,6 +1706,7 @@ checks_ok:
 
 out_unlock:
 	slab_unlock(page);
+	local_irq_restore_nort(flags);
 	return;
 
 slab_empty:
@@ -1566,6 +1718,7 @@ slab_empty:
 
 	slab_unlock(page);
 	discard_slab(s, page);
+	local_irq_restore_nort(flags);
 	return;
 
 debug:
@@ -1591,15 +1744,30 @@ static void __always_inline slab_free(st
 	void **object = (void *)x;
 	unsigned long flags;
 
-	local_irq_save(flags);
+	__local_begin(flags);
+	/*
+	 * We have to either take slab_lock(page) or disable preemption while
+	 * trying to add to the lockless freelist because we have to guarantee
+	 * page == s->cpu_slab[cpu] during the operation.
+	 *
+	 * fix this by allowing non active slabs to have a lockless_freelist?
+	 * cannot do since Christoph is about to pull lockless_freelist from
+	 * the struct page.
+	 *
+	 * preempt_disable() seems cheapest for these few instructions vs the
+	 * atomic ops involved with slab_lock()
+	 */
+	preempt_disable();
 	if (likely(page == s->cpu_slab[smp_processor_id()] &&
-						!SlabDebug(page))) {
+				!SlabDebug(page))) {
 		object[page->offset] = page->lockless_freelist;
 		page->lockless_freelist = object;
-	} else
+		preempt_enable();
+	} else {
+		preempt_enable();
 		__slab_free(s, page, x, addr);
-
-	local_irq_restore(flags);
+	}
+	__local_end(flags);
 }
 
 void kmem_cache_free(struct kmem_cache *s, void *x)
Index: linux-2.6/init/Kconfig
===================================================================
--- linux-2.6.orig/init/Kconfig
+++ linux-2.6/init/Kconfig
@@ -578,7 +578,6 @@ config SLAB
 
 config SLUB
 	bool "SLUB (Unqueued Allocator)"
-	depends on !PREEMPT_RT
 	help
 	   SLUB is a slab allocator that minimizes cache line usage
 	   instead of managing queues of cached objects (SLAB approach).

--

