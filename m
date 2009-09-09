Return-Path: <linux-kernel-owner+w=401wt.eu-S1751862AbZIIG5P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751862AbZIIG5P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 02:57:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751528AbZIIG5O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 02:57:14 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:61649 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751514AbZIIG5N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 02:57:13 -0400
Message-ID: <4AA7517C.2070009@cn.fujitsu.com>
Date: Wed, 09 Sep 2009 14:55:56 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH] tracing: Clean up trace.h
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- remove some dead code
- remove @stats from struct tracer
- move DEFINE_COMPARISON_PRED() and DEFINE_EQUALITY_PRED()
  to kernel/trace/trace_events_filter.c

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/trace/trace.h               |   87 +++++-------------------------------
 kernel/trace/trace_events_filter.c |   41 +++++++++++++++++
 kernel/trace/trace_selftest.c      |    2 +-
 3 files changed, 53 insertions(+), 77 deletions(-)

diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index ea7e0bc..e6b1c73 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -125,14 +125,6 @@ struct print_entry {
 	char			buf[];
 };
 
-#define TRACE_OLD_SIZE		88
-
-struct trace_field_cont {
-	unsigned char		type;
-	/* Temporary till we get rid of this completely */
-	char			buf[TRACE_OLD_SIZE - 1];
-};
-
 struct trace_mmiotrace_rw {
 	struct trace_entry	ent;
 	struct mmiotrace_rw	rw;
@@ -182,20 +174,20 @@ enum kmemtrace_type_id {
 
 struct kmemtrace_alloc_entry {
 	struct trace_entry	ent;
-	enum kmemtrace_type_id type_id;
-	unsigned long call_site;
-	const void *ptr;
-	size_t bytes_req;
-	size_t bytes_alloc;
-	gfp_t gfp_flags;
-	int node;
+	enum kmemtrace_type_id	type_id;
+	unsigned long		call_site;
+	const void		*ptr;
+	size_t			bytes_req;
+	size_t			bytes_alloc;
+	gfp_t			gfp_flags;
+	int			node;
 };
 
 struct kmemtrace_free_entry {
 	struct trace_entry	ent;
-	enum kmemtrace_type_id type_id;
-	unsigned long call_site;
-	const void *ptr;
+	enum kmemtrace_type_id	type_id;
+	unsigned long		call_site;
+	const void		*ptr;
 };
 
 struct syscall_trace_enter {
@@ -210,7 +202,6 @@ struct syscall_trace_exit {
 	unsigned long		ret;
 };
 
-#define KSYM_SELFTEST_ENTRY "ksym_selftest_dummy"
 extern int process_new_ksym_entry(char *ksymname, int op, unsigned long addr);
 
 struct ksym_trace_entry {
@@ -226,7 +217,7 @@ struct ksym_trace_entry {
  * states when a trace occurs. These are:
  *  IRQS_OFF		- interrupts were disabled
  *  IRQS_NOSUPPORT	- arch does not support irqs_disabled_flags
- *  NEED_RESCED		- reschedule is requested
+ *  NEED_RESCHED	- reschedule is requested
  *  HARDIRQ		- inside an interrupt handler
  *  SOFTIRQ		- inside a softirq handler
  */
@@ -406,7 +397,6 @@ struct tracer {
 	struct tracer		*next;
 	int			print_max;
 	struct tracer_flags	*flags;
-	struct tracer_stat	*stats;
 };
 
 
@@ -525,20 +515,6 @@ static inline void __trace_stack(struct trace_array *tr, unsigned long flags,
 
 extern cycle_t ftrace_now(int cpu);
 
-#ifdef CONFIG_CONTEXT_SWITCH_TRACER
-typedef void
-(*tracer_switch_func_t)(void *private,
-			void *__rq,
-			struct task_struct *prev,
-			struct task_struct *next);
-
-struct tracer_switch_ops {
-	tracer_switch_func_t		func;
-	void				*private;
-	struct tracer_switch_ops	*next;
-};
-#endif /* CONFIG_CONTEXT_SWITCH_TRACER */
-
 extern void trace_find_cmdline(int pid, char comm[]);
 
 #ifdef CONFIG_DYNAMIC_FTRACE
@@ -841,47 +817,6 @@ filter_check_discard(struct ftrace_event_call *call, void *rec,
 	return 0;
 }
 
-#define DEFINE_COMPARISON_PRED(type)					\
-static int filter_pred_##type(struct filter_pred *pred, void *event,	\
-			      int val1, int val2)			\
-{									\
-	type *addr = (type *)(event + pred->offset);			\
-	type val = (type)pred->val;					\
-	int match = 0;							\
-									\
-	switch (pred->op) {						\
-	case OP_LT:							\
-		match = (*addr < val);					\
-		break;							\
-	case OP_LE:							\
-		match = (*addr <= val);					\
-		break;							\
-	case OP_GT:							\
-		match = (*addr > val);					\
-		break;							\
-	case OP_GE:							\
-		match = (*addr >= val);					\
-		break;							\
-	default:							\
-		break;							\
-	}								\
-									\
-	return match;							\
-}
-
-#define DEFINE_EQUALITY_PRED(size)					\
-static int filter_pred_##size(struct filter_pred *pred, void *event,	\
-			      int val1, int val2)			\
-{									\
-	u##size *addr = (u##size *)(event + pred->offset);		\
-	u##size val = (u##size)pred->val;				\
-	int match;							\
-									\
-	match = (val == *addr) ^ pred->not;				\
-									\
-	return match;							\
-}
-
 extern struct mutex event_mutex;
 extern struct list_head ftrace_events;
 
diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index 93660fb..2324578 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -121,6 +121,47 @@ struct filter_parse_state {
 	} operand;
 };
 
+#define DEFINE_COMPARISON_PRED(type)					\
+static int filter_pred_##type(struct filter_pred *pred, void *event,	\
+			      int val1, int val2)			\
+{									\
+	type *addr = (type *)(event + pred->offset);			\
+	type val = (type)pred->val;					\
+	int match = 0;							\
+									\
+	switch (pred->op) {						\
+	case OP_LT:							\
+		match = (*addr < val);					\
+		break;							\
+	case OP_LE:							\
+		match = (*addr <= val);					\
+		break;							\
+	case OP_GT:							\
+		match = (*addr > val);					\
+		break;							\
+	case OP_GE:							\
+		match = (*addr >= val);					\
+		break;							\
+	default:							\
+		break;							\
+	}								\
+									\
+	return match;							\
+}
+
+#define DEFINE_EQUALITY_PRED(size)					\
+static int filter_pred_##size(struct filter_pred *pred, void *event,	\
+			      int val1, int val2)			\
+{									\
+	u##size *addr = (u##size *)(event + pred->offset);		\
+	u##size val = (u##size)pred->val;				\
+	int match;							\
+									\
+	match = (val == *addr) ^ pred->not;				\
+									\
+	return match;							\
+}
+
 DEFINE_COMPARISON_PRED(s64);
 DEFINE_COMPARISON_PRED(u64);
 DEFINE_COMPARISON_PRED(s32);
diff --git a/kernel/trace/trace_selftest.c b/kernel/trace/trace_selftest.c
index 7179c12..a006f00 100644
--- a/kernel/trace/trace_selftest.c
+++ b/kernel/trace/trace_selftest.c
@@ -828,7 +828,7 @@ trace_selftest_startup_ksym(struct tracer *trace, struct trace_array *tr)
 
 	ksym_selftest_dummy = 0;
 	/* Register the read-write tracing request */
-	ret = process_new_ksym_entry(KSYM_SELFTEST_ENTRY, HW_BREAKPOINT_RW,
+	ret = process_new_ksym_entry("ksym_selftest_dummy", HW_BREAKPOINT_RW,
 					(unsigned long)(&ksym_selftest_dummy));
 
 	if (ret < 0) {
-- 
1.6.3

