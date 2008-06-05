Return-Path: <linux-kernel-owner+w=401wt.eu-S1759380AbYFEMug@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759380AbYFEMug (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 08:50:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757287AbYFEMuU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 08:50:20 -0400
Received: from viefep26-int.chello.at ([62.179.121.46]:12666 "EHLO
	viefep26-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757489AbYFEMuS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 08:50:18 -0400
X-SourceIP: 80.56.237.116
Subject: Re: [BUG] hotplug cpus on ia64
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Cliff Wickman <cpw@sgi.com>
Cc: sivanich@sgi.com, linux-kernel@vger.kernel.org
In-Reply-To: <20080603221759.GA19039@sgi.com>
References: <E1K1l2y-0007bu-44@eag09.americas.sgi.com>
	 <1212154614.12349.244.camel@twins>  <20080603221759.GA19039@sgi.com>
Content-Type: text/plain
Date: Thu, 05 Jun 2008 14:49:58 +0200
Message-Id: <1212670198.23439.45.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-06-03 at 17:17 -0500, Cliff Wickman wrote:
> On Fri, May 30, 2008 at 03:36:54PM +0200, Peter Zijlstra wrote:
> > On Thu, 2008-05-29 at 11:32 -0500, Cliff Wickman wrote:
> > > >> I built an ia64 kernel from Andrew's tree (2.6.26-rc2-mm1)
> > > >> and get a very predictable hotplug cpu problem.
> > > >> billberry1:/tmp/cpw # ./dis
> > > >> disabled cpu 17
> > > >> enabled cpu 17
> > > >> billberry1:/tmp/cpw # ./dis
> > > >> disabled cpu 17
> > > >> enabled cpu 17
> > > >> billberry1:/tmp/cpw # ./dis
> > > >> 
> > > >> The script that disables the cpu always hangs (unkillable)
> > > >> on the 3rd attempt.
> > > 
> > > > And a bit further:
> > > > The kstopmachine thread always sits on the run queue (real time) for about
> > > > 30 minutes before running.
> > > 
> > > And a bit further:
> > > 
> > > The kstopmachine thread is queued as real-time on the downed cpu:
> > > >> rq -f 17
> > > CPU#       runq address size Lock     current task         time name
> > > ==========================================================================
> > >   17 0xe000046003059540    3  U 0xe0000360f06f8000            0 swapper
> > >         Total of 3 queued:
> > >         3 real time tasks:  px *(rt_rq *)0xe000046003059608
> > >         exclusive queue:
> > >         slot 0
> > >         0xe0000760f4628000            0 migration/17
> > >         0xe0000760f4708000            0 kstopmachine
> > >         0xe0000760f6678000            0 watchdog/17
> > > 
> > > I put in counters and see that schedule() is never again entered by cpu 17
> > > after it is downed the 3rd time.
> > > (it is entered after being up'd the first two times)
> > > 
> > > The kstopmachine thread is bound to cpu 17 by __stop_machine_run()'s call
> > > to kthread_bind().
> > > 
> > > A cpu does not schedule after being downed, of course.  But it does again
> > > after being up'd.  
> > > Why would the second up be different?  Following it, if the cpu is
> > > downed it never schedules again.
> > > 
> > > If I always bind kstopmachine to cpu 0 the problem disappears.
> > 
> > does:
> > 
> > echo -1 > /proc/sys/kernel/sched_rt_runtime_us
> > 
> > fix the problem?
> 
> Yes! It does. 
> 
> Dimitri Sivanich has run into what looks like a similar problem.
> Hope the above workaround is a good clue to its solution.


Does the below fix it?


Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched.c    |   15 +++++--
 kernel/sched_rt.c |  109 +++++++++++++++++++++++++++++++++++++++++++++++++++---
 2 files changed, 115 insertions(+), 9 deletions(-)

Index: linux-2.6/kernel/sched_rt.c
===================================================================
--- linux-2.6.orig/kernel/sched_rt.c
+++ linux-2.6/kernel/sched_rt.c
@@ -280,6 +280,9 @@ static int balance_runtime(struct rt_rq 
 			continue;
 
 		spin_lock(&iter->rt_runtime_lock);
+		if (iter->rt_runtime == RUNTIME_INF)
+			goto next;
+
 		diff = iter->rt_runtime - iter->rt_time;
 		if (diff > 0) {
 			do_div(diff, weight);
@@ -293,12 +296,105 @@ static int balance_runtime(struct rt_rq 
 				break;
 			}
 		}
+next:
 		spin_unlock(&iter->rt_runtime_lock);
 	}
 	spin_unlock(&rt_b->rt_runtime_lock);
 
 	return more;
 }
+
+static void __disable_runtime(struct rq *rq)
+{
+	struct root_domain *rd = rq->rd;
+	struct rt_rq *rt_rq;
+
+	if (unlikely(!scheduler_running))
+		return;
+
+	for_each_leaf_rt_rq(rt_rq, rq) {
+		struct rt_bandwidth *rt_b = sched_rt_bandwidth(rt_rq);
+		s64 want;
+		int i;
+
+		spin_lock(&rt_b->rt_runtime_lock);
+		spin_lock(&rt_rq->rt_runtime_lock);
+		if (rt_rq->rt_runtime == RUNTIME_INF ||
+				rt_rq->rt_runtime == rt_b->rt_runtime)
+			goto balanced;
+		spin_unlock(&rt_rq->rt_runtime_lock);
+
+		want = rt_b->rt_runtime - rt_rq->rt_runtime;
+
+		for_each_cpu_mask(i, rd->span) {
+			struct rt_rq *iter = sched_rt_period_rt_rq(rt_b, i);
+			s64 diff;
+
+			if (iter == rt_rq)
+				continue;
+
+			spin_lock(&iter->rt_runtime_lock);
+			if (want > 0) {
+				diff = min_t(s64, iter->rt_runtime, want);
+				iter->rt_runtime -= diff;
+				want -= diff;
+			} else {
+				iter->rt_runtime -= want;
+				want -= want;
+			}
+			spin_unlock(&iter->rt_runtime_lock);
+
+			if (!want)
+				break;
+		}
+
+		spin_lock(&rt_rq->rt_runtime_lock);
+		BUG_ON(want);
+balanced:
+		rt_rq->rt_runtime = RUNTIME_INF;
+		spin_unlock(&rt_rq->rt_runtime_lock);
+		spin_unlock(&rt_b->rt_runtime_lock);
+	}
+}
+
+static void disable_runtime(struct rq *rq)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&rq->lock, flags);
+	__disable_runtime(rq);
+	spin_unlock_irqrestore(&rq->lock, flags);
+}
+
+static void __enable_runtime(struct rq *rq)
+{
+	struct root_domain *rd = rq->rd;
+	struct rt_rq *rt_rq;
+
+	if (unlikely(!scheduler_running))
+		return;
+
+	for_each_leaf_rt_rq(rt_rq, rq) {
+		struct rt_bandwidth *rt_b = sched_rt_bandwidth(rt_rq);
+
+		spin_lock(&rt_b->rt_runtime_lock);
+		spin_lock(&rt_rq->rt_runtime_lock);
+		rt_rq->rt_runtime = rt_b->rt_runtime;
+		rt_rq->rt_time = 0;
+		spin_unlock(&rt_rq->rt_runtime_lock);
+		spin_unlock(&rt_b->rt_runtime_lock);
+	}
+}
+
+static void enable_runtime(struct rq *rq)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&rq->lock, flags);
+	__enable_runtime(rq);
+	spin_unlock_irqrestore(&rq->lock, flags);
+}
+
 #endif
 
 static inline int rt_se_prio(struct sched_rt_entity *rt_se)
@@ -328,14 +424,13 @@ static int sched_rt_runtime_exceeded(str
 
 #ifdef CONFIG_SMP
 	if (rt_rq->rt_time > runtime) {
-		int more;
-
 		spin_unlock(&rt_rq->rt_runtime_lock);
-		more = balance_runtime(rt_rq);
+		balance_runtime(rt_rq);
 		spin_lock(&rt_rq->rt_runtime_lock);
 
-		if (more)
-			runtime = sched_rt_runtime(rt_rq);
+		runtime = sched_rt_runtime(rt_rq);
+		if (runtime == RUNTIME_INF)
+			return 0;
 	}
 #endif
 
@@ -1157,6 +1252,8 @@ static void join_domain_rt(struct rq *rq
 {
 	if (rq->rt.overloaded)
 		rt_set_overload(rq);
+
+	__enable_runtime(rq);
 }
 
 /* Assumes rq->lock is held */
@@ -1164,6 +1261,8 @@ static void leave_domain_rt(struct rq *r
 {
 	if (rq->rt.overloaded)
 		rt_clear_overload(rq);
+
+	__disable_runtime(rq);
 }
 
 /*
Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -7455,20 +7455,27 @@ int sched_create_sysfs_power_savings_ent
 static int update_sched_domains(struct notifier_block *nfb,
 				unsigned long action, void *hcpu)
 {
+	int cpu = (int)(long)hcpu;
+
 	switch (action) {
-	case CPU_UP_PREPARE:
-	case CPU_UP_PREPARE_FROZEN:
 	case CPU_DOWN_PREPARE:
 	case CPU_DOWN_PREPARE_FROZEN:
+		disable_runtime(cpu_rq(cpu));
+		/* fall-through */
+	case CPU_UP_PREPARE:
+	case CPU_UP_PREPARE_FROZEN:
 		detach_destroy_domains(&cpu_online_map);
 		return NOTIFY_OK;
 
-	case CPU_UP_CANCELED:
-	case CPU_UP_CANCELED_FROZEN:
+
 	case CPU_DOWN_FAILED:
 	case CPU_DOWN_FAILED_FROZEN:
 	case CPU_ONLINE:
 	case CPU_ONLINE_FROZEN:
+		enable_runtime(cpu_rq(cpu));
+		/* fall-through */
+	case CPU_UP_CANCELED:
+	case CPU_UP_CANCELED_FROZEN:
 	case CPU_DEAD:
 	case CPU_DEAD_FROZEN:
 		/*


