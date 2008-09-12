Return-Path: <linux-kernel-owner+w=401wt.eu-S1757208AbYILQ4n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757208AbYILQ4n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 12:56:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753496AbYILQ4c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 12:56:32 -0400
Received: from smtp-out.google.com ([216.239.33.17]:45810 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752863AbYILQ42 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 12:56:28 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=subject:from:to:cc:content-type:organization:date:
	message-id:mime-version:x-mailer:content-transfer-encoding;
	b=xauf3iGVW4m4n7Z5+m2jRqXqCReyuS+LKyXRT4sQvXiSZl+3ls/xC2n1PwmUzJU7r
	IZvnLnLTmA0BRn1+coP9Q==
Subject: [PATCH 2.6.27-rc5 resubmit] Fix itimer/many thread hang.
From: Frank Mayhar <fmayhar@google.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Roland McGrath <roland@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain
Organization: Google, Inc.
Date: Fri, 12 Sep 2008 09:54:39 -0700
Message-Id: <1221238479.30136.2.camel@bobble.smo.corp.google.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a resubmission of the posix timer rework patch, posted a few days ago.
This addresses Oleg Nesterov's comments, removing the RCU stuff from the patch
and un-inlining the thread_group_cputime() function for SMP.  I left the
function itself as an inline defined in sched.h but the SMP version just calls
thread_group_cputime_smp() which is defined in posix-cpu-timers.c.  (The UP
version was a one-liner; I left it as an inline.)

The original README follows (to keep it together with the patch itself):


Overview

This patch reworks the handling of POSIX CPU timers, including the
ITIMER_PROF, ITIMER_VIRT timers and rlimit handling.  It was put together
with the help of Roland McGrath, the owner and original writer of this code.

The problem we ran into, and the reason for this rework, has to do with using
a profiling timer in a process with a large number of threads.  It appears
that the performance of the old implementation of run_posix_cpu_timers() was
at least O(n*3) (where "n" is the number of threads in a process) or worse.
Everything is fine with an increasing number of threads until the time taken
for that routine to run becomes the same as or greater than the tick time, at
which point things degrade rather quickly.

This patch fixes bug 9906, "Weird hang with NPTL and SIGPROF."


Code Changes

This rework corrects the implementation of run_posix_cpu_timers() to make it
run in constant time for a particular machine.  (Performance may vary between
one machine and another depending upon whether the kernel is built as single-
or multiprocessor and, in the latter case, depending upon the number of
running processors.)  To do this, at each tick we now update fields in
signal_struct as well as task_struct.  The run_posix_cpu_timers() function
uses those fields to make its decisions.

We define a new structure, "task_cputime," to contain user, system and
scheduler times and use these in appropriate places:

struct task_cputime {
	cputime_t utime;
	cputime_t stime;
	unsigned long long sum_exec_runtime;
};

This is included in the structure "thread_group_cputime," which is a new
substructure of signal_struct and which varies for uniprocessor versus
multiprocessor kernels.  For uniprocessor kernels, it uses "task_cputime" as
a simple substructure, while for multiprocessor kernels it is a pointer:

struct thread_group_cputime {
	struct task_cputime totals;
};

struct thread_group_cputime {
	struct task_cputime *totals;
};

We also add a new task_cputime substructure directly to signal_struct, to
cache the earliest expiration of process-wide timers, and task_cputime also
replaces the it_*_expires fields of task_struct (used for earliest expiration
of thread timers).  The "thread_group_cputime" structure contains process-wide
timers that are updated via account_user_time() and friends.  In the non-SMP
case the structure is a simple aggregator; unfortunately in the SMP case that
simplicity was not achievable due to cache-line contention between CPUs (in
one measured case performance was actually _worse_ on a 16-cpu system than
the same test on a 4-cpu system, due to this contention).  For SMP, the
thread_group_cputime counters are maintained as a per-cpu structure allocated
using alloc_percpu().  The timer functions update only the timer field in
the structure corresponding to the running CPU, obtained using per_cpu_ptr().

We define a set of inline functions in sched.h that we use to maintain the
thread_group_cputime structure and hide the differences between UP and SMP
implementations from the rest of the kernel.  The thread_group_cputime_init()
function initializes the thread_group_cputime structure for the given task.
The thread_group_cputime_alloc() is a no-op for UP; for SMP it calls the
out-of-line function thread_group_cputime_alloc_smp() to allocate and fill
in the per-cpu structures and fields.  The thread_group_cputime_free()
function, also a no-op for UP, in SMP frees the per-cpu structures.  The
thread_group_cputime_clone_thread() function (also a UP no-op) for SMP calls
thread_group_cputime_alloc() if the per-cpu structures haven't yet been
allocated.  The thread_group_cputime() function fills the task_cputime
structure it is passed with the contents of the thread_group_cputime fields;
in UP it's that simple but in SMP it must also safely check that tsk->signal
is non-NULL (if it is it just uses the appropriate fields of task_struct) and,
if so, sums the per-cpu values for each online CPU.  Finally, the three
functions account_group_user_time(), account_group_system_time() and
account_group_exec_runtime() are used by timer functions to update the
respective fields of the thread_group_cputime structure.

Non-SMP operation is trivial and will not be mentioned further.

The per-cpu structure is always allocated when a task creates its first new
thread, via a call to thread_group_cputime_clone_thread() from copy_signal().
It is freed at process exit via a call to thread_group_cputime_free() from
cleanup_signal().

All functions that formerly summed utime/stime/sum_sched_runtime values from
from all threads in the thread group now use thread_group_cputime() to
snapshot the values in the thread_group_cputime structure or the values in
the task structure itself if the per-cpu structure hasn't been allocated.

Finally, the code in kernel/posix-cpu-timers.c has changed quite a bit.
The run_posix_cpu_timers() function has been split into a fast path and a
slow path; the former safely checks whether there are any expired thread
timers and, if not, just returns, while the slow path does the heavy lifting.
With the dedicated thread group fields, timers are no longer "rebalanced" and
the process_timer_rebalance() function and related code has gone away.  All
summing loops are gone and all code that used them now uses the
thread_group_cputime() inline.  When process-wide timers are set, the new
task_cputime structure in signal_struct is used to cache the earliest
expiration; this is checked in the fast path.


Performance

The fix appears not to add significant overhead to existing operations.  It
generally performs the same as the current code except in two cases, one in
which it performs slightly worse (Case 5 below) and one in which it performs
very significantly better (Case 2 below).  Overall it's a wash except in those
two cases.


I've since done somewhat more involved testing on a dual-core Opteron system.

Case 1: With no itimer running, for a test with 100,000 threads, the fixed
	kernel took 1428.5 seconds, 513 seconds more than the unfixed system,
	all of which was spent in the system.  There were twice as many
	voluntary context switches with the fix as without it.

Case 2: With an itimer running at .01 second ticks and 4000 threads (the most
	an unmodified kernel can handle), the fixed kernel ran the test in
	eight percent of the time (5.8 seconds as opposed to 70 seconds) and
	had better tick accuracy (.012 seconds per tick as opposed to .023
	seconds per tick).

Case 3: A 4000-thread test with an initial timer tick of .01 second and an
	interval of 10,000 seconds (i.e. a timer that ticks only once) had
	very nearly the same performance in both cases:  6.3 seconds elapsed
	for the fixed kernel versus 5.5 seconds for the unfixed kernel.

With fewer threads (eight in these tests), the Case 1 test ran in essentially
the same time on both the modified and unmodified kernels (5.2 seconds versus
5.8 seconds).  The Case 2 test ran in about the same time as well, 5.9 seconds
versus 5.4 seconds but again with much better tick accuracy, .013 seconds per
tick versus .025 seconds per tick for the unmodified kernel.

Since the fix affected the rlimit code, I also tested soft and hard CPU limits.

Case 4: With a hard CPU limit of 20 seconds and eight threads (and an itimer
	running), the modified kernel was very slightly favored in that while
	it killed the process in 19.997 seconds of CPU time (5.002 seconds of
	wall time), only .003 seconds of that was system time, the rest was
	user time.  The unmodified kernel killed the process in 20.001 seconds
	of CPU (5.014 seconds of wall time) of which .016 seconds was system
	time.  Really, though, the results were too close to call.  The results
	were essentially the same with no itimer running.

Case 5: With a soft limit of 20 seconds and a hard limit of 2000 seconds
	(where the hard limit would never be reached) and an itimer running,
	the modified kernel exhibited worse tick accuracy than the unmodified
	kernel: .050 seconds/tick versus .028 seconds/tick.  Otherwise,
	performance was almost indistinguishable.  With no itimer running this
	test exhibited virtually identical behavior and times in both cases.

In times past I did some limited performance testing.  those results are below.

On a four-cpu Opteron system without this fix, a sixteen-thread test executed
in 3569.991 seconds, of which user was 3568.435s and system was 1.556s.  On
the same system with the fix, user and elapsed time were about the same, but
system time dropped to 0.007 seconds.  Performance with eight, four and one
thread were comparable.  Interestingly, the timer ticks with the fix seemed
more accurate:  The sixteen-thread test with the fix received 149543 ticks
for 0.024 seconds per tick, while the same test without the fix received 58720
for 0.061 seconds per tick.  Both cases were configured for an interval of
0.01 seconds.  Again, the other tests were comparable.  Each thread in this
test computed the primes up to 25,000,000.

I also did a test with a large number of threads, 100,000 threads, which is
impossible without the fix.  In this case each thread computed the primes only
up to 10,000 (to make the runtime manageable).  System time dominated, at
1546.968 seconds out of a total 2176.906 seconds (giving a user time of
629.938s).  It received 147651 ticks for 0.015 seconds per tick, still quite
accurate.  There is obviously no comparable test without the fix.

Signed-off-by: Frank Mayhar <fmayhar@google.com>

 fs/binfmt_elf.c              |   19 +-
 fs/proc/array.c              |    8 +-
 include/linux/posix-timers.h |    2 +
 include/linux/sched.h        |  257 ++++++++++++++++++++++--
 include/linux/time.h         |    3 +
 kernel/compat.c              |   53 ++----
 kernel/exit.c                |   19 +-
 kernel/fork.c                |   88 +++++----
 kernel/itimer.c              |   33 +--
 kernel/posix-cpu-timers.c    |  471 ++++++++++++++++++++++--------------------
 kernel/sched.c               |   53 ++++-
 kernel/sched_fair.c          |    1 +
 kernel/sched_rt.c            |    4 +-
 kernel/signal.c              |    8 +-
 kernel/sys.c                 |   75 +++-----
 security/selinux/hooks.c     |    9 +-
 16 files changed, 677 insertions(+), 426 deletions(-)

diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index 655ed8d..a8635f6 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -1333,20 +1333,15 @@ static void fill_prstatus(struct elf_prstatus *prstatus,
 	prstatus->pr_pgrp = task_pgrp_vnr(p);
 	prstatus->pr_sid = task_session_vnr(p);
 	if (thread_group_leader(p)) {
+		struct task_cputime cputime;
+
 		/*
-		 * This is the record for the group leader.  Add in the
-		 * cumulative times of previous dead threads.  This total
-		 * won't include the time of each live thread whose state
-		 * is included in the core dump.  The final total reported
-		 * to our parent process when it calls wait4 will include
-		 * those sums as well as the little bit more time it takes
-		 * this and each other thread to finish dying after the
-		 * core dump synchronization phase.
+		 * This is the record for the group leader.  It shows the
+		 * group-wide total, not its individual thread total.
 		 */
-		cputime_to_timeval(cputime_add(p->utime, p->signal->utime),
-				   &prstatus->pr_utime);
-		cputime_to_timeval(cputime_add(p->stime, p->signal->stime),
-				   &prstatus->pr_stime);
+		thread_group_cputime(p, &cputime);
+		cputime_to_timeval(cputime.utime, &prstatus->pr_utime);
+		cputime_to_timeval(cputime.stime, &prstatus->pr_stime);
 	} else {
 		cputime_to_timeval(p->utime, &prstatus->pr_utime);
 		cputime_to_timeval(p->stime, &prstatus->pr_stime);
diff --git a/fs/proc/array.c b/fs/proc/array.c
index 71c9be5..933953c 100644
--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@ -395,20 +395,20 @@ static int do_task_stat(struct seq_file *m, struct pid_namespace *ns,
 
 		/* add up live thread stats at the group level */
 		if (whole) {
+			struct task_cputime cputime;
 			struct task_struct *t = task;
 			do {
 				min_flt += t->min_flt;
 				maj_flt += t->maj_flt;
-				utime = cputime_add(utime, task_utime(t));
-				stime = cputime_add(stime, task_stime(t));
 				gtime = cputime_add(gtime, task_gtime(t));
 				t = next_thread(t);
 			} while (t != task);
 
 			min_flt += sig->min_flt;
 			maj_flt += sig->maj_flt;
-			utime = cputime_add(utime, sig->utime);
-			stime = cputime_add(stime, sig->stime);
+			thread_group_cputime(task, &cputime);
+			utime = cputime.utime;
+			stime = cputime.stime;
 			gtime = cputime_add(gtime, sig->gtime);
 		}
 
diff --git a/include/linux/posix-timers.h b/include/linux/posix-timers.h
index a7dd38f..f9d8e9e 100644
--- a/include/linux/posix-timers.h
+++ b/include/linux/posix-timers.h
@@ -115,4 +115,6 @@ void set_process_cpu_timer(struct task_struct *task, unsigned int clock_idx,
 
 long clock_nanosleep_restart(struct restart_block *restart_block);
 
+void update_rlimit_cpu(unsigned long rlim_new);
+
 #endif
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 3d9120c..26d7a5f 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -425,6 +425,45 @@ struct pacct_struct {
 	unsigned long		ac_minflt, ac_majflt;
 };
 
+/**
+ * struct task_cputime - collected CPU time counts
+ * @utime:		time spent in user mode, in &cputime_t units
+ * @stime:		time spent in kernel mode, in &cputime_t units
+ * @sum_exec_runtime:	total time spent on the CPU, in nanoseconds
+ * 
+ * This structure groups together three kinds of CPU time that are
+ * tracked for threads and thread groups.  Most things considering
+ * CPU time want to group these counts together and treat all three
+ * of them in parallel.
+ */
+struct task_cputime {
+	cputime_t utime;
+	cputime_t stime;
+	unsigned long long sum_exec_runtime;
+};
+/* Alternate field names when used to cache expirations. */
+#define prof_exp	stime
+#define virt_exp	utime
+#define sched_exp	sum_exec_runtime
+
+/**
+ * struct thread_group_cputime - thread group interval timer counts
+ * @totals:		thread group interval timers; substructure for
+ *			uniprocessor kernel, per-cpu for SMP kernel.
+ *
+ * This structure contains the version of task_cputime, above, that is
+ * used for thread group CPU clock calculations.
+ */
+#ifdef CONFIG_SMP
+struct thread_group_cputime {
+	struct task_cputime *totals;
+};
+#else
+struct thread_group_cputime {
+	struct task_cputime totals;
+};
+#endif
+
 /*
  * NOTE! "signal_struct" does not have it's own
  * locking, because a shared signal_struct always
@@ -470,6 +509,17 @@ struct signal_struct {
 	cputime_t it_prof_expires, it_virt_expires;
 	cputime_t it_prof_incr, it_virt_incr;
 
+	/*
+	 * Thread group totals for process CPU clocks.
+	 * See thread_group_cputime(), et al, for details.
+	 */
+	struct thread_group_cputime cputime;
+
+	/* Earliest-expiration cache. */
+	struct task_cputime cputime_expires;
+
+	struct list_head cpu_timers[3];
+
 	/* job control IDs */
 
 	/*
@@ -500,7 +550,7 @@ struct signal_struct {
 	 * Live threads maintain their own counters and add to these
 	 * in __exit_signal, except for the group leader.
 	 */
-	cputime_t utime, stime, cutime, cstime;
+	cputime_t cutime, cstime;
 	cputime_t gtime;
 	cputime_t cgtime;
 	unsigned long nvcsw, nivcsw, cnvcsw, cnivcsw;
@@ -509,14 +559,6 @@ struct signal_struct {
 	struct task_io_accounting ioac;
 
 	/*
-	 * Cumulative ns of scheduled CPU time for dead threads in the
-	 * group, not including a zombie group leader.  (This only differs
-	 * from jiffies_to_ns(utime + stime) if sched_clock uses something
-	 * other than jiffies.)
-	 */
-	unsigned long long sum_sched_runtime;
-
-	/*
 	 * We don't bother to synchronize most readers of this at all,
 	 * because there is no reader checking a limit that actually needs
 	 * to get both rlim_cur and rlim_max atomically, and either one
@@ -527,8 +569,6 @@ struct signal_struct {
 	 */
 	struct rlimit rlim[RLIM_NLIMITS];
 
-	struct list_head cpu_timers[3];
-
 	/* keep the process-shared keyrings here so that they do the right
 	 * thing in threads created with CLONE_THREAD */
 #ifdef CONFIG_KEYS
@@ -1134,8 +1174,7 @@ struct task_struct {
 /* mm fault and swap info: this can arguably be seen as either mm-specific or thread-specific */
 	unsigned long min_flt, maj_flt;
 
-  	cputime_t it_prof_expires, it_virt_expires;
-	unsigned long long it_sched_expires;
+	struct task_cputime cputime_expires;
 	struct list_head cpu_timers[3];
 
 /* process credentials */
@@ -1585,6 +1624,7 @@ extern unsigned long long cpu_clock(int cpu);
 
 extern unsigned long long
 task_sched_runtime(struct task_struct *task);
+extern unsigned long long thread_group_sched_runtime(struct task_struct *task);
 
 /* sched_exec is called by processes performing an exec */
 #ifdef CONFIG_SMP
@@ -2082,6 +2122,197 @@ static inline int spin_needbreak(spinlock_t *lock)
 }
 
 /*
+ * Thread group CPU time accounting.
+ */
+#ifdef CONFIG_SMP
+
+extern int thread_group_cputime_alloc_smp(struct task_struct *);
+extern void thread_group_cputime_smp(struct task_struct *, struct task_cputime *);
+
+static inline void thread_group_cputime_init(struct signal_struct *sig)
+{
+	sig->cputime.totals = NULL;
+}
+
+static inline int thread_group_cputime_clone_thread(struct task_struct *curr,
+						    struct task_struct *new)
+{
+	if (curr->signal->cputime.totals)
+		return 0;
+	return thread_group_cputime_alloc_smp(curr);
+}
+
+static inline void thread_group_cputime_free(struct signal_struct *sig)
+{
+	free_percpu(sig->cputime.totals);
+}
+
+/**
+ * thread_group_cputime - Sum the thread group time fields across all CPUs.
+ *
+ * This is a wrapper for the real routine, thread_group_cputime_smp().  See
+ * that routine for details.
+ */
+static inline void thread_group_cputime(
+	struct task_struct *tsk,
+	struct task_cputime *times)
+{
+	thread_group_cputime_smp(tsk, times);
+}
+
+/**
+ * thread_group_cputime_account_user - Maintain utime for a thread group.
+ *
+ * @tgtimes:	Pointer to thread_group_cputime structure.
+ * @cputime:	Time value by which to increment the utime field of that
+ *		structure.
+ *
+ * If thread group time is being maintained, get the structure for the
+ * running CPU and update the utime field there.
+ */
+static inline void thread_group_cputime_account_user(
+	struct thread_group_cputime *tgtimes,
+	cputime_t cputime)
+{
+	if (tgtimes->totals) {
+		struct task_cputime *times;
+
+		times = per_cpu_ptr(tgtimes->totals, get_cpu());
+		times->utime = cputime_add(times->utime, cputime);
+		put_cpu_no_resched();
+	}
+}
+
+/**
+ * thread_group_cputime_account_system - Maintain stime for a thread group.
+ *
+ * @tgtimes:	Pointer to thread_group_cputime structure.
+ * @cputime:	Time value by which to increment the stime field of that
+ *		structure.
+ *
+ * If thread group time is being maintained, get the structure for the
+ * running CPU and update the stime field there.
+ */
+static inline void thread_group_cputime_account_system(
+	struct thread_group_cputime *tgtimes,
+	cputime_t cputime)
+{
+	if (tgtimes->totals) {
+		struct task_cputime *times;
+
+		times = per_cpu_ptr(tgtimes->totals, get_cpu());
+		times->stime = cputime_add(times->stime, cputime);
+		put_cpu_no_resched();
+	}
+}
+
+/**
+ * thread_group_cputime_account_exec_runtime - Maintain exec runtime for a
+ *						thread group.
+ *
+ * @tgtimes:	Pointer to thread_group_cputime structure.
+ * @ns:		Time value by which to increment the sum_exec_runtime field
+ *		of that structure.
+ *
+ * If thread group time is being maintained, get the structure for the
+ * running CPU and update the sum_exec_runtime field there.
+ */
+static inline void thread_group_cputime_account_exec_runtime(
+	struct thread_group_cputime *tgtimes,
+	unsigned long long ns)
+{
+	if (tgtimes->totals) {
+		struct task_cputime *times;
+
+		times = per_cpu_ptr(tgtimes->totals, get_cpu());
+		times->sum_exec_runtime += ns;
+		put_cpu_no_resched();
+	}
+}
+
+#else /* CONFIG_SMP */
+
+static inline void thread_group_cputime_init(struct signal_struct *sig)
+{
+	sig->cputime.totals.utime = cputime_zero;
+	sig->cputime.totals.stime = cputime_zero;
+	sig->cputime.totals.sum_exec_runtime = 0;
+}
+
+static inline int thread_group_cputime_alloc(struct task_struct *tsk)
+{
+	return 0;
+}
+
+static inline void thread_group_cputime_free(struct signal_struct *sig)
+{
+}
+
+static inline int thread_group_cputime_clone_thread(struct task_struct *curr,
+						     struct task_struct *tsk)
+{
+}
+
+static inline void thread_group_cputime(struct task_struct *tsk,
+					 struct task_cputime *cputime)
+{
+	*cputime = tsk->signal->cputime.totals;
+}
+
+static inline void thread_group_cputime_account_user(
+	struct thread_group_cputime *tgtimes,
+	cputime_t cputime)
+{
+	tgtimes->totals->utime = cputime_add(tgtimes->totals->utime, cputime);
+}
+
+static inline void thread_group_cputime_account_system(
+	struct thread_group_cputime *tgtimes,
+	cputime_t cputime)
+{
+	tgtimes->totals->stime = cputime_add(tgtimes->totals->stime, cputime);
+}
+
+static inline void thread_group_cputime_account_exec_runtime(
+	struct thread_group_cputime *tgtimes,
+	unsigned long long ns)
+{
+	tgtimes->totals->sum_exec_runtime += ns;
+}
+
+#endif /* CONFIG_SMP */
+
+static inline void account_group_user_time(struct task_struct *tsk,
+					    cputime_t cputime)
+{
+	struct signal_struct *sig;
+
+	sig = tsk->signal;
+	if (likely(sig))
+		thread_group_cputime_account_user(&sig->cputime, cputime);
+}
+
+static inline void account_group_system_time(struct task_struct *tsk,
+					      cputime_t cputime)
+{
+	struct signal_struct *sig;
+
+	sig = tsk->signal;
+	if (likely(sig))
+		thread_group_cputime_account_system(&sig->cputime, cputime);
+}
+
+static inline void account_group_exec_runtime(struct task_struct *tsk,
+					       unsigned long long ns)
+{
+	struct signal_struct *sig;
+
+	sig = tsk->signal;
+	if (likely(sig))
+		thread_group_cputime_account_exec_runtime(&sig->cputime, ns);
+}
+
+/*
  * Reevaluate whether the task has signals pending delivery.
  * Wake the task if so.
  * This is required every time the blocked sigset_t changes.
diff --git a/include/linux/time.h b/include/linux/time.h
index e15206a..1b70b3c 100644
--- a/include/linux/time.h
+++ b/include/linux/time.h
@@ -125,6 +125,9 @@ extern int timekeeping_valid_for_hres(void);
 extern void update_wall_time(void);
 extern void update_xtime_cache(u64 nsec);
 
+struct tms;
+extern void do_sys_times(struct tms *);
+
 /**
  * timespec_to_ns - Convert timespec to nanoseconds
  * @ts:		pointer to the timespec variable to be converted
diff --git a/kernel/compat.c b/kernel/compat.c
index 32c254a..72650e3 100644
--- a/kernel/compat.c
+++ b/kernel/compat.c
@@ -23,6 +23,7 @@
 #include <linux/timex.h>
 #include <linux/migrate.h>
 #include <linux/posix-timers.h>
+#include <linux/times.h>
 
 #include <asm/uaccess.h>
 
@@ -150,49 +151,23 @@ asmlinkage long compat_sys_setitimer(int which,
 	return 0;
 }
 
+static compat_clock_t clock_t_to_compat_clock_t(clock_t x)
+{
+	return compat_jiffies_to_clock_t(clock_t_to_jiffies(x));
+}
+
 asmlinkage long compat_sys_times(struct compat_tms __user *tbuf)
 {
-	/*
-	 *	In the SMP world we might just be unlucky and have one of
-	 *	the times increment as we use it. Since the value is an
-	 *	atomically safe type this is just fine. Conceptually its
-	 *	as if the syscall took an instant longer to occur.
-	 */
 	if (tbuf) {
+		struct tms tms;
 		struct compat_tms tmp;
-		struct task_struct *tsk = current;
-		struct task_struct *t;
-		cputime_t utime, stime, cutime, cstime;
-
-		read_lock(&tasklist_lock);
-		utime = tsk->signal->utime;
-		stime = tsk->signal->stime;
-		t = tsk;
-		do {
-			utime = cputime_add(utime, t->utime);
-			stime = cputime_add(stime, t->stime);
-			t = next_thread(t);
-		} while (t != tsk);
-
-		/*
-		 * While we have tasklist_lock read-locked, no dying thread
-		 * can be updating current->signal->[us]time.  Instead,
-		 * we got their counts included in the live thread loop.
-		 * However, another thread can come in right now and
-		 * do a wait call that updates current->signal->c[us]time.
-		 * To make sure we always see that pair updated atomically,
-		 * we take the siglock around fetching them.
-		 */
-		spin_lock_irq(&tsk->sighand->siglock);
-		cutime = tsk->signal->cutime;
-		cstime = tsk->signal->cstime;
-		spin_unlock_irq(&tsk->sighand->siglock);
-		read_unlock(&tasklist_lock);
-
-		tmp.tms_utime = compat_jiffies_to_clock_t(cputime_to_jiffies(utime));
-		tmp.tms_stime = compat_jiffies_to_clock_t(cputime_to_jiffies(stime));
-		tmp.tms_cutime = compat_jiffies_to_clock_t(cputime_to_jiffies(cutime));
-		tmp.tms_cstime = compat_jiffies_to_clock_t(cputime_to_jiffies(cstime));
+
+		do_sys_times(&tms);
+		/* Convert our struct tms to the compat version. */
+		tmp.tms_utime = clock_t_to_compat_clock_t(tms.tms_utime);
+		tmp.tms_stime = clock_t_to_compat_clock_t(tms.tms_stime);
+		tmp.tms_cutime = clock_t_to_compat_clock_t(tms.tms_cutime);
+		tmp.tms_cstime = clock_t_to_compat_clock_t(tms.tms_cstime);
 		if (copy_to_user(tbuf, &tmp, sizeof(tmp)))
 			return -EFAULT;
 	}
diff --git a/kernel/exit.c b/kernel/exit.c
index 1639564..40036ac 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -112,8 +112,6 @@ static void __exit_signal(struct task_struct *tsk)
 		 * We won't ever get here for the group leader, since it
 		 * will have been the last reference on the signal_struct.
 		 */
-		sig->utime = cputime_add(sig->utime, task_utime(tsk));
-		sig->stime = cputime_add(sig->stime, task_stime(tsk));
 		sig->gtime = cputime_add(sig->gtime, task_gtime(tsk));
 		sig->min_flt += tsk->min_flt;
 		sig->maj_flt += tsk->maj_flt;
@@ -122,7 +120,6 @@ static void __exit_signal(struct task_struct *tsk)
 		sig->inblock += task_io_get_inblock(tsk);
 		sig->oublock += task_io_get_oublock(tsk);
 		task_io_accounting_add(&sig->ioac, &tsk->ioac);
-		sig->sum_sched_runtime += tsk->se.sum_exec_runtime;
 		sig = NULL; /* Marker for below. */
 	}
 
@@ -1294,6 +1291,7 @@ static int wait_task_zombie(struct task_struct *p, int options,
 	if (likely(!traced)) {
 		struct signal_struct *psig;
 		struct signal_struct *sig;
+		struct task_cputime cputime;
 
 		/*
 		 * The resource counters for the group leader are in its
@@ -1309,20 +1307,23 @@ static int wait_task_zombie(struct task_struct *p, int options,
 		 * need to protect the access to p->parent->signal fields,
 		 * as other threads in the parent group can be right
 		 * here reaping other children at the same time.
+		 *
+		 * We use thread_group_cputime() to get times for the thread
+		 * group, which consolidates times for all threads in the
+		 * group including the group leader.
 		 */
 		spin_lock_irq(&p->parent->sighand->siglock);
 		psig = p->parent->signal;
 		sig = p->signal;
+		thread_group_cputime(p, &cputime);
 		psig->cutime =
 			cputime_add(psig->cutime,
-			cputime_add(p->utime,
-			cputime_add(sig->utime,
-				    sig->cutime)));
+			cputime_add(cputime.utime,
+				    sig->cutime));
 		psig->cstime =
 			cputime_add(psig->cstime,
-			cputime_add(p->stime,
-			cputime_add(sig->stime,
-				    sig->cstime)));
+			cputime_add(cputime.stime,
+				    sig->cstime));
 		psig->cgtime =
 			cputime_add(psig->cgtime,
 			cputime_add(p->gtime,
diff --git a/kernel/fork.c b/kernel/fork.c
index 7ce2ebe..a8ac2ef 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -759,15 +759,44 @@ void __cleanup_sighand(struct sighand_struct *sighand)
 		kmem_cache_free(sighand_cachep, sighand);
 }
 
+
+/*
+ * Initialize POSIX timer handling for a thread group.
+ */
+static void posix_cpu_timers_init_group(struct signal_struct *sig)
+{
+	/* Thread group counters. */
+	thread_group_cputime_init(sig);
+
+	/* Expiration times and increments. */
+	sig->it_virt_expires = cputime_zero;
+	sig->it_virt_incr = cputime_zero;
+	sig->it_prof_expires = cputime_zero;
+	sig->it_prof_incr = cputime_zero;
+
+	/* Cached expiration times. */
+	sig->cputime_expires.prof_exp = cputime_zero;
+	sig->cputime_expires.virt_exp = cputime_zero;
+	sig->cputime_expires.sched_exp = 0;
+
+	/* The timer lists. */
+	INIT_LIST_HEAD(&sig->cpu_timers[0]);
+	INIT_LIST_HEAD(&sig->cpu_timers[1]);
+	INIT_LIST_HEAD(&sig->cpu_timers[2]);
+}
+
 static int copy_signal(unsigned long clone_flags, struct task_struct *tsk)
 {
 	struct signal_struct *sig;
 	int ret;
 
 	if (clone_flags & CLONE_THREAD) {
-		atomic_inc(&current->signal->count);
-		atomic_inc(&current->signal->live);
-		return 0;
+		ret = thread_group_cputime_clone_thread(current, tsk);
+		if (likely(!ret)) {
+			atomic_inc(&current->signal->count);
+			atomic_inc(&current->signal->live);
+		}
+		return ret;
 	}
 	sig = kmem_cache_alloc(signal_cachep, GFP_KERNEL);
 	tsk->signal = sig;
@@ -795,15 +824,10 @@ static int copy_signal(unsigned long clone_flags, struct task_struct *tsk)
 	sig->it_real_incr.tv64 = 0;
 	sig->real_timer.function = it_real_fn;
 
-	sig->it_virt_expires = cputime_zero;
-	sig->it_virt_incr = cputime_zero;
-	sig->it_prof_expires = cputime_zero;
-	sig->it_prof_incr = cputime_zero;
-
 	sig->leader = 0;	/* session leadership doesn't inherit */
 	sig->tty_old_pgrp = NULL;
 
-	sig->utime = sig->stime = sig->cutime = sig->cstime = cputime_zero;
+	sig->cutime = sig->cstime = cputime_zero;
 	sig->gtime = cputime_zero;
 	sig->cgtime = cputime_zero;
 	sig->nvcsw = sig->nivcsw = sig->cnvcsw = sig->cnivcsw = 0;
@@ -820,14 +844,8 @@ static int copy_signal(unsigned long clone_flags, struct task_struct *tsk)
 	memcpy(sig->rlim, current->signal->rlim, sizeof sig->rlim);
 	task_unlock(current->group_leader);
 
-	if (sig->rlim[RLIMIT_CPU].rlim_cur != RLIM_INFINITY) {
-		/*
-		 * New sole thread in the process gets an expiry time
-		 * of the whole CPU time limit.
-		 */
-		tsk->it_prof_expires =
-			secs_to_cputime(sig->rlim[RLIMIT_CPU].rlim_cur);
-	}
+	posix_cpu_timers_init_group(sig);
+
 	acct_init_pacct(&sig->pacct);
 
 	tty_audit_fork(sig);
@@ -837,6 +855,7 @@ static int copy_signal(unsigned long clone_flags, struct task_struct *tsk)
 
 void __cleanup_signal(struct signal_struct *sig)
 {
+	thread_group_cputime_free(sig);
 	exit_thread_group_keys(sig);
 	kmem_cache_free(signal_cachep, sig);
 }
@@ -886,6 +905,19 @@ void mm_init_owner(struct mm_struct *mm, struct task_struct *p)
 #endif /* CONFIG_MM_OWNER */
 
 /*
+ * Initialize POSIX timer handling for a single task.
+ */
+static void posix_cpu_timers_init(struct task_struct *tsk)
+{
+	tsk->cputime_expires.prof_exp = cputime_zero;
+	tsk->cputime_expires.virt_exp = cputime_zero;
+	tsk->cputime_expires.sched_exp = 0;
+	INIT_LIST_HEAD(&tsk->cpu_timers[0]);
+	INIT_LIST_HEAD(&tsk->cpu_timers[1]);
+	INIT_LIST_HEAD(&tsk->cpu_timers[2]);
+}
+
+/*
  * This creates a new process as a copy of the old one,
  * but does not actually start it yet.
  *
@@ -995,12 +1027,7 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 	task_io_accounting_init(&p->ioac);
 	acct_clear_integrals(p);
 
-	p->it_virt_expires = cputime_zero;
-	p->it_prof_expires = cputime_zero;
-	p->it_sched_expires = 0;
-	INIT_LIST_HEAD(&p->cpu_timers[0]);
-	INIT_LIST_HEAD(&p->cpu_timers[1]);
-	INIT_LIST_HEAD(&p->cpu_timers[2]);
+	posix_cpu_timers_init(p);
 
 	p->lock_depth = -1;		/* -1 = no lock */
 	do_posix_clock_monotonic_gettime(&p->start_time);
@@ -1201,21 +1228,6 @@ static struct task_struct *copy_process(unsigned long clone_flags,
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
index ab98274..db7c358 100644
--- a/kernel/itimer.c
+++ b/kernel/itimer.c
@@ -55,17 +55,15 @@ int do_getitimer(int which, struct itimerval *value)
 		spin_unlock_irq(&tsk->sighand->siglock);
 		break;
 	case ITIMER_VIRTUAL:
-		read_lock(&tasklist_lock);
 		spin_lock_irq(&tsk->sighand->siglock);
 		cval = tsk->signal->it_virt_expires;
 		cinterval = tsk->signal->it_virt_incr;
 		if (!cputime_eq(cval, cputime_zero)) {
-			struct task_struct *t = tsk;
-			cputime_t utime = tsk->signal->utime;
-			do {
-				utime = cputime_add(utime, t->utime);
-				t = next_thread(t);
-			} while (t != tsk);
+			struct task_cputime cputime;
+			cputime_t utime;
+
+			thread_group_cputime(tsk, &cputime);
+			utime = cputime.utime;
 			if (cputime_le(cval, utime)) { /* about to fire */
 				cval = jiffies_to_cputime(1);
 			} else {
@@ -73,25 +71,19 @@ int do_getitimer(int which, struct itimerval *value)
 			}
 		}
 		spin_unlock_irq(&tsk->sighand->siglock);
-		read_unlock(&tasklist_lock);
 		cputime_to_timeval(cval, &value->it_value);
 		cputime_to_timeval(cinterval, &value->it_interval);
 		break;
 	case ITIMER_PROF:
-		read_lock(&tasklist_lock);
 		spin_lock_irq(&tsk->sighand->siglock);
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
+			struct task_cputime times;
+			cputime_t ptime;
+
+			thread_group_cputime(tsk, &times);
+			ptime = cputime_add(times.utime, times.stime);
 			if (cputime_le(cval, ptime)) { /* about to fire */
 				cval = jiffies_to_cputime(1);
 			} else {
@@ -99,7 +91,6 @@ int do_getitimer(int which, struct itimerval *value)
 			}
 		}
 		spin_unlock_irq(&tsk->sighand->siglock);
-		read_unlock(&tasklist_lock);
 		cputime_to_timeval(cval, &value->it_value);
 		cputime_to_timeval(cinterval, &value->it_interval);
 		break;
@@ -185,7 +176,6 @@ again:
 	case ITIMER_VIRTUAL:
 		nval = timeval_to_cputime(&value->it_value);
 		ninterval = timeval_to_cputime(&value->it_interval);
-		read_lock(&tasklist_lock);
 		spin_lock_irq(&tsk->sighand->siglock);
 		cval = tsk->signal->it_virt_expires;
 		cinterval = tsk->signal->it_virt_incr;
@@ -200,7 +190,6 @@ again:
 		tsk->signal->it_virt_expires = nval;
 		tsk->signal->it_virt_incr = ninterval;
 		spin_unlock_irq(&tsk->sighand->siglock);
-		read_unlock(&tasklist_lock);
 		if (ovalue) {
 			cputime_to_timeval(cval, &ovalue->it_value);
 			cputime_to_timeval(cinterval, &ovalue->it_interval);
@@ -209,7 +198,6 @@ again:
 	case ITIMER_PROF:
 		nval = timeval_to_cputime(&value->it_value);
 		ninterval = timeval_to_cputime(&value->it_interval);
-		read_lock(&tasklist_lock);
 		spin_lock_irq(&tsk->sighand->siglock);
 		cval = tsk->signal->it_prof_expires;
 		cinterval = tsk->signal->it_prof_incr;
@@ -224,7 +212,6 @@ again:
 		tsk->signal->it_prof_expires = nval;
 		tsk->signal->it_prof_incr = ninterval;
 		spin_unlock_irq(&tsk->sighand->siglock);
-		read_unlock(&tasklist_lock);
 		if (ovalue) {
 			cputime_to_timeval(cval, &ovalue->it_value);
 			cputime_to_timeval(cinterval, &ovalue->it_interval);
diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
index c42a03a..dba1c33 100644
--- a/kernel/posix-cpu-timers.c
+++ b/kernel/posix-cpu-timers.c
@@ -8,6 +8,99 @@
 #include <linux/math64.h>
 #include <asm/uaccess.h>
 
+#ifdef CONFIG_SMP
+/*
+ * Allocate the thread_group_cputime structure appropriately for SMP kernels
+ * and fill in the current values of the fields.  Called from copy_signal()
+ * via thread_group_cputime_clone_thread() when adding a second or subsequent
+ * thread to a thread group.  Assumes interrupts are enabled when called.
+ */
+int thread_group_cputime_alloc_smp(struct task_struct *tsk)
+{
+	struct signal_struct *sig = tsk->signal;
+	struct task_cputime *cputime;
+
+	/*
+	 * If we have multiple threads and we don't already have a
+	 * per-CPU task_cputime struct, allocate one and fill it in with
+	 * the times accumulated so far.
+	 */
+	if (sig->cputime.totals)
+		return 0;
+	cputime = alloc_percpu(struct task_cputime);
+	if (cputime == NULL)
+		return -ENOMEM;
+	read_lock(&tasklist_lock);
+	spin_lock_irq(&tsk->sighand->siglock);
+	if (sig->cputime.totals) {
+		spin_unlock_irq(&tsk->sighand->siglock);
+		read_unlock(&tasklist_lock);
+		free_percpu(cputime);
+		return 0;
+	}
+	sig->cputime.totals = cputime;
+	cputime = per_cpu_ptr(sig->cputime.totals, get_cpu());
+	cputime->utime = tsk->utime;
+	cputime->stime = tsk->stime;
+	cputime->sum_exec_runtime = tsk->se.sum_exec_runtime;
+	put_cpu_no_resched();
+	spin_unlock_irq(&tsk->sighand->siglock);
+	read_unlock(&tasklist_lock);
+	return 0;
+}
+
+/**
+ * thread_group_cputime_smp - Sum the thread group time fields across all CPUs.
+ *
+ * @tsk:	The task we use to identify the thread group.
+ * @times:	task_cputime structure in which we return the summed fields.
+ *
+ * Walk the list of CPUs to sum the per-CPU time fields in the thread group
+ * time structure.
+ */
+void thread_group_cputime_smp(
+	struct task_struct *tsk,
+	struct task_cputime *times)
+{
+	struct signal_struct *sig;
+	int i;
+	struct task_cputime *tot;
+
+	sig = tsk->signal;
+	if (unlikely(!sig) || !sig->cputime.totals) {
+		times->utime = tsk->utime;
+		times->stime = tsk->stime;
+		times->sum_exec_runtime = tsk->se.sum_exec_runtime;
+		return;
+	}
+	times->stime = times->utime = cputime_zero;
+	times->sum_exec_runtime = 0;
+	for_each_possible_cpu(i) {
+		tot = per_cpu_ptr(tsk->signal->cputime.totals, i);
+		times->utime = cputime_add(times->utime, tot->utime);
+		times->stime = cputime_add(times->stime, tot->stime);
+		times->sum_exec_runtime += tot->sum_exec_runtime;
+	}
+}
+
+#endif /* CONFIG_SMP */
+
+/*
+ * Called after updating RLIMIT_CPU to set timer expiration if necessary.
+ */
+void update_rlimit_cpu(unsigned long rlim_new)
+{
+	cputime_t cputime;
+
+	cputime = secs_to_cputime(rlim_new);
+	if (cputime_eq(current->signal->it_prof_expires, cputime_zero) ||
+            cputime_lt(current->signal->it_prof_expires, cputime)) {
+		spin_lock_irq(&current->sighand->siglock);
+		set_process_cpu_timer(current, CPUCLOCK_PROF, &cputime, NULL);
+		spin_unlock_irq(&current->sighand->siglock);
+	}
+}
+
 static int check_clock(const clockid_t which_clock)
 {
 	int error = 0;
@@ -158,10 +251,6 @@ static inline cputime_t virt_ticks(struct task_struct *p)
 {
 	return p->utime;
 }
-static inline unsigned long long sched_ns(struct task_struct *p)
-{
-	return task_sched_runtime(p);
-}
 
 int posix_cpu_clock_getres(const clockid_t which_clock, struct timespec *tp)
 {
@@ -211,7 +300,7 @@ static int cpu_clock_sample(const clockid_t which_clock, struct task_struct *p,
 		cpu->cpu = virt_ticks(p);
 		break;
 	case CPUCLOCK_SCHED:
-		cpu->sched = sched_ns(p);
+		cpu->sched = task_sched_runtime(p);
 		break;
 	}
 	return 0;
@@ -226,31 +315,20 @@ static int cpu_clock_sample_group_locked(unsigned int clock_idx,
 					 struct task_struct *p,
 					 union cpu_time_count *cpu)
 {
-	struct task_struct *t = p;
- 	switch (clock_idx) {
+	struct task_cputime cputime;
+
+	thread_group_cputime(p, &cputime);
+	switch (clock_idx) {
 	default:
 		return -EINVAL;
 	case CPUCLOCK_PROF:
-		cpu->cpu = cputime_add(p->signal->utime, p->signal->stime);
-		do {
-			cpu->cpu = cputime_add(cpu->cpu, prof_ticks(t));
-			t = next_thread(t);
-		} while (t != p);
+		cpu->cpu = cputime_add(cputime.utime, cputime.stime);
 		break;
 	case CPUCLOCK_VIRT:
-		cpu->cpu = p->signal->utime;
-		do {
-			cpu->cpu = cputime_add(cpu->cpu, virt_ticks(t));
-			t = next_thread(t);
-		} while (t != p);
+		cpu->cpu = cputime.utime;
 		break;
 	case CPUCLOCK_SCHED:
-		cpu->sched = p->signal->sum_sched_runtime;
-		/* Add in each other live thread.  */
-		while ((t = next_thread(t)) != p) {
-			cpu->sched += t->se.sum_exec_runtime;
-		}
-		cpu->sched += sched_ns(p);
+		cpu->sched = thread_group_sched_runtime(p);
 		break;
 	}
 	return 0;
@@ -471,80 +549,11 @@ void posix_cpu_timers_exit(struct task_struct *tsk)
 }
 void posix_cpu_timers_exit_group(struct task_struct *tsk)
 {
-	cleanup_timers(tsk->signal->cpu_timers,
-		       cputime_add(tsk->utime, tsk->signal->utime),
-		       cputime_add(tsk->stime, tsk->signal->stime),
-		     tsk->se.sum_exec_runtime + tsk->signal->sum_sched_runtime);
-}
-
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
+	struct task_cputime cputime;
 
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
+	thread_group_cputime(tsk, &cputime);
+	cleanup_timers(tsk->signal->cpu_timers,
+		       cputime.utime, cputime.stime, cputime.sum_exec_runtime);
 }
 
 static void clear_dead_task(struct k_itimer *timer, union cpu_time_count now)
@@ -608,29 +617,32 @@ static void arm_timer(struct k_itimer *timer, union cpu_time_count now)
 			default:
 				BUG();
 			case CPUCLOCK_PROF:
-				if (cputime_eq(p->it_prof_expires,
+				if (cputime_eq(p->cputime_expires.prof_exp,
 					       cputime_zero) ||
-				    cputime_gt(p->it_prof_expires,
+				    cputime_gt(p->cputime_expires.prof_exp,
 					       nt->expires.cpu))
-					p->it_prof_expires = nt->expires.cpu;
+					p->cputime_expires.prof_exp =
+						nt->expires.cpu;
 				break;
 			case CPUCLOCK_VIRT:
-				if (cputime_eq(p->it_virt_expires,
+				if (cputime_eq(p->cputime_expires.virt_exp,
 					       cputime_zero) ||
-				    cputime_gt(p->it_virt_expires,
+				    cputime_gt(p->cputime_expires.virt_exp,
 					       nt->expires.cpu))
-					p->it_virt_expires = nt->expires.cpu;
+					p->cputime_expires.virt_exp =
+						nt->expires.cpu;
 				break;
 			case CPUCLOCK_SCHED:
-				if (p->it_sched_expires == 0 ||
-				    p->it_sched_expires > nt->expires.sched)
-					p->it_sched_expires = nt->expires.sched;
+				if (p->cputime_expires.sched_exp == 0 ||
+				    p->cputime_expires.sched_exp >
+							nt->expires.sched)
+					p->cputime_expires.sched_exp =
+						nt->expires.sched;
 				break;
 			}
 		} else {
 			/*
-			 * For a process timer, we must balance
-			 * all the live threads' expirations.
+			 * For a process timer, set the cached expiration time.
 			 */
 			switch (CPUCLOCK_WHICH(timer->it_clock)) {
 			default:
@@ -641,7 +653,9 @@ static void arm_timer(struct k_itimer *timer, union cpu_time_count now)
 				    cputime_lt(p->signal->it_virt_expires,
 					       timer->it.cpu.expires.cpu))
 					break;
-				goto rebalance;
+				p->signal->cputime_expires.virt_exp =
+					timer->it.cpu.expires.cpu;
+				break;
 			case CPUCLOCK_PROF:
 				if (!cputime_eq(p->signal->it_prof_expires,
 						cputime_zero) &&
@@ -652,13 +666,12 @@ static void arm_timer(struct k_itimer *timer, union cpu_time_count now)
 				if (i != RLIM_INFINITY &&
 				    i <= cputime_to_secs(timer->it.cpu.expires.cpu))
 					break;
-				goto rebalance;
+				p->signal->cputime_expires.prof_exp =
+					timer->it.cpu.expires.cpu;
+				break;
 			case CPUCLOCK_SCHED:
-			rebalance:
-				process_timer_rebalance(
-					timer->it.cpu.task,
-					CPUCLOCK_WHICH(timer->it_clock),
-					timer->it.cpu.expires, now);
+				p->signal->cputime_expires.sched_exp =
+					timer->it.cpu.expires.sched;
 				break;
 			}
 		}
@@ -969,13 +982,13 @@ static void check_thread_timers(struct task_struct *tsk,
 	struct signal_struct *const sig = tsk->signal;
 
 	maxfire = 20;
-	tsk->it_prof_expires = cputime_zero;
+	tsk->cputime_expires.prof_exp = cputime_zero;
 	while (!list_empty(timers)) {
 		struct cpu_timer_list *t = list_first_entry(timers,
 						      struct cpu_timer_list,
 						      entry);
 		if (!--maxfire || cputime_lt(prof_ticks(tsk), t->expires.cpu)) {
-			tsk->it_prof_expires = t->expires.cpu;
+			tsk->cputime_expires.prof_exp = t->expires.cpu;
 			break;
 		}
 		t->firing = 1;
@@ -984,13 +997,13 @@ static void check_thread_timers(struct task_struct *tsk,
 
 	++timers;
 	maxfire = 20;
-	tsk->it_virt_expires = cputime_zero;
+	tsk->cputime_expires.virt_exp = cputime_zero;
 	while (!list_empty(timers)) {
 		struct cpu_timer_list *t = list_first_entry(timers,
 						      struct cpu_timer_list,
 						      entry);
 		if (!--maxfire || cputime_lt(virt_ticks(tsk), t->expires.cpu)) {
-			tsk->it_virt_expires = t->expires.cpu;
+			tsk->cputime_expires.virt_exp = t->expires.cpu;
 			break;
 		}
 		t->firing = 1;
@@ -999,13 +1012,13 @@ static void check_thread_timers(struct task_struct *tsk,
 
 	++timers;
 	maxfire = 20;
-	tsk->it_sched_expires = 0;
+	tsk->cputime_expires.sched_exp = 0;
 	while (!list_empty(timers)) {
 		struct cpu_timer_list *t = list_first_entry(timers,
 						      struct cpu_timer_list,
 						      entry);
 		if (!--maxfire || tsk->se.sum_exec_runtime < t->expires.sched) {
-			tsk->it_sched_expires = t->expires.sched;
+			tsk->cputime_expires.sched_exp = t->expires.sched;
 			break;
 		}
 		t->firing = 1;
@@ -1055,10 +1068,10 @@ static void check_process_timers(struct task_struct *tsk,
 {
 	int maxfire;
 	struct signal_struct *const sig = tsk->signal;
-	cputime_t utime, stime, ptime, virt_expires, prof_expires;
+	cputime_t utime, ptime, virt_expires, prof_expires;
 	unsigned long long sum_sched_runtime, sched_expires;
-	struct task_struct *t;
 	struct list_head *timers = sig->cpu_timers;
+	struct task_cputime cputime;
 
 	/*
 	 * Don't sample the current process CPU clocks if there are no timers.
@@ -1074,18 +1087,10 @@ static void check_process_timers(struct task_struct *tsk,
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
-
+	thread_group_cputime(tsk, &cputime);
+	utime = cputime.utime;
+	ptime = cputime_add(utime, cputime.stime);
+	sum_sched_runtime = cputime.sum_exec_runtime;
 	maxfire = 20;
 	prof_expires = cputime_zero;
 	while (!list_empty(timers)) {
@@ -1193,60 +1198,18 @@ static void check_process_timers(struct task_struct *tsk,
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
+	    (cputime_eq(sig->cputime_expires.prof_exp, cputime_zero) ||
+	     cputime_gt(sig->cputime_expires.prof_exp, prof_expires)))
+		sig->cputime_expires.prof_exp = prof_expires;
+	if (!cputime_eq(virt_expires, cputime_zero) &&
+	    (cputime_eq(sig->cputime_expires.virt_exp, cputime_zero) ||
+	     cputime_gt(sig->cputime_expires.virt_exp, virt_expires)))
+		sig->cputime_expires.virt_exp = virt_expires;
+	if (sched_expires != 0 &&
+	    (sig->cputime_expires.sched_exp == 0 ||
+	     sig->cputime_expires.sched_exp > sched_expires))
+		sig->cputime_expires.sched_exp = sched_expires;
 }
 
 /*
@@ -1314,6 +1277,78 @@ out:
 	++timer->it_requeue_pending;
 }
 
+/**
+ * task_cputime_zero - Check a task_cputime struct for all zero fields.
+ *
+ * @cputime:	The struct to compare.
+ *
+ * Checks @cputime to see if all fields are zero.  Returns true if all fields
+ * are zero, false if any field is nonzero.
+ */
+static inline int task_cputime_zero(const struct task_cputime *cputime)
+{
+	if (cputime_eq(cputime->utime, cputime_zero) &&
+	    cputime_eq(cputime->stime, cputime_zero) &&
+	    cputime->sum_exec_runtime == 0)
+		return 1;
+	return 0;
+}
+
+/**
+ * task_cputime_expired - Compare two task_cputime entities.
+ *
+ * @sample:	The task_cputime structure to be checked for expiration.
+ * @expires:	Expiration times, against which @sample will be checked.
+ *
+ * Checks @sample against @expires to see if any field of @sample has expired.
+ * Returns true if any field of the former is greater than the corresponding
+ * field of the latter if the latter field is set.  Otherwise returns false.
+ */
+static inline int task_cputime_expired(const struct task_cputime *sample,
+					const struct task_cputime *expires)
+{
+	if (!cputime_eq(expires->utime, cputime_zero) &&
+	    cputime_ge(sample->utime, expires->utime))
+		return 1;
+	if (!cputime_eq(expires->stime, cputime_zero) &&
+	    cputime_ge(cputime_add(sample->utime, sample->stime),
+		       expires->stime))
+		return 1;
+	if (expires->sum_exec_runtime != 0 &&
+	    sample->sum_exec_runtime >= expires->sum_exec_runtime)
+		return 1;
+	return 0;
+}
+
+/**
+ * fastpath_timer_check - POSIX CPU timers fast path.
+ *
+ * @tsk:	The task (thread) being checked.
+ * @sig:	The signal pointer for that task.
+ *
+ * If there are no timers set return false.  Otherwise snapshot the task and
+ * thread group timers, then compare them with the corresponding expiration
+ # times.  Returns true if a timer has expired, else returns false.
+ */
+static inline int fastpath_timer_check(struct task_struct *tsk,
+					struct signal_struct *sig)
+{
+	struct task_cputime task_sample = {
+		.utime = tsk->utime,
+		.stime = tsk->stime,
+		.sum_exec_runtime = tsk->se.sum_exec_runtime
+	};
+	struct task_cputime group_sample;
+
+	if (task_cputime_zero(&tsk->cputime_expires) &&
+	    task_cputime_zero(&sig->cputime_expires))
+		return 0;
+	if (task_cputime_expired(&task_sample, &tsk->cputime_expires))
+		return 1;
+	thread_group_cputime(tsk, &group_sample);
+	return task_cputime_expired(&group_sample, &sig->cputime_expires);
+}
+
 /*
  * This is called from the timer interrupt handler.  The irq handler has
  * already updated our counts.  We need to check if any timers fire now.
@@ -1323,30 +1358,29 @@ void run_posix_cpu_timers(struct task_struct *tsk)
 {
 	LIST_HEAD(firing);
 	struct k_itimer *timer, *next;
+	struct signal_struct *sig;
+	struct sighand_struct *sighand;
+	unsigned long flags;
 
 	BUG_ON(!irqs_disabled());
 
-#define UNEXPIRED(clock) \
-		(cputime_eq(tsk->it_##clock##_expires, cputime_zero) || \
-		 cputime_lt(clock##_ticks(tsk), tsk->it_##clock##_expires))
-
-	if (UNEXPIRED(prof) && UNEXPIRED(virt) &&
-	    (tsk->it_sched_expires == 0 ||
-	     tsk->se.sum_exec_runtime < tsk->it_sched_expires))
-		return;
-
-#undef	UNEXPIRED
-
+	/* Pick up tsk->signal and make sure it's valid. */
+	sig = tsk->signal;
 	/*
-	 * Double-check with locks held.
+	 * The fast path checks that there are no expired thread or thread
+	 * group timers.  If that's so, just return.  Also check that
+	 * tsk->signal is non-NULL; this probably can't happen but cover the
+	 * possibility anyway.
 	 */
-	read_lock(&tasklist_lock);
-	if (likely(tsk->signal != NULL)) {
-		spin_lock(&tsk->sighand->siglock);
-
+	if (unlikely(!sig) || !fastpath_timer_check(tsk, sig)) {
+		return;
+	}
+	sighand = lock_task_sighand(tsk, &flags);
+	if (likely(sighand)) {
 		/*
-		 * Here we take off tsk->cpu_timers[N] and tsk->signal->cpu_timers[N]
-		 * all the timers that are firing, and put them on the firing list.
+		 * Here we take off tsk->signal->cpu_timers[N] and
+		 * tsk->cpu_timers[N] all the timers that are firing, and
+		 * put them on the firing list.
 		 */
 		check_thread_timers(tsk, &firing);
 		check_process_timers(tsk, &firing);
@@ -1359,9 +1393,8 @@ void run_posix_cpu_timers(struct task_struct *tsk)
 		 * that gets the timer lock before we do will give it up and
 		 * spin until we've taken care of that timer below.
 		 */
-		spin_unlock(&tsk->sighand->siglock);
 	}
-	read_unlock(&tasklist_lock);
+	unlock_task_sighand(tsk, &flags);
 
 	/*
 	 * Now that all the timers on our list have the firing flag,
@@ -1389,10 +1422,9 @@ void run_posix_cpu_timers(struct task_struct *tsk)
 
 /*
  * Set one of the process-wide special case CPU timers.
- * The tasklist_lock and tsk->sighand->siglock must be held by the caller.
- * The oldval argument is null for the RLIMIT_CPU timer, where *newval is
- * absolute; non-null for ITIMER_*, where *newval is relative and we update
- * it to be absolute, *oldval is absolute and we update it to be relative.
+ * The tsk->sighand->siglock must be held by the caller.
+ * The *newval argument is relative and we update it to be absolute, *oldval
+ * is absolute and we update it to be relative.
  */
 void set_process_cpu_timer(struct task_struct *tsk, unsigned int clock_idx,
 			   cputime_t *newval, cputime_t *oldval)
@@ -1435,13 +1467,14 @@ void set_process_cpu_timer(struct task_struct *tsk, unsigned int clock_idx,
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
+			tsk->signal->cputime_expires.prof_exp = *newval;
+			break;
+		case CPUCLOCK_VIRT:
+			tsk->signal->cputime_expires.virt_exp = *newval;
+			break;
+		}
 	}
 }
 
diff --git a/kernel/sched.c b/kernel/sched.c
index 1a5f73c..3a24c46 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -4037,23 +4037,56 @@ DEFINE_PER_CPU(struct kernel_stat, kstat);
 EXPORT_PER_CPU_SYMBOL(kstat);
 
 /*
+ * Return any ns on the sched_clock that have not yet been banked in
+ * @p in case that task is currently running.
+ *
+ * Called with task_rq_lock() held on @rq.
+ */
+static unsigned long long task_delta_exec(struct task_struct *p, struct rq *rq)
+{
+	if (task_current(rq, p)) {
+		u64 delta_exec;
+
+		update_rq_clock(rq);
+		delta_exec = rq->clock - p->se.exec_start;
+		if ((s64)delta_exec > 0)
+			return delta_exec;
+	}
+	return 0;
+}
+
+/*
  * Return p->sum_exec_runtime plus any more ns on the sched_clock
  * that have not yet been banked in case the task is currently running.
  */
 unsigned long long task_sched_runtime(struct task_struct *p)
 {
 	unsigned long flags;
-	u64 ns, delta_exec;
+	u64 ns;
 	struct rq *rq;
 
 	rq = task_rq_lock(p, &flags);
-	ns = p->se.sum_exec_runtime;
-	if (task_current(rq, p)) {
-		update_rq_clock(rq);
-		delta_exec = rq->clock - p->se.exec_start;
-		if ((s64)delta_exec > 0)
-			ns += delta_exec;
-	}
+	ns = p->se.sum_exec_runtime + task_delta_exec(p, rq);
+	task_rq_unlock(rq, &flags);
+
+	return ns;
+}
+
+/*
+ * Return sum_exec_runtime for the thread group plus any more ns on the
+ * sched_clock that have not yet been banked in case the task is currently
+ * running.
+ */
+unsigned long long thread_group_sched_runtime(struct task_struct *p)
+{
+	unsigned long flags;
+	u64 ns;
+	struct rq *rq;
+	struct task_cputime totals;
+
+	rq = task_rq_lock(p, &flags);
+	thread_group_cputime(p, &totals);
+	ns = totals.sum_exec_runtime + task_delta_exec(p, rq);
 	task_rq_unlock(rq, &flags);
 
 	return ns;
@@ -4070,6 +4103,7 @@ void account_user_time(struct task_struct *p, cputime_t cputime)
 	cputime64_t tmp;
 
 	p->utime = cputime_add(p->utime, cputime);
+	account_group_user_time(p, cputime);
 
 	/* Add user time to cpustat. */
 	tmp = cputime_to_cputime64(cputime);
@@ -4094,6 +4128,7 @@ static void account_guest_time(struct task_struct *p, cputime_t cputime)
 	tmp = cputime_to_cputime64(cputime);
 
 	p->utime = cputime_add(p->utime, cputime);
+	account_group_user_time(p, cputime);
 	p->gtime = cputime_add(p->gtime, cputime);
 
 	cpustat->user = cputime64_add(cpustat->user, tmp);
@@ -4129,6 +4164,7 @@ void account_system_time(struct task_struct *p, int hardirq_offset,
 	}
 
 	p->stime = cputime_add(p->stime, cputime);
+	account_group_system_time(p, cputime);
 
 	/* Add system time to cpustat. */
 	tmp = cputime_to_cputime64(cputime);
@@ -4170,6 +4206,7 @@ void account_steal_time(struct task_struct *p, cputime_t steal)
 
 	if (p == rq->idle) {
 		p->stime = cputime_add(p->stime, steal);
+		account_group_system_time(p, steal);
 		if (atomic_read(&rq->nr_iowait) > 0)
 			cpustat->iowait = cputime64_add(cpustat->iowait, tmp);
 		else
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index fb8994c..99aa31a 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -507,6 +507,7 @@ static void update_curr(struct cfs_rq *cfs_rq)
 		struct task_struct *curtask = task_of(curr);
 
 		cpuacct_charge(curtask, delta_exec);
+		account_group_exec_runtime(curtask, delta_exec);
 	}
 }
 
diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index 5523107..8375e69 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -483,6 +483,8 @@ static void update_curr_rt(struct rq *rq)
 	schedstat_set(curr->se.exec_max, max(curr->se.exec_max, delta_exec));
 
 	curr->se.sum_exec_runtime += delta_exec;
+	account_group_exec_runtime(curr, delta_exec);
+
 	curr->se.exec_start = rq->clock;
 	cpuacct_charge(curr, delta_exec);
 
@@ -1412,7 +1414,7 @@ static void watchdog(struct rq *rq, struct task_struct *p)
 		p->rt.timeout++;
 		next = DIV_ROUND_UP(min(soft, hard), USEC_PER_SEC/HZ);
 		if (p->rt.timeout > next)
-			p->it_sched_expires = p->se.sum_exec_runtime;
+			p->cputime_expires.sched_exp = p->se.sum_exec_runtime;
 	}
 }
 
diff --git a/kernel/signal.c b/kernel/signal.c
index e661b01..6eea582 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -1338,6 +1338,7 @@ int do_notify_parent(struct task_struct *tsk, int sig)
 	struct siginfo info;
 	unsigned long flags;
 	struct sighand_struct *psig;
+	struct task_cputime cputime;
 	int ret = sig;
 
 	BUG_ON(sig == -1);
@@ -1368,10 +1369,9 @@ int do_notify_parent(struct task_struct *tsk, int sig)
 
 	info.si_uid = tsk->uid;
 
-	info.si_utime = cputime_to_clock_t(cputime_add(tsk->utime,
-						       tsk->signal->utime));
-	info.si_stime = cputime_to_clock_t(cputime_add(tsk->stime,
-						       tsk->signal->stime));
+	thread_group_cputime(tsk, &cputime);
+	info.si_utime = cputime_to_jiffies(cputime.utime);
+	info.si_stime = cputime_to_jiffies(cputime.stime);
 
 	info.si_status = tsk->exit_code & 0x7f;
 	if (tsk->exit_code & 0x80)
diff --git a/kernel/sys.c b/kernel/sys.c
index 038a7bc..d046a7a 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -853,38 +853,28 @@ asmlinkage long sys_setfsgid(gid_t gid)
 	return old_fsgid;
 }
 
+void do_sys_times(struct tms *tms)
+{
+	struct task_cputime cputime;
+	cputime_t cutime, cstime;
+
+	spin_lock_irq(&current->sighand->siglock);
+	thread_group_cputime(current, &cputime);
+	cutime = current->signal->cutime;
+	cstime = current->signal->cstime;
+	spin_unlock_irq(&current->sighand->siglock);
+	tms->tms_utime = cputime_to_clock_t(cputime.utime);
+	tms->tms_stime = cputime_to_clock_t(cputime.stime);
+	tms->tms_cutime = cputime_to_clock_t(cutime);
+	tms->tms_cstime = cputime_to_clock_t(cstime);
+}
+
 asmlinkage long sys_times(struct tms __user * tbuf)
 {
-	/*
-	 *	In the SMP world we might just be unlucky and have one of
-	 *	the times increment as we use it. Since the value is an
-	 *	atomically safe type this is just fine. Conceptually its
-	 *	as if the syscall took an instant longer to occur.
-	 */
 	if (tbuf) {
 		struct tms tmp;
-		struct task_struct *tsk = current;
-		struct task_struct *t;
-		cputime_t utime, stime, cutime, cstime;
-
-		spin_lock_irq(&tsk->sighand->siglock);
-		utime = tsk->signal->utime;
-		stime = tsk->signal->stime;
-		t = tsk;
-		do {
-			utime = cputime_add(utime, t->utime);
-			stime = cputime_add(stime, t->stime);
-			t = next_thread(t);
-		} while (t != tsk);
-
-		cutime = tsk->signal->cutime;
-		cstime = tsk->signal->cstime;
-		spin_unlock_irq(&tsk->sighand->siglock);
-
-		tmp.tms_utime = cputime_to_clock_t(utime);
-		tmp.tms_stime = cputime_to_clock_t(stime);
-		tmp.tms_cutime = cputime_to_clock_t(cutime);
-		tmp.tms_cstime = cputime_to_clock_t(cstime);
+
+		do_sys_times(&tmp);
 		if (copy_to_user(tbuf, &tmp, sizeof(struct tms)))
 			return -EFAULT;
 	}
@@ -1445,7 +1435,6 @@ asmlinkage long sys_old_getrlimit(unsigned int resource, struct rlimit __user *r
 asmlinkage long sys_setrlimit(unsigned int resource, struct rlimit __user *rlim)
 {
 	struct rlimit new_rlim, *old_rlim;
-	unsigned long it_prof_secs;
 	int retval;
 
 	if (resource >= RLIM_NLIMITS)
@@ -1491,18 +1480,7 @@ asmlinkage long sys_setrlimit(unsigned int resource, struct rlimit __user *rlim)
 	if (new_rlim.rlim_cur == RLIM_INFINITY)
 		goto out;
 
-	it_prof_secs = cputime_to_secs(current->signal->it_prof_expires);
-	if (it_prof_secs == 0 || new_rlim.rlim_cur <= it_prof_secs) {
-		unsigned long rlim_cur = new_rlim.rlim_cur;
-		cputime_t cputime;
-
-		cputime = secs_to_cputime(rlim_cur);
-		read_lock(&tasklist_lock);
-		spin_lock_irq(&current->sighand->siglock);
-		set_process_cpu_timer(current, CPUCLOCK_PROF, &cputime, NULL);
-		spin_unlock_irq(&current->sighand->siglock);
-		read_unlock(&tasklist_lock);
-	}
+	update_rlimit_cpu(new_rlim.rlim_cur);
 out:
 	return 0;
 }
@@ -1540,11 +1518,8 @@ out:
  *
  */
 
-static void accumulate_thread_rusage(struct task_struct *t, struct rusage *r,
-				     cputime_t *utimep, cputime_t *stimep)
+static void accumulate_thread_rusage(struct task_struct *t, struct rusage *r)
 {
-	*utimep = cputime_add(*utimep, t->utime);
-	*stimep = cputime_add(*stimep, t->stime);
 	r->ru_nvcsw += t->nvcsw;
 	r->ru_nivcsw += t->nivcsw;
 	r->ru_minflt += t->min_flt;
@@ -1558,12 +1533,13 @@ static void k_getrusage(struct task_struct *p, int who, struct rusage *r)
 	struct task_struct *t;
 	unsigned long flags;
 	cputime_t utime, stime;
+	struct task_cputime cputime;
 
 	memset((char *) r, 0, sizeof *r);
 	utime = stime = cputime_zero;
 
 	if (who == RUSAGE_THREAD) {
-		accumulate_thread_rusage(p, r, &utime, &stime);
+		accumulate_thread_rusage(p, r);
 		goto out;
 	}
 
@@ -1586,8 +1562,9 @@ static void k_getrusage(struct task_struct *p, int who, struct rusage *r)
 				break;
 
 		case RUSAGE_SELF:
-			utime = cputime_add(utime, p->signal->utime);
-			stime = cputime_add(stime, p->signal->stime);
+			thread_group_cputime(p, &cputime);
+			utime = cputime_add(utime, cputime.utime);
+			stime = cputime_add(stime, cputime.stime);
 			r->ru_nvcsw += p->signal->nvcsw;
 			r->ru_nivcsw += p->signal->nivcsw;
 			r->ru_minflt += p->signal->min_flt;
@@ -1596,7 +1573,7 @@ static void k_getrusage(struct task_struct *p, int who, struct rusage *r)
 			r->ru_oublock += p->signal->oublock;
 			t = p;
 			do {
-				accumulate_thread_rusage(t, r, &utime, &stime);
+				accumulate_thread_rusage(t, r);
 				t = next_thread(t);
 			} while (t != p);
 			break;
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 03fc6a8..6964978 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -75,6 +75,7 @@
 #include <linux/string.h>
 #include <linux/selinux.h>
 #include <linux/mutex.h>
+#include <linux/posix-timers.h>
 
 #include "avc.h"
 #include "objsec.h"
@@ -2321,13 +2322,7 @@ static void selinux_bprm_post_apply_creds(struct linux_binprm *bprm)
 			initrlim = init_task.signal->rlim+i;
 			rlim->rlim_cur = min(rlim->rlim_max, initrlim->rlim_cur);
 		}
-		if (current->signal->rlim[RLIMIT_CPU].rlim_cur != RLIM_INFINITY) {
-			/*
-			 * This will cause RLIMIT_CPU calculations
-			 * to be refigured.
-			 */
-			current->it_prof_expires = jiffies_to_cputime(1);
-		}
+		update_rlimit_cpu(rlim->rlim_cur);
 	}
 
 	/* Wake up the parent if it is waiting so that it can

-- 
Frank Mayhar <fmayhar@google.com>
Google, Inc.

