Return-Path: <linux-kernel-owner+w=401wt.eu-S1756557AbYGVDGQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756557AbYGVDGQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 23:06:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755317AbYGVDGA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 23:06:00 -0400
Received: from casper.infradead.org ([85.118.1.10]:54911 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754932AbYGVDF7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 23:05:59 -0400
Subject: [RFC] schedule_timeout_range()
From: David Woodhouse <dwmw2@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       arjan@infradead.org
In-Reply-To: <1216695757.18980.16.camel@shinybook.infradead.org>
References: <1216695757.18980.16.camel@shinybook.infradead.org>
Content-Type: text/plain
Organization: Intel Corporation
Date: Mon, 21 Jul 2008 23:05:41 -0400
Message-Id: <1216695942.18980.19.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Along the same lines as the previous patch, this provides
schedule_timeout_range() for when the precise moment of wakeup doesn't
matter (and isn't worth wasting power on), but any time the CPU happens
to be awake within a given range of time is fine.

Implement schedule_timeout() using it, and likewise for the _killable,
_interruptible and _uninterruptible variants.

Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
---
 include/linux/sched.h |   16 +++++--
 kernel/timer.c        |  127 +++++++++++++++++++++++++++++++------------------
 2 files changed, 93 insertions(+), 50 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 1941d8b..5e9f5a9 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -325,12 +325,20 @@ extern char __sched_text_start[], __sched_text_end[];
 extern int in_sched_functions(unsigned long addr);
 
 #define	MAX_SCHEDULE_TIMEOUT	LONG_MAX
-extern signed long schedule_timeout(signed long timeout);
-extern signed long schedule_timeout_interruptible(signed long timeout);
-extern signed long schedule_timeout_killable(signed long timeout);
-extern signed long schedule_timeout_uninterruptible(signed long timeout);
+extern long schedule_timeout_range(long timeout, long deadline);
+extern long schedule_timeout_range_interruptible(long timeout, long deadline);
+extern long schedule_timeout_range_killable(long timeout, long deadline);
+extern long schedule_timeout_range_uninterruptible(long timeout, long deadline);
 asmlinkage void schedule(void);
 
+#define schedule_timeout(_t) schedule_timeout_range((_t), (_t))
+#define schedule_timeout_interruptible(_t) \
+	schedule_timeout_range_interruptible((_t), (_t))
+#define schedule_timeout_killable(_t) \
+	schedule_timeout_range_killable((_t), (_t))
+#define schedule_timeout_uninterruptible(_t) \
+	schedule_timeout_range_uninterruptible((_t), (_t))
+
 struct nsproxy;
 struct user_namespace;
 
diff --git a/kernel/timer.c b/kernel/timer.c
index e114f08..dd43c34 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -1144,11 +1144,12 @@ static void process_timeout(unsigned long __data)
 }
 
 /**
- * schedule_timeout - sleep until timeout
- * @timeout: timeout value in jiffies
+ * schedule_timeout_range - sleep until timeout
+ * @timeout: timeout value in jiffies, deferrable
+ * @deadline: hard deadline for timeout
  *
- * Make the current task sleep until @timeout jiffies have
- * elapsed. The routine will return immediately unless
+ * Make the current task sleep for a length of time between @timeout
+ * and @deadline jiffies. The routine will return immediately unless
  * the current task state has been set (see set_current_state()).
  *
  * You can set the task state as follows -
@@ -1169,81 +1170,115 @@ static void process_timeout(unsigned long __data)
  *
  * In all cases the return value is guaranteed to be non-negative.
  */
-signed long __sched schedule_timeout(signed long timeout)
+signed long __sched schedule_timeout_range(signed long timeout,
+					   signed long deadline)
 {
 	struct timer_list timer;
+	struct timer_list timer2;
 	unsigned long expire;
+	unsigned long expire2;
 
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
+	/*
+	 * This special case is useful to be comfortable
+	 * in the caller. Nothing more. We could take
+	 * MAX_SCHEDULE_TIMEOUT from one of the negative value
+	 * but I'd like to return a valid offset (>=0) to allow
+	 * the caller to do everything it want with the retval.
+	 */
+	if (timeout == MAX_SCHEDULE_TIMEOUT &&
+	    deadline == MAX_SCHEDULE_TIMEOUT) {
 		schedule();
 		goto out;
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
+	}
+       /*
+	* Another bit of PARANOIA. Note that the retval will be
+	* 0 since no piece of kernel is supposed to do a check
+	* for a negative retval of schedule_timeout() (since it
+	* should never happens anyway). You just have the printk()
+	* that will tell you if something is gone wrong and where.
+	*/
+	if (unlikely(timeout < 0)) {
+		printk(KERN_ERR "schedule_timeout: wrong timeout "
+		       "value %lx\n", timeout);
+		dump_stack();
+		current->state = TASK_RUNNING;
+		goto out;
+	}
+	if (unlikely(deadline < 0)) {
+		printk(KERN_ERR "schedule_timeout: wrong deadline "
+		       "value %lx\n", deadline);
+		dump_stack();
+		current->state = TASK_RUNNING;
+		goto out;
+	}
+	if (unlikely(timeout > deadline)) {
+		printk(KERN_ERR "schedule_timeout: deadline %lx earlier "
+		       "than initial timeout %lx\n", deadline, timeout);
+		timeout = deadline;
 	}
 
 	expire = timeout + jiffies;
+	expire2 = expire + deadline - timeout;
+
+	/* Don't bother to set up the deferrable timer if the deadline
+	   is at the same time */
+	if (timeout != deadline) {
+		setup_timer_on_stack(&timer, process_timeout,
+				     (unsigned long)current);
+		timer_set_deferrable(&timer);
+		__mod_timer(&timer, expire);
+	}
+	/* And don't bother with the deadline if it's infinite */
+ 	if (deadline != MAX_SCHEDULE_TIMEOUT) {
+		setup_timer_on_stack(&timer2, process_timeout,
+				     (unsigned long)current);
+		__mod_timer(&timer, expire2);
+	}
 
-	setup_timer_on_stack(&timer, process_timeout, (unsigned long)current);
-	__mod_timer(&timer, expire);
 	schedule();
-	del_singleshot_timer_sync(&timer);
-
-	/* Remove the timer from the object tracker */
-	destroy_timer_on_stack(&timer);
+	if (timeout != deadline) {
+		del_singleshot_timer_sync(&timer);
+		destroy_timer_on_stack(&timer);
+	}
+	if (deadline != MAX_SCHEDULE_TIMEOUT) {
+		del_singleshot_timer_sync(&timer2);
+		destroy_timer_on_stack(&timer2);
+	}
 
 	timeout = expire - jiffies;
 
  out:
 	return timeout < 0 ? 0 : timeout;
 }
-EXPORT_SYMBOL(schedule_timeout);
+EXPORT_SYMBOL(schedule_timeout_range);
 
 /*
  * We can use __set_current_state() here because schedule_timeout() calls
  * schedule() unconditionally.
  */
-signed long __sched schedule_timeout_interruptible(signed long timeout)
+signed long __sched schedule_timeout_range_interruptible(signed long timeout,
+							 signed long deadline)
 {
 	__set_current_state(TASK_INTERRUPTIBLE);
-	return schedule_timeout(timeout);
+	return schedule_timeout_range(timeout, deadline);
 }
-EXPORT_SYMBOL(schedule_timeout_interruptible);
+EXPORT_SYMBOL(schedule_timeout_range_interruptible);
 
-signed long __sched schedule_timeout_killable(signed long timeout)
+signed long __sched schedule_timeout_range_killable(signed long timeout,
+						    signed long deadline)
 {
 	__set_current_state(TASK_KILLABLE);
-	return schedule_timeout(timeout);
+	return schedule_timeout_range(timeout, deadline);
 }
-EXPORT_SYMBOL(schedule_timeout_killable);
+EXPORT_SYMBOL(schedule_timeout_range_killable);
 
-signed long __sched schedule_timeout_uninterruptible(signed long timeout)
+signed long __sched schedule_timeout_range_uninterruptible(signed long timeout,
+							   signed long deadline)
 {
 	__set_current_state(TASK_UNINTERRUPTIBLE);
-	return schedule_timeout(timeout);
+	return schedule_timeout_range(timeout, deadline);
 }
-EXPORT_SYMBOL(schedule_timeout_uninterruptible);
+EXPORT_SYMBOL(schedule_timeout_range_uninterruptible);
 
 /* Thread ID - the internal kernel "pid" */
 asmlinkage long sys_gettid(void)
-- 
1.5.5.1



-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation


