Return-Path: <linux-kernel-owner+w=401wt.eu-S1755174AbYJCKDR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755174AbYJCKDR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 06:03:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753292AbYJCKDD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 06:03:03 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:61870 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753318AbYJCKDA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 06:03:00 -0400
Message-ID: <48E5ED4D.4030102@cn.fujitsu.com>
Date: Fri, 03 Oct 2008 18:00:45 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH] signal, procfs: lock_task_sighand() do not need rcu_read_lock()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


lock_task_sighand() make sure task->sighand is being protected,
so we do not need rcu_read_lock().
[ exec() will get task->sighand->siglock before change task->sighand! ]

But code using rcu_read_lock() _just_ to protect lock_task_sighand()
only appear in procfs. (and some code in procfs use lock_task_sighand()
without such redundant protection.)

Other subsystem may put lock_task_sighand() into rcu_read_lock()
critical region, but these rcu_read_lock() are used for protecting
"for_each_process()", "find_task_by_vpid()" etc. , not for protecting
lock_task_sighand().

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/fs/proc/array.c b/fs/proc/array.c
index 71c9be5..1c8d7b5 100644
--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@ -261,7 +261,6 @@ static inline void task_sig(struct seq_file *m, struct task_struct *p)
 	sigemptyset(&ignored);
 	sigemptyset(&caught);
 
-	rcu_read_lock();
 	if (lock_task_sighand(p, &flags)) {
 		pending = p->pending.signal;
 		shpending = p->signal->shared_pending.signal;
@@ -272,7 +271,6 @@ static inline void task_sig(struct seq_file *m, struct task_struct *p)
 		qlim = p->signal->rlim[RLIMIT_SIGPENDING].rlim_cur;
 		unlock_task_sighand(p, &flags);
 	}
-	rcu_read_unlock();
 
 	seq_printf(m, "Threads:\t%d\n", num_threads);
 	seq_printf(m, "SigQ:\t%lu/%lu\n", qsize, qlim);
diff --git a/fs/proc/base.c b/fs/proc/base.c
index a28840b..bb63fa1 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -164,7 +164,6 @@ static struct fs_struct *get_fs_struct(struct task_struct *task)
 
 static int get_nr_threads(struct task_struct *tsk)
 {
-	/* Must be called with the rcu_read_lock held */
 	unsigned long flags;
 	int count = 0;
 
@@ -471,14 +470,10 @@ static int proc_pid_limits(struct task_struct *task, char *buffer)
 
 	struct rlimit rlim[RLIM_NLIMITS];
 
-	rcu_read_lock();
-	if (!lock_task_sighand(task,&flags)) {
-		rcu_read_unlock();
+	if (!lock_task_sighand(task, &flags))
 		return 0;
-	}
 	memcpy(rlim, task->signal->rlim, sizeof(struct rlimit) * RLIM_NLIMITS);
 	unlock_task_sighand(task, &flags);
-	rcu_read_unlock();
 
 	/*
 	 * print the file header
@@ -3088,9 +3083,7 @@ static int proc_task_getattr(struct vfsmount *mnt, struct dentry *dentry, struct
 	generic_fillattr(inode, stat);
 
 	if (p) {
-		rcu_read_lock();
 		stat->nlink += get_nr_threads(p);
-		rcu_read_unlock();
 		put_task_struct(p);
 	}
 
diff --git a/kernel/sched_debug.c b/kernel/sched_debug.c
index bbe6b31..ad958c1 100644
--- a/kernel/sched_debug.c
+++ b/kernel/sched_debug.c
@@ -333,12 +333,10 @@ void proc_sched_show_task(struct task_struct *p, struct seq_file *m)
 	unsigned long flags;
 	int num_threads = 1;
 
-	rcu_read_lock();
 	if (lock_task_sighand(p, &flags)) {
 		num_threads = atomic_read(&p->signal->count);
 		unlock_task_sighand(p, &flags);
 	}
-	rcu_read_unlock();
 
 	SEQ_printf(m, "%s (%d, #threads: %d)\n", p->comm, p->pid, num_threads);
 	SEQ_printf(m,






