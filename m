Return-Path: <linux-kernel-owner+w=401wt.eu-S1758388AbZENHUH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758388AbZENHUH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 03:20:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754365AbZENHTy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 03:19:54 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:39982 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751738AbZENHTx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 03:19:53 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [PATCH] Prevent shrinking of active anon lru list in case of no swap space
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Johannes Weiner <hannes@cmpxchg.org>, Rik van Riel <riel@redhat.com>
In-Reply-To: <20090514141025.239cafe5.minchan.kim@barrios-desktop>
References: <20090514141025.239cafe5.minchan.kim@barrios-desktop>
Message-Id: <20090514155504.9B66.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu, 14 May 2009 16:19:52 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> Now shrink_active_list is called several places.
> But if we don't have a swap space, we can't reclaim anon pages.
> So, we don't need deactivating anon pages in anon lru list.
> 
> Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
> Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Rik van Riel <riel@redhat.com>

hm, The analysis seems right. but

In general branch should put into non frequency path.
why caller modification as following patch is wrong?

                        /*
                         * Do some background aging of the anon list, to give
                         * pages a chance to be referenced before reclaiming.
                         */
-                        if (inactive_anon_is_low(zone, &sc))
+                        if (inactive_anon_is_low(zone, &sc) && (nr_swap_pages <= 0))
                                shrink_active_list(SWAP_CLUSTER_MAX, zone,
                                                        &sc, priority, 0);




> ---
>  mm/vmscan.c |    6 ++++++
>  1 files changed, 6 insertions(+), 0 deletions(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 2f9d555..e4d71f4 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -1238,6 +1238,12 @@ static void shrink_active_list(unsigned long nr_pages, struct zone *zone,
>  	enum lru_list lru;
>  	struct zone_reclaim_stat *reclaim_stat = get_reclaim_stat(zone, sc);
>  
> +	/* 
> +	 * we can't shrink anon list in case of no swap space.
> +	 */
> +	if (file == 0 && nr_swap_pages <= 0)
> +		return;
> +
>
>  	lru_add_drain();
>  	spin_lock_irq(&zone->lru_lock);
>  	pgmoved = sc->isolate_pages(nr_pages, &l_hold, &pgscanned, sc->order,
> -- 
> 1.5.4.3
> 
> 
> -- 
> Kinds Regards
> Minchan Kim



