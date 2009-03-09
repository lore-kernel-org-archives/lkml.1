Return-Path: <linux-kernel-owner+w=401wt.eu-S1752815AbZCIPbS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752815AbZCIPbS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 11:31:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751672AbZCIPbB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 11:31:01 -0400
Received: from mail.gmx.net ([213.165.64.20]:49886 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751551AbZCIPbA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 11:31:00 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19eoaAcz7deTenj/BYrx7/q8LEy+Qx4rmN6+WJt8+
	qU9FlC+cABU/Ef
Subject: Re: [patch] Re: scheduler oddity [bug?]
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, Balazs Scheidler <bazsi@balabit.hu>,
       linux-kernel@vger.kernel.org, Willy Tarreau <w@1wt.eu>
In-Reply-To: <1236609711.8389.583.camel@laptop>
References: <1236448069.16726.21.camel@bzorp.balabit>
	 <1236505323.6281.57.camel@marge.simson.net>
	 <1236506309.6972.8.camel@marge.simson.net> <20090308153956.GB19658@elte.hu>
	 <1236529200.7110.16.camel@marge.simson.net>
	 <20090308175255.GA22802@elte.hu>
	 <1236585731.6118.24.camel@marge.simson.net>
	 <20090309080714.GB24904@elte.hu>  <1236596664.8389.331.camel@laptop>
	 <1236604563.6027.8.camel@marge.simson.net>
	 <1236605870.6515.5.camel@marge.simson.net>
	 <1236606389.8389.518.camel@laptop>
	 <1236607083.5980.8.camel@marge.simson.net>
	 <1236607890.6168.7.camel@marge.simson.net>
	 <1236609711.8389.583.camel@laptop>
Content-Type: text/plain
Date: Mon, 09 Mar 2009 16:30:49 +0100
Message-Id: <1236612649.6019.38.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.42
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-03-09 at 15:41 +0100, Peter Zijlstra wrote:
> On Mon, 2009-03-09 at 15:11 +0100, Mike Galbraith wrote:
> 
> > > Yes 2* worked fine.  Mysql+oltp was my worry spot, being a very affinity
> > > sensitive little <bleep>, but my patchlet didn't cause any trouble, so
> > > this one shouldn't either.  I'll do some re-test in any case, and squeak
> > > should anything turn up.
> > 
> > Squeak!  Didn't even get to mysql+oltp.
> > 
> > marge:..local/tmp # netperf -t UDP_STREAM -l 60 -H 127.0.0.1  -- -P 15888,12384 -s 32768 -S 32768 -m 4096
> > UDP UNIDIRECTIONAL SEND TEST from 0.0.0.0 (0.0.0.0) port 15888 AF_INET to 127.0.0.1 (127.0.0.1) port 12384 AF_INET
> > Socket  Message  Elapsed      Messages
> > Size    Size     Time         Okay Errors   Throughput
> > bytes   bytes    secs            #      #   10^6bits/sec
> > 
> >  65536    4096   60.00     5161103      0    2818.65
> >  65536           60.00     5149666           2812.40
> > 
> >  6188 root      20   0  1040  544  324 R  100  0.0   0:31.49 0 netperf
> >  6189 root      20   0  1044  260  164 R   48  0.0   0:15.35 3 netserver
> > 
> > Hurt, pain, ouch, vs...
> > 
> > marge:..local/tmp # netperf -t UDP_STREAM -l 60 -H 127.0.0.1 -T 0,0 -- -P 15888,12384 -s 32768 -S 32768 -m 4096
> > UDP UNIDIRECTIONAL SEND TEST from 0.0.0.0 (0.0.0.0) port 15888 AF_INET to 127.0.0.1 (127.0.0.1) port 12384 AF_INET : cpu bind
> > Socket  Message  Elapsed      Messages
> > Size    Size     Time         Okay Errors   Throughput
> > bytes   bytes    secs            #      #   10^6bits/sec
> > 
> >  65536    4096   60.00     8452028      0    4615.93
> >  65536           60.00     8442945           4610.97
> > 
> > Drat.
> 
> Bugger, so back to the drawing board it is...

Hm.

CPU utilization wise, this test is similar to pipetest.  The major
difference is chunk size.  Netperf is waking and being preempted (if on
the same CPU) at a very high rate, so the hog component gets cpu in tiny
chunks, vs hefty chunks for pipetest.

Simply doing the below (will look very familiar) made both netperf and
pipetest happy again, because of that preemption rate.  Both start life
wanting to be affine, and due to the switch rate, pipetest becomes
non-affine, but netperf remains affine.

Maybe we should factor in wakeup rate, and whether we're waking many vs
one.  Wakeup is tied to data, so there is correlation to potential
cache-miss pain, no?

There is also evidence that your patch did in fact make the right
decision, but that we really REALLY should try to punt to a CPU that
shares a cache if available.  Check out the numbers when the netperf
test runs on two CPUs that share cache.

marge:..local/tmp # netperf -t UDP_STREAM -l 60 -H 127.0.0.1 -T 0,1 -- -P 15888,12384 -s 32768 -S 32768 -m 4096
UDP UNIDIRECTIONAL SEND TEST from 0.0.0.0 (0.0.0.0) port 15888 AF_INET to 127.0.0.1 (127.0.0.1) port 12384 AF_INET : cpu bind
Socket  Message  Elapsed      Messages
Size    Size     Time         Okay Errors   Throughput
bytes   bytes    secs            #      #   10^6bits/sec

 65536    4096   60.00     15325632      0    8369.84
 65536           60.00     15321176           8367.40

(You can skip the below, nothing new there.  Just for completeness;)

diff --git a/kernel/sched.c b/kernel/sched.c
index 8e2558c..0f67b2a 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -4508,6 +4508,24 @@ static inline void schedule_debug(struct task_struct *prev)
 #endif
 }
 
+static void put_prev_task(struct rq *rq, struct task_struct *prev)
+{
+	if (prev->state == TASK_RUNNING) {
+		u64 runtime = prev->se.sum_exec_runtime;
+
+		runtime -= prev->se.prev_sum_exec_runtime;
+		runtime = min_t(u64, runtime, 2*sysctl_sched_migration_cost);
+
+		/*
+		 * In order to avoid avg_overlap growing stale when we are
+		 * indeed overlapping and hence not getting put to sleep, grow
+		 * the avg_overlap on preemption.
+		 */
+		update_avg(&prev->se.avg_overlap, runtime);
+	}
+	prev->sched_class->put_prev_task(rq, prev);
+}
+
 /*
  * Pick up the highest-prio task:
  */
@@ -4586,7 +4604,7 @@ need_resched_nonpreemptible:
 	if (unlikely(!rq->nr_running))
 		idle_balance(cpu, rq);
 
-	prev->sched_class->put_prev_task(rq, prev);
+	put_prev_task(rq, prev);
 	next = pick_next_task(rq, prev);
 
 	if (likely(prev != next)) {


