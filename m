Return-Path: <linux-kernel-owner+w=401wt.eu-S1757790AbZEZTRq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757790AbZEZTRq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 15:17:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755898AbZEZTRj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 15:17:39 -0400
Received: from mail2.shareable.org ([80.68.89.115]:49001 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752402AbZEZTRj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 15:17:39 -0400
Date: Tue, 26 May 2009 20:17:29 +0100
From: Jamie Lokier <jamie@shareable.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Catalin Marinas <catalin.marinas@arm.com>,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: Broken ARM atomic ops wrt memory barriers (was : [PATCH] Add cmpxchg support for ARMv6+ systems)
Message-ID: <20090526191729.GA12144@shareable.org>
References: <20090524131636.GB3159@n2100.arm.linux.org.uk> <20090524145633.GA14754@Krystal> <20090525132027.GA946@shareable.org> <20090525151724.GA14321@Krystal> <20090525161941.GA3667@n2100.arm.linux.org.uk> <20090526145950.GB26713@n2100.arm.linux.org.uk> <20090526153654.GA17096@Krystal> <20090526155906.GC26713@n2100.arm.linux.org.uk> <20090526172322.GB19443@Krystal> <20090526182310.GG26713@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090526182310.GG26713@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Russell King - ARM Linux wrote:
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

That looks mistaken.  The middle asm can move if it does not contain
any memory accesses.  As you say, the first and third asm are compiler
*memory* barriers, and the middle asm doesn't access memory as far as
GCC is concerned.

So for example GCC is allowed to reorder that like this:

 	asm("" : : : "memory");
 	asm("" : : : "memory");
 	asm("foo");

Looking at the constraints for __xchg:

     : "=&r" (ret), "=&r" (tmp)
     : "r" (x), "r" (ptr)
     : "cc"

*We* know the asm accesses memory, but GCC doesn't - it just sees
four numbers going in and coming out in registers.

So GCC can move it past the barriers before and after.

You might be able to rewrite it as "m" (*ptr) for the 4th argument and
a different way of expanding that in the asm itself.  You'd have to
make it an input-output argument, so "=&m" (*ptr) in the outputs.  It
used to be thought that GCC could theoretically fetch the value into a
temporary register, and store it again after the asm, but nowadays I'm
pretty sure you're allowed to depend on memory constraints.

But why waste energy on that.

The "memory" clobber was there to tell GCC that the asm does memory
accesses that GCC can't see from the constraints, and therefore it
cannot reorder the instruction past other (apparent) memory accesses,
i.e. the nearby compiler barriers.

-- Jamie
