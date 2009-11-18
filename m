Return-Path: <linux-kernel-owner+w=401wt.eu-S1755873AbZKROxw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755873AbZKROxw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 09:53:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755511AbZKROxv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 09:53:51 -0500
Received: from server1.wserver.cz ([82.113.45.157]:51274 "EHLO
	server1.wserver.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757553AbZKROwA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 09:52:00 -0500
From: Jiri Slaby <jslaby@novell.com>
To: jirislaby@gmail.com
Cc: mingo@elte.hu, nhorman@tuxdriver.com, sfr@canb.auug.org.au,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       marcin.slusarz@gmail.com, tglx@linutronix.de, mingo@redhat.com,
       hpa@zytor.com, torvalds@linux-foundation.org,
       Jiri Slaby <jslaby@novell.com>, James Morris <jmorris@namei.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 10/16] core: use ACCESS_ONCE for rlimits
Date: Wed, 18 Nov 2009 15:51:56 +0100
Message-Id: <1258555922-2064-10-git-send-email-jslaby@novell.com>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <4B040A03.2020508@gmail.com>
References: <4B040A03.2020508@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make sure compiler won't do weird things with limits. E.g. fetching
them twice may return 2 different values after writable limits are
implemented.

Signed-off-by: Jiri Slaby <jslaby@novell.com>
Cc: James Morris <jmorris@namei.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>
---
 kernel/fork.c             |   10 ++++++----
 kernel/perf_event.c       |    3 ++-
 kernel/posix-cpu-timers.c |   16 +++++++++-------
 kernel/sched.c            |    6 ++++--
 kernel/sched_rt.c         |    5 +++--
 kernel/signal.c           |    4 ++--
 kernel/sys.c              |    4 ++--
 7 files changed, 28 insertions(+), 20 deletions(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index 166b8c4..dab13f2 100644
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
+			ACCESS_ONCE(p->signal->rlim[RLIMIT_NPROC].rlim_cur)) {
 		if (!capable(CAP_SYS_ADMIN) && !capable(CAP_SYS_RESOURCE) &&
 		    p->real_cred->user != INIT_USER)
 			goto bad_fork_free;
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 7f29643..229ce9a 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -2420,7 +2420,8 @@ static int perf_mmap(struct file *file, struct vm_area_struct *vma)
 	if (user_locked > user_lock_limit)
 		extra = user_locked - user_lock_limit;
 
-	lock_limit = current->signal->rlim[RLIMIT_MEMLOCK].rlim_cur;
+	lock_limit = ACCESS_ONCE(current->signal->
+			rlim[RLIMIT_MEMLOCK].rlim_cur);
 	lock_limit >>= PAGE_SHIFT;
 	locked = vma->vm_mm->locked_vm + extra;
 
diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
index a7dcce1..4c11521 100644
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
+		if (ACCESS_ONCE(tsk->signal->rlim[RLIMIT_CPU].rlim_cur)
 		    < cputime_to_secs(*newval))
 			return;
 	}
diff --git a/kernel/sched.c b/kernel/sched.c
index 3c11ae0..15172ea 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -6072,7 +6072,8 @@ int can_nice(const struct task_struct *p, const int nice)
 	/* convert nice value [19,-20] to rlimit style value [1,40] */
 	int nice_rlim = 20 - nice;
 
-	return (nice_rlim <= p->signal->rlim[RLIMIT_NICE].rlim_cur ||
+	return (nice_rlim <= ACCESS_ONCE(p->signal->
+				rlim[RLIMIT_NICE].rlim_cur) ||
 		capable(CAP_SYS_NICE));
 }
 
@@ -6257,7 +6258,8 @@ recheck:
 
 			if (!lock_task_sighand(p, &flags))
 				return -ESRCH;
-			rlim_rtprio = p->signal->rlim[RLIMIT_RTPRIO].rlim_cur;
+			rlim_rtprio = ACCESS_ONCE(p->signal->
+					rlim[RLIMIT_RTPRIO].rlim_cur);
 			unlock_task_sighand(p, &flags);
 
 			/* can't set/change the rt policy */
diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index a4d790c..99d4490 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -1683,8 +1683,9 @@ static void watchdog(struct rq *rq, struct task_struct *p)
 	if (!p->signal)
 		return;
 
-	soft = p->signal->rlim[RLIMIT_RTTIME].rlim_cur;
-	hard = p->signal->rlim[RLIMIT_RTTIME].rlim_max;
+	/* max may change after cur was read, this will be fixed next tick */
+	soft = ACCESS_ONCE(p->signal->rlim[RLIMIT_RTTIME].rlim_cur);
+	hard = ACCESS_ONCE(p->signal->rlim[RLIMIT_RTTIME].rlim_max);
 
 	if (soft != RLIM_INFINITY) {
 		unsigned long next;
diff --git a/kernel/signal.c b/kernel/signal.c
index 6705320..e33ece0 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -208,8 +208,8 @@ static struct sigqueue *__sigqueue_alloc(struct task_struct *t, gfp_t flags,
 	user = get_uid(__task_cred(t)->user);
 	atomic_inc(&user->sigpending);
 	if (override_rlimit ||
-	    atomic_read(&user->sigpending) <=
-			t->signal->rlim[RLIMIT_SIGPENDING].rlim_cur)
+	    atomic_read(&user->sigpending) <= ACCESS_ONCE(t->signal->
+	    rlim[RLIMIT_SIGPENDING].rlim_cur))
 		q = kmem_cache_alloc(sigqueue_cachep, flags);
 	if (unlikely(q == NULL)) {
 		atomic_dec(&user->sigpending);
diff --git a/kernel/sys.c b/kernel/sys.c
index 0f86199..52200d4 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -572,8 +572,8 @@ static int set_user(struct cred *new)
 		return -EINVAL;
 	}
 
-	if (atomic_read(&new_user->processes) >=
-				current->signal->rlim[RLIMIT_NPROC].rlim_cur &&
+	if (atomic_read(&new_user->processes) >= ACCESS_ONCE(current->signal->
+				rlim[RLIMIT_NPROC].rlim_cur) &&
 			new_user != INIT_USER) {
 		free_uid(new_user);
 		return -EAGAIN;
-- 
1.6.4.2

