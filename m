Return-Path: <linux-kernel-owner+w=401wt.eu-S1757836AbXIFBYw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757836AbXIFBYw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 21:24:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757271AbXIFBYo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 21:24:44 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57467 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756983AbXIFBYn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 21:24:43 -0400
Date: Wed, 5 Sep 2007 18:23:05 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Rik van Riel <riel@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       safari-kernel@safari.iki.fi
Subject: Re: [PATCH] prevent kswapd from freeing excessive amounts of lowmem
Message-Id: <20070905182305.e5d08acf.akpm@linux-foundation.org>
In-Reply-To: <46DF3545.4050604@redhat.com>
References: <46DF3545.4050604@redhat.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, 05 Sep 2007 19:01:25 -0400 Rik van Riel <riel@redhat.com> wrote:
> The current VM can get itself into trouble fairly easily on systems
> with a small ZONE_HIGHMEM, which is common on i686 computers with
> 1GB of memory.
> 
> On one side, page_alloc() will allocate down to zone->pages_low,
> while on the other side, kswapd() and balance_pgdat() will try
> to free memory from every zone, until every zone has more free
> pages than zone->pages_high.
> 
> Highmem can be filled up to zone->pages_low with page tables,
> ramfs, vmalloc allocations and other unswappable things quite
> easily and without many bad side effects, since we still have
> a huge ZONE_NORMAL to do future allocations from.
>
> However, as long as the number of free pages in the highmem
> zone is below zone->pages_high, kswapd will continue swapping
> things out from ZONE_NORMAL, too!

crap.  I guess suitably-fashioned mlock could do the same thing.

> Sami Farin managed to get his system into a stage where kswapd
> had freed about 700MB of low memory and was still "going strong".
> 
> The attached patch will make kswapd stop paging out data from
> zones when there is more than enough memory free.

hm.  Did highmem's all_unreclaimable get set?  If so perhaps we could use
that in some way.

>  We do go above
> zone->pages_high in order to keep pressure between zones equal
> in normal circumstances, but the patch should prevent the kind
> of excesses that made Sami's computer totally unusable.
> 
> Please merge this into -mm.
> 
> Signed-off-by: Rik van Riel <riel@redhat.com>
> 
> 
> [linux-2.6-excessive-pageout.patch  text/x-patch (715B)]
> --- linux-2.6.22.noarch/mm/vmscan.c.excessive	2007-09-05 12:19:49.000000000 -0400
> +++ linux-2.6.22.noarch/mm/vmscan.c	2007-09-05 12:21:40.000000000 -0400
> @@ -1371,7 +1371,13 @@ loop_again:
>  			temp_priority[i] = priority;
>  			sc.nr_scanned = 0;
>  			note_zone_scanning_priority(zone, priority);
> -			nr_reclaimed += shrink_zone(priority, zone, &sc);
> +			/*
> +			 * We put equal pressure on every zone, unless one
> +			 * zone has way too many pages free already.
> +			 */
> +			if (!zone_watermark_ok(zone, order, 8*zone->pages_high,
> +						end_zone, 0))
> +				nr_reclaimed += shrink_zone(priority, zone, &sc);
>  			reclaim_state->reclaimed_slab = 0;
>  			nr_slab = shrink_slab(sc.nr_scanned, GFP_KERNEL,
>  						lru_pages);

I guess for a very small upper zone and a very large lower zone this could
still put the scan balancing out of whack, fixable by a smarter version of
"8*zone->pages_high" but it doesn't seem very likely that this will affect
things much.

Why doesn't direct reclaim need similar treatment?

