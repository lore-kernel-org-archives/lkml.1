Return-Path: <linux-kernel-owner+w=401wt.eu-S935454AbXLQKpG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935454AbXLQKpG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 05:45:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765008AbXLQKo4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 05:44:56 -0500
Received: from gir.skynet.ie ([193.1.99.77]:51143 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764010AbXLQKo4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 05:44:56 -0500
Date: Mon, 17 Dec 2007 10:44:53 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: Shaohua Li <shaohua.li@intel.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC] move free page back to MIGRATE_MOVABLE?
Message-ID: <20071217104452.GA3778@csn.ul.ie>
References: <1197523199.3410.1.camel@sli10-desk.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1197523199.3410.1.camel@sli10-desk.sh.intel.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (13/12/07 13:19), Shaohua Li didst pronounce:
> pages are MIGRATE_MOVABLE initially, and fallback to other types. If the
> pages are freed, I wonder why not move them back to MIGRATE_MOVABLE.

Because there is no need, if a MIGRATE_MOVABLE allocation needs more pages,
they will be acquired during fallback which always steals the largest
block. Lets say that a MIGRATE_UNMOVABLE block is freed and it is larger
than pageblock_order. The next MIGRATE_MOVABLE allocation will find it during
fallback if necessary.

> This, for example, can help memory remove.
> 

I don't see how. When hot-removing, MIGRATE_MOVABLE blocks are considered
possible to remove but they are also considered movable if the pages are free.

> Thanks,
> Shaohua 
> 
> Index: linux/mm/page_alloc.c
> ===================================================================
> --- linux.orig/mm/page_alloc.c	2007-12-13 11:44:36.000000000 +0800
> +++ linux/mm/page_alloc.c	2007-12-13 12:04:59.000000000 +0800
> @@ -386,6 +386,9 @@ static inline int page_is_buddy(struct p
>  	return 0;
>  }
>  
> +int move_freepages(struct zone *zone,
> +			struct page *start_page, struct page *end_page,
> +			int migratetype);
>  /*
>   * Freeing function for a buddy system allocator.
>   *
> @@ -446,6 +449,17 @@ static inline void __free_one_page(struc
>  	list_add(&page->lru,
>  		&zone->free_area[order].free_list[migratetype]);
>  	zone->free_area[order].nr_free++;
> +
> +	if (order >= pageblock_order && migratetype != MIGRATE_MOVABLE) {
> +		struct page *tmp = page;
> +
> +		move_freepages(zone, page, page + (1 << order) - 1, MIGRATE_MOVABLE);
> +

This is unnecessary and affects a commonly used path. If a MOVABLE allocation
needs more pages later, it will find the large free block during fallback.

> +		while (tmp < page + (1 << order)) {
> +			set_pageblock_migratetype(tmp, MIGRATE_MOVABLE);
> +			tmp += pageblock_nr_pages;
> +		}
> +	}
>  }
>  
>  static inline int free_pages_check(struct page *page)
> 

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
