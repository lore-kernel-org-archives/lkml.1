Return-Path: <linux-kernel-owner+w=401wt.eu-S1754908AbZLIReU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754908AbZLIReU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 12:34:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754707AbZLIReT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 12:34:19 -0500
Received: from mail-yw0-f198.google.com ([209.85.211.198]:47810 "EHLO
	mail-yw0-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751793AbZLIReQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 12:34:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=b7dSDQqxAgcrHSUUIfq/OCyoGMVPilZ5Im6Ym2IPeZWabc2xjE/crcNQmP+9tvBVnn
         2FSkwiiSzOk3nkPpayhbaWDsKwI1n0FM51cDP7f+98MXB9aS8uE2R+3P+JBQ4BhyVAuO
         LexM3jwoXYA7dtiQImpRgI2RCvcLJP/IzohoE=
From: Brian Gerst <brgerst@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/5] x86, 64-bit: Move kernel_thread to C
Date: Wed,  9 Dec 2009 12:34:40 -0500
Message-Id: <1260380084-3707-2-git-send-email-brgerst@gmail.com>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <1260380084-3707-1-git-send-email-brgerst@gmail.com>
References: <1260380084-3707-1-git-send-email-brgerst@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prepare for merging with 32-bit.

Signed-off-by: Brian Gerst <brgerst@gmail.com>
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
index c95c8f4..866b4b4 100644
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
-- 
1.6.5.2

