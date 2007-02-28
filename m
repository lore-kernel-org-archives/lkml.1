Return-Path: <linux-kernel-owner+w=401wt.eu-S932459AbXB1Vvy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932459AbXB1Vvy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 16:51:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932481AbXB1Vvw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 16:51:52 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:37950 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932483AbXB1VuT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 16:50:19 -0500
Date: Wed, 28 Feb 2007 22:42:37 +0100
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ulrich Drepper <drepper@redhat.com>, Zach Brown <zach.brown@oracle.com>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [patch 12/12] syslets: x86_64: add syslet/threadlet support
Message-ID: <20070228214237.GL2305@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070228213938.GA945@elte.hu>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>

add the arch specific bits of syslet/threadlet support to x86_64.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86_64/Kconfig            |    4 ++
 arch/x86_64/ia32/ia32entry.S   |   20 ++++++++++-
 arch/x86_64/kernel/entry.S     |   72 ++++++++++++++++++++++++++++++++++++++++-
 arch/x86_64/kernel/process.c   |   11 ++++++
 include/asm-x86_64/processor.h |   16 +++++++++
 include/asm-x86_64/system.h    |   12 ++++++
 include/asm-x86_64/unistd.h    |   29 +++++++++++++++-
 7 files changed, 160 insertions(+), 4 deletions(-)

Index: linux/arch/x86_64/Kconfig
===================================================================
--- linux.orig/arch/x86_64/Kconfig
+++ linux/arch/x86_64/Kconfig
@@ -36,6 +36,10 @@ config ZONE_DMA32
 	bool
 	default y
 
+config ASYNC_SUPPORT
+	bool
+	default y
+
 config LOCKDEP_SUPPORT
 	bool
 	default y
Index: linux/arch/x86_64/ia32/ia32entry.S
===================================================================
--- linux.orig/arch/x86_64/ia32/ia32entry.S
+++ linux/arch/x86_64/ia32/ia32entry.S
@@ -368,6 +368,14 @@ quiet_ni_syscall:
 	PTREGSCALL stub32_vfork, sys_vfork, %rdi
 	PTREGSCALL stub32_iopl, sys_iopl, %rsi
 	PTREGSCALL stub32_rt_sigsuspend, sys_rt_sigsuspend, %rdx
+	/*
+	 * sys_async_thread() and sys_async_exec() both take 2 parameters,
+	 * none of which is ptregs - but the syscalls rely on being able to
+	 * modify ptregs. So we put ptregs into the 3rd parameter - so it's
+	 * unused and it also does not mess up the first 2 parameters:
+	 */
+	PTREGSCALL stub32_compat_async_exec, compat_sys_async_exec, %rdx
+	PTREGSCALL stub32_compat_async_thread, sys_async_thread, %rdx
 
 ENTRY(ia32_ptregs_common)
 	popq %r11
@@ -394,6 +402,9 @@ END(ia32_ptregs_common)
 
 	.section .rodata,"a"
 	.align 8
+.globl compat_sys_call_table
+compat_sys_call_table:
+.globl ia32_sys_call_table
 ia32_sys_call_table:
 	.quad sys_restart_syscall
 	.quad sys_exit
@@ -714,9 +725,16 @@ ia32_sys_call_table:
 	.quad compat_sys_get_robust_list
 	.quad sys_splice
 	.quad sys_sync_file_range
-	.quad sys_tee
+	.quad sys_tee			/* 315 */
 	.quad compat_sys_vmsplice
 	.quad compat_sys_move_pages
 	.quad sys_getcpu
 	.quad sys_epoll_pwait
+	.quad stub32_compat_async_exec	/* 320 */
+	.quad sys_async_wait
+	.quad sys_umem_add
+	.quad stub32_compat_async_thread
+	.quad sys_threadlet_on
+	.quad sys_threadlet_off		/* 325 */
+.globl ia32_syscall_end
 ia32_syscall_end:		
Index: linux/arch/x86_64/kernel/entry.S
===================================================================
--- linux.orig/arch/x86_64/kernel/entry.S
+++ linux/arch/x86_64/kernel/entry.S
@@ -410,6 +410,14 @@ END(\label)
 	PTREGSCALL stub_rt_sigsuspend, sys_rt_sigsuspend, %rdx
 	PTREGSCALL stub_sigaltstack, sys_sigaltstack, %rdx
 	PTREGSCALL stub_iopl, sys_iopl, %rsi
+	/*
+	 * sys_async_thread() and sys_async_exec() both take 2 parameters,
+	 * none of which is ptregs - but the syscalls rely on being able to
+	 * modify ptregs. So we put ptregs into the 3rd parameter - so it's
+	 * unused and it also does not mess up the first 2 parameters:
+	 */
+	PTREGSCALL stub_async_thread, sys_async_thread, %rdx
+	PTREGSCALL stub_async_exec, sys_async_exec, %rdx
 
 ENTRY(ptregscall_common)
 	popq %r11
@@ -430,7 +438,7 @@ ENTRY(ptregscall_common)
 	ret
 	CFI_ENDPROC
 END(ptregscall_common)
-	
+
 ENTRY(stub_execve)
 	CFI_STARTPROC
 	popq %r11
@@ -990,6 +998,68 @@ child_rip:
 ENDPROC(child_rip)
 
 /*
+ * Create an async kernel thread.
+ *
+ * C extern interface:
+ *	extern long create_async_thread(int (*fn)(void *), void * arg, unsigned long flags)
+ *
+ * asm input arguments:
+ *	rdi: fn, rsi: arg, rdx: flags
+ */
+ENTRY(create_async_thread)
+	CFI_STARTPROC
+	FAKE_STACK_FRAME $async_child_rip
+	SAVE_ALL
+
+	# rdi: flags, rsi: usp, rdx: will be &pt_regs
+	movq %rdx,%rdi
+	movq $-1, %rsi
+	movq %rsp, %rdx
+
+	xorl %r8d,%r8d
+	xorl %r9d,%r9d
+
+	# clone now
+	call do_fork
+	movq %rax,RAX(%rsp)
+	xorl %edi,%edi
+
+	/*
+	 * It isn't worth to check for reschedule here,
+	 * so internally to the x86_64 port you can rely on kernel_thread()
+	 * not to reschedule the child before returning, this avoids the need
+	 * of hacks for example to fork off the per-CPU idle tasks.
+         * [Hopefully no generic code relies on the reschedule -AK]
+	 */
+	RESTORE_ALL
+	UNFAKE_STACK_FRAME
+	ret
+	CFI_ENDPROC
+ENDPROC(async_kernel_thread)
+
+async_child_rip:
+	CFI_STARTPROC
+
+	movq %rdi, %rax
+	movq %rsi, %rdi
+	call *%rax
+
+	/*
+	 * Fix up the PDA - we might return with sysexit:
+	 */
+	RESTORE_TOP_OF_STACK %r11
+
+	/*
+	 * return to user-space:
+	 */
+	movq %rax, RAX(%rsp)
+	RESTORE_REST
+	jmp int_ret_from_sys_call
+
+	CFI_ENDPROC
+ENDPROC(async_child_rip)
+
+/*
  * execve(). This function needs to use IRET, not SYSRET, to set up all state properly.
  *
  * C extern interface:
Index: linux/arch/x86_64/kernel/process.c
===================================================================
--- linux.orig/arch/x86_64/kernel/process.c
+++ linux/arch/x86_64/kernel/process.c
@@ -418,6 +418,17 @@ void release_thread(struct task_struct *
 	}
 }
 
+/*
+ * Move user-space context from one kernel thread to another.
+ * Callers must make sure that neither task is running user context
+ * at the moment:
+ */
+void
+move_user_context(struct task_struct *new_task, struct task_struct *old_task)
+{
+	*task_pt_regs(new_task) = *task_pt_regs(old_task);
+}
+
 static inline void set_32bit_tls(struct task_struct *t, int tls, u32 addr)
 {
 	struct user_desc ud = { 
Index: linux/include/asm-x86_64/processor.h
===================================================================
--- linux.orig/include/asm-x86_64/processor.h
+++ linux/include/asm-x86_64/processor.h
@@ -322,6 +322,11 @@ extern void prepare_to_copy(struct task_
 extern long kernel_thread(int (*fn)(void *), void * arg, unsigned long flags);
 
 /*
+ * create an async thread:
+ */
+extern long create_async_thread(long (*fn)(void *), void * arg, unsigned long flags);
+
+/*
  * Return saved PC of a blocked thread.
  * What is this good for? it will be always the scheduler or ret_from_fork.
  */
@@ -332,6 +337,17 @@ extern unsigned long get_wchan(struct ta
 #define KSTK_EIP(tsk) (task_pt_regs(tsk)->rip)
 #define KSTK_ESP(tsk) -1 /* sorry. doesn't work for syscall. */
 
+/*
+ * Register access methods for async syscall support.
+ *
+ * Note, task_stack_reg() must not be an lvalue, hence this macro:
+ */
+#define task_stack_reg(t)			\
+		({ unsigned long __rsp = task_pt_regs(t)->rsp; __rsp; })
+#define set_task_stack_reg(t, new_stack)	\
+		do { task_pt_regs(t)->rsp = (new_stack); } while (0)
+#define task_ip_reg(t)				task_pt_regs(t)->rip
+#define task_ret_reg(t)			task_pt_regs(t)->rax
 
 struct microcode_header {
 	unsigned int hdrver;
Index: linux/include/asm-x86_64/system.h
===================================================================
--- linux.orig/include/asm-x86_64/system.h
+++ linux/include/asm-x86_64/system.h
@@ -20,6 +20,8 @@
 #define __EXTRA_CLOBBER  \
 	,"rcx","rbx","rdx","r8","r9","r10","r11","r12","r13","r14","r15"
 
+struct task_struct;
+
 /* Save restore flags to clear handle leaking NT */
 #define switch_to(prev,next,last) \
 	asm volatile(SAVE_CONTEXT						    \
@@ -42,7 +44,15 @@
 		       [thread_info] "i" (offsetof(struct task_struct, thread_info)), \
 		       [pda_pcurrent] "i" (offsetof(struct x8664_pda, pcurrent))   \
 		     : "memory", "cc" __EXTRA_CLOBBER)
-    
+
+
+/*
+ * Move user-space context from one kernel thread to another.
+ * This includes registers and FPU state for now:
+ */
+extern void
+move_user_context(struct task_struct *new_task, struct task_struct *old_task);
+
 extern void load_gs_index(unsigned); 
 
 /*
Index: linux/include/asm-x86_64/unistd.h
===================================================================
--- linux.orig/include/asm-x86_64/unistd.h
+++ linux/include/asm-x86_64/unistd.h
@@ -619,8 +619,21 @@ __SYSCALL(__NR_sync_file_range, sys_sync
 __SYSCALL(__NR_vmsplice, sys_vmsplice)
 #define __NR_move_pages		279
 __SYSCALL(__NR_move_pages, sys_move_pages)
+#define __NR_async_exec		280
+__SYSCALL(__NR_async_exec, stub_async_exec)
+#define __NR_async_wait		281
+__SYSCALL(__NR_async_wait, sys_async_wait)
+#define __NR_umem_add		282
+__SYSCALL(__NR_umem_add, sys_umem_add)
+#define __NR_async_thread	283
+__SYSCALL(__NR_async_thread, stub_async_thread)
+#define __NR_threadlet_on	284
+__SYSCALL(__NR_threadlet_on, sys_threadlet_on)
+#define __NR_threadlet_off	285
+__SYSCALL(__NR_threadlet_off, sys_threadlet_off)
 
-#define __NR_syscall_max __NR_move_pages
+#define __NR_syscall_max	__NR_threadlet_off
+#define NR_syscalls		__NR_syscall_max
 
 #ifndef __NO_STUBS
 #define __ARCH_WANT_OLD_READDIR
@@ -654,6 +667,20 @@ __SYSCALL(__NR_move_pages, sys_move_page
 #include <linux/types.h>
 #include <asm/ptrace.h>
 
+typedef asmlinkage long (*syscall_fn_t)(long, long, long, long, long, long);
+
+extern syscall_fn_t sys_call_table[NR_syscalls];
+
+#ifdef CONFIG_COMPAT
+
+extern syscall_fn_t compat_sys_call_table[];
+extern syscall_fn_t ia32_syscall_end;
+extern syscall_fn_t ia32_sys_call_table;
+
+#define compat_NR_syscalls (&ia32_syscall_end - compat_sys_call_table)
+
+#endif
+
 asmlinkage long sys_iopl(unsigned int level, struct pt_regs *regs);
 asmlinkage long sys_ioperm(unsigned long from, unsigned long num, int turn_on);
 struct sigaction;
