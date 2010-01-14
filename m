Return-Path: <linux-kernel-owner+w=401wt.eu-S1756894Ab0ANPCV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756894Ab0ANPCV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 10:02:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756871Ab0ANPCN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 10:02:13 -0500
Received: from mail.windriver.com ([147.11.1.11]:47979 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756841Ab0ANPCG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 10:02:06 -0500
From: Jason Wessel <jason.wessel@windriver.com>
To: linux-kernel@vger.kernel.org
Cc: kgdb-bugreport@lists.sourceforge.net, mingo@elte.hu,
       Jason Wessel <jason.wessel@windriver.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 40/40] ftrace,kdb: Extend kdb to be able to dump the ftrace buffer
Date: Thu, 14 Jan 2010 08:59:36 -0600
Message-Id: <1263481176-1897-41-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.3.1.9.g95405b
In-Reply-To: <1263481176-1897-1-git-send-email-jason.wessel@windriver.com>
References: <1263481176-1897-1-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 14 Jan 2010 15:01:29.0710 (UTC) FILETIME=[73C780E0:01CA952A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add in a helper function to allow the kdb shell to dump the ftrace
buffer.

CC: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 Documentation/DocBook/kgdb.tmpl |    3 +-
 kernel/trace/Makefile           |    3 +
 kernel/trace/trace.c            |   48 +++++++---------
 kernel/trace/trace.h            |   17 ++++++
 kernel/trace/trace_kdb.c        |  116 +++++++++++++++++++++++++++++++++++++++
 5 files changed, 160 insertions(+), 27 deletions(-)
 create mode 100644 kernel/trace/trace_kdb.c

diff --git a/Documentation/DocBook/kgdb.tmpl b/Documentation/DocBook/kgdb.tmpl
index bbf4a22..b01b5b1 100644
--- a/Documentation/DocBook/kgdb.tmpl
+++ b/Documentation/DocBook/kgdb.tmpl
@@ -675,7 +675,8 @@ Task Addr       Pid   Parent [*] cpu State Thread     Command
       <itemizedlist>
         <listitem><para>A simple shell</para></listitem>
         <listitem><para>The kdb core command set</para></listitem>
-        <listitem><para>A registration API to register additional kdb shell commands.</para></listitem>
+        <listitem><para>A registration API to register additional kdb shell commands.</para>
+        <para>A good example of a self contained kdb module is the "ftdump" command for dumping the ftrace buffer.  See: kernel/trace/trace_kdb.c</para></listitem>
         <listitem><para>The implementation for kdb_printf() which emit messages directly to I/O drivers, bypassing the kernel log.</para></listitem>
         <listitem><para>SW / HW breakpoint management for the kdb shell</para></listitem>
       </itemizedlist>
diff --git a/kernel/trace/Makefile b/kernel/trace/Makefile
index cd9ecd8..c48a28f 100644
--- a/kernel/trace/Makefile
+++ b/kernel/trace/Makefile
@@ -56,5 +56,8 @@ obj-$(CONFIG_EVENT_TRACING) += trace_events_filter.o
 obj-$(CONFIG_KPROBE_EVENT) += trace_kprobe.o
 obj-$(CONFIG_KSYM_TRACER) += trace_ksym.o
 obj-$(CONFIG_EVENT_TRACING) += power-traces.o
+ifeq ($(CONFIG_TRACING),y)
+obj-$(CONFIG_KGDB_KDB) += trace_kdb.o
+endif
 
 libftrace-y := ftrace.o
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 0df1b0f..b3c786a 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -100,14 +100,11 @@ static inline void ftrace_enable_cpu(void)
 	preempt_enable();
 }
 
-static cpumask_var_t __read_mostly	tracing_buffer_mask;
+cpumask_var_t __read_mostly	tracing_buffer_mask;
 
 /* Define which cpu buffers are currently read in trace_pipe */
 static cpumask_var_t			tracing_reader_cpumask;
 
-#define for_each_tracing_cpu(cpu)	\
-	for_each_cpu(cpu, tracing_buffer_mask)
-
 /*
  * ftrace_dump_on_oops - variable to dump ftrace buffer on oops
  *
@@ -1409,11 +1406,6 @@ int trace_vprintk(unsigned long ip, const char *fmt, va_list args)
 }
 EXPORT_SYMBOL_GPL(trace_vprintk);
 
-enum trace_file_type {
-	TRACE_FILE_LAT_FMT	= 1,
-	TRACE_FILE_ANNOTATE	= 2,
-};
-
 static void trace_iterator_increment(struct trace_iterator *iter)
 {
 	/* Don't allow ftrace to trace into the ring buffers */
@@ -1503,7 +1495,7 @@ struct trace_entry *trace_find_next_entry(struct trace_iterator *iter,
 }
 
 /* Find the next real entry, and increment the iterator to the next entry */
-static void *find_next_entry_inc(struct trace_iterator *iter)
+void *trace_find_next_entry_inc(struct trace_iterator *iter)
 {
 	iter->ent = __find_next_entry(iter, &iter->cpu, &iter->ts);
 
@@ -1536,12 +1528,12 @@ static void *s_next(struct seq_file *m, void *v, loff_t *pos)
 		return NULL;
 
 	if (iter->idx < 0)
-		ent = find_next_entry_inc(iter);
+		ent = trace_find_next_entry_inc(iter);
 	else
 		ent = iter;
 
 	while (ent && iter->idx < i)
-		ent = find_next_entry_inc(iter);
+		ent = trace_find_next_entry_inc(iter);
 
 	iter->pos = *pos;
 
@@ -1878,7 +1870,7 @@ static enum print_line_t print_bin_fmt(struct trace_iterator *iter)
 	return event ? event->binary(iter, 0) : TRACE_TYPE_HANDLED;
 }
 
-static int trace_empty(struct trace_iterator *iter)
+int trace_empty(struct trace_iterator *iter)
 {
 	int cpu;
 
@@ -1909,7 +1901,7 @@ static int trace_empty(struct trace_iterator *iter)
 }
 
 /*  Called with trace_event_read_lock() held. */
-static enum print_line_t print_trace_line(struct trace_iterator *iter)
+enum print_line_t print_trace_line(struct trace_iterator *iter)
 {
 	enum print_line_t ret;
 
@@ -3074,7 +3066,7 @@ waitagain:
 	iter->pos = -1;
 
 	trace_event_read_lock();
-	while (find_next_entry_inc(iter) != NULL) {
+	while (trace_find_next_entry_inc(iter) != NULL) {
 		enum print_line_t ret;
 		int len = iter->seq.len;
 
@@ -3156,7 +3148,7 @@ tracing_fill_pipe_page(size_t rem, struct trace_iterator *iter)
 		if (ret != TRACE_TYPE_NO_CONSUME)
 			trace_consume(iter);
 		rem -= count;
-		if (!find_next_entry_inc(iter))	{
+		if (!trace_find_next_entry_inc(iter))	{
 			rem = 0;
 			iter->ent = NULL;
 			break;
@@ -3209,7 +3201,7 @@ static ssize_t tracing_splice_read_pipe(struct file *filp,
 	if (ret <= 0)
 		goto out_err;
 
-	if (!iter->ent && !find_next_entry_inc(iter)) {
+	if (!iter->ent && !trace_find_next_entry_inc(iter)) {
 		ret = -EFAULT;
 		goto out_err;
 	}
@@ -4262,7 +4254,7 @@ static struct notifier_block trace_die_notifier = {
  */
 #define KERN_TRACE		KERN_EMERG
 
-static void
+void
 trace_printk_seq(struct trace_seq *s)
 {
 	/* Probably should print a warning here. */
@@ -4277,6 +4269,13 @@ trace_printk_seq(struct trace_seq *s)
 	trace_seq_init(s);
 }
 
+void trace_init_global_iter(struct trace_iterator *iter)
+{
+	iter->tr = &global_trace;
+	iter->trace = current_trace;
+	iter->cpu_file = TRACE_PIPE_ALL_CPU;
+}
+
 static void __ftrace_dump(bool disable_tracing)
 {
 	static arch_spinlock_t ftrace_dump_lock =
@@ -4301,8 +4300,10 @@ static void __ftrace_dump(bool disable_tracing)
 	if (disable_tracing)
 		ftrace_kill();
 
+	trace_init_global_iter(&iter);
+
 	for_each_tracing_cpu(cpu) {
-		atomic_inc(&global_trace.data[cpu]->disabled);
+		atomic_inc(&iter.tr->data[cpu]->disabled);
 	}
 
 	old_userobj = trace_flags & TRACE_ITER_SYM_USEROBJ;
@@ -4312,11 +4313,6 @@ static void __ftrace_dump(bool disable_tracing)
 
 	printk(KERN_TRACE "Dumping ftrace buffer:\n");
 
-	/* Simulate the iterator */
-	iter.tr = &global_trace;
-	iter.trace = current_trace;
-	iter.cpu_file = TRACE_PIPE_ALL_CPU;
-
 	/*
 	 * We need to stop all tracing on all CPUS to read the
 	 * the next buffer. This is a bit expensive, but is
@@ -4338,7 +4334,7 @@ static void __ftrace_dump(bool disable_tracing)
 		iter.iter_flags |= TRACE_FILE_LAT_FMT;
 		iter.pos = -1;
 
-		if (find_next_entry_inc(&iter) != NULL) {
+		if (trace_find_next_entry_inc(&iter) != NULL) {
 			int ret;
 
 			ret = print_trace_line(&iter);
@@ -4359,7 +4355,7 @@ static void __ftrace_dump(bool disable_tracing)
 		trace_flags |= old_userobj;
 
 		for_each_tracing_cpu(cpu) {
-			atomic_dec(&global_trace.data[cpu]->disabled);
+			atomic_dec(&iter.tr->data[cpu]->disabled);
 		}
 		tracing_on();
 	}
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 4df6a77..563e6f8 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -352,6 +352,12 @@ struct trace_entry *tracing_get_trace_entry(struct trace_array *tr,
 struct trace_entry *trace_find_next_entry(struct trace_iterator *iter,
 					  int *ent_cpu, u64 *ent_ts);
 
+int trace_empty(struct trace_iterator *iter);
+
+void *trace_find_next_entry_inc(struct trace_iterator *iter);
+
+void trace_init_global_iter(struct trace_iterator *iter);
+
 void default_wait_pipe(struct trace_iterator *iter);
 void poll_wait_pipe(struct trace_iterator *iter);
 
@@ -391,6 +397,15 @@ void tracing_start_sched_switch_record(void);
 int register_tracer(struct tracer *type);
 void unregister_tracer(struct tracer *type);
 int is_tracing_stopped(void);
+enum trace_file_type {
+	TRACE_FILE_LAT_FMT	= 1,
+	TRACE_FILE_ANNOTATE	= 2,
+};
+
+extern cpumask_var_t __read_mostly tracing_buffer_mask;
+
+#define for_each_tracing_cpu(cpu)	\
+	for_each_cpu(cpu, tracing_buffer_mask)
 
 extern int process_new_ksym_entry(char *ksymname, int op, unsigned long addr);
 
@@ -483,6 +498,8 @@ trace_array_vprintk(struct trace_array *tr,
 		    unsigned long ip, const char *fmt, va_list args);
 int trace_array_printk(struct trace_array *tr,
 		       unsigned long ip, const char *fmt, ...);
+void trace_printk_seq(struct trace_seq *s);
+enum print_line_t print_trace_line(struct trace_iterator *iter);
 
 extern unsigned long trace_flags;
 
diff --git a/kernel/trace/trace_kdb.c b/kernel/trace/trace_kdb.c
new file mode 100644
index 0000000..9227ff3
--- /dev/null
+++ b/kernel/trace/trace_kdb.c
@@ -0,0 +1,116 @@
+/*
+ * kdb helper for dumping the ftrace buffer
+ *
+ * Copyright (C) 2010 Jason Wessel <jason.wessel@windriver.com>
+ *
+ * ftrace_dump_buf based on ftrace_dump:
+ * Copyright (C) 2007-2008 Steven Rostedt <srostedt@redhat.com>
+ * Copyright (C) 2008 Ingo Molnar <mingo@redhat.com>
+ *
+ */
+#include <linux/init.h>
+#include <linux/kgdb.h>
+#include <linux/kdb.h>
+#include <linux/ftrace.h>
+
+#include "../debug/kdb/kdb_private.h"
+#include "trace.h"
+#include "trace_output.h"
+
+static void ftrace_dump_buf(int skip_lines)
+{
+	/* use static because iter can be a bit big for the stack */
+	static struct trace_iterator iter;
+	unsigned int old_userobj;
+	int cnt = 0, cpu;
+
+	trace_init_global_iter(&iter);
+
+	for_each_tracing_cpu(cpu) {
+		atomic_inc(&iter.tr->data[cpu]->disabled);
+	}
+
+	old_userobj = trace_flags;
+
+	/* don't look at user memory in panic mode */
+	trace_flags &= ~TRACE_ITER_SYM_USEROBJ;
+
+	kdb_printf("Dumping ftrace buffer:\n");
+
+	/* reset all but tr, trace, and overruns */
+	memset(&iter.seq, 0,
+		   sizeof(struct trace_iterator) -
+		   offsetof(struct trace_iterator, seq));
+	iter.iter_flags |= TRACE_FILE_LAT_FMT;
+	iter.pos = -1;
+
+	for_each_tracing_cpu(cpu)
+		iter.buffer_iter[cpu] =
+			ring_buffer_read_start(iter.tr->buffer, cpu);
+
+	if (!trace_empty(&iter))
+		trace_find_next_entry_inc(&iter);
+	while (!trace_empty(&iter)) {
+		if (!cnt)
+			kdb_printf("---------------------------------\n");
+		cnt++;
+
+		if (trace_find_next_entry_inc(&iter) != NULL && !skip_lines)
+			print_trace_line(&iter);
+		if (!skip_lines)
+			trace_printk_seq(&iter.seq);
+		else
+			skip_lines--;
+		if (KDB_FLAG(CMD_INTERRUPT))
+			goto out;
+	}
+
+	if (!cnt)
+		kdb_printf("   (ftrace buffer empty)\n");
+	else
+		kdb_printf("---------------------------------\n");
+
+out:
+	trace_flags = old_userobj;
+
+	for_each_tracing_cpu(cpu) {
+		atomic_dec(&iter.tr->data[cpu]->disabled);
+	}
+
+	for_each_tracing_cpu(cpu)
+		if (iter.buffer_iter[cpu])
+			ring_buffer_read_finish(iter.buffer_iter[cpu]);
+}
+
+/*
+ * kdb_ftdump - Dump the ftrace log buffer
+ */
+static int kdb_ftdump(int argc, const char **argv)
+{
+	int skip_lines = 0;
+	char *cp;
+
+	if (argc > 1)
+		return KDB_ARGCOUNT;
+
+	if (argc) {
+		skip_lines = simple_strtol(argv[1], &cp, 0);
+		if (*cp)
+			skip_lines = 0;
+	}
+
+	kdb_trap_printk++;
+	ftrace_dump_buf(skip_lines);
+	kdb_trap_printk--;
+
+	return 0;
+}
+
+static __init int kdb_ftrace_register(void)
+{
+	kdb_register_repeat("ftdump", kdb_ftdump, "", "Dump ftrace log",
+			    0, KDB_REPEAT_NONE);
+	return 0;
+}
+
+late_initcall(kdb_ftrace_register);
-- 
1.6.3.1.9.g95405b

