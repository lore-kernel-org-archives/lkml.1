Return-Path: <linux-kernel-owner+w=401wt.eu-S1755093AbYK1Laf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755093AbYK1Laf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2008 06:30:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752234AbYK1LaZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Nov 2008 06:30:25 -0500
Received: from casper.infradead.org ([85.118.1.10]:51141 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752343AbYK1LaY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2008 06:30:24 -0500
Subject: Re: [PATCH] vmscan: skip freeing memory from zones with lots free
From: Peter Zijlstra <peterz@infradead.org>
To: Rik van Riel <riel@redhat.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       akpm@linux-foundation.org
In-Reply-To: <20081128060803.73cd59bd@bree.surriel.com>
References: <20081128060803.73cd59bd@bree.surriel.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Fri, 28 Nov 2008 12:30:14 +0100
Message-Id: <1227871814.4454.3855.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-11-28 at 06:08 -0500, Rik van Riel wrote:
> Skip freeing memory from zones that already have lots of free memory.
> If one memory zone has harder to free memory, we want to avoid freeing
> excessive amounts of memory from other zones, if only because pageout
> IO from the other zones can slow down page freeing from the problem zone.
> 
> This is similar to the check already done by kswapd in balance_pgdat().
> 
> Signed-off-by: Rik van Riel <riel@redhat.com>

Make sense,

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

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
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
