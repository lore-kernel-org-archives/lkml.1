Return-Path: <linux-kernel-owner+w=401wt.eu-S1756765AbZGPAxr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756765AbZGPAxr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 20:53:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756115AbZGPAxq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 20:53:46 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:36874 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752849AbZGPAxq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 20:53:46 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/3] mm: shrink_inactive_lis() nr_scan accounting fix fix
Cc: kosaki.motohiro@jp.fujitsu.com, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>, Rik van Riel <riel@redhat.com>,
       Minchan Kim <minchan.kim@gmail.com>,
       Christoph Lameter <cl@linux-foundation.org>
In-Reply-To: <20090716094619.9D07.A69D9226@jp.fujitsu.com>
References: <20090716094619.9D07.A69D9226@jp.fujitsu.com>
Message-Id: <20090716095241.9D0D.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu, 16 Jul 2009 09:53:42 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: [PATCH] mm: shrink_inactive_lis() nr_scan accounting fix fix

If sc->isolate_pages() return 0, we don't need to call shrink_page_list().
In past days, shrink_inactive_list() handled it properly.

But commit fb8d14e1 (three years ago commit!) breaked it. current shrink_inactive_list()
always call shrink_page_list() although isolate_pages() return 0.

This patch restore proper return value check.


Requirements:
  o "nr_taken == 0" condition should stay before calling shrink_page_list().
  o "nr_taken == 0" condition should stay after nr_scan related statistics
     modification.


Cc: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 mm/vmscan.c |   30 ++++++++++++++++++------------
 1 file changed, 18 insertions(+), 12 deletions(-)

Index: b/mm/vmscan.c
===================================================================
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1071,6 +1071,20 @@ static unsigned long shrink_inactive_lis
 		nr_taken = sc->isolate_pages(sc->swap_cluster_max,
 			     &page_list, &nr_scan, sc->order, mode,
 				zone, sc->mem_cgroup, 0, file);
+
+		if (scanning_global_lru(sc)) {
+			zone->pages_scanned += nr_scan;
+			if (current_is_kswapd())
+				__count_zone_vm_events(PGSCAN_KSWAPD, zone,
+						       nr_scan);
+			else
+				__count_zone_vm_events(PGSCAN_DIRECT, zone,
+						       nr_scan);
+		}
+
+		if (nr_taken == 0)
+			goto done;
+
 		nr_active = clear_active_flags(&page_list, count);
 		__count_vm_events(PGDEACTIVATE, nr_active);
 
@@ -1083,8 +1097,6 @@ static unsigned long shrink_inactive_lis
 		__mod_zone_page_state(zone, NR_INACTIVE_ANON,
 						-count[LRU_INACTIVE_ANON]);
 
-		if (scanning_global_lru(sc))
-			zone->pages_scanned += nr_scan;
 
 		reclaim_stat->recent_scanned[0] += count[LRU_INACTIVE_ANON];
 		reclaim_stat->recent_scanned[0] += count[LRU_ACTIVE_ANON];
@@ -1118,18 +1130,12 @@ static unsigned long shrink_inactive_lis
 		}
 
 		nr_reclaimed += nr_freed;
+
 		local_irq_disable();
-		if (current_is_kswapd()) {
-			__count_zone_vm_events(PGSCAN_KSWAPD, zone, nr_scan);
+		if (current_is_kswapd())
 			__count_vm_events(KSWAPD_STEAL, nr_freed);
-		} else if (scanning_global_lru(sc))
-			__count_zone_vm_events(PGSCAN_DIRECT, zone, nr_scan);
-
 		__count_zone_vm_events(PGSTEAL, zone, nr_freed);
 
-		if (nr_taken == 0)
-			goto done;
-
 		spin_lock(&zone->lru_lock);
 		/*
 		 * Put back any unfreeable pages.
@@ -1159,9 +1165,9 @@ static unsigned long shrink_inactive_lis
 			}
 		}
   	} while (nr_scanned < max_scan);
-	spin_unlock(&zone->lru_lock);
+
 done:
-	local_irq_enable();
+	spin_unlock_irq(&zone->lru_lock);
 	pagevec_release(&pvec);
 	return nr_reclaimed;
 }


