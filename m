Return-Path: <linux-kernel-owner+w=401wt.eu-S1757454AbZEZSX5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757454AbZEZSX5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 14:23:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757049AbZEZSXp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 14:23:45 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:49798 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757261AbZEZSXo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 14:23:44 -0400
Date: Tue, 26 May 2009 19:23:10 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Jamie Lokier <jamie@shareable.org>,
       Catalin Marinas <catalin.marinas@arm.com>,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: Broken ARM atomic ops wrt memory barriers (was : [PATCH] Add
	cmpxchg support for ARMv6+ systems)
Message-ID: <20090526182310.GG26713@n2100.arm.linux.org.uk>
References: <20090423141248.22193.10543.stgit@pc1117.cambridge.arm.com> <20090524131636.GB3159@n2100.arm.linux.org.uk> <20090524145633.GA14754@Krystal> <20090525132027.GA946@shareable.org> <20090525151724.GA14321@Krystal> <20090525161941.GA3667@n2100.arm.linux.org.uk> <20090526145950.GB26713@n2100.arm.linux.org.uk> <20090526153654.GA17096@Krystal> <20090526155906.GC26713@n2100.arm.linux.org.uk> <20090526172322.GB19443@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090526172322.GB19443@Krystal>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 26, 2009 at 01:23:22PM -0400, Mathieu Desnoyers wrote:
> * Russell King - ARM Linux (linux@arm.linux.org.uk) wrote:
> > On Tue, May 26, 2009 at 11:36:54AM -0400, Mathieu Desnoyers wrote:
> > > > diff --git a/arch/arm/include/asm/system.h b/arch/arm/include/asm/system.h
> > > > index bd4dc8e..e9889c2 100644
> > > > --- a/arch/arm/include/asm/system.h
> > > > +++ b/arch/arm/include/asm/system.h
> > > > @@ -248,6 +248,8 @@ static inline unsigned long __xchg(unsigned long x, volatile void *ptr, int size
> > > >  	unsigned int tmp;
> > > >  #endif
> > > >  
> > > > +	smp_mb();
> > > > +
> > > >  	switch (size) {
> > > >  #if __LINUX_ARM_ARCH__ >= 6
> > > >  	case 1:
> > > > @@ -258,7 +260,7 @@ static inline unsigned long __xchg(unsigned long x, volatile void *ptr, int size
> > > >  		"	bne	1b"
> > > >  			: "=&r" (ret), "=&r" (tmp)
> > > >  			: "r" (x), "r" (ptr)
> > > > -			: "memory", "cc");
> > > > +			: "cc");
> > > 
> > > I would not remove the "memory" constraint in here. Anyway it's just a
> > > compiler barrier, I doubt it would make anyting faster (due to the
> > > following smp_mb() added), but it surely makes things harder to
> > > understand.
> > 
> > If you don't already know that smp_mb() is always a compiler barrier then
> > I guess it's true, but then if you don't know what the barriers are defined
> > to be, should you be trying to understand atomic ops?
> > 
> 
> The "memory" constaint in a gcc inline assembly has always been there to
> tell the compiler that the inline assembly has side-effects on memory so
> the compiler can take the appropriate decisions wrt optimisations.

However, if you have a compiler memory barrier before the operation, and
after the operation, it's giving it the same information.

Think about it:

	asm("foo" : : : "memory");

is a compiler memory barrier - no program accesses specified before
this statement may be re-ordered after it, and no accesses after the
statement may be re-ordered before it.

Now think about:

	asm("" : : : "memory");
	asm("foo");
	asm("" : : : "memory");

The first and third asm is a compiler memory barrier and behaves just
as above.  The worker asm is sandwiched between two compiler memory
barriers which do not permit previous or following programatical
accesses being re-ordered into or over either of those two barriers.

So the guarantee that accesses prior to our "foo" operation are not
reordered after it, or accesses after are not reordered before is
preserved.

> The compiler needs the "memory" clobber in the inline assembly to know
> that it cannot be put outside of the smp_mb() "memory" clobbers. If you
> remove this clobber, the compiler is free to move the inline asm outside
> of the smp_mb()s as long as it only touches registers and reads
> immediate values.

That means that things can be re-ordered across an asm("" : : : "memory")
statement, which in effect means that anything can be reordered across
a Linux mb(), barrier() etc statement.  That means the kernel is extremely
buggy since these macros (according to your definition) are ineffective.

> A3.7.3 - Ordering requirements for memory accesses
> 
> Reading this, especially the table detailing the "Normal vs Normal"
> memory operation order, makes me wonder if we should map
> 
> #define smp_read_barrier_depends	dmb()
> 
> Because two consecutive reads are not guaranteed to be globally
> observable in program order. This means :
> 
> cpu A
> 
> write data
> wmb()
> update ptr
> 
> cpu B
> 
> cpyptr = rcu_dereference(ptr);
> if (cpyptr)
>   access *cpyptr data
> 
> cpu B could see the new ptr cache-line before the data cache-line, which
> means we can read garbage.

Well, this comes down to what wmb() is, and that's again dmb() on ARM.
dmb ensures that accesses before it will be seen by observers within the
domain before they see accesses after it.

So:

write data
dmb
update ptr

means that the write of data is guaranteed to be observable before ptr
gets updated.  So I don't think we have anything to worry about here.
If the dmb wasn't there, then it would be possible for the ptr update
to be seen before the data is written.

Or at least that's my reading of the architecture reference manual (which
is really what counts, not these satellite documents.)
