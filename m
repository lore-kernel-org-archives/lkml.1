Return-Path: <linux-kernel-owner+w=401wt.eu-S1751981AbZH0EjF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751981AbZH0EjF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 00:39:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751369AbZH0EjE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 00:39:04 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:39938 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751253AbZH0EjD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 00:39:03 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] vmscan: move PGDEACTIVATE modification to shrink_active_list()
Cc: kosaki.motohiro@jp.fujitsu.com
Message-Id: <20090827133727.398B.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu, 27 Aug 2009 13:39:01 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pgmoved accounting in move_active_pages_to_lru() doesn't make any sense.
it can be calculated in irq enabled area.

This patch move #-of-deactivating-pages calcution to shrink_active_list().
Fortunatelly, it also kill one branch.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 mm/vmscan.c |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 848689a..9618170 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1270,7 +1270,6 @@ static void move_active_pages_to_lru(struct zone *zone,
 				     struct list_head *list,
 				     enum lru_list lru)
 {
-	unsigned long pgmoved = 0;
 	struct pagevec pvec;
 	struct page *page;
 
@@ -1284,7 +1283,6 @@ static void move_active_pages_to_lru(struct zone *zone,
 
 		list_move(&page->lru, &zone->lru[lru].list);
 		mem_cgroup_add_lru_list(page, lru);
-		pgmoved++;
 
 		if (!pagevec_add(&pvec, page) || list_empty(list)) {
 			spin_unlock_irq(&zone->lru_lock);
@@ -1294,9 +1292,6 @@ static void move_active_pages_to_lru(struct zone *zone,
 			spin_lock_irq(&zone->lru_lock);
 		}
 	}
-	__mod_zone_page_state(zone, NR_LRU_BASE + lru, pgmoved);
-	if (!is_active_lru(lru))
-		__count_vm_events(PGDEACTIVATE, pgmoved);
 }
 
 static void shrink_active_list(unsigned long nr_pages, struct zone *zone,
@@ -1311,6 +1306,7 @@ static void shrink_active_list(unsigned long nr_pages, struct zone *zone,
 	struct page *page;
 	struct zone_reclaim_stat *reclaim_stat = get_reclaim_stat(zone, sc);
 	unsigned long nr_rotated = 0;
+	unsigned long nr_deactivated = 0;
 
 	lru_add_drain();
 	spin_lock_irq(&zone->lru_lock);
@@ -1365,12 +1361,18 @@ static void shrink_active_list(unsigned long nr_pages, struct zone *zone,
 
 		ClearPageActive(page);	/* we are de-activating */
 		list_add(&page->lru, &l_inactive);
+		nr_deactivated++;
 	}
 
 	/*
 	 * Move pages back to the lru list.
 	 */
 	spin_lock_irq(&zone->lru_lock);
+	move_active_pages_to_lru(zone, &l_active,
+						LRU_ACTIVE + file * LRU_FILE);
+	move_active_pages_to_lru(zone, &l_inactive,
+						LRU_BASE   + file * LRU_FILE);
+
 	/*
 	 * Count referenced pages from currently used mappings as rotated,
 	 * even though only some of them are actually re-activated.  This
@@ -1378,12 +1380,10 @@ static void shrink_active_list(unsigned long nr_pages, struct zone *zone,
 	 * get_scan_ratio.
 	 */
 	reclaim_stat->recent_rotated[file] += nr_rotated;
-
-	move_active_pages_to_lru(zone, &l_active,
-						LRU_ACTIVE + file * LRU_FILE);
-	move_active_pages_to_lru(zone, &l_inactive,
-						LRU_BASE   + file * LRU_FILE);
+	__count_vm_events(PGDEACTIVATE, nr_deactivated);
 	__mod_zone_page_state(zone, NR_ISOLATED_ANON + file, -nr_taken);
+	__mod_zone_page_state(zone, LRU_ACTIVE + file * LRU_FILE, nr_rotated);
+	__mod_zone_page_state(zone, LRU_BASE + file * LRU_FILE, nr_deactivated);
 	spin_unlock_irq(&zone->lru_lock);
 }
 
-- 
1.6.2.5



