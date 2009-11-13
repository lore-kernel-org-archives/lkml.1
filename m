Return-Path: <linux-kernel-owner+w=401wt.eu-S1756361AbZKMKnS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756361AbZKMKnS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 05:43:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932114AbZKMKnL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 05:43:11 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:56454 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932082AbZKMKnH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 05:43:07 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH 4/5] vmscan: Have kswapd sleep for a short interval and double check it should be asleep
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
       Frans Pop <elendil@planet.nl>, Jiri Kosina <jkosina@suse.cz>,
       Sven Geggus <lists@fuchsschwanzdomain.de>,
       Karol Lewandowski <karol.k.lewandowski@gmail.com>,
       Tobias Oetiker <tobi@oetiker.ch>, linux-kernel@vger.kernel.org,
       "linux-mm@kvack.org\"" <linux-mm@kvack.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Rik van Riel <riel@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Stephan von Krawczynski <skraw@ithnet.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
In-Reply-To: <1258054235-3208-5-git-send-email-mel@csn.ul.ie>
References: <1258054235-3208-1-git-send-email-mel@csn.ul.ie> <1258054235-3208-5-git-send-email-mel@csn.ul.ie>
Message-Id: <20091113142558.33B6.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Fri, 13 Nov 2009 19:43:09 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> After kswapd balances all zones in a pgdat, it goes to sleep. In the event
> of no IO congestion, kswapd can go to sleep very shortly after the high
> watermark was reached. If there are a constant stream of allocations from
> parallel processes, it can mean that kswapd went to sleep too quickly and
> the high watermark is not being maintained for sufficient length time.
> 
> This patch makes kswapd go to sleep as a two-stage process. It first
> tries to sleep for HZ/10. If it is woken up by another process or the
> high watermark is no longer met, it's considered a premature sleep and
> kswapd continues work. Otherwise it goes fully to sleep.
> 
> This adds more counters to distinguish between fast and slow breaches of
> watermarks. A "fast" premature sleep is one where the low watermark was
> hit in a very short time after kswapd going to sleep. A "slow" premature
> sleep indicates that the high watermark was breached after a very short
> interval.
> 
> Signed-off-by: Mel Gorman <mel@csn.ul.ie>

Why do you submit this patch to mainline? this is debugging patch
no more and no less.


> ---
>  include/linux/vmstat.h |    1 +
>  mm/vmscan.c            |   44 ++++++++++++++++++++++++++++++++++++++++++--
>  mm/vmstat.c            |    2 ++
>  3 files changed, 45 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/vmstat.h b/include/linux/vmstat.h
> index 2d0f222..9716003 100644
> --- a/include/linux/vmstat.h
> +++ b/include/linux/vmstat.h
> @@ -40,6 +40,7 @@ enum vm_event_item { PGPGIN, PGPGOUT, PSWPIN, PSWPOUT,
>  		PGSCAN_ZONE_RECLAIM_FAILED,
>  #endif
>  		PGINODESTEAL, SLABS_SCANNED, KSWAPD_STEAL, KSWAPD_INODESTEAL,
> +		KSWAPD_PREMATURE_FAST, KSWAPD_PREMATURE_SLOW,
>  		PAGEOUTRUN, ALLOCSTALL, PGROTATED,

Please don't use the word of "premature" and "fast". it is too hard to understand the meanings.
Plus, please use per-zone stastics (like NUMA_HIT).

>
>  #ifdef CONFIG_HUGETLB_PAGE
>  		HTLB_BUDDY_PGALLOC, HTLB_BUDDY_PGALLOC_FAIL,
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 190bae1..ffa1766 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -1904,6 +1904,24 @@ unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *mem_cont,
>  }
>  #endif
>  
> +/* is kswapd sleeping prematurely? */
> +static int sleeping_prematurely(int order, long remaining)
> +{
> +	struct zone *zone;
> +
> +	/* If a direct reclaimer woke kswapd within HZ/10, it's premature */
> +	if (remaining)
> +		return 1;
> +
> +	/* If after HZ/10, a zone is below the high mark, it's premature */
> +	for_each_populated_zone(zone)
> +		if (!zone_watermark_ok(zone, order, high_wmark_pages(zone),
> +								0, 0))
> +			return 1;

for_each_populated_zone() iterate all populated zone. but kswapd shuld't see another node.

> +
> +	return 0;
> +}
> +
>  /*
>   * For kswapd, balance_pgdat() will work across all this node's zones until
>   * they are all at high_wmark_pages(zone).
> @@ -2184,8 +2202,30 @@ static int kswapd(void *p)
>  			 */
>  			order = new_order;
>  		} else {
> -			if (!freezing(current))
> -				schedule();
> +			if (!freezing(current)) {
> +				long remaining = 0;
> +
> +				/* Try to sleep for a short interval */
> +				if (!sleeping_prematurely(order, remaining)) {
> +					remaining = schedule_timeout(HZ/10);
> +					finish_wait(&pgdat->kswapd_wait, &wait);
> +					prepare_to_wait(&pgdat->kswapd_wait, &wait, TASK_INTERRUPTIBLE);
> +				}
> +
> +				/*
> +				 * After a short sleep, check if it was a
> +				 * premature sleep. If not, then go fully
> +				 * to sleep until explicitly woken up
> +				 */
> +				if (!sleeping_prematurely(order, remaining))
> +					schedule();
> +				else {
> +					if (remaining)
> +						count_vm_event(KSWAPD_PREMATURE_FAST);
> +					else
> +						count_vm_event(KSWAPD_PREMATURE_SLOW);
> +				}
> +			}
>  
>  			order = pgdat->kswapd_max_order;
>  		}
> diff --git a/mm/vmstat.c b/mm/vmstat.c
> index c81321f..90b11e4 100644
> --- a/mm/vmstat.c
> +++ b/mm/vmstat.c
> @@ -683,6 +683,8 @@ static const char * const vmstat_text[] = {
>  	"slabs_scanned",
>  	"kswapd_steal",
>  	"kswapd_inodesteal",
> +	"kswapd_slept_prematurely_fast",
> +	"kswapd_slept_prematurely_slow",
>  	"pageoutrun",
>  	"allocstall",
>  
> -- 
> 1.6.5
> 



