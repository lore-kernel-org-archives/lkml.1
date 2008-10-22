Return-Path: <linux-kernel-owner+w=401wt.eu-S1760107AbYJVS5z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760107AbYJVS5z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 14:57:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759911AbYJVS5H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 14:57:07 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:48892 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759178AbYJVS5F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 14:57:05 -0400
Message-Id: <20081022185137.029783366@goodmis.org>
References: <20081022184313.179487464@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 22 Oct 2008 14:43:22 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Abhishek Sagar <sagar.abhishek@gmail.com>,
       "David S. Miller" <davem@davemloft.net>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 09/11] ftrace: remove daemon
Content-Disposition: inline; filename=ftrace-remove-dynamic-daemon.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ftrace daemon is complex and error prone.  This patch strips it out
of the code.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/ftrace.c         |  280 ++++--------------------------------------
 kernel/trace/trace_selftest.c |   14 --
 2 files changed, 28 insertions(+), 266 deletions(-)

Index: linux-compile.git/kernel/trace/ftrace.c
===================================================================
--- linux-compile.git.orig/kernel/trace/ftrace.c	2008-10-22 13:21:42.000000000 -0400
+++ linux-compile.git/kernel/trace/ftrace.c	2008-10-22 13:21:46.000000000 -0400
@@ -171,21 +171,8 @@ static int __unregister_ftrace_function(
 }
 
 #ifdef CONFIG_DYNAMIC_FTRACE
-
 #ifndef CONFIG_FTRACE_MCOUNT_RECORD
-/*
- * The hash lock is only needed when the recording of the mcount
- * callers are dynamic. That is, by the caller themselves and
- * not recorded via the compilation.
- */
-static DEFINE_SPINLOCK(ftrace_hash_lock);
-#define ftrace_hash_lock(flags)	  spin_lock_irqsave(&ftrace_hash_lock, flags)
-#define ftrace_hash_unlock(flags) \
-			spin_unlock_irqrestore(&ftrace_hash_lock, flags)
-#else
-/* This is protected via the ftrace_lock with MCOUNT_RECORD. */
-#define ftrace_hash_lock(flags)   do { (void)(flags); } while (0)
-#define ftrace_hash_unlock(flags) do { } while(0)
+# error Dynamic ftrace depends on MCOUNT_RECORD
 #endif
 
 /*
@@ -196,8 +183,6 @@ static DEFINE_SPINLOCK(ftrace_hash_lock)
  */
 static unsigned long mcount_addr = MCOUNT_ADDR;
 
-static struct task_struct *ftraced_task;
-
 enum {
 	FTRACE_ENABLE_CALLS		= (1 << 0),
 	FTRACE_DISABLE_CALLS		= (1 << 1),
@@ -214,7 +199,6 @@ static struct hlist_head ftrace_hash[FTR
 
 static DEFINE_PER_CPU(int, ftrace_shutdown_disable_cpu);
 
-static DEFINE_MUTEX(ftraced_lock);
 static DEFINE_MUTEX(ftrace_regex_lock);
 
 struct ftrace_page {
@@ -232,10 +216,6 @@ struct ftrace_page {
 static struct ftrace_page	*ftrace_pages_start;
 static struct ftrace_page	*ftrace_pages;
 
-static int ftraced_trigger;
-static int ftraced_suspend;
-static int ftraced_stop;
-
 static int ftrace_record_suspend;
 
 static struct dyn_ftrace *ftrace_free_records;
@@ -399,7 +379,6 @@ static void
 ftrace_record_ip(unsigned long ip)
 {
 	struct dyn_ftrace *node;
-	unsigned long flags;
 	unsigned long key;
 	int resched;
 	int cpu;
@@ -431,24 +410,18 @@ ftrace_record_ip(unsigned long ip)
 	if (ftrace_ip_in_hash(ip, key))
 		goto out;
 
-	ftrace_hash_lock(flags);
-
 	/* This ip may have hit the hash before the lock */
 	if (ftrace_ip_in_hash(ip, key))
-		goto out_unlock;
+		goto out;
 
 	node = ftrace_alloc_dyn_node(ip);
 	if (!node)
-		goto out_unlock;
+		goto out;
 
 	node->ip = ip;
 
 	ftrace_add_hash(node, key);
 
-	ftraced_trigger = 1;
-
- out_unlock:
-	ftrace_hash_unlock(flags);
  out:
 	per_cpu(ftrace_shutdown_disable_cpu, cpu)--;
 
@@ -629,7 +602,7 @@ ftrace_code_disable(struct dyn_ftrace *r
 	return 1;
 }
 
-static int __ftrace_update_code(void *ignore);
+static int ftrace_update_code(void *ignore);
 
 static int __ftrace_modify_code(void *data)
 {
@@ -641,7 +614,7 @@ static int __ftrace_modify_code(void *da
 		 * Update any recorded ips now that we have the
 		 * machine stopped
 		 */
-		__ftrace_update_code(NULL);
+		ftrace_update_code(NULL);
 		ftrace_replace_code(1);
 		tracing_on = 1;
 	} else if (*command & FTRACE_DISABLE_CALLS) {
@@ -668,26 +641,9 @@ static void ftrace_run_update_code(int c
 	stop_machine(__ftrace_modify_code, &command, NULL);
 }
 
-void ftrace_disable_daemon(void)
-{
-	/* Stop the daemon from calling kstop_machine */
-	mutex_lock(&ftraced_lock);
-	ftraced_stop = 1;
-	mutex_unlock(&ftraced_lock);
-
-	ftrace_force_update();
-}
-
-void ftrace_enable_daemon(void)
-{
-	mutex_lock(&ftraced_lock);
-	ftraced_stop = 0;
-	mutex_unlock(&ftraced_lock);
-
-	ftrace_force_update();
-}
-
 static ftrace_func_t saved_ftrace_func;
+static int ftrace_start;
+static DEFINE_MUTEX(ftrace_start_lock);
 
 static void ftrace_startup(void)
 {
@@ -696,9 +652,9 @@ static void ftrace_startup(void)
 	if (unlikely(ftrace_disabled))
 		return;
 
-	mutex_lock(&ftraced_lock);
-	ftraced_suspend++;
-	if (ftraced_suspend == 1)
+	mutex_lock(&ftrace_start_lock);
+	ftrace_start++;
+	if (ftrace_start == 1)
 		command |= FTRACE_ENABLE_CALLS;
 
 	if (saved_ftrace_func != ftrace_trace_function) {
@@ -711,7 +667,7 @@ static void ftrace_startup(void)
 
 	ftrace_run_update_code(command);
  out:
-	mutex_unlock(&ftraced_lock);
+	mutex_unlock(&ftrace_start_lock);
 }
 
 static void ftrace_shutdown(void)
@@ -721,9 +677,9 @@ static void ftrace_shutdown(void)
 	if (unlikely(ftrace_disabled))
 		return;
 
-	mutex_lock(&ftraced_lock);
-	ftraced_suspend--;
-	if (!ftraced_suspend)
+	mutex_lock(&ftrace_start_lock);
+	ftrace_start--;
+	if (!ftrace_start)
 		command |= FTRACE_DISABLE_CALLS;
 
 	if (saved_ftrace_func != ftrace_trace_function) {
@@ -736,7 +692,7 @@ static void ftrace_shutdown(void)
 
 	ftrace_run_update_code(command);
  out:
-	mutex_unlock(&ftraced_lock);
+	mutex_unlock(&ftrace_start_lock);
 }
 
 static void ftrace_startup_sysctl(void)
@@ -746,15 +702,15 @@ static void ftrace_startup_sysctl(void)
 	if (unlikely(ftrace_disabled))
 		return;
 
-	mutex_lock(&ftraced_lock);
+	mutex_lock(&ftrace_start_lock);
 	/* Force update next time */
 	saved_ftrace_func = NULL;
-	/* ftraced_suspend is true if we want ftrace running */
-	if (ftraced_suspend)
+	/* ftrace_start is true if we want ftrace running */
+	if (ftrace_start)
 		command |= FTRACE_ENABLE_CALLS;
 
 	ftrace_run_update_code(command);
-	mutex_unlock(&ftraced_lock);
+	mutex_unlock(&ftrace_start_lock);
 }
 
 static void ftrace_shutdown_sysctl(void)
@@ -764,20 +720,20 @@ static void ftrace_shutdown_sysctl(void)
 	if (unlikely(ftrace_disabled))
 		return;
 
-	mutex_lock(&ftraced_lock);
-	/* ftraced_suspend is true if ftrace is running */
-	if (ftraced_suspend)
+	mutex_lock(&ftrace_start_lock);
+	/* ftrace_start is true if ftrace is running */
+	if (ftrace_start)
 		command |= FTRACE_DISABLE_CALLS;
 
 	ftrace_run_update_code(command);
-	mutex_unlock(&ftraced_lock);
+	mutex_unlock(&ftrace_start_lock);
 }
 
 static cycle_t		ftrace_update_time;
 static unsigned long	ftrace_update_cnt;
 unsigned long		ftrace_update_tot_cnt;
 
-static int __ftrace_update_code(void *ignore)
+static int ftrace_update_code(void *ignore)
 {
 	int i, save_ftrace_enabled;
 	cycle_t start, stop;
@@ -851,7 +807,6 @@ static int __ftrace_update_code(void *ig
 	stop = ftrace_now(raw_smp_processor_id());
 	ftrace_update_time = stop - start;
 	ftrace_update_tot_cnt += ftrace_update_cnt;
-	ftraced_trigger = 0;
 
 	ftrace_enabled = save_ftrace_enabled;
 	ftrace_record_suspend--;
@@ -859,17 +814,6 @@ static int __ftrace_update_code(void *ig
 	return 0;
 }
 
-static int ftrace_update_code(void)
-{
-	if (unlikely(ftrace_disabled) ||
-	    !ftrace_enabled || !ftraced_trigger)
-		return 0;
-
-	stop_machine(__ftrace_update_code, NULL, NULL);
-
-	return 1;
-}
-
 static int __init ftrace_dyn_table_alloc(unsigned long num_to_init)
 {
 	struct ftrace_page *pg;
@@ -1407,10 +1351,10 @@ ftrace_regex_release(struct inode *inode
 	}
 
 	mutex_lock(&ftrace_sysctl_lock);
-	mutex_lock(&ftraced_lock);
-	if (iter->filtered && ftraced_suspend && ftrace_enabled)
+	mutex_lock(&ftrace_start_lock);
+	if (iter->filtered && ftrace_start && ftrace_enabled)
 		ftrace_run_update_code(FTRACE_ENABLE_CALLS);
-	mutex_unlock(&ftraced_lock);
+	mutex_unlock(&ftrace_start_lock);
 	mutex_unlock(&ftrace_sysctl_lock);
 
 	kfree(iter);
@@ -1430,55 +1374,6 @@ ftrace_notrace_release(struct inode *ino
 	return ftrace_regex_release(inode, file, 0);
 }
 
-static ssize_t
-ftraced_read(struct file *filp, char __user *ubuf,
-		     size_t cnt, loff_t *ppos)
-{
-	/* don't worry about races */
-	char *buf = ftraced_stop ? "disabled\n" : "enabled\n";
-	int r = strlen(buf);
-
-	return simple_read_from_buffer(ubuf, cnt, ppos, buf, r);
-}
-
-static ssize_t
-ftraced_write(struct file *filp, const char __user *ubuf,
-		      size_t cnt, loff_t *ppos)
-{
-	char buf[64];
-	long val;
-	int ret;
-
-	if (cnt >= sizeof(buf))
-		return -EINVAL;
-
-	if (copy_from_user(&buf, ubuf, cnt))
-		return -EFAULT;
-
-	if (strncmp(buf, "enable", 6) == 0)
-		val = 1;
-	else if (strncmp(buf, "disable", 7) == 0)
-		val = 0;
-	else {
-		buf[cnt] = 0;
-
-		ret = strict_strtoul(buf, 10, &val);
-		if (ret < 0)
-			return ret;
-
-		val = !!val;
-	}
-
-	if (val)
-		ftrace_enable_daemon();
-	else
-		ftrace_disable_daemon();
-
-	filp->f_pos += cnt;
-
-	return cnt;
-}
-
 static struct file_operations ftrace_avail_fops = {
 	.open = ftrace_avail_open,
 	.read = seq_read,
@@ -1509,38 +1404,6 @@ static struct file_operations ftrace_not
 	.release = ftrace_notrace_release,
 };
 
-static struct file_operations ftraced_fops = {
-	.open = tracing_open_generic,
-	.read = ftraced_read,
-	.write = ftraced_write,
-};
-
-/**
- * ftrace_force_update - force an update to all recording ftrace functions
- */
-int ftrace_force_update(void)
-{
-	int ret = 0;
-
-	if (unlikely(ftrace_disabled))
-		return -ENODEV;
-
-	mutex_lock(&ftrace_sysctl_lock);
-	mutex_lock(&ftraced_lock);
-
-	/*
-	 * If ftraced_trigger is not set, then there is nothing
-	 * to update.
-	 */
-	if (ftraced_trigger && !ftrace_update_code())
-		ret = -EBUSY;
-
-	mutex_unlock(&ftraced_lock);
-	mutex_unlock(&ftrace_sysctl_lock);
-
-	return ret;
-}
-
 static __init int ftrace_init_debugfs(void)
 {
 	struct dentry *d_tracer;
@@ -1571,17 +1434,11 @@ static __init int ftrace_init_debugfs(vo
 		pr_warning("Could not create debugfs "
 			   "'set_ftrace_notrace' entry\n");
 
-	entry = debugfs_create_file("ftraced_enabled", 0644, d_tracer,
-				    NULL, &ftraced_fops);
-	if (!entry)
-		pr_warning("Could not create debugfs "
-			   "'ftraced_enabled' entry\n");
 	return 0;
 }
 
 fs_initcall(ftrace_init_debugfs);
 
-#ifdef CONFIG_FTRACE_MCOUNT_RECORD
 static int ftrace_convert_nops(unsigned long *start,
 			       unsigned long *end)
 {
@@ -1601,7 +1458,7 @@ static int ftrace_convert_nops(unsigned 
 
 	/* p is ignored */
 	local_irq_save(flags);
-	__ftrace_update_code(p);
+	ftrace_update_code(p);
 	local_irq_restore(flags);
 
 	return 0;
@@ -1648,84 +1505,6 @@ void __init ftrace_init(void)
  failed:
 	ftrace_disabled = 1;
 }
-#else /* CONFIG_FTRACE_MCOUNT_RECORD */
-static int ftraced(void *ignore)
-{
-	unsigned long usecs;
-
-	while (!kthread_should_stop()) {
-
-		set_current_state(TASK_INTERRUPTIBLE);
-
-		/* check once a second */
-		schedule_timeout(HZ);
-
-		if (unlikely(ftrace_disabled))
-			continue;
-
-		mutex_lock(&ftrace_sysctl_lock);
-		mutex_lock(&ftraced_lock);
-		if (!ftraced_suspend && !ftraced_stop &&
-		    ftrace_update_code()) {
-			usecs = nsecs_to_usecs(ftrace_update_time);
-			if (ftrace_update_tot_cnt > 100000) {
-				ftrace_update_tot_cnt = 0;
-				pr_info("hm, dftrace overflow: %lu change%s"
-					" (%lu total) in %lu usec%s\n",
-					ftrace_update_cnt,
-					ftrace_update_cnt != 1 ? "s" : "",
-					ftrace_update_tot_cnt,
-					usecs, usecs != 1 ? "s" : "");
-				FTRACE_WARN_ON_ONCE(1);
-			}
-		}
-		mutex_unlock(&ftraced_lock);
-		mutex_unlock(&ftrace_sysctl_lock);
-
-		ftrace_shutdown_replenish();
-	}
-	__set_current_state(TASK_RUNNING);
-	return 0;
-}
-
-static int __init ftrace_dynamic_init(void)
-{
-	struct task_struct *p;
-	unsigned long addr;
-	int ret;
-
-	addr = (unsigned long)ftrace_record_ip;
-
-	stop_machine(ftrace_dyn_arch_init, &addr, NULL);
-
-	/* ftrace_dyn_arch_init places the return code in addr */
-	if (addr) {
-		ret = (int)addr;
-		goto failed;
-	}
-
-	ret = ftrace_dyn_table_alloc(NR_TO_INIT);
-	if (ret)
-		goto failed;
-
-	p = kthread_run(ftraced, NULL, "ftraced");
-	if (IS_ERR(p)) {
-		ret = -1;
-		goto failed;
-	}
-
-	last_ftrace_enabled = ftrace_enabled = 1;
-	ftraced_task = p;
-
-	return 0;
-
- failed:
-	ftrace_disabled = 1;
-	return ret;
-}
-
-core_initcall(ftrace_dynamic_init);
-#endif /* CONFIG_FTRACE_MCOUNT_RECORD */
 
 #else
 # define ftrace_startup()		do { } while (0)
@@ -1745,9 +1524,6 @@ void ftrace_kill(void)
 {
 	ftrace_disabled = 1;
 	ftrace_enabled = 0;
-#ifdef CONFIG_DYNAMIC_FTRACE
-	ftraced_suspend = -1;
-#endif
 	clear_ftrace_function();
 }
 
Index: linux-compile.git/kernel/trace/trace_selftest.c
===================================================================
--- linux-compile.git.orig/kernel/trace/trace_selftest.c	2008-10-22 13:21:42.000000000 -0400
+++ linux-compile.git/kernel/trace/trace_selftest.c	2008-10-22 13:21:46.000000000 -0400
@@ -99,13 +99,6 @@ int trace_selftest_startup_dynamic_traci
 	/* passed in by parameter to fool gcc from optimizing */
 	func();
 
-	/* update the records */
-	ret = ftrace_force_update();
-	if (ret) {
-		printk(KERN_CONT ".. ftraced failed .. ");
-		return ret;
-	}
-
 	/*
 	 * Some archs *cough*PowerPC*cough* add charachters to the
 	 * start of the function names. We simply put a '*' to
@@ -183,13 +176,6 @@ trace_selftest_startup_function(struct t
 	/* make sure msleep has been recorded */
 	msleep(1);
 
-	/* force the recorded functions to be traced */
-	ret = ftrace_force_update();
-	if (ret) {
-		printk(KERN_CONT ".. ftraced failed .. ");
-		return ret;
-	}
-
 	/* start the tracing */
 	ftrace_enabled = 1;
 	tracer_enabled = 1;

-- 
