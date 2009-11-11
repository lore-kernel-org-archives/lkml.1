Return-Path: <linux-kernel-owner+w=401wt.eu-S1756658AbZKKB6e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756658AbZKKB6e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 20:58:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756537AbZKKB6d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 20:58:33 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:50101 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756490AbZKKB6c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 20:58:32 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/5] vmscan: separate sc.swap_cluster_max and sc.nr_max_reclaim
Cc: kosaki.motohiro@jp.fujitsu.com, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Minchan Kim <minchan.kim@gmail.com>, Rik van Riel <riel@redhat.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
In-Reply-To: <20091111104744.FD3B.A69D9226@jp.fujitsu.com>
References: <20091111104744.FD3B.A69D9226@jp.fujitsu.com>
Message-Id: <20091111105714.FD3E.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed, 11 Nov 2009 10:58:34 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, sc.scap_cluster_max has double meanings.

 1) reclaim batch size as isolate_lru_pages()'s argument
 2) reclaim baling out thresolds

The two meanings pretty unrelated. Thus, Let's separate it.
this patch doesn't change any behavior.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Reviewed-by: Rik van Riel <riel@redhat.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
---
 mm/vmscan.c |   25 +++++++++++++++++++------
 1 files changed, 19 insertions(+), 6 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index f805958..7be2927 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -55,6 +55,9 @@ struct scan_control {
 	/* Number of pages freed so far during a call to shrink_zones() */
 	unsigned long nr_reclaimed;
 
+	/* How many pages shrink_list() should reclaim */
+	unsigned long nr_to_reclaim;
+
 	/* This context's GFP mask */
 	gfp_t gfp_mask;
 
@@ -1585,6 +1588,7 @@ static void shrink_zone(int priority, struct zone *zone,
 	enum lru_list l;
 	unsigned long nr_reclaimed = sc->nr_reclaimed;
 	unsigned long swap_cluster_max = sc->swap_cluster_max;
+	unsigned long nr_to_reclaim = sc->nr_to_reclaim;
 	struct zone_reclaim_stat *reclaim_stat = get_reclaim_stat(zone, sc);
 	int noswap = 0;
 
@@ -1634,8 +1638,7 @@ static void shrink_zone(int priority, struct zone *zone,
 		 * with multiple processes reclaiming pages, the total
 		 * freeing target can get unreasonably large.
 		 */
-		if (nr_reclaimed > swap_cluster_max &&
-			priority < DEF_PRIORITY && !current_is_kswapd())
+		if (nr_reclaimed > nr_to_reclaim && priority < DEF_PRIORITY)
 			break;
 	}
 
@@ -1733,6 +1736,7 @@ static unsigned long do_try_to_free_pages(struct zonelist *zonelist,
 	struct zoneref *z;
 	struct zone *zone;
 	enum zone_type high_zoneidx = gfp_zone(sc->gfp_mask);
+	unsigned long writeback_threshold;
 
 	delayacct_freepages_start();
 
@@ -1768,7 +1772,7 @@ static unsigned long do_try_to_free_pages(struct zonelist *zonelist,
 			}
 		}
 		total_scanned += sc->nr_scanned;
-		if (sc->nr_reclaimed >= sc->swap_cluster_max) {
+		if (sc->nr_reclaimed >= sc->nr_to_reclaim) {
 			ret = sc->nr_reclaimed;
 			goto out;
 		}
@@ -1780,8 +1784,8 @@ static unsigned long do_try_to_free_pages(struct zonelist *zonelist,
 		 * that's undesirable in laptop mode, where we *want* lumpy
 		 * writeout.  So in laptop mode, write out the whole world.
 		 */
-		if (total_scanned > sc->swap_cluster_max +
-					sc->swap_cluster_max / 2) {
+		writeback_threshold = sc->nr_to_reclaim + sc->nr_to_reclaim / 2;
+		if (total_scanned > writeback_threshold) {
 			wakeup_flusher_threads(laptop_mode ? 0 : total_scanned);
 			sc->may_writepage = 1;
 		}
@@ -1827,6 +1831,7 @@ unsigned long try_to_free_pages(struct zonelist *zonelist, int order,
 		.gfp_mask = gfp_mask,
 		.may_writepage = !laptop_mode,
 		.swap_cluster_max = SWAP_CLUSTER_MAX,
+		.nr_to_reclaim = SWAP_CLUSTER_MAX,
 		.may_unmap = 1,
 		.may_swap = 1,
 		.swappiness = vm_swappiness,
@@ -1885,6 +1890,7 @@ unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *mem_cont,
 		.may_unmap = 1,
 		.may_swap = !noswap,
 		.swap_cluster_max = SWAP_CLUSTER_MAX,
+		.nr_to_reclaim = SWAP_CLUSTER_MAX,
 		.swappiness = swappiness,
 		.order = 0,
 		.mem_cgroup = mem_cont,
@@ -1932,6 +1938,11 @@ static unsigned long balance_pgdat(pg_data_t *pgdat, int order)
 		.may_unmap = 1,
 		.may_swap = 1,
 		.swap_cluster_max = SWAP_CLUSTER_MAX,
+		/*
+		 * kswapd doesn't want to be bailed out while reclaim. because
+		 * we want to put equal scanning pressure on each zone.
+		 */
+		.nr_to_reclaim = ULONG_MAX,
 		.swappiness = vm_swappiness,
 		.order = order,
 		.mem_cgroup = NULL,
@@ -2549,7 +2560,9 @@ static int __zone_reclaim(struct zone *zone, gfp_t gfp_mask, unsigned int order)
 		.may_unmap = !!(zone_reclaim_mode & RECLAIM_SWAP),
 		.may_swap = 1,
 		.swap_cluster_max = max_t(unsigned long, nr_pages,
-					SWAP_CLUSTER_MAX),
+				       SWAP_CLUSTER_MAX),
+		.nr_to_reclaim = max_t(unsigned long, nr_pages,
+				       SWAP_CLUSTER_MAX),
 		.gfp_mask = gfp_mask,
 		.swappiness = vm_swappiness,
 		.order = order,
-- 
1.6.2.5



