Return-Path: <linux-kernel-owner+w=401wt.eu-S1759918AbXEXGmu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759918AbXEXGmu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 02:42:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755362AbXEXGmn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 02:42:43 -0400
Received: from ausmtp05.au.ibm.com ([202.81.18.154]:56312 "EHLO
	ausmtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755287AbXEXGmm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 02:42:42 -0400
Date: Thu, 24 May 2007 12:12:35 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, pranith-kumar_d@mentorg.com
Subject: Re: [patch] CFS scheduler, -v14
Message-ID: <20070524064235.GA2386@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20070523120616.GA23407@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070523120616.GA23407@elte.hu>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 23, 2007 at 02:06:16PM +0200, Ingo Molnar wrote:
> 
> i'm pleased to announce release -v14 of the CFS scheduler patchset.
> 
> The CFS patch against v2.6.22-rc2, v2.6.21.1 or v2.6.20.10 can be 
> downloaded from the usual place:
>    
>       http://people.redhat.com/mingo/cfs-scheduler/
> 
> In -v14 the biggest user-visible change is increased sleeper fairness 
> (done by Mike Galbraith and myself), which results in better 
> interactivity under load. In particular 3D apps such as compiz/Beryl or 
> games benefit from it and should be less sensitive to other apps running 
> in parallel to them - but plain X benefits from it too.
> 
> CFS is converging nicely, with no regressions reported against -v13. 
> Changes since -v13:
> 
>  - increase sleeper-fairness (Mike Galbraith, me)
> 
>  - kernel/sched_debug.c printk argument fixes for ia64 (Andrew Morton)
> 
>  - CFS documentation fixes (Pranith Kumar D)
> 
>  - increased the default rescheduling granularity to 3msecs on UP,
>    6 msecs on 2-way systems
> 
>  - small update_curr() precision fix
> 
>  - added an overview section to Documentation/sched-design-CFS.txt
> 
>  - misc cleanups
> 
> As usual, any sort of feedback, bugreport, fix and suggestion is more 
> than welcome!
> 
> 	Ingo

Hi, Ingo,

I've implemented a patch on top of v14 for better accounting of
sched_info statistics. Earlier, sched_info relied on jiffies for
accounting and I've seen applications that show "0" cpu usage
statistics (in delay accounting and from /proc) even though they've
been running on the CPU for a long time. The basic problem is that
accounting in jiffies is too coarse to be accurate.

The patch below uses sched_clock() for sched_info accounting.

Comments, suggestions, feedback is more than welcome!

Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
---

 include/linux/sched.h |   10 +++++-----
 kernel/delayacct.c    |   10 +++++-----
 kernel/sched_stats.h  |   28 ++++++++++++++--------------
 3 files changed, 24 insertions(+), 24 deletions(-)

diff -puN kernel/sched_stats.h~move-sched-accounting-to-sched_clock kernel/sched_stats.h
--- linux-2.6.21/kernel/sched_stats.h~move-sched-accounting-to-sched_clock	2007-05-24 11:23:38.000000000 +0530
+++ linux-2.6.21-balbir/kernel/sched_stats.h	2007-05-24 11:23:38.000000000 +0530
@@ -97,10 +97,10 @@ const struct file_operations proc_scheds
  * Expects runqueue lock to be held for atomicity of update
  */
 static inline void
-rq_sched_info_arrive(struct rq *rq, unsigned long delta_jiffies)
+rq_sched_info_arrive(struct rq *rq, unsigned long long delta)
 {
 	if (rq) {
-		rq->rq_sched_info.run_delay += delta_jiffies;
+		rq->rq_sched_info.run_delay += delta;
 		rq->rq_sched_info.pcnt++;
 	}
 }
@@ -109,19 +109,19 @@ rq_sched_info_arrive(struct rq *rq, unsi
  * Expects runqueue lock to be held for atomicity of update
  */
 static inline void
-rq_sched_info_depart(struct rq *rq, unsigned long delta_jiffies)
+rq_sched_info_depart(struct rq *rq, unsigned long long delta)
 {
 	if (rq)
-		rq->rq_sched_info.cpu_time += delta_jiffies;
+		rq->rq_sched_info.cpu_time += delta;
 }
 # define schedstat_inc(rq, field)	do { (rq)->field++; } while (0)
 # define schedstat_add(rq, field, amt)	do { (rq)->field += (amt); } while (0)
 #else /* !CONFIG_SCHEDSTATS */
 static inline void
-rq_sched_info_arrive(struct rq *rq, unsigned long delta_jiffies)
+rq_sched_info_arrive(struct rq *rq, unsigned long long delta)
 {}
 static inline void
-rq_sched_info_depart(struct rq *rq, unsigned long delta_jiffies)
+rq_sched_info_depart(struct rq *rq, unsigned long long delta)
 {}
 # define schedstat_inc(rq, field)	do { } while (0)
 # define schedstat_add(rq, field, amt)	do { } while (0)
@@ -155,16 +155,16 @@ static inline void sched_info_dequeued(s
  */
 static void sched_info_arrive(struct task_struct *t)
 {
-	unsigned long now = jiffies, delta_jiffies = 0;
+	unsigned long long now = sched_clock(), delta = 0;
 
 	if (t->sched_info.last_queued)
-		delta_jiffies = now - t->sched_info.last_queued;
+		delta = now - t->sched_info.last_queued;
 	sched_info_dequeued(t);
-	t->sched_info.run_delay += delta_jiffies;
+	t->sched_info.run_delay += delta;
 	t->sched_info.last_arrival = now;
 	t->sched_info.pcnt++;
 
-	rq_sched_info_arrive(task_rq(t), delta_jiffies);
+	rq_sched_info_arrive(task_rq(t), delta);
 }
 
 /*
@@ -186,7 +186,7 @@ static inline void sched_info_queued(str
 {
 	if (unlikely(sched_info_on()))
 		if (!t->sched_info.last_queued)
-			t->sched_info.last_queued = jiffies;
+			t->sched_info.last_queued = sched_clock();
 }
 
 /*
@@ -195,10 +195,10 @@ static inline void sched_info_queued(str
  */
 static inline void sched_info_depart(struct task_struct *t)
 {
-	unsigned long delta_jiffies = jiffies - t->sched_info.last_arrival;
+	unsigned long long delta = sched_clock() - t->sched_info.last_arrival;
 
-	t->sched_info.cpu_time += delta_jiffies;
-	rq_sched_info_depart(task_rq(t), delta_jiffies);
+	t->sched_info.cpu_time += delta;
+	rq_sched_info_depart(task_rq(t), delta);
 }
 
 /*
diff -puN include/linux/sched.h~move-sched-accounting-to-sched_clock include/linux/sched.h
--- linux-2.6.21/include/linux/sched.h~move-sched-accounting-to-sched_clock	2007-05-24 11:23:38.000000000 +0530
+++ linux-2.6.21-balbir/include/linux/sched.h	2007-05-24 11:23:38.000000000 +0530
@@ -588,13 +588,13 @@ struct reclaim_state;
 #if defined(CONFIG_SCHEDSTATS) || defined(CONFIG_TASK_DELAY_ACCT)
 struct sched_info {
 	/* cumulative counters */
-	unsigned long	cpu_time,	/* time spent on the cpu */
-			run_delay,	/* time spent waiting on a runqueue */
-			pcnt;		/* # of timeslices run on this cpu */
+	unsigned long pcnt;	      /* # of times run on this cpu */
+	unsigned long long cpu_time,  /* time spent on the cpu */
+			   run_delay; /* time spent waiting on a runqueue */
 
 	/* timestamps */
-	unsigned long	last_arrival,	/* when we last ran on a cpu */
-			last_queued;	/* when we were last queued to run */
+	unsigned long long last_arrival,/* when we last ran on a cpu */
+			   last_queued;	/* when we were last queued to run */
 };
 #endif /* defined(CONFIG_SCHEDSTATS) || defined(CONFIG_TASK_DELAY_ACCT) */
 
diff -puN kernel/delayacct.c~move-sched-accounting-to-sched_clock kernel/delayacct.c
--- linux-2.6.21/kernel/delayacct.c~move-sched-accounting-to-sched_clock	2007-05-24 11:31:11.000000000 +0530
+++ linux-2.6.21-balbir/kernel/delayacct.c	2007-05-24 11:52:33.000000000 +0530
@@ -99,9 +99,10 @@ void __delayacct_blkio_end(void)
 int __delayacct_add_tsk(struct taskstats *d, struct task_struct *tsk)
 {
 	s64 tmp;
-	struct timespec ts;
-	unsigned long t1,t2,t3;
+	unsigned long t1;
+	unsigned long long t2,t3;
 	unsigned long flags;
+	struct timespec ts;
 
 	/* Though tsk->delays accessed later, early exit avoids
 	 * unnecessary returning of other data
@@ -124,11 +125,10 @@ int __delayacct_add_tsk(struct taskstats
 
 	d->cpu_count += t1;
 
-	jiffies_to_timespec(t2, &ts);
-	tmp = (s64)d->cpu_delay_total + timespec_to_ns(&ts);
+	tmp = (s64)d->cpu_delay_total + t2;
 	d->cpu_delay_total = (tmp < (s64)d->cpu_delay_total) ? 0 : tmp;
 
-	tmp = (s64)d->cpu_run_virtual_total + (s64)jiffies_to_usecs(t3) * 1000;
+	tmp = (s64)d->cpu_run_virtual_total + t3;
 	d->cpu_run_virtual_total =
 		(tmp < (s64)d->cpu_run_virtual_total) ?	0 : tmp;
 
_

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
