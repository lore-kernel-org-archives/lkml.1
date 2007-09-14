Return-Path: <linux-kernel-owner+w=401wt.eu-S1752734AbXINIdH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752734AbXINIdH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 04:33:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751510AbXINIcz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 04:32:55 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56600 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750910AbXINIcy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 04:32:54 -0400
Date: Fri, 14 Sep 2007 10:32:46 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Antoine Martin <antoine@nagafix.co.uk>
Cc: Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: CFS: some bad numbers with Java/database threading
Message-ID: <20070914083246.GA20514@elte.hu>
References: <46E871FE.9010908@nagafix.co.uk> <20070913112427.GA20686@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070913112427.GA20686@elte.hu>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> hm, could you try the patch below ontop of 2.6.23-rc6 and do:
> 
>  echo 1 > /proc/sys/kernel/sched_yield_bug_workaround
> 
> does this improve the numbers?

the patch i sent was against CFS-devel. Could you try the one below, 
which is against vanilla -rc6, does it improve the numbers? (it should 
have an impact) Keep CONFIG_SCHED_DEBUG=y to be able to twiddle the 
sysctl.

	Ingo

------------------------>
Subject: sched: yield debugging
From: Ingo Molnar <mingo@elte.hu>

introduce various sched_yield implementations:

 # default one:
 echo 0 > /proc/sys/kernel/sched_yield_bug_workaround

 # always queues the current task next to the next task:
 echo 1 > /proc/sys/kernel/sched_yield_bug_workaround

 # NOP:
 echo 2 > /proc/sys/kernel/sched_yield_bug_workaround

tunability depends on CONFIG_SCHED_DEBUG=y.

Not-yet-signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/sched.h |    2 +
 kernel/sched_fair.c   |   73 +++++++++++++++++++++++++++++++++++++++++++++-----
 kernel/sysctl.c       |   19 +++++++++++++
 3 files changed, 88 insertions(+), 6 deletions(-)

Index: linux/include/linux/sched.h
===================================================================
--- linux.orig/include/linux/sched.h
+++ linux/include/linux/sched.h
@@ -1402,10 +1402,12 @@ extern void sched_idle_next(void);
 
 extern unsigned int sysctl_sched_latency;
 extern unsigned int sysctl_sched_min_granularity;
+extern unsigned int sysctl_sched_yield_granularity;
 extern unsigned int sysctl_sched_wakeup_granularity;
 extern unsigned int sysctl_sched_batch_wakeup_granularity;
 extern unsigned int sysctl_sched_stat_granularity;
 extern unsigned int sysctl_sched_runtime_limit;
+extern unsigned int sysctl_sched_yield_bug_workaround;
 extern unsigned int sysctl_sched_child_runs_first;
 extern unsigned int sysctl_sched_features;
 
Index: linux/kernel/sched_fair.c
===================================================================
--- linux.orig/kernel/sched_fair.c
+++ linux/kernel/sched_fair.c
@@ -42,6 +42,16 @@ unsigned int sysctl_sched_latency __read
  */
 unsigned int sysctl_sched_min_granularity __read_mostly = 2000000ULL;
 
+unsigned int sysctl_sched_yield_granularity __read_mostly = 10000000ULL;
+
+/*
+ * sys_sched_yield workaround switch.
+ *
+ * This option switches the yield implementation of the
+ * old scheduler back on.
+ */
+unsigned int __read_mostly sysctl_sched_yield_bug_workaround;
+
 /*
  * SCHED_BATCH wake-up granularity.
  * (default: 25 msec, units: nanoseconds)
@@ -901,15 +911,66 @@ static void dequeue_task_fair(struct rq 
  */
 static void yield_task_fair(struct rq *rq, struct task_struct *p)
 {
-	struct cfs_rq *cfs_rq = task_cfs_rq(p);
+	if (!sysctl_sched_yield_bug_workaround) {
+		struct cfs_rq *cfs_rq = task_cfs_rq(p);
+		__update_rq_clock(rq);
+
+		/*
+		 * Dequeue and enqueue the task to update its
+		 * position within the tree:
+		 */
+		dequeue_entity(cfs_rq, &p->se, 0);
+		enqueue_entity(cfs_rq, &p->se, 0);
+		return;
+	}
+
+	if (sysctl_sched_yield_bug_workaround == 1) {
+		struct cfs_rq *cfs_rq = task_cfs_rq(p);
+		struct rb_node *curr, *next, *first;
+		struct task_struct *p_next;
+		s64 yield_key;
+
+		__update_rq_clock(rq);
+		curr = &p->se.run_node;
+		first = first_fair(cfs_rq);
+		/*
+		 * Move this task to the second place in the tree:
+		 */
+		if (unlikely(curr != first)) {
+			next = first;
+		} else {
+			next = rb_next(curr);
+			/*
+			 * We were the last one already - nothing to do, return
+			 * and reschedule:
+			 */
+			if (unlikely(!next))
+				return;
+		}
+
+		p_next = rb_entry(next, struct task_struct, se.run_node);
+		/*
+		 * Minimally necessary key value to be the second in the tree:
+		 */
+		yield_key = p_next->se.fair_key + (int)sysctl_sched_yield_granularity;
+
+		dequeue_entity(cfs_rq, &p->se, 0);
+
+		/*
+		 * Only update the key if we need to move more backwards
+		 * than the minimally necessary position to be the second:
+		 */
+		if (p->se.fair_key < yield_key)
+			p->se.fair_key = yield_key;
+
+		__enqueue_entity(cfs_rq, &p->se);
+		return;
+	}
 
-	__update_rq_clock(rq);
 	/*
-	 * Dequeue and enqueue the task to update its
-	 * position within the tree:
+	 * Just reschedule, do nothing else:
 	 */
-	dequeue_entity(cfs_rq, &p->se, 0);
-	enqueue_entity(cfs_rq, &p->se, 0);
+	resched_task(p);
 }
 
 /*
Index: linux/kernel/sysctl.c
===================================================================
--- linux.orig/kernel/sysctl.c
+++ linux/kernel/sysctl.c
@@ -244,6 +244,17 @@ static ctl_table kern_table[] = {
 	},
 	{
 		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "sched_yield_granularity_ns",
+		.data		= &sysctl_sched_yield_granularity,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec_minmax,
+		.strategy	= &sysctl_intvec,
+		.extra1		= &min_sched_granularity_ns,
+		.extra2		= &max_sched_granularity_ns,
+	},
+	{
+		.ctl_name	= CTL_UNNUMBERED,
 		.procname	= "sched_wakeup_granularity_ns",
 		.data		= &sysctl_sched_wakeup_granularity,
 		.maxlen		= sizeof(unsigned int),
@@ -288,6 +299,14 @@ static ctl_table kern_table[] = {
 	},
 	{
 		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "sched_yield_bug_workaround",
+		.data		= &sysctl_sched_yield_bug_workaround,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec,
+	},
+	{
+		.ctl_name	= CTL_UNNUMBERED,
 		.procname	= "sched_child_runs_first",
 		.data		= &sysctl_sched_child_runs_first,
 		.maxlen		= sizeof(unsigned int),
