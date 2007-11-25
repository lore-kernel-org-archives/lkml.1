Return-Path: <linux-kernel-owner+w=401wt.eu-S1757258AbXKYVz7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757258AbXKYVz7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2007 16:55:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755556AbXKYVzv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Nov 2007 16:55:51 -0500
Received: from mx1.redhat.com ([66.187.233.31]:53980 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755037AbXKYVzu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2007 16:55:50 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
X-Fcc: ~/Mail/linus
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 01/27] ptrace: arch_has_single_step
X-Shopping-List: (1) Mighty baskets
   (2) Noxious hobnobbing prescriptions
   (3) Constant selector commissions
   (4) Righteous nutrition
Message-Id: <20071125215507.4B89226F8C5@magilla.localdomain>
Date: Sun, 25 Nov 2007 13:55:07 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This defines the new macro arch_has_single_step() in linux/ptrace.h, a
default for when asm/ptrace.h does not define it.  It declares the new
user_enable_single_step and user_disable_single_step functions.
This is not used yet, but paves the way to harmonize on this interface
for the arch-specific calls on all machines.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 include/linux/ptrace.h |   46 ++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 46 insertions(+), 0 deletions(-)

diff --git a/include/linux/ptrace.h b/include/linux/ptrace.h
index ae8146a..a6effc8 100644
--- a/include/linux/ptrace.h
+++ b/include/linux/ptrace.h
@@ -128,6 +128,52 @@ int generic_ptrace_pokedata(struct task_struct *tsk, long addr, long data);
 #define force_successful_syscall_return() do { } while (0)
 #endif
 
+/*
+ * <asm/ptrace.h> should define the following things inside #ifdef __KERNEL__.
+ *
+ * These do-nothing inlines are used when the arch does not
+ * implement single-step.  The kerneldoc comments are here
+ * to document the interface for all arch definitions.
+ */
+
+#ifndef arch_has_single_step
+/**
+ * arch_has_single_step - does this CPU support user-mode single-step?
+ *
+ * If this is defined, then there must be function declarations or
+ * inlines for user_enable_single_step() and user_disable_single_step().
+ * arch_has_single_step() should evaluate to nonzero iff the machine
+ * supports instruction single-step for user mode.
+ * It can be a constant or it can test a CPU feature bit.
+ */
+#define arch_has_single_step()		(0)
+
+/**
+ * user_enable_single_step - single-step in user-mode task
+ * @task: either current or a task stopped in %TASK_TRACED
+ *
+ * This can only be called when arch_has_single_step() has returned nonzero.
+ * Set @task so that when it returns to user mode, it will trap after the
+ * next single instruction executes.
+ */
+static inline void user_enable_single_step(struct task_struct *task)
+{
+	BUG();			/* This can never be called.  */
+}
+
+/**
+ * user_disable_single_step - cancel user-mode single-step
+ * @task: either current or a task stopped in %TASK_TRACED
+ *
+ * Clear @task of the effects of user_enable_single_step().  This can
+ * be called whether or not user_enable_single_step() was ever called
+ * on @task, and even if arch_has_single_step() returned zero.
+ */
+static inline void user_disable_single_step(struct task_struct *task)
+{
+}
+#endif	/* arch_has_single_step */
+
 #endif
 
 #endif
-- 
1.5.3.4

