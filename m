Return-Path: <linux-kernel-owner+w=401wt.eu-S1753477AbZK0AX5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753477AbZK0AX5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 19:23:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752276AbZK0AX5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 19:23:57 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:52391 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751568AbZK0AX4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 19:23:56 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [RFC][PATCH 4/4] vmscan: vmscan don't use pcp list
Cc: kosaki.motohiro@jp.fujitsu.com, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>
In-Reply-To: <20091127091357.A7CC.A69D9226@jp.fujitsu.com>
References: <20091127091357.A7CC.A69D9226@jp.fujitsu.com>
Message-Id: <20091127091920.A7D5.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Fri, 27 Nov 2009 09:23:57 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


note: Last year,  Andy Whitcroft reported pcp prevent to make contenious
high order page when lumpy reclaim is running.
He posted "capture pages freed during direct reclaim for allocation by the reclaimer"
patch series, but Christoph mentioned simple bypass pcp instead.
I made it. I'd hear Christoph and Mel's mention.


==========================
Currently vmscan free unused pages by __pagevec_free().  It mean free pages one by one
and use pcp. it makes two suboptimal result.

 - The another task can steal the freed page in pcp easily. it decrease
   lumpy reclaim worth.
 - To pollute pcp cache, vmscan freed pages might kick out cache hot
   pages from pcp.

This patch make new free_pages_bulk() function and vmscan use it.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 include/linux/gfp.h |    2 +
 mm/page_alloc.c     |   56 +++++++++++++++++++++++++++++++++++++++++++++++++++
 mm/vmscan.c         |   23 +++++++++++----------
 3 files changed, 70 insertions(+), 11 deletions(-)

diff --git a/include/linux/gfp.h b/include/linux/gfp.h
index f53e9b8..403584d 100644
--- a/include/linux/gfp.h
+++ b/include/linux/gfp.h
@@ -330,6 +330,8 @@ extern void free_hot_page(struct page *page);
 #define __free_page(page) __free_pages((page), 0)
 #define free_page(addr) free_pages((addr),0)
 
+void free_pages_bulk(struct zone *zone, int count, struct list_head *list);
+
 void page_alloc_init(void);
 void drain_zone_pages(struct zone *zone, struct per_cpu_pages *pcp);
 void drain_all_pages(void);
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 11ae66e..f77f8a8 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2037,6 +2037,62 @@ void free_pages(unsigned long addr, unsigned int order)
 
 EXPORT_SYMBOL(free_pages);
 
+/*
+ * Frees a number of pages from the list
+ * Assumes all pages on list are in same zone and order==0.
+ * count is the number of pages to free.
+ *
+ * This is similar to __pagevec_free(), but receive list instead pagevec.
+ * and this don't use pcp cache. it is good characteristics for vmscan.
+ */
+void free_pages_bulk(struct zone *zone, int count, struct list_head *list)
+{
+	unsigned long flags;
+	struct page *page;
+	struct page *page2;
+
+	list_for_each_entry_safe(page, page2, list, lru) {
+		int wasMlocked = __TestClearPageMlocked(page);
+
+		kmemcheck_free_shadow(page, 0);
+
+		if (PageAnon(page))
+			page->mapping = NULL;
+		if (free_pages_check(page)) {
+			/* orphan this page. */
+			list_del(&page->lru);
+			continue;
+		}
+		if (!PageHighMem(page)) {
+			debug_check_no_locks_freed(page_address(page),
+						   PAGE_SIZE);
+			debug_check_no_obj_freed(page_address(page), PAGE_SIZE);
+		}
+		arch_free_page(page, 0);
+		kernel_map_pages(page, 1, 0);
+
+		local_irq_save(flags);
+		if (unlikely(wasMlocked))
+			free_page_mlock(page);
+		local_irq_restore(flags);
+	}
+
+	spin_lock_irqsave(&zone->lock, flags);
+	__count_vm_events(PGFREE, count);
+	zone_clear_flag(zone, ZONE_ALL_UNRECLAIMABLE);
+	zone->pages_scanned = 0;
+
+	__mod_zone_page_state(zone, NR_FREE_PAGES, count);
+
+	list_for_each_entry_safe(page, page2, list, lru) {
+		/* have to delete it as __free_one_page list manipulates */
+		list_del(&page->lru);
+		trace_mm_page_free_direct(page, 0);
+		__free_one_page(page, zone, 0, page_private(page));
+	}
+	spin_unlock_irqrestore(&zone->lock, flags);
+}
+
 /**
  * alloc_pages_exact - allocate an exact number physically-contiguous pages.
  * @size: the number of bytes to allocate
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 56faefb..00156f2 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -598,18 +598,17 @@ redo:
  * shrink_page_list() returns the number of reclaimed pages
  */
 static unsigned long shrink_page_list(struct list_head *page_list,
+				      struct list_head *freed_pages_list,
 					struct scan_control *sc,
 					enum pageout_io sync_writeback)
 {
 	LIST_HEAD(ret_pages);
-	struct pagevec freed_pvec;
 	int pgactivate = 0;
 	unsigned long nr_reclaimed = 0;
 	unsigned long vm_flags;
 
 	cond_resched();
 
-	pagevec_init(&freed_pvec, 1);
 	while (!list_empty(page_list)) {
 		struct address_space *mapping;
 		struct page *page;
@@ -785,10 +784,7 @@ static unsigned long shrink_page_list(struct list_head *page_list,
 		__clear_page_locked(page);
 free_it:
 		nr_reclaimed++;
-		if (!pagevec_add(&freed_pvec, page)) {
-			__pagevec_free(&freed_pvec);
-			pagevec_reinit(&freed_pvec);
-		}
+		list_add(&page->lru, freed_pages_list);
 		continue;
 
 cull_mlocked:
@@ -812,8 +808,6 @@ keep:
 		VM_BUG_ON(PageLRU(page) || PageUnevictable(page));
 	}
 	list_splice(&ret_pages, page_list);
-	if (pagevec_count(&freed_pvec))
-		__pagevec_free(&freed_pvec);
 	count_vm_events(PGACTIVATE, pgactivate);
 	return nr_reclaimed;
 }
@@ -1100,6 +1094,7 @@ static unsigned long shrink_inactive_list(unsigned long nr_to_scan,
 					  int priority, int file)
 {
 	LIST_HEAD(page_list);
+	LIST_HEAD(freed_pages_list);
 	struct pagevec pvec;
 	unsigned long nr_scanned;
 	unsigned long nr_reclaimed = 0;
@@ -1174,7 +1169,8 @@ static unsigned long shrink_inactive_list(unsigned long nr_to_scan,
 
 	spin_unlock_irq(&zone->lru_lock);
 
-	nr_reclaimed = shrink_page_list(&page_list, sc, PAGEOUT_IO_ASYNC);
+	nr_reclaimed = shrink_page_list(&page_list, &freed_pages_list, sc,
+					PAGEOUT_IO_ASYNC);
 
 	/*
 	 * If we are direct reclaiming for contiguous pages and we do
@@ -1192,10 +1188,15 @@ static unsigned long shrink_inactive_list(unsigned long nr_to_scan,
 		nr_active = clear_active_flags(&page_list, count);
 		count_vm_events(PGDEACTIVATE, nr_active);
 
-		nr_reclaimed += shrink_page_list(&page_list, sc,
-						 PAGEOUT_IO_SYNC);
+		nr_reclaimed += shrink_page_list(&page_list, &freed_pages_list,
+						 sc, PAGEOUT_IO_SYNC);
 	}
 
+	/*
+	 * Free unused pages.
+	 */
+	free_pages_bulk(zone, nr_reclaimed, &freed_pages_list);
+
 	local_irq_disable();
 	if (current_is_kswapd())
 		__count_vm_events(KSWAPD_STEAL, nr_reclaimed);
-- 
1.6.5.2



