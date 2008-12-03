Return-Path: <linux-kernel-owner+w=401wt.eu-S1754714AbYLCFF0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754714AbYLCFF0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 00:05:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751182AbYLCFFO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 00:05:14 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:52610 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750847AbYLCFFN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 00:05:13 -0500
Date: Wed, 3 Dec 2008 14:04:22 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH  14/21] memcg-remove-mem_cgroup_cal_reclaim.patch
Message-Id: <20081203140422.9a4ad305.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20081203134718.6b60986f.kamezawa.hiroyu@jp.fujitsu.com>
References: <20081203134718.6b60986f.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now, get_scan_ratio() return correct value although memcg reclaim.
Then, mem_cgroup_calc_reclaim() can be removed.

So, memcg reclaim get the same capability of anon/file reclaim balancing as global reclaim now.

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@redhat.com>
Acked-by: Rik van Riel <riel@redhat.com>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
 include/linux/memcontrol.h |   10 ----------
 mm/memcontrol.c            |   21 ---------------------
 mm/vmscan.c                |   27 ++++++++++-----------------
 3 files changed, 10 insertions(+), 48 deletions(-)

Index: mmotm-2.6.28-Dec02/include/linux/memcontrol.h
===================================================================
--- mmotm-2.6.28-Dec02.orig/include/linux/memcontrol.h
+++ mmotm-2.6.28-Dec02/include/linux/memcontrol.h
@@ -97,9 +97,6 @@ extern void mem_cgroup_note_reclaim_prio
 							int priority);
 extern void mem_cgroup_record_reclaim_priority(struct mem_cgroup *mem,
 							int priority);
-
-extern long mem_cgroup_calc_reclaim(struct mem_cgroup *mem, struct zone *zone,
-					int priority, enum lru_list lru);
 int mem_cgroup_inactive_anon_is_low(struct mem_cgroup *memcg,
 				    struct zone *zone);
 unsigned long mem_cgroup_zone_nr_pages(struct mem_cgroup *memcg,
@@ -244,13 +241,6 @@ static inline void mem_cgroup_record_rec
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
Index: mmotm-2.6.28-Dec02/mm/memcontrol.c
===================================================================
--- mmotm-2.6.28-Dec02.orig/mm/memcontrol.c
+++ mmotm-2.6.28-Dec02/mm/memcontrol.c
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
Index: mmotm-2.6.28-Dec02/mm/vmscan.c
===================================================================
--- mmotm-2.6.28-Dec02.orig/mm/vmscan.c
+++ mmotm-2.6.28-Dec02/mm/vmscan.c
@@ -1519,30 +1519,23 @@ static void shrink_zone(int priority, st
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

