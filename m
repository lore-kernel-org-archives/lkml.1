Return-Path: <linux-kernel-owner+w=401wt.eu-S935871AbXGQUgj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935871AbXGQUgj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 16:36:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759818AbXGQUgM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 16:36:12 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:43873 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753187AbXGQUgJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 16:36:09 -0400
Date: Tue, 17 Jul 2007 21:35:19 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Joe Jin <joe.jin@oracle.com>, bill.irwin@oracle.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Add nid sanity on alloc_pages_node
In-Reply-To: <20070717130118.bc78d31a.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0707172133400.9010@blonde.wat.veritas.com>
References: <20070713024507.GA19438@joejin-pc.cn.oracle.com>
 <20070712221842.f5e47065.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0707171558470.26771@blonde.wat.veritas.com>
 <20070717093228.3a3638aa.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0707171818080.19489@blonde.wat.veritas.com>
 <20070717115849.9f5e435c.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0707172044001.5286@blonde.wat.veritas.com>
 <20070717130118.bc78d31a.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Brightmail-Verdict: VlJEQwAAAAIAAAABAAAAAAAAAAEAAAAAAAAABGluYm94AGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmcAam9lLmppbkBvcmFjbGUuY29tAGJpbGwuaXJ3aW5Ab3JhY2xlLmNvbQBha3BtQGxpbnV4LWZvdW5kYXRpb24ub3JnAA==
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Jul 2007, Andrew Morton wrote:
> 
> Given that we've now gone and added deliberate-but-we-hope-benign 
> races into this code, an elaborate comment which explains and justifies
> it all is pretty much obligatory, IMO.

[PATCH] Remove nid_lock from alloc_fresh_huge_page

The fix to that race in alloc_fresh_huge_page() which could give an illegal
node ID did not need nid_lock at all: the fix was to replace static int nid
by static int prev_nid and do the work on local int nid.  nid_lock did make
sure that racers strictly roundrobin the nodes, but that's not something we
need to enforce strictly.  Kill nid_lock.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
---
 mm/hugetlb.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- 2.6.22-git9/mm/hugetlb.c	2007-07-17 20:29:33.000000000 +0100
+++ linux/mm/hugetlb.c	2007-07-17 21:29:58.000000000 +0100
@@ -107,15 +107,19 @@ static int alloc_fresh_huge_page(void)
 {
 	static int prev_nid;
 	struct page *page;
-	static DEFINE_SPINLOCK(nid_lock);
 	int nid;
 
-	spin_lock(&nid_lock);
+	/*
+	 * Copy static prev_nid to local nid, work on that, then copy it
+	 * back to prev_nid afterwards: otherwise there's a window in which
+	 * a racer might pass invalid nid MAX_NUMNODES to alloc_pages_node.
+	 * But we don't need to use a spin_lock here: it really doesn't
+	 * matter if occasionally a racer chooses the same nid as we do.
+	 */
 	nid = next_node(prev_nid, node_online_map);
 	if (nid == MAX_NUMNODES)
 		nid = first_node(node_online_map);
 	prev_nid = nid;
-	spin_unlock(&nid_lock);
 
 	page = alloc_pages_node(nid, htlb_alloc_mask|__GFP_COMP|__GFP_NOWARN,
 					HUGETLB_PAGE_ORDER);
