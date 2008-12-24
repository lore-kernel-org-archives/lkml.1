Return-Path: <linux-kernel-owner+w=401wt.eu-S1752119AbYLXEZy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752119AbYLXEZy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2008 23:25:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751979AbYLXEZH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Dec 2008 23:25:07 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:38287 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751481AbYLXEZC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2008 23:25:02 -0500
Message-Id: <20081224042459.886327787@goodmis.org>
References: <20081224042410.746044949@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 23 Dec 2008 23:24:12 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Pekka Paalanen <pq@iki.fi>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 2/3] ftrace: set up trace event hash infrastructure
Content-Disposition: inline; filename=0002-ftrace-set-up-trace-event-hash-infrastructure.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Impact: introduction of trace event hash

The trace.c file is becoming more difficult to maintain due to the
growing number of events. There is several formats that an event may
be printed. This patch sets up the infrastructure of an event hash to
allow for events to register how they should be printed.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/Makefile                |    1 +
 kernel/trace/trace.c                 |  275 +-------------------------
 kernel/trace/trace.h                 |    8 +-
 kernel/trace/trace_boot.c            |    1 +
 kernel/trace/trace_functions_graph.c |    1 +
 kernel/trace/trace_hw_branches.c     |    1 +
 kernel/trace/trace_mmiotrace.c       |    1 +
 kernel/trace/trace_output.c          |  365 ++++++++++++++++++++++++++++++++++
 kernel/trace/trace_output.h          |   43 ++++
 kernel/trace/trace_power.c           |    1 +
 10 files changed, 416 insertions(+), 281 deletions(-)
 create mode 100644 kernel/trace/trace_output.c
 create mode 100644 kernel/trace/trace_output.h

diff --git a/kernel/trace/Makefile b/kernel/trace/Makefile
index 349d5a9..549f93c 100644
--- a/kernel/trace/Makefile
+++ b/kernel/trace/Makefile
@@ -19,6 +19,7 @@ obj-$(CONFIG_FUNCTION_TRACER) += libftrace.o
 obj-$(CONFIG_RING_BUFFER) += ring_buffer.o
 
 obj-$(CONFIG_TRACING) += trace.o
+obj-$(CONFIG_TRACING) += trace_output.o
 obj-$(CONFIG_CONTEXT_SWITCH_TRACER) += trace_sched_switch.o
 obj-$(CONFIG_SYSPROF_TRACER) += trace_sysprof.o
 obj-$(CONFIG_FUNCTION_TRACER) += trace_functions.o
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 481d79b..707340f 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -38,6 +38,7 @@
 #include <linux/irqflags.h>
 
 #include "trace.h"
+#include "trace_output.h"
 
 #define TRACE_BUFFER_FLAGS	(RB_FL_OVERWRITE)
 
@@ -330,132 +331,6 @@ __update_max_tr(struct trace_array *tr, struct task_struct *tsk, int cpu)
 	tracing_record_cmdline(current);
 }
 
-/**
- * trace_seq_printf - sequence printing of trace information
- * @s: trace sequence descriptor
- * @fmt: printf format string
- *
- * The tracer may use either sequence operations or its own
- * copy to user routines. To simplify formating of a trace
- * trace_seq_printf is used to store strings into a special
- * buffer (@s). Then the output may be either used by
- * the sequencer or pulled into another buffer.
- */
-int
-trace_seq_printf(struct trace_seq *s, const char *fmt, ...)
-{
-	int len = (PAGE_SIZE - 1) - s->len;
-	va_list ap;
-	int ret;
-
-	if (!len)
-		return 0;
-
-	va_start(ap, fmt);
-	ret = vsnprintf(s->buffer + s->len, len, fmt, ap);
-	va_end(ap);
-
-	/* If we can't write it all, don't bother writing anything */
-	if (ret >= len)
-		return 0;
-
-	s->len += ret;
-
-	return len;
-}
-
-/**
- * trace_seq_puts - trace sequence printing of simple string
- * @s: trace sequence descriptor
- * @str: simple string to record
- *
- * The tracer may use either the sequence operations or its own
- * copy to user routines. This function records a simple string
- * into a special buffer (@s) for later retrieval by a sequencer
- * or other mechanism.
- */
-static int
-trace_seq_puts(struct trace_seq *s, const char *str)
-{
-	int len = strlen(str);
-
-	if (len > ((PAGE_SIZE - 1) - s->len))
-		return 0;
-
-	memcpy(s->buffer + s->len, str, len);
-	s->len += len;
-
-	return len;
-}
-
-static int
-trace_seq_putc(struct trace_seq *s, unsigned char c)
-{
-	if (s->len >= (PAGE_SIZE - 1))
-		return 0;
-
-	s->buffer[s->len++] = c;
-
-	return 1;
-}
-
-static int
-trace_seq_putmem(struct trace_seq *s, void *mem, size_t len)
-{
-	if (len > ((PAGE_SIZE - 1) - s->len))
-		return 0;
-
-	memcpy(s->buffer + s->len, mem, len);
-	s->len += len;
-
-	return len;
-}
-
-#define MAX_MEMHEX_BYTES	8
-#define HEX_CHARS		(MAX_MEMHEX_BYTES*2 + 1)
-
-static int
-trace_seq_putmem_hex(struct trace_seq *s, void *mem, size_t len)
-{
-	unsigned char hex[HEX_CHARS];
-	unsigned char *data = mem;
-	int i, j;
-
-#ifdef __BIG_ENDIAN
-	for (i = 0, j = 0; i < len; i++) {
-#else
-	for (i = len-1, j = 0; i >= 0; i--) {
-#endif
-		hex[j++] = hex_asc_hi(data[i]);
-		hex[j++] = hex_asc_lo(data[i]);
-	}
-	hex[j++] = ' ';
-
-	return trace_seq_putmem(s, hex, j);
-}
-
-static int
-trace_seq_path(struct trace_seq *s, struct path *path)
-{
-	unsigned char *p;
-
-	if (s->len >= (PAGE_SIZE - 1))
-		return 0;
-	p = d_path(path, s->buffer + s->len, PAGE_SIZE - s->len);
-	if (!IS_ERR(p)) {
-		p = mangle_path(s->buffer + s->len, p, "\n");
-		if (p) {
-			s->len = p - s->buffer;
-			return 1;
-		}
-	} else {
-		s->buffer[s->len++] = '?';
-		return 1;
-	}
-
-	return 0;
-}
-
 static void
 trace_seq_reset(struct trace_seq *s)
 {
@@ -1473,154 +1348,6 @@ static void s_stop(struct seq_file *m, void *p)
 	mutex_unlock(&trace_types_lock);
 }
 
-#ifdef CONFIG_KRETPROBES
-static inline const char *kretprobed(const char *name)
-{
-	static const char tramp_name[] = "kretprobe_trampoline";
-	int size = sizeof(tramp_name);
-
-	if (strncmp(tramp_name, name, size) == 0)
-		return "[unknown/kretprobe'd]";
-	return name;
-}
-#else
-static inline const char *kretprobed(const char *name)
-{
-	return name;
-}
-#endif /* CONFIG_KRETPROBES */
-
-static int
-seq_print_sym_short(struct trace_seq *s, const char *fmt, unsigned long address)
-{
-#ifdef CONFIG_KALLSYMS
-	char str[KSYM_SYMBOL_LEN];
-	const char *name;
-
-	kallsyms_lookup(address, NULL, NULL, NULL, str);
-
-	name = kretprobed(str);
-
-	return trace_seq_printf(s, fmt, name);
-#endif
-	return 1;
-}
-
-static int
-seq_print_sym_offset(struct trace_seq *s, const char *fmt,
-		     unsigned long address)
-{
-#ifdef CONFIG_KALLSYMS
-	char str[KSYM_SYMBOL_LEN];
-	const char *name;
-
-	sprint_symbol(str, address);
-	name = kretprobed(str);
-
-	return trace_seq_printf(s, fmt, name);
-#endif
-	return 1;
-}
-
-#ifndef CONFIG_64BIT
-# define IP_FMT "%08lx"
-#else
-# define IP_FMT "%016lx"
-#endif
-
-int
-seq_print_ip_sym(struct trace_seq *s, unsigned long ip, unsigned long sym_flags)
-{
-	int ret;
-
-	if (!ip)
-		return trace_seq_printf(s, "0");
-
-	if (sym_flags & TRACE_ITER_SYM_OFFSET)
-		ret = seq_print_sym_offset(s, "%s", ip);
-	else
-		ret = seq_print_sym_short(s, "%s", ip);
-
-	if (!ret)
-		return 0;
-
-	if (sym_flags & TRACE_ITER_SYM_ADDR)
-		ret = trace_seq_printf(s, " <" IP_FMT ">", ip);
-	return ret;
-}
-
-static inline int seq_print_user_ip(struct trace_seq *s, struct mm_struct *mm,
-				    unsigned long ip, unsigned long sym_flags)
-{
-	struct file *file = NULL;
-	unsigned long vmstart = 0;
-	int ret = 1;
-
-	if (mm) {
-		const struct vm_area_struct *vma;
-
-		down_read(&mm->mmap_sem);
-		vma = find_vma(mm, ip);
-		if (vma) {
-			file = vma->vm_file;
-			vmstart = vma->vm_start;
-		}
-		if (file) {
-			ret = trace_seq_path(s, &file->f_path);
-			if (ret)
-				ret = trace_seq_printf(s, "[+0x%lx]", ip - vmstart);
-		}
-		up_read(&mm->mmap_sem);
-	}
-	if (ret && ((sym_flags & TRACE_ITER_SYM_ADDR) || !file))
-		ret = trace_seq_printf(s, " <" IP_FMT ">", ip);
-	return ret;
-}
-
-static int
-seq_print_userip_objs(const struct userstack_entry *entry, struct trace_seq *s,
-		      unsigned long sym_flags)
-{
-	struct mm_struct *mm = NULL;
-	int ret = 1;
-	unsigned int i;
-
-	if (trace_flags & TRACE_ITER_SYM_USEROBJ) {
-		struct task_struct *task;
-		/*
-		 * we do the lookup on the thread group leader,
-		 * since individual threads might have already quit!
-		 */
-		rcu_read_lock();
-		task = find_task_by_vpid(entry->ent.tgid);
-		if (task)
-			mm = get_task_mm(task);
-		rcu_read_unlock();
-	}
-
-	for (i = 0; i < FTRACE_STACK_ENTRIES; i++) {
-		unsigned long ip = entry->caller[i];
-
-		if (ip == ULONG_MAX || !ret)
-			break;
-		if (i && ret)
-			ret = trace_seq_puts(s, " <- ");
-		if (!ip) {
-			if (ret)
-				ret = trace_seq_puts(s, "??");
-			continue;
-		}
-		if (!ret)
-			break;
-		if (ret)
-			ret = seq_print_user_ip(s, mm, ip, sym_flags);
-	}
-
-	if (mm)
-		mmput(mm);
-	return ret;
-}
-
 static void print_lat_help_header(struct seq_file *m)
 {
 	seq_puts(m, "#                  _------=> CPU#            \n");
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 3a35738..6bd71fa 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -30,7 +30,7 @@ enum trace_type {
 	TRACE_HW_BRANCHES,
 	TRACE_POWER,
 
-	__TRACE_LAST_TYPE
+	__TRACE_LAST_TYPE,
 };
 
 /*
@@ -484,12 +484,6 @@ extern int trace_selftest_startup_branch(struct tracer *trace,
 #endif /* CONFIG_FTRACE_STARTUP_TEST */
 
 extern void *head_page(struct trace_array_cpu *data);
-extern int trace_seq_printf(struct trace_seq *s, const char *fmt, ...);
-extern int
-seq_print_ip_sym(struct trace_seq *s, unsigned long ip,
-		unsigned long sym_flags);
-extern ssize_t trace_seq_to_user(struct trace_seq *s, char __user *ubuf,
-				 size_t cnt);
 extern long ns2usecs(cycle_t nsec);
 extern int
 trace_vprintk(unsigned long ip, int depth, const char *fmt, va_list args);
diff --git a/kernel/trace/trace_boot.c b/kernel/trace/trace_boot.c
index 3ccebde..cb2ff3e 100644
--- a/kernel/trace/trace_boot.c
+++ b/kernel/trace/trace_boot.c
@@ -11,6 +11,7 @@
 #include <linux/kallsyms.h>
 
 #include "trace.h"
+#include "trace_output.h"
 
 static struct trace_array *boot_trace;
 static bool pre_initcalls_finished;
diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
index a02c997..8a34006 100644
--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
@@ -12,6 +12,7 @@
 #include <linux/fs.h>
 
 #include "trace.h"
+#include "trace_output.h"
 
 #define TRACE_GRAPH_INDENT	2
 
diff --git a/kernel/trace/trace_hw_branches.c b/kernel/trace/trace_hw_branches.c
index b6a3e20..879752b 100644
--- a/kernel/trace/trace_hw_branches.c
+++ b/kernel/trace/trace_hw_branches.c
@@ -14,6 +14,7 @@
 #include <asm/ds.h>
 
 #include "trace.h"
+#include "trace_output.h"
 
 
 #define SIZEOF_BTS (1 << 13)
diff --git a/kernel/trace/trace_mmiotrace.c b/kernel/trace/trace_mmiotrace.c
index 83f20ae..fcec59f 100644
--- a/kernel/trace/trace_mmiotrace.c
+++ b/kernel/trace/trace_mmiotrace.c
@@ -11,6 +11,7 @@
 #include <linux/pci.h>
 
 #include "trace.h"
+#include "trace_output.h"
 
 struct header_iter {
 	struct pci_dev *dev;
diff --git a/kernel/trace/trace_output.c b/kernel/trace/trace_output.c
new file mode 100644
index 0000000..1f3f800
--- /dev/null
+++ b/kernel/trace/trace_output.c
@@ -0,0 +1,365 @@
+/*
+ * trace_output.c
+ *
+ * Copyright (C) 2008 Red Hat Inc, Steven Rostedt <srostedt@redhat.com>
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/mutex.h>
+#include <linux/ftrace.h>
+
+#include "trace_output.h"
+
+/* must be a power of 2 */
+#define EVENT_HASHSIZE	128
+
+static DEFINE_MUTEX(trace_event_mutex);
+static struct hlist_head event_hash[EVENT_HASHSIZE] __read_mostly;
+
+static int next_event_type = __TRACE_LAST_TYPE + 1;
+
+/**
+ * trace_seq_printf - sequence printing of trace information
+ * @s: trace sequence descriptor
+ * @fmt: printf format string
+ *
+ * The tracer may use either sequence operations or its own
+ * copy to user routines. To simplify formating of a trace
+ * trace_seq_printf is used to store strings into a special
+ * buffer (@s). Then the output may be either used by
+ * the sequencer or pulled into another buffer.
+ */
+int
+trace_seq_printf(struct trace_seq *s, const char *fmt, ...)
+{
+	int len = (PAGE_SIZE - 1) - s->len;
+	va_list ap;
+	int ret;
+
+	if (!len)
+		return 0;
+
+	va_start(ap, fmt);
+	ret = vsnprintf(s->buffer + s->len, len, fmt, ap);
+	va_end(ap);
+
+	/* If we can't write it all, don't bother writing anything */
+	if (ret >= len)
+		return 0;
+
+	s->len += ret;
+
+	return len;
+}
+
+/**
+ * trace_seq_puts - trace sequence printing of simple string
+ * @s: trace sequence descriptor
+ * @str: simple string to record
+ *
+ * The tracer may use either the sequence operations or its own
+ * copy to user routines. This function records a simple string
+ * into a special buffer (@s) for later retrieval by a sequencer
+ * or other mechanism.
+ */
+int trace_seq_puts(struct trace_seq *s, const char *str)
+{
+	int len = strlen(str);
+
+	if (len > ((PAGE_SIZE - 1) - s->len))
+		return 0;
+
+	memcpy(s->buffer + s->len, str, len);
+	s->len += len;
+
+	return len;
+}
+
+int trace_seq_putc(struct trace_seq *s, unsigned char c)
+{
+	if (s->len >= (PAGE_SIZE - 1))
+		return 0;
+
+	s->buffer[s->len++] = c;
+
+	return 1;
+}
+
+int trace_seq_putmem(struct trace_seq *s, void *mem, size_t len)
+{
+	if (len > ((PAGE_SIZE - 1) - s->len))
+		return 0;
+
+	memcpy(s->buffer + s->len, mem, len);
+	s->len += len;
+
+	return len;
+}
+
+int trace_seq_putmem_hex(struct trace_seq *s, void *mem, size_t len)
+{
+	unsigned char hex[HEX_CHARS];
+	unsigned char *data = mem;
+	int i, j;
+
+#ifdef __BIG_ENDIAN
+	for (i = 0, j = 0; i < len; i++) {
+#else
+	for (i = len-1, j = 0; i >= 0; i--) {
+#endif
+		hex[j++] = hex_asc_hi(data[i]);
+		hex[j++] = hex_asc_lo(data[i]);
+	}
+	hex[j++] = ' ';
+
+	return trace_seq_putmem(s, hex, j);
+}
+
+int trace_seq_path(struct trace_seq *s, struct path *path)
+{
+	unsigned char *p;
+
+	if (s->len >= (PAGE_SIZE - 1))
+		return 0;
+	p = d_path(path, s->buffer + s->len, PAGE_SIZE - s->len);
+	if (!IS_ERR(p)) {
+		p = mangle_path(s->buffer + s->len, p, "\n");
+		if (p) {
+			s->len = p - s->buffer;
+			return 1;
+		}
+	} else {
+		s->buffer[s->len++] = '?';
+		return 1;
+	}
+
+	return 0;
+}
+
+#ifdef CONFIG_KRETPROBES
+static inline const char *kretprobed(const char *name)
+{
+	static const char tramp_name[] = "kretprobe_trampoline";
+	int size = sizeof(tramp_name);
+
+	if (strncmp(tramp_name, name, size) == 0)
+		return "[unknown/kretprobe'd]";
+	return name;
+}
+#else
+static inline const char *kretprobed(const char *name)
+{
+	return name;
+}
+#endif /* CONFIG_KRETPROBES */
+
+static int
+seq_print_sym_short(struct trace_seq *s, const char *fmt, unsigned long address)
+{
+#ifdef CONFIG_KALLSYMS
+	char str[KSYM_SYMBOL_LEN];
+	const char *name;
+
+	kallsyms_lookup(address, NULL, NULL, NULL, str);
+
+	name = kretprobed(str);
+
+	return trace_seq_printf(s, fmt, name);
+#endif
+	return 1;
+}
+
+static int
+seq_print_sym_offset(struct trace_seq *s, const char *fmt,
+		     unsigned long address)
+{
+#ifdef CONFIG_KALLSYMS
+	char str[KSYM_SYMBOL_LEN];
+	const char *name;
+
+	sprint_symbol(str, address);
+	name = kretprobed(str);
+
+	return trace_seq_printf(s, fmt, name);
+#endif
+	return 1;
+}
+
+#ifndef CONFIG_64BIT
+# define IP_FMT "%08lx"
+#else
+# define IP_FMT "%016lx"
+#endif
+
+int seq_print_user_ip(struct trace_seq *s, struct mm_struct *mm,
+		      unsigned long ip, unsigned long sym_flags)
+{
+	struct file *file = NULL;
+	unsigned long vmstart = 0;
+	int ret = 1;
+
+	if (mm) {
+		const struct vm_area_struct *vma;
+
+		down_read(&mm->mmap_sem);
+		vma = find_vma(mm, ip);
+		if (vma) {
+			file = vma->vm_file;
+			vmstart = vma->vm_start;
+		}
+		if (file) {
+			ret = trace_seq_path(s, &file->f_path);
+			if (ret)
+				ret = trace_seq_printf(s, "[+0x%lx]",
+						       ip - vmstart);
+		}
+		up_read(&mm->mmap_sem);
+	}
+	if (ret && ((sym_flags & TRACE_ITER_SYM_ADDR) || !file))
+		ret = trace_seq_printf(s, " <" IP_FMT ">", ip);
+	return ret;
+}
+
+int
+seq_print_userip_objs(const struct userstack_entry *entry, struct trace_seq *s,
+		      unsigned long sym_flags)
+{
+	struct mm_struct *mm = NULL;
+	int ret = 1;
+	unsigned int i;
+
+	if (trace_flags & TRACE_ITER_SYM_USEROBJ) {
+		struct task_struct *task;
+		/*
+		 * we do the lookup on the thread group leader,
+		 * since individual threads might have already quit!
+		 */
+		rcu_read_lock();
+		task = find_task_by_vpid(entry->ent.tgid);
+		if (task)
+			mm = get_task_mm(task);
+		rcu_read_unlock();
+	}
+
+	for (i = 0; i < FTRACE_STACK_ENTRIES; i++) {
+		unsigned long ip = entry->caller[i];
+
+		if (ip == ULONG_MAX || !ret)
+			break;
+		if (i && ret)
+			ret = trace_seq_puts(s, " <- ");
+		if (!ip) {
+			if (ret)
+				ret = trace_seq_puts(s, "??");
+			continue;
+		}
+		if (!ret)
+			break;
+		if (ret)
+			ret = seq_print_user_ip(s, mm, ip, sym_flags);
+	}
+
+	if (mm)
+		mmput(mm);
+	return ret;
+}
+
+int
+seq_print_ip_sym(struct trace_seq *s, unsigned long ip, unsigned long sym_flags)
+{
+	int ret;
+
+	if (!ip)
+		return trace_seq_printf(s, "0");
+
+	if (sym_flags & TRACE_ITER_SYM_OFFSET)
+		ret = seq_print_sym_offset(s, "%s", ip);
+	else
+		ret = seq_print_sym_short(s, "%s", ip);
+
+	if (!ret)
+		return 0;
+
+	if (sym_flags & TRACE_ITER_SYM_ADDR)
+		ret = trace_seq_printf(s, " <" IP_FMT ">", ip);
+	return ret;
+}
+
+/**
+ * ftrace_find_event - find a registered event
+ * @type: the type of event to look for
+ *
+ * Returns an event of type @type otherwise NULL
+ */
+struct trace_event *ftrace_find_event(int type)
+{
+	struct trace_event *event;
+	struct hlist_node *n;
+	unsigned key;
+
+	key = type & (EVENT_HASHSIZE - 1);
+
+	hlist_for_each_entry_rcu(event, n, &event_hash[key], node) {
+		if (event->type == type)
+			return event;
+	}
+
+	return NULL;
+}
+
+/**
+ * register_ftrace_event - register output for an event type
+ * @event: the event type to register
+ *
+ * Event types are stored in a hash and this hash is used to
+ * find a way to print an event. If the @event->type is set
+ * then it will use that type, otherwise it will assign a
+ * type to use.
+ *
+ * If you assign your own type, please make sure it is added
+ * to the trace_type enum in trace.h, to avoid collisions
+ * with the dynamic types.
+ *
+ * Returns the event type number or zero on error.
+ */
+int register_ftrace_event(struct trace_event *event)
+{
+	unsigned key;
+	int ret = 0;
+
+	mutex_lock(&trace_event_mutex);
+
+	if (!event->type)
+		event->type = next_event_type++;
+	else if (event->type > __TRACE_LAST_TYPE) {
+		printk(KERN_WARNING "Need to add type to trace.h\n");
+		WARN_ON(1);
+	}
+
+	if (ftrace_find_event(event->type))
+		goto out;
+
+	key = event->type & (EVENT_HASHSIZE - 1);
+
+	hlist_add_head_rcu(&event->node, &event_hash[key]);
+
+	ret = event->type;
+ out:
+	mutex_unlock(&trace_event_mutex);
+
+	return ret;
+}
+
+/**
+ * unregister_ftrace_event - remove a no longer used event
+ * @event: the event to remove
+ */
+int unregister_ftrace_event(struct trace_event *event)
+{
+	mutex_lock(&trace_event_mutex);
+	hlist_del(&event->node);
+	mutex_unlock(&trace_event_mutex);
+
+	return 0;
+}
diff --git a/kernel/trace/trace_output.h b/kernel/trace/trace_output.h
new file mode 100644
index 0000000..1fcc76e
--- /dev/null
+++ b/kernel/trace/trace_output.h
@@ -0,0 +1,43 @@
+#ifndef __TRACE_EVENTS_H
+#define __TRACE_EVENTS_H
+
+#include "trace.h"
+
+typedef int (*trace_print_func)(struct trace_seq *s, struct trace_entry *entry,
+				int flags);
+
+struct trace_event {
+	struct hlist_node	node;
+	int			type;
+	trace_print_func	trace;
+	trace_print_func	latency_trace;
+	trace_print_func	raw;
+	trace_print_func	hex;
+	trace_print_func	binary;
+};
+
+extern int trace_seq_printf(struct trace_seq *s, const char *fmt, ...);
+extern int
+seq_print_ip_sym(struct trace_seq *s, unsigned long ip,
+		unsigned long sym_flags);
+extern ssize_t trace_seq_to_user(struct trace_seq *s, char __user *ubuf,
+				 size_t cnt);
+int trace_seq_puts(struct trace_seq *s, const char *str);
+int trace_seq_putc(struct trace_seq *s, unsigned char c);
+int trace_seq_putmem(struct trace_seq *s, void *mem, size_t len);
+int trace_seq_putmem_hex(struct trace_seq *s, void *mem, size_t len);
+int trace_seq_path(struct trace_seq *s, struct path *path);
+int seq_print_userip_objs(const struct userstack_entry *entry,
+			  struct trace_seq *s, unsigned long sym_flags);
+int seq_print_user_ip(struct trace_seq *s, struct mm_struct *mm,
+		      unsigned long ip, unsigned long sym_flags);
+
+struct trace_event *ftrace_find_event(int type);
+int register_ftrace_event(struct trace_event *event);
+int unregister_ftrace_event(struct trace_event *event);
+
+#define MAX_MEMHEX_BYTES	8
+#define HEX_CHARS		(MAX_MEMHEX_BYTES*2 + 1)
+
+#endif
+
diff --git a/kernel/trace/trace_power.c b/kernel/trace/trace_power.c
index a7172a3..b9b13c3 100644
--- a/kernel/trace/trace_power.c
+++ b/kernel/trace/trace_power.c
@@ -16,6 +16,7 @@
 #include <linux/module.h>
 
 #include "trace.h"
+#include "trace_output.h"
 
 static struct trace_array *power_trace;
 static int __read_mostly trace_power_enabled;
-- 
1.5.6.5

-- 
