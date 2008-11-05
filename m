Return-Path: <linux-kernel-owner+w=401wt.eu-S1755567AbYKEMbO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755567AbYKEMbO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 07:31:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751081AbYKEMa7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 07:30:59 -0500
Received: from cantor2.suse.de ([195.135.220.15]:37550 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750983AbYKEMa6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 07:30:58 -0500
From: Andreas Schwab <schwab@suse.de>
To: linuxppc-dev@ozlabs.org
Subject: [PATCH] Fix msr check in compat_sys_swapcontext
Cc: linux-kernel@vger.kernel.org
X-Yow: Finally, Zippy drives his 1958 RAMBLER METROPOLITAN into the
 faculty dining room.
Date: Wed, 05 Nov 2008 13:30:57 +0100
Message-ID: <jeprlabbi6.fsf@sykes.suse.de>
User-Agent: Gnus/5.110009 (No Gnus v0.9) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The new context may not be 16-byte aligned, so the real address of the
mcontext structure should be read from the uc_regs pointer instead of
directly using the (unaligned) uc_mcontext field.

Signed-off-by: Andreas Schwab <schwab@suse.de>

---
diff --git a/arch/powerpc/kernel/signal_32.c b/arch/powerpc/kernel/signal_32.c
index a6a4310..dc10720 100644
--- a/arch/powerpc/kernel/signal_32.c
+++ b/arch/powerpc/kernel/signal_32.c
@@ -941,9 +941,17 @@ long sys_swapcontext(struct ucontext __user *old_ctx,
 #ifdef CONFIG_PPC64
 	unsigned long new_msr = 0;
 
-	if (new_ctx &&
-	    get_user(new_msr, &new_ctx->uc_mcontext.mc_gregs[PT_MSR]))
-		return -EFAULT;
+	if (new_ctx) {
+		struct mcontext __user *mcp;
+		u32 cmcp;
+
+		/* Get pointer to the real mcontext. */
+		if (__get_user(cmcp, &new_ctx->uc_regs))
+			return -EFAULT;
+		mcp = (struct mcontext __user *)(u64)cmcp;
+		if (__get_user(new_msr, &mcp->mc_gregs[PT_MSR]))
+			return -EFAULT;
+	}
 	/*
 	 * Check that the context is not smaller than the original
 	 * size (with VMX but without VSX)

-- 
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
PGP key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
