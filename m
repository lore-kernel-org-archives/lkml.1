Return-Path: <linux-kernel-owner+w=401wt.eu-S1756061AbZDUQMp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756061AbZDUQMp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 12:12:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755883AbZDUQMV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 12:12:21 -0400
Received: from gir.skynet.ie ([193.1.99.77]:55501 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755378AbZDUQMU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 12:12:20 -0400
Date: Tue, 21 Apr 2009 17:12:16 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lin Ming <ming.m.lin@intel.com>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 17/25] Do not call get_pageblock_migratetype() more
	than necessary
Message-ID: <20090421161215.GD29083@csn.ul.ie>
References: <1240266011-11140-1-git-send-email-mel@csn.ul.ie> <1240266011-11140-18-git-send-email-mel@csn.ul.ie> <20090421200154.F174.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20090421200154.F174.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 21, 2009 at 08:03:10PM +0900, KOSAKI Motohiro wrote:
> > get_pageblock_migratetype() is potentially called twice for every page
> > free. Once, when being freed to the pcp lists and once when being freed
> > back to buddy. When freeing from the pcp lists, it is known what the
> > pageblock type was at the time of free so use it rather than rechecking.
> > In low memory situations under memory pressure, this might skew
> > anti-fragmentation slightly but the interference is minimal and
> > decisions that are fragmenting memory are being made anyway.
> > 
> > Signed-off-by: Mel Gorman <mel@csn.ul.ie>
> > Reviewed-by: Christoph Lameter <cl@linux-foundation.org>
> > ---
> >  mm/page_alloc.c |   16 ++++++++++------
> >  1 files changed, 10 insertions(+), 6 deletions(-)
> > 
> > diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> > index c57c602..a1ca038 100644
> > --- a/mm/page_alloc.c
> > +++ b/mm/page_alloc.c
> > @@ -456,16 +456,18 @@ static inline int page_is_buddy(struct page *page, struct page *buddy,
> >   */
> >  
> >  static inline void __free_one_page(struct page *page,
> > -		struct zone *zone, unsigned int order)
> > +		struct zone *zone, unsigned int order,
> > +		int migratetype)
> >  {
> >  	unsigned long page_idx;
> >  	int order_size = 1 << order;
> > -	int migratetype = get_pageblock_migratetype(page);
> >  
> >  	if (unlikely(PageCompound(page)))
> >  		if (unlikely(destroy_compound_page(page, order)))
> >  			return;
> >  
> > +	VM_BUG_ON(migratetype == -1);
> > +
> >  	page_idx = page_to_pfn(page) & ((1 << MAX_ORDER) - 1);
> >  
> >  	VM_BUG_ON(page_idx & (order_size - 1));
> > @@ -534,17 +536,18 @@ static void free_pages_bulk(struct zone *zone, int count,
> >  		page = list_entry(list->prev, struct page, lru);
> >  		/* have to delete it as __free_one_page list manipulates */
> >  		list_del(&page->lru);
> > -		__free_one_page(page, zone, order);
> > +		__free_one_page(page, zone, order, page_private(page));
> >  	}
> >  	spin_unlock(&zone->lock);
> 
> looks good.
> 	Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> 
> 
> btw, I can't review rest patch today. I plan to do that tommorow, sorry.
> 

No problem. Thanks a million for the work you've done so far. It was a
big help and you caught a fair few problems in there.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
