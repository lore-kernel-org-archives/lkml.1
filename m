Return-Path: <linux-kernel-owner+w=401wt.eu-S1755195AbZBJNAj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755195AbZBJNAj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 08:00:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754008AbZBJNAa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 08:00:30 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:38365 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753623AbZBJNA3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 08:00:29 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: MinChan Kim <minchan.kim@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>,
       Rik van Riel <riel@redhat.com>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: [PATCH] shrink_all_memory() use sc.nr_reclaimed
Cc: kosaki.motohiro@jp.fujitsu.com,
       William Lee Irwin III <wli@movementarian.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
In-Reply-To: <20090210215718.700D.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <28c262360902100440v765d3f7bnd56cc4b5510349c0@mail.gmail.com> <20090210215718.700D.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Message-Id: <20090210215811.7010.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Tue, 10 Feb 2009 22:00:26 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup

Commit a79311c14eae4bb946a97af25f3e1b17d625985d "vmscan: bail out of
direct reclaim after swap_cluster_max pages" moved the nr_reclaimed
counter into the scan control to accumulate the number of all
reclaimed pages in a reclaim invocation.

shrink_all_memory() can use the same mechanism. it increase code 
consistency.


Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: MinChan Kim <minchan.kim@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Rik van Riel <riel@redhat.com>
---
 mm/vmscan.c |   49 ++++++++++++++++++++++++-------------------------
 1 file changed, 24 insertions(+), 25 deletions(-)

Index: b/mm/vmscan.c
===================================================================
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2004,16 +2004,15 @@ unsigned long global_lru_pages(void)
 #ifdef CONFIG_PM
 /*
  * Helper function for shrink_all_memory().  Tries to reclaim 'nr_pages' pages
- * from LRU lists system-wide, for given pass and priority, and returns the
- * number of reclaimed pages
+ * from LRU lists system-wide, for given pass and priority.
  *
  * For pass > 3 we also try to shrink the LRU lists that contain a few pages
  */
-static unsigned long shrink_all_zones(unsigned long nr_pages, int prio,
+static void shrink_all_zones(unsigned long nr_pages, int prio,
 				      int pass, struct scan_control *sc)
 {
 	struct zone *zone;
-	unsigned long nr_to_scan, ret = 0;
+	unsigned long nr_to_scan;
 	enum lru_list l;
 
 	for_each_zone(zone) {
@@ -2038,15 +2037,13 @@ static unsigned long shrink_all_zones(un
 				nr_to_scan = min(nr_pages,
 					zone_page_state(zone,
 							NR_LRU_BASE + l));
-				ret += shrink_list(l, nr_to_scan, zone,
-								sc, prio);
-				if (ret >= nr_pages)
-					return ret;
+				sc->nr_reclaimed += shrink_list(l, nr_to_scan,
+								zone, sc, prio);
+				if (sc->nr_reclaimed >= nr_pages)
+					return;
 			}
 		}
 	}
-
-	return ret;
 }
 
 /*
@@ -2060,10 +2057,10 @@ static unsigned long shrink_all_zones(un
 unsigned long shrink_all_memory(unsigned long nr_pages)
 {
 	unsigned long lru_pages, nr_slab;
-	unsigned long ret = 0;
 	int pass;
 	struct reclaim_state reclaim_state;
 	struct scan_control sc = {
+		.nr_reclaimed = 0,
 		.gfp_mask = GFP_KERNEL,
 		.may_swap = 0,
 		.swap_cluster_max = nr_pages,
@@ -2083,8 +2080,8 @@ unsigned long shrink_all_memory(unsigned
 		if (!reclaim_state.reclaimed_slab)
 			break;
 
-		ret += reclaim_state.reclaimed_slab;
-		if (ret >= nr_pages)
+		sc.nr_reclaimed += reclaim_state.reclaimed_slab;
+		if (sc.nr_reclaimed >= nr_pages)
 			goto out;
 
 		nr_slab -= reclaim_state.reclaimed_slab;
@@ -2108,18 +2105,18 @@ unsigned long shrink_all_memory(unsigned
 		}
 
 		for (prio = DEF_PRIORITY; prio >= 0; prio--) {
-			unsigned long nr_to_scan = nr_pages - ret;
+			unsigned long nr_to_scan = nr_pages - sc.nr_reclaimed;
 
 			sc.nr_scanned = 0;
-			ret += shrink_all_zones(nr_to_scan, prio, pass, &sc);
-			if (ret >= nr_pages)
+			shrink_all_zones(nr_to_scan, prio, pass, &sc);
+			if (sc.nr_reclaimed >= nr_pages)
 				goto out;
 
 			reclaim_state.reclaimed_slab = 0;
 			shrink_slab(sc.nr_scanned, sc.gfp_mask,
 					global_lru_pages());
-			ret += reclaim_state.reclaimed_slab;
-			if (ret >= nr_pages)
+			sc.nr_reclaimed += reclaim_state.reclaimed_slab;
+			if (sc.nr_reclaimed >= nr_pages)
 				goto out;
 
 			if (sc.nr_scanned && prio < DEF_PRIORITY - 2)
@@ -2128,21 +2125,23 @@ unsigned long shrink_all_memory(unsigned
 	}
 
 	/*
-	 * If ret = 0, we could not shrink LRUs, but there may be something
-	 * in slab caches
+	 * If sc.nr_reclaimed = 0, we could not shrink LRUs, but there may be
+	 * something in slab caches
 	 */
-	if (!ret) {
+	if (!sc.nr_reclaimed) {
 		do {
 			reclaim_state.reclaimed_slab = 0;
-			shrink_slab(nr_pages, sc.gfp_mask, global_lru_pages());
-			ret += reclaim_state.reclaimed_slab;
-		} while (ret < nr_pages && reclaim_state.reclaimed_slab > 0);
+			shrink_slab(nr_pages, sc.gfp_mask,
+				    global_lru_pages());
+			sc.nr_reclaimed += reclaim_state.reclaimed_slab;
+		} while (sc.nr_reclaimed < nr_pages &&
+			 reclaim_state.reclaimed_slab > 0);
 	}
 
 out:
 	current->reclaim_state = NULL;
 
-	return ret;
+	return sc.nr_reclaimed;
 }
 #endif
 


