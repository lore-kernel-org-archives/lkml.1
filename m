Return-Path: <linux-kernel-owner+w=401wt.eu-S1753331AbZK0ATR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753331AbZK0ATR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 19:19:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751510AbZK0ATR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 19:19:17 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:59856 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751157AbZK0ATQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 19:19:16 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/4] vmscan: move PGDEACTIVATE modification to shrink_active_list()
Cc: kosaki.motohiro@jp.fujitsu.com, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20091127091357.A7CC.A69D9226@jp.fujitsu.com>
References: <20091127091357.A7CC.A69D9226@jp.fujitsu.com>
Message-Id: <20091127091841.A7D2.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Fri, 27 Nov 2009 09:19:20 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pgmoved accounting in move_active_pages_to_lru() doesn't make any sense.
it can be calculated in irq enabled area.

This patch move #-of-deactivating-pages calcution to shrink_active_list().
Fortunatelly, it also kill one branch.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 mm/vmscan.c |   18 ++++++++++++------
 1 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 7e0245d..56faefb 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -167,6 +167,11 @@ static inline enum lru_list lru_index(int active, int file)
 	return lru;
 }
 
+static inline int lru_stat_index(int active, int file)
+{
+	return lru_index(active, file) + NR_LRU_BASE;
+}
+
 /*
  * Add a shrinker callback to be called from the vm
  */
@@ -1269,7 +1274,6 @@ static void move_active_pages_to_lru(struct zone *zone,
 				     struct list_head *list,
 				     enum lru_list lru)
 {
-	unsigned long pgmoved = 0;
 	struct pagevec pvec;
 	struct page *page;
 
@@ -1283,7 +1287,6 @@ static void move_active_pages_to_lru(struct zone *zone,
 
 		list_move(&page->lru, &zone->lru[lru].list);
 		mem_cgroup_add_lru_list(page, lru);
-		pgmoved++;
 
 		if (!pagevec_add(&pvec, page) || list_empty(list)) {
 			spin_unlock_irq(&zone->lru_lock);
@@ -1293,9 +1296,6 @@ static void move_active_pages_to_lru(struct zone *zone,
 			spin_lock_irq(&zone->lru_lock);
 		}
 	}
-	__mod_zone_page_state(zone, NR_LRU_BASE + lru, pgmoved);
-	if (!is_active_lru(lru))
-		__count_vm_events(PGDEACTIVATE, pgmoved);
 }
 
 static void shrink_active_list(unsigned long nr_pages, struct zone *zone,
@@ -1310,6 +1310,8 @@ static void shrink_active_list(unsigned long nr_pages, struct zone *zone,
 	struct page *page;
 	struct zone_reclaim_stat *reclaim_stat = get_reclaim_stat(zone, sc);
 	unsigned long nr_rotated = 0;
+	unsigned long nr_deactivated = 0;
+	unsigned long nr_reactivated = 0;
 
 	lru_add_drain();
 	spin_lock_irq(&zone->lru_lock);
@@ -1358,12 +1360,14 @@ static void shrink_active_list(unsigned long nr_pages, struct zone *zone,
 			 */
 			if ((vm_flags & VM_EXEC) && page_is_file_cache(page)) {
 				list_add(&page->lru, &l_active);
+				nr_reactivated++;
 				continue;
 			}
 		}
 
 		ClearPageActive(page);	/* we are de-activating */
 		list_add(&page->lru, &l_inactive);
+		nr_deactivated++;
 	}
 
 	/*
@@ -1377,9 +1381,11 @@ static void shrink_active_list(unsigned long nr_pages, struct zone *zone,
 	 * get_scan_ratio.
 	 */
 	reclaim_stat->recent_rotated[file] += nr_rotated;
-
 	move_active_pages_to_lru(zone, &l_active, lru_index(1, file));
 	move_active_pages_to_lru(zone, &l_inactive, lru_index(0, file));
+	__count_vm_events(PGDEACTIVATE, nr_deactivated);
+	__mod_zone_page_state(zone, lru_stat_index(1, file), nr_reactivated);
+	__mod_zone_page_state(zone, lru_stat_index(0, file), nr_deactivated);
 	__mod_zone_page_state(zone, NR_ISOLATED_ANON + file, -nr_taken);
 	spin_unlock_irq(&zone->lru_lock);
 }
-- 
1.6.5.2



