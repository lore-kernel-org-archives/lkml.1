Return-Path: <linux-kernel-owner+w=401wt.eu-S1755284AbXHTVzl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755284AbXHTVzl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 17:55:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752284AbXHTVxY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 17:53:24 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:51608 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751523AbXHTVxS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 17:53:18 -0400
Message-Id: <20070820215316.762304882@sgi.com>
References: <20070820215040.937296148@sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 20 Aug 2007 14:50:44 -0700
From: Christoph Lameter <clameter@sgi.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org
Cc: dkegel@google.com
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: David Miller <davem@davemloft.net>
Cc: Nick Piggin <npiggin@suse.de>
Subject: [RFC 4/7] Pass laundry through shrink_inactive_list() and shrink_zone()
Content-Disposition: inline; filename=shrink_zones
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Both functions are equipped with an additional laundry parameter
that is then passed to shrink_page_list.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 mm/vmscan.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

Index: linux-2.6/mm/vmscan.c
===================================================================
--- linux-2.6.orig/mm/vmscan.c	2007-08-19 23:27:16.000000000 -0700
+++ linux-2.6/mm/vmscan.c	2007-08-19 23:30:15.000000000 -0700
@@ -802,7 +802,7 @@ static unsigned long clear_active_flags(
  * of reclaimed pages
  */
 static unsigned long shrink_inactive_list(unsigned long max_scan,
-				struct zone *zone, struct scan_control *sc)
+	struct zone *zone, struct scan_control *sc, struct list_head *laundry)
 {
 	LIST_HEAD(page_list);
 	unsigned long nr_scanned = 0;
@@ -830,7 +830,7 @@ static unsigned long shrink_inactive_lis
 		spin_unlock_irq(&zone->lru_lock);
 
 		nr_scanned += nr_scan;
-		nr_freed = shrink_page_list(&page_list, sc, NULL);
+		nr_freed = shrink_page_list(&page_list, sc, laundry);
 		nr_reclaimed += nr_freed;
 		local_irq_disable();
 		if (current_is_kswapd()) {
@@ -1030,7 +1030,7 @@ force_reclaim_mapped:
  * This is a basic per-zone page freer.  Used by both kswapd and direct reclaim.
  */
 static unsigned long shrink_zone(int priority, struct zone *zone,
-				struct scan_control *sc)
+			struct scan_control *sc, struct list_head *laundry)
 {
 	unsigned long nr_active;
 	unsigned long nr_inactive;
@@ -1072,7 +1072,7 @@ static unsigned long shrink_zone(int pri
 					(unsigned long)sc->swap_cluster_max);
 			nr_inactive -= nr_to_scan;
 			nr_reclaimed += shrink_inactive_list(nr_to_scan, zone,
-								sc);
+								sc, laundry);
 		}
 	}
 
@@ -1121,7 +1121,7 @@ static unsigned long shrink_zones(int pr
 
 		sc->all_unreclaimable = 0;
 
-		nr_reclaimed += shrink_zone(priority, zone, sc);
+		nr_reclaimed += shrink_zone(priority, zone, sc, NULL);
 	}
 	return nr_reclaimed;
 }
@@ -1341,7 +1341,7 @@ loop_again:
 			temp_priority[i] = priority;
 			sc.nr_scanned = 0;
 			note_zone_scanning_priority(zone, priority);
-			nr_reclaimed += shrink_zone(priority, zone, &sc);
+			nr_reclaimed += shrink_zone(priority, zone, &sc, NULL);
 			reclaim_state->reclaimed_slab = 0;
 			nr_slab = shrink_slab(sc.nr_scanned, GFP_KERNEL,
 						lru_pages);
@@ -1539,7 +1539,7 @@ static unsigned long shrink_all_zones(un
 			zone->nr_scan_inactive = 0;
 			nr_to_scan = min(nr_pages,
 				zone_page_state(zone, NR_INACTIVE));
-			ret += shrink_inactive_list(nr_to_scan, zone, sc);
+			ret += shrink_inactive_list(nr_to_scan, zone, sc, NULL);
 			if (ret >= nr_pages)
 				return ret;
 		}
@@ -1780,7 +1780,7 @@ static int __zone_reclaim(struct zone *z
 		priority = ZONE_RECLAIM_PRIORITY;
 		do {
 			note_zone_scanning_priority(zone, priority);
-			nr_reclaimed += shrink_zone(priority, zone, &sc);
+			nr_reclaimed += shrink_zone(priority, zone, &sc, NULL);
 			priority--;
 		} while (priority >= 0 && nr_reclaimed < nr_pages);
 	}

-- 
