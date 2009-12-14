Return-Path: <linux-kernel-owner+w=401wt.eu-S1751140AbZLNMbn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751140AbZLNMbn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 07:31:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750997AbZLNMbk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 07:31:40 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:44874 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750852AbZLNMbj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 07:31:39 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Rik van Riel <riel@redhat.com>
Subject: [PATCH 6/8] Stop reclaim quickly when the task reclaimed enough lots pages
Cc: kosaki.motohiro@jp.fujitsu.com, lwoodman@redhat.com,
       akpm@linux-foundation.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, minchan.kim@gmail.com
In-Reply-To: <20091214210823.BBAE.A69D9226@jp.fujitsu.com>
References: <20091211164651.036f5340@annuminas.surriel.com> <20091214210823.BBAE.A69D9226@jp.fujitsu.com>
Message-Id: <20091214213103.BBC0.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Mon, 14 Dec 2009 21:31:36 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>From latency view, There isn't any reason shrink_zones() continue to
reclaim another zone's page if the task reclaimed enough lots pages.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 mm/vmscan.c |   16 ++++++++++++----
 1 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 0880668..bf229d3 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1654,7 +1654,7 @@ static void shrink_zone_end(struct zone *zone, struct scan_control *sc)
 /*
  * This is a basic per-zone page freer.  Used by both kswapd and direct reclaim.
  */
-static void shrink_zone(int priority, struct zone *zone,
+static int shrink_zone(int priority, struct zone *zone,
 			struct scan_control *sc)
 {
 	unsigned long nr[NR_LRU_LISTS];
@@ -1669,7 +1669,7 @@ static void shrink_zone(int priority, struct zone *zone,
 
 	ret = shrink_zone_begin(zone, sc);
 	if (ret)
-		return;
+		return ret;
 
 	/* If we have no swap space, do not bother scanning anon pages. */
 	if (!sc->may_swap || (nr_swap_pages <= 0)) {
@@ -1692,6 +1692,7 @@ static void shrink_zone(int priority, struct zone *zone,
 					  &reclaim_stat->nr_saved_scan[l]);
 	}
 
+	ret = 0;
 	while (nr[LRU_INACTIVE_ANON] || nr[LRU_ACTIVE_FILE] ||
 					nr[LRU_INACTIVE_FILE]) {
 		for_each_evictable_lru(l) {
@@ -1712,8 +1713,10 @@ static void shrink_zone(int priority, struct zone *zone,
 		 * with multiple processes reclaiming pages, the total
 		 * freeing target can get unreasonably large.
 		 */
-		if (nr_reclaimed >= nr_to_reclaim && priority < DEF_PRIORITY)
+		if (nr_reclaimed >= nr_to_reclaim && priority < DEF_PRIORITY) {
+			ret = -ERESTARTSYS;
 			break;
+		}
 	}
 
 	sc->nr_reclaimed = nr_reclaimed;
@@ -1727,6 +1730,8 @@ static void shrink_zone(int priority, struct zone *zone,
 
 	throttle_vm_writeout(sc->gfp_mask);
 	shrink_zone_end(zone, sc);
+
+	return ret;
 }
 
 /*
@@ -1751,6 +1756,7 @@ static void shrink_zones(int priority, struct zonelist *zonelist,
 	enum zone_type high_zoneidx = gfp_zone(sc->gfp_mask);
 	struct zoneref *z;
 	struct zone *zone;
+	int ret;
 
 	sc->all_unreclaimable = 1;
 	for_each_zone_zonelist_nodemask(zone, z, zonelist, high_zoneidx,
@@ -1780,7 +1786,9 @@ static void shrink_zones(int priority, struct zonelist *zonelist,
 							priority);
 		}
 
-		shrink_zone(priority, zone, sc);
+		ret = shrink_zone(priority, zone, sc);
+		if (ret)
+			return;
 	}
 }
 
-- 
1.6.5.2



