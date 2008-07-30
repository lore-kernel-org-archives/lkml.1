Return-Path: <linux-kernel-owner+w=401wt.eu-S1759527AbYG3VNl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759527AbYG3VNl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 17:13:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756239AbYG3VN2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 17:13:28 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:50453 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753950AbYG3VN1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 17:13:27 -0400
Date: Wed, 30 Jul 2008 17:13:24 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: LKML <linux-kernel@vger.kernel.org>
cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH] ftrace: dump out ftrace buffers to console on panic
Message-ID: <alpine.DEB.1.10.0807301700080.16138@gandalf.stny.rr.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


At OLS I had a lot of interest to be able to have the ftrace buffers
dumped on panic.  Usually one would expect to uses kexec and examine
the buffers after a new kernel is loaded. But sometimes the resources
do not permit kdump and kexec, so having an option to still see the 
sequence of events up to the crash is very advantageous.

This patch adds the option to have the ftrace buffers dumped to the 
console in the latency_trace format on a panic. When the option is set, 
the default entries per CPU buffer are lowered to 16384, since the writing 
to the serial (if that is the console) may take an aweful long time 
otherwise.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
  include/linux/ftrace.h |    6 +
  kernel/trace/Kconfig   |   10 ++
  kernel/trace/trace.c   |  179 ++++++++++++++++++++++++++++++++++++++++++++++++-
  3 files changed, 194 insertions(+), 1 deletion(-)

Index: linux-tip.git/kernel/trace/trace.c
===================================================================
--- linux-tip.git.orig/kernel/trace/trace.c	2008-07-29 10:47:53.000000000 -0400
+++ linux-tip.git/kernel/trace/trace.c	2008-07-30 16:46:15.000000000 -0400
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
@@ -104,7 +106,16 @@ int				ftrace_function_enabled;
   * for a buffer. Note, the number of entries is always rounded
   * to ENTRIES_PER_PAGE.
   */
-static unsigned long		trace_nr_entries = 65536UL;
+#ifdef CONFIG_FTRACE_DUMP_ON_OOPS
+/*
+ * If dump on oops is defined, lower the number of entries.
+ * Usually this goes over the serial, and is used for debugging.
+ */
+# define TRACE_ENTRIES_DEFAULT	16384UL
+#else
+# define TRACE_ENTRIES_DEFAULT	65536UL
+#endif
+static unsigned long		trace_nr_entries = TRACE_ENTRIES_DEFAULT;

  /* trace_types holds a link list of available tracers. */
  static struct tracer		*trace_types __read_mostly;
@@ -2930,6 +2941,166 @@ static __init void tracer_init_debugfs(v
  #endif
  }

+#ifdef CONFIG_FTRACE_DUMP_ON_OOPS
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
+static void
+trace_printk_seq(struct trace_seq *s)
+{
+	int len = s->len >= PAGE_SIZE ? PAGE_SIZE - 1 : s->len;
+
+	s->buffer[len] = 0;
+
+	printk("%s", s->buffer);
+
+	trace_seq_reset(s);
+}
+
+
+static struct trace_iterator dump_iter;
+static raw_spinlock_t ftrace_dump_lock =
+	(raw_spinlock_t)__RAW_SPIN_LOCK_UNLOCKED;
+static int dump_running;
+
+void ftrace_dump(void)
+{
+	struct trace_iterator *iter = &dump_iter;
+	struct trace_array_cpu *data;
+	static cpumask_t mask;
+	unsigned long flags;
+	int cpu, ret;
+	int cnt = 0;
+
+	local_irq_save(flags);
+
+	/* only one dump at a time */
+	__raw_spin_lock(&ftrace_dump_lock);
+	if (dump_running)
+		ret = 1;
+	else {
+		dump_running = 1;
+		ret = 0;
+	}
+	__raw_spin_unlock(&ftrace_dump_lock);
+
+	if (ret)
+		goto out;
+
+	/* No turning back! */
+	ftrace_kill_atomic();
+
+	printk("Dumping ftrace buffer:\n");
+
+	memset(iter, 0, sizeof(*iter));
+
+	iter->tr = &global_trace;
+	iter->trace = current_trace;
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
+		data = iter->tr->data[cpu];
+
+		if (!head_page(data) || !data->trace_idx)
+			continue;
+
+		atomic_inc(&data->disabled);
+		cpu_set(cpu, mask);
+	}
+
+	for_each_cpu_mask(cpu, mask) {
+		data = iter->tr->data[cpu];
+		__raw_spin_lock(&data->lock);
+
+		if (data->overrun > iter->last_overrun[cpu])
+			iter->overrun[cpu] +=
+				data->overrun - iter->last_overrun[cpu];
+		iter->last_overrun[cpu] = data->overrun;
+	}
+
+	while (!trace_empty(iter)) {
+
+		if (!cnt)
+			printk("---------------------------------\n");
+
+		cnt++;
+
+		/* reset all but tr, trace, and overruns */
+		memset(&iter->seq, 0,
+		       sizeof(struct trace_iterator) -
+		       offsetof(struct trace_iterator, seq));
+		iter->iter_flags |= TRACE_FILE_LAT_FMT;
+		iter->pos = -1;
+
+		if (find_next_entry_inc(iter) != NULL) {
+			print_trace_line(iter);
+			trace_consume(iter);
+		}
+
+		trace_printk_seq(&iter->seq);
+	}
+
+	if (!cnt)
+		printk("   (ftrace buffer empty)\n");
+	else
+		printk("---------------------------------\n");
+
+	for_each_cpu_mask(cpu, mask) {
+		data = iter->tr->data[cpu];
+		__raw_spin_unlock(&data->lock);
+	}
+
+	for_each_cpu_mask(cpu, mask) {
+		data = iter->tr->data[cpu];
+		atomic_dec(&data->disabled);
+	}
+
+	__raw_spin_lock(&ftrace_dump_lock);
+	dump_running = 0;
+	__raw_spin_unlock(&ftrace_dump_lock);
+
+ out:
+	local_irq_restore(flags);
+}
+#endif /* CONFIG_FTRACE_DUMP_ON_OOPS */
+
  static int trace_alloc_page(void)
  {
  	struct trace_array_cpu *data;
@@ -3126,6 +3297,12 @@ __init static int tracer_alloc_buffers(v
  	global_trace.ctrl = tracer_enabled;
  	tracing_disabled = 0;

+#ifdef CONFIG_FTRACE_DUMP_ON_OOPS
+	atomic_notifier_chain_register(&panic_notifier_list,
+				       &trace_panic_notifier);
+
+	register_die_notifier(&trace_die_notifier);
+#endif
  	return 0;

   free_buffers:
Index: linux-tip.git/include/linux/ftrace.h
===================================================================
--- linux-tip.git.orig/include/linux/ftrace.h	2008-07-14 10:42:44.000000000 -0400
+++ linux-tip.git/include/linux/ftrace.h	2008-07-30 13:33:48.000000000 -0400
@@ -141,4 +141,10 @@ static inline void
  ftrace_special(unsigned long arg1, unsigned long arg2, unsigned long arg3) { }
  #endif

+#ifdef CONFIG_FTRACE_DUMP_ON_OOPS
+extern void ftrace_dump(void);
+#else
+static inline void ftrace_dump(void) { }
+#endif
+
  #endif /* _LINUX_FTRACE_H */
Index: linux-tip.git/kernel/trace/Kconfig
===================================================================
--- linux-tip.git.orig/kernel/trace/Kconfig	2008-07-30 11:41:09.000000000 -0400
+++ linux-tip.git/kernel/trace/Kconfig	2008-07-30 17:05:22.000000000 -0400
@@ -151,3 +151,13 @@ config FTRACE_NMI_TESTER
  	        the tester is active.

  	  If unsure say N.
+
+config FTRACE_DUMP_ON_OOPS
+	bool "Dump ftrace buffers to console on OOPS"
+	depends on TRACING
+	help
+	  This option is useful for debugging were kdump can not be used.
+	  If the kernel crashes and panics, the ftrace buffer will be dumped out
+	  to the console in the latency_trace format.
+
+	  If unsure say N.
