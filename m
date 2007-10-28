Return-Path: <linux-kernel-owner+w=401wt.eu-S1751597AbXJ1Ddc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751597AbXJ1Ddc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 23:33:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751312AbXJ1DdB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 23:33:01 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:59544 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751014AbXJ1Dc7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 23:32:59 -0400
Message-Id: <20071028033258.546533164@sgi.com>
References: <20071028033156.022983073@sgi.com>
User-Agent: quilt/0.46-1
Date: Sat, 27 Oct 2007 20:31:57 -0700
From: Christoph Lameter <clameter@sgi.com>
To: Matthew Wilcox <matthew@wil.cx>
Cc: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Subject: [patch 01/10] SLUB: Consolidate add_partial and add_partial_tail to one function
Content-Disposition: inline; filename=slab_defrag_add_partial_tail
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add a parameter to add_partial instead of having separate functions.
That allows the detailed control from multiple places when putting
slabs back to the partial list. If we put slabs back to the front
then they are likely immediately used for allocations. If they are
put at the end then we can maximize the time that the partial slabs
spent without allocations.

When deactivating slab we can put the slabs that had remote objects freed
to them at the end of the list so that the cache lines can cool down.
Slabs that had objects from the local cpu freed to them are put in the
front of the list to be reused ASAP in order to exploit the cache hot state.

[This patch is already in mm]

Signed-off-by: Christoph Lameter <clameter@sgi.com>
---
 mm/slub.c |   31 +++++++++++++++----------------
 1 file changed, 15 insertions(+), 16 deletions(-)

Index: linux-2.6/mm/slub.c
===================================================================
--- linux-2.6.orig/mm/slub.c	2007-10-24 08:33:01.000000000 -0700
+++ linux-2.6/mm/slub.c	2007-10-24 09:19:52.000000000 -0700
@@ -1197,19 +1197,15 @@
 /*
  * Management of partially allocated slabs
  */
-static void add_partial_tail(struct kmem_cache_node *n, struct page *page)
+static void add_partial(struct kmem_cache_node *n,
+				struct page *page, int tail)
 {
 	spin_lock(&n->list_lock);
 	n->nr_partial++;
-	list_add_tail(&page->lru, &n->partial);
-	spin_unlock(&n->list_lock);
-}
-
-static void add_partial(struct kmem_cache_node *n, struct page *page)
-{
-	spin_lock(&n->list_lock);
-	n->nr_partial++;
-	list_add(&page->lru, &n->partial);
+	if (tail)
+		list_add_tail(&page->lru, &n->partial);
+	else
+		list_add(&page->lru, &n->partial);
 	spin_unlock(&n->list_lock);
 }
 
@@ -1337,7 +1333,7 @@
  *
  * On exit the slab lock will have been dropped.
  */
-static void unfreeze_slab(struct kmem_cache *s, struct page *page)
+static void unfreeze_slab(struct kmem_cache *s, struct page *page, int tail)
 {
 	struct kmem_cache_node *n = get_node(s, page_to_nid(page));
 
@@ -1345,7 +1341,7 @@
 	if (page->inuse) {
 
 		if (page->freelist)
-			add_partial(n, page);
+			add_partial(n, page, tail);
 		else if (SlabDebug(page) && (s->flags & SLAB_STORE_USER))
 			add_full(n, page);
 		slab_unlock(page);
@@ -1360,7 +1356,7 @@
 			 * partial list stays small. kmem_cache_shrink can
 			 * reclaim empty slabs from the partial list.
 			 */
-			add_partial_tail(n, page);
+			add_partial(n, page, 1);
 			slab_unlock(page);
 		} else {
 			slab_unlock(page);
@@ -1375,6 +1371,7 @@
 static void deactivate_slab(struct kmem_cache *s, struct kmem_cache_cpu *c)
 {
 	struct page *page = c->page;
+	int tail = 1;
 	/*
 	 * Merge cpu freelist into freelist. Typically we get here
 	 * because both freelists are empty. So this is unlikely
@@ -1383,6 +1380,8 @@
 	while (unlikely(c->freelist)) {
 		void **object;
 
+		tail = 0;	/* Hot objects. Put the slab first */
+
 		/* Retrieve object from cpu_freelist */
 		object = c->freelist;
 		c->freelist = c->freelist[c->offset];
@@ -1393,7 +1392,7 @@
 		page->inuse--;
 	}
 	c->page = NULL;
-	unfreeze_slab(s, page);
+	unfreeze_slab(s, page, tail);
 }
 
 static inline void flush_slab(struct kmem_cache *s, struct kmem_cache_cpu *c)
@@ -1633,7 +1632,7 @@
 	 * then add it.
 	 */
 	if (unlikely(!prior))
-		add_partial(get_node(s, page_to_nid(page)), page);
+		add_partial(get_node(s, page_to_nid(page)), page, 0);
 
 out_unlock:
 	slab_unlock(page);
@@ -2041,7 +2040,7 @@
 #endif
 	init_kmem_cache_node(n);
 	atomic_long_inc(&n->nr_slabs);
-	add_partial(n, page);
+	add_partial(n, page, 0);
 	return n;
 }
 

-- 
