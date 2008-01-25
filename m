Return-Path: <linux-kernel-owner+w=401wt.eu-S1754874AbYAYB7p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754874AbYAYB7p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 20:59:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752311AbYAYB7h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 20:59:37 -0500
Received: from mx1.redhat.com ([66.187.233.31]:50819 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752159AbYAYB7g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 20:59:36 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: mingo@elte.hu, tglx@linutronix.de
X-Fcc: ~/Mail/linus
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH x86/mm] x86: i387 fpregs_set convert_to_fxsr
In-Reply-To: Siddha, Suresh B's message of  Thursday, 24 January 2008 17:40:59 -0800 <20080125014059.GA5342@linux-os.sc.intel.com>
References: <20080125014059.GA5342@linux-os.sc.intel.com>
X-Zippy-Says: Okay, BARBRA STREISAND, I recognize you now!!  Also EFREM
    ZIMBALIST, JUNIOR!!  And BEAUMONT NEWHALL!!  Everybody into th'
    BATHROOM!
Message-Id: <20080125015933.587DF26F9FD@magilla.localdomain>
Date: Thu, 24 Jan 2008 17:59:33 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for catching that, Suresh.  
The fix needed a few nits different from your patch.


Thanks,
Roland

---

This fixes the bug introduced recently during the revamp of the code.
fpregs_set() needs to use convert_to_fxsr() rather than copying into the
fxsave struct directly.

Reported-by: Suresh Siddha <suresh.b.siddha@intel.com>
Signed-off-by: Roland McGrath <roland@redhat.com>
---
 arch/x86/kernel/i387.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/i387.c b/arch/x86/kernel/i387.c
index 7e354a3..26719bd 100644
--- a/arch/x86/kernel/i387.c
+++ b/arch/x86/kernel/i387.c
@@ -326,6 +326,7 @@ int fpregs_set(struct task_struct *target, const struct user_regset *regset,
 	       unsigned int pos, unsigned int count,
 	       const void *kbuf, const void __user *ubuf)
 {
+	struct user_i387_ia32_struct env;
 	int ret;
 
 	if (!HAVE_HWFP)
@@ -338,13 +339,12 @@ int fpregs_set(struct task_struct *target, const struct user_regset *regset,
 		return user_regset_copyin(&pos, &count, &kbuf, &ubuf,
 					  &target->thread.i387.fsave, 0, -1);
 
-	ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf,
-				 &target->thread.i387.fxsave, 0, -1);
+	if (pos > 0 || count < sizeof(env))
+		convert_from_fxsr(&env, target);
 
-	/*
-	 * mxcsr reserved bits must be masked to zero for security reasons.
-	 */
-	target->thread.i387.fxsave.mxcsr &= mxcsr_feature_mask;
+	ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf, &env, 0, -1);
+	if (!ret)
+		convert_to_fxsr(target, &env);
 
 	return ret;
 }
