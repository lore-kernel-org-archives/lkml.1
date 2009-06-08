Return-Path: <linux-kernel-owner+w=401wt.eu-S1755062AbZFHNBx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755062AbZFHNBx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 09:01:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752914AbZFHNBb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 09:01:31 -0400
Received: from gir.skynet.ie ([193.1.99.77]:53639 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752754AbZFHNBb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 09:01:31 -0400
From: Mel Gorman <mel@csn.ul.ie>
To: Mel Gorman <mel@csn.ul.ie>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>, yanmin.zhang@intel.com,
       Wu Fengguang <fengguang.wu@intel.com>, linuxram@us.ibm.com
Cc: linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/3] Properly account for the number of page cache pages zone_reclaim() can reclaim
Date: Mon,  8 Jun 2009 14:01:29 +0100
Message-Id: <1244466090-10711-3-git-send-email-mel@csn.ul.ie>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1244466090-10711-1-git-send-email-mel@csn.ul.ie>
References: <1244466090-10711-1-git-send-email-mel@csn.ul.ie>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On NUMA machines, the administrator can configure zone_relcaim_mode that
is a more targetted form of direct reclaim. On machines with large NUMA
distances for example, a zone_reclaim_mode defaults to 1 meaning that clean
unmapped pages will be reclaimed if the zone watermarks are not being met.

There is a heuristic that determines if the scan is worthwhile but the
problem is that the heuristic is not being properly applied and is basically
assuming zone_reclaim_mode is 1 if it is enabled.

This patch makes zone_reclaim() makes a better attempt at working out how
many pages it might be able to reclaim given the current reclaim_mode. If it
cannot clean pages, then NR_FILE_DIRTY number of pages are not candidates. If
it cannot swap, then NR_FILE_MAPPED are not. This indirectly addresses tmpfs
as those pages tend to be dirty as they are not cleaned by pdflush or sync.

The ideal would be that the number of tmpfs pages would also be known
and account for like NR_FILE_MAPPED as swap is required to discard them.
A means of working this out quickly was not obvious but a comment is added
noting the problem.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
---
 mm/vmscan.c |   18 ++++++++++++++++--
 1 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index ba211c1..ffe2f32 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2380,6 +2380,21 @@ int zone_reclaim(struct zone *zone, gfp_t gfp_mask, unsigned int order)
 {
 	int node_id;
 	int ret;
+	int pagecache_reclaimable;
+
+	/*
+	 * Work out how many page cache pages we can reclaim in this mode.
+	 *
+	 * NOTE: Ideally, tmpfs pages would be accounted as if they were
+	 *       NR_FILE_MAPPED as swap is required to discard those
+	 *       pages even when they are clean. However, there is no
+	 *       way of quickly identifying the number of tmpfs pages
+	 */
+	pagecache_reclaimable = zone_page_state(zone, NR_FILE_PAGES);
+	if (!(zone_reclaim_mode & RECLAIM_WRITE))
+		pagecache_reclaimable -= zone_page_state(zone, NR_FILE_DIRTY);
+	if (!(zone_reclaim_mode & RECLAIM_SWAP))
+		pagecache_reclaimable -= zone_page_state(zone, NR_FILE_MAPPED);
 
 	/*
 	 * Zone reclaim reclaims unmapped file backed pages and
@@ -2391,8 +2406,7 @@ int zone_reclaim(struct zone *zone, gfp_t gfp_mask, unsigned int order)
 	 * if less than a specified percentage of the zone is used by
 	 * unmapped file backed pages.
 	 */
-	if (zone_page_state(zone, NR_FILE_PAGES) -
-	    zone_page_state(zone, NR_FILE_MAPPED) <= zone->min_unmapped_pages
+	if (pagecache_reclaimable <= zone->min_unmapped_pages
 	    && zone_page_state(zone, NR_SLAB_RECLAIMABLE)
 			<= zone->min_slab_pages)
 		return 0;
-- 
1.5.6.5

