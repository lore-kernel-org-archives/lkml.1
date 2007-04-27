Return-Path: <linux-kernel-owner+w=401wt.eu-S1755886AbXD0Pg5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755886AbXD0Pg5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 11:36:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756008AbXD0Pg5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 11:36:57 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:57319 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755886AbXD0Pgy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 11:36:54 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH -mm 1/2] Separate freezer from PM code
Date: Fri, 27 Apr 2007 17:38:47 +0200
User-Agent: KMail/1.9.5
Cc: Gautham R Shenoy <ego@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Oleg Nesterov <oleg@tv-sign.ru>, Pavel Machek <pavel@ucw.cz>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       LKML <linux-kernel@vger.kernel.org>
References: <200704271737.31192.rjw@sisk.pl>
In-Reply-To: <200704271737.31192.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704271738.48429.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Now that the freezer is used by kprobes, it is no longer a PM-specific piece of
code.  Move the freezer code out of kernel/power and introduce the
CONFIG_FREEZER option that will be chosen automatically if PM or KPROBES is
set.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Pavel Machek <pavel@ucw.cz>
---
 arch/arm/Kconfig         |    5 
 arch/avr32/Kconfig.debug |    5 
 arch/blackfin/Kconfig    |    5 
 arch/frv/Kconfig         |    5 
 arch/i386/Kconfig        |    5 
 arch/ia64/Kconfig        |    5 
 arch/mips/Kconfig        |    5 
 arch/powerpc/Kconfig     |    5 
 arch/ppc/Kconfig         |    5 
 arch/s390/Kconfig        |    5 
 arch/sh/Kconfig          |    5 
 arch/sparc64/Kconfig     |    5 
 arch/x86_64/Kconfig      |    8 +
 include/linux/freezer.h  |    2 
 kernel/Makefile          |    1 
 kernel/freezer.c         |  236 +++++++++++++++++++++++++++++++++++++++++++++++
 kernel/kprobes.c         |    2 
 kernel/power/Makefile    |    2 
 kernel/power/process.c   |  236 -----------------------------------------------
 19 files changed, 308 insertions(+), 239 deletions(-)

Index: linux-2.6.21-rc7-mm2/arch/x86_64/Kconfig
===================================================================
--- linux-2.6.21-rc7-mm2.orig/arch/x86_64/Kconfig	2007-04-27 01:22:33.000000000 +0200
+++ linux-2.6.21-rc7-mm2/arch/x86_64/Kconfig	2007-04-27 01:33:22.000000000 +0200
@@ -703,6 +703,14 @@ config GENERIC_PENDING_IRQ
 	depends on GENERIC_HARDIRQS && SMP
 	default y
 
+#
+# Use the tasks freezer
+#
+config FREEZER
+	bool
+	default y
+	depends on PM || KPROBES
+
 menu "Power management options"
 
 source kernel/power/Kconfig
Index: linux-2.6.21-rc7-mm2/arch/avr32/Kconfig.debug
===================================================================
--- linux-2.6.21-rc7-mm2.orig/arch/avr32/Kconfig.debug	2007-04-27 01:22:33.000000000 +0200
+++ linux-2.6.21-rc7-mm2/arch/avr32/Kconfig.debug	2007-04-27 01:33:22.000000000 +0200
@@ -24,3 +24,8 @@ source "kernel/Kconfig.marker"
 endmenu
 
 endmenu
+
+config FREEZER
+	bool
+	default y
+	depends on KPROBES
Index: linux-2.6.21-rc7-mm2/arch/frv/Kconfig
===================================================================
--- linux-2.6.21-rc7-mm2.orig/arch/frv/Kconfig	2007-04-27 01:22:33.000000000 +0200
+++ linux-2.6.21-rc7-mm2/arch/frv/Kconfig	2007-04-27 01:33:22.000000000 +0200
@@ -364,6 +364,11 @@ source "drivers/pcmcia/Kconfig"
 #	  sleep-deprived psychotic hacker types can say Y now, everyone else
 #	  should probably wait a while.
 
+config FREEZER
+	bool
+	default y
+	depends on PM
+
 menu "Power management options"
 source kernel/power/Kconfig
 endmenu
Index: linux-2.6.21-rc7-mm2/arch/i386/Kconfig
===================================================================
--- linux-2.6.21-rc7-mm2.orig/arch/i386/Kconfig	2007-04-27 01:22:33.000000000 +0200
+++ linux-2.6.21-rc7-mm2/arch/i386/Kconfig	2007-04-27 01:33:22.000000000 +0200
@@ -912,6 +912,11 @@ config ARCH_ENABLE_MEMORY_HOTPLUG
 	def_bool y
 	depends on HIGHMEM
 
+config FREEZER
+	bool
+	default y
+	depends on PM || KPROBES
+
 menu "Power management options (ACPI, APM)"
 	depends on !X86_VOYAGER
 
Index: linux-2.6.21-rc7-mm2/arch/ia64/Kconfig
===================================================================
--- linux-2.6.21-rc7-mm2.orig/arch/ia64/Kconfig	2007-04-27 01:22:33.000000000 +0200
+++ linux-2.6.21-rc7-mm2/arch/ia64/Kconfig	2007-04-27 01:33:22.000000000 +0200
@@ -495,6 +495,11 @@ source "fs/Kconfig.binfmt"
 
 endmenu
 
+config FREEZER
+	bool
+	default y
+	depends on PM || KPROBES
+
 menu "Power management and ACPI"
 
 source "kernel/power/Kconfig"
Index: linux-2.6.21-rc7-mm2/arch/powerpc/Kconfig
===================================================================
--- linux-2.6.21-rc7-mm2.orig/arch/powerpc/Kconfig	2007-04-27 01:22:33.000000000 +0200
+++ linux-2.6.21-rc7-mm2/arch/powerpc/Kconfig	2007-04-27 01:33:22.000000000 +0200
@@ -552,6 +552,11 @@ config CMDLINE
 	  some command-line options at build time by entering them here.  In
 	  most cases you will need to specify the root device here.
 
+config FREEZER
+	bool
+	default y
+	depends on PM || KPROBES
+
 if !44x || BROKEN
 source kernel/power/Kconfig
 endif
Index: linux-2.6.21-rc7-mm2/arch/ppc/Kconfig
===================================================================
--- linux-2.6.21-rc7-mm2.orig/arch/ppc/Kconfig	2007-04-27 01:22:33.000000000 +0200
+++ linux-2.6.21-rc7-mm2/arch/ppc/Kconfig	2007-04-27 01:33:22.000000000 +0200
@@ -1154,6 +1154,11 @@ config PROC_HARDWARE
 source "drivers/zorro/Kconfig"
 
 if !44x || BROKEN
+config FREEZER
+	bool
+	default y
+	depends on PM
+
 source kernel/power/Kconfig
 endif
 
Index: linux-2.6.21-rc7-mm2/arch/s390/Kconfig
===================================================================
--- linux-2.6.21-rc7-mm2.orig/arch/s390/Kconfig	2007-04-27 01:22:33.000000000 +0200
+++ linux-2.6.21-rc7-mm2/arch/s390/Kconfig	2007-04-27 01:33:22.000000000 +0200
@@ -564,6 +564,11 @@ config KPROBES
 	  for kernel debugging, non-intrusive instrumentation and testing.
 	  If in doubt, say "N".
 
+config FREEZER
+	bool
+	default y
+	depends on KPROBES
+
 source "kernel/Kconfig.marker"
 
 source "lib/Kconfig.statistic"
Index: linux-2.6.21-rc7-mm2/arch/sh/Kconfig
===================================================================
--- linux-2.6.21-rc7-mm2.orig/arch/sh/Kconfig	2007-04-27 01:22:33.000000000 +0200
+++ linux-2.6.21-rc7-mm2/arch/sh/Kconfig	2007-04-27 01:33:22.000000000 +0200
@@ -699,6 +699,11 @@ source "fs/Kconfig.binfmt"
 
 endmenu
 
+config FREEZER
+	bool
+	default y
+	depends on PM
+
 menu "Power management options (EXPERIMENTAL)"
 depends on EXPERIMENTAL
 
Index: linux-2.6.21-rc7-mm2/arch/sparc64/Kconfig
===================================================================
--- linux-2.6.21-rc7-mm2.orig/arch/sparc64/Kconfig	2007-04-27 01:22:33.000000000 +0200
+++ linux-2.6.21-rc7-mm2/arch/sparc64/Kconfig	2007-04-27 01:33:22.000000000 +0200
@@ -435,6 +435,11 @@ config KPROBES
 	  for kernel debugging, non-intrusive instrumentation and testing.
 	  If in doubt, say "N".
 
+config FREEZER
+	bool
+	default y
+	depends on KPROBES
+
 source "kernel/Kconfig.marker"
 
 endmenu
Index: linux-2.6.21-rc7-mm2/kernel/Makefile
===================================================================
--- linux-2.6.21-rc7-mm2.orig/kernel/Makefile	2007-04-27 01:22:33.000000000 +0200
+++ linux-2.6.21-rc7-mm2/kernel/Makefile	2007-04-27 01:33:22.000000000 +0200
@@ -33,6 +33,7 @@ obj-$(CONFIG_MODULES) += module.o
 obj-$(CONFIG_KALLSYMS) += kallsyms.o
 obj-$(CONFIG_STACK_UNWIND) += unwind.o
 obj-$(CONFIG_PM) += power/
+obj-$(CONFIG_FREEZER) += freezer.o
 obj-$(CONFIG_BSD_PROCESS_ACCT) += acct.o
 obj-$(CONFIG_KEXEC) += kexec.o
 obj-$(CONFIG_COMPAT) += compat.o
Index: linux-2.6.21-rc7-mm2/kernel/power/Makefile
===================================================================
--- linux-2.6.21-rc7-mm2.orig/kernel/power/Makefile	2007-04-27 01:22:33.000000000 +0200
+++ linux-2.6.21-rc7-mm2/kernel/power/Makefile	2007-04-27 01:33:22.000000000 +0200
@@ -3,7 +3,7 @@ ifeq ($(CONFIG_PM_DEBUG),y)
 EXTRA_CFLAGS	+=	-DDEBUG
 endif
 
-obj-y				:= main.o process.o console.o notify.o
+obj-y				:= main.o console.o notify.o
 obj-$(CONFIG_PM_LEGACY)		+= pm.o
 obj-$(CONFIG_SOFTWARE_SUSPEND)	+= swsusp.o disk.o snapshot.o swap.o user.o
 
Index: linux-2.6.21-rc7-mm2/kernel/kprobes.c
===================================================================
--- linux-2.6.21-rc7-mm2.orig/kernel/kprobes.c	2007-04-27 01:22:33.000000000 +0200
+++ linux-2.6.21-rc7-mm2/kernel/kprobes.c	2007-04-27 01:33:22.000000000 +0200
@@ -108,7 +108,7 @@ static int collect_garbage_slots(void);
 static int __kprobes check_safety(void)
 {
 	int ret = 0;
-#if defined(CONFIG_PREEMPT) && defined(CONFIG_PM)
+#ifdef CONFIG_PREEMPT
 	ret = freeze_processes();
 	if (ret == 0) {
 		struct task_struct *p, *q;
Index: linux-2.6.21-rc7-mm2/include/linux/freezer.h
===================================================================
--- linux-2.6.21-rc7-mm2.orig/include/linux/freezer.h	2007-04-27 01:31:19.000000000 +0200
+++ linux-2.6.21-rc7-mm2/include/linux/freezer.h	2007-04-27 01:33:22.000000000 +0200
@@ -2,7 +2,7 @@
 
 #include <linux/sched.h>
 
-#ifdef CONFIG_PM
+#ifdef CONFIG_FREEZER
 /*
  * Check if a process has been frozen
  */
Index: linux-2.6.21-rc7-mm2/arch/arm/Kconfig
===================================================================
--- linux-2.6.21-rc7-mm2.orig/arch/arm/Kconfig	2007-04-27 01:22:33.000000000 +0200
+++ linux-2.6.21-rc7-mm2/arch/arm/Kconfig	2007-04-27 01:33:22.000000000 +0200
@@ -929,6 +929,11 @@ menu "Power management options"
 
 source "kernel/power/Kconfig"
 
+config FREEZER
+	bool
+	default y
+	depends on PM
+
 endmenu
 
 source "net/Kconfig"
Index: linux-2.6.21-rc7-mm2/arch/blackfin/Kconfig
===================================================================
--- linux-2.6.21-rc7-mm2.orig/arch/blackfin/Kconfig	2007-04-27 01:22:33.000000000 +0200
+++ linux-2.6.21-rc7-mm2/arch/blackfin/Kconfig	2007-04-27 01:33:22.000000000 +0200
@@ -819,6 +819,11 @@ endmenu
 menu "Power management options"
 source "kernel/power/Kconfig"
 
+config FREEZER
+	bool
+	default y
+	depends on PM
+
 choice
 	prompt "Select PM Wakeup Event Source"
 	default PM_WAKEUP_GPIO_BY_SIC_IWR
Index: linux-2.6.21-rc7-mm2/arch/mips/Kconfig
===================================================================
--- linux-2.6.21-rc7-mm2.orig/arch/mips/Kconfig	2007-04-27 01:22:33.000000000 +0200
+++ linux-2.6.21-rc7-mm2/arch/mips/Kconfig	2007-04-27 01:33:22.000000000 +0200
@@ -2138,6 +2138,11 @@ config BINFMT_ELF32
 
 source "kernel/power/Kconfig"
 
+config FREEZER
+	bool
+	default y
+	depends on PM
+
 endmenu
 
 source "net/Kconfig"
Index: linux-2.6.21-rc7-mm2/kernel/freezer.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6.21-rc7-mm2/kernel/freezer.c	2007-04-27 01:35:21.000000000 +0200
@@ -0,0 +1,236 @@
+/*
+ * linux/kernel/freezer.c
+ *
+ * Generic mechanism for freezing and thawing tasks, originally from swsusp.
+ *
+ * Distributed under the GPLv2
+ */
+
+
+#undef DEBUG
+
+#include <linux/sched.h>
+#include <linux/interrupt.h>
+#include <linux/module.h>
+#include <linux/syscalls.h>
+#include <linux/freezer.h>
+
+/*
+ * Timeout for stopping processes
+ */
+#define TIMEOUT	(20 * HZ)
+
+#define FREEZER_KERNEL_THREADS 0
+#define FREEZER_USER_SPACE 1
+
+static inline int freezeable(struct task_struct * p)
+{
+	if ((p == current) ||
+	    (p->flags & PF_NOFREEZE) ||
+	    (p->exit_state != 0))
+		return 0;
+	return 1;
+}
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
+	clear_tsk_thread_flag(current, TIF_FREEZE);
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
+	current->state = save;
+}
+
+static inline void freeze_process(struct task_struct *p)
+{
+	unsigned long flags;
+
+	if (!freezing(p)) {
+		rmb();
+		if (!frozen(p)) {
+			if (p->state == TASK_STOPPED)
+				force_sig_specific(SIGSTOP, p);
+
+			freeze(p);
+			spin_lock_irqsave(&p->sighand->siglock, flags);
+			signal_wake_up(p, p->state == TASK_STOPPED);
+			spin_unlock_irqrestore(&p->sighand->siglock, flags);
+		}
+	}
+}
+
+static void cancel_freezing(struct task_struct *p)
+{
+	unsigned long flags;
+
+	if (freezing(p)) {
+		pr_debug("  clean up: %s\n", p->comm);
+		do_not_freeze(p);
+		spin_lock_irqsave(&p->sighand->siglock, flags);
+		recalc_sigpending_tsk(p);
+		spin_unlock_irqrestore(&p->sighand->siglock, flags);
+	}
+}
+
+static inline int is_user_space(struct task_struct *p)
+{
+	int ret;
+
+	task_lock(p);
+	ret = p->mm && !(p->flags & PF_BORROWED_MM);
+	task_unlock(p);
+	return ret;
+}
+
+static unsigned int try_to_freeze_tasks(int freeze_user_space)
+{
+	struct task_struct *g, *p;
+	unsigned long end_time;
+	unsigned int todo;
+
+	end_time = jiffies + TIMEOUT;
+	do {
+		todo = 0;
+		read_lock(&tasklist_lock);
+		do_each_thread(g, p) {
+			if (!freezeable(p))
+				continue;
+
+			if (frozen(p))
+				continue;
+
+			if (p->state == TASK_TRACED && frozen(p->parent)) {
+				cancel_freezing(p);
+				continue;
+			}
+			if (freeze_user_space && !is_user_space(p))
+				continue;
+
+			freeze_process(p);
+			if (!freezer_should_skip(p))
+				todo++;
+		} while_each_thread(g, p);
+		read_unlock(&tasklist_lock);
+		yield();			/* Yield is okay here */
+		if (todo && time_after(jiffies, end_time))
+			break;
+	} while (todo);
+
+	if (todo) {
+		/* This does not unfreeze processes that are already frozen
+		 * (we have slightly ugly calling convention in that respect,
+		 * and caller must call thaw_processes() if something fails),
+		 * but it cleans up leftover PF_FREEZE requests.
+		 */
+		printk("\n");
+		printk(KERN_ERR "Stopping %s timed out after %d seconds "
+				"(%d tasks refusing to freeze):\n",
+				freeze_user_space ? "user space processes" :
+					"kernel threads",
+				TIMEOUT / HZ, todo);
+		read_lock(&tasklist_lock);
+		do_each_thread(g, p) {
+			if (freeze_user_space && !is_user_space(p))
+				continue;
+
+			task_lock(p);
+			if (freezeable(p) && !frozen(p) &&
+			    !freezer_should_skip(p))
+				printk(KERN_ERR " %s\n", p->comm);
+
+			cancel_freezing(p);
+			task_unlock(p);
+		} while_each_thread(g, p);
+		read_unlock(&tasklist_lock);
+	}
+
+	return todo;
+}
+
+/**
+ *	freeze_processes - tell processes to enter the refrigerator
+ *
+ *	Returns 0 on success, or the number of processes that didn't freeze,
+ *	although they were told to.
+ */
+int freeze_processes(void)
+{
+	unsigned int nr_unfrozen;
+
+	printk("Stopping tasks ... ");
+	nr_unfrozen = try_to_freeze_tasks(FREEZER_USER_SPACE);
+	if (nr_unfrozen)
+		return nr_unfrozen;
+
+	sys_sync();
+	nr_unfrozen = try_to_freeze_tasks(FREEZER_KERNEL_THREADS);
+	if (nr_unfrozen)
+		return nr_unfrozen;
+
+	printk("done.\n");
+	BUG_ON(in_atomic());
+	return 0;
+}
+
+static void thaw_tasks(int thaw_user_space)
+{
+	struct task_struct *g, *p;
+
+	read_lock(&tasklist_lock);
+	do_each_thread(g, p) {
+		if (!freezeable(p))
+			continue;
+
+		if (is_user_space(p) == !thaw_user_space)
+			continue;
+
+		thaw_process(p);
+	} while_each_thread(g, p);
+	read_unlock(&tasklist_lock);
+}
+
+void thaw_processes(void)
+{
+	printk("Restarting tasks ... ");
+	thaw_tasks(FREEZER_KERNEL_THREADS);
+	thaw_tasks(FREEZER_USER_SPACE);
+	schedule();
+	printk("done.\n");
+}
+
+EXPORT_SYMBOL(refrigerator);
Index: linux-2.6.21-rc7-mm2/kernel/power/process.c
===================================================================
--- linux-2.6.21-rc7-mm2.orig/kernel/power/process.c	2007-04-27 01:31:00.000000000 +0200
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,236 +0,0 @@
-/*
- * drivers/power/process.c - Functions for starting/stopping processes on 
- *                           suspend transitions.
- *
- * Originally from swsusp.
- */
-
-
-#undef DEBUG
-
-#include <linux/sched.h>
-#include <linux/interrupt.h>
-#include <linux/suspend.h>
-#include <linux/module.h>
-#include <linux/syscalls.h>
-#include <linux/freezer.h>
-
-/* 
- * Timeout for stopping processes
- */
-#define TIMEOUT	(20 * HZ)
-
-#define FREEZER_KERNEL_THREADS 0
-#define FREEZER_USER_SPACE 1
-
-static inline int freezeable(struct task_struct * p)
-{
-	if ((p == current) ||
-	    (p->flags & PF_NOFREEZE) ||
-	    (p->exit_state != 0))
-		return 0;
-	return 1;
-}
-
-/*
- * freezing is complete, mark current process as frozen
- */
-static inline void frozen_process(void)
-{
-	if (!unlikely(current->flags & PF_NOFREEZE)) {
-		current->flags |= PF_FROZEN;
-		wmb();
-	}
-	clear_tsk_thread_flag(current, TIF_FREEZE);
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
-	current->state = save;
-}
-
-static inline void freeze_process(struct task_struct *p)
-{
-	unsigned long flags;
-
-	if (!freezing(p)) {
-		rmb();
-		if (!frozen(p)) {
-			if (p->state == TASK_STOPPED)
-				force_sig_specific(SIGSTOP, p);
-
-			freeze(p);
-			spin_lock_irqsave(&p->sighand->siglock, flags);
-			signal_wake_up(p, p->state == TASK_STOPPED);
-			spin_unlock_irqrestore(&p->sighand->siglock, flags);
-		}
-	}
-}
-
-static void cancel_freezing(struct task_struct *p)
-{
-	unsigned long flags;
-
-	if (freezing(p)) {
-		pr_debug("  clean up: %s\n", p->comm);
-		do_not_freeze(p);
-		spin_lock_irqsave(&p->sighand->siglock, flags);
-		recalc_sigpending_tsk(p);
-		spin_unlock_irqrestore(&p->sighand->siglock, flags);
-	}
-}
-
-static inline int is_user_space(struct task_struct *p)
-{
-	int ret;
-
-	task_lock(p);
-	ret = p->mm && !(p->flags & PF_BORROWED_MM);
-	task_unlock(p);
-	return ret;
-}
-
-static unsigned int try_to_freeze_tasks(int freeze_user_space)
-{
-	struct task_struct *g, *p;
-	unsigned long end_time;
-	unsigned int todo;
-
-	end_time = jiffies + TIMEOUT;
-	do {
-		todo = 0;
-		read_lock(&tasklist_lock);
-		do_each_thread(g, p) {
-			if (!freezeable(p))
-				continue;
-
-			if (frozen(p))
-				continue;
-
-			if (p->state == TASK_TRACED && frozen(p->parent)) {
-				cancel_freezing(p);
-				continue;
-			}
-			if (freeze_user_space && !is_user_space(p))
-				continue;
-
-			freeze_process(p);
-			if (!freezer_should_skip(p))
-				todo++;
-		} while_each_thread(g, p);
-		read_unlock(&tasklist_lock);
-		yield();			/* Yield is okay here */
-		if (todo && time_after(jiffies, end_time))
-			break;
-	} while (todo);
-
-	if (todo) {
-		/* This does not unfreeze processes that are already frozen
-		 * (we have slightly ugly calling convention in that respect,
-		 * and caller must call thaw_processes() if something fails),
-		 * but it cleans up leftover PF_FREEZE requests.
-		 */
-		printk("\n");
-		printk(KERN_ERR "Stopping %s timed out after %d seconds "
-				"(%d tasks refusing to freeze):\n",
-				freeze_user_space ? "user space processes" :
-					"kernel threads",
-				TIMEOUT / HZ, todo);
-		read_lock(&tasklist_lock);
-		do_each_thread(g, p) {
-			if (freeze_user_space && !is_user_space(p))
-				continue;
-
-			task_lock(p);
-			if (freezeable(p) && !frozen(p) &&
-			    !freezer_should_skip(p))
-				printk(KERN_ERR " %s\n", p->comm);
-
-			cancel_freezing(p);
-			task_unlock(p);
-		} while_each_thread(g, p);
-		read_unlock(&tasklist_lock);
-	}
-
-	return todo;
-}
-
-/**
- *	freeze_processes - tell processes to enter the refrigerator
- *
- *	Returns 0 on success, or the number of processes that didn't freeze,
- *	although they were told to.
- */
-int freeze_processes(void)
-{
-	unsigned int nr_unfrozen;
-
-	printk("Stopping tasks ... ");
-	nr_unfrozen = try_to_freeze_tasks(FREEZER_USER_SPACE);
-	if (nr_unfrozen)
-		return nr_unfrozen;
-
-	sys_sync();
-	nr_unfrozen = try_to_freeze_tasks(FREEZER_KERNEL_THREADS);
-	if (nr_unfrozen)
-		return nr_unfrozen;
-
-	printk("done.\n");
-	BUG_ON(in_atomic());
-	return 0;
-}
-
-static void thaw_tasks(int thaw_user_space)
-{
-	struct task_struct *g, *p;
-
-	read_lock(&tasklist_lock);
-	do_each_thread(g, p) {
-		if (!freezeable(p))
-			continue;
-
-		if (is_user_space(p) == !thaw_user_space)
-			continue;
-
-		thaw_process(p);
-	} while_each_thread(g, p);
-	read_unlock(&tasklist_lock);
-}
-
-void thaw_processes(void)
-{
-	printk("Restarting tasks ... ");
-	thaw_tasks(FREEZER_KERNEL_THREADS);
-	thaw_tasks(FREEZER_USER_SPACE);
-	schedule();
-	printk("done.\n");
-}
-
-EXPORT_SYMBOL(refrigerator);

