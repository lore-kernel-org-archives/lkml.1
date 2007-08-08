Return-Path: <linux-kernel-owner+w=401wt.eu-S1765720AbXHHQQn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765720AbXHHQQn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 12:16:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764652AbXHHQQL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 12:16:11 -0400
Received: from gir.skynet.ie ([193.1.99.77]:53619 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764608AbXHHQQJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 12:16:09 -0400
From: Mel Gorman <mel@csn.ul.ie>
To: Lee.Schermerhorn@hp.com, pj@sgi.com, ak@suse.de,
       kamezawa.hiroyu@jp.fujitsu.com, clameter@sgi.com
Cc: Mel Gorman <mel@csn.ul.ie>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Message-Id: <20070808161605.32320.40722.sendpatchset@skynet.skynet.ie>
In-Reply-To: <20070808161504.32320.79576.sendpatchset@skynet.skynet.ie>
References: <20070808161504.32320.79576.sendpatchset@skynet.skynet.ie>
Subject: [PATCH 3/3] Apply MPOL_BIND policy to two highest zones when highest is ZONE_MOVABLE
Date: Wed,  8 Aug 2007 17:16:05 +0100 (IST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


The NUMA layer only supports the MPOL_BIND NUMA policy for the highest
zone. When ZONE_MOVABLE is configured with kernelcore=, the the highest
zone becomes ZONE_MOVABLE. The result is that the bind policy policies is
only applied to allocations like anonymous pages and page cache allocated
from ZONE_MOVABLE when the zone is used.

This patch applies policies to the two highest zones when the highest zone
is ZONE_MOVABLE. As ZONE_MOVABLE consists of pages from the highest "real"
zone, these two zones are equivalent in policy terms.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
---

 include/linux/mempolicy.h |    2 +-
 mm/mempolicy.c            |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -rup -X /usr/src/patchset-0.6/bin//dontdiff linux-2.6.23-rc1-mm2-010_use_zonelist/include/linux/mempolicy.h linux-2.6.23-rc1-mm2-015_treat_movable_highest/include/linux/mempolicy.h
--- linux-2.6.23-rc1-mm2-010_use_zonelist/include/linux/mempolicy.h	2007-08-08 11:35:09.000000000 +0100
+++ linux-2.6.23-rc1-mm2-015_treat_movable_highest/include/linux/mempolicy.h	2007-08-08 14:36:52.000000000 +0100
@@ -157,7 +157,7 @@ extern enum zone_type policy_zone;
 
 static inline void check_highest_zone(enum zone_type k)
 {
-	if (k > policy_zone)
+	if (k > policy_zone && k != ZONE_MOVABLE)
 		policy_zone = k;
 }
 
diff -rup -X /usr/src/patchset-0.6/bin//dontdiff linux-2.6.23-rc1-mm2-010_use_zonelist/mm/mempolicy.c linux-2.6.23-rc1-mm2-015_treat_movable_highest/mm/mempolicy.c
--- linux-2.6.23-rc1-mm2-010_use_zonelist/mm/mempolicy.c	2007-08-08 11:35:09.000000000 +0100
+++ linux-2.6.23-rc1-mm2-015_treat_movable_highest/mm/mempolicy.c	2007-08-08 14:36:52.000000000 +0100
@@ -151,7 +151,7 @@ static struct zonelist *bind_zonelist(no
 	   lower zones etc. Avoid empty zones because the memory allocator
 	   doesn't like them. If you implement node hot removal you
 	   have to fix that. */
-	k = policy_zone;
+	k = MAX_NR_ZONES - 1;
 	while (1) {
 		for_each_node_mask(nd, *nodes) { 
 			struct zone *z = &NODE_DATA(nd)->node_zones[k];
