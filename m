Return-Path: <linux-kernel-owner+w=401wt.eu-S932887AbZGPRdq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932887AbZGPRdq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 13:33:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932867AbZGPRdq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 13:33:46 -0400
Received: from cmpxchg.org ([85.214.51.133]:33279 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932844AbZGPRdp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 13:33:45 -0400
Date: Thu, 16 Jul 2009 19:32:49 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>, Rik van Riel <riel@redhat.com>,
       Minchan Kim <minchan.kim@gmail.com>,
       Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [PATCH 1/3] Rename pgmoved variable in shrink_active_list()
Message-ID: <20090716173249.GB2267@cmpxchg.org>
References: <20090716094619.9D07.A69D9226@jp.fujitsu.com> <20090716095119.9D0A.A69D9226@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090716095119.9D0A.A69D9226@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 16, 2009 at 09:52:34AM +0900, KOSAKI Motohiro wrote:
> Subject: [PATCH] Rename pgmoved variable in shrink_active_list()
> 
> Currently, pgmoved variable have two meanings. it cause harder reviewing a bit.
> This patch separate it.
> 
> 
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>

Below are just minor suggestions regarding the changed code.

> ---
>  mm/vmscan.c |   16 ++++++++--------
>  1 file changed, 8 insertions(+), 8 deletions(-)
> 
> Index: b/mm/vmscan.c
> ===================================================================
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -1239,7 +1239,7 @@ static void move_active_pages_to_lru(str
>  static void shrink_active_list(unsigned long nr_pages, struct zone *zone,
>  			struct scan_control *sc, int priority, int file)
>  {
> -	unsigned long pgmoved;
> +	unsigned long nr_taken;
>  	unsigned long pgscanned;
>  	unsigned long vm_flags;
>  	LIST_HEAD(l_hold);	/* The pages which were snipped off */
> @@ -1247,10 +1247,11 @@ static void shrink_active_list(unsigned 
>  	LIST_HEAD(l_inactive);
>  	struct page *page;
>  	struct zone_reclaim_stat *reclaim_stat = get_reclaim_stat(zone, sc);
> +	unsigned long nr_rotated = 0;
>  
>  	lru_add_drain();
>  	spin_lock_irq(&zone->lru_lock);
> -	pgmoved = sc->isolate_pages(nr_pages, &l_hold, &pgscanned, sc->order,
> +	nr_taken = sc->isolate_pages(nr_pages, &l_hold, &pgscanned, sc->order,
>  					ISOLATE_ACTIVE, zone,
>  					sc->mem_cgroup, 1, file);
>  	/*
> @@ -1260,16 +1261,15 @@ static void shrink_active_list(unsigned 
>  	if (scanning_global_lru(sc)) {
>  		zone->pages_scanned += pgscanned;
>  	}
> -	reclaim_stat->recent_scanned[!!file] += pgmoved;
> +	reclaim_stat->recent_scanned[!!file] += nr_taken;

Hm, file is a boolean already, the double negation can probably be
dropped.

>  	__count_zone_vm_events(PGREFILL, zone, pgscanned);
>  	if (file)
> -		__mod_zone_page_state(zone, NR_ACTIVE_FILE, -pgmoved);
> +		__mod_zone_page_state(zone, NR_ACTIVE_FILE, -nr_taken);
>  	else
> -		__mod_zone_page_state(zone, NR_ACTIVE_ANON, -pgmoved);
> +		__mod_zone_page_state(zone, NR_ACTIVE_ANON, -nr_taken);

Should perhaps be in another patch, but we could use

	__mod_zone_page_state(zone, LRU_ACTIVE + file * LRU_FILE);

like in the call to move_active_pages_to_lru().

>  	spin_unlock_irq(&zone->lru_lock);
>  
> -	pgmoved = 0;  /* count referenced (mapping) mapped pages */
>  	while (!list_empty(&l_hold)) {
>  		cond_resched();
>  		page = lru_to_page(&l_hold);
> @@ -1283,7 +1283,7 @@ static void shrink_active_list(unsigned 
>  		/* page_referenced clears PageReferenced */
>  		if (page_mapping_inuse(page) &&
>  		    page_referenced(page, 0, sc->mem_cgroup, &vm_flags)) {
> -			pgmoved++;
> +			nr_rotated++;
>  			/*
>  			 * Identify referenced, file-backed active pages and
>  			 * give them one more trip around the active list. So
> @@ -1312,7 +1312,7 @@ static void shrink_active_list(unsigned 
>  	 * helps balance scan pressure between file and anonymous pages in
>  	 * get_scan_ratio.
>  	 */
> -	reclaim_stat->recent_rotated[!!file] += pgmoved;
> +	reclaim_stat->recent_rotated[!!file] += nr_rotated;

file is boolean.

There is one more double negation in isolate_pages_global() that can
be dropped as well.  If you agree, I can submit all those changes in
separate patches.

	Hannes
