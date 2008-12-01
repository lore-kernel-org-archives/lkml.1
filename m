Return-Path: <linux-kernel-owner+w=401wt.eu-S1754422AbYLAMSi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754422AbYLAMSi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 07:18:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753387AbYLAMSY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 07:18:24 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:41713 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752279AbYLAMSW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 07:18:22 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>
Subject: [PATCH 09/11] memcg: remove mem_cgroup_calc_reclaim()
Cc: kosaki.motohiro@jp.fujitsu.com
In-Reply-To: <20081201205810.1CCA.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <20081201205810.1CCA.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Message-Id: <20081201211742.1CE5.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Mon,  1 Dec 2008 21:18:19 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now, get_scan_ratio() return correct value although memcg reclaim.
Then, mem_cgroup_calc_reclaim() can be removed.

So, memcg reclaim get the same capability of anon/file reclaim balancing as global reclaim now.


Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 include/linux/memcontrol.h |   10 ----------
 mm/memcontrol.c            |   21 ---------------------
 mm/vmscan.c                |   27 ++++++++++-----------------
 3 files changed, 10 insertions(+), 48 deletions(-)

Index: b/include/linux/memcontrol.h
===================================================================
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -87,9 +87,6 @@ extern void mem_cgroup_note_reclaim_prio
 							int priority);
 extern void mem_cgroup_record_reclaim_priority(struct mem_cgroup *mem,
 							int priority);
-
-extern long mem_cgroup_calc_reclaim(struct mem_cgroup *mem, struct zone *zone,
-					int priority, enum lru_list lru);
 int mem_cgroup_inactive_anon_is_low(struct mem_cgroup *memcg,
 				    struct zone *zone);
 struct zone_reclaim_stat *mem_cgroup_get_reclaim_stat(struct mem_cgroup *memcg,
@@ -234,13 +231,6 @@ static inline void mem_cgroup_record_rec
 {
 }
 
-static inline long mem_cgroup_calc_reclaim(struct mem_cgroup *mem,
-					struct zone *zone, int priority,
-					enum lru_list lru)
-{
-	return 0;
-}
-
 static inline bool mem_cgroup_disabled(void)
 {
 	return true;
Index: b/mm/memcontrol.c
===================================================================
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -414,27 +414,6 @@ void mem_cgroup_record_reclaim_priority(
 	mem->prev_priority = priority;
 }
 
-/*
- * Calculate # of pages to be scanned in this priority/zone.
- * See also vmscan.c
- *
- * priority starts from "DEF_PRIORITY" and decremented in each loop.
- * (see include/linux/mmzone.h)
- */
-
-long mem_cgroup_calc_reclaim(struct mem_cgroup *mem, struct zone *zone,
-					int priority, enum lru_list lru)
-{
-	long nr_pages;
-	int nid = zone->zone_pgdat->node_id;
-	int zid = zone_idx(zone);
-	struct mem_cgroup_per_zone *mz = mem_cgroup_zoneinfo(mem, nid, zid);
-
-	nr_pages = MEM_CGROUP_ZSTAT(mz, lru);
-
-	return (nr_pages >> priority);
-}
-
 int mem_cgroup_inactive_anon_is_low(struct mem_cgroup *memcg, struct zone *zone)
 {
 	unsigned long active;
Index: b/mm/vmscan.c
===================================================================
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1524,30 +1524,23 @@ static void shrink_zone(int priority, st
 	get_scan_ratio(zone, sc, percent);
 
 	for_each_evictable_lru(l) {
-		if (scan_global_lru(sc)) {
-			int file = is_file_lru(l);
-			int scan;
+		int file = is_file_lru(l);
+		int scan;
 
-			scan = zone_page_state(zone, NR_LRU_BASE + l);
-			if (priority) {
-				scan >>= priority;
-				scan = (scan * percent[file]) / 100;
-			}
+		scan = zone_page_state(zone, NR_LRU_BASE + l);
+		if (priority) {
+			scan >>= priority;
+			scan = (scan * percent[file]) / 100;
+		}
+		if (scan_global_lru(sc)) {
 			zone->lru[l].nr_scan += scan;
 			nr[l] = zone->lru[l].nr_scan;
 			if (nr[l] >= sc->swap_cluster_max)
 				zone->lru[l].nr_scan = 0;
 			else
 				nr[l] = 0;
-		} else {
-			/*
-			 * This reclaim occurs not because zone memory shortage
-			 * but because memory controller hits its limit.
-			 * Don't modify zone reclaim related data.
-			 */
-			nr[l] = mem_cgroup_calc_reclaim(sc->mem_cgroup, zone,
-								priority, l);
-		}
+		} else
+			nr[l] = scan;
 	}
 
 	while (nr[LRU_INACTIVE_ANON] || nr[LRU_ACTIVE_FILE] ||


