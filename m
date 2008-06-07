Return-Path: <linux-kernel-owner+w=401wt.eu-S1761723AbYFGOyT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761723AbYFGOyT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2008 10:54:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756626AbYFGOyM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jun 2008 10:54:12 -0400
Received: from mail.gmx.net ([213.165.64.20]:40748 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756228AbYFGOyL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2008 10:54:11 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19de/gP5IRdtwvI3yZWfIyGbgPB898eidCaZ1QWBr
	Ob2A+TvoAFWY59
Subject: [patch part 2] Re: [patch] Re: PostgreSQL pgbench performance
	regression in 2.6.23+
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Greg Smith <gsmith@gregsmith.com>, Ingo Molnar <mingo@elte.hu>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
In-Reply-To: <1212844084.19205.85.camel@lappy.programming.kicks-ass.net>
References: <1211440207.5733.8.camel@marge.simson.net>
	 <20080522082814.GA4499@linux.vnet.ibm.com>
	 <1211447105.4823.7.camel@marge.simson.net>
	 <1211452465.7606.8.camel@marge.simson.net>
	 <1211455553.4381.9.camel@marge.simson.net>
	 <1211456659.29104.20.camel@twins>
	 <1211458176.5693.6.camel@marge.simson.net>
	 <1211459081.29104.40.camel@twins>
	 <Pine.GSO.4.64.0805230232190.28654@westnet.com>
	 <1211536814.5851.18.camel@marge.simson.net>
	 <20080523101000.GA13964@elte.hu>
	 <1211537717.5851.22.camel@marge.simson.net>
	 <Pine.GSO.4.64.0805231907150.25273@westnet.com>
	 <1211586407.4786.5.camel@marge.simson.net>
	 <Pine.GSO.4.64.0805260851510.24771@westnet.com>
	 <1211867950.5505.47.camel@marge.simson.net>
	 <Pine.GSO.4.64.0806060027290.8466@westnet.com>
	 <1212732780.13981.43.camel@marge.simson.net>
	 <1212838682.5571.6.camel@marge.simson.net>
	 <1212844084.19205.85.camel@lappy.programming.kicks-ass.net>
Content-Type: text/plain
Date: Sat, 07 Jun 2008 16:54:07 +0200
Message-Id: <1212850447.4668.10.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 2008-06-07 at 15:08 +0200, Peter Zijlstra wrote:
> On Sat, 2008-06-07 at 13:38 +0200, Mike Galbraith wrote:
> 
> Interesting.. Looks good.

In that case it _might_ fly, so needs changelog and blame line.

Tasks which awaken many clients can suffer terribly due to affine wakeup
preemption.  This  can (does for pgbench) lead to serialization of the entire
load on one CPU due to ever lowering throughput of the preempted waker and
constant affine wakeup of many preempters.  Prevent this by noticing when
multi-task preemption is going on, ensure that the 1:N waker can always do
a reasonable batch of work, and temporarily restrict further affine wakeups.

Signed-off-by: Mike Galbraith <efault@gmx.de>


 include/linux/sched.h |    1 +
 kernel/sched.c        |    1 +
 kernel/sched_fair.c   |   49 ++++++++++++++++++++++++++++++++++++++++++-------
 3 files changed, 44 insertions(+), 7 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index ae0be3c..73b7d23 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -963,6 +963,7 @@ struct sched_entity {
 
 	u64			last_wakeup;
 	u64			avg_overlap;
+	struct sched_entity	*last_preempter;
 
 #ifdef CONFIG_SCHEDSTATS
 	u64			wait_start;
diff --git a/kernel/sched.c b/kernel/sched.c
index bfb8ad8..deb30e9 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2176,6 +2176,7 @@ static void __sched_fork(struct task_struct *p)
 	p->se.prev_sum_exec_runtime	= 0;
 	p->se.last_wakeup		= 0;
 	p->se.avg_overlap		= 0;
+	p->se.last_preempter		= NULL;
 
 #ifdef CONFIG_SCHEDSTATS
 	p->se.wait_start		= 0;
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 08ae848..4539a79 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -664,6 +664,7 @@ dequeue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int sleep)
 
 	update_stats_dequeue(cfs_rq, se);
 	if (sleep) {
+		se->last_preempter = NULL;
 		update_avg_stats(cfs_rq, se);
 #ifdef CONFIG_SCHEDSTATS
 		if (entity_is_task(se)) {
@@ -692,8 +693,10 @@ check_preempt_tick(struct cfs_rq *cfs_rq, struct sched_entity *curr)
 
 	ideal_runtime = sched_slice(cfs_rq, curr);
 	delta_exec = curr->sum_exec_runtime - curr->prev_sum_exec_runtime;
-	if (delta_exec > ideal_runtime)
+	if (delta_exec > ideal_runtime) {
+		curr->last_preempter = NULL;
 		resched_task(rq_of(cfs_rq)->curr);
+	}
 }
 
 static void
@@ -994,6 +997,7 @@ wake_affine(struct rq *rq, struct sched_domain *this_sd, struct rq *this_rq,
 	    unsigned int imbalance)
 {
 	struct task_struct *curr = this_rq->curr;
+	struct sched_entity *se = &curr->se, *pse = &p->se;
 	unsigned long tl = this_load;
 	unsigned long tl_per_task;
 	int balanced;
@@ -1002,14 +1006,26 @@ wake_affine(struct rq *rq, struct sched_domain *this_sd, struct rq *this_rq,
 		return 0;
 
 	/*
+	 * If the current task is being wakeup preempted by multiple tasks
+	 * that it awakened, such that it can't get significant work done
+	 * between preemptions, try to spread these preemption sources.
+	 */
+	if (sync && se->last_preempter && se->last_preempter != pse) {
+		u64 se_last_exec = se->sum_exec_runtime - se->prev_sum_exec_runtime;
+
+		if (se_last_exec < sysctl_sched_migration_cost)
+			return 0;
+	}
+
+	/*
 	 * If sync wakeup then subtract the (maximum possible)
 	 * effect of the currently running task from the load
 	 * of the current CPU:
 	 */
 	if (sync)
-		tl -= current->se.load.weight;
+		tl -= se->load.weight;
 
-	balanced = 100*(tl + p->se.load.weight) <= imbalance*load;
+	balanced = 100*(tl + pse->load.weight) <= imbalance*load;
 
 	/*
 	 * If the currently running task will sleep within
@@ -1017,8 +1033,8 @@ wake_affine(struct rq *rq, struct sched_domain *this_sd, struct rq *this_rq,
 	 * woken task:
 	 */
 	if (sync && balanced && curr->sched_class == &fair_sched_class) {
-		if (curr->se.avg_overlap < sysctl_sched_migration_cost &&
-				p->se.avg_overlap < sysctl_sched_migration_cost)
+		if (se->avg_overlap < sysctl_sched_migration_cost &&
+				pse->avg_overlap < sysctl_sched_migration_cost)
 			return 1;
 	}
 
@@ -1219,8 +1235,27 @@ static void check_preempt_wakeup(struct rq *rq, struct task_struct *p)
 		pse = parent_entity(pse);
 	}
 
-	if (wakeup_preempt_entity(se, pse) == 1)
-		resched_task(curr);
+	if (wakeup_preempt_entity(se, pse) == 1) {
+		int preempt = 1;
+
+		/*
+		 * If current task is being prempted by multiple wakees,
+		 * tag it for 1:N affine wakeup preemption avoidance.
+		 */
+		if (se->last_preempter && se->last_preempter != pse &&
+				se->load.weight >= pse->load.weight) {
+			u64 exec = se->sum_exec_runtime - se->prev_sum_exec_runtime;
+
+			if (exec < sysctl_sched_migration_cost)
+				preempt = 0;
+		}
+
+		if (se == &current->se)
+			se->last_preempter = pse;
+
+		if (preempt)
+			resched_task(curr);
+	}
 }
 
 static struct task_struct *pick_next_task_fair(struct rq *rq)


