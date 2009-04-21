Return-Path: <linux-kernel-owner+w=401wt.eu-S1756211AbZDUBAl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756211AbZDUBAl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 21:00:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752603AbZDUBAc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 21:00:32 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:38755 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752597AbZDUBAb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 21:00:31 -0400
Date: Tue, 21 Apr 2009 09:58:57 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Rik van Riel <riel@redhat.com>,
       Hugh Dickins <hugh@veritas.com>
Subject: Re: [patch 3/3][rfc] vmscan: batched swap slot allocation
Message-Id: <20090421095857.b989ce44.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1240259085-25872-3-git-send-email-hannes@cmpxchg.org>
References: <1240259085-25872-1-git-send-email-hannes@cmpxchg.org>
	<1240259085-25872-3-git-send-email-hannes@cmpxchg.org>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Apr 2009 22:24:45 +0200
Johannes Weiner <hannes@cmpxchg.org> wrote:

> Every swap slot allocation tries to be subsequent to the previous one
> to help keeping the LRU order of anon pages intact when they are
> swapped out.
> 
> With an increasing number of concurrent reclaimers, the average
> distance between two subsequent slot allocations of one reclaimer
> increases as well.  The contiguous LRU list chunks each reclaimer
> swaps out get 'multiplexed' on the swap space as they allocate the
> slots concurrently.
> 
> 	2 processes isolating 15 pages each and allocating swap slots
> 	concurrently:
> 
> 	#0			#1
> 
> 	page 0 slot 0		page 15 slot 1
> 	page 1 slot 2		page 16 slot 3
> 	page 2 slot 4		page 17 slot 5
> 	...
> 
> 	-> average slot distance of 2
> 
> All reclaimers being equally fast, this becomes a problem when the
> total number of concurrent reclaimers gets so high that even equal
> distribution makes the average distance between the slots of one
> reclaimer too wide for optimistic swap-in to compensate.
> 
> But right now, one reclaimer can take much longer than another one
> because its pages are mapped into more page tables and it has thus
> more work to do and the faster reclaimer will allocate multiple swap
> slots between two slot allocations of the slower one.
> 
> This patch makes shrink_page_list() allocate swap slots in batches,
> collecting all the anonymous memory pages in a list without
> rescheduling and actual reclaim in between.  And only after all anon
> pages are swap cached, unmap and write-out starts for them.
> 
> While this does not fix the fundamental issue of slot distribution
> increasing with reclaimers, it mitigates the problem by balancing the
> resulting fragmentation equally between the allocators.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Rik van Riel <riel@redhat.com>
> Cc: Hugh Dickins <hugh@veritas.com>
> ---
>  mm/vmscan.c |   49 +++++++++++++++++++++++++++++++++++++++++--------
>  1 files changed, 41 insertions(+), 8 deletions(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 70092fa..b3823fe 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -592,24 +592,42 @@ static unsigned long shrink_page_list(struct list_head *page_list,
>  					enum pageout_io sync_writeback)
>  {
>  	LIST_HEAD(ret_pages);
> +	LIST_HEAD(swap_pages);
>  	struct pagevec freed_pvec;
> -	int pgactivate = 0;
> +	int pgactivate = 0, restart = 0;
>  	unsigned long nr_reclaimed = 0;
>  
>  	cond_resched();
>  
>  	pagevec_init(&freed_pvec, 1);
> +restart:
>  	while (!list_empty(page_list)) {
>  		struct address_space *mapping;
>  		struct page *page;
>  		int may_enter_fs;
>  		int referenced;
>  
> -		cond_resched();
> +		if (list_empty(&swap_pages))
> +			cond_resched();
>  
Why this ?

>  		page = lru_to_page(page_list);
>  		list_del(&page->lru);
>  
> +		if (restart) {
> +			/*
> +			 * We are allowed to do IO when we restart for
> +			 * swap pages.
> +			 */
> +			may_enter_fs = 1;
> +			/*
> +			 * Referenced pages will be sorted out by
> +			 * try_to_unmap() and unmapped (anon!) pages
> +			 * are not to be referenced anymore.
> +			 */
> +			referenced = 0;
> +			goto reclaim;
> +		}
> +
>  		if (!trylock_page(page))
>  			goto keep;
>  
Keeping multiple pages locked while they stay on private list ? 

BTW, isn't it better to add "allocate multiple swap space at once" function
like
 - void get_swap_pages(nr, swp_entry_array[])
? "nr" will not be bigger than SWAP_CLUSTER_MAX.

Regards,
-Kame

