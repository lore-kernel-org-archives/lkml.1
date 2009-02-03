Return-Path: <linux-kernel-owner+w=401wt.eu-S1753803AbZBCL41@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753803AbZBCL41 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 06:56:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751791AbZBCL4T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 06:56:19 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:38986 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750845AbZBCL4S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 06:56:18 -0500
Subject: [RFC] process wide itimer cruft
From: Peter Zijlstra <peterz@infradead.org>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Cc: Lin Ming <ming.m.lin@intel.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Oleg Nesterov <oleg@redhat.com>
In-Reply-To: <1233564818.4787.107.camel@laptop>
References: <1233473426.2604.13.camel@ymzhang>
	 <d3f22a0902010026q1db36381j36cb1c9803d48431@mail.gmail.com>
	 <1233476961.13659.12.camel@minggr.sh.intel.com>
	 <1233479836.4787.63.camel@laptop>  <1233482239.4787.65.camel@laptop>
	 <1233537134.2604.24.camel@ymzhang>  <1233564818.4787.107.camel@laptop>
Content-Type: text/plain
Date: Tue, 03 Feb 2009 12:56:05 +0100
Message-Id: <1233662165.10184.33.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-02-02 at 09:53 +0100, Peter Zijlstra wrote:

> Now the problems appears to be that I overlooked that we keep the itimer
> clock running at all times, not only when we have a pending timer, and I
> suppose that the standard mandates that behaviour :/

> I would rather go back to the old model where we iterate all threads,
> and find a way to not make programs with too many threads for their own
> good lock up the kernel, but instead get poor service.

OK, so I attempted something like that (sort-of boots) but exit.c makes
my head hurt.

I'm punting the sum-all-threads work off to a workqueue, now the problem
is that __exit_signal() needs ensurance that that worklet isn't
outstanding, or delay the freeing of signal struct until the worklet it
done.

We cannot use cancel_delayed_work_sync() because that can sleep, so I
tried the other approach, but it seems my put_signal() below is flawed
in that release_task() can be called by a 3rd party in case of ptrace.

The remaining option is to make signal struct itself rcu freed, but
before I do that, I thought I'd run this code by some folks.

Any comments?

Not-Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/init_task.h |    7 +++-
 include/linux/sched.h     |   10 ++++
 kernel/exit.c             |   33 ++++++++------
 kernel/sched.c            |  107 +++++++++++++++++++++++++++++++++++++++++++-
 kernel/sched_fair.c       |    1 -
 kernel/sched_rt.c         |    1 -
 kernel/sched_stats.h      |   91 --------------------------------------
 7 files changed, 138 insertions(+), 112 deletions(-)

diff --git a/include/linux/init_task.h b/include/linux/init_task.h
index fa50bdb..538c89e 100644
--- a/include/linux/init_task.h
+++ b/include/linux/init_task.h
@@ -14,6 +14,8 @@
 extern struct files_struct init_files;
 extern struct fs_struct init_fs;
 
+extern void do_thread_group_cputime_update(struct work_struct *work);
+
 #define INIT_KIOCTX(name, which_mm) \
 {							\
 	.users		= ATOMIC_INIT(1),		\
@@ -53,7 +55,10 @@ extern struct fs_struct init_fs;
 		.stime = cputime_zero,					\
 		.sum_exec_runtime = 0,					\
 		.lock = __SPIN_LOCK_UNLOCKED(sig.cputime.totals.lock),	\
-	}, },								\
+	},								\
+		.work = __DELAYED_WORK_INITIALIZER(sig.cputime.work,	\
+				      do_thread_group_cputime_update),	\
+	}, 								\
 }
 
 extern struct nsproxy init_nsproxy;
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 4cdec0d..1ced38c 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -478,6 +478,7 @@ struct task_cputime {
  */
 struct thread_group_cputime {
 	struct task_cputime totals;
+	struct delayed_work work;
 };
 
 /*
@@ -567,6 +568,7 @@ struct signal_struct {
 	 * in __exit_signal, except for the group leader.
 	 */
 	cputime_t cutime, cstime;
+	u64 cruntime;
 	cputime_t gtime;
 	cputime_t cgtime;
 	unsigned long nvcsw, nivcsw, cnvcsw, cnivcsw;
@@ -1949,6 +1951,7 @@ extern void exit_thread(void);
 extern void exit_files(struct task_struct *);
 extern void __cleanup_signal(struct signal_struct *);
 extern void __cleanup_sighand(struct sighand_struct *);
+extern void put_signal(struct signal_struct *sig);
 
 extern void exit_itimers(struct signal_struct *);
 extern void flush_itimer_signals(void);
@@ -2210,6 +2213,9 @@ static inline int spin_needbreak(spinlock_t *lock)
  * Thread group CPU time accounting.
  */
 
+extern void __thread_group_cputime_update(struct task_struct *p);
+extern void do_thread_group_cputime_update(struct work_struct *work);
+
 static inline
 void thread_group_cputime(struct task_struct *tsk, struct task_cputime *times)
 {
@@ -2217,6 +2223,7 @@ void thread_group_cputime(struct task_struct *tsk, struct task_cputime *times)
 	unsigned long flags;
 
 	spin_lock_irqsave(&totals->lock, flags);
+	__thread_group_cputime_update(tsk);
 	*times = *totals;
 	spin_unlock_irqrestore(&totals->lock, flags);
 }
@@ -2230,6 +2237,9 @@ static inline void thread_group_cputime_init(struct signal_struct *sig)
 	};
 
 	spin_lock_init(&sig->cputime.totals.lock);
+
+	INIT_DELAYED_WORK(&sig->cputime.work,
+			     do_thread_group_cputime_update);
 }
 
 static inline void thread_group_cputime_free(struct signal_struct *sig)
diff --git a/kernel/exit.c b/kernel/exit.c
index a1b18c0..899749e 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -81,6 +81,15 @@ static void __unhash_process(struct task_struct *p)
 	list_del_init(&p->sibling);
 }
 
+void put_signal(struct signal_struct *sig)
+{
+	if (atomic_dec_and_test(&sig->count)) {
+		flush_sigqueue(&sig->shared_pending);
+		taskstats_tgid_free(sig);
+		__cleanup_signal(sig);
+	}
+}
+
 /*
  * This function expects the tasklist_lock write-locked.
  */
@@ -96,14 +105,16 @@ static void __exit_signal(struct task_struct *tsk)
 	spin_lock(&sighand->siglock);
 
 	posix_cpu_timers_exit(tsk);
-	if (atomic_dec_and_test(&sig->count))
+	if (!atomic_read(&sig->live)) {
 		posix_cpu_timers_exit_group(tsk);
-	else {
+		sig->curr_target = NULL;
+	} else {
 		/*
 		 * If there is any task waiting for the group exit
 		 * then notify it:
 		 */
-		if (sig->group_exit_task && atomic_read(&sig->count) == sig->notify_count)
+		if (sig->group_exit_task &&
+				atomic_read(&sig->live) == sig->notify_count)
 			wake_up_process(sig->group_exit_task);
 
 		if (tsk == sig->curr_target)
@@ -126,7 +137,6 @@ static void __exit_signal(struct task_struct *tsk)
 		sig->inblock += task_io_get_inblock(tsk);
 		sig->oublock += task_io_get_oublock(tsk);
 		task_io_accounting_add(&sig->ioac, &tsk->ioac);
-		sig = NULL; /* Marker for below. */
 	}
 
 	__unhash_process(tsk);
@@ -142,17 +152,9 @@ static void __exit_signal(struct task_struct *tsk)
 	spin_unlock(&sighand->siglock);
 
 	__cleanup_sighand(sighand);
-	clear_tsk_thread_flag(tsk,TIF_SIGPENDING);
-	if (sig) {
-		flush_sigqueue(&sig->shared_pending);
-		taskstats_tgid_free(sig);
-		/*
-		 * Make sure ->signal can't go away under rq->lock,
-		 * see account_group_exec_runtime().
-		 */
-		task_rq_unlock_wait(tsk);
-		__cleanup_signal(sig);
-	}
+	clear_tsk_thread_flag(tsk, TIF_SIGPENDING);
+
+	put_signal(sig);
 }
 
 static void delayed_put_task_struct(struct rcu_head *rhp)
@@ -1329,6 +1331,7 @@ static int wait_task_zombie(struct task_struct *p, int options,
 			cputime_add(psig->cstime,
 			cputime_add(cputime.stime,
 				    sig->cstime));
+		psig->cruntime += cputime.sum_exec_runtime + sig->cruntime;
 		psig->cgtime =
 			cputime_add(psig->cgtime,
 			cputime_add(p->gtime,
diff --git a/kernel/sched.c b/kernel/sched.c
index 96439a4..2c21c12 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -4338,7 +4338,6 @@ void account_user_time(struct task_struct *p, cputime_t cputime,
 	/* Add user time to process. */
 	p->utime = cputime_add(p->utime, cputime);
 	p->utimescaled = cputime_add(p->utimescaled, cputime_scaled);
-	account_group_user_time(p, cputime);
 
 	/* Add user time to cpustat. */
 	tmp = cputime_to_cputime64(cputime);
@@ -4367,7 +4366,6 @@ static void account_guest_time(struct task_struct *p, cputime_t cputime,
 	/* Add guest time to process. */
 	p->utime = cputime_add(p->utime, cputime);
 	p->utimescaled = cputime_add(p->utimescaled, cputime_scaled);
-	account_group_user_time(p, cputime);
 	p->gtime = cputime_add(p->gtime, cputime);
 
 	/* Add guest time to cpustat. */
@@ -4396,7 +4394,6 @@ void account_system_time(struct task_struct *p, int hardirq_offset,
 	/* Add system time to process. */
 	p->stime = cputime_add(p->stime, cputime);
 	p->stimescaled = cputime_add(p->stimescaled, cputime_scaled);
-	account_group_system_time(p, cputime);
 
 	/* Add system time to cpustat. */
 	tmp = cputime_to_cputime64(cputime);
@@ -4442,6 +4439,108 @@ void account_idle_time(cputime_t cputime)
 #ifndef CONFIG_VIRT_CPU_ACCOUNTING
 
 /*
+ * Must be called with IRQs disabled, or from hardirq context.
+ */
+void __thread_group_cputime_update(struct task_struct *p)
+{
+	struct rq *rq = this_rq();
+	struct signal_struct *sig;
+
+	/*
+	 * Early boot might not have workqueues running yet.
+	 */
+	if (unlikely(system_state != SYSTEM_RUNNING))
+		return;
+
+	/*
+	 * Nobody cares about group cputimes for idle.
+	 */
+	if (unlikely(rq->idle == p))
+		return;
+
+	/*
+	 * Dead man walking.
+	 */
+	if (unlikely(p->exit_state))
+		return;
+
+	sig = p->signal;
+	/*
+	 * We raced with __exit_signal() and lost.
+	 */
+	if (unlikely(!sig))
+		return;
+
+	/*
+	 * __exit_signal() is ran with IRQs disabled, so when we have
+	 * a signal pointer, it must still be valid.
+	 */
+	if (schedule_delayed_work(&sig->cputime.work,
+				ilog2(atomic_read(&sig->live) / nr_cpu_ids)))
+		atomic_inc(&sig->count);
+}
+
+void do_thread_group_cputime_update(struct work_struct *work)
+{
+	struct task_cputime *totals;
+	struct signal_struct *sig;
+	struct task_struct *t, *n;
+	unsigned long flags;
+
+	cputime_t utime = cputime_zero, stime = cputime_zero;
+	u64 runtime = 0;
+
+	sig = container_of(work, struct signal_struct, cputime.work.work);
+
+	rcu_read_lock();
+	n = t = sig->curr_target;
+	if (n) do {
+		/*
+		 * Dead tasks come later.
+		 */
+		if (unlikely(n->exit_state))
+			goto next;
+
+		/*
+		 * Add time for each task.
+		 */
+		stime = cputime_add(stime, n->stime);
+		utime = cputime_add(utime, n->utime);
+		runtime += n->se.sum_exec_runtime;
+
+next:
+		n = next_thread(n);
+	} while (n != t);
+
+	/*
+	 * Add accumulated time of dead tasks.
+	 *
+	 * There is a risk we missed a task which was dying but hasn't
+	 * been added to the accumulated time yet, too bad, better luck
+	 * next time we try.
+	 */
+	stime = cputime_add(stime, sig->cstime);
+	utime = cputime_add(utime, sig->cutime);
+	runtime += sig->cruntime;
+
+	/*
+	 * Ensure time goes forward.
+	 */
+	totals = &sig->cputime.totals;
+	spin_lock_irqsave(&totals->lock, flags);
+	if (cputime_gt(stime, totals->stime))
+		totals->stime = stime;
+	if (cputime_gt(utime, totals->utime))
+		totals->utime = utime;
+	if (runtime > totals->sum_exec_runtime)
+		totals->sum_exec_runtime = runtime;
+	spin_unlock_irqrestore(&totals->lock, flags);
+	rcu_read_unlock();
+
+	put_signal(sig);
+}
+
+/*
  * Account a single tick of cpu time.
  * @p: the process that the cpu time gets accounted to
  * @user_tick: indicates if the tick is a user or a system tick
@@ -4459,6 +4558,8 @@ void account_process_tick(struct task_struct *p, int user_tick)
 				    one_jiffy_scaled);
 	else
 		account_idle_time(one_jiffy);
+
+	__thread_group_cputime_update(p);
 }
 
 /*
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index bc1563e..5fe3b3d 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -499,7 +499,6 @@ static void update_curr(struct cfs_rq *cfs_rq)
 		struct task_struct *curtask = task_of(curr);
 
 		cpuacct_charge(curtask, delta_exec);
-		account_group_exec_runtime(curtask, delta_exec);
 	}
 }
 
diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index 299d012..607951e 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -581,7 +581,6 @@ static void update_curr_rt(struct rq *rq)
 	schedstat_set(curr->se.exec_max, max(curr->se.exec_max, delta_exec));
 
 	curr->se.sum_exec_runtime += delta_exec;
-	account_group_exec_runtime(curr, delta_exec);
 
 	curr->se.exec_start = rq->clock;
 	cpuacct_charge(curr, delta_exec);
diff --git a/kernel/sched_stats.h b/kernel/sched_stats.h
index 8ab0cef..9831d8c 100644
--- a/kernel/sched_stats.h
+++ b/kernel/sched_stats.h
@@ -276,94 +276,3 @@ sched_info_switch(struct task_struct *prev, struct task_struct *next)
 #define sched_info_dequeued(t)			do { } while (0)
 #define sched_info_switch(t, next)		do { } while (0)
 #endif /* CONFIG_SCHEDSTATS || CONFIG_TASK_DELAY_ACCT */
-
-/*
- * The following are functions that support scheduler-internal time accounting.
- * These functions are generally called at the timer tick.  None of this depends
- * on CONFIG_SCHEDSTATS.
- */
-
-/**
- * account_group_user_time - Maintain utime for a thread group.
- *
- * @tsk:	Pointer to task structure.
- * @cputime:	Time value by which to increment the utime field of the
- *		thread_group_cputime structure.
- *
- * If thread group time is being maintained, get the structure for the
- * running CPU and update the utime field there.
- */
-static inline void account_group_user_time(struct task_struct *tsk,
-					   cputime_t cputime)
-{
-	struct task_cputime *times;
-	struct signal_struct *sig;
-
-	/* tsk == current, ensure it is safe to use ->signal */
-	if (unlikely(tsk->exit_state))
-		return;
-
-	sig = tsk->signal;
-	times = &sig->cputime.totals;
-
-	spin_lock(&times->lock);
-	times->utime = cputime_add(times->utime, cputime);
-	spin_unlock(&times->lock);
-}
-
-/**
- * account_group_system_time - Maintain stime for a thread group.
- *
- * @tsk:	Pointer to task structure.
- * @cputime:	Time value by which to increment the stime field of the
- *		thread_group_cputime structure.
- *
- * If thread group time is being maintained, get the structure for the
- * running CPU and update the stime field there.
- */
-static inline void account_group_system_time(struct task_struct *tsk,
-					     cputime_t cputime)
-{
-	struct task_cputime *times;
-	struct signal_struct *sig;
-
-	/* tsk == current, ensure it is safe to use ->signal */
-	if (unlikely(tsk->exit_state))
-		return;
-
-	sig = tsk->signal;
-	times = &sig->cputime.totals;
-
-	spin_lock(&times->lock);
-	times->stime = cputime_add(times->stime, cputime);
-	spin_unlock(&times->lock);
-}
-
-/**
- * account_group_exec_runtime - Maintain exec runtime for a thread group.
- *
- * @tsk:	Pointer to task structure.
- * @ns:		Time value by which to increment the sum_exec_runtime field
- *		of the thread_group_cputime structure.
- *
- * If thread group time is being maintained, get the structure for the
- * running CPU and update the sum_exec_runtime field there.
- */
-static inline void account_group_exec_runtime(struct task_struct *tsk,
-					      unsigned long long ns)
-{
-	struct task_cputime *times;
-	struct signal_struct *sig;
-
-	sig = tsk->signal;
-	/* see __exit_signal()->task_rq_unlock_wait() */
-	barrier();
-	if (unlikely(!sig))
-		return;
-
-	times = &sig->cputime.totals;
-
-	spin_lock(&times->lock);
-	times->sum_exec_runtime += ns;
-	spin_unlock(&times->lock);
-}


