Return-Path: <linux-kernel-owner+w=401wt.eu-S1757417AbYACH2J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757417AbYACH2J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 02:28:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754111AbYACHYw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 02:24:52 -0500
Received: from ms-smtp-01.nyroc.rr.com ([24.24.2.55]:57545 "EHLO
	ms-smtp-01.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754821AbYACHYW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 02:24:22 -0500
Message-Id: <20080103072228.372074690@goodmis.org>
References: <20080103071609.478486470@goodmis.org>
User-Agent: quilt/0.46-1
Date: Thu, 03 Jan 2008 02:16:20 -0500
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
       "William L. Irwin" <sparclinux@vger.kernel.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [RFC PATCH 11/11] Add a symbol only trace output
Content-Disposition: inline; filename=mcount-tracer-symbol-only.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The trace output is very verbose with outputing both the
IP address (Instruction Pointer not Internet Protocol!)
and the kallsyms symbol. So if kallsyms is configured into
the kernel, another file is created in the debugfs system.
This is the trace_symonly file that leaves out the IP address.

Here's an example:

CPU 1: swapper:0 smp_apic_timer_interrupt+0xc/0x58 <-- apic_timer_interrupt+0x66/0x70
CPU 1: swapper:0 exit_idle+0x9/0x22 <-- smp_apic_timer_interrupt+0x35/0x58
CPU 0: sshd:2611 _spin_unlock+0x9/0x38 <-- __qdisc_run+0xb2/0x1a1
CPU 1: swapper:0 __exit_idle+0x9/0x2e <-- exit_idle+0x20/0x22
CPU 0: sshd:2611 _spin_lock+0xe/0x7a <-- __qdisc_run+0xba/0x1a1
CPU 1: swapper:0 atomic_notifier_call_chain+0x9/0x16 <-- __exit_idle+0x2c/0x2e
CPU 1: swapper:0 __atomic_notifier_call_chain+0xe/0x56 <-- atomic_notifier_call_chain+0x14/0x16


Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 lib/mcount/tracer.c |  161 ++++++++++++++++++++++++++++++++++------------------
 1 file changed, 106 insertions(+), 55 deletions(-)

Index: linux-compile.git/lib/mcount/tracer.c
===================================================================
--- linux-compile.git.orig/lib/mcount/tracer.c	2008-01-03 00:29:31.000000000 -0500
+++ linux-compile.git/lib/mcount/tracer.c	2008-01-03 00:37:40.000000000 -0500
@@ -85,6 +85,7 @@ struct mctracer_iterator {
 	unsigned long next_idx[NR_CPUS];
 	int cpu;
 	int idx;
+	int sym_only;
 };
 
 static struct mctracer_entry *mctracer_entry_idx(struct mctracer_trace *tr,
@@ -156,7 +157,7 @@ static void *s_next(struct seq_file *m, 
 	return ent;
 }
 
-static void *s_start(struct seq_file *m, loff_t *pos)
+static void *__s_start(struct seq_file *m, loff_t *pos, int sym_only)
 {
 	struct mctracer_iterator *iter = m->private;
 	void *p = NULL;
@@ -166,6 +167,8 @@ static void *s_start(struct seq_file *m,
 	iter->ent = NULL;
 	iter->cpu = 0;
 	iter->idx = -1;
+	iter->sym_only = sym_only;
+
 	for (i = 0; i < NR_CPUS; i++)
 		iter->next_idx[i] = 0;
 
@@ -179,6 +182,11 @@ static void *s_start(struct seq_file *m,
 	return p;
 }
 
+static void *s_start(struct seq_file *m, loff_t *pos)
+{
+	return __s_start(m, pos, 0);
+}
+
 static void s_stop(struct seq_file *m, void *p)
 {
 	struct mctracer_iterator *iter = m->private;
@@ -186,58 +194,7 @@ static void s_stop(struct seq_file *m, v
 		register_mcount_function(trace_function);
 }
 
-#ifdef CONFIG_KALLSYMS
-static void seq_print_symbol(struct seq_file *m,
-			     const char *fmt, unsigned long address)
-{
-	char buffer[KSYM_SYMBOL_LEN];
-
-	sprint_symbol(buffer, address);
-	seq_printf(m, fmt, buffer);
-}
-#else
-# define seq_print_symbol(m, fmt, address) do { } while (0)
-#endif
-
-#ifndef CONFIG_64BIT
-#define seq_print_ip_sym(m, ip)			\
-do {						\
-	seq_printf(m, "[<%08lx>]", ip);		\
-	seq_print_symbol(m, " %s", ip);	\
-} while (0)
-#else
-#define seq_print_ip_sym(m, ip)			\
-do {						\
-	seq_printf(m, "[<%016lx>]", ip);	\
-	seq_print_symbol(m, " %s", ip);	\
-} while (0)
-#endif
-
-static int s_show(struct seq_file *m, void *v)
-{
-	int i = (long)(v);
-	struct mctracer_iterator *iter = v;
-
-	if (i == 1) {
-		seq_printf(m, "mctracer:\n");
-	} else {
-		if (!iter->ent) {
-			seq_printf(m, " ERROR!!!! ent is NULL!\n");
-			return -1;
-		}
-
-		seq_printf(m, "CPU %d: ", iter->cpu);
-		seq_printf(m, "%s:%d ", iter->ent->comm, iter->ent->pid);
-		seq_print_ip_sym(m, iter->ent->ip);
-		if (iter->ent->parent_ip) {
-			seq_printf(m, " <-- ");
-			seq_print_ip_sym(m, iter->ent->parent_ip);
-		}
-		seq_printf(m, "\n");
-	}
-
-	return 0;
-}
+static int s_show(struct seq_file *m, void *v);
 
 static struct seq_operations mctrace_seq_ops = {
 	.start = s_start,
@@ -246,7 +203,8 @@ static struct seq_operations mctrace_seq
 	.show = s_show,
 };
 
-static int mctrace_open (struct inode *inode, struct file *file)
+static int __mctrace_open(struct inode *inode, struct file *file,
+			  struct seq_operations *seq_ops)
 {
 	struct mctracer_iterator *iter;
 	int ret;
@@ -258,7 +216,7 @@ static int mctrace_open (struct inode *i
 	iter->tr = &mctracer_trace;
 
 	/* TODO stop tracer */
-	ret = seq_open(file, &mctrace_seq_ops);
+	ret = seq_open(file, seq_ops);
 	if (!ret) {
 		struct seq_file *m = file->private_data;
 		m->private = iter;
@@ -268,6 +226,11 @@ static int mctrace_open (struct inode *i
 	return ret;
 }
 
+static int mctrace_open(struct inode *inode, struct file *file)
+{
+	return __mctrace_open(inode, file, &mctrace_seq_ops);
+}
+
 int mctrace_release(struct inode *inode, struct file *file)
 {
 	struct seq_file *m = (struct seq_file *)file->private_data;
@@ -278,6 +241,87 @@ int mctrace_release(struct inode *inode,
 	return 0;
 }
 
+#ifndef CONFIG_64BIT
+#define seq_print_ip_sym(m, ip, sym_only)		\
+do {							\
+	if (!sym_only)					\
+		seq_printf(m, "[<%08lx>] ", ip);	\
+	seq_print_symbol(m, "%s", ip);			\
+} while (0)
+#else
+#define seq_print_ip_sym(m, ip, sym_only)		\
+do {							\
+	if (!sym_only)					\
+		seq_printf(m, "[<%016lx>] ", ip);	\
+	seq_print_symbol(m, "%s", ip);			\
+} while (0)
+#endif
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
+
+static void *s_start_sym_only(struct seq_file *m, loff_t *pos)
+{
+	return __s_start(m, pos, 1);
+}
+
+static struct seq_operations mctrace_sym_only_seq_ops = {
+	.start = s_start_sym_only,
+	.next = s_next,
+	.stop = s_stop,
+	.show = s_show,
+};
+
+static int mctrace_open_sym_only(struct inode *inode, struct file *file)
+{
+	return __mctrace_open(inode, file, &mctrace_sym_only_seq_ops);
+}
+
+static struct file_operations mctrace_sym_only_fops = {
+	.open = mctrace_open_sym_only,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = mctrace_release,
+};
+
+#else
+# define seq_print_symbol(m, fmt, address) do { } while (0)
+#endif
+
+static int s_show(struct seq_file *m, void *v)
+{
+	int i = (long)(v);
+	struct mctracer_iterator *iter = v;
+
+	if (i == 1) {
+		seq_printf(m, "mctracer:\n");
+	} else {
+		if (!iter->ent) {
+			seq_printf(m, " ERROR!!!! ent is NULL!\n");
+			return -1;
+		}
+
+		seq_printf(m, "CPU %d: ", iter->cpu);
+		seq_printf(m, "%s:%d ", iter->ent->comm, iter->ent->pid);
+		seq_print_ip_sym(m, iter->ent->ip, iter->sym_only);
+		if (iter->ent->parent_ip) {
+			seq_printf(m, " <-- ");
+			seq_print_ip_sym(m, iter->ent->parent_ip,
+					 iter->sym_only);
+		}
+		seq_printf(m, "\n");
+	}
+
+	return 0;
+}
+
 static struct file_operations mctrace_fops = {
 	.open = mctrace_open,
 	.read = seq_read,
@@ -361,6 +405,13 @@ static void mctrace_init_debugfs(void)
 				    &mctracer_trace, &mctrace_fops);
 	if (!entry)
 		pr_warning("Could not create debugfs 'trace' entry\n");
+
+#ifdef CONFIG_KALLSYMS
+	entry = debugfs_create_file("trace_symonly", 0444, d_mctracer,
+				    &mctracer_trace, &mctrace_sym_only_fops);
+	if (!entry)
+		pr_warning("Could not create debugfs 'trace_symonly' entry\n");
+#endif
 }
 #else /* CONFIG_DEBUG_FS */
 static void mctrace_init_debugfs(void)

-- 
