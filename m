Return-Path: <linux-kernel-owner+w=401wt.eu-S1755294AbZGMJ4G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755294AbZGMJ4G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 05:56:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755153AbZGMJ4G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 05:56:06 -0400
Received: from gir.skynet.ie ([193.1.99.77]:36492 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755154AbZGMJ4E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 05:56:04 -0400
Date: Mon, 13 Jul 2009 10:56:03 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Shaohua Li <shaohua.li@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH] switch free memory back to MIGRATE_MOVABLE
Message-ID: <20090713095602.GA996@csn.ul.ie>
References: <20090713023030.GA27269@sli10-desk.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20090713023030.GA27269@sli10-desk.sh.intel.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 13, 2009 at 10:30:30AM +0800, Shaohua Li wrote:
> When page is back to buddy and its order is bigger than pageblock_order, we can
> switch its type to MIGRATE_MOVABLE. This can reduce fragmentation. The patch
> has obvious effect when read a block device and then drop caches.
> 
> Signed-off-by: Shaohua Li <shaohua.li@intel.com>

NAK.

There is no point making this check in the free path, it can be left at
whatever type it is. rmqueue fallback will already find blocks like this and
switch the type again if necessary. The only time you might care is memory
off-lining and at that point, you can check if a free page spans the
pageblock and if so, ignore the existing migrate type.

> ---
>  mm/page_alloc.c |    9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> Index: linux/mm/page_alloc.c
> ===================================================================
> --- linux.orig/mm/page_alloc.c	2009-07-10 11:36:07.000000000 +0800
> +++ linux/mm/page_alloc.c	2009-07-13 09:25:21.000000000 +0800
> @@ -475,6 +475,15 @@ static inline void __free_one_page(struc
>  		order++;
>  	}
>  	set_page_order(page, order);
> +
> +	if (order >= pageblock_order && migratetype != MIGRATE_MOVABLE) {
> +		int i;
> +
> +		migratetype = MIGRATE_MOVABLE;
> +		for (i = 0; i < (1 << (order - pageblock_order)); i++)
> +			set_pageblock_migratetype(page +
> +				i * pageblock_nr_pages, MIGRATE_MOVABLE);
> +	}
>  	list_add(&page->lru,
>  		&zone->free_area[order].free_list[migratetype]);
>  	zone->free_area[order].nr_free++;
> 

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
