Return-Path: <linux-kernel-owner+w=401wt.eu-S1758997AbYCKVOz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758997AbYCKVOz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 17:14:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757017AbYCKVOn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 17:14:43 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:46017 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757010AbYCKVOm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 17:14:42 -0400
Date: Tue, 11 Mar 2008 21:12:19 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Andrew Morton <akpm@linux-foundation.org>
cc: Mel Gorman <mel@csn.ul.ie>, Balbir Singh <balbir@linux.vnet.ibm.com>,
       Pavel Emelyanov <xemul@openvz.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH rc5-mm1 1/3] mm-have-zonelist: fix memcg ooms
Message-ID: <Pine.LNX.4.64.0803112108470.17067@blonde.site>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Memcgroups up against their limit were OOMing unjustifiably on x86_32
with highmem: pages ripe for freeing were not being found.

It's because the zonelist changes in vmscan.c now derive zone from gfp_mask,
and the gfp mask being passed into try_to_free_mem_cgroup_pages is atuned
to allocating a struct page_cgroup (__GFP_HIGHMEM masked off), whereas here
we need to be scanning highmem zones.

Frankenstein a gfp_mask from GFP_HIGHUSER_MOVABLE and the mask passed in.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
---
Same error was in -rc3-mm1, sorry for not sending fix in time for -rc5-mm1.
The error comes 1 or 4 patches earlier, but this patch atop 2.6.25-rc5-mm1
fits best just after
mm-have-zonelist-contains-structs-with-both-a-zone-pointer-and-zone_idx.patch

I've other GFP masking fixes or cleanups to come another day: this fixes
just one clear bug, peculiar to the -mm tree, orthogonal to the rest.
But two little do_try_to_free_pages cleanups follow on from this...

 mm/vmscan.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- 2.6.25-rc5-mm1/mm/vmscan.c	2008-03-11 14:19:36.000000000 +0000
+++ linux/mm/vmscan.c	2008-03-11 20:09:05.000000000 +0000
@@ -1444,7 +1444,6 @@ unsigned long try_to_free_mem_cgroup_pag
 						gfp_t gfp_mask)
 {
 	struct scan_control sc = {
-		.gfp_mask = gfp_mask,
 		.may_writepage = !laptop_mode,
 		.may_swap = 1,
 		.swap_cluster_max = SWAP_CLUSTER_MAX,
@@ -1454,9 +1453,10 @@ unsigned long try_to_free_mem_cgroup_pag
 		.isolate_pages = mem_cgroup_isolate_pages,
 	};
 	struct zonelist *zonelist;
-	int target_zone = gfp_zonelist(GFP_HIGHUSER_MOVABLE);
 
-	zonelist = &NODE_DATA(numa_node_id())->node_zonelists[target_zone];
+	sc.gfp_mask = (gfp_mask & GFP_RECLAIM_MASK) |
+			(GFP_HIGHUSER_MOVABLE & ~GFP_RECLAIM_MASK);
+	zonelist = NODE_DATA(numa_node_id())->node_zonelists;
 	if (do_try_to_free_pages(zonelist, sc.gfp_mask, &sc))
 		return 1;
 	return 0;
