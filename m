Return-Path: <linux-kernel-owner+w=401wt.eu-S1755608AbXLSB4A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755608AbXLSB4A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 20:56:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753125AbXLSBzx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 20:55:53 -0500
Received: from mx1.suse.de ([195.135.220.2]:34706 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752826AbXLSBzw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 20:55:52 -0500
Date: Wed, 19 Dec 2007 02:55:50 +0100
From: Nick Piggin <npiggin@suse.de>
To: Hugh Dickins <hugh@veritas.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Christoph Rohland <hans-christoph.rohland@sap.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/9] tmpfs: shuffle add_to_swap_caches
Message-ID: <20071219015550.GA1389@wotan.suse.de>
References: <Pine.LNX.4.64.0712182144370.26235@blonde.wat.veritas.com> <Pine.LNX.4.64.0712182157480.27165@blonde.wat.veritas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0712182157480.27165@blonde.wat.veritas.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 18, 2007 at 09:59:22PM +0000, Hugh Dickins wrote:
> add_to_swap_cache doesn't amount to much: merge it into its sole caller
> read_swap_cache_async.  But we'll be needing to call __add_to_swap_cache
> from shmem.c, so promote it to the new add_to_swap_cache.  Both were
> static, so there's no interface confusion to worry about.
> 
> And lose that inappropriate "Anon pages are already on the LRU" comment
> in the merging: they're not already on the LRU, as Nick Piggin noticed.
> 
> Signed-off-by: Hugh Dickins <hugh@veritas.com>

No problems with me. Actually it is nice to make add_to_swap_cache
more closely match add_to_page_cache.


> 
>  mm/swap_state.c |   53 ++++++++++++++++------------------------------
>  1 file changed, 19 insertions(+), 34 deletions(-)
> 
> --- tmpfs1/mm/swap_state.c	2007-12-05 16:42:16.000000000 +0000
> +++ tmpfs2/mm/swap_state.c	2007-12-05 16:42:16.000000000 +0000
> @@ -64,10 +64,10 @@ void show_swap_cache_info(void)
>  }
>  
>  /*
> - * __add_to_swap_cache resembles add_to_page_cache on swapper_space,
> + * add_to_swap_cache resembles add_to_page_cache on swapper_space,
>   * but sets SwapCache flag and private instead of mapping and index.
>   */
> -static int __add_to_swap_cache(struct page *page, swp_entry_t entry,
> +static int add_to_swap_cache(struct page *page, swp_entry_t entry,
>  			       gfp_t gfp_mask)
>  {
>  	int error;
> @@ -94,28 +94,6 @@ static int __add_to_swap_cache(struct pa
>  	return error;
>  }
>  
> -static int add_to_swap_cache(struct page *page, swp_entry_t entry,
> -				gfp_t gfp_mask)
> -{
> -	int error;
> -
> -	BUG_ON(PageLocked(page));
> -	if (!swap_duplicate(entry))
> -		return -ENOENT;
> -
> -	SetPageLocked(page);
> -	error = __add_to_swap_cache(page, entry, gfp_mask & GFP_KERNEL);
> -	/*
> -	 * Anon pages are already on the LRU, we don't run lru_cache_add here.
> -	 */
> -	if (error) {
> -		ClearPageLocked(page);
> -		swap_free(entry);
> -		return error;
> -	}
> -	return 0;
> -}
> -
>  /*
>   * This must be called only on pages that have
>   * been verified to be in the swap cache.
> @@ -165,7 +143,7 @@ int add_to_swap(struct page * page, gfp_
>  		/*
>  		 * Add it to the swap cache and mark it dirty
>  		 */
> -		err = __add_to_swap_cache(page, entry,
> +		err = add_to_swap_cache(page, entry,
>  				gfp_mask|__GFP_NOMEMALLOC|__GFP_NOWARN);
>  
>  		switch (err) {
> @@ -210,7 +188,7 @@ void delete_from_swap_cache(struct page 
>   */
>  int move_to_swap_cache(struct page *page, swp_entry_t entry)
>  {
> -	int err = __add_to_swap_cache(page, entry, GFP_ATOMIC);
> +	int err = add_to_swap_cache(page, entry, GFP_ATOMIC);
>  	if (!err) {
>  		remove_from_page_cache(page);
>  		page_cache_release(page);	/* pagecache ref */
> @@ -335,16 +313,21 @@ struct page *read_swap_cache_async(swp_e
>  		}
>  
>  		/*
> +		 * Swap entry may have been freed since our caller observed it.
> +		 */
> +		if (!swap_duplicate(entry))
> +			break;
> +
> +		/*
>  		 * Associate the page with swap entry in the swap cache.
> -		 * May fail (-ENOENT) if swap entry has been freed since
> -		 * our caller observed it.  May fail (-EEXIST) if there
> -		 * is already a page associated with this entry in the
> -		 * swap cache: added by a racing read_swap_cache_async,
> -		 * or by try_to_swap_out (or shmem_writepage) re-using
> -		 * the just freed swap entry for an existing page.
> +		 * May fail (-EEXIST) if there is already a page associated
> +		 * with this entry in the swap cache: added by a racing
> +		 * read_swap_cache_async, or add_to_swap or shmem_writepage
> +		 * re-using the just freed swap entry for an existing page.
>  		 * May fail (-ENOMEM) if radix-tree node allocation failed.
>  		 */
> -		err = add_to_swap_cache(new_page, entry, gfp_mask);
> +		SetPageLocked(new_page);
> +		err = add_to_swap_cache(new_page, entry, gfp_mask & GFP_KERNEL);
>  		if (!err) {
>  			/*
>  			 * Initiate read into locked page and return.
> @@ -353,7 +336,9 @@ struct page *read_swap_cache_async(swp_e
>  			swap_readpage(NULL, new_page);
>  			return new_page;
>  		}
> -	} while (err != -ENOENT && err != -ENOMEM);
> +		ClearPageLocked(new_page);
> +		swap_free(entry);
> +	} while (err != -ENOMEM);
>  
>  	if (new_page)
>  		page_cache_release(new_page);
