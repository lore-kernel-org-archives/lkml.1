Return-Path: <linux-kernel-owner+w=401wt.eu-S1764033AbZFLKp5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764033AbZFLKp5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 06:45:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753569AbZFLKpk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 06:45:40 -0400
Received: from mx2.redhat.com ([66.187.237.31]:50015 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755642AbZFLKpi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 06:45:38 -0400
Date: Fri, 12 Jun 2009 12:39:03 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Oleg Nesterov <oleg@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Subject: [RFC PATCH] posix-cpu-timers: optimize calling
 thread_group_cputime()
Message-ID: <20090612123903.37cfd868@dhcp-lab-109.englab.brq.redhat.com>
Organization: RedHat
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When we call thread_group_cputime() we not always need all 3 cputime values. 
Use additional mask to specify which fields of struct task_cputime is caller
interested. Similarly cputimer is changed to  make cputimer->running mask
of currently accounted cpu times.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 fs/binfmt_elf.c           |    3 +-
 fs/binfmt_elf_fdpic.c     |    2 +-
 fs/proc/array.c           |    4 ++-
 include/linux/sched.h     |   12 +++++++++-
 kernel/exit.c             |    3 +-
 kernel/fork.c             |    2 +-
 kernel/itimer.c           |    6 +++-
 kernel/posix-cpu-timers.c |   48 +++++++++++++++++++++++++++++---------------
 kernel/sched.c            |    2 +-
 kernel/sched_stats.h      |    6 ++--
 kernel/sys.c              |    7 ++++-
 11 files changed, 63 insertions(+), 32 deletions(-)

diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index 40381df..d5f4efd 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -1351,7 +1351,8 @@ static void fill_prstatus(struct elf_prstatus *prstatus,
 		 * This is the record for the group leader.  It shows the
 		 * group-wide total, not its individual thread total.
 		 */
-		thread_group_cputime(p, &cputime);
+		thread_group_cputime(p, &cputime,
+				     TG_CPUCLOCK_UTIME | TG_CPUCLOCK_STIME);
 		cputime_to_timeval(cputime.utime, &prstatus->pr_utime);
 		cputime_to_timeval(cputime.stime, &prstatus->pr_stime);
 	} else {
diff --git a/fs/binfmt_elf_fdpic.c b/fs/binfmt_elf_fdpic.c
index fdb66fa..004a141 100644
--- a/fs/binfmt_elf_fdpic.c
+++ b/fs/binfmt_elf_fdpic.c
@@ -1398,7 +1398,7 @@ static void fill_prstatus(struct elf_prstatus *prstatus,
 		 * This is the record for the group leader.  It shows the
 		 * group-wide total, not its individual thread total.
 		 */
-		thread_group_cputime(p, &cputime);
+		thread_group_cputime(p, &cputime, TG_UTIME | TG_STIME);
 		cputime_to_timeval(cputime.utime, &prstatus->pr_utime);
 		cputime_to_timeval(cputime.stime, &prstatus->pr_stime);
 	} else {
diff --git a/fs/proc/array.c b/fs/proc/array.c
index 725a650..c517495 100644
--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@ -416,7 +416,9 @@ static int do_task_stat(struct seq_file *m, struct pid_namespace *ns,
 
 			min_flt += sig->min_flt;
 			maj_flt += sig->maj_flt;
-			thread_group_cputime(task, &cputime);
+			thread_group_cputime(task, &cputime,
+					     TG_CPUCLOCK_UTIME |
+					     TG_CPUCLOCK_STIME);
 			utime = cputime.utime;
 			stime = cputime.stime;
 			gtime = cputime_add(gtime, sig->gtime);
diff --git a/include/linux/sched.h b/include/linux/sched.h
index d139966..872974a 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2267,8 +2267,16 @@ static inline int spin_needbreak(spinlock_t *lock)
 /*
  * Thread group CPU time accounting.
  */
-void thread_group_cputime(struct task_struct *tsk, struct task_cputime *times);
-void thread_group_cputimer(struct task_struct *tsk, struct task_cputime *times);
+
+#define TG_CPUCLOCK_UTIME 0x1
+#define TG_CPUCLOCK_STIME 0x2
+#define TG_CPUCLOCK_SCHED 0x4
+#define TG_CPUCLOCK_ALL   0x7
+
+void thread_group_cputime(struct task_struct *tsk, struct task_cputime *times,
+			  int mask);
+void thread_group_cputimer(struct task_struct *tsk, struct task_cputime *times,
+			   int mask);
 
 static inline void thread_group_cputime_init(struct signal_struct *sig)
 {
diff --git a/kernel/exit.c b/kernel/exit.c
index cab535c..155c4cd 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -1205,7 +1205,8 @@ static int wait_task_zombie(struct task_struct *p, int options,
 		 * group, which consolidates times for all threads in the
 		 * group including the group leader.
 		 */
-		thread_group_cputime(p, &cputime);
+		thread_group_cputime(p, &cputime,
+				     TG_CPUCLOCK_UTIME | TG_CPUCLOCK_STIME);
 		spin_lock_irq(&p->parent->sighand->siglock);
 		psig = p->parent->signal;
 		sig = p->signal;
diff --git a/kernel/fork.c b/kernel/fork.c
index bb762b4..4229223 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -802,7 +802,7 @@ static void posix_cpu_timers_init_group(struct signal_struct *sig)
 	if (sig->rlim[RLIMIT_CPU].rlim_cur != RLIM_INFINITY) {
 		sig->cputime_expires.prof_exp =
 			secs_to_cputime(sig->rlim[RLIMIT_CPU].rlim_cur);
-		sig->cputimer.running = 1;
+		sig->cputimer.running = TG_CPUCLOCK_SCHED;
 	}
 
 	/* The timer lists. */
diff --git a/kernel/itimer.c b/kernel/itimer.c
index 58762f7..0e29bd6 100644
--- a/kernel/itimer.c
+++ b/kernel/itimer.c
@@ -62,7 +62,7 @@ int do_getitimer(int which, struct itimerval *value)
 			struct task_cputime cputime;
 			cputime_t utime;
 
-			thread_group_cputimer(tsk, &cputime);
+			thread_group_cputimer(tsk, &cputime, TG_CPUCLOCK_UTIME);
 			utime = cputime.utime;
 			if (cputime_le(cval, utime)) { /* about to fire */
 				cval = jiffies_to_cputime(1);
@@ -82,7 +82,9 @@ int do_getitimer(int which, struct itimerval *value)
 			struct task_cputime times;
 			cputime_t ptime;
 
-			thread_group_cputimer(tsk, &times);
+			thread_group_cputimer(tsk, &times,
+					      TG_CPUCLOCK_UTIME |
+					      TG_CPUCLOCK_STIME);
 			ptime = cputime_add(times.utime, times.stime);
 			if (cputime_le(cval, ptime)) { /* about to fire */
 				cval = jiffies_to_cputime(1);
diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
index 1d9cdf3..b5f1b44 100644
--- a/kernel/posix-cpu-timers.c
+++ b/kernel/posix-cpu-timers.c
@@ -230,7 +230,8 @@ static int cpu_clock_sample(const clockid_t which_clock, struct task_struct *p,
 	return 0;
 }
 
-void thread_group_cputime(struct task_struct *tsk, struct task_cputime *times)
+void thread_group_cputime(struct task_struct *tsk, struct task_cputime *times,
+			  int mask)
 {
 	struct sighand_struct *sighand;
 	struct signal_struct *sig;
@@ -247,16 +248,22 @@ void thread_group_cputime(struct task_struct *tsk, struct task_cputime *times)
 
 	t = tsk;
 	do {
-		times->utime = cputime_add(times->utime, t->utime);
-		times->stime = cputime_add(times->stime, t->stime);
-		times->sum_exec_runtime += t->se.sum_exec_runtime;
+		if (mask & TG_CPUCLOCK_UTIME)
+			times->utime = cputime_add(times->utime, t->utime);
+		if (mask & TG_CPUCLOCK_STIME)
+			times->stime = cputime_add(times->stime, t->stime);
+		if (mask & TG_CPUCLOCK_SCHED)
+			times->sum_exec_runtime += t->se.sum_exec_runtime;
 
 		t = next_thread(t);
 	} while (t != tsk);
 
-	times->utime = cputime_add(times->utime, sig->utime);
-	times->stime = cputime_add(times->stime, sig->stime);
-	times->sum_exec_runtime += sig->sum_sched_runtime;
+	if (mask & TG_CPUCLOCK_UTIME)
+		times->utime = cputime_add(times->utime, sig->utime);
+	if (mask & TG_CPUCLOCK_STIME)
+		times->stime = cputime_add(times->stime, sig->stime);
+	if (mask & TG_CPUCLOCK_SCHED)
+		times->sum_exec_runtime += sig->sum_sched_runtime;
 out:
 	rcu_read_unlock();
 }
@@ -273,22 +280,25 @@ static void update_gt_cputime(struct task_cputime *a, struct task_cputime *b)
 		a->sum_exec_runtime = b->sum_exec_runtime;
 }
 
-void thread_group_cputimer(struct task_struct *tsk, struct task_cputime *times)
+void thread_group_cputimer(struct task_struct *tsk, struct task_cputime *times,
+			   int mask)
 {
 	struct thread_group_cputimer *cputimer = &tsk->signal->cputimer;
 	struct task_cputime sum;
 	unsigned long flags;
+	int new_clocks;
 
 	spin_lock_irqsave(&cputimer->lock, flags);
-	if (!cputimer->running) {
-		cputimer->running = 1;
+	if ((cputimer->running & mask) != mask) {
+		new_clocks = (cputimer->running ^ mask) & mask;
+		cputimer->running |= mask;
 		/*
 		 * The POSIX timer interface allows for absolute time expiry
 		 * values through the TIMER_ABSTIME flag, therefore we have
 		 * to synchronize the timer to the clock every time we start
 		 * it.
 		 */
-		thread_group_cputime(tsk, &sum);
+		thread_group_cputime(tsk, &sum, new_clocks);
 		update_gt_cputime(&cputimer->cputime, &sum);
 	}
 	*times = cputimer->cputime;
@@ -309,11 +319,12 @@ static int cpu_clock_sample_group(const clockid_t which_clock,
 	default:
 		return -EINVAL;
 	case CPUCLOCK_PROF:
-		thread_group_cputime(p, &cputime);
+		thread_group_cputime(p, &cputime,
+				     TG_CPUCLOCK_STIME | TG_CPUCLOCK_UTIME);
 		cpu->cpu = cputime_add(cputime.utime, cputime.stime);
 		break;
 	case CPUCLOCK_VIRT:
-		thread_group_cputime(p, &cputime);
+		thread_group_cputime(p, &cputime, TG_CPUCLOCK_UTIME);
 		cpu->cpu = cputime.utime;
 		break;
 	case CPUCLOCK_SCHED:
@@ -523,7 +534,7 @@ void posix_cpu_timers_exit_group(struct task_struct *tsk)
 {
 	struct task_cputime cputime;
 
-	thread_group_cputimer(tsk, &cputime);
+	thread_group_cputimer(tsk, &cputime, TG_CPUCLOCK_ALL);
 	cleanup_timers(tsk->signal->cpu_timers,
 		       cputime.utime, cputime.stime, cputime.sum_exec_runtime);
 }
@@ -691,17 +702,20 @@ static int cpu_timer_sample_group(const clockid_t which_clock,
 {
 	struct task_cputime cputime;
 
-	thread_group_cputimer(p, &cputime);
 	switch (CPUCLOCK_WHICH(which_clock)) {
 	default:
 		return -EINVAL;
 	case CPUCLOCK_PROF:
+		thread_group_cputimer(p, &cputime,
+				      TG_CPUCLOCK_UTIME | TG_CPUCLOCK_STIME);
 		cpu->cpu = cputime_add(cputime.utime, cputime.stime);
 		break;
 	case CPUCLOCK_VIRT:
+		thread_group_cputimer(p, &cputime, TG_CPUCLOCK_UTIME);
 		cpu->cpu = cputime.utime;
 		break;
 	case CPUCLOCK_SCHED:
+		thread_group_cputimer(p, &cputime, TG_CPUCLOCK_SCHED);
 		cpu->sched = cputime.sum_exec_runtime + task_delta_exec(p);
 		break;
 	}
@@ -1101,7 +1115,7 @@ static void check_process_timers(struct task_struct *tsk,
 	/*
 	 * Collect the current process totals.
 	 */
-	thread_group_cputimer(tsk, &cputime);
+	thread_group_cputimer(tsk, &cputime, TG_CPUCLOCK_ALL);
 	utime = cputime.utime;
 	ptime = cputime_add(utime, cputime.stime);
 	sum_sched_runtime = cputime.sum_exec_runtime;
@@ -1367,7 +1381,7 @@ static inline int fastpath_timer_check(struct task_struct *tsk)
 	if (!task_cputime_zero(&sig->cputime_expires)) {
 		struct task_cputime group_sample;
 
-		thread_group_cputimer(tsk, &group_sample);
+		thread_group_cputimer(tsk, &group_sample, TG_CPUCLOCK_ALL);
 		if (task_cputime_expired(&group_sample, &sig->cputime_expires))
 			return 1;
 	}
diff --git a/kernel/sched.c b/kernel/sched.c
index 14c447a..fe6e0ac 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -4828,7 +4828,7 @@ unsigned long long thread_group_sched_runtime(struct task_struct *p)
 	u64 ns;
 
 	rq = task_rq_lock(p, &flags);
-	thread_group_cputime(p, &totals);
+	thread_group_cputime(p, &totals, TG_CPUCLOCK_SCHED);
 	ns = totals.sum_exec_runtime + do_task_delta_exec(p, rq);
 	task_rq_unlock(rq, &flags);
 
diff --git a/kernel/sched_stats.h b/kernel/sched_stats.h
index 32d2bd4..9156e44 100644
--- a/kernel/sched_stats.h
+++ b/kernel/sched_stats.h
@@ -303,7 +303,7 @@ static inline void account_group_user_time(struct task_struct *tsk,
 
 	cputimer = &tsk->signal->cputimer;
 
-	if (!cputimer->running)
+	if (!(cputimer->running & TG_CPUCLOCK_UTIME))
 		return;
 
 	spin_lock(&cputimer->lock);
@@ -333,7 +333,7 @@ static inline void account_group_system_time(struct task_struct *tsk,
 
 	cputimer = &tsk->signal->cputimer;
 
-	if (!cputimer->running)
+	if (!(cputimer->running & TG_CPUCLOCK_STIME))
 		return;
 
 	spin_lock(&cputimer->lock);
@@ -366,7 +366,7 @@ static inline void account_group_exec_runtime(struct task_struct *tsk,
 
 	cputimer = &sig->cputimer;
 
-	if (!cputimer->running)
+	if (!(cputimer->running & TG_CPUCLOCK_SCHED))
 		return;
 
 	spin_lock(&cputimer->lock);
diff --git a/kernel/sys.c b/kernel/sys.c
index 0805d08..69d64f0 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -914,7 +914,8 @@ void do_sys_times(struct tms *tms)
 	cputime_t cutime, cstime;
 
 	spin_lock_irq(&current->sighand->siglock);
-	thread_group_cputime(current, &cputime);
+	thread_group_cputime(current, &cputime,
+			     TG_CPUCLOCK_UTIME | TG_CPUCLOCK_STIME);
 	cutime = current->signal->cutime;
 	cstime = current->signal->cstime;
 	spin_unlock_irq(&current->sighand->siglock);
@@ -1650,7 +1651,9 @@ static void k_getrusage(struct task_struct *p, int who, struct rusage *r)
 				break;
 
 		case RUSAGE_SELF:
-			thread_group_cputime(p, &cputime);
+			thread_group_cputime(p, &cputime,
+					     TG_CPUCLOCK_UTIME |
+					     TG_CPUCLOCK_STIME);
 			utime = cputime_add(utime, cputime.utime);
 			stime = cputime_add(stime, cputime.stime);
 			r->ru_nvcsw += p->signal->nvcsw;
-- 
1.6.0.6

