Return-Path: <linux-kernel-owner+w=401wt.eu-S1757902AbYHZWEP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757902AbYHZWEP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 18:04:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752206AbYHZWD7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 18:03:59 -0400
Received: from mx2.redhat.com ([66.187.237.31]:58580 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752053AbYHZWD5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 18:03:57 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
X-Fcc: ~/Mail/linus
Subject: [PATCH 2/2] utrace: ptrace cooperation
In-Reply-To: Roland McGrath's message of  Tuesday, 26 August 2008 15:01:02 -0700 <20080826220102.89635154233@magilla.localdomain>
References: <20080826220102.89635154233@magilla.localdomain>
X-Windows: it could be worse, but it'll take time.
Message-Id: <20080826220237.66B3D154233@magilla.localdomain>
Date: Tue, 26 Aug 2008 15:02:37 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This adds the CONFIG_UTRACE_PTRACE option under CONFIG_UTRACE.
When set, parts of ptrace are replaced so it uses the utrace
facilities for noticing events, stopping and resuming threads.

This makes ptrace play nicely with other utrace-based things
tracing the same threads.  It also makes all ptrace uses rely on
some of the utrace code working right, even when you are not
using any other utrace-based things.  So it's experimental and
not real well proven yet.  But it's recommended if you enable
CONFIG_UTRACE and want to try new utrace things.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 include/linux/ptrace.h    |   21 ++
 include/linux/sched.h     |    1 +
 include/linux/tracehook.h |    4 +
 init/Kconfig              |   17 ++
 kernel/ptrace.c           |  604 ++++++++++++++++++++++++++++++++++++++++++++-
 kernel/signal.c           |   14 +-
 kernel/utrace.c           |   15 ++
 7 files changed, 670 insertions(+), 6 deletions(-)

diff --git a/include/linux/ptrace.h b/include/linux/ptrace.h
index ea7416c..06eaace 100644
--- a/include/linux/ptrace.h
+++ b/include/linux/ptrace.h
@@ -121,6 +121,7 @@ static inline void ptrace_unlink(struct task_struct *child)
 int generic_ptrace_peekdata(struct task_struct *tsk, long addr, long data);
 int generic_ptrace_pokedata(struct task_struct *tsk, long addr, long data);
 
+#ifndef CONFIG_UTRACE_PTRACE
 /**
  * task_ptrace - return %PT_* flags that apply to a task
  * @task:	pointer to &task_struct in question
@@ -154,6 +155,26 @@ static inline int ptrace_event(int mask, int event, unsigned long message)
 	return 1;
 }
 
+static inline void ptrace_utrace_exit(struct task_struct *task)
+{
+}
+
+#else  /* CONFIG_UTRACE_PTRACE */
+
+static inline int task_ptrace(struct task_struct *task)
+{
+	return 0;
+}
+
+static inline int ptrace_event(int mask, int event, unsigned long message)
+{
+	return 0;
+}
+
+extern void ptrace_utrace_exit(struct task_struct *);
+
+#endif	/* !CONFIG_UTRACE_PTRACE */
+
 /**
  * ptrace_init_task - initialize ptrace state for a new child
  * @child:		new child task
diff --git a/include/linux/sched.h b/include/linux/sched.h
index c58f771..581c487 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1773,6 +1773,7 @@ extern int kill_pgrp(struct pid *pid, int sig, int priv);
 extern int kill_pid(struct pid *pid, int sig, int priv);
 extern int kill_proc_info(int, struct siginfo *, pid_t);
 extern int do_notify_parent(struct task_struct *, int);
+extern void do_notify_parent_cldstop(struct task_struct *, int);
 extern void force_sig(int, struct task_struct *);
 extern void force_sig_specific(int, struct task_struct *);
 extern int send_sig(int, struct task_struct *, int);
diff --git a/include/linux/tracehook.h b/include/linux/tracehook.h
index 632a787..717a1c8 100644
--- a/include/linux/tracehook.h
+++ b/include/linux/tracehook.h
@@ -228,6 +228,8 @@ static inline void tracehook_report_exit(long *exit_code)
 	if (unlikely(task_utrace_flags(current) & UTRACE_EVENT(EXIT)))
 		utrace_report_exit(exit_code);
 	ptrace_event(PT_TRACE_EXIT, PTRACE_EVENT_EXIT, *exit_code);
+	if (unlikely(!list_empty(&current->ptraced)))
+		ptrace_utrace_exit(current);
 }
 
 /**
@@ -418,8 +420,10 @@ static inline void tracehook_signal_handler(int sig, siginfo_t *info,
 {
 	if (task_utrace_flags(current))
 		utrace_signal_handler(current, stepping);
+#ifndef CONFIG_UTRACE_PTRACE
 	if (stepping)
 		ptrace_notify(SIGTRAP);
+#endif
 }
 
 /**
diff --git a/init/Kconfig b/init/Kconfig
index 89cbc74..a2b8ea8 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -908,6 +908,23 @@ menuconfig UTRACE
 	  kernel interface exported to kernel modules, to track events in
 	  user threads, extract and change user thread state.
 
+config UTRACE_PTRACE
+	bool "utrace-based ptrace (EXPERIMENTAL)"
+	default y if UTRACE
+	depends on UTRACE
+	help
+	  This changes the implementation of ptrace() to cooperate with
+	  the utrace facility.  Without this option, using any utrace
+	  facility on a task that anything also uses ptrace() on (i.e.
+	  usual debuggers, strace, etc) can have confusing and unreliable
+	  results.  With this option, the ptrace() implementation is
+	  changed to work via utrace facilities and the two cooperate well.
+
+	  It's recommended to enable this if you are experimenting with
+	  new modules that use utrace.  But, disabling it makes sure that
+	  using traditional ptrace() on tasks not touched by utrace will
+	  not use any experimental new code that might be unreliable.
+
 source "block/Kconfig"
 
 config PREEMPT_NOTIFIERS
diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index 356699a..9734661 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -16,6 +16,7 @@
 #include <linux/pagemap.h>
 #include <linux/smp_lock.h>
 #include <linux/ptrace.h>
+#include <linux/utrace.h>
 #include <linux/security.h>
 #include <linux/signal.h>
 #include <linux/audit.h>
@@ -38,6 +39,7 @@ void __ptrace_link(struct task_struct *child, struct task_struct *new_parent)
 	child->parent = new_parent;
 }
  
+#ifndef CONFIG_UTRACE_PTRACE
 /*
  * Turn a tracing stop into a normal stop now, since with no tracer there
  * would be no way to wake it up with SIGCONT or SIGKILL.  If there was a
@@ -58,6 +60,54 @@ void ptrace_untrace(struct task_struct *child)
 	spin_unlock(&child->sighand->siglock);
 }
 
+static void ptrace_finish(struct task_struct *child)
+{
+	if (task_is_traced(child))
+		ptrace_untrace(child);
+}
+
+static void ptrace_detach_task(struct task_struct *child)
+{
+	/* Architecture-specific hardware disable .. */
+	ptrace_disable(child);
+	clear_tsk_thread_flag(child, TIF_SYSCALL_TRACE);
+}
+
+static void utrace_engine_put(struct utrace_attached_engine *engine)
+{
+}
+
+#else  /* CONFIG_UTRACE_PTRACE */
+
+static const struct utrace_engine_ops ptrace_utrace_ops; /* forward decl */
+
+static void ptrace_detach_task(struct task_struct *child)
+{
+	struct utrace_attached_engine *engine;
+	engine = utrace_attach_task(child, UTRACE_ATTACH_MATCH_OPS,
+				    &ptrace_utrace_ops, NULL);
+	if (likely(!IS_ERR(engine))) {
+		int ret = utrace_control(child, engine, UTRACE_DETACH);
+		WARN_ON(ret && ret != -ESRCH);
+		utrace_engine_put(engine);
+	}
+}
+
+void ptrace_utrace_exit(struct task_struct *task)
+{
+	struct task_struct *child;
+	read_lock(&tasklist_lock);
+	list_for_each_entry(child, &task->ptraced, ptrace_entry)
+		ptrace_detach_task(child);
+	read_unlock(&tasklist_lock);
+}
+
+static void ptrace_finish(struct task_struct *child)
+{
+}
+
+#endif	/* !CONFIG_UTRACE_PTRACE */
+
 /*
  * unptrace a task: move it back to its original parent and
  * remove it from the ptrace list.
@@ -72,10 +122,11 @@ void __ptrace_unlink(struct task_struct *child)
 	child->parent = child->real_parent;
 	list_del_init(&child->ptrace_entry);
 
-	if (task_is_traced(child))
-		ptrace_untrace(child);
+	ptrace_finish(child);
 }
 
+#ifndef CONFIG_UTRACE_PTRACE
+
 /*
  * Check that we have indeed attached to the thing..
  */
@@ -113,6 +164,457 @@ int ptrace_check_attach(struct task_struct *child, int kill)
 	return ret;
 }
 
+static struct utrace_attached_engine *ptrace_attach_utrace(
+	struct task_struct *task)
+{
+	return NULL;
+}
+
+static void ptrace_detach_utrace(struct task_struct *task,
+				 struct utrace_attached_engine *engine)
+{
+}
+
+static int ptrace_update_utrace(struct task_struct *task,
+				struct utrace_attached_engine *engine)
+{
+	return 0;
+}
+
+#else	/* CONFIG_UTRACE_PTRACE */
+
+static int ptrace_update_utrace(struct task_struct *task,
+				struct utrace_attached_engine *engine)
+{
+	unsigned long events;
+
+	/*
+	 * We need this for resume handling.
+	 */
+	events = UTRACE_EVENT(QUIESCE);
+
+	/*
+	 * These events are always reported.
+	 */
+	events |= UTRACE_EVENT(EXEC) | UTRACE_EVENT_SIGNAL_ALL;
+
+	/*
+	 * We always have to examine clone events to check for CLONE_PTRACE.
+	 */
+	events |= UTRACE_EVENT(CLONE);
+
+	/*
+	 * PTRACE_SETOPTIONS can request more events.
+	 */
+	if (task->ptrace & PT_TRACE_EXIT)
+		events |= UTRACE_EVENT(EXIT);
+
+	if (!engine) {
+		int ret;
+		engine = utrace_attach_task(task, UTRACE_ATTACH_MATCH_OPS,
+					    &ptrace_utrace_ops, NULL);
+		if (IS_ERR(engine))
+			return -ESRCH;
+		ret = utrace_set_events(task, engine, events);
+		utrace_engine_put(engine);
+		return ret;
+	}
+
+	return utrace_set_events(task, engine, events);
+}
+
+static int ptrace_unsafe_exec(struct utrace_attached_engine *engine,
+			      struct task_struct *task)
+{
+	if (task->ptrace & PT_PTRACE_CAP)
+		return LSM_UNSAFE_PTRACE_CAP;
+
+	return LSM_UNSAFE_PTRACE;
+}
+
+static struct task_struct *ptrace_tracer_task(
+	struct utrace_attached_engine *engine, struct task_struct *target)
+{
+	return target->parent;
+}
+
+static void ptrace_set_action(struct task_struct *task,
+			      enum utrace_resume_action action,
+			      enum utrace_syscall_action syscall)
+{
+	task->ptrace &= ~((UTRACE_SYSCALL_MASK | UTRACE_RESUME_MASK) << 16);
+	task->ptrace |= ((UTRACE_RESUME - action) | syscall) << 16;
+}
+
+static enum utrace_resume_action ptrace_resume_action(struct task_struct *task)
+{
+	return UTRACE_RESUME - ((task->ptrace >> 16) & UTRACE_RESUME_MASK);
+}
+
+static enum utrace_syscall_action ptrace_syscall_action(
+	struct task_struct *task)
+{
+	return (task->ptrace >> 16) & UTRACE_SYSCALL_MASK;
+}
+
+static u32 utrace_ptrace_report(u32 action, struct task_struct *task, int code)
+{
+	/*
+	 * Special kludge magic in utrace.c (utrace_stop) sees this
+	 * and calls do_notify_parent_cldstop() for us.  This kludge
+	 * is necessary to keep that wakeup after we enter TASK_TRACED.
+	 */
+	ptrace_set_action(task, UTRACE_STOP, 0);
+
+	task->exit_code = code;
+
+	return action | UTRACE_STOP;
+}
+
+static u32 utrace_ptrace_event(struct task_struct *task,
+			       int event, unsigned long msg)
+{
+	task->ptrace_message = msg;
+	return utrace_ptrace_report(0, task, (event << 8) | SIGTRAP);
+}
+
+static u32 ptrace_report_exec(enum utrace_resume_action action,
+			      struct utrace_attached_engine *engine,
+			      struct task_struct *task,
+			      const struct linux_binfmt *fmt,
+			      const struct linux_binprm *bprm,
+			      struct pt_regs *regs)
+{
+	if (task->ptrace & PT_TRACE_EXEC)
+		return utrace_ptrace_event(task, PTRACE_EVENT_EXEC, 0);
+
+	/*
+	 * Old-fashioned ptrace'd exec just posts a plain signal.
+	 */
+	send_sig(SIGTRAP, task, 0);
+	return UTRACE_RESUME;
+}
+
+static u32 ptrace_report_exit(enum utrace_resume_action action,
+			      struct utrace_attached_engine *engine,
+			      struct task_struct *task,
+			      long orig_code, long *code)
+{
+	return utrace_ptrace_event(task, PTRACE_EVENT_EXIT, *code);
+}
+
+#define	PT_VFORKING	PT_DTRACE /* reuse obsolete bit */
+
+static u32 ptrace_report_clone(enum utrace_resume_action action,
+			       struct utrace_attached_engine *engine,
+			       struct task_struct *parent,
+			       unsigned long clone_flags,
+			       struct task_struct *child)
+{
+	int event;
+	struct utrace_attached_engine *child_engine;
+
+	/*
+	 * To simulate vfork-done tracing, we'll have to catch the
+	 * parent's syscall-exit event for this vfork/clone system call.
+	 * Since PTRACE_SETOPTIONS can enable PTRACE_O_TRACEVFORKDONE
+	 * during the PTRACE_EVENT_VFORK stop, we must do this if either
+	 * is enabled right now.
+	 */
+	if ((clone_flags & CLONE_VFORK) &&
+	    (parent->ptrace & (PT_TRACE_VFORK | PT_TRACE_VFORK_DONE))) {
+		if (!(engine->flags & UTRACE_EVENT(SYSCALL_EXIT))) {
+			int ret = utrace_set_events(parent, engine,
+						    engine->flags |
+						    UTRACE_EVENT(SYSCALL_EXIT));
+			WARN_ON(ret);
+		}
+		parent->ptrace |= PT_VFORKING;
+	}
+
+	if (clone_flags & CLONE_UNTRACED)
+		return UTRACE_RESUME;
+
+	event = 0;
+	if (clone_flags & CLONE_VFORK) {
+		if (parent->ptrace & PT_TRACE_VFORK)
+			event = PTRACE_EVENT_VFORK;
+	} else if ((clone_flags & CSIGNAL) != SIGCHLD) {
+		if (parent->ptrace & PT_TRACE_CLONE)
+			event = PTRACE_EVENT_CLONE;
+	} else if (parent->ptrace & PT_TRACE_FORK) {
+		event = PTRACE_EVENT_FORK;
+	}
+
+	if (!event)
+		return UTRACE_RESUME;
+
+	/*
+	 * Any of these reports implies auto-attaching the new child.
+	 */
+	child_engine = utrace_attach_task(child, UTRACE_ATTACH_CREATE |
+					  UTRACE_ATTACH_EXCLUSIVE |
+					  UTRACE_ATTACH_MATCH_OPS,
+					  &ptrace_utrace_ops, NULL);
+	if (unlikely(IS_ERR(child_engine))) {
+		WARN_ON(1);	/* XXX */
+	} else {
+		/* XXX already set by old ptrace code
+		task_lock(child);
+		child->ptrace = parent->ptrace;
+		child->parent = parent->parent;
+		task_unlock(child);
+		*/
+		ptrace_update_utrace(child, child_engine);
+		utrace_engine_put(child_engine);
+	}
+
+	return utrace_ptrace_event(parent, event, child->pid);
+}
+
+
+static u32 ptrace_report_syscall(u32 action, struct task_struct *task)
+{
+	int code = SIGTRAP;
+	if (task->ptrace & PT_TRACESYSGOOD)
+		code |= 0x80;
+	return utrace_ptrace_report(action, task, code);
+}
+
+static u32 ptrace_report_syscall_entry(u32 action,
+				       struct utrace_attached_engine *engine,
+				       struct task_struct *task,
+				       struct pt_regs *regs)
+{
+	/*
+	 * If we're doing PTRACE_SYSEMU, just punt here and report
+	 * at the exit stop instead.
+	 */
+	if (ptrace_syscall_action(task))
+		return UTRACE_SYSCALL_ABORT | UTRACE_RESUME;
+
+	return ptrace_report_syscall(UTRACE_SYSCALL_RUN, task);
+}
+
+static u32 ptrace_report_syscall_exit(enum utrace_resume_action action,
+				      struct utrace_attached_engine *engine,
+				      struct task_struct *task,
+				      struct pt_regs *regs)
+{
+	if (!(engine->flags & UTRACE_EVENT(SYSCALL_ENTRY))) {
+		/*
+		 * We were not really using PTRACE_SYSCALL.
+		 * SYSCALL_EXIT was only caught for vfork-done tracing.
+		 */
+		int ret = utrace_set_events(
+			task, engine,
+			engine->flags & ~UTRACE_EVENT(SYSCALL_EXIT));
+		WARN_ON(ret);
+		WARN_ON(!(task->ptrace & PT_VFORKING));
+		task->ptrace &= ~PT_VFORKING;
+		return utrace_ptrace_event(task, PTRACE_EVENT_VFORK_DONE, 0);
+	}
+
+	if (task->ptrace & PT_VFORKING) {
+		/*
+		 * If we're reporting vfork-done, we'll have to
+		 * remember to report syscall-exit after that.
+		 */
+		if (task->ptrace & PT_TRACE_VFORK_DONE)
+			return utrace_ptrace_event(task,
+						   PTRACE_EVENT_VFORK_DONE, 0);
+		task->ptrace &= ~PT_VFORKING;
+	}
+
+	if (unlikely(ptrace_syscall_action(task)) &&
+	    unlikely(ptrace_resume_action(task) == UTRACE_SINGLESTEP))
+		/*
+		 * This is PTRACE_SYSEMU_SINGLESTEP.
+		 * Kludge: Prevent arch code from sending a SIGTRAP
+		 * after tracehook_report_syscall_exit() returns.
+		 */
+		user_disable_single_step(task);
+
+	return ptrace_report_syscall(0, task);
+}
+
+static u32 ptrace_resumed(struct task_struct *task, struct pt_regs *regs,
+			  siginfo_t *info, struct k_sigaction *return_ka)
+{
+	/*
+	 * This is not a new signal, but just a notification we
+	 * asked for.  Either we're stopping after another report
+	 * like exec or syscall, or we're resuming.
+	 */
+	if (ptrace_resume_action(task) == UTRACE_STOP)
+		return UTRACE_SIGNAL_REPORT | UTRACE_STOP;
+
+	/*
+	 * We're resuming.  If there's no signal to deliver, just go.
+	 * If we were given a signal, deliver it now.
+	 */
+	task->last_siginfo = NULL;
+	if (!task->exit_code)
+		return UTRACE_SIGNAL_REPORT | ptrace_resume_action(task);
+
+	/* Update the siginfo structure if the signal has
+	   changed.  If the debugger wanted something
+	   specific in the siginfo structure then it should
+	   have updated *info via PTRACE_SETSIGINFO.  */
+	if (task->exit_code != info->si_signo) {
+		info->si_signo = task->exit_code;
+		info->si_errno = 0;
+		info->si_code = SI_USER;
+		info->si_pid = task_pid_vnr(task->parent);
+		info->si_uid = task->parent->uid;
+	}
+
+	task->exit_code = 0;
+
+	spin_lock_irq(&task->sighand->siglock);
+	*return_ka = task->sighand->action[info->si_signo - 1];
+	spin_unlock_irq(&task->sighand->siglock);
+
+	return UTRACE_SIGNAL_DELIVER | ptrace_resume_action(task);
+}
+
+static u32 ptrace_report_signal(u32 action,
+				struct utrace_attached_engine *engine,
+				struct task_struct *task,
+				struct pt_regs *regs,
+				siginfo_t *info,
+				const struct k_sigaction *orig_ka,
+				struct k_sigaction *return_ka)
+{
+	/*
+	 * Deal with a pending vfork-done event.  We'll stop again now
+	 * for the syscall-exit report that was replaced with vfork-done.
+	 */
+	if (unlikely(task->ptrace & PT_VFORKING)) {
+		task->ptrace &= ~PT_VFORKING;
+		if ((engine->flags & UTRACE_EVENT(SYSCALL_ENTRY)) &&
+		    utrace_signal_action(action) == UTRACE_SIGNAL_REPORT) {
+			/*
+			 * Make sure we get another report on wakeup.
+			 */
+			int x = utrace_control(task, engine, UTRACE_INTERRUPT);
+			WARN_ON(x);
+			return ptrace_report_syscall(UTRACE_SIGNAL_REPORT,
+						     task);
+		}
+	}
+
+	switch (utrace_signal_action(action)) {
+	default:
+		break;
+	case UTRACE_SIGNAL_HANDLER:
+		/*
+		 * A handler was set up.  If we are stepping, pretend
+		 * another SIGTRAP arrived.
+		 */
+		if (ptrace_resume_action(task) == UTRACE_SINGLESTEP ||
+		    ptrace_resume_action(task) == UTRACE_BLOCKSTEP) {
+			memset(info, 0, sizeof *info);
+			info->si_signo = SIGTRAP;
+			info->si_code = SIGTRAP;
+			info->si_pid = task_pid_vnr(task);
+			info->si_uid = task->uid;
+			break;
+		}
+		/* Fall through.  */
+	case UTRACE_SIGNAL_REPORT:
+		return ptrace_resumed(task, regs, info, return_ka);
+	}
+
+	task->last_siginfo = info;
+	return utrace_ptrace_report(UTRACE_SIGNAL_IGN, task, info->si_signo);
+}
+
+static u32 ptrace_report_quiesce(u32 action,
+				 struct utrace_attached_engine *engine,
+				 struct task_struct *task,
+				 unsigned long event)
+{
+	/*
+	 * Make sure we deal with a pending vfork-done event (see above).
+	 */
+	if (unlikely(task->ptrace & PT_VFORKING))
+		return UTRACE_INTERRUPT;
+
+	task->last_siginfo = NULL;
+	return ptrace_resume_action(task);
+}
+
+static const struct utrace_engine_ops ptrace_utrace_ops = {
+	.tracer_task = ptrace_tracer_task,
+	.unsafe_exec = ptrace_unsafe_exec,
+	.report_signal = ptrace_report_signal,
+	.report_quiesce = ptrace_report_quiesce,
+	.report_exec = ptrace_report_exec,
+	.report_exit = ptrace_report_exit,
+	.report_clone = ptrace_report_clone,
+	.report_syscall_entry = ptrace_report_syscall_entry,
+	.report_syscall_exit = ptrace_report_syscall_exit,
+};
+
+/*
+ * Detach the utrace engine.
+ */
+static void ptrace_detach_utrace(struct task_struct *task,
+				 struct utrace_attached_engine *engine)
+{
+	int ret = utrace_control(task, engine, UTRACE_DETACH);
+	WARN_ON(ret && ret != -ESRCH);
+}
+
+/*
+ * Attach a utrace engine for ptrace and set up its event mask.
+ * Returns the engine pointer or an IS_ERR() pointer.
+ */
+static struct utrace_attached_engine *ptrace_attach_utrace(
+	struct task_struct *child)
+{
+	struct utrace_attached_engine *engine;
+	engine = utrace_attach_task(child, UTRACE_ATTACH_CREATE |
+				    UTRACE_ATTACH_EXCLUSIVE |
+				    UTRACE_ATTACH_MATCH_OPS,
+				    &ptrace_utrace_ops, NULL);
+	if (IS_ERR(engine))
+		return engine;
+	if (likely(!ptrace_update_utrace(child, engine)))
+		return engine;
+	ptrace_detach_utrace(child, engine);
+	utrace_engine_put(engine);
+	return ERR_PTR(-ESRCH);
+}
+
+int ptrace_check_attach(struct task_struct *child, int kill)
+{
+	struct utrace_attached_engine *engine;
+	struct utrace_examiner exam;
+	int ret;
+
+	engine = utrace_attach_task(child, UTRACE_ATTACH_MATCH_OPS,
+				    &ptrace_utrace_ops, NULL);
+	if (IS_ERR(engine))
+		return -ESRCH;
+
+	/*
+	 * Make sure our engine has already stopped the child.
+	 * Then wait for it to be off the CPU.
+	 */
+	ret = 0;
+	if (utrace_control(child, engine, UTRACE_STOP) ||
+	    utrace_prepare_examine(child, engine, &exam))
+		ret = -ESRCH;
+
+	utrace_engine_put(engine);
+
+	return ret;
+}
+
+#endif	/* !CONFIG_UTRACE_PTRACE */
+
 int __ptrace_may_access(struct task_struct *task, unsigned int mode)
 {
 	/* May we inspect the given task?
@@ -156,6 +658,7 @@ int ptrace_attach(struct task_struct *task)
 {
 	int retval;
 	unsigned long flags;
+	struct utrace_attached_engine *engine;
 
 	audit_ptrace(task);
 
@@ -163,6 +666,13 @@ int ptrace_attach(struct task_struct *task)
 	if (same_thread_group(task, current))
 		goto out;
 
+	engine = ptrace_attach_utrace(task);
+	if (unlikely(IS_ERR(engine))) {
+		if (PTR_ERR(engine) == -ESRCH)
+			retval = -ESRCH;
+		goto out;
+	}
+
 repeat:
 	/*
 	 * Nasty, nasty.
@@ -202,6 +712,11 @@ repeat:
 bad:
 	write_unlock_irqrestore(&tasklist_lock, flags);
 	task_unlock(task);
+	if (!IS_ERR(engine)) {
+		if (retval)
+			ptrace_detach_utrace(task, engine);
+		utrace_engine_put(engine);
+	}
 out:
 	return retval;
 }
@@ -221,9 +736,7 @@ int ptrace_detach(struct task_struct *child, unsigned int data)
 	if (!valid_signal(data))
 		return -EIO;
 
-	/* Architecture-specific hardware disable .. */
-	ptrace_disable(child);
-	clear_tsk_thread_flag(child, TIF_SYSCALL_TRACE);
+	ptrace_detach_task(child);
 
 	write_lock_irq(&tasklist_lock);
 	/* protect against de_thread()->release_task() */
@@ -309,6 +822,8 @@ static int ptrace_setoptions(struct task_struct *child, long data)
 	if (data & PTRACE_O_TRACEEXIT)
 		child->ptrace |= PT_TRACE_EXIT;
 
+	ptrace_update_utrace(child, NULL);
+
 	return (data & ~PTRACE_O_MASK) ? -EINVAL : 0;
 }
 
@@ -367,6 +882,7 @@ static int ptrace_setsiginfo(struct task_struct *child, const siginfo_t *info)
 #define is_sysemu_singlestep(request)	0
 #endif
 
+#ifndef CONFIG_UTRACE_PTRACE
 static int ptrace_resume(struct task_struct *child, long request, long data)
 {
 	if (!valid_signal(data))
@@ -401,6 +917,76 @@ static int ptrace_resume(struct task_struct *child, long request, long data)
 
 	return 0;
 }
+#else  /* CONFIG_UTRACE_PTRACE */
+static int ptrace_resume(struct task_struct *child, long request, long data)
+{
+	struct utrace_attached_engine *engine;
+	enum utrace_resume_action action;
+	enum utrace_syscall_action syscall;
+	int ret = 0;
+
+	if (!valid_signal(data))
+		return -EIO;
+
+	engine = utrace_attach_task(child, UTRACE_ATTACH_MATCH_OPS,
+				    &ptrace_utrace_ops, NULL);
+	if (IS_ERR(engine))
+		return -ESRCH;
+
+	syscall = UTRACE_SYSCALL_RUN;
+#ifdef PTRACE_SYSEMU
+	if (request == PTRACE_SYSEMU || request == PTRACE_SYSEMU_SINGLESTEP)
+		syscall = UTRACE_SYSCALL_ABORT;
+#endif
+
+	if (syscall != UTRACE_SYSCALL_RUN || request == PTRACE_SYSCALL) {
+		if (!(engine->flags & UTRACE_EVENT_SYSCALL) &&
+		    utrace_set_events(child, engine,
+				      engine->flags | UTRACE_EVENT_SYSCALL))
+			ret = -ESRCH;
+	} else if (engine->flags & UTRACE_EVENT(SYSCALL_ENTRY)) {
+		if (utrace_set_events(child, engine,
+				      engine->flags & ~UTRACE_EVENT_SYSCALL))
+			ret = -ESRCH;
+	}
+
+	action = UTRACE_RESUME;
+	if (is_singleblock(request)) {
+		if (unlikely(!arch_has_block_step()))
+			ret = -EIO;
+		action = UTRACE_BLOCKSTEP;
+	} else if (is_singlestep(request) || is_sysemu_singlestep(request)) {
+		if (unlikely(!arch_has_single_step()))
+			ret = -EIO;
+		action = UTRACE_SINGLESTEP;
+	}
+
+	if (!ret) {
+		child->exit_code = data;
+
+		ptrace_set_action(child, action, syscall);
+
+		if (task_is_stopped(child)) {
+			spin_lock_irq(&child->sighand->siglock);
+			child->signal->flags &= ~SIGNAL_STOP_STOPPED;
+			spin_unlock_irq(&child->sighand->siglock);
+		}
+
+		/*
+		 * To resume with a signal we must hit ptrace_report_signal.
+		 */
+		if (data)
+			action = UTRACE_INTERRUPT;
+
+		if (utrace_control(child, engine, action))
+			ret = -ESRCH;
+	}
+
+	utrace_engine_put(engine);
+
+	return ret;
+}
+#endif	/* !CONFIG_UTRACE_PTRACE */
 
 int ptrace_request(struct task_struct *child, long request,
 		   long addr, long data)
@@ -480,6 +1066,11 @@ int ptrace_request(struct task_struct *child, long request,
 int ptrace_traceme(void)
 {
 	int ret = -EPERM;
+	struct utrace_attached_engine *engine;
+
+	engine = ptrace_attach_utrace(current);
+	if (unlikely(IS_ERR(engine)))
+		return ret;
 
 	/*
 	 * Are we already being traced?
@@ -513,6 +1104,9 @@ repeat:
 		write_unlock_irqrestore(&tasklist_lock, flags);
 	}
 	task_unlock(current);
+	if (ret)
+		ptrace_detach_utrace(current, engine);
+	utrace_engine_put(engine);
 	return ret;
 }
 
diff --git a/kernel/signal.c b/kernel/signal.c
index e661b01..1effefc 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -1415,7 +1415,7 @@ int do_notify_parent(struct task_struct *tsk, int sig)
 	return ret;
 }
 
-static void do_notify_parent_cldstop(struct task_struct *tsk, int why)
+void do_notify_parent_cldstop(struct task_struct *tsk, int why)
 {
 	struct siginfo info;
 	unsigned long flags;
@@ -1470,6 +1470,8 @@ static void do_notify_parent_cldstop(struct task_struct *tsk, int why)
 	spin_unlock_irqrestore(&sighand->siglock, flags);
 }
 
+#ifndef CONFIG_UTRACE_PTRACE
+
 static inline int may_ptrace_stop(void)
 {
 	if (!likely(current->ptrace & PT_PTRACED))
@@ -1602,6 +1604,8 @@ void ptrace_notify(int exit_code)
 	spin_unlock_irq(&current->sighand->siglock);
 }
 
+#endif	/* !CONFIG_UTRACE_PTRACE */
+
 static void
 finish_stop(int stop_count)
 {
@@ -1679,6 +1683,7 @@ static int do_signal_stop(int signr)
 	return 1;
 }
 
+#ifndef CONFIG_UTRACE_PTRACE
 static int ptrace_signal(int signr, siginfo_t *info,
 			 struct pt_regs *regs, void *cookie)
 {
@@ -1717,6 +1722,13 @@ static int ptrace_signal(int signr, siginfo_t *info,
 
 	return signr;
 }
+#else
+static int ptrace_signal(int signr, siginfo_t *info,
+			 struct pt_regs *regs, void *cookie)
+{
+	return signr;
+}
+#endif
 
 int get_signal_to_deliver(siginfo_t *info, struct k_sigaction *return_ka,
 			  struct pt_regs *regs, void *cookie)
diff --git a/kernel/utrace.c b/kernel/utrace.c
index 918e7cf..aad2181 100644
--- a/kernel/utrace.c
+++ b/kernel/utrace.c
@@ -501,6 +501,21 @@ static bool utrace_stop(struct task_struct *task, struct utrace *utrace)
 	spin_unlock_irq(&task->sighand->siglock);
 	spin_unlock(&utrace->lock);
 
+#ifdef CONFIG_UTRACE_PTRACE
+	/*
+	 * If ptrace is among the reasons for this stop, do its
+	 * notification now.  This could not just be done in
+	 * ptrace's own event report callbacks because it has to
+	 * be done after we are in TASK_TRACED.  This makes the
+	 * synchronization with ptrace_do_wait() work right.
+	 */
+	if ((task->ptrace >> 16) == UTRACE_RESUME - UTRACE_STOP) {
+		read_lock(&tasklist_lock);
+		do_notify_parent_cldstop(task, CLD_TRAPPED);
+		read_unlock(&tasklist_lock);
+	}
+#endif
+
 	schedule();
 
 	/*
