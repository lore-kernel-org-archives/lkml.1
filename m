Return-Path: <linux-kernel-owner+w=401wt.eu-S1756559AbXHTVyX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756559AbXHTVyX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 17:54:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751914AbXHTVxV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 17:53:21 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:51617 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751534AbXHTVxR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 17:53:17 -0400
Message-Id: <20070820215317.202810753@sgi.com>
References: <20070820215040.937296148@sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 20 Aug 2007 14:50:46 -0700
From: Christoph Lameter <clameter@sgi.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org
Cc: dkegel@google.com
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: David Miller <davem@davemloft.net>
Cc: Nick Piggin <npiggin@suse.de>
Subject: [RFC 6/7] kswapd: Do laundry after reclaim
Content-Disposition: inline; filename=kswapd
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Collect dirty pages and perform writeout when everything else is done.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 mm/vmscan.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

Index: linux-2.6/mm/vmscan.c
===================================================================
--- linux-2.6.orig/mm/vmscan.c	2007-08-19 23:53:43.000000000 -0700
+++ linux-2.6/mm/vmscan.c	2007-08-19 23:53:47.000000000 -0700
@@ -1273,6 +1273,7 @@ static unsigned long balance_pgdat(pg_da
 	 * this zone was successfully refilled to free_pages == pages_high.
 	 */
 	int temp_priority[MAX_NR_ZONES];
+	LIST_HEAD(laundry);
 
 loop_again:
 	total_scanned = 0;
@@ -1347,7 +1348,7 @@ loop_again:
 			temp_priority[i] = priority;
 			sc.nr_scanned = 0;
 			note_zone_scanning_priority(zone, priority);
-			nr_reclaimed += shrink_zone(priority, zone, &sc, NULL);
+			nr_reclaimed += shrink_zone(priority, zone, &sc, &laundry);
 			reclaim_state->reclaimed_slab = 0;
 			nr_slab = shrink_slab(sc.nr_scanned, GFP_KERNEL,
 						lru_pages);
@@ -1374,6 +1375,7 @@ loop_again:
 		 * OK, kswapd is getting into trouble.  Take a nap, then take
 		 * another pass across the zones.
 		 */
+		throttle_vm_writeout(GFP_KERNEL);
 		if (total_scanned && priority < DEF_PRIORITY - 2)
 			congestion_wait(WRITE, HZ/10);
 
@@ -1404,7 +1406,8 @@ out:
 
 		goto loop_again;
 	}
-
+	nr_reclaimed += shrink_page_list(&laundry, &sc, NULL);
+	release_lru_pages(&laundry);
 	return nr_reclaimed;
 }
 

-- 
