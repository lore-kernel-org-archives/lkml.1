Return-Path: <linux-kernel-owner+w=401wt.eu-S933696AbXGMGlr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933696AbXGMGlr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 02:41:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753676AbXGMGlj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 02:41:39 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:58474 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753418AbXGMGli (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 02:41:38 -0400
Date: Fri, 13 Jul 2007 14:40:04 +0800
From: Joe Jin <joe.jin@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Joe Jin <joe.jin@oracle.com>, bill.irwin@oracle.com,
       linux-kernel@vger.kernel.org, gurudas.pai@oracle.com
Subject: Re: [PATCH] Add nid sanity on alloc_pages_node
Message-ID: <20070713064004.GA21833@joejin-pc.cn.oracle.com>
References: <20070713024507.GA19438@joejin-pc.cn.oracle.com> <20070712221842.f5e47065.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070712221842.f5e47065.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.2i
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAA==
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2007-07-12 22:18, Andrew Morton wrote:
> On Fri, 13 Jul 2007 10:45:07 +0800 Joe Jin <joe.jin@oracle.com> wrote:
> 
> > This patch add nid sanity check on alloc_pages_node().
> > While two process change nr_hugepages at a system, alloc_fresh_huge_page()
> > been called, at this function, nid defined as a static variable, but, there
> > is not any protection of, if 2 process called at the same time, maybe pass a
> > invalid nid to alloc_pages_node. 
> > 
> > We have hit it by following scripts:
> > 
> > #!/bin/bash
> > while : ; do 
> > 	echo 1000000000000 > /proc/sys/vm/nr_hugepages 
> > 	echo 1 > /proc/sys/vm/nr_hugepages 
> > 	echo 10000000000000000000 > /proc/sys/vm/nr_hugepages 
> > 	echo 0 > /proc/sys/vm/nr_hugepages 
> > done 
> > 
> > 
> > Run the script at _two_ difference terminal, after a short time, a kernel panic
> > info will print.
> > 
> > 
> > Signed-off-by: Joe Jin <joe.jin@oracle.com>
> > ---
> > 
> > --- linux-2.6.22/include/linux/gfp.h.orig	2007-07-12 15:06:23.000000000 +0800
> > +++ linux-2.6.22/include/linux/gfp.h	2007-07-12 15:02:59.000000000 +0800
> > @@ -133,6 +133,9 @@
> >  	/* Unknown node is current node */
> >  	if (nid < 0)
> >  		nid = numa_node_id();
> > +	
> > +	if (unlikely(nid == MAX_NUMNODES))
> > +		nid = first_node(node_online_map);
> >  
> >  	return __alloc_pages(gfp_mask, order,
> >  		NODE_DATA(nid)->node_zonelists + gfp_zone(gfp_mask));
> 
> alloc_pages_node() is pretty much the last place where we want to fix this:
> it adds more cycles and more code to many important codepaths in the
> kernel.
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
> _
> 

The patch looks good for this bug, thanks :)

if other caller give a invalid nid to alloc_pages_node(), __alloc_pages
will crash again.

So I think we add some sanity check for nid at alloc_pages_node is
meaningful.  

another question, if (nid >= MAX_NUMNODES),  may I set nid to 0 directly
like following code?

	if (unlikly(nid >= MAX_NUMNODES)
		nid = 0

Thanks,
Joe

