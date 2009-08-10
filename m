Return-Path: <linux-kernel-owner+w=401wt.eu-S1755293AbZHJDSj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755293AbZHJDSj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Aug 2009 23:18:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753740AbZHJDSj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Aug 2009 23:18:39 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:51604 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753035AbZHJDSi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Aug 2009 23:18:38 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 10 Aug 2009 12:16:44 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [BUGFIX][1/2] mm: add_to_swap_cache() must not sleep
Message-Id: <20090810121644.6fe466f9.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090810112641.02e1db72.nishimura@mxp.nes.nec.co.jp>
References: <20090810112326.3526b11d.nishimura@mxp.nes.nec.co.jp>
	<20090810112641.02e1db72.nishimura@mxp.nes.nec.co.jp>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Aug 2009 11:26:41 +0900
Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp> wrote:

> After commit 355cfa73(mm: modify swap_map and add SWAP_HAS_CACHE flag),
> read_swap_cache_async() will busy-wait while a entry doesn't on swap cache
> but it has SWAP_HAS_CACHE flag.
> 
> Such entries can exist on add/delete path of swap cache.
> On add path, add_to_swap_cache() is called soon after SWAP_HAS_CACHE flag
> is set, and on delete path, swapcache_free() will be called (SWAP_HAS_CACHE
> flag is cleared) soon after __delete_from_swap_cache() is called.
> So, the busy-wait works well in most cases.
> 
yes.

> But this mechanism can cause soft lockup if add_to_swap_cache() sleeps
> and read_swap_cache_async() tries to swap-in the same entry on the same cpu.
> 
Hmm..

> add_to_swap() and shmem_writepage() call add_to_swap_cache() w/o __GFP_WAIT,
> but read_swap_cache_async() can call it w/ __GFP_WAIT, so it can cause
> soft lockup.
> 
> This patch changes the gfp_mask of add_to_swap_cache() in read_swap_cache_async().
> 
> Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>

Thank you for catching.
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

But Hm...I wonder whether this is the best fix.

If I was you, I may do following.

  1. remove radix_tree_preload() and gfp_mask from add_to_swapcache().
     Then, rename it fo __add_to_swapcache().
     Or, move swap_duplicate() into add_to_swapcache() with a new flag.

  2. do things in following order.

	radix_tree_peload();
	swap_duplicate();	# this never sleeps.
	add_to_swapcache()
	radix_tree_peload_end();

 Good point of this approach is 
	- we can use __GFP_WAIT in gfp_mask.
	- -ENOMEM means OOM, then, we should be aggressive to get a page.

How do you think ?

Thanks,
-Kame

> ---
>  mm/swap_state.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/mm/swap_state.c b/mm/swap_state.c
> index 42cd38e..3e6dd72 100644
> --- a/mm/swap_state.c
> +++ b/mm/swap_state.c
> @@ -76,6 +76,7 @@ int add_to_swap_cache(struct page *page, swp_entry_t entry, gfp_t gfp_mask)
>  	VM_BUG_ON(!PageLocked(page));
>  	VM_BUG_ON(PageSwapCache(page));
>  	VM_BUG_ON(!PageSwapBacked(page));
> +	VM_BUG_ON(gfp_mask & __GFP_WAIT);
>  
>  	error = radix_tree_preload(gfp_mask);
>  	if (!error) {
> @@ -307,7 +308,7 @@ struct page *read_swap_cache_async(swp_entry_t entry, gfp_t gfp_mask,
>  		 */
>  		__set_page_locked(new_page);
>  		SetPageSwapBacked(new_page);
> -		err = add_to_swap_cache(new_page, entry, gfp_mask & GFP_KERNEL);
> +		err = add_to_swap_cache(new_page, entry, GFP_ATOMIC);
>  		if (likely(!err)) {
>  			/*
>  			 * Initiate read into locked page and return.
> 

