Return-Path: <linux-kernel-owner+w=401wt.eu-S1759517AbYG2Rlb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759517AbYG2Rlb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 13:41:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753281AbYG2Rk0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 13:40:26 -0400
Received: from mga09.intel.com ([134.134.136.24]:34002 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752688AbYG2RkX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 13:40:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.31,273,1215414000"; 
   d="scan'208";a="320702092"
Message-Id: <20080729173157.813771000@linux-os.sc.intel.com>
References: <20080729172917.185593000@linux-os.sc.intel.com>
User-Agent: quilt/0.46-1
Date: Tue, 29 Jul 2008 10:29:21 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       arjan@linux.intel.com, roland@redhat.com, drepper@redhat.com,
       mikpe@it.uu.se, chrisw@sous-sol.org, andi@firstfloor.org
Cc: linux-kernel@vger.kernel.org, suresh.b.siddha@intel.com
Subject: [patch 4/9] x86, xsave: dynamically allocate sigframes fpstate instead of static allocation
Content-Disposition: inline; filename=fpstate_dynamic.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dynamically allocate fpstate on the stack, instead of static allocation
in the current sigframe layout on the user stack. This will allow the
fpstate structure to grow in the future, which includes extended state
information supporting xsave/xrstor.

signal handlers will be able to access the fpstate pointer from the
sigcontext structure asusual, with no change. For the non RT sigframe's
(which are supported only for 32bit apps), current static fpstate layout
in the sigframe will be unused(so that we don't change the extramask[]
offset in the sigframe and thus prevent breaking app's which modify
extramask[]).

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---

Index: tip-0728/arch/x86/ia32/ia32_signal.c
===================================================================
--- tip-0728.orig/arch/x86/ia32/ia32_signal.c	2008-07-28 18:20:15.000000000 -0700
+++ tip-0728/arch/x86/ia32/ia32_signal.c	2008-07-28 18:35:50.000000000 -0700
@@ -179,9 +179,10 @@
 	u32 pretcode;
 	int sig;
 	struct sigcontext_ia32 sc;
-	struct _fpstate_ia32 fpstate;
+	struct _fpstate_ia32 fpstate_unused; /* look at kernel/sigframe.h */
 	unsigned int extramask[_COMPAT_NSIG_WORDS-1];
 	char retcode[8];
+	/* fp state follows here */
 };
 
 struct rt_sigframe
@@ -192,8 +193,8 @@
 	u32 puc;
 	compat_siginfo_t info;
 	struct ucontext_ia32 uc;
-	struct _fpstate_ia32 fpstate;
 	char retcode[8];
+	/* fp state follows here */
 };
 
 #define COPY(x)		{ 		\
@@ -402,7 +403,8 @@
  * Determine which stack to use..
  */
 static void __user *get_sigframe(struct k_sigaction *ka, struct pt_regs *regs,
-				 size_t frame_size)
+				 size_t frame_size,
+				 struct _fpstate_ia32 **fpstate)
 {
 	unsigned long sp;
 
@@ -421,6 +423,11 @@
 		 ka->sa.sa_restorer)
 		sp = (unsigned long) ka->sa.sa_restorer;
 
+	if (used_math()) {
+		sp = sp - sig_xstate_ia32_size;
+		*fpstate = (struct _fpstate_ia32 *) sp;
+	}
+
 	sp -= frame_size;
 	/* Align the stack pointer according to the i386 ABI,
 	 * i.e. so that on function entry ((sp + 4) & 15) == 0. */
@@ -434,6 +441,7 @@
 	struct sigframe __user *frame;
 	void __user *restorer;
 	int err = 0;
+	struct _fpstate_ia32 __user *fpstate = NULL;
 
 	/* copy_to_user optimizes that into a single 8 byte store */
 	static const struct {
@@ -448,7 +456,7 @@
 		0,
 	};
 
-	frame = get_sigframe(ka, regs, sizeof(*frame));
+	frame = get_sigframe(ka, regs, sizeof(*frame), &fpstate);
 
 	if (!access_ok(VERIFY_WRITE, frame, sizeof(*frame)))
 		goto give_sigsegv;
@@ -457,8 +465,7 @@
 	if (err)
 		goto give_sigsegv;
 
-	err |= ia32_setup_sigcontext(&frame->sc, &frame->fpstate, regs,
-					set->sig[0]);
+	err |= ia32_setup_sigcontext(&frame->sc, fpstate, regs, set->sig[0]);
 	if (err)
 		goto give_sigsegv;
 
@@ -522,6 +529,7 @@
 	struct rt_sigframe __user *frame;
 	void __user *restorer;
 	int err = 0;
+	struct _fpstate_ia32 __user *fpstate = NULL;
 
 	/* __copy_to_user optimizes that into a single 8 byte store */
 	static const struct {
@@ -537,7 +545,7 @@
 		0,
 	};
 
-	frame = get_sigframe(ka, regs, sizeof(*frame));
+	frame = get_sigframe(ka, regs, sizeof(*frame), &fpstate);
 
 	if (!access_ok(VERIFY_WRITE, frame, sizeof(*frame)))
 		goto give_sigsegv;
@@ -556,7 +564,7 @@
 	err |= __put_user(sas_ss_flags(regs->sp),
 			  &frame->uc.uc_stack.ss_flags);
 	err |= __put_user(current->sas_ss_size, &frame->uc.uc_stack.ss_size);
-	err |= ia32_setup_sigcontext(&frame->uc.uc_mcontext, &frame->fpstate,
+	err |= ia32_setup_sigcontext(&frame->uc.uc_mcontext, fpstate,
 				     regs, set->sig[0]);
 	err |= __copy_to_user(&frame->uc.uc_sigmask, set, sizeof(*set));
 	if (err)
Index: tip-0728/arch/x86/kernel/sigframe.h
===================================================================
--- tip-0728.orig/arch/x86/kernel/sigframe.h	2008-07-28 18:20:15.000000000 -0700
+++ tip-0728/arch/x86/kernel/sigframe.h	2008-07-28 18:31:15.000000000 -0700
@@ -3,9 +3,18 @@
 	char __user *pretcode;
 	int sig;
 	struct sigcontext sc;
-	struct _fpstate fpstate;
+	/*
+	 * fpstate is unused. fpstate is moved/allocated after
+	 * retcode[] below. This movement allows to have the FP state and the
+	 * future state extensions (xsave) stay together.
+	 * And at the same time retaining the unused fpstate, prevents changing
+	 * the offset of extramask[] in the sigframe and thus prevent any
+	 * legacy application accessing/modifying it.
+	 */
+	struct _fpstate fpstate_unused;
 	unsigned long extramask[_NSIG_WORDS-1];
 	char retcode[8];
+	/* fp state follows here */
 };
 
 struct rt_sigframe {
@@ -15,13 +24,14 @@
 	void __user *puc;
 	struct siginfo info;
 	struct ucontext uc;
-	struct _fpstate fpstate;
 	char retcode[8];
+	/* fp state follows here */
 };
 #else
 struct rt_sigframe {
 	char __user *pretcode;
 	struct ucontext uc;
 	struct siginfo info;
+	/* fp state follows here */
 };
 #endif
Index: tip-0728/arch/x86/kernel/signal_32.c
===================================================================
--- tip-0728.orig/arch/x86/kernel/signal_32.c	2008-07-28 18:20:15.000000000 -0700
+++ tip-0728/arch/x86/kernel/signal_32.c	2008-07-28 18:34:54.000000000 -0700
@@ -308,7 +308,8 @@
  * Determine which stack to use..
  */
 static inline void __user *
-get_sigframe(struct k_sigaction *ka, struct pt_regs *regs, size_t frame_size)
+get_sigframe(struct k_sigaction *ka, struct pt_regs *regs, size_t frame_size,
+	     struct _fpstate **fpstate)
 {
 	unsigned long sp;
 
@@ -334,6 +335,11 @@
 			sp = (unsigned long) ka->sa.sa_restorer;
 	}
 
+	if (used_math()) {
+		sp = sp - sig_xstate_size;
+		*fpstate = (struct _fpstate *) sp;
+	}
+
 	sp -= frame_size;
 	/*
 	 * Align the stack pointer according to the i386 ABI,
@@ -352,8 +358,9 @@
 	void __user *restorer;
 	int err = 0;
 	int usig;
+	struct _fpstate __user *fpstate = NULL;
 
-	frame = get_sigframe(ka, regs, sizeof(*frame));
+	frame = get_sigframe(ka, regs, sizeof(*frame), &fpstate);
 
 	if (!access_ok(VERIFY_WRITE, frame, sizeof(*frame)))
 		goto give_sigsegv;
@@ -368,7 +375,7 @@
 	if (err)
 		goto give_sigsegv;
 
-	err = setup_sigcontext(&frame->sc, &frame->fpstate, regs, set->sig[0]);
+	err = setup_sigcontext(&frame->sc, fpstate, regs, set->sig[0]);
 	if (err)
 		goto give_sigsegv;
 
@@ -429,8 +436,9 @@
 	void __user *restorer;
 	int err = 0;
 	int usig;
+	struct _fpstate __user *fpstate = NULL;
 
-	frame = get_sigframe(ka, regs, sizeof(*frame));
+	frame = get_sigframe(ka, regs, sizeof(*frame), &fpstate);
 
 	if (!access_ok(VERIFY_WRITE, frame, sizeof(*frame)))
 		goto give_sigsegv;
@@ -455,7 +463,7 @@
 	err |= __put_user(sas_ss_flags(regs->sp),
 			  &frame->uc.uc_stack.ss_flags);
 	err |= __put_user(current->sas_ss_size, &frame->uc.uc_stack.ss_size);
-	err |= setup_sigcontext(&frame->uc.uc_mcontext, &frame->fpstate,
+	err |= setup_sigcontext(&frame->uc.uc_mcontext, fpstate,
 				regs, set->sig[0]);
 	err |= __copy_to_user(&frame->uc.uc_sigmask, set, sizeof(*set));
 	if (err)
Index: tip-0728/arch/x86/kernel/i387.c
===================================================================
--- tip-0728.orig/arch/x86/kernel/i387.c	2008-07-28 18:27:28.000000000 -0700
+++ tip-0728/arch/x86/kernel/i387.c	2008-07-28 18:31:15.000000000 -0700
@@ -24,6 +24,7 @@
 # define save_i387_ia32		save_i387
 # define restore_i387_ia32	restore_i387
 # define _fpstate_ia32		_fpstate
+# define sig_xstate_ia32_size   sig_xstate_size
 # define user_i387_ia32_struct	user_i387_struct
 # define user32_fxsr_struct	user_fxsr_struct
 #endif
@@ -36,6 +37,7 @@
 
 static unsigned int		mxcsr_feature_mask __read_mostly = 0xffffffffu;
 unsigned int xstate_size;
+unsigned int sig_xstate_ia32_size = sizeof(struct _fpstate_ia32);
 static struct i387_fxsave_struct fx_scratch __cpuinitdata;
 
 void __cpuinit mxcsr_feature_mask_init(void)
Index: tip-0728/arch/x86/kernel/signal_64.c
===================================================================
--- tip-0728.orig/arch/x86/kernel/signal_64.c	2008-07-28 18:20:15.000000000 -0700
+++ tip-0728/arch/x86/kernel/signal_64.c	2008-07-28 18:31:15.000000000 -0700
@@ -284,7 +284,7 @@
 	struct task_struct *me = current;
 
 	if (used_math()) {
-		fp = get_stack(ka, regs, sizeof(struct _fpstate)); 
+		fp = get_stack(ka, regs, sig_xstate_size);
 		frame = (void __user *)round_down(
 			(unsigned long)fp - sizeof(struct rt_sigframe), 16) - 8;
 
Index: tip-0728/arch/x86/kernel/xsave.c
===================================================================
--- tip-0728.orig/arch/x86/kernel/xsave.c	2008-07-28 18:27:03.000000000 -0700
+++ tip-0728/arch/x86/kernel/xsave.c	2008-07-28 18:31:15.000000000 -0700
@@ -17,6 +17,10 @@
  */
 struct xsave_struct *init_xstate_buf;
 
+#ifdef CONFIG_X86_64
+unsigned int sig_xstate_size = sizeof(struct _fpstate);
+#endif
+
 /*
  * Enable the extended processor state save/restore feature
  */
Index: tip-0728/include/asm-x86/i387.h
===================================================================
--- tip-0728.orig/include/asm-x86/i387.h	2008-07-28 18:27:28.000000000 -0700
+++ tip-0728/include/asm-x86/i387.h	2008-07-28 18:31:15.000000000 -0700
@@ -20,6 +20,7 @@
 #include <asm/uaccess.h>
 #include <asm/xsave.h>
 
+extern unsigned int sig_xstate_size;
 extern void fpu_init(void);
 extern void mxcsr_feature_mask_init(void);
 extern int init_fpu(struct task_struct *child);
@@ -32,6 +33,7 @@
 extern user_regset_set_fn fpregs_set, xfpregs_set, fpregs_soft_set;
 
 #ifdef CONFIG_IA32_EMULATION
+extern unsigned int sig_xstate_ia32_size;
 struct _fpstate_ia32;
 extern int save_i387_ia32(struct _fpstate_ia32 __user *buf);
 extern int restore_i387_ia32(struct _fpstate_ia32 __user *buf);

-- 

