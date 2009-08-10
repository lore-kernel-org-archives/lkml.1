Return-Path: <linux-kernel-owner+w=401wt.eu-S1755311AbZHJDV6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755311AbZHJDV6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Aug 2009 23:21:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754201AbZHJDV6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Aug 2009 23:21:58 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:51668 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753583AbZHJDV5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Aug 2009 23:21:57 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 10 Aug 2009 12:19:59 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [cleanup][2/2] mm: add_to_swap_cache() does not return -EEXIST
Message-Id: <20090810121959.5ed44d07.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090810112716.fb110c5a.nishimura@mxp.nes.nec.co.jp>
References: <20090810112326.3526b11d.nishimura@mxp.nes.nec.co.jp>
	<20090810112716.fb110c5a.nishimura@mxp.nes.nec.co.jp>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Aug 2009 11:27:16 +0900
Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp> wrote:

> After commit 355cfa73(mm: modify swap_map and add SWAP_HAS_CACHE flag),
> only the context which have set SWAP_HAS_CACHE flag by swapcache_prepare()
> or get_swap_page() would call add_to_swap_cache().
> So add_to_swap_cache() doesn't return -EEXIST any more.
> 
> Even though it doesn't return -EEXIST, it's not a good behavior conceptually
> to call swapcache_prepare() in -EEXIST case, because it means clearing
> SWAP_HAS_CACHE flag while the entry is on swap cache.
> 
> This patch removes redundant codes and comments from callers of it, and
> adds VM_BUG_ON() in error path of add_to_swap_cache() and some comments.
> 
> Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>

Nice! I've postponed this ;(
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

> ---
>  mm/shmem.c      |    4 +++
>  mm/swap_state.c |   75 +++++++++++++++++++++++++++----------------------------
>  2 files changed, 41 insertions(+), 38 deletions(-)
> 
> diff --git a/mm/shmem.c b/mm/shmem.c
> index d713239..c71ac6c 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -1097,6 +1097,10 @@ static int shmem_writepage(struct page *page, struct writeback_control *wbc)
>  	shmem_swp_unmap(entry);
>  unlock:
>  	spin_unlock(&info->lock);
> +	/*
> +	 * add_to_swap_cache() doesn't return -EEXIST, so we can safely
> +	 * clear SWAP_HAS_CACHE flag.
> +	 */
>  	swapcache_free(swap, NULL);
>  redirty:
>  	set_page_dirty(page);
> diff --git a/mm/swap_state.c b/mm/swap_state.c
> index 3e6dd72..e891208 100644
> --- a/mm/swap_state.c
> +++ b/mm/swap_state.c
> @@ -96,6 +96,12 @@ int add_to_swap_cache(struct page *page, swp_entry_t entry, gfp_t gfp_mask)
>  		radix_tree_preload_end();
>  
>  		if (unlikely(error)) {
> +			/*
> +			 * Only the context which have set SWAP_HAS_CACHE flag
> +			 * would call add_to_swap_cache().
> +			 * So add_to_swap_cache() doesn't returns -EEXIST.
> +			 */
> +			VM_BUG_ON(error == -EEXIST);
>  			set_page_private(page, 0UL);
>  			ClearPageSwapCache(page);
>  			page_cache_release(page);
> @@ -137,38 +143,34 @@ int add_to_swap(struct page *page)
>  	VM_BUG_ON(!PageLocked(page));
>  	VM_BUG_ON(!PageUptodate(page));
>  
> -	for (;;) {
> -		entry = get_swap_page();
> -		if (!entry.val)
> -			return 0;
> +	entry = get_swap_page();
> +	if (!entry.val)
> +		return 0;
>  
> +	/*
> +	 * Radix-tree node allocations from PF_MEMALLOC contexts could
> +	 * completely exhaust the page allocator. __GFP_NOMEMALLOC
> +	 * stops emergency reserves from being allocated.
> +	 *
> +	 * TODO: this could cause a theoretical memory reclaim
> +	 * deadlock in the swap out path.
> +	 */
> +	/*
> +	 * Add it to the swap cache and mark it dirty
> +	 */
> +	err = add_to_swap_cache(page, entry,
> +			__GFP_HIGH|__GFP_NOMEMALLOC|__GFP_NOWARN);
> +
> +	if (!err) {	/* Success */
> +		SetPageDirty(page);
> +		return 1;
> +	} else {	/* -ENOMEM radix-tree allocation failure */
>  		/*
> -		 * Radix-tree node allocations from PF_MEMALLOC contexts could
> -		 * completely exhaust the page allocator. __GFP_NOMEMALLOC
> -		 * stops emergency reserves from being allocated.
> -		 *
> -		 * TODO: this could cause a theoretical memory reclaim
> -		 * deadlock in the swap out path.
> -		 */
> -		/*
> -		 * Add it to the swap cache and mark it dirty
> +		 * add_to_swap_cache() doesn't return -EEXIST, so we can safely
> +		 * clear SWAP_HAS_CACHE flag.
>  		 */
> -		err = add_to_swap_cache(page, entry,
> -				__GFP_HIGH|__GFP_NOMEMALLOC|__GFP_NOWARN);
> -
> -		switch (err) {
> -		case 0:				/* Success */
> -			SetPageDirty(page);
> -			return 1;
> -		case -EEXIST:
> -			/* Raced with "speculative" read_swap_cache_async */
> -			swapcache_free(entry, NULL);
> -			continue;
> -		default:
> -			/* -ENOMEM radix-tree allocation failure */
> -			swapcache_free(entry, NULL);
> -			return 0;
> -		}
> +		swapcache_free(entry, NULL);
> +		return 0;
>  	}
>  }
>  
> @@ -298,14 +300,7 @@ struct page *read_swap_cache_async(swp_entry_t entry, gfp_t gfp_mask,
>  		if (err)           /* swp entry is obsolete ? */
>  			break;
>  
> -		/*
> -		 * Associate the page with swap entry in the swap cache.
> -		 * May fail (-EEXIST) if there is already a page associated
> -		 * with this entry in the swap cache: added by a racing
> -		 * read_swap_cache_async, or add_to_swap or shmem_writepage
> -		 * re-using the just freed swap entry for an existing page.
> -		 * May fail (-ENOMEM) if radix-tree node allocation failed.
> -		 */
> +		/* May fail (-ENOMEM) if radix-tree node allocation failed. */
>  		__set_page_locked(new_page);
>  		SetPageSwapBacked(new_page);
>  		err = add_to_swap_cache(new_page, entry, GFP_ATOMIC);
> @@ -319,6 +314,10 @@ struct page *read_swap_cache_async(swp_entry_t entry, gfp_t gfp_mask,
>  		}
>  		ClearPageSwapBacked(new_page);
>  		__clear_page_locked(new_page);
> +		/*
> +		 * add_to_swap_cache() doesn't return -EEXIST, so we can safely
> +		 * clear SWAP_HAS_CACHE flag.
> +		 */
>  		swapcache_free(entry, NULL);
>  	} while (err != -ENOMEM);
>  
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
> 

