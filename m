Return-Path: <linux-kernel-owner+w=401wt.eu-S1756482AbYBEICT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756482AbYBEICT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 03:02:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754869AbYBEICE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 03:02:04 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:56967 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754563AbYBEICC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 03:02:02 -0500
Date: Tue, 5 Feb 2008 09:01:49 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Roland McGrath <roland@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86_64: make traps on 'iret' be debuggable in user
	space
Message-ID: <20080205080149.GA16929@elte.hu>
References: <20080205075137.617012701A8@magilla.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080205075137.617012701A8@magilla.localdomain>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Roland McGrath <roland@redhat.com> wrote:

> This makes the x86-64 behavior for 32-bit processes that set bogus 
> %cs/%ss values (the only ones that can fault in iret) match what the 
> native i386 behavior has been since:
> 
> 	commit a879cbbb34cbecfa9707fbb6e5a00c503ac1ecb9
> 	Author: Linus Torvalds <torvalds@ppc970.osdl.org>
> 	Date:   Fri Apr 29 09:38:44 2005 -0700
> 
> 	    x86: make traps on 'iret' be debuggable in user space
> 
> Signed-off-by: Roland McGrath <roland@redhat.com>
> ---
>  arch/x86/kernel/entry_64.S |   25 +++++++++++++++++++------
>  1 files changed, 19 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
> index 07d4aba..62744b1 100644
> --- a/arch/x86/kernel/entry_64.S
> +++ b/arch/x86/kernel/entry_64.S
> @@ -592,13 +592,26 @@ ENTRY(native_iret)
>  	.quad native_iret, bad_iret
>  	.previous
>  	.section .fixup,"ax"
> -	/* force a signal here? this matches i386 behaviour */
> -	/* running with kernel gs */
>  bad_iret:
> -	movq $11,%rdi	/* SIGSEGV */
> -	TRACE_IRQS_ON
> -	ENABLE_INTERRUPTS(CLBR_ANY | ~(CLBR_RDI))
> -	jmp do_exit
> +	/*
> +	 * The iret traps when the %cs or %ss being restored is bogus.
> +	 * (This can only happen in a 32-bit process, and only by invalid
> +	 * selectors being set via ptrace.  Changing the value enforces
> +	 * that the USER_RPL bits are set, but not that the index is valid.)
> +	 * We've lost the original trap vector and error code.
> +	 * #GPF is the most likely one to get for an invalid selector.
> +	 * So pretend we completed the iret and took the #GPF in user mode.
> +	 *
> +	 * We are now running with the kernel GS after exception recovery.
> +	 * But error_entry expects us to have user GS to match the user %cs,
> +	 * so swap back.
> +	 */
> +	INTR_FRAME
> +	pushq $0
> +	CFI_ADJUST_CFA_OFFSET 8
> +	SWAPGS
> +	jmp general_protection
> +	CFI_ENDPROC
>  	.previous

thanks, applied. I suppose you have a testcase for this that we could 
try?

	Ingo
