Return-Path: <linux-kernel-owner+w=401wt.eu-S1758290AbXIMWvk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758290AbXIMWvk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 18:51:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752571AbXIMWva
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 18:51:30 -0400
Received: from an-out-0708.google.com ([209.85.132.251]:22472 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752133AbXIMWv2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 18:51:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Sz303ZlHkPaApgpnCe6/JunOIEi/QpSYT3CQU0gxatXQ1+DceUf2DxOaOYrBH4qlX2we0WmYmPKhYQVrYhtkkpMzIr4aRC5xAkplsCkGTLbQIdJCHZENSLSy1aGFEY0izbDg566rORs9/UvgrIb5Zh0qsVYSNwfnl1ZgCoaFyew=
Subject: Re: [announce] CFS-devel, performance improvements
From: dimm <dmitry.adamushko@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Roman Zippel <zippel@linux-m68k.org>, Mike Galbraith <efault@gmx.de>,
       dmitry.adamushko@gmail.com, linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Fri, 14 Sep 2007 00:51:10 +0200
Message-Id: <1189723870.4485.18.camel@earth>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

please find a couple of minor cleanups below (on top of sched-cfs-v2.6.23-rc6-v21-combo-3.patch):


(1)

Better placement of #ifdef CONFIG_SCHEDSTAT block in dequeue_entity().

Signed-off-by: Dmitry Adamushko <dmitry.adamushko@gmail.com>

---
diff -upr linux-2.6.23-rc6/kernel/sched_fair.c linux-2.6.23-rc6-my/kernel/sched_fair.c
--- linux-2.6.23-rc6/kernel/sched_fair.c	2007-09-13 21:38:49.000000000 +0200
+++ linux-2.6.23-rc6-my/kernel/sched_fair.c	2007-09-13 21:48:50.000000000 +0200
@@ -453,8 +453,8 @@ static void
 dequeue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int sleep)
 {
 	update_stats_dequeue(cfs_rq, se);
-	if (sleep) {
 #ifdef CONFIG_SCHEDSTATS
+	if (sleep) {
 		if (entity_is_task(se)) {
 			struct task_struct *tsk = task_of(se);
 
@@ -463,8 +463,8 @@ dequeue_entity(struct cfs_rq *cfs_rq, st
 			if (tsk->state & TASK_UNINTERRUPTIBLE)
 				se->block_start = rq_of(cfs_rq)->clock;
 		}
-#endif
 	}
+#endif
 	__dequeue_entity(cfs_rq, se);
 }
 
---


(2)

unless we are very eager to keep an additional layer of abstraction,
'struct load_stat' is redundant now so let's get rid of it.

Signed-off-by: Dmitry Adamushko <dmitry.adamushko@gmail.com>


---
diff -upr linux-2.6.23-rc6/kernel/sched.c linux-2.6.23-rc6-sched-dev/kernel/sched.c
--- linux-2.6.23-rc6/kernel/sched.c	2007-09-12 21:37:41.000000000 +0200
+++ linux-2.6.23-rc6-sched-dev/kernel/sched.c	2007-09-12 21:26:10.000000000 +0200
@@ -170,10 +170,6 @@ struct rt_prio_array {
 	struct list_head queue[MAX_RT_PRIO];
 };
 
-struct load_stat {
-	struct load_weight load;
-};
-
 /* CFS-related fields in a runqueue */
 struct cfs_rq {
 	struct load_weight load;
@@ -232,7 +228,7 @@ struct rq {
 #ifdef CONFIG_NO_HZ
 	unsigned char in_nohz_recently;
 #endif
-	struct load_stat ls;	/* capture load from *all* tasks on this cpu */
+	struct load_weight load;	/* capture load from *all* tasks on this cpu */
 	unsigned long nr_load_updates;
 	u64 nr_switches;
 
@@ -804,7 +800,7 @@ static int balance_tasks(struct rq *this
  * Update delta_exec, delta_fair fields for rq.
  *
  * delta_fair clock advances at a rate inversely proportional to
- * total load (rq->ls.load.weight) on the runqueue, while
+ * total load (rq->load.weight) on the runqueue, while
  * delta_exec advances at the same rate as wall-clock (provided
  * cpu is not idle).
  *
@@ -812,17 +808,17 @@ static int balance_tasks(struct rq *this
  * runqueue over any given interval. This (smoothened) load is used
  * during load balance.
  *
- * This function is called /before/ updating rq->ls.load
+ * This function is called /before/ updating rq->load
  * and when switching tasks.
  */
 static inline void inc_load(struct rq *rq, const struct task_struct *p)
 {
-	update_load_add(&rq->ls.load, p->se.load.weight);
+	update_load_add(&rq->load, p->se.load.weight);
 }
 
 static inline void dec_load(struct rq *rq, const struct task_struct *p)
 {
-	update_load_sub(&rq->ls.load, p->se.load.weight);
+	update_load_sub(&rq->load, p->se.load.weight);
 }
 
 static void inc_nr_running(struct task_struct *p, struct rq *rq)
@@ -967,7 +963,7 @@ inline int task_curr(const struct task_s
 /* Used instead of source_load when we know the type == 0 */
 unsigned long weighted_cpuload(const int cpu)
 {
-	return cpu_rq(cpu)->ls.load.weight;
+	return cpu_rq(cpu)->load.weight;
 }
 
 static inline void __set_task_cpu(struct task_struct *p, unsigned int cpu)
@@ -1933,7 +1929,7 @@ unsigned long nr_active(void)
  */
 static void update_cpu_load(struct rq *this_rq)
 {
-	unsigned long this_load = this_rq->ls.load.weight;
+	unsigned long this_load = this_rq->load.weight;
 	int i, scale;
 
 	this_rq->nr_load_updates++;
diff -upr linux-2.6.23-rc6/kernel/sched_debug.c linux-2.6.23-rc6-sched-dev/kernel/sched_debug.c
--- linux-2.6.23-rc6/kernel/sched_debug.c	2007-09-12 21:37:41.000000000 +0200
+++ linux-2.6.23-rc6-sched-dev/kernel/sched_debug.c	2007-09-12 21:36:04.000000000 +0200
@@ -137,7 +137,7 @@ static void print_cpu(struct seq_file *m
 
 	P(nr_running);
 	SEQ_printf(m, "  .%-30s: %lu\n", "load",
-		   rq->ls.load.weight);
+		   rq->load.weight);
 	P(nr_switches);
 	P(nr_load_updates);
 	P(nr_uninterruptible);
diff -upr linux-2.6.23-rc6/kernel/sched_fair.c linux-2.6.23-rc6-sched-dev/kernel/sched_fair.c
--- linux-2.6.23-rc6/kernel/sched_fair.c	2007-09-12 21:37:41.000000000 +0200
+++ linux-2.6.23-rc6-sched-dev/kernel/sched_fair.c	2007-09-12 21:35:27.000000000 +0200
@@ -499,7 +499,7 @@ set_next_entity(struct cfs_rq *cfs_rq, s
 	 * least twice that of our own weight (i.e. dont track it
 	 * when there are only lesser-weight tasks around):
 	 */
-	if (rq_of(cfs_rq)->ls.load.weight >= 2*se->load.weight) {
+	if (rq_of(cfs_rq)->load.weight >= 2*se->load.weight) {
 		se->slice_max = max(se->slice_max,
 			se->sum_exec_runtime - se->prev_sum_exec_runtime);
 	}

---

