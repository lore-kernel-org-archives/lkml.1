Return-Path: <linux-kernel-owner+w=401wt.eu-S1762975AbZFKLdS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762975AbZFKLdS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 07:33:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758048AbZFKLdD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 07:33:03 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:45700 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752108AbZFKLdB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 07:33:01 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH 3/3] Count the number of times zone_reclaim() scans and fails
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>, linuxram@us.ibm.com,
       linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1244717273-15176-4-git-send-email-mel@csn.ul.ie>
References: <1244717273-15176-1-git-send-email-mel@csn.ul.ie> <1244717273-15176-4-git-send-email-mel@csn.ul.ie>
Message-Id: <20090611203232.6D65.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu, 11 Jun 2009 20:33:00 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On NUMA machines, the administrator can configure zone_reclaim_mode that
> is a more targetted form of direct reclaim. On machines with large NUMA
> distances for example, a zone_reclaim_mode defaults to 1 meaning that clean
> unmapped pages will be reclaimed if the zone watermarks are not being met.
> 
> There is a heuristic that determines if the scan is worthwhile but it is
> possible that the heuristic will fail and the CPU gets tied up scanning
> uselessly. Detecting the situation requires some guesswork and experimentation
> so this patch adds a counter "zreclaim_failed" to /proc/vmstat. If during
> high CPU utilisation this counter is increasing rapidly, then the resolution
> to the problem may be to set /proc/sys/vm/zone_reclaim_mode to 0.
> 
> Signed-off-by: Mel Gorman <mel@csn.ul.ie>
> Reviewed-by: Rik van Riel <riel@redhat.com>
> ---
>  include/linux/vmstat.h |    3 +++
>  mm/vmscan.c            |    3 +++
>  mm/vmstat.c            |    3 +++
>  3 files changed, 9 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/vmstat.h b/include/linux/vmstat.h
> index ff4696c..416f748 100644
> --- a/include/linux/vmstat.h
> +++ b/include/linux/vmstat.h
> @@ -36,6 +36,9 @@ enum vm_event_item { PGPGIN, PGPGOUT, PSWPIN, PSWPOUT,
>  		FOR_ALL_ZONES(PGSTEAL),
>  		FOR_ALL_ZONES(PGSCAN_KSWAPD),
>  		FOR_ALL_ZONES(PGSCAN_DIRECT),
> +#ifdef CONFIG_NUMA
> +		PGSCAN_ZONERECLAIM_FAILED,
> +#endif
>  		PGINODESTEAL, SLABS_SCANNED, KSWAPD_STEAL, KSWAPD_INODESTEAL,
>  		PAGEOUTRUN, ALLOCSTALL, PGROTATED,
>  #ifdef CONFIG_HUGETLB_PAGE
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 7b8eb3f..42c1013 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -2492,6 +2492,9 @@ int zone_reclaim(struct zone *zone, gfp_t gfp_mask, unsigned int order)
>  	ret = __zone_reclaim(zone, gfp_mask, order);
>  	zone_clear_flag(zone, ZONE_RECLAIM_LOCKED);
>  
> +	if (!ret)
> +		count_vm_event(PGSCAN_ZONERECLAIM_FAILED);
> +
>  	return ret;
>  }
>  #endif
> diff --git a/mm/vmstat.c b/mm/vmstat.c
> index 1e3aa81..02677d1 100644
> --- a/mm/vmstat.c
> +++ b/mm/vmstat.c
> @@ -673,6 +673,9 @@ static const char * const vmstat_text[] = {
>  	TEXTS_FOR_ZONES("pgscan_kswapd")
>  	TEXTS_FOR_ZONES("pgscan_direct")
>  
> +#ifdef CONFIG_NUMA
> +	"zreclaim_failed",
> +#endif
>  	"pginodesteal",
>  	"slabs_scanned",
>  	"kswapd_steal",

Looks good.
	Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>



