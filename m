Return-Path: <linux-kernel-owner+w=401wt.eu-S1760289AbZENQYq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760289AbZENQYq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 12:24:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751565AbZENQYh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 12:24:37 -0400
Received: from cmpxchg.org ([85.214.51.133]:51782 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751185AbZENQYh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 12:24:37 -0400
Date: Thu, 14 May 2009 18:22:01 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
To: Minchan Kim <barrioskmc@gmail.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       MinChan Kim <minchan.kim@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH] mmtom: Prevent shrinking of active anon lru list in case of no swap space V3
Message-ID: <20090514162201.GA2361@cmpxchg.org>
References: <20090514231555.f52c81eb.minchan.kim@gmail.com> <2f11576a0905140727j5ba02b07t94826f57dd99839c@mail.gmail.com> <44c63dc40905140739n271d3d2w2e0cc364c0012d71@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <44c63dc40905140739n271d3d2w2e0cc364c0012d71@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 14, 2009 at 11:39:49PM +0900, Minchan Kim wrote:
> On Thu, May 14, 2009 at 11:27 PM, KOSAKI Motohiro
> <kosaki.motohiro@jp.fujitsu.com> wrote:
> >>  mm/vmscan.c |    2 +-
> >>  1 files changed, 1 insertions(+), 1 deletions(-)
> >>
> >> diff --git a/mm/vmscan.c b/mm/vmscan.c
> >> index 2f9d555..621708f 100644
> >> --- a/mm/vmscan.c
> >> +++ b/mm/vmscan.c
> >> @@ -1577,7 +1577,7 @@ static void shrink_zone(int priority, struct zone *zone,
> >>         * Even if we did not try to evict anon pages at all, we want to
> >>         * rebalance the anon lru active/inactive ratio.
> >>         */
> >> -       if (inactive_anon_is_low(zone, sc))
> >> +       if (inactive_anon_is_low(zone, sc) && nr_swap_pages > 0)
> >>                shrink_active_list(SWAP_CLUSTER_MAX, zone, sc, priority, 0);
> >
> >
> >       if (nr_swap_pages > 0 && inactive_anon_is_low(zone, sc))
> >
> > is better?
> > compiler can't swap evaluate order around &&.
> 
> If GCC optimizes away that branch with CONFIG_SWAP=n as Rik mentioned,
> we don't have a concern.

It can only optimize it away when the condition is a compile time
constant.

But inactive_anon_is_low() contains atomic operations which the
compiler is not allowed to drop and so the && semantics lead to

	atomic_read() && 0

emitting the read while still knowing the whole expression is 0 at
compile-time, optimizing away only the branch itself but leaving the
read in place!

Compared to

	0 && atomic_read()

where the && short-circuitry leads to atomic_read() not being
executed.  And since the 0 is a compile time constant, no code has to
be emitted for the read.

So KOSAKI-san's is right.  Your version results in bigger object code.

	Hannes
