Return-Path: <linux-kernel-owner+w=401wt.eu-S1760132AbXEJIwS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760132AbXEJIwS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 04:52:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757087AbXEJIwJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 04:52:09 -0400
Received: from mail.gmx.net ([213.165.64.20]:38855 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756413AbXEJIwG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 04:52:06 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18l8J8IOUQlcN1WVWPMIIuFYa8mSqY5llU0sBrRyC
	9xy/G3JWOZ2eGn
Subject: Re: Definition of fairness (was Re: [patch] CFS scheduler, -v11)
From: Mike Galbraith <efault@gmx.de>
To: vatsa@in.ibm.com
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Willy Tarreau <w@1wt.eu>, Gene Heskett <gene.heskett@gmail.com>,
       Mark Lord <lkml@rtr.ca>, tingy@cs.umass.edu, tong.n.li@intel.com
In-Reply-To: <20070509180205.GA27462@in.ibm.com>
References: <20070508150431.GA26977@elte.hu>
	 <20070509180205.GA27462@in.ibm.com>
Content-Type: text/plain
Date: Thu, 10 May 2007 10:51:58 +0200
Message-Id: <1178787118.6035.26.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-05-09 at 23:32 +0530, Srivatsa Vaddagiri wrote:

> Ingo,
> 	I had a question with respect to the definition of fairness used, esp
> for tasks that are not 100% cpu hogs.
> 
> Ex: consider two equally important tasks T1 and T2 running on same CPU and 
> whose execution nature is:
> 
> 	T1 = 100% cpu hog
> 	T2 = 60% cpu hog (run for 600ms, sleep for 400ms)
> 
> Over a arbitrary observation period of 10 sec, 
> 
> 	T1 was ready to run for all 10sec
> 	T2 was ready to run for 6 sec
> 
> Over this observation period, how much execution time should T2 get,
> under a "fair" scheduler?
> 
> I was expecting both T2 and T1 to get 5 sec (50:50 split). Is this a
> wrong expectation of fairness?

Depends on how long your fairness yardstick is I suppose.

> Anyway, results of this experiment (using testcase attached) is below.
> T2 gets way below its fair share IMO (under both cfs and sd).
> 
> 
> 2.6.21.1:
> 
>  5444 vatsa     16   0  2468  460  388 R   59  0.0   0:19.76 3 T1
>  5443 vatsa     25   0  2468  460  388 R   40  0.0   0:15.36 3 T2
> 
> 
> 2.6.21.1 + cfs-v11:
> 
>  5460 vatsa     31   0  2464  460  388 R   70  0.0   0:15.28 3 T1
>  5461 vatsa     29   0  2468  460  388 R   30  0.0   0:05.65 3 T2
> 
> 
> 2.6.21 + sd-0.48:
> 
>  5459 vatsa     23   0  2468  460  388 R   70  0.0   0:17.02 3 T1
>  5460 vatsa     21   0  2464  460  388 R   30  0.0   0:06.21 3 T2
> 
> 
> Note: 
> 
> T1 is started as ./cpuhog 600 0 10 > /dev/null &

 6524 root      20   0  1432  396  336 S   51  0.0   2:31.83 1 cpuhog
 6525 root      20   0  1436  356  296 R   48  0.0   2:25.76 1 chew

> T2 is started as ./cpuhog 600 400 10 > /dev/null &

That's cpuhog in the above, and chew is the 100% hog.  The below is
cpuhog as you started them. 

 6565 root      20   0  1436  396  336 R   51  0.0   1:49.30 1 cpuhog
 6566 root      20   0  1432  396  336 S   49  0.0   1:59.16 1 cpuhog

FWIW, I can squeeze some better long term fairness out of it by doing
the below.

If a task isn't going to sleep, it's always in competition with someone
even if it happens to be the invisible man right now, so runners will
drift to the right.  Also,  these two tasks aren't necessarily the same
at dequeue time wrt the effect they have (or rather _will_ have) on the
system, but are being treated as if they're identical twins.

	-Mike

Experimental gefingerpoken und mittengrabben.

--- kernel/sched_fair.c.org	2007-05-08 07:51:48.000000000 +0200
+++ kernel/sched_fair.c	2007-05-10 09:43:17.000000000 +0200
@@ -20,7 +20,7 @@ unsigned int sysctl_sched_granularity __
 
 unsigned int sysctl_sched_sleep_history_max __read_mostly = 2000000000;
 
-unsigned int sysctl_sched_load_smoothing = 1 | 2 | 4 | 0;
+unsigned int sysctl_sched_load_smoothing = 0 | 0 | 0 | 0 | 16;
 
 /*
  * Wake-up granularity.
@@ -140,6 +140,8 @@ static void limit_wait_runtime(struct ta
 {
 	s64 limit = sysctl_sched_granularity * 16;
 
+	if (sysctl_sched_load_smoothing & 16)
+		limit = sysctl_sched_sleep_history_max >> 1;
 	if (p->wait_runtime > limit)
 		p->wait_runtime = limit;
 	if (p->wait_runtime < -limit)
@@ -150,10 +152,11 @@ static void limit_wait_runtime(struct ta
  * Update the current task's runtime statistics. Skip current tasks that
  * are not in our scheduling class.
  */
-static inline void update_curr(struct rq *rq, u64 now)
+static inline void update_curr(struct rq *rq, u64 now, int load_weight)
 {
 	u64 delta_exec, delta_fair, delta_mine;
 	struct task_struct *curr = rq->curr;
+	unsigned long load = get_rq_load(rq);
 
 	if (curr->sched_class != &fair_sched_class || curr == rq->idle
 			|| !curr->on_rq)
@@ -167,8 +170,6 @@ static inline void update_curr(struct rq
 		curr->exec_max = delta_exec;
 
 	if (sysctl_sched_load_smoothing & 1) {
-		unsigned long load = get_rq_load(rq);
-
 		if (sysctl_sched_load_smoothing & 2) {
 			delta_fair = delta_exec << NICE_0_SHIFT;
 			do_div(delta_fair, load);
@@ -178,13 +179,13 @@ static inline void update_curr(struct rq
 		}
 
 		delta_mine = delta_exec * curr->load_weight;
-		do_div(delta_mine, load);
+		do_div(delta_mine, load + load_weight);
 	} else {
 		delta_fair = delta_exec << NICE_0_SHIFT;
-		do_div(delta_fair, rq->raw_weighted_load);
+		do_div(delta_fair, load);
 
 		delta_mine = delta_exec * curr->load_weight;
-		do_div(delta_mine, rq->raw_weighted_load);
+		do_div(delta_mine, load + load_weight);
 	}
 
 	curr->sum_exec_runtime += delta_exec;
@@ -300,7 +301,7 @@ update_stats_wait_end(struct rq *rq, str
 static inline void
 update_stats_dequeue(struct rq *rq, struct task_struct *p, u64 now)
 {
-	update_curr(rq, now);
+	update_curr(rq, now, !p->sleep_start_fair ? NICE_0_LOAD : 0);
 	/*
 	 * Mark the end of the wait period if dequeueing a
 	 * waiting task:
@@ -327,7 +328,7 @@ update_stats_curr_start(struct rq *rq, s
 static inline void
 update_stats_curr_end(struct rq *rq, struct task_struct *p, u64 now)
 {
-	update_curr(rq, now);
+	update_curr(rq, now, !p->sleep_start_fair ? NICE_0_LOAD : 0);
 
 	p->exec_start = 0;
 }
@@ -378,7 +379,7 @@ enqueue_task_fair(struct rq *rq, struct 
 	/*
 	 * Update the fair clock.
 	 */
-	update_curr(rq, now);
+	update_curr(rq, now, 0);
 
 	if (wakeup) {
 		if (p->sleep_start) {



