Return-Path: <linux-kernel-owner+w=401wt.eu-S1752654AbZFTT0S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752654AbZFTT0S (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jun 2009 15:26:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751337AbZFTT0K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Jun 2009 15:26:10 -0400
Received: from gir.skynet.ie ([193.1.99.77]:55164 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751509AbZFTT0J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jun 2009 15:26:09 -0400
Date: Sat, 20 Jun 2009 20:26:08 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Peter Chubb <peter.chubb@nicta.com.au>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [BUG] Bad page flags when process using mlock()ed memory exits
Message-ID: <20090620192608.GA10878@csn.ul.ie>
References: <87y6ro6exi.wl%peter@chubb.wattle.id.au> <20090619174502.GA2477@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20090619174502.GA2477@cmpxchg.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 19, 2009 at 07:45:02PM +0200, Johannes Weiner wrote:
> On Fri, Jun 19, 2009 at 02:11:21PM +1000, Peter Chubb wrote:
> > 
> > In recent kernels I've been seeing many mesages of the form:
> > 
> > BUG: Bad page state in process reiserfsck  pfn:79c58
> > page:c3d03b00 flags:8050000c count:0 mapcount:0 mapping:(null) index:8095
> > Pid: 3927, comm: reiserfsck Not tainted 2.6.30-test-05456-gda456f1 #60
> > Call Trace:
> >  [<c134a67c>] ? printk+0xf/0x13
> >  [<c10774dc>] bad_page+0xc9/0xe2
> >  [<c1078041>] free_hot_cold_page+0x5c/0x204
> >  [<c1078206>] __pagevec_free+0x1d/0x25
> >  [<c107ac3e>] release_pages+0x14e/0x18e)
> >  [<c108ef8a>] free_pages_and_swap_cache+0x69/0x82
> >  [<c1089458>] exit_mmap+0xf6/0x11f
> >  [<c102afcd>] mmput+0x39/0xaf
> >  [<c102e534>] exit_mm+0xe5/0xed
> >  [<c102fa66>] do_exit+0x13f/0x578
> >  [<c102fefd>] do_group_exit+0x5e/0x85
> >  [<c102ff37>] sys_exit_group+0x13/0x17
> >  [<c10031ef>] sysenter_do_call+0x12/0x3c
> > Disabling lock debugging due to kernel taint
> > 
> > This appears to have been introduced by patch 
> >     da456f14d2f2d7350f2b9440af79c85a34c7eed5
> >     page allocator: do not disable interrupts in free_page_mlock()
> > 
> > That patch removed the free_page_mlock() from free_pages_check(), so
> > if free_hot_cold_page() is called on an Mlocked page (e.g., if a
> > process that used mlock() calls exit()) free_pages_check() will always
> > barf, whereas before it would just unlock the page.
> 
> I prepared a fix, thanks for chasing it down.
> 
> Mel, to keep this simple I just used the atomic test-clear, but if I
> am not mistaken we should not need any atomicity here, so we could
> probably add a __TestClearPage version and use this instead...?
> 

It should not need to be atomic as there should be no other user of the
page. If __TestClearPage existed, it would be usable here.

> ---
> From 493b74e8615db4e3323b5b169b0b8265dfd7c3f4 Mon Sep 17 00:00:00 2001
> From: Johannes Weiner <hannes@cmpxchg.org>
> Date: Fri, 19 Jun 2009 19:30:56 +0200
> Subject: [patch] mm: page_alloc: clear PG_locked before checking flags on free
> 
> da456f1 "page allocator: do not disable interrupts in free_page_mlock()" moved
> the PG_mlocked clearing after the flag sanity checking which makes mlocked
> pages always trigger 'bad page'.  Fix this by clearing the bit up front.
> 
> Reported-by: Peter Chubb <peter.chubb@nicta.com.au>
> Debugged-by: Peter Chubb <peter.chubb@nicta.com.au>
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Mel Gorman <mel@csn.ul.ie>

The patch looks ok and I see no problem with clearing the bit without
disabling interrupts. The disabling of interrupts was for updating the
counters so;

Acked-by: Mel Gorman <mel@csn.ul.ie>

Thanks Peter for catching this and thanks Johannes for fixing it up.

My apologies for the long delay in responding. I was offline for two days
at a conference. I thought I would have internet access but no such luck. Am
playing catch-up now in a rush.

> ---
>  mm/page_alloc.c |    9 ++++-----
>  1 files changed, 4 insertions(+), 5 deletions(-)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 6f0753f..30d5093 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -488,7 +488,6 @@ static inline void __free_one_page(struct page *page,
>   */
>  static inline void free_page_mlock(struct page *page)
>  {
> -	__ClearPageMlocked(page);
>  	__dec_zone_page_state(page, NR_MLOCK);
>  	__count_vm_event(UNEVICTABLE_MLOCKFREED);
>  }
> @@ -558,7 +557,7 @@ static void __free_pages_ok(struct page *page, unsigned int order)
>  	unsigned long flags;
>  	int i;
>  	int bad = 0;
> -	int clearMlocked = PageMlocked(page);
> +	int wasMlocked = TestClearPageMlocked(page);
>  
>  	kmemcheck_free_shadow(page, order);
>  
> @@ -576,7 +575,7 @@ static void __free_pages_ok(struct page *page, unsigned int order)
>  	kernel_map_pages(page, 1 << order, 0);
>  
>  	local_irq_save(flags);
> -	if (unlikely(clearMlocked))
> +	if (unlikely(wasMlocked))
>  		free_page_mlock(page);
>  	__count_vm_events(PGFREE, 1 << order);
>  	free_one_page(page_zone(page), page, order,
> @@ -1022,7 +1021,7 @@ static void free_hot_cold_page(struct page *page, int cold)
>  	struct zone *zone = page_zone(page);
>  	struct per_cpu_pages *pcp;
>  	unsigned long flags;
> -	int clearMlocked = PageMlocked(page);
> +	int wasMlocked = TestClearPageMlocked(page);
>  
>  	kmemcheck_free_shadow(page, 0);
>  
> @@ -1041,7 +1040,7 @@ static void free_hot_cold_page(struct page *page, int cold)
>  	pcp = &zone_pcp(zone, get_cpu())->pcp;
>  	set_page_private(page, get_pageblock_migratetype(page));
>  	local_irq_save(flags);
> -	if (unlikely(clearMlocked))
> +	if (unlikely(wasMlocked))
>  		free_page_mlock(page);
>  	__count_vm_event(PGFREE);
>  
> -- 
> 1.6.3
> 
> 
> 

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
