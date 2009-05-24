Return-Path: <linux-kernel-owner+w=401wt.eu-S1755213AbZEXO4m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755213AbZEXO4m (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 10:56:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753515AbZEXO4f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 10:56:35 -0400
Received: from tomts13.bellnexxia.net ([209.226.175.34]:44574 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753783AbZEXO4e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 10:56:34 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArkHAFf9GEpMQW1W/2dsb2JhbACBT5ZtuAeECwU
Date: Sun, 24 May 2009 10:56:33 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org
Subject: Re: Broken ARM atomic ops wrt memory barriers (was : [PATCH] Add
	cmpxchg support for ARMv6+ systems)
Message-ID: <20090524145633.GA14754@Krystal>
References: <20090422171703.19555.83629.stgit@pc1117.cambridge.arm.com> <20090423141248.22193.10543.stgit@pc1117.cambridge.arm.com> <20090524131636.GB3159@n2100.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20090524131636.GB3159@n2100.arm.linux.org.uk>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 10:19:49 up 85 days, 10:46,  4 users,  load average: 0.19, 0.14,
	0.07
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Russell King - ARM Linux (linux@arm.linux.org.uk) wrote:
> On Thu, Apr 23, 2009 at 03:13:21PM +0100, Catalin Marinas wrote:
> > (updated following received comments)
> 
> This appears to remove cmpxchg_local / cmpxchg64_local support on ARMv6
> (although what the point of cmpxchg_local etc is I've no idea; it seems
> not to be used except with asm-generic/cmpxchg.h).
> 
> No idea if that's a problem or not - I don't know what the intentions of
> cmpxchg_local was (it looks to me now like it was an attempt to make
> things more complicated for the arch maintainer to understand.)
> 

It is used in the LTTng tree.

On x86, powerpc, mips (at least), there is a performance improvement
associated with using a uniprocessor atomic operation on per-cpu data
instead of a fully SMP-aware (lock prefix on intel, memory barriers on
powerpc and mips) instruction. See Documentation/local_ops.txt.

I use a local cmpxchg in the LTTng tree as key instruction to manage the
ring buffer in a irq, softirq and NMI-safe way (due to the atomic nature
of this instruction), but without the overhead of synchronizing across
CPUs.

On ARM, the semantic looks a bit like PowerPC with linked load/linked
store, and you don't seem to need memory barriers. I guess that's either
because

a) they are implicit in the ll/ls or
b) ARM does not perform out-of-order memory read/writes or
c) they've simply been forgotten, and it's a bug.

the cmpxchg local instruction maps currently to cmpxchg, as a fallback,
since there is no difference between the SMP-aware and UP-only
instructions.

But if I look at arch/arm/include/asm/spinlock.h, the answer I get seems
to be c) : ARM needs memory barriers.

static inline void __raw_spin_lock(raw_spinlock_t *lock)
{
        unsigned long tmp;

        __asm__ __volatile__(
"1:     ldrex   %0, [%1]\n"
"       teq     %0, #0\n"
#ifdef CONFIG_CPU_32v6K
"       wfene\n"
#endif
"       strexeq %0, %2, [%1]\n"
"       teqeq   %0, #0\n"
"       bne     1b"
        : "=&r" (tmp)
        : "r" (&lock->lock), "r" (1)
        : "cc");

        smp_mb();
}

static inline void __raw_spin_unlock(raw_spinlock_t *lock)
{
        smp_mb();

        __asm__ __volatile__(
"       str     %1, [%0]\n"
#ifdef CONFIG_CPU_32v6K
"       mcr     p15, 0, %1, c7, c10, 4\n" /* DSB */
"       sev"
#endif
        :
        : "r" (&lock->lock), "r" (0)
        : "cc");
}

Where the smp_mb() maps to dmb() on SMP systems :

arch/arm/include/asm/system.h :

#ifndef CONFIG_SMP
#define mb()    do { if (arch_is_coherent()) dmb(); else barrier(); } while (0)
#define rmb()   do { if (arch_is_coherent()) dmb(); else barrier(); } while (0)
#define wmb()   do { if (arch_is_coherent()) dmb(); else barrier(); } while (0)
#define smp_mb()        barrier()
#define smp_rmb()       barrier()
#define smp_wmb()       barrier()
#else
#define mb()            dmb()
#define rmb()           dmb()
#define wmb()           dmb()
#define smp_mb()        dmb()
#define smp_rmb()       dmb()
#define smp_wmb()       dmb()
#endif

Which tells me that the spin lock needs the dmb() to provide
acquire/release semantic with respect to other memory accesses within
the critical section.

And the code in __raw_spin_unlock seems a bit strange : on CPU_32v6K, it
does _two_ memory barriers (one synchronizing memory accesses, and then
one serializing memory accesses and unrelated instruction execution
too). Why ?

Given the atomic instruction semantic in the Linux kernel stated in
Documentation/atomic_ops.txt, instructions like cmpxchg, xchg and the
atomic add return family would be expected to have memory barriers on
SMP, but they don't. This is very likely a bug.

Mathieu

> > Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> > ---
> >  arch/arm/include/asm/system.h |   73 ++++++++++++++++++++++++++++++++++++++++-
> >  1 files changed, 71 insertions(+), 2 deletions(-)
> > 
> > diff --git a/arch/arm/include/asm/system.h b/arch/arm/include/asm/system.h
> > index bd4dc8e..aa2debc 100644
> > --- a/arch/arm/include/asm/system.h
> > +++ b/arch/arm/include/asm/system.h
> > @@ -314,6 +314,12 @@ static inline unsigned long __xchg(unsigned long x, volatile void *ptr, int size
> >  extern void disable_hlt(void);
> >  extern void enable_hlt(void);
> >  
> > +#if __LINUX_ARM_ARCH__ < 6
> > +
> > +#ifdef CONFIG_SMP
> > +#error "SMP is not supported on this platform"
> > +#endif
> > +
> >  #include <asm-generic/cmpxchg-local.h>
> >  
> >  /*
> > @@ -325,9 +331,72 @@ extern void enable_hlt(void);
> >  			(unsigned long)(n), sizeof(*(ptr))))
> >  #define cmpxchg64_local(ptr, o, n) __cmpxchg64_local_generic((ptr), (o), (n))
> >  
> > -#ifndef CONFIG_SMP
> >  #include <asm-generic/cmpxchg.h>
> > -#endif
> > +
> > +#else	/* __LINUX_ARM_ARCH__ >= 6 */
> > +
> > +extern void __bad_cmpxchg(volatile void *ptr, int size);
> > +
> > +static inline unsigned long __cmpxchg(volatile void *ptr, unsigned long old,
> > +				      unsigned long new, int size)
> > +{
> > +	unsigned long oldval, res;
> > +
> > +	switch (size) {
> > +	case 1:
> > +		do {
> > +			asm volatile("@ __cmpxchg1\n"
> > +			"	ldrexb	%1, [%2]\n"
> > +			"	mov	%0, #0\n"
> > +			"	teq	%1, %3\n"
> > +			"	strexbeq %0, %4, [%2]\n"
> > +				: "=&r" (res), "=&r" (oldval)
> > +				: "r" (ptr), "Ir" (old), "r" (new)
> > +				: "cc");
> > +		} while (res);
> > +		break;
> > +
> > +	case 2:
> > +		do {
> > +			asm volatile("@ __cmpxchg1\n"
> > +			"	ldrexh	%1, [%2]\n"
> > +			"	mov	%0, #0\n"
> > +			"	teq	%1, %3\n"
> > +			"	strexheq %0, %4, [%2]\n"
> > +				: "=&r" (res), "=&r" (oldval)
> > +				: "r" (ptr), "Ir" (old), "r" (new)
> > +				: "cc");
> > +		} while (res);
> > +		break;
> > +
> > +	case 4:
> > +		do {
> > +			asm volatile("@ __cmpxchg4\n"
> > +			"	ldrex	%1, [%2]\n"
> > +			"	mov	%0, #0\n"
> > +			"	teq	%1, %3\n"
> > +			"	strexeq %0, %4, [%2]\n"
> > +				: "=&r" (res), "=&r" (oldval)
> > +				: "r" (ptr), "Ir" (old), "r" (new)
> > +				: "cc");
> > +		} while (res);
> > +		break;
> > +
> > +	default:
> > +		__bad_cmpxchg(ptr, size);
> > +		oldval = 0;
> > +	}
> > +
> > +	return oldval;
> > +}
> > +
> > +#define cmpxchg(ptr,o,n)					\
> > +	((__typeof__(*(ptr)))__cmpxchg((ptr),			\
> > +				       (unsigned long)(o),	\
> > +				       (unsigned long)(n),	\
> > +				       sizeof(*(ptr))))
> > +
> > +#endif	/* __LINUX_ARM_ARCH__ >= 6 */
> >  
> >  #endif /* __ASSEMBLY__ */
> >  
> > 
> > 
> > -------------------------------------------------------------------
> > List admin: http://lists.arm.linux.org.uk/mailman/listinfo/linux-arm-kernel
> > FAQ:        http://www.arm.linux.org.uk/mailinglists/faq.php
> > Etiquette:  http://www.arm.linux.org.uk/mailinglists/etiquette.php

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
