Return-Path: <linux-kernel-owner+w=401wt.eu-S1756267AbZIKToo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756267AbZIKToo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 15:44:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753464AbZIKTon
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 15:44:43 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:36018 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751760AbZIKTom (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 15:44:42 -0400
Date: Fri, 11 Sep 2009 21:44:32 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [GIT PULL] x86/fpu for v2.6.32
Message-ID: <20090911194432.GA29736@elte.hu>
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

Please pull the x86-fpu-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-fpu-for-linus

 Thanks,

	Ingo

------------------>
Jeremy Fitzhardinge (4):
      x86: split out core __math_state_restore
      x86-32: make sure clts is batched during context switch
      x86-64: move unlazy_fpu() into lazy cpu state part of context switch
      x86-64: move clts into batch cpu state updates when preloading fpu


 arch/x86/include/asm/i387.h  |    1 +
 arch/x86/kernel/process_32.c |   27 ++++++++++++++++-----------
 arch/x86/kernel/process_64.c |   33 +++++++++++++++++++++------------
 arch/x86/kernel/traps.c      |   33 +++++++++++++++++++++++----------
 4 files changed, 61 insertions(+), 33 deletions(-)

diff --git a/arch/x86/include/asm/i387.h b/arch/x86/include/asm/i387.h
index 175adf5..2e75292 100644
--- a/arch/x86/include/asm/i387.h
+++ b/arch/x86/include/asm/i387.h
@@ -26,6 +26,7 @@ extern void fpu_init(void);
 extern void mxcsr_feature_mask_init(void);
 extern int init_fpu(struct task_struct *child);
 extern asmlinkage void math_state_restore(void);
+extern void __math_state_restore(void);
 extern void init_thread_xstate(void);
 extern int dump_fpu(struct pt_regs *, struct user_i387_struct *);
 
diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index 59f4524..a80eddd 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -350,14 +350,21 @@ __switch_to(struct task_struct *prev_p, struct task_struct *next_p)
 				 *next = &next_p->thread;
 	int cpu = smp_processor_id();
 	struct tss_struct *tss = &per_cpu(init_tss, cpu);
+	bool preload_fpu;
 
 	/* never put a printk in __switch_to... printk() calls wake_up*() indirectly */
 
-	__unlazy_fpu(prev_p);
+	/*
+	 * If the task has used fpu the last 5 timeslices, just do a full
+	 * restore of the math state immediately to avoid the trap; the
+	 * chances of needing FPU soon are obviously high now
+	 */
+	preload_fpu = tsk_used_math(next_p) && next_p->fpu_counter > 5;
 
+	__unlazy_fpu(prev_p);
 
 	/* we're going to use this soon, after a few expensive things */
-	if (next_p->fpu_counter > 5)
+	if (preload_fpu)
 		prefetch(next->xstate);
 
 	/*
@@ -398,6 +405,11 @@ __switch_to(struct task_struct *prev_p, struct task_struct *next_p)
 		     task_thread_info(next_p)->flags & _TIF_WORK_CTXSW_NEXT))
 		__switch_to_xtra(prev_p, next_p, tss);
 
+	/* If we're going to preload the fpu context, make sure clts
+	   is run while we're batching the cpu state updates. */
+	if (preload_fpu)
+		clts();
+
 	/*
 	 * Leave lazy mode, flushing any hypercalls made here.
 	 * This must be done before restoring TLS segments so
@@ -407,15 +419,8 @@ __switch_to(struct task_struct *prev_p, struct task_struct *next_p)
 	 */
 	arch_end_context_switch(next_p);
 
-	/* If the task has used fpu the last 5 timeslices, just do a full
-	 * restore of the math state immediately to avoid the trap; the
-	 * chances of needing FPU soon are obviously high now
-	 *
-	 * tsk_used_math() checks prevent calling math_state_restore(),
-	 * which can sleep in the case of !tsk_used_math()
-	 */
-	if (tsk_used_math(next_p) && next_p->fpu_counter > 5)
-		math_state_restore();
+	if (preload_fpu)
+		__math_state_restore();
 
 	/*
 	 * Restore %gs if needed (which is common)
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index ebefb54..a28279d 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -386,9 +386,17 @@ __switch_to(struct task_struct *prev_p, struct task_struct *next_p)
 	int cpu = smp_processor_id();
 	struct tss_struct *tss = &per_cpu(init_tss, cpu);
 	unsigned fsindex, gsindex;
+	bool preload_fpu;
+
+	/*
+	 * If the task has used fpu the last 5 timeslices, just do a full
+	 * restore of the math state immediately to avoid the trap; the
+	 * chances of needing FPU soon are obviously high now
+	 */
+	preload_fpu = tsk_used_math(next_p) && next_p->fpu_counter > 5;
 
 	/* we're going to use this soon, after a few expensive things */
-	if (next_p->fpu_counter > 5)
+	if (preload_fpu)
 		prefetch(next->xstate);
 
 	/*
@@ -419,6 +427,13 @@ __switch_to(struct task_struct *prev_p, struct task_struct *next_p)
 
 	load_TLS(next, cpu);
 
+	/* Must be after DS reload */
+	unlazy_fpu(prev_p);
+
+	/* Make sure cpu is ready for new context */
+	if (preload_fpu)
+		clts();
+
 	/*
 	 * Leave lazy mode, flushing any hypercalls made here.
 	 * This must be done before restoring TLS segments so
@@ -459,9 +474,6 @@ __switch_to(struct task_struct *prev_p, struct task_struct *next_p)
 		wrmsrl(MSR_KERNEL_GS_BASE, next->gs);
 	prev->gsindex = gsindex;
 
-	/* Must be after DS reload */
-	unlazy_fpu(prev_p);
-
 	/*
 	 * Switch the PDA and FPU contexts.
 	 */
@@ -480,15 +492,12 @@ __switch_to(struct task_struct *prev_p, struct task_struct *next_p)
 		     task_thread_info(prev_p)->flags & _TIF_WORK_CTXSW_PREV))
 		__switch_to_xtra(prev_p, next_p, tss);
 
-	/* If the task has used fpu the last 5 timeslices, just do a full
-	 * restore of the math state immediately to avoid the trap; the
-	 * chances of needing FPU soon are obviously high now
-	 *
-	 * tsk_used_math() checks prevent calling math_state_restore(),
-	 * which can sleep in the case of !tsk_used_math()
+	/*
+	 * Preload the FPU context, now that we've determined that the
+	 * task is likely to be using it. 
 	 */
-	if (tsk_used_math(next_p) && next_p->fpu_counter > 5)
-		math_state_restore();
+	if (preload_fpu)
+		__math_state_restore();
 	return prev_p;
 }
 
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index 5f935f0..71b9166 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -814,6 +814,28 @@ asmlinkage void __attribute__((weak)) smp_threshold_interrupt(void)
 }
 
 /*
+ * __math_state_restore assumes that cr0.TS is already clear and the
+ * fpu state is all ready for use.  Used during context switch.
+ */
+void __math_state_restore(void)
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
 
