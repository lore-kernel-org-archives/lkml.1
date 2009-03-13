Return-Path: <linux-kernel-owner+w=401wt.eu-S1758570AbZCMKi0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758570AbZCMKi0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 06:38:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758096AbZCMKhi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 06:37:38 -0400
Received: from hera.kernel.org ([140.211.167.34]:36948 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758008AbZCMKhf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 06:37:35 -0400
Date: Fri, 13 Mar 2009 10:36:52 GMT
From: Ingo Molnar <mingo@elte.hu>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <49B91A7E.76E4.0078.0@novell.com>
References: <49B91A7E.76E4.0078.0@novell.com>
Subject: [tip:core/ipi] panic: clean up kernel/panic.c
Message-ID: <tip-c95dbf27e201587b2a6cf63f8501a0313d9b4801@git.kernel.org>
Git-Commit-ID: c95dbf27e201587b2a6cf63f8501a0313d9b4801
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 13 Mar 2009 10:37:01 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c95dbf27e201587b2a6cf63f8501a0313d9b4801
Gitweb:     http://git.kernel.org/tip/c95dbf27e201587b2a6cf63f8501a0313d9b4801
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Fri, 13 Mar 2009 11:14:06 +0100
Commit:     Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 13 Mar 2009 11:25:53 +0100

panic: clean up kernel/panic.c

Impact: cleanup, no code changed

Clean up kernel/panic.c some more and make it more consistent.

LKML-Reference: <49B91A7E.76E4.0078.0@novell.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/panic.c |  111 ++++++++++++++++++++++++++++++--------------------------
 1 files changed, 59 insertions(+), 52 deletions(-)

diff --git a/kernel/panic.c b/kernel/panic.c
index ca75e81..3fd8c5b 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -8,19 +8,19 @@
  * This function is used through-out the kernel (including mm and fs)
  * to indicate a major problem.
  */
+#include <linux/debug_locks.h>
+#include <linux/interrupt.h>
+#include <linux/kallsyms.h>
+#include <linux/notifier.h>
 #include <linux/module.h>
-#include <linux/sched.h>
-#include <linux/delay.h>
+#include <linux/random.h>
 #include <linux/reboot.h>
-#include <linux/notifier.h>
-#include <linux/init.h>
+#include <linux/delay.h>
+#include <linux/kexec.h>
+#include <linux/sched.h>
 #include <linux/sysrq.h>
-#include <linux/interrupt.h>
+#include <linux/init.h>
 #include <linux/nmi.h>
-#include <linux/kexec.h>
-#include <linux/debug_locks.h>
-#include <linux/random.h>
-#include <linux/kallsyms.h>
 #include <linux/dmi.h>
 
 int panic_on_oops;
@@ -52,19 +52,15 @@ EXPORT_SYMBOL(panic_blink);
  *
  *	This function never returns.
  */
-
 NORET_TYPE void panic(const char * fmt, ...)
 {
-	long i;
 	static char buf[1024];
 	va_list args;
-#if defined(CONFIG_S390)
-	unsigned long caller = (unsigned long) __builtin_return_address(0);
-#endif
+	long i;
 
 	/*
-	 * It's possible to come here directly from a panic-assertion and not
-	 * have preempt disabled. Some functions called from here want
+	 * It's possible to come here directly from a panic-assertion and
+	 * not have preempt disabled. Some functions called from here want
 	 * preempt to be disabled. No point enabling it later though...
 	 */
 	preempt_disable();
@@ -99,19 +95,21 @@ NORET_TYPE void panic(const char * fmt, ...)
 
 	if (panic_timeout > 0) {
 		/*
-	 	 * Delay timeout seconds before rebooting the machine. 
-		 * We can't use the "normal" timers since we just panicked..
-	 	 */
-		printk(KERN_EMERG "Rebooting in %d seconds..",panic_timeout);
+		 * Delay timeout seconds before rebooting the machine.
+		 * We can't use the "normal" timers since we just panicked.
+		 */
+		printk(KERN_EMERG "Rebooting in %d seconds..", panic_timeout);
+
 		for (i = 0; i < panic_timeout*1000; ) {
 			touch_nmi_watchdog();
 			i += panic_blink(i);
 			mdelay(1);
 			i++;
 		}
-		/*	This will not be a clean reboot, with everything
-		 *	shutting down.  But if there is a chance of
-		 *	rebooting the system it will be rebooted.
+		/*
+		 * This will not be a clean reboot, with everything
+		 * shutting down.  But if there is a chance of
+		 * rebooting the system it will be rebooted.
 		 */
 		emergency_restart();
 	}
@@ -124,10 +122,15 @@ NORET_TYPE void panic(const char * fmt, ...)
 	}
 #endif
 #if defined(CONFIG_S390)
-	disabled_wait(caller);
+	{
+		unsigned long caller;
+
+		caller = (unsigned long)__builtin_return_address(0);
+		disabled_wait(caller);
+	}
 #endif
 	local_irq_enable();
-	for (i = 0;;) {
+	for (i = 0; ; ) {
 		touch_softlockup_watchdog();
 		i += panic_blink(i);
 		mdelay(1);
@@ -140,23 +143,23 @@ EXPORT_SYMBOL(panic);
 
 
 struct tnt {
-	u8 bit;
-	char true;
-	char false;
+	u8	bit;
+	char	true;
+	char	false;
 };
 
 static const struct tnt tnts[] = {
-	{ TAINT_PROPRIETARY_MODULE, 'P', 'G' },
-	{ TAINT_FORCED_MODULE, 'F', ' ' },
-	{ TAINT_UNSAFE_SMP, 'S', ' ' },
-	{ TAINT_FORCED_RMMOD, 'R', ' ' },
-	{ TAINT_MACHINE_CHECK, 'M', ' ' },
-	{ TAINT_BAD_PAGE, 'B', ' ' },
-	{ TAINT_USER, 'U', ' ' },
-	{ TAINT_DIE, 'D', ' ' },
-	{ TAINT_OVERRIDDEN_ACPI_TABLE, 'A', ' ' },
-	{ TAINT_WARN, 'W', ' ' },
-	{ TAINT_CRAP, 'C', ' ' },
+	{ TAINT_PROPRIETARY_MODULE,	'P', 'G' },
+	{ TAINT_FORCED_MODULE,		'F', ' ' },
+	{ TAINT_UNSAFE_SMP,		'S', ' ' },
+	{ TAINT_FORCED_RMMOD,		'R', ' ' },
+	{ TAINT_MACHINE_CHECK,		'M', ' ' },
+	{ TAINT_BAD_PAGE,		'B', ' ' },
+	{ TAINT_USER,			'U', ' ' },
+	{ TAINT_DIE,			'D', ' ' },
+	{ TAINT_OVERRIDDEN_ACPI_TABLE,	'A', ' ' },
+	{ TAINT_WARN,			'W', ' ' },
+	{ TAINT_CRAP,			'C', ' ' },
 };
 
 /**
@@ -193,7 +196,8 @@ const char *print_tainted(void)
 		*s = 0;
 	} else
 		snprintf(buf, sizeof(buf), "Not tainted");
-	return(buf);
+
+	return buf;
 }
 
 int test_taint(unsigned flag)
@@ -209,7 +213,8 @@ unsigned long get_taint(void)
 
 void add_taint(unsigned flag)
 {
-	debug_locks = 0; /* can't trust the integrity of the kernel anymore */
+	/* can't trust the integrity of the kernel anymore: */
+	debug_locks = 0;
 	set_bit(flag, &tainted_mask);
 }
 EXPORT_SYMBOL(add_taint);
@@ -264,8 +269,8 @@ static void do_oops_enter_exit(void)
 }
 
 /*
- * Return true if the calling CPU is allowed to print oops-related info.  This
- * is a bit racy..
+ * Return true if the calling CPU is allowed to print oops-related info.
+ * This is a bit racy..
  */
 int oops_may_print(void)
 {
@@ -274,20 +279,22 @@ int oops_may_print(void)
 
 /*
  * Called when the architecture enters its oops handler, before it prints
- * anything.  If this is the first CPU to oops, and it's oopsing the first time
- * then let it proceed.
+ * anything.  If this is the first CPU to oops, and it's oopsing the first
+ * time then let it proceed.
  *
- * This is all enabled by the pause_on_oops kernel boot option.  We do all this
- * to ensure that oopses don't scroll off the screen.  It has the side-effect
- * of preventing later-oopsing CPUs from mucking up the display, too.
+ * This is all enabled by the pause_on_oops kernel boot option.  We do all
+ * this to ensure that oopses don't scroll off the screen.  It has the
+ * side-effect of preventing later-oopsing CPUs from mucking up the display,
+ * too.
  *
- * It turns out that the CPU which is allowed to print ends up pausing for the
- * right duration, whereas all the other CPUs pause for twice as long: once in
- * oops_enter(), once in oops_exit().
+ * It turns out that the CPU which is allowed to print ends up pausing for
+ * the right duration, whereas all the other CPUs pause for twice as long:
+ * once in oops_enter(), once in oops_exit().
  */
 void oops_enter(void)
 {
-	debug_locks_off(); /* can't trust the integrity of the kernel anymore */
+	/* can't trust the integrity of the kernel anymore: */
+	debug_locks_off();
 	do_oops_enter_exit();
 }
 
