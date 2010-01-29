Return-Path: <linux-kernel-owner+w=401wt.eu-S1754356Ab0A2UvK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754356Ab0A2UvK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 15:51:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753454Ab0A2UvJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 15:51:09 -0500
Received: from nlpi157.sbcis.sbc.com ([207.115.36.171]:42605 "EHLO
	nlpi157.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753443Ab0A2UvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 15:51:08 -0500
Message-Id: <20100129205008.370029854@quilx.com>
References: <20100129204931.789743493@quilx.com>
User-Agent: quilt/0.46-1
Date: Fri, 29 Jan 2010 14:49:49 -0600
From: Christoph Lameter <cl@linux-foundation.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: akpm@linux-foundation.org
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: linux-kernel@vger.kernel.org
Subject: slub defrag: Transition patch upstream -> -next
Content-Disposition: inline; filename=fixup-next
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The slub statistics have been simplified through the use of per cpu
operations in -next. In order for this patchset to compile applied to the
 -next tree the following changes need to be made.

Signed-off-by: Christoph Lameter <cl@linux-foundation.org>


---
 mm/slub.c |   14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

Index: slab-2.6/mm/slub.c
===================================================================
--- slab-2.6.orig/mm/slub.c	2010-01-29 12:26:52.000000000 -0600
+++ slab-2.6/mm/slub.c	2010-01-29 12:28:28.000000000 -0600
@@ -2906,7 +2906,6 @@ static int kmem_cache_vacate(struct page
 	void *private;
 	unsigned long flags;
 	unsigned long objects;
-	struct kmem_cache_cpu *c;
 
 	local_irq_save(flags);
 	slab_lock(page);
@@ -2955,13 +2954,12 @@ out:
 	 * Check the result and unfreeze the slab
 	 */
 	leftover = page->inuse;
-	c = get_cpu_slab(s, smp_processor_id());
 	if (leftover) {
 		/* Unsuccessful reclaim. Avoid future reclaim attempts. */
-		stat(c, SHRINK_OBJECT_RECLAIM_FAILED);
+		stat(s, SHRINK_OBJECT_RECLAIM_FAILED);
 		__ClearPageSlubKickable(page);
 	} else
-		stat(c, SHRINK_SLAB_RECLAIMED);
+		stat(s, SHRINK_SLAB_RECLAIMED);
 	unfreeze_slab(s, page, leftover > 0);
 	local_irq_restore(flags);
 	return leftover;
@@ -3012,14 +3010,12 @@ static unsigned long __kmem_cache_shrink
 	LIST_HEAD(zaplist);
 	int freed = 0;
 	struct kmem_cache_node *n = get_node(s, node);
-	struct kmem_cache_cpu *c;
 
 	if (n->nr_partial <= limit)
 		return 0;
 
 	spin_lock_irqsave(&n->list_lock, flags);
-	c = get_cpu_slab(s, smp_processor_id());
-	stat(c, SHRINK_CALLS);
+	stat(s, SHRINK_CALLS);
 	list_for_each_entry_safe(page, page2, &n->partial, lru) {
 		if (!slab_trylock(page))
 			/* Busy slab. Get out of the way */
@@ -3039,14 +3035,14 @@ static unsigned long __kmem_cache_shrink
 
 			list_move(&page->lru, &zaplist);
 			if (s->kick) {
-				stat(c, SHRINK_ATTEMPT_DEFRAG);
+				stat(s, SHRINK_ATTEMPT_DEFRAG);
 				n->nr_partial--;
 				__SetPageSlubFrozen(page);
 			}
 			slab_unlock(page);
 		} else {
 			/* Empty slab page */
-			stat(c, SHRINK_EMPTY_SLAB);
+			stat(s, SHRINK_EMPTY_SLAB);
 			list_del(&page->lru);
 			n->nr_partial--;
 			slab_unlock(page);

-- 
