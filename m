Return-Path: <linux-kernel-owner+w=401wt.eu-S1752050AbZCHKCT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752050AbZCHKCT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Mar 2009 06:02:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751319AbZCHKCI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Mar 2009 06:02:08 -0400
Received: from mail.gmx.net ([213.165.64.20]:53179 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751291AbZCHKCH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Mar 2009 06:02:07 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18DOadodiwDLdJVbAE+nfXfABGiu9iKZ6uwt0uRqQ
	UfD1fbWx8f5sAB
Subject: Re: scheduler oddity [bug?]
From: Mike Galbraith <efault@gmx.de>
To: Balazs Scheidler <bazsi@balabit.hu>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
In-Reply-To: <1236506309.6972.8.camel@marge.simson.net>
References: <1236448069.16726.21.camel@bzorp.balabit>
	 <1236505323.6281.57.camel@marge.simson.net>
	 <1236506309.6972.8.camel@marge.simson.net>
Content-Type: text/plain
Date: Sun, 08 Mar 2009 11:02:02 +0100
Message-Id: <1236506522.6972.13.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.46
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-03-08 at 10:58 +0100, Mike Galbraith wrote:
> On Sun, 2009-03-08 at 10:42 +0100, Mike Galbraith wrote:
> > On Sat, 2009-03-07 at 18:47 +0100, Balazs Scheidler wrote:
> > > Hi,
> > > 
> > > I'm experiencing an odd behaviour from the Linux scheduler. I have an
> > > application that feeds data to another process using a pipe. Both
> > > processes use a fair amount of CPU time apart from writing to/reading
> > > from this pipe.
> > > 
> > > The machine I'm running on  is an Opteron Quad-Core CPU:
> > > model name	: Quad-Core AMD Opteron(tm) Processor 2347 HE
> > > stepping	: 3
> > > 
> > > What I see is that only one of the cores is used, the other three is
> > > idling without doing any work. If I explicitly set the CPU affinity of
> > > the processes to use distinct CPUs the performance goes up
> > > significantly. (e.g. it starts to use the other cores and the load
> > > scales linearly).
> > > 
> > > I've tried to reproduce the problem by writing a small test program,
> > > which you can find attached. The program creates two processes, one
> > > feeds the other using a pipe and each does a series of memset() calls to
> > > simulate CPU load. I've also added capability to the program to set its
> > > own CPU affinity. The results (the more the better):
> > > 
> > > Without enabling CPU affinity:
> > > $ ./a.out
> > > Check: 0 loops/sec, sum: 1 
> > > Check: 12 loops/sec, sum: 13 
> > > Check: 41 loops/sec, sum: 54 
> > > Check: 41 loops/sec, sum: 95 
> > > Check: 41 loops/sec, sum: 136 
> > > Check: 41 loops/sec, sum: 177 
> > > Check: 41 loops/sec, sum: 218 
> > > Check: 40 loops/sec, sum: 258 
> > > Check: 41 loops/sec, sum: 299 
> > > Check: 41 loops/sec, sum: 340 
> > > Check: 41 loops/sec, sum: 381 
> > > Check: 41 loops/sec, sum: 422 
> > > Check: 41 loops/sec, sum: 463 
> > > Check: 41 loops/sec, sum: 504 
> > > Check: 41 loops/sec, sum: 545 
> > > Check: 40 loops/sec, sum: 585 
> > > Check: 41 loops/sec, sum: 626 
> > > Check: 41 loops/sec, sum: 667 
> > > Check: 41 loops/sec, sum: 708 
> > > Check: 41 loops/sec, sum: 749 
> > > Check: 41 loops/sec, sum: 790 
> > > Check: 41 loops/sec, sum: 831 
> > > Final: 39 loops/sec, sum: 831
> > > 
> > > 
> > > With CPU affinity:
> > > # ./a.out 1
> > > Check: 0 loops/sec, sum: 1 
> > > Check: 41 loops/sec, sum: 42 
> > > Check: 49 loops/sec, sum: 91 
> > > Check: 49 loops/sec, sum: 140 
> > > Check: 49 loops/sec, sum: 189 
> > > Check: 49 loops/sec, sum: 238 
> > > Check: 49 loops/sec, sum: 287 
> > > Check: 50 loops/sec, sum: 337 
> > > Check: 49 loops/sec, sum: 386 
> > > Check: 49 loops/sec, sum: 435 
> > > Check: 49 loops/sec, sum: 484 
> > > Check: 49 loops/sec, sum: 533 
> > > Check: 49 loops/sec, sum: 582 
> > > Check: 49 loops/sec, sum: 631 
> > > Check: 49 loops/sec, sum: 680 
> > > Check: 49 loops/sec, sum: 729 
> > > Check: 49 loops/sec, sum: 778 
> > > Check: 49 loops/sec, sum: 827 
> > > Check: 49 loops/sec, sum: 876 
> > > Check: 49 loops/sec, sum: 925 
> > > Check: 50 loops/sec, sum: 975 
> > > Check: 49 loops/sec, sum: 1024 
> > > Final: 48 loops/sec, sum: 1024
> > > 
> > > The difference is about 20%, which is about the same work performed by
> > > the slave process. If the two processes race for the same CPU this 20%
> > > of performance is lost.
> > > 
> > > I've tested this on 3 computers and each showed the same symptoms:
> > >  * quad core Opteron, running Ubuntu kernel 2.6.27-13.29
> > >  * Core 2 Duo, running Ubuntu kernel 2.6.27-11.27
> > >  * Dual Core Opteron, Debian backports.org kernel 2.6.26-13~bpo40+1
> > > 
> > > Is this a bug, or a feature?
> > 
> > Both.  Affine wakeups are cache friendly, and generally a feature, but
> > can lead to underutilized CPUs in some cases, thus turning feature into
> > bug as your testcase demonstrates.  The metric we for the affinity hint
> > works well, but clearly wants some refinement.
> > 
> > You can turn this scheduler hint off via:
> > 	echo NO_SYNC_WAKEUPS > /sys/kernel/debug/sched_features
> > 
> 

(reply got munged)

> The problem with your particular testcase is that while one half has an
> avg_overlap (what we use as affinity hint for synchronous wakeups) which
> triggers the affinity hint, the other half has avg_overlap of zero, what
> it was born with, so despite significant execution overlap, the
> scheduler treats them as if they were truly synchronous tasks.
> 
> The below cures it, but is only a demo hack.

diff --git a/kernel/sched.c b/kernel/sched.c
index 8e2558c..85f9ced 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1712,11 +1712,15 @@ static void enqueue_task(struct rq *rq, struct task_struct *p, int wakeup)
 
 static void dequeue_task(struct rq *rq, struct task_struct *p, int sleep)
 {
+	u64 limit = sysctl_sched_migration_cost;
+	u64 runtime = p->se.sum_exec_runtime - p->se.prev_sum_exec_runtime;
+
 	if (sleep && p->se.last_wakeup) {
 		update_avg(&p->se.avg_overlap,
 			   p->se.sum_exec_runtime - p->se.last_wakeup);
 		p->se.last_wakeup = 0;
-	}
+	} else if (p->se.avg_overlap < limit && runtime >= limit)
+		update_avg(&p->se.avg_overlap, runtime);
 
 	sched_info_dequeued(p);
 	p->sched_class->dequeue_task(rq, p, sleep);

pipetest (6701, #threads: 1)
---------------------------------------------------------
se.exec_start                      :       5607096.896687
se.vruntime                        :        274158.274352
se.sum_exec_runtime                :        139434.783417
se.avg_overlap                     :             6.477067 <== was zero
nr_switches                        :                 2246
nr_voluntary_switches              :                    1
nr_involuntary_switches            :                 2245
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  102

pipetest (6702, #threads: 1)
---------------------------------------------------------
se.exec_start                      :       5607096.896687
se.vruntime                        :        274098.273516
se.sum_exec_runtime                :         32987.899515
se.avg_overlap                     :             0.502174 <== was always < migration cost
nr_switches                        :                13631
nr_voluntary_switches              :                11639
nr_involuntary_switches            :                 1992
se.load.weight                     :                 1024
policy                             :                    0
prio                               :                  120
clock-delta                        :                  117


