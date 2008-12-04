Return-Path: <linux-kernel-owner+w=401wt.eu-S1756862AbYLDHPy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756862AbYLDHPy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 02:15:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752812AbYLDHPn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 02:15:43 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:41253 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752196AbYLDHPn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 02:15:43 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH 08/11] memcg: make zone_reclaim_stat
Cc: kosaki.motohiro@jp.fujitsu.com
In-Reply-To: <20081203140655.GG17701@balbir.in.ibm.com>
References: <20081201211646.1CE2.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20081203140655.GG17701@balbir.in.ibm.com>
Message-Id: <20081204151647.1D78.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Thu,  4 Dec 2008 16:15:37 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > +struct zone_reclaim_stat *mem_cgroup_get_reclaim_stat(struct mem_cgroup *memcg,
> > +						      struct zone *zone)
> > +{
> > +	int nid = zone->zone_pgdat->node_id;
> > +	int zid = zone_idx(zone);
> > +	struct mem_cgroup_per_zone *mz = mem_cgroup_zoneinfo(memcg, nid, zid);
> > +
> > +	return &mz->reclaim_stat;
> > +}
> > +
> > +struct zone_reclaim_stat *mem_cgroup_get_reclaim_stat_by_page(struct page *page)
> > +{
> 
> I would prefer to use stat_from_page instead of stat_by_page, by page
> is confusing.

ok.
will fix.


> > @@ -172,6 +173,12 @@ void activate_page(struct page *page)
> > 
> >  		reclaim_stat->recent_rotated[!!file]++;
> >  		reclaim_stat->recent_scanned[!!file]++;
> > +
> > +		memcg_reclaim_stat = mem_cgroup_get_reclaim_stat_by_page(page);
> > +		if (memcg_reclaim_stat) {
> > +			memcg_reclaim_stat->recent_rotated[!!file]++;
> > +			memcg_reclaim_stat->recent_scanned[!!file]++;
> > +		}
> 
> Does it make sense to write two inline routines like
> 
> update_recent_rotated(page)
> {
>         zone = page_zone(page);
> 
>         zone->reclaim_stat->recent_rotated[!!file]++;
>         mem_reclaim_stat = mem_cgroup_get_reclaim_stat_by_page(page);
>         if (mem_reclaim_stat)
>                 mem_cg_reclaim_stat->recent_rotated[!!file]++;
>         ...
> 
> }
> 
> and similarly update_recent_reclaimed(page)

makes sense. good cleanup.

will fix.



> > Index: b/mm/vmscan.c
> > ===================================================================
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> > @@ -134,6 +134,9 @@ static DECLARE_RWSEM(shrinker_rwsem);
> >  static struct zone_reclaim_stat *get_reclaim_stat(struct zone *zone,
> >  						  struct scan_control *sc)
> >  {
> > +	if (!scan_global_lru(sc))
> > +		mem_cgroup_get_reclaim_stat(sc->mem_cgroup, zone);
> 
> What do we gain by just calling mem_cgroup_get_reclaim_stat? Where do
> we return/use this value?

Agghh.
My last cleanup is _not_ cleanup..

thanks! will fix.





