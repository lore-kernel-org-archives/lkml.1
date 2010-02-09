Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754621Ab0BIWzc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 17:55:32 -0500
Received: from hera.kernel.org ([140.211.167.34]:34804 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753761Ab0BIWza (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 17:55:30 -0500
Date: Tue, 9 Feb 2010 22:55:13 GMT
From: tip-bot for Suresh Siddha <suresh.b.siddha@intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       suresh.b.siddha@intel.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       suresh.b.siddha@intel.com, tglx@linutronix.de
In-Reply-To: <20100209202502.310242237@sbs-t61.sc.intel.com>
References: <20100209202502.310242237@sbs-t61.sc.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/ptrace] x86, ptrace: Prepare regset get/set routines for user specified lengths
Message-ID: <tip-a6bf9383255e088f5a78d93e2f8cd871aa028060@git.kernel.org>
Git-Commit-ID: a6bf9383255e088f5a78d93e2f8cd871aa028060
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 09 Feb 2010 22:55:15 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a6bf9383255e088f5a78d93e2f8cd871aa028060
Gitweb:     http://git.kernel.org/tip/a6bf9383255e088f5a78d93e2f8cd871aa028060
Author:     Suresh Siddha <suresh.b.siddha@intel.com>
AuthorDate: Tue, 9 Feb 2010 12:13:12 -0800
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Tue, 9 Feb 2010 14:09:58 -0800

x86, ptrace: Prepare regset get/set routines for user specified lengths

Prepare the x86 regset routines for the upcoming generic
PTRACE_GETREGSET/PTRACE_SETREGSET commands. These commands allow the user
to specify how much to read and hence the kernel needs to ensure that
the get/set routines of the regset don't allow the user to access more kernel
buffers than needed.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
LKML-Reference: <20100209202502.310242237@sbs-t61.sc.intel.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/kernel/i387.c |   15 ++++++++++-----
 1 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/i387.c b/arch/x86/kernel/i387.c
index 4719bf9..23efdef 100644
--- a/arch/x86/kernel/i387.c
+++ b/arch/x86/kernel/i387.c
@@ -184,6 +184,7 @@ int xfpregs_get(struct task_struct *target, const struct user_regset *regset,
 		void *kbuf, void __user *ubuf)
 {
 	int ret;
+	int size = regset->n * regset->size;
 
 	if (!cpu_has_fxsr)
 		return -ENODEV;
@@ -193,7 +194,7 @@ int xfpregs_get(struct task_struct *target, const struct user_regset *regset,
 		return ret;
 
 	return user_regset_copyout(&pos, &count, &kbuf, &ubuf,
-				   &target->thread.xstate->fxsave, 0, -1);
+				   &target->thread.xstate->fxsave, 0, size);
 }
 
 int xfpregs_set(struct task_struct *target, const struct user_regset *regset,
@@ -201,6 +202,7 @@ int xfpregs_set(struct task_struct *target, const struct user_regset *regset,
 		const void *kbuf, const void __user *ubuf)
 {
 	int ret;
+	int size = regset->n * regset->size;
 
 	if (!cpu_has_fxsr)
 		return -ENODEV;
@@ -210,7 +212,7 @@ int xfpregs_set(struct task_struct *target, const struct user_regset *regset,
 		return ret;
 
 	ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf,
-				 &target->thread.xstate->fxsave, 0, -1);
+				 &target->thread.xstate->fxsave, 0, size);
 
 	/*
 	 * mxcsr reserved bits must be masked to zero for security reasons.
@@ -452,6 +454,7 @@ int fpregs_get(struct task_struct *target, const struct user_regset *regset,
 	       void *kbuf, void __user *ubuf)
 {
 	struct user_i387_ia32_struct env;
+	int size = regset->n * regset->size;
 	int ret;
 
 	ret = init_fpu(target);
@@ -464,7 +467,7 @@ int fpregs_get(struct task_struct *target, const struct user_regset *regset,
 	if (!cpu_has_fxsr) {
 		return user_regset_copyout(&pos, &count, &kbuf, &ubuf,
 					   &target->thread.xstate->fsave, 0,
-					   -1);
+					   size);
 	}
 
 	if (kbuf && pos == 0 && count == sizeof(env)) {
@@ -482,6 +485,7 @@ int fpregs_set(struct task_struct *target, const struct user_regset *regset,
 	       const void *kbuf, const void __user *ubuf)
 {
 	struct user_i387_ia32_struct env;
+	int size = regset->n * regset->size;
 	int ret;
 
 	ret = init_fpu(target);
@@ -495,13 +499,14 @@ int fpregs_set(struct task_struct *target, const struct user_regset *regset,
 
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
 
