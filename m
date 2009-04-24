Return-Path: <linux-kernel-owner+w=401wt.eu-S1759418AbZDXNHA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759418AbZDXNHA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 09:07:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753422AbZDXNGw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 09:06:52 -0400
Received: from gir.skynet.ie ([193.1.99.77]:33527 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752802AbZDXNGv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 09:06:51 -0400
Date: Fri, 24 Apr 2009 14:06:48 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, kosaki.motohiro@jp.fujitsu.com,
       cl@linux-foundation.org, npiggin@suse.de, linux-kernel@vger.kernel.org,
       ming.m.lin@intel.com, yanmin_zhang@linux.intel.com,
       peterz@infradead.org, penberg@cs.helsinki.fi
Subject: Re: [PATCH 19/22] Update NR_FREE_PAGES only as necessary
Message-ID: <20090424130648.GI14283@csn.ul.ie>
References: <1240408407-21848-1-git-send-email-mel@csn.ul.ie> <1240408407-21848-20-git-send-email-mel@csn.ul.ie> <20090423160610.a093ddf0.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20090423160610.a093ddf0.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 23, 2009 at 04:06:10PM -0700, Andrew Morton wrote:
> On Wed, 22 Apr 2009 14:53:24 +0100
> Mel Gorman <mel@csn.ul.ie> wrote:
> 
> > When pages are being freed to the buddy allocator, the zone
> > NR_FREE_PAGES counter must be updated. In the case of bulk per-cpu page
> > freeing, it's updated once per page. This retouches cache lines more
> > than necessary. Update the counters one per per-cpu bulk free.
> > 
> > ...
> >
> > --- a/mm/page_alloc.c
> > +++ b/mm/page_alloc.c
> > @@ -460,7 +460,6 @@ static inline void __free_one_page(struct page *page,
> >  		int migratetype)
> >  {
> >  	unsigned long page_idx;
> > -	int order_size = 1 << order;
> >  
> >  	if (unlikely(PageCompound(page)))
> >  		if (unlikely(destroy_compound_page(page, order)))
> > @@ -470,10 +469,9 @@ static inline void __free_one_page(struct page *page,
> >  
> >  	page_idx = page_to_pfn(page) & ((1 << MAX_ORDER) - 1);
> >  
> > -	VM_BUG_ON(page_idx & (order_size - 1));
> > +	VM_BUG_ON(page_idx & ((1 << order) - 1));
> >  	VM_BUG_ON(bad_range(zone, page));
> >  
> 
> <head spins>
> 
> Is this all a slow and obscure way of doing
> 
> 	VM_BUG_ON(order > MAX_ORDER);
> 
> ?

Nope.

> 
> If not, what _is_ it asserting?
> 

That the page is properly placed. The start of the page being freed has to
be size-of-page-aligned. If it isn't the calculation that works out where
the buddy is will break.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
