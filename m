Return-Path: <linux-kernel-owner+w=401wt.eu-S1762239AbXIUXcs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762239AbXIUXcs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 19:32:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761357AbXIUXci
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 19:32:38 -0400
Received: from smtp3-g19.free.fr ([212.27.42.29]:41281 "EHLO smtp3-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754467AbXIUXch (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 19:32:37 -0400
From: Guillaume Chazarain <guichaz@yahoo.fr>
Subject: [PATCH 1/3] taskstats: separate PID/TGID stats producers to complete
	the TGID ones
To: Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@tv-sign.ru>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, Jonathan Lim <jlim@sgi.com>,
       Jay Lan <jlan@cthulhu.engr.sgi.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 22 Sep 2007 01:30:38 +0200
Message-ID: <20070921233038.21607.51089.stgit@localhost.localdomain>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

TASKSTATS_CMD_ATTR_TGID used to return only the delay accounting stats, not
the basic and extended accounting.  With this patch,
TASKSTATS_CMD_ATTR_TGID also aggregates the accounting info for all threads
of a thread group.

TASKSTATS_CMD_ATTR_PID output should be unchanged
TASKSTATS_CMD_ATTR_TGID output should have all fields set, unlike before the
patch where most of the fiels were set to 0.

To this aim, two functions were introduced: fill_threadgroup() and add_tsk().
These functions are responsible for aggregating the subsystem specific
accounting information. Taskstats requesters (fill_pid(), fill_tgid() and
fill_tgid_exit()) should only call add_tsk() and fill_threadgroup() to get the
stats.

Signed-off-by: Guillaume Chazarain <guichaz@yahoo.fr>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Jay Lan <jlan@engr.sgi.com>
Cc: Jonathan Lim <jlim@sgi.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
---

 Documentation/accounting/getdelays.c |    2 -
 include/linux/tsacct_kern.h          |   12 ++-
 kernel/taskstats.c                   |  131 ++++++++++++++++++++++------------
 kernel/tsacct.c                      |  106 ++++++++++++++++------------
 4 files changed, 155 insertions(+), 96 deletions(-)

diff --git a/Documentation/accounting/getdelays.c b/Documentation/accounting/getdelays.c
index cbee3a2..78773c0 100644
--- a/Documentation/accounting/getdelays.c
+++ b/Documentation/accounting/getdelays.c
@@ -76,7 +76,7 @@ static void usage(void)
 	fprintf(stderr, "getdelays [-dilv] [-w logfile] [-r bufsize] "
 			"[-m cpumask] [-t tgid] [-p pid]\n");
 	fprintf(stderr, "  -d: print delayacct stats\n");
-	fprintf(stderr, "  -i: print IO accounting (works only with -p)\n");
+	fprintf(stderr, "  -i: print IO accounting\n");
 	fprintf(stderr, "  -l: listen forever\n");
 	fprintf(stderr, "  -v: debug on\n");
 }
diff --git a/include/linux/tsacct_kern.h b/include/linux/tsacct_kern.h
index 7e50ac7..93dffc2 100644
--- a/include/linux/tsacct_kern.h
+++ b/include/linux/tsacct_kern.h
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
diff --git a/kernel/taskstats.c b/kernel/taskstats.c
index 059431e..ce43fae 100644
--- a/kernel/taskstats.c
+++ b/kernel/taskstats.c
@@ -168,6 +168,68 @@ static void send_cpu_listeners(struct sk_buff *skb,
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
@@ -185,23 +247,8 @@ static int fill_pid(pid_t pid, struct task_struct *tsk,
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
+	add_tsk(stats, tsk);
+	fill_threadgroup(stats, tsk);
 
 	/* Define err: label here if needed */
 	put_task_struct(tsk);
@@ -233,31 +280,20 @@ static int fill_tgid(pid_t tgid, struct task_struct *first,
 		memset(stats, 0, sizeof(*stats));
 
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
-
+	do
+		if (!tsk->exit_state)
+			/*
+			 * This check is racy as a thread could exit just right
+			 * now and have its statistics accounted twice.
+			 */
+			add_tsk(stats, tsk);
+	while_each_thread(first, tsk);
+
+	fill_threadgroup(stats, first->group_leader);
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
 
@@ -267,19 +303,14 @@ static void fill_tgid_exit(struct task_struct *tsk)
 	unsigned long flags;
 
 	spin_lock_irqsave(&tsk->sighand->siglock, flags);
-	if (!tsk->signal->stats)
-		goto ret;
 
 	/*
-	 * Each accounting subsystem calls its functions here to
-	 * accumalate its per-task stats for tsk, into the per-tgid structure
-	 *
-	 *	per-task-foo(tsk->signal->stats, tsk);
+	 * The fill_threadgroup() part of the statistics will be added by the
+	 * stats requester, i.e. fill_tgid() or taskstats_exit()
 	 */
-	delayacct_add_tsk(tsk->signal->stats, tsk);
-ret:
+	add_tsk(tsk->signal->stats, tsk);
+
 	spin_unlock_irqrestore(&tsk->sighand->siglock, flags);
-	return;
 }
 
 static int add_del_listener(pid_t pid, cpumask_t *maskp, int isadd)
@@ -508,7 +539,13 @@ void taskstats_exit(struct task_struct *tsk, int group_dead)
 	if (!stats)
 		goto err;
 
+	/*
+	 * Race here: the last thread may have not finished its
+	 * fill_tgid_exit(), leaving an incomplete tsk->signal->stats
+	 */
+
 	memcpy(stats, tsk->signal->stats, sizeof(*stats));
+	fill_threadgroup(stats, tsk->group_leader);
 
 send:
 	send_cpu_listeners(rep_skb, listeners);
diff --git a/kernel/tsacct.c b/kernel/tsacct.c
index 4ab1b58..9541a1a 100644
--- a/kernel/tsacct.c
+++ b/kernel/tsacct.c
@@ -22,54 +22,68 @@
 #include <linux/acct.h>
 #include <linux/jiffies.h>
 
-/*
- * fill in basic accounting fields
- */
-void bacct_add_tsk(struct taskstats *stats, struct task_struct *tsk)
+static void fill_wall_times(struct taskstats *stats, struct task_struct *tsk)
 {
 	struct timespec uptime, ts;
 	s64 ac_etime;
 
-	BUILD_BUG_ON(TS_COMM_LEN < TASK_COMM_LEN);
-
 	/* calculate task elapsed time in timespec */
 	do_posix_clock_monotonic_gettime(&uptime);
 	ts = timespec_sub(uptime, tsk->start_time);
 	/* rebase elapsed time to usec */
 	ac_etime = timespec_to_ns(&ts);
 	do_div(ac_etime, NSEC_PER_USEC);
-	stats->ac_etime = ac_etime;
-	stats->ac_btime = get_seconds() - ts.tv_sec;
-	if (thread_group_leader(tsk)) {
-		stats->ac_exitcode = tsk->exit_code;
-		if (tsk->flags & PF_FORKNOEXEC)
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
+	if (thread_group_leader(task)) {
+		stats->ac_exitcode = task->exit_code;
+		if (task->flags & PF_FORKNOEXEC)
 			stats->ac_flag |= AFORK;
 	}
+
+	stats->ac_nice		= task_nice(task);
+	stats->ac_sched		= task->policy;
+	stats->ac_uid		= task->uid;
+	stats->ac_gid		= task->gid;
+	stats->ac_pid		= task->pid;
+
+	strncpy(stats->ac_comm, task->comm, sizeof(stats->ac_comm));
+}
+
+void bacct_add_tsk(struct taskstats *stats, struct task_struct *tsk)
+{
 	if (tsk->flags & PF_SUPERPRIV)
 		stats->ac_flag |= ASU;
 	if (tsk->flags & PF_DUMPCORE)
 		stats->ac_flag |= ACORE;
 	if (tsk->flags & PF_SIGNALED)
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
-	stats->ac_utimescaled =
+
+	stats->ac_utime	 += cputime_to_msecs(tsk->utime) * USEC_PER_MSEC;
+	stats->ac_stime	 += cputime_to_msecs(tsk->stime) * USEC_PER_MSEC;
+	stats->ac_utimescaled +=
 		cputime_to_msecs(tsk->utimescaled) * USEC_PER_MSEC;
-	stats->ac_stimescaled =
+	stats->ac_stimescaled +=
 		cputime_to_msecs(tsk->stimescaled) * USEC_PER_MSEC;
-	stats->ac_minflt = tsk->min_flt;
-	stats->ac_majflt = tsk->maj_flt;
-
-	strncpy(stats->ac_comm, tsk->comm, sizeof(stats->ac_comm));
+	stats->ac_minflt += tsk->min_flt;
+	stats->ac_majflt += tsk->maj_flt;
 }
 
 
@@ -80,32 +94,34 @@ void bacct_add_tsk(struct taskstats *stats, struct task_struct *tsk)
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

