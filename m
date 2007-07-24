Return-Path: <linux-kernel-owner+w=401wt.eu-S1762618AbXGXI2T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762618AbXGXI2T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 04:28:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750944AbXGXI2G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 04:28:06 -0400
Received: from mail4.iitk.ac.in ([203.197.196.4]:38022 "EHLO mail4.iitk.ac.in"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762797AbXGXI2D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 04:28:03 -0400
X-Virus-Scanner: This message was checked by NOD32 Antivirus system
	for Linux Server. For more information on NOD32 Antivirus System,
	please, visit our website: http://www.nod32.com/.
Date: Tue, 24 Jul 2007 13:59:24 +0530 (IST)
From: Satyam Sharma <ssatyam@cse.iitk.ac.in>
To: Nick Piggin <nickpiggin@yahoo.com.au>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       David Howells <dhowells@redhat.com>, Andi Kleen <ak@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH 6/8] i386: bitops: Don't mark memory as clobbered
 unnecessarily
In-Reply-To: <46A5A929.4020706@yahoo.com.au>
Message-ID: <Pine.LNX.4.64.0707241304410.1433@cselinux1.cse.iitk.ac.in>
References: <20070723160528.22137.84144.sendpatchset@cselinux1.cse.iitk.ac.in>
 <20070723160558.22137.71943.sendpatchset@cselinux1.cse.iitk.ac.in>
 <46A578A1.5010504@yahoo.com.au> <Pine.LNX.4.64.0707241154060.1433@cselinux1.cse.iitk.ac.in>
 <46A5A929.4020706@yahoo.com.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Jul 2007, Nick Piggin wrote:

> > > [...]
> > > 
> > > __test_and_change_bit is one that you could remove the memory clobber
> > > from.
> > 
> > Yes, for the atomic versions we don't care if we're asking gcc to
> > generate trashy code (even though I'd have wanted to only disallow
> > problematic optimizations -- ones involving the passed bit-string
> > address -- there, and allow other memory references to be optimized
> > as and how the compiler feels like it) because the atomic variants
> > are slow anyway and we probably want to be extra-safe there.
> > 
> > But for the non-atomic variants, it does make sense to remove the
> > memory clobber (and the unneeded __asm__ __volatile__ that another
> > patch did -- for the non-atomic variants, again).
> 
> No. It has nothing to do with atomicity and all to do with ordering.

The memory clobber, or the volatile asm? There's more than one variable
here ... but still, I don't think either affects _ordering_ in any
_direct_ way.


> For example test_bit, clear_bit, set_bit, etc are all atomic but none
> place any restrictions on ordering.

In that case we need to update comments in include/asm-i386/bitops.h


> __test_and_change_bit has no restriction on ordering, so as long as
> the correct operands are clobbered, a "memory" clobber to enforce a
> compiler barrier is not needed.

But why even for the other operations? Consider (current code of)
test_and_set_bit():

static inline int test_and_set_bit(int nr, volatile unsigned long * addr)
{
	int oldbit;
	__asm__ __volatile__( LOCK_PREFIX
		"btsl %2,%1\n\tsbbl %0,%0"
		:"=r" (oldbit),"+m" (ADDR)
		:"Ir" (nr) : "memory");

	return oldbit;
}

The only memory reference in there is to the passed address, it will
be modified, yes, but that's been made obvious to gcc in the asm
already. So why are we marking all of memory as clobbered, is the
question. (I just read Jeremy's latest reply, but I don't see how
or why the memory clobber helps that case either -- does a memory
clobber affect how gcc would order / reorder code?)


> > OTOH, as per Linus' review it seems we can drop the "memory" clobber
> > and specify the output operand for the extended asm as "+m". But I
> > must admit I didn't quite understand that at all.
> 
> Yes, but that is for cases where "memory" is being used to say that
> some otherwise unspecified memory is actually being changed, rather
> than to provide a compiler barrier as is the case for test_and_set_bit
> and co.

Again, as I said above.

> > [ I should probably start reading gcc sources, the docs are said to
> >   be insufficient/out-of-date, as per the reviews of the patches. ]
> 
> You should read Documentation/atomic_ops.txt and memory-barriers.txt,
> which are quite useful and should be uptodate.

I have, of course. Will probably read again, thanks.


Satyam
