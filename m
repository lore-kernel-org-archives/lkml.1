Return-Path: <linux-kernel-owner+w=401wt.eu-S1751721AbYKFQq4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751721AbYKFQq4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 11:46:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750938AbYKFQqt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 11:46:49 -0500
Received: from gir.skynet.ie ([193.1.99.77]:43608 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751005AbYKFQqs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 11:46:48 -0500
Date: Thu, 6 Nov 2008 16:46:45 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       linux-mm <linux-mm@kvack.org>
Subject: Re: [RFC][PATCH] mm: the page of MIGRATE_RESERVE don't insert into pcp
Message-ID: <20081106164644.GA14012@csn.ul.ie>
References: <20081106091431.0D2A.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20081106091431.0D2A.KOSAKI.MOTOHIRO@jp.fujitsu.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 06, 2008 at 09:16:58AM +0900, KOSAKI Motohiro wrote:
> MIGRATE_RESERVE mean that the page is for emergency.
> So it shouldn't be cached in pcp.
> 

It doesn't necessarily mean it's for emergencys. MIGRATE_RESERVE is one
or more pageblocks at the beginning of the zone. While it's possible
that the minimum page reserve for GFP_ATOMIC is located here, it's not
mandatory.

What MIGRATE_RESERVE can help is high-order atomic allocations used by
some network drivers (a wireless one is what led to MIGRATE_RESERVE). As
they are high-order allocations, they would be returned to the buddy
allocator anyway.

What your patch may help is the situation where the system is under intense
memory pressure, is dipping routinely into the lowmem reserves and mixing
with high-order atomic allocations. This seems a bit extreme.

> otherwise, the system have unnecessary memory starvation risk
> because other cpu can't use this emergency pages.
> 
> 
> 
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> CC: Mel Gorman <mel@csn.ul.ie>
> CC: Christoph Lameter <cl@linux-foundation.org>
> 

This patch seems functionally sound but as Christoph points out, this
adds another branch to the fast path. Now, I ran some tests and those that
completed didn't show any problems but adding branches in the fast path can
eventually lead to hard-to-detect performance problems.

Do you have a situation in mind that this patch fixes up?

Thanks

> ---
>  mm/page_alloc.c |   12 +++++++++++-
>  1 file changed, 11 insertions(+), 1 deletion(-)
> 
> Index: b/mm/page_alloc.c
> ===================================================================
> --- a/mm/page_alloc.c	2008-11-06 06:01:15.000000000 +0900
> +++ b/mm/page_alloc.c	2008-11-06 06:27:41.000000000 +0900
> @@ -1002,6 +1002,7 @@ static void free_hot_cold_page(struct pa
>  	struct zone *zone = page_zone(page);
>  	struct per_cpu_pages *pcp;
>  	unsigned long flags;
> +	int migratetype = get_pageblock_migratetype(page);
>  
>  	if (PageAnon(page))
>  		page->mapping = NULL;
> @@ -1018,16 +1019,25 @@ static void free_hot_cold_page(struct pa
>  	pcp = &zone_pcp(zone, get_cpu())->pcp;
>  	local_irq_save(flags);
>  	__count_vm_event(PGFREE);
> +
> +	set_page_private(page, migratetype);
> +
> +	/* the page for emergency shouldn't be cached */
> +	if (migratetype == MIGRATE_RESERVE) {
> +		free_one_page(zone, page, 0);
> +		goto out;
> +	}
>  	if (cold)
>  		list_add_tail(&page->lru, &pcp->list);
>  	else
>  		list_add(&page->lru, &pcp->list);
> -	set_page_private(page, get_pageblock_migratetype(page));
>  	pcp->count++;
>  	if (pcp->count >= pcp->high) {
>  		free_pages_bulk(zone, pcp->batch, &pcp->list, 0);
>  		pcp->count -= pcp->batch;
>  	}
> +
> +out:
>  	local_irq_restore(flags);
>  	put_cpu();
>  }
> 
> 

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
