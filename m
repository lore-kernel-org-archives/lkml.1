Return-Path: <linux-kernel-owner+w=401wt.eu-S1752387AbXB0Te4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752387AbXB0Te4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 14:34:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752079AbXB0Te4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 14:34:56 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:36104 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752387AbXB0Tez (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 14:34:55 -0500
From: Andy Whitcroft <apw@shadowen.org>
To: Andrew Morton <akpm@osdl.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       Andy Whitcroft <apw@shadowen.org>, Mel Gorman <mel@csn.ul.ie>
Subject: [PATCH 2/5] lumpy: isolate_lru_pages wants to specifically take active or inactive pages
References: <exportbomb.1172604830@kernel>
InReply-To: <exportbomb.1172604830@kernel>
Message-ID: <f2cdac47f652dc10d19f6041997e85b1@kernel>
Date: Tue, 27 Feb 2007 11:34:52 -0800
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


The caller of isolate_lru_pages specifically knows whether it wants
to take either inactive or active pages.  Currently we take the
state of the LRU page at hand and use that to scan for matching
pages in the order sized block.  If that page is transiting we
can scan for the wrong type.  The caller knows what they want and
should be telling us.  Pass in the required active/inactive state
and match against that.

Note, that now we pass the expected active state when scanning the
active/inactive lists we may find missmatching target pages, pages
which are in the process of changing state.  This is no longer an
error and we should simply ignore them.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
---
diff --git a/mm/vmscan.c b/mm/vmscan.c
index f15ffcb..b878d54 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -663,12 +663,13 @@ static int __isolate_lru_page(struct page *page, int active)
  * @dst:	The temp list to put pages on to.
  * @scanned:	The number of pages that were scanned.
  * @order:	The caller's attempted allocation order
+ * @active:	The caller's trying to obtain active or inactive pages
  *
  * returns how many pages were moved onto *@dst.
  */
 static unsigned long isolate_lru_pages(unsigned long nr_to_scan,
 		struct list_head *src, struct list_head *dst,
-		unsigned long *scanned, int order)
+		unsigned long *scanned, int order, int active)
 {
 	unsigned long nr_taken = 0;
 	unsigned long scan;
@@ -678,7 +679,6 @@ static unsigned long isolate_lru_pages(unsigned long nr_to_scan,
 		unsigned long pfn;
 		unsigned long end_pfn;
 		unsigned long page_pfn;
-		int active;
 		int zone_id;
 
 		page = lru_to_page(src);
@@ -686,20 +686,16 @@ static unsigned long isolate_lru_pages(unsigned long nr_to_scan,
 
 		VM_BUG_ON(!PageLRU(page));
 
-		active = PageActive(page);
 		switch (__isolate_lru_page(page, active)) {
 		case 0:
 			list_move(&page->lru, dst);
 			nr_taken++;
 			break;
 
-		case -EBUSY:
-			/* else it is being freed elsewhere */
+		default:
+			/* page is being freed, or is a missmatch */
 			list_move(&page->lru, src);
 			continue;
-
-		default:
-			BUG();
 		}
 
 		if (!order)
@@ -768,8 +764,8 @@ static unsigned long shrink_inactive_list(unsigned long max_scan,
 		unsigned long nr_freed;
 
 		nr_taken = isolate_lru_pages(sc->swap_cluster_max,
-					     &zone->inactive_list,
-					     &page_list, &nr_scan, sc->order);
+				     &zone->inactive_list,
+				     &page_list, &nr_scan, sc->order, 0);
 		__mod_zone_page_state(zone, NR_INACTIVE, -nr_taken);
 		zone->pages_scanned += nr_scan;
 		zone->total_scanned += nr_scan;
@@ -916,7 +912,7 @@ force_reclaim_mapped:
 	lru_add_drain();
 	spin_lock_irq(&zone->lru_lock);
 	pgmoved = isolate_lru_pages(nr_pages, &zone->active_list,
-				    &l_hold, &pgscanned, sc->order);
+				    &l_hold, &pgscanned, sc->order, 1);
 	zone->pages_scanned += pgscanned;
 	__mod_zone_page_state(zone, NR_ACTIVE, -pgmoved);
 	spin_unlock_irq(&zone->lru_lock);
