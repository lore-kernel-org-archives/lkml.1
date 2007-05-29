Return-Path: <linux-kernel-owner+w=401wt.eu-S1757082AbXE2OBS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757082AbXE2OBS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 10:01:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752032AbXE2N7s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 09:59:48 -0400
Received: from madara.hpl.hp.com ([192.6.19.124]:56272 "EHLO madara.hpl.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750976AbXE2N7o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 09:59:44 -0400
X-Greylist: delayed 659 seconds by postgrey-1.27 at vger.kernel.org; Tue, 29 May 2007 09:59:42 EDT
Date: Tue, 29 May 2007 06:48:36 -0700
From: Stephane Eranian <eranian@frankl.hpl.hp.com>
Message-Id: <200705291348.l4TDmajk019879@frankl.hpl.hp.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 21/22] 2.6.22-rc3 perfmon2 : modified mips files
Cc: eranian@hpl.hp.com
X-HPL-MailScanner: Found to be clean
X-HPL-MailScanner-From: eranian@frankl.hpl.hp.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch contains the modified mips files


Modified files are as follows:

arch/mips/Kconfig:
	- add link to configuration menu in arch/mips/perfmon/Kconfig

arch/mips/Makefile:
	- add perfmon subdir

arch/mips/kernel/scall32-o32.S
	- add new system calls

arch/mips/kernel/scall64-64.S
	- add new system calls

arch/mips/kernel/scall64-n32.S
	- add new system calls

arch/mips/kernel/scall64-o32.S
	- add new system calls

arch/mips/kernel/time.c
	- add hook for perfmon time-base set switching

arch/mips/mips-boards/generic/time.c
	- add perfmon.h header to list of includes

arch/mips/kernel/process.c:
	- add hook in exit_thread() to cleanup perfmon2 context
	- add hook in copy_thread() to cleanup perfmon2 context in child (perfmon2 context
	  is never inherited)

arch/mips/kernel/signal.c:
	- add hook for extra work before kernel exit. Need to block a thread after a overflow with
	  user level notification. Also needed to do some bookeeeping, such as reset certain counters
	  and cleanup in some difficult corner cases

include/asm-mips/system.h
	- add context switch hook

asm-mips/thread_info.h
	- add TIF flags

include/asm-mips/unistd.h
	- add new system calls




diff --exclude=.git -urp linux-2.6.22.base/arch/mips/Kconfig linux-2.6.22/arch/mips/Kconfig
--- linux-2.6.22.base/arch/mips/Kconfig	2007-05-29 03:17:16.000000000 -0700
+++ linux-2.6.22/arch/mips/Kconfig	2007-05-29 03:24:14.000000000 -0700
@@ -1774,6 +1774,8 @@ config SECCOMP
 
 	  If unsure, say Y. Only embedded should say N here.
 
+source "arch/mips/perfmon/Kconfig"
+
 endmenu
 
 config RWSEM_GENERIC_SPINLOCK
diff --exclude=.git -urp linux-2.6.22.base/arch/mips/Makefile linux-2.6.22/arch/mips/Makefile
--- linux-2.6.22.base/arch/mips/Makefile	2007-05-29 03:17:16.000000000 -0700
+++ linux-2.6.22/arch/mips/Makefile	2007-05-29 03:24:14.000000000 -0700
@@ -148,6 +148,12 @@ endif
 endif
 
 #
+# Perfmon support
+#
+
+core-$(CONFIG_PERFMON)		+= arch/mips/perfmon/
+
+#
 # Firmware support
 #
 libs-$(CONFIG_ARC)		+= arch/mips/arc/
diff --exclude=.git -urp linux-2.6.22.base/arch/mips/kernel/process.c linux-2.6.22/arch/mips/kernel/process.c
--- linux-2.6.22.base/arch/mips/kernel/process.c	2007-05-29 03:17:16.000000000 -0700
+++ linux-2.6.22/arch/mips/kernel/process.c	2007-05-29 03:24:14.000000000 -0700
@@ -25,6 +25,7 @@
 #include <linux/init.h>
 #include <linux/completion.h>
 #include <linux/kallsyms.h>
+#include <linux/perfmon.h>
 
 #include <asm/bootinfo.h>
 #include <asm/cpu.h>
@@ -90,6 +91,7 @@ void start_thread(struct pt_regs * regs,
 
 void exit_thread(void)
 {
+  pfm_exit_thread(current);
 }
 
 void flush_thread(void)
@@ -164,6 +166,8 @@ int copy_thread(int nr, unsigned long cl
 	if (clone_flags & CLONE_SETTLS)
 		ti->tp_value = regs->regs[7];
 
+	pfm_copy_thread(p);
+
 	return 0;
 }
 
diff --exclude=.git -urp linux-2.6.22.base/arch/mips/kernel/scall32-o32.S linux-2.6.22/arch/mips/kernel/scall32-o32.S
--- linux-2.6.22.base/arch/mips/kernel/scall32-o32.S	2007-05-29 03:17:16.000000000 -0700
+++ linux-2.6.22/arch/mips/kernel/scall32-o32.S	2007-05-29 03:24:14.000000000 -0700
@@ -657,7 +657,19 @@ einval:	li	v0, -EINVAL
 	sys	sys_getcpu		3
 	sys	sys_epoll_pwait		6
 	sys	sys_ioprio_set		3
-	sys	sys_ioprio_get		2
+	sys	sys_ioprio_get		2	/* 4315 */
+      	sys	sys_pfm_create_context	4
+      	sys	sys_pfm_write_pmcs	3
+      	sys	sys_pfm_write_pmds	4
+      	sys	sys_pfm_read_pmds	3
+      	sys	sys_pfm_load_context	2	/* 4320 */
+      	sys	sys_pfm_start		2
+      	sys	sys_pfm_stop		1
+      	sys	sys_pfm_restart		1
+      	sys	sys_pfm_create_evtsets	3
+      	sys	sys_pfm_getinfo_evtsets 3	/* 4325 */
+      	sys	sys_pfm_delete_evtsets	3
+      	sys	sys_pfm_unload_context	1
 	.endm
 
 	/* We pre-compute the number of _instruction_ bytes needed to
diff --exclude=.git -urp linux-2.6.22.base/arch/mips/kernel/scall64-64.S linux-2.6.22/arch/mips/kernel/scall64-64.S
--- linux-2.6.22.base/arch/mips/kernel/scall64-64.S	2007-05-29 03:17:16.000000000 -0700
+++ linux-2.6.22/arch/mips/kernel/scall64-64.S	2007-05-29 03:24:14.000000000 -0700
@@ -473,4 +473,16 @@ sys_call_table:
 	PTR	sys_epoll_pwait
 	PTR	sys_ioprio_set
 	PTR	sys_ioprio_get
+      	PTR	sys_pfm_create_context		/* 5275 */
+      	PTR	sys_pfm_write_pmcs
+      	PTR	sys_pfm_write_pmds
+      	PTR	sys_pfm_read_pmds
+      	PTR	sys_pfm_load_context
+      	PTR	sys_pfm_start			/* 5280 */
+      	PTR	sys_pfm_stop
+      	PTR	sys_pfm_restart
+      	PTR	sys_pfm_create_evtsets
+      	PTR	sys_pfm_getinfo_evtsets
+      	PTR	sys_pfm_delete_evtsets		/* 5285 */
+ 	PTR	sys_pfm_unload_context
 	.size	sys_call_table,.-sys_call_table
diff --exclude=.git -urp linux-2.6.22.base/arch/mips/kernel/scall64-n32.S linux-2.6.22/arch/mips/kernel/scall64-n32.S
--- linux-2.6.22.base/arch/mips/kernel/scall64-n32.S	2007-05-29 03:17:16.000000000 -0700
+++ linux-2.6.22/arch/mips/kernel/scall64-n32.S	2007-05-29 03:24:14.000000000 -0700
@@ -399,4 +399,16 @@ EXPORT(sysn32_call_table)
 	PTR	compat_sys_epoll_pwait
 	PTR	sys_ioprio_set
 	PTR	sys_ioprio_get
+     	PTR	sys_pfm_create_context
+     	PTR	sys_pfm_write_pmcs		/* 6280 */
+     	PTR	sys_pfm_write_pmds
+     	PTR	sys_pfm_read_pmds
+     	PTR	sys_pfm_load_context
+     	PTR	sys_pfm_start
+     	PTR	sys_pfm_stop			/* 6285 */
+     	PTR	sys_pfm_restart
+     	PTR	sys_pfm_create_evtsets
+     	PTR	sys_pfm_getinfo_evtsets
+     	PTR	sys_pfm_delete_evtsets
+  	PTR	sys_pfm_unload_context		/* 6290 */
 	.size	sysn32_call_table,.-sysn32_call_table
diff --exclude=.git -urp linux-2.6.22.base/arch/mips/kernel/scall64-o32.S linux-2.6.22/arch/mips/kernel/scall64-o32.S
--- linux-2.6.22.base/arch/mips/kernel/scall64-o32.S	2007-05-29 03:17:16.000000000 -0700
+++ linux-2.6.22/arch/mips/kernel/scall64-o32.S	2007-05-29 03:24:14.000000000 -0700
@@ -521,4 +521,16 @@ sys_call_table:
 	PTR	compat_sys_epoll_pwait
 	PTR	sys_ioprio_set
 	PTR	sys_ioprio_get			/* 4315 */
+    	PTR	sys_pfm_create_context
+     	PTR	sys_pfm_write_pmcs
+     	PTR	sys_pfm_write_pmds
+     	PTR	sys_pfm_read_pmds
+     	PTR	sys_pfm_load_context		/* 4320 */
+     	PTR	sys_pfm_start
+     	PTR	sys_pfm_stop
+     	PTR	sys_pfm_restart
+     	PTR	sys_pfm_create_evtsets
+    	PTR	sys_pfm_getinfo_evtsets		/* 4325 */
+     	PTR	sys_pfm_delete_evtsets
+     	PTR	sys_pfm_unload_context
 	.size	sys_call_table,.-sys_call_table
diff --exclude=.git -urp linux-2.6.22.base/arch/mips/kernel/signal.c linux-2.6.22/arch/mips/kernel/signal.c
--- linux-2.6.22.base/arch/mips/kernel/signal.c	2007-05-29 03:17:16.000000000 -0700
+++ linux-2.6.22/arch/mips/kernel/signal.c	2007-05-29 03:24:14.000000000 -0700
@@ -20,6 +20,7 @@
 #include <linux/unistd.h>
 #include <linux/compiler.h>
 #include <linux/uaccess.h>
+#include <linux/perfmon.h>
 
 #include <asm/abi.h>
 #include <asm/asm.h>
@@ -696,6 +697,9 @@ static void do_signal(struct pt_regs *re
 asmlinkage void do_notify_resume(struct pt_regs *regs, void *unused,
 	__u32 thread_info_flags)
 {
+        if (thread_info_flags & _TIF_PERFMON_WORK)
+		pfm_handle_work(regs);
+
 	/* deal with pending signal delivery */
 	if (thread_info_flags & (_TIF_SIGPENDING | _TIF_RESTORE_SIGMASK))
 		do_signal(regs);
diff --exclude=.git -urp linux-2.6.22.base/arch/mips/kernel/time.c linux-2.6.22/arch/mips/kernel/time.c
--- linux-2.6.22.base/arch/mips/kernel/time.c	2007-05-29 03:17:16.000000000 -0700
+++ linux-2.6.22/arch/mips/kernel/time.c	2007-05-29 03:24:14.000000000 -0700
@@ -23,6 +23,7 @@
 #include <linux/spinlock.h>
 #include <linux/interrupt.h>
 #include <linux/module.h>
+#include <linux/perfmon.h>
 
 #include <asm/bootinfo.h>
 #include <asm/cache.h>
@@ -140,6 +141,7 @@ static long last_rtc_update;
 void local_timer_interrupt(int irq, void *dev_id)
 {
 	profile_tick(CPU_PROFILING);
+ 	pfm_handle_switch_timeout();
 	update_process_times(user_mode(get_irq_regs()));
 }
 
diff --exclude=.git -urp linux-2.6.22.base/arch/mips/mips-boards/generic/time.c linux-2.6.22/arch/mips/mips-boards/generic/time.c
--- linux-2.6.22.base/arch/mips/mips-boards/generic/time.c	2007-05-29 03:17:16.000000000 -0700
+++ linux-2.6.22/arch/mips/mips-boards/generic/time.c	2007-05-29 03:24:14.000000000 -0700
@@ -27,6 +27,7 @@
 #include <linux/time.h>
 #include <linux/timex.h>
 #include <linux/mc146818rtc.h>
+#include <linux/perfmon.h>
 
 #include <asm/mipsregs.h>
 #include <asm/mipsmtregs.h>
Only in linux-2.6.22/arch/mips: perfmon
Only in linux-2.6.22/include/asm-mips: perfmon.h
Only in linux-2.6.22/include/asm-mips: perfmon_api.h
diff --exclude=.git -urp linux-2.6.22.base/include/asm-mips/system.h linux-2.6.22/include/asm-mips/system.h
--- linux-2.6.22.base/include/asm-mips/system.h	2007-05-29 03:17:57.000000000 -0700
+++ linux-2.6.22/include/asm-mips/system.h	2007-05-29 03:24:14.000000000 -0700
@@ -65,6 +65,9 @@ do {									\
 do {									\
 	if (cpu_has_dsp)						\
 		__save_dsp(prev);					\
+	if (test_tsk_thread_flag(prev, TIF_PERFMON_CTXSW)		\
+	    || test_tsk_thread_flag(next, TIF_PERFMON_CTXSW))		\
+		pfm_ctxsw(prev, next);					\
 	(last) = resume(prev, next, task_thread_info(next));		\
 	if (cpu_has_dsp)						\
 		__restore_dsp(current);					\
diff --exclude=.git -urp linux-2.6.22.base/include/asm-mips/thread_info.h linux-2.6.22/include/asm-mips/thread_info.h
--- linux-2.6.22.base/include/asm-mips/thread_info.h	2007-05-29 03:20:21.000000000 -0700
+++ linux-2.6.22/include/asm-mips/thread_info.h	2007-05-29 03:24:14.000000000 -0700
@@ -113,11 +113,13 @@ register struct thread_info *__current_t
 #define TIF_NEED_RESCHED	2	/* rescheduling necessary */
 #define TIF_SYSCALL_AUDIT	3	/* syscall auditing active */
 #define TIF_SECCOMP		4	/* secure computing */
-#define TIF_RESTORE_SIGMASK	9	/* restore signal mask in do_signal() */
+#define TIF_RESTORE_SIGMASK	5	/* restore signal mask in do_signal() */
+#define TIF_PERFMON_WORK	6	/* work for pfm_handle_work() */
 #define TIF_USEDFPU		16	/* FPU was used by this task this quantum (SMP) */
 #define TIF_POLLING_NRFLAG	17	/* true if poll_idle() is polling TIF_NEED_RESCHED */
 #define TIF_MEMDIE		18
 #define TIF_FREEZE		19
+#define TIF_PERFMON_CTXSW	21	/* perfmon needs ctxsw calls */
 #define TIF_SYSCALL_TRACE	31	/* syscall trace active */
 
 #define _TIF_SYSCALL_TRACE	(1<<TIF_SYSCALL_TRACE)
@@ -129,6 +131,8 @@ register struct thread_info *__current_t
 #define _TIF_USEDFPU		(1<<TIF_USEDFPU)
 #define _TIF_POLLING_NRFLAG	(1<<TIF_POLLING_NRFLAG)
 #define _TIF_FREEZE		(1<<TIF_FREEZE)
+#define _TIF_PERFMON_WORK	(1<<TIF_PERFMON_WORK)
+#define _TIF_PERFMON_CTXSW	(1<<TIF_PERFMON_CTXSW)
 
 /* work to do on interrupt/exception return */
 #define _TIF_WORK_MASK		(0x0000ffef & ~_TIF_SECCOMP)
diff --exclude=.git -urp linux-2.6.22.base/include/asm-mips/unistd.h linux-2.6.22/include/asm-mips/unistd.h
--- linux-2.6.22.base/include/asm-mips/unistd.h	2007-05-29 03:17:57.000000000 -0700
+++ linux-2.6.22/include/asm-mips/unistd.h	2007-05-29 03:24:14.000000000 -0700
@@ -336,16 +336,28 @@
 #define __NR_epoll_pwait		(__NR_Linux + 313)
 #define __NR_ioprio_set			(__NR_Linux + 314)
 #define __NR_ioprio_get			(__NR_Linux + 315)
-
+#define __NR_pfm_create_context         (__NR_Linux + 316)
+#define __NR_pfm_write_pmcs		(__NR_pfm_create_context+1)
+#define __NR_pfm_write_pmds		(__NR_pfm_create_context+2)
+#define __NR_pfm_read_pmds		(__NR_pfm_create_context+3)
+#define __NR_pfm_load_context		(__NR_pfm_create_context+4)
+#define __NR_pfm_start			(__NR_pfm_create_context+5)
+#define __NR_pfm_stop			(__NR_pfm_create_context+6)
+#define __NR_pfm_restart		(__NR_pfm_create_context+7)
+#define __NR_pfm_create_evtsets		(__NR_pfm_create_context+8)
+#define __NR_pfm_getinfo_evtsets 	(__NR_pfm_create_context+9)
+#define __NR_pfm_delete_evtsets 	(__NR_pfm_create_context+10)
+#define __NR_pfm_unload_context		(__NR_pfm_create_context+11)
+ 
 /*
  * Offset of the last Linux o32 flavoured syscall
  */
-#define __NR_Linux_syscalls		315
+#define __NR_Linux_syscalls		327
 
 #endif /* _MIPS_SIM == _MIPS_SIM_ABI32 */
 
 #define __NR_O32_Linux			4000
-#define __NR_O32_Linux_syscalls		315
+#define __NR_O32_Linux_syscalls		327
 
 #if _MIPS_SIM == _MIPS_SIM_ABI64
 
@@ -628,16 +640,28 @@
 #define __NR_epoll_pwait		(__NR_Linux + 272)
 #define __NR_ioprio_set			(__NR_Linux + 273)
 #define __NR_ioprio_get			(__NR_Linux + 274)
-
+#define __NR_pfm_create_context         (__NR_Linux + 275)
+#define __NR_pfm_write_pmcs		(__NR_pfm_create_context+1)
+#define __NR_pfm_write_pmds		(__NR_pfm_create_context+2)
+#define __NR_pfm_read_pmds		(__NR_pfm_create_context+3)
+#define __NR_pfm_load_context		(__NR_pfm_create_context+4)
+#define __NR_pfm_start			(__NR_pfm_create_context+5)
+#define __NR_pfm_stop			(__NR_pfm_create_context+6)
+#define __NR_pfm_restart		(__NR_pfm_create_context+7)
+#define __NR_pfm_create_evtsets		(__NR_pfm_create_context+8)
+#define __NR_pfm_getinfo_evtsets 	(__NR_pfm_create_context+9)
+#define __NR_pfm_delete_evtsets 	(__NR_pfm_create_context+10)
+#define __NR_pfm_unload_context		(__NR_pfm_create_context+11)
+ 
 /*
  * Offset of the last Linux 64-bit flavoured syscall
  */
-#define __NR_Linux_syscalls		274
+#define __NR_Linux_syscalls		286
 
 #endif /* _MIPS_SIM == _MIPS_SIM_ABI64 */
 
 #define __NR_64_Linux			5000
-#define __NR_64_Linux_syscalls		274
+#define __NR_64_Linux_syscalls		286
 
 #if _MIPS_SIM == _MIPS_SIM_NABI32
 
@@ -924,16 +948,28 @@
 #define __NR_epoll_pwait		(__NR_Linux + 276)
 #define __NR_ioprio_set			(__NR_Linux + 277)
 #define __NR_ioprio_get			(__NR_Linux + 278)
-
+#define __NR_pfm_create_context         (__NR_Linux + 279)
+#define __NR_pfm_write_pmcs		(__NR_pfm_create_context+1)
+#define __NR_pfm_write_pmds		(__NR_pfm_create_context+2)
+#define __NR_pfm_read_pmds		(__NR_pfm_create_context+3)
+#define __NR_pfm_load_context		(__NR_pfm_create_context+4)
+#define __NR_pfm_start			(__NR_pfm_create_context+5)
+#define __NR_pfm_stop			(__NR_pfm_create_context+6)
+#define __NR_pfm_restart		(__NR_pfm_create_context+7)
+#define __NR_pfm_create_evtsets		(__NR_pfm_create_context+8)
+#define __NR_pfm_getinfo_evtsets 	(__NR_pfm_create_context+9)
+#define __NR_pfm_delete_evtsets 	(__NR_pfm_create_context+10)
+#define __NR_pfm_unload_context		(__NR_pfm_create_context+11)
+ 
 /*
  * Offset of the last N32 flavoured syscall
  */
-#define __NR_Linux_syscalls		278
+#define __NR_Linux_syscalls		290
 
 #endif /* _MIPS_SIM == _MIPS_SIM_NABI32 */
 
 #define __NR_N32_Linux			6000
-#define __NR_N32_Linux_syscalls		278
+#define __NR_N32_Linux_syscalls		290
 
 #ifdef __KERNEL__
 
