Return-Path: <linux-kernel-owner+w=401wt.eu-S933544AbXGaUfo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933544AbXGaUfo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 16:35:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933992AbXGaUeB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 16:34:01 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:38310 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933965AbXGaUd6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 16:33:58 -0400
Date: Tue, 31 Jul 2007 22:33:51 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Tim Chen <tim.c.chen@linux.intel.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [patch] sched: yield debugging
Message-ID: <20070731203351.GB21667@elte.hu>
References: <1185573687.19777.44.camel@localhost.localdomain> <20070729173735.GA4041@elte.hu> <1185819052.19777.52.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1185819052.19777.52.camel@localhost.localdomain>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Tim Chen <tim.c.chen@linux.intel.com> wrote:

> Here's a summary of Volanomark performance numbers:
> Variant 0 is 80% down from 2.6.22
> Variant 1 is 20% down from 2.6.22  (this is indeed helped)
> Variant 2 is 89% down from 2.6.22

ok, good! Could you try the updated debug patch below? I've done two 
changes: made '1' the default, and added the 
/proc/sys/kernel/sched_yield_granularity_ns tunable. (available if 
CONFIG_SCHED_DEBUG=y)

Could you try to change the yield-granularity tunable and see which 
value gives the best performance? A value of '100000' should in theory 
give the current (80% degraded) volanomark performance, the default 
value should give the above '20% down' result. The question is, is '20% 
down' the best we can get out of it? Does larger/smaller 
yield-granularity help perhaps? You can change it to any value between 
100 usecs and 1 second.

	Ingo

------------------------------>
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
 kernel/sched_fair.c   |   72 +++++++++++++++++++++++++++++++++++++++++++++-----
 kernel/sysctl.c       |   19 +++++++++++++
 3 files changed, 87 insertions(+), 6 deletions(-)

Index: linux/include/linux/sched.h
===================================================================
--- linux.orig/include/linux/sched.h
+++ linux/include/linux/sched.h
@@ -1397,10 +1397,12 @@ static inline void idle_task_exit(void) 
 extern void sched_idle_next(void);
 
 extern unsigned int sysctl_sched_granularity;
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
@@ -32,6 +32,7 @@
  * systems, 4x on 8-way systems, 5x on 16-way systems, etc.)
  */
 unsigned int sysctl_sched_granularity __read_mostly = 2000000000ULL/HZ;
+unsigned int sysctl_sched_yield_granularity __read_mostly = 2000000000ULL/HZ;
 
 /*
  * SCHED_BATCH wake-up granularity.
@@ -62,6 +63,16 @@ unsigned int sysctl_sched_stat_granulari
 unsigned int sysctl_sched_runtime_limit __read_mostly;
 
 /*
+ * sys_sched_yield workaround switch.
+ *
+ * This option switches the yield implementation of the
+ * old scheduler back on.
+ */
+unsigned int sysctl_sched_yield_bug_workaround __read_mostly = 1;
+
+EXPORT_SYMBOL_GPL(sysctl_sched_yield_bug_workaround);
+
+/*
  * Debugging: various feature bits
  */
 enum {
@@ -834,14 +845,63 @@ dequeue_task_fair(struct rq *rq, struct 
 static void yield_task_fair(struct rq *rq, struct task_struct *p)
 {
 	struct cfs_rq *cfs_rq = task_cfs_rq(p);
+	struct rb_node *curr, *next, *first;
+	struct task_struct *p_next;
 	u64 now = __rq_clock(rq);
+	s64 yield_key;
 
-	/*
-	 * Dequeue and enqueue the task to update its
-	 * position within the tree:
-	 */
-	dequeue_entity(cfs_rq, &p->se, 0, now);
-	enqueue_entity(cfs_rq, &p->se, 0, now);
+
+	switch (sysctl_sched_yield_bug_workaround) {
+	default:
+		/*
+		 * Dequeue and enqueue the task to update its
+		 * position within the tree:
+		 */
+		dequeue_entity(cfs_rq, &p->se, 0, now);
+		enqueue_entity(cfs_rq, &p->se, 0, now);
+		break;
+	case 1:
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
+		dequeue_entity(cfs_rq, &p->se, 0, now);
+
+		/*
+		 * Only update the key if we need to move more backwards
+		 * than the minimally necessary position to be the second:
+		 */
+		if (p->se.fair_key < yield_key)
+			p->se.fair_key = yield_key;
+
+		__enqueue_entity(cfs_rq, &p->se);
+		break;
+	case 2:
+		/*
+		 * Just reschedule, do nothing else:
+		 */
+		resched_task(p);
+		break;
+	}
 }
 
 /*
Index: linux/kernel/sysctl.c
===================================================================
--- linux.orig/kernel/sysctl.c
+++ linux/kernel/sysctl.c
@@ -234,6 +234,17 @@ static ctl_table kern_table[] = {
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
@@ -278,6 +289,14 @@ static ctl_table kern_table[] = {
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
