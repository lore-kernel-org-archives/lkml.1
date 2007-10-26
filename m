Return-Path: <linux-kernel-owner+w=401wt.eu-S1757036AbXJZTht@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757036AbXJZTht (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 15:37:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751001AbXJZThm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 15:37:42 -0400
Received: from tomts13-srv.bellnexxia.net ([209.226.175.34]:61850 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750815AbXJZThl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 15:37:41 -0400
Date: Fri, 26 Oct 2007 15:37:38 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Andi Kleen <ak@muc.de>
Cc: linux-kernel@vger.kernel.org
Subject: Adding TIF_TRACE_KERNEL to x86_64
Message-ID: <20071026193738.GA1591@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 15:29:41 up 88 days, 19:48,  6 users,  load average: 0.95, 0.45, 0.44
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andi,

I am trying to add a TIF_TRACE_KERNEL to each architectures to have a
system-wide activation of syscall_trace. However, I get the following
issue on x86_64 : a few processes segfault and others get a GPF when I
enable the flag on all processes. I am starting to think that it might
be caused by an incorrect top of stack when we return from a
syscall/interrupt in these processes. It would happen if we get into the
following race:

1 - process A enters in a syscall, TIF_KERNEL_TRACE is cleared
2 - we activate TIF_KERNEL_TRACE
3 - process A returns from syscall (with wrong top of stack ?) -> segfault.

Am I on the right track ?

Can this be a concern with TIF_SYSCALL_TRACE also ? (potential race in
ptrace ?)

Thanks for you input,

Mathieu

My x86_64 flags patch for 2.6.23.1 looks like this:

---
 include/asm-x86_64/thread_info.h |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

Index: linux-2.6-lttng/include/asm-x86_64/thread_info.h
===================================================================
--- linux-2.6-lttng.orig/include/asm-x86_64/thread_info.h	2007-07-30 18:46:16.000000000 -0400
+++ linux-2.6-lttng/include/asm-x86_64/thread_info.h	2007-07-30 19:13:03.000000000 -0400
@@ -107,6 +107,7 @@ static inline struct thread_info *stack_
  * Warning: layout of LSW is hardcoded in entry.S
  */
 #define TIF_SYSCALL_TRACE	0	/* syscall trace active */
+#define TIF_KERNEL_TRACE	1	/* kernel trace active */
 #define TIF_SIGPENDING		2	/* signal pending */
 #define TIF_NEED_RESCHED	3	/* rescheduling necessary */
 #define TIF_SINGLESTEP		4	/* reenable singlestep on user return*/
@@ -125,6 +126,7 @@ static inline struct thread_info *stack_
 #define TIF_FREEZE		23	/* is freezing for suspend */
 
 #define _TIF_SYSCALL_TRACE	(1<<TIF_SYSCALL_TRACE)
+#define _TIF_KERNEL_TRACE	(1<<TIF_KERNEL_TRACE)
 #define _TIF_SIGPENDING		(1<<TIF_SIGPENDING)
 #define _TIF_SINGLESTEP		(1<<TIF_SINGLESTEP)
 #define _TIF_NEED_RESCHED	(1<<TIF_NEED_RESCHED)
@@ -142,7 +144,7 @@ static inline struct thread_info *stack_
 
 /* work to do on interrupt/exception return */
 #define _TIF_WORK_MASK \
-  (0x0000FFFF & ~(_TIF_SYSCALL_TRACE|_TIF_SYSCALL_AUDIT|_TIF_SINGLESTEP|_TIF_SECCOMP))
+  (0x0000FFFF & ~(_TIF_SYSCALL_TRACE|_TIF_SYSCALL_AUDIT|_TIF_KERNEL_TRACE|_TIF_SINGLESTEP|_TIF_SECCOMP))
 /* work to do on any return to user space */
 #define _TIF_ALLWORK_MASK (0x0000FFFF & ~_TIF_SECCOMP)
 
And the code to activate/deactivate the flags:

---
 include/linux/sched.h |    3 +++
 kernel/fork.c         |    9 +++++++++
 kernel/sched.c        |   42 ++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 54 insertions(+)

Index: linux-2.6-lttng/include/linux/sched.h
===================================================================
--- linux-2.6-lttng.orig/include/linux/sched.h	2007-10-12 12:02:09.000000000 -0400
+++ linux-2.6-lttng/include/linux/sched.h	2007-10-12 12:11:23.000000000 -0400
@@ -1953,6 +1953,9 @@ static inline void inc_syscw(struct task
 }
 #endif
 
+extern void clear_kernel_trace_flag_all_tasks(void);
+extern void set_kernel_trace_flag_all_tasks(void);
+
 #endif /* __KERNEL__ */
 
 #endif
Index: linux-2.6-lttng/kernel/fork.c
===================================================================
--- linux-2.6-lttng.orig/kernel/fork.c	2007-10-12 12:02:18.000000000 -0400
+++ linux-2.6-lttng/kernel/fork.c	2007-10-12 12:11:23.000000000 -0400
@@ -1241,6 +1241,15 @@ static struct task_struct *copy_process(
 			!cpu_online(task_cpu(p))))
 		set_task_cpu(p, smp_processor_id());
 
+	/*
+	 * The state of the parent's TIF_KTRACE flag may have changed
+	 * since it was copied in dup_task_struct() so we re-copy it here.
+	 */
+	if (test_thread_flag(TIF_KERNEL_TRACE))
+		set_tsk_thread_flag(p, TIF_KERNEL_TRACE);
+	else
+		clear_tsk_thread_flag(p, TIF_KERNEL_TRACE);
+
 	/* CLONE_PARENT re-uses the old parent */
 	if (clone_flags & (CLONE_PARENT|CLONE_THREAD))
 		p->real_parent = current->real_parent;
Index: linux-2.6-lttng/kernel/sched.c
===================================================================
--- linux-2.6-lttng.orig/kernel/sched.c	2007-10-12 12:02:17.000000000 -0400
+++ linux-2.6-lttng/kernel/sched.c	2007-10-12 12:11:55.000000000 -0400
@@ -7032,3 +7032,45 @@ struct cgroup_subsys cpu_cgroup_subsys =
 };
 
 #endif	/* CONFIG_FAIR_CGROUP_SCHED */
+
+/**
+ * clear_kernel_trace_flag_all_tasks - clears all TIF_KERNEL_TRACE thread flags.
+ *
+ * This function iterates on all threads in the system to clear their
+ * TIF_KERNEL_TRACE flag. Setting the TIF_KERNEL_TRACE flag with the
+ * tasklist_lock held in copy_process() makes sure that once we finish clearing
+ * the thread flags, all threads have their flags cleared.
+ */
+void clear_kernel_trace_flag_all_tasks(void)
+{
+	struct task_struct *p;
+	struct task_struct *t;
+
+	read_lock(&tasklist_lock);
+	do_each_thread(p, t) {
+		clear_tsk_thread_flag(t, TIF_KERNEL_TRACE);
+	} while_each_thread(p, t);
+	read_unlock(&tasklist_lock);
+}
+EXPORT_SYMBOL_GPL(clear_kernel_trace_flag_all_tasks);
+
+/**
+ * set_kernel_trace_flag_all_tasks - sets all TIF_KERNEL_TRACE thread flags.
+ *
+ * This function iterates on all threads in the system to set their
+ * TIF_KERNEL_TRACE flag. Setting the TIF_KERNEL_TRACE flag with the
+ * tasklist_lock held in copy_process() makes sure that once we finish setting
+ * the thread flags, all threads have their flags set.
+ */
+void set_kernel_trace_flag_all_tasks(void)
+{
+	struct task_struct *p;
+	struct task_struct *t;
+
+	read_lock(&tasklist_lock);
+	do_each_thread(p, t) {
+		set_tsk_thread_flag(t, TIF_KERNEL_TRACE);
+	} while_each_thread(p, t);
+	read_unlock(&tasklist_lock);
+}
+EXPORT_SYMBOL_GPL(set_kernel_trace_flag_all_tasks);


-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
