Return-Path: <linux-kernel-owner+w=401wt.eu-S1760526AbXHTWHX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760526AbXHTWHX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 18:07:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750979AbXHTWHK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 18:07:10 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:32998 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750784AbXHTWHH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 18:07:07 -0400
Date: Mon, 20 Aug 2007 15:07:07 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, mingo@redhat.com
Subject: Re: [patch 01/23] Fall back on interrupt disable in cmpxchg8b on
 80386 and 80486
In-Reply-To: <20070820215413.GA28452@Krystal>
Message-ID: <Pine.LNX.4.64.0708201506010.32213@schroedinger.engr.sgi.com>
References: <20070820201519.512791382@polymtl.ca> <20070820201822.597720007@polymtl.ca>
 <Pine.LNX.4.64.0708201330130.30053@schroedinger.engr.sgi.com>
 <20070820204126.GA22507@Krystal> <Pine.LNX.4.64.0708201346160.30353@schroedinger.engr.sgi.com>
 <20070820212922.GA27011@Krystal> <Pine.LNX.4.64.0708201448080.31411@schroedinger.engr.sgi.com>
 <20070820215413.GA28452@Krystal>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Aug 2007, Mathieu Desnoyers wrote:

> * Christoph Lameter (clameter@sgi.com) wrote:
> > On Mon, 20 Aug 2007, Mathieu Desnoyers wrote:
> > 
> > > I'm digging in the slub with cmpxchg_local patch... first detail:
> > > slab_alloc seems to have a return path that does not reenable
> > > preemption... I'll keep you posted when I finish the 2.6.23-rc2-mm2
> > > port.
> > 
> > I have a patchset here if that would help you?
> > 
> 
> Sure, I'd like to give it a try.

This applies on top of 
http://git.kernel.org/?p=linux/kernel/git/christoph/slab.git;a=shortlog;h=performance


SLUB: Single atomic instruction alloc/free using cmpxchg

A cmpxchg allows us to avoid disabling and enabling interrupts. The cmpxchg
is optimal to allow operations on per cpu freelist even if we may be moved
to other processors while getting to the cmpxchg. So we do not need to be
pinned to a cpu. This may be particularly useful for the RT kernel
where we currently seem to have major SLAB issues with the per cpu structures.
But the constant interrupt disable / enable of slab operations also increases
the performance in general.

The hard binding to per cpu structures only comes into play when we enter
the slow path (__slab_alloc and __slab_free). At that point we have to disable
interrupts like before.

We have a problem of determining the page struct in slab_free due the
issue that the freelist pointer is the only data value that we can reliably
operate on. So we need to do a virt_to_page() on the freelist. This makes it
impossible to use the fastpath for a full slab and increases overhead
through a second virt_to_page for each slab_free(). We really need the
virtual memmap patchset to get slab_free to good performance for this one.

Pro:

        - Dirty single cacheline with a single instruction in
          slab_alloc to accomplish allocation.
        - Critical section is also a single instruction in slab_free.
          (but we need to write to the cacheline of the object too)

Con:
        - Complex freelist management. __slab_alloc has to deal
	  with results of race conditions.
        - Recalculation of per cpu structure address is necessary
          in __slab_alloc since process may be rescheduled while
          executing in slab_alloc.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 include/linux/slub_def.h |   10 ++--
 mm/slub.c                |  100 ++++++++++++++++++++++++++++++++---------------
 2 files changed, 74 insertions(+), 36 deletions(-)

Index: linux-2.6.23-rc1/mm/slub.c
===================================================================
--- linux-2.6.23-rc1.orig/mm/slub.c	2007-07-27 19:58:32.000000000 -0700
+++ linux-2.6.23-rc1/mm/slub.c	2007-07-27 21:15:27.000000000 -0700
@@ -1346,34 +1346,38 @@ static void unfreeze_slab(struct kmem_ca
 /*
  * Remove the cpu slab
  */
-static void deactivate_slab(struct kmem_cache *s, struct kmem_cache_cpu *c)
+static void deactivate_slab(struct kmem_cache *s, struct kmem_cache_cpu *c,
+			void **freelist)
 {
 	struct page *page = c->page;
+
+	c->page = NULL;
 	/*
 	 * Merge cpu freelist into freelist. Typically we get here
 	 * because both freelists are empty. So this is unlikely
 	 * to occur.
 	 */
-	while (unlikely(c->freelist)) {
+	while (unlikely(freelist)) {
 		void **object;
 
 		/* Retrieve object from cpu_freelist */
-		object = c->freelist;
-		c->freelist = c->freelist[c->offset];
+		object = freelist;
+		freelist = freelist[c->offset];
 
 		/* And put onto the regular freelist */
 		object[c->offset] = page->freelist;
 		page->freelist = object;
 		page->inuse--;
 	}
-	c->page = NULL;
 	unfreeze_slab(s, page);
 }
 
 static inline void flush_slab(struct kmem_cache *s, struct kmem_cache_cpu *c)
 {
+	void **freelist = xchg(&c->freelist, NULL);
+
 	slab_lock(c->page);
-	deactivate_slab(s, c);
+	deactivate_slab(s, c, freelist);
 }
 
 /*
@@ -1439,17 +1443,31 @@ static inline int node_match(struct kmem
  * we need to allocate a new slab. This is slowest path since we may sleep.
  */
 static void *__slab_alloc(struct kmem_cache *s,
-		gfp_t gfpflags, int node, void *addr, struct kmem_cache_cpu *c)
+		gfp_t gfpflags, int node, void *addr)
 {
 	void **object;
 	struct page *new;
+	struct kmem_cache_cpu *c;
+	void **freelist = NULL;
+	unsigned long flags;
 
+	local_irq_save(flags);
+	c = get_cpu_slab(s, smp_processor_id());
 	if (!c->page)
+		/* Slab was flushed */
 		goto new_slab;
 
+	freelist = xchg(&c->freelist, NULL);
+
 	slab_lock(c->page);
 	if (unlikely(!node_match(c, node)))
 		goto another_slab;
+
+	if (unlikely(freelist)) {
+		object = freelist;
+		goto out_object;
+	}
+
 load_freelist:
 	object = c->page->freelist;
 	if (unlikely(!object))
@@ -1458,15 +1476,20 @@ load_freelist:
 		goto debug;
 
 	object = c->page->freelist;
-	c->freelist = object[c->offset];
 	c->page->inuse = s->objects;
 	c->page->freelist = NULL;
 	c->node = page_to_nid(c->page);
+out_object:
+	c->freelist = object[c->offset];
+out:
 	slab_unlock(c->page);
+	local_irq_restore(flags);
+	if (unlikely((gfpflags & __GFP_ZERO)))
+		memset(object, 0, c->objsize);
 	return object;
 
 another_slab:
-	deactivate_slab(s, c);
+	deactivate_slab(s, c, freelist);
 
 new_slab:
 	new = get_partial(s, gfpflags, node);
@@ -1503,6 +1526,7 @@ new_slab:
 		c->page = new;
 		goto load_freelist;
 	}
+	local_irq_restore(flags);
 	return NULL;
 debug:
 	object = c->page->freelist;
@@ -1512,8 +1536,7 @@ debug:
 	c->page->inuse++;
 	c->page->freelist = object[c->offset];
 	c->node = -1;
-	slab_unlock(c->page);
-	return object;
+	goto out;
 }
 
 /*
@@ -1530,25 +1553,28 @@ static void __always_inline *slab_alloc(
 		gfp_t gfpflags, int node, void *addr)
 {
 	void **object;
-	unsigned long flags;
 	struct kmem_cache_cpu *c;
 
-	local_irq_save(flags);
-	c = get_cpu_slab(s, smp_processor_id());
-	if (unlikely(!c->freelist || !node_match(c, node)))
+redo:
+	c = get_cpu_slab(s, raw_smp_processor_id());
+	object = c->freelist;
+	if (unlikely(!object))
+		goto slow;
 
-		object = __slab_alloc(s, gfpflags, node, addr, c);
+	if (unlikely(!node_match(c, node)))
+		goto slow;
 
-	else {
-		object = c->freelist;
-		c->freelist = object[c->offset];
-	}
-	local_irq_restore(flags);
+	if (unlikely(cmpxchg(&c->freelist, object,
+		object[c->offset]) != object))
+			goto redo;
 
-	if (unlikely((gfpflags & __GFP_ZERO) && object))
+	if (unlikely((gfpflags & __GFP_ZERO)))
 		memset(object, 0, c->objsize);
 
 	return object;
+slow:
+	return __slab_alloc(s, gfpflags, node, addr);
+
 }
 
 void *kmem_cache_alloc(struct kmem_cache *s, gfp_t gfpflags)
@@ -1578,7 +1604,9 @@ static void __slab_free(struct kmem_cach
 {
 	void *prior;
 	void **object = (void *)x;
+	unsigned long flags;
 
+	local_irq_save(flags);
 	slab_lock(page);
 
 	if (unlikely(SlabDebug(page)))
@@ -1604,6 +1632,7 @@ checks_ok:
 
 out_unlock:
 	slab_unlock(page);
+	local_irq_restore(flags);
 	return;
 
 slab_empty:
@@ -1614,6 +1643,7 @@ slab_empty:
 		remove_partial(s, page);
 
 	slab_unlock(page);
+	local_irq_restore(flags);
 	discard_slab(s, page);
 	return;
 
@@ -1638,18 +1668,26 @@ static void __always_inline slab_free(st
 			struct page *page, void *x, void *addr)
 {
 	void **object = (void *)x;
-	unsigned long flags;
+	void **freelist;
 	struct kmem_cache_cpu *c;
 
-	local_irq_save(flags);
-	c = get_cpu_slab(s, smp_processor_id());
-	if (likely(page == c->page && c->node >= 0)) {
-		object[c->offset] = c->freelist;
-		c->freelist = object;
-	} else
-		__slab_free(s, page, x, addr, c->offset);
+	c = get_cpu_slab(s, raw_smp_processor_id());
+	if (unlikely(c->node >= 0))
+		goto slow;
+
+redo:
+	freelist = c->freelist;
+	smp_rmb();
+	if (unlikely(page != c->page))
+		goto slow;
 
-	local_irq_restore(flags);
+	object[c->offset] = freelist;
+
+	if (unlikely(cmpxchg_local(&c->freelist, freelist, object) != freelist))
+		goto redo;
+	return;
+slow:
+	__slab_free(s, page, x, addr, c->offset);
 }
 
 void kmem_cache_free(struct kmem_cache *s, void *x)
Index: linux-2.6.23-rc1/include/linux/slub_def.h
===================================================================
--- linux-2.6.23-rc1.orig/include/linux/slub_def.h	2007-07-27 19:30:03.000000000 -0700
+++ linux-2.6.23-rc1/include/linux/slub_def.h	2007-07-27 21:15:27.000000000 -0700
@@ -12,11 +12,11 @@
 #include <linux/kobject.h>
 
 struct kmem_cache_cpu {
-	void **freelist;
-	struct page *page;
-	int node;
-	unsigned int offset;
-	unsigned int objsize;
+	void **freelist;	/* Updated through atomic ops */
+	struct page *page;	/* Updated with interrupts disabled */
+	int node;		/* Updated with interrupts disabled */
+	unsigned int offset;	/* Set up on kmem_cache_create() */
+	unsigned int objsize;	/* Set up on kmem_cache_create() */
 };
 
 struct kmem_cache_node {
