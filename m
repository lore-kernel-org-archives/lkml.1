Return-Path: <linux-kernel-owner+w=401wt.eu-S1757886AbZBLHdq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757886AbZBLHdq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 02:33:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753559AbZBLHdg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 02:33:36 -0500
Received: from ti-out-0910.google.com ([209.85.142.189]:40857 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752198AbZBLHdf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 02:33:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=ovSmXi6PqbjHUWvd9tdqLauj3zpmukSkqim0Q46egmIlTCD54ki+krNJsj43wma/2f
         cSdE6xAUsZrH+4Ih7cdvG4A/02JKFWbQJpff1i+s94wwcuGlpf/PSoefmNLOlj0gblkt
         hY36BbcHOR0Lcmpeve4KJ65h0YBH1Ncywh+y8=
Date: Thu, 12 Feb 2009 16:33:10 +0900
From: MinChan Kim <minchan.kim@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
       Johannes Weiner <hannes@cmpxchg.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Rik van Riel <riel@redhat.com>
Subject: [PATCH v2]  shrink_all_memory() use sc.nr_reclaimed
Message-Id: <20090212163310.b204e80a.minchan.kim@barrios-desktop>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: cleanup

Commit a79311c14eae4bb946a97af25f3e1b17d625985d "vmscan: bail out of
direct reclaim after swap_cluster_max pages" moved the nr_reclaimed
counter into the scan control to accumulate the number of all
reclaimed pages in a reclaim invocation.

The shrink_all_memory() can use the same mechanism. it increases code
consistency and readability.

It's based on mmtom 2009-02-11-17-15.

Signed-off-by: MinChan Kim <minchan.kim@gmail.com>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Rik van Riel <riel@redhat.com>


---
 mm/vmscan.c |   51 ++++++++++++++++++++++++++++++---------------------
 1 files changed, 30 insertions(+), 21 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index ae4202b..caa2de5 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2055,16 +2055,15 @@ unsigned long global_lru_pages(void)
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
-	unsigned long ret = 0;
+	unsigned long nr_reclaimed = 0;
 
 	for_each_populated_zone(zone) {
 		enum lru_list l;
@@ -2087,14 +2086,16 @@ static unsigned long shrink_all_zones(unsigned long nr_pages, int prio,
 
 				zone->lru[l].nr_scan = 0;
 				nr_to_scan = min(nr_pages, lru_pages);
-				ret += shrink_list(l, nr_to_scan, zone,
+				nr_reclaimed += shrink_list(l, nr_to_scan, zone,
 								sc, prio);
-				if (ret >= nr_pages)
-					return ret;
+				if (nr_reclaimed >= nr_pages) {
+					sc->nr_reclaimed = nr_reclaimed;
+					return;
+				}
 			}
 		}
 	}
-	return ret;
+	sc->nr_reclaimed = nr_reclaimed;
 }
 
 /*
@@ -2126,13 +2127,15 @@ unsigned long shrink_all_memory(unsigned long nr_pages)
 	/* If slab caches are huge, it's better to hit them first */
 	while (nr_slab >= lru_pages) {
 		reclaim_state.reclaimed_slab = 0;
-		shrink_slab(nr_pages, sc.gfp_mask, lru_pages);
+		shrink_slab(sc.swap_cluster_max, sc.gfp_mask, lru_pages);
 		if (!reclaim_state.reclaimed_slab)
 			break;
 
-		ret += reclaim_state.reclaimed_slab;
-		if (ret >= nr_pages)
+		sc.nr_reclaimed += reclaim_state.reclaimed_slab;
+		if (sc.nr_reclaimed >= sc.swap_cluster_max) {
+			ret = sc.nr_reclaimed;
 			goto out;
+		}
 
 		nr_slab -= reclaim_state.reclaimed_slab;
 	}
@@ -2153,19 +2156,23 @@ unsigned long shrink_all_memory(unsigned long nr_pages)
 			sc.may_unmap = 1;
 
 		for (prio = DEF_PRIORITY; prio >= 0; prio--) {
-			unsigned long nr_to_scan = nr_pages - ret;
+			unsigned long nr_to_scan = sc.swap_cluster_max - sc.nr_reclaimed;
 
 			sc.nr_scanned = 0;
-			ret += shrink_all_zones(nr_to_scan, prio, pass, &sc);
-			if (ret >= nr_pages)
+			shrink_all_zones(nr_to_scan, prio, pass, &sc);
+			if (sc.nr_reclaimed >= sc.swap_cluster_max) {
+				ret = sc.nr_reclaimed;
 				goto out;
+			}
 
 			reclaim_state.reclaimed_slab = 0;
 			shrink_slab(sc.nr_scanned, sc.gfp_mask,
 					global_lru_pages());
-			ret += reclaim_state.reclaimed_slab;
-			if (ret >= nr_pages)
+			sc.nr_reclaimed += reclaim_state.reclaimed_slab;
+			if (sc.nr_reclaimed >= sc.swap_cluster_max) {
+				ret = sc.nr_reclaimed;
 				goto out;
+			}
 
 			if (sc.nr_scanned && prio < DEF_PRIORITY - 2)
 				congestion_wait(WRITE, HZ / 10);
@@ -2173,17 +2180,19 @@ unsigned long shrink_all_memory(unsigned long nr_pages)
 	}
 
 	/*
-	 * If ret = 0, we could not shrink LRUs, but there may be something
+	 * If sc.nr_reclaimed = 0, we could not shrink LRUs, but there may be something
 	 * in slab caches
 	 */
-	if (!ret) {
+	if (!sc.nr_reclaimed) {
 		do {
 			reclaim_state.reclaimed_slab = 0;
-			shrink_slab(nr_pages, sc.gfp_mask, global_lru_pages());
-			ret += reclaim_state.reclaimed_slab;
-		} while (ret < nr_pages && reclaim_state.reclaimed_slab > 0);
+			shrink_slab(sc.swap_cluster_max, sc.gfp_mask, global_lru_pages());
+			sc.nr_reclaimed += reclaim_state.reclaimed_slab;
+		} while (sc.nr_reclaimed < sc.swap_cluster_max && reclaim_state.reclaimed_slab > 0);
 	}
 
+	ret = sc.nr_reclaimed;
+
 out:
 	current->reclaim_state = NULL;
 
-- 
1.5.4.3



-- 
Kinds Regards
MinChan Kim
