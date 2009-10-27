Return-Path: <linux-kernel-owner+w=401wt.eu-S1756102AbZJ0Cm6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756102AbZJ0Cm6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 22:42:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753500AbZJ0Cm4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 22:42:56 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:51759 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752889AbZJ0Cmz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 22:42:55 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH 3/5] vmscan: Force kswapd to take notice faster when high-order watermarks are being hit
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
In-Reply-To: <1256221356-26049-4-git-send-email-mel@csn.ul.ie>
References: <1256221356-26049-1-git-send-email-mel@csn.ul.ie> <1256221356-26049-4-git-send-email-mel@csn.ul.ie>
Message-Id: <20091026232924.2F75.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue, 27 Oct 2009 11:42:55 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> When a high-order allocation fails, kswapd is kicked so that it reclaims
> at a higher-order to avoid direct reclaimers stall and to help GFP_ATOMIC
> allocations. Something has changed in recent kernels that affect the timing
> where high-order GFP_ATOMIC allocations are now failing with more frequency,
> particularly under pressure. This patch forces kswapd to notice sooner that
> high-order allocations are occuring.
> 
> Signed-off-by: Mel Gorman <mel@csn.ul.ie>
> ---
>  mm/vmscan.c |    9 +++++++++
>  1 files changed, 9 insertions(+), 0 deletions(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 64e4388..cd68109 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -2016,6 +2016,15 @@ loop_again:
>  					priority != DEF_PRIORITY)
>  				continue;
>  
> +			/*
> +			 * Exit quickly to restart if it has been indicated
> +			 * that higher orders are required
> +			 */
> +			if (pgdat->kswapd_max_order > order) {
> +				all_zones_ok = 1;
> +				goto out;
> +			}
> +
>  			if (!zone_watermark_ok(zone, order,
>  					high_wmark_pages(zone), end_zone, 0))
>  				all_zones_ok = 0;

this is simplest patch and seems reasonable.
	Reviewed-by: KOSAKI Motohiro <kosaki.motohiro>


btw, now balance_pgdat() have too complex flow. at least Vincent was
confused it.
Then, I think kswap_max_order handling should move into balance_pgdat()
at later release.
the following patch addressed my proposed concept.



>From 2c5be772f6db25a5ef82975960d0b5788736ec2b Mon Sep 17 00:00:00 2001
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Date: Mon, 26 Oct 2009 23:25:29 +0900
Subject: [PATCH] kswapd_max_order handling move into balance_pgdat()

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 mm/vmscan.c |   45 +++++++++++++++++++++------------------------
 1 files changed, 21 insertions(+), 24 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 64e4388..49001d3 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1915,7 +1915,7 @@ unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *mem_cont,
  * interoperates with the page allocator fallback scheme to ensure that aging
  * of pages is balanced across the zones.
  */
-static unsigned long balance_pgdat(pg_data_t *pgdat, int order)
+static unsigned long balance_pgdat(pg_data_t *pgdat)
 {
 	int all_zones_ok;
 	int priority;
@@ -1928,7 +1928,7 @@ static unsigned long balance_pgdat(pg_data_t *pgdat, int order)
 		.may_swap = 1,
 		.swap_cluster_max = SWAP_CLUSTER_MAX,
 		.swappiness = vm_swappiness,
-		.order = order,
+		.order = 0,
 		.mem_cgroup = NULL,
 		.isolate_pages = isolate_pages_global,
 	};
@@ -1938,6 +1938,8 @@ static unsigned long balance_pgdat(pg_data_t *pgdat, int order)
 	 * free_pages == high_wmark_pages(zone).
 	 */
 	int temp_priority[MAX_NR_ZONES];
+	int order = 0;
+	int new_order;
 
 loop_again:
 	total_scanned = 0;
@@ -1945,6 +1947,11 @@ loop_again:
 	sc.may_writepage = !laptop_mode;
 	count_vm_event(PAGEOUTRUN);
 
+	new_order = pgdat->kswapd_max_order;
+	pgdat->kswapd_max_order = 0;
+	if (order < new_order)
+		order = sc.order = new_order;
+
 	for (i = 0; i < pgdat->nr_zones; i++)
 		temp_priority[i] = DEF_PRIORITY;
 
@@ -2087,11 +2094,17 @@ out:
 
 		zone->prev_priority = temp_priority[i];
 	}
-	if (!all_zones_ok) {
-		cond_resched();
 
-		try_to_freeze();
+	cond_resched();
+	try_to_freeze();
 
+	/*
+	 * restart if someone wants a larger 'order' allocation
+	 */
+	if (order < pgdat->kswapd_max_order)
+		goto loop_again;
+
+	if (!all_zones_ok) {
 		/*
 		 * Fragmentation may mean that the system cannot be
 		 * rebalanced for high-order allocations in all zones.
@@ -2130,7 +2143,6 @@ out:
  */
 static int kswapd(void *p)
 {
-	unsigned long order;
 	pg_data_t *pgdat = (pg_data_t*)p;
 	struct task_struct *tsk = current;
 	DEFINE_WAIT(wait);
@@ -2160,32 +2172,17 @@ static int kswapd(void *p)
 	tsk->flags |= PF_MEMALLOC | PF_SWAPWRITE | PF_KSWAPD;
 	set_freezable();
 
-	order = 0;
 	for ( ; ; ) {
-		unsigned long new_order;
-
 		prepare_to_wait(&pgdat->kswapd_wait, &wait, TASK_INTERRUPTIBLE);
-		new_order = pgdat->kswapd_max_order;
-		pgdat->kswapd_max_order = 0;
-		if (order < new_order) {
-			/*
-			 * Don't sleep if someone wants a larger 'order'
-			 * allocation
-			 */
-			order = new_order;
-		} else {
-			if (!freezing(current))
-				schedule();
-
-			order = pgdat->kswapd_max_order;
-		}
+		if (!freezing(current))
+			schedule();
 		finish_wait(&pgdat->kswapd_wait, &wait);
 
 		if (!try_to_freeze()) {
 			/* We can speed up thawing tasks if we don't call
 			 * balance_pgdat after returning from the refrigerator
 			 */
-			balance_pgdat(pgdat, order);
+			balance_pgdat(pgdat);
 		}
 	}
 	return 0;
-- 
1.6.2.5






