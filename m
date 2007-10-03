Return-Path: <linux-kernel-owner+w=401wt.eu-S1755319AbXJCSdo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755319AbXJCSdo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 14:33:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751241AbXJCSdf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 14:33:35 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:58235 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750766AbXJCSde (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 14:33:34 -0400
Subject: Re: [PATCH] hugetlb: Fix pool resizing corner case
From: Adam Litke <agl@us.ibm.com>
To: Dave Hansen <haveblue@us.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <1191433248.4939.79.camel@localhost>
References: <20071003154748.19516.90317.stgit@kernel>
	 <1191433248.4939.79.camel@localhost>
Content-Type: text/plain
Date: Wed, 03 Oct 2007 13:33:12 -0500
Message-Id: <1191436392.19775.43.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-10-03 at 10:40 -0700, Dave Hansen wrote:
> > diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> > index 84c795e..7af3908 100644
> > --- a/mm/hugetlb.c
> > +++ b/mm/hugetlb.c
> > @@ -224,14 +224,14 @@ static void try_to_free_low(unsigned long count)
> >  	for (i = 0; i < MAX_NUMNODES; ++i) {
> >  		struct page *page, *next;
> >  		list_for_each_entry_safe(page, next, &hugepage_freelists[i], lru) {
> > +			if (count >= nr_huge_pages)
> > +				return;
> >  			if (PageHighMem(page))
> >  				continue;
> >  			list_del(&page->lru);
> >  			update_and_free_page(page);
> >  			free_huge_pages--;
> >  			free_huge_pages_node[page_to_nid(page)]--;
> > -			if (count >= nr_huge_pages)
> > -				return;
> >  		}
> >  	}
> >  }
> 
> That's an excellent problem description.  I'm just a bit hazy on how the
> patch fixes it. :)
> 
> What is the actual error in this loop?  The fact that we can go trying
> to free pages when the count is actually OK?

The above hunk serves only to change the behavior of try_to_free_low()
so that rather than always freeing _at_least_ one huge page, it can
return without having freed any pages. 

> BTW, try_to_free_low(count) kinda sucks for a function name.  Is that
> count the number of pages we're trying to end up with, or the total
> number of low pages that we're trying to free?

I agree the name sucks, but this is a bugfix patch.

> Also, as I look at try_to_free_low(), why do we need to #ifdef it out in
> the case of !HIGHMEM?  If we have CONFIG_HIGHMEM=yes, we still might not
> have any _actual_ high memory.  So, they loop obviously doesn't *hurt*
> when there is no high memory.

Maybe, but not really in-scope of what this patch is trying to
accomplish.

> > @@ -251,7 +251,7 @@ static unsigned long set_max_huge_pages(unsigned long count)
> >  		return nr_huge_pages;
> > 
> >  	spin_lock(&hugetlb_lock);
> > -	count = max(count, resv_huge_pages);
> > +	count = max(count, resv_huge_pages + nr_huge_pages - free_huge_pages);
> >  	try_to_free_low(count);
> >  	while (count < nr_huge_pages) {
> >  		struct page *page = dequeue_huge_page(NULL, 0);
> 
> The real problem with this line is that "count" is too ambiguous. :)

I agree, count is almost always a bad variable name :)

> We could rewrite the original max() line this way:
> 
> 	if (resv_huge_pages > nr_of_pages_to_end_up_with)
> 		nr_of_pages_to_end_up_with = resv_huge_pages;
> 	try_to_make_the_total_nr_of_hpages(nr_of_pages_to_end_up_with);
> 
> Which makes it more clear that you're setting the number of total pages
> to the number of reserved pages, which is obviously screwy.
> 
> OK, so this is actually saying: "count can never go below
> resv_huge_pages+nr_huge_pages"?

Not quite.  Count can never go below the number of reserved pages plus
pages allocated to MAP_PRIVATE mappings.  That number is computed by:
(resv + (total - free)).

> Could we change try_to_free_low() to free a distinct number of pages?
> 
> 	if (count > free_huge_pages)
> 		count = free_huge_pages;
> 	try_to_free_nr_huge_pages(count);
> 
> I feel a bit sketchy about the "resv_huge_pages + nr_huge_pages -
> free_huge_pages" logic.  Could you elaborate a bit there on what the
> rules are?

The key is that we don't want to shrink the pool below the number of
pages we are committed to keeping around.  Before this patch, we only
accounted for the pages we plan to hand out (reserved huge pages) but
not the ones we've already handed out (total - free).  Does that make
sense?

-- 
Adam Litke - (agl at us.ibm.com)
IBM Linux Technology Center

