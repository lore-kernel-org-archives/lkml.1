Return-Path: <linux-kernel-owner+w=401wt.eu-S1760091AbXHTVyA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760091AbXHTVyA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 17:54:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751895AbXHTVxU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 17:53:20 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:59774 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751487AbXHTVxR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 17:53:17 -0400
Message-Id: <20070820215316.058310630@sgi.com>
References: <20070820215040.937296148@sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 20 Aug 2007 14:50:41 -0700
From: Christoph Lameter <clameter@sgi.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org
Cc: dkegel@google.com
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: David Miller <davem@davemloft.net>
Cc: Nick Piggin <npiggin@suse.de>
Subject: [RFC 1/7] release_lru_pages(): Generic release of pages to the LRU
Content-Disposition: inline; filename=release_lru_pages
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Provide a function to generically release pages that were isolated back
to the LRU. The function supports mixing zones etc.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 mm/vmscan.c |   72 ++++++++++++++++++++++++++++++++++--------------------------
 1 file changed, 41 insertions(+), 31 deletions(-)

Index: linux-2.6/mm/vmscan.c
===================================================================
--- linux-2.6.orig/mm/vmscan.c	2007-08-19 23:12:43.000000000 -0700
+++ linux-2.6/mm/vmscan.c	2007-08-19 23:13:24.000000000 -0700
@@ -581,6 +581,42 @@ keep:
 	return nr_reclaimed;
 }
 
+/*
+ * Put back any unfreeable pages.
+ */
+void release_lru_pages(struct list_head *page_list)
+{
+	struct page *page;
+	struct pagevec pvec;
+	struct zone *zone = NULL;
+
+	pagevec_init(&pvec, 1);
+	while (!list_empty(page_list)) {
+		page = lru_to_page(page_list);
+		VM_BUG_ON(PageLRU(page));
+		if (zone != page_zone(page)) {
+			if (zone)
+				spin_unlock_irq(&zone->lru_lock);
+			zone = page_zone(page);
+			spin_lock_irq(&zone->lru_lock);
+		}
+		SetPageLRU(page);
+		list_del(&page->lru);
+		if (PageActive(page))
+			add_page_to_active_list(zone, page);
+		else
+			add_page_to_inactive_list(zone, page);
+		if (!pagevec_add(&pvec, page)) {
+			spin_unlock_irq(&zone->lru_lock);
+			__pagevec_release(&pvec);
+			spin_lock_irq(&zone->lru_lock);
+		}
+	}
+	if (zone)
+		spin_unlock_irq(&zone->lru_lock);
+	pagevec_release(&pvec);
+}
+
 /* LRU Isolation modes. */
 #define ISOLATE_INACTIVE 0	/* Isolate inactive pages. */
 #define ISOLATE_ACTIVE 1	/* Isolate active pages. */
@@ -756,21 +792,17 @@ static unsigned long shrink_inactive_lis
 				struct zone *zone, struct scan_control *sc)
 {
 	LIST_HEAD(page_list);
-	struct pagevec pvec;
 	unsigned long nr_scanned = 0;
 	unsigned long nr_reclaimed = 0;
 
-	pagevec_init(&pvec, 1);
-
 	lru_add_drain();
-	spin_lock_irq(&zone->lru_lock);
 	do {
-		struct page *page;
 		unsigned long nr_taken;
 		unsigned long nr_scan;
 		unsigned long nr_freed;
 		unsigned long nr_active;
 
+		spin_lock_irq(&zone->lru_lock);
 		nr_taken = isolate_lru_pages(sc->swap_cluster_max,
 			     &zone->inactive_list,
 			     &page_list, &nr_scan, sc->order,
@@ -794,34 +826,12 @@ static unsigned long shrink_inactive_lis
 		} else
 			__count_zone_vm_events(PGSCAN_DIRECT, zone, nr_scan);
 		__count_zone_vm_events(PGSTEAL, zone, nr_freed);
+		local_irq_enable();
+		release_lru_pages(&page_list);
 
-		if (nr_taken == 0)
-			goto done;
-
-		spin_lock(&zone->lru_lock);
-		/*
-		 * Put back any unfreeable pages.
-		 */
-		while (!list_empty(&page_list)) {
-			page = lru_to_page(&page_list);
-			VM_BUG_ON(PageLRU(page));
-			SetPageLRU(page);
-			list_del(&page->lru);
-			if (PageActive(page))
-				add_page_to_active_list(zone, page);
-			else
-				add_page_to_inactive_list(zone, page);
-			if (!pagevec_add(&pvec, page)) {
-				spin_unlock_irq(&zone->lru_lock);
-				__pagevec_release(&pvec);
-				spin_lock_irq(&zone->lru_lock);
-			}
-		}
+		if (!nr_taken)
+			break;
   	} while (nr_scanned < max_scan);
-	spin_unlock(&zone->lru_lock);
-done:
-	local_irq_enable();
-	pagevec_release(&pvec);
 	return nr_reclaimed;
 }
 

-- 
