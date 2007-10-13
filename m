Return-Path: <linux-kernel-owner+w=401wt.eu-S1762033AbXJMWve@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762033AbXJMWve (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 18:51:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753876AbXJMWv0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 18:51:26 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:52230 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753820AbXJMWvZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 18:51:25 -0400
Subject: [RFC][PATCH] sched: SCHED_FIFO watchdog timer
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Mike Galbraith <efault@gmx.de>,
       Lennart Poettering <mztabzr@0pointer.de>
In-Reply-To: <1192222309.5897.3.camel@lappy>
References: <1192222309.5897.3.camel@lappy>
Content-Type: text/plain
Date: Sun, 14 Oct 2007 00:51:07 +0200
Message-Id: <1192315867.5625.6.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The below patch is an idea proposed by tglx and depends on sched-devel +
the hrtick patch previously posted.

The current watchdog action is to demote the task to SCHED_NORMAL,
however it might be wanted to deliver a signal instead (or have more per
task configuration state). Which is why I added Lennart to the CC list
as I gathered he would like something like this for PulseAudio.

---
Subject: sched: SCHED_FIFO watchdog timer

Set a per task (rlimit based) limit on SCHED_FIFO runtime. When the
limit is exceeded the task is demoted back to SCHED_NORMAL.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/asm-generic/resource.h |    5 +++--
 kernel/sched.c                 |    5 +++++
 kernel/sched_rt.c              |   36 ++++++++++++++++++++++++++++++++++++
 3 files changed, 44 insertions(+), 2 deletions(-)

Index: linux-2.6/include/asm-generic/resource.h
===================================================================
--- linux-2.6.orig/include/asm-generic/resource.h
+++ linux-2.6/include/asm-generic/resource.h
@@ -44,8 +44,8 @@
 #define RLIMIT_NICE		13	/* max nice prio allowed to raise to
 					   0-39 for nice level 19 .. -20 */
 #define RLIMIT_RTPRIO		14	/* maximum realtime priority */
-
-#define RLIM_NLIMITS		15
+#define RLIMIT_FIFOTIME		15	/* timeout for fifo slices in us */
+#define RLIM_NLIMITS		16
 
 /*
  * SuS says limits have to be unsigned.
@@ -86,6 +86,7 @@
 	[RLIMIT_MSGQUEUE]	= {   MQ_BYTES_MAX,   MQ_BYTES_MAX },	\
 	[RLIMIT_NICE]		= { 0, 0 },				\
 	[RLIMIT_RTPRIO]		= { 0, 0 },				\
+	[RLIMIT_FIFOTIME]	= {  RLIM_INFINITY,  RLIM_INFINITY },	\
 }
 
 #endif	/* __KERNEL__ */
Index: linux-2.6/kernel/sched_rt.c
===================================================================
--- linux-2.6.orig/kernel/sched_rt.c
+++ linux-2.6/kernel/sched_rt.c
@@ -89,6 +89,14 @@ static struct task_struct *pick_next_tas
 
 	next->se.exec_start = rq->clock;
 
+	if (next->policy == SCHED_FIFO) {
+		unsigned long fifotime;
+
+		fifotime = rq->curr->signal->rlim[RLIMIT_FIFOTIME].rlim_cur;
+		if (fifotime != RLIM_INFINITY)
+			hrtick_start(rq, (u64)fifotime * 1000, 0);
+	}
+
 	return next;
 }
 
@@ -194,8 +202,36 @@ load_balance_rt(struct rq *this_rq, int 
 	return load_moved;
 }
 
+#ifdef CONFIG_SCHED_HRT_TICK
+static int fifo_watchdog(struct rq *rq, struct task_struct *p, int queued)
+{
+	if (likely(!queued || p->policy != SCHED_FIFO))
+		return 0;
+
+	/*
+	 * task has been naughty, turn into SCHED_NORMAL
+	 */
+	printk(KERN_INFO "SCHED_FIFO task %s/%d exceeded his runtime quota,"
+			" demoting to regular task\n", p->comm, task_pid_nr(p));
+	deactivate_task(rq, p, 0);
+	__setscheduler(rq, p, SCHED_NORMAL, 0);
+	activate_task(rq, p, 0);
+	resched_task(p);
+
+	return 1;
+}
+#else
+static inline int fifo_watchdog(struct rq *rq, struct task_struct *p, int queued)
+{
+	return 0;
+}
+#endif
+
 static void task_tick_rt(struct rq *rq, struct task_struct *p, int queued)
 {
+	if (fifo_watchdog(rq, p, queued))
+		return;
+
 	/*
 	 * RR tasks need a special form of timeslice management.
 	 * FIFO tasks have no timeslices.
Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -132,6 +132,11 @@ static inline void sg_inc_cpu_power(stru
 }
 #endif
 
+static void deactivate_task(struct rq *rq, struct task_struct *p, int sleep);
+static void activate_task(struct rq *rq, struct task_struct *p, int wakeup);
+static void
+__setscheduler(struct rq *rq, struct task_struct *p, int policy, int prio);
+
 static inline int rt_policy(int policy)
 {
 	if (unlikely(policy == SCHED_FIFO) || unlikely(policy == SCHED_RR))


