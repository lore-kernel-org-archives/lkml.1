Return-Path: <linux-kernel-owner+w=401wt.eu-S1755355AbZCLKtI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755355AbZCLKtI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 06:49:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752056AbZCLKsy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 06:48:54 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:55089 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751499AbZCLKsy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 06:48:54 -0400
Date: Thu, 12 Mar 2009 11:48:34 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jan Beulich <jbeulich@novell.com>, Cyrill Gorcunov <gorcunov@gmail.com>,
       Alexander van Heukelum <heukelum@fastmail.fm>
Cc: tglx@linutronix.de, hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86-64: fix unwind annotations in entry_64.S
Message-ID: <20090312104834.GA30204@elte.hu>
References: <49B8F2DF.76E4.0078.0@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49B8F2DF.76E4.0078.0@novell.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Jan Beulich <jbeulich@novell.com> wrote:

>  	.macro XCPT_FRAME start=1 offset=0
> -	INTR_FRAME \start, RIP+\offset-ORIG_RAX
> -	/*CFI_REL_OFFSET orig_rax, ORIG_RAX-ORIG_RAX*/
> +	INTR_FRAME \start, __stringify(RIP+\offset-ORIG_RAX)
>  	.endm
>  
>  /*
>   * frame that enables calling into C.
>   */
>  	.macro PARTIAL_FRAME start=1 offset=0
> -	XCPT_FRAME \start, ORIG_RAX+\offset-ARGOFFSET
> +	.if \start >= 0
> +	XCPT_FRAME \start, __stringify(ORIG_RAX+\offset-ARGOFFSET)
> +	.endif

So we pass in a stringified parameter from PARTIAL_FRAME to 
XCPT_FRAME and then we stringify it again?

> -	movq_cfi rdi, RDI+16-ARGOFFSET
> -	movq_cfi rsi, RSI+16-ARGOFFSET
> -	movq_cfi rdx, RDX+16-ARGOFFSET
> -	movq_cfi rcx, RCX+16-ARGOFFSET
> -	movq_cfi rax, RAX+16-ARGOFFSET
> -	movq_cfi  r8,  R8+16-ARGOFFSET
> -	movq_cfi  r9,  R9+16-ARGOFFSET
> -	movq_cfi r10, R10+16-ARGOFFSET
> -	movq_cfi r11, R11+16-ARGOFFSET
> +	movq %rdi, RDI+16-ARGOFFSET(%rsp)
> +	movq %rsi, RSI+16-ARGOFFSET(%rsp)
> +	movq %rdx, RDX+16-ARGOFFSET(%rsp)
> +	movq %rcx, RCX+16-ARGOFFSET(%rsp)
> +	movq_cfi rax, __stringify(RAX+16-ARGOFFSET)
> +	movq  %r8,  R8+16-ARGOFFSET(%rsp)
> +	movq  %r9,  R9+16-ARGOFFSET(%rsp)
> +	movq %r10, R10+16-ARGOFFSET(%rsp)
> +	movq_cfi r11, __stringify(R11+16-ARGOFFSET)

Hm, we used to have annotations for those arguments too, now 
they are gone.

>  	leaq 8(%rsp), %rbp		/* mov %rsp, %ebp */
> +	CFI_DEF_CFA_REGISTER rbp
> +	CFI_ADJUST_CFA_OFFSET -8

This open-codes CFI annotations again - please introduce a 
helper instead.

> -	popq_cfi %rax			/* move return address... */
> +	popq %rax			/* move return address... */

No annotation needed?

>  	mov %gs:pda_irqstackptr,%rsp
> -	EMPTY_FRAME 0
> -	pushq_cfi %rbp			/* backlink for unwinder */
> -	pushq_cfi %rax			/* ... to the new stack */
> +	pushq %rbp			/* backlink for unwinder */
> +	pushq %rax			/* ... to the new stack */

Ditto?

>  ENTRY(save_rest)
> -	PARTIAL_FRAME 1 REST_SKIP+8
> +	CFI_STARTPROC
>  	movq 5*8+16(%rsp), %r11	/* save return address */
> -	movq_cfi rbx, RBX+16
> -	movq_cfi rbp, RBP+16
> -	movq_cfi r12, R12+16
> -	movq_cfi r13, R13+16
> -	movq_cfi r14, R14+16
> -	movq_cfi r15, R15+16
> +	movq %rbx, RBX+16(%rsp)
> +	movq %rbp, RBP+16(%rsp)
> +	movq %r12, R12+16(%rsp)
> +	movq %r13, R13+16(%rsp)
> +	movq %r14, R14+16(%rsp)
> +	movq %r15, R15+16(%rsp)

Same here?

>  	CFI_ADJUST_CFA_OFFSET REST_SKIP
>  	call save_rest
> -	DEFAULT_FRAME 0 8		/* offset 8: return address */
> +	DEFAULT_FRAME -2 8		/* offset 8: return address */
>  	leaq 8(%rsp), \arg	/* pt_regs pointer */

Open-coded CFI annotation again.

I havent checked the rest of the patch but it shows similar 
patters.

The thing is, this patch is completely unacceptable - it just 
reintroduces the same ugly crufty CFI code we used to have 
there.

The current annotations might be completely broken but at least 
they _look_ structured and attempt to bring some order into the 
CFI annotations chaos.

There's really just two options here:

- You either submit clean, gradual patches that fix the problems 
  and explain what is done and why, and documents the annotation
  rules and makes CFI annotations maintainable,

- Or we'll remove all CFI annotations from all x86 assembly
  files and wait for future, clean patches.

	Ingo
