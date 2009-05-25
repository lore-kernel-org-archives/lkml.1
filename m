Return-Path: <linux-kernel-owner+w=401wt.eu-S1753862AbZEYUWV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753862AbZEYUWV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 16:22:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751746AbZEYUWN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 16:22:13 -0400
Received: from tomts43.bellnexxia.net ([209.226.175.110]:65061 "EHLO
	tomts43-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751712AbZEYUWM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 16:22:12 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArQHACeVGkpMQW1W/2dsb2JhbACBT5ZttBCECwU
Date: Mon, 25 May 2009 16:22:10 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Jamie Lokier <jamie@shareable.org>,
       Catalin Marinas <catalin.marinas@arm.com>,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: Broken ARM atomic ops wrt memory barriers (was : [PATCH] Add
	cmpxchg support for ARMv6+ systems)
Message-ID: <20090525202210.GD22651@Krystal>
References: <20090422171703.19555.83629.stgit@pc1117.cambridge.arm.com> <20090423141248.22193.10543.stgit@pc1117.cambridge.arm.com> <20090524131636.GB3159@n2100.arm.linux.org.uk> <20090524145633.GA14754@Krystal> <20090525132027.GA946@shareable.org> <20090525151724.GA14321@Krystal> <20090525161941.GA3667@n2100.arm.linux.org.uk> <20090525172955.GA17665@Krystal> <20090525195656.GC3667@n2100.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20090525195656.GC3667@n2100.arm.linux.org.uk>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 16:06:44 up 86 days, 16:32,  8 users,  load average: 0.17, 0.26,
	0.16
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Russell King - ARM Linux (linux@arm.linux.org.uk) wrote:
> This reply is based upon what's in your email rather than atomic_ops.
> 
> On Mon, May 25, 2009 at 01:29:55PM -0400, Mathieu Desnoyers wrote:
> > This is a very good start, but I think a few are still missing :
> > 
> > in atomic.h :
> > 
> > /* Atomic operations are already serializing on ARM */
> > #define smp_mb__before_atomic_dec()     barrier()
> > #define smp_mb__after_atomic_dec()      barrier()
> > #define smp_mb__before_atomic_inc()     barrier()
> > #define smp_mb__after_atomic_inc()      barrier()
> > 
> > should probably map to smp_mb() for arm v6+.
> 
> BTW, I think you're wrong here.  atomic_dec() and atomic_inc() are
> implemented using atomic_add_return() and atomic_sub_return().  Both
> of these functions are serializing as a result of the patch you
> replied to.
> 

Hrm, then atomic add/dec should not be implemented on top of the add/sub
return with memory barriers, given this would kill performance for no
reason. It would be better to re-implement mb-less add/dec and add those
smp_mb__*() primitives.

But you are right : it's not a bug, just... very slow.

> > Also, bitops.h should have : (taken from powerpc)
> > 
> > /*
> >  * clear_bit doesn't imply a memory barrier
> >  */
> > #define smp_mb__before_clear_bit()      smp_mb()
> > #define smp_mb__after_clear_bit()       smp_mb()
> 
> Again, disagree.  With the current definition being mb(), they become
> either:
> 
> - a compiler barrier on UP architectures (which don't have weak ordering
>   models)
> - a data memory barrier on UP coherent xscale (don't know if this has
>   weak ordering)
> - a data memory barrier on SMP
> 
> So, I think no change is required; mb() is doing at least the right thing.
> (Whether it's heavier than it actually needs to be is another question,
> and that only affects the coherent xscale stuff.  That is out of my
> knowledge to answer.)

Right, no bug here, only probably much slower.

To give you an order of magnitude, a cmpxchg_local primitive without the
memory barriers takes 11 cycles on my ARMv7 omap3. cmpxchg with mb()
before and after the cmpxchg takes 71 cycles. That's 6.45 times slower.

> 
> > According to atomic_ops.txt, 3 other bitwise atomic ops imply memory
> > barriers :
> > 
> > "There are two special bitops with lock barrier semantics (acquire/release,
> > same as spinlocks). These operate in the same way as their non-_lock/unlock
> > postfixed variants, except that they are to provide acquire/release semantics,
> > respectively. This means they can be used for bit_spin_trylock and
> > bit_spin_unlock type operations without specifying any more barriers.
> > 
> >         int test_and_set_bit_lock(unsigned long nr, unsigned long *addr);
> >         void clear_bit_unlock(unsigned long nr, unsigned long *addr);
> >         void __clear_bit_unlock(unsigned long nr, unsigned long *addr);
> > 
> > The __clear_bit_unlock version is non-atomic, however it still implements
> > unlock barrier semantics. This can be useful if the lock itself is protecting
> > the other bits in the word."
> 
> It looks to me that if we make arch/arm/lib/bitops.h fully ordered then
> these get sorted out for free.
> 

Yes, this has been my first thought too. I think all these
implementations use bitops.h.

> > arch/arm/include/asm/mutex.h should also have smp_mb() to provide
> > acquire/release semantic to mutex fastpath (like spinlock does),
> > otherwise subtle deadlocks and various problems could occur.
> 
> Hmm, the mutex is undocumented in the atomic ops document.  Does it
> require ordering both before and after, or do some of those ops just
> need it before acquire and after release?
> 

I guess the mutex fast path should probably be added to atomic_ops.txt.
If I look at PowerPC mutex.h, mutex lock provides acquire semantic (like
spinlock) and mutex unlock provides release semantic (like spin unlock).

acquire :

take lock
smp_mb()
(critical section memory accesses)

release :

(critical section memory accesses)
smp_mb()
release lock

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
