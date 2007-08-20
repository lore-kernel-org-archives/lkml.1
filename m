Return-Path: <linux-kernel-owner+w=401wt.eu-S1759718AbXHTVy5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759718AbXHTVy5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 17:54:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752210AbXHTVxX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 17:53:23 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:59780 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751527AbXHTVxS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 17:53:18 -0400
Message-Id: <20070820215316.994224842@sgi.com>
References: <20070820215040.937296148@sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 20 Aug 2007 14:50:45 -0700
From: Christoph Lameter <clameter@sgi.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org
Cc: dkegel@google.com
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: David Miller <davem@davemloft.net>
Cc: Nick Piggin <npiggin@suse.de>
Subject: [RFC 5/7] Laundry handling for direct reclaim
Content-Disposition: inline; filename=direct_reclaim
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Direct reclaim collects a global laundry list in try_to_free_pages().

Pages are only written back after a reclaim pass is complete.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 mm/vmscan.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

Index: linux-2.6/mm/vmscan.c
===================================================================
--- linux-2.6.orig/mm/vmscan.c	2007-08-19 23:30:15.000000000 -0700
+++ linux-2.6/mm/vmscan.c	2007-08-19 23:53:43.000000000 -0700
@@ -1099,7 +1099,7 @@ static unsigned long shrink_zone(int pri
  * scan then give up on it.
  */
 static unsigned long shrink_zones(int priority, struct zone **zones,
-					struct scan_control *sc)
+			struct scan_control *sc, struct list_head *laundry)
 {
 	unsigned long nr_reclaimed = 0;
 	int i;
@@ -1121,7 +1121,7 @@ static unsigned long shrink_zones(int pr
 
 		sc->all_unreclaimable = 0;
 
-		nr_reclaimed += shrink_zone(priority, zone, sc, NULL);
+		nr_reclaimed += shrink_zone(priority, zone, sc, laundry);
 	}
 	return nr_reclaimed;
 }
@@ -1156,6 +1156,7 @@ unsigned long try_to_free_pages(struct z
 		.swappiness = vm_swappiness,
 		.order = order,
 	};
+	LIST_HEAD(laundry);
 
 	count_vm_event(ALLOCSTALL);
 
@@ -1170,16 +1171,19 @@ unsigned long try_to_free_pages(struct z
 	}
 
 	for (priority = DEF_PRIORITY; priority >= 0; priority--) {
+
 		sc.nr_scanned = 0;
 		if (!priority)
 			disable_swap_token();
-		nr_reclaimed += shrink_zones(priority, zones, &sc);
+		nr_reclaimed += shrink_zones(priority, zones, &sc, &laundry);
 		shrink_slab(sc.nr_scanned, gfp_mask, lru_pages);
 		if (reclaim_state) {
 			nr_reclaimed += reclaim_state->reclaimed_slab;
 			reclaim_state->reclaimed_slab = 0;
 		}
+
 		total_scanned += sc.nr_scanned;
+
 		if (nr_reclaimed >= sc.swap_cluster_max) {
 			ret = 1;
 			goto out;
@@ -1223,6 +1227,8 @@ out:
 
 		zone->prev_priority = priority;
 	}
+	nr_reclaimed += shrink_page_list(&laundry, &sc, NULL);
+	release_lru_pages(&laundry);
 	return ret;
 }
 

-- 
