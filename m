Return-Path: <linux-kernel-owner+w=401wt.eu-S1752318AbXDKL6h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752318AbXDKL6h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 07:58:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752319AbXDKL6h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 07:58:37 -0400
Received: from rtsoft3.corbina.net ([85.21.88.6]:20539 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752316AbXDKL6g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 07:58:36 -0400
Message-ID: <461CCD94.6010507@ru.mvista.com>
Date: Wed, 11 Apr 2007 15:59:16 +0400
From: Maxim Uvarov <muvarov@ru.mvista.com>
User-Agent: Debian Thunderbird 1.0.7 (X11/20051017)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: linux-kernel@vger.kernel.org, davidsen@tmr.com, randy.dunlap@oracle.com,
       Valdis.Kletnieks@vt.edu, jesper.juhl@gmail.com
Subject: Re: Performance Stats: Kernel patch
References: <461A4C1E.3070309@ru.mvista.com> <20070410102111.923b92a9.dada1@cosmosbay.com>
In-Reply-To: <20070410102111.923b92a9.dada1@cosmosbay.com>
Content-Type: multipart/mixed;
 boundary="------------080103070502000407090500"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080103070502000407090500
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Eric Dumazet wrote:
[snip]

> Please reorganize the code so that you dont duplicate 
> GET_THREAD_INFO() stuff


Thanks Eric, I's really better. I have done changes. Do you have any 
others objections now?
All is in attached perf_stat.patch.

Best regards,
Maxim Uvarov.

--------------080103070502000407090500
Content-Type: text/plain;
 name="perf_stat.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="perf_stat.patch"

Patch adds Process Performance Statistics.
It make available to the user the following 
new per-process (thread) performance statistics:
   * Involuntary Context Switches
   * Voluntary Context Switches
   * Number of system calls
   
This data is useful for detecting hyperactivity 
patterns between processes.

Signed-off-by: Maxim Uvarov muvarov@ru.mvista.com

 arch/i386/kernel/asm-offsets.c    |    3 +++
 arch/i386/kernel/entry.S          |    3 +++
 arch/powerpc/kernel/asm-offsets.c |    4 ++++
 arch/powerpc/kernel/entry_32.S    |    5 +++++
 arch/powerpc/kernel/entry_64.S    |    5 +++++
 arch/x86_64/kernel/asm-offsets.c  |    3 +++
 arch/x86_64/kernel/entry.S        |    3 +++
 fs/proc/array.c                   |   17 +++++++++++++++++
 include/asm-i386/thread_info.h    |    5 +++--
 include/asm-powerpc/thread_info.h |    3 +++
 include/asm-x86_64/thread_info.h  |    4 +++-
 kernel/fork.c                     |    4 ++++
 lib/Kconfig.debug                 |   15 +++++++++++++++
 13 files changed, 71 insertions(+), 3 deletions(-)

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
+       depends on THREAD_PERF_STAT && (X86 || PPC)
+       help
+         This option adds a syscall counter to /proc/PID/status.
Index: linux-2.6.21-rc5/arch/i386/kernel/entry.S
===================================================================
--- linux-2.6.21-rc5.orig/arch/i386/kernel/entry.S
+++ linux-2.6.21-rc5/arch/i386/kernel/entry.S
@@ -334,6 +334,9 @@ sysenter_past_esp:
 	CFI_ADJUST_CFA_OFFSET 4
 	SAVE_ALL
 	GET_THREAD_INFO(%ebp)
+#ifdef CONFIG_THREAD_PERF_STAT_SYSC
+        incl    TI_sysc_cnt(%ebp)       # Increment syscalls counter
+#endif /* CONFIG_THREAD_PERF_STAT_SYSC */
 
 	/* Note, _TIF_SECCOMP is bit number 8, and so it needs testw and not testb */
 	testw $(_TIF_SYSCALL_EMU|_TIF_SYSCALL_TRACE|_TIF_SECCOMP|_TIF_SYSCALL_AUDIT),TI_flags(%ebp)
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
@@ -202,6 +202,11 @@ _GLOBAL(DoSyscall)
 	bl	do_show_syscall
 #endif /* SHOW_SYSCALLS */
 	rlwinm	r10,r1,0,0,(31-THREAD_SHIFT)	/* current_thread_info() */
+#ifdef CONFIG_THREAD_PERF_STAT_SYSC
+	lwz r11,TI_SYSC_CNT(r10)
+	addi r11,r11,1
+	stw r11,TI_SYSC_CNT(r10)
+#endif /* CONFIG_THREAD_PERF_STAT_SYSC */
 	lwz	r11,TI_FLAGS(r10)
 	andi.	r11,r11,_TIF_SYSCALL_T_OR_A
 	bne-	syscall_dotrace
Index: linux-2.6.21-rc5/arch/powerpc/kernel/entry_64.S
===================================================================
--- linux-2.6.21-rc5.orig/arch/powerpc/kernel/entry_64.S
+++ linux-2.6.21-rc5/arch/powerpc/kernel/entry_64.S
@@ -115,6 +115,11 @@ END_FW_FTR_SECTION_IFSET(FW_FEATURE_ISER
 	addi	r9,r1,STACK_FRAME_OVERHEAD
 #endif
 	clrrdi	r11,r1,THREAD_SHIFT
+#ifdef CONFIG_THREAD_PERF_STAT_SYSC
+	lwz r10,TI_SYSC_CNT(r11)
+	addi r10,r10,1
+	stw r10,TI_SYSC_CNT(r11)
+#endif /* CONFIG_THREAD_PERF_STAT_SYSC */
 	ld	r10,TI_FLAGS(r11)
 	andi.	r11,r10,_TIF_SYSCALL_T_OR_A
 	bne-	syscall_dotrace
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
Index: linux-2.6.21-rc5/arch/x86_64/kernel/entry.S
===================================================================
--- linux-2.6.21-rc5.orig/arch/x86_64/kernel/entry.S
+++ linux-2.6.21-rc5/arch/x86_64/kernel/entry.S
@@ -229,6 +229,9 @@ ENTRY(system_call)
 	movq  %rcx,RIP-ARGOFFSET(%rsp)
 	CFI_REL_OFFSET rip,RIP-ARGOFFSET
 	GET_THREAD_INFO(%rcx)
+#ifdef CONFIG_THREAD_PERF_STAT_SYSC
+	addq $1, threadinfo_sysc_cnt(%rcx)   # Increment syscalls counter
+#endif /* CONFIG_THREAD_PERF_STAT_SYSC */
 	testl $(_TIF_SYSCALL_TRACE|_TIF_SYSCALL_AUDIT|_TIF_SECCOMP),threadinfo_flags(%rcx)
 	jnz tracesys
 	cmpq $__NR_syscall_max,%rax
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

--------------080103070502000407090500--
