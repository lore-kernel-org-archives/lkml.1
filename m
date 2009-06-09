Return-Path: <linux-kernel-owner+w=401wt.eu-S1757298AbZFIRCP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757298AbZFIRCP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 13:02:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754878AbZFIRBr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 13:01:47 -0400
Received: from gir.skynet.ie ([193.1.99.77]:59476 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753202AbZFIRBp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 13:01:45 -0400
From: Mel Gorman <mel@csn.ul.ie>
To: Mel Gorman <mel@csn.ul.ie>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>, yanmin.zhang@intel.com,
       Wu Fengguang <fengguang.wu@intel.com>, linuxram@us.ibm.com
Cc: linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/4] Properly account for the number of page cache pages zone_reclaim() can reclaim
Date: Tue,  9 Jun 2009 18:01:41 +0100
Message-Id: <1244566904-31470-2-git-send-email-mel@csn.ul.ie>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1244566904-31470-1-git-send-email-mel@csn.ul.ie>
References: <1244566904-31470-1-git-send-email-mel@csn.ul.ie>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On NUMA machines, the administrator can configure zone_reclaim_mode that
is a more targetted form of direct reclaim. On machines with large NUMA
distances for example, a zone_reclaim_mode defaults to 1 meaning that clean
unmapped pages will be reclaimed if the zone watermarks are not being met.

There is a heuristic that determines if the scan is worthwhile but the
problem is that the heuristic is not being properly applied and is basically
assuming zone_reclaim_mode is 1 if it is enabled.

Historically, once enabled it was depending on NR_FILE_PAGES which may
include swapcache pages that the reclaim_mode cannot deal with.  Patch
vmscan-change-the-number-of-the-unmapped-files-in-zone-reclaim.patch by
Kosaki Motohiro noted that zone_page_state(zone, NR_FILE_PAGES) included
pages that were not file-backed such as swapcache and made a calculation
based on the inactive, active and mapped files. This is far superior
when zone_reclaim==1 but if RECLAIM_SWAP is set, then NR_FILE_PAGES is a
reasonable starting figure.

This patch alters how zone_reclaim() works out how many pages it might be
able to reclaim given the current reclaim_mode. If RECLAIM_SWAP is set
in the reclaim_mode it will either consider NR_FILE_PAGES as potential
candidates or else use NR_{IN}ACTIVE}_PAGES-NR_FILE_MAPPED to discount
swapcache and other non-file-backed pages.  If RECLAIM_WRITE is not set,
then NR_FILE_DIRTY number of pages are not candidates. If RECLAIM_SWAP is
not set, then NR_FILE_MAPPED are not.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Acked-by: Christoph Lameter <cl@linux-foundation.org>
---
 mm/vmscan.c |   52 ++++++++++++++++++++++++++++++++++++++--------------
 1 files changed, 38 insertions(+), 14 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 2ddcfc8..2bfc76e 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2333,6 +2333,41 @@ int sysctl_min_unmapped_ratio = 1;
  */
 int sysctl_min_slab_ratio = 5;
 
+static inline unsigned long zone_unmapped_file_pages(struct zone *zone)
+{
+	return zone_page_state(zone, NR_INACTIVE_FILE) +
+		zone_page_state(zone, NR_ACTIVE_FILE) -
+		zone_page_state(zone, NR_FILE_MAPPED);
+}
+
+/* Work out how many page cache pages we can reclaim in this reclaim_mode */
+static inline long zone_pagecache_reclaimable(struct zone *zone)
+{
+	long nr_pagecache_reclaimable;
+	long delta = 0;
+
+	/*
+	 * If RECLAIM_SWAP is set, then all file pages are considered
+	 * potentially reclaimable. Otherwise, we have to worry about
+	 * pages like swapcache and zone_unmapped_file_pages() provides
+	 * a better estimate
+	 */
+	if (zone_reclaim_mode & RECLAIM_SWAP)
+		nr_pagecache_reclaimable = zone_page_state(zone, NR_FILE_PAGES);
+	else
+		nr_pagecache_reclaimable = zone_unmapped_file_pages(zone);
+
+	/* If we can't clean pages, remove dirty pages from consideration */
+	if (!(zone_reclaim_mode & RECLAIM_WRITE))
+		delta += zone_page_state(zone, NR_FILE_DIRTY);
+
+	/* Beware of double accounting */
+	if (delta < nr_pagecache_reclaimable)
+		nr_pagecache_reclaimable -= delta;
+
+	return nr_pagecache_reclaimable;
+}
+
 /*
  * Try to free up some pages from this zone through reclaim.
  */
@@ -2355,7 +2390,6 @@ static int __zone_reclaim(struct zone *zone, gfp_t gfp_mask, unsigned int order)
 		.isolate_pages = isolate_pages_global,
 	};
 	unsigned long slab_reclaimable;
-	long nr_unmapped_file_pages;
 
 	disable_swap_token();
 	cond_resched();
@@ -2368,11 +2402,7 @@ static int __zone_reclaim(struct zone *zone, gfp_t gfp_mask, unsigned int order)
 	reclaim_state.reclaimed_slab = 0;
 	p->reclaim_state = &reclaim_state;
 
-	nr_unmapped_file_pages = zone_page_state(zone, NR_INACTIVE_FILE) +
-				 zone_page_state(zone, NR_ACTIVE_FILE) -
-				 zone_page_state(zone, NR_FILE_MAPPED);
-
-	if (nr_unmapped_file_pages > zone->min_unmapped_pages) {
+	if (zone_pagecache_reclaimable(zone) > zone->min_unmapped_pages) {
 		/*
 		 * Free memory by calling shrink zone with increasing
 		 * priorities until we have enough memory freed.
@@ -2419,8 +2449,6 @@ int zone_reclaim(struct zone *zone, gfp_t gfp_mask, unsigned int order)
 {
 	int node_id;
 	int ret;
-	long nr_unmapped_file_pages;
-	long nr_slab_reclaimable;
 
 	/*
 	 * Zone reclaim reclaims unmapped file backed pages and
@@ -2432,12 +2460,8 @@ int zone_reclaim(struct zone *zone, gfp_t gfp_mask, unsigned int order)
 	 * if less than a specified percentage of the zone is used by
 	 * unmapped file backed pages.
 	 */
-	nr_unmapped_file_pages = zone_page_state(zone, NR_INACTIVE_FILE) +
-				 zone_page_state(zone, NR_ACTIVE_FILE) -
-				 zone_page_state(zone, NR_FILE_MAPPED);
-	nr_slab_reclaimable = zone_page_state(zone, NR_SLAB_RECLAIMABLE);
-	if (nr_unmapped_file_pages <= zone->min_unmapped_pages &&
-	    nr_slab_reclaimable <= zone->min_slab_pages)
+	if (zone_pagecache_reclaimable(zone) <= zone->min_unmapped_pages &&
+	    zone_page_state(zone, NR_SLAB_RECLAIMABLE) <= zone->min_slab_pages)
 		return 0;
 
 	if (zone_is_all_unreclaimable(zone))
-- 
1.5.6.5

