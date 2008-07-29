Return-Path: <linux-kernel-owner+w=401wt.eu-S1760041AbYG2Rmb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760041AbYG2Rmb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 13:42:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754194AbYG2Rk2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 13:40:28 -0400
Received: from mga09.intel.com ([134.134.136.24]:6214 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753122AbYG2RkY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 13:40:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.31,273,1215414000"; 
   d="scan'208";a="423495877"
Message-Id: <20080729173158.381497000@linux-os.sc.intel.com>
References: <20080729172917.185593000@linux-os.sc.intel.com>
User-Agent: quilt/0.46-1
Date: Tue, 29 Jul 2008 10:29:25 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       arjan@linux.intel.com, roland@redhat.com, drepper@redhat.com,
       mikpe@it.uu.se, chrisw@sous-sol.org, andi@firstfloor.org
Cc: linux-kernel@vger.kernel.org, suresh.b.siddha@intel.com
Subject: [patch 8/9] x86, xsave: save/restore the extended state context in sigframe
Content-Disposition: inline; filename=extended_fpstate_in_sigcontext.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On cpu's supporting xsave/xrstor, fpstate pointer in the sigcontext, will
include the extended state information along with fpstate information. Presence
of extended state information is indicated by the presence
of FP_XSTATE_MAGIC1 at fpstate.sw_reserved.magic1 and FP_XSTATE_MAGIC2
at fpstate + (fpstate.sw_reserved.extended_size - FP_XSTATE_MAGIC2_SIZE).

Extended feature bit mask that is saved in the memory layout is represented
by the fpstate.sw_reserved.xstate_bv

For RT signal frames, UC_FP_XSTATE in the uc_flags also indicate the
presence of extended state information in the sigcontext's fpstate
pointer.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---

Index: tip-0728/arch/x86/kernel/xsave.c
===================================================================
--- tip-0728.orig/arch/x86/kernel/xsave.c	2008-07-28 18:50:02.000000000 -0700
+++ tip-0728/arch/x86/kernel/xsave.c	2008-07-28 18:51:24.000000000 -0700
@@ -6,12 +6,68 @@
 #include <linux/bootmem.h>
 #include <linux/compat.h>
 #include <asm/i387.h>
+#ifdef CONFIG_IA32_EMULATION
+#include <asm/sigcontext32.h>
+#endif
 
 /*
  * Supported feature mask by the CPU and the kernel.
  */
 unsigned int pcntxt_hmask, pcntxt_lmask;
 
+struct _fpx_sw_bytes fx_sw_reserved;
+#ifdef CONFIG_IA32_EMULATION
+struct _fpx_sw_bytes fx_sw_reserved_ia32;
+#endif
+
+/*
+ * Check for the presence of extended state information in the
+ * user fpstate pointer in the sigcontext.
+ */
+int check_for_xstate(struct i387_fxsave_struct __user *buf,
+		     void __user *fpstate,
+		     struct _fpx_sw_bytes *fx_sw_user)
+{
+	int min_xstate_size = sizeof(struct i387_fxsave_struct) +
+			      sizeof(struct xsave_hdr_struct);
+	unsigned int magic2;
+	int err;
+
+	err = __copy_from_user(fx_sw_user, &buf->sw_reserved[0],
+			       sizeof(struct _fpx_sw_bytes));
+
+	if (err)
+		return err;
+
+	/*
+	 * First Magic check failed.
+	 */
+	if (fx_sw_user->magic1 != FP_XSTATE_MAGIC1)
+		return -1;
+
+	/*
+	 * Check for error scenarios.
+	 */
+	if (fx_sw_user->xstate_size < min_xstate_size ||
+	    fx_sw_user->xstate_size > xstate_size ||
+	    fx_sw_user->xstate_size > fx_sw_user->extended_size)
+		return -1;
+
+	err = __get_user(magic2, (__u32 *) (((void *)fpstate) +
+					    fx_sw_user->extended_size -
+					    FP_XSTATE_MAGIC2_SIZE));
+	/*
+	 * Check for the presence of second magic word at the end of memory
+	 * layout. This detects the case where the user just copied the legacy
+	 * fpstate layout with out copying the extended state information
+	 * in the memory layout.
+	 */
+	if (err || magic2 != FP_XSTATE_MAGIC2)
+		return -1;
+
+	return 0;
+}
+
 #ifdef CONFIG_X86_64
 /*
  * Signal frame handlers.
@@ -28,15 +84,18 @@
 	BUILD_BUG_ON(sizeof(struct user_i387_struct) !=
 			sizeof(tsk->thread.xstate->fxsave));
 
-	if ((unsigned long)buf % 16)
+	if ((unsigned long)buf % 64)
 		printk("save_i387_xstate: bad fpstate %p\n", buf);
 
 	if (!used_math())
 		return 0;
 	clear_used_math(); /* trigger finit */
 	if (task_thread_info(tsk)->status & TS_USEDFPU) {
-		err = save_i387_checking((struct i387_fxsave_struct __user *)
-					 buf);
+		if (task_thread_info(tsk)->status & TS_XSAVE)
+			err = xsave_user(buf);
+		else
+			err = fxsave_user(buf);
+
 		if (err)
 			return err;
 		task_thread_info(tsk)->status &= ~TS_USEDFPU;
@@ -46,23 +105,77 @@
 				   xstate_size))
 			return -1;
 	}
+
+	if (task_thread_info(tsk)->status & TS_XSAVE) {
+		struct _fpstate __user *fx = buf;
+
+		err = __copy_to_user(&fx->sw_reserved, &fx_sw_reserved,
+				     sizeof(struct _fpx_sw_bytes));
+
+		err |= __put_user(FP_XSTATE_MAGIC2,
+				  (__u32 __user *) (buf + sig_xstate_size
+						    - FP_XSTATE_MAGIC2_SIZE));
+	}
+
 	return 1;
 }
 
 /*
+ * Restore the extended state if present. Otherwise, restore the FP/SSE
+ * state.
+ */
+int restore_user_xstate(void __user *buf)
+{
+	struct _fpx_sw_bytes fx_sw_user;
+	unsigned int lmask, hmask;
+	int err;
+
+	if (((unsigned long)buf % 64) ||
+	     check_for_xstate(buf, buf, &fx_sw_user))
+		goto fx_only;
+
+	lmask = fx_sw_user.xstate_bv;
+	hmask = fx_sw_user.xstate_bv >> 32;
+
+	/*
+	 * restore the state passed by the user.
+	 */
+	err = xrestore_user(buf, lmask, hmask);
+	if (err)
+		return err;
+
+	/*
+	 * init the state skipped by the user.
+	 */
+	lmask = pcntxt_lmask & ~lmask;
+	hmask = pcntxt_hmask & ~hmask;
+
+	xrstor_state(init_xstate_buf, lmask, hmask);
+
+	return 0;
+
+fx_only:
+	/*
+	 * couldn't find the extended state information in the
+	 * memory layout. Restore just the FP/SSE and init all
+	 * the other extended state.
+	 */
+	xrstor_state(init_xstate_buf, pcntxt_lmask & ~XSTATE_FPSSE,
+		     pcntxt_hmask);
+	return fxrstor_checking((__force struct i387_fxsave_struct *)buf);
+}
+
+/*
  * This restores directly out of user space. Exceptions are handled.
  */
 int restore_i387_xstate(void __user *buf)
 {
 	struct task_struct *tsk = current;
-	int err;
+	int err = 0;
 
 	if (!buf) {
-		if (used_math()) {
-			clear_fpu(tsk);
-			clear_used_math();
-		}
-
+		if (used_math())
+			goto clear;
 		return 0;
 	} else
 		if (!access_ok(VERIFY_READ, buf, sig_xstate_size))
@@ -78,12 +191,17 @@
 		clts();
 		task_thread_info(current)->status |= TS_USEDFPU;
 	}
-	err = fxrstor_checking((__force struct i387_fxsave_struct *)buf);
+	if (task_thread_info(tsk)->status & TS_XSAVE)
+		err = restore_user_xstate(buf);
+	else
+		err = fxrstor_checking((__force struct i387_fxsave_struct *)
+				       buf);
 	if (unlikely(err)) {
 		/*
 		 * Encountered an error while doing the restore from the
 		 * user buffer, clear the fpu state.
 		 */
+clear:
 		clear_fpu(tsk);
 		clear_used_math();
 	}
@@ -92,6 +210,38 @@
 #endif
 
 /*
+ * Prepare the SW reserved portion of the fxsave memory layout, indicating
+ * the presence of the extended state information in the memory layout
+ * pointed by the fpstate pointer in the sigcontext.
+ * This will be saved when ever the FP and extended state context is
+ * saved on the user stack during the signal handler delivery to the user.
+ */
+void prepare_fx_sw_frame(void)
+{
+	int size_extended = (xstate_size - sizeof(struct i387_fxsave_struct)) +
+			     FP_XSTATE_MAGIC2_SIZE;
+
+	sig_xstate_size = sizeof(struct _fpstate) + size_extended;
+
+#ifdef CONFIG_IA32_EMULATION
+	sig_xstate_ia32_size = sizeof(struct _fpstate_ia32) + size_extended;
+#endif
+
+	memset(&fx_sw_reserved, 0, sizeof(fx_sw_reserved));
+
+	fx_sw_reserved.magic1 = FP_XSTATE_MAGIC1;
+	fx_sw_reserved.extended_size = sig_xstate_size;
+	fx_sw_reserved.xstate_bv = pcntxt_lmask |
+					 (((u64) (pcntxt_hmask)) << 32);
+	fx_sw_reserved.xstate_size = xstate_size;
+#ifdef CONFIG_IA32_EMULATION
+	memcpy(&fx_sw_reserved_ia32, &fx_sw_reserved,
+	       sizeof(struct _fpx_sw_bytes));
+	fx_sw_reserved_ia32.extended_size = sig_xstate_ia32_size;
+#endif
+}
+
+/*
  * Represents init state for the supported extended state.
  */
 struct xsave_struct *init_xstate_buf;
@@ -162,6 +312,8 @@
 
 	xstate_size = ebx;
 
+	prepare_fx_sw_frame();
+
 	setup_xstate_init();
 
 	printk(KERN_INFO "xsave/xrstor: enabled xstate_bv %Lx, cntxt size %x\n",
Index: tip-0728/arch/x86/kernel/i387.c
===================================================================
--- tip-0728.orig/arch/x86/kernel/i387.c	2008-07-28 18:50:02.000000000 -0700
+++ tip-0728/arch/x86/kernel/i387.c	2008-07-28 18:50:08.000000000 -0700
@@ -26,6 +26,7 @@
 # define _fpstate_ia32		_fpstate
 # define _xstate_ia32		_xstate
 # define sig_xstate_ia32_size   sig_xstate_size
+# define fx_sw_reserved_ia32	fx_sw_reserved
 # define user_i387_ia32_struct	user_i387_struct
 # define user32_fxsr_struct	user_fxsr_struct
 #endif
@@ -447,12 +448,30 @@
 	if (err)
 		return -1;
 
-	if (__copy_to_user(&buf->_fxsr_env[0], fx,
-			   sizeof(struct i387_fxsave_struct)))
+	if (__copy_to_user(&buf->_fxsr_env[0], fx, xstate_size))
 		return -1;
 	return 1;
 }
 
+static int save_i387_xsave(void __user *buf)
+{
+	struct _fpstate_ia32 __user *fx = buf;
+	int err = 0;
+
+	if (save_i387_fxsave(fx) < 0)
+		return -1;
+
+	err = __copy_to_user(&fx->sw_reserved, &fx_sw_reserved_ia32,
+			     sizeof(struct _fpx_sw_bytes));
+	err |= __put_user(FP_XSTATE_MAGIC2,
+			  (__u32 __user *) (buf + sig_xstate_ia32_size
+					    - FP_XSTATE_MAGIC2_SIZE));
+	if (err)
+		return -1;
+
+	return 1;
+}
+
 int save_i387_xstate_ia32(void __user *buf)
 {
 	struct _fpstate_ia32 __user *fp = (struct _fpstate_ia32 __user *) buf;
@@ -477,6 +496,8 @@
 
 	unlazy_fpu(tsk);
 
+	if (cpu_has_xsave)
+		return save_i387_xsave(fp);
 	if (cpu_has_fxsr)
 		return save_i387_fxsave(fp);
 	else
@@ -491,14 +512,15 @@
 				sizeof(struct i387_fsave_struct));
 }
 
-static int restore_i387_fxsave(struct _fpstate_ia32 __user *buf)
+static int restore_i387_fxsave(struct _fpstate_ia32 __user *buf,
+			       unsigned int size)
 {
 	struct task_struct *tsk = current;
 	struct user_i387_ia32_struct env;
 	int err;
 
 	err = __copy_from_user(&tsk->thread.xstate->fxsave, &buf->_fxsr_env[0],
-			       sizeof(struct i387_fxsave_struct));
+			       size);
 	/* mxcsr reserved bits must be masked to zero for security reasons */
 	tsk->thread.xstate->fxsave.mxcsr &= mxcsr_feature_mask;
 	if (err || __copy_from_user(&env, buf, sizeof(env)))
@@ -508,6 +530,51 @@
 	return 0;
 }
 
+static int restore_i387_xsave(void __user *buf)
+{
+	struct _fpx_sw_bytes fx_sw_user;
+	struct _fpstate_ia32 __user *fx_user =
+			((struct _fpstate_ia32 __user *) buf);
+	struct i387_fxsave_struct __user *fx =
+		(struct i387_fxsave_struct __user *) &fx_user->_fxsr_env[0];
+	struct xsave_hdr_struct *xsave_hdr =
+				&current->thread.xstate->xsave.xsave_hdr;
+	unsigned int lmask, hmask;
+	int err;
+
+	if (check_for_xstate(fx, buf, &fx_sw_user))
+		goto fx_only;
+
+	lmask = fx_sw_user.xstate_bv;
+	hmask = fx_sw_user.xstate_bv >> 32;
+
+	err = restore_i387_fxsave(buf, fx_sw_user.xstate_size);
+
+	xsave_hdr->xstate_bv &=  (pcntxt_lmask | (((u64) pcntxt_hmask) << 32));
+	/*
+	 * These bits must be zero.
+	 */
+	xsave_hdr->reserved1[0] = xsave_hdr->reserved1[1] = 0;
+
+	/*
+	 * Init the state that is not present in the memory layout
+	 * and enabled by the OS.
+	 */
+	lmask = ~(pcntxt_lmask & ~lmask);
+	hmask = ~(pcntxt_hmask & ~hmask);
+	xsave_hdr->xstate_bv &=  (lmask | (((u64) hmask) << 32));
+
+	return err;
+fx_only:
+	/*
+	 * Couldn't find the extended state information in the memory
+	 * layout. Restore the FP/SSE and init the other extended state
+	 * enabled by the OS.
+	 */
+	xsave_hdr->xstate_bv = XSTATE_FPSSE;
+	return restore_i387_fxsave(buf, sizeof(struct i387_fxsave_struct));
+}
+
 int restore_i387_xstate_ia32(void __user *buf)
 {
 	int err;
@@ -535,8 +602,11 @@
 	}
 
 	if (HAVE_HWFP) {
-		if (cpu_has_fxsr)
-			err = restore_i387_fxsave(fp);
+		if (cpu_has_xsave)
+			err = restore_i387_xsave(buf);
+		else if (cpu_has_fxsr)
+			err = restore_i387_fxsave(fp, sizeof(struct
+							   i387_fxsave_struct));
 		else
 			err = restore_i387_fsave(fp);
 	} else {
Index: tip-0728/arch/x86/kernel/signal_64.c
===================================================================
--- tip-0728.orig/arch/x86/kernel/signal_64.c	2008-07-28 18:50:02.000000000 -0700
+++ tip-0728/arch/x86/kernel/signal_64.c	2008-07-28 18:50:08.000000000 -0700
@@ -195,7 +195,7 @@
 			sp = current->sas_ss_sp + current->sas_ss_size;
 	}
 
-	return (void __user *)round_down(sp - size, 16);
+	return (void __user *)round_down(sp - size, 64);
 }
 
 static int setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
@@ -229,7 +229,10 @@
 	}
 		
 	/* Create the ucontext.  */
-	err |= __put_user(0, &frame->uc.uc_flags);
+	if (cpu_has_xsave)
+		err |= __put_user(UC_FP_XSTATE, &frame->uc.uc_flags);
+	else
+		err |= __put_user(0, &frame->uc.uc_flags);
 	err |= __put_user(0, &frame->uc.uc_link);
 	err |= __put_user(me->sas_ss_sp, &frame->uc.uc_stack.ss_sp);
 	err |= __put_user(sas_ss_flags(regs->sp),
Index: tip-0728/include/asm-x86/i387.h
===================================================================
--- tip-0728.orig/include/asm-x86/i387.h	2008-07-28 18:50:02.000000000 -0700
+++ tip-0728/include/asm-x86/i387.h	2008-07-28 18:50:08.000000000 -0700
@@ -32,8 +32,10 @@
 extern user_regset_get_fn fpregs_get, xfpregs_get, fpregs_soft_get;
 extern user_regset_set_fn fpregs_set, xfpregs_set, fpregs_soft_set;
 
+extern struct _fpx_sw_bytes fx_sw_reserved;
 #ifdef CONFIG_IA32_EMULATION
 extern unsigned int sig_xstate_ia32_size;
+extern struct _fpx_sw_bytes fx_sw_reserved_ia32;
 struct _fpstate_ia32;
 struct _xstate_ia32;
 extern int save_i387_xstate_ia32(void __user *buf);
@@ -105,7 +107,7 @@
 			  X86_FEATURE_FXSAVE_LEAK);
 }
 
-static inline int save_i387_checking(struct i387_fxsave_struct __user *fx)
+static inline int fxsave_user(struct i387_fxsave_struct __user *fx)
 {
 	int err;
 
Index: tip-0728/include/asm-x86/xsave.h
===================================================================
--- tip-0728.orig/include/asm-x86/xsave.h	2008-07-28 18:50:02.000000000 -0700
+++ tip-0728/include/asm-x86/xsave.h	2008-07-28 18:50:08.000000000 -0700
@@ -29,6 +29,9 @@
 extern void xsave_cntxt_init(void);
 extern void xsave_init(void);
 extern int init_fpu(struct task_struct *child);
+extern int check_for_xstate(struct i387_fxsave_struct __user *buf,
+			    void __user *fpstate,
+			    struct _fpx_sw_bytes *sw);
 
 static inline int xrstor_checking(struct xsave_struct *fx)
 {
@@ -48,7 +51,7 @@
 	return err;
 }
 
-static inline int xsave_check(struct xsave_struct __user *buf)
+static inline int xsave_user(struct xsave_struct __user *buf)
 {
 	int err;
 	__asm__ __volatile__("1: .byte " REX_PREFIX "0x0f,0xae,0x27\n"
Index: tip-0728/include/asm-x86/ucontext.h
===================================================================
--- tip-0728.orig/include/asm-x86/ucontext.h	2008-07-28 18:49:10.000000000 -0700
+++ tip-0728/include/asm-x86/ucontext.h	2008-07-28 18:50:08.000000000 -0700
@@ -1,6 +1,12 @@
 #ifndef ASM_X86__UCONTEXT_H
 #define ASM_X86__UCONTEXT_H
 
+#define UC_FP_XSTATE	0x1	/* indicates the presence of extended state
+				 * information in the memory layout pointed
+				 * by the fpstate pointer in the ucontext's
+				 * sigcontext struct (uc_mcontext).
+				 */
+
 struct ucontext {
 	unsigned long	  uc_flags;
 	struct ucontext  *uc_link;
Index: tip-0728/arch/x86/ia32/ia32_signal.c
===================================================================
--- tip-0728.orig/arch/x86/ia32/ia32_signal.c	2008-07-28 18:50:02.000000000 -0700
+++ tip-0728/arch/x86/ia32/ia32_signal.c	2008-07-28 18:50:08.000000000 -0700
@@ -544,7 +544,10 @@
 		goto give_sigsegv;
 
 	/* Create the ucontext.  */
-	err |= __put_user(0, &frame->uc.uc_flags);
+	if (cpu_has_xsave)
+		err |= __put_user(UC_FP_XSTATE, &frame->uc.uc_flags);
+	else
+		err |= __put_user(0, &frame->uc.uc_flags);
 	err |= __put_user(0, &frame->uc.uc_link);
 	err |= __put_user(current->sas_ss_sp, &frame->uc.uc_stack.ss_sp);
 	err |= __put_user(sas_ss_flags(regs->sp),
Index: tip-0728/arch/x86/kernel/signal_32.c
===================================================================
--- tip-0728.orig/arch/x86/kernel/signal_32.c	2008-07-28 18:50:02.000000000 -0700
+++ tip-0728/arch/x86/kernel/signal_32.c	2008-07-28 18:50:08.000000000 -0700
@@ -443,7 +443,10 @@
 		goto give_sigsegv;
 
 	/* Create the ucontext.  */
-	err |= __put_user(0, &frame->uc.uc_flags);
+	if (cpu_has_xsave)
+		err |= __put_user(UC_FP_XSTATE, &frame->uc.uc_flags);
+	else
+		err |= __put_user(0, &frame->uc.uc_flags);
 	err |= __put_user(0, &frame->uc.uc_link);
 	err |= __put_user(current->sas_ss_sp, &frame->uc.uc_stack.ss_sp);
 	err |= __put_user(sas_ss_flags(regs->sp),

-- 

