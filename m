Return-Path: <linux-kernel-owner+w=401wt.eu-S1756666AbXKNLZm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756666AbXKNLZm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 06:25:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751452AbXKNLZe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 06:25:34 -0500
Received: from gir.skynet.ie ([193.1.99.77]:40073 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750954AbXKNLZe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 06:25:34 -0500
Date: Wed, 14 Nov 2007 11:25:31 +0000
To: Andi Kleen <andi@firstfloor.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, akpm@osdl.org, torvalds@osdl.org,
       linux-kernel@vger.kernel.org, linux-mm@vger.kernel.org
Subject: Re: Major mke2fs slowdown (reproducable, bisected)
Message-ID: <20071114112531.GC9566@skynet.ie>
References: <20071112182526.GC11244@martell.zuzino.mipt.ru> <p736406yuxm.fsf@bingen.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <p736406yuxm.fsf@bingen.suse.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: mel@skynet.ie (Mel Gorman)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On (13/11/07 17:25), Andi Kleen didst pronounce:
> Alexey Dobriyan <adobriyan@gmail.com> writes:
> >  
> > +/* Return the page with the lowest PFN in the list */
> > +static struct page *min_page(struct list_head *list)
> > +{
> > +	unsigned long min_pfn = -1UL;
> > +	struct page *min_page = NULL, *page;;
> > +
> > +	list_for_each_entry(page, list, lru) {
> > +		unsigned long pfn = page_to_pfn(page);
> > +		if (pfn < min_pfn) {
> > +			min_pfn = pfn;
> > +			min_page = page;
> > +		}
> > +	}
> > +
> > +	return min_page;
> > +}
> > +
> >  /* Remove an element from the buddy allocator from the fallback list */
> >  static struct page *__rmqueue_fallback(struct zone *zone, int order,
> >  						int start_migratetype)
> > @@ -795,8 +812,11 @@ retry:
> >  			if (list_empty(&area->free_list[migratetype]))
> >  				continue;
> >  
> > +			/* Bias kernel allocations towards low pfns */
> >  			page = list_entry(area->free_list[migratetype].next,
> >  					struct page, lru);
> > +			if (unlikely(start_migratetype != MIGRATE_MOVABLE))
> > +				page = min_page(&area->free_list[migratetype]);
> 
> Do I misread this, or does it really turn the O(1) buddy allocation into
> a "search whole free list" algorithm?  Even as fallback that looks like
> a quite extreme thing to do.
> 

It's extreme but not *quite* as extreme as you imply. The whole free-lists are
not searched, just one set at a specific order so it's "search a portion of
the free-lists". It happens for non-movable allocations (usually the minority)
and only then in fallback (in itself quite rare in almost all cases I've seen).

The problem was not detected before by me because it wasn't just a case of
creating a large number of pinned allocations but also depended on the type
of workload preceding it. If mke2fs was long-lived, it might not even have
been noticed. When run more than once, the fallbacks have all been dealt
with and it goes back to normal times.

The patch is now reverted and I don't expect to try bringing it back.
There are ways to bias the placement the pages as the patch intended without
doing an expensive search.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
