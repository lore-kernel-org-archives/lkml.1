Return-Path: <linux-kernel-owner+w=401wt.eu-S932417AbZFKK2l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932417AbZFKK2l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 06:28:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761412AbZFKK2b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 06:28:31 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:58132 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760592AbZFKK2a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 06:28:30 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH for mmotm 5/5] fix vmscan-change-the-number-of-the-unmapped-files-in-zone-reclaim.patch 
Cc: kosaki.motohiro@jp.fujitsu.com, Mel Gorman <mel@csn.ul.ie>,
       Wu Fengguang <fengguang.wu@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20090611192114.6D4A.A69D9226@jp.fujitsu.com>
References: <20090611192114.6D4A.A69D9226@jp.fujitsu.com>
Message-Id: <20090611192757.6D59.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu, 11 Jun 2009 19:28:30 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: [PATCH] fix vmscan-change-the-number-of-the-unmapped-files-in-zone-reclaim.patch 


+	nr_unmapped_file_pages = zone_page_state(zone, NR_INACTIVE_FILE) +
+				 zone_page_state(zone, NR_ACTIVE_FILE) -
+				 zone_page_state(zone, NR_FILE_MAPPED);

is wrong. it can be underflow because tmpfs pages are not counted NR_*_FILE,
but they are counted NR_FILE_MAPPED.

fixing here.


Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Wu Fengguang <fengguang.wu@intel.com>
---
 mm/vmscan.c |   32 ++++++++++++++++++++------------
 1 file changed, 20 insertions(+), 12 deletions(-)

Index: b/mm/vmscan.c
===================================================================
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2333,6 +2333,23 @@ int sysctl_min_unmapped_ratio = 1;
  */
 int sysctl_min_slab_ratio = 5;
 
+static unsigned long zone_unmapped_file_pages(struct zone *zone)
+{
+	long nr_file_pages;
+	long nr_file_mapped;
+	long nr_unmapped_file_pages;
+
+	nr_file_pages = zone_page_state(zone, NR_INACTIVE_FILE) +
+			zone_page_state(zone, NR_ACTIVE_FILE);
+	nr_file_mapped = zone_page_state(zone, NR_FILE_MAPPED) -
+			 zone_page_state(zone,
+					NR_SWAP_BACKED_FILE_MAPPED);
+	nr_unmapped_file_pages = nr_file_pages - nr_file_mapped;
+
+	return nr_unmapped_file_pages > 0 ? nr_unmapped_file_pages : 0;
+}
+
+
 /*
  * Try to free up some pages from this zone through reclaim.
  */
@@ -2355,7 +2372,6 @@ static int __zone_reclaim(struct zone *z
 		.isolate_pages = isolate_pages_global,
 	};
 	unsigned long slab_reclaimable;
-	long nr_unmapped_file_pages;
 
 	disable_swap_token();
 	cond_resched();
@@ -2368,11 +2384,7 @@ static int __zone_reclaim(struct zone *z
 	reclaim_state.reclaimed_slab = 0;
 	p->reclaim_state = &reclaim_state;
 
-	nr_unmapped_file_pages = zone_page_state(zone, NR_INACTIVE_FILE) +
-				 zone_page_state(zone, NR_ACTIVE_FILE) -
-				 zone_page_state(zone, NR_FILE_MAPPED);
-
-	if (nr_unmapped_file_pages > zone->min_unmapped_pages) {
+	if (zone_unmapped_file_pages(zone) > zone->min_unmapped_pages) {
 		/*
 		 * Free memory by calling shrink zone with increasing
 		 * priorities until we have enough memory freed.
@@ -2419,8 +2431,7 @@ int zone_reclaim(struct zone *zone, gfp_
 {
 	int node_id;
 	int ret;
-	long nr_unmapped_file_pages;
-	long nr_slab_reclaimable;
+	unsigned long nr_slab_reclaimable;
 
 	/*
 	 * Zone reclaim reclaims unmapped file backed pages and
@@ -2432,11 +2443,8 @@ int zone_reclaim(struct zone *zone, gfp_
 	 * if less than a specified percentage of the zone is used by
 	 * unmapped file backed pages.
 	 */
-	nr_unmapped_file_pages = zone_page_state(zone, NR_INACTIVE_FILE) +
-				 zone_page_state(zone, NR_ACTIVE_FILE) -
-				 zone_page_state(zone, NR_FILE_MAPPED);
 	nr_slab_reclaimable = zone_page_state(zone, NR_SLAB_RECLAIMABLE);
-	if (nr_unmapped_file_pages <= zone->min_unmapped_pages &&
+	if (zone_unmapped_file_pages(zone) <= zone->min_unmapped_pages &&
 	    nr_slab_reclaimable <= zone->min_slab_pages)
 		return 0;
 


