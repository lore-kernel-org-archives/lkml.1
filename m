Return-Path: <linux-kernel-owner+w=401wt.eu-S1763136AbXLRSVf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763136AbXLRSVf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 13:21:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762792AbXLRSUi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 13:20:38 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:57975 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756168AbXLRSUg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 13:20:36 -0500
Message-Id: <20071218174429.147070000@chello.nl>
References: <20071218174120.711901000@chello.nl>
User-Agent: quilt/0.45-1
Date: Tue, 18 Dec 2007 18:41:23 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>,
       Lennart Poettering <mzxreary@0pointer.de>,
       Michael Kerrisk <mtk.manpages@googlemail.com>,
       Ulrich Drepper <drepper@redhat.com>
Subject: [PATCH 3/3] sched: SCHED_FIFO/SCHED_RR watchdog timer
Content-Disposition: inline; filename=sched-watchdog.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce a new rlimit that allows the user to set a runtime timeout on
real-time tasks their slice. Once this limit is exceeded the task will receive
SIGXCPU.

So it measures runtime since the last sleep.

Input and ideas by Thomas Gleixner and Lennart Poettering.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Lennart Poettering <mzxreary@0pointer.de>
CC: Michael Kerrisk <mtk.manpages@googlemail.com>
CC: Ulrich Drepper <drepper@redhat.com>
---
 include/asm-generic/resource.h |    5 +++--
 include/linux/sched.h          |    1 +
 kernel/posix-cpu-timers.c      |   28 ++++++++++++++++++++++++++++
 kernel/sched_rt.c              |   30 ++++++++++++++++++++++++++++++
 4 files changed, 62 insertions(+), 2 deletions(-)

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
+#define RLIMIT_RTTIME		15	/* timeout for RT tasks in us */
+#define RLIM_NLIMITS		16
 
 /*
  * SuS says limits have to be unsigned.
@@ -86,6 +86,7 @@
 	[RLIMIT_MSGQUEUE]	= {   MQ_BYTES_MAX,   MQ_BYTES_MAX },	\
 	[RLIMIT_NICE]		= { 0, 0 },				\
 	[RLIMIT_RTPRIO]		= { 0, 0 },				\
+	[RLIMIT_RTTIME]		= {  RLIM_INFINITY,  RLIM_INFINITY },	\
 }
 
 #endif	/* __KERNEL__ */
Index: linux-2.6/kernel/sched_rt.c
===================================================================
--- linux-2.6.orig/kernel/sched_rt.c
+++ linux-2.6/kernel/sched_rt.c
@@ -116,6 +116,9 @@ static void enqueue_task_rt(struct rq *r
 	inc_cpu_load(rq, p->se.load.weight);
 
 	inc_rt_tasks(p, rq);
+
+	if (wakeup)
+		p->rt.timeout = 0;
 }
 
 /*
@@ -834,11 +837,38 @@ static void prio_changed_rt(struct rq *r
 	}
 }
 
+static void watchdog(struct rq *rq, struct task_struct *p)
+{
+	unsigned long soft, hard;
+
+	if (!p->signal)
+		return;
+
+	soft = p->signal->rlim[RLIMIT_RTTIME].rlim_cur;
+	hard = p->signal->rlim[RLIMIT_RTTIME].rlim_max;
+
+	if (soft != RLIM_INFINITY) {
+		unsigned long next;
+
+		p->rt.timeout++;
+		next = DIV_ROUND_UP(min(soft, hard), USEC_PER_SEC/HZ);
+		if (next > p->rt.timeout) {
+			u64 next_time = p->se.sum_exec_runtime;
+
+			next_time += next * (NSEC_PER_SEC/HZ);
+			if (p->it_sched_expires > next_time)
+				p->it_sched_expires = next_time;
+		} else
+			p->it_sched_expires = p->se.sum_exec_runtime;
+	}
+}
 
 static void task_tick_rt(struct rq *rq, struct task_struct *p)
 {
 	update_curr_rt(rq);
 
+	watchdog(rq, p);
+
 	/*
 	 * RR tasks need a special form of timeslice management.
 	 * FIFO tasks have no timeslices.
Index: linux-2.6/include/linux/sched.h
===================================================================
--- linux-2.6.orig/include/linux/sched.h
+++ linux-2.6/include/linux/sched.h
@@ -937,6 +937,7 @@ struct sched_entity {
 struct sched_rt_entity {
 	struct list_head run_list;
 	unsigned int time_slice;
+	unsigned long timeout;
 };
 
 struct task_struct {
Index: linux-2.6/kernel/posix-cpu-timers.c
===================================================================
--- linux-2.6.orig/kernel/posix-cpu-timers.c
+++ linux-2.6/kernel/posix-cpu-timers.c
@@ -967,6 +967,7 @@ static void check_thread_timers(struct t
 {
 	int maxfire;
 	struct list_head *timers = tsk->cpu_timers;
+	struct signal_struct *const sig = tsk->signal;
 
 	maxfire = 20;
 	tsk->it_prof_expires = cputime_zero;
@@ -1011,6 +1012,33 @@ static void check_thread_timers(struct t
 		t->firing = 1;
 		list_move_tail(&t->entry, firing);
 	}
+
+	/*
+	 * Check for the special case thread timers.
+	 */
+	if (sig->rlim[RLIMIT_RTTIME].rlim_cur != RLIM_INFINITY) {
+		unsigned long hard = sig->rlim[RLIMIT_RTTIME].rlim_max;
+		unsigned long *soft = &sig->rlim[RLIMIT_RTTIME].rlim_cur;
+
+		if (tsk->rt.timeout > DIV_ROUND_UP(hard, USEC_PER_SEC/HZ)) {
+			/*
+			 * At the hard limit, we just die.
+			 * No need to calculate anything else now.
+			 */
+			__group_send_sig_info(SIGKILL, SEND_SIG_PRIV, tsk);
+			return;
+		}
+		if (tsk->rt.timeout > DIV_ROUND_UP(*soft, USEC_PER_SEC/HZ)) {
+			/*
+			 * At the soft limit, send a SIGXCPU every second.
+			 */
+			if (sig->rlim[RLIMIT_RTTIME].rlim_cur
+			    < sig->rlim[RLIMIT_RTTIME].rlim_max)
+				sig->rlim[RLIMIT_RTTIME].rlim_cur += USEC_PER_SEC;
+
+			__group_send_sig_info(SIGXCPU, SEND_SIG_PRIV, tsk);
+		}
+	}
 }
 
 /*

--

