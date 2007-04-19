Return-Path: <linux-kernel-owner+w=401wt.eu-S637739AbXDSMFu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S637739AbXDSMFu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 08:05:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993254AbXDSMFu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 08:05:50 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:53579 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993246AbXDSMFs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 08:05:48 -0400
Date: Thu, 19 Apr 2007 17:34:19 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: Oleg Nesterov <oleg@tv-sign.ru>, "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@elte.hu,
       vatsa@in.ibm.com, paulmck@us.ibm.com, pavel@ucw.cz
Subject: [RFC PATCH(experimental) 2/2] Fix freezer-kthread_stop race
Message-ID: <20070419120419.GB17069@in.ibm.com>
Reply-To: ego@in.ibm.com
References: <20070419120131.GB13435@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070419120131.GB13435@in.ibm.com>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Threads which wait for completion on a frozen thread might result in 
causing the freezer to fail, if the waiting thread is freezeable.

There are some well known cases where it's preferable to temporarily thaw
the frozen process, finish the wait for completion and allow both the 
processes to call try_to_freeze. 

kthread_stop is one such case. flush_workqueue might be another. 

This patch attempts to address such a situation with a fix for kthread_stop.

Strictly experimental. Compile tested on i386.

Signed-off-by: Gautham R Shenoy <ego@in.ibm.com>

---
 include/asm-arm/thread_info.h      |    2 
 include/asm-blackfin/thread_info.h |    4 +
 include/asm-frv/thread_info.h      |    4 +
 include/asm-i386/thread_info.h     |    4 +
 include/asm-ia64/thread_info.h     |    4 +
 include/asm-mips/thread_info.h     |    2 
 include/asm-powerpc/thread_info.h  |    4 +
 include/asm-sh/thread_info.h       |    2 
 include/asm-x86_64/thread_info.h   |    4 +
 include/linux/freezer.h            |    4 +
 kernel/kthread.c                   |    4 +
 kernel/power/process.c             |   81 ++++++++++++++++++++++++++++++++++++-
 12 files changed, 118 insertions(+), 1 deletion(-)

Index: linux-2.6.21-rc6/kernel/power/process.c
===================================================================
--- linux-2.6.21-rc6.orig/kernel/power/process.c
+++ linux-2.6.21-rc6/kernel/power/process.c
@@ -23,6 +23,16 @@
 #define FREEZER_KERNEL_THREADS 0
 #define FREEZER_USER_SPACE 1
 
+struct freezer_status_struct {
+	spinlock_t lock;
+	int count;
+};
+
+static struct freezer_status_struct freezer_status = {
+				.lock = SPIN_LOCK_UNLOCKED,
+				.count = 0,
+			};
+
 static inline int freezeable(struct task_struct * p)
 {
 	if ((p == current) ||
@@ -45,7 +55,8 @@ void refrigerator(void)
 		 * *after* the freezer did the freezeable() check
 		 * on us.
 		 */
-		if (current->flags & PF_NOFREEZE) {
+		if ((current->flags & PF_NOFREEZE) ||
+		    test_tsk_thread_flag(current, TIF_FREEZER_HELD)) {
 			clear_tsk_thread_flag(current, TIF_FREEZE);
 			task_unlock(current);
 			return;
@@ -63,12 +74,16 @@ void refrigerator(void)
 	recalc_sigpending(); /* We sent fake signal, clean it up */
 	spin_unlock_irq(&current->sighand->siglock);
 
+	task_lock(current);
 	for (;;) {
 		set_current_state(TASK_UNINTERRUPTIBLE);
 		if (!frozen(current))
 			break;
+		task_unlock(current);
 		schedule();
+		task_lock(current);
 	}
+	task_unlock(current);
 	pr_debug("%s left refrigerator\n", current->comm);
 	current->state = save;
 }
@@ -114,6 +129,47 @@ static inline int is_user_space(struct t
 	return ret;
 }
 
+/*
+ * Delay the freezer from declaring the system as frozen,
+ * if it is not frozen already.
+ *
+ * Usage:
+ * int result = hold_freezer_for_task(p);
+ * wait_for_completion(something_which_p_completes);
+ * release_freezer(p, result);
+ */
+
+int hold_freezer_for_task(struct task_struct *p)
+{
+	int ret = 0;
+	spin_lock(&freezer_status.lock);
+	if (freezer_status.count >= 0)
+	{
+		set_tsk_thread_flag(p, TIF_FREEZER_HELD);
+		thaw_process(p);
+		freezer_status.count++;
+		ret = 1;
+	}
+	spin_unlock(&freezer_status.lock);
+
+	return ret;
+}
+
+/*
+ * Allow freezer to function normally as before.
+ * Usage: See the comment above definition of hold_freezer_for_task()
+ */
+void release_freezer(struct task_struct *p, int result)
+{
+	if (result) {
+		spin_lock(&freezer_status.lock);
+		BUG_ON(freezer_status.count <= 0);
+		clear_tsk_thread_flag(p, TIF_FREEZER_HELD);
+		freezer_status.count--;
+		spin_unlock(&freezer_status.lock);
+	}
+
+}
 static unsigned int try_to_freeze_tasks(int freeze_user_space)
 {
 	struct task_struct *g, *p;
@@ -146,6 +202,22 @@ static unsigned int try_to_freeze_tasks(
 		yield();			/* Yield is okay here */
 		if (todo && time_after(jiffies, end_time))
 			break;
+
+		if (!freeze_user_space && !todo) {
+			spin_lock(&freezer_status.lock);
+			if (freezer_status.count == 0)
+				freezer_status.count--;
+			else {
+				spin_unlock(&freezer_status.lock);
+				/* check once more for any unfrozen
+				 * tasks. someone might have thawed
+				 * a task temporarily.
+				 */
+				continue;
+			}
+			spin_unlock(&freezer_status.lock);
+		}
+
 	} while (todo);
 
 	if (todo) {
@@ -219,6 +291,13 @@ static void thaw_tasks(int thaw_user_spa
 		thaw_process(p);
 	} while_each_thread(g, p);
 	read_unlock(&tasklist_lock);
+
+	if (thaw_user_space) {
+		spin_lock(&freezer_status.lock);
+			if (freezer_status.count < 0)
+				freezer_status.count++;
+		spin_unlock(&freezer_status.lock);
+	}
 }
 
 void thaw_processes(void)
Index: linux-2.6.21-rc6/include/linux/freezer.h
===================================================================
--- linux-2.6.21-rc6.orig/include/linux/freezer.h
+++ linux-2.6.21-rc6/include/linux/freezer.h
@@ -65,6 +65,8 @@ static inline void frozen_process(struct
 extern void refrigerator(void);
 extern int freeze_processes(void);
 extern void thaw_processes(void);
+extern int hold_freezer_for_task(struct task_struct *p);
+extern void release_freezer(struct task_struct *p, int result);
 
 static inline int try_to_freeze(void)
 {
@@ -125,6 +127,8 @@ static inline int freezing(struct task_s
 static inline void freeze(struct task_struct *p) { BUG(); }
 static inline int thaw_process(struct task_struct *p) { return 1; }
 static inline void frozen_process(struct task_struct *p) { BUG(); }
+static inline int hold_freezer_for_task(struct task_struct *p) { return 0;}
+static inline void release_freezer(struct task_struct *p, int result) {}
 
 static inline void refrigerator(void) {}
 static inline int freeze_processes(void) { BUG(); return 0; }
Index: linux-2.6.21-rc6/kernel/kthread.c
===================================================================
--- linux-2.6.21-rc6.orig/kernel/kthread.c
+++ linux-2.6.21-rc6/kernel/kthread.c
@@ -14,6 +14,7 @@
 #include <linux/module.h>
 #include <linux/mutex.h>
 #include <asm/semaphore.h>
+#include <linux/freezer.h>
 
 /*
  * We dont want to execute off keventd since it might
@@ -220,6 +221,7 @@ EXPORT_SYMBOL(kthread_bind);
 int kthread_stop(struct task_struct *k)
 {
 	int ret;
+	int freezer_is_held;
 
 	mutex_lock(&kthread_stop_lock);
 
@@ -236,7 +238,9 @@ int kthread_stop(struct task_struct *k)
 	put_task_struct(k);
 
 	/* Once it dies, reset stop ptr, gather result and we're done. */
+	freezer_is_held = hold_freezer_for_task(k);
 	wait_for_completion(&kthread_stop_info.done);
+	release_freezer(k, freezer_is_held);
 	kthread_stop_info.k = NULL;
 	ret = kthread_stop_info.err;
 	mutex_unlock(&kthread_stop_lock);
Index: linux-2.6.21-rc6/include/asm-arm/thread_info.h
===================================================================
--- linux-2.6.21-rc6.orig/include/asm-arm/thread_info.h
+++ linux-2.6.21-rc6/include/asm-arm/thread_info.h
@@ -148,6 +148,7 @@ extern void iwmmxt_task_switch(struct th
 #define TIF_USING_IWMMXT	17
 #define TIF_MEMDIE		18
 #define TIF_FREEZE		19
+#define TIF_FREEZER_HELD	20
 
 #define _TIF_NOTIFY_RESUME	(1 << TIF_NOTIFY_RESUME)
 #define _TIF_SIGPENDING		(1 << TIF_SIGPENDING)
@@ -156,6 +157,7 @@ extern void iwmmxt_task_switch(struct th
 #define _TIF_POLLING_NRFLAG	(1 << TIF_POLLING_NRFLAG)
 #define _TIF_USING_IWMMXT	(1 << TIF_USING_IWMMXT)
 #define _TIF_FREEZE		(1 << TIF_FREEZE)
+#define _TIF_FREEZER_HELD	(1 << TIF_FREEZER_HELD)
 
 /*
  * Change these and you break ASM code in entry-common.S
Index: linux-2.6.21-rc6/include/asm-blackfin/thread_info.h
===================================================================
--- linux-2.6.21-rc6.orig/include/asm-blackfin/thread_info.h
+++ linux-2.6.21-rc6/include/asm-blackfin/thread_info.h
@@ -127,6 +127,9 @@ static inline struct thread_info *curren
 #define TIF_RESTORE_SIGMASK	6	/* restore signal mask in do_signal() */
 #define TIF_FREEZE              7       /* is freezing for suspend */
 #define TIF_SINGLESTEP		8       /* restore singlestep on return to user mode */
+#define TIF_FREEZER_HELD	9	/* Thread is temporarily holding up
+					 * the process freezer
+					 */
 
 /* as above, but as bit values */
 #define _TIF_SYSCALL_TRACE	(1<<TIF_SYSCALL_TRACE)
@@ -137,6 +140,7 @@ static inline struct thread_info *curren
 #define _TIF_RESTORE_SIGMASK	(1<<TIF_RESTORE_SIGMASK)
 #define _TIF_FREEZE             (1<<TIF_FREEZE)
 #define _TIF_SINGLESTEP		(1<<TIF_SINGLESTEP)
+#define _TIF_FREEZER_HELD	(1<<TIF_FREEZER_HELD)
 
 #define _TIF_WORK_MASK		0x0000FFFE	/* work to do on interrupt/exception return */
 
Index: linux-2.6.21-rc6/include/asm-frv/thread_info.h
===================================================================
--- linux-2.6.21-rc6.orig/include/asm-frv/thread_info.h
+++ linux-2.6.21-rc6/include/asm-frv/thread_info.h
@@ -117,6 +117,9 @@ register struct thread_info *__current_t
 #define TIF_POLLING_NRFLAG	16	/* true if poll_idle() is polling TIF_NEED_RESCHED */
 #define TIF_MEMDIE		17	/* OOM killer killed process */
 #define TIF_FREEZE		18	/* freezing for suspend */
+#define TIF_FREEZER_HELD	19	/* Thread is holding up freezer
+					 * temporarily.
+					 */
 
 #define _TIF_SYSCALL_TRACE	(1 << TIF_SYSCALL_TRACE)
 #define _TIF_NOTIFY_RESUME	(1 << TIF_NOTIFY_RESUME)
@@ -127,6 +130,7 @@ register struct thread_info *__current_t
 #define _TIF_RESTORE_SIGMASK	(1 << TIF_RESTORE_SIGMASK)
 #define _TIF_POLLING_NRFLAG	(1 << TIF_POLLING_NRFLAG)
 #define _TIF_FREEZE		(1 << TIF_FREEZE)
+#define _TIF_FREEZER_HELD	(1 << TIF_FREEZER_HELD)
 
 #define _TIF_WORK_MASK		0x0000FFFE	/* work to do on interrupt/exception return */
 #define _TIF_ALLWORK_MASK	0x0000FFFF	/* work to do on any return to u-space */
Index: linux-2.6.21-rc6/include/asm-i386/thread_info.h
===================================================================
--- linux-2.6.21-rc6.orig/include/asm-i386/thread_info.h
+++ linux-2.6.21-rc6/include/asm-i386/thread_info.h
@@ -137,6 +137,9 @@ static inline struct thread_info *curren
 #define TIF_IO_BITMAP		18	/* uses I/O bitmap */
 #define TIF_FREEZE		19	/* is freezing for suspend */
 #define TIF_FORCED_TF		20	/* true if TF in eflags artificially */
+#define TIF_FREEZER_HELD	21	/* is temporarily holding up process
+					 * freezer
+					 */
 
 #define _TIF_SYSCALL_TRACE	(1<<TIF_SYSCALL_TRACE)
 #define _TIF_NOTIFY_RESUME	(1<<TIF_NOTIFY_RESUME)
@@ -151,6 +154,7 @@ static inline struct thread_info *curren
 #define _TIF_IO_BITMAP		(1<<TIF_IO_BITMAP)
 #define _TIF_FREEZE		(1<<TIF_FREEZE)
 #define _TIF_FORCED_TF		(1<<TIF_FORCED_TF)
+#define _TIF_FREEZER_HELD	(1<<TIF_FREEZER_HELD)
 
 /* work to do on interrupt/exception return */
 #define _TIF_WORK_MASK \
Index: linux-2.6.21-rc6/include/asm-ia64/thread_info.h
===================================================================
--- linux-2.6.21-rc6.orig/include/asm-ia64/thread_info.h
+++ linux-2.6.21-rc6/include/asm-ia64/thread_info.h
@@ -90,6 +90,9 @@ struct thread_info {
 #define TIF_MCA_INIT		18	/* this task is processing MCA or INIT */
 #define TIF_DB_DISABLED		19	/* debug trap disabled for fsyscall */
 #define TIF_FREEZE		20	/* is freezing for suspend */
+#define TIF_FREEZER_HELD	21	/* is temporarily holding up the
+					 * process freezer
+					 */
 
 #define _TIF_SYSCALL_TRACE	(1 << TIF_SYSCALL_TRACE)
 #define _TIF_SYSCALL_AUDIT	(1 << TIF_SYSCALL_AUDIT)
@@ -102,6 +105,7 @@ struct thread_info {
 #define _TIF_MCA_INIT		(1 << TIF_MCA_INIT)
 #define _TIF_DB_DISABLED	(1 << TIF_DB_DISABLED)
 #define _TIF_FREEZE		(1 << TIF_FREEZE)
+#define _TIF_FREEZER_HELD	(1 << TIF_FREEZER_HELD)
 
 /* "work to do on user-return" bits */
 #define TIF_ALLWORK_MASK	(_TIF_NOTIFY_RESUME|_TIF_SIGPENDING|_TIF_NEED_RESCHED|_TIF_SYSCALL_TRACE|_TIF_SYSCALL_AUDIT)
Index: linux-2.6.21-rc6/include/asm-mips/thread_info.h
===================================================================
--- linux-2.6.21-rc6.orig/include/asm-mips/thread_info.h
+++ linux-2.6.21-rc6/include/asm-mips/thread_info.h
@@ -120,6 +120,7 @@ register struct thread_info *__current_t
 #define TIF_MEMDIE		18
 #define TIF_FREEZE		19
 #define TIF_ALLOW_FP_IN_KERNEL	20
+#define TIF_FREEZER_HELD	21
 #define TIF_SYSCALL_TRACE	31	/* syscall trace active */
 
 #define _TIF_SYSCALL_TRACE	(1<<TIF_SYSCALL_TRACE)
@@ -132,6 +133,7 @@ register struct thread_info *__current_t
 #define _TIF_USEDFPU		(1<<TIF_USEDFPU)
 #define _TIF_POLLING_NRFLAG	(1<<TIF_POLLING_NRFLAG)
 #define _TIF_FREEZE		(1<<TIF_FREEZE)
+#define _TIF_FREEZER_HELD	(1<<TIF_FREEZER_HELD)
 
 /* work to do on interrupt/exception return */
 #define _TIF_WORK_MASK		(0x0000ffef & ~_TIF_SECCOMP)
Index: linux-2.6.21-rc6/include/asm-powerpc/thread_info.h
===================================================================
--- linux-2.6.21-rc6.orig/include/asm-powerpc/thread_info.h
+++ linux-2.6.21-rc6/include/asm-powerpc/thread_info.h
@@ -123,6 +123,9 @@ static inline struct thread_info *curren
 #define TIF_NOERROR		14	/* Force successful syscall return */
 #define TIF_RESTORE_SIGMASK	15	/* Restore signal mask in do_signal */
 #define TIF_FREEZE		16	/* Freezing for suspend */
+#define TIF_FREEZER_HELD	17	/* Is temporarily holding up the
+					 * process freezer.
+					 */
 
 /* as above, but as bit values */
 #define _TIF_SYSCALL_TRACE	(1<<TIF_SYSCALL_TRACE)
@@ -140,6 +143,7 @@ static inline struct thread_info *curren
 #define _TIF_NOERROR		(1<<TIF_NOERROR)
 #define _TIF_RESTORE_SIGMASK	(1<<TIF_RESTORE_SIGMASK)
 #define _TIF_FREEZE		(1<<TIF_FREEZE)
+#define _TIF_FREEZER_HELD	(1<<TIF_FREEZER_HELD)
 #define _TIF_SYSCALL_T_OR_A	(_TIF_SYSCALL_TRACE|_TIF_SYSCALL_AUDIT|_TIF_SECCOMP)
 
 #define _TIF_USER_WORK_MASK	(_TIF_NOTIFY_RESUME | _TIF_SIGPENDING | \
Index: linux-2.6.21-rc6/include/asm-sh/thread_info.h
===================================================================
--- linux-2.6.21-rc6.orig/include/asm-sh/thread_info.h
+++ linux-2.6.21-rc6/include/asm-sh/thread_info.h
@@ -116,6 +116,7 @@ static inline struct thread_info *curren
 #define TIF_POLLING_NRFLAG	17	/* true if poll_idle() is polling TIF_NEED_RESCHED */
 #define TIF_MEMDIE		18
 #define TIF_FREEZE		19
+#define TIF_FREEZER_HELD	20
 
 #define _TIF_SYSCALL_TRACE	(1<<TIF_SYSCALL_TRACE)
 #define _TIF_NOTIFY_RESUME	(1<<TIF_NOTIFY_RESUME)
@@ -126,6 +127,7 @@ static inline struct thread_info *curren
 #define _TIF_USEDFPU		(1<<TIF_USEDFPU)
 #define _TIF_POLLING_NRFLAG	(1<<TIF_POLLING_NRFLAG)
 #define _TIF_FREEZE		(1<<TIF_FREEZE)
+#define _TIF_FREEZER_HELD	(1<<TIF_FREEZER_HELD)
 
 #define _TIF_WORK_MASK		0x000000FE	/* work to do on interrupt/exception return */
 #define _TIF_ALLWORK_MASK	0x000000FF	/* work to do on any return to u-space */
Index: linux-2.6.21-rc6/include/asm-x86_64/thread_info.h
===================================================================
--- linux-2.6.21-rc6.orig/include/asm-x86_64/thread_info.h
+++ linux-2.6.21-rc6/include/asm-x86_64/thread_info.h
@@ -123,6 +123,9 @@ static inline struct thread_info *stack_
 #define TIF_DEBUG		21	/* uses debug registers */
 #define TIF_IO_BITMAP		22	/* uses I/O bitmap */
 #define TIF_FREEZE		23	/* is freezing for suspend */
+#define TIF_FREEZER_HELD	24	/* is temporarily holding up the
+					 * process freezer
+					 */
 
 #define _TIF_SYSCALL_TRACE	(1<<TIF_SYSCALL_TRACE)
 #define _TIF_NOTIFY_RESUME	(1<<TIF_NOTIFY_RESUME)
@@ -140,6 +143,7 @@ static inline struct thread_info *stack_
 #define _TIF_DEBUG		(1<<TIF_DEBUG)
 #define _TIF_IO_BITMAP		(1<<TIF_IO_BITMAP)
 #define _TIF_FREEZE		(1<<TIF_FREEZE)
+#define _TIF_FREEZER_HELD	(1<<TIF_FREEZER_HELD)
 
 /* work to do on interrupt/exception return */
 #define _TIF_WORK_MASK \
-- 
Gautham R Shenoy
Linux Technology Center
IBM India.
"Freedom comes with a price tag of responsibility, which is still a bargain,
because Freedom is priceless!"
