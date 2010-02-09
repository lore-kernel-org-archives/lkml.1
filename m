Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752090Ab0BIU21 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 15:28:27 -0500
Received: from mga11.intel.com ([192.55.52.93]:56226 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751455Ab0BIU2Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 15:28:25 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,438,1262592000"; 
   d="scan'208";a="539273816"
Message-Id: <20100209202502.310242237@sbs-t61.sc.intel.com>
User-Agent: quilt/0.47-1
Date: Tue, 09 Feb 2010 12:13:12 -0800
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, hjl.tools@gmail.com,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [patch v2 3/4] x86, ptrace: prepare regset get/set routines for user specified lengths
References: <20100209201309.902050211@sbs-t61.sc.intel.com>
Content-Disposition: inline; filename=prepare_for_ptrace_get_set_regset.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prepare the x86 regset routines for the upcoming generic
PTRACE_GETREGSET/PTRACE_SETREGSET commands. These commands allow the user
to specify how much to read and hence the kernel needs to ensure that
the get/set routines of the regset don't allow the user to access more kernel
buffers than needed.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---
 arch/x86/kernel/i387.c |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

Index: tip/arch/x86/kernel/i387.c
===================================================================
--- tip.orig/arch/x86/kernel/i387.c
+++ tip/arch/x86/kernel/i387.c
@@ -184,6 +184,7 @@ int xfpregs_get(struct task_struct *targ
 		void *kbuf, void __user *ubuf)
 {
 	int ret;
+	int size = regset->n * regset->size;
 
 	if (!cpu_has_fxsr)
 		return -ENODEV;
@@ -193,7 +194,7 @@ int xfpregs_get(struct task_struct *targ
 		return ret;
 
 	return user_regset_copyout(&pos, &count, &kbuf, &ubuf,
-				   &target->thread.xstate->fxsave, 0, -1);
+				   &target->thread.xstate->fxsave, 0, size);
 }
 
 int xfpregs_set(struct task_struct *target, const struct user_regset *regset,
@@ -201,6 +202,7 @@ int xfpregs_set(struct task_struct *targ
 		const void *kbuf, const void __user *ubuf)
 {
 	int ret;
+	int size = regset->n * regset->size;
 
 	if (!cpu_has_fxsr)
 		return -ENODEV;
@@ -210,7 +212,7 @@ int xfpregs_set(struct task_struct *targ
 		return ret;
 
 	ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf,
-				 &target->thread.xstate->fxsave, 0, -1);
+				 &target->thread.xstate->fxsave, 0, size);
 
 	/*
 	 * mxcsr reserved bits must be masked to zero for security reasons.
@@ -452,6 +454,7 @@ int fpregs_get(struct task_struct *targe
 	       void *kbuf, void __user *ubuf)
 {
 	struct user_i387_ia32_struct env;
+	int size = regset->n * regset->size;
 	int ret;
 
 	ret = init_fpu(target);
@@ -464,7 +467,7 @@ int fpregs_get(struct task_struct *targe
 	if (!cpu_has_fxsr) {
 		return user_regset_copyout(&pos, &count, &kbuf, &ubuf,
 					   &target->thread.xstate->fsave, 0,
-					   -1);
+					   size);
 	}
 
 	if (kbuf && pos == 0 && count == sizeof(env)) {
@@ -482,6 +485,7 @@ int fpregs_set(struct task_struct *targe
 	       const void *kbuf, const void __user *ubuf)
 {
 	struct user_i387_ia32_struct env;
+	int size = regset->n * regset->size;
 	int ret;
 
 	ret = init_fpu(target);
@@ -495,13 +499,14 @@ int fpregs_set(struct task_struct *targe
 
 	if (!cpu_has_fxsr) {
 		return user_regset_copyin(&pos, &count, &kbuf, &ubuf,
-					  &target->thread.xstate->fsave, 0, -1);
+					  &target->thread.xstate->fsave, 0,
+					  size);
 	}
 
 	if (pos > 0 || count < sizeof(env))
 		convert_from_fxsr(&env, target);
 
-	ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf, &env, 0, -1);
+	ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf, &env, 0, size);
 	if (!ret)
 		convert_to_fxsr(target, &env);
 


