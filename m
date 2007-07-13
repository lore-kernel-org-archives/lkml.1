Return-Path: <linux-kernel-owner+w=401wt.eu-S935096AbXGMGuR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935096AbXGMGuR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 02:50:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752134AbXGMGuG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 02:50:06 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59376 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751699AbXGMGuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 02:50:04 -0400
Date: Thu, 12 Jul 2007 23:49:38 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Joe Jin <joe.jin@oracle.com>
Cc: bill.irwin@oracle.com, linux-kernel@vger.kernel.org,
       gurudas.pai@oracle.com
Subject: Re: [PATCH] Add nid sanity on alloc_pages_node
Message-Id: <20070712234938.c77f3a48.akpm@linux-foundation.org>
In-Reply-To: <20070713064004.GA21833@joejin-pc.cn.oracle.com>
References: <20070713024507.GA19438@joejin-pc.cn.oracle.com>
	<20070712221842.f5e47065.akpm@linux-foundation.org>
	<20070713064004.GA21833@joejin-pc.cn.oracle.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Jul 2007 14:40:04 +0800 Joe Jin <joe.jin@oracle.com> wrote:

> On 2007-07-12 22:18, Andrew Morton wrote:
> > On Fri, 13 Jul 2007 10:45:07 +0800 Joe Jin <joe.jin@oracle.com> wrote:
> > 
> > Something like this?
> > 
> > --- a/mm/hugetlb.c~a
> > +++ a/mm/hugetlb.c
> > @@ -105,13 +105,20 @@ static void free_huge_page(struct page *
> >  
> >  static int alloc_fresh_huge_page(void)
> >  {
> > -	static int nid = 0;
> > +	static int prev_nid;
> > +	static DEFINE_SPINLOCK(nid_lock);
> >  	struct page *page;
> > -	page = alloc_pages_node(nid, htlb_alloc_mask|__GFP_COMP|__GFP_NOWARN,
> > -					HUGETLB_PAGE_ORDER);
> > -	nid = next_node(nid, node_online_map);
> > +	int nid;
> > +
> > +	spin_lock(&nid_lock);
> > +	nid = next_node(prev_nid, node_online_map);
> >  	if (nid == MAX_NUMNODES)
> >  		nid = first_node(node_online_map);
> > +	prev_nid = nid;
> > +	spin_unlock(&nid_lock);
> > +
> > +	page = alloc_pages_node(nid, htlb_alloc_mask|__GFP_COMP|__GFP_NOWARN,
> > +					HUGETLB_PAGE_ORDER);
> >  	if (page) {
> >  		set_compound_page_dtor(page, free_huge_page);
> >  		spin_lock(&hugetlb_lock);
> > _
> > 
> 
> The patch looks good for this bug, thanks :)

If you have time could you test it and sent it back at me please?

> if other caller give a invalid nid to alloc_pages_node(), __alloc_pages
> will crash again.

That would be a buggy caller, so we should fix that caller.

> So I think we add some sanity check for nid at alloc_pages_node is
> meaningful.  
> 
> another question, if (nid >= MAX_NUMNODES),  may I set nid to 0 directly
> like following code?
> 
> 	if (unlikly(nid >= MAX_NUMNODES)
> 		nid = 0

if (nid > MAX_NUMNODES) then that is a bug and we should report it (doing
this via a BUG() is OK) rather than quietly covering it up.

if (nid == MAX_NUMNODES) then we should set it to
first_node(node_online_map);
