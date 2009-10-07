Return-Path: <linux-kernel-owner+w=401wt.eu-S1754972AbZJGWFR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754972AbZJGWFR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 18:05:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754908AbZJGWFP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 18:05:15 -0400
Received: from smtp2.ultrahosting.com ([74.213.174.253]:52464 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753951AbZJGWFK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 18:05:10 -0400
X-Amavis-Alert: BAD HEADER, Duplicate header field: "Cc"
Message-Id: <20091007211053.378634196@gentwo.org>
References: <20091007211024.442168959@gentwo.org>
User-Agent: quilt/0.46-1
Date: Wed, 07 Oct 2009 17:10:31 -0400
From: cl@linux-foundation.org
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Pekka Enberg <penberg@cs.helsinki.fi>
CC: Mel Gorman <mel@csn.ul.ie>
Subject: [this_cpu_xx V6 7/7] this_cpu: slub aggressive use of this_cpu operations in the hotpaths
Content-Disposition: inline; filename=this_cpu_slub_aggressive_cpu_ops
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use this_cpu_* operations in the hotpath to avoid calculations of
kmem_cache_cpu pointer addresses.

On x86 there is a trade off: Multiple uses segment prefixes against an
address calculation and more register pressure. Code size is reduced
also therefore it is an advantage icache wise.

The use of prefixes is necessary if we want to use a scheme
for fastpaths that do not require disabling interrupts.

Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Christoph Lameter <cl@linux-foundation.org>

---
 mm/slub.c |   80 ++++++++++++++++++++++++++++++--------------------------------
 1 file changed, 39 insertions(+), 41 deletions(-)

Index: linux-2.6/mm/slub.c
===================================================================
--- linux-2.6.orig/mm/slub.c	2009-10-07 14:52:05.000000000 -0500
+++ linux-2.6/mm/slub.c	2009-10-07 14:58:50.000000000 -0500
@@ -1512,10 +1512,10 @@ static void flush_all(struct kmem_cache 
  * Check if the objects in a per cpu structure fit numa
  * locality expectations.
  */
-static inline int node_match(struct kmem_cache_cpu *c, int node)
+static inline int node_match(struct kmem_cache *s, int node)
 {
 #ifdef CONFIG_NUMA
-	if (node != -1 && c->node != node)
+	if (node != -1 && __this_cpu_read(s->cpu_slab->node) != node)
 		return 0;
 #endif
 	return 1;
@@ -1603,46 +1603,46 @@ slab_out_of_memory(struct kmem_cache *s,
  * a call to the page allocator and the setup of a new slab.
  */
 static void *__slab_alloc(struct kmem_cache *s, gfp_t gfpflags, int node,
-			  unsigned long addr, struct kmem_cache_cpu *c)
+			  unsigned long addr)
 {
 	void **object;
-	struct page *new;
+	struct page *page = __this_cpu_read(s->cpu_slab->page);
 
 	/* We handle __GFP_ZERO in the caller */
 	gfpflags &= ~__GFP_ZERO;
 
-	if (!c->page)
+	if (!page)
 		goto new_slab;
 
-	slab_lock(c->page);
-	if (unlikely(!node_match(c, node)))
+	slab_lock(page);
+	if (unlikely(!node_match(s, node)))
 		goto another_slab;
 
 	stat(s, ALLOC_REFILL);
 
 load_freelist:
-	object = c->page->freelist;
+	object = page->freelist;
 	if (unlikely(!object))
 		goto another_slab;
-	if (unlikely(SLABDEBUG && PageSlubDebug(c->page)))
+	if (unlikely(SLABDEBUG && PageSlubDebug(page)))
 		goto debug;
 
-	c->freelist = get_freepointer(s, object);
-	c->page->inuse = c->page->objects;
-	c->page->freelist = NULL;
-	c->node = page_to_nid(c->page);
+	__this_cpu_write(s->cpu_slab->node, page_to_nid(page));
+	__this_cpu_write(s->cpu_slab->freelist, get_freepointer(s, object));
+	page->inuse = page->objects;
+	page->freelist = NULL;
 unlock_out:
-	slab_unlock(c->page);
+	slab_unlock(page);
 	stat(s, ALLOC_SLOWPATH);
 	return object;
 
 another_slab:
-	deactivate_slab(s, c);
+	deactivate_slab(s, __this_cpu_ptr(s->cpu_slab));
 
 new_slab:
-	new = get_partial(s, gfpflags, node);
-	if (new) {
-		c->page = new;
+	page = get_partial(s, gfpflags, node);
+	if (page) {
+		__this_cpu_write(s->cpu_slab->page, page);
 		stat(s, ALLOC_FROM_PARTIAL);
 		goto load_freelist;
 	}
@@ -1650,31 +1650,30 @@ new_slab:
 	if (gfpflags & __GFP_WAIT)
 		local_irq_enable();
 
-	new = new_slab(s, gfpflags, node);
+	page = new_slab(s, gfpflags, node);
 
 	if (gfpflags & __GFP_WAIT)
 		local_irq_disable();
 
-	if (new) {
-		c = __this_cpu_ptr(s->cpu_slab);
+	if (page) {
 		stat(s, ALLOC_SLAB);
-		if (c->page)
-			flush_slab(s, c);
-		slab_lock(new);
-		__SetPageSlubFrozen(new);
-		c->page = new;
+		if (__this_cpu_read(s->cpu_slab->page))
+			flush_slab(s, __this_cpu_ptr(s->cpu_slab));
+		slab_lock(page);
+		__SetPageSlubFrozen(page);
+		__this_cpu_write(s->cpu_slab->page, page);
 		goto load_freelist;
 	}
 	if (!(gfpflags & __GFP_NOWARN) && printk_ratelimit())
 		slab_out_of_memory(s, gfpflags, node);
 	return NULL;
 debug:
-	if (!alloc_debug_processing(s, c->page, object, addr))
+	if (!alloc_debug_processing(s, page, object, addr))
 		goto another_slab;
 
-	c->page->inuse++;
-	c->page->freelist = get_freepointer(s, object);
-	c->node = -1;
+	page->inuse++;
+	page->freelist = get_freepointer(s, object);
+	__this_cpu_write(s->cpu_slab->node, -1);
 	goto unlock_out;
 }
 
@@ -1692,7 +1691,6 @@ static __always_inline void *slab_alloc(
 		gfp_t gfpflags, int node, unsigned long addr)
 {
 	void **object;
-	struct kmem_cache_cpu *c;
 	unsigned long flags;
 
 	gfpflags &= gfp_allowed_mask;
@@ -1704,14 +1702,14 @@ static __always_inline void *slab_alloc(
 		return NULL;
 
 	local_irq_save(flags);
-	c = __this_cpu_ptr(s->cpu_slab);
-	object = c->freelist;
-	if (unlikely(!object || !node_match(c, node)))
+	object = __this_cpu_read(s->cpu_slab->freelist);
+	if (unlikely(!object || !node_match(s, node)))
 
-		object = __slab_alloc(s, gfpflags, node, addr, c);
+		object = __slab_alloc(s, gfpflags, node, addr);
 
 	else {
-		c->freelist = get_freepointer(s, object);
+		__this_cpu_write(s->cpu_slab->freelist,
+			get_freepointer(s, object));
 		stat(s, ALLOC_FASTPATH);
 	}
 	local_irq_restore(flags);
@@ -1847,19 +1845,19 @@ static __always_inline void slab_free(st
 			struct page *page, void *x, unsigned long addr)
 {
 	void **object = (void *)x;
-	struct kmem_cache_cpu *c;
 	unsigned long flags;
 
 	kmemleak_free_recursive(x, s->flags);
 	local_irq_save(flags);
-	c = __this_cpu_ptr(s->cpu_slab);
 	kmemcheck_slab_free(s, object, s->objsize);
 	debug_check_no_locks_freed(object, s->objsize);
 	if (!(s->flags & SLAB_DEBUG_OBJECTS))
 		debug_check_no_obj_freed(object, s->objsize);
-	if (likely(page == c->page && c->node >= 0)) {
-		set_freepointer(s, object, c->freelist);
-		c->freelist = object;
+
+	if (likely(page == __this_cpu_read(s->cpu_slab->page) &&
+			__this_cpu_read(s->cpu_slab->node) >= 0)) {
+		set_freepointer(s, object, __this_cpu_read(s->cpu_slab->freelist));
+		__this_cpu_write(s->cpu_slab->freelist, object);
 		stat(s, FREE_FASTPATH);
 	} else
 		__slab_free(s, page, x, addr);

-- 
