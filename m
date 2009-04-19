Return-Path: <linux-kernel-owner+w=401wt.eu-S1760976AbZDSMnT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760976AbZDSMnT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Apr 2009 08:43:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758584AbZDSMnF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Apr 2009 08:43:05 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:39554 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758069AbZDSMnD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Apr 2009 08:43:03 -0400
Date: Sun, 19 Apr 2009 21:42:14 +0900 (JST)
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Subject: [PATCH v3] vmscan,memcg: reintroduce sc->may_swap
Cc: kosaki.motohiro@jp.fujitsu.com,
       Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090418184337.GA5556@cmpxchg.org>
References: <20090418152100.125A.A69D9226@jp.fujitsu.com> <20090418184337.GA5556@cmpxchg.org>
Message-Id: <20090419214122.FFD1.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


next version here :)

==================================
Subject: [PATCH v3] vmscan,memcg: reintroduce sc->may_swap

vmscan-rename-scmay_swap-to-may_unmap.patch removed may_swap flag,
but memcg had used it as a flag for "we need to use swap?", as the
name indicate.

And in current implementation, memcg cannot reclaim mapped file caches
when mem+swap hits the limit.

re-introduce may_swap flag and handle it at get_scan_ratio().
This patch doesn't influence any scan_control users other than memcg.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
--
 mm/vmscan.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

Index: b/mm/vmscan.c
===================================================================
--- a/mm/vmscan.c	2009-04-17 21:39:58.000000000 +0900
+++ b/mm/vmscan.c	2009-04-19 20:33:00.000000000 +0900
@@ -64,6 +64,9 @@ struct scan_control {
 	/* Can mapped pages be reclaimed? */
 	int may_unmap;
 
+	/* Can pages be swapped as part of reclaim? */
+	int may_swap;
+
 	/* This context's SWAP_CLUSTER_MAX. If freeing memory for
 	 * suspend, we effectively ignore SWAP_CLUSTER_MAX.
 	 * In this context, it doesn't matter that we scan the
@@ -1387,7 +1390,7 @@ static void get_scan_ratio(struct zone *
 	struct zone_reclaim_stat *reclaim_stat = get_reclaim_stat(zone, sc);
 
 	/* If we have no swap space, do not bother scanning anon pages. */
-	if (nr_swap_pages <= 0) {
+	if (!sc->may_swap || (nr_swap_pages <= 0)) {
 		percent[0] = 0;
 		percent[1] = 100;
 		return;
@@ -1704,6 +1707,7 @@ unsigned long try_to_free_pages(struct z
 		.may_writepage = !laptop_mode,
 		.swap_cluster_max = SWAP_CLUSTER_MAX,
 		.may_unmap = 1,
+		.may_swap = 1,
 		.swappiness = vm_swappiness,
 		.order = order,
 		.mem_cgroup = NULL,
@@ -1724,6 +1728,7 @@ unsigned long try_to_free_mem_cgroup_pag
 	struct scan_control sc = {
 		.may_writepage = !laptop_mode,
 		.may_unmap = 1,
+		.may_swap = !noswap,
 		.swap_cluster_max = SWAP_CLUSTER_MAX,
 		.swappiness = swappiness,
 		.order = 0,
@@ -1733,9 +1738,6 @@ unsigned long try_to_free_mem_cgroup_pag
 	};
 	struct zonelist *zonelist;
 
-	if (noswap)
-		sc.may_unmap = 0;
-
 	sc.gfp_mask = (gfp_mask & GFP_RECLAIM_MASK) |
 			(GFP_HIGHUSER_MOVABLE & ~GFP_RECLAIM_MASK);
 	zonelist = NODE_DATA(numa_node_id())->node_zonelists;
@@ -1774,6 +1776,7 @@ static unsigned long balance_pgdat(pg_da
 	struct scan_control sc = {
 		.gfp_mask = GFP_KERNEL,
 		.may_unmap = 1,
+		.may_swap = 1,
 		.swap_cluster_max = SWAP_CLUSTER_MAX,
 		.swappiness = vm_swappiness,
 		.order = order,
@@ -2304,6 +2307,7 @@ static int __zone_reclaim(struct zone *z
 	struct scan_control sc = {
 		.may_writepage = !!(zone_reclaim_mode & RECLAIM_WRITE),
 		.may_unmap = !!(zone_reclaim_mode & RECLAIM_SWAP),
+		.may_swap = 1,
 		.swap_cluster_max = max_t(unsigned long, nr_pages,
 					SWAP_CLUSTER_MAX),
 		.gfp_mask = gfp_mask,


