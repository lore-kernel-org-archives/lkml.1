Return-Path: <linux-kernel-owner+w=401wt.eu-S1758292AbZBVXWY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758292AbZBVXWY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Feb 2009 18:22:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756489AbZBVXQg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Feb 2009 18:16:36 -0500
Received: from gir.skynet.ie ([193.1.99.77]:39511 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756196AbZBVXQa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Feb 2009 18:16:30 -0500
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
Subject: [PATCH 16/20] Do not setup zonelist cache when there is only one node
Date: Sun, 22 Feb 2009 23:17:25 +0000
Message-Id: <1235344649-18265-17-git-send-email-mel@csn.ul.ie>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1235344649-18265-1-git-send-email-mel@csn.ul.ie>
References: <1235344649-18265-1-git-send-email-mel@csn.ul.ie>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a zonelist cache which is used to track zones that are not in
the allowed cpuset or found to be recently full. This is to reduce cache
footprint on large machines. On smaller machines, it just incurs cost
for no gain. This patch only uses the zonelist cache when there are NUMA
nodes.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
---
 mm/page_alloc.c |   12 +++++++++---
 1 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 9adafba..9e16aec 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1481,9 +1481,15 @@ this_zone_full:
 			zlc_mark_zone_full(zonelist, z);
 try_next_zone:
 		if (NUMA_BUILD && !did_zlc_setup) {
-			/* we do zlc_setup after the first zone is tried */
-			allowednodes = zlc_setup(zonelist, alloc_flags);
-			zlc_active = 1;
+			/*
+			 * we do zlc_setup after the first zone is tried
+			 * but only if there are multiple nodes to make
+			 * it worthwhile
+			 */
+			if (num_online_nodes() > 1) {
+				allowednodes = zlc_setup(zonelist, alloc_flags);
+				zlc_active = 1;
+			}
 			did_zlc_setup = 1;
 		}
 	}
-- 
1.5.6.5

