Return-Path: <linux-kernel-owner+w=401wt.eu-S1759456AbYE1Ass@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759456AbYE1Ass (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 20:48:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754645AbYE1Ask
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 20:48:40 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:43343 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753941AbYE1Asj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 20:48:39 -0400
Date: Tue, 27 May 2008 20:48:37 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH] ftrace: user update and disable dynamic ftrace daemon
Message-ID: <Pine.LNX.4.58.0805272047500.13881@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


In dynamic ftrace, the mcount function starts off pointing to a stub
function that just returns.

On start up, the call to the stub is modified to point to a "record_ip"
function. The job of the record_ip function is to add the function to
a pre-allocated hash list. If the function is already there, it simply is
ignored, otherwise it is added to the list.

Later, a ftraced daemon wakes up and calls kstop_machine if any functions
have been recorded, and changes the calls to the recorded functions to
a simple nop.  If no functions were recorded, the daemon goes back to sleep.

The daemon wakes up once a second to see if it needs to update any newly
recorded functions into nops.  Usually it does not, but if a lot of code
has been executed for the first time in the kernel, the ftraced daemon
will call kstop_machine to update those into nops.

The problem currently is that there's no way to stop the daemon from doing
this, and it can cause unneeded latencies (800us which for some is bothersome).

This patch adds a new file /debugfs/tracing/ftraced_enabled. If the daemon
is active, reading this will return "enabled\n" and "disabled\n" when the
daemon is not running. To disable the daemon, the user can echo "0" or
"disable" into this file, and "1" or "enable" to re-enable the daemon.

Since the daemon is used to convert the functions into nops to increase
the performance of the system, I also added that anytime something is
written into the ftraced_enabled file, kstop_machine will run if there
are new functions that have been detected that need to be converted.

This way the user can disable the daemon but still be able to control the
conversion of the mcount calls to nops by simply,

  "echo 0 > /debugfs/tracing/ftraced_enabled"

when they need to do more conversions.

To see the number of converted functions:

  "cat /debugfs/tracing/dyn_ftrace_total_info"

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 include/linux/ftrace.h |    6 +
 kernel/trace/ftrace.c  |  157 ++++++++++++++++++++++++++++++++++---------------
 2 files changed, 116 insertions(+), 47 deletions(-)

Index: linux-tip.git/include/linux/ftrace.h
===================================================================
--- linux-tip.git.orig/include/linux/ftrace.h	2008-05-27 19:47:26.000000000 -0400
+++ linux-tip.git/include/linux/ftrace.h	2008-05-27 20:02:47.000000000 -0400
@@ -72,9 +72,15 @@ extern int ftrace_update_ftrace_func(ftr
 extern void ftrace_caller(void);
 extern void ftrace_call(void);
 extern void mcount_call(void);
+
+void ftrace_disable_daemon(void);
+void ftrace_enable_daemon(void);
+
 #else
 # define ftrace_force_update()			({ 0; })
 # define ftrace_set_filter(buf, len, reset)	do { } while (0)
+# define ftrace_disable_daemon()		do { } while (0)
+# define ftrace_enable_daemon()			do { } while (0)
 #endif

 /* totally disable ftrace - can not re-enable after this */
Index: linux-tip.git/kernel/trace/ftrace.c
===================================================================
--- linux-tip.git.orig/kernel/trace/ftrace.c	2008-05-27 19:47:26.000000000 -0400
+++ linux-tip.git/kernel/trace/ftrace.c	2008-05-27 20:07:25.000000000 -0400
@@ -151,8 +151,6 @@ static int __unregister_ftrace_function(
 #ifdef CONFIG_DYNAMIC_FTRACE

 static struct task_struct *ftraced_task;
-static DECLARE_WAIT_QUEUE_HEAD(ftraced_waiters);
-static unsigned long ftraced_iteration_counter;

 enum {
 	FTRACE_ENABLE_CALLS		= (1 << 0),
@@ -189,6 +187,7 @@ static struct ftrace_page	*ftrace_pages;

 static int ftraced_trigger;
 static int ftraced_suspend;
+static int ftraced_stop;

 static int ftrace_record_suspend;

@@ -474,14 +473,21 @@ ftrace_code_disable(struct dyn_ftrace *r
 	return 1;
 }

+static int __ftrace_update_code(void *ignore);
+
 static int __ftrace_modify_code(void *data)
 {
 	unsigned long addr;
 	int *command = data;

-	if (*command & FTRACE_ENABLE_CALLS)
+	if (*command & FTRACE_ENABLE_CALLS) {
+		/*
+		 * Update any recorded ips now that we have the
+		 * machine stopped
+		 */
+		__ftrace_update_code(NULL);
 		ftrace_replace_code(1);
-	else if (*command & FTRACE_DISABLE_CALLS)
+	} else if (*command & FTRACE_DISABLE_CALLS)
 		ftrace_replace_code(0);

 	if (*command & FTRACE_UPDATE_TRACE_FUNC)
@@ -503,6 +509,25 @@ static void ftrace_run_update_code(int c
 	stop_machine_run(__ftrace_modify_code, &command, NR_CPUS);
 }

+void ftrace_disable_daemon(void)
+{
+	/* Stop the daemon from calling kstop_machine */
+	mutex_lock(&ftraced_lock);
+	ftraced_stop = 1;
+	mutex_unlock(&ftraced_lock);
+
+	ftrace_force_update();
+}
+
+void ftrace_enable_daemon(void)
+{
+	mutex_lock(&ftraced_lock);
+	ftraced_stop = 0;
+	mutex_unlock(&ftraced_lock);
+
+	ftrace_force_update();
+}
+
 static ftrace_func_t saved_ftrace_func;

 static void ftrace_startup(void)
@@ -603,6 +628,7 @@ static int __ftrace_update_code(void *ig
 	int i;

 	/* Don't be recording funcs now */
+	ftrace_record_suspend++;
 	save_ftrace_enabled = ftrace_enabled;
 	ftrace_enabled = 0;

@@ -628,18 +654,23 @@ static int __ftrace_update_code(void *ig
 	stop = ftrace_now(raw_smp_processor_id());
 	ftrace_update_time = stop - start;
 	ftrace_update_tot_cnt += ftrace_update_cnt;
+	ftraced_trigger = 0;

 	ftrace_enabled = save_ftrace_enabled;
+	ftrace_record_suspend--;

 	return 0;
 }

-static void ftrace_update_code(void)
+static int ftrace_update_code(void)
 {
-	if (unlikely(ftrace_disabled))
-		return;
+	if (unlikely(ftrace_disabled) ||
+	    !ftrace_enabled || !ftraced_trigger)
+		return 0;

 	stop_machine_run(__ftrace_update_code, NULL, NR_CPUS);
+
+	return 1;
 }

 static int ftraced(void *ignore)
@@ -658,14 +689,13 @@ static int ftraced(void *ignore)

 		mutex_lock(&ftrace_sysctl_lock);
 		mutex_lock(&ftraced_lock);
-		if (ftrace_enabled && ftraced_trigger && !ftraced_suspend) {
-			ftrace_record_suspend++;
-			ftrace_update_code();
+		if (!ftraced_suspend && !ftraced_stop &&
+		    ftrace_update_code()) {
 			usecs = nsecs_to_usecs(ftrace_update_time);
 			if (ftrace_update_tot_cnt > 100000) {
 				ftrace_update_tot_cnt = 0;
 				pr_info("hm, dftrace overflow: %lu change%s"
-					 " (%lu total) in %lu usec%s\n",
+					" (%lu total) in %lu usec%s\n",
 					ftrace_update_cnt,
 					ftrace_update_cnt != 1 ? "s" : "",
 					ftrace_update_tot_cnt,
@@ -673,15 +703,10 @@ static int ftraced(void *ignore)
 				ftrace_disabled = 1;
 				WARN_ON_ONCE(1);
 			}
-			ftraced_trigger = 0;
-			ftrace_record_suspend--;
 		}
-		ftraced_iteration_counter++;
 		mutex_unlock(&ftraced_lock);
 		mutex_unlock(&ftrace_sysctl_lock);

-		wake_up_interruptible(&ftraced_waiters);
-
 		ftrace_shutdown_replenish();
 	}
 	__set_current_state(TASK_RUNNING);
@@ -1219,6 +1244,55 @@ ftrace_notrace_release(struct inode *ino
 	return ftrace_regex_release(inode, file, 0);
 }

+static ssize_t
+ftraced_read(struct file *filp, char __user *ubuf,
+		     size_t cnt, loff_t *ppos)
+{
+	/* don't worry about races */
+	char *buf = ftraced_stop ? "disabled\n" : "enabled\n";
+	int r = strlen(buf);
+
+	return simple_read_from_buffer(ubuf, cnt, ppos, buf, r);
+}
+
+static ssize_t
+ftraced_write(struct file *filp, const char __user *ubuf,
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
+	if (val)
+		ftrace_enable_daemon();
+	else
+		ftrace_disable_daemon();
+
+	filp->f_pos += cnt;
+
+	return cnt;
+}
+
 static struct file_operations ftrace_avail_fops = {
 	.open = ftrace_avail_open,
 	.read = seq_read,
@@ -1242,51 +1316,34 @@ static struct file_operations ftrace_not
 	.release = ftrace_notrace_release,
 };

+static struct file_operations ftraced_fops = {
+	.open = tracing_open_generic,
+	.read = ftraced_read,
+	.write = ftraced_write,
+};
+
 /**
  * ftrace_force_update - force an update to all recording ftrace functions
- *
- * The ftrace dynamic update daemon only wakes up once a second.
- * There may be cases where an update needs to be done immediately
- * for tests or internal kernel tracing to begin. This function
- * wakes the daemon to do an update and will not return until the
- * update is complete.
  */
 int ftrace_force_update(void)
 {
-	unsigned long last_counter;
-	DECLARE_WAITQUEUE(wait, current);
 	int ret = 0;

 	if (unlikely(ftrace_disabled))
 		return -ENODEV;

+	mutex_lock(&ftrace_sysctl_lock);
 	mutex_lock(&ftraced_lock);
-	last_counter = ftraced_iteration_counter;
-
-	set_current_state(TASK_INTERRUPTIBLE);
-	add_wait_queue(&ftraced_waiters, &wait);

-	if (unlikely(!ftraced_task)) {
-		ret = -ENODEV;
-		goto out;
-	}
-
-	do {
-		mutex_unlock(&ftraced_lock);
-		wake_up_process(ftraced_task);
-		schedule();
-		mutex_lock(&ftraced_lock);
-		if (signal_pending(current)) {
-			ret = -EINTR;
-			break;
-		}
-		set_current_state(TASK_INTERRUPTIBLE);
-	} while (last_counter == ftraced_iteration_counter);
+	/*
+	 * If ftraced_trigger is not set, then there is nothing
+	 * to update.
+	 */
+	if (ftraced_trigger && !ftrace_update_code())
+		ret = -EBUSY;

- out:
 	mutex_unlock(&ftraced_lock);
-	remove_wait_queue(&ftraced_waiters, &wait);
-	set_current_state(TASK_RUNNING);
+	mutex_unlock(&ftrace_sysctl_lock);

 	return ret;
 }
@@ -1331,6 +1388,12 @@ static __init int ftrace_init_debugfs(vo
 	if (!entry)
 		pr_warning("Could not create debugfs "
 			   "'set_ftrace_notrace' entry\n");
+
+	entry = debugfs_create_file("ftraced_enabled", 0644, d_tracer,
+				    NULL, &ftraced_fops);
+	if (!entry)
+		pr_warning("Could not create debugfs "
+			   "'ftraced_enabled' entry\n");
 	return 0;
 }


