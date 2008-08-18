Return-Path: <linux-kernel-owner+w=401wt.eu-S1756450AbYHRSlI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756450AbYHRSlI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 14:41:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753781AbYHRSko
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 14:40:44 -0400
Received: from mga03.intel.com ([143.182.124.21]:2096 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753427AbYHRSkn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 14:40:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,229,1217833200"; 
   d="scan'208";a="34890833"
Message-Id: <20080818183605.719267000@linux-os.sc.intel.com>
User-Agent: quilt/0.46-1
Date: Mon, 18 Aug 2008 11:35:46 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: greg@kroah.com, mingo@elte.hu
Cc: stable@kernel.org, linux-kernel@vger.kernel.org,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: [stable 1/2] x86-64: Clean up save/restore_i387() usage
Content-Disposition: inline; filename=fpu_code_cleanup.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Upstream commit: b30f3ae50cd03ef2ff433a5030fbf88dd8323528]

Suresh Siddha wants to fix a possible FPU leakage in error conditions,
but the fact that save/restore_i387() are inlines in a header file makes
that harder to do than necessary.  So start off with an obvious cleanup.

This just moves the x86-64 version of save/restore_i387() out of the
header file, and moves it to the only file that it is actually used in:
arch/x86/kernel/signal_64.c.  So exposing it in a header file was wrong
to begin with.

[ Side note: I'd like to fix up some of the games we play with the
  32-bit version of these functions too, but that's a separate
  matter.  The 32-bit versions are shared - under different names
  at that! - by both the native x86-32 code and the x86-64 32-bit
  compatibility code ]

Acked-by: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: <stable@kernel.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
---

Index: linux-2.6.26.2/arch/x86/kernel/signal_64.c
===================================================================
--- linux-2.6.26.2.orig/arch/x86/kernel/signal_64.c	2008-08-06 09:19:01.000000000 -0700
+++ linux-2.6.26.2/arch/x86/kernel/signal_64.c	2008-08-18 11:16:43.000000000 -0700
@@ -53,6 +53,59 @@
 	return do_sigaltstack(uss, uoss, regs->sp);
 }
 
+/*
+ * Signal frame handlers.
+ */
+
+static inline int save_i387(struct _fpstate __user *buf)
+{
+	struct task_struct *tsk = current;
+	int err = 0;
+
+	BUILD_BUG_ON(sizeof(struct user_i387_struct) !=
+			sizeof(tsk->thread.xstate->fxsave));
+
+	if ((unsigned long)buf % 16)
+		printk("save_i387: bad fpstate %p\n", buf);
+
+	if (!used_math())
+		return 0;
+	clear_used_math(); /* trigger finit */
+	if (task_thread_info(tsk)->status & TS_USEDFPU) {
+		err = save_i387_checking((struct i387_fxsave_struct __user *)
+					 buf);
+		if (err)
+			return err;
+		task_thread_info(tsk)->status &= ~TS_USEDFPU;
+		stts();
+	} else {
+		if (__copy_to_user(buf, &tsk->thread.xstate->fxsave,
+				   sizeof(struct i387_fxsave_struct)))
+			return -1;
+	}
+	return 1;
+}
+
+/*
+ * This restores directly out of user space. Exceptions are handled.
+ */
+static inline int restore_i387(struct _fpstate __user *buf)
+{
+	struct task_struct *tsk = current;
+	int err;
+
+	if (!used_math()) {
+		err = init_fpu(tsk);
+		if (err)
+			return err;
+	}
+
+	if (!(task_thread_info(current)->status & TS_USEDFPU)) {
+		clts();
+		task_thread_info(current)->status |= TS_USEDFPU;
+	}
+	return restore_fpu_checking((__force struct i387_fxsave_struct *)buf);
+}
 
 /*
  * Do a signal return; undo the signal stack.
Index: linux-2.6.26.2/include/asm-x86/i387.h
===================================================================
--- linux-2.6.26.2.orig/include/asm-x86/i387.h	2008-08-06 09:19:01.000000000 -0700
+++ linux-2.6.26.2/include/asm-x86/i387.h	2008-08-18 11:16:43.000000000 -0700
@@ -137,60 +137,6 @@
 	task_thread_info(tsk)->status &= ~TS_USEDFPU;
 }
 
-/*
- * Signal frame handlers.
- */
-
-static inline int save_i387(struct _fpstate __user *buf)
-{
-	struct task_struct *tsk = current;
-	int err = 0;
-
-	BUILD_BUG_ON(sizeof(struct user_i387_struct) !=
-			sizeof(tsk->thread.xstate->fxsave));
-
-	if ((unsigned long)buf % 16)
-		printk("save_i387: bad fpstate %p\n", buf);
-
-	if (!used_math())
-		return 0;
-	clear_used_math(); /* trigger finit */
-	if (task_thread_info(tsk)->status & TS_USEDFPU) {
-		err = save_i387_checking((struct i387_fxsave_struct __user *)
-					 buf);
-		if (err)
-			return err;
-		task_thread_info(tsk)->status &= ~TS_USEDFPU;
-		stts();
-	} else {
-		if (__copy_to_user(buf, &tsk->thread.xstate->fxsave,
-				   sizeof(struct i387_fxsave_struct)))
-			return -1;
-	}
-	return 1;
-}
-
-/*
- * This restores directly out of user space. Exceptions are handled.
- */
-static inline int restore_i387(struct _fpstate __user *buf)
-{
-	struct task_struct *tsk = current;
-	int err;
-
-	if (!used_math()) {
-		err = init_fpu(tsk);
-		if (err)
-			return err;
-	}
-
-	if (!(task_thread_info(current)->status & TS_USEDFPU)) {
-		clts();
-		task_thread_info(current)->status |= TS_USEDFPU;
-	}
-	return restore_fpu_checking((__force struct i387_fxsave_struct *)buf);
-}
-
 #else  /* CONFIG_X86_32 */
 
 extern void finit(void);

-- 

