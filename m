Return-Path: <linux-kernel-owner+w=401wt.eu-S1757314AbZGPDVy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757314AbZGPDVy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 23:21:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757304AbZGPDVw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 23:21:52 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:43533 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757303AbZGPDVv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 23:21:51 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 16 Jul 2009 12:19:56 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Rik van Riel <riel@redhat.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: [PATCH -mm] throttle direct reclaim when too many pages are
 isolated already
Message-Id: <20090716121956.fc50949f.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090715223854.7548740a@bree.surriel.com>
References: <20090715223854.7548740a@bree.surriel.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Jul 2009 22:38:53 -0400
Rik van Riel <riel@redhat.com> wrote:

> When way too many processes go into direct reclaim, it is possible
> for all of the pages to be taken off the LRU.  One result of this
> is that the next process in the page reclaim code thinks there are
> no reclaimable pages left and triggers an out of memory kill.
> 
> One solution to this problem is to never let so many processes into
> the page reclaim path that the entire LRU is emptied.  Limiting the
> system to only having half of each inactive list isolated for
> reclaim should be safe.
> 
> Signed-off-by: Rik van Riel <riel@redhat.com>
> ---
> This patch goes on top of Kosaki's "Account the number of isolated pages"
> patch series.
> 
>  mm/vmscan.c |   25 +++++++++++++++++++++++++
>  1 file changed, 25 insertions(+)
> 
> Index: mmotm/mm/vmscan.c
> ===================================================================
> --- mmotm.orig/mm/vmscan.c	2009-07-08 21:37:01.000000000 -0400
> +++ mmotm/mm/vmscan.c	2009-07-08 21:39:02.000000000 -0400
> @@ -1035,6 +1035,27 @@ int isolate_lru_page(struct page *page)
>  }
>  
>  /*
> + * Are there way too many processes in the direct reclaim path already?
> + */
> +static int too_many_isolated(struct zone *zone, int file)
> +{
> +	unsigned long inactive, isolated;
> +
> +	if (current_is_kswapd())
> +		return 0;
> +
> +	if (file) {
> +		inactive = zone_page_state(zone, NR_INACTIVE_FILE);
> +		isolated = zone_page_state(zone, NR_ISOLATED_FILE);
> +	} else {
> +		inactive = zone_page_state(zone, NR_INACTIVE_ANON);
> +		isolated = zone_page_state(zone, NR_ISOLATED_ANON);
> +	}
> +
> +	return isolated > inactive;
> +}

Why this means "too much" ?
And, could you put this check under scanning_global_lru(sc) ?

Thanks,
-Kame


> +
> +/*
>   * shrink_inactive_list() is a helper for shrink_zone().  It returns the number
>   * of reclaimed pages
>   */
> @@ -1049,6 +1070,10 @@ static unsigned long shrink_inactive_lis
>  	struct zone_reclaim_stat *reclaim_stat = get_reclaim_stat(zone, sc);
>  	int lumpy_reclaim = 0;
>  
> +	while (unlikely(too_many_isolated(zone, file))) {
> +		schedule_timeout_interruptible(HZ/10);
> +	}
> +
>  	/*
>  	 * If we need a large contiguous chunk of memory, or have
>  	 * trouble getting a small set of contiguous pages, we
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
> 

