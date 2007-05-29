Return-Path: <linux-kernel-owner+w=401wt.eu-S1757934AbXE2OHJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757934AbXE2OHJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 10:07:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756133AbXE2OCt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 10:02:49 -0400
Received: from tayrelbas03.tay.hp.com ([161.114.80.246]:59096 "EHLO
	tayrelbas03.tay.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760788AbXE2OCr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 10:02:47 -0400
Date: Tue, 29 May 2007 06:48:15 -0700
From: Stephane Eranian <eranian@frankl.hpl.hp.com>
Message-Id: <200705291348.l4TDmF4w019619@frankl.hpl.hp.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 01/22] 2.6.22-rc3 perfmon2: arch-specific infrastructure changes
Cc: eranian@hpl.hp.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch contains the remaining infrastructure changes required
for perfmon2 for all architectures. It is expected that this patch
will be obsolete by 2.6.23.

all arch:
	- remove unused TIF_NOTIFY_RESUME (already in -mm)

mips:
	- add smp_call_function_single()





diff -urNp --exclude=.git linux-2.6.22.orig/arch/arm/kernel/entry-common.S linux-2.6.22.base/arch/arm/kernel/entry-common.S
--- linux-2.6.22.orig/arch/arm/kernel/entry-common.S	2007-04-25 20:08:32.000000000 -0700
+++ linux-2.6.22.base/arch/arm/kernel/entry-common.S	2007-05-29 03:20:21.000000000 -0700
@@ -46,7 +46,7 @@ fast_work_pending:
 work_pending:
 	tst	r1, #_TIF_NEED_RESCHED
 	bne	work_resched
-	tst	r1, #_TIF_NOTIFY_RESUME | _TIF_SIGPENDING
+	tst	r1, #_TIF_SIGPENDING
 	beq	no_work_pending
 	mov	r0, sp				@ 'regs'
 	mov	r2, why				@ 'syscall'
diff -urNp --exclude=.git linux-2.6.22.orig/arch/arm26/kernel/entry.S linux-2.6.22.base/arch/arm26/kernel/entry.S
--- linux-2.6.22.orig/arch/arm26/kernel/entry.S	2007-04-25 20:08:32.000000000 -0700
+++ linux-2.6.22.base/arch/arm26/kernel/entry.S	2007-05-29 03:20:21.000000000 -0700
@@ -194,7 +194,7 @@ fast_work_pending:
 work_pending:
 	tst	r1, #_TIF_NEED_RESCHED
 	bne	work_resched
-	tst	r1, #_TIF_NOTIFY_RESUME | _TIF_SIGPENDING
+	tst	r1, #_TIF_SIGPENDING
 	beq	no_work_pending
 	mov	r0, sp				@ 'regs'
 	mov	r2, why				@ 'syscall'
diff -urNp --exclude=.git linux-2.6.22.orig/arch/ia64/kernel/perfmon.c linux-2.6.22.base/arch/ia64/kernel/perfmon.c
--- linux-2.6.22.orig/arch/ia64/kernel/perfmon.c	2007-05-29 03:16:09.000000000 -0700
+++ linux-2.6.22.base/arch/ia64/kernel/perfmon.c	2007-05-29 03:20:21.000000000 -0700
@@ -591,13 +591,13 @@ pfm_set_task_notify(struct task_struct *
 	struct thread_info *info;
 
 	info = (struct thread_info *) ((char *) task + IA64_TASK_SIZE);
-	set_bit(TIF_NOTIFY_RESUME, &info->flags);
+	set_bit(TIF_PERFMON_WORK, &info->flags);
 }
 
 static inline void
 pfm_clear_task_notify(void)
 {
-	clear_thread_flag(TIF_NOTIFY_RESUME);
+	clear_thread_flag(TIF_PERFMON_WORK);
 }
 
 static inline void
diff -urNp --exclude=.git linux-2.6.22.orig/arch/mips/kernel/smp.c linux-2.6.22.base/arch/mips/kernel/smp.c
--- linux-2.6.22.orig/arch/mips/kernel/smp.c	2007-04-25 20:08:32.000000000 -0700
+++ linux-2.6.22.base/arch/mips/kernel/smp.c	2007-05-29 03:20:21.000000000 -0700
@@ -203,6 +203,52 @@ void smp_call_function_interrupt(void)
 	}
 }
 
+int smp_call_function_single (int cpu, void (*func) (void *info), void *info, int retry,
+			      int wait)
+{
+  struct call_data_struct data;
+  int me = smp_processor_id();
+
+  /*
+     * Can die spectacularly if this CPU isn't yet marked online
+      */
+  BUG_ON(!cpu_online(me));
+  if (cpu == me) {
+    WARN_ON(1);
+    return -EBUSY;
+    }
+
+  /* Can deadlock when called with interrupts disabled */
+  WARN_ON(irqs_disabled());
+
+  data.func = func;
+  data.info = info;
+  atomic_set(&data.started, 0);
+  data.wait = wait;
+  if (wait)
+    atomic_set(&data.finished, 0);
+
+  spin_lock(&smp_call_lock);
+  call_data = &data;
+  mb();
+
+  /* Send a message to the other CPU */
+  core_send_ipi(cpu, SMP_CALL_FUNCTION);
+
+  /* Wait for response */
+  /* FIXME: lock-up detection, backtrace on lock-up */
+  while (atomic_read(&data.started) != 1)
+    barrier();
+
+  if (wait)
+    while (atomic_read(&data.finished) != 1)
+      barrier();
+  call_data = NULL;
+  spin_unlock(&smp_call_lock);
+
+  return 0;
+}
+
 static void stop_this_cpu(void *dummy)
 {
 	/*
diff -urNp --exclude=.git linux-2.6.22.orig/arch/powerpc/kernel/entry_64.S linux-2.6.22.base/arch/powerpc/kernel/entry_64.S
--- linux-2.6.22.orig/arch/powerpc/kernel/entry_64.S	2007-04-25 20:08:32.000000000 -0700
+++ linux-2.6.22.base/arch/powerpc/kernel/entry_64.S	2007-05-29 03:20:21.000000000 -0700
@@ -546,7 +546,6 @@ END_FW_FTR_SECTION_IFSET(FW_FEATURE_ISER
 	rfid
 	b	.	/* prevent speculative execution */
 
-/* Note: this must change if we start using the TIF_NOTIFY_RESUME bit */
 do_work:
 #ifdef CONFIG_PREEMPT
 	andi.	r0,r3,MSR_PR	/* Returning to user mode? */
diff -urNp --exclude=.git linux-2.6.22.orig/arch/x86_64/kernel/entry.S linux-2.6.22.base/arch/x86_64/kernel/entry.S
--- linux-2.6.22.orig/arch/x86_64/kernel/entry.S	2007-05-29 03:16:09.000000000 -0700
+++ linux-2.6.22.base/arch/x86_64/kernel/entry.S	2007-05-29 03:20:21.000000000 -0700
@@ -282,7 +282,7 @@ sysret_careful:
 sysret_signal:
 	TRACE_IRQS_ON
 	sti
-	testl $(_TIF_SIGPENDING|_TIF_NOTIFY_RESUME|_TIF_SINGLESTEP),%edx
+	testl $(_TIF_SIGPENDING|_TIF_SINGLESTEP),%edx
 	jz    1f
 
 	/* Really a signal */
@@ -375,7 +375,7 @@ int_very_careful:
 	jmp int_restore_rest
 	
 int_signal:
-	testl $(_TIF_NOTIFY_RESUME|_TIF_SIGPENDING|_TIF_SINGLESTEP),%edx
+	testl $(_TIF_SIGPENDING|_TIF_SINGLESTEP),%edx
 	jz 1f
 	movq %rsp,%rdi		# &ptregs -> arg1
 	xorl %esi,%esi		# oldset -> arg2
@@ -599,7 +599,7 @@ retint_careful:
 	jmp retint_check
 	
 retint_signal:
-	testl $(_TIF_SIGPENDING|_TIF_NOTIFY_RESUME|_TIF_SINGLESTEP),%edx
+	testl $(_TIF_SIGPENDING|_TIF_SINGLESTEP),%edx
 	jz    retint_swapgs
 	TRACE_IRQS_ON
 	sti
diff -urNp --exclude=.git linux-2.6.22.orig/include/asm-alpha/thread_info.h linux-2.6.22.base/include/asm-alpha/thread_info.h
--- linux-2.6.22.orig/include/asm-alpha/thread_info.h	2007-05-29 03:16:27.000000000 -0700
+++ linux-2.6.22.base/include/asm-alpha/thread_info.h	2007-05-29 03:20:21.000000000 -0700
@@ -67,25 +67,22 @@ register struct thread_info *__current_t
  * TIF_SYSCALL_TRACE is known to be 0 via blbs.
  */
 #define TIF_SYSCALL_TRACE	0	/* syscall trace active */
-#define TIF_NOTIFY_RESUME	1	/* resumption notification requested */
-#define TIF_SIGPENDING		2	/* signal pending */
-#define TIF_NEED_RESCHED	3	/* rescheduling necessary */
-#define TIF_POLLING_NRFLAG	4	/* poll_idle is polling NEED_RESCHED */
-#define TIF_DIE_IF_KERNEL	5	/* dik recursion lock */
-#define TIF_UAC_NOPRINT		6	/* see sysinfo.h */
-#define TIF_UAC_NOFIX		7
-#define TIF_UAC_SIGBUS		8
-#define TIF_MEMDIE		9
+#define TIF_SIGPENDING		1	/* signal pending */
+#define TIF_NEED_RESCHED	2	/* rescheduling necessary */
+#define TIF_POLLING_NRFLAG	3	/* poll_idle is polling NEED_RESCHED */
+#define TIF_DIE_IF_KERNEL	4	/* dik recursion lock */
+#define TIF_UAC_NOPRINT		5	/* see sysinfo.h */
+#define TIF_UAC_NOFIX		6
+#define TIF_UAC_SIGBUS		7
+#define TIF_MEMDIE		8
 
 #define _TIF_SYSCALL_TRACE	(1<<TIF_SYSCALL_TRACE)
-#define _TIF_NOTIFY_RESUME	(1<<TIF_NOTIFY_RESUME)
 #define _TIF_SIGPENDING		(1<<TIF_SIGPENDING)
 #define _TIF_NEED_RESCHED	(1<<TIF_NEED_RESCHED)
 #define _TIF_POLLING_NRFLAG	(1<<TIF_POLLING_NRFLAG)
 
 /* Work to do on interrupt/exception return.  */
-#define _TIF_WORK_MASK		(_TIF_NOTIFY_RESUME	\
-				 | _TIF_SIGPENDING	\
+#define _TIF_WORK_MASK		(_TIF_SIGPENDING	\
 				 | _TIF_NEED_RESCHED)
 
 /* Work to do on any return to userspace.  */
diff -urNp --exclude=.git linux-2.6.22.orig/include/asm-arm/thread_info.h linux-2.6.22.base/include/asm-arm/thread_info.h
--- linux-2.6.22.orig/include/asm-arm/thread_info.h	2007-05-29 03:16:27.000000000 -0700
+++ linux-2.6.22.base/include/asm-arm/thread_info.h	2007-05-29 03:20:21.000000000 -0700
@@ -135,22 +135,19 @@ extern void iwmmxt_task_switch(struct th
 /*
  * thread information flags:
  *  TIF_SYSCALL_TRACE	- syscall trace active
- *  TIF_NOTIFY_RESUME	- resumption notification requested
  *  TIF_SIGPENDING	- signal pending
  *  TIF_NEED_RESCHED	- rescheduling necessary
  *  TIF_USEDFPU		- FPU was used by this task this quantum (SMP)
  *  TIF_POLLING_NRFLAG	- true if poll_idle() is polling TIF_NEED_RESCHED
  */
-#define TIF_NOTIFY_RESUME	0
-#define TIF_SIGPENDING		1
-#define TIF_NEED_RESCHED	2
+#define TIF_SIGPENDING		0
+#define TIF_NEED_RESCHED	1
 #define TIF_SYSCALL_TRACE	8
 #define TIF_POLLING_NRFLAG	16
 #define TIF_USING_IWMMXT	17
 #define TIF_MEMDIE		18
 #define TIF_FREEZE		19
 
-#define _TIF_NOTIFY_RESUME	(1 << TIF_NOTIFY_RESUME)
 #define _TIF_SIGPENDING		(1 << TIF_SIGPENDING)
 #define _TIF_NEED_RESCHED	(1 << TIF_NEED_RESCHED)
 #define _TIF_SYSCALL_TRACE	(1 << TIF_SYSCALL_TRACE)
diff -urNp --exclude=.git linux-2.6.22.orig/include/asm-arm26/thread_info.h linux-2.6.22.base/include/asm-arm26/thread_info.h
--- linux-2.6.22.orig/include/asm-arm26/thread_info.h	2007-04-25 20:08:32.000000000 -0700
+++ linux-2.6.22.base/include/asm-arm26/thread_info.h	2007-05-29 03:20:21.000000000 -0700
@@ -110,21 +110,18 @@ extern void free_thread_info(struct thre
 /*
  * thread information flags:
  *  TIF_SYSCALL_TRACE	- syscall trace active
- *  TIF_NOTIFY_RESUME	- resumption notification requested
  *  TIF_SIGPENDING	- signal pending
  *  TIF_NEED_RESCHED	- rescheduling necessary
  *  TIF_USEDFPU		- FPU was used by this task this quantum (SMP)
  *  TIF_POLLING_NRFLAG	- true if poll_idle() is polling TIF_NEED_RESCHED
  */
-#define TIF_NOTIFY_RESUME	0
-#define TIF_SIGPENDING		1
-#define TIF_NEED_RESCHED	2
+#define TIF_SIGPENDING		0
+#define TIF_NEED_RESCHED	1
 #define TIF_SYSCALL_TRACE	8
 #define TIF_USED_FPU		16
 #define TIF_POLLING_NRFLAG	17
 #define TIF_MEMDIE		18
 
-#define _TIF_NOTIFY_RESUME	(1 << TIF_NOTIFY_RESUME)
 #define _TIF_SIGPENDING		(1 << TIF_SIGPENDING)
 #define _TIF_NEED_RESCHED	(1 << TIF_NEED_RESCHED)
 #define _TIF_SYSCALL_TRACE	(1 << TIF_SYSCALL_TRACE)
diff -urNp --exclude=.git linux-2.6.22.orig/include/asm-avr32/thread_info.h linux-2.6.22.base/include/asm-avr32/thread_info.h
--- linux-2.6.22.orig/include/asm-avr32/thread_info.h	2007-05-29 03:16:27.000000000 -0700
+++ linux-2.6.22.base/include/asm-avr32/thread_info.h	2007-05-29 03:20:21.000000000 -0700
@@ -74,20 +74,18 @@ static inline struct thread_info *curren
  * - other flags in MSW
  */
 #define TIF_SYSCALL_TRACE       0       /* syscall trace active */
-#define TIF_NOTIFY_RESUME       1       /* resumption notification requested */
-#define TIF_SIGPENDING          2       /* signal pending */
-#define TIF_NEED_RESCHED        3       /* rescheduling necessary */
-#define TIF_POLLING_NRFLAG      4       /* true if poll_idle() is polling
+#define TIF_SIGPENDING          1       /* signal pending */
+#define TIF_NEED_RESCHED        2       /* rescheduling necessary */
+#define TIF_POLLING_NRFLAG      3       /* true if poll_idle() is polling
 					   TIF_NEED_RESCHED */
-#define TIF_BREAKPOINT		5	/* true if we should break after return */
-#define TIF_SINGLE_STEP		6	/* single step after next break */
-#define TIF_MEMDIE		7
-#define TIF_RESTORE_SIGMASK	8	/* restore signal mask in do_signal */
-#define TIF_CPU_GOING_TO_SLEEP	9	/* CPU is entering sleep 0 mode */
+#define TIF_BREAKPOINT		4	/* true if we should break after return */
+#define TIF_SINGLE_STEP		5	/* single step after next break */
+#define TIF_MEMDIE		6
+#define TIF_RESTORE_SIGMASK	7	/* restore signal mask in do_signal */
+#define TIF_CPU_GOING_TO_SLEEP	8	/* CPU is entering sleep 0 mode */
 #define TIF_USERSPACE		31      /* true if FS sets userspace */
 
 #define _TIF_SYSCALL_TRACE	(1 << TIF_SYSCALL_TRACE)
-#define _TIF_NOTIFY_RESUME	(1 << TIF_NOTIFY_RESUME)
 #define _TIF_SIGPENDING		(1 << TIF_SIGPENDING)
 #define _TIF_NEED_RESCHED	(1 << TIF_NEED_RESCHED)
 #define _TIF_POLLING_NRFLAG	(1 << TIF_POLLING_NRFLAG)
diff -urNp --exclude=.git linux-2.6.22.orig/include/asm-blackfin/thread_info.h linux-2.6.22.base/include/asm-blackfin/thread_info.h
--- linux-2.6.22.orig/include/asm-blackfin/thread_info.h	2007-05-29 03:16:27.000000000 -0700
+++ linux-2.6.22.base/include/asm-blackfin/thread_info.h	2007-05-29 03:20:21.000000000 -0700
@@ -118,18 +118,16 @@ static inline struct thread_info *curren
  * thread information flag bit numbers
  */
 #define TIF_SYSCALL_TRACE	0	/* syscall trace active */
-#define TIF_NOTIFY_RESUME	1	/* resumption notification requested */
-#define TIF_SIGPENDING		2	/* signal pending */
-#define TIF_NEED_RESCHED	3	/* rescheduling necessary */
-#define TIF_POLLING_NRFLAG	4	/* true if poll_idle() is polling
+#define TIF_SIGPENDING		1	/* signal pending */
+#define TIF_NEED_RESCHED	2	/* rescheduling necessary */
+#define TIF_POLLING_NRFLAG	3	/* true if poll_idle() is polling
 					   TIF_NEED_RESCHED */
-#define TIF_MEMDIE              5
-#define TIF_RESTORE_SIGMASK	6	/* restore signal mask in do_signal() */
-#define TIF_FREEZE              7       /* is freezing for suspend */
+#define TIF_MEMDIE              4
+#define TIF_RESTORE_SIGMASK	5	/* restore signal mask in do_signal() */
+#define TIF_FREEZE              6       /* is freezing for suspend */
 
 /* as above, but as bit values */
 #define _TIF_SYSCALL_TRACE	(1<<TIF_SYSCALL_TRACE)
-#define _TIF_NOTIFY_RESUME	(1<<TIF_NOTIFY_RESUME)
 #define _TIF_SIGPENDING		(1<<TIF_SIGPENDING)
 #define _TIF_NEED_RESCHED	(1<<TIF_NEED_RESCHED)
 #define _TIF_POLLING_NRFLAG	(1<<TIF_POLLING_NRFLAG)
diff -urNp --exclude=.git linux-2.6.22.orig/include/asm-cris/thread_info.h linux-2.6.22.base/include/asm-cris/thread_info.h
--- linux-2.6.22.orig/include/asm-cris/thread_info.h	2007-04-25 20:08:32.000000000 -0700
+++ linux-2.6.22.base/include/asm-cris/thread_info.h	2007-05-29 03:20:21.000000000 -0700
@@ -79,14 +79,12 @@ struct thread_info {
  * - other flags in MSW
  */
 #define TIF_SYSCALL_TRACE	0	/* syscall trace active */
-#define TIF_NOTIFY_RESUME	1	/* resumption notification requested */
-#define TIF_SIGPENDING		2	/* signal pending */
-#define TIF_NEED_RESCHED	3	/* rescheduling necessary */
+#define TIF_SIGPENDING		1	/* signal pending */
+#define TIF_NEED_RESCHED	2	/* rescheduling necessary */
 #define TIF_POLLING_NRFLAG	16	/* true if poll_idle() is polling TIF_NEED_RESCHED */
 #define TIF_MEMDIE		17
 
 #define _TIF_SYSCALL_TRACE	(1<<TIF_SYSCALL_TRACE)
-#define _TIF_NOTIFY_RESUME	(1<<TIF_NOTIFY_RESUME)
 #define _TIF_SIGPENDING		(1<<TIF_SIGPENDING)
 #define _TIF_NEED_RESCHED	(1<<TIF_NEED_RESCHED)
 #define _TIF_POLLING_NRFLAG	(1<<TIF_POLLING_NRFLAG)
diff -urNp --exclude=.git linux-2.6.22.orig/include/asm-frv/thread_info.h linux-2.6.22.base/include/asm-frv/thread_info.h
--- linux-2.6.22.orig/include/asm-frv/thread_info.h	2007-04-25 20:08:32.000000000 -0700
+++ linux-2.6.22.base/include/asm-frv/thread_info.h	2007-05-29 03:20:21.000000000 -0700
@@ -108,18 +108,16 @@ register struct thread_info *__current_t
  * - other flags in MSW
  */
 #define TIF_SYSCALL_TRACE	0	/* syscall trace active */
-#define TIF_NOTIFY_RESUME	1	/* resumption notification requested */
-#define TIF_SIGPENDING		2	/* signal pending */
-#define TIF_NEED_RESCHED	3	/* rescheduling necessary */
-#define TIF_SINGLESTEP		4	/* restore singlestep on return to user mode */
-#define TIF_IRET		5	/* return with iret */
-#define TIF_RESTORE_SIGMASK	6	/* restore signal mask in do_signal() */
+#define TIF_SIGPENDING		1	/* signal pending */
+#define TIF_NEED_RESCHED	2	/* rescheduling necessary */
+#define TIF_SINGLESTEP		3	/* restore singlestep on return to user mode */
+#define TIF_IRET		4	/* return with iret */
+#define TIF_RESTORE_SIGMASK	5	/* restore signal mask in do_signal() */
 #define TIF_POLLING_NRFLAG	16	/* true if poll_idle() is polling TIF_NEED_RESCHED */
 #define TIF_MEMDIE		17	/* OOM killer killed process */
 #define TIF_FREEZE		18	/* freezing for suspend */
 
 #define _TIF_SYSCALL_TRACE	(1 << TIF_SYSCALL_TRACE)
-#define _TIF_NOTIFY_RESUME	(1 << TIF_NOTIFY_RESUME)
 #define _TIF_SIGPENDING		(1 << TIF_SIGPENDING)
 #define _TIF_NEED_RESCHED	(1 << TIF_NEED_RESCHED)
 #define _TIF_SINGLESTEP		(1 << TIF_SINGLESTEP)
diff -urNp --exclude=.git linux-2.6.22.orig/include/asm-h8300/thread_info.h linux-2.6.22.base/include/asm-h8300/thread_info.h
--- linux-2.6.22.orig/include/asm-h8300/thread_info.h	2007-04-25 20:08:32.000000000 -0700
+++ linux-2.6.22.base/include/asm-h8300/thread_info.h	2007-05-29 03:20:21.000000000 -0700
@@ -86,16 +86,14 @@ static inline struct thread_info *curren
  * thread information flag bit numbers
  */
 #define TIF_SYSCALL_TRACE	0	/* syscall trace active */
-#define TIF_NOTIFY_RESUME	1	/* resumption notification requested */
-#define TIF_SIGPENDING		2	/* signal pending */
-#define TIF_NEED_RESCHED	3	/* rescheduling necessary */
-#define TIF_POLLING_NRFLAG	4	/* true if poll_idle() is polling
+#define TIF_SIGPENDING		1	/* signal pending */
+#define TIF_NEED_RESCHED	2	/* rescheduling necessary */
+#define TIF_POLLING_NRFLAG	3	/* true if poll_idle() is polling
 					   TIF_NEED_RESCHED */
-#define TIF_MEMDIE		5
+#define TIF_MEMDIE		4
 
 /* as above, but as bit values */
 #define _TIF_SYSCALL_TRACE	(1<<TIF_SYSCALL_TRACE)
-#define _TIF_NOTIFY_RESUME	(1<<TIF_NOTIFY_RESUME)
 #define _TIF_SIGPENDING		(1<<TIF_SIGPENDING)
 #define _TIF_NEED_RESCHED	(1<<TIF_NEED_RESCHED)
 #define _TIF_POLLING_NRFLAG	(1<<TIF_POLLING_NRFLAG)
diff -urNp --exclude=.git linux-2.6.22.orig/include/asm-i386/thread_info.h linux-2.6.22.base/include/asm-i386/thread_info.h
--- linux-2.6.22.orig/include/asm-i386/thread_info.h	2007-05-29 03:16:27.000000000 -0700
+++ linux-2.6.22.base/include/asm-i386/thread_info.h	2007-05-29 03:20:21.000000000 -0700
@@ -124,22 +124,20 @@ static inline struct thread_info *curren
  * - other flags in MSW
  */
 #define TIF_SYSCALL_TRACE	0	/* syscall trace active */
-#define TIF_NOTIFY_RESUME	1	/* resumption notification requested */
-#define TIF_SIGPENDING		2	/* signal pending */
-#define TIF_NEED_RESCHED	3	/* rescheduling necessary */
-#define TIF_SINGLESTEP		4	/* restore singlestep on return to user mode */
-#define TIF_IRET		5	/* return with iret */
-#define TIF_SYSCALL_EMU		6	/* syscall emulation active */
-#define TIF_SYSCALL_AUDIT	7	/* syscall auditing active */
-#define TIF_SECCOMP		8	/* secure computing */
-#define TIF_RESTORE_SIGMASK	9	/* restore signal mask in do_signal() */
+#define TIF_SIGPENDING		1	/* signal pending */
+#define TIF_NEED_RESCHED	2	/* rescheduling necessary */
+#define TIF_SINGLESTEP		3	/* restore singlestep on return to user mode */
+#define TIF_IRET		4	/* return with iret */
+#define TIF_SYSCALL_EMU		5	/* syscall emulation active */
+#define TIF_SYSCALL_AUDIT	6	/* syscall auditing active */
+#define TIF_SECCOMP		7	/* secure computing */
+#define TIF_RESTORE_SIGMASK	8	/* restore signal mask in do_signal() */
 #define TIF_MEMDIE		16
 #define TIF_DEBUG		17	/* uses debug registers */
 #define TIF_IO_BITMAP		18	/* uses I/O bitmap */
 #define TIF_FREEZE		19	/* is freezing for suspend */
 
 #define _TIF_SYSCALL_TRACE	(1<<TIF_SYSCALL_TRACE)
-#define _TIF_NOTIFY_RESUME	(1<<TIF_NOTIFY_RESUME)
 #define _TIF_SIGPENDING		(1<<TIF_SIGPENDING)
 #define _TIF_NEED_RESCHED	(1<<TIF_NEED_RESCHED)
 #define _TIF_SINGLESTEP		(1<<TIF_SINGLESTEP)
diff -urNp --exclude=.git linux-2.6.22.orig/include/asm-ia64/thread_info.h linux-2.6.22.base/include/asm-ia64/thread_info.h
--- linux-2.6.22.orig/include/asm-ia64/thread_info.h	2007-05-29 03:16:27.000000000 -0700
+++ linux-2.6.22.base/include/asm-ia64/thread_info.h	2007-05-29 03:20:21.000000000 -0700
@@ -79,13 +79,13 @@ struct thread_info {
  * - pending work-to-be-done flags are in least-significant 16 bits, other flags
  *   in top 16 bits
  */
-#define TIF_NOTIFY_RESUME	0	/* resumption notification requested */
-#define TIF_SIGPENDING		1	/* signal pending */
-#define TIF_NEED_RESCHED	2	/* rescheduling necessary */
-#define TIF_SYSCALL_TRACE	3	/* syscall trace active */
-#define TIF_SYSCALL_AUDIT	4	/* syscall auditing active */
-#define TIF_SINGLESTEP		5	/* restore singlestep on return to user mode */
-#define TIF_RESTORE_SIGMASK	6	/* restore signal mask in do_signal() */
+#define TIF_SIGPENDING		0	/* signal pending */
+#define TIF_NEED_RESCHED	1	/* rescheduling necessary */
+#define TIF_SYSCALL_TRACE	2	/* syscall trace active */
+#define TIF_SYSCALL_AUDIT	3	/* syscall auditing active */
+#define TIF_SINGLESTEP		4	/* restore singlestep on return to user mode */
+#define TIF_RESTORE_SIGMASK	5	/* restore signal mask in do_signal() */
+#define TIF_PERFMON_WORK	6	/* work for pfm_handle_work() */
 #define TIF_POLLING_NRFLAG	16	/* true if poll_idle() is polling TIF_NEED_RESCHED */
 #define TIF_MEMDIE		17
 #define TIF_MCA_INIT		18	/* this task is processing MCA or INIT */
@@ -96,8 +96,8 @@ struct thread_info {
 #define _TIF_SYSCALL_AUDIT	(1 << TIF_SYSCALL_AUDIT)
 #define _TIF_SINGLESTEP		(1 << TIF_SINGLESTEP)
 #define _TIF_SYSCALL_TRACEAUDIT	(_TIF_SYSCALL_TRACE|_TIF_SYSCALL_AUDIT|_TIF_SINGLESTEP)
-#define _TIF_NOTIFY_RESUME	(1 << TIF_NOTIFY_RESUME)
 #define _TIF_RESTORE_SIGMASK	(1 << TIF_RESTORE_SIGMASK)
+#define _TIF_PERFMON_WORK	(1 << TIF_PERFMON_WORK)
 #define _TIF_SIGPENDING		(1 << TIF_SIGPENDING)
 #define _TIF_NEED_RESCHED	(1 << TIF_NEED_RESCHED)
 #define _TIF_POLLING_NRFLAG	(1 << TIF_POLLING_NRFLAG)
@@ -106,7 +106,9 @@ struct thread_info {
 #define _TIF_FREEZE		(1 << TIF_FREEZE)
 
 /* "work to do on user-return" bits */
-#define TIF_ALLWORK_MASK	(_TIF_NOTIFY_RESUME|_TIF_SIGPENDING|_TIF_NEED_RESCHED|_TIF_SYSCALL_TRACE|_TIF_SYSCALL_AUDIT|_TIF_RESTORE_SIGMASK)
+#define TIF_ALLWORK_MASK	(_TIF_SIGPENDING|_TIF_PERFMON_WORK|_TIF_SYSCALL_AUDIT|\
+				 _TIF_NEED_RESCHED| _TIF_SYSCALL_TRACE|\
+				 _TIF_RESTORE_SIGMASK)
 /* like TIF_ALLWORK_BITS but sans TIF_SYSCALL_TRACE or TIF_SYSCALL_AUDIT */
 #define TIF_WORK_MASK		(TIF_ALLWORK_MASK&~(_TIF_SYSCALL_TRACE|_TIF_SYSCALL_AUDIT))
 
diff -urNp --exclude=.git linux-2.6.22.orig/include/asm-m32r/thread_info.h linux-2.6.22.base/include/asm-m32r/thread_info.h
--- linux-2.6.22.orig/include/asm-m32r/thread_info.h	2007-04-25 20:08:32.000000000 -0700
+++ linux-2.6.22.base/include/asm-m32r/thread_info.h	2007-05-29 03:20:21.000000000 -0700
@@ -146,17 +146,15 @@ static inline unsigned int get_thread_fa
  * - other flags in MSW
  */
 #define TIF_SYSCALL_TRACE	0	/* syscall trace active */
-#define TIF_NOTIFY_RESUME	1	/* resumption notification requested */
-#define TIF_SIGPENDING		2	/* signal pending */
-#define TIF_NEED_RESCHED	3	/* rescheduling necessary */
-#define TIF_SINGLESTEP		4	/* restore singlestep on return to user mode */
-#define TIF_IRET		5	/* return with iret */
+#define TIF_SIGPENDING		1	/* signal pending */
+#define TIF_NEED_RESCHED	2	/* rescheduling necessary */
+#define TIF_SINGLESTEP		3	/* restore singlestep on return to user mode */
+#define TIF_IRET		4	/* return with iret */
 #define TIF_POLLING_NRFLAG	16	/* true if poll_idle() is polling TIF_NEED_RESCHED */
 					/* 31..28 fault code */
 #define TIF_MEMDIE		17
 
 #define _TIF_SYSCALL_TRACE	(1<<TIF_SYSCALL_TRACE)
-#define _TIF_NOTIFY_RESUME	(1<<TIF_NOTIFY_RESUME)
 #define _TIF_SIGPENDING		(1<<TIF_SIGPENDING)
 #define _TIF_NEED_RESCHED	(1<<TIF_NEED_RESCHED)
 #define _TIF_SINGLESTEP		(1<<TIF_SINGLESTEP)
diff -urNp --exclude=.git linux-2.6.22.orig/include/asm-m68knommu/thread_info.h linux-2.6.22.base/include/asm-m68knommu/thread_info.h
--- linux-2.6.22.orig/include/asm-m68knommu/thread_info.h	2007-04-25 20:08:32.000000000 -0700
+++ linux-2.6.22.base/include/asm-m68knommu/thread_info.h	2007-05-29 03:20:21.000000000 -0700
@@ -83,16 +83,14 @@ static inline struct thread_info *curren
  * thread information flag bit numbers
  */
 #define TIF_SYSCALL_TRACE	0	/* syscall trace active */
-#define TIF_NOTIFY_RESUME	1	/* resumption notification requested */
-#define TIF_SIGPENDING		2	/* signal pending */
-#define TIF_NEED_RESCHED	3	/* rescheduling necessary */
-#define TIF_POLLING_NRFLAG	4	/* true if poll_idle() is polling
+#define TIF_SIGPENDING		1	/* signal pending */
+#define TIF_NEED_RESCHED	2	/* rescheduling necessary */
+#define TIF_POLLING_NRFLAG	3	/* true if poll_idle() is polling
 					   TIF_NEED_RESCHED */
-#define TIF_MEMDIE		5
+#define TIF_MEMDIE		4
 
 /* as above, but as bit values */
 #define _TIF_SYSCALL_TRACE	(1<<TIF_SYSCALL_TRACE)
-#define _TIF_NOTIFY_RESUME	(1<<TIF_NOTIFY_RESUME)
 #define _TIF_SIGPENDING		(1<<TIF_SIGPENDING)
 #define _TIF_NEED_RESCHED	(1<<TIF_NEED_RESCHED)
 #define _TIF_POLLING_NRFLAG	(1<<TIF_POLLING_NRFLAG)
diff -urNp --exclude=.git linux-2.6.22.orig/include/asm-mips/smp.h linux-2.6.22.base/include/asm-mips/smp.h
--- linux-2.6.22.orig/include/asm-mips/smp.h	2007-04-25 20:08:32.000000000 -0700
+++ linux-2.6.22.base/include/asm-mips/smp.h	2007-05-29 03:20:21.000000000 -0700
@@ -109,6 +109,8 @@ static inline void smp_send_reschedule(i
 	core_send_ipi(cpu, SMP_RESCHEDULE_YOURSELF);
 }
 
+extern int smp_call_function_single(int cpuid, void (*func) (void *info),
+				void *info, int retry, int wait);
 extern asmlinkage void smp_call_function_interrupt(void);
 
 #endif /* CONFIG_SMP */
diff -urNp --exclude=.git linux-2.6.22.orig/include/asm-mips/thread_info.h linux-2.6.22.base/include/asm-mips/thread_info.h
--- linux-2.6.22.orig/include/asm-mips/thread_info.h	2007-04-25 20:08:32.000000000 -0700
+++ linux-2.6.22.base/include/asm-mips/thread_info.h	2007-05-29 03:20:21.000000000 -0700
@@ -109,11 +109,10 @@ register struct thread_info *__current_t
  * - pending work-to-be-done flags are in LSW
  * - other flags in MSW
  */
-#define TIF_NOTIFY_RESUME	1	/* resumption notification requested */
-#define TIF_SIGPENDING		2	/* signal pending */
-#define TIF_NEED_RESCHED	3	/* rescheduling necessary */
-#define TIF_SYSCALL_AUDIT	4	/* syscall auditing active */
-#define TIF_SECCOMP		5	/* secure computing */
+#define TIF_SIGPENDING		1	/* signal pending */
+#define TIF_NEED_RESCHED	2	/* rescheduling necessary */
+#define TIF_SYSCALL_AUDIT	3	/* syscall auditing active */
+#define TIF_SECCOMP		4	/* secure computing */
 #define TIF_RESTORE_SIGMASK	9	/* restore signal mask in do_signal() */
 #define TIF_USEDFPU		16	/* FPU was used by this task this quantum (SMP) */
 #define TIF_POLLING_NRFLAG	17	/* true if poll_idle() is polling TIF_NEED_RESCHED */
@@ -122,7 +121,6 @@ register struct thread_info *__current_t
 #define TIF_SYSCALL_TRACE	31	/* syscall trace active */
 
 #define _TIF_SYSCALL_TRACE	(1<<TIF_SYSCALL_TRACE)
-#define _TIF_NOTIFY_RESUME	(1<<TIF_NOTIFY_RESUME)
 #define _TIF_SIGPENDING		(1<<TIF_SIGPENDING)
 #define _TIF_NEED_RESCHED	(1<<TIF_NEED_RESCHED)
 #define _TIF_SYSCALL_AUDIT	(1<<TIF_SYSCALL_AUDIT)
diff -urNp --exclude=.git linux-2.6.22.orig/include/asm-parisc/thread_info.h linux-2.6.22.base/include/asm-parisc/thread_info.h
--- linux-2.6.22.orig/include/asm-parisc/thread_info.h	2007-04-25 20:08:32.000000000 -0700
+++ linux-2.6.22.base/include/asm-parisc/thread_info.h	2007-05-29 03:20:21.000000000 -0700
@@ -56,23 +56,21 @@ struct thread_info {
  * thread information flags
  */
 #define TIF_SYSCALL_TRACE	0	/* syscall trace active */
-#define TIF_NOTIFY_RESUME	1	/* resumption notification requested */
-#define TIF_SIGPENDING		2	/* signal pending */
-#define TIF_NEED_RESCHED	3	/* rescheduling necessary */
-#define TIF_POLLING_NRFLAG	4	/* true if poll_idle() is polling TIF_NEED_RESCHED */
-#define TIF_32BIT               5       /* 32 bit binary */
-#define TIF_MEMDIE		6
-#define TIF_RESTORE_SIGMASK	7	/* restore saved signal mask */
+#define TIF_SIGPENDING		1	/* signal pending */
+#define TIF_NEED_RESCHED	2	/* rescheduling necessary */
+#define TIF_POLLING_NRFLAG	3	/* true if poll_idle() is polling TIF_NEED_RESCHED */
+#define TIF_32BIT               4       /* 32 bit binary */
+#define TIF_MEMDIE		5
+#define TIF_RESTORE_SIGMASK	6	/* restore saved signal mask */
 
 #define _TIF_SYSCALL_TRACE	(1 << TIF_SYSCALL_TRACE)
-#define _TIF_NOTIFY_RESUME	(1 << TIF_NOTIFY_RESUME)
 #define _TIF_SIGPENDING		(1 << TIF_SIGPENDING)
 #define _TIF_NEED_RESCHED	(1 << TIF_NEED_RESCHED)
 #define _TIF_POLLING_NRFLAG	(1 << TIF_POLLING_NRFLAG)
 #define _TIF_32BIT		(1 << TIF_32BIT)
 #define _TIF_RESTORE_SIGMASK	(1 << TIF_RESTORE_SIGMASK)
 
-#define _TIF_USER_WORK_MASK     (_TIF_NOTIFY_RESUME | _TIF_SIGPENDING | \
+#define _TIF_USER_WORK_MASK     (_TIF_SIGPENDING | \
                                  _TIF_NEED_RESCHED | _TIF_RESTORE_SIGMASK)
 
 #endif /* __KERNEL__ */
diff -urNp --exclude=.git linux-2.6.22.orig/include/asm-powerpc/thread_info.h linux-2.6.22.base/include/asm-powerpc/thread_info.h
--- linux-2.6.22.orig/include/asm-powerpc/thread_info.h	2007-04-25 20:08:32.000000000 -0700
+++ linux-2.6.22.base/include/asm-powerpc/thread_info.h	2007-05-29 03:20:21.000000000 -0700
@@ -107,26 +107,24 @@ static inline struct thread_info *curren
  * thread information flag bit numbers
  */
 #define TIF_SYSCALL_TRACE	0	/* syscall trace active */
-#define TIF_NOTIFY_RESUME	1	/* resumption notification requested */
-#define TIF_SIGPENDING		2	/* signal pending */
-#define TIF_NEED_RESCHED	3	/* rescheduling necessary */
-#define TIF_POLLING_NRFLAG	4	/* true if poll_idle() is polling
+#define TIF_SIGPENDING		1	/* signal pending */
+#define TIF_NEED_RESCHED	2	/* rescheduling necessary */
+#define TIF_POLLING_NRFLAG	3	/* true if poll_idle() is polling
 					   TIF_NEED_RESCHED */
-#define TIF_32BIT		5	/* 32 bit binary */
-#define TIF_RUNLATCH		6	/* Is the runlatch enabled? */
-#define TIF_ABI_PENDING		7	/* 32/64 bit switch needed */
-#define TIF_SYSCALL_AUDIT	8	/* syscall auditing active */
-#define TIF_SINGLESTEP		9	/* singlestepping active */
-#define TIF_MEMDIE		10
-#define TIF_SECCOMP		11	/* secure computing */
-#define TIF_RESTOREALL		12	/* Restore all regs (implies NOERROR) */
+#define TIF_32BIT		4	/* 32 bit binary */
+#define TIF_RUNLATCH		5	/* Is the runlatch enabled? */
+#define TIF_ABI_PENDING		6	/* 32/64 bit switch needed */
+#define TIF_SYSCALL_AUDIT	7	/* syscall auditing active */
+#define TIF_SINGLESTEP		8	/* singlestepping active */
+#define TIF_MEMDIE		9
+#define TIF_SECCOMP		10	/* secure computing */
+#define TIF_RESTOREALL		11	/* Restore all regs (implies NOERROR) */
 #define TIF_NOERROR		14	/* Force successful syscall return */
 #define TIF_RESTORE_SIGMASK	15	/* Restore signal mask in do_signal */
 #define TIF_FREEZE		16	/* Freezing for suspend */
 
 /* as above, but as bit values */
 #define _TIF_SYSCALL_TRACE	(1<<TIF_SYSCALL_TRACE)
-#define _TIF_NOTIFY_RESUME	(1<<TIF_NOTIFY_RESUME)
 #define _TIF_SIGPENDING		(1<<TIF_SIGPENDING)
 #define _TIF_NEED_RESCHED	(1<<TIF_NEED_RESCHED)
 #define _TIF_POLLING_NRFLAG	(1<<TIF_POLLING_NRFLAG)
@@ -142,7 +140,7 @@ static inline struct thread_info *curren
 #define _TIF_FREEZE		(1<<TIF_FREEZE)
 #define _TIF_SYSCALL_T_OR_A	(_TIF_SYSCALL_TRACE|_TIF_SYSCALL_AUDIT|_TIF_SECCOMP)
 
-#define _TIF_USER_WORK_MASK	(_TIF_NOTIFY_RESUME | _TIF_SIGPENDING | \
+#define _TIF_USER_WORK_MASK	( _TIF_SIGPENDING | \
 				 _TIF_NEED_RESCHED | _TIF_RESTORE_SIGMASK)
 #define _TIF_PERSYSCALL_MASK	(_TIF_RESTOREALL|_TIF_NOERROR)
 
diff -urNp --exclude=.git linux-2.6.22.orig/include/asm-sh/thread_info.h linux-2.6.22.base/include/asm-sh/thread_info.h
--- linux-2.6.22.orig/include/asm-sh/thread_info.h	2007-04-25 20:08:32.000000000 -0700
+++ linux-2.6.22.base/include/asm-sh/thread_info.h	2007-05-29 03:20:21.000000000 -0700
@@ -107,18 +107,16 @@ static inline struct thread_info *curren
  * - other flags in MSW
  */
 #define TIF_SYSCALL_TRACE	0	/* syscall trace active */
-#define TIF_NOTIFY_RESUME	1	/* resumption notification requested */
-#define TIF_SIGPENDING		2	/* signal pending */
-#define TIF_NEED_RESCHED	3	/* rescheduling necessary */
-#define TIF_RESTORE_SIGMASK	4	/* restore signal mask in do_signal() */
-#define TIF_SINGLESTEP		5	/* singlestepping active */
+#define TIF_SIGPENDING		1	/* signal pending */
+#define TIF_NEED_RESCHED	2	/* rescheduling necessary */
+#define TIF_RESTORE_SIGMASK	3	/* restore signal mask in do_signal() */
+#define TIF_SINGLESTEP		4	/* singlestepping active */
 #define TIF_USEDFPU		16	/* FPU was used by this task this quantum (SMP) */
 #define TIF_POLLING_NRFLAG	17	/* true if poll_idle() is polling TIF_NEED_RESCHED */
 #define TIF_MEMDIE		18
 #define TIF_FREEZE		19
 
 #define _TIF_SYSCALL_TRACE	(1<<TIF_SYSCALL_TRACE)
-#define _TIF_NOTIFY_RESUME	(1<<TIF_NOTIFY_RESUME)
 #define _TIF_SIGPENDING		(1<<TIF_SIGPENDING)
 #define _TIF_NEED_RESCHED	(1<<TIF_NEED_RESCHED)
 #define _TIF_RESTORE_SIGMASK	(1<<TIF_RESTORE_SIGMASK)
diff -urNp --exclude=.git linux-2.6.22.orig/include/asm-v850/thread_info.h linux-2.6.22.base/include/asm-v850/thread_info.h
--- linux-2.6.22.orig/include/asm-v850/thread_info.h	2007-04-25 20:08:32.000000000 -0700
+++ linux-2.6.22.base/include/asm-v850/thread_info.h	2007-05-29 03:20:21.000000000 -0700
@@ -77,16 +77,14 @@ struct thread_info {
  * thread information flag bit numbers
  */
 #define TIF_SYSCALL_TRACE	0	/* syscall trace active */
-#define TIF_NOTIFY_RESUME	1	/* resumption notification requested */
-#define TIF_SIGPENDING		2	/* signal pending */
-#define TIF_NEED_RESCHED	3	/* rescheduling necessary */
-#define TIF_POLLING_NRFLAG	4	/* true if poll_idle() is polling
+#define TIF_SIGPENDING		1	/* signal pending */
+#define TIF_NEED_RESCHED	2	/* rescheduling necessary */
+#define TIF_POLLING_NRFLAG	3	/* true if poll_idle() is polling
 					   TIF_NEED_RESCHED */
-#define TIF_MEMDIE		5
+#define TIF_MEMDIE		4
 
 /* as above, but as bit values */
 #define _TIF_SYSCALL_TRACE	(1<<TIF_SYSCALL_TRACE)
-#define _TIF_NOTIFY_RESUME	(1<<TIF_NOTIFY_RESUME)
 #define _TIF_SIGPENDING		(1<<TIF_SIGPENDING)
 #define _TIF_NEED_RESCHED	(1<<TIF_NEED_RESCHED)
 #define _TIF_POLLING_NRFLAG	(1<<TIF_POLLING_NRFLAG)
diff -urNp --exclude=.git linux-2.6.22.orig/include/asm-x86_64/thread_info.h linux-2.6.22.base/include/asm-x86_64/thread_info.h
--- linux-2.6.22.orig/include/asm-x86_64/thread_info.h	2007-05-29 03:16:27.000000000 -0700
+++ linux-2.6.22.base/include/asm-x86_64/thread_info.h	2007-05-29 03:20:21.000000000 -0700
@@ -107,14 +107,13 @@ static inline struct thread_info *stack_
  * Warning: layout of LSW is hardcoded in entry.S
  */
 #define TIF_SYSCALL_TRACE	0	/* syscall trace active */
-#define TIF_NOTIFY_RESUME	1	/* resumption notification requested */
-#define TIF_SIGPENDING		2	/* signal pending */
-#define TIF_NEED_RESCHED	3	/* rescheduling necessary */
-#define TIF_SINGLESTEP		4	/* reenable singlestep on user return*/
-#define TIF_IRET		5	/* force IRET */
-#define TIF_SYSCALL_AUDIT	7	/* syscall auditing active */
-#define TIF_SECCOMP		8	/* secure computing */
-#define TIF_RESTORE_SIGMASK	9	/* restore signal mask in do_signal */
+#define TIF_SIGPENDING		1	/* signal pending */
+#define TIF_NEED_RESCHED	2	/* rescheduling necessary */
+#define TIF_SINGLESTEP		3	/* reenable singlestep on user return*/
+#define TIF_IRET		4	/* force IRET */
+#define TIF_SYSCALL_AUDIT	5	/* syscall auditing active */
+#define TIF_SECCOMP		6	/* secure computing */
+#define TIF_RESTORE_SIGMASK	7	/* restore signal mask in do_signal */
 /* 16 free */
 #define TIF_IA32		17	/* 32bit process */ 
 #define TIF_FORK		18	/* ret_from_fork */
@@ -125,7 +124,6 @@ static inline struct thread_info *stack_
 #define TIF_FREEZE		23	/* is freezing for suspend */
 
 #define _TIF_SYSCALL_TRACE	(1<<TIF_SYSCALL_TRACE)
-#define _TIF_NOTIFY_RESUME	(1<<TIF_NOTIFY_RESUME)
 #define _TIF_SIGPENDING		(1<<TIF_SIGPENDING)
 #define _TIF_SINGLESTEP		(1<<TIF_SINGLESTEP)
 #define _TIF_NEED_RESCHED	(1<<TIF_NEED_RESCHED)
diff -urNp --exclude=.git linux-2.6.22.orig/include/asm-xtensa/thread_info.h linux-2.6.22.base/include/asm-xtensa/thread_info.h
--- linux-2.6.22.orig/include/asm-xtensa/thread_info.h	2007-04-25 20:08:32.000000000 -0700
+++ linux-2.6.22.base/include/asm-xtensa/thread_info.h	2007-05-29 03:20:21.000000000 -0700
@@ -110,16 +110,14 @@ static inline struct thread_info *curren
  * - other flags in MSW
  */
 #define TIF_SYSCALL_TRACE	0	/* syscall trace active */
-#define TIF_NOTIFY_RESUME	1	/* resumption notification requested */
-#define TIF_SIGPENDING		2	/* signal pending */
-#define TIF_NEED_RESCHED	3	/* rescheduling necessary */
-#define TIF_SINGLESTEP		4	/* restore singlestep on return to user mode */
-#define TIF_IRET		5	/* return with iret */
-#define TIF_MEMDIE		6
+#define TIF_SIGPENDING		1	/* signal pending */
+#define TIF_NEED_RESCHED	2	/* rescheduling necessary */
+#define TIF_SINGLESTEP		3	/* restore singlestep on return to user mode */
+#define TIF_IRET		4	/* return with iret */
+#define TIF_MEMDIE		5
 #define TIF_POLLING_NRFLAG	16	/* true if poll_idle() is polling TIF_NEED_RESCHED */
 
 #define _TIF_SYSCALL_TRACE	(1<<TIF_SYSCALL_TRACE)
-#define _TIF_NOTIFY_RESUME	(1<<TIF_NOTIFY_RESUME)
 #define _TIF_SIGPENDING		(1<<TIF_SIGPENDING)
 #define _TIF_NEED_RESCHED	(1<<TIF_NEED_RESCHED)
 #define _TIF_SINGLESTEP		(1<<TIF_SINGLESTEP)
