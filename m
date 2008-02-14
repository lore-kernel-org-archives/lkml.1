Return-Path: <linux-kernel-owner+w=401wt.eu-S1762096AbYBNXRT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762096AbYBNXRT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 18:17:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756200AbYBNXRG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 18:17:06 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:43223 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756065AbYBNXRF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 18:17:05 -0500
Date: Fri, 15 Feb 2008 00:16:41 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jakub Jelinek <jakub@redhat.com>
Cc: pageexec@freemail.hu, Sam Ravnborg <sam@ravnborg.org>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [x86.git#mm] stack protector fixes, vmsplice exploit
Message-ID: <20080214231640.GA31883@elte.hu>
References: <20080214190050.GA32258@elte.hu> <47B4AAB8.106.FEA5232@pageexec.freemail.hu> <20080214202535.GA25316@elte.hu> <20080214223553.GW24887@devserv.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080214223553.GW24887@devserv.devel.redhat.com>
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


* Jakub Jelinek <jakub@redhat.com> wrote:

> On Thu, Feb 14, 2008 at 09:25:35PM +0100, Ingo Molnar wrote:
> > The per function call overhead from stackprotector is already pretty 
> > serious IMO, but at least that's something that GCC _could_ be doing 
> > (much) smarter (why doesnt it jne forward out to __check_stk_failure, 
> > instead of generating 4 instructions, one of them a default-mispredicted 
> > branch instruction??), so that overhead could in theory be something 
> > like 4 fall-through instructions per function, instead of the current 6.
> 
> Where do you see a mispredicted branch?

ah!

> int foo (void)
> {
>   char buf[64];
>   bar (buf);
>   return 6;
> }
> 
> -O2 -fstack-protector -m64:
>         subq    $88, %rsp
>         movq    %fs:40, %rax
>         movq    %rax, 72(%rsp)
>         xorl    %eax, %eax
>         movq    %rsp, %rdi
>         call    bar
>         movq    72(%rsp), %rdx
>         xorq    %fs:40, %rdx
>         movl    $6, %eax
>         jne     .L5
>         addq    $88, %rsp
>         ret
> .L5:
>         .p2align 4,,6
>         .p2align 3
>         call    __stack_chk_fail

i got this:

	.file	""
	.text
.globl foo
	.type	foo, @function
foo:
.LFB2:
	pushq	%rbp
.LCFI0:
	movq	%rsp, %rbp
.LCFI1:
	subq	$208, %rsp
.LCFI2:
	movq	__stack_chk_guard(%rip), %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	movl	$3, %eax
	movq	-8(%rbp), %rdx
	xorq	__stack_chk_guard(%rip), %rdx
	je	.L3
	call	__stack_chk_fail
.L3:
	leave
	ret

but that's F8's gcc 4.1, and not the kernel mode code generator either. 

the code you cited looks far better - that's good news!

one optimization would be to do a 'jne' straight into __stack_chk_fail() 
- it's not like we ever want to return. [and it's obvious from the 
existing stackframe which one the failing function was] That way we'd 
have about 3 bytes less per function? We dont want to return to the 
original function so for the kernel it would be OK.

another potential optimization would be to exchange this:

>         subq    $88, %rsp
>         movq    %fs:40, %rax
>         movq    %rax, 72(%rsp)

into:

	pushq	%fs:40
	subq	$80, %rsp

or am i missing something? (is there perhaps an address generation 
dependency between the pushq and the subq? Or the canary would be at the 
wrong position?)

> both with gcc 4.1.x and 4.3.0. BTW, you can use -fstack-protector 
> --param=ssp-buffer-size=4 etc. to tweak the size of buffers to trigger 
> stack protection, the default is 8, but e.g. whole Fedora is compiled 
> with 4.

ok. is -fstack-protector-all basically equivalent to 
--param=ssp-buffer-size=0 ? I'm wondering whether it would be easy for 
gcc to completely skip stackprotector code on functions that have no 
buffers, even under -fstack-protector-all. (perhaps it already does?)

	Ingo
