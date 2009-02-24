Return-Path: <linux-kernel-owner+w=401wt.eu-S1759639AbZBXTfs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759639AbZBXTfs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 14:35:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754876AbZBXTe5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 14:34:57 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:33584 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753765AbZBXTey (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 14:34:54 -0500
Message-Id: <20090224193450.734369391@goodmis.org>
References: <20090224193344.638329210@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 24 Feb 2009 14:33:45 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Theodore Tso <tytso@mit.edu>,
       Arjan van de Ven <arjan@infradead.org>, Pekka Paalanen <pq@iki.fi>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Jason Baron <jbaron@redhat.com>, Martin Bligh <mbligh@google.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 1/4][RFC] tracing: add event trace infrastructure
Content-Disposition: inline; filename=0001-tracing-add-event-trace-infrastructure.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

This patch creates the event tracing infrastructure of ftrace.
It will create the files:

 /debug/tracing/available_events
 /debug/tracing/set_event

The available_events will list the trace points that have been
registered with the event tracer.

set_events will allow the user to enable or disable an event hook.

example:

 # echo sched_wakeup > /debug/tracing/set_event

Will enable the sched_wakeup event (if it is registered).

 # echo "!sched_wakeup" >> /debug/tracing/set_event

Will disable the sched_wakeup event (and only that event).

 # echo > /debug/tracing/set_event

Will disable all events (notice the '>')

 # cat /debug/tracing/available_events > /debug/tracing/set_event

Will enable all registered event hooks.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 include/asm-generic/vmlinux.lds.h |   11 ++-
 kernel/trace/Kconfig              |    9 ++
 kernel/trace/Makefile             |    1 +
 kernel/trace/trace_events.c       |  280 +++++++++++++++++++++++++++++++++++++
 kernel/trace/trace_events.h       |   49 +++++++
 5 files changed, 349 insertions(+), 1 deletions(-)
 create mode 100644 kernel/trace/trace_events.c
 create mode 100644 kernel/trace/trace_events.h

diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index 5406e70..9d97491 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -61,6 +61,14 @@
 #define BRANCH_PROFILE()
 #endif
 
+#ifdef CONFIG_EVENT_TRACER
+#define FTRACE_EVENTS()	VMLINUX_SYMBOL(__start_ftrace_events) = .;	\
+			*(_ftrace_events)				\
+			VMLINUX_SYMBOL(__stop_ftrace_events) = .;
+#else
+#define FTRACE_EVENTS()
+#endif
+
 /* .data section */
 #define DATA_DATA							\
 	*(.data)							\
@@ -81,7 +89,8 @@
 	*(__tracepoints)						\
 	VMLINUX_SYMBOL(__stop___tracepoints) = .;			\
 	LIKELY_PROFILE()		       				\
-	BRANCH_PROFILE()
+	BRANCH_PROFILE()						\
+	FTRACE_EVENTS()
 
 #define RO_DATA(align)							\
 	. = ALIGN((align));						\
diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index 9e4f17c..02bc5d6 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -159,6 +159,15 @@ config CONTEXT_SWITCH_TRACER
 	  This tracer gets called from the context switch and records
 	  all switching of tasks.
 
+config EVENT_TRACER
+	bool "Trace various events in the kernel"
+	depends on DEBUG_KERNEL
+	select TRACING
+	help
+	  This tracer hooks to various trace points in the kernel
+	  allowing the user to pick and choose which trace point they
+	  want to trace.
+
 config BOOT_TRACER
 	bool "Trace boot initcalls"
 	depends on DEBUG_KERNEL
diff --git a/kernel/trace/Makefile b/kernel/trace/Makefile
index 627090b..c736356 100644
--- a/kernel/trace/Makefile
+++ b/kernel/trace/Makefile
@@ -38,5 +38,6 @@ obj-$(CONFIG_POWER_TRACER) += trace_power.o
 obj-$(CONFIG_KMEMTRACE) += kmemtrace.o
 obj-$(CONFIG_WORKQUEUE_TRACER) += trace_workqueue.o
 obj-$(CONFIG_BLK_DEV_IO_TRACE)	+= blktrace.o
+obj-$(CONFIG_EVENT_TRACER) += trace_events.o
 
 libftrace-y := ftrace.o
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
new file mode 100644
index 0000000..05bc80e
--- /dev/null
+++ b/kernel/trace/trace_events.c
@@ -0,0 +1,280 @@
+/*
+ * event tracer
+ *
+ * Copyright (C) 2008 Red Hat Inc, Steven Rostedt <srostedt@redhat.com>
+ *
+ */
+
+#include <linux/debugfs.h>
+#include <linux/uaccess.h>
+#include <linux/module.h>
+#include <linux/ctype.h>
+
+#include "trace_events.h"
+
+void event_trace_printk(unsigned long ip, const char *fmt, ...)
+{
+	va_list ap;
+
+	va_start(ap, fmt);
+	tracing_record_cmdline(current);
+	trace_vprintk(ip, task_curr_ret_stack(current), fmt, ap);
+	va_end(ap);
+}
+
+static void ftrace_clear_events(void)
+{
+	struct ftrace_event_call *call = (void *)__start_ftrace_events;
+
+
+	while ((unsigned long)call < (unsigned long)__stop_ftrace_events) {
+
+		if (call->enabled) {
+			call->enabled = 0;
+			call->unregfunc();
+		}
+		call++;
+	}
+}
+
+static int ftrace_set_clr_event(char *buf, int set)
+{
+	struct ftrace_event_call *call = (void *)__start_ftrace_events;
+
+
+	while ((unsigned long)call < (unsigned long)__stop_ftrace_events) {
+
+		if (strcmp(buf, call->name) != 0) {
+			call++;
+			continue;
+		}
+
+		if (set) {
+			/* Already set? */
+			if (call->enabled)
+				return 0;
+			call->enabled = 1;
+			call->regfunc();
+		} else {
+			/* Already cleared? */
+			if (!call->enabled)
+				return 0;
+			call->enabled = 0;
+			call->unregfunc();
+		}
+		return 0;
+	}
+	return -EINVAL;
+}
+
+/* 128 should be much more than enough */
+#define EVENT_BUF_SIZE		127
+
+static ssize_t
+ftrace_event_write(struct file *file, const char __user *ubuf,
+		   size_t cnt, loff_t *ppos)
+{
+	size_t read = 0;
+	int i, set = 1;
+	ssize_t ret;
+	char *buf;
+	char ch;
+
+	if (!cnt || cnt < 0)
+		return 0;
+
+	ret = get_user(ch, ubuf++);
+	if (ret)
+		return ret;
+	read++;
+	cnt--;
+
+	/* skip white space */
+	while (cnt && isspace(ch)) {
+		ret = get_user(ch, ubuf++);
+		if (ret)
+			return ret;
+		read++;
+		cnt--;
+	}
+
+	/* Only white space found? */
+	if (isspace(ch)) {
+		file->f_pos += read;
+		ret = read;
+		return ret;
+	}
+
+	buf = kmalloc(EVENT_BUF_SIZE+1, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	if (cnt > EVENT_BUF_SIZE)
+		cnt = EVENT_BUF_SIZE;
+
+	i = 0;
+	while (cnt && !isspace(ch)) {
+		if (!i && ch == '!')
+			set = 0;
+		else
+			buf[i++] = ch;
+
+		ret = get_user(ch, ubuf++);
+		if (ret)
+			goto out_free;
+		read++;
+		cnt--;
+	}
+	buf[i] = 0;
+
+	file->f_pos += read;
+
+	ret = ftrace_set_clr_event(buf, set);
+	if (ret)
+		goto out_free;
+
+	ret = read;
+
+ out_free:
+	kfree(buf);
+
+	return ret;
+}
+
+static void *
+t_next(struct seq_file *m, void *v, loff_t *pos)
+{
+	struct ftrace_event_call *call = m->private;
+	struct ftrace_event_call *next = call;
+
+	(*pos)++;
+
+	if ((unsigned long)call >= (unsigned long)__stop_ftrace_events)
+		return NULL;
+
+	m->private = ++next;
+
+	return call;
+}
+
+static void *t_start(struct seq_file *m, loff_t *pos)
+{
+	return t_next(m, NULL, pos);
+}
+
+static void *
+s_next(struct seq_file *m, void *v, loff_t *pos)
+{
+	struct ftrace_event_call *call = m->private;
+	struct ftrace_event_call *next;
+
+	(*pos)++;
+
+ retry:
+	if ((unsigned long)call >= (unsigned long)__stop_ftrace_events)
+		return NULL;
+
+	if (!call->enabled) {
+		call++;
+		goto retry;
+	}
+
+	next = call;
+	m->private = ++next;
+
+	return call;
+}
+
+static void *s_start(struct seq_file *m, loff_t *pos)
+{
+	return s_next(m, NULL, pos);
+}
+
+static int t_show(struct seq_file *m, void *v)
+{
+	struct ftrace_event_call *call = v;
+
+	seq_printf(m, "%s\n", call->name);
+
+	return 0;
+}
+
+static void t_stop(struct seq_file *m, void *p)
+{
+}
+
+static int
+ftrace_event_seq_open(struct inode *inode, struct file *file)
+{
+	int ret;
+	const struct seq_operations *seq_ops;
+
+	if ((file->f_mode & FMODE_WRITE) &&
+	    !(file->f_flags & O_APPEND))
+		ftrace_clear_events();
+
+	seq_ops = inode->i_private;
+	ret = seq_open(file, seq_ops);
+	if (!ret) {
+		struct seq_file *m = file->private_data;
+
+		m->private = __start_ftrace_events;
+	}
+	return ret;
+}
+
+static const struct seq_operations show_event_seq_ops = {
+	.start = t_start,
+	.next = t_next,
+	.show = t_show,
+	.stop = t_stop,
+};
+
+static const struct seq_operations show_set_event_seq_ops = {
+	.start = s_start,
+	.next = s_next,
+	.show = t_show,
+	.stop = t_stop,
+};
+
+static const struct file_operations ftrace_avail_fops = {
+	.open = ftrace_event_seq_open,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = seq_release,
+};
+
+static const struct file_operations ftrace_set_event_fops = {
+	.open = ftrace_event_seq_open,
+	.read = seq_read,
+	.write = ftrace_event_write,
+	.llseek = seq_lseek,
+	.release = seq_release,
+};
+
+static __init int event_trace_init(void)
+{
+	struct dentry *d_tracer;
+	struct dentry *entry;
+
+	d_tracer = tracing_init_dentry();
+	if (!d_tracer)
+		return 0;
+
+	entry = debugfs_create_file("available_events", 0444, d_tracer,
+				    (void *)&show_event_seq_ops,
+				    &ftrace_avail_fops);
+	if (!entry)
+		pr_warning("Could not create debugfs "
+			   "'available_events' entry\n");
+
+	entry = debugfs_create_file("set_event", 0644, d_tracer,
+				    (void *)&show_set_event_seq_ops,
+				    &ftrace_set_event_fops);
+	if (!entry)
+		pr_warning("Could not create debugfs "
+			   "'set_event' entry\n");
+
+	return 0;
+}
+fs_initcall(event_trace_init);
diff --git a/kernel/trace/trace_events.h b/kernel/trace/trace_events.h
new file mode 100644
index 0000000..aa82057
--- /dev/null
+++ b/kernel/trace/trace_events.h
@@ -0,0 +1,49 @@
+#ifndef _LINUX_KERNEL_TRACE_EVENTS_H
+#define _LINUX_KERNEL_TRACE_EVENTS_H
+
+#include <linux/ftrace.h>
+#include "trace.h"
+
+struct ftrace_event_call {
+	char		*name;
+	int		enabled;
+	int		(*regfunc)(void);
+	void		(*unregfunc)(void);
+};
+
+
+#undef DECLARE_TRACE_FMT
+#define DECLARE_TRACE_FMT(call, proto, args, fmt, fmt_args)		\
+static void ftrace_event_##call(proto)					\
+{									\
+	event_trace_printk(_RET_IP_, "(%s) " fmt "\n", #call, fmt_args); \
+}									\
+									\
+static int ftrace_reg_event_##call(void)				\
+{									\
+	int ret;							\
+									\
+	ret = register_trace_##call(ftrace_event_##call);		\
+	if (!ret)							\
+		pr_info("event trace: Could not activate trace point "	\
+			"probe to " #call);				\
+	return ret;							\
+}									\
+									\
+static void ftrace_unreg_event_##call(void)				\
+{									\
+	unregister_trace_##call(ftrace_event_##call);			\
+}									\
+									\
+static struct ftrace_event_call __used					\
+__attribute__((section("_ftrace_events"))) event_##call = {		\
+	.name 			= #call,				\
+	.regfunc		= ftrace_reg_event_##call,		\
+	.unregfunc		= ftrace_unreg_event_##call,		\
+}
+
+void event_trace_printk(unsigned long ip, const char *fmt, ...);
+extern unsigned long __start_ftrace_events[];
+extern unsigned long __stop_ftrace_events[];
+
+#endif /* _LINUX_KERNEL_TRACE_EVENTS_H */
-- 
1.5.6.5

-- 
