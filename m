Return-Path: <linux-kernel-owner+w=401wt.eu-S1755393AbZERDQA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755393AbZERDQA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 May 2009 23:16:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752327AbZERDPt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 May 2009 23:15:49 -0400
Received: from mga14.intel.com ([143.182.124.37]:56601 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751580AbZERDPt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 May 2009 23:15:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,208,1241420400"; 
   d="scan'208";a="143886554"
Date: Mon, 18 May 2009 11:15:36 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [PATCH 1/4] vmscan: change the number of the unmapped files in
	zone reclaim
Message-ID: <20090518031536.GC5869@localhost>
References: <20090513120155.5879.A69D9226@jp.fujitsu.com> <20090513120606.587C.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090513120606.587C.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 13, 2009 at 12:06:28PM +0900, KOSAKI Motohiro wrote:
> Subject: [PATCH] vmscan: change the number of the unmapped files in zone reclaim
> 
> Documentation/sysctl/vm.txt says
> 
> 	A percentage of the total pages in each zone.  Zone reclaim will only
> 	occur if more than this percentage of pages are file backed and unmapped.
> 	This is to insure that a minimal amount of local pages is still available for
> 	file I/O even if the node is overallocated.
> 
> However, zone_page_state(zone, NR_FILE_PAGES) contain some non file backed pages
> (e.g. swapcache, buffer-head)
> 
> The right calculation is to use NR_{IN}ACTIVE_FILE.
> 
> 
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Cc: Christoph Lameter <cl@linux-foundation.org>
> Cc: Rik van Riel <riel@redhat.com>
> ---
>  mm/vmscan.c |   21 ++++++++++++++-------
>  1 file changed, 14 insertions(+), 7 deletions(-)
> 
> Index: b/mm/vmscan.c
> ===================================================================
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -2397,6 +2397,7 @@ static int __zone_reclaim(struct zone *z
>  		.isolate_pages = isolate_pages_global,
>  	};
>  	unsigned long slab_reclaimable;
> +	long nr_unmapped_file_pages;
>  
>  	disable_swap_token();
>  	cond_resched();
> @@ -2409,9 +2410,11 @@ static int __zone_reclaim(struct zone *z
>  	reclaim_state.reclaimed_slab = 0;
>  	p->reclaim_state = &reclaim_state;
>  
> -	if (zone_page_state(zone, NR_FILE_PAGES) -
> -		zone_page_state(zone, NR_FILE_MAPPED) >
> -		zone->min_unmapped_pages) {
> +	nr_unmapped_file_pages = zone_page_state(zone, NR_INACTIVE_FILE) +
> +				 zone_page_state(zone, NR_ACTIVE_FILE) -
> +				 zone_page_state(zone, NR_FILE_MAPPED);

This can possibly go negative.

> +	if (nr_unmapped_file_pages > zone->min_unmapped_pages) {
>  		/*
>  		 * Free memory by calling shrink zone with increasing
>  		 * priorities until we have enough memory freed.
> @@ -2458,6 +2461,8 @@ int zone_reclaim(struct zone *zone, gfp_
>  {
>  	int node_id;
>  	int ret;
> +	long nr_unmapped_file_pages;
> +	long nr_slab_reclaimable;
>  
>  	/*
>  	 * Zone reclaim reclaims unmapped file backed pages and
> @@ -2469,10 +2474,12 @@ int zone_reclaim(struct zone *zone, gfp_
>  	 * if less than a specified percentage of the zone is used by
>  	 * unmapped file backed pages.
>  	 */
> -	if (zone_page_state(zone, NR_FILE_PAGES) -
> -	    zone_page_state(zone, NR_FILE_MAPPED) <= zone->min_unmapped_pages
> -	    && zone_page_state(zone, NR_SLAB_RECLAIMABLE)
> -			<= zone->min_slab_pages)
> +	nr_unmapped_file_pages = zone_page_state(zone, NR_INACTIVE_FILE) +
> +				 zone_page_state(zone, NR_ACTIVE_FILE) -
> +				 zone_page_state(zone, NR_FILE_MAPPED);

Ditto.

Reviewed-by: Wu Fengguang <fengguang.wu@intel.com>

> +	nr_slab_reclaimable = zone_page_state(zone, NR_SLAB_RECLAIMABLE);
> +	if (nr_unmapped_file_pages <= zone->min_unmapped_pages &&
> +	    nr_slab_reclaimable <= zone->min_slab_pages)
>  		return 0;
>  
>  	if (zone_is_all_unreclaimable(zone))
> 
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
