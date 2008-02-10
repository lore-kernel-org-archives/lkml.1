Return-Path: <linux-kernel-owner+w=401wt.eu-S1760143AbYBJH2B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760143AbYBJH2B (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 02:28:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757926AbYBJHV2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 02:21:28 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:35518 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758200AbYBJHV1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 02:21:27 -0500
Date: Sun, 10 Feb 2008 08:21:13 +0100
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@zip.com.au>, Steven Rostedt <rostedt@goodmis.org>
Subject: [18/19] ftrace: add ftrace_enabled sysctl to disable mcount
	function
Message-ID: <20080210072113.GS4100@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

This patch adds back the sysctl ftrace_enabled. This time it is
defaulted to on, if DYNAMIC_FTRACE is configured. When ftrace_enabled
is disabled, the ftrace function is set to the stub return.

If DYNAMIC_FTRACE is also configured, on ftrace_enabled = 0,
the registered ftrace functions will all be set to jmps, but no more
new calls to ftrace recording (used to find the ftrace calling sites)
will be called.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/ftrace.h |    6 ++
 kernel/sysctl.c        |   11 ++++
 kernel/trace/ftrace.c  |  125 +++++++++++++++++++++++++++++++++++++++++--------
 3 files changed, 124 insertions(+), 18 deletions(-)

Index: linux/include/linux/ftrace.h
===================================================================
--- linux.orig/include/linux/ftrace.h
+++ linux/include/linux/ftrace.h
@@ -5,6 +5,12 @@
 
 #include <linux/linkage.h>
 
+extern int ftrace_enabled;
+extern int
+ftrace_enable_sysctl(struct ctl_table *table, int write,
+		     struct file *filp, void __user *buffer, size_t *lenp,
+		     loff_t *ppos);
+
 typedef void (*ftrace_func_t)(unsigned long ip, unsigned long parent_ip);
 
 struct ftrace_ops {
Index: linux/kernel/sysctl.c
===================================================================
--- linux.orig/kernel/sysctl.c
+++ linux/kernel/sysctl.c
@@ -45,6 +45,7 @@
 #include <linux/nfs_fs.h>
 #include <linux/acpi.h>
 #include <linux/reboot.h>
+#include <linux/ftrace.h>
 
 #include <asm/uaccess.h>
 #include <asm/processor.h>
@@ -488,6 +489,16 @@ static struct ctl_table kern_table[] = {
 		.mode		= 0644,
 		.proc_handler	= &proc_dointvec,
 	},
+#ifdef CONFIG_FTRACE
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "ftrace_enabled",
+		.data		= &ftrace_enabled,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= &ftrace_enable_sysctl,
+	},
+#endif
 #ifdef CONFIG_KMOD
 	{
 		.ctl_name	= KERN_MODPROBE,
Index: linux/kernel/trace/ftrace.c
===================================================================
--- linux.orig/kernel/trace/ftrace.c
+++ linux/kernel/trace/ftrace.c
@@ -20,12 +20,24 @@
 #include <linux/hardirq.h>
 #include <linux/ftrace.h>
 #include <linux/module.h>
+#include <linux/sysctl.h>
 #include <linux/hash.h>
 #include <linux/list.h>
 
 #include "trace.h"
 
+#ifdef CONFIG_DYNAMIC_FTRACE
+# define FTRACE_ENABLED_INIT 1
+#else
+# define FTRACE_ENABLED_INIT 0
+#endif
+
+int ftrace_enabled = FTRACE_ENABLED_INIT;
+static int last_ftrace_enabled = FTRACE_ENABLED_INIT;
+
 static DEFINE_SPINLOCK(ftrace_lock);
+static DEFINE_MUTEX(ftrace_sysctl_lock);
+
 static struct ftrace_ops ftrace_list_end __read_mostly =
 {
 	.func = ftrace_stub,
@@ -78,14 +90,16 @@ static int notrace __register_ftrace_fun
 	smp_wmb();
 	ftrace_list = ops;
 
-	/*
-	 * For one func, simply call it directly.
-	 * For more than one func, call the chain.
-	 */
-	if (ops->next == &ftrace_list_end)
-		ftrace_trace_function = ops->func;
-	else
-		ftrace_trace_function = ftrace_list_func;
+	if (ftrace_enabled) {
+		/*
+		 * For one func, simply call it directly.
+		 * For more than one func, call the chain.
+		 */
+		if (ops->next == &ftrace_list_end)
+			ftrace_trace_function = ops->func;
+		else
+			ftrace_trace_function = ftrace_list_func;
+	}
 
 	spin_unlock(&ftrace_lock);
 
@@ -120,10 +134,12 @@ static int notrace __unregister_ftrace_f
 
 	*p = (*p)->next;
 
-	/* If we only have one func left, then call that directly */
-	if (ftrace_list == &ftrace_list_end ||
-	    ftrace_list->next == &ftrace_list_end)
-		ftrace_trace_function = ftrace_list->func;
+	if (ftrace_enabled) {
+		/* If we only have one func left, then call that directly */
+		if (ftrace_list == &ftrace_list_end ||
+		    ftrace_list->next == &ftrace_list_end)
+			ftrace_trace_function = ftrace_list->func;
+	}
 
  out:
 	spin_unlock(&ftrace_lock);
@@ -263,7 +279,8 @@ static void notrace ftrace_startup(void)
 		goto out;
 	__unregister_ftrace_function(&ftrace_shutdown_ops);
 
-	ftrace_run_startup_code();
+	if (ftrace_enabled)
+		ftrace_run_startup_code();
  out:
 	mutex_unlock(&ftraced_lock);
 }
@@ -275,13 +292,32 @@ static void notrace ftrace_shutdown(void
 	if (ftraced_suspend)
 		goto out;
 
-	ftrace_run_shutdown_code();
+	if (ftrace_enabled)
+		ftrace_run_shutdown_code();
 
 	__register_ftrace_function(&ftrace_shutdown_ops);
  out:
 	mutex_unlock(&ftraced_lock);
 }
 
+static void notrace ftrace_startup_sysctl(void)
+{
+	mutex_lock(&ftraced_lock);
+	/* ftraced_suspend is true if we want ftrace running */
+	if (ftraced_suspend)
+		ftrace_run_startup_code();
+	mutex_unlock(&ftraced_lock);
+}
+
+static void notrace ftrace_shutdown_sysctl(void)
+{
+	mutex_lock(&ftraced_lock);
+	/* ftraced_suspend is true if ftrace is running */
+	if (ftraced_suspend)
+		ftrace_run_shutdown_code();
+	mutex_unlock(&ftraced_lock);
+}
+
 static cycle_t		ftrace_update_time;
 static unsigned long	ftrace_update_cnt;
 unsigned long		ftrace_update_tot_cnt;
@@ -341,8 +377,9 @@ static int notrace ftraced(void *ignore)
 		/* check once a second */
 		schedule_timeout(HZ);
 
+		mutex_lock(&ftrace_sysctl_lock);
 		mutex_lock(&ftraced_lock);
-		if (ftraced_trigger && !ftraced_suspend) {
+		if (ftrace_enabled && ftraced_trigger && !ftraced_suspend) {
 			ftrace_record_suspend++;
 			ftrace_update_code();
 			usecs = nsecs_to_usecs(ftrace_update_time);
@@ -360,6 +397,7 @@ static int notrace ftraced(void *ignore)
 			ftrace_record_suspend--;
 		}
 		mutex_unlock(&ftraced_lock);
+		mutex_unlock(&ftrace_sysctl_lock);
 
 		ftrace_shutdown_replenish();
 
@@ -389,8 +427,10 @@ static int __init notrace ftrace_shutdow
 
 core_initcall(ftrace_shutdown_init);
 #else
-# define ftrace_startup()	do { } while (0)
-# define ftrace_shutdown()	do { } while (0)
+# define ftrace_startup()	  do { } while (0)
+# define ftrace_shutdown()	  do { } while (0)
+# define ftrace_startup_sysctl()  do { } while (0)
+# define ftrace_shutdown_sysctl() do { } while (0)
 #endif /* CONFIG_DYNAMIC_FTRACE */
 
 /**
@@ -406,9 +446,15 @@ core_initcall(ftrace_shutdown_init);
  */
 int register_ftrace_function(struct ftrace_ops *ops)
 {
+	int ret;
+
+	mutex_lock(&ftrace_sysctl_lock);
 	ftrace_startup();
 
-	return __register_ftrace_function(ops);
+	ret = __register_ftrace_function(ops);
+	mutex_unlock(&ftrace_sysctl_lock);
+
+	return ret;
 }
 
 /**
@@ -421,10 +467,53 @@ int unregister_ftrace_function(struct ft
 {
 	int ret;
 
+	mutex_lock(&ftrace_sysctl_lock);
 	ret = __unregister_ftrace_function(ops);
 
 	if (ftrace_list == &ftrace_list_end)
 		ftrace_shutdown();
 
+	mutex_unlock(&ftrace_sysctl_lock);
+
+	return ret;
+}
+
+notrace int
+ftrace_enable_sysctl(struct ctl_table *table, int write,
+		     struct file *filp, void __user *buffer, size_t *lenp,
+		     loff_t *ppos)
+{
+	int ret;
+
+	mutex_lock(&ftrace_sysctl_lock);
+
+	ret  = proc_dointvec(table, write, filp, buffer, lenp, ppos);
+
+	if (ret || !write || (last_ftrace_enabled == ftrace_enabled))
+		goto out;
+
+	last_ftrace_enabled = ftrace_enabled;
+
+	if (ftrace_enabled) {
+
+		ftrace_startup_sysctl();
+
+		/* we are starting ftrace again */
+		if (ftrace_list != &ftrace_list_end) {
+			if (ftrace_list->next == &ftrace_list_end)
+				ftrace_trace_function = ftrace_list->func;
+			else
+				ftrace_trace_function = ftrace_list_func;
+		}
+
+	} else {
+		/* stopping ftrace calls (just send to ftrace_stub) */
+		ftrace_trace_function = ftrace_stub;
+
+		ftrace_shutdown_sysctl();
+	}
+
+ out:
+	mutex_unlock(&ftrace_sysctl_lock);
 	return ret;
 }
