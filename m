Return-Path: <linux-kernel-owner+w=401wt.eu-S1754466Ab0ALXCm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754466Ab0ALXCm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 18:02:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753887Ab0ALXCl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 18:02:41 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58655 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752392Ab0ALXCk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 18:02:40 -0500
Date: Tue, 12 Jan 2010 15:01:52 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Mel Gorman <mel@csn.ul.ie>, Rik van Riel <riel@redhat.com>,
       linux-mm <linux-mm@kvack.org>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -mmotm-2010-01-06-14-34] check high watermark after
 shrink zone
Message-Id: <20100112150152.78604b78.akpm@linux-foundation.org>
In-Reply-To: <20100108141235.ef56b567.minchan.kim@barrios-desktop>
References: <20100108141235.ef56b567.minchan.kim@barrios-desktop>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Jan 2010 14:12:35 +0900
Minchan Kim <minchan.kim@gmail.com> wrote:

> Kswapd check that zone have enough free by zone_water_mark.
> If any zone doesn't have enough page, it set all_zones_ok to zero.
> all_zone_ok makes kswapd retry not sleeping.
> 
> I think the watermark check before shrink zone is pointless.
> Kswapd try to shrink zone then the check is meaningul.
> 
> This patch move the check after shrink zone.

The changelog is rather hard to understand.  I changed it to

: Kswapd checks that zone has sufficient pages free via zone_watermark_ok().
: 
: If any zone doesn't have enough pages, we set all_zones_ok to zero. 
: !all_zone_ok makes kswapd retry rather than sleeping.
: 
: I think the watermark check before shrink_zone() is pointless.  Only after
: kswapd has tried to shrink the zone is the check meaningful.
: 
: Move the check to after the call to shrink_zone().


> Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
> CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> CC: Mel Gorman <mel@csn.ul.ie>
> CC: Rik van Riel <riel@redhat.com>
> ---
>  mm/vmscan.c |   21 +++++++++++----------
>  1 files changed, 11 insertions(+), 10 deletions(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 885207a..b81adf8 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -2057,9 +2057,6 @@ loop_again:
>  					priority != DEF_PRIORITY)
>  				continue;
>  
> -			if (!zone_watermark_ok(zone, order,
> -					high_wmark_pages(zone), end_zone, 0))
> -				all_zones_ok = 0;

This will make kswapd stop doing reclaim if all zones have
zone_is_all_unreclaimable():

			if (zone_is_all_unreclaimable(zone))
				continue;

This seems bad.

>  			temp_priority[i] = priority;
>  			sc.nr_scanned = 0;
>  			note_zone_scanning_priority(zone, priority);
> @@ -2099,13 +2096,17 @@ loop_again:
>  			    total_scanned > sc.nr_reclaimed + sc.nr_reclaimed / 2)
>  				sc.may_writepage = 1;
>  
> -			/*
> -			 * We are still under min water mark. it mean we have
> -			 * GFP_ATOMIC allocation failure risk. Hurry up!
> -			 */
> -			if (!zone_watermark_ok(zone, order, min_wmark_pages(zone),
> -					      end_zone, 0))
> -				has_under_min_watermark_zone = 1;
> +			if (!zone_watermark_ok(zone, order,
> +					high_wmark_pages(zone), end_zone, 0)) {
> +				all_zones_ok = 0;
> +				/*
> +				 * We are still under min water mark. it mean we have
> +				 * GFP_ATOMIC allocation failure risk. Hurry up!
> +				 */
> +				if (!zone_watermark_ok(zone, order, min_wmark_pages(zone),
> +						      end_zone, 0))
> +					has_under_min_watermark_zone = 1;
> +			}
>  

The vmscan.c code makes an effort to look nice in an 80-col display.
