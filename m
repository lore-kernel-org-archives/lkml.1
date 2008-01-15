Return-Path: <linux-kernel-owner+w=401wt.eu-S1758572AbYAOU5Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758572AbYAOU5Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 15:57:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757431AbYAOUuy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 15:50:54 -0500
Received: from ms-smtp-03.nyroc.rr.com ([24.24.2.57]:51796 "EHLO
	ms-smtp-03.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755487AbYAOUug (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 15:50:36 -0500
Message-Id: <20080115205022.908509019@goodmis.org>
References: <20080115204907.838227723@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 15 Jan 2008 15:49:17 -0500
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
       Jan Kiszka <jan.kiszka@siemens.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [RFC PATCH 10/30 v3] Add a symbol only trace output
Content-Disposition: inline; filename=mcount-tracer-symbol-only.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The trace output is very verbose with outputing both the
IP address (Instruction Pointer not Internet Protocol!)
and the kallsyms symbol. So if kallsyms is configured into
the kernel, another file is created in the debugfs system.

A new file is added to the debugfs. iter_ctrl

 echo symonly > /debugfs/tracing/iter_ctrl

will turn off printing of instruction pointers.

 echo nosymonly > /debugfs/tracing/iter_ctrl

will turn them back on.

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
 lib/tracing/tracer.c |   65 +++++++++++++++++++++++++++++++++++++++++++++++----
 lib/tracing/tracer.h |    1 
 2 files changed, 62 insertions(+), 4 deletions(-)

Index: linux-compile.git/lib/tracing/tracer.c
===================================================================
--- linux-compile.git.orig/lib/tracing/tracer.c	2008-01-15 14:57:29.000000000 -0500
+++ linux-compile.git/lib/tracing/tracer.c	2008-01-15 14:57:36.000000000 -0500
@@ -89,6 +89,10 @@ static struct mcount_ops trace_ops __rea
 };
 
 #ifdef CONFIG_DEBUG_FS
+enum trace_iterator {
+	TRACE_ITER_SYM_ONLY	= 1,
+};
+
 struct mctracer_iterator {
 	struct mctracer_trace *tr;
 	struct mctracer_entry *ent;
@@ -217,25 +221,29 @@ static void seq_print_symbol(struct seq_
 #endif
 
 static void notrace seq_print_ip_sym(struct seq_file *m,
-				     unsigned long ip)
+				     unsigned long ip,
+				     int sym_only)
 {
 	seq_print_symbol(m, "%s", ip);
-	seq_printf(m, " <" IP_FMT ">", ip);
+	if (!sym_only)
+		seq_printf(m, " <" IP_FMT ">", ip);
 }
 
 static int s_show(struct seq_file *m, void *v)
 {
 	struct mctracer_iterator *iter = v;
+	int sym_only = !!(iter->tr->iter_flags & TRACE_ITER_SYM_ONLY);
 
 	if (iter->ent == NULL) {
 		seq_printf(m, "mctracer:\n");
 	} else {
 		seq_printf(m, "CPU %d: ", iter->cpu);
 		seq_printf(m, "%s:%d ", iter->ent->comm, iter->ent->pid);
-		seq_print_ip_sym(m, iter->ent->ip);
+		seq_print_ip_sym(m, iter->ent->ip, sym_only);
 		if (iter->ent->parent_ip) {
 			seq_printf(m, " <-- ");
-			seq_print_ip_sym(m, iter->ent->parent_ip);
+			seq_print_ip_sym(m, iter->ent->parent_ip,
+					 sym_only);
 		}
 		seq_printf(m, "\n");
 	}
@@ -345,6 +353,50 @@ static struct file_operations mctracer_c
 	.write = mctracer_ctrl_write,
 };
 
+static ssize_t mctracer_iter_ctrl_read(struct file *filp, char __user *ubuf,
+				       size_t cnt, loff_t *ppos)
+{
+	struct mctracer_trace *tr = filp->private_data;
+	char buf[64];
+	int r = 0;
+
+	if (tr->iter_flags & TRACE_ITER_SYM_ONLY)
+		r = sprintf(buf, "%s", "symonly ");
+	r += sprintf(buf+r, "\n");
+
+	return simple_read_from_buffer(ubuf, cnt, ppos,
+				       buf, r);
+}
+
+static ssize_t mctracer_iter_ctrl_write(struct file *filp,
+					const char __user *ubuf,
+					size_t cnt, loff_t *ppos)
+{
+	struct mctracer_trace *tr = filp->private_data;
+	char buf[64];
+
+	if (cnt > 63)
+		cnt = 63;
+
+	if (copy_from_user(&buf, ubuf, cnt))
+		return -EFAULT;
+
+	buf[cnt] = 0;
+
+	if (strncmp(buf, "symonly", 7) == 0)
+		tr->iter_flags |= TRACE_ITER_SYM_ONLY;
+
+	filp->f_pos += cnt;
+
+	return cnt;
+}
+
+static struct file_operations mctracer_iter_fops = {
+	.open = mctracer_open_generic,
+	.read = mctracer_iter_ctrl_read,
+	.write = mctracer_iter_ctrl_write,
+};
+
 static void mctrace_init_debugfs(void)
 {
 	struct dentry *d_mctracer;
@@ -361,10 +413,15 @@ static void mctrace_init_debugfs(void)
 	if (!entry)
 		pr_warning("Could not create debugfs 'ctrl' entry\n");
 
+	entry = debugfs_create_file("iter_ctrl", 0644, d_mctracer,
+				    &mctracer_trace, &mctracer_iter_fops);
+	if (!entry)
+		pr_warning("Could not create debugfs 'iter_ctrl' entry\n");
 	entry = debugfs_create_file("trace", 0444, d_mctracer,
 				    &mctracer_trace, &mctrace_fops);
 	if (!entry)
 		pr_warning("Could not create debugfs 'trace' entry\n");
+
 }
 #else /* CONFIG_DEBUG_FS */
 static void mctrace_init_debugfs(void)
Index: linux-compile.git/lib/tracing/tracer.h
===================================================================
--- linux-compile.git.orig/lib/tracing/tracer.h	2008-01-15 14:57:29.000000000 -0500
+++ linux-compile.git/lib/tracing/tracer.h	2008-01-15 14:57:36.000000000 -0500
@@ -17,6 +17,7 @@ struct mctracer_trace {
 	unsigned long trace_idx[NR_CPUS];
 	unsigned long entries;
 	long	      ctrl;
+	unsigned long iter_flags;
 	atomic_t      cnt;
 	atomic_t      disabled[NR_CPUS];
 	atomic_t      underrun[NR_CPUS];

-- 
