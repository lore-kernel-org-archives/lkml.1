Return-Path: <linux-kernel-owner+w=401wt.eu-S965941AbXHaRq1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965941AbXHaRq1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 13:46:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965377AbXHaRqU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 13:46:20 -0400
Received: from ozlabs.org ([203.10.76.45]:45934 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758399AbXHaRqS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 13:46:18 -0400
Subject: Re: [PATCH] Fix out-by-one error in traps.c
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       lguest <lguest@ozlabs.org>, Frederik Deweerdt <deweerdt@free.fr>,
       Andi Kleen <ak@muc.de>
In-Reply-To: <alpine.LFD.0.999.0708310044450.25853@woody.linux-foundation.org>
References: <20070822020648.5ea3a612.akpm@linux-foundation.org>
	 <20070822202551.GB31846@slug>
	 <20070823145038.9895784f.akpm@linux-foundation.org>
	 <20070824060438.GE31846@slug> <46CE7EDC.9080007@goop.org>
	 <20070824082249.GG31846@slug>
	 <1188043649.20041.81.camel@localhost.localdomain>
	 <20070825122324.GA6138@slug> <20070825211405.GA18217@slug>
	 <1188230999.5531.15.camel@localhost.localdomain>
	 <20070830163812.GA22190@slug>
	 <1188512066.6353.5.camel@localhost.localdomain>
	 <alpine.LFD.0.999.0708302140480.25853@woody.linux-foundation.org>
	 <1188540238.6004.28.camel@localhost.localdomain>
	 <alpine.LFD.0.999.0708310044450.25853@woody.linux-foundation.org>
Content-Type: text/plain
Date: Sat, 01 Sep 2007 03:37:32 +1000
Message-Id: <1188581852.10802.13.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-08-31 at 00:51 -0700, Linus Torvalds wrote:
> 
> On Fri, 31 Aug 2007, Rusty Russell wrote:
> > head.S pushes a "$0" on the stack to stop the unwinder, lguest doesn't.
> 
> The unwinder should stop when it sees an invalid frame pointer, and even 
> without the push 0 I'd have expected it to be invalid.
> 
> But I suspect lguest triggers another thing: you actually make the stack 
> start at the *very*top* of the stack area. Afaik, normal x86 does not. A 
> normal x86 kernel will start off with a pt_regs[] setup, I think - ie the 
> kernel stack is always set up so that it has the "return to user mode" 
> information.

This is only for the initial booting stack (init_thread_union); see
arch/i386/kernel/head.S:
	/* Set up the stack pointer */
	lss stack_start,%esp
	...
	pushl $0		# fake return address for unwinder
	...
.data
ENTRY(stack_start)
	.long init_thread_union+THREAD_SIZE
	.long __BOOT_DS

lguest_asm.S missed the pushl $0 (lguest doesn't boot via head.S.  I'd
like to change that for 2.6.24, but it involved perturbing that code so
maybe not).

> But your patch does improve the sanity checking of the frame pointer. That 
> said, I think the following patch improves it more: does this also work 
> for you? (Totally untested, but it looks like the RightThing(tm) to do)

Yes, looks good.  Perhaps one additional magic num removal:

>  #ifdef	CONFIG_FRAME_POINTER
> -	while (valid_stack_ptr(tinfo, (void *)ebp)) {
> +	while (valid_stack_ptr(tinfo, (void *)ebp, 2*sizeof(unsigned long))) {
>  		unsigned long new_ebp;
>  		addr = *(unsigned long *)(ebp + 4);

*((unsigned long *)ebp + 1)?

Thanks,
Rusty.

