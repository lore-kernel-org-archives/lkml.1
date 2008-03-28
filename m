Return-Path: <linux-kernel-owner+w=401wt.eu-S1756828AbYC1Ax1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756828AbYC1Ax1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 20:53:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756544AbYC1AxM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 20:53:12 -0400
Received: from smtp-out.google.com ([216.239.45.13]:12340 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754924AbYC1AxG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 20:53:06 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:subject:from:to:cc:in-reply-to:references:
	content-type:organization:date:message-id:mime-version:x-mailer:content-transfer-encoding;
	b=eKOBcwq3gQxVFZBQ37gnPVQ4vaEs+SfTIz/j6P8ZQObMH6Io19epiEiHT/PvpN8R9
	ufiQeIs81Sl5GM0lEwFuw==
Subject: [PATCH 2.6.25-rc6] Fix itimer/many thread hang.
From: Frank Mayhar <fmayhar@google.com>
To: Roland McGrath <roland@redhat.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20080322215829.D69D026F9A7@magilla.localdomain>
References: <bug-9906-10286@http.bugzilla.kernel.org/>
	 <20080206165045.89b809cc.akpm@linux-foundation.org>
	 <1202345893.8525.33.camel@peace.smo.corp.google.com>
	 <alpine.LRH.1.00.0802062148480.7445@mini.warudkars.net>
	 <20080207162203.3e3cf5ab@Varda>
	 <alpine.LRH.1.00.0802071040010.29320@mini.warudkars.net>
	 <alpine.LRH.1.00.0802071054160.29320@mini.warudkars.net>
	 <20080207165455.04ec490b@Varda>
	 <alpine.LRH.1.00.0802071100230.29369@mini.warudkars.net>
	 <alpine.LRH.1.00.0802071153130.15220@mini.warudkars.net>
	 <1204314904.4850.23.camel@peace.smo.corp.google.com>
	 <20080304070016.903E127010A@magilla.localdomain>
	 <1204660376.9768.1.camel@bobble.smo.corp.google.com>
	 <20080305040826.D0E6127010A@magilla.localdomain>
	 <1204830243.20004.31.camel@bobble.smo.corp.google.com>
	 <20080311075020.A93DB26F991@magilla.localdomain>
	 <1205269507.23124.57.camel@bobble.smo.corp.google.com>
	 <20080311213507.5BCDF26F991@magilla.localdomain>
	 <1205455050.19551.16.camel@bobble.smo.corp.google.com>
	 <20080321071846.1B22B26F9A7@magilla.localdomain>
	 <1206122240.14638.31.camel@bobble.smo.corp.google.com>
	 <20080322215829.D69D026F9A7@magilla.localdomain>
Content-Type: text/plain
Organization: Google, Inc.
Date: Thu, 27 Mar 2008 17:52:48 -0700
Message-Id: <1206665568.426.24.camel@bobble.smo.corp.google.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is my official first cut at a patch that will fix bug 9906, "Weird
hang with NPTL and SIGPROF."  The problem is that run_posix_cpu_timers()
repeatedly walks the entire thread group every time it runs, which is at
interrupt.  With heavy load and lots of threads, this can take longer
than the tick, at which point the kernel stops doing anything put
servicing clock ticks and the occasional interrupt.  Many thanks to
Roland McGrath for his help in my attempt to understand his code.

The change adds a new structure to the signal_struct,
thread_group_cputime.  On an SMP kernel, this is allocated as a percpu
structure when needed (from do_setitimer()) using the alloc_percpu()
mechanism).  It is manipulated via a set of inline functions and macros
defined in sched.h, thread_group_times_init(),
thread_group_times_free(), thread_group_times_alloc(),
thread_group_update() (the macro) and thread_group_cputime().  The
thread_group_update macro is used to update a single field of the
thread_group_cputime structure when needed; the thread_group_cputime()
function sums the fields for each cpu into a passed structure.

In the uniprocessor case, the thread_group_cputime structure becomes a
simple substructure of the signal_struct, allocation and freeing go away
and updating and "summing" become simple assignments.

In addition to fixing the hang, this change removes the overloading of
it_prof_expires for RLIMIT_CPU handling, replacing it with a new field,
rlim_expires, which is checked instead.  This makes the code simpler and
more straightforward.

I've made some decisions in this work that could have gone in different
directions and I'm certainly happy to entertain comments and criticisms.
Performance with this fix is at least as good as before and in a few
cases is slightly improved, possibly due to the reduced tick overhead.

Signed-off-by:  Frank Mayhar <fmayhar@google.com>

 include/linux/sched.h     |  172 ++++++++++++++++++++++++++++
 kernel/compat.c           |   31 ++++--
 kernel/fork.c             |   22 +---
 kernel/itimer.c           |   40 ++++---
 kernel/posix-cpu-timers.c |  271 +++++++++++++--------------------------------
 kernel/sched.c            |    4 +
 kernel/sched_fair.c       |    2 +
 kernel/sched_rt.c         |    2 +
 kernel/sys.c              |   41 ++++---
 security/selinux/hooks.c  |    4 +-
 10 files changed, 333 insertions(+), 256 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index fed07d0..8d1b19d 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -424,6 +424,18 @@ struct pacct_struct {
 };
 
 /*
+ * This structure contains the versions of utime, stime and sum_exec_runtime
+ * that are shared across threads within a process.  It's only used for
+ * interval timers and is allocated via alloc_percpu() in the signal
+ * structure when such a timer is set up.
+ */
+struct thread_group_cputime {
+	cputime_t utime;
+	cputime_t stime;
+	unsigned long long sum_exec_runtime;
+};
+
+/*
  * NOTE! "signal_struct" does not have it's own
  * locking, because a shared signal_struct always
  * implies a shared sighand_struct, so locking
@@ -468,6 +480,12 @@ struct signal_struct {
 	cputime_t it_prof_expires, it_virt_expires;
 	cputime_t it_prof_incr, it_virt_incr;
 
+	/* Scheduling timer for the process */
+	unsigned long long it_sched_expires;
+
+	/* RLIMIT_CPU timer for the process */
+	cputime_t rlim_expires;
+
 	/* job control IDs */
 
 	/*
@@ -492,6 +510,13 @@ struct signal_struct {
 
 	struct tty_struct *tty; /* NULL if no tty */
 
+	/* Process-wide times for POSIX interval timing.  Per CPU. */
+#ifdef CONFIG_SMP
+	struct thread_group_cputime *thread_group_times;
+#else
+	struct thread_group_cputime thread_group_times;
+#endif
+
 	/*
 	 * Cumulative resource counters for dead threads in the group,
 	 * and for reaped dead child processes forked by this group.
@@ -1978,6 +2003,153 @@ static inline int spin_needbreak(spinlock_t *lock)
 #endif
 }
 
+#define thread_group_runtime_add(a, b) ((a) + (b))
+
+#ifdef CONFIG_SMP
+
+static inline void thread_group_times_init(struct signal_struct *sig)
+{
+	sig->thread_group_times = NULL;
+}
+
+static inline void thread_group_times_free(struct signal_struct *sig)
+{
+	if (sig->thread_group_times)
+		free_percpu(sig->thread_group_times);
+}
+
+/*
+ * Allocate the thread_group_cputime struct appropriately and fill in the current
+ * values of the fields.  Called from do_setitimer() when setting an interval
+ * timer (ITIMER_PROF or ITIMER_VIRTUAL).  Assumes interrupts are enabled when
+ * it's called.  Note that there is no corresponding deallocation done from
+ * do_setitimer(); the structure is freed at process exit.
+ */
+static inline int thread_group_times_alloc(struct task_struct *tsk)
+{
+	struct signal_struct *sig = tsk->signal;
+	struct thread_group_cputime *thread_group_times;
+	struct task_struct *t;
+	cputime_t utime, stime;
+	unsigned long long sum_exec_runtime;
+
+	/*
+	 * If we don't already have a thread_group_cputime struct, allocate
+	 * one and fill it in with the accumulated times.
+	 */
+	if (sig->thread_group_times)
+		return 0;
+	thread_group_times = alloc_percpu(struct thread_group_cputime);
+	if (thread_group_times == NULL)
+		return -ENOMEM;
+	read_lock(&tasklist_lock);
+	spin_lock_irq(&tsk->sighand->siglock);
+	if (sig->thread_group_times) {
+		spin_unlock_irq(&tsk->sighand->siglock);
+		read_unlock(&tasklist_lock);
+		free_percpu(thread_group_times);
+		return 0;
+	}
+	sig->thread_group_times = thread_group_times;
+	utime = sig->utime;
+	stime = sig->stime;
+	sum_exec_runtime = tsk->se.sum_exec_runtime;
+	t = tsk;
+	do {
+		utime = cputime_add(utime, t->utime);
+		stime = cputime_add(stime, t->stime);
+		sum_exec_runtime += t->se.sum_exec_runtime;
+	} while_each_thread(tsk, t);
+	thread_group_times = per_cpu_ptr(sig->thread_group_times, get_cpu());
+	thread_group_times->utime = utime;
+	thread_group_times->stime = stime;
+	thread_group_times->sum_exec_runtime = sum_exec_runtime;
+	put_cpu_no_resched();
+	spin_unlock_irq(&tsk->sighand->siglock);
+	read_unlock(&tasklist_lock);
+	return 0;
+}
+
+#define thread_group_update(sig, field, val, op) ({ \
+	if (sig && sig->thread_group_times) {				\
+		int cpu;						\
+		struct thread_group_cputime *thread_group_times;	\
+									\
+		cpu = get_cpu();					\
+		thread_group_times =					\
+			per_cpu_ptr(sig->thread_group_times, cpu);	\
+		thread_group_times->field =				\
+			op(thread_group_times->field, val);		\
+		put_cpu_no_resched();					\
+	}								\
+})
+
+/*
+ * Sum the time fields across all running CPUs.
+ */
+static inline int thread_group_cputime(struct thread_group_cputime *thread_group_times,
+	struct signal_struct *sig)
+{
+	int i;
+	struct thread_group_cputime *tg_times;
+	cputime_t utime = cputime_zero;
+	cputime_t stime = cputime_zero;
+	unsigned long long sum_exec_runtime = 0;
+
+	if (!sig->thread_group_times)
+		return(0);
+	for_each_online_cpu(i) {
+		tg_times = per_cpu_ptr(sig->thread_group_times, i);
+		utime = cputime_add(utime, tg_times->utime);
+		stime = cputime_add(stime, tg_times->stime);
+		sum_exec_runtime += tg_times->sum_exec_runtime;
+	}
+	thread_group_times->utime = utime;
+	thread_group_times->stime = stime;
+	thread_group_times->sum_exec_runtime = sum_exec_runtime;
+	return(1);
+}
+
+#else /* CONFIG_SMP */
+
+static inline void thread_group_times_init(struct signal_struct *sig)
+{
+}
+
+static inline void thread_group_times_free(struct signal_struct *sig)
+{
+}
+
+/*
+ * Allocate the thread_group_cputime struct appropriately and fill in the current
+ * values of the fields.  Called from do_setitimer() when setting an interval
+ * timer (ITIMER_PROF or ITIMER_VIRTUAL).  Assumes interrupts are enabled when
+ * it's called.  Note that there is no corresponding deallocation done from
+ * do_setitimer(); the structure is freed at process exit.
+ */
+static inline int thread_group_times_alloc(struct task_struct *tsk)
+{
+	return 0;
+}
+
+#define thread_group_update(sig, field, val, op) ({ \
+	if (sig)							\
+		sig->thread_group_times.field =				\
+			op(sig->thread_group_times.field, val);		\
+})
+
+/*
+ * Sum the time fields across all running CPUs.
+ */
+static inline int thread_group_cputime(struct thread_group_cputime *thread_group_times,
+	struct signal_struct *sig)
+{
+	*thread_group_times = sig->thread_group_times;
+	return(1);
+}
+
+#endif /* CONFIG_SMP */
+
 /*
  * Reevaluate whether the task has signals pending delivery.
  * Wake the task if so.
diff --git a/kernel/compat.c b/kernel/compat.c
index 5f0e201..5c80f32 100644
--- a/kernel/compat.c
+++ b/kernel/compat.c
@@ -153,6 +153,8 @@ asmlinkage long compat_sys_setitimer(int which,
 
 asmlinkage long compat_sys_times(struct compat_tms __user *tbuf)
 {
+	struct thread_group_cputime thread_group_times;
+
 	/*
 	 *	In the SMP world we might just be unlucky and have one of
 	 *	the times increment as we use it. Since the value is an
@@ -162,18 +164,28 @@ asmlinkage long compat_sys_times(struct compat_tms __user *tbuf)
 	if (tbuf) {
 		struct compat_tms tmp;
 		struct task_struct *tsk = current;
-		struct task_struct *t;
 		cputime_t utime, stime, cutime, cstime;
 
 		read_lock(&tasklist_lock);
-		utime = tsk->signal->utime;
-		stime = tsk->signal->stime;
-		t = tsk;
-		do {
-			utime = cputime_add(utime, t->utime);
-			stime = cputime_add(stime, t->stime);
-			t = next_thread(t);
-		} while (t != tsk);
+		/*
+		 * If a POSIX interval timer is running use the process-wide
+		 * fields, else fall back to brute force.
+		 */
+		if (thread_group_cputime(&thread_group_times, tsk->signal)) {
+			utime = thread_group_times.utime;
+			stime = thread_group_times.stime;
+		}
+		else {
+			struct task_struct *t;
+
+			utime = tsk->signal->utime;
+			stime = tsk->signal->stime;
+			t = tsk;
+			do {
+				utime = cputime_add(utime, t->utime);
+				stime = cputime_add(stime, t->stime);
+			} while_each_thread(tsk, t);
+		}
 
 		/*
 		 * While we have tasklist_lock read-locked, no dying thread
@@ -1081,4 +1093,3 @@ compat_sys_sysinfo(struct compat_sysinfo __user *info)
 
 	return 0;
 }
-
diff --git a/kernel/fork.c b/kernel/fork.c
index dd249c3..e05d224 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -914,10 +914,14 @@ static int copy_signal(unsigned long clone_flags, struct task_struct *tsk)
 	sig->it_virt_incr = cputime_zero;
 	sig->it_prof_expires = cputime_zero;
 	sig->it_prof_incr = cputime_zero;
+	sig->it_sched_expires = 0;
+	sig->rlim_expires = cputime_zero;
 
 	sig->leader = 0;	/* session leadership doesn't inherit */
 	sig->tty_old_pgrp = NULL;
 
+	thread_group_times_init(sig);
+
 	sig->utime = sig->stime = sig->cutime = sig->cstime = cputime_zero;
 	sig->gtime = cputime_zero;
 	sig->cgtime = cputime_zero;
@@ -939,7 +943,7 @@ static int copy_signal(unsigned long clone_flags, struct task_struct *tsk)
 		 * New sole thread in the process gets an expiry time
 		 * of the whole CPU time limit.
 		 */
-		tsk->it_prof_expires =
+		sig->rlim_expires =
 			secs_to_cputime(sig->rlim[RLIMIT_CPU].rlim_cur);
 	}
 	acct_init_pacct(&sig->pacct);
@@ -952,6 +956,7 @@ static int copy_signal(unsigned long clone_flags, struct task_struct *tsk)
 void __cleanup_signal(struct signal_struct *sig)
 {
 	exit_thread_group_keys(sig);
+	thread_group_times_free(sig);
 	kmem_cache_free(signal_cachep, sig);
 }
 
@@ -1311,21 +1316,6 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 	if (clone_flags & CLONE_THREAD) {
 		p->group_leader = current->group_leader;
 		list_add_tail_rcu(&p->thread_group, &p->group_leader->thread_group);
-
-		if (!cputime_eq(current->signal->it_virt_expires,
-				cputime_zero) ||
-		    !cputime_eq(current->signal->it_prof_expires,
-				cputime_zero) ||
-		    current->signal->rlim[RLIMIT_CPU].rlim_cur != RLIM_INFINITY ||
-		    !list_empty(&current->signal->cpu_timers[0]) ||
-		    !list_empty(&current->signal->cpu_timers[1]) ||
-		    !list_empty(&current->signal->cpu_timers[2])) {
-			/*
-			 * Have child wake up on its first tick to check
-			 * for process CPU timers.
-			 */
-			p->it_prof_expires = jiffies_to_cputime(1);
-		}
 	}
 
 	if (likely(p->pid)) {
diff --git a/kernel/itimer.c b/kernel/itimer.c
index ab98274..8310db2 100644
--- a/kernel/itimer.c
+++ b/kernel/itimer.c
@@ -60,12 +60,11 @@ int do_getitimer(int which, struct itimerval *value)
 		cval = tsk->signal->it_virt_expires;
 		cinterval = tsk->signal->it_virt_incr;
 		if (!cputime_eq(cval, cputime_zero)) {
-			struct task_struct *t = tsk;
-			cputime_t utime = tsk->signal->utime;
-			do {
-				utime = cputime_add(utime, t->utime);
-				t = next_thread(t);
-			} while (t != tsk);
+			struct thread_group_cputime thread_group_times;
+			cputime_t utime;
+
+			(void)thread_group_cputime(&thread_group_times, tsk->signal);
+			utime = thread_group_times.utime;
 			if (cputime_le(cval, utime)) { /* about to fire */
 				cval = jiffies_to_cputime(1);
 			} else {
@@ -83,15 +82,12 @@ int do_getitimer(int which, struct itimerval *value)
 		cval = tsk->signal->it_prof_expires;
 		cinterval = tsk->signal->it_prof_incr;
 		if (!cputime_eq(cval, cputime_zero)) {
-			struct task_struct *t = tsk;
-			cputime_t ptime = cputime_add(tsk->signal->utime,
-						      tsk->signal->stime);
-			do {
-				ptime = cputime_add(ptime,
-						    cputime_add(t->utime,
-								t->stime));
-				t = next_thread(t);
-			} while (t != tsk);
+			struct thread_group_cputime thread_group_times;
+			cputime_t ptime;
+
+			(void)thread_group_cputime(&thread_group_times, tsk->signal);
+			ptime = cputime_add(thread_group_times.utime,
+					    thread_group_times.stime);
 			if (cputime_le(cval, ptime)) { /* about to fire */
 				cval = jiffies_to_cputime(1);
 			} else {
@@ -185,6 +181,13 @@ again:
 	case ITIMER_VIRTUAL:
 		nval = timeval_to_cputime(&value->it_value);
 		ninterval = timeval_to_cputime(&value->it_interval);
+		/*
+		 * If he's setting the timer for the first time, we need to
+		 * allocate the percpu area.  It's freed when the process
+		 * exits.
+		 */
+		if (!cputime_eq(nval, cputime_zero))
+			thread_group_times_alloc(tsk);
 		read_lock(&tasklist_lock);
 		spin_lock_irq(&tsk->sighand->siglock);
 		cval = tsk->signal->it_virt_expires;
@@ -209,6 +212,13 @@ again:
 	case ITIMER_PROF:
 		nval = timeval_to_cputime(&value->it_value);
 		ninterval = timeval_to_cputime(&value->it_interval);
+		/*
+		 * If he's setting the timer for the first time, we need to
+		 * allocate the percpu area.  It's freed when the process
+		 * exits.
+		 */
+		if (!cputime_eq(nval, cputime_zero))
+			thread_group_times_alloc(tsk);
 		read_lock(&tasklist_lock);
 		spin_lock_irq(&tsk->sighand->siglock);
 		cval = tsk->signal->it_prof_expires;
diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
index 2eae91f..53a4486 100644
--- a/kernel/posix-cpu-timers.c
+++ b/kernel/posix-cpu-timers.c
@@ -227,31 +227,20 @@ static int cpu_clock_sample_group_locked(unsigned int clock_idx,
 					 struct task_struct *p,
 					 union cpu_time_count *cpu)
 {
-	struct task_struct *t = p;
- 	switch (clock_idx) {
+	struct thread_group_cputime thread_group_times;
+
+	(void)thread_group_cputime(&thread_group_times, p->signal);
+	switch (clock_idx) {
 	default:
 		return -EINVAL;
 	case CPUCLOCK_PROF:
-		cpu->cpu = cputime_add(p->signal->utime, p->signal->stime);
-		do {
-			cpu->cpu = cputime_add(cpu->cpu, prof_ticks(t));
-			t = next_thread(t);
-		} while (t != p);
+		cpu->cpu = cputime_add(thread_group_times.utime, thread_group_times.stime);
 		break;
 	case CPUCLOCK_VIRT:
-		cpu->cpu = p->signal->utime;
-		do {
-			cpu->cpu = cputime_add(cpu->cpu, virt_ticks(t));
-			t = next_thread(t);
-		} while (t != p);
+		cpu->cpu = thread_group_times.utime;
 		break;
 	case CPUCLOCK_SCHED:
-		cpu->sched = p->signal->sum_sched_runtime;
-		/* Add in each other live thread.  */
-		while ((t = next_thread(t)) != p) {
-			cpu->sched += t->se.sum_exec_runtime;
-		}
-		cpu->sched += sched_ns(p);
+		cpu->sched = thread_group_times.sum_exec_runtime;
 		break;
 	}
 	return 0;
@@ -472,80 +461,13 @@ void posix_cpu_timers_exit(struct task_struct *tsk)
 }
 void posix_cpu_timers_exit_group(struct task_struct *tsk)
 {
-	cleanup_timers(tsk->signal->cpu_timers,
-		       cputime_add(tsk->utime, tsk->signal->utime),
-		       cputime_add(tsk->stime, tsk->signal->stime),
-		     tsk->se.sum_exec_runtime + tsk->signal->sum_sched_runtime);
-}
+	struct thread_group_cputime thread_group_times;
 
-
-/*
- * Set the expiry times of all the threads in the process so one of them
- * will go off before the process cumulative expiry total is reached.
- */
-static void process_timer_rebalance(struct task_struct *p,
-				    unsigned int clock_idx,
-				    union cpu_time_count expires,
-				    union cpu_time_count val)
-{
-	cputime_t ticks, left;
-	unsigned long long ns, nsleft;
- 	struct task_struct *t = p;
-	unsigned int nthreads = atomic_read(&p->signal->live);
-
-	if (!nthreads)
-		return;
-
-	switch (clock_idx) {
-	default:
-		BUG();
-		break;
-	case CPUCLOCK_PROF:
-		left = cputime_div_non_zero(cputime_sub(expires.cpu, val.cpu),
-				       nthreads);
-		do {
-			if (likely(!(t->flags & PF_EXITING))) {
-				ticks = cputime_add(prof_ticks(t), left);
-				if (cputime_eq(t->it_prof_expires,
-					       cputime_zero) ||
-				    cputime_gt(t->it_prof_expires, ticks)) {
-					t->it_prof_expires = ticks;
-				}
-			}
-			t = next_thread(t);
-		} while (t != p);
-		break;
-	case CPUCLOCK_VIRT:
-		left = cputime_div_non_zero(cputime_sub(expires.cpu, val.cpu),
-				       nthreads);
-		do {
-			if (likely(!(t->flags & PF_EXITING))) {
-				ticks = cputime_add(virt_ticks(t), left);
-				if (cputime_eq(t->it_virt_expires,
-					       cputime_zero) ||
-				    cputime_gt(t->it_virt_expires, ticks)) {
-					t->it_virt_expires = ticks;
-				}
-			}
-			t = next_thread(t);
-		} while (t != p);
-		break;
-	case CPUCLOCK_SCHED:
-		nsleft = expires.sched - val.sched;
-		do_div(nsleft, nthreads);
-		nsleft = max_t(unsigned long long, nsleft, 1);
-		do {
-			if (likely(!(t->flags & PF_EXITING))) {
-				ns = t->se.sum_exec_runtime + nsleft;
-				if (t->it_sched_expires == 0 ||
-				    t->it_sched_expires > ns) {
-					t->it_sched_expires = ns;
-				}
-			}
-			t = next_thread(t);
-		} while (t != p);
-		break;
-	}
+	(void)thread_group_cputime(&thread_group_times, tsk->signal);
+	cleanup_timers(tsk->signal->cpu_timers,
+		       thread_group_times.utime,
+		       thread_group_times.stime,
+		       thread_group_times.sum_exec_runtime);
 }
 
 static void clear_dead_task(struct k_itimer *timer, union cpu_time_count now)
@@ -642,24 +564,18 @@ static void arm_timer(struct k_itimer *timer, union cpu_time_count now)
 				    cputime_lt(p->signal->it_virt_expires,
 					       timer->it.cpu.expires.cpu))
 					break;
-				goto rebalance;
+				p->signal->it_virt_expires = timer->it.cpu.expires.cpu;
+				break;
 			case CPUCLOCK_PROF:
 				if (!cputime_eq(p->signal->it_prof_expires,
 						cputime_zero) &&
 				    cputime_lt(p->signal->it_prof_expires,
 					       timer->it.cpu.expires.cpu))
 					break;
-				i = p->signal->rlim[RLIMIT_CPU].rlim_cur;
-				if (i != RLIM_INFINITY &&
-				    i <= cputime_to_secs(timer->it.cpu.expires.cpu))
-					break;
-				goto rebalance;
+				p->signal->it_prof_expires = timer->it.cpu.expires.cpu;
+				break;
 			case CPUCLOCK_SCHED:
-			rebalance:
-				process_timer_rebalance(
-					timer->it.cpu.task,
-					CPUCLOCK_WHICH(timer->it_clock),
-					timer->it.cpu.expires, now);
+				p->signal->it_sched_expires = timer->it.cpu.expires.sched;
 				break;
 			}
 		}
@@ -1053,10 +969,10 @@ static void check_process_timers(struct task_struct *tsk,
 {
 	int maxfire;
 	struct signal_struct *const sig = tsk->signal;
-	cputime_t utime, stime, ptime, virt_expires, prof_expires;
+	cputime_t utime, ptime, virt_expires, prof_expires;
 	unsigned long long sum_sched_runtime, sched_expires;
-	struct task_struct *t;
 	struct list_head *timers = sig->cpu_timers;
+	struct thread_group_cputime thread_group_times;
 
 	/*
 	 * Don't sample the current process CPU clocks if there are no timers.
@@ -1072,17 +988,10 @@ static void check_process_timers(struct task_struct *tsk,
 	/*
 	 * Collect the current process totals.
 	 */
-	utime = sig->utime;
-	stime = sig->stime;
-	sum_sched_runtime = sig->sum_sched_runtime;
-	t = tsk;
-	do {
-		utime = cputime_add(utime, t->utime);
-		stime = cputime_add(stime, t->stime);
-		sum_sched_runtime += t->se.sum_exec_runtime;
-		t = next_thread(t);
-	} while (t != tsk);
-	ptime = cputime_add(utime, stime);
+	(void)thread_group_cputime(&thread_group_times, sig);
+	utime = thread_group_times.utime;
+	ptime = cputime_add(utime, thread_group_times.stime);
+	sum_sched_runtime = thread_group_times.sum_exec_runtime;
 
 	maxfire = 20;
 	prof_expires = cputime_zero;
@@ -1185,66 +1094,24 @@ static void check_process_timers(struct task_struct *tsk,
 			}
 		}
 		x = secs_to_cputime(sig->rlim[RLIMIT_CPU].rlim_cur);
-		if (cputime_eq(prof_expires, cputime_zero) ||
-		    cputime_lt(x, prof_expires)) {
-			prof_expires = x;
+		if (cputime_eq(sig->rlim_expires, cputime_zero) ||
+		    cputime_lt(x, sig->rlim_expires)) {
+			sig->rlim_expires = x;
 		}
 	}
 
-	if (!cputime_eq(prof_expires, cputime_zero) ||
-	    !cputime_eq(virt_expires, cputime_zero) ||
-	    sched_expires != 0) {
-		/*
-		 * Rebalance the threads' expiry times for the remaining
-		 * process CPU timers.
-		 */
-
-		cputime_t prof_left, virt_left, ticks;
-		unsigned long long sched_left, sched;
-		const unsigned int nthreads = atomic_read(&sig->live);
-
-		if (!nthreads)
-			return;
-
-		prof_left = cputime_sub(prof_expires, utime);
-		prof_left = cputime_sub(prof_left, stime);
-		prof_left = cputime_div_non_zero(prof_left, nthreads);
-		virt_left = cputime_sub(virt_expires, utime);
-		virt_left = cputime_div_non_zero(virt_left, nthreads);
-		if (sched_expires) {
-			sched_left = sched_expires - sum_sched_runtime;
-			do_div(sched_left, nthreads);
-			sched_left = max_t(unsigned long long, sched_left, 1);
-		} else {
-			sched_left = 0;
-		}
-		t = tsk;
-		do {
-			if (unlikely(t->flags & PF_EXITING))
-				continue;
-
-			ticks = cputime_add(cputime_add(t->utime, t->stime),
-					    prof_left);
-			if (!cputime_eq(prof_expires, cputime_zero) &&
-			    (cputime_eq(t->it_prof_expires, cputime_zero) ||
-			     cputime_gt(t->it_prof_expires, ticks))) {
-				t->it_prof_expires = ticks;
-			}
-
-			ticks = cputime_add(t->utime, virt_left);
-			if (!cputime_eq(virt_expires, cputime_zero) &&
-			    (cputime_eq(t->it_virt_expires, cputime_zero) ||
-			     cputime_gt(t->it_virt_expires, ticks))) {
-				t->it_virt_expires = ticks;
-			}
-
-			sched = t->se.sum_exec_runtime + sched_left;
-			if (sched_expires && (t->it_sched_expires == 0 ||
-					      t->it_sched_expires > sched)) {
-				t->it_sched_expires = sched;
-			}
-		} while ((t = next_thread(t)) != tsk);
-	}
+	if (!cputime_eq(prof_expires, cputime_zero) &&
+	    (cputime_eq(sig->it_prof_expires, cputime_zero) ||
+	     cputime_gt(sig->it_prof_expires, prof_expires)))
+		sig->it_prof_expires = prof_expires;
+	if (!cputime_eq(virt_expires, cputime_zero) &&
+	    (cputime_eq(sig->it_virt_expires, cputime_zero) ||
+	     cputime_gt(sig->it_virt_expires, virt_expires)))
+		sig->it_virt_expires = virt_expires;
+	if (sched_expires != 0 &&
+	    (sig->it_sched_expires == 0 ||
+	     sig->it_sched_expires > sched_expires))
+		sig->it_sched_expires = sched_expires;
 }
 
 /*
@@ -1321,19 +1188,40 @@ void run_posix_cpu_timers(struct task_struct *tsk)
 {
 	LIST_HEAD(firing);
 	struct k_itimer *timer, *next;
+	struct thread_group_cputime thread_group_times;
+	cputime_t tg_virt, tg_prof;
+	unsigned long long tg_exec_runtime;
 
 	BUG_ON(!irqs_disabled());
 
-#define UNEXPIRED(clock) \
-		(cputime_eq(tsk->it_##clock##_expires, cputime_zero) || \
-		 cputime_lt(clock##_ticks(tsk), tsk->it_##clock##_expires))
+#define UNEXPIRED(p, prof, virt, sched) \
+	((cputime_eq((p)->it_prof_expires, cputime_zero) ||	\
+	 cputime_lt((prof), (p)->it_prof_expires)) &&		\
+	(cputime_eq((p)->it_virt_expires, cputime_zero) ||	\
+	 cputime_lt((virt), (p)->it_virt_expires)) &&		\
+	((p)->it_sched_expires == 0 || (sched) < (p)->it_sched_expires))
 
-	if (UNEXPIRED(prof) && UNEXPIRED(virt) &&
-	    (tsk->it_sched_expires == 0 ||
-	     tsk->se.sum_exec_runtime < tsk->it_sched_expires))
-		return;
+	/*
+	 * If there are no expired thread timers, no expired thread group
+	 * timers and no expired RLIMIT_CPU timer, just return.
+	 */
+	if (UNEXPIRED(tsk, prof_ticks(tsk),
+	    virt_ticks(tsk), tsk->se.sum_exec_runtime)) {
+		if (unlikely(tsk->signal == NULL))
+			return;
+		if ((tsk->signal->rlim[RLIMIT_CPU].rlim_cur == RLIM_INFINITY ||
+		     cputime_lt(tg_prof, tsk->signal->rlim_expires)) &&
+		    !thread_group_cputime(&thread_group_times, tsk->signal))
+			return;
+		tg_virt = thread_group_times.utime;
+		tg_prof = cputime_add(thread_group_times.utime,
+		    thread_group_times.stime);
+		tg_exec_runtime = thread_group_times.sum_exec_runtime;
+		if (UNEXPIRED(tsk->signal, tg_virt, tg_prof, tg_exec_runtime))
+			return;
+	}
 
-#undef	UNEXPIRED
+#undef UNEXPIRED
 
 	/*
 	 * Double-check with locks held.
@@ -1414,14 +1302,6 @@ void set_process_cpu_timer(struct task_struct *tsk, unsigned int clock_idx,
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
@@ -1433,13 +1313,14 @@ void set_process_cpu_timer(struct task_struct *tsk, unsigned int clock_idx,
 	    cputime_ge(list_first_entry(head,
 				  struct cpu_timer_list, entry)->expires.cpu,
 		       *newval)) {
-		/*
-		 * Rejigger each thread's expiry time so that one will
-		 * notice before we hit the process-cumulative expiry time.
-		 */
-		union cpu_time_count expires = { .sched = 0 };
-		expires.cpu = *newval;
-		process_timer_rebalance(tsk, clock_idx, expires, now);
+		switch (clock_idx) {
+		case CPUCLOCK_PROF:
+			tsk->signal->it_prof_expires = *newval;
+			break;
+		case CPUCLOCK_VIRT:
+			tsk->signal->it_virt_expires = *newval;
+			break;
+		}
 	}
 }
 
diff --git a/kernel/sched.c b/kernel/sched.c
index 28c73f0..1ff1a32 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -3594,6 +3594,7 @@ void account_user_time(struct task_struct *p, cputime_t cputime)
 	cputime64_t tmp;
 
 	p->utime = cputime_add(p->utime, cputime);
+	thread_group_update(p->signal, utime, cputime, cputime_add);
 
 	/* Add user time to cpustat. */
 	tmp = cputime_to_cputime64(cputime);
@@ -3616,6 +3617,7 @@ static void account_guest_time(struct task_struct *p, cputime_t cputime)
 	tmp = cputime_to_cputime64(cputime);
 
 	p->utime = cputime_add(p->utime, cputime);
+	thread_group_update(p->signal, utime, cputime, cputime_add);
 	p->gtime = cputime_add(p->gtime, cputime);
 
 	cpustat->user = cputime64_add(cpustat->user, tmp);
@@ -3649,6 +3651,7 @@ void account_system_time(struct task_struct *p, int hardirq_offset,
 		return account_guest_time(p, cputime);
 
 	p->stime = cputime_add(p->stime, cputime);
+	thread_group_update(p->signal, stime, cputime, cputime_add);
 
 	/* Add system time to cpustat. */
 	tmp = cputime_to_cputime64(cputime);
@@ -3690,6 +3693,7 @@ void account_steal_time(struct task_struct *p, cputime_t steal)
 
 	if (p == rq->idle) {
 		p->stime = cputime_add(p->stime, steal);
+		thread_group_update(p->signal, stime, steal, cputime_add);
 		if (atomic_read(&rq->nr_iowait) > 0)
 			cpustat->iowait = cputime64_add(cpustat->iowait, tmp);
 		else
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 86a9337..6f7d5d2 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -353,6 +353,8 @@ static void update_curr(struct cfs_rq *cfs_rq)
 		struct task_struct *curtask = task_of(curr);
 
 		cpuacct_charge(curtask, delta_exec);
+		thread_group_update(curtask->signal, sum_exec_runtime,
+			delta_exec, thread_group_runtime_add);
 	}
 }
 
diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index 0a6d2e5..7a2cc40 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -256,6 +256,8 @@ static void update_curr_rt(struct rq *rq)
 	schedstat_set(curr->se.exec_max, max(curr->se.exec_max, delta_exec));
 
 	curr->se.sum_exec_runtime += delta_exec;
+	thread_group_update(curr->signal, sum_exec_runtime,
+		delta_exec, thread_group_runtime_add);
 	curr->se.exec_start = rq->clock;
 	cpuacct_charge(curr, delta_exec);
 
diff --git a/kernel/sys.c b/kernel/sys.c
index a626116..baa3130 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -864,6 +864,8 @@ asmlinkage long sys_setfsgid(gid_t gid)
 
 asmlinkage long sys_times(struct tms __user * tbuf)
 {
+	struct thread_group_cputime thread_group_times;
+
 	/*
 	 *	In the SMP world we might just be unlucky and have one of
 	 *	the times increment as we use it. Since the value is an
@@ -873,19 +875,28 @@ asmlinkage long sys_times(struct tms __user * tbuf)
 	if (tbuf) {
 		struct tms tmp;
 		struct task_struct *tsk = current;
-		struct task_struct *t;
 		cputime_t utime, stime, cutime, cstime;
 
 		spin_lock_irq(&tsk->sighand->siglock);
-		utime = tsk->signal->utime;
-		stime = tsk->signal->stime;
-		t = tsk;
-		do {
-			utime = cputime_add(utime, t->utime);
-			stime = cputime_add(stime, t->stime);
-			t = next_thread(t);
-		} while (t != tsk);
+		/*
+		 * If a POSIX interval timer is running use the process-wide
+		 * fields, else fall back to brute force.
+		 */
+		if (thread_group_cputime(&thread_group_times, tsk->signal)) {
+			utime = thread_group_times.utime;
+			stime = thread_group_times.stime;
+		}
+		else {
+			struct task_struct *t;
 
+			utime = tsk->signal->utime;
+			stime = tsk->signal->stime;
+			t = tsk;
+			do {
+				utime = cputime_add(utime, t->utime);
+				stime = cputime_add(stime, t->stime);
+			} while_each_thread(tsk, t);
+		}
 		cutime = tsk->signal->cutime;
 		cstime = tsk->signal->cstime;
 		spin_unlock_irq(&tsk->sighand->siglock);
@@ -1444,7 +1455,7 @@ asmlinkage long sys_old_getrlimit(unsigned int resource, struct rlimit __user *r
 asmlinkage long sys_setrlimit(unsigned int resource, struct rlimit __user *rlim)
 {
 	struct rlimit new_rlim, *old_rlim;
-	unsigned long it_prof_secs;
+	unsigned long rlim_secs;
 	int retval;
 
 	if (resource >= RLIM_NLIMITS)
@@ -1490,15 +1501,11 @@ asmlinkage long sys_setrlimit(unsigned int resource, struct rlimit __user *rlim)
 	if (new_rlim.rlim_cur == RLIM_INFINITY)
 		goto out;
 
-	it_prof_secs = cputime_to_secs(current->signal->it_prof_expires);
-	if (it_prof_secs == 0 || new_rlim.rlim_cur <= it_prof_secs) {
-		unsigned long rlim_cur = new_rlim.rlim_cur;
-		cputime_t cputime;
-
-		cputime = secs_to_cputime(rlim_cur);
+	rlim_secs = cputime_to_secs(current->signal->rlim_expires);
+	if (rlim_secs == 0 || new_rlim.rlim_cur <= rlim_secs) {
 		read_lock(&tasklist_lock);
 		spin_lock_irq(&current->sighand->siglock);
-		set_process_cpu_timer(current, CPUCLOCK_PROF, &cputime, NULL);
+		current->signal->rlim_expires = secs_to_cputime(new_rlim.rlim_cur);
 		spin_unlock_irq(&current->sighand->siglock);
 		read_unlock(&tasklist_lock);
 	}
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 41a049f..62fed13 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -2201,7 +2201,7 @@ static void selinux_bprm_post_apply_creds(struct linux_binprm *bprm)
 			 * This will cause RLIMIT_CPU calculations
 			 * to be refigured.
 			 */
-			current->it_prof_expires = jiffies_to_cputime(1);
+			current->signal->rlim_expires = jiffies_to_cputime(1);
 		}
 	}
 
@@ -5624,5 +5624,3 @@ int selinux_disable(void)
 	return 0;
 }
 #endif
-
-

-- 
Frank Mayhar <fmayhar@google.com>
Google, Inc.


