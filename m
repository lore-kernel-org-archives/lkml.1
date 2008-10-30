Return-Path: <linux-kernel-owner+w=401wt.eu-S1754898AbYJ3UMY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754898AbYJ3UMY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 16:12:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754775AbYJ3ULc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 16:11:32 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:55139 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754733AbYJ3UL3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 16:11:29 -0400
Message-Id: <20081030201128.000197812@goodmis.org>
References: <20081030200831.467420488@goodmis.org>
User-Agent: quilt/0.46-1
Date: Thu, 30 Oct 2008 16:08:33 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 2/2] ftrace: nmi update statistics
Content-Disposition: inline; filename=ftrace-count-nmi-writes.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds dynamic ftrace NMI update statistics to the
/debugfs/tracing/dyn_ftrace_total_info stat file.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 arch/x86/kernel/ftrace.c |   26 ++++++++++++++++++++++++--
 kernel/trace/trace.c     |   31 ++++++++++++++++++++++++-------
 2 files changed, 48 insertions(+), 9 deletions(-)

Index: linux-tip.git/arch/x86/kernel/ftrace.c
===================================================================
--- linux-tip.git.orig/arch/x86/kernel/ftrace.c	2008-10-30 15:30:12.000000000 -0400
+++ linux-tip.git/arch/x86/kernel/ftrace.c	2008-10-30 15:51:51.000000000 -0400
@@ -91,6 +91,19 @@ static int mod_code_write;
 static void *mod_code_ip;
 static void *mod_code_newcode;
 
+static int nmi_wait_count;
+static atomic_t nmi_update_count;
+
+int ftrace_arch_read_dyn_info(char *buf, int size)
+{
+	int r;
+
+	r = snprintf(buf, size, "%u %u",
+		     nmi_wait_count,
+		     atomic_read(&nmi_update_count));
+	return r;
+}
+
 static void ftrace_mod_code(void)
 {
 	/*
@@ -109,8 +122,10 @@ void ftrace_nmi_enter(void)
 	atomic_inc(&in_nmi);
 	/* Must have in_nmi seen before reading write flag */
 	smp_mb();
-	if (mod_code_write)
+	if (mod_code_write) {
 		ftrace_mod_code();
+		atomic_inc(&nmi_update_count);
+	}
 }
 
 void ftrace_nmi_exit(void)
@@ -122,8 +137,15 @@ void ftrace_nmi_exit(void)
 
 static void wait_for_nmi(void)
 {
-	while (atomic_read(&in_nmi))
+	int waited = 0;
+
+	while (atomic_read(&in_nmi)) {
+		waited = 1;
 		cpu_relax();
+	}
+
+	if (waited)
+		nmi_wait_count++;
 }
 
 static int
Index: linux-tip.git/kernel/trace/trace.c
===================================================================
--- linux-tip.git.orig/kernel/trace/trace.c	2008-10-30 15:18:45.000000000 -0400
+++ linux-tip.git/kernel/trace/trace.c	2008-10-30 15:51:51.000000000 -0400
@@ -2837,22 +2837,39 @@ static struct file_operations tracing_ma
 
 #ifdef CONFIG_DYNAMIC_FTRACE
 
+#define DYN_INFO_BUF_SIZE 1023
+static char ftrace_dyn_info_buffer[DYN_INFO_BUF_SIZE+1];
+static DEFINE_MUTEX(dyn_info_mutex);
+
+int __weak ftrace_arch_read_dyn_info(char *buf, int size)
+{
+	return 0;
+}
+
 static ssize_t
-tracing_read_long(struct file *filp, char __user *ubuf,
+tracing_read_dyn_info(struct file *filp, char __user *ubuf,
 		  size_t cnt, loff_t *ppos)
 {
 	unsigned long *p = filp->private_data;
-	char buf[64];
+	char *buf = ftrace_dyn_info_buffer;
 	int r;
 
-	r = sprintf(buf, "%ld\n", *p);
+	mutex_lock(&dyn_info_mutex);
+	r = sprintf(buf, "%ld ", *p);
+
+	r += ftrace_arch_read_dyn_info(buf+r, DYN_INFO_BUF_SIZE-r);
+	buf[r++] = '\n';
+
+	r = simple_read_from_buffer(ubuf, cnt, ppos, buf, r);
+
+	mutex_unlock(&dyn_info_mutex);
 
-	return simple_read_from_buffer(ubuf, cnt, ppos, buf, r);
+	return r;
 }
 
-static struct file_operations tracing_read_long_fops = {
+static struct file_operations tracing_dyn_info_fops = {
 	.open		= tracing_open_generic,
-	.read		= tracing_read_long,
+	.read		= tracing_read_dyn_info,
 };
 #endif
 
@@ -2961,7 +2978,7 @@ static __init int tracer_init_debugfs(vo
 #ifdef CONFIG_DYNAMIC_FTRACE
 	entry = debugfs_create_file("dyn_ftrace_total_info", 0444, d_tracer,
 				    &ftrace_update_tot_cnt,
-				    &tracing_read_long_fops);
+				    &tracing_dyn_info_fops);
 	if (!entry)
 		pr_warning("Could not create debugfs "
 			   "'dyn_ftrace_total_info' entry\n");

-- 
