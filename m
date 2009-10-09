Return-Path: <linux-kernel-owner+w=401wt.eu-S1760360AbZJII5R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760360AbZJII5R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 04:57:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760302AbZJII5R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 04:57:17 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:54679 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760303AbZJII5Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 04:57:16 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: [PATCH 2/2] vmscan: kill shrink_all_zones()
Cc: kosaki.motohiro@jp.fujitsu.com, LKML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>
In-Reply-To: <20091009174756.12B5.A69D9226@jp.fujitsu.com>
References: <20091009174756.12B5.A69D9226@jp.fujitsu.com>
Message-Id: <20091009175559.12B8.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Fri,  9 Oct 2009 17:56:33 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

shrink_all_zone() was introduced by commit d6277db4ab (swsusp: rework
memory shrinker) for hibernate performance improvement. and sc.swap_cluster_max
was introduced by commit a06fe4d307 (Speed freeing memory for suspend).

commit a06fe4d307 said

    Without the patch:
    Freed  14600 pages in  1749 jiffies = 32.61 MB/s (Anomolous!)
    Freed  88563 pages in 14719 jiffies = 23.50 MB/s
    Freed 205734 pages in 32389 jiffies = 24.81 MB/s

    With the patch:
    Freed  68252 pages in   496 jiffies = 537.52 MB/s
    Freed 116464 pages in   569 jiffies = 798.54 MB/s
    Freed 209699 pages in   705 jiffies = 1161.89 MB/s

At that time, their patch was pretty worth. However, Modern Hardware
trend and recent VM improvement broke its worth. From several reason,
I think we should remove shrink_all_zones() at all.

detail:

1) Old days, shrink_zone()'s slowness was mainly caused by stupid congestion_wait()
   at no i/o congestion.
   but current shrink_zone() is sane, not slow.

2) shrink_all_zone() try to shrink all pages at a time. but it doesn't works
   fine on numa system.
   example)
     System has 4GB memory and each node have 2GB. and hibernate need 1GB.

     optimal)
	steal 500MB from each node.
     shrink_all_zones)
	steal 1GB from node-0.

   Oh, Cache balancing was broke ;)
   Unfortunately, Desktop system moved ahead NUMA.
   (Side note, if hibernate require 2GB, shrink_all_zones() never success)

3) if the node has several I/O flighting pages, shrink_all_zones() makes
   pretty bad result.

   schenario) hibernate need 1GB

   1) shrink_all_zones() try to reclaim 1GB from Node-0
   2) but it only reclaimed 990MB
   3) stupidly, shrink_all_zones() try to reclaim 1GB from Node-1
   4) it reclaimed 990MB

   Oh, well. it reclaimed twice much than required.
   In the other hand, current shrink_zone() has sane baling out logic.
   then, it doesn't make overkill reclaim. then, we lost shrink_zones()'s risk.

4) SplitLRU VM always keep active/inactive ratio very carefully. inactive list only
   shrinking break its assumption. it makes unnecessary OOM risk. it obviously suboptimal.

  Throuput comparision
  ==============================================
  old		2192.10 MB/s
  new		2222.22 MB/s

  ok, it's almost same throuput.

Cc: Rafael J. Wysocki <rjw@sisk.pl>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 mm/vmscan.c |   75 +++++++++++++---------------------------------------------
 1 files changed, 17 insertions(+), 58 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 80e727d..9f28166 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2130,51 +2130,6 @@ unsigned long global_lru_pages(void)
 
 #ifdef CONFIG_HIBERNATION
 /*
- * Helper function for shrink_all_memory().  Tries to reclaim 'nr_pages' pages
- * from LRU lists system-wide, for given pass and priority.
- *
- * For pass > 3 we also try to shrink the LRU lists that contain a few pages
- */
-static void shrink_all_zones(unsigned long nr_pages, int prio,
-				      int pass, struct scan_control *sc)
-{
-	struct zone *zone;
-	unsigned long nr_reclaimed = 0;
-
-	for_each_populated_zone(zone) {
-		enum lru_list l;
-
-		if (zone_is_all_unreclaimable(zone) && prio != DEF_PRIORITY)
-			continue;
-
-		for_each_evictable_lru(l) {
-			enum zone_stat_item ls = NR_LRU_BASE + l;
-			unsigned long lru_pages = zone_page_state(zone, ls);
-
-			/* For pass = 0, we don't shrink the active list */
-			if (pass == 0 && (l == LRU_ACTIVE_ANON ||
-						l == LRU_ACTIVE_FILE))
-				continue;
-
-			zone->lru[l].nr_saved_scan += (lru_pages >> prio) + 1;
-			if (zone->lru[l].nr_saved_scan >= nr_pages || pass > 3) {
-				unsigned long nr_to_scan;
-
-				zone->lru[l].nr_saved_scan = 0;
-				nr_to_scan = min(nr_pages, lru_pages);
-				nr_reclaimed += shrink_list(l, nr_to_scan, zone,
-								sc, prio);
-				if (nr_reclaimed >= nr_pages) {
-					sc->nr_reclaimed += nr_reclaimed;
-					return;
-				}
-			}
-		}
-	}
-	sc->nr_reclaimed += nr_reclaimed;
-}
-
-/*
  * Try to free `nr_pages' of memory, system-wide, and return the number of
  * freed pages.
  *
@@ -2188,12 +2143,18 @@ unsigned long shrink_all_memory(unsigned long nr_pages)
 	int pass;
 	struct reclaim_state reclaim_state;
 	struct scan_control sc = {
-		.gfp_mask = GFP_KERNEL,
+		.gfp_mask = GFP_HIGHUSER_MOVABLE,
+		.may_swap = 0,
 		.may_unmap = 0,
 		.may_writepage = 1,
+		.swap_cluster_max = SWAP_CLUSTER_MAX,
+		.nr_to_reclaim = nr_pages,
+		.swappiness = vm_swappiness,
+		.order = 0,
 		.isolate_pages = isolate_pages_global,
-		.nr_reclaimed = 0,
 	};
+	struct zonelist * zonelist = node_zonelist(first_online_node,
+						   GFP_HIGHUSER_MOVABLE);
 
 	current->reclaim_state = &reclaim_state;
 
@@ -2215,9 +2176,9 @@ unsigned long shrink_all_memory(unsigned long nr_pages)
 
 	/*
 	 * We try to shrink LRUs in 5 passes:
-	 * 0 = Reclaim from inactive_list only
-	 * 1 = Reclaim from active list but don't reclaim mapped
-	 * 2 = 2nd pass of type 1
+	 * 0 = Reclaim unmapped pages
+	 * 1 = 2nd pass of type 0
+	 * 2 = 3rd pass of type 0
 	 * 3 = Reclaim mapped (normal reclaim)
 	 * 4 = 2nd pass of type 3
 	 */
@@ -2225,15 +2186,15 @@ unsigned long shrink_all_memory(unsigned long nr_pages)
 		int prio;
 
 		/* Force reclaiming mapped pages in the passes #3 and #4 */
-		if (pass > 2)
+		if (pass > 2) {
 			sc.may_unmap = 1;
+			sc.may_swap = 1;
+		}
 
 		for (prio = DEF_PRIORITY; prio >= 0; prio--) {
-			unsigned long nr_to_scan = nr_pages - sc.nr_reclaimed;
-
 			sc.nr_scanned = 0;
-			sc.swap_cluster_max = nr_to_scan;
-			shrink_all_zones(nr_to_scan, prio, pass, &sc);
+
+			shrink_zones(prio, zonelist, &sc);
 			if (sc.nr_reclaimed >= nr_pages)
 				goto out;
 
@@ -2243,10 +2204,8 @@ unsigned long shrink_all_memory(unsigned long nr_pages)
 			sc.nr_reclaimed += reclaim_state.reclaimed_slab;
 			if (sc.nr_reclaimed >= nr_pages)
 				goto out;
-
-			if (sc.nr_scanned && prio < DEF_PRIORITY - 2)
-				congestion_wait(BLK_RW_ASYNC, HZ / 10);
 		}
+		congestion_wait(BLK_RW_ASYNC, HZ / 10);
 	}
 
 	/*
-- 
1.6.2.5



