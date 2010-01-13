Return-Path: <linux-kernel-owner+w=401wt.eu-S1754886Ab0AMGKW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754886Ab0AMGKW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 01:10:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753606Ab0AMGKV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 01:10:21 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33789 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751957Ab0AMGKU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 01:10:20 -0500
Date: Wed, 13 Jan 2010 17:10:24 +1100
From: Nick Piggin <npiggin@suse.de>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Minchan Kim <minchan.kim@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH v2] mm, lockdep: annotate reclaim context to zone
	reclaim too
Message-ID: <20100113061023.GD3901@nick>
References: <20100112141330.B3A6.A69D9226@jp.fujitsu.com> <28c262361001120646y6f3603b8q236d0a7c02250ffa@mail.gmail.com> <20100113084525.B3CB.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100113084525.B3CB.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 13, 2010 at 08:57:21AM +0900, KOSAKI Motohiro wrote:
> > On Tue, Jan 12, 2010 at 2:16 PM, KOSAKI Motohiro
> > <kosaki.motohiro@jp.fujitsu.com> wrote:
> > >
> > > Commit cf40bd16fd (lockdep: annotate reclaim context) introduced reclaim
> > > context annotation. But it didn't annotate zone reclaim. This patch do it.
> > >
> > > Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> > > Cc: Nick Piggin <npiggin@suse.de>
> > > Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > > Cc: Ingo Molnar <mingo@elte.hu>
> > Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
> > 
> > I think your good explanation in previous thread is good for
> > changelog. so I readd in here.
> > If you mind this, feel free to discard.
> > I don't care about it. :)
> 
> Thanks, refrected.
> 
> ====================================================
> Commit cf40bd16fd (lockdep: annotate reclaim context) introduced reclaim
> context annotation. But it didn't annotate zone reclaim. This patch do it.
> 
> The point is,  commit cf40bd16fd annotate __alloc_pages_direct_reclaim
> but zone-reclaim doesn't use __alloc_pages_direct_reclaim.
> 
> current call graph is
> 
> __alloc_pages_nodemask
>    get_page_from_freelist
>        zone_reclaim()
>    __alloc_pages_slowpath
>        __alloc_pages_direct_reclaim
>            try_to_free_pages
> 
> Actually, if zone_reclaim_mode=1, VM never call
> __alloc_pages_direct_reclaim in usual VM pressure.

Acked-by: Nick Piggin <npiggin@suse.de>

> 
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
> Cc: Nick Piggin <npiggin@suse.de>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Ingo Molnar <mingo@elte.hu>
> ---
>  mm/vmscan.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 2bbee91..a039e78 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -2547,6 +2547,7 @@ static int __zone_reclaim(struct zone *zone, gfp_t gfp_mask, unsigned int order)
>  	 * and RECLAIM_SWAP.
>  	 */
>  	p->flags |= PF_MEMALLOC | PF_SWAPWRITE;
> +	lockdep_set_current_reclaim_state(gfp_mask);
>  	reclaim_state.reclaimed_slab = 0;
>  	p->reclaim_state = &reclaim_state;
>  
> @@ -2590,6 +2591,7 @@ static int __zone_reclaim(struct zone *zone, gfp_t gfp_mask, unsigned int order)
>  
>  	p->reclaim_state = NULL;
>  	current->flags &= ~(PF_MEMALLOC | PF_SWAPWRITE);
> +	lockdep_clear_current_reclaim_state();
>  	return sc.nr_reclaimed >= nr_pages;
>  }
>  
> -- 
> 1.6.6
> 
> 
> 
