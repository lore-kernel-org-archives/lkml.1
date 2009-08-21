Return-Path: <linux-kernel-owner+w=401wt.eu-S932866AbZHUXyO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932866AbZHUXyO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 19:54:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755017AbZHUXyO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 19:54:14 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45427 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752616AbZHUXyN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 19:54:13 -0400
Date: Fri, 21 Aug 2009 16:54:03 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Andy Whitcroft <apw@canonical.com>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, apw@canonical.com
Subject: Re: [PATCH 0/7] update checkpatch to v0.29
Message-Id: <20090821165403.88a7fbd1.akpm@linux-foundation.org>
In-Reply-To: <1250891170-8599-1-git-send-email-apw@canonical.com>
References: <1250891170-8599-1-git-send-email-apw@canonical.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Aug 2009 22:46:03 +0100
Andy Whitcroft <apw@canonical.com> wrote:

> Here is a few update for checkpatch that seem to have gotten lost
> somewhere along the line, I though you had everything I had queued.
> These have passed testing here, I have some more stuff in testing and I
> will get those out soon.
> 
> This update brings an a number of minor fixes.  Thanks for the
> contributions.

Running checkpatch 0.29 against the below diff produces a warning spew:

Use of uninitialized value in length at scripts/checkpatch.pl line 1480.
Use of uninitialized value in substr at scripts/checkpatch.pl line 1480.
Use of uninitialized value in substr at scripts/checkpatch.pl line 1480.
Use of uninitialized value in pattern match (m//) at scripts/checkpatch.pl line 1488.
Use of uninitialized value in pattern match (m//) at scripts/checkpatch.pl line 1545.
Use of uninitialized value in length at scripts/checkpatch.pl line 1480.
Use of uninitialized value in substr at scripts/checkpatch.pl line 1480.
Use of uninitialized value in substr at scripts/checkpatch.pl line 1480.
Use of uninitialized value in pattern match (m//) at scripts/checkpatch.pl line 1488.
Use of uninitialized value in pattern match (m//) at scripts/checkpatch.pl line 1545.
total: 0 errors, 0 warnings, 72 lines checked




From: Wu Fengguang <fengguang.wu@intel.com>

For mem_cgroup, shrink_zone() may call shrink_list() with nr_to_scan=1, in
which case shrink_list() _still_ calls isolate_pages() with the much
larger SWAP_CLUSTER_MAX.  It effectively scales up the inactive list scan
rate by up to 32 times.

For example, with 16k inactive pages and DEF_PRIORITY=12, (16k >> 12)=4. 
So when shrink_zone() expects to scan 4 pages in the active/inactive list,
the active list will be scanned 4 pages, while the inactive list will be
(over) scanned SWAP_CLUSTER_MAX=32 pages in effect.  And that could break
the balance between the two lists.

It can further impact the scan of anon active list, due to the anon
active/inactive ratio rebalance logic in balance_pgdat()/shrink_zone():

inactive anon list over scanned => inactive_anon_is_low() == TRUE
                                => shrink_active_list()
                                => active anon list over scanned

So the end result may be

- anon inactive  => over scanned
- anon active    => over scanned (maybe not as much)
- file inactive  => over scanned
- file active    => under scanned (relatively)

The accesses to nr_saved_scan are not lock protected and so not 100%
accurate, however we can tolerate small errors and the resulted small
imbalanced scan rates between zones.

Cc: Rik van Riel <riel@redhat.com>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    6 +++++-
 mm/page_alloc.c        |    2 +-
 mm/vmscan.c            |   20 +++++++++++---------
 3 files changed, 17 insertions(+), 11 deletions(-)

diff -puN include/linux/mmzone.h~mm-do-batched-scans-for-mem_cgroup include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-do-batched-scans-for-mem_cgroup
+++ a/include/linux/mmzone.h
@@ -273,6 +273,11 @@ struct zone_reclaim_stat {
 	 */
 	unsigned long		recent_rotated[2];
 	unsigned long		recent_scanned[2];
+
+	/*
+	 * accumulated for batching
+	 */
+	unsigned long		nr_saved_scan[NR_LRU_LISTS];
 };
 
 struct zone {
@@ -327,7 +332,6 @@ struct zone {
 	spinlock_t		lru_lock;	
 	struct zone_lru {
 		struct list_head list;
-		unsigned long nr_saved_scan;	/* accumulated for batching */
 	} lru[NR_LRU_LISTS];
 
 	struct zone_reclaim_stat reclaim_stat;
diff -puN mm/page_alloc.c~mm-do-batched-scans-for-mem_cgroup mm/page_alloc.c
--- a/mm/page_alloc.c~mm-do-batched-scans-for-mem_cgroup
+++ a/mm/page_alloc.c
@@ -3830,7 +3830,7 @@ static void __paginginit free_area_init_
 		zone_pcp_init(zone);
 		for_each_lru(l) {
 			INIT_LIST_HEAD(&zone->lru[l].list);
-			zone->lru[l].nr_saved_scan = 0;
+			zone->reclaim_stat.nr_saved_scan[l] = 0;
 		}
 		zone->reclaim_stat.recent_rotated[0] = 0;
 		zone->reclaim_stat.recent_rotated[1] = 0;
diff -puN mm/vmscan.c~mm-do-batched-scans-for-mem_cgroup mm/vmscan.c
--- a/mm/vmscan.c~mm-do-batched-scans-for-mem_cgroup
+++ a/mm/vmscan.c
@@ -1586,6 +1586,7 @@ static void shrink_zone(int priority, st
 	enum lru_list l;
 	unsigned long nr_reclaimed = sc->nr_reclaimed;
 	unsigned long swap_cluster_max = sc->swap_cluster_max;
+	struct zone_reclaim_stat *reclaim_stat = get_reclaim_stat(zone, sc);
 	int noswap = 0;
 
 	/* If we have no swap space, do not bother scanning anon pages. */
@@ -1605,12 +1606,9 @@ static void shrink_zone(int priority, st
 			scan >>= priority;
 			scan = (scan * percent[file]) / 100;
 		}
-		if (scanning_global_lru(sc))
-			nr[l] = nr_scan_try_batch(scan,
-						  &zone->lru[l].nr_saved_scan,
-						  swap_cluster_max);
-		else
-			nr[l] = scan;
+		nr[l] = nr_scan_try_batch(scan,
+					  &reclaim_stat->nr_saved_scan[l],
+					  swap_cluster_max);
 	}
 
 	while (nr[LRU_INACTIVE_ANON] || nr[LRU_ACTIVE_FILE] ||
@@ -2220,6 +2218,7 @@ static void shrink_all_zones(unsigned lo
 {
 	struct zone *zone;
 	unsigned long nr_reclaimed = 0;
+	struct zone_reclaim_stat *reclaim_stat;
 
 	for_each_populated_zone(zone) {
 		enum lru_list l;
@@ -2236,11 +2235,14 @@ static void shrink_all_zones(unsigned lo
 						l == LRU_ACTIVE_FILE))
 				continue;
 
-			zone->lru[l].nr_saved_scan += (lru_pages >> prio) + 1;
-			if (zone->lru[l].nr_saved_scan >= nr_pages || pass > 3) {
+			reclaim_stat = get_reclaim_stat(zone, sc);
+			reclaim_stat->nr_saved_scan[l] +=
+						(lru_pages >> prio) + 1;
+			if (reclaim_stat->nr_saved_scan[l]
+						>= nr_pages || pass > 3) {
 				unsigned long nr_to_scan;
 
-				zone->lru[l].nr_saved_scan = 0;
+				reclaim_stat->nr_saved_scan[l] = 0;
 				nr_to_scan = min(nr_pages, lru_pages);
 				nr_reclaimed += shrink_list(l, nr_to_scan, zone,
 								sc, prio);
_

