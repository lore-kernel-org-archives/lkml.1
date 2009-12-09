Return-Path: <linux-kernel-owner+w=401wt.eu-S1753308AbZLIJmg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753308AbZLIJmg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 04:42:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753276AbZLIJmd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 04:42:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:25498 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753196AbZLIJm2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 04:42:28 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>, Oleg Nesterov <oleg@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Balbir Singh <balbir@in.ibm.com>, linux-kernel@vger.kernel.org,
       Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [RFC PATCH 1/6] cpu-timers: simplify RLIMIT_CPU handling
Date: Wed,  9 Dec 2009 10:39:53 +0100
Message-Id: <1260351598-4203-2-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1260351598-4203-1-git-send-email-sgruszka@redhat.com>
References: <1260351598-4203-1-git-send-email-sgruszka@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Let always set expiration (prof_exp) cache when settings itimers,
POSIX 1.b timers and RLIMIT_CPU. Together with settings expiration
cache in fork, this allow to remove RLIMIT_CPU != inf check in
fastpath_timer_check() and do some other cleanups.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 kernel/posix-cpu-timers.c |   74 ++++++++++++++++-----------------------------
 1 files changed, 26 insertions(+), 48 deletions(-)

diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
index 438ff45..137d991 100644
--- a/kernel/posix-cpu-timers.c
+++ b/kernel/posix-cpu-timers.c
@@ -11,19 +11,17 @@
 #include <trace/events/timer.h>
 
 /*
- * Called after updating RLIMIT_CPU to set timer expiration if necessary.
+ * Called after updating RLIMIT_CPU to run cputimer and set expiration cache
+ * if necessary. Need siglock since cpu timers can work with cputime_expires
+ * as well.
  */
 void update_rlimit_cpu(unsigned long rlim_new)
 {
 	cputime_t cputime = secs_to_cputime(rlim_new);
-	struct signal_struct *const sig = current->signal;
 
-	if (cputime_eq(sig->it[CPUCLOCK_PROF].expires, cputime_zero) ||
-	    cputime_gt(sig->it[CPUCLOCK_PROF].expires, cputime)) {
-		spin_lock_irq(&current->sighand->siglock);
-		set_process_cpu_timer(current, CPUCLOCK_PROF, &cputime, NULL);
-		spin_unlock_irq(&current->sighand->siglock);
-	}
+	spin_lock_irq(&current->sighand->siglock);
+	set_process_cpu_timer(current, CPUCLOCK_PROF, &cputime, NULL);
+	spin_unlock_irq(&current->sighand->siglock);
 }
 
 static int check_clock(const clockid_t which_clock)
@@ -564,7 +562,6 @@ static void arm_timer(struct k_itimer *timer, union cpu_time_count now)
 	struct list_head *head, *listpos;
 	struct cpu_timer_list *const nt = &timer->it.cpu;
 	struct cpu_timer_list *next;
-	unsigned long i;
 
 	head = (CPUCLOCK_PERTHREAD(timer->it_clock) ?
 		p->cpu_timers : p->signal->cpu_timers);
@@ -630,20 +627,11 @@ static void arm_timer(struct k_itimer *timer, union cpu_time_count now)
 			default:
 				BUG();
 			case CPUCLOCK_VIRT:
-				if (expires_le(sig->it[CPUCLOCK_VIRT].expires,
-					       exp->cpu))
-					break;
-				sig->cputime_expires.virt_exp = exp->cpu;
-				break;
+				if (expires_gt(sig->cputime_expires.virt_exp, exp->cpu))
+					sig->cputime_expires.virt_exp = exp->cpu;
 			case CPUCLOCK_PROF:
-				if (expires_le(sig->it[CPUCLOCK_PROF].expires,
-					       exp->cpu))
-					break;
-				i = sig->rlim[RLIMIT_CPU].rlim_cur;
-				if (i != RLIM_INFINITY &&
-				    i <= cputime_to_secs(exp->cpu))
-					break;
-				sig->cputime_expires.prof_exp = exp->cpu;
+				if (expires_gt(sig->cputime_expires.prof_exp, exp->cpu))
+					sig->cputime_expires.prof_exp = exp->cpu;
 				break;
 			case CPUCLOCK_SCHED:
 				sig->cputime_expires.sched_exp = exp->sched;
@@ -1382,7 +1370,7 @@ static inline int fastpath_timer_check(struct task_struct *tsk)
 			return 1;
 	}
 
-	return sig->rlim[RLIMIT_CPU].rlim_cur != RLIM_INFINITY;
+	return 0;
 }
 
 /*
@@ -1448,21 +1436,23 @@ void run_posix_cpu_timers(struct task_struct *tsk)
 }
 
 /*
- * Set one of the process-wide special case CPU timers.
+ * Set one of the process-wide special case CPU timers or RLIMIT_CPU.
  * The tsk->sighand->siglock must be held by the caller.
- * The *newval argument is relative and we update it to be absolute, *oldval
- * is absolute and we update it to be relative.
  */
 void set_process_cpu_timer(struct task_struct *tsk, unsigned int clock_idx,
 			   cputime_t *newval, cputime_t *oldval)
 {
 	union cpu_time_count now;
-	struct list_head *head;
 
 	BUG_ON(clock_idx == CPUCLOCK_SCHED);
 	cpu_timer_sample_group(clock_idx, tsk, &now);
 
 	if (oldval) {
+		/*
+		 * We are setting itimer. The *newval argument is relative
+		 * and we update it to be absolute, *oldval is absolute and
+		 * we update it to be relative.
+		 */
 		if (!cputime_eq(*oldval, cputime_zero)) {
 			if (cputime_le(*oldval, now.cpu)) {
 				/* Just about to fire. */
@@ -1475,33 +1465,21 @@ void set_process_cpu_timer(struct task_struct *tsk, unsigned int clock_idx,
 		if (cputime_eq(*newval, cputime_zero))
 			return;
 		*newval = cputime_add(*newval, now.cpu);
-
-		/*
-		 * If the RLIMIT_CPU timer will expire before the
-		 * ITIMER_PROF timer, we have nothing else to do.
-		 */
-		if (tsk->signal->rlim[RLIMIT_CPU].rlim_cur
-		    < cputime_to_secs(*newval))
-			return;
 	}
 
 	/*
-	 * Check whether there are any process timers already set to fire
-	 * before this one.  If so, we don't have anything more to do.
+	 * Update expiration cache if we are the earliest timer
+	 * or RLIMIT_CPU limits before any other timer expire.
 	 */
-	head = &tsk->signal->cpu_timers[clock_idx];
-	if (list_empty(head) ||
-	    cputime_ge(list_first_entry(head,
-				  struct cpu_timer_list, entry)->expires.cpu,
-		       *newval)) {
-		switch (clock_idx) {
-		case CPUCLOCK_PROF:
+	switch (clock_idx) {
+	case CPUCLOCK_PROF:
+		if (expires_gt(tsk->signal->cputime_expires.prof_exp, *newval))
 			tsk->signal->cputime_expires.prof_exp = *newval;
-			break;
-		case CPUCLOCK_VIRT:
+		break;
+	case CPUCLOCK_VIRT:
+		if (expires_gt(tsk->signal->cputime_expires.virt_exp, *newval))
 			tsk->signal->cputime_expires.virt_exp = *newval;
-			break;
-		}
+		break;
 	}
 }
 
-- 
1.6.2.5

