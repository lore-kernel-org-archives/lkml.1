Return-Path: <linux-kernel-owner+w=401wt.eu-S932236Ab0AFPZW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932236Ab0AFPZW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 10:25:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932164Ab0AFPZF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 10:25:05 -0500
Received: from smtp.mujha-vel.cz ([81.30.225.246]:40229 "EHLO
	smtp.mujha-vel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754622Ab0AFPY6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 10:24:58 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: jirislaby@gmail.com
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] core: use helpers for rlimits
Date: Wed,  6 Jan 2010 16:24:37 +0100
Message-Id: <1262791479-26594-9-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.6.5.7
In-Reply-To: <1262791479-26594-1-git-send-email-jslaby@suse.cz>
References: <1262791479-26594-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make sure compiler won't do weird things with limits. E.g. fetching
them twice may return 2 different values after writable limits are
implemented.

I.e. either use rlimit helpers added in
3e10e716abf3c71bdb5d86b8f507f9e72236c9cd
or ACCESS_ONCE if not applicable.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 kernel/fork.c             |   10 ++++++----
 kernel/perf_event.c       |    2 +-
 kernel/posix-cpu-timers.c |   16 +++++++++-------
 kernel/sched.c            |    4 ++--
 kernel/sched_rt.c         |    5 +++--
 kernel/signal.c           |    2 +-
 kernel/sys.c              |    3 +--
 7 files changed, 23 insertions(+), 19 deletions(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index 5b2959b..85f9f1c 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -824,6 +824,8 @@ void __cleanup_sighand(struct sighand_struct *sighand)
  */
 static void posix_cpu_timers_init_group(struct signal_struct *sig)
 {
+	unsigned long cpu_limit;
+
 	/* Thread group counters. */
 	thread_group_cputime_init(sig);
 
@@ -838,9 +840,9 @@ static void posix_cpu_timers_init_group(struct signal_struct *sig)
 	sig->cputime_expires.virt_exp = cputime_zero;
 	sig->cputime_expires.sched_exp = 0;
 
-	if (sig->rlim[RLIMIT_CPU].rlim_cur != RLIM_INFINITY) {
-		sig->cputime_expires.prof_exp =
-			secs_to_cputime(sig->rlim[RLIMIT_CPU].rlim_cur);
+	cpu_limit = ACCESS_ONCE(sig->rlim[RLIMIT_CPU].rlim_cur);
+	if (cpu_limit != RLIM_INFINITY) {
+		sig->cputime_expires.prof_exp = secs_to_cputime(cpu_limit);
 		sig->cputimer.running = 1;
 	}
 
@@ -1033,7 +1035,7 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 #endif
 	retval = -EAGAIN;
 	if (atomic_read(&p->real_cred->user->processes) >=
-			p->signal->rlim[RLIMIT_NPROC].rlim_cur) {
+			task_rlimit(p, RLIMIT_NPROC)) {
 		if (!capable(CAP_SYS_ADMIN) && !capable(CAP_SYS_RESOURCE) &&
 		    p->real_cred->user != INIT_USER)
 			goto bad_fork_free;
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 603c0d8..8ee8ff3 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -2462,7 +2462,7 @@ static int perf_mmap(struct file *file, struct vm_area_struct *vma)
 	if (user_locked > user_lock_limit)
 		extra = user_locked - user_lock_limit;
 
-	lock_limit = current->signal->rlim[RLIMIT_MEMLOCK].rlim_cur;
+	lock_limit = rlimit(RLIMIT_MEMLOCK);
 	lock_limit >>= PAGE_SHIFT;
 	locked = vma->vm_mm->locked_vm + extra;
 
diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
index de7bdb3..2cb3f30 100644
--- a/kernel/posix-cpu-timers.c
+++ b/kernel/posix-cpu-timers.c
@@ -639,7 +639,7 @@ static void arm_timer(struct k_itimer *timer, union cpu_time_count now)
 				if (expires_le(sig->it[CPUCLOCK_PROF].expires,
 					       exp->cpu))
 					break;
-				i = sig->rlim[RLIMIT_CPU].rlim_cur;
+				i = ACCESS_ONCE(sig->rlim[RLIMIT_CPU].rlim_cur);
 				if (i != RLIM_INFINITY &&
 				    i <= cputime_to_secs(exp->cpu))
 					break;
@@ -1031,9 +1031,10 @@ static void check_thread_timers(struct task_struct *tsk,
 	/*
 	 * Check for the special case thread timers.
 	 */
-	soft = sig->rlim[RLIMIT_RTTIME].rlim_cur;
+	soft = ACCESS_ONCE(sig->rlim[RLIMIT_RTTIME].rlim_cur);
 	if (soft != RLIM_INFINITY) {
-		unsigned long hard = sig->rlim[RLIMIT_RTTIME].rlim_max;
+		unsigned long hard = ACCESS_ONCE(sig->rlim[RLIMIT_RTTIME].
+				rlim_max);
 
 		if (hard != RLIM_INFINITY &&
 		    tsk->rt.timeout > DIV_ROUND_UP(hard, USEC_PER_SEC/HZ)) {
@@ -1121,7 +1122,7 @@ static void check_process_timers(struct task_struct *tsk,
 	unsigned long long sum_sched_runtime, sched_expires;
 	struct list_head *timers = sig->cpu_timers;
 	struct task_cputime cputime;
-	unsigned long cpu_cur_lim = sig->rlim[RLIMIT_CPU].rlim_cur;
+	unsigned long cpu_cur_lim = ACCESS_ONCE(sig->rlim[RLIMIT_CPU].rlim_cur);
 
 	/*
 	 * Don't sample the current process CPU clocks if there are no timers.
@@ -1197,7 +1198,8 @@ static void check_process_timers(struct task_struct *tsk,
 
 	if (cpu_cur_lim != RLIM_INFINITY) {
 		unsigned long psecs = cputime_to_secs(ptime);
-		unsigned long hard = sig->rlim[RLIMIT_CPU].rlim_max;
+		unsigned long hard =
+			ACCESS_ONCE(sig->rlim[RLIMIT_CPU].rlim_max);
 		cputime_t x;
 		if (psecs >= hard) {
 			/*
@@ -1384,7 +1386,7 @@ static inline int fastpath_timer_check(struct task_struct *tsk)
 			return 1;
 	}
 
-	return sig->rlim[RLIMIT_CPU].rlim_cur != RLIM_INFINITY;
+	return ACCESS_ONCE(sig->rlim[RLIMIT_CPU].rlim_cur) != RLIM_INFINITY;
 }
 
 /*
@@ -1482,7 +1484,7 @@ void set_process_cpu_timer(struct task_struct *tsk, unsigned int clock_idx,
 		 * If the RLIMIT_CPU timer will expire before the
 		 * ITIMER_PROF timer, we have nothing else to do.
 		 */
-		if (tsk->signal->rlim[RLIMIT_CPU].rlim_cur
+		if (task_rlimit(tsk, RLIMIT_CPU)
 		    < cputime_to_secs(*newval))
 			return;
 	}
diff --git a/kernel/sched.c b/kernel/sched.c
index c535cc4..16bad24 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -6132,7 +6132,7 @@ int can_nice(const struct task_struct *p, const int nice)
 	/* convert nice value [19,-20] to rlimit style value [1,40] */
 	int nice_rlim = 20 - nice;
 
-	return (nice_rlim <= p->signal->rlim[RLIMIT_NICE].rlim_cur ||
+	return (nice_rlim <= task_rlimit(p, RLIMIT_NICE) ||
 		capable(CAP_SYS_NICE));
 }
 
@@ -6309,7 +6309,7 @@ recheck:
 
 			if (!lock_task_sighand(p, &flags))
 				return -ESRCH;
-			rlim_rtprio = p->signal->rlim[RLIMIT_RTPRIO].rlim_cur;
+			rlim_rtprio = task_rlimit(p, RLIMIT_RTPRIO);
 			unlock_task_sighand(p, &flags);
 
 			/* can't set/change the rt policy */
diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index f48328a..552c71e 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -1670,8 +1670,9 @@ static void watchdog(struct rq *rq, struct task_struct *p)
 	if (!p->signal)
 		return;
 
-	soft = p->signal->rlim[RLIMIT_RTTIME].rlim_cur;
-	hard = p->signal->rlim[RLIMIT_RTTIME].rlim_max;
+	/* max may change after cur was read, this will be fixed next tick */
+	soft = task_rlimit(p, RLIMIT_RTTIME);
+	hard = task_rlimit_max(p, RLIMIT_RTTIME);
 
 	if (soft != RLIM_INFINITY) {
 		unsigned long next;
diff --git a/kernel/signal.c b/kernel/signal.c
index d09692b..3fa06ff 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -228,7 +228,7 @@ __sigqueue_alloc(int sig, struct task_struct *t, gfp_t flags, int override_rlimi
 
 	if (override_rlimit ||
 	    atomic_read(&user->sigpending) <=
-			t->signal->rlim[RLIMIT_SIGPENDING].rlim_cur) {
+			task_rlimit(t, RLIMIT_SIGPENDING)) {
 		q = kmem_cache_alloc(sigqueue_cachep, flags);
 	} else {
 		print_dropped_signal(sig);
diff --git a/kernel/sys.c b/kernel/sys.c
index 26a6b73..9177663 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -574,8 +574,7 @@ static int set_user(struct cred *new)
 		return -EINVAL;
 	}
 
-	if (atomic_read(&new_user->processes) >=
-				current->signal->rlim[RLIMIT_NPROC].rlim_cur &&
+	if (atomic_read(&new_user->processes) >= rlimit(RLIMIT_NPROC) &&
 			new_user != INIT_USER) {
 		free_uid(new_user);
 		return -EAGAIN;
-- 
1.6.5.7

