Return-Path: <linux-kernel-owner+w=401wt.eu-S1765125AbZDHL5W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765125AbZDHL5W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 07:57:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764767AbZDHLd3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 07:33:29 -0400
Received: from smtp.wellnetcz.com ([212.24.148.102]:33807 "EHLO
	smtp.wellnetcz.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759499AbZDHLd0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 07:33:26 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: mingo@redhat.com
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 1/3] x86_32: make restore_fpu ckecking
Date: Wed,  8 Apr 2009 13:31:58 +0200
Message-Id: <1239190320-23952-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Like on x86_64, return an error from restore_fpu and kill the task if it
fails.

Also rename restore_fpu to restore_fpu_checking which allows ifdefs to be
removed in math_state_restore.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/include/asm/i387.h |    9 ++++-----
 arch/x86/kernel/traps.c     |    5 +----
 2 files changed, 5 insertions(+), 9 deletions(-)

diff --git a/arch/x86/include/asm/i387.h b/arch/x86/include/asm/i387.h
index 71c9e51..09a2d6d 100644
--- a/arch/x86/include/asm/i387.h
+++ b/arch/x86/include/asm/i387.h
@@ -185,12 +185,10 @@ static inline void tolerant_fwait(void)
 	asm volatile("fnclex ; fwait");
 }
 
-static inline void restore_fpu(struct task_struct *tsk)
+static inline int restore_fpu_checking(struct task_struct *tsk)
 {
-	if (task_thread_info(tsk)->status & TS_XSAVE) {
-		xrstor_checking(&tsk->thread.xstate->xsave);
-		return;
-	}
+	if (task_thread_info(tsk)->status & TS_XSAVE)
+		return xrstor_checking(&tsk->thread.xstate->xsave);
 	/*
 	 * The "nop" is needed to make the instructions the same
 	 * length.
@@ -200,6 +198,7 @@ static inline void restore_fpu(struct task_struct *tsk)
 		"fxrstor %1",
 		X86_FEATURE_FXSR,
 		"m" (tsk->thread.xstate->fxsave));
+	return 0;
 }
 
 /* We need a safe address that is cheap to find and that is already
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index a1d2883..d696145 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -839,9 +839,6 @@ asmlinkage void math_state_restore(void)
 	}
 
 	clts();				/* Allow maths ops (or we recurse) */
-#ifdef CONFIG_X86_32
-	restore_fpu(tsk);
-#else
 	/*
 	 * Paranoid restore. send a SIGSEGV if we fail to restore the state.
 	 */
@@ -850,7 +847,7 @@ asmlinkage void math_state_restore(void)
 		force_sig(SIGSEGV, tsk);
 		return;
 	}
-#endif
+
 	thread->status |= TS_USEDFPU;	/* So we fnsave on switch_to() */
 	tsk->fpu_counter++;
 }
-- 
1.6.2

