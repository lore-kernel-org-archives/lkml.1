Return-Path: <linux-kernel-owner+w=401wt.eu-S1754075AbZKFFL3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754075AbZKFFL3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 00:11:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753477AbZKFFL2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 00:11:28 -0500
Received: from mail.gmx.net ([213.165.64.20]:54205 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752380AbZKFFL1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 00:11:27 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18IXFZr/s0IDMQiwFS9/FQ4KvuiEDZlhMobvtDMkG
	LMBm8wpOhlYkQz
Subject: Re: [patch] Re: There is something with scheduler (was Re: [patch]
 Re: [regression bisect -next] BUG: using smp_processor_id() in preemptible
 [00000000] code: rmmod)
From: Mike Galbraith <efault@gmx.de>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org,
       hpa@zytor.com, tglx@linutronix.de
In-Reply-To: <1257481667.6394.54.camel@marge.simson.net>
References: <1256784158.2848.8.camel@dhcp231-106.rdu.redhat.com>
	 <1256805552.7158.22.camel@marge.simson.net>
	 <20091029091411.GE22963@elte.hu>
	 <1256807967.7158.58.camel@marge.simson.net>
	 <1256813310.7574.3.camel@marge.simson.net> <20091102182808.GA8950@elte.hu>
	 <1257190811.19608.2.camel@marge.simson.net>
	 <4AF2AC30.4000003@cn.fujitsu.com>
	 <1257430388.6437.31.camel@marge.simson.net>
	 <1257431437.7016.3.camel@marge.simson.net>
	 <1257462632.6560.8.camel@marge.simson.net>
	 <4AF38A72.9000900@cn.fujitsu.com>
	 <1257481667.6394.54.camel@marge.simson.net>
Content-Type: text/plain
Date: Fri, 06 Nov 2009 06:11:25 +0100
Message-Id: <1257484285.6233.5.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.42
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-11-06 at 05:27 +0100, Mike Galbraith wrote:

> In fact, now that I think about it more, seems I want to disable preempt
> across the call to select_task_rq().  Concurrency sounds nice, but when
> when waker is preempted, the hostage, who may well have earned the right
> to instant cpu access will wait until the waker returns, and finishes
> looking for a runqueue.  We want to get wakee onto the runqueue asap.
> What happens if say a SCHED_IDLE task gets CPU on a busy box long enough
> to wake kjournald?

So, here's the 6 A.M. no java yet version.  Now to go _make_ some java,
and settle in for a long test session.


sched: fix runqueue locking buglet.

Calling set_task_cpu() with the runqueue unlocked is unsafe.  Add cpu_rq_lock()
locking primitive, and lock the runqueue.  Also, update rq->clock before calling
set_task_cpu(), as it could be stale.

Running netperf UDP_STREAM with two pinned tasks with tip 1b9508f applied emitted
the thoroughly unbelievable result that ratelimiting newidle could produce twice
the throughput of the virgin kernel.  Reverting to locking the runqueue prior to
runqueue selection restored benchmarking sanity, as did this patchlet.

Before:
git v2.6.32-rc6-26-g91d3f9b virgin
Socket  Message  Elapsed      Messages
Size    Size     Time         Okay Errors   Throughput
bytes   bytes    secs            #      #   10^6bits/sec

 65536    4096   60.00     7340005      0    4008.62
 65536           60.00     7320453           3997.94

git v2.6.32-rc6-26-g91d3f9b with only 1b9508f
Socket  Message  Elapsed      Messages
Size    Size     Time         Okay Errors   Throughput
bytes   bytes    secs            #      #   10^6bits/sec

 65536    4096   60.00     15018541      0    8202.12
 65536           60.00     15018232           8201.96

After:
git v2.6.32-rc6-26-g91d3f9b with only 1b9508f + this patch
Socket  Message  Elapsed      Messages
Size    Size     Time         Okay Errors   Throughput
bytes   bytes    secs            #      #   10^6bits/sec

 65536    4096   60.00     7780289      0    4249.07
 65536           60.00     7779832           4248.82


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


