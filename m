Return-Path: <linux-kernel-owner+w=401wt.eu-S1754665AbZBWPBP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754665AbZBWPBP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 10:01:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754574AbZBWPA7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 10:00:59 -0500
Received: from gir.skynet.ie ([193.1.99.77]:46925 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754263AbZBWPA6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 10:00:58 -0500
Date: Mon, 23 Feb 2009 15:00:56 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Rik van Riel <riel@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lin Ming <ming.m.lin@intel.com>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>
Subject: Re: [RFC PATCH 00/20] Cleanup and optimise the page allocator
Message-ID: <20090223150055.GK6740@csn.ul.ie>
References: <1235344649-18265-1-git-send-email-mel@csn.ul.ie> <200902240146.03456.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: 7BIT
In-Reply-To: <200902240146.03456.nickpiggin@yahoo.com.au>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 24, 2009 at 01:46:01AM +1100, Nick Piggin wrote:
> Hi Mel,
> 
> Seems like a nice patchset.
> 

Thanks

> On Monday 23 February 2009 10:17:09 Mel Gorman wrote:
> > The complexity of the page allocator has been increasing for some time
> > and it has now reached the point where the SLUB allocator is doing strange
> > tricks to avoid the page allocator. This is obviously bad as it may
> > encourage other subsystems to try avoiding the page allocator as well.
> >
> > This series of patches is intended to reduce the cost of the page
> > allocator by doing the following.
> >
> > Patches 1-3 iron out the entry paths slightly and remove stupid sanity
> > checks from the fast path.
> >
> > Patch 4 uses a lookup table instead of a number of branches to decide what
> > zones are usable given the GFP flags.
> >
> > Patch 5 avoids repeated checks of the zonelist
> >
> > Patch 6 breaks the allocator up into a fast and slow path where the fast
> > path later becomes one long inlined function.
> >
> > Patches 7-10 avoids calculating the same things repeatedly and instead
> > calculates them once.
> >
> > Patches 11-13 inline the whole allocator fast path
> >
> > Patch 14 avoids calling get_pageblock_migratetype() potentially twice on
> > every page free
> >
> > Patch 15 reduces the number of times interrupts are disabled by reworking
> > what free_page_mlock() does. However, I notice that the cost of calling
> > TestClearPageMlocked() is still quite high and I'm guessing it's because
> > it's a locked bit operation. It's be nice if it could be established if
> > it's safe to use an unlocked version here. Rik, can you comment?
> 
> Yes, it can. page flags are owned entirely by the owner of the page.
> 

I figured that was the case but hadn't convinced myself 100%. I wanted a
second opinion but I'm sure it's safe now.

> free_page_mlock shouldn't really be in free_pages_check, but oh well.
> 

Agreed, I took it out of there. The name alone implies it's debugging
that could be optionally disabled if you really had to.

> 
> > Patch 16 avoids using the zonelist cache on non-NUMA machines
> >
> > Patch 17 removes an expensive and excessively paranoid check in the
> > allocator fast path
> 
> I would be careful of removing useful debug checks completely like
> this. What is the cost? Obviously non-zero, but it is also a check

The cost was something like 1/10th the cost of the path. There are atomic
operations in there that are causing the problems.

> I have seen trigger on quite a lot of occasions (due to kernel bugs
> and hardware bugs, and in each case it is better to warn than not,
> even if many other situations can go undetected).
> 

Have you really seen it trigger for the allocation path or did it
trigger in teh free path? Essentially we are making the same check on
every allocation and free which is why I considered it excessivly
paranoid.

> One problem is that some of the calls we're making in page_alloc.c
> do the compound_head() thing, wheras we know that we only want to
> look at this page. I've attached a patch which cuts out about 150
> bytes of text and several branches from these paths.
> 

Nice, I should have spotted that. I'm going to fold this into the series
if that is ok with you? I'll replace patch 17 with it and see does it
still show up on profiles.

> 
> > Patch 18 avoids a list search in the allocator fast path.
> 
> Ah, this was badly needed :)
> 
> 
> > o On many machines, I'm seeing a 0-2% improvement on kernbench. The
> > dominant cost in kernbench is the compiler and zeroing allocated pages for
> > pagetables.
> 
> zeroing is a factor, but IIRC page faults and page allocator are among
> the top of the profiles.
> 

kernbench is also very fork heavy. That means lots of pagetable
allocations with lots of zeroing. I tried various ways of reducing the
zeroing cost including having processes exiting zero the pages as they
free but I couldn't make it go any faster.

> > o For tbench, I have seen an 8-12% improvement on two x86-64 machines
> > (elm3b6 on test.kernel.org gained 8%) but generally it was less dramatic on
> > x86-64 in the range of 0-4%. On one PPC64, the different was also in the
> > range of 0-4%. Generally there were gains, but one specific ppc64 showed a
> > regression of 7% for one client but a negligible difference for 8 clients.
> > It's not clear why this machine regressed and others didn't.
> 
> Did you bisect your patchset? It could have been random or pointed to
> eg the hot/cold removal?
> 

I didn't bisect, but I probably should to see can this be pinned down. I
should run one kernel for each patch to see what exactly is helping.
When I was writing the patches, I was just running kernbench and reading
profiles.

> > o hackbench is harder to conclude anything from. Most machines showed
> >   performance gains in the 5-11% range but one machine in particular showed
> >   a mix of gains and losses depending on the number of clients. Might be
> >   a caching thing.
> >
> > o One machine in particular was a major surprise for sysbench with gains
> >   of 4-8% there which was drastically higher than I was expecting. However,
> >   on other machines, it was in the more reasonable 0-4% range, still pretty
> >   respectable. It's not guaranteed though. While most machines showed some
> >   sort of gain, one ppc64 showed no difference at all.
> >
> > So, by and large it's an improvement of some sort.
> 
> Most of these benchmarks *really* need to be run quite a few times to get
> a reasonable confidence.
> 

Most are run repeatedly and an average taken but I should double check
what is going on. It's irritating that gains/regressions are
inconsistent between different machine types but that is nothing new.

> But it sounds pretty positive.
> ---
>  mm/page_alloc.c |   10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> Index: linux-2.6/mm/page_alloc.c
> ===================================================================
> --- linux-2.6.orig/mm/page_alloc.c
> +++ linux-2.6/mm/page_alloc.c
> @@ -420,7 +420,7 @@ static inline int page_is_buddy(struct p
>  		return 0;
>  
>  	if (PageBuddy(buddy) && page_order(buddy) == order) {
> -		BUG_ON(page_count(buddy) != 0);
> +		VM_BUG_ON(page_count(buddy) != 0);
>  		return 1;
>  	}
>  	return 0;
> @@ -493,9 +493,9 @@ static inline void __free_one_page(struc
>  static inline int free_pages_check(struct page *page)
>  {
>  	free_page_mlock(page);
> -	if (unlikely(page_mapcount(page) |
> +	if (unlikely((atomic_read(&page->_mapcount) != -1) |
>  		(page->mapping != NULL)  |
> -		(page_count(page) != 0)  |
> +		(atomic_read(&page->_count) != 0) |
>  		(page->flags & PAGE_FLAGS_CHECK_AT_FREE))) {
>  		bad_page(page);
>  		return 1;
> @@ -633,9 +633,9 @@ static inline void expand(struct zone *z
>   */
>  static int prep_new_page(struct page *page, int order, gfp_t gfp_flags)
>  {
> -	if (unlikely(page_mapcount(page) |
> +	if (unlikely((atomic_read(&page->_mapcount) != -1) |
>  		(page->mapping != NULL)  |
> -		(page_count(page) != 0)  |
> +		(atomic_read(&page->_count) != 0)  |
>  		(page->flags & PAGE_FLAGS_CHECK_AT_PREP))) {
>  		bad_page(page);
>  		return 1;
> 
-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
