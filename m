Return-Path: <linux-kernel-owner+w=401wt.eu-S1760639AbXGXTAa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760639AbXGXTAa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 15:00:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754319AbXGXTAW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 15:00:22 -0400
Received: from mail4.iitk.ac.in ([203.197.196.4]:52104 "EHLO mail4.iitk.ac.in"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753617AbXGXTAV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 15:00:21 -0400
X-Virus-Scanner: This message was checked by NOD32 Antivirus system
	for Linux Server. For more information on NOD32 Antivirus System,
	please, visit our website: http://www.nod32.com/.
Date: Wed, 25 Jul 2007 00:31:47 +0530 (IST)
From: Satyam Sharma <ssatyam@cse.iitk.ac.in>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       David Howells <dhowells@redhat.com>, Andi Kleen <ak@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 8/8] i386: bitops: smp_mb__{before, after}_clear_bit()
 definitions
In-Reply-To: <alpine.LFD.0.999.0707240959331.3607@woody.linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0707250007260.12726@cselinux1.cse.iitk.ac.in>
References: <423904.37199.qm@web53810.mail.re2.yahoo.com>
 <Pine.LNX.4.64.0707241631220.1433@cselinux1.cse.iitk.ac.in>
 <46A5E366.8030605@yahoo.com.au> <Pine.LNX.4.64.0707241708350.1433@cselinux1.cse.iitk.ac.in>
 <alpine.LFD.0.999.0707240959331.3607@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 24 Jul 2007, Linus Torvalds wrote:

> On Tue, 24 Jul 2007, Satyam Sharma wrote:
> > 
> > Looks like when you said "CPU memory barrier extends to all memory
> > references" you were probably referring to a _given_ CPU ... yes,
> > that statement is correct in that case.
> 
> No. CPU memory barriers extend to all CPU's. End of discussion.
> 
> It's not about "that cacheline". The whole *point* of a CPU memory barrier 
> is that it's about independent memory accesses.
> 
> Yes, for a memory barrier to be effective, all CPU's involved in the 
> transaction have to have the barriers - the same way a lock needs to be 
> taken by everybody in order for it to make sense - but the point is, CPU 
> barriers are about *global* behaviour, not local ones.
> 
> So there's a *huge* difference between
> 
> 	clear_bit(x,y);
> 
> and
> 
> 	clear_bit(x,y);
> 	smp_mb__before_after_clear_bit();
> 
> and it has absolutely nothing to do with the particular cacheline that "y" 
> is in, it's about the *global* memory ordering.
> 
> Any write you do after that "smp_mb__before_after_clear_bit()" will be 
> guaranteed to be visible to _other_ CPU's *after* they have seen the bit 
> being cleared. Yes, those other CPU's need to have a read barrier between 
> reading the bit and reading some other thign, but the point is, this hass 
> *nothing* to do with cache coherency, and the particular cache line that 
> "y" is in.
> 
> And no, "smp_mb__before/after_clear_bit()" must *not* be just an empty "do 
> {} while (0)". It needs to be a compiler barrier even when it has no 
> actual CPU meaning, unless clear_bit() itself is guaranteed to be a 
> compiler barrier (which it isn't, although the "volatile" on the asm in 
> practice makes it something *close* to that).
> 
> Why? Think of the sequence like this:
> 
> 	clear_bit(x,y);
> 	smp_mb__after_clear_bit();
> 	other_variable = 10;
> 
> the whole *point* of this sequence is that if another CPU does
> 
> 	x = other_variable;
> 	smp_rmb();
> 	bit = test_bit(x,y)
> 
> then if it sees "x" being 10, then the bit *has* to be clear.
> 
> And this is why the compiler barrier in "smp_mb__after_clear_bit()" needs 
> to be a compiler barrier:
> 
>  - it doesn't matter for the action of the "clear_bit()" itself: that one 
>    is locked, and on x86 it thus also happens to be a serializing 
>    instruction, and the cache coherency and lock obviously means that the 
>    bit clearing *itself* is safe!
> 
>  - but it *does* matter for the compiler scheduling. If the compiler were 
>    to decide that "y" and "other_variable" are totally independent, it 
>    might otherwise decide to move the "other_variable = 10" assignment to 
>    *before* the clear_bit(), which would make the whole code pointless!
> 
> See? We have two totally independent issues:
> 
>  - the CPU itself can re-order the visibility of accesses. x86 doesn't do 
>    this very much, and doesn't do it at all across a locked instruction, 
>    but it's still a real issue, even if it tends to be much easier to see 
>    on other architectures.
> 
>  - the compiler doesn't care about rules of "locked instruction" at all, 
>    because it has no clue. It has *different* rules about how it can 
>    re-order instructions and accesses, and maybe the "asm volatile" will 
>    guarantee that the compiler won't re-order things around the 
>    clear_bit(), and maybe it won't. But making it a compiler barrier (by 
>    using the "memory clobber" thing, *guarantees* that gcc cannot reorder 
>    memory writes or reads.
> 
> See? Two different - and _totally_ independent - levels of ordering, and 
> we need to make sure that both are valid.

Ok, thanks much (David and Nick too!) for taking the time to explain this
out clearly. It does look amazingly obvious now that I see it, with
callers using bitops to implement locking schemes who would completely
break otherwise -- in fact 6 and 8 in this series look amazingly obtuse
now ...


Satyam
