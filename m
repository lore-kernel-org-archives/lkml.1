Return-Path: <linux-kernel-owner+w=401wt.eu-S1756746AbYFGBFj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756746AbYFGBFj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 21:05:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755505AbYFGBFP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 21:05:15 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44809 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754017AbYFGBFF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 21:05:05 -0400
Date: Fri, 6 Jun 2008 18:04:34 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Rik van Riel <riel@redhat.com>
Cc: linux-kernel@vger.kernel.org, lee.schermerhorn@hp.com,
       kosaki.motohiro@jp.fujitsu.com, minchan.kim@gmail.com
Subject: Re: [PATCH -mm 05/25] define page_file_cache() function
Message-Id: <20080606180434.f9558bab.akpm@linux-foundation.org>
In-Reply-To: <20080606202858.624305330@redhat.com>
References: <20080606202838.390050172@redhat.com>
	<20080606202858.624305330@redhat.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 06 Jun 2008 16:28:43 -0400
Rik van Riel <riel@redhat.com> wrote:

> From: Rik van Riel <riel@redhat.com>
> 
> Define page_file_cache() function to answer the question:
> 	is page backed by a file?
> 
> Originally part of Rik van Riel's split-lru patch.  Extracted
> to make available for other, independent reclaim patches.
> 
> Moved inline function to linux/mm_inline.h where it will
> be needed by subsequent "split LRU" and "noreclaim" patches.  
> 
> Unfortunately this needs to use a page flag, since the
> PG_swapbacked state needs to be preserved all the way
> to the point where the page is last removed from the
> LRU.  Trying to derive the status from other info in
> the page resulted in wrong VM statistics in earlier
> split VM patchsets.
>

argh.  How many are left?

> +#ifndef LINUX_MM_INLINE_H
> +#define LINUX_MM_INLINE_H
> +
> +/**
> + * page_file_cache - should the page be on a file LRU or anon LRU?
> + * @page: the page to test
> + *
> + * Returns !0 if @page is page cache page backed by a regular filesystem,
> + * or 0 if @page is anonymous, tmpfs or otherwise ram or swap backed.
> + *
> + * We would like to get this info without a page flag, but the state
> + * needs to survive until the page is last deleted from the LRU, which
> + * could be as far down as __page_cache_release.
> + */
> +static inline int page_file_cache(struct page *page)
> +{
> +	if (PageSwapBacked(page))
> +		return 0;
> +
> +	/* The page is page cache backed by a normal filesystem. */
> +	return 2;

2?

Maybe bool would suit here.

Maybe a better name would be page_is_file_cache().  The gnu (gcc?)
convention of putting _p at the end of predicate functions' names makes
heaps of sense.


This function doesn't do enough stuff to do that which it says it does.
There must be a whole pile of preconditions which the caller must
evaluate before this function can be usefully used.  I mean, it would
be a bug to pass an anonymous page or a slab page or whatever into
here?

> +}
> +
>
> ...
>
> --- linux-2.6.26-rc2-mm1.orig/include/linux/page-flags.h	2008-05-23 14:21:21.000000000 -0400
> +++ linux-2.6.26-rc2-mm1/include/linux/page-flags.h	2008-05-23 14:21:34.000000000 -0400
> @@ -93,6 +93,7 @@ enum pageflags {
>  	PG_mappedtodisk,	/* Has blocks allocated on-disk */
>  	PG_reclaim,		/* To be reclaimed asap */
>  	PG_buddy,		/* Page is free, on buddy lists */
> +	PG_swapbacked,		/* Page is backed by RAM/swap */
>  #ifdef CONFIG_IA64_UNCACHED_ALLOCATOR
>  	PG_uncached,		/* Page has been mapped as uncached */
>  #endif
> @@ -160,6 +161,7 @@ PAGEFLAG(Pinned, owner_priv_1) TESTSCFLA
>  PAGEFLAG(Reserved, reserved) __CLEARPAGEFLAG(Reserved, reserved)
>  PAGEFLAG(Private, private) __CLEARPAGEFLAG(Private, private)
>  	__SETPAGEFLAG(Private, private)
> +PAGEFLAG(SwapBacked, swapbacked) __CLEARPAGEFLAG(SwapBacked, swapbacked)

Those __ClearPageFoo() functions scare my pants into the next suburb. 
They can cause such horridly subtle bugs if misused.  Every single
callsite should have special attention and careful justification in
comments, IMO.

>  /*
>   * Only test-and-set exist for PG_writeback.  The unconditional operators are
> Index: linux-2.6.26-rc2-mm1/mm/memory.c
> ===================================================================
> --- linux-2.6.26-rc2-mm1.orig/mm/memory.c	2008-05-23 14:21:21.000000000 -0400
> +++ linux-2.6.26-rc2-mm1/mm/memory.c	2008-05-23 14:21:34.000000000 -0400
> @@ -1765,6 +1765,7 @@ gotten:
>  		ptep_clear_flush(vma, address, page_table);
>  		set_pte_at(mm, address, page_table, entry);
>  		update_mmu_cache(vma, address, entry);
> +		SetPageSwapBacked(new_page);
>  		lru_cache_add_active(new_page);
>  		page_add_new_anon_rmap(new_page, vma, address);
>  
> @@ -2233,6 +2234,7 @@ static int do_anonymous_page(struct mm_s
>  	if (!pte_none(*page_table))
>  		goto release;
>  	inc_mm_counter(mm, anon_rss);
> +	SetPageSwapBacked(page);
>  	lru_cache_add_active(page);
>  	page_add_new_anon_rmap(page, vma, address);
>  	set_pte_at(mm, address, page_table, entry);
> @@ -2374,6 +2376,7 @@ static int __do_fault(struct mm_struct *
>  		set_pte_at(mm, address, page_table, entry);
>  		if (anon) {
>                          inc_mm_counter(mm, anon_rss);
> +			SetPageSwapBacked(page);
>                          lru_cache_add_active(page);
>                          page_add_new_anon_rmap(page, vma, address);

OK, someone lost their tab key and it wasn't you.

<does git-blame>

<blames Nick>

>  		} else {
>
> ...
>
> @@ -261,6 +261,7 @@ static void bad_page(struct page *page)
>  			1 << PG_slab    |
>  			1 << PG_swapcache |
>  			1 << PG_writeback |
> +			1 << PG_swapbacked |
>  			1 << PG_buddy );
>  	set_page_count(page, 0);
>  	reset_page_mapcount(page);
> @@ -494,6 +495,8 @@ static inline int free_pages_check(struc
>  		bad_page(page);
>  	if (PageDirty(page))
>  		__ClearPageDirty(page);
> +	if (PageSwapBacked(page))
> +		__ClearPageSwapBacked(page);

OK, that one isn't so scary.

>  	/*
>  	 * For now, we report if PG_reserved was found set, but do not
>  	 * clear it, and do not free the page.  But we shall soon need
> @@ -644,6 +647,7 @@ static int prep_new_page(struct page *pa
>  			1 << PG_swapcache |
>  			1 << PG_writeback |
>  			1 << PG_reserved |
> +			1 << PG_swapbacked |
>  			1 << PG_buddy ))))
>  		bad_page(page);

