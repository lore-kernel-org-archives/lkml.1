Return-Path: <linux-kernel-owner+w=401wt.eu-S1758320AbZBLOQ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758320AbZBLOQ7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 09:16:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755183AbZBLOQu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 09:16:50 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:52920 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752896AbZBLOQu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 09:16:50 -0500
Subject: [PATCH] timers: more consistently use clock vs timer
From: Peter Zijlstra <peterz@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: L-K <linux-kernel@vger.kernel.org>, Oleg Nesterov <oleg@redhat.com>
Content-Type: text/plain
Date: Thu, 12 Feb 2009 15:16:31 +0100
Message-Id: <1234448191.10603.9.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.90 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: timers: more consistently use clock vs timer
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Thu Feb 12 15:00:52 CET 2009

While reviewing the manpages, I noticed I'd missed some clock vs timer sites.

Make sure that all timer functions call cpu_timer_sample_group() and not
cpu_clock_sample_group(). This ensures that we enable the process wide timer
in time, and therefore pay the O(n) thread group cost from the syscall.

Not doing it here, will result in the first jiffy tick after setting the timer
doing this, resulting in a very expensive tick (but only once) and a delay in
actually starting the timer.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/posix-cpu-timers.c |   60 +++++++++++++++++++++++-----------------------
 1 file changed, 30 insertions(+), 30 deletions(-)

Index: linux-2.6/kernel/posix-cpu-timers.c
===================================================================
--- linux-2.6.orig/kernel/posix-cpu-timers.c
+++ linux-2.6/kernel/posix-cpu-timers.c
@@ -681,6 +681,33 @@ static void cpu_timer_fire(struct k_itim
 }
 
 /*
+ * Sample a process (thread group) timer for the given group_leader task.
+ * Must be called with tasklist_lock held for reading.
+ */
+static int cpu_timer_sample_group(const clockid_t which_clock,
+				  struct task_struct *p,
+				  union cpu_time_count *cpu)
+{
+	struct task_cputime cputime;
+
+	thread_group_cputimer(p, &cputime);
+	switch (CPUCLOCK_WHICH(which_clock)) {
+	default:
+		return -EINVAL;
+	case CPUCLOCK_PROF:
+		cpu->cpu = cputime_add(cputime.utime, cputime.stime);
+		break;
+	case CPUCLOCK_VIRT:
+		cpu->cpu = cputime.utime;
+		break;
+	case CPUCLOCK_SCHED:
+		cpu->sched = cputime.sum_exec_runtime + task_delta_exec(p);
+		break;
+	}
+	return 0;
+}
+
+/*
  * Guts of sys_timer_settime for CPU timers.
  * This is called with the timer locked and interrupts disabled.
  * If we return TIMER_RETRY, it's necessary to release the timer's lock
@@ -741,7 +768,7 @@ int posix_cpu_timer_set(struct k_itimer 
 	if (CPUCLOCK_PERTHREAD(timer->it_clock)) {
 		cpu_clock_sample(timer->it_clock, p, &val);
 	} else {
-		cpu_clock_sample_group(timer->it_clock, p, &val);
+		cpu_timer_sample_group(timer->it_clock, p, &val);
 	}
 
 	if (old) {
@@ -889,7 +916,7 @@ void posix_cpu_timer_get(struct k_itimer
 			read_unlock(&tasklist_lock);
 			goto dead;
 		} else {
-			cpu_clock_sample_group(timer->it_clock, p, &now);
+			cpu_timer_sample_group(timer->it_clock, p, &now);
 			clear_dead = (unlikely(p->exit_state) &&
 				      thread_group_empty(p));
 		}
@@ -1244,7 +1271,7 @@ void posix_cpu_timer_schedule(struct k_i
 			clear_dead_task(timer, now);
 			goto out_unlock;
 		}
-		cpu_clock_sample_group(timer->it_clock, p, &now);
+		cpu_timer_sample_group(timer->it_clock, p, &now);
 		bump_cpu_timer(timer, now);
 		/* Leave the tasklist_lock locked for the call below.  */
 	}
@@ -1409,33 +1436,6 @@ void run_posix_cpu_timers(struct task_st
 }
 
 /*
- * Sample a process (thread group) timer for the given group_leader task.
- * Must be called with tasklist_lock held for reading.
- */
-static int cpu_timer_sample_group(const clockid_t which_clock,
-				  struct task_struct *p,
-				  union cpu_time_count *cpu)
-{
-	struct task_cputime cputime;
-
-	thread_group_cputimer(p, &cputime);
-	switch (CPUCLOCK_WHICH(which_clock)) {
-	default:
-		return -EINVAL;
-	case CPUCLOCK_PROF:
-		cpu->cpu = cputime_add(cputime.utime, cputime.stime);
-		break;
-	case CPUCLOCK_VIRT:
-		cpu->cpu = cputime.utime;
-		break;
-	case CPUCLOCK_SCHED:
-		cpu->sched = cputime.sum_exec_runtime + task_delta_exec(p);
-		break;
-	}
-	return 0;
-}
-
-/*
  * Set one of the process-wide special case CPU timers.
  * The tsk->sighand->siglock must be held by the caller.
  * The *newval argument is relative and we update it to be absolute, *oldval


