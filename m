Return-Path: <linux-kernel-owner+w=401wt.eu-S1754844Ab0ALX5a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754844Ab0ALX5a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 18:57:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753527Ab0ALX53
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 18:57:29 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:41099 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753239Ab0ALX52 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 18:57:28 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Minchan Kim <minchan.kim@gmail.com>
Subject: [PATCH v2] mm, lockdep: annotate reclaim context to zone  reclaim too
Cc: kosaki.motohiro@jp.fujitsu.com, LKML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <28c262361001120646y6f3603b8q236d0a7c02250ffa@mail.gmail.com>
References: <20100112141330.B3A6.A69D9226@jp.fujitsu.com> <28c262361001120646y6f3603b8q236d0a7c02250ffa@mail.gmail.com>
Message-Id: <20100113084525.B3CB.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed, 13 Jan 2010 08:57:21 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, Jan 12, 2010 at 2:16 PM, KOSAKI Motohiro
> <kosaki.motohiro@jp.fujitsu.com> wrote:
> >
> > Commit cf40bd16fd (lockdep: annotate reclaim context) introduced reclaim
> > context annotation. But it didn't annotate zone reclaim. This patch do it.
> >
> > Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> > Cc: Nick Piggin <npiggin@suse.de>
> > Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > Cc: Ingo Molnar <mingo@elte.hu>
> Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
> 
> I think your good explanation in previous thread is good for
> changelog. so I readd in here.
> If you mind this, feel free to discard.
> I don't care about it. :)

Thanks, refrected.

====================================================
Commit cf40bd16fd (lockdep: annotate reclaim context) introduced reclaim
context annotation. But it didn't annotate zone reclaim. This patch do it.

The point is,  commit cf40bd16fd annotate __alloc_pages_direct_reclaim
but zone-reclaim doesn't use __alloc_pages_direct_reclaim.

current call graph is

__alloc_pages_nodemask
   get_page_from_freelist
       zone_reclaim()
   __alloc_pages_slowpath
       __alloc_pages_direct_reclaim
           try_to_free_pages

Actually, if zone_reclaim_mode=1, VM never call
__alloc_pages_direct_reclaim in usual VM pressure.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Cc: Nick Piggin <npiggin@suse.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
---
 mm/vmscan.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 2bbee91..a039e78 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2547,6 +2547,7 @@ static int __zone_reclaim(struct zone *zone, gfp_t gfp_mask, unsigned int order)
 	 * and RECLAIM_SWAP.
 	 */
 	p->flags |= PF_MEMALLOC | PF_SWAPWRITE;
+	lockdep_set_current_reclaim_state(gfp_mask);
 	reclaim_state.reclaimed_slab = 0;
 	p->reclaim_state = &reclaim_state;
 
@@ -2590,6 +2591,7 @@ static int __zone_reclaim(struct zone *zone, gfp_t gfp_mask, unsigned int order)
 
 	p->reclaim_state = NULL;
 	current->flags &= ~(PF_MEMALLOC | PF_SWAPWRITE);
+	lockdep_clear_current_reclaim_state();
 	return sc.nr_reclaimed >= nr_pages;
 }
 
-- 
1.6.6



