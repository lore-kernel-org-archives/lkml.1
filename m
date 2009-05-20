Return-Path: <linux-kernel-owner+w=401wt.eu-S1756192AbZETHeU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756192AbZETHeU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 03:34:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754628AbZETHeL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 03:34:11 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:32871 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754218AbZETHeK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 03:34:10 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [PATCH 3/3] reset wmark_min and inactive ratio of zone when hotplug happens
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Mel Gorman <mel@csn.ul.ie>, Rik van Riel <riel@redhat.com>,
       Johannes Weiner <hannes@cmpxchg.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Yasunori Goto <y-goto@jp.fujitsu.com>
In-Reply-To: <20090520162001.3f3bbe5c.minchan.kim@barrios-desktop>
References: <20090520162001.3f3bbe5c.minchan.kim@barrios-desktop>
Message-Id: <20090520162616.744C.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed, 20 May 2009 16:34:08 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This patch solve two problems.
> 
> Whenever memory hotplug sucessfully happens, zone->present_pages
> have to be changed.
> 
> 1) Now, memory hotplug calls setup_per_zone_wmark_min only when
> online_pages called, not offline_pages.
> 
> It breaks balance.
> 
> 2) If zone->present_pages is changed, we also have to change
> zone->inactive_ratio. That's because inactive_ratio depends
> on zone->present_pages.

Good catch!
looks good to me. but I'm not familiar this area. CC to Goto-san.





> CC: Mel Gorman <mel@csn.ul.ie>
> CC: Rik van Riel <riel@redhat.com>
> CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> CC: Johannes Weiner <hannes@cmpxchg.org>
> Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
> ---
>  mm/memory_hotplug.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
> index 40bf385..1611010 100644
> --- a/mm/memory_hotplug.c
> +++ b/mm/memory_hotplug.c
> @@ -423,6 +423,7 @@ int online_pages(unsigned long pfn, unsigned long nr_pages)
>  	zone->zone_pgdat->node_present_pages += onlined_pages;
>  
>  	setup_per_zone_wmark_min();
> +	calculate_per_zone_inactive_ratio(zone);
>  	if (onlined_pages) {
>  		kswapd_run(zone_to_nid(zone));
>  		node_set_state(zone_to_nid(zone), N_HIGH_MEMORY);
> @@ -832,6 +833,9 @@ repeat:
>  	totalram_pages -= offlined_pages;
>  	num_physpages -= offlined_pages;
>  
> +	setup_per_zone_wmark_min();
> +	calculate_per_zone_inactive_ratio(zone);
> +
>  	vm_total_pages = nr_free_pagecache_pages();
>  	writeback_set_ratelimit();
>  
> -- 
> 1.5.4.3
> 
> 
> 
> -- 
> Kinds Regards
> Minchan Kim



