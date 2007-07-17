Return-Path: <linux-kernel-owner+w=401wt.eu-S935812AbXGQTu6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935812AbXGQTu6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 15:50:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756845AbXGQTuu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 15:50:50 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:38174 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758329AbXGQTut (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 15:50:49 -0400
Date: Tue, 17 Jul 2007 20:49:25 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Joe Jin <joe.jin@oracle.com>, bill.irwin@oracle.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Add nid sanity on alloc_pages_node
In-Reply-To: <20070717115849.9f5e435c.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0707172044001.5286@blonde.wat.veritas.com>
References: <20070713024507.GA19438@joejin-pc.cn.oracle.com>
 <20070712221842.f5e47065.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0707171558470.26771@blonde.wat.veritas.com>
 <20070717093228.3a3638aa.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0707171818080.19489@blonde.wat.veritas.com>
 <20070717115849.9f5e435c.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Brightmail-Verdict: VlJEQwAAAAIAAAABAAAAAAAAAAEAAAAAAAAABGluYm94AGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmcAam9lLmppbkBvcmFjbGUuY29tAGJpbGwuaXJ3aW5Ab3JhY2xlLmNvbQBha3BtQGxpbnV4LWZvdW5kYXRpb24ub3JnAA==
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Jul 2007, Andrew Morton wrote:
> On Tue, 17 Jul 2007 18:26:14 +0100 (BST) Hugh Dickins <hugh@veritas.com> wrote:
> > > I think I like the lock ;)
> > 
> > I hate to waste your time, but I'm still puzzled.  Wasn't the race fixed
> > by your changeover from use of "static int nid" throughout, to setting
> > local "int nid" from "static int prev_nid", working with nid, then
> > setting prev_nid from nid at the end?  What does the lock add to that?
> 
> There are still minor races without the lock - two CPUs will allocate
> from the first node, and prev_nid can occasionally go backwards.
> 
> I agree that they are sufficiently minor that we could remove the lock.

Phew, yes, that's what I meant - thanks.


[PATCH] Remove nid_lock from alloc_fresh_huge_page

The fix to the race in alloc_fresh_huge_page() which could give an illegal
node ID did not need nid_lock at all: the fix was to replace static int nid
by static int prev_nid and do the work on local int nid.  nid_lock did make
sure that racers strictly roundrobin the nodes, but that's not something we
actually need to enforce strictly.  Kill that nid_lock.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
---
 mm/hugetlb.c |    3 ---
 1 file changed, 3 deletions(-)

--- 2.6.22-git9/mm/hugetlb.c	2007-07-17 20:29:33.000000000 +0100
+++ linux/mm/hugetlb.c	2007-07-17 20:32:51.000000000 +0100
@@ -107,15 +107,12 @@ static int alloc_fresh_huge_page(void)
 {
 	static int prev_nid;
 	struct page *page;
-	static DEFINE_SPINLOCK(nid_lock);
 	int nid;
 
-	spin_lock(&nid_lock);
 	nid = next_node(prev_nid, node_online_map);
 	if (nid == MAX_NUMNODES)
 		nid = first_node(node_online_map);
 	prev_nid = nid;
-	spin_unlock(&nid_lock);
 
 	page = alloc_pages_node(nid, htlb_alloc_mask|__GFP_COMP|__GFP_NOWARN,
 					HUGETLB_PAGE_ORDER);
