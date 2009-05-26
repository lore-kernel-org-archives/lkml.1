Return-Path: <linux-kernel-owner+w=401wt.eu-S1756039AbZEZRXd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756039AbZEZRXd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 13:23:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753286AbZEZRX0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 13:23:26 -0400
Received: from tomts13.bellnexxia.net ([209.226.175.34]:45408 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753231AbZEZRX0 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 13:23:26 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArsKAHfAG0pMQW1W/2dsb2JhbACBT5Z4ti+ECwU
Date: Tue, 26 May 2009 13:23:22 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Jamie Lokier <jamie@shareable.org>,
       Catalin Marinas <catalin.marinas@arm.com>,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: Broken ARM atomic ops wrt memory barriers (was : [PATCH] Add
	cmpxchg support for ARMv6+ systems)
Message-ID: <20090526172322.GB19443@Krystal>
References: <20090422171703.19555.83629.stgit@pc1117.cambridge.arm.com> <20090423141248.22193.10543.stgit@pc1117.cambridge.arm.com> <20090524131636.GB3159@n2100.arm.linux.org.uk> <20090524145633.GA14754@Krystal> <20090525132027.GA946@shareable.org> <20090525151724.GA14321@Krystal> <20090525161941.GA3667@n2100.arm.linux.org.uk> <20090526145950.GB26713@n2100.arm.linux.org.uk> <20090526153654.GA17096@Krystal> <20090526155906.GC26713@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20090526155906.GC26713@n2100.arm.linux.org.uk>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 12:41:51 up 87 days, 13:08,  4 users,  load average: 0.31, 0.12,
	0.09
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Russell King - ARM Linux (linux@arm.linux.org.uk) wrote:
> On Tue, May 26, 2009 at 11:36:54AM -0400, Mathieu Desnoyers wrote:
> > > diff --git a/arch/arm/include/asm/system.h b/arch/arm/include/asm/system.h
> > > index bd4dc8e..e9889c2 100644
> > > --- a/arch/arm/include/asm/system.h
> > > +++ b/arch/arm/include/asm/system.h
> > > @@ -248,6 +248,8 @@ static inline unsigned long __xchg(unsigned long x, volatile void *ptr, int size
> > >  	unsigned int tmp;
> > >  #endif
> > >  
> > > +	smp_mb();
> > > +
> > >  	switch (size) {
> > >  #if __LINUX_ARM_ARCH__ >= 6
> > >  	case 1:
> > > @@ -258,7 +260,7 @@ static inline unsigned long __xchg(unsigned long x, volatile void *ptr, int size
> > >  		"	bne	1b"
> > >  			: "=&r" (ret), "=&r" (tmp)
> > >  			: "r" (x), "r" (ptr)
> > > -			: "memory", "cc");
> > > +			: "cc");
> > 
> > I would not remove the "memory" constraint in here. Anyway it's just a
> > compiler barrier, I doubt it would make anyting faster (due to the
> > following smp_mb() added), but it surely makes things harder to
> > understand.
> 
> If you don't already know that smp_mb() is always a compiler barrier then
> I guess it's true, but then if you don't know what the barriers are defined
> to be, should you be trying to understand atomic ops?
> 

The "memory" constaint in a gcc inline assembly has always been there to
tell the compiler that the inline assembly has side-effects on memory so
the compiler can take the appropriate decisions wrt optimisations.

Removing the "memory" clobber is just a bug.

The compiler needs the "memory" clobber in the inline assembly to know
that it cannot be put outside of the smp_mb() "memory" clobbers. If you
remove this clobber, the compiler is free to move the inline asm outside
of the smp_mb()s as long as it only touches registers and reads
immediate values.

> > If we determine that some reorderings are not possible on ARM, we might
> > eventually change rmb() for a simple barrier() and make atomic op
> > barriers a bit more lightweight.
> 
> There seems to be no "read memory barrier" on ARM - the dmb instruction
> can be restricted to writes, but not just reads.
> 

Yes, I've noticed that too. BTW binutils seems broken and does not
support "dmb st" :-(

> Moreover, there's a comment in the architecture reference manual that
> implementations which don't provide the other dmb variants must default
> to doing the full dmb, but then goes on to say that programs should not
> rely on this (what... that the relaxed dmb()s have any effect what so
> ever?)

Whoah.. that sounds odd.

> 
> Suggest we don't go anywhere near those until ARMv7 stuff has matured
> for a few years and these details resolved.

I think we have more insteresting details in the following reference
which tells us we are in the right direction. I wonder about
smp_read_barrier_depends though.  Maybe we should add a dmb in there
given how permissive the ordering semantic seems to be.

ARM v7-M Architecture Application Level Reference

http://jedrzej.ulasiewicz.staff.iiar.pwr.wroc.pl/KomputeroweSystSter/seminarium/materialy/arm/ARMv7_Ref.pdf

"A3.4.6 Synchronization primitives and the memory order model

The synchronization primitives follow the memory ordering model of the
memory type accessed by the instructions. For this reason:

• Portable code for claiming a spinlock must include a DMB instruction
between claiming the spinlock and making any access that makes use of
the spinlock.
• Portable code for releasing a spinlock must include a DMB instruction
before writing to clear the spinlock.

This requirement applies to code using the
Load-Exclusive/Store-Exclusive instruction pairs, for example
LDREX/STREX."

(this means that adding the dmb as we are doing is required)


A3.7.3 - Ordering requirements for memory accesses

Reading this, especially the table detailing the "Normal vs Normal"
memory operation order, makes me wonder if we should map

#define smp_read_barrier_depends	dmb()

Because two consecutive reads are not guaranteed to be globally
observable in program order. This means :

cpu A

write data
wmb()
update ptr

cpu B

cpyptr = rcu_dereference(ptr);
if (cpyptr)
  access *cpyptr data

cpu B could see the new ptr cache-line before the data cache-line, which
means we can read garbage.

But currently, only the old alphas have this requirement. I wonder if
it's just me missing some very important detail, but the documentation
about ordering seems permissive enough that it could potentially allow
such reordering.

Mathieu


-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
