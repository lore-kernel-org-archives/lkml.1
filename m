Return-Path: <linux-kernel-owner+w=401wt.eu-S1753900AbYKFKtY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753900AbYKFKtY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 05:49:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754671AbYKFKtE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 05:49:04 -0500
Received: from ns1.suse.de ([195.135.220.2]:59500 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754501AbYKFKtD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 05:49:03 -0500
From: Andreas Schwab <schwab@suse.de>
To: Paul Mackerras <paulus@samba.org>
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix msr check in compat_sys_swapcontext
References: <jeprlabbi6.fsf@sykes.suse.de>
	<18706.16317.759662.855430@cargo.ozlabs.ibm.com>
	<jey6zx9piz.fsf@sykes.suse.de>
	<18706.51381.987014.370948@cargo.ozlabs.ibm.com>
X-Yow: This is my WILLIAM BENDIX memorial CORNER where I worship William
 Bendix like a GOD!!
Date: Thu, 06 Nov 2008 11:49:00 +0100
In-Reply-To: <18706.51381.987014.370948@cargo.ozlabs.ibm.com> (Paul
	Mackerras's message of "Thu, 6 Nov 2008 21:36:37 +1100")
Message-ID: <jek5bh9lk3.fsf@sykes.suse.de>
User-Agent: Gnus/5.110009 (No Gnus v0.9) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Mackerras <paulus@samba.org> writes:

> Andreas Schwab writes:
>
>> Paul Mackerras <paulus@samba.org> writes:
>> 
>> > we need to use get_user, not __get_user, since we haven't done an
>> > access_ok() check on the address.
>> 
>> The address is always ok since its a compat pointer, see do_setcontext.
>
> OK, since it's inside a CONFIG_PPC64 block.  I'll add a paragraph to
> the patch description pointing that out.

How about this:

diff --git a/arch/powerpc/kernel/signal_32.c b/arch/powerpc/kernel/signal_32.c
index a6a4310..b13abf3 100644
--- a/arch/powerpc/kernel/signal_32.c
+++ b/arch/powerpc/kernel/signal_32.c
@@ -941,9 +941,21 @@ long sys_swapcontext(struct ucontext __user *old_ctx,
 #ifdef CONFIG_PPC64
 	unsigned long new_msr = 0;
 
-	if (new_ctx &&
-	    get_user(new_msr, &new_ctx->uc_mcontext.mc_gregs[PT_MSR]))
-		return -EFAULT;
+	if (new_ctx) {
+		struct mcontext __user *mcp;
+		u32 cmcp;
+
+		/*
+		 * Get pointer to the real mcontext.  No need for
+		 * access_ok since we are dealing with compat
+		 * pointers.
+		 */
+		if (__get_user(cmcp, &new_ctx->uc_regs))
+			return -EFAULT;
+		mcp = (struct mcontext __user *)(u64)cmcp;
+		if (__get_user(new_msr, &mcp->mc_gregs[PT_MSR]))
+			return -EFAULT;
+	}
 	/*
 	 * Check that the context is not smaller than the original
 	 * size (with VMX but without VSX)

Andreas.

-- 
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
PGP key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
