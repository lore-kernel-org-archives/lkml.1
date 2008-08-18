Return-Path: <linux-kernel-owner+w=401wt.eu-S1752968AbYHRKrM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752968AbYHRKrM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 06:47:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751453AbYHRKq6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 06:46:58 -0400
Received: from casper.infradead.org ([85.118.1.10]:48517 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751323AbYHRKq5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 06:46:57 -0400
Subject: [PATCH] sched: rt-bandwidth disable fixes
From: Peter Zijlstra <peterz@infradead.org>
To: Dario Faggioli <raistlin@linux.it>
Cc: Stefani Seibold <stefani@seibold.net>, linux-kernel@vger.kernel.org,
       mingo@redhat.com
In-Reply-To: <1219011326.25992.19.camel@Palanthas>
References: <1218880552.11912.9.camel@matrix>
	 <1218898413.10800.252.camel@twins>  <1218922190.3747.6.camel@matrix>
	 <1219011326.25992.19.camel@Palanthas>
Content-Type: text/plain
Date: Mon, 18 Aug 2008 12:47:09 +0200
Message-Id: <1219056429.10800.302.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-08-18 at 00:15 +0200, Dario Faggioli wrote:
> On Sat, 2008-08-16 at 23:29 +0200, Stefani Seibold wrote:
> > After disabling kernel support for "Group CPU scheduler" and applying
> > 'echo -1 > /proc/sys/kernel/sched_rt_runtime_us' the behaviour is as
> > expected.

> > So the problem is located first in the new sched_rt_runtime_us default
> > value and second in the "Group CPU scheduler".
> Well, if you have group scheduling configured I think you should do both
> # echo -1 > /proc/sys/kernel/sched_rt_runtime_us
> # echo -1 > /dev/cgroup/cpu.rt_runtime_us
> 
> if /dev/cgroup is the mount point of the cgroup file system.
> 
> In situations like the one you are describing, this worked for me...
> Hope that it also helps you! :-)

Ah, right - I knew I was forgetting something..

(compile tested only)

---
Subject: sched: rt-bandwidth disable fixes
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Mon Aug 18 12:39:07 CEST 2008

Currently there is no way to revert to the classical behaviour if
RT_GROUP_SCHED is set. Fix this by introducing rt_bandwidth_enabled(),
which will turn off all the bandwidth accounting if sched_rt_runtime_us
is set to a negative value.

Also fix a bug where we would still increase the used time when the limit
would be set to RUNTIME_INF - causing a long throttle period once it would
be lowered.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched.c    |    9 ++++++++-
 kernel/sched_rt.c |   16 +++++++++-------
 2 files changed, 17 insertions(+), 8 deletions(-)

Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -204,11 +204,13 @@ void init_rt_bandwidth(struct rt_bandwid
 	rt_b->rt_period_timer.cb_mode = HRTIMER_CB_IRQSAFE_NO_SOFTIRQ;
 }
 
+static inline int rt_bandwidth_enabled(void);
+
 static void start_rt_bandwidth(struct rt_bandwidth *rt_b)
 {
 	ktime_t now;
 
-	if (rt_b->rt_runtime == RUNTIME_INF)
+	if (rt_bandwidth_enabled() && rt_b->rt_runtime == RUNTIME_INF)
 		return;
 
 	if (hrtimer_active(&rt_b->rt_period_timer))
@@ -839,6 +841,11 @@ static inline u64 global_rt_runtime(void
 	return (u64)sysctl_sched_rt_runtime * NSEC_PER_USEC;
 }
 
+static inline int rt_bandwidth_enabled(void)
+{
+	return sysctl_sched_rt_runtime >= 0;
+}
+
 #ifndef prepare_arch_switch
 # define prepare_arch_switch(next)	do { } while (0)
 #endif
Index: linux-2.6/kernel/sched_rt.c
===================================================================
--- linux-2.6.orig/kernel/sched_rt.c
+++ linux-2.6/kernel/sched_rt.c
@@ -386,7 +386,7 @@ static int do_sched_rt_period_timer(stru
 	int i, idle = 1;
 	cpumask_t span;
 
-	if (rt_b->rt_runtime == RUNTIME_INF)
+	if (!rt_bandwidth_enabled() || rt_b->rt_runtime == RUNTIME_INF)
 		return 1;
 
 	span = sched_rt_period_mask();
@@ -438,9 +438,6 @@ static int sched_rt_runtime_exceeded(str
 {
 	u64 runtime = sched_rt_runtime(rt_rq);
 
-	if (runtime == RUNTIME_INF)
-		return 0;
-
 	if (rt_rq->rt_throttled)
 		return rt_rq_throttled(rt_rq);
 
@@ -487,13 +484,18 @@ static void update_curr_rt(struct rq *rq
 	curr->se.exec_start = rq->clock;
 	cpuacct_charge(curr, delta_exec);
 
+	if (!rt_bandwidth_enabled())
+		return;
+
 	for_each_sched_rt_entity(rt_se) {
 		rt_rq = rt_rq_of_se(rt_se);
 
 		spin_lock(&rt_rq->rt_runtime_lock);
-		rt_rq->rt_time += delta_exec;
-		if (sched_rt_runtime_exceeded(rt_rq))
-			resched_task(curr);
+		if (sched_rt_runtime(rt_rq) != RUNTIME_INF) {
+			rt_rq->rt_time += delta_exec;
+			if (sched_rt_runtime_exceeded(rt_rq))
+				resched_task(curr);
+		}
 		spin_unlock(&rt_rq->rt_runtime_lock);
 	}
 }


