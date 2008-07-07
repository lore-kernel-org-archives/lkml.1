Return-Path: <linux-kernel-owner+w=401wt.eu-S1755493AbYGGQVv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755493AbYGGQVv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 12:21:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753509AbYGGQVn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 12:21:43 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42867 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753190AbYGGQVn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 12:21:43 -0400
Date: Mon, 7 Jul 2008 09:21:36 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Vitaly Mayatskikh <v.mayatskih@gmail.com>
cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/2] Introduce copy_user_handle_tail routine
In-Reply-To: <m34p71yjyx.fsf@gravicappa.englab.brq.redhat.com>
Message-ID: <alpine.LFD.1.10.0807070901490.11076@woody.linux-foundation.org>
References: <m37icazgt0.fsf@gravicappa.englab.brq.redhat.com> <alpine.LFD.1.10.0806281108240.4371@hp.linux-foundation.org> <m3lk0ngdo5.fsf@gravicappa.englab.brq.redhat.com> <alpine.LFD.1.10.0806300835220.28533@hp.linux-foundation.org>
 <m3fxqsjt22.fsf_-_@gravicappa.englab.brq.redhat.com> <486B8B6C.2050109@firstfloor.org> <m37ic4jr2w.fsf@gravicappa.englab.brq.redhat.com> <alpine.LFD.1.10.0807021930470.18105@woody.linux-foundation.org> <m34p71yjyx.fsf@gravicappa.englab.brq.redhat.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 7 Jul 2008, Vitaly Mayatskikh wrote:

> Linus Torvalds <torvalds@linux-foundation.org> writes:
> 
> > Now, the stuff that comes *before* that point is the "try to fix up one 
> > byte at a time" thing, which I'd like to be simple and dumb. At least to 
> > start with.
> 
> Just to be clear: do these patches are good enough now (to start with)?
> Or, may be, it needs to be further improved?

I think they are getting there. I'm obviously not merging them in 2.6.26, 
but I'd be happy to do so for .27. 

Obviously, I'd be even happier if it also went through the normal x86 
review cycles (ie Ingo &co), but the current series is largely ack'ed by 
me.

> Btw, how much does it cost to CPU to do a fault? Can it be compared with
> average time of find_vma()?

It's *much* higher than a find_vma(). It's on the order of several 
thousand cycles, easy (well, it depends on uarch - on a P4, iirc any 
exception is soemthing like 1500 cycles *minimum*, and that's just for the 
exception overhead, not the actual fault path).

But the thing is, it doesn't even need a find_vma(). We can avoid the 
extra trap 99.9% of the time by knowing that the trap happened at a page 
crosser (in *theory* a trap can happen in the middle of a page because 
another CPU did a munmap() in the middle, but that's not a case we need to 
even bother optimize for). In particular, we *know* we shouldn't even try 
to cross user pages. So the fixup routine can just do

	/* Think about it.. */
	#define BYTES_LEFT_IN_PAGE(ptr) \
		(unsigned int)((PAGE_SIZE-1) & -(long)(ptr))


	/* How much should we try to copy carefully byte-by-byte? */
	unsigned int max_copy = remaining;

	/* Don't even bother trying to cross a page in user space! */
	if (flags & DEST_IS_USERSPACE)
		max_copy = min(max_copy, BYTES_LEFT_IN_PAGE(dst));
	if (flags & SOURCE_IS_USERSPACE)
		max_copy = min(max_copy, BYTES_LEFT_IN_PAGE(src));

	/* Do the careful copy */
	while (max_copy--) {
		unsigned char c;
		if (__get_user(c,src))
			break;
		if (__put_user(c,dst))
			break;
		src++;
		dst++;
		remaining--;
	}

	if (flags & CLEAR_REMAINDER)
		memset(dst, 0, remaining);

	return remaining;

or similar. Note how this still uses the slow-and-careful byte-at-a-time 
approach to the final copy, but it avoids - on purpose - even trying to 
copy across page boundaries, and thus will never take a second trap in the 
common case.

See? We don't actually care about vma boundaries or anything like that. We 
just care about the only boundary that matters for faults: the page 
boundary.

		Linus
