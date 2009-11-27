Return-Path: <linux-kernel-owner+w=401wt.eu-S1753976AbZK0XIv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753976AbZK0XIv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 18:08:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753968AbZK0XIR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 18:08:17 -0500
Received: from server1.wserver.cz ([82.113.45.157]:60466 "EHLO
	server1.wserver.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753724AbZK0XGG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 18:06:06 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: jirislaby@gmail.com
Cc: mingo@elte.hu, nhorman@tuxdriver.com, sfr@canb.auug.org.au,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       marcin.slusarz@gmail.com, tglx@linutronix.de, mingo@redhat.com,
       hpa@zytor.com, torvalds@linux-foundation.org, oleg@redhat.com,
       James Morris <jmorris@namei.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH v3 22/27] core: use helpers for rlimits
Date: Sat, 28 Nov 2009 00:06:02 +0100
Message-Id: <1259363167-9347-22-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <1259363167-9347-1-git-send-email-jslaby@suse.cz>
References: <1259363167-9347-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make sure compiler won't do weird things with limits. E.g. fetching
them twice may return 2 different values after writable limits are
implemented.

I.e. either use newly added rlimit helpers or ACCESS_ONCE if not
applicable.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: James Morris <jmorris@namei.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>
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
index 166b8c4..9f0773d 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -822,6 +822,8 @@ void __cleanup_sighand(struct sighand_struct *sighand)
  */
 static void posix_cpu_timers_init_group(struct signal_struct *sig)
 {
+	unsigned long cpu_limit;
+
 	/* Thread group counters. */
 	thread_group_cputime_init(sig);
 
@@ -836,9 +838,9 @@ static void posix_cpu_timers_init_group(struct signal_struct *sig)
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
 
@@ -1028,7 +1030,7 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 #endif
 	retval = -EAGAIN;
 	if (atomic_read(&p->real_cred->user->processes) >=
-			p->signal->rlim[RLIMIT_NPROC].rlim_cur) {
+			task_rlim_get_cur(p, RLIMIT_NPROC)) {
 		if (!capable(CAP_SYS_ADMIN) && !capable(CAP_SYS_RESOURCE) &&
 		    p->real_cred->user != INIT_USER)
 			goto bad_fork_free;
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 7f29643..02ba1e0 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -2420,7 +2420,7 @@ static int perf_mmap(struct file *file, struct vm_area_struct *vma)
 	if (user_locked > user_lock_limit)
 		extra = user_locked - user_lock_limit;
 
-	lock_limit = current->signal->rlim[RLIMIT_MEMLOCK].rlim_cur;
+	lock_limit = rlim_get_cur(RLIMIT_MEMLOCK);
 	lock_limit >>= PAGE_SHIFT;
 	locked = vma->vm_mm->locked_vm + extra;
 
diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
index a7dcce1..79d4cb3 100644
--- a/kernel/posix-cpu-timers.c
+++ b/kernel/posix-cpu-timers.c
@@ -640,7 +640,7 @@ static void arm_timer(struct k_itimer *timer, union cpu_time_count now)
 				if (expires_le(sig->it[CPUCLOCK_PROF].expires,
 					       exp->cpu))
 					break;
-				i = sig->rlim[RLIMIT_CPU].rlim_cur;
+				i = ACCESS_ONCE(sig->rlim[RLIMIT_CPU].rlim_cur);
 				if (i != RLIM_INFINITY &&
 				    i <= cputime_to_secs(exp->cpu))
 					break;
@@ -1032,9 +1032,10 @@ static void check_thread_timers(struct task_struct *tsk,
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
@@ -1122,7 +1123,7 @@ static void check_process_timers(struct task_struct *tsk,
 	unsigned long long sum_sched_runtime, sched_expires;
 	struct list_head *timers = sig->cpu_timers;
 	struct task_cputime cputime;
-	unsigned long cpu_cur_lim = sig->rlim[RLIMIT_CPU].rlim_cur;
+	unsigned long cpu_cur_lim = ACCESS_ONCE(sig->rlim[RLIMIT_CPU].rlim_cur);
 
 	/*
 	 * Don't sample the current process CPU clocks if there are no timers.
@@ -1198,7 +1199,8 @@ static void check_process_timers(struct task_struct *tsk,
 
 	if (cpu_cur_lim != RLIM_INFINITY) {
 		unsigned long psecs = cputime_to_secs(ptime);
-		unsigned long hard = sig->rlim[RLIMIT_CPU].rlim_max;
+		unsigned long hard =
+			ACCESS_ONCE(sig->rlim[RLIMIT_CPU].rlim_max);
 		cputime_t x;
 		if (psecs >= hard) {
 			/*
@@ -1385,7 +1387,7 @@ static inline int fastpath_timer_check(struct task_struct *tsk)
 			return 1;
 	}
 
-	return sig->rlim[RLIMIT_CPU].rlim_cur != RLIM_INFINITY;
+	return ACCESS_ONCE(sig->rlim[RLIMIT_CPU].rlim_cur) != RLIM_INFINITY;
 }
 
 /*
@@ -1483,7 +1485,7 @@ void set_process_cpu_timer(struct task_struct *tsk, unsigned int clock_idx,
 		 * If the RLIMIT_CPU timer will expire before the
 		 * ITIMER_PROF timer, we have nothing else to do.
 		 */
-		if (tsk->signal->rlim[RLIMIT_CPU].rlim_cur
+		if (task_rlim_get_cur(tsk, RLIMIT_CPU)
 		    < cputime_to_secs(*newval))
 			return;
 	}
diff --git a/kernel/sched.c b/kernel/sched.c
index 3c11ae0..0e4077d 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -6072,7 +6072,7 @@ int can_nice(const struct task_struct *p, const int nice)
 	/* convert nice value [19,-20] to rlimit style value [1,40] */
 	int nice_rlim = 20 - nice;
 
-	return (nice_rlim <= p->signal->rlim[RLIMIT_NICE].rlim_cur ||
+	return (nice_rlim <= task_rlim_get_cur(p, RLIMIT_NICE) ||
 		capable(CAP_SYS_NICE));
 }
 
@@ -6257,7 +6257,7 @@ recheck:
 
 			if (!lock_task_sighand(p, &flags))
 				return -ESRCH;
-			rlim_rtprio = p->signal->rlim[RLIMIT_RTPRIO].rlim_cur;
+			rlim_rtprio = task_rlim_get_cur(p, RLIMIT_RTPRIO);
 			unlock_task_sighand(p, &flags);
 
 			/* can't set/change the rt policy */
diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index a4d790c..ab41715 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -1683,8 +1683,9 @@ static void watchdog(struct rq *rq, struct task_struct *p)
 	if (!p->signal)
 		return;
 
-	soft = p->signal->rlim[RLIMIT_RTTIME].rlim_cur;
-	hard = p->signal->rlim[RLIMIT_RTTIME].rlim_max;
+	/* max may change after cur was read, this will be fixed next tick */
+	soft = task_rlim_get_cur(p, RLIMIT_RTTIME);
+	hard = task_rlim_get_max(p, RLIMIT_RTTIME);
 
 	if (soft != RLIM_INFINITY) {
 		unsigned long next;
diff --git a/kernel/signal.c b/kernel/signal.c
index 6705320..34efd79 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -209,7 +209,7 @@ static struct sigqueue *__sigqueue_alloc(struct task_struct *t, gfp_t flags,
 	atomic_inc(&user->sigpending);
 	if (override_rlimit ||
 	    atomic_read(&user->sigpending) <=
-			t->signal->rlim[RLIMIT_SIGPENDING].rlim_cur)
+			task_rlim_get_cur(t, RLIMIT_SIGPENDING))
 		q = kmem_cache_alloc(sigqueue_cachep, flags);
 	if (unlikely(q == NULL)) {
 		atomic_dec(&user->sigpending);
diff --git a/kernel/sys.c b/kernel/sys.c
index fad6010..c4065c5 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -572,8 +572,7 @@ static int set_user(struct cred *new)
 		return -EINVAL;
 	}
 
-	if (atomic_read(&new_user->processes) >=
-				current->signal->rlim[RLIMIT_NPROC].rlim_cur &&
+	if (atomic_read(&new_user->processes) >= rlim_get_cur(RLIMIT_NPROC) &&
 			new_user != INIT_USER) {
 		free_uid(new_user);
 		return -EAGAIN;
-- 
1.6.5.3

