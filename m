Return-Path: <linux-kernel-owner+w=401wt.eu-S935750AbYEBT1U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935750AbYEBT1U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 15:27:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757649AbYEBT1J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 15:27:09 -0400
Received: from mail.gmx.net ([213.165.64.20]:44630 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753173AbYEBT1H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 15:27:07 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/oN5Jnh7ToBxLyJz02ByyzFS0bNHCGsCkIVIBHF7
	IpIipJfpDbg1is
Subject: Re: Horrendous Audio Stutter - current git
From: Mike Galbraith <efault@gmx.de>
To: Frans Pop <elendil@planet.nl>
Cc: Parag Warudkar <parag.warudkar@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <200805022053.24779.elendil@planet.nl>
References: <82e4877d0805011714m35a47753q58cca706b7af6557@mail.gmail.com>
	 <1209740523.4776.1.camel@marge.simson.net>
	 <200805021749.10205.elendil@planet.nl>
	 <200805022053.24779.elendil@planet.nl>
Content-Type: text/plain
Date: Fri, 02 May 2008 21:27:03 +0200
Message-Id: <1209756423.4693.8.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-05-02 at 20:53 +0200, Frans Pop wrote:
> On Friday 02 May 2008, Frans Pop wrote:
> > As I had group scheduling disabled, I only saw the first one. But my
> > audio skips were a lot less severe than Parag described. And disabling
> > group scheduling helped solve the problem for him.
> >
> > So it may well still be worth following up on this.
> 
> I have just tested a kernel with GROUP_SCHED enabled (with Peter's patch 
> still included) and can confirm that enabling group scheduling causes 
> serious latencies.
> Skips are much more frequent than with the issue that was just solved.
> 
> latencytop shows (different samples)
> Scheduler: waiting for cpu                        537.7 msec
> Scheduler: waiting for cpu                        172.0 msec 
> Scheduler: waiting for cpu                        414.6 msec
> Scheduler: waiting for cpu                        455.7 msec
> Scheduler: waiting for cpu                        446.5 msec
> 
> I think I also see why....
> 
> # grep bonus_max `grep -l amarokapp /proc/*/task/*/sched`
> /proc/4725/task/20645/sched:se.bonus_max  :        122640.203776
> /proc/4725/task/4725/sched:se.bonus_max  :        122640.203776
> /proc/4725/task/4793/sched:se.bonus_max  :      41902109.884416
> /proc/4725/task/4797/sched:se.bonus_max  :      41902109.884416
> /proc/4725/task/4798/sched:se.bonus_max  :      41902109.884416
> /proc/4725/task/4799/sched:se.bonus_max  :         40880.046080
> /proc/4725/task/4800/sched:se.bonus_max  :            19.970683

Hm. I enabled group scheduling, with Peter's patch + revert of the
commit that is giving me grief + the below, and it seems to work ok
here.  Definitely no sound skips even under quite hefty load.

The below _seems_ to make a difference stand-alone, but subjective
things like 'lurches' require _very_ much testing... you tend to see
what you want to see with such things.  As you can see, I thought about
submitting it, but I have way too much subjective poison in my system
from testing this and that while reading source.

Fix undesirable rq.clock update noops.

Signed-off-by: Mike Galbraith <efault@gmx.de>

Index: linux-2.6.26.git/kernel/sched.c
===================================================================
--- linux-2.6.26.git.orig/kernel/sched.c
+++ linux-2.6.26.git/kernel/sched.c
@@ -668,9 +668,6 @@ static void __update_rq_clock(struct rq 
 	s64 delta = now - prev_raw;
 	u64 clock = rq->clock;
 
-#ifdef CONFIG_SCHED_DEBUG
-	WARN_ON_ONCE(cpu_of(rq) != smp_processor_id());
-#endif
 	/*
 	 * Protect against sched_clock() occasionally going backwards:
 	 */
@@ -3009,8 +3006,8 @@ static void double_rq_lock(struct rq *rq
 			spin_lock(&rq1->lock);
 		}
 	}
-	update_rq_clock(rq1);
-	update_rq_clock(rq2);
+	__update_rq_clock(rq1);
+	__update_rq_clock(rq2);
 }
 
 /*
@@ -3860,7 +3857,7 @@ redo:
 		/* Attempt to move tasks */
 		double_lock_balance(this_rq, busiest);
 		/* this_rq->clock is already updated */
-		update_rq_clock(busiest);
+		__update_rq_clock(busiest);
 		ld_moved = move_tasks(this_rq, this_cpu, busiest,
 					imbalance, sd, CPU_NEWLY_IDLE,
 					&all_pinned);
@@ -3959,8 +3956,8 @@ static void active_load_balance(struct r
 
 	/* move a task from busiest_rq to target_rq */
 	double_lock_balance(busiest_rq, target_rq);
-	update_rq_clock(busiest_rq);
-	update_rq_clock(target_rq);
+	__update_rq_clock(busiest_rq);
+	__update_rq_clock(target_rq);
 
 	/* Search for an sd spanning us and the target CPU. */
 	for_each_domain(target_cpu, sd) {
Index: linux-2.6.26.git/kernel/sched_fair.c
===================================================================
--- linux-2.6.26.git.orig/kernel/sched_fair.c
+++ linux-2.6.26.git/kernel/sched_fair.c
@@ -1221,7 +1221,7 @@ static void check_preempt_wakeup(struct 
 	int se_depth, pse_depth;
 
 	if (unlikely(rt_prio(p->prio))) {
-		update_rq_clock(rq);
+		__update_rq_clock(rq);
 		update_curr(cfs_rq);
 		resched_task(curr);
 		return;


