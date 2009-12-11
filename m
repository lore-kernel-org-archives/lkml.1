Return-Path: <linux-kernel-owner+w=401wt.eu-S1762089AbZLKAp6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762089AbZLKAp6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 19:45:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761718AbZLKApz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 19:45:55 -0500
Received: from hera.kernel.org ([140.211.167.34]:44566 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761765AbZLKApt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 19:45:49 -0500
Date: Fri, 11 Dec 2009 00:45:35 GMT
From: tip-bot for Brian Gerst <brgerst@gmail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       brgerst@gmail.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       brgerst@gmail.com, tglx@linutronix.de
In-Reply-To: <1260380084-3707-2-git-send-email-brgerst@gmail.com>
References: <1260380084-3707-2-git-send-email-brgerst@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asm] x86, 64-bit: Move kernel_thread to C
Message-ID: <tip-3bd95dfb182969dc6d2a317c150e0df7107608d3@git.kernel.org>
Git-Commit-ID: 3bd95dfb182969dc6d2a317c150e0df7107608d3
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3bd95dfb182969dc6d2a317c150e0df7107608d3
Gitweb:     http://git.kernel.org/tip/3bd95dfb182969dc6d2a317c150e0df7107608d3
Author:     Brian Gerst <brgerst@gmail.com>
AuthorDate: Wed, 9 Dec 2009 12:34:40 -0500
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Thu, 10 Dec 2009 15:55:26 -0800

x86, 64-bit: Move kernel_thread to C

Prepare for merging with 32-bit.

Signed-off-by: Brian Gerst <brgerst@gmail.com>
LKML-Reference: <1260380084-3707-2-git-send-email-brgerst@gmail.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/kernel/entry_64.S       |   49 ++-----------------------------------
 arch/x86/kernel/process_64.c     |   31 ++++++++++++++++++++++-
 arch/x86/kernel/x8664_ksyms_64.c |    2 -
 3 files changed, 32 insertions(+), 50 deletions(-)

diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 63bca79..73d9b2c 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -1166,63 +1166,20 @@ bad_gs:
 	jmp  2b
 	.previous
 
-/*
- * Create a kernel thread.
- *
- * C extern interface:
- *	extern long kernel_thread(int (*fn)(void *), void * arg, unsigned long flags)
- *
- * asm input arguments:
- *	rdi: fn, rsi: arg, rdx: flags
- */
-ENTRY(kernel_thread)
-	CFI_STARTPROC
-	FAKE_STACK_FRAME $child_rip
-	SAVE_ALL
-
-	# rdi: flags, rsi: usp, rdx: will be &pt_regs
-	movq %rdx,%rdi
-	orq  kernel_thread_flags(%rip),%rdi
-	movq $-1, %rsi
-	movq %rsp, %rdx
-
-	xorl %r8d,%r8d
-	xorl %r9d,%r9d
-
-	# clone now
-	call do_fork
-	movq %rax,RAX(%rsp)
-	xorl %edi,%edi
-
-	/*
-	 * It isn't worth to check for reschedule here,
-	 * so internally to the x86_64 port you can rely on kernel_thread()
-	 * not to reschedule the child before returning, this avoids the need
-	 * of hacks for example to fork off the per-CPU idle tasks.
-	 * [Hopefully no generic code relies on the reschedule -AK]
-	 */
-	RESTORE_ALL
-	UNFAKE_STACK_FRAME
-	ret
-	CFI_ENDPROC
-END(kernel_thread)
-
-ENTRY(child_rip)
+ENTRY(kernel_thread_helper)
 	pushq $0		# fake return address
 	CFI_STARTPROC
 	/*
 	 * Here we are in the child and the registers are set as they were
 	 * at kernel_thread() invocation in the parent.
 	 */
-	movq %rdi, %rax
-	movq %rsi, %rdi
-	call *%rax
+	call *%rsi
 	# exit
 	mov %eax, %edi
 	call do_exit
 	ud2			# padding for call trace
 	CFI_ENDPROC
-END(child_rip)
+END(kernel_thread_helper)
 
 /*
  * execve(). This function needs to use IRET, not SYSRET, to set up all state properly.
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index 83019f9..92484c2 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -59,8 +59,6 @@ asmlinkage extern void ret_from_fork(void);
 DEFINE_PER_CPU(unsigned long, old_rsp);
 static DEFINE_PER_CPU(unsigned char, is_idle);
 
-unsigned long kernel_thread_flags = CLONE_VM | CLONE_UNTRACED;
-
 static ATOMIC_NOTIFIER_HEAD(idle_notifier);
 
 void idle_notifier_register(struct notifier_block *n)
@@ -231,6 +229,35 @@ void show_regs(struct pt_regs *regs)
 	show_trace(NULL, regs, (void *)(regs + 1), regs->bp);
 }
 
+/*
+ * This gets run with %si containing the
+ * function to call, and %di containing
+ * the "args".
+ */
+extern void kernel_thread_helper(void);
+
+/*
+ * Create a kernel thread
+ */
+int kernel_thread(int (*fn)(void *), void *arg, unsigned long flags)
+{
+	struct pt_regs regs;
+
+	memset(&regs, 0, sizeof(regs));
+
+	regs.si = (unsigned long) fn;
+	regs.di = (unsigned long) arg;
+
+	regs.orig_ax = -1;
+	regs.ip = (unsigned long) kernel_thread_helper;
+	regs.cs = __KERNEL_CS;
+	regs.flags = X86_EFLAGS_IF;
+
+	/* Ok, create the new process.. */
+	return do_fork(flags | CLONE_VM | CLONE_UNTRACED, ~0UL, &regs, 0, NULL, NULL);
+}
+EXPORT_SYMBOL(kernel_thread);
+
 void release_thread(struct task_struct *dead_task)
 {
 	if (dead_task->mm) {
diff --git a/arch/x86/kernel/x8664_ksyms_64.c b/arch/x86/kernel/x8664_ksyms_64.c
index a102976..9fafaf8 100644
--- a/arch/x86/kernel/x8664_ksyms_64.c
+++ b/arch/x86/kernel/x8664_ksyms_64.c
@@ -17,8 +17,6 @@
 EXPORT_SYMBOL(mcount);
 #endif
 
-EXPORT_SYMBOL(kernel_thread);
-
 EXPORT_SYMBOL(__get_user_1);
 EXPORT_SYMBOL(__get_user_2);
 EXPORT_SYMBOL(__get_user_4);
