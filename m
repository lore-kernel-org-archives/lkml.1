Return-Path: <linux-kernel-owner+w=401wt.eu-S1753258AbZBQQjU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753258AbZBQQjU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 11:39:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750989AbZBQQjK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 11:39:10 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:57014 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751511AbZBQQjJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 11:39:09 -0500
Date: Tue, 17 Feb 2009 17:38:54 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [git pull] timer fix
Message-ID: <20090217163854.GA4252@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest timers-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git timers-fixes-for-linus

 Thanks,

	Ingo

------------------>
Peter Zijlstra (1):
      timers: more consistently use clock vs timer


 kernel/posix-cpu-timers.c |   60 ++++++++++++++++++++++----------------------
 1 files changed, 30 insertions(+), 30 deletions(-)

diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
index 2313a4c..e976e50 100644
--- a/kernel/posix-cpu-timers.c
+++ b/kernel/posix-cpu-timers.c
@@ -681,6 +681,33 @@ static void cpu_timer_fire(struct k_itimer *timer)
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
@@ -741,7 +768,7 @@ int posix_cpu_timer_set(struct k_itimer *timer, int flags,
 	if (CPUCLOCK_PERTHREAD(timer->it_clock)) {
 		cpu_clock_sample(timer->it_clock, p, &val);
 	} else {
-		cpu_clock_sample_group(timer->it_clock, p, &val);
+		cpu_timer_sample_group(timer->it_clock, p, &val);
 	}
 
 	if (old) {
@@ -889,7 +916,7 @@ void posix_cpu_timer_get(struct k_itimer *timer, struct itimerspec *itp)
 			read_unlock(&tasklist_lock);
 			goto dead;
 		} else {
-			cpu_clock_sample_group(timer->it_clock, p, &now);
+			cpu_timer_sample_group(timer->it_clock, p, &now);
 			clear_dead = (unlikely(p->exit_state) &&
 				      thread_group_empty(p));
 		}
@@ -1244,7 +1271,7 @@ void posix_cpu_timer_schedule(struct k_itimer *timer)
 			clear_dead_task(timer, now);
 			goto out_unlock;
 		}
-		cpu_clock_sample_group(timer->it_clock, p, &now);
+		cpu_timer_sample_group(timer->it_clock, p, &now);
 		bump_cpu_timer(timer, now);
 		/* Leave the tasklist_lock locked for the call below.  */
 	}
@@ -1409,33 +1436,6 @@ void run_posix_cpu_timers(struct task_struct *tsk)
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
