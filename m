Return-Path: <linux-kernel-owner+w=401wt.eu-S1758812AbZE0B1z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758812AbZE0B1z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 21:27:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755209AbZE0B1r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 21:27:47 -0400
Received: from tomts13-srv.bellnexxia.net ([209.226.175.34]:53012 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754600AbZE0B1q convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 21:27:46 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApQIAH0tHEpMQW1W/2dsb2JhbACBT5Z7tiKCMgeBUgU
Date: Tue, 26 May 2009 21:22:43 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Jamie Lokier <jamie@shareable.org>,
       Catalin Marinas <catalin.marinas@arm.com>,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: Broken ARM atomic ops wrt memory barriers (was : [PATCH] Add
	cmpxchg support for ARMv6+ systems)
Message-ID: <20090527012243.GB29692@Krystal>
References: <20090524131636.GB3159@n2100.arm.linux.org.uk> <20090524145633.GA14754@Krystal> <20090525132027.GA946@shareable.org> <20090525151724.GA14321@Krystal> <20090525161941.GA3667@n2100.arm.linux.org.uk> <20090526145950.GB26713@n2100.arm.linux.org.uk> <20090526153654.GA17096@Krystal> <20090526155906.GC26713@n2100.arm.linux.org.uk> <20090526172322.GB19443@Krystal> <20090526182310.GG26713@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20090526182310.GG26713@n2100.arm.linux.org.uk>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 21:00:09 up 87 days, 21:26,  4 users,  load average: 0.00, 0.04,
	0.00
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Russell King - ARM Linux (linux@arm.linux.org.uk) wrote:
> On Tue, May 26, 2009 at 01:23:22PM -0400, Mathieu Desnoyers wrote:
> > * Russell King - ARM Linux (linux@arm.linux.org.uk) wrote:
> > > On Tue, May 26, 2009 at 11:36:54AM -0400, Mathieu Desnoyers wrote:
> > > > > diff --git a/arch/arm/include/asm/system.h b/arch/arm/include/asm/system.h
> > > > > index bd4dc8e..e9889c2 100644
> > > > > --- a/arch/arm/include/asm/system.h
> > > > > +++ b/arch/arm/include/asm/system.h
> > > > > @@ -248,6 +248,8 @@ static inline unsigned long __xchg(unsigned long x, volatile void *ptr, int size
> > > > >  	unsigned int tmp;
> > > > >  #endif
> > > > >  
> > > > > +	smp_mb();
> > > > > +
> > > > >  	switch (size) {
> > > > >  #if __LINUX_ARM_ARCH__ >= 6
> > > > >  	case 1:
> > > > > @@ -258,7 +260,7 @@ static inline unsigned long __xchg(unsigned long x, volatile void *ptr, int size
> > > > >  		"	bne	1b"
> > > > >  			: "=&r" (ret), "=&r" (tmp)
> > > > >  			: "r" (x), "r" (ptr)
> > > > > -			: "memory", "cc");
> > > > > +			: "cc");
> > > > 
> > > > I would not remove the "memory" constraint in here. Anyway it's just a
> > > > compiler barrier, I doubt it would make anyting faster (due to the
> > > > following smp_mb() added), but it surely makes things harder to
> > > > understand.
> > > 
> > > If you don't already know that smp_mb() is always a compiler barrier then
> > > I guess it's true, but then if you don't know what the barriers are defined
> > > to be, should you be trying to understand atomic ops?
> > > 
> > 
> > The "memory" constaint in a gcc inline assembly has always been there to
> > tell the compiler that the inline assembly has side-effects on memory so
> > the compiler can take the appropriate decisions wrt optimisations.
> 
> However, if you have a compiler memory barrier before the operation, and
> after the operation, it's giving it the same information.
> 
> Think about it:
> 
> 	asm("foo" : : : "memory");
> 
> is a compiler memory barrier - no program accesses specified before
> this statement may be re-ordered after it, and no accesses after the
> statement may be re-ordered before it.
> 
> Now think about:
> 
> 	asm("" : : : "memory");
> 	asm("foo");
> 	asm("" : : : "memory");
> 
> The first and third asm is a compiler memory barrier and behaves just
> as above.  The worker asm is sandwiched between two compiler memory
> barriers which do not permit previous or following programatical
> accesses being re-ordered into or over either of those two barriers.
> 
> So the guarantee that accesses prior to our "foo" operation are not
> reordered after it, or accesses after are not reordered before is
> preserved.
> 
> > The compiler needs the "memory" clobber in the inline assembly to know
> > that it cannot be put outside of the smp_mb() "memory" clobbers. If you
> > remove this clobber, the compiler is free to move the inline asm outside
> > of the smp_mb()s as long as it only touches registers and reads
> > immediate values.
> 
> That means that things can be re-ordered across an asm("" : : : "memory")
> statement, which in effect means that anything can be reordered across
> a Linux mb(), barrier() etc statement.  That means the kernel is extremely
> buggy since these macros (according to your definition) are ineffective.
> 

Jamie's answer is appropriate. (the compiler does not know the
asm("foo") modifies memory unless we add the "memory" clobber)

I'd recommend sticking to :

asm volatile ("insns" : : : "memory");

About the volatile :

There is _no_ performance decrease here, and this is what all other
architectures are doing.

include/linux/compiler-gcc.h is quite interesting :

/* Optimization barrier */
/* The "volatile" is due to gcc bugs */
#define barrier() __asm__ __volatile__("": : :"memory")

But you'll have to ask the person who wrote this comment for
clarifications.

Running git blame :

^1da177e (Linus Torvalds    2005-04-16 15:20:36 -0700 10) /* Optimization barrier */
^1da177e (Linus Torvalds    2005-04-16 15:20:36 -0700 11) /* The "volatile" is due to gcc bugs */
^1da177e (Linus Torvalds    2005-04-16 15:20:36 -0700 12) #define barrier() __asm__ __volatile__("": : :"memory")

> > A3.7.3 - Ordering requirements for memory accesses
> > 
> > Reading this, especially the table detailing the "Normal vs Normal"
> > memory operation order, makes me wonder if we should map
> > 
> > #define smp_read_barrier_depends	dmb()
> > 
> > Because two consecutive reads are not guaranteed to be globally
> > observable in program order. This means :
> > 
> > cpu A
> > 
> > write data
> > wmb()
> > update ptr
> > 
> > cpu B
> > 
> > cpyptr = rcu_dereference(ptr);
> > if (cpyptr)
> >   access *cpyptr data
> > 
> > cpu B could see the new ptr cache-line before the data cache-line, which
> > means we can read garbage.
> 
> Well, this comes down to what wmb() is, and that's again dmb() on ARM.
> dmb ensures that accesses before it will be seen by observers within the
> domain before they see accesses after it.
> 
> So:
> 
> write data
> dmb
> update ptr
> 
> means that the write of data is guaranteed to be observable before ptr
> gets updated.  So I don't think we have anything to worry about here.
> If the dmb wasn't there, then it would be possible for the ptr update
> to be seen before the data is written.
> 
> Or at least that's my reading of the architecture reference manual (which
> is really what counts, not these satellite documents.)

My point was not about the wmb() : we _clearly_ need a dmb there. My
point is about the hidden

smp_read_barrier_depends() in rcu_dereference() :

cpyptr = ptr;
smp_read_barrier_depends();
access *cpyptr data

Which is needed to make sure we update our global view of memory between
the pointer value read and the moment we read the data pointed to. This
makes sure the data read is not garbage.

Quoting Paul McKenney at http://www.linuxjournal.com/article/8211

"The second-to-last column, dependent reads reordered, requires some
explanation, which will be undertaken in the second installment of this
series. The short version is Alpha requires memory barriers for readers
as well as for updaters of linked data structures. Yes, this does mean
that Alpha in effect can fetch the data pointed to before it fetches the
pointer itself—strange but true. Please see the “Ask the Wizard” column
on the manufacturer's site, listed in Resources, if you think that I am
making this up. The benefit of this extremely weak memory model is Alpha
can use simpler cache hardware, which in turn permitted higher clock
frequencies in Alpha's heyday."

And at http://www.linuxjournal.com/article/8212

"Figure 1 shows how this can happen on an aggressively parallel machine
with partitioned caches, so that alternating cache lines are processed
by the different partitions of the caches. Assume that the list header
head is processed by cache bank 0 and the new element is processed by
cache bank 1. On Alpha, the smp_wmb() guarantees that the cache
invalidation performed by lines 6–8 of Listing 1 reaches the
interconnect before that of line 10. But, it makes absolutely no
guarantee about the order in which the new values reach the reading
CPU's core. For example, it is possible that the reading CPU's cache
bank 1 is busy, while cache bank 0 is idle. This could result in the
cache invalidates for the new element being delayed, so that the reading
CPU gets the new value for the pointer but sees the old cached values
for the new element."

So, my questions is : is ARMv7 weak memory ordering model as weak as
Alpha ?

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
