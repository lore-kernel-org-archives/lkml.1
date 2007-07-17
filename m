Return-Path: <linux-kernel-owner+w=401wt.eu-S935239AbXGQTA3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935239AbXGQTA3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 15:00:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933852AbXGQS7t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 14:59:49 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37425 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933785AbXGQS7r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 14:59:47 -0400
Date: Tue, 17 Jul 2007 11:58:49 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Hugh Dickins <hugh@veritas.com>
Cc: Joe Jin <joe.jin@oracle.com>, bill.irwin@oracle.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Add nid sanity on alloc_pages_node
Message-Id: <20070717115849.9f5e435c.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0707171818080.19489@blonde.wat.veritas.com>
References: <20070713024507.GA19438@joejin-pc.cn.oracle.com>
	<20070712221842.f5e47065.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0707171558470.26771@blonde.wat.veritas.com>
	<20070717093228.3a3638aa.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0707171818080.19489@blonde.wat.veritas.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Jul 2007 18:26:14 +0100 (BST) Hugh Dickins <hugh@veritas.com> wrote:

> On Tue, 17 Jul 2007, Andrew Morton wrote:
> > On Tue, 17 Jul 2007 16:04:54 +0100 (BST) Hugh Dickins <hugh@veritas.com> wrote:
> > > On Thu, 12 Jul 2007, Andrew Morton wrote:
> > > > 
> > > > It'd be much better to fix the race within alloc_fresh_huge_page().  That
> > > > function is pretty pathetic.
> > > > 
> > > > Something like this?
> > > > 
> > > > --- a/mm/hugetlb.c~a
> > > > +++ a/mm/hugetlb.c
> > > > @@ -105,13 +105,20 @@ static void free_huge_page(struct page *
> > > >  
> > > >  static int alloc_fresh_huge_page(void)
> > > >  {
> > > > -	static int nid = 0;
> > > > +	static int prev_nid;
> > > > +	static DEFINE_SPINLOCK(nid_lock);
> > > >  	struct page *page;
> > > > -	page = alloc_pages_node(nid, htlb_alloc_mask|__GFP_COMP|__GFP_NOWARN,
> > > > -					HUGETLB_PAGE_ORDER);
> > > > -	nid = next_node(nid, node_online_map);
> > > > +	int nid;
> > > > +
> > > > +	spin_lock(&nid_lock);
> > > > +	nid = next_node(prev_nid, node_online_map);
> > > >  	if (nid == MAX_NUMNODES)
> > > >  		nid = first_node(node_online_map);
> > > > +	prev_nid = nid;
> > > > +	spin_unlock(&nid_lock);
> > > > +
> > > > +	page = alloc_pages_node(nid, htlb_alloc_mask|__GFP_COMP|__GFP_NOWARN,
> > > > +					HUGETLB_PAGE_ORDER);
> > > >  	if (page) {
> > > >  		set_compound_page_dtor(page, free_huge_page);
> > > >  		spin_lock(&hugetlb_lock);
> > > 
> > > Now that it's gone into the tree, I look at it and wonder, does your
> > > nid_lock really serve any purpose?  We're just doing a simple assignment
> > > to prev_nid, and it doesn't matter if occasionally two racers choose the
> > > same node, and there's no protection here against a node being offlined
> > > before the alloc_pages_node anyway (unsupported? I'm ignorant).
> > 
> > umm, actually, yes, the code as it happens to be structured does mean that
> > ther is no longer a way in which a race can cause us to pass MAX_NUMNODES
> > into alloc_pages_node().
> > 
> > Or not.  We can call next_node(MAX_NUMNODES, node_online_map) in that race
> > window, with perhaps bad results.
> > 
> > I think I like the lock ;)
> 
> I hate to waste your time, but I'm still puzzled.  Wasn't the race fixed
> by your changeover from use of "static int nid" throughout, to setting
> local "int nid" from "static int prev_nid", working with nid, then
> setting prev_nid from nid at the end?  What does the lock add to that?
> 

There are still minor races without the lock - two CPUs will allocate
from the first node, and prev_nid can occasionally go backwards.

I agree that they are sufficiently minor that we could remove the lock.


