Return-Path: <linux-kernel-owner+w=401wt.eu-S1752682AbZFTT06@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752682AbZFTT06 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jun 2009 15:26:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751337AbZFTT0v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Jun 2009 15:26:51 -0400
Received: from gir.skynet.ie ([193.1.99.77]:56852 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751509AbZFTT0v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jun 2009 15:26:51 -0400
Date: Sat, 20 Jun 2009 20:26:51 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>,
       Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org
Subject: Re: BUG] Strange oopses in 2.6.30
Message-ID: <20090620192651.GB10878@csn.ul.ie>
References: <1245448091.5475.19.camel@localhost> <1245506908.6327.36.camel@localhost> <Pine.LNX.4.64.0906201626270.5322@sister.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0906201626270.5322@sister.anvils>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 20, 2009 at 04:40:12PM +0100, Hugh Dickins wrote:
> On Sat, 20 Jun 2009, Maxim Levitsky wrote:
> > On Sat, 2009-06-20 at 00:48 +0300, Maxim Levitsky wrote:
> > > I see lots of following oopses in 2.6.30 and latest -git 
> > > 
> > > Many different applications shows up, not just reiserfsck
> > > Something in MM I guess, it makes me worry. But system seems to work.
> > > 
> > > Is this known?
> 
> I think so...
> 

Thanks Hugh.

> > > 
> > > dmesg attached.
> > > 
> > > 
> > > [   34.544040] BUG: Bad page state in process reiserfsck  pfn:37d86
> > > [   34.544044] page:c2a34f38 flags:3650000c count:0 mapcount:0
> > > mapping:(null) index:bffeb
> > > [   34.544048] Pid: 2654, comm: reiserfsck Tainted: G    B
> > > 2.6.30-git #4
> > > [   34.544051] Call Trace:
> > > [   34.544055]  [<c04cd26a>] ? printk+0x18/0x1e
> > > [   34.544059]  [<c018f065>] bad_page+0xd5/0x140
> > > [   34.544064]  [<c0190097>] free_hot_cold_page+0x1e7/0x280
> > > [   34.544069]  [<c0193682>] ? release_pages+0x92/0x1b0
> > > [   34.544074]  [<c0190155>] __pagevec_free+0x25/0x30
> > > [   34.544078]  [<c0193758>] release_pages+0x168/0x1b0
> > > [   34.544084]  [<c0193cf3>] ? lru_add_drain+0x53/0xd0
> > > [   34.544088]  [<c01ab7d4>] free_pages_and_swap_cache+0x84/0xa0
> > > [   34.544093]  [<c019ff5d>] unmap_vmas+0x73d/0x760
> > > [   34.544099]  [<c016480e>] ? lock_release_non_nested+0x15e/0x270
> > > [   34.544104]  [<c01a43b5>] exit_mmap+0xb5/0x1b0
> > > [   34.544109]  [<c0138666>] mmput+0x36/0xc0
> > > [   34.544113]  [<c013c874>] exit_mm+0xe4/0x120
> > > [   34.544117]  [<c0175539>] ? acct_collect+0x139/0x180
> > > [   34.544122]  [<c013e889>] do_exit+0x6b9/0x720
> > > [   34.544142]  [<c01bcac2>] ? vfs_write+0x122/0x180
> > > [   34.544146]  [<c01bbda0>] ? do_sync_write+0x0/0x110
> > > [   34.544151]  [<c013e920>] do_group_exit+0x30/0x90
> > > [   34.544156]  [<c013e993>] sys_exit_group+0x13/0x20
> > > [   34.544161]  [<c01039e8>] sysenter_do_call+0x12/0x3c
> > > [   34.544180] BUG: Bad page state in process reiserfsck  pfn:37d91
> > > [   34.544184] page:c2a35174 flags:3650000c count:0 mapcount:0
> > > mapping:(null) index:bfff6
> > > [   34.544188] Pid: 2654, comm: reiserfsck Tainted: G    B
> > > 2.6.30-git #4
> > > 
> > 
> > This really worries me
> 
> I hope it's fixed by this patch Hannes posted yesterday...
> 

Does the patch fix the problem up?

> From hannes@cmpxchg.org Fri Jun 19 19:04:49 2009
> Date: Fri, 19 Jun 2009 19:45:02 +0200
> From: Johannes Weiner <hannes@cmpxchg.org>
> To: Peter Chubb <peter.chubb@nicta.com.au>
> Cc:  <linux-kernel@vger.kernel.org>,  <mel@csn.ul.ie>,  <akpm@linux-foundation.org>
> Subject: Re: [BUG] Bad page flags when process using mlock()ed memory exits
> 
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
> ---
> >From 493b74e8615db4e3323b5b169b0b8265dfd7c3f4 Mon Sep 17 00:00:00 2001
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

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
