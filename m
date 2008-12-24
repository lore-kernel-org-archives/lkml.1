Return-Path: <linux-kernel-owner+w=401wt.eu-S1751487AbYLXPpl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751487AbYLXPpl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2008 10:45:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752002AbYLXPpT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Dec 2008 10:45:19 -0500
Received: from cmpxchg.org ([85.214.51.133]:34491 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751959AbYLXPpR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2008 10:45:17 -0500
Date: Wed, 24 Dec 2008 16:45:02 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
       linux-kernel@vger.kernel.org
Subject: Re: [mmotm 2008-12-22-16-14] NULL pointer dereference in dma_alloc_from_coherent().
Message-ID: <20081224154502.GA6710@cmpxchg.org>
References: <200812240634.mBO6Y6ZY084756@www262.sakura.ne.jp> <20081223233705.21f1eaa4.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081223233705.21f1eaa4.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 23, 2008 at 11:37:05PM -0800, Andrew Morton wrote:
> On Wed, 24 Dec 2008 15:34:06 +0900 Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp> wrote:
> 
> > IP: [<c0159475>] dma_alloc_from_coherent+0x35/0xa0
> 
> Thanks.

I hope you don't have that one already!

> dma-coherent-catch-oversized-requests-to-dma_alloc_from_coherent.patch does
> 
> --- a/kernel/dma-coherent.c~dma-coherent-catch-oversized-requests-to-dma_alloc_from_coherent
> +++ a/kernel/dma-coherent.c
> @@ -112,6 +112,9 @@ int dma_alloc_from_coherent(struct devic
>  	struct dma_coherent_mem *mem = dev ? dev->dma_mem : NULL;
>  	int order = get_order(size);
>  
> +	if (unlikely(size > mem->size))
> +		return 0;
> +
>  	if (mem) {
>  		int page = bitmap_find_free_region(mem->bitmap, mem->size,
>  						     order);
> 
> which can plainly oops if dev==NULL or if dev->dma_mem=NULL.
> 
> That function is fairly stinky, so prior to altering it, let's clean it up:
> 
> From: Andrew Morton <akpm@linux-foundation.org>
> 
> This thing was rather stupidly coded.  Rework it all prior to making
> changes.
> 
> Also, rename local variable `page': kernel readers expect something called
> `page' to have type `struct page *'.
> 
> Cc: Guennadi Liakhovetski <lg@denx.de>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Pekka Enberg <penberg@cs.helsinki.fi>
> Cc: Dmitry Baryshkov <dbaryshkov@gmail.com>
> Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
> Cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  kernel/dma-coherent.c |   27 ++++++++++++++++-----------
>  1 file changed, 16 insertions(+), 11 deletions(-)
> 
> diff -puN kernel/dma-coherent.c~dma_alloc_coherent-clean-it-up kernel/dma-coherent.c
> --- a/kernel/dma-coherent.c~dma_alloc_coherent-clean-it-up
> +++ a/kernel/dma-coherent.c
> @@ -109,20 +109,25 @@ EXPORT_SYMBOL(dma_mark_declared_memory_o
>  int dma_alloc_from_coherent(struct device *dev, ssize_t size,
>  				       dma_addr_t *dma_handle, void **ret)
>  {
> -	struct dma_coherent_mem *mem = dev ? dev->dma_mem : NULL;
> +	struct dma_coherent_mem *mem;
>  	int order = get_order(size);
> +	int pageno;
> +
> +	if (!dev)
> +		return 0;
> +	mem = dev->dma_mem;
> +	if (!mem)
> +		return 0;
>  
> -	if (mem) {
> -		int page = bitmap_find_free_region(mem->bitmap, mem->size,
> -						     order);
> -		if (page >= 0) {
> -			*dma_handle = mem->device_base + (page << PAGE_SHIFT);
> -			*ret = mem->virt_base + (page << PAGE_SHIFT);
> -			memset(*ret, 0, size);
> -		} else if (mem->flags & DMA_MEMORY_EXCLUSIVE)
> -			*ret = NULL;
> +	pageno = bitmap_find_free_region(mem->bitmap, mem->size, order);
> +	if (pageno >= 0) {
> +		*dma_handle = mem->device_base + (pageno << PAGE_SHIFT);
> +		*ret = mem->virt_base + (pageno << PAGE_SHIFT);
> +		memset(*ret, 0, size);
> +	} else if (mem->flags & DMA_MEMORY_EXCLUSIVE) {
> +		*ret = NULL;
>  	}
> -	return (mem != NULL);
> +	return 1;
>  }
>  EXPORT_SYMBOL(dma_alloc_from_coherent);

Yep, looks much better.

> Then
> dma-coherent-catch-oversized-requests-to-dma_alloc_from_coherent.patch
> becomes:
> 
> --- a/kernel/dma-coherent.c~dma-coherent-catch-oversized-requests-to-dma_alloc_from_coherent
> +++ a/kernel/dma-coherent.c
> @@ -118,6 +118,8 @@ int dma_alloc_from_coherent(struct devic
>  	mem = dev->dma_mem;
>  	if (!mem)
>  		return 0;
> +	if (unlikely(size > mem->size))
> + 		return 0;
>  
>  	pageno = bitmap_find_free_region(mem->bitmap, mem->size, order);
>  	if (pageno >= 0) {
> _
> 

Great, thank you Andrew.  Sorry for the explosion :/

	Hannes
