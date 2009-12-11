Return-Path: <linux-kernel-owner+w=401wt.eu-S1762106AbZLKAq4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762106AbZLKAq4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 19:46:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762079AbZLKAqx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 19:46:53 -0500
Received: from hera.kernel.org ([140.211.167.34]:35798 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933295AbZLKAqs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 19:46:48 -0500
Date: Fri, 11 Dec 2009 00:46:35 GMT
From: tip-bot for Brian Gerst <brgerst@gmail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       brgerst@gmail.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       brgerst@gmail.com, tglx@linutronix.de
In-Reply-To: <1260380084-3707-6-git-send-email-brgerst@gmail.com>
References: <1260380084-3707-6-git-send-email-brgerst@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asm] x86: Merge kernel_thread()
Message-ID: <tip-df59e7bf439918f523ac29e996ec1eebbed60440@git.kernel.org>
Git-Commit-ID: df59e7bf439918f523ac29e996ec1eebbed60440
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  df59e7bf439918f523ac29e996ec1eebbed60440
Gitweb:     http://git.kernel.org/tip/df59e7bf439918f523ac29e996ec1eebbed60440
Author:     Brian Gerst <brgerst@gmail.com>
AuthorDate: Wed, 9 Dec 2009 12:34:44 -0500
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Thu, 10 Dec 2009 16:41:31 -0800

x86: Merge kernel_thread()

Signed-off-by: Brian Gerst <brgerst@gmail.com>
LKML-Reference: <1260380084-3707-6-git-send-email-brgerst@gmail.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/kernel/process.c    |   35 +++++++++++++++++++++++++++++++++++
 arch/x86/kernel/process_32.c |   36 ------------------------------------
 arch/x86/kernel/process_64.c |   36 ------------------------------------
 3 files changed, 35 insertions(+), 72 deletions(-)

diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index f3c1a6b..8705cce 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -243,6 +243,41 @@ sys_clone(unsigned long clone_flags, unsigned long newsp,
 	return do_fork(clone_flags, newsp, regs, 0, parent_tid, child_tid);
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
+#ifdef CONFIG_X86_32
+	regs.ds = __USER_DS;
+	regs.es = __USER_DS;
+	regs.fs = __KERNEL_PERCPU;
+	regs.gs = __KERNEL_STACK_CANARY;
+#endif
+
+	regs.orig_ax = -1;
+	regs.ip = (unsigned long) kernel_thread_helper;
+	regs.cs = __KERNEL_CS | get_kernel_rpl();
+	regs.flags = X86_EFLAGS_IF | 0x2;
+
+	/* Ok, create the new process.. */
+	return do_fork(flags | CLONE_VM | CLONE_UNTRACED, 0, &regs, 0, NULL, NULL);
+}
+EXPORT_SYMBOL(kernel_thread);
 
 /*
  * sys_execve() executes a new program.
diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index f2e8b05..ccf2342 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -192,42 +192,6 @@ void show_regs(struct pt_regs *regs)
 	show_trace(NULL, regs, &regs->sp, regs->bp);
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
-#ifdef CONFIG_X86_32
-	regs.ds = __USER_DS;
-	regs.es = __USER_DS;
-	regs.fs = __KERNEL_PERCPU;
-	regs.gs = __KERNEL_STACK_CANARY;
-#endif
-
-	regs.orig_ax = -1;
-	regs.ip = (unsigned long) kernel_thread_helper;
-	regs.cs = __KERNEL_CS | get_kernel_rpl();
-	regs.flags = X86_EFLAGS_IF | 0x2;
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
index d49a909..1a362c5 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -229,42 +229,6 @@ void show_regs(struct pt_regs *regs)
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
-#ifdef CONFIG_X86_32
-	regs.ds = __USER_DS;
-	regs.es = __USER_DS;
-	regs.fs = __KERNEL_PERCPU;
-	regs.gs = __KERNEL_STACK_CANARY;
-#endif
-
-	regs.orig_ax = -1;
-	regs.ip = (unsigned long) kernel_thread_helper;
-	regs.cs = __KERNEL_CS | get_kernel_rpl();
-	regs.flags = X86_EFLAGS_IF | 0x2;
-
-	/* Ok, create the new process.. */
-	return do_fork(flags | CLONE_VM | CLONE_UNTRACED, 0, &regs, 0, NULL, NULL);
-}
-EXPORT_SYMBOL(kernel_thread);
-
 void release_thread(struct task_struct *dead_task)
 {
 	if (dead_task->mm) {
