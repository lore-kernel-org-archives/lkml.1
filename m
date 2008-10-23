Return-Path: <linux-kernel-owner+w=401wt.eu-S1758561AbYJWTPk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758561AbYJWTPk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 15:15:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754625AbYJWTPb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 15:15:31 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:62801 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753075AbYJWTPa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 15:15:30 -0400
Date: Thu, 23 Oct 2008 15:15:27 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: LKML <linux-kernel@vger.kernel.org>
cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH] ftrace: ftrace dump on oops control
Message-ID: <alpine.DEB.1.10.0810231514140.8986@gandalf.stny.rr.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Currently, ftrace is set up to dump its contents to the console if the
kernel panics or oops. This can be annoying if you have trace data in
the buffers and you experience an oops, but the trace data is old or
static.

Usually when you want ftrace to dump its contents is when you are debugging
your system and you have set up ftrace to trace the events leading to
an oops.

This patch adds a control variable called "ftrace_dump_on_oops" that will
enable the ftrace dump to console on oops. This variable is default off
but a developer can enable it either through the kernel command line
by adding "ftrace_dump_on_oops" or at run time by setting (or disabling)
/proc/sys/kernel/ftrace_dump_on_oops.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 include/linux/ftrace.h |    2 ++
 kernel/sysctl.c        |   10 ++++++++++
 kernel/trace/trace.c   |   29 ++++++++++++++++++++++++++---
 3 files changed, 38 insertions(+), 3 deletions(-)

Index: linux-tip.git/include/linux/ftrace.h
===================================================================
--- linux-tip.git.orig/include/linux/ftrace.h	2008-10-23 12:55:35.000000000 -0400
+++ linux-tip.git/include/linux/ftrace.h	2008-10-23 14:17:22.000000000 -0400
@@ -181,6 +181,8 @@ static inline void __ftrace_enabled_rest
 #endif
 
 #ifdef CONFIG_TRACING
+extern int ftrace_dump_on_oops;
+
 extern void
 ftrace_special(unsigned long arg1, unsigned long arg2, unsigned long arg3);
 
Index: linux-tip.git/kernel/sysctl.c
===================================================================
--- linux-tip.git.orig/kernel/sysctl.c	2008-10-23 12:55:37.000000000 -0400
+++ linux-tip.git/kernel/sysctl.c	2008-10-23 15:01:00.000000000 -0400
@@ -485,6 +485,16 @@ static struct ctl_table kern_table[] = {
 		.proc_handler	= &ftrace_enable_sysctl,
 	},
 #endif
+#ifdef CONFIG_TRACING
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "ftrace_dump_on_opps",
+		.data		= &ftrace_dump_on_oops,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec,
+	},
+#endif
 #ifdef CONFIG_MODULES
 	{
 		.ctl_name	= KERN_MODPROBE,
Index: linux-tip.git/kernel/trace/trace.c
===================================================================
--- linux-tip.git.orig/kernel/trace/trace.c	2008-10-23 12:55:37.000000000 -0400
+++ linux-tip.git/kernel/trace/trace.c	2008-10-23 14:24:28.000000000 -0400
@@ -63,6 +63,28 @@ static cpumask_t __read_mostly		tracing_
 
 static int tracing_disabled = 1;
 
+/**
+ * ftrace_dump_on_oops - variable to dump ftrace buffer on oops
+ *
+ * If there is an oops (or kernel panic) and the ftrace_dump_on_oops
+ * is set, then ftrace_dump is called. This will output the contents
+ * of the ftrace buffers to the console.  This is very useful for
+ * capturing traces that lead to crashes and outputing it to a
+ * serial console.
+ *
+ * It is default off, but you can enable it with either specifying
+ * "ftrace_dump_on_oops" in the kernel command line, or setting
+ * /proc/sys/kernel/ftrace_dump_on_oops to true.
+ */
+int ftrace_dump_on_oops;
+
+static int __init set_ftrace_dump_on_oops(char *str)
+{
+	ftrace_dump_on_oops = 1;
+	return 1;
+}
+__setup("ftrace_dump_on_oops", set_ftrace_dump_on_oops);
+
 long
 ns2usecs(cycle_t nsec)
 {
@@ -3018,7 +3040,8 @@ EXPORT_SYMBOL_GPL(__ftrace_printk);
 static int trace_panic_handler(struct notifier_block *this,
 			       unsigned long event, void *unused)
 {
-	ftrace_dump();
+	if (ftrace_dump_on_oops)
+		ftrace_dump();
 	return NOTIFY_OK;
 }
 
@@ -3034,7 +3057,8 @@ static int trace_die_handler(struct noti
 {
 	switch (val) {
 	case DIE_OOPS:
-		ftrace_dump();
+		if (ftrace_dump_on_oops)
+			ftrace_dump();
 		break;
 	default:
 		break;
@@ -3075,7 +3099,6 @@ trace_printk_seq(struct trace_seq *s)
 	trace_seq_reset(s);
 }
 
-
 void ftrace_dump(void)
 {
 	static DEFINE_SPINLOCK(ftrace_dump_lock);

