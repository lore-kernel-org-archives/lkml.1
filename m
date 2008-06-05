Return-Path: <linux-kernel-owner+w=401wt.eu-S1759741AbYFEFUc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759741AbYFEFUc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 01:20:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751648AbYFEFUY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 01:20:24 -0400
Received: from E23SMTP04.au.ibm.com ([202.81.18.173]:44527 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751546AbYFEFUX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 01:20:23 -0400
Date: Thu, 5 Jun 2008 10:50:08 +0530
From: Ankita Garg <ankita@in.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Gregory Haskins <ghaskins@novell.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, rostedt@goodmis.org,
       suresh.b.siddha@intel.com, aneesh.kumar@linux.vnet.ibm.com,
       dhaval@linux.vnet.ibm.com, vatsa@linux.vnet.ibm.com,
       David Bahi <DBahi@novell.com>
Subject: Re: [ANNOUNCE] sched: schedtop utility
Message-ID: <20080605052008.GA7635@in.ibm.com>
Reply-To: Ankita Garg <ankita@in.ibm.com>
References: <483545B4.BA47.005A.0@novell.com> <20080602124822.GA15410@in.ibm.com> <1212412051.6269.5.camel@lappy.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1212412051.6269.5.camel@lappy.programming.kicks-ass.net>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Jun 02, 2008 at 03:07:31PM +0200, Peter Zijlstra wrote:
> On Mon, 2008-06-02 at 18:18 +0530, Ankita Garg wrote:
> > Hi Gregory,
> > 
> > On Thu, May 22, 2008 at 08:06:44AM -0600, Gregory Haskins wrote:
> > > Hi all scheduler developers,
> > >   I had an itch to scratch w.r.t. watching the stats in /proc/schedstats, and it appears that the perl scripts referenced in Documentation/scheduler/sched-stats.txt do not support v14 from HEAD so I whipped up a little utility I call "schedtop".
> > >
> > 
> > Nice tool! Helps in better visualization of the data in schedstats. 
> > 
> > Using the tool, realized that most of the timing related stats therein
> > might not be completely usable in many scenarios, as might already be
> > known.
> > 
> > Without any additional load on the system, all the stats are nice and
> > sane. But, as soon as I ran my particular testcase, the data
> > pertaining to the delta of run_delay/cpu_time went haywire! I understand
> > that all the values are based on top of rq->clock, which relies on tsc that 
> > is not synced across cpus and would result in skews/incorrect values.
> > But, turns out to be not so reliable data for debugging. This is
> > ofcourse nothing related to the tool, but for schedstat in
> > general...rather just adding on to the already existing woes with non-syned 
> > tscs :-)
> 
> Thing is, things runtime should be calculated by using per cpu deltas.
> You take a stamp when you get scheduled on the cpu and another one when
> you stop running, then the delta is added to runtime.
> 
> This is always on the same cpu - when you get migrated you're stopped
> and re-scheduled so that should work out nicely.
> 
> So in that sense it shouldn't matter that the rq->clock values can get
> skewed between cpus.
>
> So I'm still a little puzzled by your observations; though it could be
> that the schedstat stuff got broken - I've never really looked too
> closely at it.
> 

Thanks Peter for the explanation...
I agree with the above and that is the reason why I did not see weird
values with cpu_time. But, run_delay still would suffer skews as the end
points for delta could be taken on different cpus due to migration (more
so on RT kernel due to the push-pull operations). With the below patch,
I could not reproduce the issue I had seen earlier. After every dequeue,
we take the delta and start wait measurements from zero when moved to a 
different rq.
 

Signed-off-by: Ankita Garg <ankita@in.ibm.com> 

Index: linux-2.6.24.4/kernel/sched.c
===================================================================
--- linux-2.6.24.4.orig/kernel/sched.c	2008-06-03 14:14:07.000000000 +0530
+++ linux-2.6.24.4/kernel/sched.c	2008-06-04 12:48:34.000000000 +0530
@@ -948,6 +948,7 @@
 
 static void dequeue_task(struct rq *rq, struct task_struct *p, int sleep)
 {
+	sched_info_dequeued(p);
 	p->sched_class->dequeue_task(rq, p, sleep);
 	p->se.on_rq = 0;
 }
Index: linux-2.6.24.4/kernel/sched_stats.h
===================================================================
--- linux-2.6.24.4.orig/kernel/sched_stats.h	2008-06-03 14:14:28.000000000 +0530
+++ linux-2.6.24.4/kernel/sched_stats.h	2008-06-05 10:39:39.000000000 +0530
@@ -113,6 +113,13 @@
 	if (rq)
 		rq->rq_sched_info.cpu_time += delta;
 }
+
+static inline void
+rq_sched_info_dequeued(struct rq *rq, unsigned long long delta)
+{
+	if (rq)
+		rq->rq_sched_info.run_delay += delta;
+}
 # define schedstat_inc(rq, field)	do { (rq)->field++; } while (0)
 # define schedstat_add(rq, field, amt)	do { (rq)->field += (amt); } while (0)
 # define schedstat_set(var, val)	do { var = (val); } while (0)
@@ -129,6 +136,11 @@
 #endif
 
 #if defined(CONFIG_SCHEDSTATS) || defined(CONFIG_TASK_DELAY_ACCT)
+static inline void sched_info_reset_dequeued(struct task_struct *t)
+{
+	t->sched_info.last_queued = 0;
+}
+
 /*
  * Called when a process is dequeued from the active array and given
  * the cpu.  We should note that with the exception of interactive
@@ -138,15 +150,22 @@
  * active queue, thus delaying tasks in the expired queue from running;
  * see scheduler_tick()).
  *
- * This function is only called from sched_info_arrive(), rather than
- * dequeue_task(). Even though a task may be queued and dequeued multiple
- * times as it is shuffled about, we're really interested in knowing how
- * long it was from the *first* time it was queued to the time that it
- * finally hit a cpu.
+ * Though we are interested in knowing how long it was from the *first* time a
+ * task was queued to the time that it finally hit a cpu, we call this routine
+ * from dequeue_task() to account for possible rq->clock skew across cpus. The
+ * delta taken on each cpu would annul the skew.
  */
 static inline void sched_info_dequeued(struct task_struct *t)
 {
-	t->sched_info.last_queued = 0;
+	unsigned long long now = task_rq(t)->clock, delta = 0;
+
+	if(unlikely(sched_info_on()))
+		if(t->sched_info.last_queued)
+				delta = now - t->sched_info.last_queued;
+	sched_info_reset_dequeued(t);
+	t->sched_info.run_delay += delta;
+
+	rq_sched_info_dequeued(task_rq(t), delta);
 }
 
 /*
@@ -160,7 +179,7 @@
 
 	if (t->sched_info.last_queued)
 		delta = now - t->sched_info.last_queued;
-	sched_info_dequeued(t);
+	sched_info_reset_dequeued(t);
 	t->sched_info.run_delay += delta;
 	t->sched_info.last_arrival = now;
 	t->sched_info.pcount++;

-- 
Regards,
Ankita Garg (ankita@in.ibm.com)
Linux Technology Center
IBM India Systems & Technology Labs, 
Bangalore, India   
