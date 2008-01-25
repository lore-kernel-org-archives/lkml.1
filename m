Return-Path: <linux-kernel-owner+w=401wt.eu-S1753431AbYAYBlR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753431AbYAYBlR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 20:41:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752017AbYAYBlA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 20:41:00 -0500
Received: from mga11.intel.com ([192.55.52.93]:17190 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752002AbYAYBlA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 20:41:00 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,247,1199692800"; 
   d="scan'208";a="507863627"
Date: Thu, 24 Jan 2008 17:40:59 -0800
From: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
To: roland@redhat.com, linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, tglx@linutronix.de
Subject: [patch] x86, i387:  use convert_to_fxsr() in fpregs_set()
Message-ID: <20080125014059.GA5342@linux-os.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roland, Just happen to notice this bug. Can you please ack the bug fix which
needs to goto x86 mm tree.

thanks.
---
[patch] x86, i387: use convert_to_fxsr() in fpregs_set()

This fixes the bug introduced recently during the revamp of the code.
fpregs_set() need to use convert_to_fxsr() rather than copying into the
fxsave struct directly.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---

diff --git a/arch/x86/kernel/i387.c b/arch/x86/kernel/i387.c
index 7e354a3..93a1706 100644
--- a/arch/x86/kernel/i387.c
+++ b/arch/x86/kernel/i387.c
@@ -327,6 +327,7 @@ int fpregs_set(struct task_struct *target, const struct user_regset *regset,
 	       const void *kbuf, const void __user *ubuf)
 {
 	int ret;
+	struct user_i387_ia32_struct env;
 
 	if (!HAVE_HWFP)
 		return fpregs_soft_set(target, regset, pos, count, kbuf, ubuf);
@@ -339,13 +340,9 @@ int fpregs_set(struct task_struct *target, const struct user_regset *regset,
 					  &target->thread.i387.fsave, 0, -1);
 
 	ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf,
-				 &target->thread.i387.fxsave, 0, -1);
-
-	/*
-	 * mxcsr reserved bits must be masked to zero for security reasons.
-	 */
-	target->thread.i387.fxsave.mxcsr &= mxcsr_feature_mask;
+				 &env, 0, -1);
 
+	convert_to_fxsr(target, &env);
 	return ret;
 }
 
