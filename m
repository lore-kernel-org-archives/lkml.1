Return-Path: <linux-kernel-owner+w=401wt.eu-S1755880AbZJGXFO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755880AbZJGXFO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 19:05:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755113AbZJGXFO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 19:05:14 -0400
Received: from smtp2.ultrahosting.com ([74.213.174.253]:39666 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755038AbZJGXFM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 19:05:12 -0400
X-Amavis-Alert: BAD HEADER, Header field occurs more than once: "Cc" occurs 3
	times
Message-Id: <20091007211053.187155632@gentwo.org>
References: <20091007211024.442168959@gentwo.org>
User-Agent: quilt/0.46-1
Date: Wed, 07 Oct 2009 17:10:30 -0400
From: cl@linux-foundation.org
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>
CC: Mel Gorman <mel@csn.ul.ie>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [this_cpu_xx V6 6/7] Make slub statistics use this_cpu_inc
Content-Disposition: inline; filename=this_cpu_slub_cleanup_stat
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

this_cpu_inc() translates into a single instruction on x86 and does not
need any register. So use it in stat(). We also want to avoid the
calculation of the per cpu kmem_cache_cpu structure pointer. So pass
a kmem_cache pointer instead of a kmem_cache_cpu pointer.

Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Christoph Lameter <cl@linux-foundation.org?

---
 mm/slub.c |   43 ++++++++++++++++++++-----------------------
 1 file changed, 20 insertions(+), 23 deletions(-)

Index: linux-2.6/mm/slub.c
===================================================================
--- linux-2.6.orig/mm/slub.c	2009-09-29 11:44:35.000000000 -0500
+++ linux-2.6/mm/slub.c	2009-09-29 11:44:49.000000000 -0500
@@ -217,10 +217,10 @@ static inline void sysfs_slab_remove(str
 
 #endif
 
-static inline void stat(struct kmem_cache_cpu *c, enum stat_item si)
+static inline void stat(struct kmem_cache *s, enum stat_item si)
 {
 #ifdef CONFIG_SLUB_STATS
-	c->stat[si]++;
+	__this_cpu_inc(s->cpu_slab->stat[si]);
 #endif
 }
 
@@ -1108,7 +1108,7 @@ static struct page *allocate_slab(struct
 		if (!page)
 			return NULL;
 
-		stat(this_cpu_ptr(s->cpu_slab), ORDER_FALLBACK);
+		stat(s, ORDER_FALLBACK);
 	}
 
 	if (kmemcheck_enabled
@@ -1406,23 +1406,22 @@ static struct page *get_partial(struct k
 static void unfreeze_slab(struct kmem_cache *s, struct page *page, int tail)
 {
 	struct kmem_cache_node *n = get_node(s, page_to_nid(page));
-	struct kmem_cache_cpu *c = this_cpu_ptr(s->cpu_slab);
 
 	__ClearPageSlubFrozen(page);
 	if (page->inuse) {
 
 		if (page->freelist) {
 			add_partial(n, page, tail);
-			stat(c, tail ? DEACTIVATE_TO_TAIL : DEACTIVATE_TO_HEAD);
+			stat(s, tail ? DEACTIVATE_TO_TAIL : DEACTIVATE_TO_HEAD);
 		} else {
-			stat(c, DEACTIVATE_FULL);
+			stat(s, DEACTIVATE_FULL);
 			if (SLABDEBUG && PageSlubDebug(page) &&
 						(s->flags & SLAB_STORE_USER))
 				add_full(n, page);
 		}
 		slab_unlock(page);
 	} else {
-		stat(c, DEACTIVATE_EMPTY);
+		stat(s, DEACTIVATE_EMPTY);
 		if (n->nr_partial < s->min_partial) {
 			/*
 			 * Adding an empty slab to the partial slabs in order
@@ -1438,7 +1437,7 @@ static void unfreeze_slab(struct kmem_ca
 			slab_unlock(page);
 		} else {
 			slab_unlock(page);
-			stat(__this_cpu_ptr(s->cpu_slab), FREE_SLAB);
+			stat(s, FREE_SLAB);
 			discard_slab(s, page);
 		}
 	}
@@ -1453,7 +1452,7 @@ static void deactivate_slab(struct kmem_
 	int tail = 1;
 
 	if (page->freelist)
-		stat(c, DEACTIVATE_REMOTE_FREES);
+		stat(s, DEACTIVATE_REMOTE_FREES);
 	/*
 	 * Merge cpu freelist into slab freelist. Typically we get here
 	 * because both freelists are empty. So this is unlikely
@@ -1479,7 +1478,7 @@ static void deactivate_slab(struct kmem_
 
 static inline void flush_slab(struct kmem_cache *s, struct kmem_cache_cpu *c)
 {
-	stat(c, CPUSLAB_FLUSH);
+	stat(s, CPUSLAB_FLUSH);
 	slab_lock(c->page);
 	deactivate_slab(s, c);
 }
@@ -1619,7 +1618,7 @@ static void *__slab_alloc(struct kmem_ca
 	if (unlikely(!node_match(c, node)))
 		goto another_slab;
 
-	stat(c, ALLOC_REFILL);
+	stat(s, ALLOC_REFILL);
 
 load_freelist:
 	object = c->page->freelist;
@@ -1634,7 +1633,7 @@ load_freelist:
 	c->node = page_to_nid(c->page);
 unlock_out:
 	slab_unlock(c->page);
-	stat(c, ALLOC_SLOWPATH);
+	stat(s, ALLOC_SLOWPATH);
 	return object;
 
 another_slab:
@@ -1644,7 +1643,7 @@ new_slab:
 	new = get_partial(s, gfpflags, node);
 	if (new) {
 		c->page = new;
-		stat(c, ALLOC_FROM_PARTIAL);
+		stat(s, ALLOC_FROM_PARTIAL);
 		goto load_freelist;
 	}
 
@@ -1658,7 +1657,7 @@ new_slab:
 
 	if (new) {
 		c = __this_cpu_ptr(s->cpu_slab);
-		stat(c, ALLOC_SLAB);
+		stat(s, ALLOC_SLAB);
 		if (c->page)
 			flush_slab(s, c);
 		slab_lock(new);
@@ -1713,7 +1712,7 @@ static __always_inline void *slab_alloc(
 
 	else {
 		c->freelist = get_freepointer(s, object);
-		stat(c, ALLOC_FASTPATH);
+		stat(s, ALLOC_FASTPATH);
 	}
 	local_irq_restore(flags);
 
@@ -1780,10 +1779,8 @@ static void __slab_free(struct kmem_cach
 {
 	void *prior;
 	void **object = (void *)x;
-	struct kmem_cache_cpu *c;
 
-	c = __this_cpu_ptr(s->cpu_slab);
-	stat(c, FREE_SLOWPATH);
+	stat(s, FREE_SLOWPATH);
 	slab_lock(page);
 
 	if (unlikely(SLABDEBUG && PageSlubDebug(page)))
@@ -1796,7 +1793,7 @@ checks_ok:
 	page->inuse--;
 
 	if (unlikely(PageSlubFrozen(page))) {
-		stat(c, FREE_FROZEN);
+		stat(s, FREE_FROZEN);
 		goto out_unlock;
 	}
 
@@ -1809,7 +1806,7 @@ checks_ok:
 	 */
 	if (unlikely(!prior)) {
 		add_partial(get_node(s, page_to_nid(page)), page, 1);
-		stat(c, FREE_ADD_PARTIAL);
+		stat(s, FREE_ADD_PARTIAL);
 	}
 
 out_unlock:
@@ -1822,10 +1819,10 @@ slab_empty:
 		 * Slab still on the partial list.
 		 */
 		remove_partial(s, page);
-		stat(c, FREE_REMOVE_PARTIAL);
+		stat(s, FREE_REMOVE_PARTIAL);
 	}
 	slab_unlock(page);
-	stat(c, FREE_SLAB);
+	stat(s, FREE_SLAB);
 	discard_slab(s, page);
 	return;
 
@@ -1863,7 +1860,7 @@ static __always_inline void slab_free(st
 	if (likely(page == c->page && c->node >= 0)) {
 		set_freepointer(s, object, c->freelist);
 		c->freelist = object;
-		stat(c, FREE_FASTPATH);
+		stat(s, FREE_FASTPATH);
 	} else
 		__slab_free(s, page, x, addr);
 

-- 
