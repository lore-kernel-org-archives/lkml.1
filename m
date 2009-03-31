Return-Path: <linux-kernel-owner+w=401wt.eu-S1759463AbZCaBoW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759463AbZCaBoW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 21:44:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756754AbZCaBoN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 21:44:13 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:49611 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754897AbZCaBoM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 21:44:12 -0400
Date: Tue, 31 Mar 2009 10:42:37 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Johannes Weiner <hannes@cmpxchg.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Rik van Riel <riel@redhat.com>,
       Balbir Singh <balbir@in.ibm.com>
Subject: Re: [PATCH] vmscan: memcg needs may_swap (Re: [patch] vmscan:
 rename  sc.may_swap to may_unmap)
Message-Id: <20090331104237.e689f279.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <28c262360903301826w6429720es8ceb361cfc088b1@mail.gmail.com>
References: <20090327151926.f252fba7.nishimura@mxp.nes.nec.co.jp>
	<20090327153035.35498303.kamezawa.hiroyu@jp.fujitsu.com>
	<20090328214636.68FF.A69D9226@jp.fujitsu.com>
	<28c262360903301826w6429720es8ceb361cfc088b1@mail.gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 31 Mar 2009 10:26:17 +0900
Minchan Kim <minchan.kim@gmail.com> wrote:

> > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > index 3be6157..00ea4a1 100644
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> > @@ -63,6 +63,9 @@ struct scan_control {
> >        /* Can mapped pages be reclaimed? */
> >        int may_unmap;
> >
> > +       /* Can pages be swapped as part of reclaim? */
> > +       int may_swap;
> > +
> 
> Sorry for too late response.
> I don't know memcg well.
> 
> The memcg managed to use may_swap well with global page reclaim until now.
> I think that was because may_swap can represent both meaning.
> Do we need each variables really ?
> 
> How about using union variable ?

or Just removing one of them  ?

Thanks,
-Kame

> ---
> 
> struct scan_control {
>   /* Incremented by the number of inactive pages that were scanned */
>   unsigned long nr_scanned;
> ...
>    union {
>     int may_swap; /* memcg: Cap pages be swapped as part of reclaim? */
>     int may_unmap /* global: Can mapped pages be reclaimed? */
>   };
> 
> 
> 
> >        /* This context's SWAP_CLUSTER_MAX. If freeing memory for
> >         * suspend, we effectively ignore SWAP_CLUSTER_MAX.
> >         * In this context, it doesn't matter that we scan the
> > @@ -1379,7 +1382,7 @@ static void get_scan_ratio(struct zone *zone, struct scan_control *sc,
> >        struct zone_reclaim_stat *reclaim_stat = get_reclaim_stat(zone, sc);
> >
> >        /* If we have no swap space, do not bother scanning anon pages. */
> > -       if (nr_swap_pages <= 0) {
> > +       if (!sc->may_swap || (nr_swap_pages <= 0)) {
> >                percent[0] = 0;
> >                percent[1] = 100;
> >                return;
> > @@ -1695,6 +1698,7 @@ unsigned long try_to_free_pages(struct zonelist *zonelist, int order,
> >                .may_writepage = !laptop_mode,
> >                .swap_cluster_max = SWAP_CLUSTER_MAX,
> >                .may_unmap = 1,
> > +               .may_swap = 1,
> >                .swappiness = vm_swappiness,
> >                .order = order,
> >                .mem_cgroup = NULL,
> > @@ -1714,6 +1718,7 @@ unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *mem_cont,
> >        struct scan_control sc = {
> >                .may_writepage = !laptop_mode,
> >                .may_unmap = 1,
> > +               .may_swap = 1,
> >                .swap_cluster_max = SWAP_CLUSTER_MAX,
> >                .swappiness = swappiness,
> >                .order = 0,
> > @@ -1723,7 +1728,7 @@ unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *mem_cont,
> >        struct zonelist *zonelist;
> >
> >        if (noswap)
> > -               sc.may_unmap = 0;
> > +               sc.may_swap = 0;
> >
> >        sc.gfp_mask = (gfp_mask & GFP_RECLAIM_MASK) |
> >                        (GFP_HIGHUSER_MOVABLE & ~GFP_RECLAIM_MASK);
> > @@ -1763,6 +1768,7 @@ static unsigned long balance_pgdat(pg_data_t *pgdat, int order)
> >        struct scan_control sc = {
> >                .gfp_mask = GFP_KERNEL,
> >                .may_unmap = 1,
> > +               .may_swap = 1,
> >                .swap_cluster_max = SWAP_CLUSTER_MAX,
> >                .swappiness = vm_swappiness,
> >                .order = order,
> > @@ -2109,6 +2115,7 @@ unsigned long shrink_all_memory(unsigned long nr_pages)
> >        struct scan_control sc = {
> >                .gfp_mask = GFP_KERNEL,
> >                .may_unmap = 0,
> > +               .may_swap = 1,
> >                .swap_cluster_max = nr_pages,
> >                .may_writepage = 1,
> >                .isolate_pages = isolate_pages_global,
> > @@ -2289,6 +2296,7 @@ static int __zone_reclaim(struct zone *zone, gfp_t gfp_mask, unsigned int order)
> >        struct scan_control sc = {
> >                .may_writepage = !!(zone_reclaim_mode & RECLAIM_WRITE),
> >                .may_unmap = !!(zone_reclaim_mode & RECLAIM_SWAP),
> > +               .may_swap = 1,
> >                .swap_cluster_max = max_t(unsigned long, nr_pages,
> >                                        SWAP_CLUSTER_MAX),
> >                .gfp_mask = gfp_mask,
> >
> >
> >
> >
> >
> 
> 
> 
> -- 
> Kinds regards,
> Minchan Kim
> 

