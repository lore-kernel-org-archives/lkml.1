Return-Path: <linux-kernel-owner+w=401wt.eu-S1760735AbYEWX0r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760735AbYEWX0r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 19:26:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754349AbYEWX0j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 19:26:39 -0400
Received: from mga11.intel.com ([192.55.52.93]:26670 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754216AbYEWX0i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 19:26:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,532,1204531200"; 
   d="scan'208";a="568145934"
Date: Fri, 23 May 2008 16:26:37 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: hpa@zytor.com, tglx@linutronix.de, mingo@elte.hu
Cc: linux-kernel@vger.kernel.org
Subject: [patch] x86: fix broken math-emu with lazy allocation of fpu area
Message-ID: <20080523232637.GF18385@linux-os.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the math emulation that got broken with the recent lazy allocation of FPU
area. init_fpu() need to be added for the math-emulation path aswell
for the FPU area allocation.

math emulation enabled kernel booted fine with this, in the presence
of "no387 nofxsr" boot param.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---

diff --git a/arch/x86/kernel/i387.c b/arch/x86/kernel/i387.c
index e03cc95..eb9ddd8 100644
--- a/arch/x86/kernel/i387.c
+++ b/arch/x86/kernel/i387.c
@@ -56,6 +56,11 @@ void __cpuinit mxcsr_feature_mask_init(void)
 
 void __init init_thread_xstate(void)
 {
+	if (!HAVE_HWFP) {
+		xstate_size = sizeof(struct i387_soft_struct);
+		return;
+	}
+
 	if (cpu_has_fxsr)
 		xstate_size = sizeof(struct i387_fxsave_struct);
 #ifdef CONFIG_X86_32
@@ -94,7 +99,7 @@ void __cpuinit fpu_init(void)
 int init_fpu(struct task_struct *tsk)
 {
 	if (tsk_used_math(tsk)) {
-		if (tsk == current)
+		if (HAVE_HWFP && tsk == current)
 			unlazy_fpu(tsk);
 		return 0;
 	}
@@ -109,6 +114,15 @@ int init_fpu(struct task_struct *tsk)
 			return -ENOMEM;
 	}
 
+#ifdef CONFIG_X86_32
+	if (!HAVE_HWFP) {
+		memset(tsk->thread.xstate, 0, xstate_size);
+		finit();
+		set_stopped_child_used_math(tsk);
+		return 0;
+	}
+#endif
+
 	if (cpu_has_fxsr) {
 		struct i387_fxsave_struct *fx = &tsk->thread.xstate->fxsave;
 
@@ -330,13 +344,13 @@ int fpregs_get(struct task_struct *target, const struct user_regset *regset,
 	struct user_i387_ia32_struct env;
 	int ret;
 
-	if (!HAVE_HWFP)
-		return fpregs_soft_get(target, regset, pos, count, kbuf, ubuf);
-
 	ret = init_fpu(target);
 	if (ret)
 		return ret;
 
+	if (!HAVE_HWFP)
+		return fpregs_soft_get(target, regset, pos, count, kbuf, ubuf);
+
 	if (!cpu_has_fxsr) {
 		return user_regset_copyout(&pos, &count, &kbuf, &ubuf,
 					   &target->thread.xstate->fsave, 0,
@@ -360,15 +374,15 @@ int fpregs_set(struct task_struct *target, const struct user_regset *regset,
 	struct user_i387_ia32_struct env;
 	int ret;
 
-	if (!HAVE_HWFP)
-		return fpregs_soft_set(target, regset, pos, count, kbuf, ubuf);
-
 	ret = init_fpu(target);
 	if (ret)
 		return ret;
 
 	set_stopped_child_used_math(target);
 
+	if (!HAVE_HWFP)
+		return fpregs_soft_set(target, regset, pos, count, kbuf, ubuf);
+
 	if (!cpu_has_fxsr) {
 		return user_regset_copyin(&pos, &count, &kbuf, &ubuf,
 					  &target->thread.xstate->fsave, 0, -1);
@@ -474,18 +488,18 @@ static int restore_i387_fxsave(struct _fpstate_ia32 __user *buf)
 int restore_i387_ia32(struct _fpstate_ia32 __user *buf)
 {
 	int err;
+	struct task_struct *tsk = current;
 
-	if (HAVE_HWFP) {
-		struct task_struct *tsk = current;
-
+	if (HAVE_HWFP)
 		clear_fpu(tsk);
 
-		if (!used_math()) {
-			err = init_fpu(tsk);
-			if (err)
-				return err;
-		}
+	if (!used_math()) {
+		err = init_fpu(tsk);
+		if (err)
+			return err;
+	}
 
+	if (HAVE_HWFP) {
 		if (cpu_has_fxsr)
 			err = restore_i387_fxsave(buf);
 		else
diff --git a/arch/x86/math-emu/fpu_entry.c b/arch/x86/math-emu/fpu_entry.c
index 6e38d87..c7b06fe 100644
--- a/arch/x86/math-emu/fpu_entry.c
+++ b/arch/x86/math-emu/fpu_entry.c
@@ -30,6 +30,7 @@
 #include <asm/uaccess.h>
 #include <asm/desc.h>
 #include <asm/user.h>
+#include <asm/i387.h>
 
 #include "fpu_system.h"
 #include "fpu_emu.h"
@@ -146,6 +147,13 @@ asmlinkage void math_emulate(long arg)
 	unsigned long code_limit = 0;	/* Initialized to stop compiler warnings */
 	struct desc_struct code_descriptor;
 
+	if (!used_math()) {
+		if (init_fpu(current)) {
+			do_group_exit(SIGKILL);
+			return;
+		}
+	}
+
 #ifdef RE_ENTRANT_CHECKING
 	if (emulating) {
 		printk("ERROR: wm-FPU-emu is not RE-ENTRANT!\n");
@@ -153,11 +161,6 @@ asmlinkage void math_emulate(long arg)
 	RE_ENTRANT_CHECK_ON;
 #endif /* RE_ENTRANT_CHECKING */
 
-	if (!used_math()) {
-		finit();
-		set_used_math();
-	}
-
 	SETUP_DATA_AREA(arg);
 
 	FPU_ORIG_EIP = FPU_EIP;
diff --git a/include/asm-x86/i387.h b/include/asm-x86/i387.h
index 6b722d3..37672f7 100644
--- a/include/asm-x86/i387.h
+++ b/include/asm-x86/i387.h
@@ -193,6 +193,8 @@ static inline int restore_i387(struct _fpstate __user *buf)
 
 #else  /* CONFIG_X86_32 */
 
+extern void finit(void);
+
 static inline void tolerant_fwait(void)
 {
 	asm volatile("fnclex ; fwait");
