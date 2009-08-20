Return-Path: <linux-kernel-owner+w=401wt.eu-S1753599AbZHTCtq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753599AbZHTCtq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 22:49:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753492AbZHTCtq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 22:49:46 -0400
Received: from mga14.intel.com ([143.182.124.37]:8373 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753065AbZHTCtp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 22:49:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,412,1246863600"; 
   d="scan'208";a="177989385"
Date: Thu, 20 Aug 2009 10:49:29 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
       Avi Kivity <avi@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>,
       "Dike, Jeffrey G" <jeffrey.g.dike@intel.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Christoph Lameter <cl@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "lizf@cn.fujitsu.com" <lizf@cn.fujitsu.com>,
       "menage@google.com" <menage@google.com>
Subject: [PATCH] mm: do batched scans for mem_cgroup
Message-ID: <20090820024929.GA19793@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For mem_cgroup, shrink_zone() may call shrink_list() with nr_to_scan=1,
in which case shrink_list() _still_ calls isolate_pages() with the much
larger SWAP_CLUSTER_MAX.  It effectively scales up the inactive list
scan rate by up to 32 times.

For example, with 16k inactive pages and DEF_PRIORITY=12, (16k >> 12)=4.
So when shrink_zone() expects to scan 4 pages in the active/inactive
list, it will be scanned SWAP_CLUSTER_MAX=32 pages in effect.

The accesses to nr_saved_scan are not lock protected and so not 100%
accurate, however we can tolerate small errors and the resulted small
imbalanced scan rates between zones.

This batching won't blur up the cgroup limits, since it is driven by
"pages reclaimed" rather than "pages scanned". When shrink_zone()
decides to cancel (and save) one smallish scan, it may well be called
again to accumulate up nr_saved_scan.

It could possibly be a problem for some tiny mem_cgroup (which may be
_full_ scanned too much times in order to accumulate up nr_saved_scan).

CC: Rik van Riel <riel@redhat.com>
CC: Minchan Kim <minchan.kim@gmail.com>
CC: Balbir Singh <balbir@linux.vnet.ibm.com>
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 include/linux/memcontrol.h |    3 +++
 mm/memcontrol.c            |   12 ++++++++++++
 mm/vmscan.c                |    9 +++++----
 3 files changed, 20 insertions(+), 4 deletions(-)

--- linux.orig/include/linux/memcontrol.h	2009-08-20 10:41:05.000000000 +0800
+++ linux/include/linux/memcontrol.h	2009-08-20 10:43:22.000000000 +0800
@@ -98,6 +98,9 @@ int mem_cgroup_inactive_file_is_low(stru
 unsigned long mem_cgroup_zone_nr_pages(struct mem_cgroup *memcg,
 				       struct zone *zone,
 				       enum lru_list lru);
+unsigned long *mem_cgroup_get_saved_scan(struct mem_cgroup *memcg,
+					 struct zone *zone,
+					 enum lru_list lru);
 struct zone_reclaim_stat *mem_cgroup_get_reclaim_stat(struct mem_cgroup *memcg,
 						      struct zone *zone);
 struct zone_reclaim_stat*
--- linux.orig/mm/memcontrol.c	2009-08-20 10:43:20.000000000 +0800
+++ linux/mm/memcontrol.c	2009-08-20 10:43:22.000000000 +0800
@@ -115,6 +115,7 @@ struct mem_cgroup_per_zone {
 	 */
 	struct list_head	lists[NR_LRU_LISTS];
 	unsigned long		count[NR_LRU_LISTS];
+	unsigned long		nr_saved_scan[NR_LRU_LISTS];
 
 	struct zone_reclaim_stat reclaim_stat;
 };
@@ -597,6 +598,17 @@ unsigned long mem_cgroup_zone_nr_pages(s
 	return MEM_CGROUP_ZSTAT(mz, lru);
 }
 
+unsigned long *mem_cgroup_get_saved_scan(struct mem_cgroup *memcg,
+					 struct zone *zone,
+					 enum lru_list lru)
+{
+	int nid = zone->zone_pgdat->node_id;
+	int zid = zone_idx(zone);
+	struct mem_cgroup_per_zone *mz = mem_cgroup_zoneinfo(memcg, nid, zid);
+
+	return &mz->nr_saved_scan[lru];
+}
+
 struct zone_reclaim_stat *mem_cgroup_get_reclaim_stat(struct mem_cgroup *memcg,
 						      struct zone *zone)
 {
--- linux.orig/mm/vmscan.c	2009-08-20 10:40:56.000000000 +0800
+++ linux/mm/vmscan.c	2009-08-20 10:43:22.000000000 +0800
@@ -1534,6 +1534,7 @@ static void shrink_zone(int priority, st
 	for_each_evictable_lru(l) {
 		int file = is_file_lru(l);
 		unsigned long scan;
+		unsigned long *saved_scan;
 
 		scan = zone_nr_pages(zone, sc, l);
 		if (priority || noswap) {
@@ -1541,11 +1542,11 @@ static void shrink_zone(int priority, st
 			scan = (scan * percent[file]) / 100;
 		}
 		if (scanning_global_lru(sc))
-			nr[l] = nr_scan_try_batch(scan,
-						  &zone->lru[l].nr_saved_scan,
-						  swap_cluster_max);
+			saved_scan = &zone->lru[l].nr_saved_scan;
 		else
-			nr[l] = scan;
+			saved_scan = mem_cgroup_get_saved_scan(sc->mem_cgroup,
+							       zone, l);
+		nr[l] = nr_scan_try_batch(scan, saved_scan, swap_cluster_max);
 	}
 
 	while (nr[LRU_INACTIVE_ANON] || nr[LRU_ACTIVE_FILE] ||
