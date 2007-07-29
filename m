Return-Path: <linux-kernel-owner+w=401wt.eu-S932622AbXG2Rh4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932622AbXG2Rh4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 13:37:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758949AbXG2Rht
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 13:37:49 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:48397 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758530AbXG2Rhs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 13:37:48 -0400
Date: Sun, 29 Jul 2007 19:37:35 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Tim Chen <tim.c.chen@linux.intel.com>
Cc: linux-kernel@vger.kernel.org
Subject: [patch] sched: yield debugging
Message-ID: <20070729173735.GA4041@elte.hu>
References: <1185573687.19777.44.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1185573687.19777.44.camel@localhost.localdomain>
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

Tim,

* Tim Chen <tim.c.chen@linux.intel.com> wrote:

> Ingo,
> 
> Volanomark slows by 80% with CFS scheduler on 2.6.23-rc1.  Benchmark 
> was run on a 2 socket Core2 machine.

thanks for testing and reporting this!

> The change in scheduler treatment of sched_yield could play a part in 
> changing Volanomark behavior.

Could you try the patch below? It does not change the default behavior 
of yield but introduces 2 other yield strategies which you can activate 
runtime (if CONFIG_SCHED_DEBUG=y) via:

  # default one:
  echo 0 > /proc/sys/kernel/sched_yield_bug_workaround

  # always queues the current task next to the next task:
  echo 1 > /proc/sys/kernel/sched_yield_bug_workaround

  # NOP:
  echo 2 > /proc/sys/kernel/sched_yield_bug_workaround

does variant '1' improve Java's VolanoMark performance perhaps?

i'm also wondering, which JDK is this, and where does Java make use of 
sys_sched_yield()? It's a voefully badly defined (and thus unreliable) 
system call, IMO Java should stop using it ASAP and use a saner locking 
model.

thanks,

	Ingo

------------------------------->
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
 include/linux/sched.h |    1 
 kernel/sched_fair.c   |   71 +++++++++++++++++++++++++++++++++++++++++++++-----
 kernel/sysctl.c       |    8 +++++
 3 files changed, 74 insertions(+), 6 deletions(-)

Index: linux/include/linux/sched.h
===================================================================
--- linux.orig/include/linux/sched.h
+++ linux/include/linux/sched.h
@@ -1401,6 +1401,7 @@ extern unsigned int sysctl_sched_wakeup_
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
@@ -62,6 +62,16 @@ unsigned int sysctl_sched_stat_granulari
 unsigned int sysctl_sched_runtime_limit __read_mostly;
 
 /*
+ * sys_sched_yield workaround switch.
+ *
+ * This option switches the yield implementation of the
+ * old scheduler back on.
+ */
+unsigned int sysctl_sched_yield_bug_workaround __read_mostly = 0;
+
+EXPORT_SYMBOL_GPL(sysctl_sched_yield_bug_workaround);
+
+/*
  * Debugging: various feature bits
  */
 enum {
@@ -834,14 +844,63 @@ dequeue_task_fair(struct rq *rq, struct 
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
+		yield_key = p_next->se.fair_key + (int)sysctl_sched_granularity;
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
@@ -278,6 +278,14 @@ static ctl_table kern_table[] = {
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
