Return-Path: <linux-kernel-owner+w=401wt.eu-S1753255AbZLIJmc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753255AbZLIJmc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 04:42:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753228AbZLIJmb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 04:42:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:23403 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752877AbZLIJm0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 04:42:26 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>, Oleg Nesterov <oleg@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Balbir Singh <balbir@in.ibm.com>, linux-kernel@vger.kernel.org,
       Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [RFC PATCH 2/6] cpu-timers: cleanup arm_timer()
Date: Wed,  9 Dec 2009 10:39:54 +0100
Message-Id: <1260351598-4203-3-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1260351598-4203-2-git-send-email-sgruszka@redhat.com>
References: <1260351598-4203-1-git-send-email-sgruszka@redhat.com>
 <1260351598-4203-2-git-send-email-sgruszka@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Updating expiration cache is messed in arm_timer(), clean it up.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 kernel/posix-cpu-timers.c |  104 +++++++++++++++------------------------------
 1 files changed, 35 insertions(+), 69 deletions(-)

diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
index 137d991..84589e9 100644
--- a/kernel/posix-cpu-timers.c
+++ b/kernel/posix-cpu-timers.c
@@ -546,97 +546,63 @@ static inline int expires_gt(cputime_t expires, cputime_t new_exp)
 	       cputime_gt(expires, new_exp);
 }
 
-static inline int expires_le(cputime_t expires, cputime_t new_exp)
-{
-	return !cputime_eq(expires, cputime_zero) &&
-	       cputime_le(expires, new_exp);
-}
 /*
  * Insert the timer on the appropriate list before any timers that
  * expire later.  This must be called with the tasklist_lock held
  * for reading, and interrupts disabled.
  */
-static void arm_timer(struct k_itimer *timer, union cpu_time_count now)
+static void arm_timer(struct k_itimer *timer)
 {
 	struct task_struct *p = timer->it.cpu.task;
 	struct list_head *head, *listpos;
+	struct task_cputime *cputime_expires;
 	struct cpu_timer_list *const nt = &timer->it.cpu;
 	struct cpu_timer_list *next;
 
-	head = (CPUCLOCK_PERTHREAD(timer->it_clock) ?
-		p->cpu_timers : p->signal->cpu_timers);
+	if (CPUCLOCK_PERTHREAD(timer->it_clock)) {
+		head = p->cpu_timers;
+		cputime_expires = &p->cputime_expires;
+	} else {
+		head = p->signal->cpu_timers;
+		cputime_expires = &p->signal->cputime_expires;
+	}
 	head += CPUCLOCK_WHICH(timer->it_clock);
 
 	BUG_ON(!irqs_disabled());
 	spin_lock(&p->sighand->siglock);
 
 	listpos = head;
-	if (CPUCLOCK_WHICH(timer->it_clock) == CPUCLOCK_SCHED) {
-		list_for_each_entry(next, head, entry) {
-			if (next->expires.sched > nt->expires.sched)
-				break;
-			listpos = &next->entry;
-		}
-	} else {
-		list_for_each_entry(next, head, entry) {
-			if (cputime_gt(next->expires.cpu, nt->expires.cpu))
-				break;
-			listpos = &next->entry;
-		}
+	list_for_each_entry(next, head, entry) {
+		if (cpu_time_before(timer->it_clock, nt->expires, next->expires))
+			break;
+		listpos = &next->entry;
 	}
 	list_add(&nt->entry, listpos);
 
 	if (listpos == head) {
+		union cpu_time_count *exp = &nt->expires;
+
 		/*
-		 * We are the new earliest-expiring timer.
-		 * If we are a thread timer, there can always
-		 * be a process timer telling us to stop earlier.
+		 * We are the new earliest-expiring POSIX 1.b timer, hence
+		 * need to update expiration cache. Take into account that
+		 * for process timers we share expiration cache with itimers
+		 * and RLIMIT_CPU and for thread timers with RLIMIT_RTTIME.
 		 */
 
-		if (CPUCLOCK_PERTHREAD(timer->it_clock)) {
-			union cpu_time_count *exp = &nt->expires;
-
-			switch (CPUCLOCK_WHICH(timer->it_clock)) {
-			default:
-				BUG();
-			case CPUCLOCK_PROF:
-				if (expires_gt(p->cputime_expires.prof_exp,
-					       exp->cpu))
-					p->cputime_expires.prof_exp = exp->cpu;
-				break;
-			case CPUCLOCK_VIRT:
-				if (expires_gt(p->cputime_expires.virt_exp,
-					       exp->cpu))
-					p->cputime_expires.virt_exp = exp->cpu;
-				break;
-			case CPUCLOCK_SCHED:
-				if (p->cputime_expires.sched_exp == 0 ||
-				    p->cputime_expires.sched_exp > exp->sched)
-					p->cputime_expires.sched_exp =
-								exp->sched;
-				break;
-			}
-		} else {
-			struct signal_struct *const sig = p->signal;
-			union cpu_time_count *exp = &timer->it.cpu.expires;
-
-			/*
-			 * For a process timer, set the cached expiration time.
-			 */
-			switch (CPUCLOCK_WHICH(timer->it_clock)) {
-			default:
-				BUG();
-			case CPUCLOCK_VIRT:
-				if (expires_gt(sig->cputime_expires.virt_exp, exp->cpu))
-					sig->cputime_expires.virt_exp = exp->cpu;
-			case CPUCLOCK_PROF:
-				if (expires_gt(sig->cputime_expires.prof_exp, exp->cpu))
-					sig->cputime_expires.prof_exp = exp->cpu;
-				break;
-			case CPUCLOCK_SCHED:
-				sig->cputime_expires.sched_exp = exp->sched;
-				break;
-			}
+		switch (CPUCLOCK_WHICH(timer->it_clock)) {
+		case CPUCLOCK_PROF:
+			if (expires_gt(cputime_expires->prof_exp, exp->cpu))
+				cputime_expires->prof_exp = exp->cpu;
+			break;
+		case CPUCLOCK_VIRT:
+			if (expires_gt(cputime_expires->virt_exp, exp->cpu))
+				cputime_expires->virt_exp = exp->cpu;
+			break;
+		case CPUCLOCK_SCHED:
+			if (cputime_expires->sched_exp == 0 ||
+			    cputime_expires->sched_exp > exp->sched)
+				cputime_expires->sched_exp = exp->sched;
+			break;
 		}
 	}
 
@@ -818,7 +784,7 @@ int posix_cpu_timer_set(struct k_itimer *timer, int flags,
 	if (new_expires.sched != 0 &&
 	    (timer->it_sigev_notify & ~SIGEV_THREAD_ID) != SIGEV_NONE &&
 	    cpu_time_before(timer->it_clock, val, new_expires)) {
-		arm_timer(timer, val);
+		arm_timer(timer);
 	}
 
 	read_unlock(&tasklist_lock);
@@ -1278,7 +1244,7 @@ void posix_cpu_timer_schedule(struct k_itimer *timer)
 	/*
 	 * Now re-arm for the new expiry time.
 	 */
-	arm_timer(timer, now);
+	arm_timer(timer);
 
 out_unlock:
 	read_unlock(&tasklist_lock);
-- 
1.6.2.5

