Return-Path: <linux-kernel-owner+w=401wt.eu-S1759397AbYGaChB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759397AbYGaChB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 22:37:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754219AbYGaCgu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 22:36:50 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:51026 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753377AbYGaCgt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 22:36:49 -0400
Date: Wed, 30 Jul 2008 22:36:46 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: LKML <linux-kernel@vger.kernel.org>
cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH v2] ftrace: dump out ftrace buffers to console on panic
Message-ID: <alpine.DEB.1.10.0807302227320.20785@gandalf.stny.rr.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[
 Changes since -v1:
  Got alpine to send correctly (as well as spell check working).
  Removed config option.
  Moved the static variables into ftrace_dump itself.
  Gave printk a log level.
]

At OLS I had a lot of interest to be able to have the ftrace buffers
dumped on panic.  Usually one would expect to uses kexec and examine
the buffers after a new kernel is loaded. But sometimes the resources
do not permit kdump and kexec, so having an option to still see the 
sequence of events up to the crash is very advantageous.

This patch adds the option to have the ftrace buffers dumped to the 
console in the latency_trace format on a panic. When the option is set, 
the default entries per CPU buffer are lowered to 16384, since the writing 
to the serial (if that is the console) may take an awful long time 
otherwise.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 include/linux/ftrace.h |    2 
 kernel/trace/trace.c   |  175 ++++++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 176 insertions(+), 1 deletion(-)

Index: linux-tip.git/kernel/trace/trace.c
===================================================================
--- linux-tip.git.orig/kernel/trace/trace.c	2008-07-29 10:47:53.000000000 -0400
+++ linux-tip.git/kernel/trace/trace.c	2008-07-30 22:25:25.000000000 -0400
@@ -14,6 +14,7 @@
 #include <linux/utsrelease.h>
 #include <linux/kallsyms.h>
 #include <linux/seq_file.h>
+#include <linux/notifier.h>
 #include <linux/debugfs.h>
 #include <linux/pagemap.h>
 #include <linux/hardirq.h>
@@ -22,6 +23,7 @@
 #include <linux/ftrace.h>
 #include <linux/module.h>
 #include <linux/percpu.h>
+#include <linux/kdebug.h>
 #include <linux/ctype.h>
 #include <linux/init.h>
 #include <linux/poll.h>
@@ -103,8 +105,15 @@ int				ftrace_function_enabled;
  * trace_nr_entries is the number of entries that is allocated
  * for a buffer. Note, the number of entries is always rounded
  * to ENTRIES_PER_PAGE.
+ *
+ * This number is purposely set to a low number of 16384.
+ * If the dump on oops happens, it will be much appreciated
+ * to not have to wait for all that output. Anyway this can be
+ * boot time and run time configurable.
  */
-static unsigned long		trace_nr_entries = 65536UL;
+#define TRACE_ENTRIES_DEFAULT	16384UL
+
+static unsigned long		trace_nr_entries = TRACE_ENTRIES_DEFAULT;
 
 /* trace_types holds a link list of available tracers. */
 static struct tracer		*trace_types __read_mostly;
@@ -2930,6 +2939,165 @@ static __init void tracer_init_debugfs(v
 #endif
 }
 
+static int trace_panic_handler(struct notifier_block *this,
+			       unsigned long event, void *unused)
+{
+	ftrace_dump();
+	return NOTIFY_OK;
+}
+
+static struct notifier_block trace_panic_notifier = {
+	.notifier_call  = trace_panic_handler,
+	.next           = NULL,
+	.priority       = 150   /* priority: INT_MAX >= x >= 0 */
+};
+
+static int trace_die_handler(struct notifier_block *self,
+			     unsigned long val,
+			     void *data)
+{
+	switch (val) {
+	case DIE_OOPS:
+		ftrace_dump();
+		break;
+	default:
+		break;
+	}
+	return NOTIFY_OK;
+}
+
+static struct notifier_block trace_die_notifier = {
+	.notifier_call = trace_die_handler,
+	.priority = 200
+};
+
+/*
+ * printk is set to max of 1024, we really don't need it that big.
+ * Nothing should be printing 1000 characters anyway.
+ */
+#define TRACE_MAX_PRINT		1000
+
+/*
+ * Define here KERN_TRACE so that we have one place to modify
+ * it if we decide to change what log level the ftrace dump
+ * should be at.
+ */
+#define KERN_TRACE		KERN_INFO
+
+static void
+trace_printk_seq(struct trace_seq *s)
+{
+	/* Probably should print a warning here. */
+	if (s->len >= 1000)
+		s->len = 1000;
+
+	/* should be zero ended, but we are paranoid. */
+	s->buffer[s->len] = 0;
+
+	printk(KERN_TRACE "%s", s->buffer);
+
+	trace_seq_reset(s);
+}
+
+
+void ftrace_dump(void)
+{
+	static DEFINE_SPINLOCK(ftrace_dump_lock);
+	/* use static because iter can be a bit big for the stack */
+	static struct trace_iterator iter;
+	struct trace_array_cpu *data;
+	static cpumask_t mask;
+	static int dump_ran;
+	unsigned long flags;
+	int cnt = 0;
+	int cpu;
+
+	/* only one dump */
+	spin_lock_irqsave(&ftrace_dump_lock, flags);
+	if (dump_ran)
+		goto out;
+
+	dump_ran = 1;
+
+	/* No turning back! */
+	ftrace_kill_atomic();
+
+	printk(KERN_TRACE "Dumping ftrace buffer:\n");
+
+	iter.tr = &global_trace;
+	iter.trace = current_trace;
+
+	/*
+	 * We need to stop all tracing on all CPUS to read the
+	 * the next buffer. This is a bit expensive, but is
+	 * not done often. We fill all what we can read,
+	 * and then release the locks again.
+	 */
+
+	cpus_clear(mask);
+
+	for_each_tracing_cpu(cpu) {
+		data = iter.tr->data[cpu];
+
+		if (!head_page(data) || !data->trace_idx)
+			continue;
+
+		atomic_inc(&data->disabled);
+		cpu_set(cpu, mask);
+	}
+
+	for_each_cpu_mask(cpu, mask) {
+		data = iter.tr->data[cpu];
+		__raw_spin_lock(&data->lock);
+
+		if (data->overrun > iter.last_overrun[cpu])
+			iter.overrun[cpu] +=
+				data->overrun - iter.last_overrun[cpu];
+		iter.last_overrun[cpu] = data->overrun;
+	}
+
+	while (!trace_empty(&iter)) {
+
+		if (!cnt)
+			printk(KERN_TRACE "---------------------------------\n");
+
+		cnt++;
+
+		/* reset all but tr, trace, and overruns */
+		memset(&iter.seq, 0,
+		       sizeof(struct trace_iterator) -
+		       offsetof(struct trace_iterator, seq));
+		iter.iter_flags |= TRACE_FILE_LAT_FMT;
+		iter.pos = -1;
+
+		if (find_next_entry_inc(&iter) != NULL) {
+			print_trace_line(&iter);
+			trace_consume(&iter);
+		}
+
+		trace_printk_seq(&iter.seq);
+	}
+
+	if (!cnt)
+		printk(KERN_TRACE "   (ftrace buffer empty)\n");
+	else
+		printk(KERN_TRACE "---------------------------------\n");
+
+	for_each_cpu_mask(cpu, mask) {
+		data = iter.tr->data[cpu];
+		__raw_spin_unlock(&data->lock);
+	}
+
+	for_each_cpu_mask(cpu, mask) {
+		data = iter.tr->data[cpu];
+		atomic_dec(&data->disabled);
+	}
+
+
+ out:
+	spin_unlock_irqrestore(&ftrace_dump_lock, flags);
+}
+
 static int trace_alloc_page(void)
 {
 	struct trace_array_cpu *data;
@@ -3126,6 +3294,11 @@ __init static int tracer_alloc_buffers(v
 	global_trace.ctrl = tracer_enabled;
 	tracing_disabled = 0;
 
+	atomic_notifier_chain_register(&panic_notifier_list,
+				       &trace_panic_notifier);
+
+	register_die_notifier(&trace_die_notifier);
+
 	return 0;
 
  free_buffers:
Index: linux-tip.git/include/linux/ftrace.h
===================================================================
--- linux-tip.git.orig/include/linux/ftrace.h	2008-07-14 10:42:44.000000000 -0400
+++ linux-tip.git/include/linux/ftrace.h	2008-07-30 20:41:13.000000000 -0400
@@ -136,9 +136,11 @@ static inline void tracer_disable(void)
 #ifdef CONFIG_TRACING
 extern void
 ftrace_special(unsigned long arg1, unsigned long arg2, unsigned long arg3);
+extern void ftrace_dump(void);
 #else
 static inline void
 ftrace_special(unsigned long arg1, unsigned long arg2, unsigned long arg3) { }
+static inline void ftrace_dump(void) { }
 #endif
 
 #endif /* _LINUX_FTRACE_H */
