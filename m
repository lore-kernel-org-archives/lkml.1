Return-Path: <linux-kernel-owner+w=401wt.eu-S1757609AbXJKGya@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757609AbXJKGya (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 02:54:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751641AbXJKGyX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 02:54:23 -0400
Received: from qsrv02sl.mx.bigpond.com ([144.140.93.182]:56965 "EHLO
	qsrv02sl.mx.bigpond.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751810AbXJKGyW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 02:54:22 -0400
X-Greylist: delayed 15567 seconds by postgrey-1.27 at vger.kernel.org; Thu, 11 Oct 2007 02:54:21 EDT
Message-ID: <470D7055.4090000@bigpond.net.au>
Date: Thu, 11 Oct 2007 10:37:41 +1000
From: Peter Williams <pwil3058@bigpond.net.au>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Nick Piggin <npiggin@suse.de>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] sched: Rationalize sys_sched_rr_get_interval()
Content-Type: multipart/mixed;
 boundary="------------000703010504000400010707"
X-Authentication-Info: Submitted using SMTP AUTH PLAIN at oaamta08sl.mx.bigpond.com from [121.222.199.46] using ID pwil3058@bigpond.net.au at Thu, 11 Oct 2007 00:37:41 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000703010504000400010707
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

At the moment, static_prio_timeslice() is only used in 
sys_sched_rr_get_interval() and only gives the correct result for 
SCHED_FIFO and SCHED_RR tasks as the time slice for normal tasks is 
unrelated to the values returned by static_prio_timeslice().

This patch addresses this problem and in the process moves all the code 
associated with static_prio_timeslice() to sched_rt.c which is the only 
place where it now has relevance.

Signed-off-by: Peter Williams <pwil3058@bigpond.net.au>

Peter
-- 
Peter Williams                                   pwil3058@bigpond.net.au

"Learning, n. The kind of ignorance distinguishing the studious."
      -- Ambrose Bierce





--------------000703010504000400010707
Content-Type: text/x-patch;
 name="rationalize-sys_sched_rr_get_interval.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="rationalize-sys_sched_rr_get_interval.patch"

diff -r 3df82b0661ca include/linux/sched.h
--- a/include/linux/sched.h	Mon Sep 03 12:06:59 2007 +1000
+++ b/include/linux/sched.h	Mon Sep 03 12:06:59 2007 +1000
@@ -878,6 +878,7 @@ struct sched_class {
 	void (*set_curr_task) (struct rq *rq);
 	void (*task_tick) (struct rq *rq, struct task_struct *p);
 	void (*task_new) (struct rq *rq, struct task_struct *p);
+	unsigned int (*default_timeslice) (struct task_struct *p);
 };
 
 struct load_weight {
diff -r 3df82b0661ca kernel/sched.c
--- a/kernel/sched.c	Mon Sep 03 12:06:59 2007 +1000
+++ b/kernel/sched.c	Mon Sep 03 12:06:59 2007 +1000
@@ -101,16 +101,6 @@ unsigned long long __attribute__((weak))
 #define NICE_0_LOAD		SCHED_LOAD_SCALE
 #define NICE_0_SHIFT		SCHED_LOAD_SHIFT
 
-/*
- * These are the 'tuning knobs' of the scheduler:
- *
- * Minimum timeslice is 5 msecs (or 1 jiffy, whichever is larger),
- * default timeslice is 100 msecs, maximum timeslice is 800 msecs.
- * Timeslices get refilled after they expire.
- */
-#define MIN_TIMESLICE		max(5 * HZ / 1000, 1)
-#define DEF_TIMESLICE		(100 * HZ / 1000)
-
 #ifdef CONFIG_SMP
 /*
  * Divide a load by a sched group cpu_power : (load / sg->__cpu_power)
@@ -131,24 +121,6 @@ static inline void sg_inc_cpu_power(stru
 	sg->reciprocal_cpu_power = reciprocal_value(sg->__cpu_power);
 }
 #endif
-
-#define SCALE_PRIO(x, prio) \
-	max(x * (MAX_PRIO - prio) / (MAX_USER_PRIO / 2), MIN_TIMESLICE)
-
-/*
- * static_prio_timeslice() scales user-nice values [ -20 ... 0 ... 19 ]
- * to time slice values: [800ms ... 100ms ... 5ms]
- */
-static unsigned int static_prio_timeslice(int static_prio)
-{
-	if (static_prio == NICE_TO_PRIO(19))
-		return 1;
-
-	if (static_prio < NICE_TO_PRIO(0))
-		return SCALE_PRIO(DEF_TIMESLICE * 4, static_prio);
-	else
-		return SCALE_PRIO(DEF_TIMESLICE, static_prio);
-}
 
 static inline int rt_policy(int policy)
 {
@@ -4784,8 +4756,7 @@ long sys_sched_rr_get_interval(pid_t pid
 	if (retval)
 		goto out_unlock;
 
-	jiffies_to_timespec(p->policy == SCHED_FIFO ?
-				0 : static_prio_timeslice(p->static_prio), &t);
+	jiffies_to_timespec(p->sched_class->default_timeslice(p), &t);
 	read_unlock(&tasklist_lock);
 	retval = copy_to_user(interval, &t, sizeof(t)) ? -EFAULT : 0;
 out_nounlock:
diff -r 3df82b0661ca kernel/sched_fair.c
--- a/kernel/sched_fair.c	Mon Sep 03 12:06:59 2007 +1000
+++ b/kernel/sched_fair.c	Mon Sep 03 12:06:59 2007 +1000
@@ -1159,6 +1159,11 @@ static void set_curr_task_fair(struct rq
 }
 #endif
 
+static unsigned int default_timeslice_fair(struct task_struct *p)
+{
+	return NS_TO_JIFFIES(sysctl_sched_min_granularity);
+}
+
 /*
  * All the scheduling class methods:
  */
@@ -1180,6 +1185,7 @@ struct sched_class fair_sched_class __re
 	.set_curr_task          = set_curr_task_fair,
 	.task_tick		= task_tick_fair,
 	.task_new		= task_new_fair,
+	.default_timeslice	= default_timeslice_fair,
 };
 
 #ifdef CONFIG_SCHED_DEBUG
diff -r 3df82b0661ca kernel/sched_idletask.c
--- a/kernel/sched_idletask.c	Mon Sep 03 12:06:59 2007 +1000
+++ b/kernel/sched_idletask.c	Mon Sep 03 12:06:59 2007 +1000
@@ -59,6 +59,11 @@ static void task_tick_idle(struct rq *rq
 {
 }
 
+static unsigned int default_timeslice_idle(struct task_struct *p)
+{
+	return 0;
+}
+
 /*
  * Simple, special scheduling class for the per-CPU idle tasks:
  */
@@ -80,4 +85,5 @@ static struct sched_class idle_sched_cla
 
 	.task_tick		= task_tick_idle,
 	/* no .task_new for idle tasks */
+	.default_timeslice	= default_timeslice_idle,
 };
diff -r 3df82b0661ca kernel/sched_rt.c
--- a/kernel/sched_rt.c	Mon Sep 03 12:06:59 2007 +1000
+++ b/kernel/sched_rt.c	Mon Sep 03 12:06:59 2007 +1000
@@ -205,6 +205,34 @@ move_one_task_rt(struct rq *this_rq, int
 }
 #endif
 
+/*
+ * These are the 'tuning knobs' of the scheduler:
+ *
+ * Minimum timeslice is 5 msecs (or 1 jiffy, whichever is larger),
+ * default timeslice is 100 msecs, maximum timeslice is 800 msecs.
+ * Timeslices get refilled after they expire.
+ */
+#define MIN_TIMESLICE		max(5 * HZ / 1000, 1)
+#define DEF_TIMESLICE		(100 * HZ / 1000)
+
+#define SCALE_PRIO(x, prio) \
+	max(x * (MAX_PRIO - prio) / (MAX_USER_PRIO / 2), MIN_TIMESLICE)
+
+/*
+ * static_prio_timeslice() scales user-nice values [ -20 ... 0 ... 19 ]
+ * to time slice values: [800ms ... 100ms ... 5ms]
+ */
+static unsigned int static_prio_timeslice(int static_prio)
+{
+	if (static_prio == NICE_TO_PRIO(19))
+		return 1;
+
+	if (static_prio < NICE_TO_PRIO(0))
+		return SCALE_PRIO(DEF_TIMESLICE * 4, static_prio);
+	else
+		return SCALE_PRIO(DEF_TIMESLICE, static_prio);
+}
+
 static void task_tick_rt(struct rq *rq, struct task_struct *p)
 {
 	/*
@@ -229,6 +257,14 @@ static void task_tick_rt(struct rq *rq, 
 	}
 }
 
+static unsigned int default_timeslice_rt(struct task_struct *p)
+{
+	if (p->policy == SCHED_FIFO)
+		return 0;
+
+	return static_prio_timeslice(p->static_prio);
+}
+
 static struct sched_class rt_sched_class __read_mostly = {
 	.enqueue_task		= enqueue_task_rt,
 	.dequeue_task		= dequeue_task_rt,
@@ -245,4 +281,5 @@ static struct sched_class rt_sched_class
 #endif
 
 	.task_tick		= task_tick_rt,
+	.default_timeslice	= default_timeslice_rt,
 };

--------------000703010504000400010707--
