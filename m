Return-Path: <linux-kernel-owner+w=401wt.eu-S1755132AbXIZUHh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755132AbXIZUHh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 16:07:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760295AbXIZUHP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 16:07:15 -0400
Received: from smtp-out1.tiscali.nl ([195.241.79.176]:36977 "EHLO
	smtp-out1.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758577AbXIZUHO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 16:07:14 -0400
Message-ID: <46FABBEF.5000301@tiscali.nl>
Date: Wed, 26 Sep 2007 22:07:11 +0200
From: roel <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Matthew Wilcox <willy@linux.intel.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] Change dmapool free block management
References: <20070926185757.GM3899@parisc-linux.org> <1190833279354-git-send-email-willy@linux.intel.com>
In-Reply-To: <1190833279354-git-send-email-willy@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Wilcox wrote:

[...]

> @@ -113,9 +133,12 @@ struct dma_pool *dma_pool_create(const char *name, struct device *dev,
>  		return NULL;
>  	}
>  
> -	if (size == 0)
> +	if (size == 0) {
>  		return NULL;
> -
> +	} else if (size < 4) {
> +		size = 4;
> +	}

you could do without brackets

[...]

> @@ -263,34 +288,21 @@ void dma_pool_destroy(struct dma_pool *pool)
>   *
>   * This returns the kernel virtual address of a currently unused block,
>   * and reports its dma address through the handle.
> - * If such a memory block can't be allocated, null is returned.
> + * If such a memory block can't be allocated, %NULL is returned.
>   */
>  void *dma_pool_alloc(struct dma_pool *pool, gfp_t mem_flags,
>  		     dma_addr_t * handle)
>  {
>  	unsigned long flags;
>  	struct dma_page *page;
> -	int map, block;
>  	size_t offset;
>  	void *retval;
>  
>  	spin_lock_irqsave(&pool->lock, flags);
>   restart:
>  	list_for_each_entry(page, &pool->page_list, page_list) {
> -		int i;
> -		/* only cachable accesses here ... */
> -		for (map = 0, i = 0;
> -		     i < pool->blocks_per_page; i += BITS_PER_LONG, map++) {
> -			if (page->bitmap[map] == 0)
> -				continue;
> -			block = ffz(~page->bitmap[map]);
> -			if ((i + block) < pool->blocks_per_page) {
> -				clear_bit(block, &page->bitmap[map]);
> -				offset = (BITS_PER_LONG * map) + block;
> -				offset *= pool->size;
> -				goto ready;
> -			}
> -		}
> +		if (page->offset < pool->allocation)
> +			goto ready;
>  	}
>  	if (!(page = pool_alloc_page(pool, GFP_ATOMIC))) {

	page = pool_alloc_page(pool, GFP_ATOMIC);
	if(!page) {

[...]

> @@ -355,7 +366,7 @@ void dma_pool_free(struct dma_pool *pool, void *vaddr, dma_addr_t dma)
>  {
>  	struct dma_page *page;
>  	unsigned long flags;
> -	int map, block;
> +	unsigned int offset;
>  
>  	if ((page = pool_find_page(pool, dma)) == 0) {

	page = pool_find_page(pool, dma);
	if (page == 0) {

>  		if (pool->dev)
> @@ -368,13 +379,9 @@ void dma_pool_free(struct dma_pool *pool, void *vaddr, dma_addr_t dma)
>  		return;
>  	}
>  
> -	block = dma - page->dma;
> -	block /= pool->size;
> -	map = block / BITS_PER_LONG;
> -	block %= BITS_PER_LONG;
> -
> +	offset = vaddr - page->vaddr;
>  #ifdef	CONFIG_DEBUG_SLAB
> -	if (((dma - page->dma) + (void *)page->vaddr) != vaddr) {
> +	if ((dma - page->dma) != offset) {

	if (dma - page->dma != offset) {
[...]
