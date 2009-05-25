Return-Path: <linux-kernel-owner+w=401wt.eu-S1754272AbZEYT5X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754272AbZEYT5X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 15:57:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751824AbZEYT5Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 15:57:16 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:36383 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750979AbZEYT5P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 15:57:15 -0400
Date: Mon, 25 May 2009 20:56:56 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Jamie Lokier <jamie@shareable.org>,
       Catalin Marinas <catalin.marinas@arm.com>,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org
Subject: Re: Broken ARM atomic ops wrt memory barriers (was : [PATCH] Add
	cmpxchg support for ARMv6+ systems)
Message-ID: <20090525195656.GC3667@n2100.arm.linux.org.uk>
References: <20090422171703.19555.83629.stgit@pc1117.cambridge.arm.com> <20090423141248.22193.10543.stgit@pc1117.cambridge.arm.com> <20090524131636.GB3159@n2100.arm.linux.org.uk> <20090524145633.GA14754@Krystal> <20090525132027.GA946@shareable.org> <20090525151724.GA14321@Krystal> <20090525161941.GA3667@n2100.arm.linux.org.uk> <20090525172955.GA17665@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090525172955.GA17665@Krystal>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reply is based upon what's in your email rather than atomic_ops.

On Mon, May 25, 2009 at 01:29:55PM -0400, Mathieu Desnoyers wrote:
> This is a very good start, but I think a few are still missing :
> 
> in atomic.h :
> 
> /* Atomic operations are already serializing on ARM */
> #define smp_mb__before_atomic_dec()     barrier()
> #define smp_mb__after_atomic_dec()      barrier()
> #define smp_mb__before_atomic_inc()     barrier()
> #define smp_mb__after_atomic_inc()      barrier()
> 
> should probably map to smp_mb() for arm v6+.

BTW, I think you're wrong here.  atomic_dec() and atomic_inc() are
implemented using atomic_add_return() and atomic_sub_return().  Both
of these functions are serializing as a result of the patch you
replied to.

> Also, bitops.h should have : (taken from powerpc)
> 
> /*
>  * clear_bit doesn't imply a memory barrier
>  */
> #define smp_mb__before_clear_bit()      smp_mb()
> #define smp_mb__after_clear_bit()       smp_mb()

Again, disagree.  With the current definition being mb(), they become
either:

- a compiler barrier on UP architectures (which don't have weak ordering
  models)
- a data memory barrier on UP coherent xscale (don't know if this has
  weak ordering)
- a data memory barrier on SMP

So, I think no change is required; mb() is doing at least the right thing.
(Whether it's heavier than it actually needs to be is another question,
and that only affects the coherent xscale stuff.  That is out of my
knowledge to answer.)

> According to atomic_ops.txt, 3 other bitwise atomic ops imply memory
> barriers :
> 
> "There are two special bitops with lock barrier semantics (acquire/release,
> same as spinlocks). These operate in the same way as their non-_lock/unlock
> postfixed variants, except that they are to provide acquire/release semantics,
> respectively. This means they can be used for bit_spin_trylock and
> bit_spin_unlock type operations without specifying any more barriers.
> 
>         int test_and_set_bit_lock(unsigned long nr, unsigned long *addr);
>         void clear_bit_unlock(unsigned long nr, unsigned long *addr);
>         void __clear_bit_unlock(unsigned long nr, unsigned long *addr);
> 
> The __clear_bit_unlock version is non-atomic, however it still implements
> unlock barrier semantics. This can be useful if the lock itself is protecting
> the other bits in the word."

It looks to me that if we make arch/arm/lib/bitops.h fully ordered then
these get sorted out for free.

> arch/arm/include/asm/mutex.h should also have smp_mb() to provide
> acquire/release semantic to mutex fastpath (like spinlock does),
> otherwise subtle deadlocks and various problems could occur.

Hmm, the mutex is undocumented in the atomic ops document.  Does it
require ordering both before and after, or do some of those ops just
need it before acquire and after release?

