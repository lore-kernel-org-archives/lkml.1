Return-Path: <linux-kernel-owner+w=401wt.eu-S1757015AbYC1WrJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757015AbYC1WrJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 18:47:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750995AbYC1Wqz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 18:46:55 -0400
Received: from smtp-out.google.com ([216.239.45.13]:17902 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753170AbYC1Wqw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 18:46:52 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:subject:from:to:cc:in-reply-to:references:
	content-type:organization:date:message-id:mime-version:x-mailer:content-transfer-encoding;
	b=cIew9qpeqd7RwlU0ZVjr1W9d4h6CU4ArFLNbQEKoj7h/VdSlhIgAkUqw+hZWe3mPj
	BnvHItK/ztml5bNh0FfOg==
Subject: [PATCH 2.6.25-rc7 resubmit] Fix itimer/many thread hang.
From: Frank Mayhar <fmayhar@google.com>
To: Roland McGrath <roland@redhat.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1206665568.426.24.camel@bobble.smo.corp.google.com>
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
	 <1206665568.426.24.camel@bobble.smo.corp.google.com>
Content-Type: text/plain
Organization: Google, Inc.
Date: Fri, 28 Mar 2008 15:46:40 -0700
Message-Id: <1206744400.19691.31.camel@bobble.smo.corp.google.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is my second cut at a patch that will fix bug 9906, "Weird hang
with NPTL and SIGPROF."  Thanks to Ingo Molnar who sent me feedback
regarding the first cut.

Again, the problem is that run_posix_cpu_timers() repeatedly walks the
entire thread group every time it runs, which is at interrupt.  With
heavy load and lots of threads, this can take longer than the tick, at
which point the kernel stops doing anything put servicing clock ticks
and the occasional interrupt.  Many thanks to Roland McGrath for his
help in my attempt to understand his code.

The change adds a new structure to the signal_struct,
thread_group_cputime.  On an SMP kernel, this is allocated as a percpu
structure when needed (from do_setitimer()) using the alloc_percpu()
mechanism).  It is manipulated via a set of functions defined in sched.c
and sched.h.  These new functions are

      * thread_group_times_free(), inline function to free via
        free_percpu() (SMP) or kfree (UP) the thread_group_cputime
        structure.
      * thread_group_times_alloc(), external function to allocate the
        thread_group_cputime structure when needed.
      * thread_group_update(), inline function to update a field of the
        thread_group_cputime structure; called at interrupt from tick
        handlers, generally.  It depends on the "offsetof()" macro to
        know which field to update and on compiler optimization to
        remove the unused code paths in each case.
      * thread_group_cputime(), inline function that sums the time
        fields for all running CPUs (SMP) or snapshots the time fields
        (UP) into a passed structure.

I've changed the uniprocessor case to retain the dynamic allocation of
the thread_group_cputime structure as needed; this makes the code
somewhat more consistent between SMP and UP and retains the feature of
reducing overhead for processes that don't use interval timers.

In addition to fixing the hang, this change removes the overloading of
it_prof_expires for RLIMIT_CPU handling, replacing it with a new field,
rlim_expires, which is checked instead.  This makes the code simpler and
more straightforward.

The kernel/posix-cpu-timers.c file has changed pretty drastically, with
it no longer using the per-task times to know when to check for timer
expiration.  Instead, it consecutively checks the per-task timers and
then the per-process timers for expiration, consulting the individual
expiration fields (including the new RLIMIT_CPU expiration field) which
are now logically separate.  Rather than performing "rebalancing"
functions now do simple assignments and all loops through the thread
group have gone away, replaced with calls to thread_group_cputime().

Elsewhere, do_getitimer(), compat_sys_times() and sys_times() now use
thread_group_cputime() to get the times if a POSIX interval timer is in
use, providing a faster path in that case.

This version moves the thread_group_times_alloc() routine to sched.c,
changes the thread_group_update() macro to an inline function, shortens
a few things and cleans up the sched.h changes a bit.

Again, performance with the fix is at least as good as before and in a
few cases is slightly improved, possibly due to the reduced tick
overhead.

Finally, the patch has been retargeted to 2.6.25-rc7 instead of -rc6.

Signed-off-by:  Frank Mayhar <fmayhar@google.com>

 include/linux/sched.h     |  117 +++++++++++++++++++
 kernel/compat.c           |   30 ++++--
 kernel/fork.c             |   22 +---
 kernel/itimer.c           |   40 ++++---
 kernel/posix-cpu-timers.c |  276 +++++++++++++--------------------------------
 kernel/sched.c            |   73 ++++++++++++
 kernel/sched_fair.c       |    3 +
 kernel/sched_rt.c         |    3 +
 kernel/sys.c              |   44 +++++---
 security/selinux/hooks.c  |    4 +-
 10 files changed, 354 insertions(+), 258 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 6a1e7af..f6052ac 100644
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
+	cputime_t utime;		/* User time. */
+	cputime_t stime;		/* System time. */
+	unsigned long long sum_exec_runtime; /* Scheduler time. */
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
@@ -492,6 +510,9 @@ struct signal_struct {
 
 	struct tty_struct *tty; /* NULL if no tty */
 
+	/* Process-wide times for POSIX interval timing.  Per CPU. */
+	struct thread_group_cputime *thread_group_times;
+
 	/*
 	 * Cumulative resource counters for dead threads in the group,
 	 * and for reaped dead child processes forked by this group.
@@ -1984,6 +2005,102 @@ static inline int spin_needbreak(spinlock_t *lock)
 #endif
 }
 
+#ifdef CONFIG_SMP
+
+static inline void thread_group_times_free(
+	struct thread_group_cputime *tg_times)
+{
+	free_percpu(tg_times);
+}
+
+/*
+ * Sum the time fields across all running CPUs.
+ */
+static inline void thread_group_cputime(
+	struct thread_group_cputime *tg_times,
+	struct signal_struct *sig)
+{
+	int i;
+	struct thread_group_cputime *tg;
+
+	/*
+	 * Get the values for the current CPU separately so we don't get
+	 * preempted, then sum all the rest.
+	 */
+	tg = per_cpu_ptr(sig->thread_group_times, get_cpu());
+	*tg_times = *tg;
+	put_cpu_no_resched();
+	for_each_online_cpu(i) {
+		if (i == smp_processor_id())
+			continue;
+		tg = per_cpu_ptr(sig->thread_group_times, i);
+		tg_times->utime = cputime_add(tg_times->utime, tg->utime);
+		tg_times->stime = cputime_add(tg_times->stime, tg->stime);
+		tg_times->sum_exec_runtime += tg->sum_exec_runtime;
+	}
+}
+
+#else /* CONFIG_SMP */
+
+static inline void thread_group_times_free(
+	struct thread_group_cputime *tg_times)
+{
+	kfree(tg_times);
+}
+
+/*
+ * Snapshot the time fields.
+ */
+static inline void thread_group_cputime(
+	struct thread_group_cputime *tg_times,
+	struct signal_struct *sig)
+{
+	*tg_times = *sig->thread_group_times;
+}
+
+#endif /* CONFIG_SMP */
+
+/*
+ * Update one of the fields in the thread_group_cputime structure.  This is
+ * passed the offset of the field to be updated (acquired via the "offsetof"
+ * macro) and uses that to determine the actual field.
+ */
+static inline void thread_group_update(struct signal_struct *sig,
+	const int fieldoff, void *val)
+{
+	cputime_t cputime;
+	unsigned long long sum_exec_runtime;
+	struct thread_group_cputime *tg_times;
+
+	if (!sig || !sig->thread_group_times)
+		return;
+#ifdef CONFIG_SMP
+	tg_times = per_cpu_ptr(sig->thread_group_times, get_cpu());
+#else
+	tg_times = sig->thread_group_times;
+#endif
+	switch (fieldoff) {
+	case offsetof(struct thread_group_cputime, utime):
+		cputime = *(cputime_t *)val;
+		tg_times->utime = cputime_add(tg_times->utime, cputime);
+		break;
+	case offsetof(struct thread_group_cputime, stime):
+		cputime = *(cputime_t *)val;
+		tg_times->utime = cputime_add(tg_times->utime, cputime);
+		break;
+	case offsetof(struct thread_group_cputime, sum_exec_runtime):
+		sum_exec_runtime = *(unsigned long long *)val;
+		tg_times->sum_exec_runtime += sum_exec_runtime;
+		break;
+	}
+#ifdef CONFIG_SMP
+	put_cpu_no_resched();
+#endif
+}
+
+/* The thread_group_cputime allocator. */
+extern int thread_group_times_alloc(struct task_struct *);
+
 /*
  * Reevaluate whether the task has signals pending delivery.
  * Wake the task if so.
diff --git a/kernel/compat.c b/kernel/compat.c
index 5f0e201..06a7e3a 100644
--- a/kernel/compat.c
+++ b/kernel/compat.c
@@ -162,18 +162,29 @@ asmlinkage long compat_sys_times(struct compat_tms __user *tbuf)
 	if (tbuf) {
 		struct compat_tms tmp;
 		struct task_struct *tsk = current;
-		struct task_struct *t;
 		cputime_t utime, stime, cutime, cstime;
+		struct thread_group_cputime thread_group_times;
 
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
+		if (sig->thread_group_times) {
+			thread_group_cputime(&thread_group_times, tsk->signal);
+			utime = thread_group_times.utime;
+			stime = thread_group_times.stime;
+		} else {
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
@@ -1081,4 +1092,3 @@ compat_sys_sysinfo(struct compat_sysinfo __user *info)
 
 	return 0;
 }
-
diff --git a/kernel/fork.c b/kernel/fork.c
index dd249c3..d4f6282 100644
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
 
+	sig->thread_group_times = NULL;
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
+	thread_group_times_free(sig->thread_group_times);
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
index ab98274..7c5b416 100644
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
+			thread_group_cputime(&thread_group_times, tsk->signal);
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
+			thread_group_cputime(&thread_group_times, tsk->signal);
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
index 2eae91f..309a7c4 100644
--- a/kernel/posix-cpu-timers.c
+++ b/kernel/posix-cpu-timers.c
@@ -227,31 +227,21 @@ static int cpu_clock_sample_group_locked(unsigned int clock_idx,
 					 struct task_struct *p,
 					 union cpu_time_count *cpu)
 {
-	struct task_struct *t = p;
- 	switch (clock_idx) {
+	struct thread_group_cputime thread_group_times;
+
+	thread_group_cputime(&thread_group_times, p->signal);
+	switch (clock_idx) {
 	default:
 		return -EINVAL;
 	case CPUCLOCK_PROF:
-		cpu->cpu = cputime_add(p->signal->utime, p->signal->stime);
-		do {
-			cpu->cpu = cputime_add(cpu->cpu, prof_ticks(t));
-			t = next_thread(t);
-		} while (t != p);
+		cpu->cpu = cputime_add(thread_group_times.utime,
+			thread_group_times.stime);
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
@@ -472,80 +462,13 @@ void posix_cpu_timers_exit(struct task_struct *tsk)
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
+	thread_group_cputime(&thread_group_times, tsk->signal);
+	cleanup_timers(tsk->signal->cpu_timers,
+		       thread_group_times.utime,
+		       thread_group_times.stime,
+		       thread_group_times.sum_exec_runtime);
 }
 
 static void clear_dead_task(struct k_itimer *timer, union cpu_time_count now)
@@ -572,7 +495,6 @@ static void arm_timer(struct k_itimer *timer, union cpu_time_count now)
 	struct list_head *head, *listpos;
 	struct cpu_timer_list *const nt = &timer->it.cpu;
 	struct cpu_timer_list *next;
-	unsigned long i;
 
 	head = (CPUCLOCK_PERTHREAD(timer->it_clock) ?
 		p->cpu_timers : p->signal->cpu_timers);
@@ -642,24 +564,21 @@ static void arm_timer(struct k_itimer *timer, union cpu_time_count now)
 				    cputime_lt(p->signal->it_virt_expires,
 					       timer->it.cpu.expires.cpu))
 					break;
-				goto rebalance;
+				p->signal->it_virt_expires =
+					timer->it.cpu.expires.cpu;
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
+				p->signal->it_prof_expires =
+					timer->it.cpu.expires.cpu;
+				break;
 			case CPUCLOCK_SCHED:
-			rebalance:
-				process_timer_rebalance(
-					timer->it.cpu.task,
-					CPUCLOCK_WHICH(timer->it_clock),
-					timer->it.cpu.expires, now);
+				p->signal->it_sched_expires =
+					timer->it.cpu.expires.sched;
 				break;
 			}
 		}
@@ -1053,10 +972,10 @@ static void check_process_timers(struct task_struct *tsk,
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
@@ -1072,17 +991,10 @@ static void check_process_timers(struct task_struct *tsk,
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
+	thread_group_cputime(&thread_group_times, sig);
+	utime = thread_group_times.utime;
+	ptime = cputime_add(utime, thread_group_times.stime);
+	sum_sched_runtime = thread_group_times.sum_exec_runtime;
 
 	maxfire = 20;
 	prof_expires = cputime_zero;
@@ -1185,66 +1097,24 @@ static void check_process_timers(struct task_struct *tsk,
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
@@ -1321,19 +1191,40 @@ void run_posix_cpu_timers(struct task_struct *tsk)
 {
 	LIST_HEAD(firing);
 	struct k_itimer *timer, *next;
+	struct thread_group_cputime tg_times;
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
+		if (!sig->thread_group_times)
+			return;
+		thread_group_cputime(&tg_times, tsk->signal);
+		tg_prof = cputime_add(tg_times.utime, tg_times.stime);
+		tg_virt = tg_times.utime;
+		tg_exec_runtime = tg_times.sum_exec_runtime;
+		if ((tsk->signal->rlim[RLIMIT_CPU].rlim_cur == RLIM_INFINITY ||
+		     cputime_lt(tg_prof, tsk->signal->rlim_expires)) &&
+		    UNEXPIRED(tsk->signal, tg_virt, tg_prof, tg_exec_runtime))
+			return;
+	}
 
-#undef	UNEXPIRED
+#undef UNEXPIRED
 
 	/*
 	 * Double-check with locks held.
@@ -1414,14 +1305,6 @@ void set_process_cpu_timer(struct task_struct *tsk, unsigned int clock_idx,
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
@@ -1433,13 +1316,14 @@ void set_process_cpu_timer(struct task_struct *tsk, unsigned int clock_idx,
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
index 8dcdec6..81b61eb 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -3637,6 +3637,9 @@ void account_user_time(struct task_struct *p, cputime_t cputime)
 	cputime64_t tmp;
 
 	p->utime = cputime_add(p->utime, cputime);
+	thread_group_update(p->signal,
+		offsetof(struct thread_group_cputime, utime),
+		(void *)&cputime);
 
 	/* Add user time to cpustat. */
 	tmp = cputime_to_cputime64(cputime);
@@ -3659,6 +3662,9 @@ static void account_guest_time(struct task_struct *p, cputime_t cputime)
 	tmp = cputime_to_cputime64(cputime);
 
 	p->utime = cputime_add(p->utime, cputime);
+	thread_group_update(p->signal,
+		offsetof(struct thread_group_cputime, utime),
+		(void *)&cputime);
 	p->gtime = cputime_add(p->gtime, cputime);
 
 	cpustat->user = cputime64_add(cpustat->user, tmp);
@@ -3692,6 +3698,9 @@ void account_system_time(struct task_struct *p, int hardirq_offset,
 		return account_guest_time(p, cputime);
 
 	p->stime = cputime_add(p->stime, cputime);
+	thread_group_update(p->signal,
+		offsetof(struct thread_group_cputime, stime),
+		(void *)&cputime);
 
 	/* Add system time to cpustat. */
 	tmp = cputime_to_cputime64(cputime);
@@ -3733,6 +3742,9 @@ void account_steal_time(struct task_struct *p, cputime_t steal)
 
 	if (p == rq->idle) {
 		p->stime = cputime_add(p->stime, steal);
+		thread_group_update(p->signal,
+			offsetof(struct thread_group_cputime, stime),
+			(void *)&steal);
 		if (atomic_read(&rq->nr_iowait) > 0)
 			cpustat->iowait = cputime64_add(cpustat->iowait, tmp);
 		else
@@ -8138,3 +8150,64 @@ struct cgroup_subsys cpuacct_subsys = {
 	.subsys_id = cpuacct_subsys_id,
 };
 #endif	/* CONFIG_CGROUP_CPUACCT */
+
+/*
+ * Allocate the thread_group_cputime struct appropriately and fill in the
+ * current values of the fields.  Called from do_setitimer() when setting an
+ * interval timer (ITIMER_PROF or ITIMER_VIRTUAL).  Assumes interrupts are
+ * enabled when it's called.  Note that there is no corresponding deallocation
+ * done from do_setitimer(); the structure is freed at process exit.
+ */
+int thread_group_times_alloc(struct task_struct *tsk)
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
+#ifdef CONFIG_SMP
+	thread_group_times = alloc_percpu(struct thread_group_cputime);
+#else
+	thread_group_times =
+		kmalloc(sizeof(struct thread_group_cputime), GFP_KERNEL);
+#endif
+	if (thread_group_times == NULL)
+		return -ENOMEM;
+	read_lock(&tasklist_lock);
+	spin_lock_irq(&tsk->sighand->siglock);
+	if (sig->thread_group_times) {
+		spin_unlock_irq(&tsk->sighand->siglock);
+		read_unlock(&tasklist_lock);
+		thread_group_times_free(thread_group_times);
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
+#ifdef CONFIG_SMP
+	thread_group_times = per_cpu_ptr(sig->thread_group_times, get_cpu());
+#endif
+	thread_group_times->utime = utime;
+	thread_group_times->stime = stime;
+	thread_group_times->sum_exec_runtime = sum_exec_runtime;
+#ifdef CONFIG_SMP
+	put_cpu_no_resched();
+#endif
+	spin_unlock_irq(&tsk->sighand->siglock);
+	read_unlock(&tasklist_lock);
+	return 0;
+}
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 86a9337..fc5e269 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -353,6 +353,9 @@ static void update_curr(struct cfs_rq *cfs_rq)
 		struct task_struct *curtask = task_of(curr);
 
 		cpuacct_charge(curtask, delta_exec);
+		thread_group_update(curtask->signal,
+			offsetof(struct thread_group_cputime, sum_exec_runtime),
+			(void *)&delta_exec);
 	}
 }
 
diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index 0a6d2e5..ea48a92 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -256,6 +256,9 @@ static void update_curr_rt(struct rq *rq)
 	schedstat_set(curr->se.exec_max, max(curr->se.exec_max, delta_exec));
 
 	curr->se.sum_exec_runtime += delta_exec;
+	thread_group_update(curr->signal,
+		offsetof(struct thread_group_cputime, sum_exec_runtime),
+		(void *)&delta_exec);
 	curr->se.exec_start = rq->clock;
 	cpuacct_charge(curr, delta_exec);
 
diff --git a/kernel/sys.c b/kernel/sys.c
index a626116..ce70226 100644
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
-
+		/*
+		 * If a POSIX interval timer is running use the process-wide
+		 * fields, else fall back to brute force.
+		 */
+		if (sig->thread_group_times) {
+			thread_group_cputime(&thread_group_times, tsk->signal);
+			utime = thread_group_times.utime;
+			stime = thread_group_times.stime;
+		} else {
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
@@ -1490,15 +1501,12 @@ asmlinkage long sys_setrlimit(unsigned int resource, struct rlimit __user *rlim)
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
+		current->signal->rlim_expires =
+			secs_to_cputime(new_rlim.rlim_cur);
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

-- 
Frank Mayhar <fmayhar@google.com>
Google, Inc.

