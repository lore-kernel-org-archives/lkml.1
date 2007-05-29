Return-Path: <linux-kernel-owner+w=401wt.eu-S1754164AbXE2OAY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754164AbXE2OAY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 10:00:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750912AbXE2N7o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 09:59:44 -0400
Received: from madara.hpl.hp.com ([192.6.19.124]:56272 "EHLO madara.hpl.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750699AbXE2N7m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 09:59:42 -0400
X-Greylist: delayed 659 seconds by postgrey-1.27 at vger.kernel.org; Tue, 29 May 2007 09:59:42 EDT
Date: Tue, 29 May 2007 06:48:31 -0700
From: Stephane Eranian <eranian@frankl.hpl.hp.com>
Message-Id: <200705291348.l4TDmVGp019827@frankl.hpl.hp.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 17/22] 2.6.22-rc3 perfmon2 : modified powerpc files
Cc: eranian@hpl.hp.com
X-HPL-MailScanner: Found to be clean
X-HPL-MailScanner-From: eranian@frankl.hpl.hp.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch contains the modified powerpc files.


The modified files are as follows:

arch/powerpc/Kconfig:
	- add link to perfmon menuconfig options

arch/powerpc/Makefile:
	- add perfmon subdir

arch/powerpc/kernel/entry_64.S:
	- add hook for extra work before kernel exit. Need to block a thread after a overflow with
	  user level notification. Also needed to do some bookeeeping, such as reset certain counters
	  and cleanup in some difficult corner cases

arch/powerpc/kernel/process.c:
	- add hook in exit_thread() to cleanup perfmon2 context
	- add hook in copy_thread() to cleanup perfmon2 context in child (perfmon2 context
	  is never inherited)
	- add hook in __switch_to() for PMU state save/restore

arch/powerpc/kernel/systbl.S:
	- add new system calls definitions

include/asm-powerpc/thread_info.h:
	- add TIF_PERFMON which is used for PMU context switching in __switch_to()

include/asm-powerpc/unistd.h:
	- add new system calls




diff --exclude=.git -urp linux-2.6.22.base/arch/powerpc/Kconfig linux-2.6.22/arch/powerpc/Kconfig
--- linux-2.6.22.base/arch/powerpc/Kconfig	2007-05-29 03:17:16.000000000 -0700
+++ linux-2.6.22/arch/powerpc/Kconfig	2007-05-29 03:24:14.000000000 -0700
@@ -392,6 +392,9 @@ config NOT_COHERENT_CACHE
 
 config CONFIG_CHECK_CACHE_COHERENCY
 	bool
+ 
+source "arch/powerpc/perfmon/Kconfig"
+
 endmenu
 
 source "init/Kconfig"
diff --exclude=.git -urp linux-2.6.22.base/arch/powerpc/Makefile linux-2.6.22/arch/powerpc/Makefile
--- linux-2.6.22.base/arch/powerpc/Makefile	2007-05-29 03:17:16.000000000 -0700
+++ linux-2.6.22/arch/powerpc/Makefile	2007-05-29 03:24:14.000000000 -0700
@@ -137,6 +137,7 @@ core-y				+= arch/powerpc/kernel/ \
 				   arch/powerpc/platforms/
 core-$(CONFIG_MATH_EMULATION)	+= arch/powerpc/math-emu/
 core-$(CONFIG_XMON)		+= arch/powerpc/xmon/
+core-$(CONFIG_PERFMON)		+= arch/powerpc/perfmon/
 
 drivers-$(CONFIG_OPROFILE)	+= arch/powerpc/oprofile/
 
diff --exclude=.git -urp linux-2.6.22.base/arch/powerpc/kernel/entry_32.S linux-2.6.22/arch/powerpc/kernel/entry_32.S
--- linux-2.6.22.base/arch/powerpc/kernel/entry_32.S	2007-05-29 03:17:16.000000000 -0700
+++ linux-2.6.22/arch/powerpc/kernel/entry_32.S	2007-05-29 03:24:14.000000000 -0700
@@ -38,7 +38,7 @@
  * MSR_KERNEL is > 0x10000 on 4xx/Book-E since it include MSR_CE.
  */
 #if MSR_KERNEL >= 0x10000
-#define LOAD_MSR_KERNEL(r, x)	lis r,(x)@h; ori r,r,(x)@l
+#define LOAD_MSR_KERNEL(r, x)	lis r,(x)@ha; ori r,r,(x)@l
 #else
 #define LOAD_MSR_KERNEL(r, x)	li r,(x)
 #endif
diff --exclude=.git -urp linux-2.6.22.base/arch/powerpc/kernel/entry_64.S linux-2.6.22/arch/powerpc/kernel/entry_64.S
--- linux-2.6.22.base/arch/powerpc/kernel/entry_64.S	2007-05-29 03:20:21.000000000 -0700
+++ linux-2.6.22/arch/powerpc/kernel/entry_64.S	2007-05-29 03:24:14.000000000 -0700
@@ -587,6 +587,10 @@ user_work:
 	b	.ret_from_except_lite
 
 1:	bl	.save_nvgprs
+#ifdef CONFIG_PERFMON
+	addi	r3,r1,STACK_FRAME_OVERHEAD
+	bl	.__pfm_handle_work
+#endif /* CONFIG_PERFMON */
 	li	r3,0
 	addi	r4,r1,STACK_FRAME_OVERHEAD
 	bl	.do_signal
diff --exclude=.git -urp linux-2.6.22.base/arch/powerpc/kernel/process.c linux-2.6.22/arch/powerpc/kernel/process.c
--- linux-2.6.22.base/arch/powerpc/kernel/process.c	2007-05-29 03:17:16.000000000 -0700
+++ linux-2.6.22/arch/powerpc/kernel/process.c	2007-05-29 03:24:14.000000000 -0700
@@ -33,6 +33,7 @@
 #include <linux/mqueue.h>
 #include <linux/hardirq.h>
 #include <linux/utsname.h>
+#include <linux/perfmon.h>
 
 #include <asm/pgtable.h>
 #include <asm/uaccess.h>
@@ -322,6 +323,9 @@ struct task_struct *__switch_to(struct t
 		new_thread->start_tb = current_tb;
 	}
 #endif
+	if (test_tsk_thread_flag(new, TIF_PERFMON_CTXSW)
+	    || test_tsk_thread_flag(prev, TIF_PERFMON_CTXSW))
+		pfm_ctxsw(prev, new);
 
 	local_irq_save(flags);
 
@@ -455,6 +459,7 @@ void show_regs(struct pt_regs * regs)
 void exit_thread(void)
 {
 	discard_lazy_cpu_state();
+	pfm_exit_thread(current);
 }
 
 void flush_thread(void)
@@ -570,6 +575,7 @@ int copy_thread(int nr, unsigned long cl
 #else
 	kregs->nip = (unsigned long)ret_from_fork;
 #endif
+	pfm_copy_thread(p);
 
 	return 0;
 }
Only in linux-2.6.22/arch/powerpc: perfmon
Only in linux-2.6.22/include/asm-powerpc: perfmon.h
Only in linux-2.6.22/include/asm-powerpc: perfmon_api.h
diff --exclude=.git -urp linux-2.6.22.base/include/asm-powerpc/systbl.h linux-2.6.22/include/asm-powerpc/systbl.h
--- linux-2.6.22.base/include/asm-powerpc/systbl.h	2007-05-29 03:17:57.000000000 -0700
+++ linux-2.6.22/include/asm-powerpc/systbl.h	2007-05-29 03:24:14.000000000 -0700
@@ -311,3 +311,15 @@ COMPAT_SYS_SPU(utimensat)
 COMPAT_SYS_SPU(signalfd)
 COMPAT_SYS_SPU(timerfd)
 SYSCALL_SPU(eventfd)
+SYSCALL(pfm_create_context)
+SYSCALL(pfm_write_pmcs)
+SYSCALL(pfm_write_pmds)
+SYSCALL(pfm_read_pmds)
+SYSCALL(pfm_load_context)
+SYSCALL(pfm_start)
+SYSCALL(pfm_stop)
+SYSCALL(pfm_restart)
+SYSCALL(pfm_create_evtsets)
+SYSCALL(pfm_getinfo_evtsets)
+SYSCALL(pfm_delete_evtsets)
+SYSCALL(pfm_unload_context)
diff --exclude=.git -urp linux-2.6.22.base/include/asm-powerpc/thread_info.h linux-2.6.22/include/asm-powerpc/thread_info.h
--- linux-2.6.22.base/include/asm-powerpc/thread_info.h	2007-05-29 03:20:21.000000000 -0700
+++ linux-2.6.22/include/asm-powerpc/thread_info.h	2007-05-29 03:24:14.000000000 -0700
@@ -112,16 +112,18 @@ static inline struct thread_info *curren
 #define TIF_POLLING_NRFLAG	3	/* true if poll_idle() is polling
 					   TIF_NEED_RESCHED */
 #define TIF_32BIT		4	/* 32 bit binary */
-#define TIF_RUNLATCH		5	/* Is the runlatch enabled? */
-#define TIF_ABI_PENDING		6	/* 32/64 bit switch needed */
+#define TIF_PERFMON_WORK	5	/* work for pfm_handle_work() */
+#define TIF_PERFMON_CTXSW	6	/* perfmon needs ctxsw calls */
 #define TIF_SYSCALL_AUDIT	7	/* syscall auditing active */
 #define TIF_SINGLESTEP		8	/* singlestepping active */
 #define TIF_MEMDIE		9
 #define TIF_SECCOMP		10	/* secure computing */
 #define TIF_RESTOREALL		11	/* Restore all regs (implies NOERROR) */
-#define TIF_NOERROR		14	/* Force successful syscall return */
-#define TIF_RESTORE_SIGMASK	15	/* Restore signal mask in do_signal */
-#define TIF_FREEZE		16	/* Freezing for suspend */
+#define TIF_NOERROR		12	/* Force successful syscall return */
+#define TIF_RESTORE_SIGMASK	13	/* Restore signal mask in do_signal */
+#define TIF_FREEZE		14	/* Freezing for suspend */
+#define TIF_RUNLATCH		15	/* Is the runlatch enabled? */
+#define TIF_ABI_PENDING		16	/* 32/64 bit switch needed */
 
 /* as above, but as bit values */
 #define _TIF_SYSCALL_TRACE	(1<<TIF_SYSCALL_TRACE)
@@ -129,8 +131,8 @@ static inline struct thread_info *curren
 #define _TIF_NEED_RESCHED	(1<<TIF_NEED_RESCHED)
 #define _TIF_POLLING_NRFLAG	(1<<TIF_POLLING_NRFLAG)
 #define _TIF_32BIT		(1<<TIF_32BIT)
-#define _TIF_RUNLATCH		(1<<TIF_RUNLATCH)
-#define _TIF_ABI_PENDING	(1<<TIF_ABI_PENDING)
+#define _TIF_PERFMON_WORK	(1<<TIF_PERFMON_WORK)
+#define _TIF_PERFMON_CTXSW	(1<<TIF_PERFMON_CTXSW)
 #define _TIF_SYSCALL_AUDIT	(1<<TIF_SYSCALL_AUDIT)
 #define _TIF_SINGLESTEP		(1<<TIF_SINGLESTEP)
 #define _TIF_SECCOMP		(1<<TIF_SECCOMP)
@@ -138,10 +140,14 @@ static inline struct thread_info *curren
 #define _TIF_NOERROR		(1<<TIF_NOERROR)
 #define _TIF_RESTORE_SIGMASK	(1<<TIF_RESTORE_SIGMASK)
 #define _TIF_FREEZE		(1<<TIF_FREEZE)
+#define _TIF_RUNLATCH		(1<<TIF_RUNLATCH)
+#define _TIF_ABI_PENDING	(1<<TIF_ABI_PENDING)
 #define _TIF_SYSCALL_T_OR_A	(_TIF_SYSCALL_TRACE|_TIF_SYSCALL_AUDIT|_TIF_SECCOMP)
+#define _TIF_PERFMON_WORK	(1<<TIF_PERFMON_WORK)
+#define _TIF_PERFMON_CTXSW	(1<<TIF_PERFMON_CTXSW)
 
-#define _TIF_USER_WORK_MASK	( _TIF_SIGPENDING | \
-				 _TIF_NEED_RESCHED | _TIF_RESTORE_SIGMASK)
+#define _TIF_USER_WORK_MASK	(_TIF_SIGPENDING | \
+				 _TIF_NEED_RESCHED | _TIF_RESTORE_SIGMASK| _TIF_PERFMON_WORK)
 #define _TIF_PERSYSCALL_MASK	(_TIF_RESTOREALL|_TIF_NOERROR)
 
 /* Bits in local_flags */
diff --exclude=.git -urp linux-2.6.22.base/include/asm-powerpc/unistd.h linux-2.6.22/include/asm-powerpc/unistd.h
--- linux-2.6.22.base/include/asm-powerpc/unistd.h	2007-05-29 03:17:57.000000000 -0700
+++ linux-2.6.22/include/asm-powerpc/unistd.h	2007-05-29 03:24:14.000000000 -0700
@@ -330,10 +330,22 @@
 #define __NR_signalfd		305
 #define __NR_timerfd		306
 #define __NR_eventfd		307
+#define __NR_pfm_create_context	308
+#define __NR_pfm_write_pmcs	(__NR_pfm_create_context+1)
+#define __NR_pfm_write_pmds	(__NR_pfm_create_context+2)
+#define __NR_pfm_read_pmds	(__NR_pfm_create_context+3)
+#define __NR_pfm_load_context	(__NR_pfm_create_context+4)
+#define __NR_pfm_start		(__NR_pfm_create_context+5)
+#define __NR_pfm_stop		(__NR_pfm_create_context+6)
+#define __NR_pfm_restart	(__NR_pfm_create_context+7)
+#define __NR_pfm_create_evtsets	(__NR_pfm_create_context+8)
+#define __NR_pfm_getinfo_evtsets (__NR_pfm_create_context+9)
+#define __NR_pfm_delete_evtsets (__NR_pfm_create_context+10)
+#define __NR_pfm_unload_context	(__NR_pfm_create_context+11)
 
 #ifdef __KERNEL__
 
-#define __NR_syscalls		308
+#define __NR_syscalls		319
 
 #define __NR__exit __NR_exit
 #define NR_syscalls	__NR_syscalls
