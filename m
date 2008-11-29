Return-Path: <linux-kernel-owner+w=401wt.eu-S1753221AbYK2HUI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753221AbYK2HUI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2008 02:20:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750897AbYK2HTz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Nov 2008 02:19:55 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57325 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750865AbYK2HTy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2008 02:19:54 -0500
Date: Fri, 28 Nov 2008 23:19:33 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Rik van Riel <riel@redhat.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH] vmscan: skip freeing memory from zones with lots free
Message-Id: <20081128231933.8daef193.akpm@linux-foundation.org>
In-Reply-To: <20081128060803.73cd59bd@bree.surriel.com>
References: <20081128060803.73cd59bd@bree.surriel.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Nov 2008 06:08:03 -0500 Rik van Riel <riel@redhat.com> wrote:

> Skip freeing memory from zones that already have lots of free memory.
> If one memory zone has harder to free memory, we want to avoid freeing
> excessive amounts of memory from other zones, if only because pageout
> IO from the other zones can slow down page freeing from the problem zone.
> 
> This is similar to the check already done by kswapd in balance_pgdat().
> 
> Signed-off-by: Rik van Riel <riel@redhat.com>
> ---
> Kosaki-san, this should address point (3) from your list.
> 
>  mm/vmscan.c |    3 +++
>  1 file changed, 3 insertions(+)
> 
> Index: linux-2.6.28-rc5/mm/vmscan.c
> ===================================================================
> --- linux-2.6.28-rc5.orig/mm/vmscan.c	2008-11-28 05:53:56.000000000 -0500
> +++ linux-2.6.28-rc5/mm/vmscan.c	2008-11-28 06:05:29.000000000 -0500
> @@ -1510,6 +1510,9 @@ static unsigned long shrink_zones(int pr
>  			if (zone_is_all_unreclaimable(zone) &&
>  						priority != DEF_PRIORITY)
>  				continue;	/* Let kswapd poll it */
> +			if (zone_watermark_ok(zone, sc->order,
> +					4*zone->pages_high, high_zoneidx, 0))
> +				continue;	/* Lots free already */
>  			sc->all_unreclaimable = 0;
>  		} else {
>  			/*

We already tried this, or something very similar in effect, I think...


commit 26e4931632352e3c95a61edac22d12ebb72038fe
Author: akpm <akpm>
Date:   Sun Sep 8 19:21:55 2002 +0000

    [PATCH] refill the inactive list more quickly
    
    Fix a problem noticed by Ed Tomlinson: under shifting workloads the
    shrink_zone() logic will refill the inactive load too slowly.
    
    Bale out of the zone scan when we've reclaimed enough pages.  Fixes a
    rarely-occurring problem wherein refill_inactive_zone() ends up
    shuffling 100,000 pages and generally goes silly.
    
    This needs to be revisited - we should go on and rebalance the lower
    zones even if we reclaimed enough pages from highmem.
    


Then it was reverted a year or two later:


commit 265b2b8cac1774f5f30c88e0ab8d0bcf794ef7b3
Author: akpm <akpm>
Date:   Fri Mar 12 16:23:50 2004 +0000

    [PATCH] vmscan: zone balancing fix
    
    We currently have a problem with the balancing of reclaim between zones: much
    more reclaim happens against highmem than against lowmem.
    
    This patch partially fixes this by changing the direct reclaim path so it
    does not bale out of the zone walk after having reclaimed sufficient pages
    from highmem: go on to reclaim from lowmem regardless of how many pages we
    reclaimed from lowmem.
    

My changelog does not adequately explain the reasons.

But we don't want to rediscover these reasons in early 2010 :(  Some trolling
of the linux-mm and lkml archives around those dates might help us avoid
a mistake here.


