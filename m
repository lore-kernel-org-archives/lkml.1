Return-Path: <linux-kernel-owner+w=401wt.eu-S1755321AbYJBNV4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755321AbYJBNV4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 09:21:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754733AbYJBNTD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 09:19:03 -0400
Received: from casper.infradead.org ([85.118.1.10]:54805 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754696AbYJBNSz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 09:18:55 -0400
Message-Id: <20081002131608.372668704@chello.nl>
References: <20081002130504.927878499@chello.nl>
User-Agent: quilt/0.46-1
Date: Thu, 02 Oct 2008 15:05:16 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, netdev@vger.kernel.org, trond.myklebust@fys.uio.no,
       Daniel Lezcano <dlezcano@fr.ibm.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Neil Brown <neilb@suse.de>,
       David Miller <davem@davemloft.net>
Subject: [PATCH 12/32] mm: system wide ALLOC_NO_WATERMARK
Content-Disposition: inline; filename=global-ALLOC_NO_WATERMARKS.patch
X-Bad-Reply: References but no 'Re:' in Subject.
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
 mm/page_alloc.c |    5 +++++
 1 file changed, 5 insertions(+)

Index: linux-2.6/mm/page_alloc.c
===================================================================
--- linux-2.6.orig/mm/page_alloc.c
+++ linux-2.6/mm/page_alloc.c
@@ -1533,6 +1533,11 @@ restart:
 rebalance:
 	if (alloc_flags & ALLOC_NO_WATERMARKS) {
 nofail_alloc:
+		/*
+		 * break out of mempolicy boundaries
+		 */
+		zonelist = node_zonelist(numa_node_id(), gfp_mask);
+
 		/* go through the zonelist yet again, ignoring mins */
 		page = get_page_from_freelist(gfp_mask, nodemask, order,
 				zonelist, high_zoneidx, ALLOC_NO_WATERMARKS);

-- 

