Return-Path: <linux-kernel-owner+w=401wt.eu-S1764372AbZDIMW6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764372AbZDIMW6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 08:22:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758489AbZDIMWr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 08:22:47 -0400
Received: from hera.kernel.org ([140.211.167.34]:38229 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751456AbZDIMWq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 08:22:46 -0400
Subject: Re: [tip:x86/signal] x86: signal: check signal stack overflow
 properly
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: mingo@redhat.com, hpa@zytor.com, h-shimamoto@ct.jp.nec.com,
       linux-kernel@vger.kernel.org, roland@redhat.com, tglx@linutronix.de,
       mingo@elte.hu
Cc: linux-tip-commits@vger.kernel.org
In-Reply-To: <tip-14fc9fbc700dc95b4f46ebd588169324fe6deff8@git.kernel.org>
References: <49C2874D.3080002@ct.jp.nec.com>
	 <tip-14fc9fbc700dc95b4f46ebd588169324fe6deff8@git.kernel.org>
Content-Type: text/plain
Date: Thu, 09 Apr 2009 17:52:03 +0530
Message-Id: <1239279723.11859.18.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hiroshi-san,

I am getting few sparse warnings from your commited lines.
If possible, please run sparse before sending patch.

On Fri, 2009-03-20 at 18:03 +0000, Hiroshi Shimamoto wrote:
> Commit-ID:  14fc9fbc700dc95b4f46ebd588169324fe6deff8
> Gitweb:     http://git.kernel.org/tip/14fc9fbc700dc95b4f46ebd588169324fe6deff8
> Author:     Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
> AuthorDate: Thu, 19 Mar 2009 10:56:29 -0700
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Fri, 20 Mar 2009 19:01:31 +0100
> 
> x86: signal: check signal stack overflow properly
> 
> Impact: cleanup
> 
> Check alternate signal stack overflow with proper stack pointer.
> The stack pointer of the next signal frame is different if that
> task has i387 state.
> 
> On x86_64, redzone would be included.
> 
> No need to check SA_ONSTACK if we're already using alternate signal stack.
> 
> Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
> Cc: Roland McGrath <roland@redhat.com>
> LKML-Reference: <49C2874D.3080002@ct.jp.nec.com>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> 
> 
> ---
>  arch/x86/kernel/signal.c |   48 +++++++++++++++++++++++++--------------------
>  1 files changed, 27 insertions(+), 21 deletions(-)
> 
> diff --git a/arch/x86/kernel/signal.c b/arch/x86/kernel/signal.c
> index d2cc642..dfcc74a 100644
> --- a/arch/x86/kernel/signal.c
> +++ b/arch/x86/kernel/signal.c
> @@ -244,12 +240,22 @@ get_sigframe(struct k_sigaction *ka, struct pt_regs *regs, size_t frame_size,
>  		sp = round_down(sp, 64);
>  #endif /* CONFIG_X86_64 */
>  		*fpstate = (void __user *)sp;
> -
> -		if (save_i387_xstate(*fpstate) < 0)
> -			return (void __user *)-1L;
>  	}
>  
> -	return (void __user *)align_sigframe(sp - frame_size);
> +	sp = align_sigframe(sp - frame_size);
> +
> +	/*
> +	 * If we are on the alternate signal stack and would overflow it, don't.
> +	 * Return an always-bogus address instead so we will die with SIGSEGV.
> +	 */
> +	if (onsigstack && !likely(on_sig_stack(sp)))
> +		return (void __user *)-1L;

arch/x86/kernel/signal.c:251:11: warning: cast adds address space to expression (<asn:1>)

> +
> +	/* save i387 state */
> +	if (used_math() && save_i387_xstate(*fpstate) < 0)
> +		return (void __user *)-1L;

arch/x86/kernel/signal.c:255:11: warning: cast adds address space to expression (<asn:1>)
> +
> +	return (void __user *)sp;
>  }
>  
>  #ifdef CONFIG_X86_32


4a612048 arch/x86/kernel/signal_32.c (Hiroshi Shimamoto 2008-11-11 19:09:29 -0800 326)  err |= __put_user(*((u64 *)&retcode), (u64 *)frame->retcode);

arch/x86/kernel/signal.c:326:9: warning: cast removes address space of expression
arch/x86/kernel/signal.c:326:9: warning: incorrect type in argument 1 (different address spaces)
arch/x86/kernel/signal.c:326:9:    expected void const volatile [noderef] <asn:1>*<noident>
arch/x86/kernel/signal.c:326:9:    got unsigned long long [usertype] *<noident>
arch/x86/kernel/signal.c:326:9: warning: cast removes address space of expression
arch/x86/kernel/signal.c:326:9: warning: cast removes address space of expression
arch/x86/kernel/signal.c:326:9: warning: cast removes address space of expression
arch/x86/kernel/signal.c:326:9: warning: cast adds address space to expression (<asn:1>)
arch/x86/kernel/signal.c:326:9: warning: cast removes address space of expression
arch/x86/kernel/signal.c:326:9: warning: cast removes address space of expression
arch/x86/kernel/signal.c:326:9: warning: cast adds address space to expression (<asn:1>)
arch/x86/kernel/signal.c:326:9: warning: cast removes address space of expression
arch/x86/kernel/signal.c:326:9: warning: cast removes address space of expression
arch/x86/kernel/signal.c:326:9: warning: cast adds address space to expression (<asn:1>)
arch/x86/kernel/signal.c:326:9: warning: cast removes address space of expression
arch/x86/kernel/signal.c:326:9: warning: cast removes address space of expression
arch/x86/kernel/signal.c:326:9: warning: cast removes address space of expression

98e3d45e arch/x86/kernel/signal.c    (Hiroshi Shimamoto 2009-01-23 15:50:10 -0800 359)  put_user_try {
98e3d45e arch/x86/kernel/signal.c    (Hiroshi Shimamoto 2009-01-23 15:50:10 -0800 360)          put_user_ex(sig, &frame->sig);
98e3d45e arch/x86/kernel/signal.c    (Hiroshi Shimamoto 2009-01-23 15:50:10 -0800 361)          put_user_ex(&frame->info, &frame->pinfo);

arch/x86/kernel/signal.c:361:3: warning: cast removes address space of expression
arch/x86/kernel/signal.c:361:3: warning: cast removes address space of expression
arch/x86/kernel/signal.c:361:3: warning: cast removes address space of expression
arch/x86/kernel/signal.c:361:3: warning: cast removes address space of expression

98e3d45e arch/x86/kernel/signal.c    (Hiroshi Shimamoto 2009-01-23 15:50:10 -0800 362)          put_user_ex(&frame->uc, &frame->puc);

arch/x86/kernel/signal.c:362:3: warning: cast removes address space of expression
arch/x86/kernel/signal.c:362:3: warning: cast removes address space of expression
arch/x86/kernel/signal.c:362:3: warning: cast removes address space of expression
arch/x86/kernel/signal.c:362:3: warning: cast removes address space of expression

98e3d45e arch/x86/kernel/signal.c    (Hiroshi Shimamoto 2009-01-23 15:50:10 -0800 363)          err |= copy_siginfo_to_user(&frame->info, info);
98e3d45e arch/x86/kernel/signal.c    (Hiroshi Shimamoto 2009-01-23 15:50:10 -0800 364) 

98e3d45e arch/x86/kernel/signal.c    (Hiroshi Shimamoto 2009-01-23 15:50:10 -0800 379)          /* Set up to return from userspace.  */
98e3d45e arch/x86/kernel/signal.c    (Hiroshi Shimamoto 2009-01-23 15:50:10 -0800 380)          restorer = VDSO32_SYMBOL(current->mm->context.vdso, rt_si

arch/x86/kernel/signal.c:380:12: warning: incorrect type in assignment (different address spaces)
arch/x86/kernel/signal.c:380:12:    expected void [noderef] <asn:1>*restorer
arch/x86/kernel/signal.c:380:12:    got void *<noident>


98e3d45e arch/x86/kernel/signal.c    (Hiroshi Shimamoto 2009-01-23 15:50:10 -0800 381)          if (ka->sa.sa_flags & SA_RESTORER)
98e3d45e arch/x86/kernel/signal.c    (Hiroshi Shimamoto 2009-01-23 15:50:10 -0800 382)                  restorer = ka->sa.sa_restorer;
98e3d45e arch/x86/kernel/signal.c    (Hiroshi Shimamoto 2009-01-23 15:50:10 -0800 383)          put_user_ex(restorer, &frame->pretcode);

arch/x86/kernel/signal.c:383:3: warning: cast removes address space of expression
arch/x86/kernel/signal.c:383:3: warning: cast removes address space of expression
arch/x86/kernel/signal.c:383:3: warning: cast removes address space of expression
arch/x86/kernel/signal.c:383:3: warning: cast removes address space of expression

98e3d45e arch/x86/kernel/signal.c    (Hiroshi Shimamoto 2009-01-23 15:50:10 -0800 392)          put_user_ex(*((u64 *)&rt_retcode), (u64 *)frame->retcode)

arch/x86/kernel/signal.c:392:3: warning: cast removes address space of expression
arch/x86/kernel/signal.c:392:3: warning: incorrect type in argument 1 (different address spaces)
arch/x86/kernel/signal.c:392:3:    expected void const volatile [noderef] <asn:1>*<noident>
arch/x86/kernel/signal.c:392:3:    got unsigned long long [usertype] *<noident>
arch/x86/kernel/signal.c:392:3: warning: cast removes address space of expression
arch/x86/kernel/signal.c:392:3: warning: cast removes address space of expression
arch/x86/kernel/signal.c:392:3: warning: cast removes address space of expression
arch/x86/kernel/signal.c:392:3: warning: cast adds address space to expression (<asn:1>)
arch/x86/kernel/signal.c:392:3: warning: cast removes address space of expression
arch/x86/kernel/signal.c:392:3: warning: cast removes address space of expression
arch/x86/kernel/signal.c:392:3: warning: cast adds address space to expression (<asn:1>)
arch/x86/kernel/signal.c:392:3: warning: cast removes address space of expression
arch/x86/kernel/signal.c:392:3: warning: cast removes address space of expression
arch/x86/kernel/signal.c:392:3: warning: cast adds address space to expression (<asn:1>)
arch/x86/kernel/signal.c:392:3: warning: cast removes address space of expression
arch/x86/kernel/signal.c:392:3: warning: cast removes address space of expression
arch/x86/kernel/signal.c:392:3: warning: cast removes address space of expression

--
JSR

