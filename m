Return-Path: <linux-kernel-owner+w=401wt.eu-S1763883AbZEHA3T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763883AbZEHA3T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 20:29:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759531AbZEHAKr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 20:10:47 -0400
Received: from adsl-76-233-236-102.dsl.pltn13.sbcglobal.net ([76.233.236.102]:52721
	"EHLO abulafia.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756884AbZEHAKD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 20:10:03 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 2/5] x86: split out core __math_state_restore
Date: Thu,  7 May 2009 13:32:50 -0700
Message-Id: <1241728373-3537-3-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1241728373-3537-1-git-send-email-jeremy@goop.org>
References: <1241728373-3537-1-git-send-email-jeremy@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

Split the core fpu state restoration out into __math_state_restore, which
assumes that cr0.TS is clear and that the fpu context has been initialized.

This will be used during context switch.  There are two reasons this is
desireable:

- There's a small clarification.  When __switch_to() calls math_state_restore,
  it relies on the fact that tsk_used_math() returns true, and so will
  never do a blocking init_fpu().  __math_state_restore() does not have
  (or need) that logic, so the question never arises.

- It allows the clts() to be moved earler in __switch_to() so it can be performed
  while cpu context updates are batched (will be done in a later patch).

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/include/asm/i387.h |    1 +
 arch/x86/kernel/traps.c     |   33 +++++++++++++++++++++++----------
 2 files changed, 24 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/i387.h b/arch/x86/include/asm/i387.h
index 63d1850..6eda5d2 100644
--- a/arch/x86/include/asm/i387.h
+++ b/arch/x86/include/asm/i387.h
@@ -26,6 +26,7 @@ extern void fpu_init(void);
 extern void mxcsr_feature_mask_init(void);
 extern int init_fpu(struct task_struct *child);
 extern asmlinkage void math_state_restore(void);
+extern void __math_state_restore(void);
 extern void init_thread_xstate(void);
 extern int dump_fpu(struct pt_regs *, struct user_i387_struct *);
 
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index f07ada4..4ea50f7 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -814,6 +814,28 @@ asmlinkage void __attribute__((weak)) mce_threshold_interrupt(void)
 #endif
 
 /*
+ * __math_state_restore assumes that cr0.TS is already clear and the
+ * fpu state is all ready for use.  Used during context switch.
+ */
+inline void __math_state_restore(void)
+{
+	struct thread_info *thread = current_thread_info();
+	struct task_struct *tsk = thread->task;
+
+	/*
+	 * Paranoid restore. send a SIGSEGV if we fail to restore the state.
+	 */
+	if (unlikely(restore_fpu_checking(tsk))) {
+		stts();
+		force_sig(SIGSEGV, tsk);
+		return;
+	}
+
+	thread->status |= TS_USEDFPU;	/* So we fnsave on switch_to() */
+	tsk->fpu_counter++;
+}
+
+/*
  * 'math_state_restore()' saves the current math information in the
  * old math state array, and gets the new ones from the current task
  *
@@ -844,17 +866,8 @@ asmlinkage void math_state_restore(void)
 	}
 
 	clts();				/* Allow maths ops (or we recurse) */
-	/*
-	 * Paranoid restore. send a SIGSEGV if we fail to restore the state.
-	 */
-	if (unlikely(restore_fpu_checking(tsk))) {
-		stts();
-		force_sig(SIGSEGV, tsk);
-		return;
-	}
 
-	thread->status |= TS_USEDFPU;	/* So we fnsave on switch_to() */
-	tsk->fpu_counter++;
+	__math_state_restore();
 }
 EXPORT_SYMBOL_GPL(math_state_restore);
 
-- 
1.6.0.6

