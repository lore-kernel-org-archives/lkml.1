Return-Path: <linux-kernel-owner+w=401wt.eu-S1752030AbXDPKkP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752030AbXDPKkP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 06:40:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752051AbXDPKkP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 06:40:15 -0400
Received: from [212.12.190.212] ([212.12.190.212]:32953 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752030AbXDPKkN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 06:40:13 -0400
From: Al Boldi <a1426z@gawab.com>
To: Peter Williams <pwil3058@bigpond.net.au>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair
Date: Mon, 16 Apr 2007 13:42:34 +0300
User-Agent: KMail/1.5
Cc: linux-kernel@vger.kernel.org
References: <200704150931.42268.a1426z@gawab.com> <200704161153.17390.a1426z@gawab.com> <46234D59.8020801@bigpond.net.au>
In-Reply-To: <46234D59.8020801@bigpond.net.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704161342.34498.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Williams wrote:
> Al Boldi wrote:
> > Peter Williams wrote:
> >> William Lee Irwin III wrote:
> >>> On Mon, Apr 16, 2007 at 11:06:56AM +1000, Peter Williams wrote:
> >>>> PS I no longer read LKML (due to time constraints) and would
> >>>> appreciate it if I could be CC'd on any e-mails suggesting scheduler
> >>>> changes. PPS I'm just happy to see that Ingo has finally accepted
> >>>> that the vanilla scheduler was badly in need of fixing and don't
> >>>> really care who fixes it.
> >>>> PPS Different schedulers for different aims (i.e. server or work
> >>>> station) do make a difference.  E.g. the spa_svr scheduler in
> >>>> plugsched does about 1% better on kernbench than the next best
> >>>> scheduler in the bunch. PPPS Con, fairness isn't always best as
> >>>> humans aren't very altruistic and we need to give unfair preference
> >>>> to interactive tasks in order to stop the users flinging their PCs
> >>>> out the window.  But the current scheduler doesn't do this very well
> >>>> and is also not very good at fairness so needs to change.  But the
> >>>> changes need to address interactive response and fairness not just
> >>>> fairness.
> >>>
> >>> Kernel compiles not so useful a benchmark. SDET, OAST, AIM7, etc. are
> >>> better ones. I'd not bother citing kernel compile results.
> >>
> >> spa_svr actually does its best work when the system isn't fully loaded
> >> as the type of improvement it strives to achieve (minimizing on queue
> >> wait time) hasn't got much room to manoeuvre when the system is fully
> >> loaded.  Therefore, the fact that it's 1% better even in these
> >> circumstances is a good result and also indicates that the overhead for
> >> keeping the scheduling statistics it uses for its decision making is
> >> well spent.  Especially, when you consider that the total available
> >> room for improvement on this benchmark is less than 3%.
> >>
> >> To elaborate, the motivation for this scheduler was acquired from the
> >> observation of scheduling statistics (in particular, on queue wait
> >> time) on systems running at about 30% to 50% load.  Theoretically, at
> >> these load levels there should be no such waiting but the statistics
> >> show that there is considerable waiting (sometimes as high as 30% to
> >> 50%).  I put this down to "lack of serendipity" e.g.  everyone sleeping
> >> at the same time and then trying to run at the same time would be
> >> complete lack of serendipity.  On the other hand, if everyone is synced
> >> then there would be total serendipity.
> >>
> >> Obviously, from the POV of a client, time the server task spends
> >> waiting on the queue adds to the response time for any request that has
> >> been made so reduction of this time on a server is a good thing(tm). 
> >> Equally obviously, trying to achieve this synchronization by asking the
> >> tasks to cooperate with each other is not a feasible solution and some
> >> external influence needs to be exerted and this is what spa_svr does --
> >> it nudges the scheduling order of the tasks in a way that makes them
> >> become well synced.
> >>
> >> Unfortunately, this is not a good scheduler for an interactive system
> >> as it minimizes the response times for ALL tasks (and the system as a
> >> whole) and this can result in increased response time for some
> >> interactive tasks (clunkiness) which annoys interactive users.  When
> >> you start fiddling with this scheduler to bring back "interactive
> >> unfairness" you kill a lot of its superior low overall wait time
> >> performance.
> >
> > spa_svr is my favorite, but as you mentioned doesn't work well with ia. 
> > So I started instrumenting its behaviour with chew.c (attached).  What I
> > found is that prio-levels are way to coarse.  Setting max_tpt_bonus = 3
> > bounds this somewhat, but it was still not enough.  Looking at
> > spa_svr_reassess_bonus and changing it to simply adjust prio based on
> > avg_sleep did the trick like this:
> >
> > static void spa_svr_reassess_bonus(struct task_struct *p)
> > {
> > 	if (p->sdu.spa.avg_sleep_per_cycle >> 10) {
> > 		incr_throughput_bonus(p, 1);
> > 	} else
> > 		decr_throughput_bonus(p);
> > }
>
> I suspect that this would kill some of the good server performance as it
> removes the mechanism that minimises wait time.  It is effectively just
> a simplification of what the vanilla O(1) scheduler tries to do i.e.
> assume tasks that sleep a lot are interactive and give them a boost.
>
> spa_ws tries to do this as well only in a bit more complicated fashion.
>   So maybe an spa_svr modified in this way and renamed could make a good
> interactive scheduler.

Great!

Reducing the prio-level granularity may also be helpful; or maybe even make 
it adjustable?  Any easy way to introduce something like this?


Thanks!

--
Al

