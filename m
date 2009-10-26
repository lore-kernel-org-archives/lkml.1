Return-Path: <linux-kernel-owner+w=401wt.eu-S1754456AbZJZBLa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754456AbZJZBLa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Oct 2009 21:11:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754442AbZJZBL3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Oct 2009 21:11:29 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:55037 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754338AbZJZBL2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Oct 2009 21:11:28 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH 1/5] page allocator: Always wake kswapd when restarting an allocation attempt after direct reclaim failed
Cc: kosaki.motohiro@jp.fujitsu.com, Frans Pop <elendil@planet.nl>,
       Jiri Kosina <jkosina@suse.cz>,
       Sven Geggus <lists@fuchsschwanzdomain.de>,
       Karol Lewandowski <karol.k.lewandowski@gmail.com>,
       Tobias Oetiker <tobi@oetiker.ch>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       David Miller <davem@davemloft.net>,
       Reinette Chatre <reinette.chatre@intel.com>,
       Kalle Valo <kalle.valo@iki.fi>, David Rientjes <rientjes@google.com>,
       Mohamed Abbas <mohamed.abbas@intel.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Stephan von Krawczynski <skraw@ithnet.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       "linux-mm@kvack.org\"" <linux-mm@kvack.org>
In-Reply-To: <1256221356-26049-2-git-send-email-mel@csn.ul.ie>
References: <1256221356-26049-1-git-send-email-mel@csn.ul.ie> <1256221356-26049-2-git-send-email-mel@csn.ul.ie>
Message-Id: <20091026100019.2F4A.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Mon, 26 Oct 2009 10:11:29 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> If a direct reclaim makes no forward progress, it considers whether it
> should go OOM or not. Whether OOM is triggered or not, it may retry the
> application afterwards. In times past, this would always wake kswapd as well
> but currently, kswapd is not woken up after direct reclaim fails. For order-0
> allocations, this makes little difference but if there is a heavy mix of
> higher-order allocations that direct reclaim is failing for, it might mean
> that kswapd is not rewoken for higher orders as much as it did previously.
> 
> This patch wakes up kswapd when an allocation is being retried after a direct
> reclaim failure. It would be expected that kswapd is already awake, but
> this has the effect of telling kswapd to reclaim at the higher order as well.
> 
> Signed-off-by: Mel Gorman <mel@csn.ul.ie>
> ---
>  mm/page_alloc.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index bf72055..dfa4362 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -1817,9 +1817,9 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
>  	if (NUMA_BUILD && (gfp_mask & GFP_THISNODE) == GFP_THISNODE)
>  		goto nopage;
>  
> +restart:
>  	wake_all_kswapd(order, zonelist, high_zoneidx);
>  
> -restart:
>  	/*
>  	 * OK, we're below the kswapd watermark and have kicked background
>  	 * reclaim. Now things get more complex, so set up alloc_flags according

I think this patch is correct. personally, I like to add some commnent
at restart label. but it isn't big matter.
	Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

However, I have a question. __alloc_pages_slowpath() retry logic is,

1. try_to_free_pages() reclaimed some pages:
	-> wait awhile and goto rebalance
2. try_to_free_pages() didn't reclaimed any page:
	-> call out_of_memory() and goto restart

Then, case-1 should be fixed too? 
I mean,

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index bf72055..5a27896 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1899,6 +1899,12 @@ rebalance:
 	if (should_alloc_retry(gfp_mask, order, pages_reclaimed)) {
 		/* Wait for some write requests to complete then retry */
 		congestion_wait(BLK_RW_ASYNC, HZ/50);
+
+		/*
+		 * While we wait congestion wait, Amount of free memory can
+		 * be changed dramatically. Thus, we kick kswapd again.
+		 */
+		wake_all_kswapd(order, zonelist, high_zoneidx);
 		goto rebalance;
 	}
 
-------------------------------------------

?



