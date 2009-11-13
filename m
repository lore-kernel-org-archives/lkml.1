Return-Path: <linux-kernel-owner+w=401wt.eu-S1757423AbZKMTzJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757423AbZKMTzJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 14:55:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757385AbZKMTyz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 14:54:55 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:45752 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757296AbZKMTyt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 14:54:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=catu9w3T1KcButtOCNLC7fpG/+bwyylBLw//XEe4kHsLMkrOSShIeznaKh6ZI+N5SV
         j2RaMWCzdoMLmAatWbEMfUwGf24zfcLCHqtDHtn84UkljjwRJwp9pYWo5mJDRXM7Mfje
         KsrbbrXmEcD4QC3l/lMfyPZxoNQ2qZOp3vqNE=
From: Brian Gerst <brgerst@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] x86: Merge 32/64-bit kernel_thread
Date: Fri, 13 Nov 2009 14:54:56 -0500
Message-Id: <1258142098-3832-3-git-send-email-brgerst@gmail.com>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1258142098-3832-1-git-send-email-brgerst@gmail.com>
References: <1258142098-3832-1-git-send-email-brgerst@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Brian Gerst <brgerst@gmail.com>
---
 arch/x86/kernel/entry_32.S   |    6 +++---
 arch/x86/kernel/process.c    |   34 ++++++++++++++++++++++++++++++++++
 arch/x86/kernel/process_32.c |   33 ---------------------------------
 arch/x86/kernel/process_64.c |   29 -----------------------------
 4 files changed, 37 insertions(+), 65 deletions(-)

diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
index c097e7d..2778ae3 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -984,10 +984,10 @@ END(spurious_interrupt_bug)
 ENTRY(kernel_thread_helper)
 	pushl $0		# fake return address for unwinder
 	CFI_STARTPROC
-	movl %edx,%eax
-	push %edx
+	movl %edi,%eax
+	push %edi
 	CFI_ADJUST_CFA_OFFSET 4
-	call *%ebx
+	call *%esi
 	push %eax
 	CFI_ADJUST_CFA_OFFSET 4
 	call do_exit
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 5284cd2..71a22c9 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -247,6 +247,40 @@ int sys_vfork(struct pt_regs *regs)
 		       NULL, NULL);
 }
 
+extern void kernel_thread_helper(void);
+
+/*
+ * Create a kernel thread
+ */
+int kernel_thread(int (*fn)(void *), void *arg, unsigned long flags)
+{
+	struct pt_regs regs;
+	unsigned long newsp;
+
+	memset(&regs, 0, sizeof(regs));
+
+	regs.si = (unsigned long) fn;
+	regs.di = (unsigned long) arg;
+
+#ifdef CONFIG_X86_32
+	regs.ds = __USER_DS;
+	regs.es = __USER_DS;
+	regs.fs = __KERNEL_PERCPU;
+	regs.gs = __KERNEL_STACK_CANARY;
+	newsp = 0;
+#else
+	newsp = ~0UL;
+#endif
+
+	regs.orig_ax = -1;
+	regs.ip = (unsigned long) kernel_thread_helper;
+	regs.cs = __KERNEL_CS | get_kernel_rpl();
+	regs.flags = X86_EFLAGS_IF | 2;
+
+	/* Ok, create the new process.. */
+	return do_fork(flags | CLONE_VM | CLONE_UNTRACED, newsp, &regs, 0, NULL, NULL);
+}
+EXPORT_SYMBOL(kernel_thread);
 
 /*
  * Idle related variables and functions
diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index 4cf7956..8afe621 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -191,39 +191,6 @@ void show_regs(struct pt_regs *regs)
 	show_trace(NULL, regs, &regs->sp, regs->bp);
 }
 
-/*
- * This gets run with %bx containing the
- * function to call, and %dx containing
- * the "args".
- */
-extern void kernel_thread_helper(void);
-
-/*
- * Create a kernel thread
- */
-int kernel_thread(int (*fn)(void *), void *arg, unsigned long flags)
-{
-	struct pt_regs regs;
-
-	memset(&regs, 0, sizeof(regs));
-
-	regs.bx = (unsigned long) fn;
-	regs.dx = (unsigned long) arg;
-
-	regs.ds = __USER_DS;
-	regs.es = __USER_DS;
-	regs.fs = __KERNEL_PERCPU;
-	regs.gs = __KERNEL_STACK_CANARY;
-	regs.orig_ax = -1;
-	regs.ip = (unsigned long) kernel_thread_helper;
-	regs.cs = __KERNEL_CS | get_kernel_rpl();
-	regs.flags = X86_EFLAGS_IF | X86_EFLAGS_SF | X86_EFLAGS_PF | 0x2;
-
-	/* Ok, create the new process.. */
-	return do_fork(flags | CLONE_VM | CLONE_UNTRACED, 0, &regs, 0, NULL, NULL);
-}
-EXPORT_SYMBOL(kernel_thread);
-
 void release_thread(struct task_struct *dead_task)
 {
 	BUG_ON(dead_task->mm);
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index cf1d59d..8151a82 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -229,35 +229,6 @@ void show_regs(struct pt_regs *regs)
 	show_trace(NULL, regs, (void *)(regs + 1), regs->bp);
 }
 
-/*
- * This gets run with %si containing the
- * function to call, and %di containing
- * the "args".
- */
-extern void kernel_thread_helper(void);
-
-/*
- * Create a kernel thread
- */
-int kernel_thread(int (*fn)(void *), void *arg, unsigned long flags)
-{
-	struct pt_regs regs;
-
-	memset(&regs, 0, sizeof(regs));
-
-	regs.si = (unsigned long) fn;
-	regs.di = (unsigned long) arg;
-
-	regs.orig_ax = -1;
-	regs.ip = (unsigned long) kernel_thread_helper;
-	regs.cs = __KERNEL_CS;
-	regs.flags = X86_EFLAGS_IF;
-
-	/* Ok, create the new process.. */
-	return do_fork(flags | CLONE_VM | CLONE_UNTRACED, ~0UL, &regs, 0, NULL, NULL);
-}
-EXPORT_SYMBOL(kernel_thread);
-
 void release_thread(struct task_struct *dead_task)
 {
 	if (dead_task->mm) {
-- 
1.6.2.5

