Return-Path: <linux-kernel-owner+w=401wt.eu-S1762625AbXE2OI7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762625AbXE2OI7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 10:08:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760308AbXE2OD4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 10:03:56 -0400
Received: from tayrelbas04.tay.hp.com ([161.114.80.247]:54448 "EHLO
	tayrelbas04.tay.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932083AbXE2ODx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 10:03:53 -0400
Date: Tue, 29 May 2007 06:48:29 -0700
From: Stephane Eranian <eranian@frankl.hpl.hp.com>
Message-Id: <200705291348.l4TDmTxN019801@frankl.hpl.hp.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 15/22] 2.6.22-rc3 perfmon2 : modified i386 files
Cc: eranian@hpl.hp.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch contains the modified i386 files


Modified files are as follows:

arch/i386/Kconfig:
	- add link to configuration menu in arch/i386/perfmon/Kconfig

arch/i386/Makefile:
	- add perfmon subdir

arch/i386/kernel/apic.c:
	- add hook to call pfm_handle_switch_timeout() on timer tick for timeout based
	  set multiplexing

arch/i386/kernel/i8259.c:
	- PMU interrupt vector gate initialization

arch/i386/kernel/process.c:
	- add hook in exit_thread() to cleanup perfmon2 context
	- add hook in copy_thread() to cleanup perfmon2 context in child (perfmon2 context
	  is never inherited)
	- add hook in __switch_to() for PMU state save/restore

arch/i386/kernel/signal.c:
	- add hook for extra work before kernel exit. Need to block a thread after a overflow with
	  user level notification. Also needed to do some bookeeeping, such as reset certain counters
	  and cleanup in some difficult corner cases

arch/i386/kernel/syscall_table.S:	
	- add new perfmon2 system calls

include/asm-i386/mach-default/entry_arch.h:
	- add pmu_interrupt stub

include/asm-i386/mach-default/irq_vectors.h:
	- define PMU interrupt vector

include/asm-i386/thread_info.h:
	- add TIF_PERFMON which is used for PMU context switching in __switch_to()

include/asm-i386/unistd.h:
	- add new system calls





diff --exclude=.git -urp linux-2.6.22.base/arch/i386/Kconfig linux-2.6.22/arch/i386/Kconfig
--- linux-2.6.22.base/arch/i386/Kconfig	2007-05-29 03:17:15.000000000 -0700
+++ linux-2.6.22/arch/i386/Kconfig	2007-05-29 03:24:14.000000000 -0700
@@ -910,6 +910,8 @@ config COMPAT_VDSO
 
 	  If unsure, say Y.
 
+source "arch/i386/perfmon/Kconfig"
+
 endmenu
 
 config ARCH_ENABLE_MEMORY_HOTPLUG
diff --exclude=.git -urp linux-2.6.22.base/arch/i386/Makefile linux-2.6.22/arch/i386/Makefile
--- linux-2.6.22.base/arch/i386/Makefile	2007-05-29 03:17:15.000000000 -0700
+++ linux-2.6.22/arch/i386/Makefile	2007-05-29 03:24:14.000000000 -0700
@@ -99,6 +99,7 @@ mflags-y += -Iinclude/asm-i386/mach-defa
 head-y := arch/i386/kernel/head.o arch/i386/kernel/init_task.o
 
 libs-y 					+= arch/i386/lib/
+core-$(CONFIG_PERFMON)			+= arch/i386/perfmon/
 core-y					+= arch/i386/kernel/ \
 					   arch/i386/mm/ \
 					   arch/i386/$(mcore-y)/ \
diff --exclude=.git -urp linux-2.6.22.base/arch/i386/kernel/apic.c linux-2.6.22/arch/i386/kernel/apic.c
--- linux-2.6.22.base/arch/i386/kernel/apic.c	2007-05-29 03:17:15.000000000 -0700
+++ linux-2.6.22/arch/i386/kernel/apic.c	2007-05-29 03:24:14.000000000 -0700
@@ -28,6 +28,7 @@
 #include <linux/acpi_pmtmr.h>
 #include <linux/module.h>
 #include <linux/dmi.h>
+#include <linux/perfmon.h>
 
 #include <asm/atomic.h>
 #include <asm/smp.h>
@@ -562,6 +563,8 @@ static void local_apic_timer_interrupt(v
 	per_cpu(irq_stat, cpu).apic_timer_irqs++;
 
 	evt->event_handler(evt);
+
+	pfm_handle_switch_timeout();
 }
 
 /*
@@ -1325,6 +1328,9 @@ void __init apic_intr_init(void)
 #ifdef CONFIG_X86_MCE_P4THERMAL
 	set_intr_gate(THERMAL_APIC_VECTOR, thermal_interrupt);
 #endif
+#ifdef CONFIG_PERFMON
+	set_intr_gate(LOCAL_PERFMON_VECTOR, pmu_interrupt);
+#endif
 }
 
 /**
diff --exclude=.git -urp linux-2.6.22.base/arch/i386/kernel/cpu/common.c linux-2.6.22/arch/i386/kernel/cpu/common.c
--- linux-2.6.22.base/arch/i386/kernel/cpu/common.c	2007-05-29 03:17:15.000000000 -0700
+++ linux-2.6.22/arch/i386/kernel/cpu/common.c	2007-05-29 03:24:14.000000000 -0700
@@ -5,6 +5,7 @@
 #include <linux/module.h>
 #include <linux/percpu.h>
 #include <linux/bootmem.h>
+#include <linux/perfmon.h>
 #include <asm/semaphore.h>
 #include <asm/processor.h>
 #include <asm/i387.h>
@@ -718,6 +719,8 @@ void __cpuinit cpu_init(void)
 	current_thread_info()->status = 0;
 	clear_used_math();
 	mxcsr_feature_mask_init();
+
+	pfm_init_percpu();
 }
 
 #ifdef CONFIG_HOTPLUG_CPU
diff --exclude=.git -urp linux-2.6.22.base/arch/i386/kernel/entry.S linux-2.6.22/arch/i386/kernel/entry.S
--- linux-2.6.22.base/arch/i386/kernel/entry.S	2007-05-29 03:17:15.000000000 -0700
+++ linux-2.6.22/arch/i386/kernel/entry.S	2007-05-29 03:24:14.000000000 -0700
@@ -465,7 +465,7 @@ ENDPROC(system_call)
 	ALIGN
 	RING0_PTREGS_FRAME		# can't unwind into user space anyway
 work_pending:
-	testb $_TIF_NEED_RESCHED, %cl
+	testw $(_TIF_NEED_RESCHED|_TIF_PERFMON_WORK), %cx
 	jz work_notifysig
 work_resched:
 	call schedule
diff --exclude=.git -urp linux-2.6.22.base/arch/i386/kernel/process.c linux-2.6.22/arch/i386/kernel/process.c
--- linux-2.6.22.base/arch/i386/kernel/process.c	2007-05-29 03:17:15.000000000 -0700
+++ linux-2.6.22/arch/i386/kernel/process.c	2007-05-29 03:24:14.000000000 -0700
@@ -31,6 +31,7 @@
 #include <linux/delay.h>
 #include <linux/reboot.h>
 #include <linux/init.h>
+#include <linux/perfmon.h>
 #include <linux/mc146818rtc.h>
 #include <linux/module.h>
 #include <linux/kallsyms.h>
@@ -384,6 +385,7 @@ void exit_thread(void)
 		tss->x86_tss.io_bitmap_base = INVALID_IO_BITMAP_OFFSET;
 		put_cpu();
 	}
+	pfm_exit_thread(current);
 }
 
 void flush_thread(void)
@@ -435,6 +437,8 @@ int copy_thread(int nr, unsigned long cl
 
 	savesegment(gs,p->thread.gs);
 
+ 	pfm_copy_thread(p);
+
 	tsk = current;
 	if (unlikely(test_tsk_thread_flag(tsk, TIF_IO_BITMAP))) {
 		p->thread.io_bitmap_ptr = kmemdup(tsk->thread.io_bitmap_ptr,
@@ -538,8 +542,9 @@ int dump_task_regs(struct task_struct *t
 	return 1;
 }
 
-static noinline void __switch_to_xtra(struct task_struct *next_p,
-				    struct tss_struct *tss)
+static noinline void __switch_to_xtra(struct task_struct *prev_p,
+				      struct task_struct *next_p,
+				      struct tss_struct *tss)
 {
 	struct thread_struct *next;
 
@@ -555,6 +560,10 @@ static noinline void __switch_to_xtra(st
 		set_debugreg(next->debugreg[7], 7);
 	}
 
+	if (test_tsk_thread_flag(next_p, TIF_PERFMON_CTXSW)
+	    || test_tsk_thread_flag(prev_p, TIF_PERFMON_CTXSW))
+		pfm_ctxsw(prev_p, next_p);
+
 	if (!test_tsk_thread_flag(next_p, TIF_IO_BITMAP)) {
 		/*
 		 * Disable the bitmap via an invalid offset. We still cache
@@ -690,8 +699,8 @@ struct task_struct fastcall * __switch_t
 	 * Now maybe handle debug registers and/or IO bitmaps
 	 */
 	if (unlikely((task_thread_info(next_p)->flags & _TIF_WORK_CTXSW)
-	    || test_tsk_thread_flag(prev_p, TIF_IO_BITMAP)))
-		__switch_to_xtra(next_p, tss);
+	    || (task_thread_info(prev_p)->flags & _TIF_WORK_CTXSW)))
+		__switch_to_xtra(prev_p, next_p, tss);
 
 	disable_tsc(prev_p, next_p);
 
diff --exclude=.git -urp linux-2.6.22.base/arch/i386/kernel/signal.c linux-2.6.22/arch/i386/kernel/signal.c
--- linux-2.6.22.base/arch/i386/kernel/signal.c	2007-05-29 03:17:15.000000000 -0700
+++ linux-2.6.22/arch/i386/kernel/signal.c	2007-05-29 03:24:14.000000000 -0700
@@ -21,6 +21,7 @@
 #include <linux/ptrace.h>
 #include <linux/elf.h>
 #include <linux/binfmts.h>
+#include <linux/perfmon.h>
 #include <asm/processor.h>
 #include <asm/ucontext.h>
 #include <asm/uaccess.h>
@@ -652,6 +653,10 @@ void do_notify_resume(struct pt_regs *re
 		clear_thread_flag(TIF_SINGLESTEP);
 	}
 
+	/* process perfmon asynchronous work (e.g. block thread or reset) */
+	if (thread_info_flags & _TIF_PERFMON_WORK)
+ 		pfm_handle_work(regs);
+
 	/* deal with pending signal delivery */
 	if (thread_info_flags & (_TIF_SIGPENDING | _TIF_RESTORE_SIGMASK))
 		do_signal(regs);
diff --exclude=.git -urp linux-2.6.22.base/arch/i386/kernel/smpboot.c linux-2.6.22/arch/i386/kernel/smpboot.c
--- linux-2.6.22.base/arch/i386/kernel/smpboot.c	2007-05-29 03:17:15.000000000 -0700
+++ linux-2.6.22/arch/i386/kernel/smpboot.c	2007-05-29 03:24:14.000000000 -0700
@@ -45,6 +45,7 @@
 #include <linux/cpu.h>
 #include <linux/percpu.h>
 #include <linux/nmi.h>
+#include <linux/perfmon.h>
 
 #include <linux/delay.h>
 #include <linux/mc146818rtc.h>
@@ -1208,6 +1209,7 @@ int __cpu_disable(void)
 
 	cpu_clear(cpu, map);
 	fixup_irqs(map);
+	pfm_cpu_disable();
 	/* It's now safe to remove this processor from the online map */
 	cpu_clear(cpu, cpu_online_map);
 	return 0;
diff --exclude=.git -urp linux-2.6.22.base/arch/i386/kernel/syscall_table.S linux-2.6.22/arch/i386/kernel/syscall_table.S
--- linux-2.6.22.base/arch/i386/kernel/syscall_table.S	2007-05-29 03:17:15.000000000 -0700
+++ linux-2.6.22/arch/i386/kernel/syscall_table.S	2007-05-29 03:24:14.000000000 -0700
@@ -323,3 +323,15 @@ ENTRY(sys_call_table)
 	.long sys_signalfd
 	.long sys_timerfd
 	.long sys_eventfd
+   	.long sys_pfm_create_context
+   	.long sys_pfm_write_pmcs	/* 325 */
+   	.long sys_pfm_write_pmds
+   	.long sys_pfm_read_pmds
+   	.long sys_pfm_load_context
+   	.long sys_pfm_start
+   	.long sys_pfm_stop		/* 330 */
+   	.long sys_pfm_restart
+   	.long sys_pfm_create_evtsets
+   	.long sys_pfm_getinfo_evtsets
+   	.long sys_pfm_delete_evtsets
+   	.long sys_pfm_unload_context	/* 335 */
diff --exclude=.git -urp linux-2.6.22.base/arch/i386/oprofile/Makefile linux-2.6.22/arch/i386/oprofile/Makefile
--- linux-2.6.22.base/arch/i386/oprofile/Makefile	2007-05-29 03:17:15.000000000 -0700
+++ linux-2.6.22/arch/i386/oprofile/Makefile	2007-05-29 03:24:14.000000000 -0700
@@ -10,3 +10,4 @@ oprofile-y				:= $(DRIVER_OBJS) init.o b
 oprofile-$(CONFIG_X86_LOCAL_APIC) 	+= nmi_int.o op_model_athlon.o \
 					   op_model_ppro.o op_model_p4.o
 oprofile-$(CONFIG_X86_IO_APIC)		+= nmi_timer_int.o
+oprofile-$(CONFIG_PERFMON)		+= perfmon.o
diff --exclude=.git -urp linux-2.6.22.base/arch/i386/oprofile/init.c linux-2.6.22/arch/i386/oprofile/init.c
--- linux-2.6.22.base/arch/i386/oprofile/init.c	2007-05-29 03:17:15.000000000 -0700
+++ linux-2.6.22/arch/i386/oprofile/init.c	2007-05-29 03:24:14.000000000 -0700
@@ -15,9 +15,11 @@
  * with the NMI mode driver.
  */
  
+extern int op_perfmon_init(struct oprofile_operations * ops);
 extern int op_nmi_init(struct oprofile_operations * ops);
 extern int op_nmi_timer_init(struct oprofile_operations * ops);
 extern void op_nmi_exit(void);
+extern void op_perfmon_exit(void);
 extern void x86_backtrace(struct pt_regs * const regs, unsigned int depth);
 
 
@@ -27,8 +29,12 @@ int __init oprofile_arch_init(struct opr
 
 	ret = -ENODEV;
 
+#ifdef CONFIG_PERFMON
+	ret = op_perfmon_init(ops);
+#endif
 #ifdef CONFIG_X86_LOCAL_APIC
-	ret = op_nmi_init(ops);
+	if (ret < 0)
+		ret = op_nmi_init(ops);
 #endif
 #ifdef CONFIG_X86_IO_APIC
 	if (ret < 0)
@@ -42,6 +48,9 @@ int __init oprofile_arch_init(struct opr
 
 void oprofile_arch_exit(void)
 {
+#ifdef CONFIG_PERFMON
+	op_perfmon_exit();
+#endif
 #ifdef CONFIG_X86_LOCAL_APIC
 	op_nmi_exit();
 #endif
diff --exclude=.git -urp linux-2.6.22.base/arch/i386/oprofile/nmi_int.c linux-2.6.22/arch/i386/oprofile/nmi_int.c
--- linux-2.6.22.base/arch/i386/oprofile/nmi_int.c	2007-05-29 03:17:15.000000000 -0700
+++ linux-2.6.22/arch/i386/oprofile/nmi_int.c	2007-05-29 03:24:14.000000000 -0700
@@ -459,6 +459,7 @@ int __init op_nmi_init(struct oprofile_o
 	ops->start = nmi_start;
 	ops->stop = nmi_stop;
 	ops->cpu_type = cpu_type;
+	ops->implementation = "oprofile";
 	printk(KERN_INFO "oprofile: using NMI interrupt.\n");
 	return 0;
 }
diff --exclude=.git -urp linux-2.6.22.base/arch/i386/oprofile/nmi_timer_int.c linux-2.6.22/arch/i386/oprofile/nmi_timer_int.c
--- linux-2.6.22.base/arch/i386/oprofile/nmi_timer_int.c	2007-05-29 03:17:15.000000000 -0700
+++ linux-2.6.22/arch/i386/oprofile/nmi_timer_int.c	2007-05-29 03:24:14.000000000 -0700
@@ -64,6 +64,7 @@ int __init op_nmi_timer_init(struct opro
 	ops->start = timer_start;
 	ops->stop = timer_stop;
 	ops->cpu_type = "timer";
+	ops->implementation = "nmi_timer";
 	printk(KERN_INFO "oprofile: using NMI timer interrupt.\n");
 	return 0;
 }
Only in linux-2.6.22/arch/i386/oprofile: perfmon.c
Only in linux-2.6.22/arch/i386: perfmon
diff --exclude=.git -urp linux-2.6.22.base/include/asm-i386/mach-default/entry_arch.h linux-2.6.22/include/asm-i386/mach-default/entry_arch.h
--- linux-2.6.22.base/include/asm-i386/mach-default/entry_arch.h	2007-05-29 03:17:41.000000000 -0700
+++ linux-2.6.22/include/asm-i386/mach-default/entry_arch.h	2007-05-29 03:24:14.000000000 -0700
@@ -31,4 +31,8 @@ BUILD_INTERRUPT(spurious_interrupt,SPURI
 BUILD_INTERRUPT(thermal_interrupt,THERMAL_APIC_VECTOR)
 #endif
 
+#ifdef CONFIG_PERFMON
+BUILD_INTERRUPT(pmu_interrupt,LOCAL_PERFMON_VECTOR)
+#endif
+
 #endif
diff --exclude=.git -urp linux-2.6.22.base/include/asm-i386/mach-default/irq_vectors.h linux-2.6.22/include/asm-i386/mach-default/irq_vectors.h
--- linux-2.6.22.base/include/asm-i386/mach-default/irq_vectors.h	2007-05-29 03:17:41.000000000 -0700
+++ linux-2.6.22/include/asm-i386/mach-default/irq_vectors.h	2007-05-29 03:24:14.000000000 -0700
@@ -56,6 +56,7 @@
  * sources per level' errata.
  */
 #define LOCAL_TIMER_VECTOR	0xef
+#define LOCAL_PERFMON_VECTOR	0xee
 
 /*
  * First APIC vector available to drivers: (vectors 0x30-0xee)
@@ -63,7 +64,7 @@
  * levels. (0x80 is the syscall vector)
  */
 #define FIRST_DEVICE_VECTOR	0x31
-#define FIRST_SYSTEM_VECTOR	0xef
+#define FIRST_SYSTEM_VECTOR	0xee
 
 #define TIMER_IRQ 0
 
Only in linux-2.6.22/include/asm-i386: perfmon.h
Only in linux-2.6.22/include/asm-i386: perfmon_api.h
Only in linux-2.6.22/include/asm-i386: perfmon_pebs_smpl.h
diff --exclude=.git -urp linux-2.6.22.base/include/asm-i386/thread_info.h linux-2.6.22/include/asm-i386/thread_info.h
--- linux-2.6.22.base/include/asm-i386/thread_info.h	2007-05-29 03:20:21.000000000 -0700
+++ linux-2.6.22/include/asm-i386/thread_info.h	2007-05-29 03:24:14.000000000 -0700
@@ -132,10 +132,12 @@ static inline struct thread_info *curren
 #define TIF_SYSCALL_AUDIT	6	/* syscall auditing active */
 #define TIF_SECCOMP		7	/* secure computing */
 #define TIF_RESTORE_SIGMASK	8	/* restore signal mask in do_signal() */
+#define TIF_PERFMON_WORK	9	/* work for pfm_handle_work() */
 #define TIF_MEMDIE		16
 #define TIF_DEBUG		17	/* uses debug registers */
 #define TIF_IO_BITMAP		18	/* uses I/O bitmap */
 #define TIF_FREEZE		19	/* is freezing for suspend */
+#define TIF_PERFMON_CTXSW	20	/* perfmon needs ctxsw calls */
 
 #define _TIF_SYSCALL_TRACE	(1<<TIF_SYSCALL_TRACE)
 #define _TIF_SIGPENDING		(1<<TIF_SIGPENDING)
@@ -149,6 +151,8 @@ static inline struct thread_info *curren
 #define _TIF_DEBUG		(1<<TIF_DEBUG)
 #define _TIF_IO_BITMAP		(1<<TIF_IO_BITMAP)
 #define _TIF_FREEZE		(1<<TIF_FREEZE)
+#define _TIF_PERFMON_WORK	(1<<TIF_PERFMON_WORK)
+#define _TIF_PERFMON_CTXSW	(1<<TIF_PERFMON_CTXSW)
 
 /* work to do on interrupt/exception return */
 #define _TIF_WORK_MASK \
@@ -158,7 +162,7 @@ static inline struct thread_info *curren
 #define _TIF_ALLWORK_MASK	(0x0000FFFF & ~_TIF_SECCOMP)
 
 /* flags to check in __switch_to() */
-#define _TIF_WORK_CTXSW (_TIF_DEBUG|_TIF_IO_BITMAP)
+#define _TIF_WORK_CTXSW (_TIF_DEBUG|_TIF_IO_BITMAP|_TIF_PERFMON_CTXSW)
 
 /*
  * Thread-synchronous status.
diff --exclude=.git -urp linux-2.6.22.base/include/asm-i386/unistd.h linux-2.6.22/include/asm-i386/unistd.h
--- linux-2.6.22.base/include/asm-i386/unistd.h	2007-05-29 03:17:41.000000000 -0700
+++ linux-2.6.22/include/asm-i386/unistd.h	2007-05-29 03:24:14.000000000 -0700
@@ -329,10 +329,22 @@
 #define __NR_signalfd		321
 #define __NR_timerfd		322
 #define __NR_eventfd		323
+#define __NR_pfm_create_context	324
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
 
-#define NR_syscalls 324
+#define NR_syscalls 335
 
 #define __ARCH_WANT_IPC_PARSE_VERSION
 #define __ARCH_WANT_OLD_READDIR
