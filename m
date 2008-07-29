Return-Path: <linux-kernel-owner+w=401wt.eu-S1759812AbYG2Rlp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759812AbYG2Rlp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 13:41:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753402AbYG2Rk1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 13:40:27 -0400
Received: from mga14.intel.com ([143.182.124.37]:32501 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752771AbYG2RkX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 13:40:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.31,273,1215414000"; 
   d="scan'208";a="26651790"
Message-Id: <20080729173157.959007000@linux-os.sc.intel.com>
References: <20080729172917.185593000@linux-os.sc.intel.com>
User-Agent: quilt/0.46-1
Date: Tue, 29 Jul 2008 10:29:22 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       arjan@linux.intel.com, roland@redhat.com, drepper@redhat.com,
       mikpe@it.uu.se, chrisw@sous-sol.org, andi@firstfloor.org
Cc: linux-kernel@vger.kernel.org, suresh.b.siddha@intel.com
Subject: [patch 5/9] x86, xsave: reorganization of signal save/restore fpstate code layout
Content-Disposition: inline; filename=prepare_for_xsave_sigcontext.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

move 64bit routines that saves/restores fpstate in/from user stack from
signal_64.c to xsave.c

restore_i387_xstate() now handles the condition when user passes
NULL fpstate.

Other misc changes for prepartion of xsave/xrstor sigcontext support.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---

Index: tip-0728/arch/x86/kernel/i387.c
===================================================================
--- tip-0728.orig/arch/x86/kernel/i387.c	2008-07-28 18:31:15.000000000 -0700
+++ tip-0728/arch/x86/kernel/i387.c	2008-07-28 18:37:20.000000000 -0700
@@ -21,9 +21,10 @@
 # include <asm/sigcontext32.h>
 # include <asm/user32.h>
 #else
-# define save_i387_ia32		save_i387
-# define restore_i387_ia32	restore_i387
+# define save_i387_xstate_ia32		save_i387_xstate
+# define restore_i387_xstate_ia32	restore_i387_xstate
 # define _fpstate_ia32		_fpstate
+# define _xstate_ia32		_xstate
 # define sig_xstate_ia32_size   sig_xstate_size
 # define user_i387_ia32_struct	user_i387_struct
 # define user32_fxsr_struct	user_fxsr_struct
@@ -424,7 +425,6 @@
 	struct task_struct *tsk = current;
 	struct i387_fsave_struct *fp = &tsk->thread.xstate->fsave;
 
-	unlazy_fpu(tsk);
 	fp->status = fp->swd;
 	if (__copy_to_user(buf, fp, sizeof(struct i387_fsave_struct)))
 		return -1;
@@ -438,8 +438,6 @@
 	struct user_i387_ia32_struct env;
 	int err = 0;
 
-	unlazy_fpu(tsk);
-
 	convert_from_fxsr(&env, tsk);
 	if (__copy_to_user(buf, &env, sizeof(env)))
 		return -1;
@@ -455,10 +453,16 @@
 	return 1;
 }
 
-int save_i387_ia32(struct _fpstate_ia32 __user *buf)
+int save_i387_xstate_ia32(void __user *buf)
 {
+	struct _fpstate_ia32 __user *fp = (struct _fpstate_ia32 __user *) buf;
+	struct task_struct *tsk = current;
+
 	if (!used_math())
 		return 0;
+
+	if (!access_ok(VERIFY_WRITE, buf, sig_xstate_ia32_size))
+		return -EACCES;
 	/*
 	 * This will cause a "finit" to be triggered by the next
 	 * attempted FPU operation by the 'current' process.
@@ -468,13 +472,15 @@
 	if (!HAVE_HWFP) {
 		return fpregs_soft_get(current, NULL,
 				       0, sizeof(struct user_i387_ia32_struct),
-				       NULL, buf) ? -1 : 1;
+				       NULL, fp) ? -1 : 1;
 	}
 
+	unlazy_fpu(tsk);
+
 	if (cpu_has_fxsr)
-		return save_i387_fxsave(buf);
+		return save_i387_fxsave(fp);
 	else
-		return save_i387_fsave(buf);
+		return save_i387_fsave(fp);
 }
 
 static inline int restore_i387_fsave(struct _fpstate_ia32 __user *buf)
@@ -502,14 +508,26 @@
 	return 0;
 }
 
-int restore_i387_ia32(struct _fpstate_ia32 __user *buf)
+int restore_i387_xstate_ia32(void __user *buf)
 {
 	int err;
 	struct task_struct *tsk = current;
+	struct _fpstate_ia32 __user *fp = (struct _fpstate_ia32 __user *) buf;
 
 	if (HAVE_HWFP)
 		clear_fpu(tsk);
 
+	if (!buf) {
+		if (used_math()) {
+			clear_fpu(tsk);
+			clear_used_math();
+		}
+
+		return 0;
+	} else
+		if (!access_ok(VERIFY_READ, buf, sig_xstate_ia32_size))
+			return -EACCES;
+
 	if (!used_math()) {
 		err = init_fpu(tsk);
 		if (err)
@@ -518,13 +536,13 @@
 
 	if (HAVE_HWFP) {
 		if (cpu_has_fxsr)
-			err = restore_i387_fxsave(buf);
+			err = restore_i387_fxsave(fp);
 		else
-			err = restore_i387_fsave(buf);
+			err = restore_i387_fsave(fp);
 	} else {
 		err = fpregs_soft_set(current, NULL,
 				      0, sizeof(struct user_i387_ia32_struct),
-				      NULL, buf) != 0;
+				      NULL, fp) != 0;
 	}
 	set_used_math();
 
Index: tip-0728/arch/x86/kernel/xsave.c
===================================================================
--- tip-0728.orig/arch/x86/kernel/xsave.c	2008-07-28 18:31:15.000000000 -0700
+++ tip-0728/arch/x86/kernel/xsave.c	2008-07-28 18:37:20.000000000 -0700
@@ -12,6 +12,85 @@
  */
 unsigned int pcntxt_hmask, pcntxt_lmask;
 
+#ifdef CONFIG_X86_64
+/*
+ * Signal frame handlers.
+ */
+
+int save_i387_xstate(void __user *buf)
+{
+	struct task_struct *tsk = current;
+	int err = 0;
+
+	if (!access_ok(VERIFY_WRITE, buf, sig_xstate_size))
+		return -EACCES;
+
+	BUILD_BUG_ON(sizeof(struct user_i387_struct) !=
+			sizeof(tsk->thread.xstate->fxsave));
+
+	if ((unsigned long)buf % 16)
+		printk("save_i387_xstate: bad fpstate %p\n", buf);
+
+	if (!used_math())
+		return 0;
+	clear_used_math(); /* trigger finit */
+	if (task_thread_info(tsk)->status & TS_USEDFPU) {
+		err = save_i387_checking((struct i387_fxsave_struct __user *)
+					 buf);
+		if (err)
+			return err;
+		task_thread_info(tsk)->status &= ~TS_USEDFPU;
+		stts();
+	} else {
+		if (__copy_to_user(buf, &tsk->thread.xstate->fxsave,
+				   xstate_size))
+			return -1;
+	}
+	return 1;
+}
+
+/*
+ * This restores directly out of user space. Exceptions are handled.
+ */
+int restore_i387_xstate(void __user *buf)
+{
+	struct task_struct *tsk = current;
+	int err;
+
+	if (!buf) {
+		if (used_math()) {
+			clear_fpu(tsk);
+			clear_used_math();
+		}
+
+		return 0;
+	} else
+		if (!access_ok(VERIFY_READ, buf, sig_xstate_size))
+			return -EACCES;
+
+	if (!used_math()) {
+		err = init_fpu(tsk);
+		if (err)
+			return err;
+	}
+
+	if (!(task_thread_info(current)->status & TS_USEDFPU)) {
+		clts();
+		task_thread_info(current)->status |= TS_USEDFPU;
+	}
+	err = fxrstor_checking((__force struct i387_fxsave_struct *)buf);
+	if (unlikely(err)) {
+		/*
+		 * Encountered an error while doing the restore from the
+		 * user buffer, clear the fpu state.
+		 */
+		clear_fpu(tsk);
+		clear_used_math();
+	}
+	return err;
+}
+#endif
+
 /*
  * Represents init state for the supported extended state.
  */
Index: tip-0728/include/asm-x86/i387.h
===================================================================
--- tip-0728.orig/include/asm-x86/i387.h	2008-07-28 18:31:15.000000000 -0700
+++ tip-0728/include/asm-x86/i387.h	2008-07-28 18:37:20.000000000 -0700
@@ -35,8 +35,9 @@
 #ifdef CONFIG_IA32_EMULATION
 extern unsigned int sig_xstate_ia32_size;
 struct _fpstate_ia32;
-extern int save_i387_ia32(struct _fpstate_ia32 __user *buf);
-extern int restore_i387_ia32(struct _fpstate_ia32 __user *buf);
+struct _xstate_ia32;
+extern int save_i387_xstate_ia32(void __user *buf);
+extern int restore_i387_xstate_ia32(void __user *buf);
 #endif
 
 #define X87_FSW_ES (1 << 7)	/* Exception Summary */
@@ -250,13 +251,13 @@
 	task_thread_info(tsk)->status &= ~TS_USEDFPU;
 }
 
+#endif	/* CONFIG_X86_64 */
+
 /*
  * Signal frame handlers...
  */
-extern int save_i387(struct _fpstate __user *buf);
-extern int restore_i387(struct _fpstate __user *buf);
-
-#endif	/* CONFIG_X86_64 */
+extern int save_i387_xstate(void __user *buf);
+extern int restore_i387_xstate(void __user *buf);
 
 static inline void __unlazy_fpu(struct task_struct *tsk)
 {
Index: tip-0728/arch/x86/ia32/ia32_signal.c
===================================================================
--- tip-0728.orig/arch/x86/ia32/ia32_signal.c	2008-07-28 18:35:50.000000000 -0700
+++ tip-0728/arch/x86/ia32/ia32_signal.c	2008-07-28 18:38:04.000000000 -0700
@@ -216,7 +216,7 @@
 				   unsigned int *peax)
 {
 	unsigned int tmpflags, gs, oldgs, err = 0;
-	struct _fpstate_ia32 __user *buf;
+	void __user *buf;
 	u32 tmp;
 
 	/* Always make any pending restarted system calls return -EINTR */
@@ -260,26 +260,12 @@
 
 	err |= __get_user(tmp, &sc->fpstate);
 	buf = compat_ptr(tmp);
-	if (buf) {
-		if (!access_ok(VERIFY_READ, buf, sizeof(*buf)))
-			goto badframe;
-		err |= restore_i387_ia32(buf);
-	} else {
-		struct task_struct *me = current;
-
-		if (used_math()) {
-			clear_fpu(me);
-			clear_used_math();
-		}
-	}
+	err |= restore_i387_xstate_ia32(buf);
 
 	err |= __get_user(tmp, &sc->ax);
 	*peax = tmp;
 
 	return err;
-
-badframe:
-	return 1;
 }
 
 asmlinkage long sys32_sigreturn(struct pt_regs *regs)
@@ -351,7 +337,7 @@
  */
 
 static int ia32_setup_sigcontext(struct sigcontext_ia32 __user *sc,
-				 struct _fpstate_ia32 __user *fpstate,
+				 void __user *fpstate,
 				 struct pt_regs *regs, unsigned int mask)
 {
 	int tmp, err = 0;
@@ -382,7 +368,7 @@
 	err |= __put_user((u32)regs->flags, &sc->flags);
 	err |= __put_user((u32)regs->sp, &sc->sp_at_signal);
 
-	tmp = save_i387_ia32(fpstate);
+	tmp = save_i387_xstate_ia32(fpstate);
 	if (tmp < 0)
 		err = -EFAULT;
 	else {
@@ -404,7 +390,7 @@
  */
 static void __user *get_sigframe(struct k_sigaction *ka, struct pt_regs *regs,
 				 size_t frame_size,
-				 struct _fpstate_ia32 **fpstate)
+				 void **fpstate)
 {
 	unsigned long sp;
 
@@ -441,7 +427,7 @@
 	struct sigframe __user *frame;
 	void __user *restorer;
 	int err = 0;
-	struct _fpstate_ia32 __user *fpstate = NULL;
+	void __user *fpstate = NULL;
 
 	/* copy_to_user optimizes that into a single 8 byte store */
 	static const struct {
@@ -529,7 +515,7 @@
 	struct rt_sigframe __user *frame;
 	void __user *restorer;
 	int err = 0;
-	struct _fpstate_ia32 __user *fpstate = NULL;
+	void __user *fpstate = NULL;
 
 	/* __copy_to_user optimizes that into a single 8 byte store */
 	static const struct {
Index: tip-0728/arch/x86/kernel/signal_32.c
===================================================================
--- tip-0728.orig/arch/x86/kernel/signal_32.c	2008-07-28 18:34:54.000000000 -0700
+++ tip-0728/arch/x86/kernel/signal_32.c	2008-07-28 18:37:20.000000000 -0700
@@ -161,28 +161,14 @@
 	}
 
 	{
-		struct _fpstate __user *buf;
+		void __user *buf;
 
 		err |= __get_user(buf, &sc->fpstate);
-		if (buf) {
-			if (!access_ok(VERIFY_READ, buf, sizeof(*buf)))
-				goto badframe;
-			err |= restore_i387(buf);
-		} else {
-			struct task_struct *me = current;
-
-			if (used_math()) {
-				clear_fpu(me);
-				clear_used_math();
-			}
-		}
+		err |= restore_i387_xstate(buf);
 	}
 
 	err |= __get_user(*pax, &sc->ax);
 	return err;
-
-badframe:
-	return 1;
 }
 
 asmlinkage unsigned long sys_sigreturn(unsigned long __unused)
@@ -264,7 +250,7 @@
  * Set up a signal frame.
  */
 static int
-setup_sigcontext(struct sigcontext __user *sc, struct _fpstate __user *fpstate,
+setup_sigcontext(struct sigcontext __user *sc, void __user *fpstate,
 		 struct pt_regs *regs, unsigned long mask)
 {
 	int tmp, err = 0;
@@ -291,7 +277,7 @@
 	err |= __put_user(regs->sp, &sc->sp_at_signal);
 	err |= __put_user(regs->ss, (unsigned int __user *)&sc->ss);
 
-	tmp = save_i387(fpstate);
+	tmp = save_i387_xstate(fpstate);
 	if (tmp < 0)
 		err = 1;
 	else
@@ -309,7 +295,7 @@
  */
 static inline void __user *
 get_sigframe(struct k_sigaction *ka, struct pt_regs *regs, size_t frame_size,
-	     struct _fpstate **fpstate)
+	     void **fpstate)
 {
 	unsigned long sp;
 
@@ -358,7 +344,7 @@
 	void __user *restorer;
 	int err = 0;
 	int usig;
-	struct _fpstate __user *fpstate = NULL;
+	void __user *fpstate = NULL;
 
 	frame = get_sigframe(ka, regs, sizeof(*frame), &fpstate);
 
@@ -436,7 +422,7 @@
 	void __user *restorer;
 	int err = 0;
 	int usig;
-	struct _fpstate __user *fpstate = NULL;
+	void __user *fpstate = NULL;
 
 	frame = get_sigframe(ka, regs, sizeof(*frame), &fpstate);
 
Index: tip-0728/arch/x86/kernel/signal_64.c
===================================================================
--- tip-0728.orig/arch/x86/kernel/signal_64.c	2008-07-28 18:31:15.000000000 -0700
+++ tip-0728/arch/x86/kernel/signal_64.c	2008-07-28 18:37:20.000000000 -0700
@@ -57,69 +57,6 @@
 }
 
 /*
- * Signal frame handlers.
- */
-
-static inline int save_i387(struct _fpstate __user *buf)
-{
-	struct task_struct *tsk = current;
-	int err = 0;
-
-	BUILD_BUG_ON(sizeof(struct user_i387_struct) !=
-			sizeof(tsk->thread.xstate->fxsave));
-
-	if ((unsigned long)buf % 16)
-		printk("save_i387: bad fpstate %p\n", buf);
-
-	if (!used_math())
-		return 0;
-	clear_used_math(); /* trigger finit */
-	if (task_thread_info(tsk)->status & TS_USEDFPU) {
-		err = save_i387_checking((struct i387_fxsave_struct __user *)
-					 buf);
-		if (err)
-			return err;
-		task_thread_info(tsk)->status &= ~TS_USEDFPU;
-		stts();
-	} else {
-		if (__copy_to_user(buf, &tsk->thread.xstate->fxsave,
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
-	struct task_struct *tsk = current;
-	int err;
-
-	if (!used_math()) {
-		err = init_fpu(tsk);
-		if (err)
-			return err;
-	}
-
-	if (!(task_thread_info(current)->status & TS_USEDFPU)) {
-		clts();
-		task_thread_info(current)->status |= TS_USEDFPU;
-	}
-	err = restore_fpu_checking((__force struct i387_fxsave_struct *)buf);
-	if (unlikely(err)) {
-		/*
-		 * Encountered an error while doing the restore from the
-		 * user buffer, clear the fpu state.
-		 */
-		clear_fpu(tsk);
-		clear_used_math();
-	}
-	return err;
-}
-
-/*
  * Do a signal return; undo the signal stack.
  */
 static int
@@ -163,25 +100,11 @@
 	{
 		struct _fpstate __user * buf;
 		err |= __get_user(buf, &sc->fpstate);
-
-		if (buf) {
-			if (!access_ok(VERIFY_READ, buf, sizeof(*buf)))
-				goto badframe;
-			err |= restore_i387(buf);
-		} else {
-			struct task_struct *me = current;
-			if (used_math()) {
-				clear_fpu(me);
-				clear_used_math();
-			}
-		}
+		err |= restore_i387_xstate(buf);
 	}
 
 	err |= __get_user(*pax, &sc->ax);
 	return err;
-
-badframe:
-	return 1;
 }
 
 asmlinkage long sys_rt_sigreturn(struct pt_regs *regs)
@@ -279,7 +202,7 @@
 			   sigset_t *set, struct pt_regs * regs)
 {
 	struct rt_sigframe __user *frame;
-	struct _fpstate __user *fp = NULL; 
+	void __user *fp = NULL;
 	int err = 0;
 	struct task_struct *me = current;
 
@@ -291,7 +214,7 @@
 		if (!access_ok(VERIFY_WRITE, fp, sizeof(struct _fpstate)))
 			goto give_sigsegv;
 
-		if (save_i387(fp) < 0) 
+		if (save_i387_xstate(fp) < 0)
 			err |= -1; 
 	} else
 		frame = get_stack(ka, regs, sizeof(struct rt_sigframe)) - 8;

-- 

