Return-Path: <linux-kernel-owner+w=401wt.eu-S1753468AbZAESpb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753468AbZAESpb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 13:45:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751515AbZAESpX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 13:45:23 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34404 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751403AbZAESpV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 13:45:21 -0500
Date: Mon, 5 Jan 2009 10:44:27 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Nick Piggin <npiggin@suse.de>
cc: Peter Klotz <peter.klotz@aon.at>, stable@kernel.org,
       Linux Memory Management List <linux-mm@kvack.org>,
       Christoph Hellwig <hch@infradead.org>,
       Roman Kononov <kernel@kononov.ftml.net>, linux-kernel@vger.kernel.org,
       xfs@oss.sgi.com, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch] mm: fix lockless pagecache reordering bug (was Re: BUG:
 soft lockup - is this XFS problem?)
In-Reply-To: <20090105180008.GE32675@wotan.suse.de>
Message-ID: <alpine.LFD.2.00.0901051027011.3057@localhost.localdomain>
References: <gifgp1$8ic$1@ger.gmane.org> <20081223171259.GA11945@infradead.org> <20081230042333.GC27679@wotan.suse.de> <20090103214443.GA6612@infradead.org> <20090105014821.GA367@wotan.suse.de> <20090105041959.GC367@wotan.suse.de> <20090105064838.GA5209@wotan.suse.de>
 <49623384.2070801@aon.at> <20090105164135.GC32675@wotan.suse.de> <alpine.LFD.2.00.0901050859430.3057@localhost.localdomain> <20090105180008.GE32675@wotan.suse.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 5 Jan 2009, Nick Piggin wrote:

> On Mon, Jan 05, 2009 at 09:30:55AM -0800, Linus Torvalds wrote:
> > 
> > Not only is it ugly (which is already sufficient ground to suspect it is 
> > wrong or could at least be done better), but reading the comment, it makes 
> > no sense at all. You only put the barrier in the "goto repeat" case, but 
> > the thing is, if you worry about radix tree slot not being reloaded in the 
> > repeat case, then you damn well should worry about it not being reloaded 
> > in the non-repeat case too!
> 
> In which case atomic_inc_unless is defined to provide a barrier.

Hmm. Ok, granted.

> > If you use RCU to protect a data structure, then any data loaded from that 
> > data structure that can change due to RCU should be loaded with 
> > "rcu_dereference()". 
> 
> It doesn't need that because the last level pointers in the radix
> tree are not necessarily under RCU, but whatever synchronisation
> the caller uses (in this case, speculative page references, which
> should not require smp_read_barrier_depends, AFAIKS).

rcu_dereference() does more than that smp_read_barrier_depends() (which is 
a no-op on all sane architectures). 

The important part of rcu_dereference() is the ACCESS_ONCE() part. That's 
the one that guarantees the access to happen - exactly once.

> Putting an rcu_dereference there might work, but I think it misses a 
> subtlety of this code.

No, _you_ miss the subtlety of something that can change under you.

Look at radix_tree_deref_slot(), and realize that without the 
rcu_dereference(), the compiler would actually be allowed to think that it 
can re-load anything from *pslot several times. So without my one-liner 
patch, the compiler can actually do this:

	register = load_from_memory(pslot)
	if (radix_tree_is_indirect_ptr(register))
		goto fail:
	return load_from_memory(pslot);

   fail:
	return RADIX_TREE_RETRY;

see? Imagine if you are low on registers (x86, anyone?) and look at that 
radix_tree_is_indirect_ptr() test: it does a logical "and" which can be 
done with a memory instruction on x86. So the compiler could _literally_ 
compile this as

	testb $1,(%eax)		; %eax is "pslot"
	jne indirect_pointer
	movl (%eax),%eax	; now we load it for real

rather than

	movl (%eax),%eax
	testl $1,%eax
	jne indirect_pointer

because the first version actually keeps more registers live for the 
indirect case. In fact, the compiler might be delaying that "movl" until 
much later (depending on barriers and needs). And notice how that "now we 
load it for real" may be getting a new value - including a possible 
indirect pointer value, even though we tested that it wasn't an indirect 
pointer!

And THIS is why code that depends on RCU needs to use "rcu_dereference()". 
Because otherwise you may be testing one thing, and then later using some 
_other_ value than the one you tested. You must guarantee that you really 
just load it once, and that the compiler doesn't decide that it can load 
it multiple times, and test the multiple (possibly different) values using 
different logic.

> > Of course, it's also possible that we should just put a barrier in 
> > page_cache_get_speculative(). That doesn't seem to make a whole lot of 
> > conceptual sense, though (the same way that your barrier() didn't make any 
> > sense - I don't see that the barrier has absolutely _anything_ to do with 
> > whether the speculative getting of the page fails or not!)
> 
> When that fails, the caller can (almost) assume the pointer has changed.

Not relevant.

Yes, when it fails, the caller can obviously assume that the pointer has 
almost certainly changed, but that's neither here nor there - if the 
page_cache_get_speculative() fails, you mustn't use that pointer *whether* 
it has changed or not. So there's no point in even testing, and the code 
obviously doesn't.

> So it has to load the new pointer to continue. The object pointed to is
> not protected with RCU, nor is there a requirement to see a specific
> load execution ordering. 

Either the value can change, or it can not. It's that simple.

If it cannot change, then we can load it just once, or we can load it 
multiple times, and it won't matter. Barriers won't do anything but screw 
up the code.

If it can change from under us, you need to use rcu_dereference(), or 
open-code it with an ACCESS_ONCE() or put in barriers. But your placement 
of a barrier was NONSENSICAL. Your barrier didn't protect anything else - 
like the test for the RADIX_TREE_INDIRECT_PTR bit.

And that was the fundamental problem.

And once you fix that fundamental problem, your barrier no longer makes 
any sense, because the barrier HAS NOTHING TO DO WITH WHETHER 
page_cache_get_speculative() fails or not!

			Linus
