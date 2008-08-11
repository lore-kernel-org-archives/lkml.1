Return-Path: <linux-kernel-owner+w=401wt.eu-S1754600AbYHKPQ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754600AbYHKPQ7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 11:16:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752195AbYHKPQt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 11:16:49 -0400
Received: from nlpi053.sbcis.sbc.com ([207.115.36.82]:60828 "EHLO
	nlpi053.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752009AbYHKPQs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 11:16:48 -0400
Message-Id: <20080811150656.117393595@quilx.com>
References: <20080811150616.207532384@quilx.com>
User-Agent: quilt/0.46-1
Date: Mon, 11 Aug 2008 08:06:22 -0700
From: Christoph Lameter <cl@linux-foundation.org>
To: Pekka Enberg <penberg@cs.helsinki.fi>
CC: akpm@linux-foundation.org, Christoph Lameter <clameter@sgi.com>,
       Christoph Lameter <cl@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
CC: linux-fsdevel@vger.kernel.org
Cc: Mel Gorman <mel@skynet.ie>
Cc: andi@firstfloor.org
Cc: Rik van Riel <riel@redhat.com>
Cc: mpm@selenic.com
Cc: Dave Chinner <david@fromorbit.com>
Subject: [patch 06/19] slub: Add KICKABLE to avoid repeated kick() attempts
Content-Disposition: inline; filename=0006-SLUB-Add-KICKABLE-to-avoid-repeated-kick-attempts.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a flag KICKABLE to be set on slabs with a defragmentation method

Clear the flag if a kick action is not successful in reducing the
number of objects in a slab. This will avoid future attempts to
kick objects out.

The KICKABLE flag is set again when all objects of the slab have been
allocated (Occurs during removal of a slab from the partial lists).

Reviewed-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Christoph Lameter <cl@linux-foundation.org>

---
 include/linux/page-flags.h |    2 ++
 mm/slub.c                  |   23 ++++++++++++++++++-----
 2 files changed, 20 insertions(+), 5 deletions(-)

Index: linux-next/mm/slub.c
===================================================================
--- linux-next.orig/mm/slub.c	2008-08-11 07:47:01.482348822 -0700
+++ linux-next/mm/slub.c	2008-08-11 07:50:09.282347574 -0700
@@ -1138,6 +1138,9 @@ static struct page *new_slab(struct kmem
 			SLAB_STORE_USER | SLAB_TRACE))
 		__SetPageSlubDebug(page);
 
+	if (s->kick)
+		__SetPageSlubKickable(page);
+
 	start = page_address(page);
 
 	if (unlikely(s->flags & SLAB_POISON))
@@ -1181,6 +1184,7 @@ static void __free_slab(struct kmem_cach
 		NR_SLAB_RECLAIMABLE : NR_SLAB_UNRECLAIMABLE,
 		-pages);
 
+	__ClearPageSlubKickable(page);
 	__ClearPageSlab(page);
 	reset_page_mapcount(page);
 	__free_pages(page, order);
@@ -1391,6 +1395,8 @@ static void unfreeze_slab(struct kmem_ca
 			if (SLABDEBUG && PageSlubDebug(page) &&
 						(s->flags & SLAB_STORE_USER))
 				add_full(n, page);
+			if (s->kick)
+				__SetPageSlubKickable(page);
 		}
 		slab_unlock(page);
 	} else {
@@ -2820,12 +2826,12 @@ static int kmem_cache_vacate(struct page
 	slab_lock(page);
 
 	BUG_ON(!PageSlab(page));	/* Must be s slab page */
-	BUG_ON(!SlabFrozen(page));	/* Slab must have been frozen earlier */
+	BUG_ON(!PageSlubFrozen(page));	/* Slab must have been frozen earlier */
 
 	s = page->slab;
 	objects = page->objects;
 	map = scratch + objects * sizeof(void **);
-	if (!page->inuse || !s->kick)
+	if (!page->inuse || !s->kick || !PageSlubKickable(page))
 		goto out;
 
 	/* Determine used objects */
@@ -2863,6 +2869,9 @@ out:
 	 * Check the result and unfreeze the slab
 	 */
 	leftover = page->inuse;
+	if (leftover)
+		/* Unsuccessful reclaim. Avoid future reclaim attempts. */
+		__ClearPageSlubKickable(page);
 	unfreeze_slab(s, page, leftover > 0);
 	local_irq_restore(flags);
 	return leftover;
@@ -2924,17 +2933,21 @@ static unsigned long __kmem_cache_shrink
 			continue;
 
 		if (page->inuse) {
-			if (page->inuse * 100 >=
+			if (!PageSlubKickable(page) || page->inuse * 100 >=
 					s->defrag_ratio * page->objects) {
 				slab_unlock(page);
-				/* Slab contains enough objects */
+				/*
+				 * Slab contains enough objects
+				 * or we alrady tried reclaim before and
+				 * it failed. Skip this one.
+				 */
 				continue;
 			}
 
 			list_move(&page->lru, &zaplist);
 			if (s->kick) {
 				n->nr_partial--;
-				SetSlabFrozen(page);
+				__SetPageSlubFrozen(page);
 			}
 			slab_unlock(page);
 		} else {
Index: linux-next/include/linux/page-flags.h
===================================================================
--- linux-next.orig/include/linux/page-flags.h	2008-08-11 07:42:31.882358716 -0700
+++ linux-next/include/linux/page-flags.h	2008-08-11 07:47:01.612357581 -0700
@@ -112,6 +112,7 @@ enum pageflags {
 	/* SLUB */
 	PG_slub_frozen = PG_active,
 	PG_slub_debug = PG_error,
+	PG_slub_kickable = PG_dirty,
 };
 
 #ifndef __GENERATING_BOUNDS_H
@@ -182,6 +183,7 @@ __PAGEFLAG(SlobFree, slob_free)
 
 __PAGEFLAG(SlubFrozen, slub_frozen)
 __PAGEFLAG(SlubDebug, slub_debug)
+__PAGEFLAG(SlubKickable, slub_kickable)
 
 /*
  * Only test-and-set exist for PG_writeback.  The unconditional operators are

-- 
