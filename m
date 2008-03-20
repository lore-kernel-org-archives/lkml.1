Return-Path: <linux-kernel-owner+w=401wt.eu-S1758437AbYCTUX2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758437AbYCTUX2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 16:23:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755426AbYCTUVT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 16:21:19 -0400
Received: from viefep32-int.chello.at ([62.179.121.50]:40691 "EHLO
	viefep32-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754966AbYCTUVL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 16:21:11 -0400
Message-Id: <20080320202122.439298000@chello.nl>
References: <20080320201042.675090000@chello.nl>
User-Agent: quilt/0.45-1
Date: Thu, 20 Mar 2008 21:10:52 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, netdev@vger.kernel.org, trond.myklebust@fys.uio.no,
       neilb@suse.de, miklos@szeredi.hu, penberg@cs.helsinki.fi,
       a.p.zijlstra@chello.nl
Subject: [PATCH 10/30] mm: system wide ALLOC_NO_WATERMARK
Content-Disposition: inline; filename=global-ALLOC_NO_WATERMARKS.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The reserve is proportionally distributed over all (!highmem) zones in the
system. So we need to allow an emergency allocation access to all zones. In
order to do that we need to break out of any mempolicy boundaries we might
have.

In my opinion that does not break mempolicies as those are user oriented
and not system oriented. That is, system allocations are not guaranteed to be
within mempolicy boundaries. For instance IRQs don't even have a mempolicy.

So breaking out of mempolicy boundaries for 'rare' emergency allocations,
which are always system allocations (as opposed to user) is ok.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 mm/page_alloc.c |    6 ++++++
 1 file changed, 6 insertions(+)

Index: linux-2.6/mm/page_alloc.c
===================================================================
--- linux-2.6.orig/mm/page_alloc.c
+++ linux-2.6/mm/page_alloc.c
@@ -1625,6 +1625,12 @@ restart:
 rebalance:
 	if (alloc_flags & ALLOC_NO_WATERMARKS) {
 nofail_alloc:
+		/*
+		 * break out of mempolicy boundaries
+		 */
+		zonelist = NODE_DATA(numa_node_id())->node_zonelists +
+			gfp_zone(gfp_mask);
+
 		/* go through the zonelist yet again, ignoring mins */
 		page = get_page_from_freelist(gfp_mask, nodemask, order,
 				zonelist, high_zoneidx, ALLOC_NO_WATERMARKS);

--

