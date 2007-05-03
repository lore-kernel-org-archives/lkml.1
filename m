Return-Path: <linux-kernel-owner+w=401wt.eu-S1767366AbXECELq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767366AbXECELq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 00:11:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767367AbXECELq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 00:11:46 -0400
Received: from smtp-out.google.com ([216.239.33.17]:56438 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767366AbXECELo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 00:11:44 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:to:cc:subject:message-id:mime-version:
	content-type:content-disposition:user-agent:from;
	b=FkJVGyvHWDnaMHymUaCTBnG5OVB314PbOhBTn7RPTvZrjQSmdGCDOqRm2aIS6sZ3J
	DlY41CIbBdKXjA8ITuXfw==
Date: Wed, 2 May 2007 21:11:20 -0700
To: ak@suse.de, vojtech@suse.cz
Cc: linux-kernel@vger.kernel.org, akpm@google.com
Subject: [PATCH] x86_64: support poll() on /dev/mcelog (try #3)
Message-ID: <20070503041120.GA28583@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
From: thockin@google.com (Tim Hockin)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tim Hockin <thockin@google.com>

Background:
 /dev/mcelog is typically polled manually.  This is less than optimal for
 situations where accurate accounting of MCEs is important.  Calling
 poll() on /dev/mcelog does not work.

Description:
 This patch adds support for poll() to /dev/mcelog.  This results in
 immediate wakeup of user apps whenever the poller finds MCEs.  Because
 the exception handler can not take any locks, it can not call the wakeup
 itself.  Instead, it uses a thread_info flag (TIF_MCE_NOTIFY) which is
 caught at the next return from interrupt or exit from idle, calling the
 mce_user_notify() routine.  This patch also disables the "fake panic"
 path of the mce_panic(), because it results in printk()s in the exception
 handler and crashy systems.

 This patch also does some small cleanup for essentially unused variables,
 and moves the user notification into the body of the poller, so it is
 only called once per poll, rather than once per CPU.

Result:
 Applications can now poll() on /dev/mcelog.  When an error is logged
 (whether through the poller or through an exception) the applications are
 woken up promptly.  This should not affect any previous behaviors.  If no
 MCEs are being logged, there is no overhead.

Alternatives:
 I considered simply supporting poll() through the poller and not using
 TIF_MCE_NOTIFY at all.  However, the time between an uncorrectable error
 happening and the user application being notified is *the*most* critical
 window for us.  Many uncorrectable errors can be logged to the network if
 given a chance.

 I also considered doing the MCE poll directly from the idle notifier, but
 decided that was overkill.

Testing:
 I used an error-injecting DIMM to create lots of correctable DRAM errors
 and verified that my user app is woken up in sync with the polling interval.
 I also used the northbridge to inject uncorrectable ECC errors, and
 verified (printk() to the rescue) that the notify routine is called and the
 user app does wake up.  I built with PREEMPT on and off, and verified
 that my machine survives MCEs.

Patch:
 This patch is against 2.6.21-rc7.

Signed-off-by: Tim Hockin <thockin@google.com>

---

This is the third version version of this patch.  The TIF_* approach was
suggested by Mike Waychison and Andi did not yell at me when I suggested
it.  Hooking the idle notifier was born of an Andrew Morton suggestion
and, no surprise, seems to work well.


diff -pruN linux-2.6.20+01_poll_interval/arch/x86_64/kernel/entry.S linux-2.6.20+03_poll/arch/x86_64/kernel/entry.S
--- linux-2.6.20+01_poll_interval/arch/x86_64/kernel/entry.S	2007-04-24 22:46:19.000000000 -0700
+++ linux-2.6.20+03_poll/arch/x86_64/kernel/entry.S	2007-05-02 20:50:38.000000000 -0700
@@ -282,7 +282,7 @@ sysret_careful:
 sysret_signal:
 	TRACE_IRQS_ON
 	sti
-	testl $(_TIF_SIGPENDING|_TIF_NOTIFY_RESUME|_TIF_SINGLESTEP),%edx
+	testl $(_TIF_SIGPENDING|_TIF_NOTIFY_RESUME|_TIF_SINGLESTEP|_TIF_MCE_NOTIFY),%edx
 	jz    1f
 
 	/* Really a signal */
@@ -375,7 +375,7 @@ int_very_careful:
 	jmp int_restore_rest
 	
 int_signal:
-	testl $(_TIF_NOTIFY_RESUME|_TIF_SIGPENDING|_TIF_SINGLESTEP),%edx
+	testl $(_TIF_NOTIFY_RESUME|_TIF_SIGPENDING|_TIF_SINGLESTEP|_TIF_MCE_NOTIFY),%edx
 	jz 1f
 	movq %rsp,%rdi		# &ptregs -> arg1
 	xorl %esi,%esi		# oldset -> arg2
@@ -599,7 +599,7 @@ retint_careful:
 	jmp retint_check
 	
 retint_signal:
-	testl $(_TIF_SIGPENDING|_TIF_NOTIFY_RESUME|_TIF_SINGLESTEP),%edx
+	testl $(_TIF_SIGPENDING|_TIF_NOTIFY_RESUME|_TIF_SINGLESTEP|_TIF_MCE_NOTIFY),%edx
 	jz    retint_swapgs
 	TRACE_IRQS_ON
 	sti
diff -pruN linux-2.6.20+01_poll_interval/arch/x86_64/kernel/mce.c linux-2.6.20+03_poll/arch/x86_64/kernel/mce.c
--- linux-2.6.20+01_poll_interval/arch/x86_64/kernel/mce.c	2007-04-27 14:19:08.000000000 -0700
+++ linux-2.6.20+03_poll/arch/x86_64/kernel/mce.c	2007-05-02 21:02:16.000000000 -0700
@@ -20,12 +20,15 @@
 #include <linux/percpu.h>
 #include <linux/ctype.h>
 #include <linux/kmod.h>
+#include <linux/poll.h>
+#include <linux/thread_info.h>
 #include <asm/processor.h> 
 #include <asm/msr.h>
 #include <asm/mce.h>
 #include <asm/kdebug.h>
 #include <asm/uaccess.h>
 #include <asm/smp.h>
+#include <asm/idle.h>
 
 #define MISC_MCELOG_MINOR 227
 #define NR_BANKS 6
@@ -39,8 +42,7 @@ static int mce_dont_init;
 static int tolerant = 1;
 static int banks;
 static unsigned long bank[NR_BANKS] = { [0 ... NR_BANKS-1] = ~0UL };
-static unsigned long console_logged;
-static int notify_user;
+static unsigned long notify_user;
 static int rip_msr;
 static int mce_bootlog = 1;
 static atomic_t mce_events;
@@ -48,6 +50,8 @@ static atomic_t mce_events;
 static char trigger[128];
 static char *trigger_argv[2] = { trigger, NULL };
 
+static DECLARE_WAIT_QUEUE_HEAD(mce_wait);
+
 /*
  * Lockless MCE logging infrastructure.
  * This avoids deadlocks on printk locks without having to break locks. Also
@@ -94,8 +98,7 @@ void mce_log(struct mce *mce)
 	mcelog.entry[entry].finished = 1;
 	wmb();
 
-	if (!test_and_set_bit(0, &console_logged))
-		notify_user = 1;
+	set_bit(0, &notify_user);
 }
 
 static void print_mce(struct mce *m)
@@ -128,6 +131,10 @@ static void print_mce(struct mce *m)
 static void mce_panic(char *msg, struct mce *backup, unsigned long start)
 { 
 	int i;
+
+	if (tolerant >= 3)
+		return;
+
 	oops_begin();
 	for (i = 0; i < MCE_LOG_LEN; i++) {
 		unsigned long tsc = mcelog.entry[i].tsc;
@@ -139,10 +146,7 @@ static void mce_panic(char *msg, struct 
 	}
 	if (backup)
 		print_mce(backup);
-	if (tolerant >= 3)
-		printk("Fake panic: %s\n", msg);
-	else
-		panic(msg);
+	panic(msg);
 } 
 
 static int mce_available(struct cpuinfo_x86 *c)
@@ -167,17 +171,6 @@ static inline void mce_get_rip(struct mc
 	}
 }
 
-static void do_mce_trigger(void)
-{
-	static atomic_t mce_logged;
-	int events = atomic_read(&mce_events);
-	if (events != atomic_read(&mce_logged) && trigger[0]) {
-		/* Small race window, but should be harmless.  */
-		atomic_set(&mce_logged, events);
-		call_usermodehelper(trigger, trigger_argv, NULL, -1);
-	}
-}
-
 /* 
  * The actual machine check handler
  */
@@ -251,12 +244,8 @@ void do_machine_check(struct pt_regs * r
 	}
 
 	/* Never do anything final in the polling timer */
-	if (!regs) {
-		/* Normal interrupt context here. Call trigger for any new
-		   events. */
-		do_mce_trigger();
+	if (!regs)
 		goto out;
-	}
 
 	/* If we didn't find an uncorrectable error, pick
 	   the last one (shouldn't happen, just being safe). */
@@ -288,6 +277,9 @@ void do_machine_check(struct pt_regs * r
 			do_exit(SIGBUS);
 	}
 
+	/* notify userspace ASAP */
+	set_thread_flag(TIF_MCE_NOTIFY);
+
  out:
 	/* Last thing done in the machine check exception to clear state. */
 	wrmsrl(MSR_IA32_MCG_STATUS, 0);
@@ -344,37 +336,66 @@ static void mcheck_timer(struct work_str
 	on_each_cpu(mcheck_check_cpu, NULL, 1, 1);
 
 	/*
-	 * It's ok to read stale data here for notify_user and
-	 * console_logged as we'll simply get the updated versions
-	 * on the next mcheck_timer execution and atomic operations
-	 * on console_logged act as synchronization for notify_user
-	 * writes.
+	 * Alert userspace if needed.  If we logged an MCE, reduce the
+	 * polling interval, otherwise increase the polling interval.
 	 */
-	if (notify_user && console_logged) {
+	if (mce_notify_user()) {
+		next_interval = max(next_interval/2, HZ/100);
+	} else {
+		next_interval = min(next_interval*2, check_interval*HZ);
+	}
+
+	schedule_delayed_work(&mcheck_work, next_interval);
+}
+
+/*
+ * This is only called from process context.  This is where we do
+ * anything we need to alert userspace about new MCEs.  This is called
+ * directly from the poller and also from entry.S and idle, thanks to
+ * TIF_MCE_NOTIFY.
+ */
+int mce_notify_user(void)
+{
+	clear_thread_flag(TIF_MCE_NOTIFY);
+	if (test_and_clear_bit(0, &notify_user)) {
 		static unsigned long last_print;
 		unsigned long now = jiffies;
 
-		/* if we logged an MCE, reduce the polling interval */
-		next_interval = max(next_interval/2, HZ/100);
-		notify_user = 0;
-		clear_bit(0, &console_logged);
+		wake_up_interruptible(&mce_wait);
+		if (trigger[0])
+			call_usermodehelper(trigger, trigger_argv, NULL, -1);
+
 		if (time_after_eq(now, last_print + (check_interval*HZ))) {
 			last_print = now;
 			printk(KERN_INFO "Machine check events logged\n");
 		}
-	} else {
-		next_interval = min(next_interval*2, check_interval*HZ);
+
+		return 1;
 	}
+	return 0;
+}
 
-	schedule_delayed_work(&mcheck_work, next_interval);
+/* see if the idle task needs to notify userspace */
+static int
+mce_idle_callback(struct notifier_block *nfb, unsigned long action, void *junk)
+{
+	/* IDLE_END should be safe - interrupts are back on */
+	if (action == IDLE_END && test_thread_flag(TIF_MCE_NOTIFY))
+		mce_notify_user();
+
+	return NOTIFY_OK;
 }
 
+static struct notifier_block mce_idle_notifier = {
+	.notifier_call = mce_idle_callback,
+};
 
 static __init int periodic_mcheck_init(void)
 { 
 	next_interval = check_interval * HZ;
 	if (next_interval)
 		schedule_delayed_work(&mcheck_work, next_interval);
+	idle_notifier_register(&mce_idle_notifier);
 	return 0;
 } 
 __initcall(periodic_mcheck_init);
@@ -530,6 +551,14 @@ static ssize_t mce_read(struct file *fil
 	return err ? -EFAULT : buf - ubuf; 
 }
 
+static unsigned int mce_poll(struct file *file, poll_table *wait)
+{
+	poll_wait(file, &mce_wait, wait);
+	if (rcu_dereference(mcelog.next))
+		return POLLIN | POLLRDNORM;
+	return 0;
+}
+
 static int mce_ioctl(struct inode *i, struct file *f,unsigned int cmd, unsigned long arg)
 {
 	int __user *p = (int __user *)arg;
@@ -554,6 +583,7 @@ static int mce_ioctl(struct inode *i, st
 
 static const struct file_operations mce_chrdev_ops = {
 	.read = mce_read,
+	.poll = mce_poll,
 	.ioctl = mce_ioctl,
 };
 
diff -pruN linux-2.6.20+01_poll_interval/arch/x86_64/kernel/signal.c linux-2.6.20+03_poll/arch/x86_64/kernel/signal.c
--- linux-2.6.20+01_poll_interval/arch/x86_64/kernel/signal.c	2007-02-04 10:44:54.000000000 -0800
+++ linux-2.6.20+03_poll/arch/x86_64/kernel/signal.c	2007-05-01 12:45:46.000000000 -0700
@@ -27,6 +27,7 @@
 #include <asm/i387.h>
 #include <asm/proto.h>
 #include <asm/ia32_unistd.h>
+#include <asm/mce.h>
 
 /* #define DEBUG_SIG 1 */
 
@@ -473,6 +474,10 @@ do_notify_resume(struct pt_regs *regs, v
 		clear_thread_flag(TIF_SINGLESTEP);
 	}
 
+	/* notify userspace of pending MCEs */
+	if (thread_info_flags & _TIF_MCE_NOTIFY)
+		mce_notify_user();
+
 	/* deal with pending signal delivery */
 	if (thread_info_flags & (_TIF_SIGPENDING|_TIF_RESTORE_SIGMASK))
 		do_signal(regs);
diff -pruN linux-2.6.20+01_poll_interval/include/asm-x86_64/mce.h linux-2.6.20+03_poll/include/asm-x86_64/mce.h
--- linux-2.6.20+01_poll_interval/include/asm-x86_64/mce.h	2007-04-24 22:46:22.000000000 -0700
+++ linux-2.6.20+03_poll/include/asm-x86_64/mce.h	2007-04-30 21:53:09.000000000 -0700
@@ -105,6 +105,8 @@ extern atomic_t mce_entry;
 
 extern void do_machine_check(struct pt_regs *, long);
 
+extern int mce_notify_user(void);
+
 #endif
 
 #endif
diff -pruN linux-2.6.20+01_poll_interval/include/asm-x86_64/thread_info.h linux-2.6.20+03_poll/include/asm-x86_64/thread_info.h
--- linux-2.6.20+01_poll_interval/include/asm-x86_64/thread_info.h	2007-02-04 10:44:54.000000000 -0800
+++ linux-2.6.20+03_poll/include/asm-x86_64/thread_info.h	2007-04-27 23:13:59.000000000 -0700
@@ -115,6 +115,7 @@ static inline struct thread_info *stack_
 #define TIF_SYSCALL_AUDIT	7	/* syscall auditing active */
 #define TIF_SECCOMP		8	/* secure computing */
 #define TIF_RESTORE_SIGMASK	9	/* restore signal mask in do_signal */
+#define TIF_MCE_NOTIFY		10	/* notify userspace of an MCE */
 /* 16 free */
 #define TIF_IA32		17	/* 32bit process */ 
 #define TIF_FORK		18	/* ret_from_fork */
@@ -133,6 +134,7 @@ static inline struct thread_info *stack_
 #define _TIF_SYSCALL_AUDIT	(1<<TIF_SYSCALL_AUDIT)
 #define _TIF_SECCOMP		(1<<TIF_SECCOMP)
 #define _TIF_RESTORE_SIGMASK	(1<<TIF_RESTORE_SIGMASK)
+#define _TIF_MCE_NOTIFY		(1<<TIF_MCE_NOTIFY)
 #define _TIF_IA32		(1<<TIF_IA32)
 #define _TIF_FORK		(1<<TIF_FORK)
 #define _TIF_ABI_PENDING	(1<<TIF_ABI_PENDING)
