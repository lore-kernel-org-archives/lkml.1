Return-Path: <linux-kernel-owner+w=401wt.eu-S1754929AbYJFQwd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754929AbYJFQwd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 12:52:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753434AbYJFQwX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 12:52:23 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:54974 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754652AbYJFQwW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 12:52:22 -0400
Date: Mon, 6 Oct 2008 12:52:19 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: LKML <linux-kernel@vger.kernel.org>
cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] ftrace: add quick function trace stop
Message-ID: <alpine.DEB.1.10.0810061251330.16804@gandalf.stny.rr.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch adds a way to disable the function tracer quickly without
the need to run kstop_machine. It adds a new variable called
function_trace_stop which will stop the calls to functions from mcount
when set.  This is just an on/off switch and does not handle recursion
like preempt_disable().

It's main purpose is to help other tracers/debuggers start and stop tracing
fuctions without the need to call kstop_machine.

A new file is added to /debug/tracing called function_trace_stop.
Echoing 1 into this file will stop the function tracing and echoing 1
will allow function tracing. Note, this is not the same as the heavy weight
/proc/sys/kernel/ftrace_enabled which calls the kstop_machine to fully
enable or disable ftrace.

   ftrace_enabled      function_stop_trace

        0                     0 or 1      - No function tracing at all
        1                       0         - mcount called but no function is
                                              traced
        1                       1         - normal function tracing


Note, only x86 architecture has this implemented (for now).

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 arch/x86/kernel/entry_32.S |    6 +++++
 arch/x86/kernel/entry_64.S |    5 ++++
 include/linux/ftrace.h     |   28 ++++++++++++++++++++++++
 kernel/trace/ftrace.c      |   52 +++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 91 insertions(+)

Index: linux-tip.git/arch/x86/kernel/entry_32.S
===================================================================
--- linux-tip.git.orig/arch/x86/kernel/entry_32.S	2008-10-06 10:54:50.000000000 -0400
+++ linux-tip.git/arch/x86/kernel/entry_32.S	2008-10-06 11:31:49.000000000 -0400
@@ -1187,6 +1187,9 @@ ENTRY(mcount)
 END(mcount)
 
 ENTRY(ftrace_caller)
+	cmpl $0, function_trace_stop
+	jne  ftrace_stub
+
 	pushl %eax
 	pushl %ecx
 	pushl %edx
@@ -1210,6 +1213,9 @@ END(ftrace_caller)
 #else /* ! CONFIG_DYNAMIC_FTRACE */
 
 ENTRY(mcount)
+	cmpl $0, function_trace_stop
+	jne  ftrace_stub
+
 	cmpl $ftrace_stub, ftrace_trace_function
 	jnz trace
 .globl ftrace_stub
Index: linux-tip.git/arch/x86/kernel/entry_64.S
===================================================================
--- linux-tip.git.orig/arch/x86/kernel/entry_64.S	2008-10-06 10:54:50.000000000 -0400
+++ linux-tip.git/arch/x86/kernel/entry_64.S	2008-10-06 11:31:59.000000000 -0400
@@ -68,6 +68,8 @@ ENTRY(mcount)
 END(mcount)
 
 ENTRY(ftrace_caller)
+	cmpl $0, function_trace_stop
+	jne  ftrace_stub
 
 	/* taken from glibc */
 	subq $0x38, %rsp
@@ -103,6 +105,9 @@ END(ftrace_caller)
 
 #else /* ! CONFIG_DYNAMIC_FTRACE */
 ENTRY(mcount)
+	cmpl $0, function_trace_stop
+	jne  ftrace_stub
+
 	cmpq $ftrace_stub, ftrace_trace_function
 	jnz trace
 .globl ftrace_stub
Index: linux-tip.git/include/linux/ftrace.h
===================================================================
--- linux-tip.git.orig/include/linux/ftrace.h	2008-10-06 10:55:07.000000000 -0400
+++ linux-tip.git/include/linux/ftrace.h	2008-10-06 11:25:26.000000000 -0400
@@ -23,6 +23,34 @@ struct ftrace_ops {
 	struct ftrace_ops *next;
 };
 
+extern int function_trace_stop;
+
+/**
+ * ftrace_stop - stop function tracer.
+ *
+ * A quick way to stop the function tracer. Note this an on off switch,
+ * it is not something that is recursive like preempt_disable.
+ * This does not disable the calling of mcount, it only stops the
+ * calling of functions from mcount.
+ */
+static inline void ftrace_stop(void)
+{
+	function_trace_stop = 1;
+}
+
+/**
+ * ftrace_start - start the function tracer.
+ *
+ * This function is the inverse of ftrace_stop. This does not enable
+ * the function tracing if the function tracer is disabled. This only
+ * sets the function tracer flag to contiune calling the functions
+ * from mcount.
+ */
+static inline void ftrace_start(void)
+{
+	function_trace_stop = 0;
+}
+
 /*
  * The ftrace_ops must be a static and should also
  * be read_mostly.  These functions do modify read_mostly variables
Index: linux-tip.git/kernel/trace/ftrace.c
===================================================================
--- linux-tip.git.orig/kernel/trace/ftrace.c	2008-09-29 20:13:37.000000000 -0400
+++ linux-tip.git/kernel/trace/ftrace.c	2008-10-06 12:33:40.000000000 -0400
@@ -36,6 +36,9 @@
 int ftrace_enabled __read_mostly;
 static int last_ftrace_enabled;
 
+/* Quick disabling of function tracer. */
+int function_trace_stop;
+
 /*
  * ftrace_disabled is set when an anomaly is discovered.
  * ftrace_disabled is much stronger than ftrace_enabled.
@@ -1480,6 +1483,46 @@ ftraced_write(struct file *filp, const c
 	return cnt;
 }
 
+static ssize_t
+ftrace_stop_read(struct file *filp, char __user *ubuf,
+		     size_t cnt, loff_t *ppos)
+{
+	/* don't worry about races */
+	char *buf = function_trace_stop ? "1\n" : "0\n";
+	int r = strlen(buf);
+
+	return simple_read_from_buffer(ubuf, cnt, ppos, buf, r);
+}
+
+static ssize_t
+ftrace_stop_write(struct file *filp, const char __user *ubuf,
+		      size_t cnt, loff_t *ppos)
+{
+	char buf[64];
+	long val;
+	int ret;
+
+	if (cnt >= sizeof(buf))
+		return -EINVAL;
+
+	if (copy_from_user(&buf, ubuf, cnt))
+		return -EFAULT;
+
+	buf[cnt] = 0;
+
+	ret = strict_strtoul(buf, 10, &val);
+	if (ret < 0)
+		return ret;
+
+	val = !!val;
+
+	function_trace_stop = !!val;
+
+	filp->f_pos += cnt;
+
+	return cnt;
+}
+
 static struct file_operations ftrace_avail_fops = {
 	.open = ftrace_avail_open,
 	.read = seq_read,
@@ -1516,6 +1559,12 @@ static struct file_operations ftraced_fo
 	.write = ftraced_write,
 };
 
+static struct file_operations ftrace_stop_fops = {
+	.open = tracing_open_generic,
+	.read = ftrace_stop_read,
+	.write = ftrace_stop_write,
+};
+
 /**
  * ftrace_force_update - force an update to all recording ftrace functions
  */
@@ -1593,6 +1642,9 @@ static __init int ftrace_init_debugfs(vo
 	if (!entry)
 		pr_warning("Could not create debugfs "
 			   "'ftraced_enabled' entry\n");
+
+	entry = debugfs_create_file("function_trace_stop", 0644, d_tracer,
+				    NULL, &ftrace_stop_fops);
 	return 0;
 }
 

