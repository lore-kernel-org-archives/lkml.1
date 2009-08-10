Return-Path: <linux-kernel-owner+w=401wt.eu-S1753567AbZHJUzX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753567AbZHJUzX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 16:55:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753547AbZHJUzV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 16:55:21 -0400
Received: from mx2.redhat.com ([66.187.237.31]:60985 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753527AbZHJUzS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 16:55:18 -0400
Date: Mon, 10 Aug 2009 16:53:02 -0400
From: Jason Baron <jbaron@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: fweisbec@gmail.com, mingo@elte.hu, laijs@cn.fujitsu.com,
       rostedt@goodmis.org, peterz@infradead.org, mathieu.desnoyers@polymtl.ca,
       jiayingz@google.com, mbligh@google.com, lizf@cn.fujitsu.com
Message-Id: <b9d3c5f9d0ff2fb71993530873807443a0c7eb64.1249932670.git.jbaron@redhat.com>
In-Reply-To: <cover.1249932670.git.jbaron@redhat.com>
References: <cover.1249932670.git.jbaron@redhat.com>
Subject: [PATCH 10/12] add perf counter support
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make 'perf stat -e syscalls:sys_enter_blah' work with syscall style tracepoints.

Signed-off-by: Jason Baron <jbaron@redhat.com>

---
 include/linux/perf_counter.h  |    2 +
 include/linux/syscalls.h      |   52 +++++++++++++++++-
 include/trace/syscall.h       |    7 +++
 kernel/trace/trace_syscalls.c |  121 +++++++++++++++++++++++++++++++++++++++++
 4 files changed, 181 insertions(+), 1 deletions(-)

diff --git a/include/linux/perf_counter.h b/include/linux/perf_counter.h
index c484834..aaf0c74 100644
--- a/include/linux/perf_counter.h
+++ b/include/linux/perf_counter.h
@@ -734,6 +734,8 @@ extern int sysctl_perf_counter_mlock;
 extern int sysctl_perf_counter_sample_rate;
 
 extern void perf_counter_init(void);
+extern void perf_tpcounter_event(int event_id, u64 addr, u64 count,
+				 void *record, int entry_size);
 
 #ifndef perf_misc_flags
 #define perf_misc_flags(regs)	(user_mode(regs) ? PERF_EVENT_MISC_USER : \
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index ce4b01c..5541e75 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -98,6 +98,53 @@ struct perf_counter_attr;
 #define __SC_TEST5(t5, a5, ...)	__SC_TEST(t5); __SC_TEST4(__VA_ARGS__)
 #define __SC_TEST6(t6, a6, ...)	__SC_TEST(t6); __SC_TEST5(__VA_ARGS__)
 
+#ifdef CONFIG_EVENT_PROFILE
+#define TRACE_SYS_ENTER_PROFILE(sname)					       \
+static int prof_sysenter_enable_##sname(struct ftrace_event_call *event_call)  \
+{									       \
+	int ret = 0;							       \
+	if (!atomic_inc_return(&event_enter_##sname.profile_count))	       \
+		ret = reg_prof_syscall_enter("sys"#sname);		       \
+	return ret;							       \
+}									       \
+									       \
+static void prof_sysenter_disable_##sname(struct ftrace_event_call *event_call)\
+{									       \
+	if (atomic_add_negative(-1, &event_enter_##sname.profile_count))       \
+		unreg_prof_syscall_enter("sys"#sname);			       \
+}
+
+#define TRACE_SYS_EXIT_PROFILE(sname)					       \
+static int prof_sysexit_enable_##sname(struct ftrace_event_call *event_call)   \
+{									       \
+	int ret = 0;							       \
+	if (!atomic_inc_return(&event_exit_##sname.profile_count))	       \
+		ret = reg_prof_syscall_exit("sys"#sname);		       \
+	return ret;							       \
+}									       \
+									       \
+static void prof_sysexit_disable_##sname(struct ftrace_event_call *event_call) \
+{                                                                              \
+	if (atomic_add_negative(-1, &event_exit_##sname.profile_count))	       \
+		unreg_prof_syscall_exit("sys"#sname);			       \
+}
+
+#define TRACE_SYS_ENTER_PROFILE_INIT(sname)				       \
+	.profile_count = ATOMIC_INIT(-1),				       \
+	.profile_enable = prof_sysenter_enable_##sname,			       \
+	.profile_disable = prof_sysenter_disable_##sname,
+
+#define TRACE_SYS_EXIT_PROFILE_INIT(sname)				       \
+	.profile_count = ATOMIC_INIT(-1),				       \
+	.profile_enable = prof_sysexit_enable_##sname,			       \
+	.profile_disable = prof_sysexit_disable_##sname,
+#else
+#define TRACE_SYS_ENTER_PROFILE(sname)
+#define TRACE_SYS_ENTER_PROFILE_INIT(sname)
+#define TRACE_SYS_EXIT_PROFILE(sname)
+#define TRACE_SYS_EXIT_PROFILE_INIT(sname)
+#endif
+
 #ifdef CONFIG_FTRACE_SYSCALLS
 #define __SC_STR_ADECL1(t, a)		#a
 #define __SC_STR_ADECL2(t, a, ...)	#a, __SC_STR_ADECL1(__VA_ARGS__)
@@ -113,7 +160,6 @@ struct perf_counter_attr;
 #define __SC_STR_TDECL5(t, a, ...)	#t, __SC_STR_TDECL4(__VA_ARGS__)
 #define __SC_STR_TDECL6(t, a, ...)	#t, __SC_STR_TDECL5(__VA_ARGS__)
 
-
 #define SYSCALL_TRACE_ENTER_EVENT(sname)				\
 	static struct ftrace_event_call event_enter_##sname;		\
 	struct trace_event enter_syscall_print_##sname = {		\
@@ -134,6 +180,7 @@ struct perf_counter_attr;
 		init_preds(&event_enter_##sname);			\
 		return 0;						\
 	}								\
+	TRACE_SYS_ENTER_PROFILE(sname);					\
 	static struct ftrace_event_call __used				\
 	  __attribute__((__aligned__(4)))				\
 	  __attribute__((section("_ftrace_events")))			\
@@ -145,6 +192,7 @@ struct perf_counter_attr;
 		.regfunc		= reg_event_syscall_enter,	\
 		.unregfunc		= unreg_event_syscall_enter,	\
 		.data			= "sys"#sname,			\
+		TRACE_SYS_ENTER_PROFILE_INIT(sname)			\
 	}
 
 #define SYSCALL_TRACE_EXIT_EVENT(sname)					\
@@ -167,6 +215,7 @@ struct perf_counter_attr;
 		init_preds(&event_exit_##sname);			\
 		return 0;						\
 	}								\
+	TRACE_SYS_EXIT_PROFILE(sname);					\
 	static struct ftrace_event_call __used				\
 	  __attribute__((__aligned__(4)))				\
 	  __attribute__((section("_ftrace_events")))			\
@@ -178,6 +227,7 @@ struct perf_counter_attr;
 		.regfunc		= reg_event_syscall_exit,	\
 		.unregfunc		= unreg_event_syscall_exit,	\
 		.data			= "sys"#sname,			\
+		TRACE_SYS_EXIT_PROFILE_INIT(sname)			\
 	}
 
 #define SYSCALL_METADATA(sname, nb)				\
diff --git a/include/trace/syscall.h b/include/trace/syscall.h
index df62840..3ab6dd1 100644
--- a/include/trace/syscall.h
+++ b/include/trace/syscall.h
@@ -58,5 +58,12 @@ extern void unreg_event_syscall_exit(void *ptr);
 enum print_line_t print_syscall_enter(struct trace_iterator *iter, int flags);
 enum print_line_t print_syscall_exit(struct trace_iterator *iter, int flags);
 #endif
+#ifdef CONFIG_EVENT_PROFILE
+int reg_prof_syscall_enter(char *name);
+void unreg_prof_syscall_enter(char *name);
+int reg_prof_syscall_exit(char *name);
+void unreg_prof_syscall_exit(char *name);
+
+#endif
 
 #endif /* _TRACE_SYSCALL_H */
diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index e58a9c1..f4eaec3 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -1,6 +1,7 @@
 #include <trace/syscall.h>
 #include <linux/kernel.h>
 #include <linux/ftrace.h>
+#include <linux/perf_counter.h>
 #include <asm/syscall.h>
 
 #include "trace_output.h"
@@ -252,3 +253,123 @@ struct trace_event event_syscall_enter = {
 struct trace_event event_syscall_exit = {
 	.trace			= print_syscall_exit,
 };
+
+#ifdef CONFIG_EVENT_PROFILE
+static DECLARE_BITMAP(enabled_prof_enter_syscalls, FTRACE_SYSCALL_MAX);
+static DECLARE_BITMAP(enabled_prof_exit_syscalls, FTRACE_SYSCALL_MAX);
+static int sys_prof_refcount_enter;
+static int sys_prof_refcount_exit;
+
+static void prof_syscall_enter(struct pt_regs *regs, long id)
+{
+	struct syscall_metadata *sys_data;
+	int syscall_nr;
+
+	syscall_nr = syscall_get_nr(current, regs);
+	if (!test_bit(syscall_nr, enabled_prof_enter_syscalls))
+		return;
+
+	sys_data = syscall_nr_to_meta(syscall_nr);
+	if (!sys_data)
+		return;
+
+	perf_tpcounter_event(sys_data->enter_id, 0, 1, NULL, 0);
+}
+
+int reg_prof_syscall_enter(char *name)
+{
+	int ret = 0;
+	int num;
+
+	num = syscall_name_to_nr(name);
+	if (num < 0 || num >= FTRACE_SYSCALL_MAX)
+		return -ENOSYS;
+
+	mutex_lock(&syscall_trace_lock);
+	if (!sys_prof_refcount_enter)
+		ret = register_trace_syscall_enter(prof_syscall_enter);
+	if (ret) {
+		pr_info("event trace: Could not activate"
+				"syscall entry trace point");
+	} else {
+		set_bit(num, enabled_prof_enter_syscalls);
+		sys_prof_refcount_enter++;
+	}
+	mutex_unlock(&syscall_trace_lock);
+	return ret;
+}
+
+void unreg_prof_syscall_enter(char *name)
+{
+	int num;
+
+	num = syscall_name_to_nr(name);
+	if (num < 0 || num >= FTRACE_SYSCALL_MAX)
+		return;
+
+	mutex_lock(&syscall_trace_lock);
+	sys_prof_refcount_enter--;
+	clear_bit(num, enabled_prof_enter_syscalls);
+	if (!sys_prof_refcount_enter)
+		unregister_trace_syscall_enter(prof_syscall_enter);
+	mutex_unlock(&syscall_trace_lock);
+}
+
+static void prof_syscall_exit(struct pt_regs *regs, long ret)
+{
+	struct syscall_metadata *sys_data;
+	int syscall_nr;
+
+	syscall_nr = syscall_get_nr(current, regs);
+	if (!test_bit(syscall_nr, enabled_prof_exit_syscalls))
+		return;
+
+	sys_data = syscall_nr_to_meta(syscall_nr);
+	if (!sys_data)
+		return;
+
+	perf_tpcounter_event(sys_data->exit_id, 0, 1, NULL, 0);
+}
+
+int reg_prof_syscall_exit(char *name)
+{
+	int ret = 0;
+	int num;
+
+	num = syscall_name_to_nr(name);
+	if (num < 0 || num >= FTRACE_SYSCALL_MAX)
+		return -ENOSYS;
+
+	mutex_lock(&syscall_trace_lock);
+	if (!sys_prof_refcount_exit)
+		ret = register_trace_syscall_exit(prof_syscall_exit);
+	if (ret) {
+		pr_info("event trace: Could not activate"
+				"syscall entry trace point");
+	} else {
+		set_bit(num, enabled_prof_exit_syscalls);
+		sys_prof_refcount_exit++;
+	}
+	mutex_unlock(&syscall_trace_lock);
+	return ret;
+}
+
+void unreg_prof_syscall_exit(char *name)
+{
+	int num;
+
+	num = syscall_name_to_nr(name);
+	if (num < 0 || num >= FTRACE_SYSCALL_MAX)
+		return;
+
+	mutex_lock(&syscall_trace_lock);
+	sys_prof_refcount_exit--;
+	clear_bit(num, enabled_prof_exit_syscalls);
+	if (!sys_prof_refcount_exit)
+		unregister_trace_syscall_exit(prof_syscall_exit);
+	mutex_unlock(&syscall_trace_lock);
+}
+
+#endif
+
+
-- 
1.6.2.5

