Return-Path: <linux-kernel-owner+w=401wt.eu-S1754462AbYAXEXF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754462AbYAXEXF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 23:23:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753012AbYAXEWz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 23:22:55 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:35296 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752948AbYAXEWy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 23:22:54 -0500
Date: Thu, 24 Jan 2008 13:22:01 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [RFC][PATCH 4/8] mem_notify v5: memory_pressure_notify() caller
Cc: kosaki.motohiro@jp.fujitsu.com, Marcelo Tosatti <marcelo@kvack.org>,
       Daniel Spang <daniel.spang@gmail.com>, Rik van Riel <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <20080124130348.1760.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <20080124130348.1760.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Message-Id: <20080124132108.176C.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

the notification point to happen whenever the VM moves an
anonymous page to the inactive list - this is a pretty good indication
that there are unused anonymous pages present which will be very likely
swapped out soon.

and, It is judged out of trouble at the fllowing situations. 
 o memory pressure decrease and stop moves an anonymous page to the inactive list.
 o free pages increase than (pages_high+lowmem_reserve)*2.


ChangeLog:
	v5: add out of trouble notify to exit of balance_pgdat().


Signed-off-by: Marcelo Tosatti <marcelo@kvack.org>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

---
 mm/page_alloc.c |   12 ++++++++++++
 mm/vmscan.c     |   26 ++++++++++++++++++++++++++
 2 files changed, 38 insertions(+)

Index: b/mm/vmscan.c
===================================================================
--- a/mm/vmscan.c	2008-01-23 22:06:08.000000000 +0900
+++ b/mm/vmscan.c	2008-01-23 22:07:57.000000000 +0900
@@ -39,6 +39,7 @@
 #include <linux/kthread.h>
 #include <linux/freezer.h>
 #include <linux/memcontrol.h>
+#include <linux/mem_notify.h>
 
 #include <asm/tlbflush.h>
 #include <asm/div64.h>
@@ -1089,10 +1090,14 @@ static void shrink_active_list(unsigned 
 	struct page *page;
 	struct pagevec pvec;
 	int reclaim_mapped = 0;
+	bool inactivated_anon = 0;
 
 	if (sc->may_swap)
 		reclaim_mapped = calc_reclaim_mapped(sc, zone, priority);
 
+	if (!reclaim_mapped)
+		memory_pressure_notify(zone, 0);
+
 	lru_add_drain();
 	spin_lock_irq(&zone->lru_lock);
 	pgmoved = sc->isolate_pages(nr_pages, &l_hold, &pgscanned, sc->order,
@@ -1116,6 +1121,13 @@ static void shrink_active_list(unsigned 
 			if (!reclaim_mapped ||
 			    (total_swap_pages == 0 && PageAnon(page)) ||
 			    page_referenced(page, 0, sc->mem_cgroup)) {
+				/* deal with the case where there is no
+				 * swap but an anonymous page would be
+				 * moved to the inactive list.
+				 */
+				if (!total_swap_pages && reclaim_mapped &&
+				    PageAnon(page))
+					inactivated_anon = 1;
 				list_add(&page->lru, &l_active);
 				continue;
 			}
@@ -1123,8 +1135,12 @@ static void shrink_active_list(unsigned 
 			list_add(&page->lru, &l_active);
 			continue;
 		}
+		if (PageAnon(page))
+			inactivated_anon = 1;
 		list_add(&page->lru, &l_inactive);
 	}
+	if (inactivated_anon)
+		memory_pressure_notify(zone, 1);
 
 	pagevec_init(&pvec, 1);
 	pgmoved = 0;
@@ -1158,6 +1174,8 @@ static void shrink_active_list(unsigned 
 		pagevec_strip(&pvec);
 		spin_lock_irq(&zone->lru_lock);
 	}
+	if (!reclaim_mapped)
+		memory_pressure_notify(zone, 0);
 
 	pgmoved = 0;
 	while (!list_empty(&l_active)) {
@@ -1659,6 +1677,14 @@ out:
 		goto loop_again;
 	}
 
+	for (i = pgdat->nr_zones - 1; i >= 0; i--) {
+		struct zone *zone = pgdat->node_zones + i;
+
+		if (!populated_zone(zone))
+			continue;
+		memory_pressure_notify(zone, 0);
+	}
+
 	return nr_reclaimed;
 }
 
Index: b/mm/page_alloc.c
===================================================================
--- a/mm/page_alloc.c	2008-01-23 22:06:08.000000000 +0900
+++ b/mm/page_alloc.c	2008-01-23 23:09:32.000000000 +0900
@@ -44,6 +44,7 @@
 #include <linux/fault-inject.h>
 #include <linux/page-isolation.h>
 #include <linux/memcontrol.h>
+#include <linux/mem_notify.h>
 
 #include <asm/tlbflush.h>
 #include <asm/div64.h>
@@ -435,6 +436,8 @@ static inline void __free_one_page(struc
 	unsigned long page_idx;
 	int order_size = 1 << order;
 	int migratetype = get_pageblock_migratetype(page);
+	unsigned long prev_free;
+	unsigned long notify_threshold;
 
 	if (unlikely(PageCompound(page)))
 		destroy_compound_page(page, order);
@@ -444,6 +447,7 @@ static inline void __free_one_page(struc
 	VM_BUG_ON(page_idx & (order_size - 1));
 	VM_BUG_ON(bad_range(zone, page));
 
+	prev_free = zone_page_state(zone, NR_FREE_PAGES);
 	__mod_zone_page_state(zone, NR_FREE_PAGES, order_size);
 	while (order < MAX_ORDER-1) {
 		unsigned long combined_idx;
@@ -465,6 +469,14 @@ static inline void __free_one_page(struc
 	list_add(&page->lru,
 		&zone->free_area[order].free_list[migratetype]);
 	zone->free_area[order].nr_free++;
+
+	notify_threshold = (zone->pages_high +
+			    zone->lowmem_reserve[MAX_NR_ZONES-1]) * 2;
+
+	if (unlikely((zone->mem_notify_status == 1) &&
+		     (prev_free <= notify_threshold) &&
+		     (zone_page_state(zone, NR_FREE_PAGES) > notify_threshold)))
+		memory_pressure_notify(zone, 0);
 }
 
 static inline int free_pages_check(struct page *page)


