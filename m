Return-Path: <linux-kernel-owner+w=401wt.eu-S1756096AbZEIQwV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756096AbZEIQwV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 May 2009 12:52:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755043AbZEIQtO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 May 2009 12:49:14 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:54453 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755119AbZEIQtL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 May 2009 12:49:11 -0400
Message-Id: <20090509162351.408352245@polymtl.ca>
References: <20090509162209.217414024@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Sat, 09 May 2009 12:22:29 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, "Frank Ch. Eigler" <fche@redhat.com>,
       Jason Baron <jbaron@redhat.com>, Tom Zanussi <tzanussi@gmail.com>,
       fweisbec@gmail.com, laijs@cn.fujitsu.com, rostedt@goodmis.org,
       peterz@infradead.org, jiayingz@google.com, roland@redhat.com,
       mbligh@google.com
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [RFC patch 20/20] LTTng Kernel Trace Thread Flag API
Content-Disposition: inline; filename=lttng-kernel-trace-thread-flag-api.patch
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Sat,  9 May 2009 16:47:20 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add an API to set/clear the kernel wide tracing thread flags. Implemented in
kernel/sched.c. Updates thread flags *asynchronously* while holding the tasklist
read lock.

Upon fork, the flag must be re-copied while the tasklist write lock is held.

We are holding the read lock only to make sure we don't delay thread creation
for too long while iterating on all threads.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
---
 include/linux/sched.h |    3 ++
 kernel/fork.c         |    9 ++++++++
 kernel/sched.c        |   55 ++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 67 insertions(+)

Index: linux-2.6-lttng/include/linux/sched.h
===================================================================
--- linux-2.6-lttng.orig/include/linux/sched.h	2009-04-23 14:56:14.000000000 -0400
+++ linux-2.6-lttng/include/linux/sched.h	2009-04-23 14:56:47.000000000 -0400
@@ -2403,6 +2403,9 @@ static inline void mm_init_owner(struct 
 
 #define TASK_STATE_TO_CHAR_STR "RSDTtZX"
 
+extern void clear_kernel_trace_flag_all_tasks(void);
+extern void set_kernel_trace_flag_all_tasks(void);
+
 #endif /* __KERNEL__ */
 
 #endif
Index: linux-2.6-lttng/kernel/fork.c
===================================================================
--- linux-2.6-lttng.orig/kernel/fork.c	2009-04-23 14:56:14.000000000 -0400
+++ linux-2.6-lttng/kernel/fork.c	2009-04-23 14:56:47.000000000 -0400
@@ -1209,6 +1209,15 @@ static struct task_struct *copy_process(
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
 	if (clone_flags & (CLONE_PARENT|CLONE_THREAD)) {
 		p->real_parent = current->real_parent;
Index: linux-2.6-lttng/kernel/sched.c
===================================================================
--- linux-2.6-lttng.orig/kernel/sched.c	2009-04-23 14:56:14.000000000 -0400
+++ linux-2.6-lttng/kernel/sched.c	2009-04-23 14:56:47.000000000 -0400
@@ -10235,3 +10235,58 @@ struct cgroup_subsys cpuacct_subsys = {
 	.subsys_id = cpuacct_subsys_id,
 };
 #endif	/* CONFIG_CGROUP_CPUACCT */
+
+static DEFINE_MUTEX(kernel_trace_mutex);
+static int kernel_trace_refcount;
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
+	mutex_lock(&kernel_trace_mutex);
+	if (--kernel_trace_refcount)
+		goto end;
+	read_lock(&tasklist_lock);
+	do_each_thread(p, t) {
+		clear_tsk_thread_flag(t, TIF_KERNEL_TRACE);
+	} while_each_thread(p, t);
+	read_unlock(&tasklist_lock);
+end:
+	mutex_unlock(&kernel_trace_mutex);
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
+	mutex_lock(&kernel_trace_mutex);
+	if (kernel_trace_refcount++)
+		goto end;
+	read_lock(&tasklist_lock);
+	do_each_thread(p, t) {
+		set_tsk_thread_flag(t, TIF_KERNEL_TRACE);
+	} while_each_thread(p, t);
+	read_unlock(&tasklist_lock);
+end:
+	mutex_unlock(&kernel_trace_mutex);
+}
+EXPORT_SYMBOL_GPL(set_kernel_trace_flag_all_tasks);

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
