Return-Path: <linux-kernel-owner+w=401wt.eu-S1752532Ab0AHFah@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752532Ab0AHFah (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 00:30:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751802Ab0AHFaf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 00:30:35 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:44771 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750800Ab0AHFaf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 00:30:35 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [PATCH -mmotm-2010-01-06-14-34] check high watermark after shrink zone
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
       Mel Gorman <mel@csn.ul.ie>, Rik van Riel <riel@redhat.com>,
       linux-mm <linux-mm@kvack.org>, lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <20100108141235.ef56b567.minchan.kim@barrios-desktop>
References: <20100108141235.ef56b567.minchan.kim@barrios-desktop>
Message-Id: <20100108141654.C13E.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Fri,  8 Jan 2010 14:30:30 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Kswapd check that zone have enough free by zone_water_mark.
> If any zone doesn't have enough page, it set all_zones_ok to zero.
> all_zone_ok makes kswapd retry not sleeping.
> 
> I think the watermark check before shrink zone is pointless.
> Kswapd try to shrink zone then the check is meaningul.

probably s/meaningul/meaningful/ ?

	Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>


> 
> This patch move the check after shrink zone.
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



