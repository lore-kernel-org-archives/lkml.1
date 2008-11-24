Return-Path: <linux-kernel-owner+w=401wt.eu-S1754012AbYKXQHg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754012AbYKXQHg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 11:07:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753158AbYKXQH1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 11:07:27 -0500
Received: from casper.infradead.org ([85.118.1.10]:39489 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753070AbYKXQH0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 11:07:26 -0500
Subject: Re: regression introduced by - timers: fix itimer/many thread hang
From: Peter Zijlstra <peterz@infradead.org>
To: Petr Tesarik <ptesarik@suse.cz>
Cc: Frank Mayhar <fmayhar@google.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Doug Chapman <doug.chapman@hp.com>, mingo@elte.hu, roland@redhat.com,
       adobriyan@gmail.com, akpm@linux-foundation.org,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <1227531589.4259.117.camel@twins>
References: <1224694989.8431.23.camel@oberon>
	 <1226015568.2186.20.camel@bobble.smo.corp.google.com>
	 <1226053744.7803.5851.camel@twins>  <200811211942.43848.ptesarik@suse.cz>
	 <1227450296.7685.20759.camel@twins>
	 <1227516403.4487.20.camel@nathan.suse.cz>
	 <1227519208.7685.21951.camel@twins>
	 <1227529968.4487.45.camel@nathan.suse.cz> <1227531589.4259.117.camel@twins>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Mon, 24 Nov 2008 17:06:57 +0100
Message-Id: <1227542817.4259.341.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-11-24 at 13:59 +0100, Peter Zijlstra wrote:
>  I'll look into
> whipping up a patch removing all the per-cpu crap from there.

Remove the per-cpu-ish-ness from the itimer stuff.

Either we bounce once cacheline per cpu per tick, yielding n^2 bounces
or we just bounce a single..

Also, using per-cpu allocations for the thread-groups complicates the
per-cpu allocator in that its currently aimed to be a fixed sized
allocator and the only possible extention to that would be vmap based,
which is seriously constrained on 32 bit archs.

So making the per-cpu memory requirement depend on the number of
processes is an issue.

Lastly, it didn't deal with cpu-hotplug, although admittedly that might
be fixable.

---
 include/linux/init_task.h |    6 ++++
 include/linux/sched.h     |   29 +++++++++++-------
 kernel/fork.c             |   15 ++++-----
 kernel/posix-cpu-timers.c |   70 ---------------------------------------------
 kernel/sched_fair.c       |   13 ++++----
 kernel/sched_stats.h      |   33 +++++++++-----------
 6 files changed, 52 insertions(+), 114 deletions(-)

diff --git a/include/linux/init_task.h b/include/linux/init_task.h
index 23fd890..e9e5313 100644
--- a/include/linux/init_task.h
+++ b/include/linux/init_task.h
@@ -47,6 +47,12 @@ extern struct files_struct init_files;
 	.posix_timers	 = LIST_HEAD_INIT(sig.posix_timers),		\
 	.cpu_timers	= INIT_CPU_TIMERS(sig.cpu_timers),		\
 	.rlim		= INIT_RLIMITS,					\
+	.cputime	= { .totals = {					\
+		.utime = cputime_zero,					\
+		.stime = cputime_zero,					\
+		.sum_exec_runtime = 0,					\
+		.lock = __SPIN_LOCK_UNLOCKED(sig.cputime.totals.lock),	\
+	}, },								\
 }
 
 extern struct nsproxy init_nsproxy;
diff --git a/include/linux/sched.h b/include/linux/sched.h
index e22cb72..6a65f04 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -447,6 +447,7 @@ struct task_cputime {
 	cputime_t utime;
 	cputime_t stime;
 	unsigned long long sum_exec_runtime;
+	spinlock_t lock;
 };
 /* Alternate field names when used to cache expirations. */
 #define prof_exp	stime
@@ -462,7 +463,7 @@ struct task_cputime {
  * used for thread group CPU clock calculations.
  */
 struct thread_group_cputime {
-	struct task_cputime *totals;
+	struct task_cputime totals;
 };
 
 /*
@@ -2159,24 +2160,30 @@ static inline int spin_needbreak(spinlock_t *lock)
  * Thread group CPU time accounting.
  */
 
-extern int thread_group_cputime_alloc(struct task_struct *);
-extern void thread_group_cputime(struct task_struct *, struct task_cputime *);
-
-static inline void thread_group_cputime_init(struct signal_struct *sig)
+static inline
+void thread_group_cputime(struct task_struct *tsk, struct task_cputime *times)
 {
-	sig->cputime.totals = NULL;
+	struct task_cputime *totals = &tsk->signal->cputime.totals;
+	unsigned long flags;
+
+	spin_lock_irqsave(&totals->lock, flags);
+	*times = *totals;
+	spin_unlock_irqrestore(&totals->lock, flags);
 }
 
-static inline int thread_group_cputime_clone_thread(struct task_struct *curr)
+static inline void thread_group_cputime_init(struct signal_struct *sig)
 {
-	if (curr->signal->cputime.totals)
-		return 0;
-	return thread_group_cputime_alloc(curr);
+	sig->cputime.totals = (struct task_cputime){
+		.utime = cputime_zero,
+		.stime = cputime_zero,
+		.sum_exec_runtime = 0,
+	};
+
+	spin_lock_init(&sig->cputime.totals.lock);
 }
 
 static inline void thread_group_cputime_free(struct signal_struct *sig)
 {
-	free_percpu(sig->cputime.totals);
 }
 
 /*
diff --git a/kernel/fork.c b/kernel/fork.c
index d183739..218513b 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -812,14 +812,15 @@ static int copy_signal(unsigned long clone_flags, struct task_struct *tsk)
 	int ret;
 
 	if (clone_flags & CLONE_THREAD) {
-		ret = thread_group_cputime_clone_thread(current);
-		if (likely(!ret)) {
-			atomic_inc(&current->signal->count);
-			atomic_inc(&current->signal->live);
-		}
-		return ret;
+		atomic_inc(&current->signal->count);
+		atomic_inc(&current->signal->live);
+		return 0;
 	}
 	sig = kmem_cache_alloc(signal_cachep, GFP_KERNEL);
+
+	if (sig)
+		posix_cpu_timers_init_group(sig);
+
 	tsk->signal = sig;
 	if (!sig)
 		return -ENOMEM;
@@ -862,8 +863,6 @@ static int copy_signal(unsigned long clone_flags, struct task_struct *tsk)
 	memcpy(sig->rlim, current->signal->rlim, sizeof sig->rlim);
 	task_unlock(current->group_leader);
 
-	posix_cpu_timers_init_group(sig);
-
 	acct_init_pacct(&sig->pacct);
 
 	tty_audit_fork(sig);
diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
index 3f4377e..53dafd6 100644
--- a/kernel/posix-cpu-timers.c
+++ b/kernel/posix-cpu-timers.c
@@ -10,76 +10,6 @@
 #include <linux/kernel_stat.h>
 
 /*
- * Allocate the thread_group_cputime structure appropriately and fill in the
- * current values of the fields.  Called from copy_signal() via
- * thread_group_cputime_clone_thread() when adding a second or subsequent
- * thread to a thread group.  Assumes interrupts are enabled when called.
- */
-int thread_group_cputime_alloc(struct task_struct *tsk)
-{
-	struct signal_struct *sig = tsk->signal;
-	struct task_cputime *cputime;
-
-	/*
-	 * If we have multiple threads and we don't already have a
-	 * per-CPU task_cputime struct (checked in the caller), allocate
-	 * one and fill it in with the times accumulated so far.  We may
-	 * race with another thread so recheck after we pick up the sighand
-	 * lock.
-	 */
-	cputime = alloc_percpu(struct task_cputime);
-	if (cputime == NULL)
-		return -ENOMEM;
-	spin_lock_irq(&tsk->sighand->siglock);
-	if (sig->cputime.totals) {
-		spin_unlock_irq(&tsk->sighand->siglock);
-		free_percpu(cputime);
-		return 0;
-	}
-	sig->cputime.totals = cputime;
-	cputime = per_cpu_ptr(sig->cputime.totals, smp_processor_id());
-	cputime->utime = tsk->utime;
-	cputime->stime = tsk->stime;
-	cputime->sum_exec_runtime = tsk->se.sum_exec_runtime;
-	spin_unlock_irq(&tsk->sighand->siglock);
-	return 0;
-}
-
-/**
- * thread_group_cputime - Sum the thread group time fields across all CPUs.
- *
- * @tsk:	The task we use to identify the thread group.
- * @times:	task_cputime structure in which we return the summed fields.
- *
- * Walk the list of CPUs to sum the per-CPU time fields in the thread group
- * time structure.
- */
-void thread_group_cputime(
-	struct task_struct *tsk,
-	struct task_cputime *times)
-{
-	struct task_cputime *totals, *tot;
-	int i;
-
-	totals = tsk->signal->cputime.totals;
-	if (!totals) {
-		times->utime = tsk->utime;
-		times->stime = tsk->stime;
-		times->sum_exec_runtime = tsk->se.sum_exec_runtime;
-		return;
-	}
-
-	times->stime = times->utime = cputime_zero;
-	times->sum_exec_runtime = 0;
-	for_each_possible_cpu(i) {
-		tot = per_cpu_ptr(totals, i);
-		times->utime = cputime_add(times->utime, tot->utime);
-		times->stime = cputime_add(times->stime, tot->stime);
-		times->sum_exec_runtime += tot->sum_exec_runtime;
-	}
-}
-
-/*
  * Called after updating RLIMIT_CPU to set timer expiration if necessary.
  */
 void update_rlimit_cpu(unsigned long rlim_new)
diff --git a/kernel/sched_stats.h b/kernel/sched_stats.h
index 7dbf72a..ba7714f 100644
--- a/kernel/sched_stats.h
+++ b/kernel/sched_stats.h
@@ -296,6 +296,7 @@ sched_info_switch(struct task_struct *prev, struct task_struct *next)
 static inline void account_group_user_time(struct task_struct *tsk,
 					   cputime_t cputime)
 {
+	struct task_cputime *times;
 	struct signal_struct *sig;
 
 	/* tsk == current, ensure it is safe to use ->signal */
@@ -303,13 +304,11 @@ static inline void account_group_user_time(struct task_struct *tsk,
 		return;
 
 	sig = tsk->signal;
-	if (sig->cputime.totals) {
-		struct task_cputime *times;
+	times = &sig->cputime.totals;
 
-		times = per_cpu_ptr(sig->cputime.totals, get_cpu());
-		times->utime = cputime_add(times->utime, cputime);
-		put_cpu_no_resched();
-	}
+	spin_lock(&times->lock);
+	times->utime = cputime_add(times->utime, cputime);
+	spin_unlock(&times->lock);
 }
 
 /**
@@ -325,6 +324,7 @@ static inline void account_group_user_time(struct task_struct *tsk,
 static inline void account_group_system_time(struct task_struct *tsk,
 					     cputime_t cputime)
 {
+	struct task_cputime *times;
 	struct signal_struct *sig;
 
 	/* tsk == current, ensure it is safe to use ->signal */
@@ -332,13 +332,11 @@ static inline void account_group_system_time(struct task_struct *tsk,
 		return;
 
 	sig = tsk->signal;
-	if (sig->cputime.totals) {
-		struct task_cputime *times;
+	times = &sig->cputime.totals;
 
-		times = per_cpu_ptr(sig->cputime.totals, get_cpu());
-		times->stime = cputime_add(times->stime, cputime);
-		put_cpu_no_resched();
-	}
+	spin_lock(&times->lock);
+	times->stime = cputime_add(times->stime, cputime);
+	spin_unlock(&times->lock);
 }
 
 /**
@@ -354,6 +352,7 @@ static inline void account_group_system_time(struct task_struct *tsk,
 static inline void account_group_exec_runtime(struct task_struct *tsk,
 					      unsigned long long ns)
 {
+	struct task_cputime *times;
 	struct signal_struct *sig;
 
 	sig = tsk->signal;
@@ -362,11 +361,9 @@ static inline void account_group_exec_runtime(struct task_struct *tsk,
 	if (unlikely(!sig))
 		return;
 
-	if (sig->cputime.totals) {
-		struct task_cputime *times;
+	times = &sig->cputime.totals;
 
-		times = per_cpu_ptr(sig->cputime.totals, get_cpu());
-		times->sum_exec_runtime += ns;
-		put_cpu_no_resched();
-	}
+	spin_lock(&times->lock);
+	times->sum_exec_runtime += ns;
+	spin_unlock(&times->lock);
 }

