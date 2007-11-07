Return-Path: <linux-kernel-owner+w=401wt.eu-S1757939AbXKGBUI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757939AbXKGBUI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 20:20:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756231AbXKGBMu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 20:12:50 -0500
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:44734 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755439AbXKGBMe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 20:12:34 -0500
Message-Id: <20071107011232.167279850@sgi.com>
References: <20071107011130.382244340@sgi.com>
User-Agent: quilt/0.46-1
Date: Tue, 06 Nov 2007 17:11:53 -0800
From: Christoph Lameter <clameter@sgi.com>
To: akpm@linux-foundatin.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org
Cc: Mel Gorman <mel@skynet.ie>
Subject: [patch 23/23] SLUB: Add SlabReclaimable() to avoid repeated reclaim attempts
Content-Disposition: inline; filename=0013-slab_defrag_reclaim_flag.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add a flag RECLAIMABLE to be set on slabs with a defragmentation method

Clear the flag if a reclaim action is not successful in reducing the
number of objects in a slab.

The reclaim flag is set again when all objeccts of the slab have been
allocated and it is removed from the partial lists.

Reviewed-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Christoph Lameter <clameter@sgi.com>
---
 mm/slub.c |   20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

Index: linux-2.6/mm/slub.c
===================================================================
--- linux-2.6.orig/mm/slub.c	2007-11-06 17:06:46.000000000 -0800
+++ linux-2.6/mm/slub.c	2007-11-06 17:07:54.000000000 -0800
@@ -102,6 +102,7 @@
 
 #define FROZEN (1 << PG_active)
 #define LOCKED (1 << PG_locked)
+#define RECLAIMABLE (1 << PG_dirty)
 
 #ifdef CONFIG_SLUB_DEBUG
 #define SLABDEBUG (1 << PG_error)
@@ -1100,6 +1101,8 @@ static noinline struct page *new_slab(st
 	if (s->flags & (SLAB_DEBUG_FREE | SLAB_RED_ZONE | SLAB_POISON |
 			SLAB_STORE_USER | SLAB_TRACE))
 		state |= SLABDEBUG;
+	if (s->kick)
+		state |= RECLAIMABLE;
 
 	start = page_address(page);
 	page->end = start + 1;
@@ -1176,6 +1179,7 @@ static void discard_slab(struct kmem_cac
 
 	atomic_long_dec(&n->nr_slabs);
 	reset_page_mapcount(page);
+	page->flags &= ~RECLAIMABLE;
 	__ClearPageSlab(page);
 	free_slab(s, page);
 }
@@ -1408,8 +1412,11 @@ static void unfreeze_slab(struct kmem_ca
 
 		if (page->freelist != page->end)
 			add_partial(s, page, tail);
-		else
+		else {
 			add_full(s, page, state);
+			if (s->kick && !(state & RECLAIMABLE))
+				state |= RECLAIMABLE;
+		}
 		slab_unlock(page, state);
 
 	} else {
@@ -2633,7 +2640,7 @@ out:
  * Check if the given state is that of a reclaimable slab page.
  *
  * This is only true if this is indeed a slab page and if
- * the page has not been frozen.
+ * the page has not been frozen or marked as unreclaimable.
  */
 static inline int reclaimable_slab(unsigned long state)
 {
@@ -2643,7 +2650,7 @@ static inline int reclaimable_slab(unsig
 	if (state & FROZEN)
 		return 0;
 
-	return 1;
+	return state & RECLAIMABLE;
 }
 
  /*
@@ -2958,6 +2965,8 @@ out:
 	 * Check the result and unfreeze the slab
 	 */
 	leftover = page->inuse;
+	if (leftover)
+		state &= ~RECLAIMABLE;
 	unfreeze_slab(s, page, leftover > 0, state);
 	local_irq_restore(flags);
 	return leftover;
@@ -3012,6 +3021,11 @@ static unsigned long __kmem_cache_shrink
 		if (!state)
 			continue;
 
+		if (!(state & RECLAIMABLE)) {
+			slab_unlock(page, state);
+			continue;
+		}
+
 		if (page->inuse) {
 
 			list_move(&page->lru, &zaplist);

-- 
