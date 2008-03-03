Return-Path: <linux-kernel-owner+w=401wt.eu-S1762174AbYCCVJ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762174AbYCCVJ3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 16:09:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756771AbYCCVJT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 16:09:19 -0500
Received: from mga11.intel.com ([192.55.52.93]:53483 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755106AbYCCVJS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 16:09:18 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,439,1199692800"; 
   d="scan'208";a="303400992"
Date: Mon, 3 Mar 2008 13:01:08 -0800
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org, roland@redhat.com
Subject: [patch] x86, i387: fix ptrace leakage using init_fpu()
Message-ID: <20080303210108.GA28006@linux-os.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This needs to go into 2.6.25. Thanks.
---

This bug is introduced by the recent i387 merge.

Current usage of unlazy_fpu() in ptrace specific routines is wrong. unlazy_fpu()
will not init fpu if the task never used math. So the ptrace calls
can expose the parent tasks FPU data in some cases.

Replace it with the init_fpu() which will init the math state, if the task
never used math before.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---

diff --git a/arch/x86/kernel/i387.c b/arch/x86/kernel/i387.c
index 763dfc4..60fe801 100644
--- a/arch/x86/kernel/i387.c
+++ b/arch/x86/kernel/i387.c
@@ -132,7 +132,7 @@ int xfpregs_get(struct task_struct *target, const struct user_regset *regset,
 	if (!cpu_has_fxsr)
 		return -ENODEV;
 
-	unlazy_fpu(target);
+	init_fpu(target);
 
 	return user_regset_copyout(&pos, &count, &kbuf, &ubuf,
 				   &target->thread.i387.fxsave, 0, -1);
@@ -147,7 +147,7 @@ int xfpregs_set(struct task_struct *target, const struct user_regset *regset,
 	if (!cpu_has_fxsr)
 		return -ENODEV;
 
-	unlazy_fpu(target);
+	init_fpu(target);
 	set_stopped_child_used_math(target);
 
 	ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf,
@@ -307,7 +307,7 @@ int fpregs_get(struct task_struct *target, const struct user_regset *regset,
 	if (!HAVE_HWFP)
 		return fpregs_soft_get(target, regset, pos, count, kbuf, ubuf);
 
-	unlazy_fpu(target);
+	init_fpu(target);
 
 	if (!cpu_has_fxsr)
 		return user_regset_copyout(&pos, &count, &kbuf, &ubuf,
@@ -332,7 +332,7 @@ int fpregs_set(struct task_struct *target, const struct user_regset *regset,
 	if (!HAVE_HWFP)
 		return fpregs_soft_set(target, regset, pos, count, kbuf, ubuf);
 
-	unlazy_fpu(target);
+	init_fpu(target);
 	set_stopped_child_used_math(target);
 
 	if (!cpu_has_fxsr)
