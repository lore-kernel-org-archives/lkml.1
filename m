Return-Path: <linux-kernel-owner+w=401wt.eu-S1751689AbZEZPhQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751689AbZEZPhQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 11:37:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752491AbZEZPhG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 11:37:06 -0400
Received: from tomts40.bellnexxia.net ([209.226.175.97]:52144 "EHLO
	tomts40-srv.bellnexxia.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751015AbZEZPhF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 11:37:05 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArsKAFOkG0pMQW1W/2dsb2JhbACBT5Z4tnaECwU
Date: Tue, 26 May 2009 11:36:54 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Jamie Lokier <jamie@shareable.org>,
       Catalin Marinas <catalin.marinas@arm.com>,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org
Subject: Re: Broken ARM atomic ops wrt memory barriers (was : [PATCH] Add
	cmpxchg support for ARMv6+ systems)
Message-ID: <20090526153654.GA17096@Krystal>
References: <20090422171703.19555.83629.stgit@pc1117.cambridge.arm.com> <20090423141248.22193.10543.stgit@pc1117.cambridge.arm.com> <20090524131636.GB3159@n2100.arm.linux.org.uk> <20090524145633.GA14754@Krystal> <20090525132027.GA946@shareable.org> <20090525151724.GA14321@Krystal> <20090525161941.GA3667@n2100.arm.linux.org.uk> <20090526145950.GB26713@n2100.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20090526145950.GB26713@n2100.arm.linux.org.uk>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 11:28:59 up 87 days, 11:55,  5 users,  load average: 0.05, 0.10,
	0.09
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Russell King - ARM Linux (linux@arm.linux.org.uk) wrote:
> Here's an updated version of the patch:
> 
> adds a data memory barrier before and after these operations:
> - test_and_xxx_bit()
> - atomic_xxx_return()
> - atomic_cmpxchg()
> - __xchg
> 
> Also:
> - converts smp_mb__*_atomic_*() to use smp_mb()
> - ensures __kuser_memory_barrier uses the right instruction on ARMv7
> 
> diff --git a/arch/arm/include/asm/assembler.h b/arch/arm/include/asm/assembler.h
> index 6116e48..15f8a09 100644
> --- a/arch/arm/include/asm/assembler.h
> +++ b/arch/arm/include/asm/assembler.h
> @@ -114,3 +114,16 @@
>  	.align	3;				\
>  	.long	9999b,9001f;			\
>  	.previous
> +
> +/*
> + * SMP data memory barrier
> + */
> +	.macro	smp_dmb
> +#ifdef CONFIG_SMP
> +#if __LINUX_ARM_ARCH__ >= 7
> +	dmb
> +#elif __LINUX_ARM_ARCH__ == 6
> +	mcr	p15, 0, r0, c7, c10, 5	@ dmb
> +#endif
> +#endif
> +	.endm
> diff --git a/arch/arm/include/asm/atomic.h b/arch/arm/include/asm/atomic.h
> index ee99723..16b52f3 100644
> --- a/arch/arm/include/asm/atomic.h
> +++ b/arch/arm/include/asm/atomic.h
> @@ -44,11 +44,29 @@ static inline void atomic_set(atomic_t *v, int i)
>  	: "cc");
>  }
>  
> +static inline void atomic_add(int i, atomic_t *v)
> +{
> +	unsigned long tmp;
> +	int result;
> +
> +	__asm__ __volatile__("@ atomic_add\n"
> +"1:	ldrex	%0, [%2]\n"
> +"	add	%0, %0, %3\n"
> +"	strex	%1, %0, [%2]\n"
> +"	teq	%1, #0\n"
> +"	bne	1b"
> +	: "=&r" (result), "=&r" (tmp)
> +	: "r" (&v->counter), "Ir" (i)
> +	: "cc");
> +}
> +
>  static inline int atomic_add_return(int i, atomic_t *v)
>  {
>  	unsigned long tmp;
>  	int result;
>  
> +	smp_mb();
> +
>  	__asm__ __volatile__("@ atomic_add_return\n"
>  "1:	ldrex	%0, [%2]\n"
>  "	add	%0, %0, %3\n"
> @@ -59,14 +77,34 @@ static inline int atomic_add_return(int i, atomic_t *v)
>  	: "r" (&v->counter), "Ir" (i)
>  	: "cc");
>  
> +	smp_mb();
> +
>  	return result;
>  }
>  
> +static inline void atomic_sub(int i, atomic_t *v)
> +{
> +	unsigned long tmp;
> +	int result;
> +
> +	__asm__ __volatile__("@ atomic_sub\n"
> +"1:	ldrex	%0, [%2]\n"
> +"	sub	%0, %0, %3\n"
> +"	strex	%1, %0, [%2]\n"
> +"	teq	%1, #0\n"
> +"	bne	1b"
> +	: "=&r" (result), "=&r" (tmp)
> +	: "r" (&v->counter), "Ir" (i)
> +	: "cc");
> +}
> +
>  static inline int atomic_sub_return(int i, atomic_t *v)
>  {
>  	unsigned long tmp;
>  	int result;
>  
> +	smp_mb();
> +
>  	__asm__ __volatile__("@ atomic_sub_return\n"
>  "1:	ldrex	%0, [%2]\n"
>  "	sub	%0, %0, %3\n"
> @@ -77,6 +115,8 @@ static inline int atomic_sub_return(int i, atomic_t *v)
>  	: "r" (&v->counter), "Ir" (i)
>  	: "cc");
>  
> +	smp_mb();
> +
>  	return result;
>  }
>  
> @@ -84,6 +124,8 @@ static inline int atomic_cmpxchg(atomic_t *ptr, int old, int new)
>  {
>  	unsigned long oldval, res;
>  
> +	smp_mb();
> +
>  	do {
>  		__asm__ __volatile__("@ atomic_cmpxchg\n"
>  		"ldrex	%1, [%2]\n"
> @@ -95,6 +137,8 @@ static inline int atomic_cmpxchg(atomic_t *ptr, int old, int new)
>  		    : "cc");
>  	} while (res);
>  
> +	smp_mb();
> +
>  	return oldval;
>  }
>  
> @@ -135,6 +179,7 @@ static inline int atomic_add_return(int i, atomic_t *v)
>  
>  	return val;
>  }
> +#define atomic_add(i, v)	(void) atomic_add_return(i, v)
>  
>  static inline int atomic_sub_return(int i, atomic_t *v)
>  {
> @@ -148,6 +193,7 @@ static inline int atomic_sub_return(int i, atomic_t *v)
>  
>  	return val;
>  }
> +#define atomic_sub(i, v)	(void) atomic_sub_return(i, v)
>  
>  static inline int atomic_cmpxchg(atomic_t *v, int old, int new)
>  {
> @@ -187,10 +233,8 @@ static inline int atomic_add_unless(atomic_t *v, int a, int u)
>  }
>  #define atomic_inc_not_zero(v) atomic_add_unless((v), 1, 0)
>  
> -#define atomic_add(i, v)	(void) atomic_add_return(i, v)
> -#define atomic_inc(v)		(void) atomic_add_return(1, v)
> -#define atomic_sub(i, v)	(void) atomic_sub_return(i, v)
> -#define atomic_dec(v)		(void) atomic_sub_return(1, v)
> +#define atomic_inc(v)		atomic_add(1, v)
> +#define atomic_dec(v)		atomic_sub(1, v)
>  
>  #define atomic_inc_and_test(v)	(atomic_add_return(1, v) == 0)
>  #define atomic_dec_and_test(v)	(atomic_sub_return(1, v) == 0)
> @@ -200,11 +244,10 @@ static inline int atomic_add_unless(atomic_t *v, int a, int u)
>  
>  #define atomic_add_negative(i,v) (atomic_add_return(i, v) < 0)
>  
> -/* Atomic operations are already serializing on ARM */
> -#define smp_mb__before_atomic_dec()	barrier()
> -#define smp_mb__after_atomic_dec()	barrier()
> -#define smp_mb__before_atomic_inc()	barrier()
> -#define smp_mb__after_atomic_inc()	barrier()
> +#define smp_mb__before_atomic_dec()	smp_mb()
> +#define smp_mb__after_atomic_dec()	smp_mb()
> +#define smp_mb__before_atomic_inc()	smp_mb()
> +#define smp_mb__after_atomic_inc()	smp_mb()
>  
>  #include <asm-generic/atomic.h>
>  #endif
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

I would not remove the "memory" constraint in here. Anyway it's just a
compiler barrier, I doubt it would make anyting faster (due to the
following smp_mb() added), but it surely makes things harder to
understand.

>  		break;
>  	case 4:
>  		asm volatile("@	__xchg4\n"
> @@ -268,7 +270,7 @@ static inline unsigned long __xchg(unsigned long x, volatile void *ptr, int size
>  		"	bne	1b"
>  			: "=&r" (ret), "=&r" (tmp)
>  			: "r" (x), "r" (ptr)
> -			: "memory", "cc");

Same.

> +			: "cc");
>  		break;
>  #elif defined(swp_is_buggy)
>  #ifdef CONFIG_SMP
> @@ -293,20 +295,21 @@ static inline unsigned long __xchg(unsigned long x, volatile void *ptr, int size
>  		"	swpb	%0, %1, [%2]"
>  			: "=&r" (ret)
>  			: "r" (x), "r" (ptr)
> -			: "memory", "cc");

Same.

> +			: "cc");
>  		break;
>  	case 4:
>  		asm volatile("@	__xchg4\n"
>  		"	swp	%0, %1, [%2]"
>  			: "=&r" (ret)
>  			: "r" (x), "r" (ptr)
> -			: "memory", "cc");

Same.

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
> diff --git a/arch/arm/kernel/entry-armv.S b/arch/arm/kernel/entry-armv.S
> index d662a2f..83b1da6 100644
> --- a/arch/arm/kernel/entry-armv.S
> +++ b/arch/arm/kernel/entry-armv.S
> @@ -815,10 +815,7 @@ __kuser_helper_start:
>   */
>  
>  __kuser_memory_barrier:				@ 0xffff0fa0
> -
> -#if __LINUX_ARM_ARCH__ >= 6 && defined(CONFIG_SMP)
> -	mcr	p15, 0, r0, c7, c10, 5	@ dmb
> -#endif
> +	smp_dmb
>  	usr_ret	lr
>  
>  	.align	5
> diff --git a/arch/arm/lib/bitops.h b/arch/arm/lib/bitops.h
> index 2e787d4..c7f2627 100644
> --- a/arch/arm/lib/bitops.h
> +++ b/arch/arm/lib/bitops.h
> @@ -18,12 +18,14 @@
>  	mov	r2, #1
>  	add	r1, r1, r0, lsr #3	@ Get byte offset
>  	mov	r3, r2, lsl r3		@ create mask
> +	smp_dmb
>  1:	ldrexb	r2, [r1]
>  	ands	r0, r2, r3		@ save old value of bit
>  	\instr	r2, r2, r3			@ toggle bit
>  	strexb	ip, r2, [r1]
>  	cmp	ip, #0
>  	bne	1b
> +	smp_dmb
>  	cmp	r0, #0
>  	movne	r0, #1
>  2:	mov	pc, lr
> 

The rest looks good.

Note that we still have not checked if the full dmb is really needed
before and after each operations. For instance, lwsync (before) + isync
(after) is enough for powerpc. I suppose this is because the CPU is not
free to reorder reads when there is a data dependency.

So adding full dmb as we do here is surely safe, but might be slower
than the optimal solution.

If we determine that some reorderings are not possible on ARM, we might
eventually change rmb() for a simple barrier() and make atomic op
barriers a bit more lightweight.

But let's first make it work.

Thanks,

Mathieu


-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
