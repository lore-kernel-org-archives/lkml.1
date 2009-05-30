Return-Path: <linux-kernel-owner+w=401wt.eu-S1760659AbZE3WqF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760659AbZE3WqF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 May 2009 18:46:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759370AbZE3Wn1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 May 2009 18:43:27 -0400
Received: from mx2.redhat.com ([66.187.237.31]:48883 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759340AbZE3WnY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 May 2009 18:43:24 -0400
Date: Sun, 31 May 2009 00:38:39 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Roland McGrath <roland@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: [RFC PATCH 08/12 v3] ptrace: mv task->parent ptrace_ctx->tracer
Message-ID: <20090530223839.GA30511@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move task_struct->parent into ptrace_ctx->tracer and change the users
accordingly.

Most changes just do s/->parent/->ptrace_ctx-tracer/. Two "special"
cases are forget_original_parent() and format_mca_init_stack(), they
do not need to fixup ->parent any longer.

The next patch will add the helper to simplify/cleanup the usage of
->tracer.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 include/linux/sched.h     |    8 +-------
 include/linux/init_task.h |    1 -
 include/linux/ptrace.h    |   18 ++++++++++--------
 include/linux/tracehook.h |    4 ++--
 kernel/ptrace.c           |    8 ++++----
 kernel/exit.c             |    6 +-----
 kernel/signal.c           |   20 +++++++++++++-------
 arch/ia64/kernel/mca.c    |    2 +-
 8 files changed, 32 insertions(+), 35 deletions(-)

--- PTRACE/include/linux/sched.h~08_MV_PARENT	2009-05-30 23:28:49.000000000 +0200
+++ PTRACE/include/linux/sched.h	2009-05-30 23:32:47.000000000 +0200
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
--- PTRACE/include/linux/init_task.h~08_MV_PARENT	2009-05-30 21:18:35.000000000 +0200
+++ PTRACE/include/linux/init_task.h	2009-05-30 23:32:47.000000000 +0200
@@ -139,7 +139,6 @@ extern struct cred init_cred;
 	.ptraced	= LIST_HEAD_INIT(tsk.ptraced),			\
 	.ptrace_entry	= LIST_HEAD_INIT(tsk.ptrace_entry),		\
 	.real_parent	= &tsk,						\
-	.parent		= &tsk,						\
 	.children	= LIST_HEAD_INIT(tsk.children),			\
 	.sibling	= LIST_HEAD_INIT(tsk.sibling),			\
 	.group_leader	= &tsk,						\
--- PTRACE/include/linux/ptrace.h~08_MV_PARENT	2009-05-30 23:31:18.000000000 +0200
+++ PTRACE/include/linux/ptrace.h	2009-05-30 23:32:47.000000000 +0200
@@ -76,7 +76,8 @@
 #include <linux/sched.h>		/* For struct task_struct.  */
 
 struct ptrace_context {
-	unsigned long	flags;
+	unsigned long		flags;
+	struct task_struct	*tracer;
 };
 
 extern int alloc_ptrace_context(struct task_struct *child);
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
@@ -123,6 +119,12 @@ static inline int task_ptrace(struct tas
 		task->ptrace_ctx->flags : 0;
 }
 
+static inline int ptrace_reparented(struct task_struct *child)
+{
+	return unlikely(task_ptrace(child)) &&
+		child->ptrace_ctx->tracer != child->real_parent;
+}
+
 static inline void ptrace_unlink(struct task_struct *child)
 {
 	if (unlikely(task_ptrace(child)))
@@ -167,10 +169,10 @@ static inline void ptrace_init_task(stru
 {
 	INIT_LIST_HEAD(&child->ptrace_entry);
 	INIT_LIST_HEAD(&child->ptraced);
-	child->parent = child->real_parent;
 
 	if (unlikely(child->ptrace_ctx) && task_ptrace(current))
-		ptrace_link(child, task_ptrace(current), current->parent);
+		ptrace_link(child, task_ptrace(current),
+				current->ptrace_ctx->tracer);
 }
 
 /**
--- PTRACE/include/linux/tracehook.h~08_MV_PARENT	2009-05-30 23:05:12.000000000 +0200
+++ PTRACE/include/linux/tracehook.h	2009-05-30 23:32:47.000000000 +0200
@@ -171,8 +171,8 @@ static inline int tracehook_unsafe_exec(
  */
 static inline struct task_struct *tracehook_tracer_task(struct task_struct *tsk)
 {
-	if (task_ptrace(tsk) & PT_PTRACED)
-		return rcu_dereference(tsk->parent);
+	if (tsk->ptrace_ctx)
+		return rcu_dereference(tsk->ptrace_ctx->tracer);
 	return NULL;
 }
 
--- PTRACE/kernel/ptrace.c~08_MV_PARENT	2009-05-30 23:31:18.000000000 +0200
+++ PTRACE/kernel/ptrace.c	2009-05-30 23:32:47.000000000 +0200
@@ -47,7 +47,7 @@ void ptrace_link(struct task_struct *chi
 
 	BUG_ON(!list_empty(&child->ptrace_entry));
 	list_add(&child->ptrace_entry, &tracer->ptraced);
-	child->parent = tracer;
+	child->ptrace_ctx->tracer = tracer;
 }
 
 /*
@@ -85,7 +85,7 @@ void __ptrace_unlink(struct task_struct 
 	BUG_ON(!task_ptrace(child));
 
 	child->ptrace_ctx->flags = 0;
-	child->parent = child->real_parent;
+	child->ptrace_ctx->tracer = NULL;
 	list_del_init(&child->ptrace_entry);
 
 	arch_ptrace_untrace(child);
@@ -108,7 +108,7 @@ int ptrace_check_attach(struct task_stru
 	 * be changed by us so it's not changing right after this.
 	 */
 	read_lock(&tasklist_lock);
-	if (task_ptrace(child) && child->parent == current) {
+	if (task_ptrace(child) && child->ptrace_ctx->tracer == current) {
 		ret = 0;
 		/*
 		 * child->sighand can't be NULL, release_task()
@@ -269,7 +269,7 @@ int ptrace_traceme(void)
 	write_lock_irq(&tasklist_lock);
 	/* Are we already being traced? */
 	if (!task_ptrace(current)) {
-		ret = security_ptrace_traceme(current->parent);
+		ret = security_ptrace_traceme(current->real_parent);
 		/*
 		 * Check PF_EXITING to ensure ->real_parent has not passed
 		 * exit_ptrace(). Otherwise we don't report the error but
--- PTRACE/kernel/exit.c~08_MV_PARENT	2009-05-30 21:18:35.000000000 +0200
+++ PTRACE/kernel/exit.c	2009-05-30 23:32:47.000000000 +0200
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
--- PTRACE/kernel/signal.c~08_MV_PARENT	2009-05-30 21:52:00.000000000 +0200
+++ PTRACE/kernel/signal.c	2009-05-30 23:32:47.000000000 +0200
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
+		parent = tsk->ptrace_ctx->tracer;
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
+		parent = tsk->ptrace_ctx->tracer;
 	else {
 		tsk = tsk->group_leader;
 		parent = tsk->real_parent;
@@ -1544,7 +1550,7 @@ static inline int may_ptrace_stop(void)
 	 * is safe to enter schedule().
 	 */
 	if (unlikely(current->mm->core_state) &&
-	    unlikely(current->mm == current->parent->mm))
+	    unlikely(current->mm == current->ptrace_ctx->tracer->mm))
 		return 0;
 
 	return 1;
@@ -1777,7 +1783,7 @@ static int ptrace_signal(int signr, sigi
 		info->si_code = SI_USER;
 
 		rcu_read_lock();
-		tracer = current->parent;
+		tracer = current->ptrace_ctx->tracer;
 		if (task_ptrace(current)) {
 			info->si_pid = task_pid_vnr(tracer);
 			info->si_uid = task_uid(tracer);
--- PTRACE/arch/ia64/kernel/mca.c~08_MV_PARENT	2009-04-06 00:03:35.000000000 +0200
+++ PTRACE/arch/ia64/kernel/mca.c	2009-05-30 23:48:48.000000000 +0200
@@ -1795,7 +1795,7 @@ format_mca_init_stack(void *mca_data, un
 	p->state = TASK_UNINTERRUPTIBLE;
 	cpu_set(cpu, p->cpus_allowed);
 	INIT_LIST_HEAD(&p->tasks);
-	p->parent = p->real_parent = p->group_leader = p;
+	p->real_parent = p->group_leader = p;
 	INIT_LIST_HEAD(&p->children);
 	INIT_LIST_HEAD(&p->sibling);
 	strncpy(p->comm, type, sizeof(p->comm)-1);

