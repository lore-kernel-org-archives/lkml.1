Return-Path: <linux-kernel-owner+w=401wt.eu-S1946133AbXEAAKn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946133AbXEAAKn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 20:10:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946157AbXEAAKm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 20:10:42 -0400
Received: from scrub.xs4all.nl ([194.109.195.176]:3243 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946133AbXEAAKB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 20:10:01 -0400
Date: Tue, 1 May 2007 02:09:57 +0200 (CEST)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] wrap access to thread_info
Message-ID: <Pine.LNX.4.64.0705010208310.1479@scrub.home>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Recently a few direct accesses to the thread_info in the task structure
snuck back, so this wraps them with the appropriate wrapper.

Signed-off-by: Roman Zippel <zippel@linux-m68k.org>

---

This only leaves blackfin in -mm which I'll fix separately (depending on
how quickly Andrew is with merging it).


 arch/avr32/kernel/process.c      |    6 +++---
 arch/avr32/kernel/ptrace.c       |    2 +-
 arch/i386/kernel/traps.c         |    2 +-
 arch/mips/kernel/smtc.c          |    2 +-
 arch/x86_64/kernel/irq.c         |    2 +-
 include/asm-i386/thread_info.h   |    2 +-
 include/asm-ia64/thread_info.h   |    2 +-
 include/asm-mips/system.h        |    2 +-
 include/asm-parisc/compat.h      |    2 +-
 include/asm-x86_64/thread_info.h |    2 +-
 kernel/mutex.c                   |    8 ++++----
 11 files changed, 16 insertions(+), 16 deletions(-)

Index: linux-2.6/arch/avr32/kernel/process.c
===================================================================
--- linux-2.6.orig/arch/avr32/kernel/process.c
+++ linux-2.6/arch/avr32/kernel/process.c
@@ -330,13 +330,13 @@ int copy_thread(int nr, unsigned long cl
 {
 	struct pt_regs *childregs;
 
-	childregs = ((struct pt_regs *)(THREAD_SIZE + (unsigned long)p->thread_info)) - 1;
+	childregs = ((struct pt_regs *)(THREAD_SIZE + (unsigned long)task_stack_page(p))) - 1;
 	*childregs = *regs;
 
 	if (user_mode(regs))
 		childregs->sp = usp;
 	else
-		childregs->sp = (unsigned long)p->thread_info + THREAD_SIZE;
+		childregs->sp = (unsigned long)task_stack_page(p) + THREAD_SIZE;
 
 	childregs->r12 = 0; /* Set return value for child */
 
@@ -403,7 +403,7 @@ unsigned long get_wchan(struct task_stru
 	if (!p || p == current || p->state == TASK_RUNNING)
 		return 0;
 
-	stack_page = (unsigned long)p->thread_info;
+	stack_page = (unsigned long)task_stack_page(p);
 	BUG_ON(!stack_page);
 
 	/*
Index: linux-2.6/arch/avr32/kernel/ptrace.c
===================================================================
--- linux-2.6.orig/arch/avr32/kernel/ptrace.c
+++ linux-2.6/arch/avr32/kernel/ptrace.c
@@ -25,7 +25,7 @@
 
 static struct pt_regs *get_user_regs(struct task_struct *tsk)
 {
-	return (struct pt_regs *)((unsigned long) tsk->thread_info +
+	return (struct pt_regs *)((unsigned long)task_stack_page(tsk) +
 				  THREAD_SIZE - sizeof(struct pt_regs));
 }
 
Index: linux-2.6/arch/i386/kernel/traps.c
===================================================================
--- linux-2.6.orig/arch/i386/kernel/traps.c
+++ linux-2.6/arch/i386/kernel/traps.c
@@ -319,7 +319,7 @@ void show_registers(struct pt_regs *regs
 	       regs->xds & 0xffff, regs->xes & 0xffff, regs->xfs & 0xffff, gs, ss);
 	printk(KERN_EMERG "Process %.*s (pid: %d, ti=%p task=%p task.ti=%p)",
 		TASK_COMM_LEN, current->comm, current->pid,
-		current_thread_info(), current, current->thread_info);
+		current_thread_info(), current, task_thread_info(current));
 	/*
 	 * When in-kernel, we also print out the stack and code at the
 	 * time of the fault..
Index: linux-2.6/arch/mips/kernel/smtc.c
===================================================================
--- linux-2.6.orig/arch/mips/kernel/smtc.c
+++ linux-2.6/arch/mips/kernel/smtc.c
@@ -560,7 +560,7 @@ void smtc_boot_secondary(int cpu, struct
 	write_tc_gpr_sp(__KSTK_TOS(idle));
 
 	/* global pointer */
-	write_tc_gpr_gp((unsigned long)idle->thread_info);
+	write_tc_gpr_gp((unsigned long)task_thread_info(idle));
 
 	smtc_status |= SMTC_MTC_ACTIVE;
 	write_tc_c0_tchalt(0);
Index: linux-2.6/arch/x86_64/kernel/irq.c
===================================================================
--- linux-2.6.orig/arch/x86_64/kernel/irq.c
+++ linux-2.6/arch/x86_64/kernel/irq.c
@@ -32,7 +32,7 @@ atomic_t irq_err_count;
  */
 static inline void stack_overflow_check(struct pt_regs *regs)
 {
-	u64 curbase = (u64) current->thread_info;
+	u64 curbase = (u64)task_stack_page(current);
 	static unsigned long warned = -60*HZ;
 
 	if (regs->rsp >= curbase && regs->rsp <= curbase + THREAD_SIZE &&
Index: linux-2.6/include/asm-i386/thread_info.h
===================================================================
--- linux-2.6.orig/include/asm-i386/thread_info.h
+++ linux-2.6/include/asm-i386/thread_info.h
@@ -170,7 +170,7 @@ static inline struct thread_info *curren
 #define TS_USEDFPU		0x0001	/* FPU was used by this task this quantum (SMP) */
 #define TS_POLLING		0x0002	/* True if in idle loop and not sleeping */
 
-#define tsk_is_polling(t) ((t)->thread_info->status & TS_POLLING)
+#define tsk_is_polling(t) (task_thread_info(t)->status & TS_POLLING)
 
 #endif /* __KERNEL__ */
 
Index: linux-2.6/include/asm-ia64/thread_info.h
===================================================================
--- linux-2.6.orig/include/asm-ia64/thread_info.h
+++ linux-2.6/include/asm-ia64/thread_info.h
@@ -110,6 +110,6 @@ struct thread_info {
 
 #define TS_POLLING		1 	/* true if in idle loop and not sleeping */
 
-#define tsk_is_polling(t) ((t)->thread_info->status & TS_POLLING)
+#define tsk_is_polling(t) (task_thread_info(t)->status & TS_POLLING)
 
 #endif /* _ASM_IA64_THREAD_INFO_H */
Index: linux-2.6/include/asm-mips/system.h
===================================================================
--- linux-2.6.orig/include/asm-mips/system.h
+++ linux-2.6/include/asm-mips/system.h
@@ -55,7 +55,7 @@ do {									\
 	if (cpu_has_dsp)						\
 		__save_dsp(prev);					\
 	next->thread.emulated_fp = 0;					\
-	(last) = resume(prev, next, next->thread_info);			\
+	(last) = resume(prev, next, task_thread_info(next));		\
 	if (cpu_has_dsp)						\
 		__restore_dsp(current);					\
 } while(0)
Index: linux-2.6/include/asm-parisc/compat.h
===================================================================
--- linux-2.6.orig/include/asm-parisc/compat.h
+++ linux-2.6/include/asm-parisc/compat.h
@@ -152,7 +152,7 @@ static __inline__ void __user *compat_al
 
 static inline int __is_compat_task(struct task_struct *t)
 {
-	return test_ti_thread_flag(t->thread_info, TIF_32BIT);
+	return test_ti_thread_flag(task_thread_info(t), TIF_32BIT);
 }
 
 static inline int is_compat_task(void)
Index: linux-2.6/include/asm-x86_64/thread_info.h
===================================================================
--- linux-2.6.orig/include/asm-x86_64/thread_info.h
+++ linux-2.6/include/asm-x86_64/thread_info.h
@@ -162,7 +162,7 @@ static inline struct thread_info *stack_
 #define TS_COMPAT		0x0002	/* 32bit syscall active */
 #define TS_POLLING		0x0004	/* true if in idle loop and not sleeping */
 
-#define tsk_is_polling(t) ((t)->thread_info->status & TS_POLLING)
+#define tsk_is_polling(t) (task_thread_info(t)->status & TS_POLLING)
 
 #endif /* __KERNEL__ */
 
Index: linux-2.6/kernel/mutex.c
===================================================================
--- linux-2.6.orig/kernel/mutex.c
+++ linux-2.6/kernel/mutex.c
@@ -133,7 +133,7 @@ __mutex_lock_common(struct mutex *lock, 
 
 	debug_mutex_lock_common(lock, &waiter);
 	mutex_acquire(&lock->dep_map, subclass, 0, _RET_IP_);
-	debug_mutex_add_waiter(lock, &waiter, task->thread_info);
+	debug_mutex_add_waiter(lock, &waiter, task_thread_info(task));
 
 	/* add waiting tasks to the end of the waitqueue (FIFO): */
 	list_add_tail(&waiter.list, &lock->wait_list);
@@ -159,7 +159,7 @@ __mutex_lock_common(struct mutex *lock, 
 		 */
 		if (unlikely(state == TASK_INTERRUPTIBLE &&
 						signal_pending(task))) {
-			mutex_remove_waiter(lock, &waiter, task->thread_info);
+			mutex_remove_waiter(lock, &waiter, task_thread_info(task));
 			mutex_release(&lock->dep_map, 1, _RET_IP_);
 			spin_unlock_mutex(&lock->wait_lock, flags);
 
@@ -175,8 +175,8 @@ __mutex_lock_common(struct mutex *lock, 
 	}
 
 	/* got the lock - rejoice! */
-	mutex_remove_waiter(lock, &waiter, task->thread_info);
-	debug_mutex_set_owner(lock, task->thread_info);
+	mutex_remove_waiter(lock, &waiter, task_thread_info(task));
+	debug_mutex_set_owner(lock, task_thread_info(task));
 
 	/* set it to 0 if there are no waiters left: */
 	if (likely(list_empty(&lock->wait_list)))
