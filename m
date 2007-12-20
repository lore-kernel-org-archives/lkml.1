Return-Path: <linux-kernel-owner+w=401wt.eu-S1763390AbXLTMNB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763390AbXLTMNB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 07:13:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758587AbXLTMBS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 07:01:18 -0500
Received: from mx1.redhat.com ([66.187.233.31]:38454 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761155AbXLTMAv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 07:00:51 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
X-Fcc: ~/Mail/linus
Cc: linux-kernel@vger.kernel.org
In-Reply-To: Roland McGrath's message of  Thursday, 20 December 2007 03:52:00 -0800 <20071220115200.C767E26F98A@magilla.localdomain>
References: <20071220115200.C767E26F98A@magilla.localdomain>
Subject: [PATCH -mm 28/43] x86 i387 header cleanup
Message-Id: <20071220115946.2A45F26F98A@magilla.localdomain>
Date: Thu, 20 Dec 2007 03:59:46 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This moves some code into asm-x86/i387_64.h in preparation for
unifying this code between 32 and 64.  The 32-bit versions of
some things are copied in some existing names changed to match
32-bit names and share code.  For 64, save_i387 is moved into
an inline from i387_64.c; this matches restore_i387, which is
already an inline, and makes sense since there is exactly one
caller (in signal_64.c).  The save_i387 function could use more
cosmetic cleanup, but it is just moved verbatim in this patch.

Signed-off-by: Roland McGrath <roland@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/i387_64.c |   31 -----
 include/asm-x86/i387_64.h |  315 +++++++++++++++++++++++++++++++++------------
 2 files changed, 233 insertions(+), 113 deletions(-)

diff --git a/arch/x86/kernel/i387_64.c b/arch/x86/kernel/i387_64.c
index bfaff28..f335a76 100644
--- a/arch/x86/kernel/i387_64.c
+++ b/arch/x86/kernel/i387_64.c
@@ -72,37 +72,6 @@ void init_fpu(struct task_struct *child)
 }
 
 /*
- * Signal frame handlers.
- */
-
-int save_i387(struct _fpstate __user *buf)
-{
-	struct task_struct *tsk = current;
-	int err = 0;
-
-	BUILD_BUG_ON(sizeof(struct user_i387_struct) !=
-			sizeof(tsk->thread.i387.fxsave));
-
-	if ((unsigned long)buf % 16) 
-		printk("save_i387: bad fpstate %p\n",buf); 
-
-	if (!used_math())
-		return 0;
-	clear_used_math(); /* trigger finit */
-	if (task_thread_info(tsk)->status & TS_USEDFPU) {
-		err = save_i387_checking((struct i387_fxsave_struct __user *)buf);
-		if (err) return err;
-		task_thread_info(tsk)->status &= ~TS_USEDFPU;
-		stts();
-	} else {
-		if (__copy_to_user(buf, &tsk->thread.i387.fxsave,
-				   sizeof(struct i387_fxsave_struct)))
-			return -1;
-	}
-	return 1;
-}
-
-/*
  * ptrace request handlers.
  */
 
diff --git a/include/asm-x86/i387_64.h b/include/asm-x86/i387_64.h
index 12edb9f..4cea737 100644
--- a/include/asm-x86/i387_64.h
+++ b/include/asm-x86/i387_64.h
@@ -7,33 +7,23 @@
  * x86-64 work by Andi Kleen 2002
  */
 
-#ifndef __ASM_X86_64_I387_H
-#define __ASM_X86_64_I387_H
+#ifndef _ASM_X86_I387_H
+#define _ASM_X86_I387_H
 
 #include <linux/sched.h>
+#include <linux/kernel_stat.h>
 #include <asm/processor.h>
 #include <asm/sigcontext.h>
 #include <asm/user.h>
-#include <asm/thread_info.h>
 #include <asm/uaccess.h>
 
 extern void fpu_init(void);
 extern unsigned int mxcsr_feature_mask;
 extern void mxcsr_feature_mask_init(void);
 extern void init_fpu(struct task_struct *child);
-extern int save_i387(struct _fpstate __user *buf);
 extern asmlinkage void math_state_restore(void);
 
-/*
- * FPU lazy state save handling...
- */
-
-#define unlazy_fpu(tsk) do { \
-	if (task_thread_info(tsk)->status & TS_USEDFPU) \
-		save_init_fpu(tsk); 			\
-	else						\
-		tsk->fpu_counter = 0;			\
-} while (0)
+#ifdef CONFIG_X86_64
 
 /* Ignore delayed exceptions from user space */
 static inline void tolerant_fwait(void)
@@ -46,52 +36,8 @@ static inline void tolerant_fwait(void)
 		     "	.previous\n");
 }
 
-#define clear_fpu(tsk) do { \
-	if (task_thread_info(tsk)->status & TS_USEDFPU) {	\
-		tolerant_fwait();				\
-		task_thread_info(tsk)->status &= ~TS_USEDFPU;	\
-		stts();						\
-	}							\
-} while (0)
-
-/*
- * ptrace request handers...
- */
-extern int get_fpregs(struct user_i387_struct __user *buf,
-		      struct task_struct *tsk);
-extern int set_fpregs(struct task_struct *tsk,
-		      struct user_i387_struct __user *buf);
-
-/*
- * i387 state interaction
- */
-#define get_fpu_mxcsr(t) ((t)->thread.i387.fxsave.mxcsr)
-#define get_fpu_cwd(t) ((t)->thread.i387.fxsave.cwd)
-#define get_fpu_fxsr_twd(t) ((t)->thread.i387.fxsave.twd)
-#define get_fpu_swd(t) ((t)->thread.i387.fxsave.swd)
-#define set_fpu_cwd(t,val) ((t)->thread.i387.fxsave.cwd = (val))
-#define set_fpu_swd(t,val) ((t)->thread.i387.fxsave.swd = (val))
-#define set_fpu_fxsr_twd(t,val) ((t)->thread.i387.fxsave.twd = (val))
-
-#define X87_FSW_ES (1 << 7)	/* Exception Summary */
-
-/* AMD CPUs don't save/restore FDP/FIP/FOP unless an exception
-   is pending. Clear the x87 state here by setting it to fixed
-   values. The kernel data segment can be sometimes 0 and sometimes
-   new user value. Both should be ok.
-   Use the PDA as safe address because it should be already in L1. */
-static inline void clear_fpu_state(struct i387_fxsave_struct *fx)
+static inline int restore_fpu_checking(struct i387_fxsave_struct *fx)
 {
-	if (unlikely(fx->swd & X87_FSW_ES))
-		 asm volatile("fnclex");
-	alternative_input(ASM_NOP8 ASM_NOP2,
-	     	     "    emms\n"		/* clear stack tags */
-	     	     "    fildl %%gs:0",	/* load to clear state */
-		     X86_FEATURE_FXSAVE_LEAK);
-}
-
-static inline int restore_fpu_checking(struct i387_fxsave_struct *fx) 
-{ 
 	int err;
 
 	asm volatile("1:  rex64/fxrstor (%[fx])\n\t"
@@ -105,7 +51,7 @@ static inline int restore_fpu_checking(struct i387_fxsave_struct *fx)
 		     "   .quad  1b,3b\n"
 		     ".previous"
 		     : [err] "=r" (err)
-#if 0 /* See comment in __fxsave_clear() below. */
+#if 0 /* See comment in __save_init_fpu() below. */
 		     : [fx] "r" (fx), "m" (*fx), "0" (0));
 #else
 		     : [fx] "cdaSDb" (fx), "m" (*fx), "0" (0));
@@ -113,10 +59,27 @@ static inline int restore_fpu_checking(struct i387_fxsave_struct *fx)
 	if (unlikely(err))
 		init_fpu(current);
 	return err;
-} 
+}
 
-static inline int save_i387_checking(struct i387_fxsave_struct __user *fx) 
-{ 
+#define X87_FSW_ES (1 << 7)	/* Exception Summary */
+
+/* AMD CPUs don't save/restore FDP/FIP/FOP unless an exception
+   is pending. Clear the x87 state here by setting it to fixed
+   values. The kernel data segment can be sometimes 0 and sometimes
+   new user value. Both should be ok.
+   Use the PDA as safe address because it should be already in L1. */
+static inline void clear_fpu_state(struct i387_fxsave_struct *fx)
+{
+	if (unlikely(fx->swd & X87_FSW_ES))
+		 asm volatile("fnclex");
+	alternative_input(ASM_NOP8 ASM_NOP2,
+		     "    emms\n"		/* clear stack tags */
+		     "    fildl %%gs:0",	/* load to clear state */
+		     X86_FEATURE_FXSAVE_LEAK);
+}
+
+static inline int save_i387_checking(struct i387_fxsave_struct __user *fx)
+{
 	int err;
 
 	asm volatile("1:  rex64/fxsave (%[fx])\n\t"
@@ -139,9 +102,9 @@ static inline int save_i387_checking(struct i387_fxsave_struct __user *fx)
 		err = -EFAULT;
 	/* No need to clear here because the caller clears USED_MATH */
 	return err;
-} 
+}
 
-static inline void __fxsave_clear(struct task_struct *tsk)
+static inline void __save_init_fpu(struct task_struct *tsk)
 {
 	/* Using "rex64; fxsave %0" is broken because, if the memory operand
 	   uses any extended registers for addressing, a second REX prefix
@@ -169,18 +132,142 @@ static inline void __fxsave_clear(struct task_struct *tsk)
 					      thread.i387.fxsave)));
 #endif
 	clear_fpu_state(&tsk->thread.i387.fxsave);
+	task_thread_info(tsk)->status &= ~TS_USEDFPU;
+}
+
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
+			sizeof(tsk->thread.i387.fxsave));
+
+	if ((unsigned long)buf % 16)
+		printk("save_i387: bad fpstate %p\n", buf);
+
+	if (!used_math())
+		return 0;
+	clear_used_math(); /* trigger finit */
+	if (task_thread_info(tsk)->status & TS_USEDFPU) {
+		err = save_i387_checking((struct i387_fxsave_struct __user *)buf);
+		if (err) return err;
+		task_thread_info(tsk)->status &= ~TS_USEDFPU;
+		stts();
+	} else {
+		if (__copy_to_user(buf, &tsk->thread.i387.fxsave,
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
+	set_used_math();
+	if (!(task_thread_info(current)->status & TS_USEDFPU)) {
+		clts();
+		task_thread_info(current)->status |= TS_USEDFPU;
+	}
+	return restore_fpu_checking((__force struct i387_fxsave_struct *)buf);
+}
+
+#else  /* CONFIG_X86_32 */
+
+static inline void tolerant_fwait(void)
+{
+	asm volatile("fnclex ; fwait");
+}
+
+static inline void restore_fpu(struct task_struct *tsk)
+{
+	/*
+	 * The "nop" is needed to make the instructions the same
+	 * length.
+	 */
+	alternative_input(
+		"nop ; frstor %1",
+		"fxrstor %1",
+		X86_FEATURE_FXSR,
+		"m" ((tsk)->thread.i387.fxsave));
+}
+
+/* We need a safe address that is cheap to find and that is already
+   in L1 during context switch. The best choices are unfortunately
+   different for UP and SMP */
+#ifdef CONFIG_SMP
+#define safe_address (__per_cpu_offset[0])
+#else
+#define safe_address (kstat_cpu(0).cpustat.user)
+#endif
+
+/*
+ * These must be called with preempt disabled
+ */
+static inline void __save_init_fpu(struct task_struct *tsk)
+{
+	/* Use more nops than strictly needed in case the compiler
+	   varies code */
+	alternative_input(
+		"fnsave %[fx] ;fwait;" GENERIC_NOP8 GENERIC_NOP4,
+		"fxsave %[fx]\n"
+		"bt $7,%[fsw] ; jnc 1f ; fnclex\n1:",
+		X86_FEATURE_FXSR,
+		[fx] "m" (tsk->thread.i387.fxsave),
+		[fsw] "m" (tsk->thread.i387.fxsave.swd) : "memory");
+	/* AMD K7/K8 CPUs don't save/restore FDP/FIP/FOP unless an exception
+	   is pending.  Clear the x87 state here by setting it to fixed
+	   values. safe_address is a random variable that should be in L1 */
+	alternative_input(
+		GENERIC_NOP8 GENERIC_NOP2,
+		"emms\n\t"	  	/* clear stack tags */
+		"fildl %[addr]", 	/* set F?P to defined value */
+		X86_FEATURE_FXSAVE_LEAK,
+		[addr] "m" (safe_address));
+	task_thread_info(tsk)->status &= ~TS_USEDFPU;
+}
+
+/*
+ * Signal frame handlers...
+ */
+extern int save_i387(struct _fpstate __user *buf);
+extern int restore_i387(struct _fpstate __user *buf);
+
+#endif	/* CONFIG_X86_64 */
+
+static inline void __unlazy_fpu(struct task_struct *tsk)
+{
+	if (task_thread_info(tsk)->status & TS_USEDFPU) {
+		__save_init_fpu(tsk);
+		stts();
+	} else
+		tsk->fpu_counter = 0;
+}
+
+static inline void __clear_fpu(struct task_struct *tsk)
+{
+	if (task_thread_info(tsk)->status & TS_USEDFPU) {
+		tolerant_fwait();
+		task_thread_info(tsk)->status &= ~TS_USEDFPU;
+		stts();
+	}
 }
 
 static inline void kernel_fpu_begin(void)
 {
 	struct thread_info *me = current_thread_info();
 	preempt_disable();
-	if (me->status & TS_USEDFPU) {
-		__fxsave_clear(me->task);
-		me->status &= ~TS_USEDFPU;
-		return;
-	}
-	clts();
+	if (me->status & TS_USEDFPU)
+		__save_init_fpu(me->task);
+	else
+		clts();
 }
 
 static inline void kernel_fpu_end(void)
@@ -189,24 +276,88 @@ static inline void kernel_fpu_end(void)
 	preempt_enable();
 }
 
+#ifdef CONFIG_X86_64
+
 static inline void save_init_fpu(struct task_struct *tsk)
 {
- 	__fxsave_clear(tsk);
-	task_thread_info(tsk)->status &= ~TS_USEDFPU;
+	__save_init_fpu(tsk);
 	stts();
 }
 
-/* 
- * This restores directly out of user space. Exceptions are handled.
+#define unlazy_fpu	__unlazy_fpu
+#define clear_fpu	__clear_fpu
+
+#else  /* CONFIG_X86_32 */
+
+/*
+ * These disable preemption on their own and are safe
  */
-static inline int restore_i387(struct _fpstate __user *buf)
+static inline void save_init_fpu(struct task_struct *tsk)
 {
-	set_used_math();
-	if (!(task_thread_info(current)->status & TS_USEDFPU)) {
-		clts();
-		task_thread_info(current)->status |= TS_USEDFPU;
+	preempt_disable();
+	__save_init_fpu(tsk);
+	stts();
+	preempt_enable();
+}
+
+static inline void unlazy_fpu(struct task_struct *tsk)
+{
+	preempt_disable();
+	__unlazy_fpu(tsk);
+	preempt_enable();
+}
+
+static inline void clear_fpu(struct task_struct *tsk)
+{
+	preempt_disable();
+	__clear_fpu(tsk);
+	preempt_enable();
+}
+
+#endif	/* CONFIG_X86_64 */
+
+/*
+ * ptrace request handlers...
+ */
+extern int get_fpregs(struct user_i387_struct __user *buf,
+		      struct task_struct *tsk);
+extern int set_fpregs(struct task_struct *tsk,
+		      struct user_i387_struct __user *buf);
+
+struct user_fxsr_struct;
+extern int get_fpxregs(struct user_fxsr_struct __user *buf,
+		       struct task_struct *tsk);
+extern int set_fpxregs(struct task_struct *tsk,
+		       struct user_fxsr_struct __user *buf);
+
+/*
+ * i387 state interaction
+ */
+static inline unsigned short get_fpu_cwd(struct task_struct *tsk)
+{
+	if (cpu_has_fxsr) {
+		return tsk->thread.i387.fxsave.cwd;
+	} else {
+		return (unsigned short)tsk->thread.i387.fsave.cwd;
+	}
+}
+
+static inline unsigned short get_fpu_swd(struct task_struct *tsk)
+{
+	if (cpu_has_fxsr) {
+		return tsk->thread.i387.fxsave.swd;
+	} else {
+		return (unsigned short)tsk->thread.i387.fsave.swd;
+	}
+}
+
+static inline unsigned short get_fpu_mxcsr(struct task_struct *tsk)
+{
+	if (cpu_has_xmm) {
+		return tsk->thread.i387.fxsave.mxcsr;
+	} else {
+		return MXCSR_DEFAULT;
 	}
-	return restore_fpu_checking((__force struct i387_fxsave_struct *)buf);
 }
 
-#endif /* __ASM_X86_64_I387_H */
+#endif	/* _ASM_X86_I387_H */
-- 
1.5.3.6

