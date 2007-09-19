Return-Path: <linux-kernel-owner+w=401wt.eu-S1757924AbXISVl1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757924AbXISVl1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 17:41:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752400AbXISVlT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 17:41:19 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:45698 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751535AbXISVlS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 17:41:18 -0400
Date: Wed, 19 Sep 2007 23:41:05 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Chuck Ebbert <cebbert@redhat.com>, Antoine Martin <antoine@nagafix.co.uk>,
       Satyam Sharma <satyam.sharma@gmail.com>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: CFS: some bad numbers with Java/database threading [FIXED]
Message-ID: <20070919214105.GA12245@elte.hu>
References: <a781481a0709140306k3faf3585haae26853fe81381c@mail.gmail.com> <46EAA7E4.8020700@nagafix.co.uk> <20070914153216.GA27213@elte.hu> <46F00417.7080301@redhat.com> <20070918224656.GA26719@elte.hu> <46F058EE.1080408@redhat.com> <20070919191837.GA19500@elte.hu> <alpine.LFD.0.999.0709191230230.16478@woody.linux-foundation.org> <20070919195633.GA23595@elte.hu> <alpine.LFD.0.999.0709191306530.16478@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.999.0709191306530.16478@woody.linux-foundation.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> Btw, the "enqueue at the end" could easily be a statistical thing, not 
> an absolute thing. So it's possible that we could perhaps implement 
> the CFS "yield()" using the same logic as we have now, except *not* 
> calling the "update_stats()" stuff:
> 
> 	__dequeue_entity(..);
> 	__enqueue_entity(..);
> 
> and then just force the "fair_key" of the to something that 
> *statistically* means that it should be at the end of its nice queue.
> 
> I dunno.

i thought a bit about the statistical approach, and it's good in 
principle, but it has an implementational problem/complication: if there 
are only yielding tasks in the system, then the "queue rightwards in the 
tree, statistically" approach cycles through the key-space artificially 
fast. That can cause various problems. (this means that the 
workload-flag patch that uses yield_granularity is buggy as well. The 
queue-rightmost patch did not have this problem.)

So right now there are only two viable options i think: either do the 
current weak thing, or do the rightmost thing. The statistical method 
might work too, but it needs more thought and more testing - i'm not 
sure we can get that ready for 2.6.23.

So what we have as working code right now is the two extremes, and apps 
will really mostly prefer either the first (if they dont truly want to 
use yield but somehow it got into their code) or the second (if they 
want some massive delay). So while it does not have a good QoI, how 
about doing a compat_yield sysctl that allows the turning on of the 
"queue rightmost" logic? Find tested patch below.

Peter, what do you think?

Linus, if this would be acceptable for .23 then i'll push it out into 
sched.git together with another fix that Hiroshi Shimamoto just posted 
to lkml.

	Ingo

-------------------------------------->
Subject: sched: add /proc/sys/kernel/sched_compat_yield
From: Ingo Molnar <mingo@elte.hu>

add /proc/sys/kernel/sched_compat_yield to make sys_sched_yield()
more agressive, by moving the yielding task to the last position
in the rbtree.

with sched_compat_yield=0:

   PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
  2539 mingo     20   0  1576  252  204 R   50  0.0   0:02.03 loop_yield
  2541 mingo     20   0  1576  244  196 R   50  0.0   0:02.05 loop

with sched_compat_yield=1:

   PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
  2584 mingo     20   0  1576  248  196 R   99  0.0   0:52.45 loop
  2582 mingo     20   0  1576  256  204 R    0  0.0   0:00.00 loop_yield

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/sched.h |    1 
 kernel/sched.c        |    5 ---
 kernel/sched_fair.c   |   63 +++++++++++++++++++++++++++++++++++++++++++++-----
 kernel/sysctl.c       |    8 ++++++
 4 files changed, 67 insertions(+), 10 deletions(-)

Index: linux/include/linux/sched.h
===================================================================
--- linux.orig/include/linux/sched.h
+++ linux/include/linux/sched.h
@@ -1406,6 +1406,7 @@ extern unsigned int sysctl_sched_wakeup_
 extern unsigned int sysctl_sched_batch_wakeup_granularity;
 extern unsigned int sysctl_sched_stat_granularity;
 extern unsigned int sysctl_sched_runtime_limit;
+extern unsigned int sysctl_sched_compat_yield;
 extern unsigned int sysctl_sched_child_runs_first;
 extern unsigned int sysctl_sched_features;
 
Index: linux/kernel/sched.c
===================================================================
--- linux.orig/kernel/sched.c
+++ linux/kernel/sched.c
@@ -4550,10 +4550,7 @@ asmlinkage long sys_sched_yield(void)
 	struct rq *rq = this_rq_lock();
 
 	schedstat_inc(rq, yld_cnt);
-	if (unlikely(rq->nr_running == 1))
-		schedstat_inc(rq, yld_act_empty);
-	else
-		current->sched_class->yield_task(rq, current);
+	current->sched_class->yield_task(rq, current);
 
 	/*
 	 * Since we are going to call schedule() anyway, there's
Index: linux/kernel/sched_fair.c
===================================================================
--- linux.orig/kernel/sched_fair.c
+++ linux/kernel/sched_fair.c
@@ -43,6 +43,14 @@ unsigned int sysctl_sched_latency __read
 unsigned int sysctl_sched_min_granularity __read_mostly = 2000000ULL;
 
 /*
+ * sys_sched_yield() compat mode
+ *
+ * This option switches the agressive yield implementation of the
+ * old scheduler back on.
+ */
+unsigned int __read_mostly sysctl_sched_compat_yield;
+
+/*
  * SCHED_BATCH wake-up granularity.
  * (default: 25 msec, units: nanoseconds)
  *
@@ -897,19 +905,62 @@ static void dequeue_task_fair(struct rq 
 }
 
 /*
- * sched_yield() support is very simple - we dequeue and enqueue
+ * sched_yield() support is very simple - we dequeue and enqueue.
+ *
+ * If compat_yield is turned on then we requeue to the end of the tree.
  */
 static void yield_task_fair(struct rq *rq, struct task_struct *p)
 {
 	struct cfs_rq *cfs_rq = task_cfs_rq(p);
+	struct rb_node **link = &cfs_rq->tasks_timeline.rb_node;
+	struct sched_entity *rightmost, *se = &p->se;
+	struct rb_node *parent;
 
-	__update_rq_clock(rq);
 	/*
-	 * Dequeue and enqueue the task to update its
-	 * position within the tree:
+	 * Are we the only task in the tree?
+	 */
+	if (unlikely(cfs_rq->nr_running == 1))
+		return;
+
+	if (likely(!sysctl_sched_compat_yield)) {
+		__update_rq_clock(rq);
+		/*
+		 * Dequeue and enqueue the task to update its
+		 * position within the tree:
+		 */
+		dequeue_entity(cfs_rq, &p->se, 0);
+		enqueue_entity(cfs_rq, &p->se, 0);
+
+		return;
+	}
+	/*
+	 * Find the rightmost entry in the rbtree:
 	 */
-	dequeue_entity(cfs_rq, &p->se, 0);
-	enqueue_entity(cfs_rq, &p->se, 0);
+	do {
+		parent = *link;
+		link = &parent->rb_right;
+	} while (*link);
+
+	rightmost = rb_entry(parent, struct sched_entity, run_node);
+	/*
+	 * Already in the rightmost position?
+	 */
+	if (unlikely(rightmost == se))
+		return;
+
+	/*
+	 * Minimally necessary key value to be last in the tree:
+	 */
+	se->fair_key = rightmost->fair_key + 1;
+
+	if (cfs_rq->rb_leftmost == &se->run_node)
+		cfs_rq->rb_leftmost = rb_next(&se->run_node);
+	/*
+	 * Relink the task to the rightmost position:
+	 */
+	rb_erase(&se->run_node, &cfs_rq->tasks_timeline);
+	rb_link_node(&se->run_node, parent, link);
+	rb_insert_color(&se->run_node, &cfs_rq->tasks_timeline);
 }
 
 /*
Index: linux/kernel/sysctl.c
===================================================================
--- linux.orig/kernel/sysctl.c
+++ linux/kernel/sysctl.c
@@ -303,6 +303,14 @@ static ctl_table kern_table[] = {
 		.proc_handler	= &proc_dointvec,
 	},
 #endif
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "sched_compat_yield",
+		.data		= &sysctl_sched_compat_yield,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec,
+	},
 #ifdef CONFIG_PROVE_LOCKING
 	{
 		.ctl_name	= CTL_UNNUMBERED,
