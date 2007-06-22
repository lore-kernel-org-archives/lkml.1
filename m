Return-Path: <linux-kernel-owner+w=401wt.eu-S1757932AbXFVO5K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757932AbXFVO5K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 10:57:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753701AbXFVO46
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 10:56:58 -0400
Received: from waste.org ([66.93.16.53]:51766 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753647AbXFVO45 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 10:56:57 -0400
Date: Fri, 22 Jun 2007 09:56:35 -0500
From: Matt Mackall <mpm@selenic.com>
To: Yoshinori Sato <ysato@users.sourceforge.jp>,
       Nick Piggin <nickpiggin@yahoo.com.au>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] SLOB allocator imcompatible SLAB
Message-ID: <20070622145635.GX11115@waste.org>
References: <m2tzt01kew.wl%ysato@users.sourceforge.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m2tzt01kew.wl%ysato@users.sourceforge.jp>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 22, 2007 at 05:08:07PM +0900, Yoshinori Sato wrote:
> Because the page which SLOB allocator got does not have PG_slab,

This is for a NOMMU system?

You're using an old kernel with an old version of SLOB. SLOB in newer
kernels actually sets per-page flags. Nick, can you see any reason not
to s/PG_active/PG_slab/ in the current code?

> Signed-off-by: Yoshinori Sato <ysato@users.sourceforge.jp>
> 
> diff --git a/mm/slob.c b/mm/slob.c
> index 71976c5..d10bcda 100644
> --- a/mm/slob.c
> +++ b/mm/slob.c
> @@ -73,6 +73,21 @@ static DEFINE_SPINLOCK(block_lock);
>  static void slob_free(void *b, int size);
>  static void slob_timer_cbk(void);
>  
> +static inline void set_slabflags(const void *ptr, int order)
> +{
> +	int i;
> +	struct page *page = virt_to_page(ptr);
> +	for (i = 0; i < (1 << order); i++)
> +		__SetPageSlab(page++);
> +}
> +
> +static inline void clear_slabflags(const void *ptr, int order)
> +{
> +	int i;
> +	struct page *page = virt_to_page(ptr);
> +	for (i = 0; i < (1 << order); i++)
> +		__ClearPageSlab(page++);
> +}
>  
>  static void *slob_alloc(size_t size, gfp_t gfp, int align)
>  {
> @@ -180,6 +195,7 @@ void *__kmalloc(size_t size, gfp_t gfp)
>  	bb->pages = (void *)__get_free_pages(gfp, bb->order);
>  
>  	if (bb->pages) {
> +		set_slabflags(bb->pages, bb->order);
>  		spin_lock_irqsave(&block_lock, flags);
>  		bb->next = bigblocks;
>  		bigblocks = bb;
> @@ -240,6 +256,7 @@ void kfree(const void *block)
>  			if (bb->pages == block) {
>  				*last = bb->next;
>  				spin_unlock_irqrestore(&block_lock, flags);
> +				clear_slabflags(block, bb->order);
>  				free_pages((unsigned long)block, bb->order);
>  				slob_free(bb, sizeof(bigblock_t));
>  				return;
> @@ -323,9 +340,11 @@ void *kmem_cache_alloc(struct kmem_cache *c, gfp_t flags)
>  
>  	if (c->size < PAGE_SIZE)
>  		b = slob_alloc(c->size, flags, c->align);
> -	else
> +	else {
>  		b = (void *)__get_free_pages(flags, get_order(c->size));
> -
> +		if (b)
> +			set_slabflags(b, get_order(c->size));
> +	}
>  	if (c->ctor)
>  		c->ctor(b, c, 0);
>  
> @@ -347,8 +366,10 @@ static void __kmem_cache_free(void *b, int size)
>  {
>  	if (size < PAGE_SIZE)
>  		slob_free(b, size);
> -	else
> +	else {
> +		clear_slabflags(b, get_order(size));
>  		free_pages((unsigned long)b, get_order(size));
> +	}
>  }
>  
>  static void kmem_rcu_free(struct rcu_head *head)

-- 
Mathematics is the supreme nostalgia of our time.
