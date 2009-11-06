Return-Path: <linux-kernel-owner+w=401wt.eu-S1755496AbZKFFeL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755496AbZKFFeL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 00:34:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754679AbZKFFeK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 00:34:10 -0500
Received: from mail.gmx.net ([213.165.64.20]:41865 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754595AbZKFFeJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 00:34:09 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+BNLBfQwyBKDvs2vp5pT2u306jhHA2laYUguoj/V
	WiH/3+9gwR1d9z
Subject: Re: Intermittent early panic in try_to_wake_up
From: Mike Galbraith <efault@gmx.de>
To: Kevin Winchester <kjwinchester@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Steven Rostedt <rostedt@goodmis.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Yinghai Lu <yinghai@kernel.org>
In-Reply-To: <4AF36364.9090004@gmail.com>
References: <4AE0EBBD.6090005@gmail.com>
	 <1256289781.22979.11.camel@marge.simson.net>  <4AF36364.9090004@gmail.com>
Content-Type: text/plain
Date: Fri, 06 Nov 2009 06:34:10 +0100
Message-Id: <1257485650.6233.17.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.44
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kevin,

On Thu, 2009-11-05 at 19:44 -0400, Kevin Winchester wrote:
> Mike Galbraith wrote:
> > On Thu, 2009-10-22 at 20:33 -0300, Kevin Winchester wrote:
> >> Hi,
> >>
> >> A week or two ago I saw a panic on boot in try_to_wake_up, but it was not
> >> reproducible and I had not written down any trace information.  This
> >> evening I saw it twice more, but then on the third boot things worked fine.
> >> This time I copied down the stack trace:
> >>
> >> try_to_wake_up+0x2e/0x102
> >> wake_up_process+0x10/0x12
> >> kthread_create+0x88/0x12c
> >> ?ksoftirqd+0x00/0xb7
> >> cpu_callback+0x42/0x8f
> >> ?spawn_ksoftirqd+0x0/0x39
> >> spawn_ksoftirqd+0x17/0x39
> >> do_one_initcall+0x58/0x147
> >>
> >> The first time it happened, I remember checking the git logs and it was
> >> shortly after:
> >>
> >> commit f5dc37530ba8a35aae0f7f4f13781d1904f71e94
> >> Author: Mike Galbraith <efault@gmx.de>
> >> Date:   Fri Oct 9 08:35:03 2009 +0200
> >>
> >>     sched: Update the clock of runqueue select_task_rq() selected
> >>     
> >>     In try_to_wake_up(), we update the runqueue clock, but
> >>     select_task_rq() may select a different runqueue than the one we
> >>     updated, leaving the new runqueue's clock stale for a bit.
> >>     
> >>     This patch cures occasional huge latencies reported by latencytop
> >>     when coming out of idle on a mostly idle NO_HZ box.
> >>     
> >>     Signed-off-by: Mike Galbraith <efault@gmx.de>
> >>     Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> >>     LKML-Reference: <1255070103.7639.30.camel@marge.simson.net>
> >>     Signed-off-by: Ingo Molnar <mingo@elte.hu>
> >>
> >>
> >> ...so perhaps that has something to do with it.
> > 
> > I don't think that's very likely.  Box did explode near my grubby
> > fingerprints though.
> > 
> >> Config below.  Any help would be appreciated.
> > 
> > Building with your config, try_to_wake_up+0x2e is around..
> > 
> > (gdb) list *try_to_wake_up+0x2e
> > 0xffffffff81029107 is in try_to_wake_up (kernel/sched.c:2324).
> > 2319            this_cpu = get_cpu();
> > 2320
> > 2321            smp_wmb();
> > 2322            rq = orig_rq = task_rq_lock(p, &flags);
> > 2323            update_rq_clock(rq);
> > 2324            if (!(p->state & state))
> > 2325                    goto out;
> > 2326
> > 2327            if (p->se.on_rq)
> > 2328                    goto out_running;
> > 
> > I don't see how any of that can explode without something very bad
> > having happened to ksoftirqd before we tried to wake it.
> > 
> 
> I thought this problem had solved itself, but I've hit it again three times
> in the last few days.
> 
> I've expanded the CC list a little (based on get_maintainer for
> kernel/softirq.c, since that seems to be involved somehow, and Rafael since
> this definitely seems to be a regression), to see if anyone else has any
> ideas.

I may have found the bad thing that could have happened to ksoftirqd.

If you feel like testing, try the below.  We were altering the task
struct outside of locks, which is not interrupt etc safe.  It cures a
problem I ran into, and will hopefully cure yours as well.


sched: fix runqueue locking buglet.

Calling set_task_cpu() with the runqueue unlocked is unsafe.  Add cpu_rq_lock()
locking primitive, and lock the runqueue.  Also, update rq->clock before calling
set_task_cpu(), as it could be stale.

Running netperf UDP_STREAM with two pinned tasks with tip 1b9508f applied emitted
the thoroughly unbelievable result that ratelimiting newidle could produce twice
the throughput of the virgin kernel.  Reverting to locking the runqueue prior to
runqueue selection restored benchmarking sanity, as did this patchlet.

Signed-off-by: Mike Galbraith <efault@gmx.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>

---
 kernel/sched.c |   32 +++++++++++++++++++++++++-------
 1 file changed, 25 insertions(+), 7 deletions(-)

Index: linux-2.6.32.git/kernel/sched.c
===================================================================
--- linux-2.6.32.git.orig/kernel/sched.c
+++ linux-2.6.32.git/kernel/sched.c
@@ -1011,6 +1011,24 @@ static struct rq *this_rq_lock(void)
 	return rq;
 }
 
+/*
+ * cpu_rq_lock - lock the runqueue a given cpu and disable interrupts.
+ */
+static struct rq *cpu_rq_lock(int cpu, unsigned long *flags)
+	__acquires(rq->lock)
+{
+	struct rq *rq = cpu_rq(cpu);
+
+	spin_lock_irqsave(&rq->lock, *flags);
+	return rq;
+}
+
+static inline void cpu_rq_unlock(struct rq *rq, unsigned long *flags)
+	__releases(rq->lock)
+{
+	spin_unlock_irqrestore(&rq->lock, *flags);
+}
+
 #ifdef CONFIG_SCHED_HRTICK
 /*
  * Use HR-timers to deliver accurate preemption points.
@@ -2342,16 +2360,17 @@ static int try_to_wake_up(struct task_st
 	if (task_contributes_to_load(p))
 		rq->nr_uninterruptible--;
 	p->state = TASK_WAKING;
+	preempt_disable();
 	task_rq_unlock(rq, &flags);
 
 	cpu = p->sched_class->select_task_rq(p, SD_BALANCE_WAKE, wake_flags);
-	if (cpu != orig_cpu)
-		set_task_cpu(p, cpu);
-
-	rq = task_rq_lock(p, &flags);
-
-	if (rq != orig_rq)
+	if (cpu != orig_cpu) {
+		rq = cpu_rq_lock(cpu, &flags);
 		update_rq_clock(rq);
+		set_task_cpu(p, cpu);
+	} else
+		rq = task_rq_lock(p, &flags);
+	preempt_enable_no_resched();
 
 	if (rq->idle_stamp) {
 		u64 delta = rq->clock - rq->idle_stamp;
@@ -2365,7 +2384,6 @@ static int try_to_wake_up(struct task_st
 	}
 
 	WARN_ON(p->state != TASK_WAKING);
-	cpu = task_cpu(p);
 
 #ifdef CONFIG_SCHEDSTATS
 	schedstat_inc(rq, ttwu_count);


