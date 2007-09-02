Return-Path: <linux-kernel-owner+w=401wt.eu-S966334AbXIBMC1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966334AbXIBMC1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 08:02:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964961AbXIBMCH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 08:02:07 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:48855 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965935AbXIBMCE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 08:02:04 -0400
Date: Sun, 2 Sep 2007 14:01:54 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Roman Zippel <zippel@linux-m68k.org>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org,
       Mike Galbraith <efault@gmx.de>
Subject: [ANNOUNCE/RFC] Really Simple Really Fair Scheduler
Message-ID: <20070902120154.GA23769@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
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

> Your math is fairly simple (and that is _good_, just like CFS's 
> existing math is simple), it can be summed up in essence as (without 
> complicating it with nice-level weighting, for easy 
> understandability):
> 
> " use the already existing p->sum_exec_runtime 'task runtime' metric 
>   that CFS maintains, and use that as the key into the rb-tree that 
>   selects tasks that should be run next. To handle sleeping tasks: keep 
>   a per-rq sum of all runnable task's ->sum_exec_runtime values and 
>   start newly woken tasks at the average rq->sum/nr_running value. "
> 
> Now your patch does not actually do it that way in a clearly 
> discernible manner because lots of changes are intermixed into one big 
> patch.
> 
> ( please correct me if i got your math wrong. Your patch does not add 
>   any comments at all to the new code and this slowed down my review
>   and analysis of your patch quite considerably. Lack of comments makes
>   it harder to see the purpose and makes it harder to notice the
>   benefits/tradeoffs involved in each change. )

Roman, as an addendum to my review, please find below a prototype patch 
i've just written that implements RSRFS (Really Simple Really Fair 
Scheduler) ontop of CFS. It is intended to demonstrate the essence of 
the math you have presented via your patch. (it has no nice levels 
support yet, to make the math really apparent to everyone interested)

It's a truly simple patch:

  3 files changed, 30 insertions(+), 23 deletions(-)

and gives good fairness:

  $ ./massive_intr 10 10
  002510  00000114
  002515  00000114
  002518  00000114
  002514  00000114
  002513  00000115
  002509  00000115
  002517  00000115
  002511  00000115
  002512  00000115
  002516  00000115

Could you please confirm whether the math algorithm you are suggesting 
is implemented by this patch roughly correctly? (ignoring nice levels, 
i.e. only considering nice-0 tasks, ignoring rounding issues and 
Bresenham optimizations, CPU time slicing and other changes.)

Thanks,

	Ingo

---
 include/linux/sched.h |    1 +
 kernel/sched.c        |    2 ++
 kernel/sched_fair.c   |   50 +++++++++++++++++++++++++++-----------------------
 3 files changed, 30 insertions(+), 23 deletions(-)

Index: linux/include/linux/sched.h
===================================================================
--- linux.orig/include/linux/sched.h
+++ linux/include/linux/sched.h
@@ -904,6 +904,7 @@ struct sched_entity {
 
 	u64			exec_start;
 	u64			sum_exec_runtime;
+	u64			exec_runtime;
 	u64			prev_sum_exec_runtime;
 	u64			wait_start_fair;
 	u64			sleep_start_fair;
Index: linux/kernel/sched.c
===================================================================
--- linux.orig/kernel/sched.c
+++ linux/kernel/sched.c
@@ -183,6 +183,7 @@ struct cfs_rq {
 
 	s64 fair_clock;
 	u64 exec_clock;
+	u64 exec_runtime;
 	s64 wait_runtime;
 	u64 sleeper_bonus;
 	unsigned long wait_runtime_overruns, wait_runtime_underruns;
@@ -1586,6 +1587,7 @@ static void __sched_fork(struct task_str
 {
 	p->se.wait_start_fair		= 0;
 	p->se.exec_start		= 0;
+	p->se.exec_runtime		= 0;
 	p->se.sum_exec_runtime		= 0;
 	p->se.prev_sum_exec_runtime	= 0;
 	p->se.delta_exec		= 0;
Index: linux/kernel/sched_fair.c
===================================================================
--- linux.orig/kernel/sched_fair.c
+++ linux/kernel/sched_fair.c
@@ -82,7 +82,7 @@ enum {
 };
 
 unsigned int sysctl_sched_features __read_mostly =
-		SCHED_FEAT_FAIR_SLEEPERS	*1 |
+		SCHED_FEAT_FAIR_SLEEPERS	*0 |
 		SCHED_FEAT_SLEEPER_AVG		*0 |
 		SCHED_FEAT_SLEEPER_LOAD_AVG	*1 |
 		SCHED_FEAT_PRECISE_CPU_LOAD	*1 |
@@ -194,6 +194,8 @@ __enqueue_entity(struct cfs_rq *cfs_rq, 
 	update_load_add(&cfs_rq->load, se->load.weight);
 	cfs_rq->nr_running++;
 	se->on_rq = 1;
+
+	cfs_rq->exec_runtime += se->exec_runtime;
 }
 
 static inline void
@@ -205,6 +207,8 @@ __dequeue_entity(struct cfs_rq *cfs_rq, 
 	update_load_sub(&cfs_rq->load, se->load.weight);
 	cfs_rq->nr_running--;
 	se->on_rq = 0;
+
+	cfs_rq->exec_runtime -= se->exec_runtime;
 }
 
 static inline struct rb_node *first_fair(struct cfs_rq *cfs_rq)
@@ -347,6 +351,8 @@ __update_curr(struct cfs_rq *cfs_rq, str
 
 	curr->sum_exec_runtime += delta_exec;
 	cfs_rq->exec_clock += delta_exec;
+	curr->exec_runtime += delta_exec;
+	cfs_rq->exec_runtime += delta_exec;
 
 	if (unlikely(!load))
 		return;
@@ -431,7 +437,7 @@ calc_weighted(unsigned long delta, unsig
  */
 static void update_stats_enqueue(struct cfs_rq *cfs_rq, struct sched_entity *se)
 {
-	s64 key;
+	u64 key;
 
 	/*
 	 * Are we enqueueing a waiting task? (for current tasks
@@ -442,26 +448,7 @@ static void update_stats_enqueue(struct 
 	/*
 	 * Update the key:
 	 */
-	key = cfs_rq->fair_clock;
-
-	/*
-	 * Optimize the common nice 0 case:
-	 */
-	if (likely(se->load.weight == NICE_0_LOAD)) {
-		key -= se->wait_runtime;
-	} else {
-		u64 tmp;
-
-		if (se->wait_runtime < 0) {
-			tmp = -se->wait_runtime;
-			key += (tmp * se->load.inv_weight) >>
-					(WMULT_SHIFT - NICE_0_SHIFT);
-		} else {
-			tmp = se->wait_runtime;
-			key -= (tmp * se->load.inv_weight) >>
-					(WMULT_SHIFT - NICE_0_SHIFT);
-		}
-	}
+	key = se->exec_runtime;
 
 	se->fair_key = key;
 }
@@ -583,6 +570,20 @@ static void __enqueue_sleeper(struct cfs
 	cfs_rq->sleeper_bonus += delta_fair;
 }
 
+/*
+ * Newly woken tasks are put into the "middle" of all runnable
+ * task's current runtime:
+ */
+static u64 avg_exec_runtime(struct cfs_rq *cfs_rq)
+{
+	u64 avg_exec_runtime = cfs_rq->exec_runtime;
+
+	if (cfs_rq->nr_running)
+		do_div(avg_exec_runtime, cfs_rq->nr_running);
+
+	return avg_exec_runtime;
+}
+
 static void enqueue_sleeper(struct cfs_rq *cfs_rq, struct sched_entity *se)
 {
 	struct task_struct *tsk = task_of(se);
@@ -640,8 +641,10 @@ enqueue_entity(struct cfs_rq *cfs_rq, st
 	 */
 	update_curr(cfs_rq);
 
-	if (wakeup)
+	if (wakeup) {
+		se->exec_runtime = avg_exec_runtime(cfs_rq);
 		enqueue_sleeper(cfs_rq, se);
+	}
 
 	update_stats_enqueue(cfs_rq, se);
 	__enqueue_entity(cfs_rq, se);
@@ -1126,6 +1129,7 @@ static void task_new_fair(struct rq *rq,
 		schedstat_add(cfs_rq, wait_runtime, se->wait_runtime);
 	}
 
+	se->exec_runtime = avg_exec_runtime(cfs_rq);
 	__enqueue_entity(cfs_rq, se);
 }
 
