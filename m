Return-Path: <linux-kernel-owner+w=401wt.eu-S1752946AbZDVN72@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752946AbZDVN72 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 09:59:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755555AbZDVNxp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 09:53:45 -0400
Received: from gir.skynet.ie ([193.1.99.77]:43853 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754927AbZDVNxl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 09:53:41 -0400
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
Subject: [PATCH 16/22] Do not setup zonelist cache when there is only one node
Date: Wed, 22 Apr 2009 14:53:21 +0100
Message-Id: <1240408407-21848-17-git-send-email-mel@csn.ul.ie>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1240408407-21848-1-git-send-email-mel@csn.ul.ie>
References: <1240408407-21848-1-git-send-email-mel@csn.ul.ie>
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
 mm/page_alloc.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 7f45de1..e59bb80 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1467,8 +1467,11 @@ this_zone_full:
 		if (NUMA_BUILD)
 			zlc_mark_zone_full(zonelist, z);
 try_next_zone:
-		if (NUMA_BUILD && !did_zlc_setup) {
-			/* we do zlc_setup after the first zone is tried */
+		if (NUMA_BUILD && !did_zlc_setup && num_online_nodes() > 1) {
+			/*
+			 * we do zlc_setup after the first zone is tried but only
+			 * if there are multiple nodes make it worthwhile
+			 */
 			allowednodes = zlc_setup(zonelist, alloc_flags);
 			zlc_active = 1;
 			did_zlc_setup = 1;
-- 
1.5.6.5

