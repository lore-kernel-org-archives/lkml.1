Return-Path: <linux-kernel-owner+w=401wt.eu-S1754974AbZGMTRn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754974AbZGMTRn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 15:17:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754870AbZGMTRm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 15:17:42 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53080 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754843AbZGMTRl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 15:17:41 -0400
Date: Mon, 13 Jul 2009 12:16:28 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mel Gorman <mel@csn.ul.ie>
Cc: mel@csn.ul.ie, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 5/13] Choose pages from the per cpu list-based on
 migration type
Message-Id: <20090713121628.bde62c65.akpm@linux-foundation.org>
In-Reply-To: <20070910112151.3097.54726.sendpatchset@skynet.skynet.ie>
References: <20070910112011.3097.8438.sendpatchset@skynet.skynet.ie>
	<20070910112151.3097.54726.sendpatchset@skynet.skynet.ie>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Sep 2007 12:21:51 +0100 (IST)
Mel Gorman <mel@csn.ul.ie> wrote:
>

A somewhat belated review comment.

> The freelists for each migrate type can slowly become polluted due to the
> per-cpu list.  Consider what happens when the following happens
> 
> 1. A 2^pageblock_order list is reserved for __GFP_MOVABLE pages
> 2. An order-0 page is allocated from the newly reserved block
> 3. The page is freed and placed on the per-cpu list
> 4. alloc_page() is called with GFP_KERNEL as the gfp_mask
> 5. The per-cpu list is used to satisfy the allocation
> 
> This results in a kernel page is in the middle of a migratable region. This
> patch prevents this leak occuring by storing the MIGRATE_ type of the page in
> page->private. On allocate, a page will only be returned of the desired type,
> else more pages will be allocated. This may temporarily allow a per-cpu list
> to go over the pcp->high limit but it'll be corrected on the next free. Care
> is taken to preserve the hotness of pages recently freed.
>
> The additional code is not measurably slower for the workloads we've tested.

It sure looks slower.

> Signed-off-by: Mel Gorman <mel@csn.ul.ie>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  mm/page_alloc.c |   18 ++++++++++++++++--
>  1 file changed, 16 insertions(+), 2 deletions(-)
> 
> diff -rup -X /usr/src/patchset-0.6/bin//dontdiff linux-2.6.23-rc5-004-split-the-free-lists-for-movable-and-unmovable-allocations/mm/page_alloc.c linux-2.6.23-rc5-005-choose-pages-from-the-per-cpu-list-based-on-migration-type/mm/page_alloc.c
> --- linux-2.6.23-rc5-004-split-the-free-lists-for-movable-and-unmovable-allocations/mm/page_alloc.c	2007-09-02 16:19:34.000000000 +0100
> +++ linux-2.6.23-rc5-005-choose-pages-from-the-per-cpu-list-based-on-migration-type/mm/page_alloc.c	2007-09-02 16:20:09.000000000 +0100
> @@ -757,7 +757,8 @@ static int rmqueue_bulk(struct zone *zon
>  		struct page *page = __rmqueue(zone, order, migratetype);
>  		if (unlikely(page == NULL))
>  			break;
> -		list_add_tail(&page->lru, list);
> +		list_add(&page->lru, list);
> +		set_page_private(page, migratetype);
>  	}
>  	spin_unlock(&zone->lock);
>  	return i;
> @@ -884,6 +885,7 @@ static void fastcall free_hot_cold_page(
>  	local_irq_save(flags);
>  	__count_vm_event(PGFREE);
>  	list_add(&page->lru, &pcp->list);
> +	set_page_private(page, get_pageblock_migratetype(page));
>  	pcp->count++;
>  	if (pcp->count >= pcp->high) {
>  		free_pages_bulk(zone, pcp->batch, &pcp->list, 0);
> @@ -948,7 +950,19 @@ again:
>  			if (unlikely(!pcp->count))
>  				goto failed;
>  		}
> -		page = list_entry(pcp->list.next, struct page, lru);
> +
> +		/* Find a page of the appropriate migrate type */
> +		list_for_each_entry(page, &pcp->list, lru)
> +			if (page_private(page) == migratetype)
> +				break;

We're doing a linear search through the per-cpu magaznines right there
in the page allocator hot path.  Even if the search matches the first
element, the setup costs will matter.

Surely we can make this search go away with a better choice of data
structures?


> +		/* Allocate more to the pcp list if necessary */
> +		if (unlikely(&page->lru == &pcp->list)) {
> +			pcp->count += rmqueue_bulk(zone, 0,
> +					pcp->batch, &pcp->list, migratetype);
> +			page = list_entry(pcp->list.next, struct page, lru);
> +		}
> +
>  		list_del(&page->lru);
>  		pcp->count--;
>  	} else {

