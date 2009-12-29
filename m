Return-Path: <linux-kernel-owner+w=401wt.eu-S1752601AbZL2HeU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752601AbZL2HeU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 02:34:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751533AbZL2HeT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 02:34:19 -0500
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:41557 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751359AbZL2HeT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 02:34:19 -0500
Date: Tue, 29 Dec 2009 13:04:12 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH 2/4] vmscan: get_scan_ratio cleanup
Message-ID: <20091229073412.GN3601@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20091228164451.A687.A69D9226@jp.fujitsu.com>
 <20091228164733.A68A.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20091228164733.A68A.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> [2009-12-28 16:48:06]:

> The get_scan_ratio() should have all scan-ratio related calculations.
> Thus, this patch move some calculation into get_scan_ratio.
> 
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> ---
>  mm/vmscan.c |   23 ++++++++++++++---------
>  1 files changed, 14 insertions(+), 9 deletions(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 2bbee91..640486b 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -1501,6 +1501,13 @@ static void get_scan_ratio(struct zone *zone, struct scan_control *sc,
>  	unsigned long ap, fp;
>  	struct zone_reclaim_stat *reclaim_stat = get_reclaim_stat(zone, sc);
> 
> +	/* If we have no swap space, do not bother scanning anon pages. */
> +	if (!sc->may_swap || (nr_swap_pages <= 0)) {
> +		percent[0] = 0;
> +		percent[1] = 100;
> +		return;
> +	}
> +


>  	anon  = zone_nr_lru_pages(zone, sc, LRU_ACTIVE_ANON) +
>  		zone_nr_lru_pages(zone, sc, LRU_INACTIVE_ANON);
>  	file  = zone_nr_lru_pages(zone, sc, LRU_ACTIVE_FILE) +
> @@ -1598,22 +1605,20 @@ static void shrink_zone(int priority, struct zone *zone,
>  	unsigned long nr_reclaimed = sc->nr_reclaimed;
>  	unsigned long nr_to_reclaim = sc->nr_to_reclaim;
>  	struct zone_reclaim_stat *reclaim_stat = get_reclaim_stat(zone, sc);
> -	int noswap = 0;
> 
> -	/* If we have no swap space, do not bother scanning anon pages. */
> -	if (!sc->may_swap || (nr_swap_pages <= 0)) {
> -		noswap = 1;
> -		percent[0] = 0;
> -		percent[1] = 100;
> -	} else
> -		get_scan_ratio(zone, sc, percent);
> +	get_scan_ratio(zone, sc, percent);

Where do we set noswap? Is percent[0] == 0 used to indicate noswap =
1?

> 
>  	for_each_evictable_lru(l) {
>  		int file = is_file_lru(l);
>  		unsigned long scan;
> 
> +		if (percent[file] == 0) {
> +			nr[l] = 0;
> +			continue;
> +		}
> +

Is this really needed? Won't nr_scan_try_batch handle it correctly?

>  		scan = zone_nr_lru_pages(zone, sc, l);
> -		if (priority || noswap) {
> +		if (priority) {
>  			scan >>= priority;
>  			scan = (scan * percent[file]) / 100;
>  		}

-- 
	Balbir
