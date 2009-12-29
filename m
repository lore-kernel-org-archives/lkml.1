Return-Path: <linux-kernel-owner+w=401wt.eu-S1752207AbZL2Geq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752207AbZL2Geq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 01:34:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750775AbZL2Gep
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 01:34:45 -0500
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:39696 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750725AbZL2Geo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 01:34:44 -0500
Date: Tue, 29 Dec 2009 12:04:36 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH 1/4] vmstat: remove zone->lock from walk_zones_in_node
Message-ID: <20091229063436.GM3601@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20091228164451.A687.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20091228164451.A687.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> [2009-12-28 16:47:22]:

> The zone->lock is one of performance critical locks. Then, it shouldn't
> be hold for long time. Currently, we have four walk_zones_in_node()
> usage and almost use-case don't need to hold zone->lock.
> 
> Thus, this patch move locking responsibility from walk_zones_in_node
> to its sub function. Also this patch kill unnecessary zone->lock taking.
> 
> Cc: Mel Gorman <mel@csn.ul.ie>
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> ---
>  mm/vmstat.c |    8 +++++---
>  1 files changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/vmstat.c b/mm/vmstat.c
> index 6051fba..a5d45bc 100644
> --- a/mm/vmstat.c
> +++ b/mm/vmstat.c
> @@ -418,15 +418,12 @@ static void walk_zones_in_node(struct seq_file *m, pg_data_t *pgdat,
>  {
>  	struct zone *zone;
>  	struct zone *node_zones = pgdat->node_zones;
> -	unsigned long flags;
> 
>  	for (zone = node_zones; zone - node_zones < MAX_NR_ZONES; ++zone) {
>  		if (!populated_zone(zone))
>  			continue;
> 
> -		spin_lock_irqsave(&zone->lock, flags);
>  		print(m, pgdat, zone);
> -		spin_unlock_irqrestore(&zone->lock, flags);
>  	}
>  }
>

> @@ -455,6 +452,7 @@ static void pagetypeinfo_showfree_print(struct seq_file *m,
>  					pg_data_t *pgdat, struct zone *zone)
>  {
>  	int order, mtype;
> +	unsigned long flags;
> 
>  	for (mtype = 0; mtype < MIGRATE_TYPES; mtype++) {
>  		seq_printf(m, "Node %4d, zone %8s, type %12s ",
> @@ -468,8 +466,11 @@ static void pagetypeinfo_showfree_print(struct seq_file *m,
> 
>  			area = &(zone->free_area[order]);
> 
> +			spin_lock_irqsave(&zone->lock, flags);
>  			list_for_each(curr, &area->free_list[mtype])
>  				freecount++;
> +			spin_unlock_irqrestore(&zone->lock, flags);
> +
>  			seq_printf(m, "%6lu ", freecount);
>  		}
>  		seq_putc(m, '\n');
> @@ -709,6 +710,7 @@ static void zoneinfo_show_print(struct seq_file *m, pg_data_t *pgdat,
>  							struct zone *zone)
>  {
>  	int i;
> +
>  	seq_printf(m, "Node %d, zone %8s", pgdat->node_id, zone->name);
>  	seq_printf(m,
>  		   "\n  pages free     %lu"

While this is a noble cause, is printing all this information correct
without the lock, I am not worried about old 
information, but incorrect data. Should the read side be rcu'ed. Is
just removing the lock and accessing data safe across architectures?

-- 
	Balbir
