Return-Path: <linux-kernel-owner+w=401wt.eu-S1757677AbZFJByG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757677AbZFJByG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 21:54:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754554AbZFJBx4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 21:53:56 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:60657 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751797AbZFJBxz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 21:53:55 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH 4/4] Reintroduce zone_reclaim_interval for when zone_reclaim() scans and fails to avoid CPU spinning at 100% on NUMA
Cc: kosaki.motohiro@jp.fujitsu.com, Rik van Riel <riel@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>, yanmin.zhang@intel.com,
       Wu Fengguang <fengguang.wu@intel.com>, linuxram@us.ibm.com,
       linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1244566904-31470-5-git-send-email-mel@csn.ul.ie>
References: <1244566904-31470-1-git-send-email-mel@csn.ul.ie> <1244566904-31470-5-git-send-email-mel@csn.ul.ie>
Message-Id: <20090610105231.DDAC.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed, 10 Jun 2009 10:53:55 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +
> +zone_reclaim_interval:
> +
> +The time allowed for off-node allocations after zone reclaim
> +has failed to reclaim enough pages to allow a local allocation.
> +
> +Time is set in seconds and set by default to 30 seconds.
> +
> +Reduce the interval if undesired off-node allocations occur or
> +set to 0 to always try and reclaim pages for node-local memory.
> +However, too frequent scans will have a negative impact on
> +off-node allocation performance and manifest as high CPU usage.
> +

good documentaion :)

	Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

 -kosaki



>  ============ End of Document =================================
> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> index 8895985..3a53e1c 100644
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -335,6 +335,15 @@ struct zone {
>  	atomic_long_t		vm_stat[NR_VM_ZONE_STAT_ITEMS];
>  
>  	/*
> +	 * timestamp (in jiffies) of the last zone_reclaim that scanned
> +	 * but failed to free enough pages. This is used to avoid repeated
> +	 * scans when zone_reclaim() is unable to detect in advance that
> +	 * the scanning is useless. This can happen for example if a zone
> +	 * has large numbers of clean unmapped file pages on tmpfs
> +	 */
> +	unsigned long		zone_reclaim_failure;
> +
> +	/*
>  	 * prev_priority holds the scanning priority for this zone.  It is
>  	 * defined as the scanning priority at which we achieved our reclaim
>  	 * target at the previous try_to_free_pages() or balance_pgdat()
> diff --git a/include/linux/swap.h b/include/linux/swap.h
> index c88b366..28a01e3 100644
> --- a/include/linux/swap.h
> +++ b/include/linux/swap.h
> @@ -225,6 +225,7 @@ extern long vm_total_pages;
>  
>  #ifdef CONFIG_NUMA
>  extern int zone_reclaim_mode;
> +extern int zone_reclaim_interval;
>  extern int sysctl_min_unmapped_ratio;
>  extern int sysctl_min_slab_ratio;
>  extern int zone_reclaim(struct zone *, gfp_t, unsigned int);
> diff --git a/kernel/sysctl.c b/kernel/sysctl.c
> index 0554886..2afffa5 100644
> --- a/kernel/sysctl.c
> +++ b/kernel/sysctl.c
> @@ -1221,6 +1221,15 @@ static struct ctl_table vm_table[] = {
>  		.extra1		= &zero,
>  	},
>  	{
> +		.ctl_name       = CTL_UNNUMBERED,
> +		.procname       = "zone_reclaim_interval",
> +		.data           = &zone_reclaim_interval,
> +		.maxlen         = sizeof(zone_reclaim_interval),
> +		.mode           = 0644,
> +		.proc_handler   = &proc_dointvec_jiffies,
> +		.strategy       = &sysctl_jiffies,
> +	},
> +	{
>  		.ctl_name	= VM_MIN_UNMAPPED,
>  		.procname	= "min_unmapped_ratio",
>  		.data		= &sysctl_min_unmapped_ratio,
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 8be4582..5fa4843 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -2315,6 +2315,13 @@ int zone_reclaim_mode __read_mostly;
>  #define RECLAIM_SWAP (1<<2)	/* Swap pages out during reclaim */
>  
>  /*
> + * Minimum time between zone_reclaim() scans that failed. Ordinarily, a
> + * scan will not fail because it will be determined in advance if it can
> + * succeeed but this does not always work. See mmzone.h
> + */
> +int zone_reclaim_interval __read_mostly = 30*HZ;
> +
> +/*
>   * Priority for ZONE_RECLAIM. This determines the fraction of pages
>   * of a node considered for each zone_reclaim. 4 scans 1/16th of
>   * a zone.
> @@ -2464,6 +2471,15 @@ int zone_reclaim(struct zone *zone, gfp_t gfp_mask, unsigned int order)
>  	    zone_page_state(zone, NR_SLAB_RECLAIMABLE) <= zone->min_slab_pages)
>  		return ZONE_RECLAIM_FULL;
>  
> +	/* Watch for jiffie wraparound */
> +	if (unlikely(jiffies < zone->zone_reclaim_failure))
> +		zone->zone_reclaim_failure = jiffies;
> +
> +	/* Do not attempt a scan if scanning failed recently */
> +	if (time_before(jiffies,
> +			zone->zone_reclaim_failure + zone_reclaim_interval))
> +		return ZONE_RECLAIM_FULL;
> +
>  	if (zone_is_all_unreclaimable(zone))
>  		return ZONE_RECLAIM_FULL;
>  
> @@ -2491,6 +2507,14 @@ int zone_reclaim(struct zone *zone, gfp_t gfp_mask, unsigned int order)
>  
>  	if (!ret) {
>  		count_vm_events(PGSCAN_ZONERECLAIM_FAILED, 1);
> +
> +		/*
> +		 * We were unable to reclaim enough pages to stay on node and
> +		 * unable to detect in advance that the scan would fail. Allow
> +		 * off node accesses for zone_reclaim_inteval jiffies before
> +		 * trying zone_reclaim() again
> +		 */
> +		zone->zone_reclaim_failure = jiffies;
>  	}
>  
>  	return ret;
> -- 
> 1.5.6.5
> 



