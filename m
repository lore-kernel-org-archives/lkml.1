Return-Path: <linux-kernel-owner+w=401wt.eu-S1761596AbXENAyr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761596AbXENAyr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 20:54:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758355AbXENAyk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 20:54:40 -0400
Received: from mail36.syd.optusnet.com.au ([211.29.133.76]:35894 "EHLO
	mail36.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756561AbXENAyj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 20:54:39 -0400
From: Con Kolivas <kernel@kolivas.org>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Andrew Morton <akpm@linux-foundation.org>, ck@vds.kolivas.org
Subject: [PATCH] mm: swap prefetch more improvements
Date: Mon, 14 May 2007 10:50:54 +1000
User-Agent: KMail/1.9.5
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705141050.55038.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

akpm, please queue on top of "mm: swap prefetch improvements"

---
Failed radix_tree_insert wasn't being handled leaving stale kmem.

The list should be iterated over in the reverse order when prefetching.

Make the yield within kprefetchd stronger through the use of cond_resched.

Check that the pos entry hasn't been removed while unlocked.

Signed-off-by: Con Kolivas <kernel@kolivas.org>

---
 mm/swap_prefetch.c |   19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

Index: linux-2.6.21-ck1/mm/swap_prefetch.c
===================================================================
--- linux-2.6.21-ck1.orig/mm/swap_prefetch.c	2007-05-14 09:39:37.000000000 +1000
+++ linux-2.6.21-ck1/mm/swap_prefetch.c	2007-05-14 10:21:47.000000000 +1000
@@ -117,7 +117,8 @@ void add_to_swapped_list(struct page *pa
 	if (likely(!radix_tree_insert(&swapped.swap_tree, index, entry))) {
 		list_add(&entry->swapped_list, &swapped.list);
 		swapped.count++;
-	}
+	} else
+		kmem_cache_free(swapped.cache, entry);
 
 out_locked:
 	spin_unlock_irqrestore(&swapped.lock, flags);
@@ -427,7 +428,7 @@ out:
 static enum trickle_return trickle_swap(void)
 {
 	enum trickle_return ret = TRICKLE_DELAY;
-	struct list_head *p, *next;
+	struct swapped_entry *pos, *n;
 	unsigned long flags;
 
 	if (!prefetch_enabled())
@@ -440,19 +441,19 @@ static enum trickle_return trickle_swap(
 		return TRICKLE_FAILED;
 
 	spin_lock_irqsave(&swapped.lock, flags);
-	list_for_each_safe(p, next, &swapped.list) {
-		struct swapped_entry *entry;
+	list_for_each_entry_safe_reverse(pos, n, &swapped.list, swapped_list) {
 		swp_entry_t swp_entry;
 		int node;
 
 		spin_unlock_irqrestore(&swapped.lock, flags);
-		might_sleep();
-		if (!prefetch_suitable())
+		/* Yield to anything else running */
+		if (cond_resched() || !prefetch_suitable())
 			goto out_unlocked;
 
 		spin_lock_irqsave(&swapped.lock, flags);
-		entry = list_entry(p, struct swapped_entry, swapped_list);
-		node = get_swap_entry_node(entry);
+		if (unlikely(!pos))
+			continue;
+		node = get_swap_entry_node(pos);
 		if (!node_isset(node, sp_stat.prefetch_nodes)) {
 			/*
 			 * We found an entry that belongs to a node that is
@@ -460,7 +461,7 @@ static enum trickle_return trickle_swap(
 			 */
 			continue;
 		}
-		swp_entry = entry->swp_entry;
+		swp_entry = pos->swp_entry;
 		spin_unlock_irqrestore(&swapped.lock, flags);
 
 		if (trickle_swap_cache_async(swp_entry, node) == TRICKLE_DELAY)

-- 
-ck
