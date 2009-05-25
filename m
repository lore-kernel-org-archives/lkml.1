Return-Path: <linux-kernel-owner+w=401wt.eu-S1755314AbZEYAGF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755314AbZEYAGF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 20:06:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758290AbZEYAEz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 20:04:55 -0400
Received: from mx2.redhat.com ([66.187.237.31]:38504 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758214AbZEYAEx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 20:04:53 -0400
Date: Mon, 25 May 2009 02:00:16 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Roland McGrath <roland@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: [RFC PATCH 7/X] ptrace: mv task->parent ptrace_task->pt_tracer
Message-ID: <20090525000016.GA2239@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move task_struct->parent into ptrace_task->pt_tracer and change the users
accordingly.

The next patches will add the helper to simplify/cleanup the usage of
->pt_tracer, and unify do_notify_parent/do_notify_parent_cldstop.

 include/linux/sched.h     |    8 +-------
 include/linux/init_task.h |    1 -
 include/linux/ptrace.h    |   18 ++++++++++--------
 include/linux/tracehook.h |    4 ++--
 kernel/ptrace.c           |    8 ++++----
 kernel/exit.c             |   18 +++++++-----------
 kernel/signal.c           |   24 +++++++++++++++---------
 7 files changed, 39 insertions(+), 42 deletions(-)

--- PTRACE/include/linux/sched.h~7_MV_PARENT	2009-05-24 23:10:47.000000000 +0200
+++ PTRACE/include/linux/sched.h	2009-05-25 00:17:28.000000000 +0200
@@ -1186,13 +1186,7 @@ struct task_struct {
 	/* Canary value for the -fstack-protector gcc feature */
 	unsigned long stack_canary;
 
-	/* 
-	 * pointers to (original) parent process, youngest child, younger sibling,
-	 * older sibling, respectively.  (p->father can be replaced with 
-	 * p->real_parent->pid)
-	 */
-	struct task_struct *real_parent; /* real parent process */
-	struct task_struct *parent; /* recipient of SIGCHLD, wait4() reports */
+	struct task_struct *real_parent; /* parent process */
 	/*
 	 * children/sibling forms the list of my natural children
 	 */
--- PTRACE/include/linux/init_task.h~7_MV_PARENT	2009-04-15 12:53:58.000000000 +0200
+++ PTRACE/include/linux/init_task.h	2009-05-25 01:30:35.000000000 +0200
@@ -139,7 +139,6 @@ extern struct cred init_cred;
 	.ptraced	= LIST_HEAD_INIT(tsk.ptraced),			\
 	.ptrace_entry	= LIST_HEAD_INIT(tsk.ptrace_entry),		\
 	.real_parent	= &tsk,						\
-	.parent		= &tsk,						\
 	.children	= LIST_HEAD_INIT(tsk.children),			\
 	.sibling	= LIST_HEAD_INIT(tsk.sibling),			\
 	.group_leader	= &tsk,						\
--- PTRACE/include/linux/ptrace.h~7_MV_PARENT	2009-05-24 23:38:10.000000000 +0200
+++ PTRACE/include/linux/ptrace.h	2009-05-25 00:27:38.000000000 +0200
@@ -76,7 +76,8 @@
 #include <linux/sched.h>		/* For struct task_struct.  */
 
 struct ptrace_task {
-	unsigned long	pt_flags;
+	unsigned long		pt_flags;
+	struct task_struct	*pt_tracer;
 };
 
 extern int alloc_ptrace_task(struct task_struct *child);
@@ -103,11 +104,6 @@ extern int __ptrace_may_access(struct ta
 /* Returns true on success, false on denial. */
 extern bool ptrace_may_access(struct task_struct *task, unsigned int mode);
 
-static inline int ptrace_reparented(struct task_struct *child)
-{
-	return child->real_parent != child->parent;
-}
-
 /**
  * task_ptrace - return %PT_* flags that apply to a task
  * @task:	pointer to &task_struct in question
@@ -120,6 +116,12 @@ static inline int task_ptrace(struct tas
 		task->ptrace_task->pt_flags : 0;
 }
 
+static inline int ptrace_reparented(struct task_struct *child)
+{
+	return unlikely(task_ptrace(child)) &&
+		child->ptrace_task->pt_tracer != child->real_parent;
+}
+
 static inline void ptrace_unlink(struct task_struct *child)
 {
 	if (unlikely(task_ptrace(child)))
@@ -164,10 +166,10 @@ static inline void ptrace_init_task(stru
 {
 	INIT_LIST_HEAD(&child->ptrace_entry);
 	INIT_LIST_HEAD(&child->ptraced);
-	child->parent = child->real_parent;
 
 	if (unlikely(child->ptrace_task) && task_ptrace(current))
-		ptrace_link(child, task_ptrace(current), current->parent);
+		ptrace_link(child, task_ptrace(current),
+				current->ptrace_task->pt_tracer);
 }
 
 /**
--- PTRACE/include/linux/tracehook.h~7_MV_PARENT	2009-05-24 22:15:08.000000000 +0200
+++ PTRACE/include/linux/tracehook.h	2009-05-25 01:51:11.000000000 +0200
@@ -171,8 +171,8 @@ static inline int tracehook_unsafe_exec(
  */
 static inline struct task_struct *tracehook_tracer_task(struct task_struct *tsk)
 {
-	if (task_ptrace(tsk) & PT_PTRACED)
-		return rcu_dereference(tsk->parent);
+	if (tsk->ptrace_task)
+		return rcu_dereference(tsk->ptrace_task->pt_tracer);
 	return NULL;
 }
 
--- PTRACE/kernel/ptrace.c~7_MV_PARENT	2009-05-25 00:03:45.000000000 +0200
+++ PTRACE/kernel/ptrace.c	2009-05-25 00:41:10.000000000 +0200
@@ -47,7 +47,7 @@ void ptrace_link(struct task_struct *chi
 
 	BUG_ON(!list_empty(&child->ptrace_entry));
 	list_add(&child->ptrace_entry, &tracer->ptraced);
-	child->parent = tracer;
+	child->ptrace_task->pt_tracer = tracer;
 }
 
 /*
@@ -85,7 +85,7 @@ void __ptrace_unlink(struct task_struct 
 	BUG_ON(!task_ptrace(child));
 
 	child->ptrace_task->pt_flags = 0;
-	child->parent = child->real_parent;
+	child->ptrace_task->pt_tracer = NULL;
 	list_del_init(&child->ptrace_entry);
 
 	arch_ptrace_untrace(child);
@@ -108,7 +108,7 @@ int ptrace_check_attach(struct task_stru
 	 * be changed by us so it's not changing right after this.
 	 */
 	read_lock(&tasklist_lock);
-	if (task_ptrace(child) && child->parent == current) {
+	if (task_ptrace(child) && child->ptrace_task->pt_tracer == current) {
 		ret = 0;
 		/*
 		 * child->sighand can't be NULL, release_task()
@@ -259,7 +259,7 @@ int ptrace_traceme(void)
 	write_lock_irq(&tasklist_lock);
 	/* Are we already being traced? */
 	if (!task_ptrace(current)) {
-		ret = security_ptrace_traceme(current->parent);
+		ret = security_ptrace_traceme(current->real_parent);
 		/*
 		 * Check PF_EXITING to ensure ->real_parent has not passed
 		 * exit_ptrace(). Otherwise we don't report the error but
--- PTRACE/kernel/exit.c~7_MV_PARENT	2009-05-20 16:00:52.000000000 +0200
+++ PTRACE/kernel/exit.c	2009-05-25 00:49:27.000000000 +0200
@@ -336,7 +336,7 @@ static void reparent_to_kthreadd(void)
 
 	ptrace_unlink(current);
 	/* Reparent to init */
-	current->real_parent = current->parent = kthreadd_task;
+	current->real_parent = kthreadd_task;
 	list_move_tail(&current->sibling, &current->real_parent->children);
 
 	/* Set the exit signal to SIGCHLD so we signal init on exit */
@@ -780,10 +780,6 @@ static void forget_original_parent(struc
 
 	list_for_each_entry_safe(p, n, &father->children, sibling) {
 		p->real_parent = reaper;
-		if (p->parent == father) {
-			BUG_ON(task_ptrace(p));
-			p->parent = p->real_parent;
-		}
 		reparent_thread(father, p, &dead_children);
 	}
 	write_unlock_irq(&tasklist_lock);
@@ -1210,17 +1206,17 @@ static int wait_task_zombie(struct wait_
 		 * p->signal fields, because they are only touched by
 		 * __exit_signal, which runs with tasklist_lock
 		 * write-locked anyway, and so is excluded here.  We do
-		 * need to protect the access to p->parent->signal fields,
-		 * as other threads in the parent group can be right
-		 * here reaping other children at the same time.
+		 * need to protect the access to p->real_parent->signal
+		 * fields, as other threads in the parent group can be
+		 * right here reaping other children at the same time.
 		 *
 		 * We use thread_group_cputime() to get times for the thread
 		 * group, which consolidates times for all threads in the
 		 * group including the group leader.
 		 */
 		thread_group_cputime(p, &cputime);
-		spin_lock_irq(&p->parent->sighand->siglock);
-		psig = p->parent->signal;
+		spin_lock_irq(&p->real_parent->sighand->siglock);
+		psig = p->real_parent->signal;
 		sig = p->signal;
 		psig->cutime =
 			cputime_add(psig->cutime,
@@ -1251,7 +1247,7 @@ static int wait_task_zombie(struct wait_
 			sig->oublock + sig->coublock;
 		task_io_accounting_add(&psig->ioac, &p->ioac);
 		task_io_accounting_add(&psig->ioac, &sig->ioac);
-		spin_unlock_irq(&p->parent->sighand->siglock);
+		spin_unlock_irq(&p->real_parent->sighand->siglock);
 	}
 
 	/*
--- PTRACE/kernel/signal.c~7_MV_PARENT	2009-04-29 15:45:28.000000000 +0200
+++ PTRACE/kernel/signal.c	2009-05-25 01:22:58.000000000 +0200
@@ -1399,6 +1399,7 @@ int do_notify_parent(struct task_struct 
 {
 	struct siginfo info;
 	unsigned long flags;
+	struct task_struct *parent;
 	struct sighand_struct *psig;
 	int ret = sig;
 
@@ -1410,6 +1411,11 @@ int do_notify_parent(struct task_struct 
 	BUG_ON(!task_ptrace(tsk) &&
 	       (tsk->group_leader != tsk || !thread_group_empty(tsk)));
 
+	if (task_ptrace(tsk))
+		parent = tsk->ptrace_task->pt_tracer;
+	else
+		parent = tsk->real_parent;
+
 	info.si_signo = sig;
 	info.si_errno = 0;
 	/*
@@ -1425,7 +1431,7 @@ int do_notify_parent(struct task_struct 
 	 * correct to rely on this
 	 */
 	rcu_read_lock();
-	info.si_pid = task_pid_nr_ns(tsk, tsk->parent->nsproxy->pid_ns);
+	info.si_pid = task_pid_nr_ns(tsk, parent->nsproxy->pid_ns);
 	info.si_uid = __task_cred(tsk)->uid;
 	rcu_read_unlock();
 
@@ -1444,7 +1450,7 @@ int do_notify_parent(struct task_struct 
 		info.si_status = tsk->exit_code >> 8;
 	}
 
-	psig = tsk->parent->sighand;
+	psig = parent->sighand;
 	spin_lock_irqsave(&psig->siglock, flags);
 	if (!task_ptrace(tsk) && sig == SIGCHLD &&
 	    (psig->action[SIGCHLD-1].sa.sa_handler == SIG_IGN ||
@@ -1469,8 +1475,8 @@ int do_notify_parent(struct task_struct 
 			sig = -1;
 	}
 	if (valid_signal(sig) && sig > 0)
-		__group_send_sig_info(sig, &info, tsk->parent);
-	__wake_up_parent(tsk, tsk->parent);
+		__group_send_sig_info(sig, &info, parent);
+	__wake_up_parent(tsk, parent);
 	spin_unlock_irqrestore(&psig->siglock, flags);
 
 	return ret;
@@ -1484,7 +1490,7 @@ static void do_notify_parent_cldstop(str
 	struct sighand_struct *sighand;
 
 	if (task_ptrace(tsk))
-		parent = tsk->parent;
+		parent = tsk->ptrace_task->pt_tracer;
 	else {
 		tsk = tsk->group_leader;
 		parent = tsk->real_parent;
@@ -1496,7 +1502,7 @@ static void do_notify_parent_cldstop(str
 	 * see comment in do_notify_parent() abot the following 3 lines
 	 */
 	rcu_read_lock();
-	info.si_pid = task_pid_nr_ns(tsk, tsk->parent->nsproxy->pid_ns);
+	info.si_pid = task_pid_nr_ns(tsk, parent->nsproxy->pid_ns);
 	info.si_uid = __task_cred(tsk)->uid;
 	rcu_read_unlock();
 
@@ -1544,7 +1550,7 @@ static inline int may_ptrace_stop(void)
 	 * is safe to enter schedule().
 	 */
 	if (unlikely(current->mm->core_state) &&
-	    unlikely(current->mm == current->parent->mm))
+	    unlikely(current->mm == current->ptrace_task->pt_tracer->mm))
 		return 0;
 
 	return 1;
@@ -1773,8 +1779,8 @@ static int ptrace_signal(int signr, sigi
 		info->si_signo = signr;
 		info->si_errno = 0;
 		info->si_code = SI_USER;
-		info->si_pid = task_pid_vnr(current->parent);
-		info->si_uid = task_uid(current->parent);
+		info->si_pid = task_pid_vnr(current->ptrace_task->pt_tracer);
+		info->si_uid = task_uid(current->ptrace_task->pt_tracer);
 	}
 
 	/* If the (new) signal is now blocked, requeue it.  */

