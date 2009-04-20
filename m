Return-Path: <linux-kernel-owner+w=401wt.eu-S1758824AbZDTW04@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758824AbZDTW04 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 18:26:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757861AbZDTWUe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 18:20:34 -0400
Received: from gir.skynet.ie ([193.1.99.77]:37290 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757890AbZDTWU1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 18:20:27 -0400
From: Mel Gorman <mel@csn.ul.ie>
To: Mel Gorman <mel@csn.ul.ie>,
       Linux Memory Management List <linux-mm@kvack.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lin Ming <ming.m.lin@intel.com>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 19/25] Do not setup zonelist cache when there is only one node
Date: Mon, 20 Apr 2009 23:20:05 +0100
Message-Id: <1240266011-11140-20-git-send-email-mel@csn.ul.ie>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1240266011-11140-1-git-send-email-mel@csn.ul.ie>
References: <1240266011-11140-1-git-send-email-mel@csn.ul.ie>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a zonelist cache which is used to track zones that are not in
the allowed cpuset or found to be recently full. This is to reduce cache
footprint on large machines. On smaller machines, it just incurs cost
for no gain. This patch only uses the zonelist cache when there are NUMA
nodes.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Reviewed-by: Christoph Lameter <cl@linux-foundation.org>
---
 mm/page_alloc.c |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index bf4b8d9..ec01d8f 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1440,6 +1440,8 @@ get_page_from_freelist(gfp_t gfp_mask, nodemask_t *nodemask, unsigned int order,
 	/* Determine in advance if the zonelist needs filtering */
 	if ((alloc_flags & ALLOC_CPUSET) && unlikely(number_of_cpusets > 1))
 		zonelist_filter = 1;
+	if (num_online_nodes() > 1)
+		zonelist_filter = 1;
 
 zonelist_scan:
 	/*
@@ -1484,8 +1486,12 @@ this_zone_full:
 			zlc_mark_zone_full(zonelist, z);
 try_next_zone:
 		if (NUMA_BUILD && zonelist_filter) {
-			if (!did_zlc_setup) {
-				/* do zlc_setup after the first zone is tried */
+			if (!did_zlc_setup && num_online_nodes() > 1) {
+				/*
+				 * do zlc_setup after the first zone is tried
+				 * but only if there are multiple nodes to make
+				 * it worthwhile
+				 */
 				allowednodes = zlc_setup(zonelist, alloc_flags);
 				zlc_active = 1;
 			}
-- 
1.5.6.5

