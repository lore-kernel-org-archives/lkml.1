Return-Path: <linux-kernel-owner+w=401wt.eu-S934702AbXGMIXI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934702AbXGMIXI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 04:23:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753245AbXGMIW5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 04:22:57 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42121 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751774AbXGMIW4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 04:22:56 -0400
Date: Fri, 13 Jul 2007 01:19:24 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: gurudas pai <gurudas.pai@oracle.com>
Cc: Joe Jin <joe.jin@oracle.com>, bill.irwin@oracle.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Add nid sanity on alloc_pages_node
Message-Id: <20070713011924.75e6afd4.akpm@linux-foundation.org>
In-Reply-To: <4697320D.1060703@oracle.com>
References: <20070713024507.GA19438@joejin-pc.cn.oracle.com>
	<20070712221842.f5e47065.akpm@linux-foundation.org>
	<20070713064004.GA21833@joejin-pc.cn.oracle.com>
	<20070712234938.c77f3a48.akpm@linux-foundation.org>
	<4697320D.1060703@oracle.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Jul 2007 13:34:29 +0530 gurudas pai <gurudas.pai@oracle.com> wrote:

> 
> 
> Andrew Morton wrote:
> > On Fri, 13 Jul 2007 14:40:04 +0800 Joe Jin <joe.jin@oracle.com> wrote:
> >
> >> On 2007-07-12 22:18, Andrew Morton wrote:
> >>> On Fri, 13 Jul 2007 10:45:07 +0800 Joe Jin <joe.jin@oracle.com> wrote:
> >>>
> >>> Something like this?
> >>>
> >>> --- a/mm/hugetlb.c~a
> >>> +++ a/mm/hugetlb.c
> >>> @@ -105,13 +105,20 @@ static void free_huge_page(struct page *
> >>>  
> >>>  static int alloc_fresh_huge_page(void)
> >>>  {
> >>> -	static int nid = 0;
> >>> +	static int prev_nid;
> >>> +	static DEFINE_SPINLOCK(nid_lock);
> >>>  	struct page *page;
> >>> -	page = alloc_pages_node(nid, htlb_alloc_mask|__GFP_COMP|__GFP_NOWARN,
> >>> -					HUGETLB_PAGE_ORDER);
> >>> -	nid = next_node(nid, node_online_map);
> >>> +	int nid;
> >>> +
> >>> +	spin_lock(&nid_lock);
> >>> +	nid = next_node(prev_nid, node_online_map);
> >>>  	if (nid == MAX_NUMNODES)
> >>>  		nid = first_node(node_online_map);
> >>> +	prev_nid = nid;
> >>> +	spin_unlock(&nid_lock);
> >>> +
> >>> +	page = alloc_pages_node(nid, htlb_alloc_mask|__GFP_COMP|__GFP_NOWARN,
> >>> +					HUGETLB_PAGE_ORDER);
> >>>  	if (page) {
> >>>  		set_compound_page_dtor(page, free_huge_page);
> >>>  		spin_lock(&hugetlb_lock);
> >>> _
> >>>
> I think this will never get pages from node 0 ? Because nid = 
> next_node(prev_node,node_online_map) and even if prev_node = 0, nid will 
> become 1.

It'll start out at node 1.  But it will visit the final node (which is less
than MAX_NUMNODES) and will then advance onto the fist node (which can be
>= 0).

This code needs a bit of thought and testing for the non-numa case too
please.  At the least, there might be optimisation opportunities.


> How about this patch ?
> 
> 
> --- linux-2.6.22.orig/mm/hugetlb.c 2007-07-08 16:32:17.000000000 -0700
> +++ linux-2.6.22-devel/mm//hugetlb.c 2007-07-13 00:26:27.000000000 -0700
> @@ -103,11 +103,18 @@
> {
> static int nid = 0;
> struct page *page;
> - page = alloc_pages_node(nid, GFP_HIGHUSER|__GFP_COMP|__GFP_NOWARN,
> - HUGETLB_PAGE_ORDER);
> + int cur_nid;
> + static DEFINE_SPINLOCK(nid_lock);
> +
> + spin_lock(&nid_lock);
> + cur_nid = nid;
> nid = next_node(nid, node_online_map);
> if (nid == MAX_NUMNODES)
> nid = first_node(node_online_map);
> + spin_unlock(&nid_lock);
> +
> + page = alloc_pages_node(cur_nid, GFP_HIGHUSER|__GFP_COMP|__GFP_NOWARN,
> + HUGETLB_PAGE_ORDER);
> if (page) {
> set_compound_page_dtor(page, free_huge_page);
> spin_lock(&hugetlb_lock);

whoa, your email client made a huge mess of that one.
