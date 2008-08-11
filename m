Return-Path: <linux-kernel-owner+w=401wt.eu-S1758462AbYHKXyt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758462AbYHKXyt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 19:54:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757571AbYHKXxn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 19:53:43 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:35422 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757403AbYHKXxk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 19:53:40 -0400
Message-Id: <20080811235324.661871296@us.ibm.com>
References: <20080811235323.872291138@us.ibm.com>
User-Agent: quilt/0.46-1
Date: Mon, 11 Aug 2008 16:53:25 -0700
From: Matt Helsley <matthltc@us.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Paul Menage <menage@google.com>,
       Li Zefan <lizf@cn.fujitsu.com>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>,
       linux-pm@lists.linux-foundation.org, Cedric Le Goater <clg@fr.ibm.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>
Subject: [PATCH 2/5] Container Freezer: Make refrigerator always available
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that the TIF_FREEZE flag is available in all architectures,
extract the refrigerator() and freeze_task() from kernel/power/process.c
and make it available to all.

The refrigerator() can now be used in a control group subsystem
implementing a control group freezer.

Signed-off-by: Cedric Le Goater <clg@fr.ibm.com>
Signed-off-by: Matt Helsley <matthltc@us.ibm.com>
Acked-by: Serge E. Hallyn <serue@us.ibm.com>
Tested-by: Matt Helsley <matthltc@us.ibm.com>
---
 include/linux/freezer.h |   14 ++++-
 kernel/Makefile         |    1 
 kernel/freezer.c        |  122 ++++++++++++++++++++++++++++++++++++++++++++++++
 kernel/power/Kconfig    |    3 +
 kernel/power/process.c  |  116 ---------------------------------------------
 5 files changed, 137 insertions(+), 119 deletions(-)
 create mode 100644 kernel/freezer.c

Index: linux-2.6.27-rc1-mm1/include/linux/freezer.h
===================================================================
--- linux-2.6.27-rc1-mm1.orig/include/linux/freezer.h
+++ linux-2.6.27-rc1-mm1/include/linux/freezer.h
@@ -6,7 +6,7 @@
 #include <linux/sched.h>
 #include <linux/wait.h>
 
-#ifdef CONFIG_PM_SLEEP
+#ifdef CONFIG_FREEZER
 /*
  * Check if a process has been frozen
  */
@@ -39,6 +39,11 @@ static inline void clear_freeze_flag(str
 	clear_tsk_thread_flag(p, TIF_FREEZE);
 }
 
+static inline bool should_send_signal(struct task_struct *p)
+{
+	return !(p->flags & PF_FREEZER_NOSIG);
+}
+
 /*
  * Wake up a frozen process
  *
@@ -75,6 +80,9 @@ static inline int try_to_freeze(void)
 		return 0;
 }
 
+extern bool freeze_task(struct task_struct *p, bool sig_only);
+extern void cancel_freezing(struct task_struct *p);
+
 /*
  * The PF_FREEZER_SKIP flag should be set by a vfork parent right before it
  * calls wait_for_completion(&vfork) and reset right after it returns from this
@@ -166,7 +174,7 @@ static inline void set_freezable_with_si
 	} while (try_to_freeze());					\
 	__retval;							\
 })
-#else /* !CONFIG_PM_SLEEP */
+#else /* !CONFIG_FREEZER */
 static inline int frozen(struct task_struct *p) { return 0; }
 static inline int freezing(struct task_struct *p) { return 0; }
 static inline void set_freeze_flag(struct task_struct *p) {}
@@ -191,6 +199,6 @@ static inline void set_freezable_with_si
 #define wait_event_freezable_timeout(wq, condition, timeout)		\
 		wait_event_interruptible_timeout(wq, condition, timeout)
 
-#endif /* !CONFIG_PM_SLEEP */
+#endif /* !CONFIG_FREEZER */
 
 #endif	/* FREEZER_H_INCLUDED */
Index: linux-2.6.27-rc1-mm1/kernel/Makefile
===================================================================
--- linux-2.6.27-rc1-mm1.orig/kernel/Makefile
+++ linux-2.6.27-rc1-mm1/kernel/Makefile
@@ -24,6 +24,7 @@ CFLAGS_REMOVE_sched_clock.o = -pg
 CFLAGS_REMOVE_sched.o = -mno-spe -pg
 endif
 
+obj-$(CONFIG_FREEZER) += freezer.o
 obj-$(CONFIG_PROFILING) += profile.o
 obj-$(CONFIG_SYSCTL_SYSCALL_CHECK) += sysctl_check.o
 obj-$(CONFIG_STACKTRACE) += stacktrace.o
Index: linux-2.6.27-rc1-mm1/kernel/freezer.c
===================================================================
--- /dev/null
+++ linux-2.6.27-rc1-mm1/kernel/freezer.c
@@ -0,0 +1,122 @@
+/*
+ * kernel/freezer.c - Function to freeze a process
+ *
+ * Originally from kernel/power/process.c
+ */
+
+#include <linux/interrupt.h>
+#include <linux/suspend.h>
+#include <linux/module.h>
+#include <linux/syscalls.h>
+#include <linux/freezer.h>
+
+/*
+ * freezing is complete, mark current process as frozen
+ */
+static inline void frozen_process(void)
+{
+	if (!unlikely(current->flags & PF_NOFREEZE)) {
+		current->flags |= PF_FROZEN;
+		wmb();
+	}
+	clear_freeze_flag(current);
+}
+
+/* Refrigerator is place where frozen processes are stored :-). */
+void refrigerator(void)
+{
+	/* Hmm, should we be allowed to suspend when there are realtime
+	   processes around? */
+	long save;
+
+	task_lock(current);
+	if (freezing(current)) {
+		frozen_process();
+		task_unlock(current);
+	} else {
+		task_unlock(current);
+		return;
+	}
+	save = current->state;
+	pr_debug("%s entered refrigerator\n", current->comm);
+
+	spin_lock_irq(&current->sighand->siglock);
+	recalc_sigpending(); /* We sent fake signal, clean it up */
+	spin_unlock_irq(&current->sighand->siglock);
+
+	for (;;) {
+		set_current_state(TASK_UNINTERRUPTIBLE);
+		if (!frozen(current))
+			break;
+		schedule();
+	}
+	pr_debug("%s left refrigerator\n", current->comm);
+	__set_current_state(save);
+}
+EXPORT_SYMBOL(refrigerator);
+
+static void fake_signal_wake_up(struct task_struct *p)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&p->sighand->siglock, flags);
+	signal_wake_up(p, 0);
+	spin_unlock_irqrestore(&p->sighand->siglock, flags);
+}
+
+/**
+ *	freeze_task - send a freeze request to given task
+ *	@p: task to send the request to
+ *	@sig_only: if set, the request will only be sent if the task has the
+ *		PF_FREEZER_NOSIG flag unset
+ *	Return value: 'false', if @sig_only is set and the task has
+ *		PF_FREEZER_NOSIG set or the task is frozen, 'true', otherwise
+ *
+ *	The freeze request is sent by setting the tasks's TIF_FREEZE flag and
+ *	either sending a fake signal to it or waking it up, depending on whether
+ *	or not it has PF_FREEZER_NOSIG set.  If @sig_only is set and the task
+ *	has PF_FREEZER_NOSIG set (ie. it is a typical kernel thread), its
+ *	TIF_FREEZE flag will not be set.
+ */
+bool freeze_task(struct task_struct *p, bool sig_only)
+{
+	/*
+	 * We first check if the task is freezing and next if it has already
+	 * been frozen to avoid the race with frozen_process() which first marks
+	 * the task as frozen and next clears its TIF_FREEZE.
+	 */
+	if (!freezing(p)) {
+		rmb();
+		if (frozen(p))
+			return false;
+
+		if (!sig_only || should_send_signal(p))
+			set_freeze_flag(p);
+		else
+			return false;
+	}
+
+	if (should_send_signal(p)) {
+		if (!signal_pending(p))
+			fake_signal_wake_up(p);
+	} else if (sig_only) {
+		return false;
+	} else {
+		wake_up_state(p, TASK_INTERRUPTIBLE);
+	}
+
+	return true;
+}
+
+void cancel_freezing(struct task_struct *p)
+{
+	unsigned long flags;
+
+	if (freezing(p)) {
+		pr_debug("  clean up: %s\n", p->comm);
+		clear_freeze_flag(p);
+		spin_lock_irqsave(&p->sighand->siglock, flags);
+		recalc_sigpending_and_wake(p);
+		spin_unlock_irqrestore(&p->sighand->siglock, flags);
+	}
+}
Index: linux-2.6.27-rc1-mm1/kernel/power/process.c
===================================================================
--- linux-2.6.27-rc1-mm1.orig/kernel/power/process.c
+++ linux-2.6.27-rc1-mm1/kernel/power/process.c
@@ -28,121 +28,6 @@ static inline int freezeable(struct task
 	return 1;
 }
 
-/*
- * freezing is complete, mark current process as frozen
- */
-static inline void frozen_process(void)
-{
-	if (!unlikely(current->flags & PF_NOFREEZE)) {
-		current->flags |= PF_FROZEN;
-		wmb();
-	}
-	clear_freeze_flag(current);
-}
-
-/* Refrigerator is place where frozen processes are stored :-). */
-void refrigerator(void)
-{
-	/* Hmm, should we be allowed to suspend when there are realtime
-	   processes around? */
-	long save;
-
-	task_lock(current);
-	if (freezing(current)) {
-		frozen_process();
-		task_unlock(current);
-	} else {
-		task_unlock(current);
-		return;
-	}
-	save = current->state;
-	pr_debug("%s entered refrigerator\n", current->comm);
-
-	spin_lock_irq(&current->sighand->siglock);
-	recalc_sigpending(); /* We sent fake signal, clean it up */
-	spin_unlock_irq(&current->sighand->siglock);
-
-	for (;;) {
-		set_current_state(TASK_UNINTERRUPTIBLE);
-		if (!frozen(current))
-			break;
-		schedule();
-	}
-	pr_debug("%s left refrigerator\n", current->comm);
-	__set_current_state(save);
-}
-
-static void fake_signal_wake_up(struct task_struct *p)
-{
-	unsigned long flags;
-
-	spin_lock_irqsave(&p->sighand->siglock, flags);
-	signal_wake_up(p, 0);
-	spin_unlock_irqrestore(&p->sighand->siglock, flags);
-}
-
-static inline bool should_send_signal(struct task_struct *p)
-{
-	return !(p->flags & PF_FREEZER_NOSIG);
-}
-
-/**
- *	freeze_task - send a freeze request to given task
- *	@p: task to send the request to
- *	@sig_only: if set, the request will only be sent if the task has the
- *		PF_FREEZER_NOSIG flag unset
- *	Return value: 'false', if @sig_only is set and the task has
- *		PF_FREEZER_NOSIG set or the task is frozen, 'true', otherwise
- *
- *	The freeze request is sent by setting the tasks's TIF_FREEZE flag and
- *	either sending a fake signal to it or waking it up, depending on whether
- *	or not it has PF_FREEZER_NOSIG set.  If @sig_only is set and the task
- *	has PF_FREEZER_NOSIG set (ie. it is a typical kernel thread), its
- *	TIF_FREEZE flag will not be set.
- */
-static bool freeze_task(struct task_struct *p, bool sig_only)
-{
-	/*
-	 * We first check if the task is freezing and next if it has already
-	 * been frozen to avoid the race with frozen_process() which first marks
-	 * the task as frozen and next clears its TIF_FREEZE.
-	 */
-	if (!freezing(p)) {
-		rmb();
-		if (frozen(p))
-			return false;
-
-		if (!sig_only || should_send_signal(p))
-			set_freeze_flag(p);
-		else
-			return false;
-	}
-
-	if (should_send_signal(p)) {
-		if (!signal_pending(p))
-			fake_signal_wake_up(p);
-	} else if (sig_only) {
-		return false;
-	} else {
-		wake_up_state(p, TASK_INTERRUPTIBLE);
-	}
-
-	return true;
-}
-
-static void cancel_freezing(struct task_struct *p)
-{
-	unsigned long flags;
-
-	if (freezing(p)) {
-		pr_debug("  clean up: %s\n", p->comm);
-		clear_freeze_flag(p);
-		spin_lock_irqsave(&p->sighand->siglock, flags);
-		recalc_sigpending_and_wake(p);
-		spin_unlock_irqrestore(&p->sighand->siglock, flags);
-	}
-}
-
 static int try_to_freeze_tasks(bool sig_only)
 {
 	struct task_struct *g, *p;
@@ -264,4 +149,3 @@ void thaw_processes(void)
 	printk("done.\n");
 }
 
-EXPORT_SYMBOL(refrigerator);
Index: linux-2.6.27-rc1-mm1/kernel/power/Kconfig
===================================================================
--- linux-2.6.27-rc1-mm1.orig/kernel/power/Kconfig
+++ linux-2.6.27-rc1-mm1/kernel/power/Kconfig
@@ -85,6 +85,9 @@ config PM_SLEEP
 	depends on SUSPEND || HIBERNATION || XEN_SAVE_RESTORE
 	default y
 
+config FREEZER
+	def_bool PM_SLEEP
+
 config SUSPEND
 	bool "Suspend to RAM and standby"
 	depends on PM && ARCH_SUSPEND_POSSIBLE

-- 
