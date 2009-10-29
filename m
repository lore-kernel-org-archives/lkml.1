Return-Path: <linux-kernel-owner+w=401wt.eu-S1756545AbZJ2G5T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756545AbZJ2G5T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 02:57:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756538AbZJ2G5T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 02:57:19 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:51137 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756472AbZJ2G5P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 02:57:15 -0400
Message-ID: <4AE93C93.9060607@cn.fujitsu.com>
Date: Thu, 29 Oct 2009 14:56:19 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <peterz@infradead.org>, Pavel Machek <pavel@ucw.cz>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Masami Hiramatsu <mhiramat@redhat.com>, Jason Baron <jbaron@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] perf events: Remove CONFIG_EVENT_PROFILE
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quote from Ingo:

| This reminds me - i think we should eliminate CONFIG_EVENT_PROFILE -
| it's an unnecessary Kconfig complication. If both PERF_EVENTS and
| EVENT_TRACING is enabled we should expose generic tracepoints.
|
| Nor is it limited to event 'profiling', so it has become a misnomer as
| well.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 include/linux/ftrace_event.h       |    2 +-
 include/linux/perf_event.h         |    2 +-
 include/linux/syscalls.h           |    4 ++--
 include/trace/ftrace.h             |   12 ++++++------
 include/trace/syscall.h            |    4 ++--
 init/Kconfig                       |   13 -------------
 kernel/perf_event.c                |    4 ++--
 kernel/trace/Makefile              |    4 +++-
 kernel/trace/trace_events_filter.c |    4 ++--
 kernel/trace/trace_kprobe.c        |   14 +++++++-------
 kernel/trace/trace_syscalls.c      |    4 ++--
 11 files changed, 28 insertions(+), 39 deletions(-)

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index f7b47c3..1935221 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -187,7 +187,7 @@ do {									\
 		__trace_printk(ip, fmt, ##args);			\
 } while (0)
 
-#ifdef CONFIG_EVENT_PROFILE
+#ifdef CONFIG_PERF_EVENTS
 struct perf_event;
 extern int ftrace_profile_enable(int event_id);
 extern void ftrace_profile_disable(int event_id);
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 45b56fa..b3e2f83 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -635,7 +635,7 @@ struct perf_event {
 	struct pid_namespace		*ns;
 	u64				id;
 
-#ifdef CONFIG_EVENT_PROFILE
+#ifdef CONFIG_EVENT_TRACING
 	struct event_filter		*filter;
 #endif
 
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index b50974a..8f00120 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -98,7 +98,7 @@ struct perf_event_attr;
 #define __SC_TEST5(t5, a5, ...)	__SC_TEST(t5); __SC_TEST4(__VA_ARGS__)
 #define __SC_TEST6(t6, a6, ...)	__SC_TEST(t6); __SC_TEST5(__VA_ARGS__)
 
-#ifdef CONFIG_EVENT_PROFILE
+#ifdef CONFIG_PERF_EVENTS
 #define TRACE_SYS_ENTER_PROFILE(sname)					       \
 static int prof_sysenter_enable_##sname(struct ftrace_event_call *unused)      \
 {									       \
@@ -135,7 +135,7 @@ static void prof_sysexit_disable_##sname(struct ftrace_event_call *unused)     \
 #define TRACE_SYS_ENTER_PROFILE_INIT(sname)
 #define TRACE_SYS_EXIT_PROFILE(sname)
 #define TRACE_SYS_EXIT_PROFILE_INIT(sname)
-#endif
+#endif /* CONFIG_PERF_EVENTS */
 
 #ifdef CONFIG_FTRACE_SYSCALLS
 #define __SC_STR_ADECL1(t, a)		#a
diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index a7f9460..d68fea9 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -378,7 +378,7 @@ static inline int ftrace_get_offsets_##call(				\
 
 #include TRACE_INCLUDE(TRACE_INCLUDE_FILE)
 
-#ifdef CONFIG_EVENT_PROFILE
+#ifdef CONFIG_PERF_EVENTS
 
 /*
  * Generate the functions needed for tracepoint perf_event support.
@@ -414,7 +414,7 @@ static void ftrace_profile_disable_##call(struct ftrace_event_call *unused)\
 
 #include TRACE_INCLUDE(TRACE_INCLUDE_FILE)
 
-#endif
+#endif /* CONFIG_PERF_EVENTS */
 
 /*
  * Stage 4 of the trace events.
@@ -519,7 +519,7 @@ static void ftrace_profile_disable_##call(struct ftrace_event_call *unused)\
 #undef TP_FMT
 #define TP_FMT(fmt, args...)	fmt "\n", ##args
 
-#ifdef CONFIG_EVENT_PROFILE
+#ifdef CONFIG_PERF_EVENTS
 
 #define _TRACE_PROFILE_INIT(call)					\
 	.profile_count = ATOMIC_INIT(-1),				\
@@ -528,7 +528,7 @@ static void ftrace_profile_disable_##call(struct ftrace_event_call *unused)\
 
 #else
 #define _TRACE_PROFILE_INIT(call)
-#endif
+#endif /* CONFIG_PERF_EVENTS */
 
 #undef __entry
 #define __entry entry
@@ -699,7 +699,7 @@ __attribute__((section("_ftrace_events"))) event_##call = {		\
  * }
  */
 
-#ifdef CONFIG_EVENT_PROFILE
+#ifdef CONFIG_PERF_EVENTS
 
 #undef __perf_addr
 #define __perf_addr(a) __addr = (a)
@@ -767,7 +767,7 @@ end:									\
 }
 
 #include TRACE_INCLUDE(TRACE_INCLUDE_FILE)
-#endif /* CONFIG_EVENT_PROFILE */
+#endif /* CONFIG_PERF_EVENTS */
 
 #undef _TRACE_PROFILE_INIT
 
diff --git a/include/trace/syscall.h b/include/trace/syscall.h
index 51ee17d..2159dc2 100644
--- a/include/trace/syscall.h
+++ b/include/trace/syscall.h
@@ -55,12 +55,12 @@ ftrace_format_syscall(struct ftrace_event_call *call, struct trace_seq *s);
 enum print_line_t print_syscall_enter(struct trace_iterator *iter, int flags);
 enum print_line_t print_syscall_exit(struct trace_iterator *iter, int flags);
 #endif
-#ifdef CONFIG_EVENT_PROFILE
+
+#ifdef CONFIG_PERF_EVENTS
 int reg_prof_syscall_enter(char *name);
 void unreg_prof_syscall_enter(char *name);
 int reg_prof_syscall_exit(char *name);
 void unreg_prof_syscall_exit(char *name);
-
 #endif
 
 #endif /* _TRACE_SYSCALL_H */
diff --git a/init/Kconfig b/init/Kconfig
index d367bf6..5d278dc 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -965,19 +965,6 @@ config PERF_EVENTS
 
 	  Say Y if unsure.
 
-config EVENT_PROFILE
-	bool "Tracepoint profiling sources"
-	depends on PERF_EVENTS && EVENT_TRACING
-	default y
-	help
-	 Allow the use of tracepoints as software performance events.
-
-	 When this is enabled, you can create perf events based on
-	 tracepoints using PERF_TYPE_TRACEPOINT and the tracepoint ID
-	 found in debugfs://tracing/events/*/*/id. (The -e/--events
-	 option to the perf tool can parse and interpret symbolic
-	 tracepoints, in the subsystem:tracepoint_name format.)
-
 config PERF_COUNTERS
 	bool "Kernel performance counters (old config option)"
 	depends on HAVE_PERF_EVENTS
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index a69d4ed..6ddc6bd 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -4124,7 +4124,7 @@ static const struct pmu perf_ops_task_clock = {
 	.read		= task_clock_perf_event_read,
 };
 
-#ifdef CONFIG_EVENT_PROFILE
+#ifdef CONFIG_EVENT_TRACING
 
 void perf_tp_event(int event_id, u64 addr, u64 count, void *record,
 			  int entry_size)
@@ -4228,7 +4228,7 @@ static void perf_event_free_filter(struct perf_event *event)
 {
 }
 
-#endif /* CONFIG_EVENT_PROFILE */
+#endif /* CONFIG_EVENT_TRACING */
 
 atomic_t perf_swevent_enabled[PERF_COUNT_SW_MAX];
 
diff --git a/kernel/trace/Makefile b/kernel/trace/Makefile
index 6127e3e..b2758a2 100644
--- a/kernel/trace/Makefile
+++ b/kernel/trace/Makefile
@@ -51,7 +51,9 @@ endif
 obj-$(CONFIG_EVENT_TRACING) += trace_events.o
 obj-$(CONFIG_EVENT_TRACING) += trace_export.o
 obj-$(CONFIG_FTRACE_SYSCALLS) += trace_syscalls.o
-obj-$(CONFIG_EVENT_PROFILE) += trace_event_profile.o
+ifeq ($(CONFIG_PERF_EVENTS),y)
+obj-$(CONFIG_EVENT_TRACING) += trace_event_profile.o
+endif
 obj-$(CONFIG_EVENT_TRACING) += trace_events_filter.o
 obj-$(CONFIG_KPROBE_TRACER) += trace_kprobe.o
 obj-$(CONFIG_EVENT_TRACING) += power-traces.o
diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index 21d3475..87822c4 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -1360,7 +1360,7 @@ out_unlock:
 	return err;
 }
 
-#ifdef CONFIG_EVENT_PROFILE
+#ifdef CONFIG_PERF_EVENTS
 
 void ftrace_profile_free_filter(struct perf_event *event)
 {
@@ -1428,5 +1428,5 @@ out_unlock:
 	return err;
 }
 
-#endif /* CONFIG_EVENT_PROFILE */
+#endif /* CONFIG_PERF_EVENTS */
 
diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index b8ef707..28580f9 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -1199,7 +1199,7 @@ static int kretprobe_event_show_format(struct ftrace_event_call *call,
 					 ", REC->" FIELD_STRING_RETIP);
 }
 
-#ifdef CONFIG_EVENT_PROFILE
+#ifdef CONFIG_PERF_EVENTS
 
 /* Kprobe profile handler */
 static __kprobes int kprobe_profile_func(struct kprobe *kp,
@@ -1333,7 +1333,7 @@ static void probe_profile_disable(struct ftrace_event_call *call)
 			disable_kprobe(&tp->rp.kp);
 	}
 }
-#endif	/* CONFIG_EVENT_PROFILE */
+#endif	/* CONFIG_PERF_EVENTS */
 
 
 static __kprobes
@@ -1343,10 +1343,10 @@ int kprobe_dispatcher(struct kprobe *kp, struct pt_regs *regs)
 
 	if (tp->flags & TP_FLAG_TRACE)
 		kprobe_trace_func(kp, regs);
-#ifdef CONFIG_EVENT_PROFILE
+#ifdef CONFIG_PERF_EVENTS
 	if (tp->flags & TP_FLAG_PROFILE)
 		kprobe_profile_func(kp, regs);
-#endif	/* CONFIG_EVENT_PROFILE */
+#endif
 	return 0;	/* We don't tweek kernel, so just return 0 */
 }
 
@@ -1357,10 +1357,10 @@ int kretprobe_dispatcher(struct kretprobe_instance *ri, struct pt_regs *regs)
 
 	if (tp->flags & TP_FLAG_TRACE)
 		kretprobe_trace_func(ri, regs);
-#ifdef CONFIG_EVENT_PROFILE
+#ifdef CONFIG_PERF_EVENTS
 	if (tp->flags & TP_FLAG_PROFILE)
 		kretprobe_profile_func(ri, regs);
-#endif	/* CONFIG_EVENT_PROFILE */
+#endif
 	return 0;	/* We don't tweek kernel, so just return 0 */
 }
 
@@ -1389,7 +1389,7 @@ static int register_probe_event(struct trace_probe *tp)
 	call->regfunc = probe_event_enable;
 	call->unregfunc = probe_event_disable;
 
-#ifdef CONFIG_EVENT_PROFILE
+#ifdef CONFIG_PERF_EVENTS
 	atomic_set(&call->profile_count, -1);
 	call->profile_enable = probe_profile_enable;
 	call->profile_disable = probe_profile_disable;
diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index 58b8e53..3e8facd 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -467,7 +467,7 @@ int __init init_ftrace_syscalls(void)
 }
 core_initcall(init_ftrace_syscalls);
 
-#ifdef CONFIG_EVENT_PROFILE
+#ifdef CONFIG_PERF_EVENTS
 
 static DECLARE_BITMAP(enabled_prof_enter_syscalls, NR_syscalls);
 static DECLARE_BITMAP(enabled_prof_exit_syscalls, NR_syscalls);
@@ -669,6 +669,6 @@ void unreg_prof_syscall_exit(char *name)
 	mutex_unlock(&syscall_trace_lock);
 }
 
-#endif
+#endif /* CONFIG_PERF_EVENTS */
 
 
-- 
1.6.3

