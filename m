Return-Path: <linux-kernel-owner+w=401wt.eu-S1756694AbYFQURv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756694AbYFQURv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 16:17:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752093AbYFQURl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 16:17:41 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48360 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753138AbYFQURb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 16:17:31 -0400
Date: Tue, 17 Jun 2008 13:16:39 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Bron Gondwana <brong@fastmail.fm>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Nick Piggin <npiggin@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rob Mueller <robm@fastmail.fm>, Andi Kleen <ak@suse.de>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: BUG: mmapfile/writev spurious zero bytes (x86_64/not i386,
 bisected, reproducable)
In-Reply-To: <alpine.LFD.1.10.0806171041560.25099@woody.linux-foundation.org>
Message-ID: <alpine.LFD.1.10.0806171309130.2981@woody.linux-foundation.org>
References: <1213682410.13174.1258837181@webmail.messagingengine.com> <1213682570.13708.1258839317@webmail.messagingengine.com> <alpine.LFD.1.10.0806170947380.25099@woody.linux-foundation.org>
 <alpine.LFD.1.10.0806171041560.25099@woody.linux-foundation.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 17 Jun 2008, Linus Torvalds wrote:
> 
> Bron, does this untested patch hide the bug?

Ok, it does hide the bug.

> I don't think this patch is correct, because it doesn't really fix the 
> basic issue (the code should do the right thing even if a page isn't 
> there), but it might hide it by faulting in the whole "bytes" range rather 
> than just the first iov.
> 
> So Nick, it's still over to you, but if this does hide it, then that's an 
> interesting detail in itself.

I actually am starting to think that the bug is in 
__copy_to_user_inatomic_nocache().

The return value of that thing in the case of a failure seems to be 
totally wrong. In particular, since that function does an unrolled loop of 
accesses like so:

	.Ls1:   movq (%rsi),%r11
	.Ls2:   movq 1*8(%rsi),%r8
	.Ls3:   movq 2*8(%rsi),%r9
	.Ls4:   movq 3*8(%rsi),%r10
	.Ld1:   movnti %r11,(%rdi)
	.Ld2:   movnti %r8,1*8(%rdi)
	.Ld3:   movnti %r9,2*8(%rdi)
	.Ld4:   movnti %r10,3*8(%rdi)

it may have done three of the 64-bit loads, and then trap on the fouth: 
but since it hasn't done a _single_ of the stores, it shouldn't count as 
any different whether it traps on any of .Ls[1-4]. But that code 
definitely seems to think it makes a difference whether the exception 
happened at Ls1 or at Ls4, even though both points have copied _exactly_ 
as many bytes when the exception happens.

So I'm starting to think the bug is all in there, not in the VM itself. 
See arch/x86/lib/copy_user_nocache.S.

In fact, even the comment there implies that the author didn't know or 
care about returning the correct value.

Andi and Ingo added to Cc.

			Linus
