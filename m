Return-Path: <linux-kernel-owner+w=401wt.eu-S932726AbXIQWZl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932726AbXIQWZl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 18:25:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758161AbXIQWZc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 18:25:32 -0400
Received: from smtp3-g19.free.fr ([212.27.42.29]:40371 "EHLO smtp3-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755967AbXIQWZb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 18:25:31 -0400
Date: Tue, 18 Sep 2007 00:23:39 +0200
From: Guillaume Chazarain <guichaz@yahoo.fr>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: balbir@linux.vnet.ibm.com, Jonathan Lim <jlim@sgi.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jay Lan <jlan@cthulhu.engr.sgi.com>, Oleg Nesterov <oleg@tv-sign.ru>
Subject: Add all thread stats for TASKSTATS_CMD_ATTR_TGID (v5)
Message-ID: <20070918002339.4a989377@localhost.localdomain>
In-Reply-To: <20070915204239.4a6af65e@localhost.localdomain>
References: <200708310302.l7V32ZpV410222@sabah.engr.sgi.com>
	<46D7C23F.7020509@linux.vnet.ibm.com>
	<20070831143535.2e4709c7@localhost.localdomain>
	<20070912171816.f0993440.akpm@linux-foundation.org>
	<20070915204239.4a6af65e@localhost.localdomain>
X-Mailer: Claws Mail 3.0.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

TASKSTATS_CMD_ATTR_TGID used to return only the delay accounting stats, not
the basic and extended accounting.  With this patch,
TASKSTATS_CMD_ATTR_TGID also aggregates the accounting info for all threads
of a thread group.  This makes TASKSTATS_CMD_ATTR_TGID usable in a similar
fashion to TASKSTATS_CMD_ATTR_PID, for commands like iotop -P
(http://guichaz.free.fr/misc/iotop.py).

Changelog since V4 (http://lkml.org/lkml/2007/9/15/171):
- Revert gratuitous user interface change (returning exit_code >> 8 instead of
exit_code). Thanks Oleg Nesterov.
- Revert useless heavyweight locking (lock_task_sighand() in fill_tgid_exit).
Thanks Oleg.
- Correctly fill the TGID in taskstats_exit(). Thanks Oleg.

Changelog since V3 (http://lkml.org/lkml/2007/8/31/121):
- Removed userspace example, either it gets accepted in util-linux-ng or I'll
maintain it elsewhere.
- Added kerneldoc for fill_threadgroup() and add_tsk().
- Removed useless {get,put}_task_struct(leader) as spotted by Andrew Morton
and Oleg Nesterov.
- Use lock_task_sighand() instead of spin_lock_irqsave(&tsk->sighand->siglock)
for consistency with the locking of task->signal->stats in fill_tgid().
- Removed useless check for a NULL taskstats in fill_tgid_exit(). Thanks Oleg.
- Documented double accounting race seen by Oleg.
- Rephrased the fill_tgid_exit() comment as per Oleg's recommendation.
- Documented the special case for the AFORK ac_flag.
- Use the exit status (code >> 8) instead of the exit code as documented in
Documentation/accounting/taskstats-struct.txt.
- Use signal->group_exit_code if set for stats->ac_exitcode on a TGID as
suggested by Oleg.

Changelog since V2 (http://lkml.org/lkml/2007/8/19/96):
- Added a testcase
- Added an indirection between the stats producer and consumer:
add_task() & fill_threadgroup()
- TGID stats are either summed from all the threads or taken from the leader

Changelog since V1 (http://lkml.org/lkml/2007/8/2/185):
- Update combined stats of exited threads in fill_tgid_exit() as
suggested by Balbir Singh.
- Very light cleanup of fill_tgid_exit() by the way.
- bacct fields are also combined for all threads.
- Instead of assuming memory stats are identical for all threads, we
take the max of all threads.

Signed-off-by: Guillaume Chazarain <guichaz@yahoo.fr>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Jay Lan <jlan@engr.sgi.com>
Cc: Jonathan Lim <jlim@sgi.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
---

 include/linux/tsacct_kern.h |   12 ++-
 kernel/taskstats.c          |  135 +++++++++++++++++++++-------------
 kernel/tsacct.c             |  113 ++++++++++++++++------------
 3 files changed, 159 insertions(+), 101 deletions(-)

diff -r 2908770b8fc2 include/linux/tsacct_kern.h
--- a/include/linux/tsacct_kern.h	Sun Sep 16 22:24:49 2007 -0700
+++ b/include/linux/tsacct_kern.h	Tue Aug 28 20:35:27 2007 +0200
@@ -10,17 +10,23 @@
 #include <linux/taskstats.h>
 
 #ifdef CONFIG_TASKSTATS
-extern void bacct_add_tsk(struct taskstats *stats, struct task_struct *tsk);
+void bacct_fill_threadgroup(struct taskstats *stats, struct task_struct *task);
+void bacct_add_tsk(struct taskstats *stats, struct task_struct *task);
 #else
-static inline void bacct_add_tsk(struct taskstats *stats, struct task_struct *tsk)
+static inline void bacct_fill_threadgroup(struct taskstats *stats, struct task_struct *task)
+{}
+static inline void bacct_add_tsk(struct taskstats *stats, struct task_struct *task)
 {}
 #endif /* CONFIG_TASKSTATS */
 
 #ifdef CONFIG_TASK_XACCT
-extern void xacct_add_tsk(struct taskstats *stats, struct task_struct *p);
+void xacct_fill_threadgroup(struct taskstats *stats, struct task_struct *task);
+void xacct_add_tsk(struct taskstats *stats, struct task_struct *p);
 extern void acct_update_integrals(struct task_struct *tsk);
 extern void acct_clear_integrals(struct task_struct *tsk);
 #else
+static inline void xacct_fill_threadgroup(struct taskstats *stats, struct task_struct *task)
+{}
 static inline void xacct_add_tsk(struct taskstats *stats, struct task_struct *p)
 {}
 static inline void acct_update_integrals(struct task_struct *tsk)
diff -r 2908770b8fc2 kernel/taskstats.c
--- a/kernel/taskstats.c	Sun Sep 16 22:24:49 2007 -0700
+++ b/kernel/taskstats.c	Mon Sep 17 22:55:04 2007 +0200
@@ -168,6 +168,68 @@ static void send_cpu_listeners(struct sk
 	up_write(&listeners->sem);
 }
 
+/**
+ * fill_threadgroup - initialize some common stats for the thread group
+ * @stats: the taskstats to write into
+ * @task: the thread representing the whole group
+ *
+ * There are two types of taskstats fields when considering a thread group:
+ *	- those that can be aggregated from each thread in the group (like CPU
+ *	times),
+ *	- those that cannot be aggregated (like UID) or are identical (like
+ *	memory usage), so are taken from the group leader.
+ * XXX_threadgroup() methods deal with the first type while XXX_add_tsk() with
+ * the second.
+ */
+static void fill_threadgroup(struct taskstats *stats, struct task_struct *task)
+{
+	/*
+	 * Each accounting subsystem adds calls to its functions to initialize
+	 * relevant parts of struct taskstsats for a single tgid as follows:
+	 *
+	 *	per-task-foo-fill_threadgroup(stats, task);
+	 */
+
+	stats->version = TASKSTATS_VERSION;
+
+	/* fill in basic acct fields */
+	bacct_fill_threadgroup(stats, task);
+
+	/* fill in extended acct fields */
+	xacct_fill_threadgroup(stats, task);
+}
+
+/**
+ * add_tsk - combine some thread specific stats in a taskstats
+ * @stats: the taskstats to write into
+ * @task: the thread to combine
+ *
+ * Stats specific to each thread in the thread group. Stats of @task should be
+ * combined with those already present in @stats. add_tsk() works in
+ * conjunction with fill_threadgroup(), taskstats fields should not be touched
+ * by both functions.
+ */
+static void add_tsk(struct taskstats *stats, struct task_struct *task)
+{
+	/*
+	 * Each accounting subsystem adds calls to its functions to combine
+	 * relevant parts of struct taskstsats for a single pid as follows:
+	 *
+	 *	per-task-foo-add_tsk(stats, task);
+	 */
+	stats->nvcsw  += task->nvcsw;
+	stats->nivcsw += task->nivcsw;
+
+	/* fill in delay acct fields */
+	delayacct_add_tsk(stats, task);
+
+	/* fill in basic acct fields */
+	bacct_add_tsk(stats, task);
+
+	/* fill in extended acct fields */
+	xacct_add_tsk(stats, task);
+}
+
 static int fill_pid(pid_t pid, struct task_struct *tsk,
 		struct taskstats *stats)
 {
@@ -185,23 +247,8 @@ static int fill_pid(pid_t pid, struct ta
 		get_task_struct(tsk);
 
 	memset(stats, 0, sizeof(*stats));
-	/*
-	 * Each accounting subsystem adds calls to its functions to
-	 * fill in relevant parts of struct taskstsats as follows
-	 *
-	 *	per-task-foo(stats, tsk);
-	 */
-
-	delayacct_add_tsk(stats, tsk);
-
-	/* fill in basic acct fields */
-	stats->version = TASKSTATS_VERSION;
-	stats->nvcsw = tsk->nvcsw;
-	stats->nivcsw = tsk->nivcsw;
-	bacct_add_tsk(stats, tsk);
-
-	/* fill in extended acct fields */
-	xacct_add_tsk(stats, tsk);
+	fill_threadgroup(stats, tsk);
+	add_tsk(stats, tsk);
 
 	/* Define err: label here if needed */
 	put_task_struct(tsk);
@@ -232,32 +279,25 @@ static int fill_tgid(pid_t tgid, struct 
 	else
 		memset(stats, 0, sizeof(*stats));
 
+	fill_threadgroup(stats, first->group_leader);
+
 	tsk = first;
-	do {
-		if (tsk->exit_state)
-			continue;
-		/*
-		 * Accounting subsystem can call its functions here to
-		 * fill in relevant parts of struct taskstsats as follows
-		 *
-		 *	per-task-foo(stats, tsk);
-		 */
-		delayacct_add_tsk(stats, tsk);
-
-		stats->nvcsw += tsk->nvcsw;
-		stats->nivcsw += tsk->nivcsw;
-	} while_each_thread(first, tsk);
+	do
+		if (!tsk->exit_state)
+			/*
+			 * This check is racy as a thread could exit just right
+			 * now and have its statistics accounted twice.
+			 */
+			add_tsk(stats, tsk);
+	while_each_thread(first, tsk);
+
+	if (first->signal->group_exit_code)
+		stats->ac_exitcode = first->signal->group_exit_code;
 
 	unlock_task_sighand(first, &flags);
 	rc = 0;
 out:
 	rcu_read_unlock();
-
-	stats->version = TASKSTATS_VERSION;
-	/*
-	 * Accounting subsytems can also add calls here to modify
-	 * fields of taskstats.
-	 */
 	return rc;
 }
 
@@ -267,19 +307,14 @@ static void fill_tgid_exit(struct task_s
 	unsigned long flags;
 
 	spin_lock_irqsave(&tsk->sighand->siglock, flags);
-	if (!tsk->signal->stats)
-		goto ret;
-
-	/*
-	 * Each accounting subsystem calls its functions here to
-	 * accumalate its per-task stats for tsk, into the per-tgid structure
-	 *
-	 *	per-task-foo(tsk->signal->stats, tsk);
-	 */
-	delayacct_add_tsk(tsk->signal->stats, tsk);
-ret:
+
+	/*
+	 * The fill_threadgroup() part of the statistics will be added by the
+	 * stats requester, i.e. fill_tgid()
+	 */
+	add_tsk(tsk->signal->stats, tsk);
+
 	spin_unlock_irqrestore(&tsk->sighand->siglock, flags);
-	return;
 }
 
 static int add_del_listener(pid_t pid, cpumask_t *maskp, int isadd)
@@ -508,7 +543,7 @@ void taskstats_exit(struct task_struct *
 	if (!stats)
 		goto err;
 
-	memcpy(stats, tsk->signal->stats, sizeof(*stats));
+	fill_tgid(tsk->pid, tsk, stats);
 
 send:
 	send_cpu_listeners(rep_skb, listeners);
diff -r 2908770b8fc2 kernel/tsacct.c
--- a/kernel/tsacct.c	Sun Sep 16 22:24:49 2007 -0700
+++ b/kernel/tsacct.c	Mon Sep 17 20:44:05 2007 +0200
@@ -22,50 +22,65 @@
 #include <linux/acct.h>
 #include <linux/jiffies.h>
 
-/*
- * fill in basic accounting fields
- */
-void bacct_add_tsk(struct taskstats *stats, struct task_struct *tsk)
+static void fill_wall_times(struct taskstats *stats, struct task_struct *task)
 {
 	struct timespec uptime, ts;
 	s64 ac_etime;
 
-	BUILD_BUG_ON(TS_COMM_LEN < TASK_COMM_LEN);
-
 	/* calculate task elapsed time in timespec */
 	do_posix_clock_monotonic_gettime(&uptime);
-	ts = timespec_sub(uptime, tsk->start_time);
+	ts = timespec_sub(uptime, task->start_time);
 	/* rebase elapsed time to usec */
 	ac_etime = timespec_to_ns(&ts);
 	do_div(ac_etime, NSEC_PER_USEC);
-	stats->ac_etime = ac_etime;
-	stats->ac_btime = get_seconds() - ts.tv_sec;
-	if (thread_group_leader(tsk)) {
-		stats->ac_exitcode = tsk->exit_code;
-		if (tsk->flags & PF_FORKNOEXEC)
-			stats->ac_flag |= AFORK;
-	}
-	if (tsk->flags & PF_SUPERPRIV)
+	stats->ac_etime	= ac_etime;
+	stats->ac_btime	= get_seconds() - ts.tv_sec;
+}
+
+/*
+ * fill in basic accounting fields
+ */
+
+void bacct_fill_threadgroup(struct taskstats *stats, struct task_struct *task)
+{
+	BUILD_BUG_ON(TS_COMM_LEN < TASK_COMM_LEN);
+
+	rcu_read_lock();
+	stats->ac_ppid	= pid_alive(task) ?
+				rcu_dereference(task->real_parent)->tgid : 0;
+	rcu_read_unlock();
+
+	fill_wall_times(stats, task);
+
+	stats->ac_exitcode	= task->exit_code;
+	stats->ac_nice		= task_nice(task);
+	stats->ac_sched		= task->policy;
+	stats->ac_uid		= task->uid;
+	stats->ac_gid		= task->gid;
+	stats->ac_pid		= task->pid;
+
+	strncpy(stats->ac_comm, task->comm, sizeof(stats->ac_comm));
+}
+
+void bacct_add_tsk(struct taskstats *stats, struct task_struct *task)
+{
+	if (task->flags & PF_SUPERPRIV)
 		stats->ac_flag |= ASU;
-	if (tsk->flags & PF_DUMPCORE)
+	if (task->flags & PF_DUMPCORE)
 		stats->ac_flag |= ACORE;
-	if (tsk->flags & PF_SIGNALED)
+	if (task->flags & PF_SIGNALED)
 		stats->ac_flag |= AXSIG;
-	stats->ac_nice	 = task_nice(tsk);
-	stats->ac_sched	 = tsk->policy;
-	stats->ac_uid	 = tsk->uid;
-	stats->ac_gid	 = tsk->gid;
-	stats->ac_pid	 = tsk->pid;
-	rcu_read_lock();
-	stats->ac_ppid	 = pid_alive(tsk) ?
-				rcu_dereference(tsk->real_parent)->tgid : 0;
-	rcu_read_unlock();
-	stats->ac_utime	 = cputime_to_msecs(tsk->utime) * USEC_PER_MSEC;
-	stats->ac_stime	 = cputime_to_msecs(tsk->stime) * USEC_PER_MSEC;
-	stats->ac_minflt = tsk->min_flt;
-	stats->ac_majflt = tsk->maj_flt;
+	if (thread_group_leader(task) && (task->flags & PF_FORKNOEXEC))
+		/*
+		 * Threads are created by do_fork() and don't exec but not in
+		 * the AFORK sense, as the latter involves fork(2).
+		 */
+		stats->ac_flag |= AFORK;
 
-	strncpy(stats->ac_comm, tsk->comm, sizeof(stats->ac_comm));
+	stats->ac_utime	 += cputime_to_msecs(task->utime) * USEC_PER_MSEC;
+	stats->ac_stime	 += cputime_to_msecs(task->stime) * USEC_PER_MSEC;
+	stats->ac_minflt += task->min_flt;
+	stats->ac_majflt += task->maj_flt;
 }
 
 
@@ -76,32 +91,34 @@ void bacct_add_tsk(struct taskstats *sta
 /*
  * fill in extended accounting fields
  */
-void xacct_add_tsk(struct taskstats *stats, struct task_struct *p)
+void xacct_fill_threadgroup(struct taskstats *stats, struct task_struct *task)
 {
 	struct mm_struct *mm;
 
-	/* convert pages-jiffies to Mbyte-usec */
-	stats->coremem = jiffies_to_usecs(p->acct_rss_mem1) * PAGE_SIZE / MB;
-	stats->virtmem = jiffies_to_usecs(p->acct_vm_mem1) * PAGE_SIZE / MB;
-	mm = get_task_mm(p);
+	mm = get_task_mm(task);
 	if (mm) {
 		/* adjust to KB unit */
 		stats->hiwater_rss   = mm->hiwater_rss * PAGE_SIZE / KB;
-		stats->hiwater_vm    = mm->hiwater_vm * PAGE_SIZE / KB;
+		stats->hiwater_vm    = mm->hiwater_vm  * PAGE_SIZE / KB;
 		mmput(mm);
 	}
-	stats->read_char	= p->rchar;
-	stats->write_char	= p->wchar;
-	stats->read_syscalls	= p->syscr;
-	stats->write_syscalls	= p->syscw;
+}
+
+void xacct_add_tsk(struct taskstats *stats, struct task_struct *p)
+{
+	/* convert pages-jiffies to Mbyte-usec */
+	stats->coremem	+= jiffies_to_usecs(p->acct_rss_mem1) * PAGE_SIZE / MB;
+	stats->virtmem	+= jiffies_to_usecs(p->acct_vm_mem1)  * PAGE_SIZE / MB;
+
+	stats->read_char	+= p->rchar;
+	stats->write_char	+= p->wchar;
+	stats->read_syscalls	+= p->syscr;
+	stats->write_syscalls	+= p->syscw;
+
 #ifdef CONFIG_TASK_IO_ACCOUNTING
-	stats->read_bytes	= p->ioac.read_bytes;
-	stats->write_bytes	= p->ioac.write_bytes;
-	stats->cancelled_write_bytes = p->ioac.cancelled_write_bytes;
-#else
-	stats->read_bytes	= 0;
-	stats->write_bytes	= 0;
-	stats->cancelled_write_bytes = 0;
+	stats->read_bytes		+= p->ioac.read_bytes;
+	stats->write_bytes		+= p->ioac.write_bytes;
+	stats->cancelled_write_bytes	+= p->ioac.cancelled_write_bytes;
 #endif
 }
 #undef KB
