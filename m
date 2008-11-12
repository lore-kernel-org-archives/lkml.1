Return-Path: <linux-kernel-owner+w=401wt.eu-S1755152AbYKLVWw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755152AbYKLVWw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 16:22:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752565AbYKLVVy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 16:21:54 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:63277 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752226AbYKLVVv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 16:21:51 -0500
Message-Id: <20081112212150.295299148@goodmis.org>
References: <20081112212127.455979814@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 12 Nov 2008 16:21:29 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 2/4] ftrace: rename unlikely iter_ctrl to branch
Content-Disposition: inline; filename=0002-ftrace-rename-unlikely-iter_ctrl-to-branch.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: rename of iter_ctrl unlikely to branch

The unlikely name is ugly. This patch converts the iter_ctrl command
"unlikely" and "nounlikely" to "branch" and "nobranch" respectively.

It also renames a lot of internal functions to use "branch" instead
of "unlikely".

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/trace.c          |   14 +++++-----
 kernel/trace/trace.h          |   26 ++++++++++----------
 kernel/trace/trace_unlikely.c |   50 ++++++++++++++++++++--------------------
 3 files changed, 45 insertions(+), 45 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index bad59d3..4bf070b 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -259,7 +259,7 @@ static const char *trace_options[] = {
 	"ftrace_printk",
 	"ftrace_preempt",
 #ifdef CONFIG_BRANCH_TRACER
-	"unlikely",
+	"branch",
 #endif
 	NULL
 };
@@ -1651,8 +1651,8 @@ print_lat_fmt(struct trace_iterator *iter, unsigned int trace_idx, int cpu)
 			trace_seq_print_cont(s, iter);
 		break;
 	}
-	case TRACE_UNLIKELY: {
-		struct trace_unlikely *field;
+	case TRACE_BRANCH: {
+		struct trace_branch *field;
 
 		trace_assign_type(field, entry);
 
@@ -1802,8 +1802,8 @@ static enum print_line_t print_trace_fmt(struct trace_iterator *iter)
 		return print_return_function(iter);
 		break;
 	}
-	case TRACE_UNLIKELY: {
-		struct trace_unlikely *field;
+	case TRACE_BRANCH: {
+		struct trace_branch *field;
 
 		trace_assign_type(field, entry);
 
@@ -2619,7 +2619,7 @@ static int tracing_set_tracer(char *buf)
 	if (t == current_trace)
 		goto out;
 
-	trace_unlikely_disable();
+	trace_branch_disable();
 	if (current_trace && current_trace->reset)
 		current_trace->reset(tr);
 
@@ -2627,7 +2627,7 @@ static int tracing_set_tracer(char *buf)
 	if (t->init)
 		t->init(tr);
 
-	trace_unlikely_enable(tr);
+	trace_branch_enable(tr);
  out:
 	mutex_unlock(&trace_types_lock);
 
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index dccae63..7fbf37b 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -22,7 +22,7 @@ enum trace_type {
 	TRACE_SPECIAL,
 	TRACE_MMIO_RW,
 	TRACE_MMIO_MAP,
-	TRACE_UNLIKELY,
+	TRACE_BRANCH,
 	TRACE_BOOT_CALL,
 	TRACE_BOOT_RET,
 	TRACE_FN_RET,
@@ -137,7 +137,7 @@ struct trace_boot_ret {
 
 #define TRACE_FUNC_SIZE 30
 #define TRACE_FILE_SIZE 20
-struct trace_unlikely {
+struct trace_branch {
 	struct trace_entry	ent;
 	unsigned	        line;
 	char			func[TRACE_FUNC_SIZE+1];
@@ -247,7 +247,7 @@ extern void __ftrace_bad_type(void);
 			  TRACE_MMIO_MAP);				\
 		IF_ASSIGN(var, ent, struct trace_boot_call, TRACE_BOOT_CALL);\
 		IF_ASSIGN(var, ent, struct trace_boot_ret, TRACE_BOOT_RET);\
-		IF_ASSIGN(var, ent, struct trace_unlikely, TRACE_UNLIKELY); \
+		IF_ASSIGN(var, ent, struct trace_branch, TRACE_BRANCH); \
 		IF_ASSIGN(var, ent, struct ftrace_ret_entry, TRACE_FN_RET);\
 		__ftrace_bad_type();					\
 	} while (0)
@@ -469,7 +469,7 @@ enum trace_iterator_flags {
 	TRACE_ITER_PRINTK		= 0x400,
 	TRACE_ITER_PREEMPTONLY		= 0x800,
 #ifdef CONFIG_BRANCH_TRACER
-	TRACE_ITER_UNLIKELY		= 0x1000,
+	TRACE_ITER_BRANCH		= 0x1000,
 #endif
 };
 
@@ -531,25 +531,25 @@ static inline void ftrace_preempt_enable(int resched)
 }
 
 #ifdef CONFIG_BRANCH_TRACER
-extern int enable_unlikely_tracing(struct trace_array *tr);
-extern void disable_unlikely_tracing(void);
-static inline int trace_unlikely_enable(struct trace_array *tr)
+extern int enable_branch_tracing(struct trace_array *tr);
+extern void disable_branch_tracing(void);
+static inline int trace_branch_enable(struct trace_array *tr)
 {
-	if (trace_flags & TRACE_ITER_UNLIKELY)
-		return enable_unlikely_tracing(tr);
+	if (trace_flags & TRACE_ITER_BRANCH)
+		return enable_branch_tracing(tr);
 	return 0;
 }
-static inline void trace_unlikely_disable(void)
+static inline void trace_branch_disable(void)
 {
 	/* due to races, always disable */
-	disable_unlikely_tracing();
+	disable_branch_tracing();
 }
 #else
-static inline int trace_unlikely_enable(struct trace_array *tr)
+static inline int trace_branch_enable(struct trace_array *tr)
 {
 	return 0;
 }
-static inline void trace_unlikely_disable(void)
+static inline void trace_branch_disable(void)
 {
 }
 #endif /* CONFIG_BRANCH_TRACER */
diff --git a/kernel/trace/trace_unlikely.c b/kernel/trace/trace_unlikely.c
index 856eb3b..e5d5969 100644
--- a/kernel/trace/trace_unlikely.c
+++ b/kernel/trace/trace_unlikely.c
@@ -17,16 +17,16 @@
 
 #ifdef CONFIG_BRANCH_TRACER
 
-static int unlikely_tracing_enabled __read_mostly;
-static DEFINE_MUTEX(unlikely_tracing_mutex);
-static struct trace_array *unlikely_tracer;
+static int branch_tracing_enabled __read_mostly;
+static DEFINE_MUTEX(branch_tracing_mutex);
+static struct trace_array *branch_tracer;
 
 static void
-probe_likely_condition(struct ftrace_likely_data *f, int val, int expect)
+probe_likely_condition(struct ftrace_branch_data *f, int val, int expect)
 {
-	struct trace_array *tr = unlikely_tracer;
+	struct trace_array *tr = branch_tracer;
 	struct ring_buffer_event *event;
-	struct trace_unlikely *entry;
+	struct trace_branch *entry;
 	unsigned long flags, irq_flags;
 	int cpu, pc;
 	const char *p;
@@ -54,7 +54,7 @@ probe_likely_condition(struct ftrace_likely_data *f, int val, int expect)
 	pc = preempt_count();
 	entry	= ring_buffer_event_data(event);
 	tracing_generic_entry_update(&entry->ent, flags, pc);
-	entry->ent.type		= TRACE_UNLIKELY;
+	entry->ent.type		= TRACE_BRANCH;
 
 	/* Strip off the path, only save the file */
 	p = f->file + strlen(f->file);
@@ -77,51 +77,51 @@ probe_likely_condition(struct ftrace_likely_data *f, int val, int expect)
 }
 
 static inline
-void trace_likely_condition(struct ftrace_likely_data *f, int val, int expect)
+void trace_likely_condition(struct ftrace_branch_data *f, int val, int expect)
 {
-	if (!unlikely_tracing_enabled)
+	if (!branch_tracing_enabled)
 		return;
 
 	probe_likely_condition(f, val, expect);
 }
 
-int enable_unlikely_tracing(struct trace_array *tr)
+int enable_branch_tracing(struct trace_array *tr)
 {
 	int ret = 0;
 
-	mutex_lock(&unlikely_tracing_mutex);
-	unlikely_tracer = tr;
+	mutex_lock(&branch_tracing_mutex);
+	branch_tracer = tr;
 	/*
 	 * Must be seen before enabling. The reader is a condition
 	 * where we do not need a matching rmb()
 	 */
 	smp_wmb();
-	unlikely_tracing_enabled++;
-	mutex_unlock(&unlikely_tracing_mutex);
+	branch_tracing_enabled++;
+	mutex_unlock(&branch_tracing_mutex);
 
 	return ret;
 }
 
-void disable_unlikely_tracing(void)
+void disable_branch_tracing(void)
 {
-	mutex_lock(&unlikely_tracing_mutex);
+	mutex_lock(&branch_tracing_mutex);
 
-	if (!unlikely_tracing_enabled)
+	if (!branch_tracing_enabled)
 		goto out_unlock;
 
-	unlikely_tracing_enabled--;
+	branch_tracing_enabled--;
 
  out_unlock:
-	mutex_unlock(&unlikely_tracing_mutex);
+	mutex_unlock(&branch_tracing_mutex);
 }
 #else
 static inline
-void trace_likely_condition(struct ftrace_likely_data *f, int val, int expect)
+void trace_likely_condition(struct ftrace_branch_data *f, int val, int expect)
 {
 }
 #endif /* CONFIG_BRANCH_TRACER */
 
-void ftrace_likely_update(struct ftrace_likely_data *f, int val, int expect)
+void ftrace_likely_update(struct ftrace_branch_data *f, int val, int expect)
 {
 	/*
 	 * I would love to have a trace point here instead, but the
@@ -148,7 +148,7 @@ static void *
 t_next(struct seq_file *m, void *v, loff_t *pos)
 {
 	struct ftrace_pointer *f = m->private;
-	struct ftrace_likely_data *p = v;
+	struct ftrace_branch_data *p = v;
 
 	(*pos)++;
 
@@ -180,7 +180,7 @@ static void t_stop(struct seq_file *m, void *p)
 
 static int t_show(struct seq_file *m, void *v)
 {
-	struct ftrace_likely_data *p = v;
+	struct ftrace_branch_data *p = v;
 	const char *f;
 	unsigned long percent;
 
@@ -252,7 +252,7 @@ static struct ftrace_pointer ftrace_unlikely_pos = {
 	.stop			= __stop_unlikely_profile,
 };
 
-static __init int ftrace_unlikely_init(void)
+static __init int ftrace_branch_init(void)
 {
 	struct dentry *d_tracer;
 	struct dentry *entry;
@@ -275,4 +275,4 @@ static __init int ftrace_unlikely_init(void)
 	return 0;
 }
 
-device_initcall(ftrace_unlikely_init);
+device_initcall(ftrace_branch_init);
-- 
1.5.6.5

-- 
