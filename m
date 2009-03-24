Return-Path: <linux-kernel-owner+w=401wt.eu-S1754619AbZCXWEe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754619AbZCXWEe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 18:04:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753888AbZCXWEJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 18:04:09 -0400
Received: from mx2.redhat.com ([66.187.237.31]:56410 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752074AbZCXWEH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 18:04:07 -0400
Date: Tue, 24 Mar 2009 23:00:08 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Cc: linux-tip-commits@vger.kernel.org, linux-kernel@vger.kernel.org,
       hpa@zytor.com, mingo@redhat.com, roland@redhat.com, tglx@linutronix.de,
       mingo@elte.hu
Subject: Re: [tip:x86/signal] x86: signal: check signal stack overflow
	properly
Message-ID: <20090324220008.GA23243@redhat.com>
References: <49C2874D.3080002@ct.jp.nec.com> <tip-14fc9fbc700dc95b4f46ebd588169324fe6deff8@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-14fc9fbc700dc95b4f46ebd588169324fe6deff8@git.kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/20, Hiroshi Shimamoto wrote:
>
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

I think the patch is correct but I have a minor question,

> No need to check SA_ONSTACK if we're already using alternate signal stack.

Yes, but this also mean that we don't need sas_ss_flags() under
"if (!onsigstack)",

> @@ -211,31 +211,27 @@ get_sigframe(struct k_sigaction *ka, struct pt_regs *regs, size_t frame_size,
>  {
>  	/* Default to using normal stack */
>  	unsigned long sp = regs->sp;
> +	int onsigstack = on_sig_stack(sp);
>
>  #ifdef CONFIG_X86_64
>  	/* redzone */
>  	sp -= 128;
>  #endif /* CONFIG_X86_64 */
>
> -	/*
> -	 * If we are on the alternate signal stack and would overflow it, don't.
> -	 * Return an always-bogus address instead so we will die with SIGSEGV.
> -	 */
> -	if (on_sig_stack(sp) && !likely(on_sig_stack(sp - frame_size)))
> -		return (void __user *) -1L;
> -
> -	/* This is the X/Open sanctioned signal stack switching.  */
> -	if (ka->sa.sa_flags & SA_ONSTACK) {
> -		if (sas_ss_flags(sp) == 0)
> -			sp = current->sas_ss_sp + current->sas_ss_size;
> -	} else {
> +	if (!onsigstack) {
> +		/* This is the X/Open sanctioned signal stack switching.  */
> +		if (ka->sa.sa_flags & SA_ONSTACK) {
> +			if (sas_ss_flags(sp) == 0)
> +				sp = current->sas_ss_sp + current->sas_ss_size;

We can use "->sas_ss_size != 0" instead and avoid the unnecessary
sas_ss_flags()->on_sig_stack() check.

Please note that afaics sas_ss_flags()->on_sig_stack() is actually
wrong because we already adjusted "sp" above for redzone.

Suppose that on_sig_stack(regs->sp) = F, but "sp - 128" falls into
the altstack. In that case SA_ONSTACK won't switch the stack.

Of course, this is only theoretical, but still.

Oleg.

