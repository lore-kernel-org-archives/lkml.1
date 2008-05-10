Return-Path: <linux-kernel-owner+w=401wt.eu-S1758597AbYHASdA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758597AbYHASdA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 14:33:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753396AbYHAScM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 14:32:12 -0400
Received: from nlpi053.sbcis.sbc.com ([207.115.36.82]:3737 "EHLO
	nlpi053.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752969AbYHAScK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 14:32:10 -0400
Message-Id: <20080801182345.270090673@lameter.com>
References: <20080801182324.572058187@lameter.com>
User-Agent: quilt/0.46-1
Date: Fri, 09 May 2008 19:21:07 -0700
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
 mm/slub.c |   35 ++++++++++++++++++++++++++++++++---
 1 file changed, 32 insertions(+), 3 deletions(-)

Index: linux-2.6/mm/slub.c
===================================================================
--- linux-2.6.orig/mm/slub.c	2008-07-31 12:19:28.000000000 -0500
+++ linux-2.6/mm/slub.c	2008-07-31 12:19:39.000000000 -0500
@@ -1130,6 +1130,9 @@
 			SLAB_STORE_USER | SLAB_TRACE))
 		__SetPageSlubDebug(page);
 
+	if (s->kick)
+		__SetPageSlubKickable(page);
+
 	start = page_address(page);
 
 	if (unlikely(s->flags & SLAB_POISON))
@@ -1170,6 +1173,7 @@
 		NR_SLAB_RECLAIMABLE : NR_SLAB_UNRECLAIMABLE,
 		-pages);
 
+	__ClearPageSlubKickable(page);
 	__ClearPageSlab(page);
 	reset_page_mapcount(page);
 	__free_pages(page, order);
@@ -1380,6 +1384,8 @@
 			if (SLABDEBUG && PageSlubDebug(page) &&
 						(s->flags & SLAB_STORE_USER))
 				add_full(n, page);
+			if (s->kick)
+				__SetPageSlubKickable(page);
 		}
 		slab_unlock(page);
 	} else {
@@ -2795,12 +2801,12 @@
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
@@ -2838,6 +2844,9 @@
 	 * Check the result and unfreeze the slab
 	 */
 	leftover = page->inuse;
+	if (leftover)
+		/* Unsuccessful reclaim. Avoid future reclaim attempts. */
+		__ClearPageSlubKickable(page);
 	unfreeze_slab(s, page, leftover > 0);
 	local_irq_restore(flags);
 	return leftover;
@@ -2899,17 +2908,21 @@
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
Index: linux-2.6/include/linux/page-flags.h
===================================================================
--- linux-2.6.orig/include/linux/page-flags.h	2008-07-31 12:19:25.000000000 -0500
+++ linux-2.6/include/linux/page-flags.h	2008-07-31 12:19:28.000000000 -0500
@@ -112,6 +112,7 @@
 	/* SLUB */
 	PG_slub_frozen = PG_active,
 	PG_slub_debug = PG_error,
+	PG_slub_kickable = PG_dirty,
 };
 
 #ifndef __GENERATING_BOUNDS_H
@@ -182,6 +183,7 @@
 
 __PAGEFLAG(SlubFrozen, slub_frozen)
 __PAGEFLAG(SlubDebug, slub_debug)
+__PAGEFLAG(SlubKickable, slub_kickable)
 
 /*
  * Only test-and-set exist for PG_writeback.  The unconditional operators are

-- 
