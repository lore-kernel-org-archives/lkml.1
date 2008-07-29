Return-Path: <linux-kernel-owner+w=401wt.eu-S1758920AbYG2Rku@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758920AbYG2Rku (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 13:40:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753172AbYG2RkZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 13:40:25 -0400
Received: from mga09.intel.com ([134.134.136.24]:6214 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752644AbYG2RkW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 13:40:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.31,273,1215414000"; 
   d="scan'208";a="320702091"
Message-Id: <20080729173157.670824000@linux-os.sc.intel.com>
References: <20080729172917.185593000@linux-os.sc.intel.com>
User-Agent: quilt/0.46-1
Date: Tue, 29 Jul 2008 10:29:20 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       arjan@linux.intel.com, roland@redhat.com, drepper@redhat.com,
       mikpe@it.uu.se, chrisw@sous-sol.org, andi@firstfloor.org
Cc: linux-kernel@vger.kernel.org, suresh.b.siddha@intel.com
Subject: [patch 3/9] x86, xsave: context switch support using xsave/xrstor
Content-Disposition: inline; filename=xsave_in_context_switch.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Uses xsave/xrstor (instead of traditional fxsave/fxrstor) in context switch
when available.

Introduces TS_XSAVE flag, which determine the need to use xsave/xrstor
instructions during context switch instead of the legacy fxsave/fxrstor
instructions. Thread-synchronous status word is already in L1 cache during
this code patch and thus minimizes the performance penality compared to
(cpu_has_xsave) checks.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---

Index: tip-0728/arch/x86/kernel/cpu/common.c
===================================================================
--- tip-0728.orig/arch/x86/kernel/cpu/common.c	2008-07-28 18:23:14.000000000 -0700
+++ tip-0728/arch/x86/kernel/cpu/common.c	2008-07-28 18:27:28.000000000 -0700
@@ -709,7 +709,10 @@
 	/*
 	 * Force FPU initialization:
 	 */
-	current_thread_info()->status = 0;
+	if (cpu_has_xsave)
+		current_thread_info()->status = TS_XSAVE;
+	else
+		current_thread_info()->status = 0;
 	clear_used_math();
 	mxcsr_feature_mask_init();
 
Index: tip-0728/arch/x86/kernel/i387.c
===================================================================
--- tip-0728.orig/arch/x86/kernel/i387.c	2008-07-28 18:23:45.000000000 -0700
+++ tip-0728/arch/x86/kernel/i387.c	2008-07-28 18:27:28.000000000 -0700
@@ -97,7 +97,10 @@
 
 	mxcsr_feature_mask_init();
 	/* clean state in init */
-	current_thread_info()->status = 0;
+	if (cpu_has_xsave)
+		current_thread_info()->status = TS_XSAVE;
+	else
+		current_thread_info()->status = 0;
 	clear_used_math();
 }
 #endif	/* CONFIG_X86_64 */
Index: tip-0728/include/asm-x86/i387.h
===================================================================
--- tip-0728.orig/include/asm-x86/i387.h	2008-07-28 18:23:14.000000000 -0700
+++ tip-0728/include/asm-x86/i387.h	2008-07-28 18:27:28.000000000 -0700
@@ -37,6 +37,8 @@
 extern int restore_i387_ia32(struct _fpstate_ia32 __user *buf);
 #endif
 
+#define X87_FSW_ES (1 << 7)	/* Exception Summary */
+
 #ifdef CONFIG_X86_64
 
 /* Ignore delayed exceptions from user space */
@@ -47,7 +49,7 @@
 		     _ASM_EXTABLE(1b, 2b));
 }
 
-static inline int restore_fpu_checking(struct i387_fxsave_struct *fx)
+static inline int fxrstor_checking(struct i387_fxsave_struct *fx)
 {
 	int err;
 
@@ -67,15 +69,31 @@
 	return err;
 }
 
-#define X87_FSW_ES (1 << 7)	/* Exception Summary */
+static inline int restore_fpu_checking(struct task_struct *tsk)
+{
+	if (task_thread_info(tsk)->status & TS_XSAVE)
+		return xrstor_checking(&tsk->thread.xstate->xsave);
+	else
+		return fxrstor_checking(&tsk->thread.xstate->fxsave);
+}
 
 /* AMD CPUs don't save/restore FDP/FIP/FOP unless an exception
    is pending. Clear the x87 state here by setting it to fixed
    values. The kernel data segment can be sometimes 0 and sometimes
    new user value. Both should be ok.
    Use the PDA as safe address because it should be already in L1. */
-static inline void clear_fpu_state(struct i387_fxsave_struct *fx)
+static inline void clear_fpu_state(struct task_struct *tsk)
 {
+	struct xsave_struct *xstate = &tsk->thread.xstate->xsave;
+	struct i387_fxsave_struct *fx = &tsk->thread.xstate->fxsave;
+
+	/*
+	 * xsave header may indicate the init state of the FP.
+	 */
+	if ((task_thread_info(tsk)->status & TS_XSAVE) &&
+	    !(xstate->xsave_hdr.xstate_bv & XSTATE_FP))
+		return;
+
 	if (unlikely(fx->swd & X87_FSW_ES))
 		asm volatile("fnclex");
 	alternative_input(ASM_NOP8 ASM_NOP2,
@@ -108,7 +126,7 @@
 	return err;
 }
 
-static inline void __save_init_fpu(struct task_struct *tsk)
+static inline void fxsave(struct task_struct *tsk)
 {
 	/* Using "rex64; fxsave %0" is broken because, if the memory operand
 	   uses any extended registers for addressing, a second REX prefix
@@ -133,7 +151,16 @@
 			     : "=m" (tsk->thread.xstate->fxsave)
 			     : "cdaSDb" (&tsk->thread.xstate->fxsave));
 #endif
-	clear_fpu_state(&tsk->thread.xstate->fxsave);
+}
+
+static inline void __save_init_fpu(struct task_struct *tsk)
+{
+	if (task_thread_info(tsk)->status & TS_XSAVE)
+		xsave(tsk);
+	else
+		fxsave(tsk);
+
+	clear_fpu_state(tsk);
 	task_thread_info(tsk)->status &= ~TS_USEDFPU;
 }
 
@@ -148,6 +175,10 @@
 
 static inline void restore_fpu(struct task_struct *tsk)
 {
+	if (task_thread_info(tsk)->status & TS_XSAVE) {
+		xrstor_checking(&tsk->thread.xstate->xsave);
+		return;
+	}
 	/*
 	 * The "nop" is needed to make the instructions the same
 	 * length.
@@ -173,6 +204,27 @@
  */
 static inline void __save_init_fpu(struct task_struct *tsk)
 {
+	if (task_thread_info(tsk)->status & TS_XSAVE) {
+		struct xsave_struct *xstate = &tsk->thread.xstate->xsave;
+		struct i387_fxsave_struct *fx = &tsk->thread.xstate->fxsave;
+
+		xsave(tsk);
+
+		/*
+	 	 * xsave header may indicate the init state of the FP.
+	 	 */
+		if (!(xstate->xsave_hdr.xstate_bv & XSTATE_FP))
+			goto end;
+
+		if (unlikely(fx->swd & X87_FSW_ES))
+			asm volatile("fnclex");
+
+		/*
+		 * we can do a simple return here or be paranoid :)
+		 */
+		goto clear_state;
+	}
+
 	/* Use more nops than strictly needed in case the compiler
 	   varies code */
 	alternative_input(
@@ -182,6 +234,7 @@
 		X86_FEATURE_FXSR,
 		[fx] "m" (tsk->thread.xstate->fxsave),
 		[fsw] "m" (tsk->thread.xstate->fxsave.swd) : "memory");
+clear_state:
 	/* AMD K7/K8 CPUs don't save/restore FDP/FIP/FOP unless an exception
 	   is pending.  Clear the x87 state here by setting it to fixed
 	   values. safe_address is a random variable that should be in L1 */
@@ -191,6 +244,7 @@
 		"fildl %[addr]", 	/* set F?P to defined value */
 		X86_FEATURE_FXSAVE_LEAK,
 		[addr] "m" (safe_address));
+end:
 	task_thread_info(tsk)->status &= ~TS_USEDFPU;
 }
 
Index: tip-0728/include/asm-x86/processor.h
===================================================================
--- tip-0728.orig/include/asm-x86/processor.h	2008-07-28 18:23:14.000000000 -0700
+++ tip-0728/include/asm-x86/processor.h	2008-07-28 18:27:28.000000000 -0700
@@ -367,6 +367,7 @@
 	struct i387_fsave_struct	fsave;
 	struct i387_fxsave_struct	fxsave;
 	struct i387_soft_struct		soft;
+	struct xsave_struct		xsave;
 };
 
 #ifdef CONFIG_X86_64
Index: tip-0728/include/asm-x86/thread_info.h
===================================================================
--- tip-0728.orig/include/asm-x86/thread_info.h	2008-07-28 18:20:15.000000000 -0700
+++ tip-0728/include/asm-x86/thread_info.h	2008-07-28 18:27:28.000000000 -0700
@@ -241,6 +241,7 @@
 #define TS_POLLING		0x0004	/* true if in idle loop
 					   and not sleeping */
 #define TS_RESTORE_SIGMASK	0x0008	/* restore signal mask in do_signal() */
+#define TS_XSAVE		0x0010	/* Use xsave/xrstor */
 
 #define tsk_is_polling(t) (task_thread_info(t)->status & TS_POLLING)
 
Index: tip-0728/include/asm-x86/xsave.h
===================================================================
--- tip-0728.orig/include/asm-x86/xsave.h	2008-07-28 18:23:14.000000000 -0700
+++ tip-0728/include/asm-x86/xsave.h	2008-07-28 18:27:28.000000000 -0700
@@ -17,10 +17,43 @@
 #define XCNTXT_LMASK	(XSTATE_FP | XSTATE_SSE)
 #define XCNTXT_HMASK	0x0
 
+#ifdef CONFIG_X86_64
+#define REX_PREFIX	"0x48, "
+#else
+#define REX_PREFIX
+#endif
+
 extern unsigned int xstate_size, pcntxt_hmask, pcntxt_lmask;
 extern struct xsave_struct *init_xstate_buf;
 
 extern void xsave_cntxt_init(void);
 extern void xsave_init(void);
+extern int init_fpu(struct task_struct *child);
+
+static inline int xrstor_checking(struct xsave_struct *fx)
+{
+	int err;
+
+	asm volatile("1: .byte " REX_PREFIX "0x0f,0xae,0x2f\n\t"
+                     "2:\n"
+                     ".section .fixup,\"ax\"\n"
+                     "3:  movl $-1,%[err]\n"
+                     "    jmp  2b\n"
+                     ".previous\n"
+                     _ASM_EXTABLE(1b, 3b)
+                     : [err] "=r" (err)
+		     : "D" (fx), "m" (*fx), "a" (-1), "d" (-1), "0" (0)
+		     : "memory");
+
+	return err;
+}
 
+static inline void xsave(struct task_struct *tsk)
+{
+	/* This, however, we can work around by forcing the compiler to select
+	   an addressing mode that doesn't require extended registers. */
+	__asm__ __volatile__(".byte " REX_PREFIX "0x0f,0xae,0x27"
+			     ::"D" (&(tsk->thread.xstate->xsave)),
+			       "a" (-1), "d"(-1) : "memory");
+}
 #endif
Index: tip-0728/arch/x86/kernel/traps_64.c
===================================================================
--- tip-0728.orig/arch/x86/kernel/traps_64.c	2008-07-28 18:23:14.000000000 -0700
+++ tip-0728/arch/x86/kernel/traps_64.c	2008-07-28 18:27:28.000000000 -0700
@@ -1147,7 +1147,7 @@
 	/*
 	 * Paranoid restore. send a SIGSEGV if we fail to restore the state.
 	 */
-	if (unlikely(restore_fpu_checking(&me->thread.xstate->fxsave))) {
+	if (unlikely(restore_fpu_checking(me))) {
 		stts();
 		force_sig(SIGSEGV, me);
 		return;

-- 

