Return-Path: <linux-kernel-owner+w=401wt.eu-S1765807AbXHTUju@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765807AbXHTUju (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 16:39:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762801AbXHTUiN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 16:38:13 -0400
Received: from tomts40.bellnexxia.net ([209.226.175.97]:40267 "EHLO
	tomts40-srv.bellnexxia.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932310AbXHTUiK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 16:38:10 -0400
Date: Mon, 20 Aug 2007 16:38:07 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: clameter@sgi.com, mingo@redhat.com
Subject: Re: [patch 01/11] Fall back on interrupt disable in cmpxchg8b on 80386 and 80486
Message-ID: <20070820203807.GB20936@Krystal>
References: <20070820201902.597091353@polymtl.ca> <20070820202145.083007928@polymtl.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20070820202145.083007928@polymtl.ca>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 16:37:38 up 21 days, 20:56,  4 users,  load average: 2.62, 2.18, 1.46
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Clearly this signle patch is a duplicate from the previous patchset,
please do not apply.

* Mathieu Desnoyers (mathieu.desnoyers@polymtl.ca) wrote:
> Actually, on 386, cmpxchg and cmpxchg_local fall back on
> cmpxchg_386_u8/16/32: it disables interruptions around non atomic
> updates to mimic the cmpxchg behavior.
> 
> The comment:
> /* Poor man's cmpxchg for 386. Unsuitable for SMP */
> 
> already present in cmpxchg_386_u32 tells much about how this cmpxchg
> implementation should not be used in a SMP context. However, the cmpxchg_local
> can perfectly use this fallback, since it only needs to be atomic wrt the local
> cpu.
> 
> This patch adds a cmpxchg_486_u64 and uses it as a fallback for cmpxchg64
> and cmpxchg64_local on 80386 and 80486.
> 
> Q:
> but why is it called cmpxchg_486 when the other functions are called
> 
> A:
> Because the standard cmpxchg is missing only on 386, but cmpxchg8b is
> missing both on 386 and 486.
> 
> Citing Intel's Instruction set reference:
> 
> cmpxchg:
> This instruction is not supported on Intel processors earlier than the
> Intel486 processors.
> 
> cmpxchg8b:
> This instruction encoding is not supported on Intel processors earlier
> than the Pentium processors.
> 
> Q:
> What's the reason to have cmpxchg64_local on 32 bit architectures?
> Without that need all this would just be a few simple defines.
> 
> A:
> cmpxchg64_local on 32 bits architectures takes unsigned long long
> parameters, but cmpxchg_local only takes longs. Since we have cmpxchg8b
> to execute a 8 byte cmpxchg atomically on pentium and +, it makes sense
> to provide a flavor of cmpxchg and cmpxchg_local using this instruction.
> 
> Also, for 32 bits architectures lacking the 64 bits atomic cmpxchg, it
> makes sense _not_ to define cmpxchg64 while cmpxchg could still be
> available.
> 
> Moreover, the fallback for cmpxchg8b on i386 for 386 and 486 is a
> different case than cmpxchg (which is only required for 386). Using
> different code makes this easier.
> 
> However, cmpxchg64_local will be emulated by disabling interrupts on all
> architectures where it is not supported atomically.
> 
> Therefore, we *could* turn cmpxchg64_local into a cmpxchg_local, but it
> would make the 386/486 fallbacks ugly, make its design different from
> cmpxchg/cmpxchg64 (which really depends on atomic operations and cannot
> be emulated) and require the __cmpxchg_local to be expressed as a macro
> rather than an inline function so the parameters would not be fixed to
> unsigned long long in every case.
> 
> So I think cmpxchg64_local makes sense there, but I am open to
> suggestions.
> 
> 
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> CC: clameter@sgi.com
> CC: mingo@redhat.com
> ---
>  arch/i386/kernel/cpu/intel.c |   17 +++++++
>  include/asm-i386/cmpxchg.h   |  100 +++++++++++++++++++++++++++++--------------
>  2 files changed, 85 insertions(+), 32 deletions(-)
> 
> Index: linux-2.6-lttng/arch/i386/kernel/cpu/intel.c
> ===================================================================
> --- linux-2.6-lttng.orig/arch/i386/kernel/cpu/intel.c	2007-08-07 11:00:43.000000000 -0400
> +++ linux-2.6-lttng/arch/i386/kernel/cpu/intel.c	2007-08-07 11:11:07.000000000 -0400
> @@ -329,5 +329,22 @@ unsigned long cmpxchg_386_u32(volatile v
>  EXPORT_SYMBOL(cmpxchg_386_u32);
>  #endif
>  
> +#ifndef CONFIG_X86_CMPXCHG64
> +unsigned long long cmpxchg_486_u64(volatile void *ptr, u64 old, u64 new)
> +{
> +	u64 prev;
> +	unsigned long flags;
> +
> +	/* Poor man's cmpxchg8b for 386 and 486. Unsuitable for SMP */
> +	local_irq_save(flags);
> +	prev = *(u64 *)ptr;
> +	if (prev == old)
> +		*(u64 *)ptr = new;
> +	local_irq_restore(flags);
> +	return prev;
> +}
> +EXPORT_SYMBOL(cmpxchg_486_u64);
> +#endif
> +
>  // arch_initcall(intel_cpu_init);
>  
> Index: linux-2.6-lttng/include/asm-i386/cmpxchg.h
> ===================================================================
> --- linux-2.6-lttng.orig/include/asm-i386/cmpxchg.h	2007-08-07 11:01:17.000000000 -0400
> +++ linux-2.6-lttng/include/asm-i386/cmpxchg.h	2007-08-07 11:16:42.000000000 -0400
> @@ -116,6 +116,15 @@ static inline unsigned long __xchg(unsig
>  					(unsigned long)(n),sizeof(*(ptr))))
>  #endif
>  
> +#ifdef CONFIG_X86_CMPXCHG64
> +#define cmpxchg64(ptr,o,n)\
> +	((__typeof__(*(ptr)))__cmpxchg64((ptr),(unsigned long long)(o),\
> +					(unsigned long long)(n)))
> +#define cmpxchg64_local(ptr,o,n)\
> +	((__typeof__(*(ptr)))__cmpxchg64_local((ptr),(unsigned long long)(o),\
> +					(unsigned long long)(n)))
> +#endif
> +
>  static inline unsigned long __cmpxchg(volatile void *ptr, unsigned long old,
>  				      unsigned long new, int size)
>  {
> @@ -203,6 +212,34 @@ static inline unsigned long __cmpxchg_lo
>  	return old;
>  }
>  
> +static inline unsigned long long __cmpxchg64(volatile void *ptr,
> +			unsigned long long old, unsigned long long new)
> +{
> +	unsigned long long prev;
> +	__asm__ __volatile__(LOCK_PREFIX "cmpxchg8b %3"
> +			     : "=A"(prev)
> +			     : "b"((unsigned long)new),
> +			       "c"((unsigned long)(new >> 32)),
> +			       "m"(*__xg(ptr)),
> +			       "0"(old)
> +			     : "memory");
> +	return prev;
> +}
> +
> +static inline unsigned long long __cmpxchg64_local(volatile void *ptr,
> +			unsigned long long old, unsigned long long new)
> +{
> +	unsigned long long prev;
> +	__asm__ __volatile__("cmpxchg8b %3"
> +			     : "=A"(prev)
> +			     : "b"((unsigned long)new),
> +			       "c"((unsigned long)(new >> 32)),
> +			       "m"(*__xg(ptr)),
> +			       "0"(old)
> +			     : "memory");
> +	return prev;
> +}
> +
>  #ifndef CONFIG_X86_CMPXCHG
>  /*
>   * Building a kernel capable running on 80386. It may be necessary to
> @@ -252,38 +289,37 @@ static inline unsigned long cmpxchg_386(
>  })
>  #endif
>  
> -static inline unsigned long long __cmpxchg64(volatile void *ptr, unsigned long long old,
> -				      unsigned long long new)
> -{
> -	unsigned long long prev;
> -	__asm__ __volatile__(LOCK_PREFIX "cmpxchg8b %3"
> -			     : "=A"(prev)
> -			     : "b"((unsigned long)new),
> -			       "c"((unsigned long)(new >> 32)),
> -			       "m"(*__xg(ptr)),
> -			       "0"(old)
> -			     : "memory");
> -	return prev;
> -}
> +#ifndef CONFIG_X86_CMPXCHG64
> +/*
> + * Building a kernel capable running on 80386 and 80486. It may be necessary
> + * to simulate the cmpxchg8b on the 80386 and 80486 CPU.
> + */
> +
> +extern unsigned long long cmpxchg_486_u64(volatile void *, u64, u64);
> +
> +#define cmpxchg64(ptr,o,n)						\
> +({									\
> +	__typeof__(*(ptr)) __ret;					\
> +	if (likely(boot_cpu_data.x86 > 4))				\
> +		__ret = __cmpxchg64((ptr), (unsigned long long)(o),	\
> +				(unsigned long long)(n));		\
> +	else								\
> +		__ret = cmpxchg_486_u64((ptr), (unsigned long long)(o),	\
> +				(unsigned long long)(n));		\
> +	__ret;								\
> +})
> +#define cmpxchg64_local(ptr,o,n)					\
> +({									\
> +	__typeof__(*(ptr)) __ret;					\
> +	if (likely(boot_cpu_data.x86 > 4))				\
> +		__ret = __cmpxchg64_local((ptr), (unsigned long long)(o), \
> +				(unsigned long long)(n));		\
> +	else								\
> +		__ret = cmpxchg_486_u64((ptr), (unsigned long long)(o),	\
> +				(unsigned long long)(n));		\
> +	__ret;								\
> +})
>  
> -static inline unsigned long long __cmpxchg64_local(volatile void *ptr,
> -			unsigned long long old, unsigned long long new)
> -{
> -	unsigned long long prev;
> -	__asm__ __volatile__("cmpxchg8b %3"
> -			     : "=A"(prev)
> -			     : "b"((unsigned long)new),
> -			       "c"((unsigned long)(new >> 32)),
> -			       "m"(*__xg(ptr)),
> -			       "0"(old)
> -			     : "memory");
> -	return prev;
> -}
> +#endif
>  
> -#define cmpxchg64(ptr,o,n)\
> -	((__typeof__(*(ptr)))__cmpxchg64((ptr),(unsigned long long)(o),\
> -					(unsigned long long)(n)))
> -#define cmpxchg64_local(ptr,o,n)\
> -	((__typeof__(*(ptr)))__cmpxchg64_local((ptr),(unsigned long long)(o),\
> -					(unsigned long long)(n)))
>  #endif
> 
> -- 
> Mathieu Desnoyers
> Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
> OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
