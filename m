Return-Path: <linux-kernel-owner+w=401wt.eu-S1754195AbXKDUav@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754195AbXKDUav (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2007 15:30:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752861AbXKDUan
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Nov 2007 15:30:43 -0500
Received: from smtp.cs.utexas.edu ([128.83.120.210]:38247 "EHLO
	smtp.cs.utexas.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751176AbXKDUam (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2007 15:30:42 -0500
X-Greylist: delayed 2309 seconds by postgrey-1.27 at vger.kernel.org; Sun, 04 Nov 2007 15:30:42 EST
Date: Sun, 4 Nov 2007 13:52:12 -0600
From: Don Porter <porterde@cs.utexas.edu>
To: linux-kernel@vger.kernel.org
Subject: [RFC/PATCH] Optimize zone allocator synchronization
Message-ID: <20071104195212.GF16354@olive-green.cs.utexas.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Donald E. Porter <porterde@cs.utexas.edu>

In the bulk page allocation/free routines in mm/page_alloc.c, the zone
lock is held across all iterations.  For certain parallel workloads, I
have found that releasing and reacquiring the lock for each iteration
yields better performance, especially at higher CPU counts.  For
instance, kernel compilation is sped up by 5% on an 8 CPU test
machine.  In most cases, there is no significant effect on performance
(although the effect tends to be slightly positive).  This seems quite
reasonable for the very small scope of the change.

My intuition is that this patch prevents smaller requests from waiting
on larger ones.  While grabbing and releasing the lock within the loop
adds a few instructions, it can lower the latency for a particular
thread's allocation which is often on the thread's critical path.
Lowering the average latency for allocation can increase system throughput.

More detailed information, including data from the tests I ran to
validate this change are available at
http://www.cs.utexas.edu/~porterde/kernel-patch.html .

Thanks in advance for your consideration and feedback.

Don

Signed-off-by: Donald E. Porter <porterde@cs.utexas.edu>

---

diff -uprN linux-2.6.23.1/mm/page_alloc.c linux-2.6.23.1-opt/mm/page_alloc.c
--- linux-2.6.23.1/mm/page_alloc.c	2007-10-12 11:43:44.000000000 -0500
+++ linux-2.6.23.1-opt/mm/page_alloc.c	2007-10-29 18:29:05.000000000 -0500
@@ -477,19 +477,19 @@ static inline int free_pages_check(struc
 static void free_pages_bulk(struct zone *zone, int count,
 					struct list_head *list, int order)
 {
-	spin_lock(&zone->lock);
 	zone->all_unreclaimable = 0;
 	zone->pages_scanned = 0;
 	while (count--) {
 		struct page *page;
+		spin_lock(&zone->lock);
 
 		VM_BUG_ON(list_empty(list));
 		page = list_entry(list->prev, struct page, lru);
 		/* have to delete it as __free_one_page list manipulates */
 		list_del(&page->lru);
 		__free_one_page(page, zone, order);
+		spin_unlock(&zone->lock);
 	}
-	spin_unlock(&zone->lock);
 }
 
 static void free_one_page(struct zone *zone, struct page *page, int order)
@@ -665,14 +665,17 @@ static int rmqueue_bulk(struct zone *zon
 {
 	int i;
 	
-	spin_lock(&zone->lock);
 	for (i = 0; i < count; ++i) {
-		struct page *page = __rmqueue(zone, order);
+		struct page *page;
+		spin_lock(&zone->lock);
+
+		page = __rmqueue(zone, order);
 		if (unlikely(page == NULL))
 			break;
 		list_add_tail(&page->lru, list);
+		spin_unlock(&zone->lock);
 	}
-	spin_unlock(&zone->lock);
+
 	return i;
 }
 
