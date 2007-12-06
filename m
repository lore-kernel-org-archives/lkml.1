Return-Path: <linux-kernel-owner+w=401wt.eu-S1756121AbXLFXWW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756121AbXLFXWW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 18:22:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752974AbXLFXU2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 18:20:28 -0500
Received: from tetsuo.zabbo.net ([207.173.201.20]:50777 "EHLO tetsuo.zabbo.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753287AbXLFXUW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 18:20:22 -0500
From: Zach Brown <zach.brown@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Ulrich Drepper <drepper@redhat.com>,
       Arjan van de Ven <arjan@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Dan Williams <dan.j.williams@gmail.com>, Jeff Moyer <jmoyer@redhat.com>,
       Simon Holm Thogersen <odie@cs.aau.dk>, suresh.b.siddha@intel.com
Subject: [PATCH 6/6] syslets: add both 32bit and 64bit x86 syslet support
Date: Thu,  6 Dec 2007 15:20:19 -0800
Message-Id: <11969832192752-git-send-email-zach.brown@oracle.com>
X-Mailer: git-send-email 1.5.2.2
In-Reply-To: <11969832192130-git-send-email-zach.brown@oracle.com>
References: <1196983219534-git-send-email-zach.brown@oracle.com>
 <11969832193635-git-send-email-zach.brown@oracle.com>
 <1196983219225-git-send-email-zach.brown@oracle.com>
 <11969832192868-git-send-email-zach.brown@oracle.com>
 <1196983219370-git-send-email-zach.brown@oracle.com>
 <11969832192130-git-send-email-zach.brown@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds the architecture-specific routines needed by syslets for x86.

The syslet thread creation routines create a new thread which executes
a kernel function and then returns to userspace instead of exiting.

move_user_context() and set_user_frame() let the scheduler modify a child
thread so that it returns to userspace at the same place that a blocking
system call would have when it finished.  This currently performs a very
expensive copy of the fpu state.  Intel is working on a more robust patch
which allocates the i387 state off of thread_struct.  When that is ready
this can just juggle pointers to transfer the fpu state.

The syslets infrastructure needs to work with ptregs for the task which
is in sys_indirect().  So we add a PTREGSCALL stub around sys_indirect()
in x86_64.

Finally, we wire up sys_syslet_ring_wait().

Signed-off-by: Zach Brown <zach.brown@oracle.com>

diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
index dc7f938..66a121d 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -1025,6 +1025,30 @@ ENTRY(kernel_thread_helper)
 	CFI_ENDPROC
 ENDPROC(kernel_thread_helper)
 
+ENTRY(syslet_thread_helper)
+	CFI_STARTPROC
+	/*
+	 * Allocate space on the stack for pt-regs.
+	 * sizeof(struct pt_regs) == 64, and we've got 8 bytes on the
+	 * kernel stack already:
+	 */
+	subl $64-8, %esp
+	CFI_ADJUST_CFA_OFFSET 64-8
+	movl %edx,%eax
+	push %edx
+	CFI_ADJUST_CFA_OFFSET 4
+	call *%ebx
+	addl $4, %esp
+	CFI_ADJUST_CFA_OFFSET -4
+
+	movl %eax, PT_EAX(%esp)
+
+	GET_THREAD_INFO(%ebp)
+
+	jmp syscall_exit
+	CFI_ENDPROC
+ENDPROC(syslet_thread_helper)
+
 #ifdef CONFIG_XEN
 ENTRY(xen_hypervisor_callback)
 	CFI_STARTPROC
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 3a058bb..08e34f6 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -412,6 +412,7 @@ END(\label)
 	PTREGSCALL stub_rt_sigsuspend, sys_rt_sigsuspend, %rdx
 	PTREGSCALL stub_sigaltstack, sys_sigaltstack, %rdx
 	PTREGSCALL stub_iopl, sys_iopl, %rsi
+	PTREGSCALL stub_indirect, sys_indirect, %r8
 
 ENTRY(ptregscall_common)
 	popq %r11
@@ -994,6 +995,71 @@ child_rip:
 ENDPROC(child_rip)
 
 /*
+ * Create a syslet kernel thread.  This differs from a thread created with
+ * kernel_thread() in that it returns to userspace after it finishes executing
+ * its given kernel function.
+ *
+ * C extern interface:
+ *	extern long create_syslet_thread(int (*fn)(void *),
+ *					 void * arg, unsigned long flags)
+ *
+ * asm input arguments:
+ *	rdi: fn, rsi: arg, rdx: flags
+ */
+ENTRY(create_syslet_thread)
+	CFI_STARTPROC
+	FAKE_STACK_FRAME $syslet_child_rip
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
+ENDPROC(syslet_kernel_thread)
+
+syslet_child_rip:
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
+ENDPROC(syslet_child_rip)
+
+/*
  * execve(). This function needs to use IRET, not SYSRET, to set up all state properly.
  *
  * C extern interface:
diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index 7b89958..7bf2836 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -394,6 +394,39 @@ int kernel_thread(int (*fn)(void *), void * arg, unsigned long flags)
 EXPORT_SYMBOL(kernel_thread);
 
 /*
+ * This gets run with %ebx containing the
+ * function to call, and %edx containing
+ * the "args".
+ */
+void syslet_thread_helper(void);
+
+/*
+ * Create a syslet kernel thread.  This differs from a thread created with
+ * kernel_thread() in that it returns to userspace after it finishes executing
+ * its given kernel function.
+ */
+int create_syslet_thread(long (*fn)(void *), void *arg, unsigned long flags)
+{
+	struct pt_regs regs;
+
+	memset(&regs, 0, sizeof(regs));
+
+	regs.ebx = (unsigned long)fn;
+	regs.edx = (unsigned long)arg;
+
+	regs.xds = __USER_DS;
+	regs.xes = __USER_DS;
+	regs.xfs = __KERNEL_PERCPU;
+	regs.orig_eax = -1;
+	regs.eip = (unsigned long)syslet_thread_helper;
+	regs.xcs = __KERNEL_CS | get_kernel_rpl();
+	regs.eflags = X86_EFLAGS_IF | X86_EFLAGS_SF | X86_EFLAGS_PF | 0x2;
+
+	/* Ok, create the new task.. */
+	return do_fork(flags, 0, &regs, 0, NULL, NULL);
+}
+
+/*
  * Free current thread data structures etc..
  */
 void exit_thread(void)
@@ -852,6 +885,32 @@ unsigned long get_wchan(struct task_struct *p)
 }
 
 /*
+ * This expensive hack will go away once thread->i387 is allocated instead of
+ * embedded in task_struct.  Intel is working on it.
+ */
+static union i387_union i387_tmp[NR_CPUS] __cacheline_aligned_in_smp;
+
+/*
+ * Move user-space context from one kernel thread to another.
+ * This includes registers and FPU state. Callers must make
+ * sure that neither task is running user context at the moment:
+ */
+void move_user_context(struct task_struct *dest, struct task_struct *src)
+{
+	struct pt_regs *old_regs = task_pt_regs(src);
+	struct pt_regs *new_regs = task_pt_regs(dest);
+	union i387_union *tmp;
+
+	*new_regs = *old_regs;
+
+	tmp = &i387_tmp[get_cpu()];
+	*tmp = dest->thread.i387;
+	dest->thread.i387 = src->thread.i387;
+	src->thread.i387 = *tmp;
+	put_cpu();
+}
+
+/*
  * sys_alloc_thread_area: get a yet unused TLS descriptor index.
  */
 static int get_free_idx(void)
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index 6309b27..9fb050d 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -436,6 +436,16 @@ void release_thread(struct task_struct *dead_task)
 	}
 }
 
+/*
+ * Move user-space context from one kernel thread to another.
+ * Callers must make sure that neither task is running user context
+ * at the moment:
+ */
+void move_user_context(struct task_struct *dest, struct task_struct *src)
+{
+	*task_pt_regs(dest) = *task_pt_regs(src);
+}
+
 static inline void set_32bit_tls(struct task_struct *t, int tls, u32 addr)
 {
 	struct user_desc ud = { 
diff --git a/arch/x86/kernel/syscall_table_32.S b/arch/x86/kernel/syscall_table_32.S
index 92095b2..5a532cf 100644
--- a/arch/x86/kernel/syscall_table_32.S
+++ b/arch/x86/kernel/syscall_table_32.S
@@ -325,3 +325,4 @@ ENTRY(sys_call_table)
 	.long sys_eventfd
 	.long sys_fallocate
 	.long sys_indirect		/* 325 */
+	.long sys_syslet_ring_wait
diff --git a/include/asm-x86/syslet-abi.h b/include/asm-x86/syslet-abi.h
index 14a7182..06e7528 100644
--- a/include/asm-x86/syslet-abi.h
+++ b/include/asm-x86/syslet-abi.h
@@ -1 +1,9 @@
-#include <asm-generic/syslet-abi.h>
+#ifndef __ASM_X86_SYSLET_ABI_H
+#define __ASM_X86_SYSLET_ABI_H
+
+struct syslet_frame {
+	u64 ip;
+	u64 sp;
+};
+
+#endif
diff --git a/include/asm-x86/syslet.h b/include/asm-x86/syslet.h
index 583d810..75e4532 100644
--- a/include/asm-x86/syslet.h
+++ b/include/asm-x86/syslet.h
@@ -1 +1,32 @@
-#include <asm-generic/syslet.h>
+#ifndef __ASM_X86_SYSLET_H
+#define __ASM_X86_SYSLET_H
+
+#include "syslet-abi.h"
+
+/* These are provided by kernel/entry.S and kernel/process.c */
+void move_user_context(struct task_struct *dest, struct task_struct *src);
+int create_syslet_thread(long (*fn)(void *),
+			 void *arg, unsigned long flags);
+
+static inline int syslet_frame_valid(struct syslet_frame *frame)
+{
+	return frame->ip && frame->sp;
+}
+
+#ifdef CONFIG_X86_32
+static inline void set_user_frame(struct task_struct *task,
+				  struct syslet_frame *frame)
+{
+	task_pt_regs(task)->eip = frame->ip;
+	task_pt_regs(task)->esp = frame->sp;
+}
+#else
+static inline void set_user_frame(struct task_struct *task,
+				  struct syslet_frame *frame)
+{
+	task_pt_regs(task)->rip = frame->ip;
+	task_pt_regs(task)->rsp = frame->sp;
+}
+#endif
+
+#endif
diff --git a/include/asm-x86/unistd_32.h b/include/asm-x86/unistd_32.h
index 8ee0b20..0857c4d 100644
--- a/include/asm-x86/unistd_32.h
+++ b/include/asm-x86/unistd_32.h
@@ -331,10 +331,11 @@
 #define __NR_eventfd		323
 #define __NR_fallocate		324
 #define __NR_indirect		325
+#define __NR_syslet_ring_wait	326
 
 #ifdef __KERNEL__
 
-#define NR_syscalls 326
+#define NR_syscalls 327
 
 #define __ARCH_WANT_IPC_PARSE_VERSION
 #define __ARCH_WANT_OLD_READDIR
diff --git a/include/asm-x86/unistd_64.h b/include/asm-x86/unistd_64.h
index 66eab33..e01f5dc 100644
--- a/include/asm-x86/unistd_64.h
+++ b/include/asm-x86/unistd_64.h
@@ -636,7 +636,9 @@ __SYSCALL(__NR_eventfd, sys_eventfd)
 #define __NR_fallocate				285
 __SYSCALL(__NR_fallocate, sys_fallocate)
 #define __NR_indirect				286
-__SYSCALL(__NR_indirect, sys_indirect)
+__SYSCALL(__NR_indirect, stub_indirect)
+#define __NR_syslet_ring_wait			287
+__SYSCALL(__NR_syslet_ring_wait, sys_syslet_ring_wait)
 
 #ifndef __NO_STUBS
 #define __ARCH_WANT_OLD_READDIR
-- 
1.5.2.2

