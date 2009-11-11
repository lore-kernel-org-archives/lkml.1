Return-Path: <linux-kernel-owner+w=401wt.eu-S1756781AbZKKCBV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756781AbZKKCBV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 21:01:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756583AbZKKCBT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 21:01:19 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:50208 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756703AbZKKCBP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 21:01:15 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/5] vmscan: Kill hibernation specific reclaim logic and unify it
Cc: kosaki.motohiro@jp.fujitsu.com, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Minchan Kim <minchan.kim@gmail.com>, Rik van Riel <riel@redhat.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
In-Reply-To: <20091111104744.FD3B.A69D9226@jp.fujitsu.com>
References: <20091111104744.FD3B.A69D9226@jp.fujitsu.com>
Message-Id: <20091111105841.FD41.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed, 11 Nov 2009 11:01:18 +0900 (JST)
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

1) Old days, shrink_zone()'s slowness was mainly caused by stupid io-throttle
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

  Oh, Cache balancing logic was broken. ;)
  Unfortunately, Desktop system moved ahead NUMA at nowadays.
  (Side note, if hibernate require 2GB, shrink_all_zones() never success
   on above machine)

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

Now, shrink_all_memory() is only the wrapper function of do_try_to_free_pages().
it bring good reviewability and debuggability, and solve above problems.

side note: Reclaim logic unificication makes two good side effect.
 - Fix recursive reclaim bug on shrink_all_memory().
   it did forgot to use PF_MEMALLOC. it mean the system be able to stuck into deadlock.
 - Now, shrink_all_memory() got lockdep awareness. it bring good debuggability.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Reviewed-by: Rik van Riel <riel@redhat.com>
Acked-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 mm/vmscan.c |  153 ++++++++++-------------------------------------------------
 1 files changed, 26 insertions(+), 127 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 7be2927..eebd260 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -58,6 +58,8 @@ struct scan_control {
 	/* How many pages shrink_list() should reclaim */
 	unsigned long nr_to_reclaim;
 
+	unsigned long hibernation_mode;
+
 	/* This context's GFP mask */
 	gfp_t gfp_mask;
 
@@ -1791,7 +1793,8 @@ static unsigned long do_try_to_free_pages(struct zonelist *zonelist,
 		}
 
 		/* Take a nap, wait for some writeback to complete */
-		if (sc->nr_scanned && priority < DEF_PRIORITY - 2)
+		if (!sc->hibernation_mode && sc->nr_scanned &&
+		    priority < DEF_PRIORITY - 2)
 			congestion_wait(BLK_RW_ASYNC, HZ/10);
 	}
 	/* top priority shrink_zones still had more to do? don't OOM, then */
@@ -2266,148 +2269,44 @@ unsigned long zone_reclaimable_pages(struct zone *zone)
 
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
-	struct zone_reclaim_stat *reclaim_stat;
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
-			reclaim_stat = get_reclaim_stat(zone, sc);
-			reclaim_stat->nr_saved_scan[l] +=
-						(lru_pages >> prio) + 1;
-			if (reclaim_stat->nr_saved_scan[l]
-						>= nr_pages || pass > 3) {
-				unsigned long nr_to_scan;
-
-				reclaim_stat->nr_saved_scan[l] = 0;
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
- * Try to free `nr_pages' of memory, system-wide, and return the number of
+ * Try to free `nr_to_reclaim' of memory, system-wide, and return the number of
  * freed pages.
  *
  * Rather than trying to age LRUs the aim is to preserve the overall
  * LRU order by reclaiming preferentially
  * inactive > active > active referenced > active mapped
  */
-unsigned long shrink_all_memory(unsigned long nr_pages)
+unsigned long shrink_all_memory(unsigned long nr_to_reclaim)
 {
-	unsigned long lru_pages, nr_slab;
-	int pass;
 	struct reclaim_state reclaim_state;
 	struct scan_control sc = {
-		.gfp_mask = GFP_KERNEL,
-		.may_unmap = 0,
+		.gfp_mask = GFP_HIGHUSER_MOVABLE,
+		.may_swap = 1,
+		.may_unmap = 1,
 		.may_writepage = 1,
+		.swap_cluster_max = SWAP_CLUSTER_MAX,
+		.nr_to_reclaim = nr_to_reclaim,
+		.hibernation_mode = 1,
+		.swappiness = vm_swappiness,
+		.order = 0,
 		.isolate_pages = isolate_pages_global,
-		.nr_reclaimed = 0,
 	};
+	struct zonelist * zonelist = node_zonelist(numa_node_id(), sc.gfp_mask);
+	struct task_struct *p = current;
+	unsigned long nr_reclaimed;
 
-	current->reclaim_state = &reclaim_state;
-
-	lru_pages = global_reclaimable_pages();
-	nr_slab = global_page_state(NR_SLAB_RECLAIMABLE);
-	/* If slab caches are huge, it's better to hit them first */
-	while (nr_slab >= lru_pages) {
-		reclaim_state.reclaimed_slab = 0;
-		shrink_slab(nr_pages, sc.gfp_mask, lru_pages);
-		if (!reclaim_state.reclaimed_slab)
-			break;
-
-		sc.nr_reclaimed += reclaim_state.reclaimed_slab;
-		if (sc.nr_reclaimed >= nr_pages)
-			goto out;
-
-		nr_slab -= reclaim_state.reclaimed_slab;
-	}
-
-	/*
-	 * We try to shrink LRUs in 5 passes:
-	 * 0 = Reclaim from inactive_list only
-	 * 1 = Reclaim from active list but don't reclaim mapped
-	 * 2 = 2nd pass of type 1
-	 * 3 = Reclaim mapped (normal reclaim)
-	 * 4 = 2nd pass of type 3
-	 */
-	for (pass = 0; pass < 5; pass++) {
-		int prio;
-
-		/* Force reclaiming mapped pages in the passes #3 and #4 */
-		if (pass > 2)
-			sc.may_unmap = 1;
-
-		for (prio = DEF_PRIORITY; prio >= 0; prio--) {
-			unsigned long nr_to_scan = nr_pages - sc.nr_reclaimed;
-
-			sc.nr_scanned = 0;
-			sc.swap_cluster_max = nr_to_scan;
-			shrink_all_zones(nr_to_scan, prio, pass, &sc);
-			if (sc.nr_reclaimed >= nr_pages)
-				goto out;
-
-			reclaim_state.reclaimed_slab = 0;
-			shrink_slab(sc.nr_scanned, sc.gfp_mask,
-				    global_reclaimable_pages());
-			sc.nr_reclaimed += reclaim_state.reclaimed_slab;
-			if (sc.nr_reclaimed >= nr_pages)
-				goto out;
-
-			if (sc.nr_scanned && prio < DEF_PRIORITY - 2)
-				congestion_wait(BLK_RW_ASYNC, HZ / 10);
-		}
-	}
-
-	/*
-	 * If sc.nr_reclaimed = 0, we could not shrink LRUs, but there may be
-	 * something in slab caches
-	 */
-	if (!sc.nr_reclaimed) {
-		do {
-			reclaim_state.reclaimed_slab = 0;
-			shrink_slab(nr_pages, sc.gfp_mask,
-				    global_reclaimable_pages());
-			sc.nr_reclaimed += reclaim_state.reclaimed_slab;
-		} while (sc.nr_reclaimed < nr_pages &&
-				reclaim_state.reclaimed_slab > 0);
-	}
+	p->flags |= PF_MEMALLOC;
+	lockdep_set_current_reclaim_state(sc.gfp_mask);
+	reclaim_state.reclaimed_slab = 0;
+	p->reclaim_state = &reclaim_state;
 
+	nr_reclaimed = do_try_to_free_pages(zonelist, &sc);
 
-out:
-	current->reclaim_state = NULL;
+	p->reclaim_state = NULL;
+	lockdep_clear_current_reclaim_state();
+	p->flags &= ~PF_MEMALLOC;
 
-	return sc.nr_reclaimed;
+	return nr_reclaimed;
 }
 #endif /* CONFIG_HIBERNATION */
 
-- 
1.6.2.5



