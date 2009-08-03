Return-Path: <linux-kernel-owner+w=401wt.eu-S1753401AbZHCU6A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753401AbZHCU6A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 16:58:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753083AbZHCU5y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 16:57:54 -0400
Received: from cobra.newdream.net ([66.33.216.30]:52205 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752888AbZHCU5x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 16:57:53 -0400
Date: Mon, 3 Aug 2009 13:57:54 -0700 (PDT)
From: Sage Weil <sage@newdream.net>
To: linux-kernel@vger.kernel.org
cc: linux-mm@kvack.org
Subject: Re: [PATCH] mm: remove broken 'kzalloc' mempool
In-Reply-To: <1249332888-13440-3-git-send-email-sage@newdream.net>
Message-ID: <Pine.LNX.4.64.0908031356170.7580@cobra.newdream.net>
References: <1249332888-13440-1-git-send-email-sage@newdream.net>
 <1249332888-13440-2-git-send-email-sage@newdream.net>
 <1249332888-13440-3-git-send-email-sage@newdream.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 Aug 2009, Sage Weil wrote:
> The kzalloc mempool zeros items when they are initially allocated, but
> does not rezero used items that are returned to the pool.  Consequently
> mempool_alloc()s may return non-zeroed memory.
> 
> Since there are/were only two in-tree users for mempool_create_kzalloc_pool(),
> and 'fixing' this in a way that will re-zero used (but not new) items
> before first use is non-trivial, just remove it.

This should of course only be applied after the fixes for the two callers 
(dm multipath and ibmvscsi), whatever the protocol for order that may 
be...

sage


> 
> CC: <linux-mm@kvack.org>
> Signed-off-by: Sage Weil <sage@newdream.net>
> ---
>  include/linux/mempool.h |   10 ++--------
>  mm/mempool.c            |    7 -------
>  2 files changed, 2 insertions(+), 15 deletions(-)
> 
> diff --git a/include/linux/mempool.h b/include/linux/mempool.h
> index 9be484d..7c08052 100644
> --- a/include/linux/mempool.h
> +++ b/include/linux/mempool.h
> @@ -47,22 +47,16 @@ mempool_create_slab_pool(int min_nr, struct kmem_cache *kc)
>  }
>  
>  /*
> - * 2 mempool_alloc_t's and a mempool_free_t to kmalloc/kzalloc and kfree
> - * the amount of memory specified by pool_data
> + * a mempool_alloc_t and a mempool_free_t to kmalloc and kfree the
> + * amount of memory specified by pool_data
>   */
>  void *mempool_kmalloc(gfp_t gfp_mask, void *pool_data);
> -void *mempool_kzalloc(gfp_t gfp_mask, void *pool_data);
>  void mempool_kfree(void *element, void *pool_data);
>  static inline mempool_t *mempool_create_kmalloc_pool(int min_nr, size_t size)
>  {
>  	return mempool_create(min_nr, mempool_kmalloc, mempool_kfree,
>  			      (void *) size);
>  }
> -static inline mempool_t *mempool_create_kzalloc_pool(int min_nr, size_t size)
> -{
> -	return mempool_create(min_nr, mempool_kzalloc, mempool_kfree,
> -			      (void *) size);
> -}
>  
>  /*
>   * A mempool_alloc_t and mempool_free_t for a simple page allocator that
> diff --git a/mm/mempool.c b/mm/mempool.c
> index a46eb1b..eea4f7d 100644
> --- a/mm/mempool.c
> +++ b/mm/mempool.c
> @@ -308,13 +308,6 @@ void *mempool_kmalloc(gfp_t gfp_mask, void *pool_data)
>  }
>  EXPORT_SYMBOL(mempool_kmalloc);
>  
> -void *mempool_kzalloc(gfp_t gfp_mask, void *pool_data)
> -{
> -	size_t size = (size_t) pool_data;
> -	return kzalloc(size, gfp_mask);
> -}
> -EXPORT_SYMBOL(mempool_kzalloc);
> -
>  void mempool_kfree(void *element, void *pool_data)
>  {
>  	kfree(element);
> -- 
> 1.5.6.5
> 
> 
