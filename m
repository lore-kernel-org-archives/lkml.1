Return-Path: <linux-kernel-owner+w=401wt.eu-S1754427AbZDUHhp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754427AbZDUHhp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 03:37:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751425AbZDUHhd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 03:37:33 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:55861 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056AbZDUHhc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 03:37:32 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH 09/25] Calculate the migratetype for allocation only once
Cc: kosaki.motohiro@jp.fujitsu.com,
       Linux Memory Management List <linux-mm@kvack.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lin Ming <ming.m.lin@intel.com>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1240266011-11140-10-git-send-email-mel@csn.ul.ie>
References: <1240266011-11140-1-git-send-email-mel@csn.ul.ie> <1240266011-11140-10-git-send-email-mel@csn.ul.ie>
Message-Id: <20090421160729.F136.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50 [ja]
Date: Tue, 21 Apr 2009 16:37:28 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> GFP mask is converted into a migratetype when deciding which pagelist to
> take a page from. However, it is happening multiple times per
> allocation, at least once per zone traversed. Calculate it once.
> 
> Signed-off-by: Mel Gorman <mel@csn.ul.ie>
> ---
>  mm/page_alloc.c |   43 ++++++++++++++++++++++++++-----------------
>  1 files changed, 26 insertions(+), 17 deletions(-)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index b27bcde..f960cf5 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -1065,13 +1065,13 @@ void split_page(struct page *page, unsigned int order)
>   * or two.
>   */
>  static struct page *buffered_rmqueue(struct zone *preferred_zone,
> -			struct zone *zone, int order, gfp_t gfp_flags)
> +			struct zone *zone, int order, gfp_t gfp_flags,
> +			int migratetype)
>  {
>  	unsigned long flags;
>  	struct page *page;
>  	int cold = !!(gfp_flags & __GFP_COLD);
>  	int cpu;
> -	int migratetype = allocflags_to_migratetype(gfp_flags);

hmmm....

allocflags_to_migratetype() is very cheap function and buffered_rmqueue()
and other non-inline static function isn't guranteed inlined.

I don't think this patch improve performance on x86.
and, I have one comment to allocflags_to_migratetype.

-------------------------------------------------------------------
/* Convert GFP flags to their corresponding migrate type */
static inline int allocflags_to_migratetype(gfp_t gfp_flags)
{
        WARN_ON((gfp_flags & GFP_MOVABLE_MASK) == GFP_MOVABLE_MASK);

        if (unlikely(page_group_by_mobility_disabled))
                return MIGRATE_UNMOVABLE;

        /* Group based on mobility */
        return (((gfp_flags & __GFP_MOVABLE) != 0) << 1) |
                ((gfp_flags & __GFP_RECLAIMABLE) != 0);
}
-------------------------------------------------------------------

s/WARN_ON/VM_BUG_ON/ is better?

GFP_MOVABLE_MASK makes 3. 3 mean MIGRATE_RESERVE. it seems obviously bug.

>  
>  again:
>  	cpu  = get_cpu();
> @@ -1397,7 +1397,7 @@ static void zlc_mark_zone_full(struct zonelist *zonelist, struct zoneref *z)
>  static struct page *
>  get_page_from_freelist(gfp_t gfp_mask, nodemask_t *nodemask, unsigned int order,
>  		struct zonelist *zonelist, int high_zoneidx, int alloc_flags,
> -		struct zone *preferred_zone)
> +		struct zone *preferred_zone, int migratetype)
>  {
>  	struct zoneref *z;
>  	struct page *page = NULL;
> @@ -1449,7 +1449,8 @@ zonelist_scan:
>  			}
>  		}
>  
> -		page = buffered_rmqueue(preferred_zone, zone, order, gfp_mask);
> +		page = buffered_rmqueue(preferred_zone, zone, order,
> +						gfp_mask, migratetype);
>  		if (page)
>  			break;
>  this_zone_full:
> @@ -1513,7 +1514,8 @@ should_alloc_retry(gfp_t gfp_mask, unsigned int order,
>  static inline struct page *
>  __alloc_pages_may_oom(gfp_t gfp_mask, unsigned int order,
>  	struct zonelist *zonelist, enum zone_type high_zoneidx,
> -	nodemask_t *nodemask, struct zone *preferred_zone)
> +	nodemask_t *nodemask, struct zone *preferred_zone,
> +	int migratetype)
>  {
>  	struct page *page;
>  
> @@ -1531,7 +1533,7 @@ __alloc_pages_may_oom(gfp_t gfp_mask, unsigned int order,
>  	page = get_page_from_freelist(gfp_mask|__GFP_HARDWALL, nodemask,
>  		order, zonelist, high_zoneidx,
>  		ALLOC_WMARK_HIGH|ALLOC_CPUSET,
> -		preferred_zone);
> +		preferred_zone, migratetype);
>  	if (page)
>  		goto out;
>  
> @@ -1552,7 +1554,7 @@ static inline struct page *
>  __alloc_pages_direct_reclaim(gfp_t gfp_mask, unsigned int order,
>  	struct zonelist *zonelist, enum zone_type high_zoneidx,
>  	nodemask_t *nodemask, int alloc_flags, struct zone *preferred_zone,
> -	unsigned long *did_some_progress)
> +	int migratetype, unsigned long *did_some_progress)
>  {
>  	struct page *page = NULL;
>  	struct reclaim_state reclaim_state;
> @@ -1585,7 +1587,8 @@ __alloc_pages_direct_reclaim(gfp_t gfp_mask, unsigned int order,
>  	if (likely(*did_some_progress))
>  		page = get_page_from_freelist(gfp_mask, nodemask, order,
>  					zonelist, high_zoneidx,
> -					alloc_flags, preferred_zone);
> +					alloc_flags, preferred_zone,
> +					migratetype);
>  	return page;
>  }
>  
> @@ -1606,14 +1609,15 @@ is_allocation_high_priority(struct task_struct *p, gfp_t gfp_mask)
>  static inline struct page *
>  __alloc_pages_high_priority(gfp_t gfp_mask, unsigned int order,
>  	struct zonelist *zonelist, enum zone_type high_zoneidx,
> -	nodemask_t *nodemask, struct zone *preferred_zone)
> +	nodemask_t *nodemask, struct zone *preferred_zone,
> +	int migratetype)
>  {
>  	struct page *page;
>  
>  	do {
>  		page = get_page_from_freelist(gfp_mask, nodemask, order,
>  			zonelist, high_zoneidx, ALLOC_NO_WATERMARKS,
> -			preferred_zone);
> +			preferred_zone, migratetype);
>  
>  		if (!page && gfp_mask & __GFP_NOFAIL)
>  			congestion_wait(WRITE, HZ/50);
> @@ -1636,7 +1640,8 @@ void wake_all_kswapd(unsigned int order, struct zonelist *zonelist,
>  static inline struct page *
>  __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
>  	struct zonelist *zonelist, enum zone_type high_zoneidx,
> -	nodemask_t *nodemask, struct zone *preferred_zone)
> +	nodemask_t *nodemask, struct zone *preferred_zone,
> +	int migratetype)
>  {
>  	const gfp_t wait = gfp_mask & __GFP_WAIT;
>  	struct page *page = NULL;
> @@ -1687,14 +1692,16 @@ restart:
>  	 */
>  	page = get_page_from_freelist(gfp_mask, nodemask, order, zonelist,
>  						high_zoneidx, alloc_flags,
> -						preferred_zone);
> +						preferred_zone,
> +						migratetype);
>  	if (page)
>  		goto got_pg;
>  
>  	/* Allocate without watermarks if the context allows */
>  	if (is_allocation_high_priority(p, gfp_mask))
>  		page = __alloc_pages_high_priority(gfp_mask, order,
> -			zonelist, high_zoneidx, nodemask, preferred_zone);
> +			zonelist, high_zoneidx, nodemask, preferred_zone,
> +			migratetype);
>  	if (page)
>  		goto got_pg;
>  
> @@ -1707,7 +1714,7 @@ restart:
>  					zonelist, high_zoneidx,
>  					nodemask,
>  					alloc_flags, preferred_zone,
> -					&did_some_progress);
> +					migratetype, &did_some_progress);
>  	if (page)
>  		goto got_pg;
>  
> @@ -1719,7 +1726,8 @@ restart:
>  		if ((gfp_mask & __GFP_FS) && !(gfp_mask & __GFP_NORETRY)) {
>  			page = __alloc_pages_may_oom(gfp_mask, order,
>  					zonelist, high_zoneidx,
> -					nodemask, preferred_zone);
> +					nodemask, preferred_zone,
> +					migratetype);
>  			if (page)
>  				goto got_pg;
>  
> @@ -1758,6 +1766,7 @@ __alloc_pages_nodemask(gfp_t gfp_mask, unsigned int order,
>  	enum zone_type high_zoneidx = gfp_zone(gfp_mask);
>  	struct zone *preferred_zone;
>  	struct page *page;
> +	int migratetype = allocflags_to_migratetype(gfp_mask);
>  
>  	lockdep_trace_alloc(gfp_mask);
>  
> @@ -1783,11 +1792,11 @@ __alloc_pages_nodemask(gfp_t gfp_mask, unsigned int order,
>  	/* First allocation attempt */
>  	page = get_page_from_freelist(gfp_mask|__GFP_HARDWALL, nodemask, order,
>  			zonelist, high_zoneidx, ALLOC_WMARK_LOW|ALLOC_CPUSET,
> -			preferred_zone);
> +			preferred_zone, migratetype);
>  	if (unlikely(!page))
>  		page = __alloc_pages_slowpath(gfp_mask, order,
>  				zonelist, high_zoneidx, nodemask,
> -				preferred_zone);
> +				preferred_zone, migratetype);
>  
>  	return page;
>  }
> -- 
> 1.5.6.5
> 



