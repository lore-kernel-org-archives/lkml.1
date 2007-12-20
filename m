Return-Path: <linux-kernel-owner+w=401wt.eu-S1762103AbXLTMGf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762103AbXLTMGf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 07:06:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761223AbXLTMA5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 07:00:57 -0500
Received: from mx1.redhat.com ([66.187.233.31]:38425 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760970AbXLTMAg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 07:00:36 -0500
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
Subject: [PATCH -mm 32/43] x86 i387 cleanup
Message-Id: <20071220115954.CB4C826F98B@magilla.localdomain>
Date: Thu, 20 Dec 2007 03:59:54 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This removes all the old code that is no longer used after
the i387 unification and cleanup.  The i387_64.h is renamed
to i387.h with no changes, but since it replaces the nonempty
one-line stub i387.h it looks like a big diff and not a rename.

Signed-off-by: Roland McGrath <roland@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/ia32/fpu32.c     |  181 ----------------------
 arch/x86/kernel/i387_64.c |  119 ---------------
 include/asm-x86/i387.h    |  369 ++++++++++++++++++++++++++++++++++++++++++++-
 include/asm-x86/i387_32.h |  149 ------------------
 include/asm-x86/i387_64.h |  368 --------------------------------------------
 5 files changed, 368 insertions(+), 818 deletions(-)

diff --git a/arch/x86/ia32/fpu32.c b/arch/x86/ia32/fpu32.c
deleted file mode 100644
index ae80745..0000000
--- a/arch/x86/ia32/fpu32.c
+++ /dev/null
@@ -1,181 +0,0 @@
-/*
- * Copyright 2002 Andi Kleen, SuSE Labs.
- * FXSAVE<->i387 conversion support. Based on code by Gareth Hughes.
- * This is used for ptrace, signals and coredumps in 32bit emulation.
- */
-
-#include <linux/sched.h>
-#include <asm/sigcontext32.h>
-#include <asm/processor.h>
-#include <asm/uaccess.h>
-#include <asm/i387.h>
-
-static inline unsigned short twd_i387_to_fxsr(unsigned short twd)
-{
-	unsigned int tmp; /* to avoid 16 bit prefixes in the code */
-
-	/* Transform each pair of bits into 01 (valid) or 00 (empty) */
-	tmp = ~twd;
-	tmp = (tmp | (tmp>>1)) & 0x5555; /* 0V0V0V0V0V0V0V0V */
-	/* and move the valid bits to the lower byte. */
-	tmp = (tmp | (tmp >> 1)) & 0x3333; /* 00VV00VV00VV00VV */
-	tmp = (tmp | (tmp >> 2)) & 0x0f0f; /* 0000VVVV0000VVVV */
-	tmp = (tmp | (tmp >> 4)) & 0x00ff; /* 00000000VVVVVVVV */
-	return tmp;
-}
-
-#define FPREG_ADDR(f, n)	((void *)&(f)->st_space + (n) * 16);
-#define FP_EXP_TAG_VALID	0
-#define FP_EXP_TAG_ZERO		1
-#define FP_EXP_TAG_SPECIAL	2
-#define FP_EXP_TAG_EMPTY	3
-
-static inline unsigned long twd_fxsr_to_i387(struct i387_fxsave_struct *fxsave)
-{
-	struct _fpxreg *st;
-	unsigned long tos = (fxsave->swd >> 11) & 7;
-	unsigned long twd = (unsigned long) fxsave->twd;
-	unsigned long tag;
-	unsigned long ret = 0xffff0000;
-	int i;
-
-	for (i = 0; i < 8; i++, twd >>= 1) {
-		if (twd & 0x1) {
-			st = FPREG_ADDR(fxsave, (i - tos) & 7);
-
-			switch (st->exponent & 0x7fff) {
-			case 0x7fff:
-				tag = FP_EXP_TAG_SPECIAL;
-				break;
-			case 0x0000:
-				if (!st->significand[0] &&
-				    !st->significand[1] &&
-				    !st->significand[2] &&
-				    !st->significand[3])
-					tag = FP_EXP_TAG_ZERO;
-				else
-					tag = FP_EXP_TAG_SPECIAL;
-				break;
-			default:
-				if (st->significand[3] & 0x8000)
-					tag = FP_EXP_TAG_VALID;
-				else
-					tag = FP_EXP_TAG_SPECIAL;
-				break;
-			}
-		} else {
-			tag = FP_EXP_TAG_EMPTY;
-		}
-		ret |= tag << (2 * i);
-	}
-	return ret;
-}
-
-#define G(num, val) err |= __get_user(val, num + (u32 __user *)buf)
-
-static inline int convert_fxsr_from_user(struct i387_fxsave_struct *fxsave,
-					 struct _fpstate_ia32 __user *buf)
-{
-	struct _fpxreg *to;
-	struct _fpreg __user *from;
-	int i, err = 0;
-	u32 v;
-
-	G(0, fxsave->cwd);
-	G(1, fxsave->swd);
-	G(2, fxsave->twd);
-	fxsave->twd = twd_i387_to_fxsr(fxsave->twd);
-	G(3, fxsave->rip);
-	G(4, v);
-	/* cs ignored */
-	fxsave->fop = v>>16;
-	G(5, fxsave->rdp);
-	/* 6: ds ignored */
-	if (err)
-		return -1;
-
-	to = (struct _fpxreg *)&fxsave->st_space[0];
-	from = &buf->_st[0];
-	for (i = 0; i < 8; i++, to++, from++) {
-		if (__copy_from_user(to, from, sizeof(*from)))
-			return -1;
-	}
-	return 0;
-}
-
-#define P(num, val) err |= __put_user(val, num + (u32 __user *)buf)
-
-static inline int convert_fxsr_to_user(struct _fpstate_ia32 __user *buf,
-				       struct i387_fxsave_struct *fxsave,
-				       struct pt_regs *regs,
-				       struct task_struct *tsk)
-{
-	struct _fpreg __user *to;
-	struct _fpxreg *from;
-	int i, err = 0;
-	u16 cs, ds;
-
-	if (tsk == current) {
-		/*
-		 * should be actually ds/cs at fpu exception time, but
-		 * that information is not available in 64bit mode.
-		 */
-		asm("movw %%ds,%0 " : "=r" (ds));
-		asm("movw %%cs,%0 " : "=r" (cs));
-	} else {
-		 /* ptrace. task has stopped. */
-		ds = tsk->thread.ds;
-		cs = regs->cs;
-	}
-
-	P(0, (u32)fxsave->cwd | 0xffff0000);
-	P(1, (u32)fxsave->swd | 0xffff0000);
-	P(2, twd_fxsr_to_i387(fxsave));
-	P(3, (u32)fxsave->rip);
-	P(4,  cs | ((u32)fxsave->fop) << 16);
-	P(5, fxsave->rdp);
-	P(6, 0xffff0000 | ds);
-
-	if (err)
-		return -1;
-
-	to = &buf->_st[0];
-	from = (struct _fpxreg *) &fxsave->st_space[0];
-	for (i = 0; i < 8; i++, to++, from++) {
-		if (__copy_to_user(to, from, sizeof(*to)))
-			return -1;
-	}
-	return 0;
-}
-
-int restore_i387_ia32(struct task_struct *tsk,
-		      struct _fpstate_ia32 __user *buf, int fsave)
-{
-	clear_fpu(tsk);
-	if (!fsave) {
-		if (__copy_from_user(&tsk->thread.i387.fxsave,
-				     &buf->_fxsr_env[0],
-				     sizeof(struct i387_fxsave_struct)))
-			return -1;
-		tsk->thread.i387.fxsave.mxcsr &= mxcsr_feature_mask;
-		set_stopped_child_used_math(tsk);
-	}
-	return convert_fxsr_from_user(&tsk->thread.i387.fxsave, buf);
-}
-
-int save_i387_ia32(struct task_struct *tsk, struct _fpstate_ia32 __user *buf,
-		   struct pt_regs *regs, int fsave)
-{
-	int err = 0;
-
-	init_fpu(tsk);
-	if (convert_fxsr_to_user(buf, &tsk->thread.i387.fxsave, regs, tsk))
-		return -1;
-	if (fsave)
-		return 0;
-	err |= __put_user(tsk->thread.i387.fxsave.swd, &buf->status);
-	err |= __put_user(X86_FXSR_MAGIC, &buf->magic);
-	err |= __copy_to_user(&buf->_fxsr_env[0], &tsk->thread.i387.fxsave,
-			      sizeof(struct i387_fxsave_struct));
-	return err ? -1 : 1;
-}
diff --git a/arch/x86/kernel/i387_64.c b/arch/x86/kernel/i387_64.c
deleted file mode 100644
index f335a76..0000000
--- a/arch/x86/kernel/i387_64.c
+++ /dev/null
@@ -1,119 +0,0 @@
-/*
- *  Copyright (C) 1994 Linus Torvalds
- *  Copyright (C) 2002 Andi Kleen, SuSE Labs
- *
- *  Pentium III FXSR, SSE support
- *  General FPU state handling cleanups
- *	Gareth Hughes <gareth@valinux.com>, May 2000
- * 
- *  x86-64 rework 2002 Andi Kleen. 
- *  Does direct fxsave in and out of user space now for signal handlers.
- *  All the FSAVE<->FXSAVE conversion code has been moved to the 32bit emulation,
- *  the 64bit user space sees a FXSAVE frame directly. 
- */
-
-#include <linux/sched.h>
-#include <linux/init.h>
-#include <asm/processor.h>
-#include <asm/i387.h>
-#include <asm/sigcontext.h>
-#include <asm/user.h>
-#include <asm/ptrace.h>
-#include <asm/uaccess.h>
-
-unsigned int mxcsr_feature_mask __read_mostly = 0xffffffff;
-
-void mxcsr_feature_mask_init(void)
-{
-	unsigned int mask;
-	clts();
-	memset(&current->thread.i387.fxsave, 0, sizeof(struct i387_fxsave_struct));
-	asm volatile("fxsave %0" : : "m" (current->thread.i387.fxsave));
-	mask = current->thread.i387.fxsave.mxcsr_mask;
-	if (mask == 0) mask = 0x0000ffbf;
-	mxcsr_feature_mask &= mask;
-	stts();
-}
-
-/*
- * Called at bootup to set up the initial FPU state that is later cloned
- * into all processes.
- */
-void __cpuinit fpu_init(void)
-{
-	unsigned long oldcr0 = read_cr0();
-	extern void __bad_fxsave_alignment(void);
-		
-	if (offsetof(struct task_struct, thread.i387.fxsave) & 15)
-		__bad_fxsave_alignment();
-	set_in_cr4(X86_CR4_OSFXSR);
-	set_in_cr4(X86_CR4_OSXMMEXCPT);
-
-	write_cr0(oldcr0 & ~((1UL<<3)|(1UL<<2))); /* clear TS and EM */
-
-	mxcsr_feature_mask_init();
-	/* clean state in init */
-	current_thread_info()->status = 0;
-	clear_used_math();
-}
-
-void init_fpu(struct task_struct *child)
-{
-	if (tsk_used_math(child)) {
-		if (child == current)
-			unlazy_fpu(child);
-		return;
-	}	
-	memset(&child->thread.i387.fxsave, 0, sizeof(struct i387_fxsave_struct));
-	child->thread.i387.fxsave.cwd = 0x37f;
-	child->thread.i387.fxsave.mxcsr = 0x1f80;
-	/* only the device not available exception or ptrace can call init_fpu */
-	set_stopped_child_used_math(child);
-}
-
-/*
- * ptrace request handlers.
- */
-
-int get_fpregs(struct user_i387_struct __user *buf, struct task_struct *tsk)
-{
-	init_fpu(tsk);
-	return __copy_to_user(buf, &tsk->thread.i387.fxsave,
-			       sizeof(struct user_i387_struct)) ? -EFAULT : 0;
-}
-
-int set_fpregs(struct task_struct *tsk, struct user_i387_struct __user *buf)
-{
-	if (__copy_from_user(&tsk->thread.i387.fxsave, buf, 
-			     sizeof(struct user_i387_struct)))
-		return -EFAULT;
-		return 0;
-}
-
-/*
- * FPU state for core dumps.
- */
-
-int dump_fpu( struct pt_regs *regs, struct user_i387_struct *fpu )
-{
-	struct task_struct *tsk = current;
-
-	if (!used_math())
-		return 0;
-
-	unlazy_fpu(tsk);
-	memcpy(fpu, &tsk->thread.i387.fxsave, sizeof(struct user_i387_struct)); 
-	return 1; 
-}
-
-int dump_task_fpu(struct task_struct *tsk, struct user_i387_struct *fpu)
-{
-	int fpvalid = !!tsk_used_math(tsk);
-
-	if (fpvalid) {
-		if (tsk == current)
-			unlazy_fpu(tsk);
-		memcpy(fpu, &tsk->thread.i387.fxsave, sizeof(struct user_i387_struct)); 	
-}
-	return fpvalid;
-}
diff --git a/include/asm-x86/i387.h b/include/asm-x86/i387.h
index b2bc005..b52b891 100644
--- a/include/asm-x86/i387.h
+++ b/include/asm-x86/i387.h
@@ -1 +1,368 @@
-#include "i387_64.h"
+/*
+ * Copyright (C) 1994 Linus Torvalds
+ *
+ * Pentium III FXSR, SSE support
+ * General FPU state handling cleanups
+ *	Gareth Hughes <gareth@valinux.com>, May 2000
+ * x86-64 work by Andi Kleen 2002
+ */
+
+#ifndef _ASM_X86_I387_H
+#define _ASM_X86_I387_H
+
+#include <linux/sched.h>
+#include <linux/kernel_stat.h>
+#include <linux/regset.h>
+#include <asm/processor.h>
+#include <asm/sigcontext.h>
+#include <asm/user.h>
+#include <asm/uaccess.h>
+
+extern void fpu_init(void);
+extern unsigned int mxcsr_feature_mask;
+extern void mxcsr_feature_mask_init(void);
+extern void init_fpu(struct task_struct *child);
+extern asmlinkage void math_state_restore(void);
+
+extern user_regset_active_fn fpregs_active, xfpregs_active;
+extern user_regset_get_fn fpregs_get, xfpregs_get, fpregs_soft_get;
+extern user_regset_set_fn fpregs_set, xfpregs_set, fpregs_soft_set;
+
+#ifdef CONFIG_X86_64
+
+/* Ignore delayed exceptions from user space */
+static inline void tolerant_fwait(void)
+{
+	asm volatile("1: fwait\n"
+		     "2:\n"
+		     "   .section __ex_table,\"a\"\n"
+		     "	.align 8\n"
+		     "	.quad 1b,2b\n"
+		     "	.previous\n");
+}
+
+static inline int restore_fpu_checking(struct i387_fxsave_struct *fx)
+{
+	int err;
+
+	asm volatile("1:  rex64/fxrstor (%[fx])\n\t"
+		     "2:\n"
+		     ".section .fixup,\"ax\"\n"
+		     "3:  movl $-1,%[err]\n"
+		     "    jmp  2b\n"
+		     ".previous\n"
+		     ".section __ex_table,\"a\"\n"
+		     "   .align 8\n"
+		     "   .quad  1b,3b\n"
+		     ".previous"
+		     : [err] "=r" (err)
+#if 0 /* See comment in __save_init_fpu() below. */
+		     : [fx] "r" (fx), "m" (*fx), "0" (0));
+#else
+		     : [fx] "cdaSDb" (fx), "m" (*fx), "0" (0));
+#endif
+	if (unlikely(err))
+		init_fpu(current);
+	return err;
+}
+
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
+	int err;
+
+	asm volatile("1:  rex64/fxsave (%[fx])\n\t"
+		     "2:\n"
+		     ".section .fixup,\"ax\"\n"
+		     "3:  movl $-1,%[err]\n"
+		     "    jmp  2b\n"
+		     ".previous\n"
+		     ".section __ex_table,\"a\"\n"
+		     "   .align 8\n"
+		     "   .quad  1b,3b\n"
+		     ".previous"
+		     : [err] "=r" (err), "=m" (*fx)
+#if 0 /* See comment in __fxsave_clear() below. */
+		     : [fx] "r" (fx), "0" (0));
+#else
+		     : [fx] "cdaSDb" (fx), "0" (0));
+#endif
+	if (unlikely(err) && __clear_user(fx, sizeof(struct i387_fxsave_struct)))
+		err = -EFAULT;
+	/* No need to clear here because the caller clears USED_MATH */
+	return err;
+}
+
+static inline void __save_init_fpu(struct task_struct *tsk)
+{
+	/* Using "rex64; fxsave %0" is broken because, if the memory operand
+	   uses any extended registers for addressing, a second REX prefix
+	   will be generated (to the assembler, rex64 followed by semicolon
+	   is a separate instruction), and hence the 64-bitness is lost. */
+#if 0
+	/* Using "fxsaveq %0" would be the ideal choice, but is only supported
+	   starting with gas 2.16. */
+	__asm__ __volatile__("fxsaveq %0"
+			     : "=m" (tsk->thread.i387.fxsave));
+#elif 0
+	/* Using, as a workaround, the properly prefixed form below isn't
+	   accepted by any binutils version so far released, complaining that
+	   the same type of prefix is used twice if an extended register is
+	   needed for addressing (fix submitted to mainline 2005-11-21). */
+	__asm__ __volatile__("rex64/fxsave %0"
+			     : "=m" (tsk->thread.i387.fxsave));
+#else
+	/* This, however, we can work around by forcing the compiler to select
+	   an addressing mode that doesn't require extended registers. */
+	__asm__ __volatile__("rex64/fxsave %P2(%1)"
+			     : "=m" (tsk->thread.i387.fxsave)
+			     : "cdaSDb" (tsk),
+				"i" (offsetof(__typeof__(*tsk),
+					      thread.i387.fxsave)));
+#endif
+	clear_fpu_state(&tsk->thread.i387.fxsave);
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
+}
+
+static inline void kernel_fpu_begin(void)
+{
+	struct thread_info *me = current_thread_info();
+	preempt_disable();
+	if (me->status & TS_USEDFPU)
+		__save_init_fpu(me->task);
+	else
+		clts();
+}
+
+static inline void kernel_fpu_end(void)
+{
+	stts();
+	preempt_enable();
+}
+
+#ifdef CONFIG_X86_64
+
+static inline void save_init_fpu(struct task_struct *tsk)
+{
+	__save_init_fpu(tsk);
+	stts();
+}
+
+#define unlazy_fpu	__unlazy_fpu
+#define clear_fpu	__clear_fpu
+
+#else  /* CONFIG_X86_32 */
+
+/*
+ * These disable preemption on their own and are safe
+ */
+static inline void save_init_fpu(struct task_struct *tsk)
+{
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
+	}
+}
+
+#endif	/* _ASM_X86_I387_H */
diff --git a/include/asm-x86/i387_32.h b/include/asm-x86/i387_32.h
deleted file mode 100644
index 9ac2502..0000000
--- a/include/asm-x86/i387_32.h
+++ /dev/null
@@ -1,149 +0,0 @@
-/*
- * Copyright (C) 1994 Linus Torvalds
- *
- * Pentium III FXSR, SSE support
- * General FPU state handling cleanups
- *	Gareth Hughes <gareth@valinux.com>, May 2000
- */
-
-#ifndef __ASM_I386_I387_H
-#define __ASM_I386_I387_H
-
-#include <linux/sched.h>
-#include <linux/init.h>
-#include <linux/kernel_stat.h>
-#include <asm/processor.h>
-#include <asm/sigcontext.h>
-#include <asm/user.h>
-
-extern void mxcsr_feature_mask_init(void);
-extern void init_fpu(struct task_struct *);
-
-/*
- * FPU lazy state save handling...
- */
-
-/*
- * The "nop" is needed to make the instructions the same
- * length.
- */
-#define restore_fpu(tsk)			\
-	alternative_input(			\
-		"nop ; frstor %1",		\
-		"fxrstor %1",			\
-		X86_FEATURE_FXSR,		\
-		"m" ((tsk)->thread.i387.fxsave))
-
-extern void kernel_fpu_begin(void);
-#define kernel_fpu_end() do { stts(); preempt_enable(); } while(0)
-
-/* We need a safe address that is cheap to find and that is already
-   in L1 during context switch. The best choices are unfortunately
-   different for UP and SMP */
-#ifdef CONFIG_SMP
-#define safe_address (__per_cpu_offset[0])
-#else
-#define safe_address (kstat_cpu(0).cpustat.user)
-#endif
-
-/*
- * These must be called with preempt disabled
- */
-static inline void __save_init_fpu( struct task_struct *tsk )
-{
-	/* Use more nops than strictly needed in case the compiler
-	   varies code */
-	alternative_input(
-		"fnsave %[fx] ;fwait;" GENERIC_NOP8 GENERIC_NOP4,
-		"fxsave %[fx]\n"
-		"bt $7,%[fsw] ; jnc 1f ; fnclex\n1:",
-		X86_FEATURE_FXSR,
-		[fx] "m" (tsk->thread.i387.fxsave),
-		[fsw] "m" (tsk->thread.i387.fxsave.swd) : "memory");
-	/* AMD K7/K8 CPUs don't save/restore FDP/FIP/FOP unless an exception
-	   is pending.  Clear the x87 state here by setting it to fixed
-   	   values. safe_address is a random variable that should be in L1 */
-	alternative_input(
-		GENERIC_NOP8 GENERIC_NOP2,
-		"emms\n\t"	  	/* clear stack tags */
-		"fildl %[addr]", 	/* set F?P to defined value */
-		X86_FEATURE_FXSAVE_LEAK,
-		[addr] "m" (safe_address));
-	task_thread_info(tsk)->status &= ~TS_USEDFPU;
-}
-
-#define __unlazy_fpu( tsk ) do {				\
-	if (task_thread_info(tsk)->status & TS_USEDFPU) {	\
-		__save_init_fpu(tsk);				\
-		stts();						\
-	} else							\
-		tsk->fpu_counter = 0;				\
-} while (0)
-
-#define __clear_fpu( tsk )					\
-do {								\
-	if (task_thread_info(tsk)->status & TS_USEDFPU) {	\
-		asm volatile("fnclex ; fwait");			\
-		task_thread_info(tsk)->status &= ~TS_USEDFPU;	\
-		stts();						\
-	}							\
-} while (0)
-
-
-/*
- * These disable preemption on their own and are safe
- */
-static inline void save_init_fpu( struct task_struct *tsk )
-{
-	preempt_disable();
-	__save_init_fpu(tsk);
-	stts();
-	preempt_enable();
-}
-
-#define unlazy_fpu( tsk ) do {	\
-	preempt_disable();	\
-	__unlazy_fpu(tsk);	\
-	preempt_enable();	\
-} while (0)
-
-#define clear_fpu( tsk ) do {	\
-	preempt_disable();	\
-	__clear_fpu( tsk );	\
-	preempt_enable();	\
-} while (0)
-
-/*
- * FPU state interaction...
- */
-extern unsigned short get_fpu_cwd( struct task_struct *tsk );
-extern unsigned short get_fpu_swd( struct task_struct *tsk );
-extern unsigned short get_fpu_mxcsr( struct task_struct *tsk );
-extern asmlinkage void math_state_restore(void);
-
-/*
- * Signal frame handlers...
- */
-extern int save_i387( struct _fpstate __user *buf );
-extern int restore_i387( struct _fpstate __user *buf );
-
-/*
- * ptrace request handers...
- */
-extern int get_fpregs( struct user_i387_struct __user *buf,
-		       struct task_struct *tsk );
-extern int set_fpregs( struct task_struct *tsk,
-		       struct user_i387_struct __user *buf );
-
-extern int get_fpxregs( struct user_fxsr_struct __user *buf,
-			struct task_struct *tsk );
-extern int set_fpxregs( struct task_struct *tsk,
-			struct user_fxsr_struct __user *buf );
-
-/*
- * FPU state for core dumps...
- */
-extern int dump_fpu( struct pt_regs *regs,
-		     struct user_i387_struct *fpu );
-
-#endif /* __ASM_I386_I387_H */
diff --git a/include/asm-x86/i387_64.h b/include/asm-x86/i387_64.h
deleted file mode 100644
index b52b891..0000000
--- a/include/asm-x86/i387_64.h
+++ /dev/null
@@ -1,368 +0,0 @@
-/*
- * Copyright (C) 1994 Linus Torvalds
- *
- * Pentium III FXSR, SSE support
- * General FPU state handling cleanups
- *	Gareth Hughes <gareth@valinux.com>, May 2000
- * x86-64 work by Andi Kleen 2002
- */
-
-#ifndef _ASM_X86_I387_H
-#define _ASM_X86_I387_H
-
-#include <linux/sched.h>
-#include <linux/kernel_stat.h>
-#include <linux/regset.h>
-#include <asm/processor.h>
-#include <asm/sigcontext.h>
-#include <asm/user.h>
-#include <asm/uaccess.h>
-
-extern void fpu_init(void);
-extern unsigned int mxcsr_feature_mask;
-extern void mxcsr_feature_mask_init(void);
-extern void init_fpu(struct task_struct *child);
-extern asmlinkage void math_state_restore(void);
-
-extern user_regset_active_fn fpregs_active, xfpregs_active;
-extern user_regset_get_fn fpregs_get, xfpregs_get, fpregs_soft_get;
-extern user_regset_set_fn fpregs_set, xfpregs_set, fpregs_soft_set;
-
-#ifdef CONFIG_X86_64
-
-/* Ignore delayed exceptions from user space */
-static inline void tolerant_fwait(void)
-{
-	asm volatile("1: fwait\n"
-		     "2:\n"
-		     "   .section __ex_table,\"a\"\n"
-		     "	.align 8\n"
-		     "	.quad 1b,2b\n"
-		     "	.previous\n");
-}
-
-static inline int restore_fpu_checking(struct i387_fxsave_struct *fx)
-{
-	int err;
-
-	asm volatile("1:  rex64/fxrstor (%[fx])\n\t"
-		     "2:\n"
-		     ".section .fixup,\"ax\"\n"
-		     "3:  movl $-1,%[err]\n"
-		     "    jmp  2b\n"
-		     ".previous\n"
-		     ".section __ex_table,\"a\"\n"
-		     "   .align 8\n"
-		     "   .quad  1b,3b\n"
-		     ".previous"
-		     : [err] "=r" (err)
-#if 0 /* See comment in __save_init_fpu() below. */
-		     : [fx] "r" (fx), "m" (*fx), "0" (0));
-#else
-		     : [fx] "cdaSDb" (fx), "m" (*fx), "0" (0));
-#endif
-	if (unlikely(err))
-		init_fpu(current);
-	return err;
-}
-
-#define X87_FSW_ES (1 << 7)	/* Exception Summary */
-
-/* AMD CPUs don't save/restore FDP/FIP/FOP unless an exception
-   is pending. Clear the x87 state here by setting it to fixed
-   values. The kernel data segment can be sometimes 0 and sometimes
-   new user value. Both should be ok.
-   Use the PDA as safe address because it should be already in L1. */
-static inline void clear_fpu_state(struct i387_fxsave_struct *fx)
-{
-	if (unlikely(fx->swd & X87_FSW_ES))
-		 asm volatile("fnclex");
-	alternative_input(ASM_NOP8 ASM_NOP2,
-		     "    emms\n"		/* clear stack tags */
-		     "    fildl %%gs:0",	/* load to clear state */
-		     X86_FEATURE_FXSAVE_LEAK);
-}
-
-static inline int save_i387_checking(struct i387_fxsave_struct __user *fx)
-{
-	int err;
-
-	asm volatile("1:  rex64/fxsave (%[fx])\n\t"
-		     "2:\n"
-		     ".section .fixup,\"ax\"\n"
-		     "3:  movl $-1,%[err]\n"
-		     "    jmp  2b\n"
-		     ".previous\n"
-		     ".section __ex_table,\"a\"\n"
-		     "   .align 8\n"
-		     "   .quad  1b,3b\n"
-		     ".previous"
-		     : [err] "=r" (err), "=m" (*fx)
-#if 0 /* See comment in __fxsave_clear() below. */
-		     : [fx] "r" (fx), "0" (0));
-#else
-		     : [fx] "cdaSDb" (fx), "0" (0));
-#endif
-	if (unlikely(err) && __clear_user(fx, sizeof(struct i387_fxsave_struct)))
-		err = -EFAULT;
-	/* No need to clear here because the caller clears USED_MATH */
-	return err;
-}
-
-static inline void __save_init_fpu(struct task_struct *tsk)
-{
-	/* Using "rex64; fxsave %0" is broken because, if the memory operand
-	   uses any extended registers for addressing, a second REX prefix
-	   will be generated (to the assembler, rex64 followed by semicolon
-	   is a separate instruction), and hence the 64-bitness is lost. */
-#if 0
-	/* Using "fxsaveq %0" would be the ideal choice, but is only supported
-	   starting with gas 2.16. */
-	__asm__ __volatile__("fxsaveq %0"
-			     : "=m" (tsk->thread.i387.fxsave));
-#elif 0
-	/* Using, as a workaround, the properly prefixed form below isn't
-	   accepted by any binutils version so far released, complaining that
-	   the same type of prefix is used twice if an extended register is
-	   needed for addressing (fix submitted to mainline 2005-11-21). */
-	__asm__ __volatile__("rex64/fxsave %0"
-			     : "=m" (tsk->thread.i387.fxsave));
-#else
-	/* This, however, we can work around by forcing the compiler to select
-	   an addressing mode that doesn't require extended registers. */
-	__asm__ __volatile__("rex64/fxsave %P2(%1)"
-			     : "=m" (tsk->thread.i387.fxsave)
-			     : "cdaSDb" (tsk),
-				"i" (offsetof(__typeof__(*tsk),
-					      thread.i387.fxsave)));
-#endif
-	clear_fpu_state(&tsk->thread.i387.fxsave);
-	task_thread_info(tsk)->status &= ~TS_USEDFPU;
-}
-
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
-			sizeof(tsk->thread.i387.fxsave));
-
-	if ((unsigned long)buf % 16)
-		printk("save_i387: bad fpstate %p\n", buf);
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
- * This restores directly out of user space. Exceptions are handled.
- */
-static inline int restore_i387(struct _fpstate __user *buf)
-{
-	set_used_math();
-	if (!(task_thread_info(current)->status & TS_USEDFPU)) {
-		clts();
-		task_thread_info(current)->status |= TS_USEDFPU;
-	}
-	return restore_fpu_checking((__force struct i387_fxsave_struct *)buf);
-}
-
-#else  /* CONFIG_X86_32 */
-
-static inline void tolerant_fwait(void)
-{
-	asm volatile("fnclex ; fwait");
-}
-
-static inline void restore_fpu(struct task_struct *tsk)
-{
-	/*
-	 * The "nop" is needed to make the instructions the same
-	 * length.
-	 */
-	alternative_input(
-		"nop ; frstor %1",
-		"fxrstor %1",
-		X86_FEATURE_FXSR,
-		"m" ((tsk)->thread.i387.fxsave));
-}
-
-/* We need a safe address that is cheap to find and that is already
-   in L1 during context switch. The best choices are unfortunately
-   different for UP and SMP */
-#ifdef CONFIG_SMP
-#define safe_address (__per_cpu_offset[0])
-#else
-#define safe_address (kstat_cpu(0).cpustat.user)
-#endif
-
-/*
- * These must be called with preempt disabled
- */
-static inline void __save_init_fpu(struct task_struct *tsk)
-{
-	/* Use more nops than strictly needed in case the compiler
-	   varies code */
-	alternative_input(
-		"fnsave %[fx] ;fwait;" GENERIC_NOP8 GENERIC_NOP4,
-		"fxsave %[fx]\n"
-		"bt $7,%[fsw] ; jnc 1f ; fnclex\n1:",
-		X86_FEATURE_FXSR,
-		[fx] "m" (tsk->thread.i387.fxsave),
-		[fsw] "m" (tsk->thread.i387.fxsave.swd) : "memory");
-	/* AMD K7/K8 CPUs don't save/restore FDP/FIP/FOP unless an exception
-	   is pending.  Clear the x87 state here by setting it to fixed
-	   values. safe_address is a random variable that should be in L1 */
-	alternative_input(
-		GENERIC_NOP8 GENERIC_NOP2,
-		"emms\n\t"	  	/* clear stack tags */
-		"fildl %[addr]", 	/* set F?P to defined value */
-		X86_FEATURE_FXSAVE_LEAK,
-		[addr] "m" (safe_address));
-	task_thread_info(tsk)->status &= ~TS_USEDFPU;
-}
-
-/*
- * Signal frame handlers...
- */
-extern int save_i387(struct _fpstate __user *buf);
-extern int restore_i387(struct _fpstate __user *buf);
-
-#endif	/* CONFIG_X86_64 */
-
-static inline void __unlazy_fpu(struct task_struct *tsk)
-{
-	if (task_thread_info(tsk)->status & TS_USEDFPU) {
-		__save_init_fpu(tsk);
-		stts();
-	} else
-		tsk->fpu_counter = 0;
-}
-
-static inline void __clear_fpu(struct task_struct *tsk)
-{
-	if (task_thread_info(tsk)->status & TS_USEDFPU) {
-		tolerant_fwait();
-		task_thread_info(tsk)->status &= ~TS_USEDFPU;
-		stts();
-	}
-}
-
-static inline void kernel_fpu_begin(void)
-{
-	struct thread_info *me = current_thread_info();
-	preempt_disable();
-	if (me->status & TS_USEDFPU)
-		__save_init_fpu(me->task);
-	else
-		clts();
-}
-
-static inline void kernel_fpu_end(void)
-{
-	stts();
-	preempt_enable();
-}
-
-#ifdef CONFIG_X86_64
-
-static inline void save_init_fpu(struct task_struct *tsk)
-{
-	__save_init_fpu(tsk);
-	stts();
-}
-
-#define unlazy_fpu	__unlazy_fpu
-#define clear_fpu	__clear_fpu
-
-#else  /* CONFIG_X86_32 */
-
-/*
- * These disable preemption on their own and are safe
- */
-static inline void save_init_fpu(struct task_struct *tsk)
-{
-	preempt_disable();
-	__save_init_fpu(tsk);
-	stts();
-	preempt_enable();
-}
-
-static inline void unlazy_fpu(struct task_struct *tsk)
-{
-	preempt_disable();
-	__unlazy_fpu(tsk);
-	preempt_enable();
-}
-
-static inline void clear_fpu(struct task_struct *tsk)
-{
-	preempt_disable();
-	__clear_fpu(tsk);
-	preempt_enable();
-}
-
-#endif	/* CONFIG_X86_64 */
-
-/*
- * ptrace request handlers...
- */
-extern int get_fpregs(struct user_i387_struct __user *buf,
-		      struct task_struct *tsk);
-extern int set_fpregs(struct task_struct *tsk,
-		      struct user_i387_struct __user *buf);
-
-struct user_fxsr_struct;
-extern int get_fpxregs(struct user_fxsr_struct __user *buf,
-		       struct task_struct *tsk);
-extern int set_fpxregs(struct task_struct *tsk,
-		       struct user_fxsr_struct __user *buf);
-
-/*
- * i387 state interaction
- */
-static inline unsigned short get_fpu_cwd(struct task_struct *tsk)
-{
-	if (cpu_has_fxsr) {
-		return tsk->thread.i387.fxsave.cwd;
-	} else {
-		return (unsigned short)tsk->thread.i387.fsave.cwd;
-	}
-}
-
-static inline unsigned short get_fpu_swd(struct task_struct *tsk)
-{
-	if (cpu_has_fxsr) {
-		return tsk->thread.i387.fxsave.swd;
-	} else {
-		return (unsigned short)tsk->thread.i387.fsave.swd;
-	}
-}
-
-static inline unsigned short get_fpu_mxcsr(struct task_struct *tsk)
-{
-	if (cpu_has_xmm) {
-		return tsk->thread.i387.fxsave.mxcsr;
-	} else {
-		return MXCSR_DEFAULT;
-	}
-}
-
-#endif	/* _ASM_X86_I387_H */
-- 
1.5.3.6

