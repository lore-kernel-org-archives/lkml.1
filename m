Return-Path: <linux-kernel-owner+w=401wt.eu-S1762052AbXE2OGM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762052AbXE2OGM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 10:06:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759079AbXE2OCq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 10:02:46 -0400
Received: from tayrelbas03.tay.hp.com ([161.114.80.246]:59057 "EHLO
	tayrelbas03.tay.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760722AbXE2OCn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 10:02:43 -0400
X-Greylist: delayed 861 seconds by postgrey-1.27 at vger.kernel.org; Tue, 29 May 2007 10:02:43 EDT
Date: Tue, 29 May 2007 06:48:34 -0700
From: Stephane Eranian <eranian@frankl.hpl.hp.com>
Message-Id: <200705291348.l4TDmYaf019853@frankl.hpl.hp.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 19/22] 2.6.22-rc3 perfmon2 : modified x86_64 files
Cc: eranian@hpl.hp.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch contains the modified x86_64 files.

The modified files are as follows:

arch/x86_64/Kconfig:
	- add link to configuration menu in arch/x86_64/perfmon/Kconfig

arch/x86_64/Makefile:
	- add perfmon subdir

arch/x86_64/ia32/ia32entry.S:
	- add system call entry points for 32-bit ABI
	
arch/x86_64/kernel/apic.c:
	- add hook to call pfm_handle_switch_timeout() on timer tick for timeout based
	  set multiplexing

arch/x86_64/kernel/entry.S:
	- add pmu_interrupt stub

arch/x86_64/kernel/i8259.c:
	- PMU interrupt vector gate initialization

arch/x86_64/kernel/process.c:
	- add hook in exit_thread() to cleanup perfmon2 context
	- add hook in copy_thread() to cleanup perfmon2 context in child (perfmon2 context
	  is never inherited)
	- add hook in __switch_to() for PMU state save/restore
	- split enter_idle() is two. Until we get to 2.6.20, we need to add enter_idle() to the tail
	  of each interrupt handler due to idle loops. The loops are gone in 2.6.20.

arch/x86_64/kernel/signal.c:
	- add hook for extra work before kernel exit. Need to block a thread after a overflow with
	  user level notification. Also needed to do some bookeeeping, such as reset certain counters
	  and cleanup in some difficult corner cases

arch/x86_64/kernel/nmi.c:
	- use PERFCTR1 for architected PERFMON to allow PEBS use on Core-base processors

include/asm-x86_64/hw_irq.h:
	- define PMU interrupt vector

include/asm-x86_64/irq.h:
	- update FIRST_SYSTEM_VECTOR

include/asm-x86_64/thread_info.h:
	- add TIF_PERFMON which is used for PMU context switching in __switch_to()

include/asm-x86_64/unistd.h:
	- add new system calls



diff --exclude=.git -urp linux-2.6.22.base/arch/x86_64/Kconfig linux-2.6.22/arch/x86_64/Kconfig
--- linux-2.6.22.base/arch/x86_64/Kconfig	2007-05-29 03:17:16.000000000 -0700
+++ linux-2.6.22/arch/x86_64/Kconfig	2007-05-29 03:24:14.000000000 -0700
@@ -667,6 +667,8 @@ config K8_NB
 	def_bool y
 	depends on AGP_AMD64 || IOMMU || (PCI && NUMA)
 
+source "arch/x86_64/perfmon/Kconfig"
+
 endmenu
 
 #
diff --exclude=.git -urp linux-2.6.22.base/arch/x86_64/Makefile linux-2.6.22/arch/x86_64/Makefile
--- linux-2.6.22.base/arch/x86_64/Makefile	2007-05-29 03:17:16.000000000 -0700
+++ linux-2.6.22/arch/x86_64/Makefile	2007-05-29 03:24:14.000000000 -0700
@@ -79,6 +79,7 @@ core-y					+= arch/x86_64/kernel/ \
 					   arch/x86_64/crypto/
 core-$(CONFIG_IA32_EMULATION)		+= arch/x86_64/ia32/
 drivers-$(CONFIG_PCI)			+= arch/x86_64/pci/
+drivers-$(CONFIG_PERFMON)		+= arch/x86_64/perfmon/
 drivers-$(CONFIG_OPROFILE)		+= arch/x86_64/oprofile/
 
 boot := arch/x86_64/boot
diff --exclude=.git -urp linux-2.6.22.base/arch/x86_64/ia32/ia32entry.S linux-2.6.22/arch/x86_64/ia32/ia32entry.S
--- linux-2.6.22.base/arch/x86_64/ia32/ia32entry.S	2007-05-29 03:17:16.000000000 -0700
+++ linux-2.6.22/arch/x86_64/ia32/ia32entry.S	2007-05-29 03:24:14.000000000 -0700
@@ -719,4 +719,16 @@ ia32_sys_call_table:
 	.quad compat_sys_signalfd
 	.quad compat_sys_timerfd
 	.quad sys_eventfd
+    	.quad sys_pfm_create_context
+    	.quad sys_pfm_write_pmcs
+    	.quad sys_pfm_write_pmds
+   	.quad sys_pfm_read_pmds
+   	.quad sys_pfm_load_context
+    	.quad sys_pfm_start
+    	.quad sys_pfm_stop
+    	.quad sys_pfm_restart
+    	.quad sys_pfm_create_evtsets
+    	.quad sys_pfm_getinfo_evtsets
+    	.quad sys_pfm_delete_evtsets
+    	.quad sys_pfm_unload_context
 ia32_syscall_end:
diff --exclude=.git -urp linux-2.6.22.base/arch/x86_64/kernel/apic.c linux-2.6.22/arch/x86_64/kernel/apic.c
--- linux-2.6.22.base/arch/x86_64/kernel/apic.c	2007-05-29 03:17:16.000000000 -0700
+++ linux-2.6.22/arch/x86_64/kernel/apic.c	2007-05-29 03:24:14.000000000 -0700
@@ -25,6 +25,7 @@
 #include <linux/sysdev.h>
 #include <linux/module.h>
 #include <linux/ioport.h>
+#include <linux/perfmon.h>
 
 #include <asm/atomic.h>
 #include <asm/smp.h>
@@ -1013,6 +1014,7 @@ void setup_APIC_extened_lvt(unsigned cha
 void smp_local_timer_interrupt(void)
 {
 	profile_tick(CPU_PROFILING);
+  	pfm_handle_switch_timeout();
 #ifdef CONFIG_SMP
 	update_process_times(user_mode(get_irq_regs()));
 #endif
diff --exclude=.git -urp linux-2.6.22.base/arch/x86_64/kernel/entry.S linux-2.6.22/arch/x86_64/kernel/entry.S
--- linux-2.6.22.base/arch/x86_64/kernel/entry.S	2007-05-29 03:20:21.000000000 -0700
+++ linux-2.6.22/arch/x86_64/kernel/entry.S	2007-05-29 03:24:14.000000000 -0700
@@ -282,7 +282,7 @@ sysret_careful:
 sysret_signal:
 	TRACE_IRQS_ON
 	sti
-	testl $(_TIF_SIGPENDING|_TIF_SINGLESTEP),%edx
+	testl $(_TIF_SIGPENDING|_TIF_SINGLESTEP|_TIF_PERFMON_WORK),%edx
 	jz    1f
 
 	/* Really a signal */
@@ -375,7 +375,7 @@ int_very_careful:
 	jmp int_restore_rest
 	
 int_signal:
-	testl $(_TIF_SIGPENDING|_TIF_SINGLESTEP),%edx
+	testl $(_TIF_SIGPENDING|_TIF_SINGLESTEP|_TIF_PERFMON_WORK),%edx
 	jz 1f
 	movq %rsp,%rdi		# &ptregs -> arg1
 	xorl %esi,%esi		# oldset -> arg2
@@ -599,7 +599,7 @@ retint_careful:
 	jmp retint_check
 	
 retint_signal:
-	testl $(_TIF_SIGPENDING|_TIF_SINGLESTEP),%edx
+	testl $(_TIF_SIGPENDING|_TIF_SINGLESTEP|_TIF_PERFMON_WORK),%edx
 	jz    retint_swapgs
 	TRACE_IRQS_ON
 	sti
@@ -691,7 +691,12 @@ END(error_interrupt)
 ENTRY(spurious_interrupt)
 	apicinterrupt SPURIOUS_APIC_VECTOR,smp_spurious_interrupt
 END(spurious_interrupt)
-				
+
+#ifdef CONFIG_PERFMON
+ENTRY(pmu_interrupt)
+	apicinterrupt LOCAL_PERFMON_VECTOR,smp_pmu_interrupt
+#endif
+
 /*
  * Exception entry points.
  */ 		
diff --exclude=.git -urp linux-2.6.22.base/arch/x86_64/kernel/i8259.c linux-2.6.22/arch/x86_64/kernel/i8259.c
--- linux-2.6.22.base/arch/x86_64/kernel/i8259.c	2007-05-29 03:17:16.000000000 -0700
+++ linux-2.6.22/arch/x86_64/kernel/i8259.c	2007-05-29 03:24:14.000000000 -0700
@@ -11,6 +11,7 @@
 #include <linux/kernel_stat.h>
 #include <linux/sysdev.h>
 #include <linux/bitops.h>
+#include <linux/perfmon.h>
 
 #include <asm/acpi.h>
 #include <asm/atomic.h>
@@ -550,7 +551,9 @@ void __init init_IRQ(void)
 	/* IPI vectors for APIC spurious and error interrupts */
 	set_intr_gate(SPURIOUS_APIC_VECTOR, spurious_interrupt);
 	set_intr_gate(ERROR_APIC_VECTOR, error_interrupt);
-
+#ifdef CONFIG_PERFMON
+	set_intr_gate(LOCAL_PERFMON_VECTOR, pmu_interrupt);
+#endif
 	/*
 	 * Set the clock to HZ Hz, we already have a valid
 	 * vector now:
diff --exclude=.git -urp linux-2.6.22.base/arch/x86_64/kernel/process.c linux-2.6.22/arch/x86_64/kernel/process.c
--- linux-2.6.22.base/arch/x86_64/kernel/process.c	2007-05-29 03:17:16.000000000 -0700
+++ linux-2.6.22/arch/x86_64/kernel/process.c	2007-05-29 03:24:14.000000000 -0700
@@ -37,6 +37,7 @@
 #include <linux/notifier.h>
 #include <linux/kprobes.h>
 #include <linux/kdebug.h>
+#include <linux/perfmon.h>
 
 #include <asm/uaccess.h>
 #include <asm/pgtable.h>
@@ -379,6 +380,7 @@ void exit_thread(void)
 		t->io_bitmap_max = 0;
 		put_cpu();
 	}
+	pfm_exit_thread(me);
 }
 
 void flush_thread(void)
@@ -487,6 +489,8 @@ int copy_thread(int nr, unsigned long cl
 	asm("mov %%es,%0" : "=m" (p->thread.es));
 	asm("mov %%ds,%0" : "=m" (p->thread.ds));
 
+	pfm_copy_thread(p);
+
 	if (unlikely(test_tsk_thread_flag(me, TIF_IO_BITMAP))) {
 		p->thread.io_bitmap_ptr = kmalloc(IO_BITMAP_BYTES, GFP_KERNEL);
 		if (!p->thread.io_bitmap_ptr) {
@@ -557,6 +561,10 @@ static inline void __switch_to_xtra(stru
 		 */
 		memset(tss->io_bitmap, 0xff, prev->io_bitmap_max);
 	}
+
+	if (test_tsk_thread_flag(next_p, TIF_PERFMON_CTXSW)
+	    || test_tsk_thread_flag(prev_p, TIF_PERFMON_CTXSW))
+		pfm_ctxsw(prev_p, next_p);
 }
 
 /*
@@ -661,7 +669,7 @@ __switch_to(struct task_struct *prev_p, 
 	 * Now maybe reload the debug registers and handle I/O bitmaps
 	 */
 	if (unlikely((task_thread_info(next_p)->flags & _TIF_WORK_CTXSW))
-	    || test_tsk_thread_flag(prev_p, TIF_IO_BITMAP))
+  	    || (task_thread_info(prev_p)->flags & _TIF_WORK_CTXSW))
 		__switch_to_xtra(prev_p, next_p, tss);
 
 	/* If the task has used fpu the last 5 timeslices, just do a full
diff --exclude=.git -urp linux-2.6.22.base/arch/x86_64/kernel/setup64.c linux-2.6.22/arch/x86_64/kernel/setup64.c
--- linux-2.6.22.base/arch/x86_64/kernel/setup64.c	2007-05-29 03:17:16.000000000 -0700
+++ linux-2.6.22/arch/x86_64/kernel/setup64.c	2007-05-29 03:24:14.000000000 -0700
@@ -11,6 +11,7 @@
 #include <linux/bootmem.h>
 #include <linux/bitops.h>
 #include <linux/module.h>
+#include <linux/perfmon.h>
 #include <asm/bootsetup.h>
 #include <asm/pda.h>
 #include <asm/pgtable.h>
@@ -283,4 +284,6 @@ void __cpuinit cpu_init (void)
 	fpu_init(); 
 
 	raw_local_save_flags(kernel_eflags);
+
+ 	pfm_init_percpu();
 }
diff --exclude=.git -urp linux-2.6.22.base/arch/x86_64/kernel/signal.c linux-2.6.22/arch/x86_64/kernel/signal.c
--- linux-2.6.22.base/arch/x86_64/kernel/signal.c	2007-05-29 03:17:16.000000000 -0700
+++ linux-2.6.22/arch/x86_64/kernel/signal.c	2007-05-29 03:24:14.000000000 -0700
@@ -21,6 +21,7 @@
 #include <linux/stddef.h>
 #include <linux/personality.h>
 #include <linux/compiler.h>
+#include <linux/perfmon.h>
 #include <asm/ucontext.h>
 #include <asm/uaccess.h>
 #include <asm/i387.h>
@@ -472,6 +473,10 @@ do_notify_resume(struct pt_regs *regs, v
 		clear_thread_flag(TIF_SINGLESTEP);
 	}
 
+	/* process perfmon asynchronous work (e.g. block thread or reset) */
+	if (thread_info_flags & _TIF_PERFMON_WORK)
+		pfm_handle_work(regs);
+
 	/* deal with pending signal delivery */
 	if (thread_info_flags & (_TIF_SIGPENDING|_TIF_RESTORE_SIGMASK))
 		do_signal(regs);
diff --exclude=.git -urp linux-2.6.22.base/arch/x86_64/kernel/smpboot.c linux-2.6.22/arch/x86_64/kernel/smpboot.c
--- linux-2.6.22.base/arch/x86_64/kernel/smpboot.c	2007-05-29 03:17:16.000000000 -0700
+++ linux-2.6.22/arch/x86_64/kernel/smpboot.c	2007-05-29 03:24:14.000000000 -0700
@@ -49,6 +49,7 @@
 #include <linux/mc146818rtc.h>
 #include <linux/smp.h>
 #include <linux/kdebug.h>
+#include <linux/perfmon.h>
 
 #include <asm/mtrr.h>
 #include <asm/pgalloc.h>
@@ -1043,6 +1044,7 @@ int __cpu_disable(void)
 	spin_unlock(&vector_lock);
 	remove_cpu_from_maps();
 	fixup_irqs(cpu_online_map);
+	pfm_cpu_disable();
 	return 0;
 }
 
diff --exclude=.git -urp linux-2.6.22.base/arch/x86_64/oprofile/Makefile linux-2.6.22/arch/x86_64/oprofile/Makefile
--- linux-2.6.22.base/arch/x86_64/oprofile/Makefile	2007-05-29 03:17:16.000000000 -0700
+++ linux-2.6.22/arch/x86_64/oprofile/Makefile	2007-05-29 03:24:14.000000000 -0700
@@ -15,5 +15,6 @@ OPROFILE-y := init.o backtrace.o
 OPROFILE-$(CONFIG_X86_LOCAL_APIC) += nmi_int.o op_model_athlon.o op_model_p4.o \
 				     op_model_ppro.o
 OPROFILE-$(CONFIG_X86_IO_APIC)    += nmi_timer_int.o 
+OPROFILE-$(CONFIG_PERFMON)	  += perfmon.o
 
 oprofile-y = $(DRIVER_OBJS) $(addprefix ../../i386/oprofile/, $(OPROFILE-y))
Only in linux-2.6.22/arch/x86_64: perfmon
diff --exclude=.git -urp linux-2.6.22.base/include/asm-x86_64/hw_irq.h linux-2.6.22/include/asm-x86_64/hw_irq.h
--- linux-2.6.22.base/include/asm-x86_64/hw_irq.h	2007-05-29 03:17:57.000000000 -0700
+++ linux-2.6.22/include/asm-x86_64/hw_irq.h	2007-05-29 03:24:14.000000000 -0700
@@ -84,6 +84,7 @@
  * sources per level' errata.
  */
 #define LOCAL_TIMER_VECTOR	0xef
+#define LOCAL_PERFMON_VECTOR	0xee
 
 /*
  * First APIC vector available to drivers: (vectors 0x30-0xee)
Only in linux-2.6.22/include/asm-x86_64: perfmon.h
Only in linux-2.6.22/include/asm-x86_64: perfmon_api.h
Only in linux-2.6.22/include/asm-x86_64: perfmon_pebs_smpl.h
diff --exclude=.git -urp linux-2.6.22.base/include/asm-x86_64/thread_info.h linux-2.6.22/include/asm-x86_64/thread_info.h
--- linux-2.6.22.base/include/asm-x86_64/thread_info.h	2007-05-29 03:20:21.000000000 -0700
+++ linux-2.6.22/include/asm-x86_64/thread_info.h	2007-05-29 03:24:14.000000000 -0700
@@ -114,6 +114,7 @@ static inline struct thread_info *stack_
 #define TIF_SYSCALL_AUDIT	5	/* syscall auditing active */
 #define TIF_SECCOMP		6	/* secure computing */
 #define TIF_RESTORE_SIGMASK	7	/* restore signal mask in do_signal */
+#define TIF_PERFMON_WORK	8	/* work for pfm_handle_work() */
 /* 16 free */
 #define TIF_IA32		17	/* 32bit process */ 
 #define TIF_FORK		18	/* ret_from_fork */
@@ -122,6 +123,7 @@ static inline struct thread_info *stack_
 #define TIF_DEBUG		21	/* uses debug registers */
 #define TIF_IO_BITMAP		22	/* uses I/O bitmap */
 #define TIF_FREEZE		23	/* is freezing for suspend */
+#define TIF_PERFMON_CTXSW	24	/* perfmon needs ctxsw calls */
 
 #define _TIF_SYSCALL_TRACE	(1<<TIF_SYSCALL_TRACE)
 #define _TIF_SIGPENDING		(1<<TIF_SIGPENDING)
@@ -137,6 +139,8 @@ static inline struct thread_info *stack_
 #define _TIF_DEBUG		(1<<TIF_DEBUG)
 #define _TIF_IO_BITMAP		(1<<TIF_IO_BITMAP)
 #define _TIF_FREEZE		(1<<TIF_FREEZE)
+#define _TIF_PERFMON_WORK	(1<<TIF_PERFMON_WORK)
+#define _TIF_PERFMON_CTXSW	(1<<TIF_PERFMON_CTXSW)
 
 /* work to do on interrupt/exception return */
 #define _TIF_WORK_MASK \
@@ -145,7 +149,7 @@ static inline struct thread_info *stack_
 #define _TIF_ALLWORK_MASK (0x0000FFFF & ~_TIF_SECCOMP)
 
 /* flags to check in __switch_to() */
-#define _TIF_WORK_CTXSW (_TIF_DEBUG|_TIF_IO_BITMAP)
+#define _TIF_WORK_CTXSW (_TIF_DEBUG|_TIF_IO_BITMAP|_TIF_PERFMON_CTXSW)
 
 #define PREEMPT_ACTIVE     0x10000000
 
diff --exclude=.git -urp linux-2.6.22.base/include/asm-x86_64/unistd.h linux-2.6.22/include/asm-x86_64/unistd.h
--- linux-2.6.22.base/include/asm-x86_64/unistd.h	2007-05-29 03:17:57.000000000 -0700
+++ linux-2.6.22/include/asm-x86_64/unistd.h	2007-05-29 03:24:14.000000000 -0700
@@ -630,7 +630,31 @@ __SYSCALL(__NR_signalfd, sys_signalfd)
 __SYSCALL(__NR_timerfd, sys_timerfd)
 #define __NR_eventfd		283
 __SYSCALL(__NR_eventfd, sys_eventfd)
-
+#define __NR_pfm_create_context	284
+__SYSCALL(__NR_pfm_create_context, sys_pfm_create_context)
+#define __NR_pfm_write_pmcs	(__NR_pfm_create_context+1)
+__SYSCALL(__NR_pfm_write_pmcs, sys_pfm_write_pmcs)
+#define __NR_pfm_write_pmds	(__NR_pfm_create_context+2)
+__SYSCALL(__NR_pfm_write_pmds, sys_pfm_write_pmds)
+#define __NR_pfm_read_pmds	(__NR_pfm_create_context+3)
+__SYSCALL(__NR_pfm_read_pmds, sys_pfm_read_pmds)
+#define __NR_pfm_load_context	(__NR_pfm_create_context+4)
+__SYSCALL(__NR_pfm_load_context, sys_pfm_load_context)
+#define __NR_pfm_start		(__NR_pfm_create_context+5)
+__SYSCALL(__NR_pfm_start, sys_pfm_start)
+#define __NR_pfm_stop		(__NR_pfm_create_context+6)
+__SYSCALL(__NR_pfm_stop, sys_pfm_stop)
+#define __NR_pfm_restart	(__NR_pfm_create_context+7)
+__SYSCALL(__NR_pfm_restart, sys_pfm_restart)
+#define __NR_pfm_create_evtsets	(__NR_pfm_create_context+8)
+__SYSCALL(__NR_pfm_create_evtsets, sys_pfm_create_evtsets)
+#define __NR_pfm_getinfo_evtsets (__NR_pfm_create_context+9)
+__SYSCALL(__NR_pfm_getinfo_evtsets, sys_pfm_getinfo_evtsets)
+#define __NR_pfm_delete_evtsets (__NR_pfm_create_context+10)
+__SYSCALL(__NR_pfm_delete_evtsets, sys_pfm_delete_evtsets)
+#define __NR_pfm_unload_context	(__NR_pfm_create_context+11)
+__SYSCALL(__NR_pfm_unload_context, sys_pfm_unload_context)
+ 
 #ifndef __NO_STUBS
 #define __ARCH_WANT_OLD_READDIR
 #define __ARCH_WANT_OLD_STAT
