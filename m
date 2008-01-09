Return-Path: <linux-kernel-owner+w=401wt.eu-S1758270AbYAIXgs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758270AbYAIXgs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 18:36:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757205AbYAIXbN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 18:31:13 -0500
Received: from ms-smtp-04.nyroc.rr.com ([24.24.2.58]:37819 "EHLO
	ms-smtp-04.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754815AbYAIXay (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 18:30:54 -0500
Message-Id: <20080109233043.497620597@goodmis.org>
References: <20080109232914.676624725@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 09 Jan 2008 18:29:22 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Thomas Gleixner <tglx@linutronix.de>, Tim Bird <tim.bird@am.sony.com>,
       Sam Ravnborg <sam@ravnborg.org>, "Frank Ch. Eigler" <fche@redhat.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [RFC PATCH 08/22 -v2] mcount tracer output file
Content-Disposition: inline; filename=mcount-tracer-debugfs-show.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add /debugfs/tracing/trace to output trace output.

Here's an example of the content.

  CPU 0:  [<ffffffff80494691>] notifier_call_chain+0x16/0x60 <-- [<ffffffff80494701>] __atomic_notifier_call_chain+0x26/0x56
  CPU 0:  [<ffffffff802161c8>] mce_idle_callback+0x9/0x2f <-- [<ffffffff804946b3>] notifier_call_chain+0x38/0x60
  CPU 0:  [<ffffffff8037fb7a>] acpi_processor_idle+0x16/0x518 <-- [<ffffffff8020aee8>] cpu_idle+0xa1/0xe7
  CPU 0:  [<ffffffff8037fa98>] acpi_safe_halt+0x9/0x43 <-- [<ffffffff8037fd3a>] acpi_processor_idle+0x1d6/0x518
  CPU 1:  [<ffffffff80221db8>] smp_apic_timer_interrupt+0xc/0x58 <-- [<ffffffff8020cf06>] apic_timer_interrupt+0x66/0x70
  CPU 1:  [<ffffffff8020ac22>] exit_idle+0x9/0x22 <-- [<ffffffff80221de1>] smp_apic_timer_interrupt+0x35/0x58
  CPU 1:  [<ffffffff8020ab97>] __exit_idle+0x9/0x2e <-- [<ffffffff8020ac39>] exit_idle+0x20/0x22
  CPU 1:  [<ffffffff8049473a>] atomic_notifier_call_chain+0x9/0x16 <-- [<ffffffff8020abba>] __exit_idle+0x2c/0x2e
  CPU 1:  [<ffffffff804946e9>] __atomic_notifier_call_chain+0xe/0x56 <-- [<ffffffff80494745>] atomic_notifier_call_chain+0x14/0x16
  CPU 1:  [<ffffffff80494691>] notifier_call_chain+0x16/0x60 <-- [<ffffffff80494701>] __atomic_notifier_call_chain+0x26/0x56
  CPU 1:  [<ffffffff802161c8>] mce_idle_callback+0x9/0x2f <-- [<ffffffff804946b3>] notifier_call_chain+0x38/0x60

This is in the format of the output when KALLSYMS is defined.

  CPU <CPU#>: [<IP>] <func> <-- [<Parent-IP>] <parent-func>

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 lib/tracing/tracer.c |  206 +++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 206 insertions(+)

Index: linux-compile-i386.git/lib/tracing/tracer.c
===================================================================
--- linux-compile-i386.git.orig/lib/tracing/tracer.c	2008-01-09 14:11:59.000000000 -0500
+++ linux-compile-i386.git/lib/tracing/tracer.c	2008-01-09 15:17:41.000000000 -0500
@@ -13,9 +13,11 @@
 #include <linux/fs.h>
 #include <linux/gfp.h>
 #include <linux/init.h>
+#include <linux/module.h>
 #include <linux/linkage.h>
 #include <linux/seq_file.h>
 #include <linux/debugfs.h>
+#include <linux/kallsyms.h>
 #include <linux/uaccess.h>
 #include <linux/mcount.h>
 
@@ -74,6 +76,205 @@ static notrace void trace_function(const
 }
 
 #ifdef CONFIG_DEBUG_FS
+struct mctracer_iterator {
+	struct mctracer_trace *tr;
+	struct mctracer_entry *ent;
+	unsigned long next_idx[NR_CPUS];
+	int cpu;
+	int idx;
+};
+
+static struct mctracer_entry *mctracer_entry_idx(struct mctracer_trace *tr,
+						 unsigned long idx,
+						 int cpu)
+{
+	struct mctracer_entry *array = tr->trace[cpu];
+	unsigned long underrun;
+
+	if (idx >= tr->entries)
+		return NULL;
+
+	underrun = atomic_read(&tr->underrun[cpu]);
+	if (underrun)
+		idx = ((underrun - 1) + idx) % tr->entries;
+	else if (idx >= tr->trace_idx[cpu])
+		return NULL;
+
+	return &array[idx];
+}
+
+static void *find_next_entry(struct mctracer_iterator *iter)
+{
+	struct mctracer_trace *tr = iter->tr;
+	struct mctracer_entry *ent;
+	struct mctracer_entry *next = NULL;
+	int next_i = -1;
+	int i;
+
+	for_each_possible_cpu(i) {
+		if (!tr->trace[i])
+			continue;
+		ent = mctracer_entry_idx(tr, iter->next_idx[i], i);
+		if (ent && (!next || next->idx > ent->idx)) {
+			next = ent;
+			next_i = i;
+		}
+	}
+	if (next) {
+		iter->next_idx[next_i]++;
+		iter->idx++;
+	}
+	iter->ent = next;
+	iter->cpu = next_i;
+
+	return next ? iter : NULL;
+}
+
+static void *s_next(struct seq_file *m, void *v, loff_t *pos)
+{
+	struct mctracer_iterator *iter = m->private;
+	void *ent;
+	int i = (int)*pos;
+
+	(*pos)++;
+
+	/* can't go backwards */
+	if (iter->idx > i)
+		return NULL;
+
+	if (iter->idx < 0)
+		ent = find_next_entry(iter);
+	else
+		ent = iter;
+
+	while (ent && iter->idx < i)
+		ent = find_next_entry(iter);
+
+	return ent;
+}
+
+static void *s_start(struct seq_file *m, loff_t *pos)
+{
+	struct mctracer_iterator *iter = m->private;
+	void *p = NULL;
+	loff_t l = 0;
+	int i;
+
+	iter->ent = NULL;
+	iter->cpu = 0;
+	iter->idx = -1;
+
+	for (i = 0; i < NR_CPUS; i++)
+		iter->next_idx[i] = 0;
+
+	/* stop the trace while dumping */
+	if (iter->tr->ctrl)
+		clear_mcount_function();
+
+	for (p = iter; p && l < *pos; p = s_next(m, p, &l))
+		;
+
+	return p;
+}
+
+static void s_stop(struct seq_file *m, void *p)
+{
+	struct mctracer_iterator *iter = m->private;
+	if (iter->tr->ctrl)
+		register_mcount_function(trace_function);
+}
+
+#ifdef CONFIG_KALLSYMS
+static void seq_print_symbol(struct seq_file *m,
+			     const char *fmt, unsigned long address)
+{
+	char buffer[KSYM_SYMBOL_LEN];
+
+	sprint_symbol(buffer, address);
+	seq_printf(m, fmt, buffer);
+}
+#else
+# define seq_print_symbol(m, fmt, address) do { } while (0)
+#endif
+
+#ifndef CONFIG_64BIT
+# define IP_FMT "%08lx"
+#else
+# define IP_FMT "%016lx"
+#endif
+
+static void notrace seq_print_ip_sym(struct seq_file *m,
+				     unsigned long ip)
+{
+	seq_print_symbol(m, "%s", ip);
+	seq_printf(m, " <" IP_FMT ">", ip);
+}
+
+static int s_show(struct seq_file *m, void *v)
+{
+	struct mctracer_iterator *iter = v;
+
+	if (iter->ent == NULL) {
+		seq_printf(m, "mctracer:\n");
+	} else {
+		seq_printf(m, "  CPU %d:  ", iter->cpu);
+		seq_print_ip_sym(m, iter->ent->ip);
+		if (iter->ent->parent_ip) {
+			seq_printf(m, " <-- ");
+			seq_print_ip_sym(m, iter->ent->parent_ip);
+		}
+		seq_printf(m, "\n");
+	}
+
+	return 0;
+}
+
+static struct seq_operations mctrace_seq_ops = {
+	.start = s_start,
+	.next = s_next,
+	.stop = s_stop,
+	.show = s_show,
+};
+
+static int mctrace_open(struct inode *inode, struct file *file)
+{
+	struct mctracer_iterator *iter;
+	int ret;
+
+	iter = kzalloc(sizeof(*iter), GFP_KERNEL);
+	if (!iter)
+		return -ENOMEM;
+
+	iter->tr = &mctracer_trace;
+
+	/* TODO stop tracer */
+	ret = seq_open(file, &mctrace_seq_ops);
+	if (!ret) {
+		struct seq_file *m = file->private_data;
+		m->private = iter;
+	} else
+		kfree(iter);
+
+	return ret;
+}
+
+int mctrace_release(struct inode *inode, struct file *file)
+{
+	struct seq_file *m = (struct seq_file *)file->private_data;
+	struct mctracer_iterator *iter = m->private;
+
+	seq_release(inode, file);
+	kfree(iter);
+	return 0;
+}
+
+static struct file_operations mctrace_fops = {
+	.open = mctrace_open,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = mctrace_release,
+};
+
 static int mctracer_open_generic(struct inode *inode, struct file *filp)
 {
 	filp->private_data = inode->i_private;
@@ -145,6 +346,11 @@ static void mctrace_init_debugfs(void)
 				    &mctracer_trace, &mctracer_ctrl_fops);
 	if (!entry)
 		pr_warning("Could not create debugfs 'ctrl' entry\n");
+
+	entry = debugfs_create_file("trace", 0444, d_mctracer,
+				    &mctracer_trace, &mctrace_fops);
+	if (!entry)
+		pr_warning("Could not create debugfs 'trace' entry\n");
 }
 #else /* CONFIG_DEBUG_FS */
 static void mctrace_init_debugfs(void)

-- 
