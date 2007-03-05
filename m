Return-Path: <linux-kernel-owner+w=401wt.eu-S1752572AbXCEA3w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752572AbXCEA3w (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 19:29:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752570AbXCEA32
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 19:29:28 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:57755 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752571AbXCEA3Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 19:29:24 -0500
Message-Id: <20070305002633.087180539@arndb.de>
References: <20070305002024.875968120@arndb.de>
User-Agent: quilt/0.45-1
Date: Mon, 05 Mar 2007 01:20:27 +0100
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>
Subject: [RFC PATCH 3/3] change schedule_timeout to use hrtimers
Content-Disposition: inline; filename=implement-schedule-timeout-using-hr.patch
X-Provags-ID: kundenserver.de abuse@kundenserver.de login:c48f057754fc1b1a557605ab9fa6da41
X-Provags-ID2: V01U2FsdGVkX18Hc8vIYYw36+xPthApFxj8RzP2MYOCQFb7In0
 YJ9JvPX0gvdheXqrzcKEf9qiIB6PyTPGdJvKLe0mX2bNbDg3qP
 UdfFsJqTykaqCY3qxCVOw==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

According to the new timer statistics, many of the
timers that expire come from schedule_timeout.
Since the regular timer infrastructure is optimized
for timers that don't expire, this might be a useful
optimization.

This also changes the timer stats to show the caller
of schedule_timeout in the statistics rather than
schedule_timeout itself.

BUG: converting between jiffies and ktime is rather
     inefficient here.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Index: linux-cg/kernel/hrtimer.c
===================================================================
--- linux-cg.orig/kernel/hrtimer.c
+++ linux-cg/kernel/hrtimer.c
@@ -1254,6 +1254,96 @@ fastcall ktime_t __sched schedule_timeou
 }
 EXPORT_SYMBOL_GPL(schedule_timeout_hr);
 
+/**
+ * schedule_timeout - sleep until timeout
+ * @timeout: timeout value in jiffies
+ *
+ * Make the current task sleep until @timeout jiffies have
+ * elapsed. The routine will return immediately unless
+ * the current task state has been set (see set_current_state()).
+ *
+ * You can set the task state as follows -
+ *
+ * %TASK_UNINTERRUPTIBLE - at least @timeout jiffies are guaranteed to
+ * pass before the routine returns. The routine will return 0
+ *
+ * %TASK_INTERRUPTIBLE - the routine may return early if a signal is
+ * delivered to the current task. In this case the remaining time
+ * in jiffies will be returned, or 0 if the timer expired in time
+ *
+ * The current task state is guaranteed to be TASK_RUNNING when this
+ * routine returns.
+ *
+ * Specifying a @timeout value of %MAX_SCHEDULE_TIMEOUT will schedule
+ * the CPU away without a bound on the timeout. In this case the return
+ * value will be %MAX_SCHEDULE_TIMEOUT.
+ *
+ * In all cases the return value is guaranteed to be non-negative.
+ */
+fastcall signed long __sched schedule_timeout(signed long timeout)
+{
+	ktime_t time;
+	struct timespec ts;
+
+	switch (timeout)
+	{
+	case MAX_SCHEDULE_TIMEOUT:
+		/*
+		 * These two special cases are useful to be comfortable
+		 * in the caller. Nothing more. We could take
+		 * MAX_SCHEDULE_TIMEOUT from one of the negative value
+		 * but I' d like to return a valid offset (>=0) to allow
+		 * the caller to do everything it want with the retval.
+		 */
+		schedule();
+		goto out;
+	default:
+		/*
+		 * Another bit of PARANOID. Note that the retval will be
+		 * 0 since no piece of kernel is supposed to do a check
+		 * for a negative retval of schedule_timeout() (since it
+		 * should never happens anyway). You just have the printk()
+		 * that will tell you if something is gone wrong and where.
+		 */
+		if (timeout < 0) {
+			printk(KERN_ERR "schedule_timeout: wrong timeout "
+				"value %lx\n", timeout);
+			dump_stack();
+			current->state = TASK_RUNNING;
+			goto out;
+		}
+	}
+
+	/* FIXME: there ought to be an efficient ktime_to_jiffies
+	 *        and ktime_to_jiffies */
+	jiffies_to_timespec(timeout, &ts);
+	time = timespec_to_ktime(ts);
+	time = __schedule_timeout_hr(time, __builtin_return_address(0));
+	ts = ktime_to_timespec(time);
+	timeout = timespec_to_jiffies(&ts);
+ out:
+	return timeout < 0 ? 0 : timeout;
+}
+EXPORT_SYMBOL(schedule_timeout);
+
+/*
+ * We can use __set_current_state() here because schedule_timeout() calls
+ * schedule() unconditionally.
+ */
+signed long __sched schedule_timeout_interruptible(signed long timeout)
+{
+	__set_current_state(TASK_INTERRUPTIBLE);
+	return schedule_timeout(timeout);
+}
+EXPORT_SYMBOL(schedule_timeout_interruptible);
+
+signed long __sched schedule_timeout_uninterruptible(signed long timeout)
+{
+	__set_current_state(TASK_UNINTERRUPTIBLE);
+	return schedule_timeout(timeout);
+}
+EXPORT_SYMBOL(schedule_timeout_uninterruptible);
+
 static int __sched do_nanosleep(struct hrtimer_sleeper *t, enum hrtimer_mode mode)
 {
 	hrtimer_init_sleeper(t, current);
Index: linux-cg/kernel/timer.c
===================================================================
--- linux-cg.orig/kernel/timer.c
+++ linux-cg/kernel/timer.c
@@ -1369,103 +1369,6 @@ asmlinkage long sys_getegid(void)
 
 #endif
 
-static void process_timeout(unsigned long __data)
-{
-	wake_up_process((struct task_struct *)__data);
-}
-
-/**
- * schedule_timeout - sleep until timeout
- * @timeout: timeout value in jiffies
- *
- * Make the current task sleep until @timeout jiffies have
- * elapsed. The routine will return immediately unless
- * the current task state has been set (see set_current_state()).
- *
- * You can set the task state as follows -
- *
- * %TASK_UNINTERRUPTIBLE - at least @timeout jiffies are guaranteed to
- * pass before the routine returns. The routine will return 0
- *
- * %TASK_INTERRUPTIBLE - the routine may return early if a signal is
- * delivered to the current task. In this case the remaining time
- * in jiffies will be returned, or 0 if the timer expired in time
- *
- * The current task state is guaranteed to be TASK_RUNNING when this
- * routine returns.
- *
- * Specifying a @timeout value of %MAX_SCHEDULE_TIMEOUT will schedule
- * the CPU away without a bound on the timeout. In this case the return
- * value will be %MAX_SCHEDULE_TIMEOUT.
- *
- * In all cases the return value is guaranteed to be non-negative.
- */
-fastcall signed long __sched schedule_timeout(signed long timeout)
-{
-	struct timer_list timer;
-	unsigned long expire;
-
-	switch (timeout)
-	{
-	case MAX_SCHEDULE_TIMEOUT:
-		/*
-		 * These two special cases are useful to be comfortable
-		 * in the caller. Nothing more. We could take
-		 * MAX_SCHEDULE_TIMEOUT from one of the negative value
-		 * but I' d like to return a valid offset (>=0) to allow
-		 * the caller to do everything it want with the retval.
-		 */
-		schedule();
-		goto out;
-	default:
-		/*
-		 * Another bit of PARANOID. Note that the retval will be
-		 * 0 since no piece of kernel is supposed to do a check
-		 * for a negative retval of schedule_timeout() (since it
-		 * should never happens anyway). You just have the printk()
-		 * that will tell you if something is gone wrong and where.
-		 */
-		if (timeout < 0) {
-			printk(KERN_ERR "schedule_timeout: wrong timeout "
-				"value %lx\n", timeout);
-			dump_stack();
-			current->state = TASK_RUNNING;
-			goto out;
-		}
-	}
-
-	expire = timeout + jiffies;
-
-	setup_timer(&timer, process_timeout, (unsigned long)current);
-	__mod_timer(&timer, expire);
-	schedule();
-	del_singleshot_timer_sync(&timer);
-
-	timeout = expire - jiffies;
-
- out:
-	return timeout < 0 ? 0 : timeout;
-}
-EXPORT_SYMBOL(schedule_timeout);
-
-/*
- * We can use __set_current_state() here because schedule_timeout() calls
- * schedule() unconditionally.
- */
-signed long __sched schedule_timeout_interruptible(signed long timeout)
-{
-	__set_current_state(TASK_INTERRUPTIBLE);
-	return schedule_timeout(timeout);
-}
-EXPORT_SYMBOL(schedule_timeout_interruptible);
-
-signed long __sched schedule_timeout_uninterruptible(signed long timeout)
-{
-	__set_current_state(TASK_UNINTERRUPTIBLE);
-	return schedule_timeout(timeout);
-}
-EXPORT_SYMBOL(schedule_timeout_uninterruptible);
-
 /* Thread ID - the internal kernel "pid" */
 asmlinkage long sys_gettid(void)
 {

--

