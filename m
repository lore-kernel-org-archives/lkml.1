Return-Path: <linux-kernel-owner+w=401wt.eu-S1755430AbYG3RdL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755430AbYG3RdL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 13:33:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752421AbYG3Rc4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 13:32:56 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51842 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752391AbYG3Rcz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 13:32:55 -0400
Date: Wed, 30 Jul 2008 10:29:32 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Vitaly Mayatskikh <v.mayatskih@gmail.com>
cc: linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] x86: Optimize tail handling for copy_user
In-Reply-To: <m3ljzj60mk.fsf@gravicappa.englab.brq.redhat.com>
Message-ID: <alpine.LFD.1.10.0807301016020.3334@nehalem.linux-foundation.org>
References: <m3ljzmdrqh.fsf@gravicappa.englab.brq.redhat.com> <alpine.LFD.1.10.0807280846320.3486@nehalem.linux-foundation.org> <m3ljzj60mk.fsf@gravicappa.englab.brq.redhat.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 30 Jul 2008, Vitaly Mayatskikh wrote:
> 
> Another try.

Ok, this is starting to look more reasonable. But you cannot split things 
up like this per-file, because the end result doesn't _work_ with the 
changes separated.

> BYTES_LEFT_IN_PAGE macro returns PAGE_SIZE, not zero, when the address
> is well aligned to page.

Hmm. Why? If the address is aligned, then we shouldn't even tro to copy 
any more, should we? We know we got a fault - and regardless of whether it 
was because of some offset off the base pointer or not, if the base 
pointer was at offset zero, it's going to be in the same page. So why try 
to do an operation we know will fault again?

Also, that's a rather inefficient way to do it, isn't it? Maybe the 
compiler can figure it out, but the efficient code would be just

	PAGE_SIZE - ((PAGE_SIZE-1) &(unsigned long)ptr)

no? That said, exactly because I think we shouldn't even bother to try to 
fix up faults that happened at the beginning of a page, I think the right 
one is the one I think I posted originally, ie the one that does just

	#define BYTES_LEFT_IN_PAGE(ptr) \
		(unsigned int)((PAGE_SIZE-1) & -(long)(ptr))

which is a bit simpler (well, it requires some thought to know why it 
works, but it generates good code).

In case you wonder why it works, the operation we _want_ do do is

	(PAGE_SIZE - offset-in-page) mod PAGE_SIZE

but subtraction is "stable" in modulus calculus (*), so you can write that 
as

	(PAGE_SIZE mod PAGE_SIZE - offset-in-page) mod PAGE_SIZE

which is just

	(0 - (ptr mod PAGE_SIZE)) mod PAGE_SIZE

but again, subtraction is stable in modulus, so you can write that as

	(0 - ptr) mod PAGE_SIZE

and so the result is literally just those single 'neg' and 'and' 
instructions (in the macro, you then need all the casting and the 
parenthesis, which is why it gets ugly again)

And yes, maybe the compiler figures it all out, but judging by past 
experience, things often don't work that well.

			Linus

(*) Yeah, in math, it's stable in general, in 2's complement arithmetic 
it's only stable in mod 2^n, I guess.
