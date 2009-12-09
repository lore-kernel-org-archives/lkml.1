Return-Path: <linux-kernel-owner+w=401wt.eu-S1756285AbZLIRfB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756285AbZLIRfB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 12:35:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755579AbZLIRe2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 12:34:28 -0500
Received: from mail-yw0-f198.google.com ([209.85.211.198]:47810 "EHLO
	mail-yw0-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754242AbZLIReW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 12:34:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=X3hfXvBDeMBA3yQ0vI8YG9J8RlZ6i48S91aBcpWWnJjy4Rj04ZtiAPRbitJfOsBnkD
         R63czZLkeXreOlFgzfFIVK/JWTnODLetcg/3AKzEvL1pnULmx7wWtAijPLYp1t/eq47t
         +Y9U4ykT8FVZqvYe9rUKTEybtlpcE1OyYMmfg=
From: Brian Gerst <brgerst@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 5/5] x86: Merge kernel_thread()
Date: Wed,  9 Dec 2009 12:34:44 -0500
Message-Id: <1260380084-3707-6-git-send-email-brgerst@gmail.com>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <1260380084-3707-1-git-send-email-brgerst@gmail.com>
References: <1260380084-3707-1-git-send-email-brgerst@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Brian Gerst <brgerst@gmail.com>
---
 arch/x86/kernel/process.c    |   35 +++++++++++++++++++++++++++++++++++
 arch/x86/kernel/process_32.c |   36 ------------------------------------
 arch/x86/kernel/process_64.c |   36 ------------------------------------
 3 files changed, 35 insertions(+), 72 deletions(-)

diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 5e2ba63..ac9ac64 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -234,6 +234,41 @@ int sys_vfork(struct pt_regs *regs)
 		       NULL, NULL);
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
  * Idle related variables and functions
diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index e45aa22..af2bf74 100644
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
index 54c9939..09d3a7b 100644
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
-- 
1.6.5.2

