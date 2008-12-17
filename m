Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1755986AbYLQEOi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755986AbYLQEOi (ORCPT <rfc822;akpm@linux-foundation.org>);
	Tue, 16 Dec 2008 23:14:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751212AbYLQEO1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 23:14:27 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:54990 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751046AbYLQEO0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 23:14:26 -0500
Date: Tue, 16 Dec 2008 23:14:23 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: LKML <linux-kernel@vger.kernel.org>
cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        =?ISO-8859-15?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
Subject: [PATCH] trace: add a way to enable or disable the stack tracer
Message-ID: <alpine.DEB.1.10.0812162311430.25356@gandalf.stny.rr.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The following patch is in:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git

    branch: tip/devel


Steven Rostedt (1):
      trace: add a way to enable or disable the stack tracer

----
 Documentation/kernel-parameters.txt |    4 +++
 include/linux/ftrace.h              |    8 +++++
 kernel/sysctl.c                     |   10 +++++++
 kernel/trace/Kconfig                |   13 ++++++---
 kernel/trace/trace_stack.c          |   52 ++++++++++++++++++++++++++++++++---
 5 files changed, 79 insertions(+), 8 deletions(-)
---------------------------
commit ab8e30ab67495a48599edc11e805382da15b7761
Author: Steven Rostedt <srostedt@redhat.com>
Date:   Tue Dec 16 23:06:40 2008 -0500

    trace: add a way to enable or disable the stack tracer
    
    Impact: enhancement to stack tracer
    
    The stack tracer currently is either on when configured in or
    off when it is not. It can not be disabled when it is configured on.
    (besides disabling the function tracer that it uses)
    
    This patch adds a way to enable or disable the stack tracer at
    run time. It defaults off on bootup, but a kernel parameter 'stacktrace'
    has been added to enable it on bootup.
    
    A new sysctl has been added "kernel.stack_tracer_enabled" to let
    the user enable or disable the stack tracer at run time.
    
    Signed-off-by: Steven Rostedt <srostedt@redhat.com>

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 16aaa84..95fa674 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -89,6 +89,7 @@ parameter is applicable:
 	SPARC	Sparc architecture is enabled.
 	SWSUSP	Software suspend (hibernation) is enabled.
 	SUSPEND	System suspend states are enabled.
+	FTRACE	Function tracing enabled.
 	TS	Appropriate touchscreen support is enabled.
 	USB	USB support is enabled.
 	USBHID	USB Human Interface Device support is enabled.
@@ -2197,6 +2198,9 @@ and is between 256 and 4096 characters. It is defined in the file
 	st=		[HW,SCSI] SCSI tape parameters (buffers, etc.)
 			See Documentation/scsi/st.txt.
 
+	stacktrace	[FTRACE]
+			Enabled the stack tracer on boot up.
+
 	sti=		[PARISC,HW]
 			Format: <num>
 			Set the STI (builtin display/keyboard on the HP-PARISC
diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index 286af82..04b52e6 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -87,6 +87,14 @@ static inline void ftrace_stop(void) { }
 static inline void ftrace_start(void) { }
 #endif /* CONFIG_FUNCTION_TRACER */
 
+#ifdef CONFIG_STACK_TRACER
+extern int stack_tracer_enabled;
+int
+stack_trace_sysctl(struct ctl_table *table, int write,
+		   struct file *file, void __user *buffer, size_t *lenp,
+		   loff_t *ppos);
+#endif
+
 #ifdef CONFIG_DYNAMIC_FTRACE
 /* asm/ftrace.h must be defined for archs supporting dynamic ftrace */
 #include <asm/ftrace.h>
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index c7bf3dd..2414fa8 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -488,6 +488,16 @@ static struct ctl_table kern_table[] = {
 		.proc_handler	= &ftrace_enable_sysctl,
 	},
 #endif
+#ifdef CONFIG_STACK_TRACER
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "stack_tracer_enabled",
+		.data		= &stack_tracer_enabled,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= &stack_trace_sysctl,
+	},
+#endif
 #ifdef CONFIG_TRACING
 	{
 		.ctl_name	= CTL_UNNUMBERED,
diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index d8bae6f..e2a4ff6 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -244,10 +244,15 @@ config STACK_TRACER
 
 	  This tracer works by hooking into every function call that the
 	  kernel executes, and keeping a maximum stack depth value and
-	  stack-trace saved. Because this logic has to execute in every
-	  kernel function, all the time, this option can slow down the
-	  kernel measurably and is generally intended for kernel
-	  developers only.
+	  stack-trace saved.  If this is configured with DYNAMIC_FTRACE
+	  then it will not have any overhead while the stack tracer
+	  is disabled.
+
+	  To enable the stack tracer on bootup, pass in 'stacktrace'
+	  on the kernel command line.
+
+	  The stack tracer can also be enabled or disabled via the
+	  sysctl kernel.stack_tracer_enabled
 
 	  Say N if unsure.
 
diff --git a/kernel/trace/trace_stack.c b/kernel/trace/trace_stack.c
index 0b863f2..4842c96 100644
--- a/kernel/trace/trace_stack.c
+++ b/kernel/trace/trace_stack.c
@@ -10,6 +10,7 @@
 #include <linux/debugfs.h>
 #include <linux/ftrace.h>
 #include <linux/module.h>
+#include <linux/sysctl.h>
 #include <linux/init.h>
 #include <linux/fs.h>
 #include "trace.h"
@@ -31,6 +32,10 @@ static raw_spinlock_t max_stack_lock =
 
 static int stack_trace_disabled __read_mostly;
 static DEFINE_PER_CPU(int, trace_active);
+static DEFINE_MUTEX(stack_sysctl_mutex);
+
+int stack_tracer_enabled;
+static int last_stack_tracer_enabled;
 
 static inline void check_stack(void)
 {
@@ -174,7 +179,7 @@ stack_max_size_write(struct file *filp, const char __user *ubuf,
 	return count;
 }
 
-static struct file_operations stack_max_size_fops = {
+static const struct file_operations stack_max_size_fops = {
 	.open		= tracing_open_generic,
 	.read		= stack_max_size_read,
 	.write		= stack_max_size_write,
@@ -272,7 +277,7 @@ static int t_show(struct seq_file *m, void *v)
 	return 0;
 }
 
-static struct seq_operations stack_trace_seq_ops = {
+static const struct seq_operations stack_trace_seq_ops = {
 	.start		= t_start,
 	.next		= t_next,
 	.stop		= t_stop,
@@ -288,12 +293,48 @@ static int stack_trace_open(struct inode *inode, struct file *file)
 	return ret;
 }
 
-static struct file_operations stack_trace_fops = {
+static const struct file_operations stack_trace_fops = {
 	.open		= stack_trace_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
 };
 
+int
+stack_trace_sysctl(struct ctl_table *table, int write,
+		   struct file *file, void __user *buffer, size_t *lenp,
+		   loff_t *ppos)
+{
+	int ret;
+
+	mutex_lock(&stack_sysctl_mutex);
+
+	ret  = proc_dointvec(table, write, file, buffer, lenp, ppos);
+
+	if (ret || !write ||
+	    (last_stack_tracer_enabled == stack_tracer_enabled))
+		goto out;
+
+	last_stack_tracer_enabled = stack_tracer_enabled;
+
+	if (stack_tracer_enabled)
+		register_ftrace_function(&trace_ops);
+	else
+		unregister_ftrace_function(&trace_ops);
+
+ out:
+	mutex_unlock(&stack_sysctl_mutex);
+	return ret;
+}
+
+static int start_stack_trace __initdata;
+
+static __init int enable_stacktrace(char *str)
+{
+	start_stack_trace = 1;
+	return 1;
+}
+__setup("stacktrace", enable_stacktrace);
+
 static __init int stack_trace_init(void)
 {
 	struct dentry *d_tracer;
@@ -311,7 +352,10 @@ static __init int stack_trace_init(void)
 	if (!entry)
 		pr_warning("Could not create debugfs 'stack_trace' entry\n");
 
-	register_ftrace_function(&trace_ops);
+	if (start_stack_trace) {
+		register_ftrace_function(&trace_ops);
+		stack_tracer_enabled = 1;
+	}
 
 	return 0;
 }

