Return-Path: <linux-kernel-owner+w=401wt.eu-S1423157AbXDXW1s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423157AbXDXW1s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 18:27:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423177AbXDXW1Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 18:27:24 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:56815 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1423157AbXDXWXH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 18:23:07 -0400
Message-Id: <20070424222307.239645403@sgi.com>
References: <20070424222105.883597089@sgi.com>
User-Agent: quilt/0.45-1
Date: Tue, 24 Apr 2007 15:21:17 -0700
From: clameter@sgi.com
To: linux-kernel@vger.kernel.org
Cc: Mel Gorman <mel@skynet.ie>, William Lee Irwin III <wli@holomorphy.com>,
       David Chinner <dgc@sgi.com>, Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: [12/17] Variable Page Cache Size: Fix up reclaim counters
Content-Disposition: inline; filename=var_pc_reclaim
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

We can now reclaim larger pages. Adjust the VM counters to deal with it.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 mm/vmscan.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

Index: linux-2.6.21-rc7/mm/vmscan.c
===================================================================
--- linux-2.6.21-rc7.orig/mm/vmscan.c	2007-04-23 22:15:30.000000000 -0700
+++ linux-2.6.21-rc7/mm/vmscan.c	2007-04-23 22:19:21.000000000 -0700
@@ -471,14 +471,14 @@ static unsigned long shrink_page_list(st
 
 		VM_BUG_ON(PageActive(page));
 
-		sc->nr_scanned++;
+		sc->nr_scanned += compound_pages(page);
 
 		if (!sc->may_swap && page_mapped(page))
 			goto keep_locked;
 
 		/* Double the slab pressure for mapped and swapcache pages */
 		if (page_mapped(page) || PageSwapCache(page))
-			sc->nr_scanned++;
+			sc->nr_scanned += compound_pages(page);
 
 		if (PageWriteback(page))
 			goto keep_locked;
@@ -581,7 +581,7 @@ static unsigned long shrink_page_list(st
 
 free_it:
 		unlock_page(page);
-		nr_reclaimed++;
+		nr_reclaimed += compound_pages(page);
 		if (!pagevec_add(&freed_pvec, page))
 			__pagevec_release_nonlru(&freed_pvec);
 		continue;
@@ -627,7 +627,7 @@ static unsigned long isolate_lru_pages(u
 	struct page *page;
 	unsigned long scan;
 
-	for (scan = 0; scan < nr_to_scan && !list_empty(src); scan++) {
+	for (scan = 0; scan < nr_to_scan && !list_empty(src); ) {
 		struct list_head *target;
 		page = lru_to_page(src);
 		prefetchw_prev_lru_page(page, src, flags);
@@ -644,10 +644,11 @@ static unsigned long isolate_lru_pages(u
 			 */
 			ClearPageLRU(page);
 			target = dst;
-			nr_taken++;
+			nr_taken += compound_pages(page);
 		} /* else it is being freed elsewhere */
 
 		list_add(&page->lru, target);
+		scan += compound_pages(page);
 	}
 
 	*scanned = scan;
@@ -856,7 +857,7 @@ force_reclaim_mapped:
 		ClearPageActive(page);
 
 		list_move(&page->lru, &zone->inactive_list);
-		pgmoved++;
+		pgmoved += compound_pages(page);
 		if (!pagevec_add(&pvec, page)) {
 			__mod_zone_page_state(zone, NR_INACTIVE, pgmoved);
 			spin_unlock_irq(&zone->lru_lock);
@@ -884,7 +885,7 @@ force_reclaim_mapped:
 		SetPageLRU(page);
 		VM_BUG_ON(!PageActive(page));
 		list_move(&page->lru, &zone->active_list);
-		pgmoved++;
+		pgmoved += compound_pages(page);
 		if (!pagevec_add(&pvec, page)) {
 			__mod_zone_page_state(zone, NR_ACTIVE, pgmoved);
 			pgmoved = 0;

--
