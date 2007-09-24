Return-Path: <linux-kernel-owner+w=401wt.eu-S1756080AbXIXKK1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756080AbXIXKK1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 06:10:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751831AbXIXKKS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 06:10:18 -0400
Received: from mail.gmx.net ([213.165.64.20]:37116 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751844AbXIXKKQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 06:10:16 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+JGzBQHUWJe/46yjiYm8zKYc6DRTFGWu78UIgMxB
	91/xRK6pOcqTBP
Subject: Re: [git] CFS-devel, group scheduler, fixes
From: Mike Galbraith <efault@gmx.de>
To: Tong Li <tong.n.li@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, dimm <dmitry.adamushko@gmail.com>,
       linux-kernel@vger.kernel.org,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
In-Reply-To: <Pine.LNX.4.64.0709232259150.23861@tongli.jf.intel.com>
References: <1190144190.5204.24.camel@earth> <20070918201622.GA1632@elte.hu>
	 <Pine.LNX.4.64.0709182250120.9990@tongli.jf.intel.com>
	 <1190183324.9737.7.camel@Homer.simpson.net>
	 <1190188261.9185.21.camel@Homer.simpson.net>
	 <1190191368.8687.5.camel@Homer.simpson.net>
	 <Pine.LNX.4.64.0709190944560.11561@tongli.jf.intel.com>
	 <1190264114.6411.4.camel@Homer.simpson.net>
	 <1190272507.27867.20.camel@Homer.simpson.net>
	 <20070920075155.GA31641@elte.hu>
	 <1190275870.9232.6.camel@Homer.simpson.net>
	 <Pine.LNX.4.64.0709212018480.16240@tongli.jf.intel.com>
	 <1190455308.7404.19.camel@Homer.simpson.net>
	 <1190531662.11524.15.camel@Homer.simpson.net>
	 <Pine.LNX.4.64.0709232259150.23861@tongli.jf.intel.com>
Content-Type: text/plain
Date: Mon, 24 Sep 2007 12:10:09 +0200
Message-Id: <1190628609.6389.14.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-09-23 at 23:21 -0700, Tong Li wrote: 
> On Sun, 23 Sep 2007, Mike Galbraith wrote:
> 
> > On Sat, 2007-09-22 at 12:01 +0200, Mike Galbraith wrote:
> >> On Fri, 2007-09-21 at 20:27 -0700, Tong Li wrote:
> >>> Mike,
> >>>
> >>> Could you try this patch to see if it solves the latency problem?
> >>
> >> No, but it helps some when running two un-pinned busy loops, one at nice
> >> 0, and the other at nice 19.  Yesterday I hit latencies of up to 1.2
> >> _seconds_ doing this, and logging sched_debug and /proc/`pidof
> >> Xorg`/sched from SCHED_RR shells.
> >
> > Looking at a log (snippet attached) from this morning with the last hunk
> > of your patch still intact, it looks like min_vruntime is being modified
> > after a task is queued.  If you look at the snippet, you'll see the nice
> > 19 bash busy loop on CPU1 with a vruntime of 3010385.345325, and one
> > second later on CPU1 with it's vruntime at 2814952.425082, but
> > min_vruntime is 3061874.838356.
> 
> I think this could be what was happening: between the two seconds, CPU 0 
> becomes idle and it pulls the nice 19 task over via pull_task(), which 
> calls set_task_cpu(), which changes the task's vruntime to the current 
> min_vruntime of CPU 0 (in my patch). Then, after set_task_cpu(), CPU 0 
> calls activate_task(), which calls enqueue_task() and in turn 
> update_curr(). Now, nr_running on CPU 0 is 0, so sync_vruntime() gets 
> called and CPU 0's min_vruntime gets synced to the system max. Thus, the 
> nice 19 task now has a vruntime less than CPU 0's min_vruntime. I think 
> this can be fixed by adding the following code in set_task_cpu() before we 
> adjust p->vruntime:
> 
> if (!new_rq->cfs.nr_running)
>  	sync_vruntime(new_rq);

Hmm.  I can imagine Mondo-Boxen-R-Us folks getting upset with that.
Better would be like Ingo said, see if we can toss sync_vrintime(), and
I've been playing with that...

I found something this morning, and as usual, the darn thing turned out
to be dirt simple.  With sync_vruntime() disabled, I found queues with
negative min_vruntime right from boot, and went hunting.  Adding some
instrumentation to set_task_cpu() (annoying consequences), I found the
below:

Legend:
vrun: tasks's vruntime
old: old queue's min_vruntime
new: new queue's min_vruntime
result: what's gonna happen

[   60.214508] kseriod vrun: 1427596999 old: 15070988657 new: 4065818654 res: -9577573004
[  218.274661] konqueror vrun: 342076210254 old: 658982966338 new: 219203403598 res: -97703352486
[  218.284657] init vrun: 411638725179 old: 659187735208 new: 219203492472 res: -28345517557
[...]

A task which hasn't run in long enough for queues to have digressed
further than it's vruntime is going to end up with a negative vruntime.
Looking at place_entity(), it looks like it's supposed to fix that up,
but due to the order of arguments passed to max_vrintime(), and the
unsigned comparison therein, it won't.

Running with the patchlet below, my box _so far_ has not become
terminally unhappy despite spread0.  I'm writing this with the pinned
hogs test running right now, and all is well, so I _think_ it might be
ok to just remove sync_vruntime() after all.

diff -uprNX /root/dontdiff git/linux-2.6.sched-devel/kernel/sched_fair.c linux-2.6.23-rc7.d/kernel/sched_fair.c
--- git/linux-2.6.sched-devel/kernel/sched_fair.c	2007-09-23 14:48:18.000000000 +0200
+++ linux-2.6.23-rc7.d/kernel/sched_fair.c	2007-09-24 11:02:05.000000000 +0200
@@ -117,7 +117,7 @@ static inline struct task_struct *task_o
 static inline u64
 max_vruntime(u64 min_vruntime, u64 vruntime)
 {
-	if ((vruntime > min_vruntime) ||
+	if (((s64)vruntime > (s64)min_vruntime) ||
 	    (min_vruntime > (1ULL << 61) && vruntime < (1ULL << 50)))
 		min_vruntime = vruntime;
 
@@ -310,7 +310,7 @@ static void update_curr(struct cfs_rq *c
 	unsigned long delta_exec;
 
 	if (unlikely(!cfs_rq->nr_running))
-		return sync_vruntime(cfs_rq);
+		return ;//sync_vruntime(cfs_rq);
 	if (unlikely(!curr))
 		return;
 


