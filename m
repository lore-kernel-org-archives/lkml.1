Return-Path: <linux-kernel-owner+w=401wt.eu-S1754022AbZLGGRq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754022AbZLGGRq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 01:17:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753279AbZLGGRp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 01:17:45 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:36709 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752858AbZLGGRo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 01:17:44 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: [PATCH] vmscan: aligned scan batching
Cc: kosaki.motohiro@jp.fujitsu.com, LKML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>
In-Reply-To: <20091206054113.GA23912@localhost>
References: <20091127091357.A7CC.A69D9226@jp.fujitsu.com> <20091206054113.GA23912@localhost>
Message-Id: <20091207143548.E944.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Mon,  7 Dec 2009 15:17:48 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >  - pass nr_to_scan into isolate_pages() directly instead
> >    using SWAP_CLUSTER_MAX
> 
> This patch will make sure nr_to_scan==SWAP_CLUSTER_MAX :)
> 
> Thanks,
> Fengguang
> ---
> vmscan: aligned scan batching
> 
> Make sure ->isolate_pages() always scans in unit of SWAP_CLUSTER_MAX.
> 
> CC: Rik van Riel <riel@redhat.com>
> CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
> ---
>  mm/vmscan.c |   20 ++++++--------------
>  1 file changed, 6 insertions(+), 14 deletions(-)

Hm, Your patch always pass SWAP_CLUSTER_MAX to shrink_list().
Can we remove nr_to_scan argument of shrink_list() completely?

Anyway, this diffstat itsef explain this patch's worth. I'll queue
this patch into my vmscan cleanup branch.


> 
> --- linux-mm.orig/mm/vmscan.c	2009-12-06 13:13:28.000000000 +0800
> +++ linux-mm/mm/vmscan.c	2009-12-06 13:31:21.000000000 +0800
> @@ -1572,15 +1572,11 @@ static void get_scan_ratio(struct zone *
>  static unsigned long nr_scan_try_batch(unsigned long nr_to_scan,
>  				       unsigned long *nr_saved_scan)
>  {
> -	unsigned long nr;
> +	unsigned long nr = *nr_saved_scan + nr_to_scan;
> +	unsigned long rem = nr & (SWAP_CLUSTER_MAX - 1);
>  
> -	*nr_saved_scan += nr_to_scan;
> -	nr = *nr_saved_scan;
> -
> -	if (nr >= SWAP_CLUSTER_MAX)
> -		*nr_saved_scan = 0;
> -	else
> -		nr = 0;
> +	*nr_saved_scan = rem;
> +	nr -= rem;
>  
>  	return nr;
>  }
> @@ -1592,7 +1588,6 @@ static void shrink_zone(int priority, st
>  				struct scan_control *sc)
>  {
>  	unsigned long nr[NR_LRU_LISTS];
> -	unsigned long nr_to_scan;
>  	unsigned long percent[2];	/* anon @ 0; file @ 1 */
>  	enum lru_list l;
>  	unsigned long nr_reclaimed = sc->nr_reclaimed;
> @@ -1625,11 +1620,8 @@ static void shrink_zone(int priority, st
>  					nr[LRU_INACTIVE_FILE]) {
>  		for_each_evictable_lru(l) {
>  			if (nr[l]) {
> -				nr_to_scan = min_t(unsigned long,
> -						   nr[l], SWAP_CLUSTER_MAX);
> -				nr[l] -= nr_to_scan;
> -
> -				nr_reclaimed += shrink_list(l, nr_to_scan,
> +				nr[l] -= SWAP_CLUSTER_MAX;
> +				nr_reclaimed += shrink_list(l, SWAP_CLUSTER_MAX,
>  							    zone, sc, priority);
>  			}
>  		}



