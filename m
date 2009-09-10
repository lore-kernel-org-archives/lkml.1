Return-Path: <linux-kernel-owner+w=401wt.eu-S1754837AbZIJBff@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754837AbZIJBff (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 21:35:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753826AbZIJBfe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 21:35:34 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:56004 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752472AbZIJBfe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 21:35:34 -0400
Message-ID: <4AA8579B.4020706@cn.fujitsu.com>
Date: Thu, 10 Sep 2009 09:34:19 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Frederic Weisbecker <fweisbec@gmail.com>, Tom Zanussi <tzanussi@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH v2] tracing: Clean up trace.h
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

I've split hw_breakpoint code out.

---
 kernel/trace/trace.h               |   86 +++++-------------------------------
 kernel/trace/trace_events_filter.c |   41 +++++++++++++++++
 2 files changed, 52 insertions(+), 75 deletions(-)

diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index ea7e0bc..76ed0db 100644
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
@@ -226,7 +218,7 @@ struct ksym_trace_entry {
  * states when a trace occurs. These are:
  *  IRQS_OFF		- interrupts were disabled
  *  IRQS_NOSUPPORT	- arch does not support irqs_disabled_flags
- *  NEED_RESCED		- reschedule is requested
+ *  NEED_RESCHED	- reschedule is requested
  *  HARDIRQ		- inside an interrupt handler
  *  SOFTIRQ		- inside a softirq handler
  */
@@ -406,7 +398,6 @@ struct tracer {
 	struct tracer		*next;
 	int			print_max;
 	struct tracer_flags	*flags;
-	struct tracer_stat	*stats;
 };
 
 
@@ -525,20 +516,6 @@ static inline void __trace_stack(struct trace_array *tr, unsigned long flags,
 
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
@@ -841,47 +818,6 @@ filter_check_discard(struct ftrace_event_call *call, void *rec,
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
-- 
1.6.3

