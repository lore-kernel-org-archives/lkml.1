Return-Path: <linux-kernel-owner+w=401wt.eu-S1762537AbYFDT6R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762537AbYFDT6R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 15:58:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753062AbYFDT6H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 15:58:07 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51269 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753018AbYFDT6F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 15:58:05 -0400
Date: Wed, 4 Jun 2008 12:57:13 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Nick Piggin <npiggin@suse.de>
cc: Ingo Molnar <mingo@elte.hu>, David Howells <dhowells@redhat.com>,
       Ulrich Drepper <drepper@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/3] 64-bit futexes: Intro
In-Reply-To: <20080603032403.GA17089@wotan.suse.de>
Message-ID: <alpine.LFD.1.10.0806041249470.3473@woody.linux-foundation.org>
References: <4840C29B.6030507@redhat.com> <alpine.LFD.1.10.0805302044310.3141@woody.linux-foundation.org> <4840CE51.9060109@redhat.com> <alpine.LFD.1.10.0805302109370.3141@woody.linux-foundation.org> <alpine.LFD.1.10.0805302116440.3141@woody.linux-foundation.org>
 <4840D63F.2090407@redhat.com> <alpine.LFD.1.10.0805311438080.3141@woody.linux-foundation.org> <20080602185433.GB4081@elte.hu> <alpine.LFD.1.10.0806021246060.3141@woody.linux-foundation.org> <20080602230316.GA24159@elte.hu>
 <20080603032403.GA17089@wotan.suse.de>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 3 Jun 2008, Nick Piggin wrote:
> 
> I think optimised our unlock_page in a way that it can do a
> non-atomic unlock in the fastpath (no waiters) using 2 bits. In
> practice it was still atomic but only because other page flags
> operations could operate on ->flags at the same time.

I'd be *very* nervous about this.

> We don't require any load/store barrier in the unlock_page fastpath
> because the bits are in the same word, so cache coherency gives us a
> sequential ordering anyway.

Yes and no.

Yes, the bits are int he same word, so cache coherency guarantees a lot.

HOWEVER. If you do the sub-word write using a regular store, you are now 
invoking the _one_ non-coherent part of the x86 memory pipeline: the store 
buffer. Normal stores can (and will) be forwarded to subsequent loads from 
the store buffer, and they are not strongly ordered wrt cache coherency 
while they are buffered.

IOW, on x86, loads are ordered wrt loads, and stores are ordered wrt other 
stores, but loads are *not* ordered wrt other stores in the absense of a 
serializing instruction, and it's exactly because of the write buffer.

So:

> But actually if we're careful, we can put them in seperate parts of the 
> word and use the sub-word operations on x86 to avoid the atomic 
> requirement. I'm not aware of any architecture in which operations to 
> the same word could be out of order.

See above. The above is unsafe, because if you do a regular store to a 
partial word, with no serializing instructions between that and a 
subsequent load of the whole word, the value of the store can be bypassed 
from the store buffer, and the load from the other part of the word can be 
carried out _before_ the store has actually gotten that cacheline 
exclusively!

So when you do

	movb reg,(byteptr)
	movl (byteptr),reg

you may actually get old data in the upper 24 bits, along with new data in 
the lower 8.

I think.

Anyway, be careful. The cacheline itself will always be coherent, but the 
store buffer is not going to be part of the coherency rules, and without 
serialization (or locked ops), you _are_ going to invoke the store buffer!

		Linus
