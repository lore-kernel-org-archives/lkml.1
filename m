Return-Path: <linux-kernel-owner+w=401wt.eu-S1756729AbYHUMoA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756729AbYHUMoA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 08:44:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752945AbYHUMnu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 08:43:50 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:56362 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753858AbYHUMnt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 08:43:49 -0400
Subject: Re: [PATCH] sched: properly account IRQ and RT load in SCHED_OTHER
	load balancing
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       Gregory Haskins <ghaskins@novell.com>, vatsa <vatsa@in.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1219310330.8651.93.camel@twins>
References: <1219310330.8651.93.camel@twins>
Content-Type: text/plain
Date: Thu, 21 Aug 2008 14:43:22 +0200
Message-Id: <1219322602.8651.123.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OK, how overboard is this? (utterly uncompiled and such)

I realized while trying to do the (soft)irq accounting Ingo asked for,
that IRQs can preempt SoftIRQs which can preempt RT tasks.

Therefore we actually need to account all these times, so that we can
subtract irq time from measured softirq time, etc.

So this patch does all that.. we could even use this more accurate time
spend on the task delta to drive the scheduler.

NOTE - for now I've only considered softirq from hardirq time, as
ksoftirqd is its own task and is already accounted the regular way.

---
Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -572,9 +572,17 @@ struct rq {
 	struct task_struct *migration_thread;
 	struct list_head migration_queue;
 
-	u64 irq_stamp;
-	unsigned long irq_time;
-	unsigned long rt_time;
+	u64 irq_clock_stamp;
+	u64 sirq_clock_stamp, sirq_irq_stamp;
+	u64 rt_sirq_stamp, rt_irq_stamp;
+
+	u64 rt_time;
+	u64 sirq_time;
+	u64 rt_time;
+
+	unsigned long irq_avg;
+	unsigned long sirq_avg;
+	unsigned long rt_avg;
 	u64 age_stamp;
 
 #endif
@@ -1167,7 +1175,7 @@ void sched_irq_enter(void)
 		struct rq *rq = this_rq();
 
 		update_rq_clock(rq);
-		rq->irq_stamp = rq->clock;
+		rq->irq_clock_stamp = rq->clock;
 	}
 }
 
@@ -1175,12 +1183,58 @@ void sched_irq_exit(void)
 {
 	if (!in_irq()) {
 		struct rq *rq = this_rq();
+		u64 irq_delta;
 
 		update_rq_clock(rq);
-		rq->irq_time += rq->clock - rq->irq_stamp;
+		irq_delta = rq->clock - rq->irq_clock_stamp;
+		rq->irq_time += irq_delta;
+		rq->irq_avg += irq_delta;
 	}
 }
 
+void sched_softirq_enter(void)
+{
+	struct rq *rq = this_rq();
+
+	update_rq_clock(rq);
+	rq->sirq_clock_stamp = rq->clock;
+	rq->sirq_irq_stamp = rq->irq_time;
+}
+
+void sched_softirq_exit(void)
+{
+	struct rq *rq = this_rq();
+	u64 sirq_delta, irq_delta;
+
+	update_rq_clock(rq);
+	sirq_delta = rq->clock - rq->sirq_clock_stamp;
+	irq_delta = rq->irq_time - rq->sirq_irq_stamp;
+	sirq_delta -= irq_delta;
+	rq->sirq_time += sirq_delta;
+	rq->sirq_avg += sirq_delta;
+}
+
+void sched_rt_start(struct rq *rq)
+{
+	rq->rt_sirq_stamp = rq->sirt_time;
+	rq->rt_irq_stamp = rq->irq_time;
+}
+
+void sched_rt_update(struct rq *rq, u64 rt_delta)
+{
+	u64 sirq_delta, irq_delta;
+
+	sirq_delta = rq->sirq_time - rq->rt_sirq_stamp;
+	irq_delta = rq->irq_time - rq->rt_irq_stamp;
+
+	rt_delta -= sirq_delta + irq_delta;
+
+	rq->rt_time += rt_delta;
+	rq->rt_avg += rt_delta;
+
+	sched_rt_start(rq);
+}
+
 static inline u64 sched_avg_period(void)
 {
 	return (u64)sysctl_sched_time_avg * (NSEC_PER_MSEC / 2);
@@ -1192,8 +1246,9 @@ static inline u64 sched_avg_period(void)
 static void sched_age_time(struct rq *rq)
 {
 	if (rq->clock - rq->age_stamp >= sched_avg_period()) {
-		rq->irq_time /= 2;
-		rq->rt_time /= 2;
+		rq->rt_avg /= 2;
+		rq->irq_avg /= 2;
+		rq->sirq_avg /= 2;
 		rq->age_stamp = rq->clock;
 	}
 }
@@ -1207,7 +1262,7 @@ static void sched_age_time(struct rq *rq
 static unsigned long sched_scale_load(struct rq *rq, u64 load)
 {
 	u64 total = sched_avg_period() + (rq->clock - rq->age_stamp);
-	u64 available = total - rq->irq_time - rq->rt_time;
+	u64 available = total - rq->sirq_avg - rq->irq_avg - rq->rt_avg;
 
 	/*
 	 * Shift back to roughly us scale, so that the divisor fits in u32.
@@ -1227,9 +1282,22 @@ static unsigned long sched_scale_load(st
 	return min_t(unsigned long, load, 1UL << 22);
 }
 #else
+static inline void sched_rt_start(struct rq *rq)
+{
+}
+
+static inline void sched_rt_update(struct rq *rq, u64 delta)
+{
+}
+
 static inline void sched_age_time(struct rq *rq)
 {
 }
+
+static inline unsigned long sched_scale_load(unsigned long load)
+{
+	return load;
+}
 #endif
 
 /*
Index: linux-2.6/kernel/sched_rt.c
===================================================================
--- linux-2.6.orig/kernel/sched_rt.c
+++ linux-2.6/kernel/sched_rt.c
@@ -478,13 +478,7 @@ static void update_curr_rt(struct rq *rq
 	if (unlikely((s64)delta_exec < 0))
 		delta_exec = 0;
 
-#ifdef CONFIG_SMP
-	/*
-	 * Account the time spend running RT tasks on this rq. Used to inflate
-	 * this rq's load values.
-	 */
-	rq->rt_time += delta_exec;
-#endif
+	sched_rt_update(rq, delta_exec);
 
 	schedstat_set(curr->se.exec_max, max(curr->se.exec_max, delta_exec));
 
@@ -678,8 +672,6 @@ static void enqueue_task_rt(struct rq *r
 		rt_se->timeout = 0;
 
 	enqueue_rt_entity(rt_se);
-
-	inc_cpu_load(rq, p->se.load.weight);
 }
 
 static void dequeue_task_rt(struct rq *rq, struct task_struct *p, int sleep)
@@ -688,8 +680,6 @@ static void dequeue_task_rt(struct rq *r
 
 	update_curr_rt(rq);
 	dequeue_rt_entity(rt_se);
-
-	dec_cpu_load(rq, p->se.load.weight);
 }
 
 /*
@@ -1458,6 +1448,7 @@ static void set_curr_task_rt(struct rq *
 	struct task_struct *p = rq->curr;
 
 	p->se.exec_start = rq->clock;
+	sched_rt_start(rq);
 }
 
 static const struct sched_class rt_sched_class = {
Index: linux-2.6/kernel/softirq.c
===================================================================
--- linux-2.6.orig/kernel/softirq.c
+++ linux-2.6/kernel/softirq.c
@@ -272,6 +272,14 @@ void irq_enter(void)
 # define invoke_softirq()	do_softirq()
 #endif
 
+#ifdef CONFIG_SMP
+extern void sched_softirq_enter(void);
+extern void sched_softirq_exit(void);
+#else
+#define sched_softirq_enter() do { } while (0)
+#define sched_softirq_exit()  do { } while (0)
+#endif
+
 /*
  * Exit an interrupt context. Process softirqs if needed and possible:
  */
@@ -281,8 +289,11 @@ void irq_exit(void)
 	trace_hardirq_exit();
 	sub_preempt_count(IRQ_EXIT_OFFSET);
 	sched_irq_exit();
-	if (!in_interrupt() && local_softirq_pending())
+	if (!in_interrupt() && local_softirq_pending()) {
+		sched_softirq_enter();
 		invoke_softirq();
+		sched_softirq_exit();
+	}
 
 #ifdef CONFIG_NO_HZ
 	/* Make sure that timer wheel updates are propagated */


