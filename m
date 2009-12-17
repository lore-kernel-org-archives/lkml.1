Return-Path: <linux-kernel-owner+w=401wt.eu-S1765028AbZLQRXK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765028AbZLQRXK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 12:23:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764977AbZLQRXG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 12:23:06 -0500
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:43714 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759486AbZLQRXA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 12:23:00 -0500
Date: Thu, 17 Dec 2009 22:52:53 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "mingo@elte.hu" <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Subject: [Patch 1/1] Introduce register_user_hbp_by_pid() and
	unregister_user_hbp_by_pid()
Message-ID: <20091217172253.GC5457@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
References: <20091217172010.GB5457@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091217172010.GB5457@in.ibm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide an interface to (un)register user-space breakpoints using a
process' pid.

Signed-off-by: K.Prasad <prasad@linux.vnet.ibm.com>
---
 include/linux/hw_breakpoint.h |    8 +++
 kernel/hw_breakpoint.c        |   92 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 100 insertions(+)

Index: linux-2.6-tip.reg_by_pid/include/linux/hw_breakpoint.h
===================================================================
--- linux-2.6-tip.reg_by_pid.orig/include/linux/hw_breakpoint.h
+++ linux-2.6-tip.reg_by_pid/include/linux/hw_breakpoint.h
@@ -54,6 +54,10 @@ register_user_hw_breakpoint(struct perf_
 			    perf_overflow_handler_t triggered,
 			    struct task_struct *tsk);
 
+extern int register_user_hbp_by_pid(struct perf_event_attr *attr,
+			 perf_overflow_handler_t triggered,
+			 pid_t pid);
+extern void unregister_user_hbp_by_pid(pid_t pid);
 /* FIXME: only change from the attr, and don't unregister */
 extern int
 modify_user_hw_breakpoint(struct perf_event *bp, struct perf_event_attr *attr);
@@ -91,6 +95,10 @@ static inline struct perf_event *
 register_user_hw_breakpoint(struct perf_event_attr *attr,
 			    perf_overflow_handler_t triggered,
 			    struct task_struct *tsk)	{ return NULL; }
+int register_user_hbp_by_pid(struct perf_event_attr *attr,
+			 perf_overflow_handler_t triggered,
+			 pid_t pid)	{ return 0; }
+void unregister_user_hbp_by_pid(pid_t pid) {}
 static inline int
 modify_user_hw_breakpoint(struct perf_event *bp,
 			  struct perf_event_attr *attr)	{ return -ENOSYS; }
Index: linux-2.6-tip.reg_by_pid/kernel/hw_breakpoint.c
===================================================================
--- linux-2.6-tip.reg_by_pid.orig/kernel/hw_breakpoint.c
+++ linux-2.6-tip.reg_by_pid/kernel/hw_breakpoint.c
@@ -298,6 +298,98 @@ int register_perf_hw_breakpoint(struct p
 	return ret;
 }
 
+/*
+ * Unregister breakpoints thread-by-thread, for all threads ranging from
+ * @start to @end.
+ */
+static inline void __unregister_user_hbp_for_threads(struct task_struct *start,
+						struct task_struct *end)
+{
+	struct perf_event *bp, *temp_bp;
+
+	do {
+		mutex_lock(&start->perf_event_mutex);
+		list_for_each_entry_safe(bp, temp_bp, &start->perf_event_list,
+					 owner_entry) {
+			if (bp->attr.type != PERF_TYPE_BREAKPOINT)
+				continue;
+			unregister_hw_breakpoint(bp);
+			break;
+		}
+		mutex_unlock(&start->perf_event_mutex);
+	} while_each_thread(start, end);
+}
+
+/**
+ * register_user_hbp_by_pid - register a hardware breakpoint for user space using pid
+ * @attr: breakpoint attributes
+ * @triggered: callback to trigger when we hit the breakpoint
+ * @pid: pid of the thread group for which breakpoints must be registered
+ */
+int register_user_hbp_by_pid(struct perf_event_attr *attr,
+			 perf_overflow_handler_t triggered,
+			 pid_t pid)
+{
+	int ret;
+	struct task_struct *t1, *t2;
+
+	t1 = t2 = find_task_by_vpid(pid);
+	if (t1 == NULL)
+		return -ESRCH;
+
+	/*
+	 * Ensure that the breakpoint propogates to every new thread created in
+	 * this thread_group.
+	 */
+	attr->inherit = 1;
+	/*
+	 * Register a breakpoint individually for every thread of the
+	 * thread_group using register_user_hw_breakpoint() interface.
+	 * Warning: Involves redundant validation checks using
+	 * arch_validate_hwbkpt_settings().
+	 */
+	do {
+		ret = IS_ERR(register_user_hw_breakpoint(attr, triggered, t1));
+		if (ret)
+			goto fail;
+		t1 = next_thread(t1);
+	} while (t1 != t2);
+
+	return 0;
+fail:
+	/*
+	 * Check if the very first register_user_hw_breakpoint() request
+	 * failed. If then, do nothing but return the error value.
+	 */
+	if (t1 == t2)
+		return ret;
+	/*
+	 * Since there exists a thread where the breakpoint request was not
+	 * successful, we are unable to provide a process-wide breakpoint. Hence
+	 * cleanup the breakpoints from the previously registered threads.
+	 */
+	__unregister_user_hbp_for_threads(t2, t1);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(register_user_hbp_by_pid);
+
+/**
+ * unregister_hbp_by_pid - unregister a user-space hardware breakpoint previously registered using a pid
+ * @pid: pid of the process for which breakpoint must be unregistered
+ */
+void unregister_user_hbp_by_pid(pid_t pid)
+{
+	struct task_struct *t1, *t2;
+
+	t1 = t2 = find_task_by_vpid(pid);
+	if (t1 == NULL)
+		return;
+
+	__unregister_user_hbp_for_threads(t1, t2);
+}
+EXPORT_SYMBOL_GPL(unregister_user_hbp_by_pid);
+
 /**
  * register_user_hw_breakpoint - register a hardware breakpoint for user space
  * @attr: breakpoint attributes
