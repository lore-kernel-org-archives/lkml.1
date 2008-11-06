Return-Path: <linux-kernel-owner+w=401wt.eu-S1754262AbYKFAwe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754262AbYKFAwe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 19:52:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751870AbYKFAw0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 19:52:26 -0500
Received: from ozlabs.org ([203.10.76.45]:56098 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752044AbYKFAwZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 19:52:25 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18706.16317.759662.855430@cargo.ozlabs.ibm.com>
Date: Thu, 6 Nov 2008 11:52:13 +1100
From: Paul Mackerras <paulus@samba.org>
To: Andreas Schwab <schwab@suse.de>
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix msr check in compat_sys_swapcontext
In-Reply-To: <jeprlabbi6.fsf@sykes.suse.de>
References: <jeprlabbi6.fsf@sykes.suse.de>
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andreas Schwab writes:

> The new context may not be 16-byte aligned, so the real address of the
> mcontext structure should be read from the uc_regs pointer instead of
> directly using the (unaligned) uc_mcontext field.

Good catch, but...

> @@ -941,9 +941,17 @@ long sys_swapcontext(struct ucontext __user *old_ctx,
>  #ifdef CONFIG_PPC64
>  	unsigned long new_msr = 0;
>  
> -	if (new_ctx &&
> -	    get_user(new_msr, &new_ctx->uc_mcontext.mc_gregs[PT_MSR]))
> -		return -EFAULT;
> +	if (new_ctx) {
> +		struct mcontext __user *mcp;
> +		u32 cmcp;
> +
> +		/* Get pointer to the real mcontext. */
> +		if (__get_user(cmcp, &new_ctx->uc_regs))

we need to use get_user, not __get_user, since we haven't done an
access_ok() check on the address.

> +			return -EFAULT;
> +		mcp = (struct mcontext __user *)(u64)cmcp;
> +		if (__get_user(new_msr, &mcp->mc_gregs[PT_MSR]))

ditto here.

Paul.
