Return-Path: <linux-kernel-owner+w=401wt.eu-S1755153AbZEYJCL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755153AbZEYJCL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 05:02:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752042AbZEYJB6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 05:01:58 -0400
Received: from gir.skynet.ie ([193.1.99.77]:57664 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751335AbZEYJB5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 05:01:57 -0400
Date: Mon, 25 May 2009 10:01:56 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
       Yasunori Goto <y-goto@jp.fujitsu.com>
Subject: Re: [PATCH 3/3] reset wmark_min and inactive ratio of zone when
	hotplug happens V2
Message-ID: <20090525090156.GC12160@csn.ul.ie>
References: <20090521092337.bc0f0308.minchan.kim@barrios-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20090521092337.bc0f0308.minchan.kim@barrios-desktop>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 21, 2009 at 09:23:37AM +0900, Minchan Kim wrote:
> Changelog since V1 
>  o Add Ack-by of Yasunori Goto
>  o Modify setup_per_zone_wmarks's comment
> 
> This patch solve two problems.
> 
> Whenever memory hotplug sucessfully happens, zone->present_pages
> have to be changed.
> 
> 1) Now memory hotplug calls setup_per_zone_wmark_min only when
> online_pages called, not offline_pages.
> 
> It breaks balance.
> 
> 2) If zone->present_pages is changed, we also have to change
> zone->inactive_ratio. That's because inactive_ratio depends
> on zone->present_pages.
> 
> Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
> Acked-by: Yasunori Goto <y-goto@jp.fujitsu.com>

Acked-by: Mel Gorman <mel@csn.ul.ie>

> CC: Rik van Riel <riel@redhat.com>
> CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> CC: Johannes Weiner <hannes@cmpxchg.org>
> ---
>  mm/memory_hotplug.c |    4 ++++
>  mm/page_alloc.c     |    2 +-
>  2 files changed, 5 insertions(+), 1 deletions(-)
> 
> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
> index 037291e..e4412a6 100644
> --- a/mm/memory_hotplug.c
> +++ b/mm/memory_hotplug.c
> @@ -423,6 +423,7 @@ int online_pages(unsigned long pfn, unsigned long nr_pages)
>  	zone->zone_pgdat->node_present_pages += onlined_pages;
>  
>  	setup_per_zone_wmarks();
> +	calculate_zone_inactive_ratio(zone);
>  	if (onlined_pages) {
>  		kswapd_run(zone_to_nid(zone));
>  		node_set_state(zone_to_nid(zone), N_HIGH_MEMORY);
> @@ -832,6 +833,9 @@ repeat:
>  	totalram_pages -= offlined_pages;
>  	num_physpages -= offlined_pages;
>  
> +	setup_per_zone_wmarks();
> +	calculate_zone_inactive_ratio(zone);
> +
>  	vm_total_pages = nr_free_pagecache_pages();
>  	writeback_set_ratelimit();
>  
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index f11cfbf..d13f9b5 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -4472,7 +4472,7 @@ static void setup_per_zone_lowmem_reserve(void)
>  
>  /**
>   * setup_per_zone_wmarks - called when min_free_kbytes changes 
> - * or when memory is hot-added
> + * or when memory is hot-{added|removed}
>   *
>   * Ensures that the watermark[min,low,high] values for each zone are set correctly
>   * with respect to min_free_kbytes.
> -- 
> 1.5.4.3
> 

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
