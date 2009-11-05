Return-Path: <linux-kernel-owner+w=401wt.eu-S1757131AbZKEONN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757131AbZKEONN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 09:13:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756601AbZKEONN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 09:13:13 -0500
Received: from mail.gmx.net ([213.165.64.20]:41567 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756015AbZKEONM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 09:13:12 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19wKFIQ1hNwpMmm6eN9FhtSABEesPbv/dJCeZIwxm
	I91w10c8C9DWZr
Subject: Re: There is something with scheduler (was Re: [patch] Re:
 [regression bisect -next] BUG: using smp_processor_id() in preemptible
 [00000000] code: rmmod)
From: Mike Galbraith <efault@gmx.de>
To: Lai Jiangshan <laijs@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org,
       hpa@zytor.com, tglx@linutronix.de
In-Reply-To: <4AF2AC30.4000003@cn.fujitsu.com>
References: <1256784158.2848.8.camel@dhcp231-106.rdu.redhat.com>
	 <1256805552.7158.22.camel@marge.simson.net>
	 <20091029091411.GE22963@elte.hu>
	 <1256807967.7158.58.camel@marge.simson.net>
	 <1256813310.7574.3.camel@marge.simson.net> <20091102182808.GA8950@elte.hu>
	 <1257190811.19608.2.camel@marge.simson.net>
	 <4AF2AC30.4000003@cn.fujitsu.com>
Content-Type: text/plain
Date: Thu, 05 Nov 2009 15:13:08 +0100
Message-Id: <1257430388.6437.31.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.42
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-11-05 at 18:42 +0800, Lai Jiangshan wrote:
> Hello, Ingo
> 
> Mike Galbraith's patch didn't work.
> 
> There is something with scheduler.

Looks that way, see below.

> I still get this bug message:
> 
> BUG: using smp_processor_id() in preemptible [00000000] code: events/1/10
> caller is vmstat_update+0x2a/0x3e
> Pid: 10, comm: events/1 Not tainted 2.6.32-rc6-tip-01796-gd995f1d-dirty #118
> Call Trace:
>  [<c02a3871>] debug_smp_processor_id+0xa5/0xbc
>  [<c01a229e>] vmstat_update+0x2a/0x3e
>  [<c014d6df>] worker_thread+0x134/0x1c2
>  [<c01a2274>] ? vmstat_update+0x0/0x3e
>  [<c0151361>] ? autoremove_wake_function+0x0/0x38
>  [<c014d5ab>] ? worker_thread+0x0/0x1c2
>  [<c0151298>] kthread+0x66/0x6e
>  [<c0151232>] ? kthread+0x0/0x6e
>  [<c0102e97>] kernel_thread_helper+0x7/0x10
> 
> 
> Ftrace shows events/1 was run at cpu#0

I think we may have a problem.  It appears to me that selecting runqueue
without holding the runqueue lock is still unsafe wrt migration.

One problem I see is that we were doing set_task_cpu() without the lock
held, what the kthread_bind() patch fixed.  However, fixing that did..
not much at all.

Probably because once we release the lock, we can be preempted.  Lots of
the things we're looking at can change underneath us without that lock
held.  Anyway below is what I think is proof that this is indeed unsafe.

Virgin source running netperf UDP_STREAM _doubles_ throughput with only
1b9508f applied.  No way in hell that patch can do that.  It needs some
serious help.  Like maybe using more than the two CPUs assigned, running
this and that all over the box (but too fast to _see_ in top)?

sched: restore runqueue locking during runqueue selection. 

Selecting runqueue with the runqueue unlocked is not migration safe,
restore old locking.

Running netperf UDP_STREAM:

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

git v2.6.32-rc6-26-g91d3f9b with only 1b9508f + this patch
Socket  Message  Elapsed      Messages
Size    Size     Time         Okay Errors   Throughput
bytes   bytes    secs            #      #   10^6bits/sec

 65536    4096   60.00     7816923      0    4269.08
 65536           60.00     7816663           4268.94

4200 vs 4000 is believable, 8000 vs 4000?  Not.


Not-Signed-off-by: Mike Galbraith <efault@gmx.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>

---
 kernel/sched.c |   32 +++++++++++++++++---------------
 1 file changed, 17 insertions(+), 15 deletions(-)

Index: linux-2.6.32.git/kernel/sched.c
===================================================================
--- linux-2.6.32.git.orig/kernel/sched.c
+++ linux-2.6.32.git/kernel/sched.c
@@ -2333,25 +2333,30 @@ static int try_to_wake_up(struct task_st
 	if (unlikely(task_running(rq, p)))
 		goto out_activate;
 
-	/*
-	 * In order to handle concurrent wakeups and release the rq->lock
-	 * we put the task in TASK_WAKING state.
-	 *
-	 * First fix up the nr_uninterruptible count:
-	 */
 	if (task_contributes_to_load(p))
 		rq->nr_uninterruptible--;
-	p->state = TASK_WAKING;
-	task_rq_unlock(rq, &flags);
 
 	cpu = p->sched_class->select_task_rq(p, SD_BALANCE_WAKE, wake_flags);
-	if (cpu != orig_cpu)
+	if (cpu != orig_cpu) {
 		set_task_cpu(p, cpu);
+		task_rq_unlock(rq, &flags);
+		/* might preempt at this point */
+		rq = task_rq_lock(p, &flags);
+
+		if (rq != orig_rq)
+			update_rq_clock(rq);
+
+		if (!(p->state & state))
+			goto out;
+		if (p->se.on_rq)
+			goto out_running;
 
-	rq = task_rq_lock(p, &flags);
+		this_cpu = smp_processor_id();
+		cpu = task_cpu(p);
+	}
 
-	if (rq != orig_rq)
-		update_rq_clock(rq);
+	if (cpu != orig_cpu)
+		set_task_cpu(p, cpu);
 
 	if (rq->idle_stamp) {
 		u64 delta = rq->clock - rq->idle_stamp;
@@ -2364,9 +2369,6 @@ static int try_to_wake_up(struct task_st
 		rq->idle_stamp = 0;
 	}
 
-	WARN_ON(p->state != TASK_WAKING);
-	cpu = task_cpu(p);
-
 #ifdef CONFIG_SCHEDSTATS
 	schedstat_inc(rq, ttwu_count);
 	if (cpu == this_cpu)


