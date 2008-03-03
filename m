Return-Path: <linux-kernel-owner+w=401wt.eu-S1761633AbYCCKYs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761633AbYCCKYs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 05:24:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755548AbYCCKYk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 05:24:40 -0500
Received: from gir.skynet.ie ([193.1.99.77]:55486 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754958AbYCCKYj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 05:24:39 -0500
Date: Mon, 3 Mar 2008 10:24:36 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: Christoph Lameter <clameter@sgi.com>
Cc: linux-kernel@vger.kernel.org, Nick Piggin <npiggin@suse.de>,
       Rik van Riel <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, apw@shadowen.org,
       linux-mm@kback.org
Subject: Re: [rfc 03/10] Pageflags: Convert to the use of new macros
Message-ID: <20080303102435.GD19485@csn.ul.ie>
References: <20080301040534.797979115@sgi.com> <20080301040620.520359881@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20080301040620.520359881@sgi.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (29/02/08 20:05), Christoph Lameter didst pronounce:
> Replace explicit definitions of page flags through the use of macros.
> Significantly reduces the size of the definitions and removes a lot of
> opportunity for errors. Additonal page flags can typically be generated
> with a single line.
> 
> Signed-off-by: Christoph Lameter <clameter@sgi.com>
> 
> ---
>  include/linux/page-flags.h |  188 ++++++++++++++-------------------------------
>  1 file changed, 61 insertions(+), 127 deletions(-)
> 
> Index: linux-2.6/include/linux/page-flags.h
> ===================================================================
> --- linux-2.6.orig/include/linux/page-flags.h	2008-02-29 19:15:28.000000000 -0800
> +++ linux-2.6/include/linux/page-flags.h	2008-02-29 19:20:03.000000000 -0800
> @@ -143,28 +143,51 @@ static inline int TestClearPage##uname(s
>  #define TESTSCFLAG(uname, lname)					\
>  			TESTSETFLAG(uname, lname) TESTCLEARFLAG(uname, lname)
>  
> +struct page;	/* forward declaration */
> +
> +PAGEFLAG(Locked, locked) TESTSCFLAG(Locked, locked)
> +PAGEFLAG(Error, error)
> +PAGEFLAG(Referenced, referenced) TESTCLEARFLAG(Referenced, referenced)
> +PAGEFLAG(Dirty, dirty) TESTSCFLAG(Dirty, dirty) __CLEARPAGEFLAG(Dirty, dirty)
> +PAGEFLAG(LRU, lru) __CLEARPAGEFLAG(LRU, lru)
> +PAGEFLAG(Active, active) __CLEARPAGEFLAG(Active, active)
> +__PAGEFLAG(Slab, slab)
> +PAGEFLAG(Checked, owner_priv_1)		/* Used by some filesystems */
> +PAGEFLAG(Pinned, owner_priv_1)		/* Xen pinned pagetable */

This is what I was on about earlier with some flag comments being in a
separate place. Someone grepping for PG_pinned to see what it is for
would have a bad day.

> +PAGEFLAG(Reserved, reserved) __CLEARPAGEFLAG(Reserved, reserved)
> +PAGEFLAG(Private, private) __CLEARPAGEFLAG(Private, private)
> +	__SETPAGEFLAG(Private, private)
> +
>  /*
> - * Manipulation of page state flags
> + * Only test-and-set exist for PG_writeback.  The unconditional operators are
> + * risky: they bypass page accounting.
>   */
> -#define PageLocked(page)		\
> -		test_bit(PG_locked, &(page)->flags)
> -#define SetPageLocked(page)		\
> -		set_bit(PG_locked, &(page)->flags)
> -#define TestSetPageLocked(page)		\
> -		test_and_set_bit(PG_locked, &(page)->flags)
> -#define ClearPageLocked(page)		\
> -		clear_bit(PG_locked, &(page)->flags)
> -#define TestClearPageLocked(page)	\
> -		test_and_clear_bit(PG_locked, &(page)->flags)
> -
> -#define PageError(page)		test_bit(PG_error, &(page)->flags)
> -#define SetPageError(page)	set_bit(PG_error, &(page)->flags)
> -#define ClearPageError(page)	clear_bit(PG_error, &(page)->flags)
> -
> -#define PageReferenced(page)	test_bit(PG_referenced, &(page)->flags)
> -#define SetPageReferenced(page)	set_bit(PG_referenced, &(page)->flags)
> -#define ClearPageReferenced(page)	clear_bit(PG_referenced, &(page)->flags)
> -#define TestClearPageReferenced(page) test_and_clear_bit(PG_referenced, &(page)->flags)
> +TESTPAGEFLAG(Writeback, writeback) TESTSCFLAG(Writeback, writeback)
> +__PAGEFLAG(Buddy, buddy)
> +PAGEFLAG(MappedToDisk, mappedtodisk)
> +
> +/* PG_readahead is only used for file reads; PG_reclaim is only for writes */
> +PAGEFLAG(Reclaim, reclaim) TESTCLEARFLAG(Reclaim, reclaim)
> +PAGEFLAG(Readahead, readahead)		/* Reminder to do async read-ahead */
> +
> +#ifdef CONFIG_HIGHMEM
> +#define PageHighMem(page)	is_highmem(page_zone(page))
> +#else
> +#define PageHighMem(page)	0 /* needed to optimize away at compile time */
> +#endif
> +

Seems to be a tiny inconsistency here. PageSwapCache below is a static
inline returning 0 that you fixed up as part of the shuffling where as
PageHighMem is #defined to 0. Care to fix it up too?

> +#ifdef CONFIG_SWAP
> +PAGEFLAG(SwapCache, swapcache)
> +#else
> +static inline int PageSwapCache(struct page *page)
> +{
> +	return 0;
> +}
> +#endif
> +
> +#if (BITS_PER_LONG > 32)
> +PAGEFLAG(Uncached, uncached)
> +#endif
>  
>  static inline int PageUptodate(struct page *page)
>  {
> @@ -212,97 +235,37 @@ static inline void SetPageUptodate(struc
>  #endif
>  }
>  
> -#define ClearPageUptodate(page)	clear_bit(PG_uptodate, &(page)->flags)
> +CLEARPAGEFLAG(Uptodate, uptodate)
>  
> -#define PageDirty(page)		test_bit(PG_dirty, &(page)->flags)
> -#define SetPageDirty(page)	set_bit(PG_dirty, &(page)->flags)
> -#define TestSetPageDirty(page)	test_and_set_bit(PG_dirty, &(page)->flags)
> -#define ClearPageDirty(page)	clear_bit(PG_dirty, &(page)->flags)
> -#define __ClearPageDirty(page)	__clear_bit(PG_dirty, &(page)->flags)
> -#define TestClearPageDirty(page) test_and_clear_bit(PG_dirty, &(page)->flags)
> -
> -#define PageLRU(page)		test_bit(PG_lru, &(page)->flags)
> -#define SetPageLRU(page)	set_bit(PG_lru, &(page)->flags)
> -#define ClearPageLRU(page)	clear_bit(PG_lru, &(page)->flags)
> -#define __ClearPageLRU(page)	__clear_bit(PG_lru, &(page)->flags)
> -
> -#define PageActive(page)	test_bit(PG_active, &(page)->flags)
> -#define SetPageActive(page)	set_bit(PG_active, &(page)->flags)
> -#define ClearPageActive(page)	clear_bit(PG_active, &(page)->flags)
> -#define __ClearPageActive(page)	__clear_bit(PG_active, &(page)->flags)
> -
> -#define PageSlab(page)		test_bit(PG_slab, &(page)->flags)
> -#define __SetPageSlab(page)	__set_bit(PG_slab, &(page)->flags)
> -#define __ClearPageSlab(page)	__clear_bit(PG_slab, &(page)->flags)
> +extern void cancel_dirty_page(struct page *page, unsigned int account_size);
>  
> -#ifdef CONFIG_HIGHMEM
> -#define PageHighMem(page)	is_highmem(page_zone(page))
> -#else
> -#define PageHighMem(page)	0 /* needed to optimize away at compile time */
> -#endif
> +int test_clear_page_writeback(struct page *page);
> +int test_set_page_writeback(struct page *page);
>  
> -#define PageChecked(page)	test_bit(PG_checked, &(page)->flags)
> -#define SetPageChecked(page)	set_bit(PG_checked, &(page)->flags)
> -#define ClearPageChecked(page)	clear_bit(PG_checked, &(page)->flags)
> -
> -#define PagePinned(page)	test_bit(PG_pinned, &(page)->flags)
> -#define SetPagePinned(page)	set_bit(PG_pinned, &(page)->flags)
> -#define ClearPagePinned(page)	clear_bit(PG_pinned, &(page)->flags)
> -
> -#define PageReserved(page)	test_bit(PG_reserved, &(page)->flags)
> -#define SetPageReserved(page)	set_bit(PG_reserved, &(page)->flags)
> -#define ClearPageReserved(page)	clear_bit(PG_reserved, &(page)->flags)
> -#define __ClearPageReserved(page)	__clear_bit(PG_reserved, &(page)->flags)
> -
> -#define SetPagePrivate(page)	set_bit(PG_private, &(page)->flags)
> -#define ClearPagePrivate(page)	clear_bit(PG_private, &(page)->flags)
> -#define PagePrivate(page)	test_bit(PG_private, &(page)->flags)
> -#define __SetPagePrivate(page)  __set_bit(PG_private, &(page)->flags)
> -#define __ClearPagePrivate(page) __clear_bit(PG_private, &(page)->flags)
> +static inline void set_page_writeback(struct page *page)
> +{
> +	test_set_page_writeback(page);
> +}

It's been around for ages and unrelated to your patch series but it
looks odd that set_page_writeback() is simply a function alias that
ignores return values :/

>  
> -/*
> - * Only test-and-set exist for PG_writeback.  The unconditional operators are
> - * risky: they bypass page accounting.
> - */
> -#define PageWriteback(page)	test_bit(PG_writeback, &(page)->flags)
> -#define TestSetPageWriteback(page) test_and_set_bit(PG_writeback,	\
> -							&(page)->flags)
> -#define TestClearPageWriteback(page) test_and_clear_bit(PG_writeback,	\
> -							&(page)->flags)
> -
> -#define PageBuddy(page)		test_bit(PG_buddy, &(page)->flags)
> -#define __SetPageBuddy(page)	__set_bit(PG_buddy, &(page)->flags)
> -#define __ClearPageBuddy(page)	__clear_bit(PG_buddy, &(page)->flags)
> -
> -#define PageMappedToDisk(page)	test_bit(PG_mappedtodisk, &(page)->flags)
> -#define SetPageMappedToDisk(page) set_bit(PG_mappedtodisk, &(page)->flags)
> -#define ClearPageMappedToDisk(page) clear_bit(PG_mappedtodisk, &(page)->flags)
> -
> -#define PageReadahead(page)	test_bit(PG_readahead, &(page)->flags)
> -#define SetPageReadahead(page)	set_bit(PG_readahead, &(page)->flags)
> -#define ClearPageReadahead(page) clear_bit(PG_readahead, &(page)->flags)
> -
> -#define PageReclaim(page)	test_bit(PG_reclaim, &(page)->flags)
> -#define SetPageReclaim(page)	set_bit(PG_reclaim, &(page)->flags)
> -#define ClearPageReclaim(page)	clear_bit(PG_reclaim, &(page)->flags)
> -#define TestClearPageReclaim(page) test_and_clear_bit(PG_reclaim, &(page)->flags)
> -
> -#define PageCompound(page)	test_bit(PG_compound, &(page)->flags)
> -#define __SetPageCompound(page)	__set_bit(PG_compound, &(page)->flags)
> -#define __ClearPageCompound(page) __clear_bit(PG_compound, &(page)->flags)
> +TESTPAGEFLAG(Compound, compound)
> +__PAGEFLAG(Head, compound)
>  
>  /*
>   * PG_reclaim is used in combination with PG_compound to mark the
> - * head and tail of a compound page
> + * head and tail of a compound page. This saves one page flag
> + * but makes it impossible to use compound pages for the page cache.
> + * The PG_reclaim bit would have to be used for reclaim or readahead
> + * if compound pages enter the page cache.
>   *
>   * PG_compound & PG_reclaim	=> Tail page
>   * PG_compound & ~PG_reclaim	=> Head page
>   */
> -
>  #define PG_head_tail_mask ((1L << PG_compound) | (1L << PG_reclaim))
>  
> -#define PageTail(page)	(((page)->flags & PG_head_tail_mask)	\
> -				== PG_head_tail_mask)
> +static inline int PageTail(struct page *page)
> +{
> +	return ((page->flags & PG_head_tail_mask) == PG_head_tail_mask);
> +}
>  
>  static inline void __SetPageTail(struct page *page)
>  {
> @@ -314,33 +277,4 @@ static inline void __ClearPageTail(struc
>  	page->flags &= ~PG_head_tail_mask;
>  }
>  
> -#define PageHead(page)	(((page)->flags & PG_head_tail_mask)	\
> -				== (1L << PG_compound))
> -#define __SetPageHead(page)	__SetPageCompound(page)
> -#define __ClearPageHead(page)	__ClearPageCompound(page)
> -
> -#ifdef CONFIG_SWAP
> -#define PageSwapCache(page)	test_bit(PG_swapcache, &(page)->flags)
> -#define SetPageSwapCache(page)	set_bit(PG_swapcache, &(page)->flags)
> -#define ClearPageSwapCache(page) clear_bit(PG_swapcache, &(page)->flags)
> -#else
> -#define PageSwapCache(page)	0
> -#endif
> -
> -#define PageUncached(page)	test_bit(PG_uncached, &(page)->flags)
> -#define SetPageUncached(page)	set_bit(PG_uncached, &(page)->flags)
> -#define ClearPageUncached(page)	clear_bit(PG_uncached, &(page)->flags)
> -
> -struct page;	/* forward declaration */
> -
> -extern void cancel_dirty_page(struct page *page, unsigned int account_size);
> -
> -int test_clear_page_writeback(struct page *page);
> -int test_set_page_writeback(struct page *page);
> -
> -static inline void set_page_writeback(struct page *page)
> -{
> -	test_set_page_writeback(page);
> -}
> -
>  #endif	/* PAGE_FLAGS_H */
> 
> -- 
> 

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
