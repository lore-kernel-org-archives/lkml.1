Return-Path: <linux-kernel-owner+w=401wt.eu-S1759106AbYGQHaX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759106AbYGQHaX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 03:30:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759041AbYGQH3i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 03:29:38 -0400
Received: from mx1.redhat.com ([66.187.233.31]:53533 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758910AbYGQH3g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 03:29:36 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
X-Fcc: ~/Mail/linus
Subject: [PATCH 05/23] tracehook: clone
In-Reply-To: Roland McGrath's message of  Thursday, 17 July 2008 00:25:41 -0700 <20080717072541.F390E15411D@magilla.localdomain>
References: <20080717072541.F390E15411D@magilla.localdomain>
Emacs: Lovecraft was an optimist.
Message-Id: <20080717072901.5265715411D@magilla.localdomain>
Date: Thu, 17 Jul 2008 00:29:01 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This moves all the ptrace initialization and tracing logic for task
creation into tracehook.h and ptrace.h inlines.  It reorganizes the code
slightly, but should not change any behavior.

There are four tracehook entry points, at each important stage of task
creation.  This keeps the interface from the core fork.c code fairly clean,
while supporting the complex setup required for ptrace or something like it.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 include/linux/ptrace.h    |   22 ++++++++++
 include/linux/tracehook.h |  100 +++++++++++++++++++++++++++++++++++++++++++++
 kernel/fork.c             |   69 +++++++++++++------------------
 3 files changed, 150 insertions(+), 41 deletions(-)

diff --git a/include/linux/ptrace.h b/include/linux/ptrace.h
index c74abfc..dae6d85 100644
--- a/include/linux/ptrace.h
+++ b/include/linux/ptrace.h
@@ -154,6 +154,28 @@ static inline int ptrace_event(int mask, int event, unsigned long message)
 	return 1;
 }
 
+/**
+ * ptrace_init_task - initialize ptrace state for a new child
+ * @child:		new child task
+ * @ptrace:		true if child should be ptrace'd by parent's tracer
+ *
+ * This is called immediately after adding @child to its parent's children
+ * list.  @ptrace is false in the normal case, and true to ptrace @child.
+ *
+ * Called with current's siglock and write_lock_irq(&tasklist_lock) held.
+ */
+static inline void ptrace_init_task(struct task_struct *child, bool ptrace)
+{
+	INIT_LIST_HEAD(&child->ptrace_entry);
+	INIT_LIST_HEAD(&child->ptraced);
+	child->parent = child->real_parent;
+	child->ptrace = 0;
+	if (unlikely(ptrace)) {
+		child->ptrace = current->ptrace;
+		__ptrace_link(child, current->parent);
+	}
+}
+
 #ifndef force_successful_syscall_return
 /*
  * System call handlers that, upon successful completion, need to return a
diff --git a/include/linux/tracehook.h b/include/linux/tracehook.h
index 967ab47..3ebc58b 100644
--- a/include/linux/tracehook.h
+++ b/include/linux/tracehook.h
@@ -110,4 +110,104 @@ static inline void tracehook_report_exit(long *exit_code)
 	ptrace_event(PT_TRACE_EXIT, PTRACE_EVENT_EXIT, *exit_code);
 }
 
+/**
+ * tracehook_prepare_clone - prepare for new child to be cloned
+ * @clone_flags:	%CLONE_* flags from clone/fork/vfork system call
+ *
+ * This is called before a new user task is to be cloned.
+ * Its return value will be passed to tracehook_finish_clone().
+ *
+ * Called with no locks held.
+ */
+static inline int tracehook_prepare_clone(unsigned clone_flags)
+{
+	if (clone_flags & CLONE_UNTRACED)
+		return 0;
+
+	if (clone_flags & CLONE_VFORK) {
+		if (current->ptrace & PT_TRACE_VFORK)
+			return PTRACE_EVENT_VFORK;
+	} else if ((clone_flags & CSIGNAL) != SIGCHLD) {
+		if (current->ptrace & PT_TRACE_CLONE)
+			return PTRACE_EVENT_CLONE;
+	} else if (current->ptrace & PT_TRACE_FORK)
+		return PTRACE_EVENT_FORK;
+
+	return 0;
+}
+
+/**
+ * tracehook_finish_clone - new child created and being attached
+ * @child:		new child task
+ * @clone_flags:	%CLONE_* flags from clone/fork/vfork system call
+ * @trace:		return value from tracehook_clone_prepare()
+ *
+ * This is called immediately after adding @child to its parent's children list.
+ * The @trace value is that returned by tracehook_prepare_clone().
+ *
+ * Called with current's siglock and write_lock_irq(&tasklist_lock) held.
+ */
+static inline void tracehook_finish_clone(struct task_struct *child,
+					  unsigned long clone_flags, int trace)
+{
+	ptrace_init_task(child, (clone_flags & CLONE_PTRACE) || trace);
+}
+
+/**
+ * tracehook_report_clone - in parent, new child is about to start running
+ * @trace:		return value from tracehook_clone_prepare()
+ * @regs:		parent's user register state
+ * @clone_flags:	flags from parent's system call
+ * @pid:		new child's PID in the parent's namespace
+ * @child:		new child task
+ *
+ * Called after a child is set up, but before it has been started running.
+ * The @trace value is that returned by tracehook_clone_prepare().
+ * This is not a good place to block, because the child has not started yet.
+ * Suspend the child here if desired, and block in tracehook_clone_complete().
+ * This must prevent the child from self-reaping if tracehook_clone_complete()
+ * uses the @child pointer; otherwise it might have died and been released by
+ * the time tracehook_report_clone_complete() is called.
+ *
+ * Called with no locks held, but the child cannot run until this returns.
+ */
+static inline void tracehook_report_clone(int trace, struct pt_regs *regs,
+					  unsigned long clone_flags,
+					  pid_t pid, struct task_struct *child)
+{
+	if (unlikely(trace)) {
+		/*
+		 * The child starts up with an immediate SIGSTOP.
+		 */
+		sigaddset(&child->pending.signal, SIGSTOP);
+		set_tsk_thread_flag(child, TIF_SIGPENDING);
+	}
+}
+
+/**
+ * tracehook_report_clone_complete - new child is running
+ * @trace:		return value from tracehook_clone_prepare()
+ * @regs:		parent's user register state
+ * @clone_flags:	flags from parent's system call
+ * @pid:		new child's PID in the parent's namespace
+ * @child:		child task, already running
+ *
+ * This is called just after the child has started running.  This is
+ * just before the clone/fork syscall returns, or blocks for vfork
+ * child completion if @clone_flags has the %CLONE_VFORK bit set.
+ * The @child pointer may be invalid if a self-reaping child died and
+ * tracehook_report_clone() took no action to prevent it from self-reaping.
+ *
+ * Called with no locks held.
+ */
+static inline void tracehook_report_clone_complete(int trace,
+						   struct pt_regs *regs,
+						   unsigned long clone_flags,
+						   pid_t pid,
+						   struct task_struct *child)
+{
+	if (unlikely(trace))
+		ptrace_event(0, trace, pid);
+}
+
 #endif	/* <linux/tracehook.h> */
diff --git a/kernel/fork.c b/kernel/fork.c
index adefc11..56b6ab0 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -55,6 +55,7 @@
 #include <linux/tty.h>
 #include <linux/proc_fs.h>
 #include <linux/blkdev.h>
+#include <linux/tracehook.h>
 
 #include <asm/pgtable.h>
 #include <asm/pgalloc.h>
@@ -833,8 +834,7 @@ static void copy_flags(unsigned long clone_flags, struct task_struct *p)
 
 	new_flags &= ~PF_SUPERPRIV;
 	new_flags |= PF_FORKNOEXEC;
-	if (!(clone_flags & CLONE_PTRACE))
-		p->ptrace = 0;
+	new_flags |= PF_STARTING;
 	p->flags = new_flags;
 	clear_freeze_flag(p);
 }
@@ -875,7 +875,8 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 					struct pt_regs *regs,
 					unsigned long stack_size,
 					int __user *child_tidptr,
-					struct pid *pid)
+					struct pid *pid,
+					int trace)
 {
 	int retval;
 	struct task_struct *p;
@@ -1125,8 +1126,6 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 	 */
 	p->group_leader = p;
 	INIT_LIST_HEAD(&p->thread_group);
-	INIT_LIST_HEAD(&p->ptrace_entry);
-	INIT_LIST_HEAD(&p->ptraced);
 
 	/* Now that the task is set up, run cgroup callbacks if
 	 * necessary. We need to run them before the task is visible
@@ -1157,7 +1156,6 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 		p->real_parent = current->real_parent;
 	else
 		p->real_parent = current;
-	p->parent = p->real_parent;
 
 	spin_lock(&current->sighand->siglock);
 
@@ -1199,8 +1197,7 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 
 	if (likely(p->pid)) {
 		list_add_tail(&p->sibling, &p->real_parent->children);
-		if (unlikely(p->ptrace & PT_PTRACED))
-			__ptrace_link(p, current->parent);
+		tracehook_finish_clone(p, clone_flags, trace);
 
 		if (thread_group_leader(p)) {
 			if (clone_flags & CLONE_NEWPID)
@@ -1285,29 +1282,13 @@ struct task_struct * __cpuinit fork_idle(int cpu)
 	struct pt_regs regs;
 
 	task = copy_process(CLONE_VM, 0, idle_regs(&regs), 0, NULL,
-				&init_struct_pid);
+			    &init_struct_pid, 0);
 	if (!IS_ERR(task))
 		init_idle(task, cpu);
 
 	return task;
 }
 
-static int fork_traceflag(unsigned clone_flags)
-{
-	if (clone_flags & CLONE_UNTRACED)
-		return 0;
-	else if (clone_flags & CLONE_VFORK) {
-		if (current->ptrace & PT_TRACE_VFORK)
-			return PTRACE_EVENT_VFORK;
-	} else if ((clone_flags & CSIGNAL) != SIGCHLD) {
-		if (current->ptrace & PT_TRACE_CLONE)
-			return PTRACE_EVENT_CLONE;
-	} else if (current->ptrace & PT_TRACE_FORK)
-		return PTRACE_EVENT_FORK;
-
-	return 0;
-}
-
 /*
  *  Ok, this is the main fork-routine.
  *
@@ -1342,14 +1323,14 @@ long do_fork(unsigned long clone_flags,
 		}
 	}
 
-	if (unlikely(current->ptrace)) {
-		trace = fork_traceflag (clone_flags);
-		if (trace)
-			clone_flags |= CLONE_PTRACE;
-	}
+	/*
+	 * When called from kernel_thread, don't do user tracing stuff.
+	 */
+	if (likely(user_mode(regs)))
+		trace = tracehook_prepare_clone(clone_flags);
 
 	p = copy_process(clone_flags, stack_start, regs, stack_size,
-			child_tidptr, NULL);
+			 child_tidptr, NULL, trace);
 	/*
 	 * Do this prior waking up the new thread - the thread pointer
 	 * might get invalid after that point, if the thread exits quickly.
@@ -1367,24 +1348,30 @@ long do_fork(unsigned long clone_flags,
 			init_completion(&vfork);
 		}
 
-		if ((p->ptrace & PT_PTRACED) || (clone_flags & CLONE_STOPPED)) {
+		tracehook_report_clone(trace, regs, clone_flags, nr, p);
+
+		/*
+		 * We set PF_STARTING at creation in case tracing wants to
+		 * use this to distinguish a fully live task from one that
+		 * hasn't gotten to tracehook_report_clone() yet.  Now we
+		 * clear it and set the child going.
+		 */
+		p->flags &= ~PF_STARTING;
+
+		if (unlikely(clone_flags & CLONE_STOPPED)) {
 			/*
 			 * We'll start up with an immediate SIGSTOP.
 			 */
 			sigaddset(&p->pending.signal, SIGSTOP);
 			set_tsk_thread_flag(p, TIF_SIGPENDING);
-		}
-
-		if (!(clone_flags & CLONE_STOPPED))
-			wake_up_new_task(p, clone_flags);
-		else
 			__set_task_state(p, TASK_STOPPED);
-
-		if (unlikely (trace)) {
-			current->ptrace_message = nr;
-			ptrace_notify ((trace << 8) | SIGTRAP);
+		} else {
+			wake_up_new_task(p, clone_flags);
 		}
 
+		tracehook_report_clone_complete(trace, regs,
+						clone_flags, nr, p);
+
 		if (clone_flags & CLONE_VFORK) {
 			freezer_do_not_count();
 			wait_for_completion(&vfork);
