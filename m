Return-Path: <linux-kernel-owner+w=401wt.eu-S1757779AbZBFBjo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757779AbZBFBjo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 20:39:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753577AbZBFBjM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 20:39:12 -0500
Received: from cmpxchg.org ([85.214.51.133]:33747 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757256AbZBFBjL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 20:39:11 -0500
Message-Id: <E1LVFiy-00032t-Nh@cmpxchg.org>
From: hannes@cmpxchg.org
Date: Fri, 06 Feb 2009 02:41:44 +0100
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From hannes@cmpxchg.org Fri Feb  6 02:28:54 2009
Message-Id: <20090206012854.688444313@cmpxchg.org>
User-Agent: quilt/0.47-1
Date: Fri, 06 Feb 2009 02:26:06 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
 Rik van Riel <riel@redhat.com>,
 linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
Subject: [PATCH 1/3] swsusp: clean up shrink_all_zones()
References: <20090206012605.378214179@cmpxchg.org>
Content-Disposition: inline; filename=swsusp-clean-up-shrink_all_zones.patch

Move local variables to innermost possible scopes and use local
variables to cache calculations/reads done more than once.

No change in functionality (intended).

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/vmscan.c |   23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2057,31 +2057,31 @@ static unsigned long shrink_all_zones(un
 				      int pass, struct scan_control *sc)
 {
 	struct zone *zone;
-	unsigned long nr_to_scan, ret = 0;
-	enum lru_list l;
+	unsigned long ret = 0;
 
 	for_each_zone(zone) {
+		enum lru_list l;
 
 		if (!populated_zone(zone))
 			continue;
-
 		if (zone_is_all_unreclaimable(zone) && prio != DEF_PRIORITY)
 			continue;
 
 		for_each_evictable_lru(l) {
+			enum zone_stat_item ls = NR_LRU_BASE + l;
+			unsigned long lru_pages = zone_page_state(zone, ls);
+
 			/* For pass = 0, we don't shrink the active list */
-			if (pass == 0 &&
-				(l == LRU_ACTIVE || l == LRU_ACTIVE_FILE))
+			if (pass == 0 && (l == LRU_ACTIVE_ANON ||
+						l == LRU_ACTIVE_FILE))
 				continue;
 
-			zone->lru[l].nr_scan +=
-				(zone_page_state(zone, NR_LRU_BASE + l)
-								>> prio) + 1;
+			zone->lru[l].nr_scan += (lru_pages >> prio) + 1;
 			if (zone->lru[l].nr_scan >= nr_pages || pass > 3) {
+				unsigned long nr_to_scan;
+
 				zone->lru[l].nr_scan = 0;
-				nr_to_scan = min(nr_pages,
-					zone_page_state(zone,
-							NR_LRU_BASE + l));
+				nr_to_scan = min(nr_pages, lru_pages);
 				ret += shrink_list(l, nr_to_scan, zone,
 								sc, prio);
 				if (ret >= nr_pages)
@@ -2089,7 +2089,6 @@ static unsigned long shrink_all_zones(un
 			}
 		}
 	}
-
 	return ret;
 }
 


