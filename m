Return-Path: <linux-kernel-owner+w=401wt.eu-S934062AbXGQPGe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934062AbXGQPGe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 11:06:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933935AbXGQPGU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 11:06:20 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:56282 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933922AbXGQPGT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 11:06:19 -0400
Date: Tue, 17 Jul 2007 16:04:54 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Joe Jin <joe.jin@oracle.com>, bill.irwin@oracle.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Add nid sanity on alloc_pages_node
In-Reply-To: <20070712221842.f5e47065.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0707171558470.26771@blonde.wat.veritas.com>
References: <20070713024507.GA19438@joejin-pc.cn.oracle.com>
 <20070712221842.f5e47065.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Brightmail-Verdict: VlJEQwAAAAIAAAABAAAAAAAAAAEAAAAAAAAABGluYm94AGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmcAam9lLmppbkBvcmFjbGUuY29tAGJpbGwuaXJ3aW5Ab3JhY2xlLmNvbQBha3BtQGxpbnV4LWZvdW5kYXRpb24ub3JnAA==
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Jul 2007, Andrew Morton wrote:
> 
> It'd be much better to fix the race within alloc_fresh_huge_page().  That
> function is pretty pathetic.
> 
> Something like this?
> 
> --- a/mm/hugetlb.c~a
> +++ a/mm/hugetlb.c
> @@ -105,13 +105,20 @@ static void free_huge_page(struct page *
>  
>  static int alloc_fresh_huge_page(void)
>  {
> -	static int nid = 0;
> +	static int prev_nid;
> +	static DEFINE_SPINLOCK(nid_lock);
>  	struct page *page;
> -	page = alloc_pages_node(nid, htlb_alloc_mask|__GFP_COMP|__GFP_NOWARN,
> -					HUGETLB_PAGE_ORDER);
> -	nid = next_node(nid, node_online_map);
> +	int nid;
> +
> +	spin_lock(&nid_lock);
> +	nid = next_node(prev_nid, node_online_map);
>  	if (nid == MAX_NUMNODES)
>  		nid = first_node(node_online_map);
> +	prev_nid = nid;
> +	spin_unlock(&nid_lock);
> +
> +	page = alloc_pages_node(nid, htlb_alloc_mask|__GFP_COMP|__GFP_NOWARN,
> +					HUGETLB_PAGE_ORDER);
>  	if (page) {
>  		set_compound_page_dtor(page, free_huge_page);
>  		spin_lock(&hugetlb_lock);

Now that it's gone into the tree, I look at it and wonder, does your
nid_lock really serve any purpose?  We're just doing a simple assignment
to prev_nid, and it doesn't matter if occasionally two racers choose the
same node, and there's no protection here against a node being offlined
before the alloc_pages_node anyway (unsupported? I'm ignorant).

Hugh
