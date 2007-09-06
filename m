Return-Path: <linux-kernel-owner+w=401wt.eu-S1757791AbXIFNA3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757791AbXIFNA3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2007 09:00:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756032AbXIFNAW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Sep 2007 09:00:22 -0400
Received: from gir.skynet.ie ([193.1.99.77]:35809 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755979AbXIFNAV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2007 09:00:21 -0400
Subject: Re: [PATCH][-mm] Fix setup_per_zone_pages_min() lock.
From: Mel Gorman <mel@csn.ul.ie>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20070903194629.aa24ecc5.kamezawa.hiroyu@jp.fujitsu.com>
References: <20070903194629.aa24ecc5.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain
Date: Thu, 06 Sep 2007 14:53:01 +0100
Message-Id: <1189086781.3834.10.camel@machina.109elm.lan>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-09-03 at 19:46 +0900, KAMEZAWA Hiroyuki wrote:
> Fix setup_per_zone_pages_min().
> 
> Now setup_per_zone_pages_min() uses zone->lru_lock. This has 2 problems.
> 
> 1. setup_page_zone_pages_min() modifies zone->pages_min,pages_low,pages_high.
>    in atomic. But readers of these values tend not to take lru_lock.
>    (At least, we need lock between memory hotplug vs. sysctl)
> 2. setup_zone_migrate_reserve() should take zone->lock instead of lru_lock.
> 
> This patch replaces zone->lru_lock with zone->lock.
> 

Does it really matter as they routinely do not take zone->lru_lock
either? pages_min, pages_low and pages_high are currently examined on a
regular basis by zone_watermark_ok() without any locks held in the page
allocator and page reclaim path. Glancing through this, it would appear
that the code in question has the same level of locking protection with
zone->lru_lock or zone->lock.

Is memory hotadd specifically taking the lru_lock somewhere? I can only
think of the seqlock at the moment.

> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

> 
> 
> ---
>  mm/page_alloc.c |    5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> Index: devel-2.6.23-rc4-mm1-zone/mm/page_alloc.c
> ===================================================================
> --- devel-2.6.23-rc4-mm1-zone.orig/mm/page_alloc.c
> +++ devel-2.6.23-rc4-mm1-zone/mm/page_alloc.c
> @@ -4176,8 +4176,8 @@ void setup_per_zone_pages_min(void)
>  
>  	for_each_zone(zone) {
>  		u64 tmp;
> +		spin_lock_irqsave(&zone->lock, flags);
>  
> -		spin_lock_irqsave(&zone->lru_lock, flags);
>  		tmp = (u64)pages_min * zone->present_pages;
>  		do_div(tmp, lowmem_pages);
>  		if (is_highmem(zone)) {
> @@ -4208,8 +4208,9 @@ void setup_per_zone_pages_min(void)
>  
>  		zone->pages_low   = zone->pages_min + (tmp >> 2);
>  		zone->pages_high  = zone->pages_min + (tmp >> 1);
> +
>  		setup_zone_migrate_reserve(zone);
> -		spin_unlock_irqrestore(&zone->lru_lock, flags);
> +		spin_unlock_irqrestore(&zone->lock, flags);
>  	}
>  
>  	/* update totalreserve_pages */
> 

