Return-Path: <linux-kernel-owner+w=401wt.eu-S1757784AbZJHLqC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757784AbZJHLqC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 07:46:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757690AbZJHLqB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 07:46:01 -0400
Received: from mail.gmx.net ([213.165.64.20]:46580 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757243AbZJHLqA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 07:46:00 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18FMYcCkugFIS7fH5twqAbz1dwDfjCj7fyQCm6IO6
	2Qs8CzueipsW28
Subject: Re: [.32-rc3] scheduler: iwlagn consistently high in "waiting for
 CPU"
From: Mike Galbraith <efault@gmx.de>
To: Frans Pop <elendil@planet.nl>
Cc: Arjan van de Ven <arjan@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       linux-wireless@vger.kernel.org
In-Reply-To: <200910072034.57511.elendil@planet.nl>
References: <200910051500.55875.elendil@planet.nl>
	 <200910061749.02805.elendil@planet.nl>
	 <200910071910.53907.elendil@planet.nl>
	 <200910072034.57511.elendil@planet.nl>
Content-Type: text/plain
Date: Thu, 08 Oct 2009 13:24:22 +0200
Message-Id: <1255001062.7500.1.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.43
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-10-07 at 20:34 +0200, Frans Pop wrote:
> On Wednesday 07 October 2009, Frans Pop wrote:
> > On Tuesday 06 October 2009, Frans Pop wrote:
> > > I've checked for 2.6.31.1 now and iwlagn is listed high there too when
> > > the system is idle, but with normal values of 60-100 ms. And phy0 has
> > > normal values of below 10 ms.
> > > I've now rebooted with today's mainline git; phy0 now frequently shows
> > > with values of around 100 ms too (i.e. higher than last time).
> >
> > Mike privately sent me a script to try to capture the latencies with
> > perf, but the perf output does not show any high latencies at all. It
> > looks as if we may have found a bug in latencytop here instead.
> 
> Not sure if it's relevant nor what it means, but I frequently see two lines 
> for iwlagn, e.g:
> 
>     Scheduler: waiting for cpu              102.4 msec         99.7 %
>     .                                         3.3 msec          0.3 %
> 
> I get the same results with both latencytop 0.4 and 0.5.

Care to try a patch?


latencytop: only account on-runqueue wait time as being scheduler latency.

Latencytop was accounting uninterruptible and interruptible sleep time up to
5ms, which is not the latency the user is looking for.  Account time waiting
on-runqueue instead.  Also add a clock update to update_curr() for the case
where there's nobody home.  When coming out of idle with NO_HZ, not updating
the clock leads to bogus max latency report.

After on mostly idle NO_HZ box, was up to a second "waiting for cpu":

   LatencyTOP version 0.5       (C) 2008 Intel Corporation

Cause                                                Maximum     Percentage
Scheduler: waiting for cpu                          9.3 msec         50.3 %
[sysret_careful]                                    9.1 msec         21.6 %
Waiting for data on unix socket                     7.9 msec          0.5 %
Waiting for event (select)                          3.8 msec         21.8 %
[retint_careful]                                    1.2 msec          2.4 %
[]                                                  0.4 msec          0.0 %
Waiting for event (poll)                            0.4 msec          0.4 %
[__cond_resched]                                    0.4 msec          0.0 %
Userspace lock contention                           0.2 msec          3.0 %

TODO: Examine migration, pull may create max latency fib.
TODO: Figure out where the heck empty braces come from.

Signed-off-by: Mike Galbraith <efault@gmx.de>
Arjan van de Ven <arjan@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>

---
 include/linux/latencytop.h |    6 +++---
 kernel/latencytop.c        |   19 +------------------
 kernel/sched_fair.c        |   16 +++++++++-------
 3 files changed, 13 insertions(+), 28 deletions(-)

Index: linux-2.6/include/linux/latencytop.h
===================================================================
--- linux-2.6.orig/include/linux/latencytop.h
+++ linux-2.6/include/linux/latencytop.h
@@ -26,12 +26,12 @@ struct latency_record {
 struct task_struct;
 
 extern int latencytop_enabled;
-void __account_scheduler_latency(struct task_struct *task, int usecs, int inter);
+void __account_scheduler_latency(struct task_struct *task, unsigned long usecs);
 static inline void
-account_scheduler_latency(struct task_struct *task, int usecs, int inter)
+account_scheduler_latency(struct task_struct *task, unsigned long usecs)
 {
 	if (unlikely(latencytop_enabled))
-		__account_scheduler_latency(task, usecs, inter);
+		__account_scheduler_latency(task, usecs);
 }
 
 void clear_all_latency_tracing(struct task_struct *p);
Index: linux-2.6/kernel/latencytop.c
===================================================================
--- linux-2.6.orig/kernel/latencytop.c
+++ linux-2.6/kernel/latencytop.c
@@ -157,34 +157,17 @@ static inline void store_stacktrace(stru
  * __account_scheduler_latency - record an occured latency
  * @tsk - the task struct of the task hitting the latency
  * @usecs - the duration of the latency in microseconds
- * @inter - 1 if the sleep was interruptible, 0 if uninterruptible
  *
  * This function is the main entry point for recording latency entries
  * as called by the scheduler.
- *
- * This function has a few special cases to deal with normal 'non-latency'
- * sleeps: specifically, interruptible sleep longer than 5 msec is skipped
- * since this usually is caused by waiting for events via select() and co.
- *
- * Negative latencies (caused by time going backwards) are also explicitly
- * skipped.
  */
 void __sched
-__account_scheduler_latency(struct task_struct *tsk, int usecs, int inter)
+__account_scheduler_latency(struct task_struct *tsk, unsigned long usecs)
 {
 	unsigned long flags;
 	int i, q;
 	struct latency_record lat;
 
-	/* Long interruptible waits are generally user requested... */
-	if (inter && usecs > 5000)
-		return;
-
-	/* Negative sleeps are time going backwards */
-	/* Zero-time sleeps are non-interesting */
-	if (usecs <= 0)
-		return;
-
 	memset(&lat, 0, sizeof(lat));
 	lat.count = 1;
 	lat.time = usecs;
Index: linux-2.6/kernel/sched_fair.c
===================================================================
--- linux-2.6.orig/kernel/sched_fair.c
+++ linux-2.6/kernel/sched_fair.c
@@ -495,8 +495,10 @@ static void update_curr(struct cfs_rq *c
 	u64 now = rq_of(cfs_rq)->clock;
 	unsigned long delta_exec;
 
-	if (unlikely(!curr))
+	if (unlikely(!curr)) {
+		update_rq_clock(rq_of(cfs_rq));
 		return;
+	}
 
 	/*
 	 * Get the amount of time the current task was running
@@ -548,8 +550,11 @@ update_stats_wait_end(struct cfs_rq *cfs
 			rq_of(cfs_rq)->clock - se->wait_start);
 #ifdef CONFIG_SCHEDSTATS
 	if (entity_is_task(se)) {
-		trace_sched_stat_wait(task_of(se),
-			rq_of(cfs_rq)->clock - se->wait_start);
+		struct task_struct *tsk = task_of(se);
+		u64 delta = rq_of(cfs_rq)->clock - se->wait_start;
+
+		trace_sched_stat_wait(tsk, delta);
+		account_scheduler_latency(tsk, delta >> 10);
 	}
 #endif
 	schedstat_set(se->wait_start, 0);
@@ -643,10 +648,8 @@ static void enqueue_sleeper(struct cfs_r
 		se->sleep_start = 0;
 		se->sum_sleep_runtime += delta;
 
-		if (tsk) {
-			account_scheduler_latency(tsk, delta >> 10, 1);
+		if (tsk)
 			trace_sched_stat_sleep(tsk, delta);
-		}
 	}
 	if (se->block_start) {
 		u64 delta = rq_of(cfs_rq)->clock - se->block_start;
@@ -677,7 +680,6 @@ static void enqueue_sleeper(struct cfs_r
 						(void *)get_wchan(tsk),
 						delta >> 20);
 			}
-			account_scheduler_latency(tsk, delta >> 10, 0);
 		}
 	}
 #endif


