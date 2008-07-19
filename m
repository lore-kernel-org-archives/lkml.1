Return-Path: <linux-kernel-owner+w=401wt.eu-S1756727AbYGSMcp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756727AbYGSMcp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2008 08:32:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755794AbYGSMcS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jul 2008 08:32:18 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:35483 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756281AbYGSMcR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2008 08:32:17 -0400
Date: Sat, 19 Jul 2008 15:32:06 +0300 (EEST)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: linux-kernel@vger.kernel.org, cl@linux-foundation.org,
       akpm@linux-foundation.org, riel@redhat.com
Subject: [PATCH 6/8] slub: Add KICKABLE to avoid repeated kick() attempts
Message-ID: <Pine.LNX.4.64.0807191531460.13345@sbz-30.cs.Helsinki.FI>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christoph Lameter <clameter@sgi.com>

Add a flag KICKABLE to be set on slabs with a defragmentation method

Clear the flag if a kick action is not successful in reducing the
number of objects in a slab. This will avoid future attempts to
kick objects out.

The KICKABLE flag is set again when all objects of the slab have been
allocated (Occurs during removal of a slab from the partial lists).

[penberg@cs.helsinki.fi: convert to the new pageflag conventions.]
Reviewed-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 include/linux/page-flags.h |    1 +
 mm/slub.c                  |   19 ++++++++++++++++---
 2 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index 0d2a4e7..e532939 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -161,6 +161,7 @@ PAGEFLAG(SavePinned, dirty);					/* Xen */
 PAGEFLAG(Reserved, reserved) __CLEARPAGEFLAG(Reserved, reserved)
 PAGEFLAG(Private, private) __CLEARPAGEFLAG(Private, private)
 	__SETPAGEFLAG(Private, private)
+PAGEFLAG(SlabKickable, dirty)
 
 /*
  * Only test-and-set exist for PG_writeback.  The unconditional operators are
diff --git a/mm/slub.c b/mm/slub.c
index b8d70ba..b768183 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -1162,6 +1162,9 @@ static struct page *new_slab(struct kmem_cache *s, gfp_t flags, int node)
 			SLAB_STORE_USER | SLAB_TRACE))
 		SetSlabDebug(page);
 
+	if (s->kick)
+		SetPageSlabKickable(page);
+
 	start = page_address(page);
 
 	if (unlikely(s->flags & SLAB_POISON))
@@ -1202,6 +1205,7 @@ static void __free_slab(struct kmem_cache *s, struct page *page)
 		NR_SLAB_RECLAIMABLE : NR_SLAB_UNRECLAIMABLE,
 		-pages);
 
+	ClearPageSlabKickable(page);
 	__ClearPageSlab(page);
 	reset_page_mapcount(page);
 	__free_pages(page, order);
@@ -1411,6 +1415,8 @@ static void unfreeze_slab(struct kmem_cache *s, struct page *page, int tail)
 			stat(c, DEACTIVATE_FULL);
 			if (SlabDebug(page) && (s->flags & SLAB_STORE_USER))
 				add_full(n, page);
+			if (s->kick)
+				SetPageSlabKickable(page);
 		}
 		slab_unlock(page);
 	} else {
@@ -2839,7 +2845,7 @@ static int kmem_cache_vacate(struct page *page, void *scratch)
 	s = page->slab;
 	objects = page->objects;
 	map = scratch + objects * sizeof(void **);
-	if (!page->inuse || !s->kick)
+	if (!page->inuse || !s->kick || !PageSlabKickable(page))
 		goto out;
 
 	/* Determine used objects */
@@ -2877,6 +2883,9 @@ out:
 	 * Check the result and unfreeze the slab
 	 */
 	leftover = page->inuse;
+	if (leftover)
+		/* Unsuccessful reclaim. Avoid future reclaim attempts. */
+		ClearPageSlabKickable(page);
 	unfreeze_slab(s, page, leftover > 0);
 	local_irq_restore(flags);
 	return leftover;
@@ -2938,10 +2947,14 @@ static unsigned long __kmem_cache_shrink(struct kmem_cache *s, int node,
 			continue;
 
 		if (page->inuse) {
-			if (page->inuse * 100 >=
+			if (!PageSlabKickable(page) || page->inuse * 100 >=
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
1.5.4.3

