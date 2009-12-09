Return-Path: <linux-kernel-owner+w=401wt.eu-S1753320AbZLIJnc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753320AbZLIJnc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 04:43:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753086AbZLIJna
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 04:43:30 -0500
Received: from mx1.redhat.com ([209.132.183.28]:16610 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753282AbZLIJnC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 04:43:02 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>, Oleg Nesterov <oleg@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Balbir Singh <balbir@in.ibm.com>, linux-kernel@vger.kernel.org,
       Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [RFC PATCH 6/6] cpu-timers: optimize run_posix_cpu_timers()
Date: Wed,  9 Dec 2009 10:39:58 +0100
Message-Id: <1260351598-4203-7-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1260351598-4203-6-git-send-email-sgruszka@redhat.com>
References: <1260351598-4203-1-git-send-email-sgruszka@redhat.com>
 <1260351598-4203-2-git-send-email-sgruszka@redhat.com>
 <1260351598-4203-3-git-send-email-sgruszka@redhat.com>
 <1260351598-4203-4-git-send-email-sgruszka@redhat.com>
 <1260351598-4203-5-git-send-email-sgruszka@redhat.com>
 <1260351598-4203-6-git-send-email-sgruszka@redhat.com>
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
 kernel/posix-cpu-timers.c |   81 ++++++++++++++++++---------------------------
 1 files changed, 32 insertions(+), 49 deletions(-)

diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
index 68d4045..69a9c27 100644
--- a/kernel/posix-cpu-timers.c
+++ b/kernel/posix-cpu-timers.c
@@ -995,14 +995,11 @@ static void check_thread_timers(struct task_struct *tsk,
 	}
 }
 
-static void stop_process_timers(struct task_struct *tsk)
+static void stop_process_timers(struct signal_struct *sig)
 {
-	struct thread_group_cputimer *cputimer = &tsk->signal->cputimer;
+	struct thread_group_cputimer *cputimer = &sig->cputimer;
 	unsigned long flags;
 
-	if (!cputimer->running)
-		return;
-
 	spin_lock_irqsave(&cputimer->lock, flags);
 	cputimer->running = 0;
 	spin_unlock_irqrestore(&cputimer->lock, flags);
@@ -1042,6 +1039,23 @@ static void check_cpu_itimer(struct task_struct *tsk, struct cpu_itimer *it,
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
@@ -1058,19 +1072,6 @@ static void check_process_timers(struct task_struct *tsk,
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
-		stop_process_timers(tsk);
-		return;
-	}
-
-	/*
 	 * Collect the current process totals.
 	 */
 	thread_group_cputimer(tsk, &cputime);
@@ -1157,18 +1158,12 @@ static void check_process_timers(struct task_struct *tsk,
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
+
+	if (task_cputime_zero(&sig->cputime_expires))
+		stop_process_timers(sig);
 }
 
 /*
@@ -1241,23 +1236,6 @@ out:
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
@@ -1313,7 +1291,7 @@ static inline int fastpath_timer_check(struct task_struct *tsk)
 	}
 
 	sig = tsk->signal;
-	if (!task_cputime_zero(&sig->cputime_expires)) {
+	if (sig->cputimer.running) {
 		struct task_cputime group_sample;
 
 		thread_group_cputimer(tsk, &group_sample);
@@ -1350,7 +1328,12 @@ void run_posix_cpu_timers(struct task_struct *tsk)
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

