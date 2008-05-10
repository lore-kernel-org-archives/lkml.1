Return-Path: <linux-kernel-owner+w=401wt.eu-S1758094AbYEJDLQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758094AbYEJDLQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 23:11:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753662AbYEJDJZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 23:09:25 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:55016 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751460AbYEJDJR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 23:09:17 -0400
Message-Id: <20080510030915.978978961@sgi.com>
References: <20080510030831.796641881@sgi.com>
User-Agent: quilt/0.46-1
Date: Fri, 09 May 2008 20:08:37 -0700
From: Christoph Lameter <clameter@sgi.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>
CC: linux-fsdevel@vger.kernel.org
Cc: Mel Gorman <mel@skynet.ie>
Cc: andi@firstfloor.org
Cc: Rik van Riel <riel@redhat.com>
Cc: mpm@selenic.com
Subject: [patch 06/21] slub: Add KICKABLE to avoid repeated kick() attempts
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
---
 mm/slub.c |   35 ++++++++++++++++++++++++++++++++---
 1 file changed, 32 insertions(+), 3 deletions(-)

Index: linux-2.6/mm/slub.c
===================================================================
--- linux-2.6.orig/mm/slub.c	2008-05-05 18:49:00.043910468 -0700
+++ linux-2.6/mm/slub.c	2008-05-05 18:49:10.851410275 -0700
@@ -103,6 +103,7 @@
  */
 
 #define FROZEN (1 << PG_active)
+#define KICKABLE (1 << PG_dirty)
 
 #ifdef CONFIG_SLUB_DEBUG
 #define SLABDEBUG (1 << PG_error)
@@ -140,6 +141,21 @@ static inline void ClearSlabDebug(struct
 	page->flags &= ~SLABDEBUG;
 }
 
+static inline int SlabKickable(struct page *page)
+{
+	return page->flags & KICKABLE;
+}
+
+static inline void SetSlabKickable(struct page *page)
+{
+	page->flags |= KICKABLE;
+}
+
+static inline void ClearSlabKickable(struct page *page)
+{
+	page->flags &= ~KICKABLE;
+}
+
 /*
  * Issues still to be resolved:
  *
@@ -1163,6 +1179,9 @@ static struct page *new_slab(struct kmem
 			SLAB_STORE_USER | SLAB_TRACE))
 		SetSlabDebug(page);
 
+	if (s->kick)
+		SetSlabKickable(page);
+
 	start = page_address(page);
 
 	if (unlikely(s->flags & SLAB_POISON))
@@ -1203,6 +1222,7 @@ static void __free_slab(struct kmem_cach
 		NR_SLAB_RECLAIMABLE : NR_SLAB_UNRECLAIMABLE,
 		-pages);
 
+	ClearSlabKickable(page);
 	__ClearPageSlab(page);
 	reset_page_mapcount(page);
 	__free_pages(page, order);
@@ -1412,6 +1432,8 @@ static void unfreeze_slab(struct kmem_ca
 			stat(c, DEACTIVATE_FULL);
 			if (SlabDebug(page) && (s->flags & SLAB_STORE_USER))
 				add_full(n, page);
+			if (s->kick)
+				SetSlabKickable(page);
 		}
 		slab_unlock(page);
 	} else {
@@ -2836,7 +2858,7 @@ static int kmem_cache_vacate(struct page
 	s = page->slab;
 	objects = page->objects;
 	map = scratch + objects * sizeof(void **);
-	if (!page->inuse || !s->kick)
+	if (!page->inuse || !s->kick || !SlabKickable(page))
 		goto out;
 
 	/* Determine used objects */
@@ -2874,6 +2896,9 @@ out:
 	 * Check the result and unfreeze the slab
 	 */
 	leftover = page->inuse;
+	if (leftover)
+		/* Unsuccessful reclaim. Avoid future reclaim attempts. */
+		ClearSlabKickable(page);
 	unfreeze_slab(s, page, leftover > 0);
 	local_irq_restore(flags);
 	return leftover;
@@ -2930,10 +2955,14 @@ static unsigned long __kmem_cache_shrink
 			continue;
 
 		if (page->inuse) {
-			if (page->inuse * 100 >=
+			if (!SlabKickable(page) || page->inuse * 100 >=
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
 

-- 
