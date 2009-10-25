Return-Path: <linux-kernel-owner+w=401wt.eu-S1754235AbZJYWEq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754235AbZJYWEq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Oct 2009 18:04:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754219AbZJYWEq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Oct 2009 18:04:46 -0400
Received: from mail.gmx.net ([213.165.64.20]:48246 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754181AbZJYWEp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Oct 2009 18:04:45 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+6ebRmXwm6/RFzeREah9ytqT+vYr+2/3lTM5xHxt
	FiMabJM+xAGj2v
Subject: Re: [PATCH 3/3] sched: Disable affine wakeups by default
From: Mike Galbraith <efault@gmx.de>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Peter Zijlstra <peterz@infradead.org>, mingo@elte.hu,
       linux-kernel@vger.kernel.org
In-Reply-To: <20091025123319.2b76bf69@infradead.org>
References: <20091024125853.35143117@infradead.org>
	 <20091024130432.0c46ef27@infradead.org>
	 <20091024130728.051c4d7c@infradead.org>
	 <1256453725.12138.40.camel@marge.simson.net>
	 <20091025095109.449bac9e@infradead.org>
	 <1256492289.14241.40.camel@marge.simson.net>
	 <20091025123319.2b76bf69@infradead.org>
Content-Type: text/plain
Date: Sun, 25 Oct 2009 23:04:47 +0100
Message-Id: <1256508287.17306.14.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.45
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-10-25 at 12:33 -0700, Arjan van de Ven wrote:
> On Sun, 25 Oct 2009 18:38:09 +0100
> Mike Galbraith <efault@gmx.de> wrote:
> > > > Even if you're sharing a cache, there are reasons to wake
> > > > affine.  If the wakee can preempt the waker while it's still
> > > > eligible to run, wakee not only eats toasty warm data, it can
> > > > hand the cpu back to the waker so it can make more and repeat
> > > > this procedure for a while without someone else getting in
> > > > between, and trashing cache. 
> > > 
> > > and on the flipside, and this is the workload I'm looking at,
> > > this is halving your performance roughly due to one core being
> > > totally busy while the other one is idle.
> > 
> > Yeah, the "one pgsql+oltp pair" in the numbers I posted show that
> > problem really well.  If you can hit an idle shared cache at low load,
> > go for it every time. 
> 
> sadly the current code does not do this ;(
> my patch might be too big an axe for it, but it does solve this part ;)

The below fixed up pgsql+oltp low end, but has negative effect on high
end.  Must be some stuttering going on.

> I'll keep digging to see if we can do a more micro-incursion.
> 
> > Hm.  That looks like a bug, but after any task has scheduled a few
> > times, if it looks like a synchronous task, it'll glue itself to it's
> > waker's runqueue regardless.  Initial wakeup may disperse, but it will
> > come back if it's not overlapping.
> 
> the problem is the "synchronous to WHAT" question.
> It may be synchronous to the disk for example; in the testcase I'm
> looking at, we get "send message to X. do some more code. hit a page
> cache miss and do IO" quite a bit.

Hm.  Yes, disk could be problematic. It's going to be exactly what the
affinity code looks for, you wake somebody, and almost immediately go to
sleep.  OTOH, even a house keeper threads make warm data.

> > > The numbers you posted are for a database, and only measure
> > > throughput. There's more to the world than just databases /
> > > throughput-only computing, and I'm trying to find low impact ways
> > > to reduce the latency aspect of things. One obvious candidate is
> > > hyperthreading/SMT where it IS basically free to switch to a
> > > sibbling, so wake-affine does not really make sense there.
> > 
> > It's also almost free on my Q6600 if we aimed for idle shared cache.
> 
> yeah multicore with shared cache falls for me in the same bucket.

Anyone with a non-shared cache multicore would be most unhappy with my
little test hack.
 
> > I agree fully that affinity decisions could be more perfect than they
> > are.  Getting it wrong is very expensive either way.
> 
> Looks like we agree on a key principle:
> If there is a free cpu "close enough" (SMT or MC basically), the
> wakee should just run on that. 
> 
> we may not agree on what to do if there's no completely free logical
> cpu, but a much lighter loaded one instead.
> but first we need to let code speak ;)

mysql+oltp
clients             1          2          4          8         16         32         64        128        256
tip          10013.90   18526.84   34900.38   34420.14   33069.83   32083.40   30578.30   28010.71   25605.47 3x avg
tip+         10071.16   18498.33   34697.17   34275.20   32761.96   31657.10   30223.70   27363.50   24698.71
              9971.57   18290.17   34632.46   34204.59   32588.94   31513.19   30081.51   27504.66   24832.24
              9884.04   18502.26   34650.08   34250.13   32707.81   31566.86   29954.19   27417.09   24811.75
             

pgsql+oltp
clients             1          2          4          8         16         32         64        128        256
tip          13907.85   27135.87   52951.98   52514.04   51742.52   50705.43   49947.97   48374.19   46227.94 3x avg
tip+         15163.56   28882.70   52374.32   52469.79   51739.79   50602.02   49827.18   48029.84   46191.90
             15258.65   28778.77   52716.46   52405.32   51434.21   50440.66   49718.89   48082.22   46124.56
             15278.02   28178.55   52815.82   52609.98   51729.17   50652.10   49800.19   48126.95   46286.58


diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 37087a7..fa534f0 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1374,6 +1374,8 @@ static int select_task_rq_fair(struct task_struct *p, int sd_flag, int wake_flag
 
 	rcu_read_lock();
 	for_each_domain(cpu, tmp) {
+		int level = tmp->level;
+
 		/*
 		 * If power savings logic is enabled for a domain, see if we
 		 * are not overloaded, if so, don't balance wider.
@@ -1398,11 +1400,28 @@ static int select_task_rq_fair(struct task_struct *p, int sd_flag, int wake_flag
 				want_sd = 0;
 		}
 
+		/*
+		 * look for an idle shared cache before looking at last CPU.
+		 */
 		if (want_affine && (tmp->flags & SD_WAKE_AFFINE) &&
-		    cpumask_test_cpu(prev_cpu, sched_domain_span(tmp))) {
+				(level == SD_LV_SIBLING || level == SD_LV_MC)) {
+			int i;
 
+			for_each_cpu(i, sched_domain_span(tmp)) {
+				if (!cpu_rq(i)->cfs.nr_running) {
+					affine_sd = tmp;
+					want_affine = 0;
+					cpu = i;
+				}
+			}
+		} else if (want_affine && (tmp->flags & SD_WAKE_AFFINE) &&
+		    cpumask_test_cpu(prev_cpu, sched_domain_span(tmp))) {
 			affine_sd = tmp;
 			want_affine = 0;
+
+			if ((level == SD_LV_SIBLING || level == SD_LV_MC) &&
+					!cpu_rq(prev_cpu)->cfs.nr_running)
+				cpu = prev_cpu;
 		}
 
 		if (!want_sd && !want_affine)


