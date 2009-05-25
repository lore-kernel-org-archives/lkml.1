Return-Path: <linux-kernel-owner+w=401wt.eu-S1753934AbZEYRaF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753934AbZEYRaF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 13:30:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752441AbZEYR34
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 13:29:56 -0400
Received: from tomts10.bellnexxia.net ([209.226.175.54]:58595 "EHLO
	tomts10-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752099AbZEYR34 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 13:29:56 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArQHADtyGkpMQW1W/2dsb2JhbACBT5Zts3mECwU
Date: Mon, 25 May 2009 13:29:55 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Jamie Lokier <jamie@shareable.org>,
       Catalin Marinas <catalin.marinas@arm.com>,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org
Subject: Re: Broken ARM atomic ops wrt memory barriers (was : [PATCH] Add
	cmpxchg support for ARMv6+ systems)
Message-ID: <20090525172955.GA17665@Krystal>
References: <20090422171703.19555.83629.stgit@pc1117.cambridge.arm.com> <20090423141248.22193.10543.stgit@pc1117.cambridge.arm.com> <20090524131636.GB3159@n2100.arm.linux.org.uk> <20090524145633.GA14754@Krystal> <20090525132027.GA946@shareable.org> <20090525151724.GA14321@Krystal> <20090525161941.GA3667@n2100.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20090525161941.GA3667@n2100.arm.linux.org.uk>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 13:26:15 up 86 days, 13:52,  5 users,  load average: 0.02, 0.14,
	0.12
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Russell King - ARM Linux (linux@arm.linux.org.uk) wrote:
> On Mon, May 25, 2009 at 11:17:24AM -0400, Mathieu Desnoyers wrote:
> > I realize I have not made myself clear, I apologise :
> > 
> > - as you say, cmpxchg_local, xchg_local, local atomic add return do not
> >   need any memory barrier whatsoever, given they are cpu-local.
> 
> Presumably that's what we currently have using the generic versions.
> 
> > - cmpxchg, xchg and atomic add return need memory barriers on
> >   architectures which can reorder the relative order in which memory
> >   read/writes can be seen between CPUs, which seems to include recent
> >   ARM architectures. Those barriers are currently missing on ARM.
> 
> cmpxchg is not implemented on SMP (yet) so we can ignore that.
> 

Right, but atomic_cmpxchg is, and there really aren't much difference
between those two, especially if you choose to only support cmpxchg on
32-bits values. (powerpc only supports 32 or 64-bits cmpxchg, so that
would not be the first time)

> However, xchg and atomic ops returning values are, and as you point out
> are missing the necessary barriers.  So, here's a patch which adds the
> necessary barriers both before and after these ops (as required by the
> atomic ops doc.)
> 
> Does this satisfy your immediate concern?
> 


This is a very good start, but I think a few are still missing :

in atomic.h :

/* Atomic operations are already serializing on ARM */
#define smp_mb__before_atomic_dec()     barrier()
#define smp_mb__after_atomic_dec()      barrier()
#define smp_mb__before_atomic_inc()     barrier()
#define smp_mb__after_atomic_inc()      barrier()

should probably map to smp_mb() for arm v6+.

Also, bitops.h should have : (taken from powerpc)

/*
 * clear_bit doesn't imply a memory barrier
 */
#define smp_mb__before_clear_bit()      smp_mb()
#define smp_mb__after_clear_bit()       smp_mb()

According to atomic_ops.txt, 3 other bitwise atomic ops imply memory
barriers :

"There are two special bitops with lock barrier semantics (acquire/release,
same as spinlocks). These operate in the same way as their non-_lock/unlock
postfixed variants, except that they are to provide acquire/release semantics,
respectively. This means they can be used for bit_spin_trylock and
bit_spin_unlock type operations without specifying any more barriers.

        int test_and_set_bit_lock(unsigned long nr, unsigned long *addr);
        void clear_bit_unlock(unsigned long nr, unsigned long *addr);
        void __clear_bit_unlock(unsigned long nr, unsigned long *addr);

The __clear_bit_unlock version is non-atomic, however it still implements
unlock barrier semantics. This can be useful if the lock itself is protecting
the other bits in the word."

arch/arm/include/asm/mutex.h should also have smp_mb() to provide
acquire/release semantic to mutex fastpath (like spinlock does),
otherwise subtle deadlocks and various problems could occur.

Basically, to make sure we don't forget anything, someone should go
through all the atomic_ops.txt document once more and audit all ARM
primitives.

grep -r ldrex arch/arm/*

is also a good start. The others it covers I have not mentioned here
yet :

arch/arm/include/asm/locks.h (this one is OK, has smp_mb())
arch/arm/kernel/entry-armv.S (OK too, has a dmb)
arch/arm/lib/bitops.h (used for test and set bit ops, smp_mb()s seems
                       missing)

Thanks,

Mathieu


> diff --git a/arch/arm/include/asm/atomic.h b/arch/arm/include/asm/atomic.h
> index ee99723..4d3ad67 100644
> --- a/arch/arm/include/asm/atomic.h
> +++ b/arch/arm/include/asm/atomic.h
> @@ -49,6 +49,8 @@ static inline int atomic_add_return(int i, atomic_t *v)
>  	unsigned long tmp;
>  	int result;
>  
> +	smp_mb();
> +
>  	__asm__ __volatile__("@ atomic_add_return\n"
>  "1:	ldrex	%0, [%2]\n"
>  "	add	%0, %0, %3\n"
> @@ -59,6 +61,8 @@ static inline int atomic_add_return(int i, atomic_t *v)
>  	: "r" (&v->counter), "Ir" (i)
>  	: "cc");
>  
> +	smp_mb();
> +
>  	return result;
>  }
>  
> @@ -67,6 +71,8 @@ static inline int atomic_sub_return(int i, atomic_t *v)
>  	unsigned long tmp;
>  	int result;
>  
> +	smp_mb();
> +
>  	__asm__ __volatile__("@ atomic_sub_return\n"
>  "1:	ldrex	%0, [%2]\n"
>  "	sub	%0, %0, %3\n"
> @@ -77,6 +83,8 @@ static inline int atomic_sub_return(int i, atomic_t *v)
>  	: "r" (&v->counter), "Ir" (i)
>  	: "cc");
>  
> +	smp_mb();
> +
>  	return result;
>  }
>  
> @@ -84,6 +92,8 @@ static inline int atomic_cmpxchg(atomic_t *ptr, int old, int new)
>  {
>  	unsigned long oldval, res;
>  
> +	smp_mb();
> +
>  	do {
>  		__asm__ __volatile__("@ atomic_cmpxchg\n"
>  		"ldrex	%1, [%2]\n"
> @@ -95,6 +105,8 @@ static inline int atomic_cmpxchg(atomic_t *ptr, int old, int new)
>  		    : "cc");
>  	} while (res);
>  
> +	smp_mb();
> +
>  	return oldval;
>  }
>  
> diff --git a/arch/arm/include/asm/system.h b/arch/arm/include/asm/system.h
> index bd4dc8e..e9889c2 100644
> --- a/arch/arm/include/asm/system.h
> +++ b/arch/arm/include/asm/system.h
> @@ -248,6 +248,8 @@ static inline unsigned long __xchg(unsigned long x, volatile void *ptr, int size
>  	unsigned int tmp;
>  #endif
>  
> +	smp_mb();
> +
>  	switch (size) {
>  #if __LINUX_ARM_ARCH__ >= 6
>  	case 1:
> @@ -258,7 +260,7 @@ static inline unsigned long __xchg(unsigned long x, volatile void *ptr, int size
>  		"	bne	1b"
>  			: "=&r" (ret), "=&r" (tmp)
>  			: "r" (x), "r" (ptr)
> -			: "memory", "cc");
> +			: "cc");
>  		break;
>  	case 4:
>  		asm volatile("@	__xchg4\n"
> @@ -268,7 +270,7 @@ static inline unsigned long __xchg(unsigned long x, volatile void *ptr, int size
>  		"	bne	1b"
>  			: "=&r" (ret), "=&r" (tmp)
>  			: "r" (x), "r" (ptr)
> -			: "memory", "cc");
> +			: "cc");
>  		break;
>  #elif defined(swp_is_buggy)
>  #ifdef CONFIG_SMP
> @@ -293,20 +295,21 @@ static inline unsigned long __xchg(unsigned long x, volatile void *ptr, int size
>  		"	swpb	%0, %1, [%2]"
>  			: "=&r" (ret)
>  			: "r" (x), "r" (ptr)
> -			: "memory", "cc");
> +			: "cc");
>  		break;
>  	case 4:
>  		asm volatile("@	__xchg4\n"
>  		"	swp	%0, %1, [%2]"
>  			: "=&r" (ret)
>  			: "r" (x), "r" (ptr)
> -			: "memory", "cc");
> +			: "cc");
>  		break;
>  #endif
>  	default:
>  		__bad_xchg(ptr, size), ret = 0;
>  		break;
>  	}
> +	smp_mb();
>  
>  	return ret;
>  }

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
