Return-Path: <linux-kernel-owner+w=401wt.eu-S1756802AbXGZBTS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756802AbXGZBTS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 21:19:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752708AbXGZBTK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 21:19:10 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53626 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752664AbXGZBTJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 21:19:09 -0400
Date: Wed, 25 Jul 2007 18:18:14 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Trent Piepho <xyzzy@speakeasy.org>
cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       Satyam Sharma <ssatyam@cse.iitk.ac.in>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       David Howells <dhowells@redhat.com>, Andi Kleen <ak@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 6/8] i386: bitops: Don't mark memory as clobbered
 unnecessarily
In-Reply-To: <Pine.LNX.4.58.0707251731370.30561@shell4.speakeasy.net>
Message-ID: <alpine.LFD.0.999.0707251811130.3442@woody.linux-foundation.org>
References: <20070723160528.22137.84144.sendpatchset@cselinux1.cse.iitk.ac.in>
 <20070723160558.22137.71943.sendpatchset@cselinux1.cse.iitk.ac.in>
 <46A578A1.5010504@yahoo.com.au> <Pine.LNX.4.64.0707241154060.1433@cselinux1.cse.iitk.ac.in>
 <46A5A929.4020706@yahoo.com.au> <Pine.LNX.4.58.0707240058370.30561@shell4.speakeasy.net>
 <alpine.LFD.0.999.0707241236020.3607@woody.linux-foundation.org>
 <Pine.LNX.4.58.0707251731370.30561@shell4.speakeasy.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 25 Jul 2007, Trent Piepho wrote:
> 
> Specifically, check test6_memasm.s.  The C code looks like this:
> 
> extern int a; /* keep asm from being elided for having no used output */
> static inline void bar(void) { asm("call bar" : "=m"(a) : : "memory"); }
> /* float x can't alias asm's output int a */
> void foo(float *x) { x[20] = 1; bar(); x[20] = 2; }
> 
> The asm code ends up like this:
> foo:
>         call bar
>         movl    4(%esp), %eax   # x, x
>         movl    $0x40000000, 80(%eax)   #,
>         ret

Hmm. I really think you should take this up with the gcc people. That 
looks like a gcc bug - because there really is nothing that guarantees 
that the asm doesn't change the array that "x" points to, and the asm 
clearly talks about clobbering memory.

> Notice that the first write to x[20] was NOT done.  It's also not done for a
> volatile asm without a memory clobber.  But if you combine both volatile and a
> memory clobber, then it is!  How to explain that?

I can't explain it. I do think you've found a gcc bug.

That said, the kernel mostly uses "asm volatile()" _together_ with a 
memory clobber for these kinds of things, so it sounds like the kernel 
wouldn't be impacted. But you're definitely right - the above report makes 
me worry.

> The difference between test2_volasm.s and test2_normasm.s is hard to explain
> too.  It seems like some times gcc forgets that imull is commutative.  It will
> emit "imull %edx, %eax" in some cases, but change an asm slightly and it will
> decide it must do "imull %eax, %edx ; movl %edx, %eax" for no apparent reason.

Well, that's likely just a subtle register allocation issue, and 
understandable. Generating perfect code is impossible, you want to 
generate good code on average.

		Linus
