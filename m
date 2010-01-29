Return-Path: <linux-kernel-owner+w=401wt.eu-S1755359Ab0A2Uva@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755359Ab0A2Uva (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 15:51:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755246Ab0A2UvW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 15:51:22 -0500
Received: from nlpi157.sbcis.sbc.com ([207.115.36.171]:42793 "EHLO
	nlpi157.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755089Ab0A2UvU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 15:51:20 -0500
Message-Id: <20100129205001.371949241@quilx.com>
References: <20100129204931.789743493@quilx.com>
User-Agent: quilt/0.46-1
Date: Fri, 29 Jan 2010 14:49:37 -0600
From: Christoph Lameter <cl@linux-foundation.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Dave Chinner <david@fromorbit.com>, Christoph Lameter <clameter@sgi.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Rik van Riel <riel@redhat.com>
Cc: akpm@linux-foundation.org
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: linux-kernel@vger.kernel.org
Subject: slub: Add KICKABLE to avoid repeated kick() attempts
Content-Disposition: inline; filename=slub_add_kickable
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

Index: slab-2.6/mm/slub.c
===================================================================
--- slab-2.6.orig/mm/slub.c	2010-01-22 15:47:48.000000000 -0600
+++ slab-2.6/mm/slub.c	2010-01-22 15:49:30.000000000 -0600
@@ -1168,6 +1168,9 @@ static struct page *new_slab(struct kmem
 			SLAB_STORE_USER | SLAB_TRACE))
 		__SetPageSlubDebug(page);
 
+	if (s->kick)
+		__SetPageSlubKickable(page);
+
 	start = page_address(page);
 
 	if (unlikely(s->flags & SLAB_POISON))
@@ -1210,6 +1213,7 @@ static void __free_slab(struct kmem_cach
 		NR_SLAB_RECLAIMABLE : NR_SLAB_UNRECLAIMABLE,
 		-pages);
 
+	__ClearPageSlubKickable(page);
 	__ClearPageSlab(page);
 	reset_page_mapcount(page);
 	if (current->reclaim_state)
@@ -1421,6 +1425,8 @@ static void unfreeze_slab(struct kmem_ca
 			if (SLABDEBUG && PageSlubDebug(page) &&
 						(s->flags & SLAB_STORE_USER))
 				add_full(n, page);
+			if (s->kick)
+				__SetPageSlubKickable(page);
 		}
 		slab_unlock(page);
 	} else {
@@ -2905,12 +2911,12 @@ static int kmem_cache_vacate(struct page
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
@@ -2948,6 +2954,9 @@ out:
 	 * Check the result and unfreeze the slab
 	 */
 	leftover = page->inuse;
+	if (leftover)
+		/* Unsuccessful reclaim. Avoid future reclaim attempts. */
+		__ClearPageSlubKickable(page);
 	unfreeze_slab(s, page, leftover > 0);
 	local_irq_restore(flags);
 	return leftover;
@@ -3009,17 +3018,21 @@ static unsigned long __kmem_cache_shrink
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
Index: slab-2.6/include/linux/page-flags.h
===================================================================
--- slab-2.6.orig/include/linux/page-flags.h	2010-01-22 15:09:43.000000000 -0600
+++ slab-2.6/include/linux/page-flags.h	2010-01-22 15:49:30.000000000 -0600
@@ -129,6 +129,7 @@ enum pageflags {
 	/* SLUB */
 	PG_slub_frozen = PG_active,
 	PG_slub_debug = PG_error,
+	PG_slub_kickable = PG_dirty,
 };
 
 #ifndef __GENERATING_BOUNDS_H
@@ -216,6 +217,7 @@ __PAGEFLAG(SlobFree, slob_free)
 
 __PAGEFLAG(SlubFrozen, slub_frozen)
 __PAGEFLAG(SlubDebug, slub_debug)
+__PAGEFLAG(SlubKickable, slub_kickable)
 
 /*
  * Private page markings that may be used by the filesystem that owns the page

-- 
