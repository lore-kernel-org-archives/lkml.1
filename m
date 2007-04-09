Return-Path: <linux-kernel-owner+w=401wt.eu-S1753320AbXDIOVw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753320AbXDIOVw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 10:21:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753348AbXDIOVv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 10:21:51 -0400
Received: from rtsoft3.corbina.net ([85.21.88.6]:16990 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753320AbXDIOVu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 10:21:50 -0400
Message-ID: <461A4C1E.3070309@ru.mvista.com>
Date: Mon, 09 Apr 2007 18:22:22 +0400
From: Maxim Uvarov <muvarov@ru.mvista.com>
User-Agent: Debian Thunderbird 1.0.7 (X11/20051017)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Cc: davidsen@tmr.com, randy.dunlap@oracle.com, dada1@cosmosbay.com,
       Valdis.Kletnieks@vt.edu, jesper.juhl@gmail.com
Subject: Performance Stats: Kernel patch
Content-Type: multipart/mixed;
 boundary="------------040307000606060307080200"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040307000606060307080200
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hello collogues,

Patches make available to the user the following new per-process 
(thread) performance statistics:

    * Involuntary Context Switches
    * Voluntary Context Switches
    * Number of system calls

This data is useful for detecting hyperactivity patterns between processes.

I have attached 3 patches  perf_stat.patch, perf_stat_x86_64.patch and 
perf_stat_ppc.patch for linux-2.6.21-rc5
and corrected all notes which were before.  Do you have any objections? 
I need your opinion again.

Best regards,
Maxim Uvarov.










--------------040307000606060307080200
Content-Type: text/plain;
 name="perf_stat.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="perf_stat.patch"

Patch adds Process Performance Statistics.

 arch/i386/kernel/asm-offsets.c |    3 +++
 arch/i386/kernel/entry.S       |    6 ++++++
 fs/proc/array.c                |   17 +++++++++++++++++
 include/asm-i386/thread_info.h |    5 +++--
 kernel/fork.c                  |    4 ++++
 lib/Kconfig.debug              |   15 +++++++++++++++
 6 files changed, 48 insertions(+), 2 deletions(-)

Index: linux-2.6.21-rc5/fs/proc/array.c
===================================================================
--- linux-2.6.21-rc5.orig/fs/proc/array.c
+++ linux-2.6.21-rc5/fs/proc/array.c
@@ -291,6 +291,20 @@ static inline char *task_cap(struct task
 			    cap_t(p->cap_effective));
 }
 
+#ifdef CONFIG_THREAD_PERF_STAT
+static inline char *task_perf(struct task_struct *p, char *buffer)
+{
+#ifdef CONFIG_THREAD_PERF_STAT_SYSC
+       buffer += sprintf(buffer, "Syscalls:\t%lu\n", p->thread_info->sysc_cnt);
+#endif /* CONFIG_THREAD_PERF_STAT_SYSC */
+
+       return buffer + sprintf(buffer, "Nvcsw:\t%lu\n"
+                           "Nivcsw:\t%lu\n",
+                           p->nvcsw,
+                           p->nivcsw);
+}
+#endif /* CONFIG_THREAD_PERF_STAT */
+
 int proc_pid_status(struct task_struct *task, char * buffer)
 {
 	char * orig = buffer;
@@ -309,6 +323,9 @@ int proc_pid_status(struct task_struct *
 #if defined(CONFIG_S390)
 	buffer = task_show_regs(task, buffer);
 #endif
+#ifdef CONFIG_THREAD_PERF_STAT
+	buffer = task_perf(task, buffer);
+#endif /* CONFIG_THREAD_PERF_STAT */
 	return buffer - orig;
 }
 
Index: linux-2.6.21-rc5/kernel/fork.c
===================================================================
--- linux-2.6.21-rc5.orig/kernel/fork.c
+++ linux-2.6.21-rc5/kernel/fork.c
@@ -1044,6 +1044,10 @@ static struct task_struct *copy_process(
 	p->syscr = 0;		/* I/O counter: read syscalls */
 	p->syscw = 0;		/* I/O counter: write syscalls */
 #endif
+#ifdef CONFIG_THREAD_PERF_STAT_SYSC
+        p->thread_info->sysc_cnt = 0;   /* Syscall counter: total numbers of syscalls */
+#endif /* CONFIG_THREAD_PERF_STAT_SYSC */
+
 	task_io_accounting_init(p);
 	acct_clear_integrals(p);
 
Index: linux-2.6.21-rc5/lib/Kconfig.debug
===================================================================
--- linux-2.6.21-rc5.orig/lib/Kconfig.debug
+++ linux-2.6.21-rc5/lib/Kconfig.debug
@@ -446,3 +446,18 @@ config FAULT_INJECTION_STACKTRACE_FILTER
 	select FRAME_POINTER
 	help
 	  Provide stacktrace filter for fault-injection capabilities
+
+config THREAD_PERF_STAT
+       bool "Per-process (thread) performance statistics"
+       help
+         Make available to the user the following per-process (thread) performance statistics:
+            * Number of involuntary context switches
+            * Number of voluntary context switches
+            * Number of system calls (optional)
+         This information is available via /proc/PID/status.
+
+config THREAD_PERF_STAT_SYSC
+       bool "Enable syscall counter"
+       depends on THREAD_PERF_STAT && X86_32
+       help
+         This option adds a syscall counter to /proc/PID/status.
Index: linux-2.6.21-rc5/arch/i386/kernel/entry.S
===================================================================
--- linux-2.6.21-rc5.orig/arch/i386/kernel/entry.S
+++ linux-2.6.21-rc5/arch/i386/kernel/entry.S
@@ -342,6 +342,9 @@ sysenter_past_esp:
 	jae syscall_badsys
 	call *sys_call_table(,%eax,4)
 	movl %eax,PT_EAX(%esp)
+#ifdef CONFIG_THREAD_PERF_STAT_SYSC
+        incl    TI_sysc_cnt(%ebp)       # Increment syscalls counter
+#endif /* CONFIG_THREAD_PERF_STAT_SYSC */
 	DISABLE_INTERRUPTS(CLBR_ECX|CLBR_EDX)
 	TRACE_IRQS_OFF
 	movl TI_flags(%ebp), %ecx
@@ -385,6 +388,9 @@ syscall_call:
 	call *sys_call_table(,%eax,4)
 	movl %eax,PT_EAX(%esp)		# store the return value
 syscall_exit:
+#ifdef CONFIG_THREAD_PERF_STAT_SYSC
+        incl    TI_sysc_cnt(%ebp)       # Increment syscalls counter 
+#endif /* CONFIG_THREAD_PERF_STAT_SYSC */
 	DISABLE_INTERRUPTS(CLBR_ANY)	# make sure we don't miss an interrupt
 					# setting need_resched or sigpending
 					# between sampling and the iret
Index: linux-2.6.21-rc5/arch/i386/kernel/asm-offsets.c
===================================================================
--- linux-2.6.21-rc5.orig/arch/i386/kernel/asm-offsets.c
+++ linux-2.6.21-rc5/arch/i386/kernel/asm-offsets.c
@@ -56,6 +56,9 @@ void foo(void)
 	OFFSET(TI_addr_limit, thread_info, addr_limit);
 	OFFSET(TI_restart_block, thread_info, restart_block);
 	OFFSET(TI_sysenter_return, thread_info, sysenter_return);
+#ifdef CONFIG_THREAD_PERF_STAT_SYSC
+        OFFSET(TI_sysc_cnt, thread_info, sysc_cnt);
+#endif /* CONFIG_THREAD_PERF_STAT_SYSC */
 	BLANK();
 
 	OFFSET(GDS_size, Xgt_desc_struct, size);
Index: linux-2.6.21-rc5/include/asm-i386/thread_info.h
===================================================================
--- linux-2.6.21-rc5.orig/include/asm-i386/thread_info.h
+++ linux-2.6.21-rc5/include/asm-i386/thread_info.h
@@ -31,8 +31,9 @@ struct thread_info {
 	unsigned long		status;		/* thread-synchronous flags */
 	__u32			cpu;		/* current CPU */
 	int			preempt_count;	/* 0 => preemptable, <0 => BUG */
-
-
+#ifdef CONFIG_THREAD_PERF_STAT_SYSC
+	unsigned long		sysc_cnt;	/* Syscall counter */
+#endif /* CONFIG_THREAD_PERF_STAT_SYSC */
 	mm_segment_t		addr_limit;	/* thread address space:
 					 	   0-0xBFFFFFFF for user-thead
 						   0-0xFFFFFFFF for kernel-thread

--------------040307000606060307080200
Content-Type: text/plain;
 name="perf_stat_x86_64.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="perf_stat_x86_64.patch"

Index: linux-2.6.21-rc5/lib/Kconfig.debug
===================================================================
--- linux-2.6.21-rc5.orig/lib/Kconfig.debug
+++ linux-2.6.21-rc5/lib/Kconfig.debug
@@ -458,6 +458,6 @@ config THREAD_PERF_STAT
 
 config THREAD_PERF_STAT_SYSC
        bool "Enable syscall counter"
-       depends on THREAD_PERF_STAT && X86_32
+       depends on THREAD_PERF_STAT && X86
        help
          This option adds a syscall counter to /proc/PID/status.
Index: linux-2.6.21-rc5/include/asm-x86_64/thread_info.h
===================================================================
--- linux-2.6.21-rc5.orig/include/asm-x86_64/thread_info.h
+++ linux-2.6.21-rc5/include/asm-x86_64/thread_info.h
@@ -30,7 +30,9 @@ struct thread_info {
 	__u32			status;		/* thread synchronous flags */
 	__u32			cpu;		/* current CPU */
 	int 			preempt_count;	/* 0 => preemptable, <0 => BUG */
-
+#ifdef CONFIG_THREAD_PERF_STAT_SYSC
+	unsigned long		sysc_cnt;	/* Syscall counter */
+#endif /* CONFIG_THREAD_PERF_STAT_SYSC */
 	mm_segment_t		addr_limit;	
 	struct restart_block    restart_block;
 };
Index: linux-2.6.21-rc5/arch/x86_64/kernel/entry.S
===================================================================
--- linux-2.6.21-rc5.orig/arch/x86_64/kernel/entry.S
+++ linux-2.6.21-rc5/arch/x86_64/kernel/entry.S
@@ -236,6 +236,11 @@ ENTRY(system_call)
 	movq %r10,%rcx
 	call *sys_call_table(,%rax,8)  # XXX:	 rip relative
 	movq %rax,RAX-ARGOFFSET(%rsp)
+#ifdef CONFIG_THREAD_PERF_STAT_SYSC
+	GET_THREAD_INFO(%rcx)
+	addq $1, threadinfo_sysc_cnt(%rcx)   # Increment syscalls counter
+#endif /* CONFIG_THREAD_PERF_STAT_SYSC */
+
 /*
  * Syscall return path ending with SYSRET (fast path)
  * Has incomplete stack frame and undefined top of stack. 
@@ -319,6 +324,10 @@ tracesys:			 
 	call *sys_call_table(,%rax,8)
 1:	movq %rax,RAX-ARGOFFSET(%rsp)
 	/* Use IRET because user could have changed frame */
+#ifdef CONFIG_THREAD_PERF_STAT_SYSC
+	GET_THREAD_INFO(%rcx)
+	addq $1, threadinfo_sysc_cnt(%rcx)   # Increment syscalls counter
+#endif /* CONFIG_THREAD_PERF_STAT_SYSC */
 		
 /* 
  * Syscall return path ending with IRET.
Index: linux-2.6.21-rc5/arch/x86_64/kernel/asm-offsets.c
===================================================================
--- linux-2.6.21-rc5.orig/arch/x86_64/kernel/asm-offsets.c
+++ linux-2.6.21-rc5/arch/x86_64/kernel/asm-offsets.c
@@ -35,6 +35,9 @@ int main(void)
 	ENTRY(addr_limit);
 	ENTRY(preempt_count);
 	ENTRY(status);
+#ifdef CONFIG_THREAD_PERF_STAT_SYSC 
+	ENTRY(sysc_cnt);
+#endif /* CONFIG_THREAD_PERF_STAT_SYSC */
 	BLANK();
 #undef ENTRY
 #define ENTRY(entry) DEFINE(pda_ ## entry, offsetof(struct x8664_pda, entry))

--------------040307000606060307080200
Content-Type: text/plain;
 name="perf_stat_ppc.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="perf_stat_ppc.patch"

Index: linux-2.6.21-rc5/include/asm-powerpc/thread_info.h
===================================================================
--- linux-2.6.21-rc5.orig/include/asm-powerpc/thread_info.h
+++ linux-2.6.21-rc5/include/asm-powerpc/thread_info.h
@@ -35,6 +35,9 @@ struct thread_info {
 	int		cpu;			/* cpu we're on */
 	int		preempt_count;		/* 0 => preemptable,
 						   <0 => BUG */
+#ifdef CONFIG_THREAD_PERF_STAT_SYSC
+	unsigned long	sysc_cnt;		/* Syscall counter */
+#endif /* CONFIG_THREAD_PERF_STAT_SYSC */
 	struct restart_block restart_block;
 	unsigned long	local_flags;		/* private flags for thread */
 
Index: linux-2.6.21-rc5/arch/powerpc/kernel/asm-offsets.c
===================================================================
--- linux-2.6.21-rc5.orig/arch/powerpc/kernel/asm-offsets.c
+++ linux-2.6.21-rc5/arch/powerpc/kernel/asm-offsets.c
@@ -94,6 +94,10 @@ int main(void)
 	DEFINE(TI_LOCAL_FLAGS, offsetof(struct thread_info, local_flags));
 	DEFINE(TI_PREEMPT, offsetof(struct thread_info, preempt_count));
 	DEFINE(TI_TASK, offsetof(struct thread_info, task));
+#ifdef CONFIG_THREAD_PERF_STAT_SYSC
+        DEFINE(TI_SYSC_CNT, offsetof(struct thread_info, sysc_cnt)); 
+#endif /* CONFIG_THREAD_PERF_STAT_SYSC */
+		
 #ifdef CONFIG_PPC32
 	DEFINE(TI_EXECDOMAIN, offsetof(struct thread_info, exec_domain));
 	DEFINE(TI_CPU, offsetof(struct thread_info, cpu));
Index: linux-2.6.21-rc5/arch/powerpc/kernel/entry_32.S
===================================================================
--- linux-2.6.21-rc5.orig/arch/powerpc/kernel/entry_32.S
+++ linux-2.6.21-rc5/arch/powerpc/kernel/entry_32.S
@@ -223,6 +223,11 @@ ret_from_syscall:
 #endif
 	mr	r6,r3
 	rlwinm	r12,r1,0,0,(31-THREAD_SHIFT)	/* current_thread_info() */
+#ifdef CONFIG_THREAD_PERF_STAT_SYSC
+	lwz r9,TI_SYSC_CNT(r12)
+	addi r9,r9,1
+	stw r9,TI_SYSC_CNT(r12)
+#endif /* CONFIG_THREAD_PERF_STAT_SYSC */
 	/* disable interrupts so current_thread_info()->flags can't change */
 	LOAD_MSR_KERNEL(r10,MSR_KERNEL)	/* doesn't include MSR_EE */
 	SYNC
Index: linux-2.6.21-rc5/lib/Kconfig.debug
===================================================================
--- linux-2.6.21-rc5.orig/lib/Kconfig.debug
+++ linux-2.6.21-rc5/lib/Kconfig.debug
@@ -458,6 +458,6 @@ config THREAD_PERF_STAT
 
 config THREAD_PERF_STAT_SYSC
        bool "Enable syscall counter"
-       depends on THREAD_PERF_STAT && X86
+       depends on THREAD_PERF_STAT && (X86 || PPC32)
        help
          This option adds a syscall counter to /proc/PID/status.

--------------040307000606060307080200--
