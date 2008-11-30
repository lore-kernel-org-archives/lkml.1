Return-Path: <linux-kernel-owner+w=401wt.eu-S1754653AbYK3K7c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754653AbYK3K7c (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2008 05:59:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751394AbYK3K7Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Nov 2008 05:59:24 -0500
Received: from fgwmail.fujitsu.co.jp ([164.71.1.133]:57222 "EHLO
	fgwmail.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751384AbYK3K7X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2008 05:59:23 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>
Subject: [PATCH 04/09] memcg: make zone_reclaim_stat
Cc: kosaki.motohiro@jp.fujitsu.com
In-Reply-To: <20081130193502.8145.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <20081130193502.8145.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Message-Id: <20081130195731.8151.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Sun, 30 Nov 2008 19:59:20 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

introduce mem_cgroup_per_zone::reclaim_stat member and its statics collect
function.

latter patch use it.


Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 include/linux/memcontrol.h |   16 ++++++++++++++++
 mm/memcontrol.c            |   21 +++++++++++++++++++++
 mm/swap.c                  |   10 ++++++++++
 mm/vmscan.c                |   27 +++++++++++++--------------
 4 files changed, 60 insertions(+), 14 deletions(-)

Index: b/include/linux/memcontrol.h
===================================================================
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -92,6 +92,10 @@ extern long mem_cgroup_calc_reclaim(stru
 					int priority, enum lru_list lru);
 int mem_cgroup_inactive_anon_is_low(struct mem_cgroup *memcg,
 				    struct zone *zone);
+struct zone_reclaim_stat *mem_cgroup_get_reclaim_stat(struct mem_cgroup *memcg,
+						      struct zone *zone);
+struct zone_reclaim_stat*
+mem_cgroup_get_reclaim_stat_by_page(struct page *page);
 
 #ifdef CONFIG_CGROUP_MEM_RES_CTLR_SWAP
 extern int do_swap_account;
@@ -250,6 +254,18 @@ mem_cgroup_inactive_anon_is_low(struct m
 	return 1;
 }
 
+static inline struct zone_reclaim_stat*
+mem_cgroup_get_reclaim_stat(struct mem_cgroup *memcg, struct zone *zone)
+{
+	return NULL;
+}
+
+struct zone_reclaim_stat*
+mem_cgroup_get_reclaim_stat_by_page(struct page *page)
+{
+	return NULL;
+}
+
 
 #endif /* CONFIG_CGROUP_MEM_CONT */
 
Index: b/mm/memcontrol.c
===================================================================
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -103,6 +103,8 @@ struct mem_cgroup_per_zone {
 	 */
 	struct list_head	lists[NR_LRU_LISTS];
 	unsigned long		count[NR_LRU_LISTS];
+
+	struct zone_reclaim_stat reclaim_stat;
 };
 /* Macro for accessing counter */
 #define MEM_CGROUP_ZSTAT(mz, idx)	((mz)->count[(idx)])
@@ -445,6 +447,25 @@ int mem_cgroup_inactive_anon_is_low(stru
 	return 0;
 }
 
+struct zone_reclaim_stat *mem_cgroup_get_reclaim_stat(struct mem_cgroup *memcg,
+						      struct zone *zone)
+{
+	int nid = zone->zone_pgdat->node_id;
+	int zid = zone_idx(zone);
+	struct mem_cgroup_per_zone *mz = mem_cgroup_zoneinfo(memcg, nid, zid);
+
+	return &mz->reclaim_stat;
+}
+
+struct zone_reclaim_stat *mem_cgroup_get_reclaim_stat_by_page(struct page *page)
+{
+	struct page_cgroup *pc = lookup_page_cgroup(page);
+	struct mem_cgroup_per_zone *mz = page_cgroup_zoneinfo(pc);
+
+	return &mz->reclaim_stat;
+}
+
+
 unsigned long mem_cgroup_isolate_pages(unsigned long nr_to_scan,
 					struct list_head *dst,
 					unsigned long *scanned, int order,
Index: b/mm/swap.c
===================================================================
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -158,6 +158,7 @@ void activate_page(struct page *page)
 {
 	struct zone *zone = page_zone(page);
 	struct zone_reclaim_stat *reclaim_stat = &zone->reclaim_stat;
+	struct zone_reclaim_stat *memcg_reclaim_stat;
 
 	spin_lock_irq(&zone->lru_lock);
 	if (PageLRU(page) && !PageActive(page) && !PageUnevictable(page)) {
@@ -172,6 +173,10 @@ void activate_page(struct page *page)
 
 		reclaim_stat->recent_rotated[!!file]++;
 		reclaim_stat->recent_scanned[!!file]++;
+
+		memcg_reclaim_stat = mem_cgroup_get_reclaim_stat_by_page(page);
+		memcg_reclaim_stat->recent_rotated[!!file]++;
+		memcg_reclaim_stat->recent_scanned[!!file]++;
 	}
 	spin_unlock_irq(&zone->lru_lock);
 }
@@ -400,6 +405,7 @@ void ____pagevec_lru_add(struct pagevec 
 	int i;
 	struct zone *zone = NULL;
 	struct zone_reclaim_stat *reclaim_stat = NULL;
+	struct zone_reclaim_stat *memcg_reclaim_stat = NULL;
 
 	VM_BUG_ON(is_unevictable_lru(lru));
 
@@ -413,6 +419,8 @@ void ____pagevec_lru_add(struct pagevec 
 				spin_unlock_irq(&zone->lru_lock);
 			zone = pagezone;
 			reclaim_stat = &zone->reclaim_stat;
+			memcg_reclaim_stat =
+				mem_cgroup_get_reclaim_stat_by_page(page);
 			spin_lock_irq(&zone->lru_lock);
 		}
 		VM_BUG_ON(PageActive(page));
@@ -421,9 +429,11 @@ void ____pagevec_lru_add(struct pagevec 
 		SetPageLRU(page);
 		file = is_file_lru(lru);
 		reclaim_stat->recent_scanned[file]++;
+		memcg_reclaim_stat->recent_scanned[file]++;
 		if (is_active_lru(lru)) {
 			SetPageActive(page);
 			reclaim_stat->recent_rotated[file]++;
+			memcg_reclaim_stat->recent_rotated[file]++;
 		}
 		add_page_to_lru_list(zone, page, lru);
 	}
Index: b/mm/vmscan.c
===================================================================
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -134,6 +134,9 @@ static DECLARE_RWSEM(shrinker_rwsem);
 static struct zone_reclaim_stat *get_reclaim_stat(struct zone *zone,
 						  struct scan_control *sc)
 {
+	if (!scan_global_lru(sc))
+		mem_cgroup_get_reclaim_stat(sc->mem_cgroup, zone);
+
 	return &zone->reclaim_stat;
 }
 
@@ -1131,17 +1134,14 @@ static unsigned long shrink_inactive_lis
 		__mod_zone_page_state(zone, NR_INACTIVE_ANON,
 						-count[LRU_INACTIVE_ANON]);
 
-		if (scan_global_lru(sc)) {
+		if (scan_global_lru(sc))
 			zone->pages_scanned += nr_scan;
-			reclaim_stat->recent_scanned[0] +=
-						      count[LRU_INACTIVE_ANON];
-			reclaim_stat->recent_scanned[0] +=
-						      count[LRU_ACTIVE_ANON];
-			reclaim_stat->recent_scanned[1] +=
-						      count[LRU_INACTIVE_FILE];
-			reclaim_stat->recent_scanned[1] +=
-						      count[LRU_ACTIVE_FILE];
-		}
+
+		reclaim_stat->recent_scanned[0] += count[LRU_INACTIVE_ANON];
+		reclaim_stat->recent_scanned[0] += count[LRU_ACTIVE_ANON];
+		reclaim_stat->recent_scanned[1] += count[LRU_INACTIVE_FILE];
+		reclaim_stat->recent_scanned[1] += count[LRU_ACTIVE_FILE];
+
 		spin_unlock_irq(&zone->lru_lock);
 
 		nr_scanned += nr_scan;
@@ -1199,7 +1199,7 @@ static unsigned long shrink_inactive_lis
 			SetPageLRU(page);
 			lru = page_lru(page);
 			add_page_to_lru_list(zone, page, lru);
-			if (PageActive(page) && scan_global_lru(sc)) {
+			if (PageActive(page)) {
 				int file = !!page_is_file_cache(page);
 				reclaim_stat->recent_rotated[file]++;
 			}
@@ -1279,8 +1279,8 @@ static void shrink_active_list(unsigned 
 	 */
 	if (scan_global_lru(sc)) {
 		zone->pages_scanned += pgscanned;
-		reclaim_stat->recent_scanned[!!file] += pgmoved;
 	}
+	reclaim_stat->recent_scanned[!!file] += pgmoved;
 
 	if (file)
 		__mod_zone_page_state(zone, NR_ACTIVE_FILE, -pgmoved);
@@ -1313,8 +1313,7 @@ static void shrink_active_list(unsigned 
 	 * This helps balance scan pressure between file and anonymous
 	 * pages in get_scan_ratio.
 	 */
-	if (scan_global_lru(sc))
-		reclaim_stat->recent_rotated[!!file] += pgmoved;
+	reclaim_stat->recent_rotated[!!file] += pgmoved;
 
 	/*
 	 * Move the pages to the [file or anon] inactive list.


