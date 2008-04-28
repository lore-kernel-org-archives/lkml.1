Return-Path: <linux-kernel-owner+w=401wt.eu-S935943AbYD1S4F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935943AbYD1S4F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 14:56:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936005AbYD1Szt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 14:55:49 -0400
Received: from hu-out-0506.google.com ([72.14.214.231]:60868 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935764AbYD1Szq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 14:55:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer:mime-version:content-type:content-transfer-encoding:sender;
        b=iFqJYGo8kdrGI/Klesh2kw3zmxgvAmbXIQxak/eloE635vyTq7EdL91JiuSNU3mOsGgmhupl7inUIEgwmDD2nLAXc4iZmIOb8K5uPeZEIofbAnIP7G9l7eQLM9YHj50FB702ds2jW60V9t9BSPhhdDpRySmUNyJX6PB6T2ynbwc=
Date: Mon, 28 Apr 2008 21:55:34 +0300
From: Pekka Paalanen <pq@iki.fi>
To: linux-kernel@vger.kernel.org
Cc: Pekka Paalanen <pq@iki.fi>, Ingo Molnar <mingo@elte.hu>,
       Christoph Hellwig <hch@infradead.org>,
       Arjan van de Ven <arjan@infradead.org>, Pavel Roskin <proski@gnu.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [RFC 2/3] mmiotrace full patch, preview 3
Message-ID: <20080428215534.079c378e@daedalus.pq.iki.fi>
In-Reply-To: <20080428214504.5c359195@daedalus.pq.iki.fi>
References: <20080428214504.5c359195@daedalus.pq.iki.fi>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.8; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Apr 2008 21:45:04 +0300
Pekka Paalanen <pq@iki.fi> wrote:

> Hi all,
> 
> this is the third full mmiotrace patch set for review (a bit late, sorry).
> These patches do not apply to any git tree that I know of, but after Ingo
> pushes a new version of his sched-devel/latest tree, these patches should
> be subtractable from there.
...
> This first patch adds the bulk of the new code, only introducing new files.
> The second patch establishes the interfaces to the ftrace framework, and
> the third patch hooks everything up into the Kbuild system, page fault
> handler, and ioremap functions.

 kernel/trace/Makefile          |    1 +
 kernel/trace/trace.c           |   66 +++++++---
 kernel/trace/trace.h           |   29 ++++
 kernel/trace/trace_mmiotrace.c |  291 ++++++++++++++++++++++++++++++++++++++++
 4 files changed, 370 insertions(+), 17 deletions(-)

diff --git a/kernel/trace/Makefile b/kernel/trace/Makefile
index 7aec123..71d17de 100644
--- a/kernel/trace/Makefile
+++ b/kernel/trace/Makefile
@@ -19,5 +19,6 @@ obj-$(CONFIG_FTRACE) += trace_functions.o
 obj-$(CONFIG_IRQSOFF_TRACER) += trace_irqsoff.o
 obj-$(CONFIG_PREEMPT_TRACER) += trace_irqsoff.o
 obj-$(CONFIG_SCHED_TRACER) += trace_sched_wakeup.o
+obj-$(CONFIG_MMIOTRACE) += trace_mmiotrace.o
 
 libftrace-y := ftrace.o
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index cbe476f..06c85b3 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -54,7 +54,7 @@ static int tracing_disabled = 1;
 
 static unsigned long tracing_pages_allocated;
 
-static long
+long
 ns2usecs(cycle_t nsec)
 {
 	nsec += 500;
@@ -173,18 +173,6 @@ unsigned long nsecs_to_usecs(unsigned long nsecs)
 	return nsecs / 1000;
 }
 
-enum trace_type {
-	__TRACE_FIRST_TYPE = 0,
-
-	TRACE_FN,
-	TRACE_CTX,
-	TRACE_WAKE,
-	TRACE_STACK,
-	TRACE_SPECIAL,
-
-	__TRACE_LAST_TYPE
-};
-
 /*
  * trace_flag_type is an enumeration that holds different
  * states when a trace occurs. These are:
@@ -313,7 +301,7 @@ void *head_page(struct trace_array_cpu *data)
  * buffer (@s). Then the output may be either used by
  * the sequencer or pulled into another buffer.
  */
-static int
+int
 trace_seq_printf(struct trace_seq *s, const char *fmt, ...)
 {
 	int len = (PAGE_SIZE - 1) - s->len;
@@ -328,7 +316,7 @@ trace_seq_printf(struct trace_seq *s, const char *fmt, ...)
 	va_end(ap);
 
 	/* If we can't write it all, don't bother writing anything */
-	if (ret > len)
+	if (ret >= len)
 		return 0;
 
 	s->len += ret;
@@ -809,7 +797,7 @@ tracing_generic_entry_update(struct trace_entry *entry, unsigned long flags)
 	pc = preempt_count();
 
 	entry->preempt_count	= pc & 0xff;
-	entry->pid		= tsk->pid;
+	entry->pid		= (tsk) ? tsk->pid : 0;
 	entry->t		= ftrace_now(raw_smp_processor_id());
 	entry->flags = (irqs_disabled_flags(flags) ? TRACE_FLAG_IRQS_OFF : 0) |
 		((pc & HARDIRQ_MASK) ? TRACE_FLAG_HARDIRQ : 0) |
@@ -843,6 +831,48 @@ ftrace(struct trace_array *tr, struct trace_array_cpu *data,
 		trace_function(tr, data, ip, parent_ip, flags);
 }
 
+#ifdef CONFIG_MMIOTRACE
+void __trace_mmiotrace_rw(struct trace_array *tr, struct trace_array_cpu *data,
+						struct mmiotrace_rw *rw)
+{
+	struct trace_entry *entry;
+	unsigned long irq_flags;
+
+	raw_local_irq_save(irq_flags);
+	__raw_spin_lock(&data->lock);
+
+	entry			= tracing_get_trace_entry(tr, data);
+	tracing_generic_entry_update(entry, 0);
+	entry->type		= TRACE_MMIO_RW;
+	entry->mmiorw		= *rw;
+
+	__raw_spin_unlock(&data->lock);
+	raw_local_irq_restore(irq_flags);
+
+	trace_wake_up();
+}
+
+void __trace_mmiotrace_map(struct trace_array *tr, struct trace_array_cpu *data,
+						struct mmiotrace_map *map)
+{
+	struct trace_entry *entry;
+	unsigned long irq_flags;
+
+	raw_local_irq_save(irq_flags);
+	__raw_spin_lock(&data->lock);
+
+	entry			= tracing_get_trace_entry(tr, data);
+	tracing_generic_entry_update(entry, 0);
+	entry->type		= TRACE_MMIO_MAP;
+	entry->mmiomap		= *map;
+
+	__raw_spin_unlock(&data->lock);
+	raw_local_irq_restore(irq_flags);
+
+	trace_wake_up();
+}
+#endif
+
 void __trace_stack(struct trace_array *tr,
 		   struct trace_array_cpu *data,
 		   unsigned long flags,
@@ -1714,6 +1744,9 @@ static int trace_empty(struct trace_iterator *iter)
 
 static int print_trace_line(struct trace_iterator *iter)
 {
+	if (iter->trace && iter->trace->print_line)
+		return iter->trace->print_line(iter);
+
 	if (trace_flags & TRACE_ITER_BIN)
 		return print_bin_fmt(iter);
 
@@ -2342,7 +2375,6 @@ static int tracing_open_pipe(struct inode *inode, struct file *filp)
 
 	mutex_lock(&trace_types_lock);
 	iter->tr = &global_trace;
-
 	iter->trace = current_trace;
 	filp->private_data = iter;
 
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index f2ca481..3e15c23 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -5,6 +5,21 @@
 #include <asm/atomic.h>
 #include <linux/sched.h>
 #include <linux/clocksource.h>
+#include <linux/mmiotrace.h>
+
+enum trace_type {
+	__TRACE_FIRST_TYPE = 0,
+
+	TRACE_FN,
+	TRACE_CTX,
+	TRACE_WAKE,
+	TRACE_STACK,
+	TRACE_SPECIAL,
+	TRACE_MMIO_RW,
+	TRACE_MMIO_MAP,
+
+	__TRACE_LAST_TYPE
+};
 
 /*
  * Function trace entry - function address and parent function addres:
@@ -63,6 +78,8 @@ struct trace_entry {
 		struct ctx_switch_entry		ctx;
 		struct special_entry		special;
 		struct stack_entry		stack;
+		struct mmiotrace_rw		mmiorw;
+		struct mmiotrace_map		mmiomap;
 	};
 };
 
@@ -135,6 +152,7 @@ struct tracer {
 	int			(*selftest)(struct tracer *trace,
 					    struct trace_array *tr);
 #endif
+	int			(*print_line)(struct trace_iterator *iter);
 	struct tracer		*next;
 	int			print_max;
 };
@@ -244,6 +262,15 @@ extern unsigned long ftrace_update_tot_cnt;
 extern int DYN_FTRACE_TEST_NAME(void);
 #endif
 
+#ifdef CONFIG_MMIOTRACE
+extern void __trace_mmiotrace_rw(struct trace_array *tr,
+				struct trace_array_cpu *data,
+				struct mmiotrace_rw *rw);
+extern void __trace_mmiotrace_map(struct trace_array *tr,
+				struct trace_array_cpu *data,
+				struct mmiotrace_map *map);
+#endif
+
 #ifdef CONFIG_FTRACE_STARTUP_TEST
 #ifdef CONFIG_FTRACE
 extern int trace_selftest_startup_function(struct tracer *trace,
@@ -276,8 +303,10 @@ extern int trace_selftest_startup_sysprof(struct tracer *trace,
 #endif /* CONFIG_FTRACE_STARTUP_TEST */
 
 extern void *head_page(struct trace_array_cpu *data);
+extern int trace_seq_printf(struct trace_seq *s, const char *fmt, ...);
 extern ssize_t trace_seq_to_user(struct trace_seq *s, char __user *ubuf,
 				 size_t cnt);
+extern long ns2usecs(cycle_t nsec);
 
 extern unsigned long trace_flags;
 
diff --git a/kernel/trace/trace_mmiotrace.c b/kernel/trace/trace_mmiotrace.c
new file mode 100644
index 0000000..3c1dacd
--- /dev/null
+++ b/kernel/trace/trace_mmiotrace.c
@@ -0,0 +1,291 @@
+/*
+ * Memory mapped I/O tracing
+ *
+ * Copyright (C) 2008 Pekka Paalanen <pq@iki.fi>
+ */
+
+#define DEBUG 1
+
+#include <linux/kernel.h>
+#include <linux/mmiotrace.h>
+#include <linux/pci.h>
+
+#include "trace.h"
+
+struct header_iter {
+	struct pci_dev *dev;
+};
+
+static struct trace_array *mmio_trace_array;
+static bool overrun_detected;
+
+static void mmio_reset_data(struct trace_array *tr)
+{
+	int cpu;
+
+	overrun_detected = false;
+	tr->time_start = ftrace_now(tr->cpu);
+
+	for_each_online_cpu(cpu)
+		tracing_reset(tr->data[cpu]);
+}
+
+static void mmio_trace_init(struct trace_array *tr)
+{
+	pr_debug("in %s\n", __func__);
+	mmio_trace_array = tr;
+	if (tr->ctrl) {
+		mmio_reset_data(tr);
+		enable_mmiotrace();
+	}
+}
+
+static void mmio_trace_reset(struct trace_array *tr)
+{
+	pr_debug("in %s\n", __func__);
+	if (tr->ctrl)
+		disable_mmiotrace();
+	mmio_reset_data(tr);
+	mmio_trace_array = NULL;
+}
+
+static void mmio_trace_ctrl_update(struct trace_array *tr)
+{
+	pr_debug("in %s\n", __func__);
+	if (tr->ctrl) {
+		mmio_reset_data(tr);
+		enable_mmiotrace();
+	} else {
+		disable_mmiotrace();
+	}
+}
+
+static int mmio_print_pcidev(struct trace_seq *s, const struct pci_dev *dev)
+{
+	int ret = 0;
+	int i;
+	resource_size_t start, end;
+	const struct pci_driver *drv = pci_dev_driver(dev);
+
+	/* XXX: incomplete checks for trace_seq_printf() return value */
+	ret += trace_seq_printf(s, "PCIDEV %02x%02x %04x%04x %x",
+				dev->bus->number, dev->devfn,
+				dev->vendor, dev->device, dev->irq);
+	/*
+	 * XXX: is pci_resource_to_user() appropriate, since we are
+	 * supposed to interpret the __ioremap() phys_addr argument based on
+	 * these printed values?
+	 */
+	for (i = 0; i < 7; i++) {
+		pci_resource_to_user(dev, i, &dev->resource[i], &start, &end);
+		ret += trace_seq_printf(s, " %llx",
+			(unsigned long long)(start |
+			(dev->resource[i].flags & PCI_REGION_FLAG_MASK)));
+	}
+	for (i = 0; i < 7; i++) {
+		pci_resource_to_user(dev, i, &dev->resource[i], &start, &end);
+		ret += trace_seq_printf(s, " %llx",
+			dev->resource[i].start < dev->resource[i].end ?
+			(unsigned long long)(end - start) + 1 : 0);
+	}
+	if (drv)
+		ret += trace_seq_printf(s, " %s\n", drv->name);
+	else
+		ret += trace_seq_printf(s, " \n");
+	return ret;
+}
+
+static void destroy_header_iter(struct header_iter *hiter)
+{
+	if (!hiter)
+		return;
+	pci_dev_put(hiter->dev);
+	kfree(hiter);
+}
+
+static void mmio_pipe_open(struct trace_iterator *iter)
+{
+	struct header_iter *hiter;
+	struct trace_seq *s = &iter->seq;
+
+	trace_seq_printf(s, "VERSION 20070824\n");
+
+	hiter = kzalloc(sizeof(*hiter), GFP_KERNEL);
+	if (!hiter)
+		return;
+
+	hiter->dev = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, NULL);
+	iter->private = hiter;
+}
+
+/* XXX: This is not called when the pipe is closed! */
+static void mmio_close(struct trace_iterator *iter)
+{
+	struct header_iter *hiter = iter->private;
+	destroy_header_iter(hiter);
+	iter->private = NULL;
+}
+
+static unsigned long count_overruns(struct trace_iterator *iter)
+{
+	int cpu;
+	unsigned long cnt = 0;
+	for_each_online_cpu(cpu) {
+		cnt += iter->overrun[cpu];
+		iter->overrun[cpu] = 0;
+	}
+	return cnt;
+}
+
+static ssize_t mmio_read(struct trace_iterator *iter, struct file *filp,
+				char __user *ubuf, size_t cnt, loff_t *ppos)
+{
+	ssize_t ret;
+	struct header_iter *hiter = iter->private;
+	struct trace_seq *s = &iter->seq;
+	unsigned long n;
+
+	n = count_overruns(iter);
+	if (n) {
+		/* XXX: This is later than where events were lost. */
+		trace_seq_printf(s, "MARK 0.000000 Lost %lu events.\n", n);
+		if (!overrun_detected)
+			pr_warning("mmiotrace has lost events.\n");
+		overrun_detected = true;
+		goto print_out;
+	}
+
+	if (!hiter)
+		return 0;
+
+	mmio_print_pcidev(s, hiter->dev);
+	hiter->dev = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, hiter->dev);
+
+	if (!hiter->dev) {
+		destroy_header_iter(hiter);
+		iter->private = NULL;
+	}
+
+print_out:
+	ret = trace_seq_to_user(s, ubuf, cnt);
+	return (ret == -EBUSY) ? 0 : ret;
+}
+
+static int mmio_print_rw(struct trace_iterator *iter)
+{
+	struct trace_entry *entry = iter->ent;
+	struct mmiotrace_rw *rw	= &entry->mmiorw;
+	struct trace_seq *s	= &iter->seq;
+	unsigned long long t	= ns2usecs(entry->t);
+	unsigned long usec_rem	= do_div(t, 1000000ULL);
+	unsigned secs		= (unsigned long)t;
+	int ret = 1;
+
+	switch (entry->mmiorw.opcode) {
+	case MMIO_READ:
+		ret = trace_seq_printf(s,
+			"R %d %lu.%06lu %d 0x%lx 0x%lx 0x%lx %d\n",
+			rw->width, secs, usec_rem, rw->map_id, rw->phys,
+			rw->value, rw->pc, 0);
+		break;
+	case MMIO_WRITE:
+		ret = trace_seq_printf(s,
+			"W %d %lu.%06lu %d 0x%lx 0x%lx 0x%lx %d\n",
+			rw->width, secs, usec_rem, rw->map_id, rw->phys,
+			rw->value, rw->pc, 0);
+		break;
+	case MMIO_UNKNOWN_OP:
+		ret = trace_seq_printf(s,
+			"UNKNOWN %lu.%06lu %d 0x%lx %02x,%02x,%02x 0x%lx %d\n",
+			secs, usec_rem, rw->map_id, rw->phys,
+			(rw->value >> 16) & 0xff, (rw->value >> 8) & 0xff,
+			(rw->value >> 0) & 0xff, rw->pc, 0);
+		break;
+	default:
+		ret = trace_seq_printf(s, "rw what?\n");
+		break;
+	}
+	if (ret)
+		return 1;
+	return 0;
+}
+
+static int mmio_print_map(struct trace_iterator *iter)
+{
+	struct trace_entry *entry = iter->ent;
+	struct mmiotrace_map *m	= &entry->mmiomap;
+	struct trace_seq *s	= &iter->seq;
+	unsigned long long t	= ns2usecs(entry->t);
+	unsigned long usec_rem	= do_div(t, 1000000ULL);
+	unsigned secs		= (unsigned long)t;
+	int ret = 1;
+
+	switch (entry->mmiorw.opcode) {
+	case MMIO_PROBE:
+		ret = trace_seq_printf(s,
+			"MAP %lu.%06lu %d 0x%lx 0x%lx 0x%lx 0x%lx %d\n",
+			secs, usec_rem, m->map_id, m->phys, m->virt, m->len,
+			0UL, 0);
+		break;
+	case MMIO_UNPROBE:
+		ret = trace_seq_printf(s,
+			"UNMAP %lu.%06lu %d 0x%lx %d\n",
+			secs, usec_rem, m->map_id, 0UL, 0);
+		break;
+	default:
+		ret = trace_seq_printf(s, "map what?\n");
+		break;
+	}
+	if (ret)
+		return 1;
+	return 0;
+}
+
+/* return 0 to abort printing without consuming current entry in pipe mode */
+static int mmio_print_line(struct trace_iterator *iter)
+{
+	switch (iter->ent->type) {
+	case TRACE_MMIO_RW:
+		return mmio_print_rw(iter);
+	case TRACE_MMIO_MAP:
+		return mmio_print_map(iter);
+	default:
+		return 1; /* ignore unknown entries */
+	}
+}
+
+static struct tracer mmio_tracer __read_mostly =
+{
+	.name		= "mmiotrace",
+	.init		= mmio_trace_init,
+	.reset		= mmio_trace_reset,
+	.pipe_open	= mmio_pipe_open,
+	.close		= mmio_close,
+	.read		= mmio_read,
+	.ctrl_update	= mmio_trace_ctrl_update,
+	.print_line	= mmio_print_line,
+};
+
+__init static int init_mmio_trace(void)
+{
+	return register_tracer(&mmio_tracer);
+}
+device_initcall(init_mmio_trace);
+
+void mmio_trace_rw(struct mmiotrace_rw *rw)
+{
+	struct trace_array *tr = mmio_trace_array;
+	struct trace_array_cpu *data = tr->data[smp_processor_id()];
+	__trace_mmiotrace_rw(tr, data, rw);
+}
+
+void mmio_trace_mapping(struct mmiotrace_map *map)
+{
+	struct trace_array *tr = mmio_trace_array;
+	struct trace_array_cpu *data;
+
+	preempt_disable();
+	data = tr->data[smp_processor_id()];
+	__trace_mmiotrace_map(tr, data, map);
+	preempt_enable();
+}
