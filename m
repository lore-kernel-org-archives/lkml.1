Return-Path: <linux-kernel-owner+w=401wt.eu-S1753330AbYG3Q2x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753330AbYG3Q2x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 12:28:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751068AbYG3Q2p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 12:28:45 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:64301 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751044AbYG3Q2o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 12:28:44 -0400
Date: Wed, 30 Jul 2008 12:28:41 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: LKML <linux-kernel@vger.kernel.org>
cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH] ftrace: add ftraced_nmi runtime tester
Message-ID: <alpine.DEB.1.10.0807301225050.26259@gandalf.stny.rr.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Stated in previous patches, we can not modify code that has a chance of
running on another CPU at the same time. We use kstop_machine to modify
code to prevent most of these cases. Unfortunatly, kstop_machine does not
affect NMIs. To get around this, we simply do not trace NMI code.

Previous patches address finding areas that are being traced and called
by NMIs. But there is a very small chance that it may miss some calls.

On boot up, in mcount (all non trace disabled functions call it) has
a check to see if it is called from NMI context, and if it is, it prints
a warning and disables ftrace.  Near the end of the boot process, the kernel
thread "ftraced" will convert those recorded functions into nops.

There is a chance that the NMI code will call some function that was called
and recorded by non NMI code, and the check will not be done. Note, that
for this to happen, the NMI code had to call it _after_ the kernel thread
"ftraced" converted it. Even if the non NMI code was called first, the
check is still done until the kernel thread changes it into a nop. For
this reason, it is unlikely that the code would be missed.

In order to catch these unlikely cases, this patch adds another safety net 
that can be enabled after the system is up and running. It will convert 
all recorded functions into a call to check if they are being called from 
NMI context, and if they are, a warning is printed.

This is not turned on by default since it brings the preformance of the
system down by roughly 18% (tracing is enabled in this check).

Note: This patch did not catch any new areas that NMI is called that was
   not already caught by the other patch set. I only have this patch because
   in theory, the other patch set might miss something.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
  kernel/trace/Kconfig  |   17 ++++++++
  kernel/trace/ftrace.c |  100 ++++++++++++++++++++++++++++++++++++++++++++++++++
  2 files changed, 117 insertions(+)

Index: linux-tip.git/kernel/trace/Kconfig
===================================================================
--- linux-tip.git.orig/kernel/trace/Kconfig	2008-07-28 20:15:15.000000000 -0400
+++ linux-tip.git/kernel/trace/Kconfig	2008-07-30 11:41:09.000000000 -0400
@@ -134,3 +134,20 @@ config FTRACE_STARTUP_TEST
  	  a series of tests are made to verify that the tracer is
  	  functioning properly. It will do tests on all the configured
  	  tracers of ftrace.
+
+config FTRACE_NMI_TESTER
+	bool "Enable NMI checking in all ftrace calls"
+	depends on DYNAMIC_FTRACE
+	help
+	  This option is used to find areas in the kernel that might be traced
+	  in NMI context. It adds a function tracer that only checks to see
+	  if it is called in the NMI context, and if it is it will report a
+	  warning and stop checking.
+
+	  The file debugfs/tracing/ftrace_nmi_tester will be created.
+	  To start the NIM testing, simply echo '1' into this file.
+
+	  Note: The performance of the system will slow down around 18%, when
+	        the tester is active.
+
+	  If unsure say N.
Index: linux-tip.git/kernel/trace/ftrace.c
===================================================================
--- linux-tip.git.orig/kernel/trace/ftrace.c	2008-07-29 20:50:20.000000000 -0400
+++ linux-tip.git/kernel/trace/ftrace.c	2008-07-30 12:24:23.000000000 -0400
@@ -1473,6 +1473,97 @@ ftraced_write(struct file *filp, const c
  	return cnt;
  }

+#ifdef CONFIG_FTRACE_NMI_TESTER
+static int ftrace_nmi_tester __read_mostly;
+static int ftrace_nmi_call_detected __read_mostly;
+
+static void
+ftrace_nmi_tester_call(unsigned long ip, unsigned long parent_ip)
+{
+
+	if (unlikely(ftrace_nmi_call_detected))
+		return;
+
+	if (unlikely(in_nmi())) {
+		ftrace_nmi_call_detected = 1;
+
+		printk(KERN_WARNING
+		       "\n--------------- cut here ---------------\n");
+		printk(KERN_WARNING
+		       "WARNING: ftraced code called from NMI context ");
+		print_symbol("%s\n", ip);
+		printk(KERN_WARNING
+		     "         Please report this to the ftrace maintainer.\n");
+		dump_stack();
+		printk(KERN_WARNING
+		       "--------------- end cut here ---------------\n");
+	}
+}
+
+static struct ftrace_ops ftrace_nmi_trace_ops __read_mostly =
+{
+	.func = ftrace_nmi_tester_call,
+};
+
+static ssize_t
+ftrace_nmi_tester_read(struct file *filp, char __user *ubuf,
+		       size_t cnt, loff_t *ppos)
+{
+	/* don't worry about races */
+	char *buf = ftrace_nmi_tester ? "enabled\n" : "disabled\n";
+	int r = strlen(buf);
+
+	return simple_read_from_buffer(ubuf, cnt, ppos, buf, r);
+}
+
+static ssize_t
+ftrace_nmi_tester_write(struct file *filp, const char __user *ubuf,
+			size_t cnt, loff_t *ppos)
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
+	if (strncmp(buf, "enable", 6) == 0)
+		val = 1;
+	else if (strncmp(buf, "disable", 7) == 0)
+		val = 0;
+	else {
+		buf[cnt] = 0;
+
+		ret = strict_strtoul(buf, 10, &val);
+		if (ret < 0)
+			return ret;
+
+		val = !!val;
+	}
+
+	if (ftrace_nmi_tester != val) {
+		ftrace_nmi_tester = val;
+		if (val)
+			register_ftrace_function(&ftrace_nmi_trace_ops);
+		else
+			unregister_ftrace_function(&ftrace_nmi_trace_ops);
+	}
+
+	filp->f_pos += cnt;
+
+	return cnt;
+}
+
+static struct file_operations ftrace_nmi_tester_fops = {
+	.open = tracing_open_generic,
+	.read = ftrace_nmi_tester_read,
+	.write = ftrace_nmi_tester_write,
+};
+#endif /* CONFIG_FTRACE_NMI_TESTER */
+
  static struct file_operations ftrace_avail_fops = {
  	.open = ftrace_avail_open,
  	.read = seq_read,
@@ -1586,6 +1677,15 @@ static __init int ftrace_init_debugfs(vo
  	if (!entry)
  		pr_warning("Could not create debugfs "
  			   "'ftraced_enabled' entry\n");
+
+#ifdef CONFIG_FTRACE_NMI_TESTER
+	entry = debugfs_create_file("ftraced_nmi_tester", 0644, d_tracer,
+				    NULL, &ftrace_nmi_tester_fops);
+	if (!entry)
+		pr_warning("Could not create debugfs "
+			   "'ftrace_nmi_tester' entry\n");
+#endif
+
  	return 0;
  }


