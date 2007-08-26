Return-Path: <linux-kernel-owner+w=401wt.eu-S1751975AbXHZJp0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751975AbXHZJp0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2007 05:45:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751530AbXHZJpL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Aug 2007 05:45:11 -0400
Received: from smtp3-g19.free.fr ([212.27.42.29]:54156 "EHLO smtp3-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750952AbXHZJpH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Aug 2007 05:45:07 -0400
Date: Sun, 26 Aug 2007 11:44:47 +0200
From: Guillaume Chazarain <guichaz@yahoo.fr>
To: balbir@linux.vnet.ibm.com
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jay Lan <jlan@engr.sgi.com>, Jonathan Lim <jlim@sgi.com>
Subject: Re: [PATCH] Add all thread stats for TASKSTATS_CMD_ATTR_TGID
Message-ID: <20070826114447.24464d22@localhost.localdomain>
In-Reply-To: <46D10884.6040401@linux.vnet.ibm.com>
References: <3d8471ca0708020653l575db8cam464a3cffce68fb26@mail.gmail.com>
	<20070802120427.270e5589.akpm@linux-foundation.org>
	<20070819213435.72b287ad@localhost.localdomain>
	<46C9C8D4.9080108@linux.vnet.ibm.com>
	<20070825171039.3bc73781@localhost.localdomain>
	<46D10884.6040401@linux.vnet.ibm.com>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Le Sun, 26 Aug 2007 10:28:44 +0530,
Balbir Singh <balbir@linux.vnet.ibm.com> a écrit :

> From what I understand, task->start_time and task->real_start_time
> are taken from the realtime clock. The accounting in CSA seems
> to be very similar to the accounting done in do_acct_process()
> (kernel/acct.c).
> 
> Jay/Jonathan any comments?

Thanks, I see it is used to have a wall time version of btime.
Here is my current version of the refactoring for information.
The testcase is coming.

diff -r 27877ed82082 include/linux/tsacct_kern.h
--- a/include/linux/tsacct_kern.h	Sat Aug 25 22:17:19 2007 +0200
+++ b/include/linux/tsacct_kern.h	Sat Aug 25 21:48:51 2007 +0200
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
diff -r 27877ed82082 kernel/taskstats.c
--- a/kernel/taskstats.c	Sat Aug 25 22:17:19 2007 +0200
+++ b/kernel/taskstats.c	Sat Aug 25 22:11:23 2007 +0200
@@ -168,6 +168,55 @@ static void send_cpu_listeners(struct sk
 	up_write(&listeners->sem);
 }
 
+/*
+ * Common stats for each thread in the thread group, @task is not necessarily
+ * a thread group leader.
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
+/*
+ * Stats specific to each thread in the thread group. add_tsk() works in
+ * conjunction with fill_threadgroup(), both may write to the same field, so
+ * the ordering of these two calls indicates if the caller wants stats for the
+ * whole thread group or a specific thread.
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
@@ -185,23 +234,8 @@ static int fill_pid(pid_t pid, struct ta
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
@@ -233,31 +267,16 @@ static int fill_tgid(pid_t tgid, struct 
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
+			add_tsk(stats, tsk);
+	while_each_thread(first, tsk);
+
+	fill_threadgroup(stats, first);
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
 
@@ -265,21 +284,16 @@ static void fill_tgid_exit(struct task_s
 static void fill_tgid_exit(struct task_struct *tsk)
 {
 	unsigned long flags;
+	struct taskstats *tg_stats;
 
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
+	tg_stats = tsk->signal->stats;
+
+	/* fill_threadgroup() will be called by the stats requester */
+	if (tg_stats)
+		add_tsk(tg_stats, tsk);
+
 	spin_unlock_irqrestore(&tsk->sighand->siglock, flags);
-	return;
 }
 
 static int add_del_listener(pid_t pid, cpumask_t *maskp, int isadd)
diff -r 27877ed82082 kernel/tsacct.c
--- a/kernel/tsacct.c	Sat Aug 25 22:17:19 2007 +0200
+++ b/kernel/tsacct.c	Sat Aug 25 21:48:51 2007 +0200
@@ -22,50 +22,71 @@
 #include <linux/acct.h>
 #include <linux/jiffies.h>
 
-/*
- * fill in basic accounting fields
- */
-void bacct_add_tsk(struct taskstats *stats, struct task_struct *tsk)
+static void fill_wall_time(struct taskstats *stats, struct task_struct *task)
 {
 	struct timespec uptime, ts;
 	s64 ac_etime;
 
+	/* calculate task elapsed time in timespec */
+	do_posix_clock_monotonic_gettime(&uptime);
+	ts = timespec_sub(uptime, task->start_time);
+
+	stats->ac_btime	= get_seconds() - ts.tv_sec;
+
+	ac_etime = timespec_to_ns(&ts);
+	do_div(ac_etime, NSEC_PER_USEC);
+	stats->ac_etime	= ac_etime;
+}
+
+/*
+ * fill in basic accounting fields
+ */
+
+void bacct_fill_threadgroup(struct taskstats *stats, struct task_struct *task)
+{
+	struct task_struct *leader;
+
 	BUILD_BUG_ON(TS_COMM_LEN < TASK_COMM_LEN);
 
-	/* calculate task elapsed time in timespec */
-	do_posix_clock_monotonic_gettime(&uptime);
-	ts = timespec_sub(uptime, tsk->start_time);
-	/* rebase elapsed time to usec */
-	ac_etime = timespec_to_ns(&ts);
-	do_div(ac_etime, NSEC_PER_USEC);
-	stats->ac_etime = ac_etime;
-	stats->ac_btime = get_seconds() - ts.tv_sec;
-	if (thread_group_leader(tsk)) {
-		stats->ac_exitcode = tsk->exit_code;
-		if (tsk->flags & PF_FORKNOEXEC)
+	rcu_read_lock();
+	stats->ac_ppid	= pid_alive(task) ?
+				rcu_dereference(task->real_parent)->tgid : 0;
+	rcu_read_unlock();
+
+	leader = task->group_leader;
+	get_task_struct(leader);
+	fill_wall_time(stats, leader);
+	put_task_struct(leader);
+
+	stats->ac_nice	= task_nice(task);
+	stats->ac_sched	= task->policy;
+	stats->ac_uid	= task->uid;
+	stats->ac_gid	= task->gid;
+	stats->ac_pid	= task->pid;
+
+	strncpy(stats->ac_comm, task->comm, sizeof(stats->ac_comm));
+}
+
+void bacct_add_tsk(struct taskstats *stats, struct task_struct *task)
+{
+	if (thread_group_leader(task)) {
+		stats->ac_exitcode = task->exit_code;
+		if (task->flags & PF_FORKNOEXEC)
 			stats->ac_flag |= AFORK;
 	}
-	if (tsk->flags & PF_SUPERPRIV)
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
 
-	strncpy(stats->ac_comm, tsk->comm, sizeof(stats->ac_comm));
+	fill_wall_time(stats, task);
+
+	stats->ac_utime	 += cputime_to_msecs(task->utime) * USEC_PER_MSEC;
+	stats->ac_stime	 += cputime_to_msecs(task->stime) * USEC_PER_MSEC;
+	stats->ac_minflt += task->min_flt;
+	stats->ac_majflt += task->maj_flt;
 }
 
 
@@ -76,32 +97,34 @@ void bacct_add_tsk(struct taskstats *sta
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

-- 
Guillaume
