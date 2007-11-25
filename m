Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1758313AbXKYWHe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758313AbXKYWHe (ORCPT <rfc822;akpm@linux-foundation.org>);
	Sun, 25 Nov 2007 17:07:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758372AbXKYWF6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Nov 2007 17:05:58 -0500
Received: from mx1.redhat.com ([66.187.233.31]:56961 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758525AbXKYWF5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2007 17:05:57 -0500
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
Subject: [PATCH 20/27] ptrace: arch_has_block_step
In-Reply-To: Roland McGrath's message of  Sunday, 25 November 2007 13:55:07 -0800 <20071125215507.4B89226F8C5@magilla.localdomain>
References: <20071125215507.4B89226F8C5@magilla.localdomain>
X-Zippy-Says: Awright, which one of you hid my PENIS ENVY?
Message-Id: <20071125220552.C8D5126F8C5@magilla.localdomain>
Date: Sun, 25 Nov 2007 14:05:52 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This defines the new macro arch_has_block_step() in linux/ptrace.h, a
default for when asm/ptrace.h does not define it.  This is the analog
of arch_has_single_step() for step-until-branch on machines that have
it.  It declares the new user_enable_block_step function, which goes
with the existing user_enable_single_step and user_disable_single_step.
This is not used yet, but paves the way to harmonize on this interface
for the arch-specific calls on all machines.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 include/linux/ptrace.h |   37 +++++++++++++++++++++++++++++++++----
 1 files changed, 33 insertions(+), 4 deletions(-)

diff --git a/include/linux/ptrace.h b/include/linux/ptrace.h
index a6effc8..dd8f751 100644
--- a/include/linux/ptrace.h
+++ b/include/linux/ptrace.h
@@ -154,7 +154,8 @@ int generic_ptrace_pokedata(struct task_struct *tsk, long addr, long data);
  *
  * This can only be called when arch_has_single_step() has returned nonzero.
  * Set @task so that when it returns to user mode, it will trap after the
- * next single instruction executes.
+ * next single instruction executes.  If arch_has_block_step() is defined,
+ * this must clear the effects of user_enable_block_step() too.
  */
 static inline void user_enable_single_step(struct task_struct *task)
 {
@@ -165,15 +166,43 @@ static inline void user_enable_single_step(struct task_struct *task)
  * user_disable_single_step - cancel user-mode single-step
  * @task: either current or a task stopped in %TASK_TRACED
  *
- * Clear @task of the effects of user_enable_single_step().  This can
- * be called whether or not user_enable_single_step() was ever called
- * on @task, and even if arch_has_single_step() returned zero.
+ * Clear @task of the effects of user_enable_single_step() and
+ * user_enable_block_step().  This can be called whether or not either
+ * of those was ever called on @task, and even if arch_has_single_step()
+ * returned zero.
  */
 static inline void user_disable_single_step(struct task_struct *task)
 {
 }
 #endif	/* arch_has_single_step */
 
+#ifndef arch_has_block_step
+/**
+ * arch_has_block_step - does this CPU support user-mode block-step?
+ *
+ * If this is defined, then there must be a function declaration or inline
+ * for user_enable_block_step(), and arch_has_single_step() must be defined
+ * too.  arch_has_block_step() should evaluate to nonzero iff the machine
+ * supports step-until-branch for user mode.  It can be a constant or it
+ * can test a CPU feature bit.
+ */
+#define arch_has_single_step()		(0)
+
+/**
+ * user_enable_block_step - step until branch in user-mode task
+ * @task: either current or a task stopped in %TASK_TRACED
+ *
+ * This can only be called when arch_has_block_step() has returned nonzero,
+ * and will never be called when single-instruction stepping is being used.
+ * Set @task so that when it returns to user mode, it will trap after the
+ * next branch or trap taken.
+ */
+static inline void user_enable_block_step(struct task_struct *task)
+{
+	BUG();			/* This can never be called.  */
+}
+#endif	/* arch_has_block_step */
+
 #endif
 
 #endif
