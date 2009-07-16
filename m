Return-Path: <linux-kernel-owner+w=401wt.eu-S933593AbZGPXXT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933593AbZGPXXT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 19:23:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933580AbZGPXXS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 19:23:18 -0400
Received: from mx2.redhat.com ([66.187.237.31]:51403 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933574AbZGPXXR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 19:23:17 -0400
Subject: Re: [PATCH] ttm: add pool wc/uc page allocator
From: Dave Airlie <airlied@redhat.com>
To: Jerome Glisse <jglisse@redhat.com>
Cc: airlied@gmail.com, dri-devel@lists.sf.net, linux-kernel@vger.kernel.org
In-Reply-To: <1247760821-12122-1-git-send-email-jglisse@redhat.com>
References: <1247760821-12122-1-git-send-email-jglisse@redhat.com>
Content-Type: text/plain
Date: Fri, 17 Jul 2009 09:23:05 +1000
Message-Id: <1247786585.3572.5.camel@clockmaker.usersys.redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-07-16 at 18:13 +0200, Jerome Glisse wrote:
> On AGP system we might allocate/free routinely uncached or wc memory,
> changing page from cached (wb) to uc or wc is very expensive and involves
> a lot of flushing. To improve performance this allocator use a pool
> of uc,wc pages.
> 
> Currently each pool (wc, uc) is 256 pages big, improvement would be
> to tweak this according to memory pressure so we can give back memory
> to system.
> 
> Signed-off-by: Dave Airlie <airlied@redhat.com>
> Signed-off-by: Jerome Glisse <jglisse@redhat.com>
> ---
>  drivers/gpu/drm/ttm/Makefile         |    2 +-
>  drivers/gpu/drm/ttm/ttm_memory.c     |    3 +
>  drivers/gpu/drm/ttm/ttm_page_alloc.c |  342 ++++++++++++++++++++++++++++++++++
>  drivers/gpu/drm/ttm/ttm_page_alloc.h |   36 ++++
>  drivers/gpu/drm/ttm/ttm_tt.c         |   32 +---
>  5 files changed, 391 insertions(+), 24 deletions(-)
>  create mode 100644 drivers/gpu/drm/ttm/ttm_page_alloc.c
>  create mode 100644 drivers/gpu/drm/ttm/ttm_page_alloc.h

> +
> +
> +#ifdef CONFIG_X86
> +/* TODO: add this to x86 like _uc, this version here is inefficient */
> +static int set_pages_array_wc(struct page **pages, int addrinarray)
> +{
> +	int i;
> +
> +	for (i = 0; i < addrinarray; i++) {
> +		set_memory_wc((unsigned long)page_address(pages[i]), 1);
> +	}
> +	return 0;
> +}
> +#else
> +static int set_pages_array_wb(struct page **pages, int addrinarray)
> +{
> +#ifdef TTM_HAS_AGP
> +	int i;
> +
> +	for (i = 0; i < addrinarray; i++) {
> +		unmap_page_from_agp(pages[i]);
> +	}
> +#endif
> +	return 0;
> +}
> +
> +static int set_pages_array_wc(struct page **pages, int addrinarray)
> +{
> +#ifdef TTM_HAS_AGP
> +	int i;
> +
> +	for (i = 0; i < addrinarray; i++) {
> +		map_page_into_agp(pages[i]);
> +	}
> +#endif
> +	return 0;
> +}
> +
> +static int set_pages_array_uc(struct page **pages, int addrinarray)
> +{
> +#ifdef TTM_HAS_AGP
> +	int i;
> +
> +	for (i = 0; i < addrinarray; i++) {
> +		map_page_into_agp(pages[i]);
> +	}
> +#endif
> +	return 0;
> +}
> +#endif
> +
> +
> +void pages_free_locked(void)
> +{
> +	int i;
> +
> +	set_pages_array_wb(_pages, _npages_to_free);
> +	for (i = 0; i < _npages_to_free; i++) {
> +		__free_page(_pages[i]);
> +	}
> +	_npages_to_free = 0;
> +}
> +
> +static void ttm_page_pool_init_locked(struct page_pool *pool)
> +{
> +	INIT_LIST_HEAD(&pool->list);
> +	pool->npages = 0;	
> +}
> +
> +static int page_pool_fill_locked(struct page_pool *pool,
> +				enum ttm_caching_state cstate)
> +{
> +	struct page *page;
> +	int i, cpages;
> +
> +	/* We need the _pages table to change page cache status so empty it */
> +	if (cstate != tt_cached && _npages_to_free)
> +		pages_free_locked();
> +
> +	for (i = 0, cpages = 0; i < (NUM_PAGES_TO_ADD - pool->npages); i++) {
> +		page = alloc_page(pool->gfp_flags);
> +		if (!page) {
> +			printk(KERN_ERR "unable to get page %d\n", i);
> +			return -ENOMEM;
> +		}
> +#ifdef CONFIG_X86
> +		/* gfp flags of highmem page should never be dma32 so we
> +		 * we should be fine in such case
> +		 */
> +		if (PageHighMem(page)) {
> +			if (pool->gfp_flags & GFP_DMA32) {
> +				list_add(&page->lru, &_hm_pool_dma32.list);
> +				_hm_pool_dma32.npages++;
> +			} else {
> +				list_add(&page->lru, &_hm_pool.list);
> +				_hm_pool.npages++;
> +			}
> +		} else
> +#endif
> +		{
> +			list_add(&page->lru, &pool->list);
> +			pool->npages++;
> +			_pages[i] = page;
> +			cpages++;
> +		}
> +	}
> +	switch(cstate) {
> +	case tt_uncached:
> +		set_pages_array_uc(_pages, cpages);
> +		break;
> +	case tt_wc:
> +		set_pages_array_wc(_pages, cpages);
> +		break;
> +	case tt_cached:
> +	default:
> +		break;
> +	}
> +	return 0;
> +}
> +
> +static inline void ttm_page_put_locked(struct page *page)
> +{
> +	if (_npages_to_free >= NUM_PAGES_TO_ADD)
> +		pages_free_locked();
> +	_pages[_npages_to_free++] = page;
> +}
> +
> +static void ttm_page_pool_empty_locked(struct page_pool *pool, bool hm)
> +{
> +	struct page *page, *tmp;
> +
> +	if (hm) {
> +		list_for_each_entry_safe(page, tmp, &pool->list, lru) {
> +			list_del(&page->lru);
> +			__free_page(page);
> +		}
> +	} else {
> +		list_for_each_entry_safe(page, tmp, &pool->list, lru) {
> +			list_del(&page->lru);
> +			ttm_page_put_locked(page);
> +		}
> +	}
> +	pool->npages = 0;
> +}
> +
> +
> +struct page *ttm_get_page(int flags, enum ttm_caching_state cstate)
> +{
> +	struct page_pool *pool;
> +	struct page_pool *hm_pool;
> +	struct page *page = NULL;
> +	int gfp_flags = GFP_HIGHUSER;
> +	int r;
> +
> +	hm_pool = &_hm_pool;
> +	if (flags & TTM_PAGE_FLAG_ZERO_ALLOC)
> +		gfp_flags |= __GFP_ZERO;
> +	if (flags & TTM_PAGE_FLAG_DMA32) {
> +		gfp_flags |= GFP_DMA32;
> +		hm_pool = &_hm_pool_dma32;
> +	}

You remove my dma32 changes from my tree to fix this.
>  
> -static struct page *ttm_tt_alloc_page(unsigned page_flags)
> -{
> -	gfp_t gfp_flags = GFP_USER;
> -
> -	if (page_flags & TTM_PAGE_FLAG_ZERO_ALLOC)
> -		gfp_flags |= __GFP_ZERO;
> -
> -	if (page_flags & TTM_PAGE_FLAG_DMA32)
> -		gfp_flags |= __GFP_DMA32;
> -	else
> -		gfp_flags |= __GFP_HIGHMEM;
> -
> -	return alloc_page(gfp_flags);
> -}

Note the differences? you can't say HIGHMEM and DMA32 as the
kernel points out with CONFIG_DEBUG_VM.

Dave.

