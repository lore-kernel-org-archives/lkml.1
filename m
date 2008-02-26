Return-Path: <linux-kernel-owner+w=401wt.eu-S1765127AbYBZVTj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765127AbYBZVTj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 16:19:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753579AbYBZVTb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 16:19:31 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:52887 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750820AbYBZVTa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 16:19:30 -0500
Subject: Re: [RFC][PATCH] page reclaim throttle take2
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Rik van Riel <riel@redhat.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Nick Piggin <npiggin@suse.de>
In-Reply-To: <20080226104647.FF26.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <20080226104647.FF26.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Content-Type: text/plain
Date: Tue, 26 Feb 2008 22:18:38 +0100
Message-Id: <1204060718.6242.333.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.90 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-02-26 at 11:32 +0900, KOSAKI Motohiro wrote:

> Index: b/include/linux/mmzone.h
> ===================================================================
> --- a/include/linux/mmzone.h	2008-02-25 21:37:49.000000000 +0900
> +++ b/include/linux/mmzone.h	2008-02-26 10:12:12.000000000 +0900
> @@ -335,6 +335,9 @@ struct zone {
>  	unsigned long		spanned_pages;	/* total size, including holes */
>  	unsigned long		present_pages;	/* amount of memory (excluding holes) */
>  
> +
> +	atomic_t		nr_reclaimers;
> +	wait_queue_head_t	reclaim_throttle_waitq;
>  	/*
>  	 * rarely used fields:
>  	 */

Small nit, that extra blank line seems at the wrong end of the text
block :-)

> Index: b/mm/vmscan.c
> ===================================================================
> --- a/mm/vmscan.c	2008-02-25 21:37:49.000000000 +0900
> +++ b/mm/vmscan.c	2008-02-26 10:59:38.000000000 +0900
> @@ -1252,6 +1252,55 @@ static unsigned long shrink_zone(int pri
>  	return nr_reclaimed;
>  }
>  
> +
> +#define RECLAIM_LIMIT (3)
> +
> +static int do_shrink_zone_throttled(int priority, struct zone *zone,
> +				    struct scan_control *sc,
> +				    unsigned long *ret_reclaimed)
> +{
> +	u64 start_time;
> +	int ret = 0;
> +
> +	start_time = jiffies_64;
> +
> +	wait_event(zone->reclaim_throttle_waitq,
> +		   atomic_add_unless(&zone->nr_reclaimers, 1, RECLAIM_LIMIT));
> +
> +	/* more reclaim until needed? */
> +	if (scan_global_lru(sc) &&
> +	    !(current->flags & PF_KSWAPD) &&
> +	    time_after64(jiffies, start_time + HZ/10)) {
> +		if (zone_watermark_ok(zone, sc->order, 4*zone->pages_high,
> +				      MAX_NR_ZONES-1, 0)) {
> +			ret = -EAGAIN;
> +			goto out;
> +		}
> +	}
> +
> +	*ret_reclaimed += shrink_zone(priority, zone, sc);
> +
> +out:
> +	atomic_dec(&zone->nr_reclaimers);
> +	wake_up_all(&zone->reclaim_throttle_waitq);
> +
> +	return ret;
> +}

Would it be possible - and worthwhile - to make this FIFO fair?

