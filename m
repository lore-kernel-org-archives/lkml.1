Return-Path: <linux-kernel-owner+w=401wt.eu-S1752140Ab0ATMhr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752140Ab0ATMhr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 07:37:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751955Ab0ATMhj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 07:37:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:17760 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751922Ab0ATMhh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 07:37:37 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Oleg Nesterov <oleg@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Balbir Singh <balbir@in.ibm.com>, linux-kernel@vger.kernel.org,
       Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 6/6 -mm] cpu-timers: optimize run_posix_cpu_timers()
Date: Wed, 20 Jan 2010 13:34:28 +0100
Message-Id: <1263990868-8119-7-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1263990868-8119-6-git-send-email-sgruszka@redhat.com>
References: <1263990868-8119-1-git-send-email-sgruszka@redhat.com>
 <1263990868-8119-2-git-send-email-sgruszka@redhat.com>
 <1263990868-8119-3-git-send-email-sgruszka@redhat.com>
 <1263990868-8119-4-git-send-email-sgruszka@redhat.com>
 <1263990868-8119-5-git-send-email-sgruszka@redhat.com>
 <1263990868-8119-6-git-send-email-sgruszka@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We can optimize and simplify things taking into account signal->cputimer
is always running when we have configured any process wide cpu timer.

In check_process_timers(), we don't have to check if new updated value
of signal->cputime_expires is smaller, since we maintain new first
expiration time ({prof,virt,sched}_expires) in code flow and all other
writes to expiration cache are protected by sighand->siglock .

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 kernel/posix-cpu-timers.c |   80 ++++++++++++++++----------------------------
 1 files changed, 29 insertions(+), 51 deletions(-)

diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
index 67c877e..ffba8f4 100644
--- a/kernel/posix-cpu-timers.c
+++ b/kernel/posix-cpu-timers.c
@@ -1000,16 +1000,9 @@ static void stop_process_timers(struct signal_struct *sig)
 	struct thread_group_cputimer *cputimer = &sig->cputimer;
 	unsigned long flags;
 
-	if (!cputimer->running)
-		return;
-
 	spin_lock_irqsave(&cputimer->lock, flags);
 	cputimer->running = 0;
 	spin_unlock_irqrestore(&cputimer->lock, flags);
-
-	sig->cputime_expires.prof_exp = cputime_zero;
-	sig->cputime_expires.virt_exp = cputime_zero;
-	sig->cputime_expires.sched_exp = 0;
 }
 
 static u32 onecputick;
@@ -1046,6 +1039,23 @@ static void check_cpu_itimer(struct task_struct *tsk, struct cpu_itimer *it,
 	}
 }
 
+/**
+ * task_cputime_zero - Check a task_cputime struct for all zero fields.
+ *
+ * @cputime:	The struct to compare.
+ *
+ * Checks @cputime to see if all fields are zero.  Returns true if all fields
+ * are zero, false if any field is nonzero.
+ */
+static inline int task_cputime_zero(const struct task_cputime *cputime)
+{
+	if (cputime_eq(cputime->utime, cputime_zero) &&
+	    cputime_eq(cputime->stime, cputime_zero) &&
+	    cputime->sum_exec_runtime == 0)
+		return 1;
+	return 0;
+}
+
 /*
  * Check for any per-thread CPU timers that have fired and move them
  * off the tsk->*_timers list onto the firing list.  Per-thread timers
@@ -1062,19 +1072,6 @@ static void check_process_timers(struct task_struct *tsk,
 	struct task_cputime cputime;
 
 	/*
-	 * Don't sample the current process CPU clocks if there are no timers.
-	 */
-	if (list_empty(&timers[CPUCLOCK_PROF]) &&
-	    cputime_eq(sig->it[CPUCLOCK_PROF].expires, cputime_zero) &&
-	    sig->rlim[RLIMIT_CPU].rlim_cur == RLIM_INFINITY &&
-	    list_empty(&timers[CPUCLOCK_VIRT]) &&
-	    cputime_eq(sig->it[CPUCLOCK_VIRT].expires, cputime_zero) &&
-	    list_empty(&timers[CPUCLOCK_SCHED])) {
-		stop_process_timers(sig);
-		return;
-	}
-
-	/*
 	 * Collect the current process totals.
 	 */
 	thread_group_cputimer(tsk, &cputime);
@@ -1161,18 +1158,11 @@ static void check_process_timers(struct task_struct *tsk,
 		}
 	}
 
-	if (!cputime_eq(prof_expires, cputime_zero) &&
-	    (cputime_eq(sig->cputime_expires.prof_exp, cputime_zero) ||
-	     cputime_gt(sig->cputime_expires.prof_exp, prof_expires)))
-		sig->cputime_expires.prof_exp = prof_expires;
-	if (!cputime_eq(virt_expires, cputime_zero) &&
-	    (cputime_eq(sig->cputime_expires.virt_exp, cputime_zero) ||
-	     cputime_gt(sig->cputime_expires.virt_exp, virt_expires)))
-		sig->cputime_expires.virt_exp = virt_expires;
-	if (sched_expires != 0 &&
-	    (sig->cputime_expires.sched_exp == 0 ||
-	     sig->cputime_expires.sched_exp > sched_expires))
-		sig->cputime_expires.sched_exp = sched_expires;
+	sig->cputime_expires.prof_exp = prof_expires;
+	sig->cputime_expires.virt_exp = virt_expires;
+	sig->cputime_expires.sched_exp = sched_expires;
+	if (task_cputime_zero(&sig->cputime_expires))
+		stop_process_timers(sig);
 }
 
 /*
@@ -1245,23 +1235,6 @@ out:
 }
 
 /**
- * task_cputime_zero - Check a task_cputime struct for all zero fields.
- *
- * @cputime:	The struct to compare.
- *
- * Checks @cputime to see if all fields are zero.  Returns true if all fields
- * are zero, false if any field is nonzero.
- */
-static inline int task_cputime_zero(const struct task_cputime *cputime)
-{
-	if (cputime_eq(cputime->utime, cputime_zero) &&
-	    cputime_eq(cputime->stime, cputime_zero) &&
-	    cputime->sum_exec_runtime == 0)
-		return 1;
-	return 0;
-}
-
-/**
  * task_cputime_expired - Compare two task_cputime entities.
  *
  * @sample:	The task_cputime structure to be checked for expiration.
@@ -1317,7 +1290,7 @@ static inline int fastpath_timer_check(struct task_struct *tsk)
 	}
 
 	sig = tsk->signal;
-	if (!task_cputime_zero(&sig->cputime_expires)) {
+	if (sig->cputimer.running) {
 		struct task_cputime group_sample;
 
 		thread_group_cputimer(tsk, &group_sample);
@@ -1354,7 +1327,12 @@ void run_posix_cpu_timers(struct task_struct *tsk)
 	 * put them on the firing list.
 	 */
 	check_thread_timers(tsk, &firing);
-	check_process_timers(tsk, &firing);
+	/*
+	 * If there are any active process wide timers (POSIX 1.b, itimers,
+	 * RLIMIT_CPU) cputimer must be running.
+	 */
+	if (tsk->signal->cputimer.running)
+		check_process_timers(tsk, &firing);
 
 	/*
 	 * We must release these locks before taking any timer's lock.
-- 
1.6.2.5

