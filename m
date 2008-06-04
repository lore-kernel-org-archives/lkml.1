Return-Path: <linux-kernel-owner+w=401wt.eu-S1759695AbYFDUkS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759695AbYFDUkS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 16:40:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751047AbYFDUkF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 16:40:05 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37246 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750987AbYFDUkE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 16:40:04 -0400
Date: Wed, 4 Jun 2008 13:38:50 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Nick Piggin <npiggin@suse.de>
cc: Ingo Molnar <mingo@elte.hu>, David Howells <dhowells@redhat.com>,
       Ulrich Drepper <drepper@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/3] 64-bit futexes: Intro
In-Reply-To: <alpine.LFD.1.10.0806041249470.3473@woody.linux-foundation.org>
Message-ID: <alpine.LFD.1.10.0806041320020.3473@woody.linux-foundation.org>
References: <4840C29B.6030507@redhat.com> <alpine.LFD.1.10.0805302044310.3141@woody.linux-foundation.org> <4840CE51.9060109@redhat.com> <alpine.LFD.1.10.0805302109370.3141@woody.linux-foundation.org> <alpine.LFD.1.10.0805302116440.3141@woody.linux-foundation.org>
 <4840D63F.2090407@redhat.com> <alpine.LFD.1.10.0805311438080.3141@woody.linux-foundation.org> <20080602185433.GB4081@elte.hu> <alpine.LFD.1.10.0806021246060.3141@woody.linux-foundation.org> <20080602230316.GA24159@elte.hu> <20080603032403.GA17089@wotan.suse.de>
 <alpine.LFD.1.10.0806041249470.3473@woody.linux-foundation.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 4 Jun 2008, Linus Torvalds wrote:
> 
> So when you do
> 
> 	movb reg,(byteptr)
> 	movl (byteptr),reg
> 
> you may actually get old data in the upper 24 bits, along with new data in 
> the lower 8.

Put another way: the CPU may internally effectively rewrite the two 
instructions as

	movb reg,tmpreg		(tmp = writebuffer)
	movl (byteptr),reg	(do the 32-bit read of the old cached contents)
	movb tmpreg,reg		(writebuffer snoop by reads)
	movb tmpreg,(byteptr)	(writebuffer actually drains into cacheline)

and *if* your algorithm is robust wrt these kinds of rewrites, you're ok. 
But notice how there are two accesses to the cacheline, and how they are 
actually in the "wrong" order, and how the cacheline could have been 
updated by another CPU in between.

Does this actually happen? Yeah, I do believe it does. Is it a deathknell 
for anybody trying to be clever with overlapping reads/writes? No, you can 
still have things like causality rules that guarantee that your algorithm 
is perfectly stable in the face of these kinds of reordering. But it *is* 
one of the few re-orderings that I think is theoretically archtiecturally 
visible.

For example, let's start out with a 32-bit word that contains zero, and 
three CPU's. One CPU does

	cmpxchgl 0->0x01010101,mem

another one does

	cmpxchlg 0x01010101->0x02020202,mem

and the third one does that

	movb $0x03,mem
	movl mem,reg

and after it all completed, you may have 0x02020203 in memory, but "reg" 
on the third CPU contains 0x01010103.

Note how NO OTHER CPU could _possibly_ have seen that value! That value 
never ever existed in any caches. If the final value was 0x02020203, then 
both the cmpxchgl's must have worked, so the cache coherency contents 
*must* have gone from 0 -> 0x01010101 -> 0x02020202 -> 0x02020203 (with 
the movb actually getting the exclusive cache access last).

So the third CPU saw a value for that load that actually *never* existed 
in any cache-line: 0x01010103.  Exactly because the x86 memory ordering 
allows the store buffer contents to be forwarded within a CPU core.

And this is why atomic locked instructions are special. They bypass the 
store buffer (or at least they _act_ as if they do - they likely actually 
use the store buffer, but they flush it and the instruction pipeline 
before the load and wait for it to drain after, and have a lock on the 
cacheline that they take as part o the load, and release as part of the 
store - all to make sure that the cacheline doesn't go away in between and 
that nobody else can see the store buffer contents while this is going 
on).

This is also why there is so much room for improvement in locked 
instruction performance - you don't _have_ to flush things if you just are 
very careful about tracking how and when you use which elements in the 
store buffer, and track the ordering of cache accesses by all of this.

			Linus
