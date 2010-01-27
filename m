Return-Path: <linux-kernel-owner+w=401wt.eu-S1755248Ab0A0Qer@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755248Ab0A0Qer (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 11:34:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755156Ab0A0Qen
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 11:34:43 -0500
Received: from smtp.mujha-vel.cz ([81.30.225.246]:53239 "EHLO
	smtp.mujha-vel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754371Ab0A0Qeg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 11:34:36 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: mingo@elte.hu
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       jirislaby@gmail.com
Subject: [PATCH 2/2] core: use helpers for rlimits
Date: Wed, 27 Jan 2010 17:34:31 +0100
Message-Id: <1264610071-24794-2-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.6.6.1
In-Reply-To: <1264610071-24794-1-git-send-email-jslaby@suse.cz>
References: <1264610071-24794-1-git-send-email-jslaby@suse.cz>
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
index 3d66564..6fca655 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -824,12 +824,14 @@ void __cleanup_sighand(struct sighand_struct *sighand)
  */
 static void posix_cpu_timers_init_group(struct signal_struct *sig)
 {
+	unsigned long cpu_limit;
+
 	/* Thread group counters. */
 	thread_group_cputime_init(sig);
 
-	if (sig->rlim[RLIMIT_CPU].rlim_cur != RLIM_INFINITY) {
-		sig->cputime_expires.prof_exp =
-			secs_to_cputime(sig->rlim[RLIMIT_CPU].rlim_cur);
+	cpu_limit = ACCESS_ONCE(sig->rlim[RLIMIT_CPU].rlim_cur);
+	if (cpu_limit != RLIM_INFINITY) {
+		sig->cputime_expires.prof_exp = secs_to_cputime(cpu_limit);
 		sig->cputimer.running = 1;
 	}
 
@@ -999,7 +1001,7 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 #endif
 	retval = -EAGAIN;
 	if (atomic_read(&p->real_cred->user->processes) >=
-			p->signal->rlim[RLIMIT_NPROC].rlim_cur) {
+			task_rlimit(p, RLIMIT_NPROC)) {
 		if (!capable(CAP_SYS_ADMIN) && !capable(CAP_SYS_RESOURCE) &&
 		    p->real_cred->user != INIT_USER)
 			goto bad_fork_free;
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index faaa9e6..09e92ba 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -2463,7 +2463,7 @@ static int perf_mmap(struct file *file, struct vm_area_struct *vma)
 	if (user_locked > user_lock_limit)
 		extra = user_locked - user_lock_limit;
 
-	lock_limit = current->signal->rlim[RLIMIT_MEMLOCK].rlim_cur;
+	lock_limit = rlimit(RLIMIT_MEMLOCK);
 	lock_limit >>= PAGE_SHIFT;
 	locked = vma->vm_mm->locked_vm + extra;
 
diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
index 92c4fa1..be3fc00 100644
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
@@ -1125,7 +1126,7 @@ static void check_process_timers(struct task_struct *tsk,
 	unsigned long long sum_sched_runtime, sched_expires;
 	struct list_head *timers = sig->cpu_timers;
 	struct task_cputime cputime;
-	unsigned long cpu_cur_lim = sig->rlim[RLIMIT_CPU].rlim_cur;
+	unsigned long cpu_cur_lim = ACCESS_ONCE(sig->rlim[RLIMIT_CPU].rlim_cur);
 
 	/*
 	 * Don't sample the current process CPU clocks if there are no timers.
@@ -1201,7 +1202,8 @@ static void check_process_timers(struct task_struct *tsk,
 
 	if (cpu_cur_lim != RLIM_INFINITY) {
 		unsigned long psecs = cputime_to_secs(ptime);
-		unsigned long hard = sig->rlim[RLIMIT_CPU].rlim_max;
+		unsigned long hard =
+			ACCESS_ONCE(sig->rlim[RLIMIT_CPU].rlim_max);
 		cputime_t x;
 		if (psecs >= hard) {
 			/*
@@ -1388,7 +1390,7 @@ static inline int fastpath_timer_check(struct task_struct *tsk)
 			return 1;
 	}
 
-	return sig->rlim[RLIMIT_CPU].rlim_cur != RLIM_INFINITY;
+	return ACCESS_ONCE(sig->rlim[RLIMIT_CPU].rlim_cur) != RLIM_INFINITY;
 }
 
 /*
@@ -1486,7 +1488,7 @@ void set_process_cpu_timer(struct task_struct *tsk, unsigned int clock_idx,
 		 * If the RLIMIT_CPU timer will expire before the
 		 * ITIMER_PROF timer, we have nothing else to do.
 		 */
-		if (tsk->signal->rlim[RLIMIT_CPU].rlim_cur
+		if (task_rlimit(tsk, RLIMIT_CPU)
 		    < cputime_to_secs(*newval))
 			return;
 	}
diff --git a/kernel/sched.c b/kernel/sched.c
index 86b49f9..467fc1a 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -6138,7 +6138,7 @@ int can_nice(const struct task_struct *p, const int nice)
 	/* convert nice value [19,-20] to rlimit style value [1,40] */
 	int nice_rlim = 20 - nice;
 
-	return (nice_rlim <= p->signal->rlim[RLIMIT_NICE].rlim_cur ||
+	return (nice_rlim <= task_rlimit(p, RLIMIT_NICE) ||
 		capable(CAP_SYS_NICE));
 }
 
@@ -6315,7 +6315,7 @@ recheck:
 
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
index 278704b..2213bb4 100644
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
index ef286ab..c9da91a 100644
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
1.6.6.1

