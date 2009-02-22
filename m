Return-Path: <linux-kernel-owner+w=401wt.eu-S1756699AbZBVXTY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756699AbZBVXTY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Feb 2009 18:19:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754249AbZBVXQa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Feb 2009 18:16:30 -0500
Received: from gir.skynet.ie ([193.1.99.77]:39511 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756069AbZBVXQY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Feb 2009 18:16:24 -0500
From: Mel Gorman <mel@csn.ul.ie>
To: Mel Gorman <mel@csn.ul.ie>,
       Linux Memory Management List <linux-mm@kvack.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, Rik van Riel <riel@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lin Ming <ming.m.lin@intel.com>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>
Subject: [PATCH 07/20] Simplify the check on whether cpusets are a factor or not
Date: Sun, 22 Feb 2009 23:17:16 +0000
Message-Id: <1235344649-18265-8-git-send-email-mel@csn.ul.ie>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1235344649-18265-1-git-send-email-mel@csn.ul.ie>
References: <1235344649-18265-1-git-send-email-mel@csn.ul.ie>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The check whether cpuset contraints need to be checked or not is complex
and often repeated.  This patch makes the check in advance to the comparison
is simplier to compute.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
---
 mm/page_alloc.c |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 503d692..dc50c47 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1400,6 +1400,7 @@ get_page_from_freelist(gfp_t gfp_mask, nodemask_t *nodemask, unsigned int order,
 	nodemask_t *allowednodes = NULL;/* zonelist_cache approximation */
 	int zlc_active = 0;		/* set if using zonelist_cache */
 	int did_zlc_setup = 0;		/* just call zlc_setup() one time */
+	int alloc_cpuset = 0;
 
 	(void)first_zones_zonelist(zonelist, high_zoneidx, nodemask,
 							&preferred_zone);
@@ -1410,6 +1411,12 @@ get_page_from_freelist(gfp_t gfp_mask, nodemask_t *nodemask, unsigned int order,
 
 	VM_BUG_ON(order >= MAX_ORDER);
 
+#ifdef CONFIG_CPUSETS
+	/* Determine in advance if the cpuset checks will be needed */
+	if ((alloc_flags & ALLOC_CPUSET) && unlikely(number_of_cpusets > 1))
+		alloc_cpuset = 1;
+#endif
+
 zonelist_scan:
 	/*
 	 * Scan zonelist, looking for a zone with enough free.
@@ -1420,8 +1427,8 @@ zonelist_scan:
 		if (NUMA_BUILD && zlc_active &&
 			!zlc_zone_worth_trying(zonelist, z, allowednodes))
 				continue;
-		if ((alloc_flags & ALLOC_CPUSET) &&
-			!cpuset_zone_allowed_softwall(zone, gfp_mask))
+		if (alloc_cpuset)
+			if (!cpuset_zone_allowed_softwall(zone, gfp_mask))
 				goto try_next_zone;
 
 		if (!(alloc_flags & ALLOC_NO_WATERMARKS)) {
-- 
1.5.6.5

