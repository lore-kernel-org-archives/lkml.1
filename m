Return-Path: <linux-kernel-owner+w=401wt.eu-S972050AbXHMMgt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S972050AbXHMMgt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 08:36:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937826AbXHMHGY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 03:06:24 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:36102 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S936054AbXHMHGW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 03:06:22 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.1
From: Keith Owens <kaos@ocs.com.au>
To: linux-kernel@vger.kernel.org
Subject: Unbalanced stack usage in arch/i386/math-emu/wm_sqrt.S
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Date: Mon, 13 Aug 2007 17:06:16 +1000
Message-ID: <11592.1186988776@kao2.melbourne.sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Originally sent to the maintainer of the i386 math-emu code
(billm@suburbia.net) but that mail was bounced[1].  Is anybody
maintaining the math-emu code and do we even care about it anymore?

I am doing static code analysis on the kernel and have found a stack
imbalance in arch/i386/math-emu/wm_sqrt.S.  2.6.23-rc2, but it has
probably been there for a while.

    The code starts off with

        pushl   %ebp
        movl    %esp,%ebp
#ifndef NON_REENTRANT_FPU
        subl    $28,%esp
#endif /* NON_REENTRANT_FPU */
        pushl   %esi
        pushl   %edi
        pushl   %ebx

    At this point, the code is using 0x2c bytes of stack space.

    .... do some work

sqrt_stage_2_finish:
	sarl	$1,%ecx		/* divide by 2 */
	rcrl	$1,%eax

	/* Form the new estimate in %esi:%edi */
	movl	%eax,%edi
	addl	%ecx,%esi

	jnz	sqrt_stage_2_done	/* result should be [1..2) */

    ... still using 0x2c bytes of stack space

#ifdef PARANOID
/* It should be possible to get here only if the arg is ffff....ffff */
	cmp	$0xffffffff,FPU_fsqrt_arg_1
	jnz	sqrt_stage_2_error
#endif /* PARANOID */

/* The best rounded result. */
	xorl	%eax,%eax
	decl	%eax
	movl	%eax,%edi
	movl	%eax,%esi
	movl	$0x7fffffff,%eax
	jmp	sqrt_round_result

#ifdef PARANOID
sqrt_stage_2_error:

    .... 0x2c bytes of stack space

	pushl	EX_INTERNAL|0x213

    .... 0x30 bytes of stack space

	call	EXCEPTION

    .... EXCEPTION is FPU_exception which only aborts if __DEBUG__ is
    defined, __DEBUG__ is not defined.  So FPU_exception will return
    and we still have 0x30 bytes of stack used.  But the code drops
    through to sqrt_stage_2_done which (like the rest of the code) only
    expects 0x2c bytes of stack ===>  stack imbalance.

#endif /* PARANOID */ 

sqrt_stage_2_done:


The obvious fix is to add 'pop %eax' after 'call EXCEPTION' which will
remove the extra word from the stack.  Alas that only fixes the stack
imbalance, but does it even make sense for the code to continue after
calling EXCEPTION?


[1] <billm@suburbia.net>: host suburbia.com.au[203.24.247.1] said: 554
    <billm@suburbia.net>: Recipient address rejected: Access denied (in
    reply to RCPT TO command)

The URL listed in MAINTAINERS for FPU Emulator gets a 404 as well.

