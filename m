Return-Path: <linux-kernel-owner+w=401wt.eu-S1755527AbZFJVTC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755527AbZFJVTC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 17:19:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754160AbZFJVSx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 17:18:53 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:47893 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752867AbZFJVSw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 17:18:52 -0400
Date: Wed, 10 Jun 2009 23:18:47 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/fpu for v2.6.31
Message-ID: <20090610211847.GA14663@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-fpu-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-fpu-for-linus

( old branch with old-style impact lines - can rebase if overly annoying. )

 Thanks,

	Ingo

------------------>
Jiri Slaby (3):
      x86_32: introduce restore_fpu_checking()
      x86: unify restore_fpu_checking
      x86_64: fix incorrect comments


 arch/x86/include/asm/i387.h |   31 +++++++++++++++----------------
 arch/x86/kernel/traps.c     |    5 +----
 2 files changed, 16 insertions(+), 20 deletions(-)

diff --git a/arch/x86/include/asm/i387.h b/arch/x86/include/asm/i387.h
index 71c9e51..63d1850 100644
--- a/arch/x86/include/asm/i387.h
+++ b/arch/x86/include/asm/i387.h
@@ -67,7 +67,7 @@ static inline int fxrstor_checking(struct i387_fxsave_struct *fx)
 		     ".previous\n"
 		     _ASM_EXTABLE(1b, 3b)
 		     : [err] "=r" (err)
-#if 0 /* See comment in __save_init_fpu() below. */
+#if 0 /* See comment in fxsave() below. */
 		     : [fx] "r" (fx), "m" (*fx), "0" (0));
 #else
 		     : [fx] "cdaSDb" (fx), "m" (*fx), "0" (0));
@@ -75,14 +75,6 @@ static inline int fxrstor_checking(struct i387_fxsave_struct *fx)
 	return err;
 }
 
-static inline int restore_fpu_checking(struct task_struct *tsk)
-{
-	if (task_thread_info(tsk)->status & TS_XSAVE)
-		return xrstor_checking(&tsk->thread.xstate->xsave);
-	else
-		return fxrstor_checking(&tsk->thread.xstate->fxsave);
-}
-
 /* AMD CPUs don't save/restore FDP/FIP/FOP unless an exception
    is pending. Clear the x87 state here by setting it to fixed
    values. The kernel data segment can be sometimes 0 and sometimes
@@ -120,7 +112,7 @@ static inline int fxsave_user(struct i387_fxsave_struct __user *fx)
 		     ".previous\n"
 		     _ASM_EXTABLE(1b, 3b)
 		     : [err] "=r" (err), "=m" (*fx)
-#if 0 /* See comment in __fxsave_clear() below. */
+#if 0 /* See comment in fxsave() below. */
 		     : [fx] "r" (fx), "0" (0));
 #else
 		     : [fx] "cdaSDb" (fx), "0" (0));
@@ -185,12 +177,9 @@ static inline void tolerant_fwait(void)
 	asm volatile("fnclex ; fwait");
 }
 
-static inline void restore_fpu(struct task_struct *tsk)
+/* perform fxrstor iff the processor has extended states, otherwise frstor */
+static inline int fxrstor_checking(struct i387_fxsave_struct *fx)
 {
-	if (task_thread_info(tsk)->status & TS_XSAVE) {
-		xrstor_checking(&tsk->thread.xstate->xsave);
-		return;
-	}
 	/*
 	 * The "nop" is needed to make the instructions the same
 	 * length.
@@ -199,7 +188,9 @@ static inline void restore_fpu(struct task_struct *tsk)
 		"nop ; frstor %1",
 		"fxrstor %1",
 		X86_FEATURE_FXSR,
-		"m" (tsk->thread.xstate->fxsave));
+		"m" (*fx));
+
+	return 0;
 }
 
 /* We need a safe address that is cheap to find and that is already
@@ -262,6 +253,14 @@ end:
 
 #endif	/* CONFIG_X86_64 */
 
+static inline int restore_fpu_checking(struct task_struct *tsk)
+{
+	if (task_thread_info(tsk)->status & TS_XSAVE)
+		return xrstor_checking(&tsk->thread.xstate->xsave);
+	else
+		return fxrstor_checking(&tsk->thread.xstate->fxsave);
+}
+
 /*
  * Signal frame handlers...
  */
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
