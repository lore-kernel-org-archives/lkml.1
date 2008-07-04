Return-Path: <linux-kernel-owner+w=401wt.eu-S1756638AbYGDVWr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756638AbYGDVWr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 17:22:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754161AbYGDVVd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 17:21:33 -0400
Received: from smtp-out01.alice-dsl.net ([88.44.60.11]:52819 "EHLO
	smtp-out01.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753605AbYGDVVc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 17:21:32 -0400
From: Andi Kleen <andi@firstfloor.org>
References: <200807041120.678642023@firstfloor.org>
In-Reply-To: <200807041120.678642023@firstfloor.org>
To: masbock@linux.vnet.ibm.com, x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [7/9] MCE: Remove machine check handler idle notify on 64bit
Message-Id: <20080704212031.CB43D1B431F@basil.firstfloor.org>
Date: Fri,  4 Jul 2008 23:20:31 +0200 (CEST)
X-OriginalArrivalTime: 04 Jul 2008 21:13:09.0236 (UTC) FILETIME=[C26AE340:01C8DE1A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


i386 has no idle notifiers, but the 64bit machine check
code uses them to wake up mcelog from a fatal machine check
exception.

For corrected machine checks found by the poller or
threshold interrupts going through an idle notifier is not needed
because the wake_up can is just done directly and doesn't
need the idle notifier. It is only needed for logging
exceptions.

To be honest I never liked the idle notifier even though I signed off
on it. On closer investigation the code actually turned out to 
be a nop. Right now machine check exceptions on x86 are always unrecoverable 
(lead to panic due to PCC), which means we never execute the
idle notifier path.

Also if we implement support for non fatal machine check
exceptions there are better ways to implement that than to
go through the idle thread. Also in this case the machine check will be 
logged anyways.

So remove the "mcelog wakeup through idle notifier" code
from 64bit.

This allows to compile the 64bit machine check handler on 32bit
which doesn't have idle notifiers.

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 arch/x86/kernel/cpu/mcheck/mce_64.c |   23 +----------------------
 arch/x86/kernel/signal_64.c         |    6 ------
 include/asm-x86/thread_info_64.h    |    5 ++---
 3 files changed, 3 insertions(+), 31 deletions(-)

Index: linux/arch/x86/kernel/cpu/mcheck/mce_64.c
===================================================================
--- linux.orig/arch/x86/kernel/cpu/mcheck/mce_64.c
+++ linux/arch/x86/kernel/cpu/mcheck/mce_64.c
@@ -305,9 +305,6 @@ void do_machine_check(struct pt_regs * r
 		}
 	}
 
-	/* notify userspace ASAP */
-	set_thread_flag(TIF_MCE_NOTIFY);
-
  out:
 	/* the last thing we do is clear state */
 	for (i = 0; i < banks; i++)
@@ -389,12 +386,10 @@ static void mcheck_timer(struct work_str
 /*
  * This is only called from process context.  This is where we do
  * anything we need to alert userspace about new MCEs.  This is called
- * directly from the poller and also from entry.S and idle, thanks to
- * TIF_MCE_NOTIFY.
+ * directly from the poller.
  */
 int mce_notify_user(void)
 {
-	clear_thread_flag(TIF_MCE_NOTIFY);
 	if (test_and_clear_bit(0, &notify_user)) {
 		static unsigned long last_print;
 		unsigned long now = jiffies;
@@ -414,28 +409,12 @@ int mce_notify_user(void)
 	return 0;
 }
 
-/* see if the idle task needs to notify userspace */
-static int
-mce_idle_callback(struct notifier_block *nfb, unsigned long action, void *junk)
-{
-	/* IDLE_END should be safe - interrupts are back on */
-	if (action == IDLE_END && test_thread_flag(TIF_MCE_NOTIFY))
-		mce_notify_user();
-
-	return NOTIFY_OK;
-}
-
-static struct notifier_block mce_idle_notifier = {
-	.notifier_call = mce_idle_callback,
-};
-
 static __init int periodic_mcheck_init(void)
 {
 	next_interval = check_interval * HZ;
 	if (next_interval)
 		schedule_delayed_work(&mcheck_work,
 				      round_jiffies_relative(next_interval));
-	idle_notifier_register(&mce_idle_notifier);
 	return 0;
 }
 __initcall(periodic_mcheck_init);
Index: linux/include/asm-x86/thread_info_64.h
===================================================================
--- linux.orig/include/asm-x86/thread_info_64.h
+++ linux/include/asm-x86/thread_info_64.h
@@ -109,7 +109,7 @@ static inline struct thread_info *stack_
 #define TIF_IRET		5	/* force IRET */
 #define TIF_SYSCALL_AUDIT	7	/* syscall auditing active */
 #define TIF_SECCOMP		8	/* secure computing */
-#define TIF_MCE_NOTIFY		10	/* notify userspace of an MCE */
+/* 10 free */
 #define TIF_HRTICK_RESCHED	11	/* reprogram hrtick timer */
 /* 16 free */
 #define TIF_IA32		17	/* 32bit process */
@@ -132,7 +132,6 @@ static inline struct thread_info *stack_
 #define _TIF_IRET		(1 << TIF_IRET)
 #define _TIF_SYSCALL_AUDIT	(1 << TIF_SYSCALL_AUDIT)
 #define _TIF_SECCOMP		(1 << TIF_SECCOMP)
-#define _TIF_MCE_NOTIFY		(1 << TIF_MCE_NOTIFY)
 #define _TIF_HRTICK_RESCHED	(1 << TIF_HRTICK_RESCHED)
 #define _TIF_IA32		(1 << TIF_IA32)
 #define _TIF_FORK		(1 << TIF_FORK)
@@ -154,7 +153,7 @@ static inline struct thread_info *stack_
 #define _TIF_ALLWORK_MASK (0x0000FFFF & ~_TIF_SECCOMP)
 
 #define _TIF_DO_NOTIFY_MASK						\
-	(_TIF_SIGPENDING|_TIF_SINGLESTEP|_TIF_MCE_NOTIFY|_TIF_HRTICK_RESCHED)
+	(_TIF_SIGPENDING|_TIF_SINGLESTEP|_TIF_HRTICK_RESCHED)
 
 /* flags to check in __switch_to() */
 #define _TIF_WORK_CTXSW							\
Index: linux/arch/x86/kernel/signal_64.c
===================================================================
--- linux.orig/arch/x86/kernel/signal_64.c
+++ linux/arch/x86/kernel/signal_64.c
@@ -493,12 +493,6 @@ void do_notify_resume(struct pt_regs *re
 		clear_thread_flag(TIF_SINGLESTEP);
 	}
 
-#ifdef CONFIG_X86_MCE
-	/* notify userspace of pending MCEs */
-	if (thread_info_flags & _TIF_MCE_NOTIFY)
-		mce_notify_user();
-#endif /* CONFIG_X86_MCE */
-
 	/* deal with pending signal delivery */
 	if (thread_info_flags & _TIF_SIGPENDING)
 		do_signal(regs);
