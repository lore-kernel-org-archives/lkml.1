Return-Path: <linux-kernel-owner+w=401wt.eu-S1758828AbZE1LlM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758828AbZE1LlM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 07:41:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757765AbZE1LkU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 07:40:20 -0400
Received: from mx2.redhat.com ([66.187.237.31]:57794 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757354AbZE1LkR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 07:40:17 -0400
Date: Thu, 28 May 2009 13:35:45 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Roland McGrath <roland@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: [RFC PATCH 4/12 v2] ptrace: introduce the empty "struct
	ptrace_context"
Message-ID: <20090528113545.GA18691@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Suggested by Roland.

Introduce the new "struct ptrace_context" and add the pointer to task_struct.
The next patches will move all ptrace-related fields from task_struct into
this struct. From now, if the task was ever ptraced it has ->ptrace_ctx
!= NULL. Freed by free_task() along with task_struct itself.

With utrace based ptrace we can move this struct into utrace_engine->data.

 include/linux/sched.h     |    1 +
 include/linux/ptrace.h    |    4 ++++
 include/linux/tracehook.h |   34 ++++++++++++++++++++++++++++++++++
 kernel/fork.c             |    5 +++++
 kernel/ptrace.c           |   36 +++++++++++++++++++++++++++++++++++-
 5 files changed, 79 insertions(+), 1 deletion(-)

--- PTRACE/include/linux/sched.h~3_STRUCT	2009-05-28 06:26:19.000000000 +0200
+++ PTRACE/include/linux/sched.h	2009-05-28 07:26:35.000000000 +0200
@@ -1201,6 +1201,7 @@ struct task_struct {
 	struct list_head sibling;	/* linkage in my parent's children list */
 	struct task_struct *group_leader;	/* threadgroup leader */
 
+	struct ptrace_context *ptrace_ctx;
 	/*
 	 * ptraced is the list of tasks this task is using ptrace on.
 	 * This includes both natural children and PTRACE_ATTACH targets.
--- PTRACE/include/linux/ptrace.h~3_STRUCT	2009-05-28 06:26:19.000000000 +0200
+++ PTRACE/include/linux/ptrace.h	2009-05-28 07:26:35.000000000 +0200
@@ -79,6 +79,10 @@
 #include <linux/compiler.h>		/* For unlikely.  */
 #include <linux/sched.h>		/* For struct task_struct.  */
 
+struct ptrace_context {
+};
+
+extern int alloc_ptrace_context(struct task_struct *child);
 
 extern long arch_ptrace(struct task_struct *child, long request, long addr, long data);
 extern int ptrace_traceme(void);
--- PTRACE/include/linux/tracehook.h~3_STRUCT	2009-05-28 06:26:19.000000000 +0200
+++ PTRACE/include/linux/tracehook.h	2009-05-28 07:39:21.000000000 +0200
@@ -243,6 +243,40 @@ static inline int tracehook_prepare_clon
 }
 
 /**
+ * tracehook_init_task - initialize the new task
+ * @task:		the task to initialize
+ * @clone_flags:	%CLONE_* flags from clone/fork/vfork system call
+ * @trace:		return value from tracehook_prepare_clone()
+ *
+ * This is called immediately after dup_task_struct().
+ * It must clear/reset any tracing state so that tracehook_free_task()
+ * will work safely if the task creation fails.  If the task creation
+ * succeeds, a tracehook_finish_clone() call will follow with locks
+ * held, before @task starts or is accessible to anyone else.
+ *
+ * Called with no locks held.
+ */
+static inline int tracehook_init_task(struct task_struct *task,
+					unsigned long clone_flags, int trace)
+{
+	task->ptrace_ctx = NULL;
+	if (unlikely((clone_flags & CLONE_PTRACE) || trace))
+		return alloc_ptrace_context(task);
+	return 0;
+}
+
+/**
+ * tracehook_free_task - task is about to be freed
+ * @task:		task that will be freed
+ *
+ * May be called from any context.
+ */
+static inline void tracehook_free_task(struct task_struct *task)
+{
+	kfree(task->ptrace_ctx);
+}
+
+/**
  * tracehook_finish_clone - new child created and being attached
  * @child:		new child task
  * @clone_flags:	%CLONE_* flags from clone/fork/vfork system call
--- PTRACE/kernel/fork.c~3_STRUCT	2009-05-28 06:26:19.000000000 +0200
+++ PTRACE/kernel/fork.c	2009-05-28 07:26:35.000000000 +0200
@@ -143,6 +143,7 @@ void free_task(struct task_struct *tsk)
 	free_thread_info(tsk->stack);
 	rt_mutex_debug_task_free(tsk);
 	ftrace_graph_exit_task(tsk);
+	tracehook_free_task(tsk);
 	free_task_struct(tsk);
 }
 EXPORT_SYMBOL(free_task);
@@ -982,6 +983,10 @@ static struct task_struct *copy_process(
 	if (!p)
 		goto fork_out;
 
+	retval = tracehook_init_task(p, clone_flags, trace);
+	if (retval)
+		goto bad_fork_free;
+
 	rt_mutex_init_task(p);
 
 #ifdef CONFIG_PROVE_LOCKING
--- PTRACE/kernel/ptrace.c~3_STRUCT	2009-05-28 06:26:19.000000000 +0200
+++ PTRACE/kernel/ptrace.c	2009-05-28 08:09:47.000000000 +0200
@@ -174,6 +174,32 @@ bool ptrace_may_access(struct task_struc
 	return !err;
 }
 
+/*
+ * Check the task has ->ptrace_ctx or alloc the new one. Called
+ * from preemptible context when we are going to attach to this task.
+ * Once allocated, ->ptrace_ctx is never freed until free_task().
+ */
+int alloc_ptrace_context(struct task_struct *tsk)
+{
+	struct ptrace_context *ptrace_ctx;
+
+	if (tsk->ptrace_ctx)
+		return 0;
+
+	ptrace_ctx = kzalloc(sizeof(*ptrace_ctx), GFP_KERNEL);
+	if (unlikely(!ptrace_ctx))
+		return -ENOMEM;
+
+	task_lock(tsk);
+	if (likely(!tsk->ptrace_ctx))
+		tsk->ptrace_ctx = ptrace_ctx;
+	else
+		kfree(ptrace_ctx);
+	task_unlock(tsk);
+
+	return 0;
+}
+
 int ptrace_attach(struct task_struct *task)
 {
 	int retval;
@@ -199,6 +225,10 @@ int ptrace_attach(struct task_struct *ta
 	if (retval)
 		goto unlock_creds;
 
+	retval = alloc_ptrace_context(task);
+	if (unlikely(retval))
+		goto unlock_creds;
+
 	write_lock_irq(&tasklist_lock);
 	retval = -EPERM;
 	if (unlikely(task->exit_state))
@@ -230,8 +260,12 @@ out:
  */
 int ptrace_traceme(void)
 {
-	int ret = -EPERM;
+	int ret = alloc_ptrace_context(current);
 
+	if (unlikely(ret))
+		return ret;
+
+	ret = -EPERM;
 	write_lock_irq(&tasklist_lock);
 	/* Are we already being traced? */
 	if (!task_ptrace(current)) {

