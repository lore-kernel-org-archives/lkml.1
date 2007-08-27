Return-Path: <linux-kernel-owner+w=401wt.eu-S1760015AbXH0T3Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760015AbXH0T3Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 15:29:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756726AbXH0T3R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 15:29:17 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:33979 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757389AbXH0T3Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 15:29:16 -0400
Date: Mon, 27 Aug 2007 12:29:16 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [patch 00/28] Add cmpxchg64_local and cmpxchg_local to each
 architecture
In-Reply-To: <20070827173151.GA28974@Krystal>
Message-ID: <Pine.LNX.4.64.0708271220570.4667@schroedinger.engr.sgi.com>
References: <20070827155234.062715780@polymtl.ca>
 <20070827091726.a2e8fbb8.akpm@linux-foundation.org> <20070827173151.GA28974@Krystal>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Aug 2007, Mathieu Desnoyers wrote:

> Good point. Christoph, could you please prepare a slub cmpxchg_local
> patch for the mm tree ?

Patch follows (on top of the per cpu structures patch):

Note that we still have a ways to go before the cmpxchg_local 
implementation for slub is ready to be included. Right now we are surely 
causing a regression on non x86 platforms. There needs to be some sort of 
agreement on how to use cmpxchg_local in a way that does not cause harm 
for other architectures.

Once we have that in place then the same method that is applied to the 
SLUB fastpath can also be applied to the vm statistics. I have a patch 
here that does that. We could then also optimize the page allocator to do 
the same.

---
 include/linux/slub_def.h |   10 +++---
 mm/slub.c                |   76 ++++++++++++++++++++++++++++++++---------------
 2 files changed, 58 insertions(+), 28 deletions(-)

Index: linux-2.6/mm/slub.c
===================================================================
--- linux-2.6.orig/mm/slub.c	2007-08-22 21:42:40.000000000 -0700
+++ linux-2.6/mm/slub.c	2007-08-22 21:42:53.000000000 -0700
@@ -1442,13 +1442,18 @@ static void *__slab_alloc(struct kmem_ca
 {
 	void **object;
 	struct page *new;
+	unsigned long flags;
 
+	local_irq_save(flags);
+	put_cpu_no_resched();
 	if (!c->page)
+		/* Slab was flushed */
 		goto new_slab;
 
 	slab_lock(c->page);
 	if (unlikely(!node_match(c, node)))
 		goto another_slab;
+
 load_freelist:
 	object = c->page->freelist;
 	if (unlikely(!object))
@@ -1457,11 +1462,16 @@ load_freelist:
 		goto debug;
 
 	object = c->page->freelist;
-	c->freelist = object[c->offset];
 	c->page->inuse = s->objects;
 	c->page->freelist = NULL;
 	c->node = page_to_nid(c->page);
+	c->freelist = object[c->offset];
+out:
 	slab_unlock(c->page);
+	local_irq_restore(flags);
+	preempt_check_resched();
+	if (unlikely((gfpflags & __GFP_ZERO)))
+		memset(object, 0, c->objsize);
 	return object;
 
 another_slab:
@@ -1502,6 +1512,8 @@ new_slab:
 		c->page = new;
 		goto load_freelist;
 	}
+	local_irq_restore(flags);
+	preempt_check_resched();
 	return NULL;
 debug:
 	object = c->page->freelist;
@@ -1511,8 +1523,7 @@ debug:
 	c->page->inuse++;
 	c->page->freelist = object[c->offset];
 	c->node = -1;
-	slab_unlock(c->page);
-	return object;
+	goto out;
 }
 
 /*
@@ -1529,25 +1540,29 @@ static void __always_inline *slab_alloc(
 		gfp_t gfpflags, int node, void *addr)
 {
 	void **object;
-	unsigned long flags;
 	struct kmem_cache_cpu *c;
 
-	local_irq_save(flags);
-	c = get_cpu_slab(s, smp_processor_id());
-	if (unlikely(!c->freelist || !node_match(c, node)))
+	c = get_cpu_slab(s, get_cpu());
+redo:
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
+	if (unlikely(cmpxchg_local(&c->freelist, object,
+		object[c->offset]) != object))
+			goto redo;
 
-	if (unlikely((gfpflags & __GFP_ZERO) && object))
+	put_cpu();
+	if (unlikely((gfpflags & __GFP_ZERO)))
 		memset(object, 0, c->objsize);
 
 	return object;
+slow:
+	return __slab_alloc(s, gfpflags, node, addr, c);
+
 }
 
 void *kmem_cache_alloc(struct kmem_cache *s, gfp_t gfpflags)
@@ -1577,7 +1592,10 @@ static void __slab_free(struct kmem_cach
 {
 	void *prior;
 	void **object = (void *)x;
+	unsigned long flags;
 
+	put_cpu();
+	local_irq_save(flags);
 	slab_lock(page);
 
 	if (unlikely(SlabDebug(page)))
@@ -1603,6 +1621,7 @@ checks_ok:
 
 out_unlock:
 	slab_unlock(page);
+	local_irq_restore(flags);
 	return;
 
 slab_empty:
@@ -1613,6 +1632,7 @@ slab_empty:
 		remove_partial(s, page);
 
 	slab_unlock(page);
+	local_irq_restore(flags);
 	discard_slab(s, page);
 	return;
 
@@ -1637,19 +1657,29 @@ static void __always_inline slab_free(st
 			struct page *page, void *x, void *addr)
 {
 	void **object = (void *)x;
-	unsigned long flags;
+	void **freelist;
 	struct kmem_cache_cpu *c;
 
-	local_irq_save(flags);
 	debug_check_no_locks_freed(object, s->objsize);
-	c = get_cpu_slab(s, smp_processor_id());
-	if (likely(page == c->page && c->node >= 0)) {
-		object[c->offset] = c->freelist;
-		c->freelist = object;
-	} else
-		__slab_free(s, page, x, addr, c->offset);
 
-	local_irq_restore(flags);
+	c = get_cpu_slab(s, get_cpu());
+	if (unlikely(c->node < 0))
+		goto slow;
+redo:
+	freelist = c->freelist;
+	barrier();	/* If interrupt changes c->page -> cmpxchg failure */
+	if (unlikely(page != c->page))
+		goto slow;
+
+	object[c->offset] = freelist;
+	if (unlikely(cmpxchg_local(&c->freelist, freelist, object)
+							!= freelist))
+		goto redo;
+
+	put_cpu();
+	return;
+slow:
+	__slab_free(s, page, x, addr, c->offset);
 }
 
 void kmem_cache_free(struct kmem_cache *s, void *x)
Index: linux-2.6/include/linux/slub_def.h
===================================================================
--- linux-2.6.orig/include/linux/slub_def.h	2007-08-22 21:42:39.000000000 -0700
+++ linux-2.6/include/linux/slub_def.h	2007-08-22 21:42:43.000000000 -0700
@@ -12,11 +12,11 @@
 #include <linux/kobject.h>
 
 struct kmem_cache_cpu {
-	void **freelist;
-	struct page *page;
-	int node;
-	unsigned int offset;
-	unsigned int objsize;
+	void **freelist;	/* Updated through local atomic ops */
+	struct page *page;	/* Updated with interrupts disabled */
+	int node;		/* Updated with interrupts disabled */
+	unsigned int offset;	/* Set up on kmem_cache_create() */
+	unsigned int objsize;	/* Set up on kmem_cache_create() */
 };
 
 struct kmem_cache_node {
