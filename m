Return-Path: <linux-kernel-owner+w=401wt.eu-S1759796AbZJHT3J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759796AbZJHT3J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 15:29:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756267AbZJHT3I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 15:29:08 -0400
Received: from smtp2.ultrahosting.com ([74.213.174.253]:45592 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753542AbZJHT3G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 15:29:06 -0400
Date: Thu, 8 Oct 2009 15:21:50 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
cc: Peter Zijlstra <peterz@infradead.org>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>,
       Tejun Heo <tj@kernel.org>, Mel Gorman <mel@csn.ul.ie>, mingo@elte.hu
Subject: Re: [this_cpu_xx V5 19/19] SLUB: Experimental new fastpath w/o
 interrupt disable
In-Reply-To: <20091008191754.GA12729@Krystal>
Message-ID: <alpine.DEB.1.10.0910081520210.8030@gentwo.org>
References: <20091007124628.GB27363@Krystal> <alpine.DEB.1.10.0910071039520.5671@gentwo.org> <20091007150257.GA8508@Krystal> <alpine.DEB.1.10.0910071102590.9984@gentwo.org> <20091007151940.GA10052@Krystal> <alpine.DEB.1.10.0910071119450.9296@gentwo.org>
 <1254988350.26976.256.camel@twins> <alpine.DEB.1.10.0910081211050.21951@gentwo.org> <20091008171750.GA3370@Krystal> <alpine.DEB.1.10.0910081342540.7735@gentwo.org> <20091008191754.GA12729@Krystal>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Oct 2009, Mathieu Desnoyers wrote:

> OK, sounds good,

Then here the full patch for review (vs. percpu-next):


From: Christoph Lameter <cl@linux-foundation.org>
Subject: SLUB: Experimental new fastpath w/o interrupt disable

This is a bit of a different tack on things than the last version provided
by Mathieu.

Instead of using a cmpxchg we keep a state variable in the per cpu structure
that is incremented when we enter the hot path. We can then detect that
a thread is in the fastpath and fall back to alternate allocation / free
technique that bypasses fastpath caching.

V1->V2:
- Use safe preempt_enable / disable.
- Enable preempt before calling into the page allocator
- Checkup on hotpath activity changes when returning from page allocator.
- Add barriers.

Todo:
- Verify that this is really safe
- Is this a benefit?

Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Christoph Lameter <cl@linux-foundation.org>


---
 include/linux/slub_def.h |    1
 mm/slub.c                |  112 +++++++++++++++++++++++++++++++++++++++--------
 2 files changed, 96 insertions(+), 17 deletions(-)

Index: linux-2.6/include/linux/slub_def.h
===================================================================
--- linux-2.6.orig/include/linux/slub_def.h	2009-10-08 11:35:59.000000000 -0500
+++ linux-2.6/include/linux/slub_def.h	2009-10-08 11:35:59.000000000 -0500
@@ -38,6 +38,7 @@ struct kmem_cache_cpu {
 	void **freelist;	/* Pointer to first free per cpu object */
 	struct page *page;	/* The slab from which we are allocating */
 	int node;		/* The node of the page (or -1 for debug) */
+	int active;		/* Active fastpaths */
 #ifdef CONFIG_SLUB_STATS
 	unsigned stat[NR_SLUB_STAT_ITEMS];
 #endif
Index: linux-2.6/mm/slub.c
===================================================================
--- linux-2.6.orig/mm/slub.c	2009-10-08 11:35:59.000000000 -0500
+++ linux-2.6/mm/slub.c	2009-10-08 14:03:22.000000000 -0500
@@ -1606,7 +1606,14 @@ static void *__slab_alloc(struct kmem_ca
 			  unsigned long addr)
 {
 	void **object;
-	struct page *page = __this_cpu_read(s->cpu_slab->page);
+	struct page *page;
+	unsigned long flags;
+	int hotpath;
+
+	local_irq_save(flags);
+	hotpath = __this_cpu_read(s->cpu_slab->active) != 0;
+	__this_cpu_dec(s->cpu_slab->active);	/* Drop count from hotpath */
+	page = __this_cpu_read(s->cpu_slab->page);

 	/* We handle __GFP_ZERO in the caller */
 	gfpflags &= ~__GFP_ZERO;
@@ -1627,12 +1634,24 @@ load_freelist:
 	if (unlikely(SLABDEBUG && PageSlubDebug(page)))
 		goto debug;

-	__this_cpu_write(s->cpu_slab->node, page_to_nid(page));
-	__this_cpu_write(s->cpu_slab->freelist, get_freepointer(s, object));
-	page->inuse = page->objects;
-	page->freelist = NULL;
+	if (unlikely(hotpath)) {
+		/* Object on page free list available and hotpath busy */
+		page->inuse++;
+		page->freelist = get_freepointer(s, object);
+
+	} else {
+
+		/* Prepare new list of objects for hotpath */
+		__this_cpu_write(s->cpu_slab->freelist, get_freepointer(s, object));
+		page->inuse = page->objects;
+		page->freelist = NULL;
+		__this_cpu_write(s->cpu_slab->node, page_to_nid(page));
+
+	}
+
 unlock_out:
 	slab_unlock(page);
+	local_irq_restore(flags);
 	stat(s, ALLOC_SLOWPATH);
 	return object;

@@ -1642,21 +1661,38 @@ another_slab:
 new_slab:
 	page = get_partial(s, gfpflags, node);
 	if (page) {
-		__this_cpu_write(s->cpu_slab->page, page);
 		stat(s, ALLOC_FROM_PARTIAL);
+
+		if (hotpath)
+			goto hot_lock;
+
+		__this_cpu_write(s->cpu_slab->page, page);
 		goto load_freelist;
 	}

 	if (gfpflags & __GFP_WAIT)
 		local_irq_enable();

+	preempt_enable();
 	page = new_slab(s, gfpflags, node);
+	preempt_disable();
+
+	/*
+	 * We have already decremented our count. Someone else
+	 * could be running right now or we were moved to a
+	 * processor that is in the hotpath. So check against -1.
+	 */
+	hotpath = __this_cpu_read(s->cpu_slab->active) != -1;

 	if (gfpflags & __GFP_WAIT)
 		local_irq_disable();

 	if (page) {
 		stat(s, ALLOC_SLAB);
+
+		if (hotpath)
+			 goto hot_no_lock;
+
 		if (__this_cpu_read(s->cpu_slab->page))
 			flush_slab(s, __this_cpu_ptr(s->cpu_slab));
 		slab_lock(page);
@@ -1664,9 +1700,13 @@ new_slab:
 		__this_cpu_write(s->cpu_slab->page, page);
 		goto load_freelist;
 	}
+
+	local_irq_restore(flags);
+
 	if (!(gfpflags & __GFP_NOWARN) && printk_ratelimit())
 		slab_out_of_memory(s, gfpflags, node);
 	return NULL;
+
 debug:
 	if (!alloc_debug_processing(s, page, object, addr))
 		goto another_slab;
@@ -1675,6 +1715,20 @@ debug:
 	page->freelist = get_freepointer(s, object);
 	__this_cpu_write(s->cpu_slab->node, -1);
 	goto unlock_out;
+
+	/*
+	 * Hotpath is busy and we need to avoid touching
+	 * hotpath variables
+	 */
+hot_no_lock:
+	slab_lock(page);
+
+hot_lock:
+	__ClearPageSlubFrozen(page);
+	if (get_freepointer(s, page->freelist))
+		/* Cannot put page into the hotpath. Instead back to partial */
+		add_partial(get_node(s, page_to_nid(page)), page, 0);
+	goto load_freelist;
 }

 /*
@@ -1691,7 +1745,6 @@ static __always_inline void *slab_alloc(
 		gfp_t gfpflags, int node, unsigned long addr)
 {
 	void **object;
-	unsigned long flags;

 	gfpflags &= gfp_allowed_mask;

@@ -1701,18 +1754,27 @@ static __always_inline void *slab_alloc(
 	if (should_failslab(s->objsize, gfpflags))
 		return NULL;

-	local_irq_save(flags);
+	preempt_disable();
+
+	irqsafe_cpu_inc(s->cpu_slab->active);
+	barrier();
 	object = __this_cpu_read(s->cpu_slab->freelist);
-	if (unlikely(!object || !node_match(s, node)))
+	if (unlikely(!object || !node_match(s, node) ||
+			__this_cpu_read(s->cpu_slab->active)))

 		object = __slab_alloc(s, gfpflags, node, addr);

 	else {
+
 		__this_cpu_write(s->cpu_slab->freelist,
 			get_freepointer(s, object));
+		barrier();
+		irqsafe_cpu_dec(s->cpu_slab->active);
 		stat(s, ALLOC_FASTPATH);
+
 	}
-	local_irq_restore(flags);
+
+	preempt_enable();

 	if (unlikely((gfpflags & __GFP_ZERO) && object))
 		memset(object, 0, s->objsize);
@@ -1777,7 +1839,9 @@ static void __slab_free(struct kmem_cach
 {
 	void *prior;
 	void **object = (void *)x;
+	unsigned long flags;

+	local_irq_save(flags);
 	stat(s, FREE_SLOWPATH);
 	slab_lock(page);

@@ -1809,6 +1873,7 @@ checks_ok:

 out_unlock:
 	slab_unlock(page);
+	local_irq_restore(flags);
 	return;

 slab_empty:
@@ -1820,6 +1885,7 @@ slab_empty:
 		stat(s, FREE_REMOVE_PARTIAL);
 	}
 	slab_unlock(page);
+	local_irq_restore(flags);
 	stat(s, FREE_SLAB);
 	discard_slab(s, page);
 	return;
@@ -1845,24 +1911,31 @@ static __always_inline void slab_free(st
 			struct page *page, void *x, unsigned long addr)
 {
 	void **object = (void *)x;
-	unsigned long flags;

 	kmemleak_free_recursive(x, s->flags);
-	local_irq_save(flags);
+	preempt_disable();
 	kmemcheck_slab_free(s, object, s->objsize);
 	debug_check_no_locks_freed(object, s->objsize);
 	if (!(s->flags & SLAB_DEBUG_OBJECTS))
 		debug_check_no_obj_freed(object, s->objsize);

+	irqsafe_cpu_inc(s->cpu_slab->active);
+	barrier();
 	if (likely(page == __this_cpu_read(s->cpu_slab->page) &&
-			__this_cpu_read(s->cpu_slab->node) >= 0)) {
-		set_freepointer(s, object, __this_cpu_read(s->cpu_slab->freelist));
+			__this_cpu_read(s->cpu_slab->node) >= 0) &&
+			!__this_cpu_read(s->cpu_slab->active)) {
+		set_freepointer(s, object,
+			__this_cpu_read(s->cpu_slab->freelist));
 		__this_cpu_write(s->cpu_slab->freelist, object);
+		barrier();
+		irqsafe_cpu_dec(s->cpu_slab->active);
+		preempt_enable();
 		stat(s, FREE_FASTPATH);
-	} else
+	} else {
+		irqsafe_cpu_dec(s->cpu_slab->active);
+		preempt_enable();
 		__slab_free(s, page, x, addr);
-
-	local_irq_restore(flags);
+	}
 }

 void kmem_cache_free(struct kmem_cache *s, void *x)
@@ -2064,6 +2137,8 @@ static DEFINE_PER_CPU(struct kmem_cache_

 static inline int alloc_kmem_cache_cpus(struct kmem_cache *s, gfp_t flags)
 {
+	int cpu;
+
 	if (s < kmalloc_caches + KMALLOC_CACHES && s >= kmalloc_caches)
 		/*
 		 * Boot time creation of the kmalloc array. Use static per cpu data
@@ -2073,6 +2148,9 @@ static inline int alloc_kmem_cache_cpus(
 	else
 		s->cpu_slab =  alloc_percpu(struct kmem_cache_cpu);

+	for_each_possible_cpu(cpu)
+		per_cpu_ptr(s->cpu_slab, cpu)->active = -1;
+
 	if (!s->cpu_slab)
 		return 0;

