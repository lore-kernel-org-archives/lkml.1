Return-Path: <linux-kernel-owner+w=401wt.eu-S1753907AbYGXSFj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753907AbYGXSFj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 14:05:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751950AbYGXSFc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 14:05:32 -0400
Received: from mga14.intel.com ([143.182.124.37]:2894 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751815AbYGXSFb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 14:05:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.31,247,1215414000"; 
   d="scan'208";a="600703756"
Date: Thu, 24 Jul 2008 11:04:29 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: x86@kernel.org, andi@firstfloor.org, torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [patch] x64, fpu: fix possible FPU leakage in error conditions
Message-ID: <20080724180429.GI14380@linux-os.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

restore_fpu_checking() calls init_fpu() in error conditions. init_fpu()
just touches the FPU state in the thread struct and doesn't do anything
with the live FPU registers. While this is wrong(as our main intention is
to init the live FPU registers aswell), this was benign
before the commit 92d140e21f1ce8cf99320afbbcad73879128e6dc.

Post commit 92d140e21f1ce8cf99320afbbcad73879128e6dc, live FPU registers
may not belong to this process at this error scenario.

In the error condition for restore_fpu_checking() (especially during
the 64bit signal return), we are doing init_fpu(), which saves the live
FPU register state (possibly belonging to some other process context) into the
thread struct (through unlazy_fpu() in init_fpu()). This is wrong and can leak
the FPU data.

Remove the unlazy_fpu() from the init_fpu(). init_fpu() will now always
init the FPU data in the thread struct. For the error conditions in
restore_fpu_checking(), restore the initialized FPU data from the thread
struct.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---

diff --git a/arch/x86/kernel/i387.c b/arch/x86/kernel/i387.c
index eb9ddd8..f5c2161 100644
--- a/arch/x86/kernel/i387.c
+++ b/arch/x86/kernel/i387.c
@@ -98,12 +98,6 @@ void __cpuinit fpu_init(void)
  */
 int init_fpu(struct task_struct *tsk)
 {
-	if (tsk_used_math(tsk)) {
-		if (HAVE_HWFP && tsk == current)
-			unlazy_fpu(tsk);
-		return 0;
-	}
-
 	/*
 	 * Memory allocation at the first usage of the FPU and other state.
 	 */
diff --git a/include/asm-x86/i387.h b/include/asm-x86/i387.h
index 37672f7..38af0ed 100644
--- a/include/asm-x86/i387.h
+++ b/include/asm-x86/i387.h
@@ -45,6 +45,12 @@ static inline void tolerant_fwait(void)
 		     _ASM_EXTABLE(1b, 2b));
 }
 
+static inline void restore_fpu(struct i387_fxsave_struct *fx)
+{
+	__asm__ __volatile__("rex64/fxrstor (%[fx])"
+			     :: [fx] "cdaSDb" (fx), "m" (*fx));
+}
+
 static inline int restore_fpu_checking(struct i387_fxsave_struct *fx)
 {
 	int err;
@@ -62,8 +68,10 @@ static inline int restore_fpu_checking(struct i387_fxsave_struct *fx)
 #else
 		     : [fx] "cdaSDb" (fx), "m" (*fx), "0" (0));
 #endif
-	if (unlikely(err))
+	if (unlikely(err)) {
 		init_fpu(current);
+		restore_fpu(&current->thread.xstate->fxsave);
+	}
 	return err;
 }
 
