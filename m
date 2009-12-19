Return-Path: <linux-kernel-owner+w=401wt.eu-S1752583AbZLSOp3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752583AbZLSOp3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Dec 2009 09:45:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752372AbZLSOp2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Dec 2009 09:45:28 -0500
Received: from tomts20-srv.bellnexxia.net ([209.226.175.74]:58307 "EHLO
	tomts20-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752133AbZLSOp1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Dec 2009 09:45:27 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApwEANtzLEtGGNs5/2dsb2JhbACBStF0hC4E
Date: Sat, 19 Dec 2009 09:45:20 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
       Mel Gorman <mel@csn.ul.ie>, Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [this_cpu_xx V8 11/16] Generic support for this_cpu_cmpxchg
Message-ID: <20091219144520.GA9134@Krystal>
References: <20091218222617.384355422@quilx.com> <20091218222653.560936448@quilx.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20091218222653.560936448@quilx.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 09:39:01 up 2 days, 22:57,  3 users,  load average: 0.44, 0.34,
	0.26
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Christoph Lameter (cl@linux-foundation.org) wrote:
> Provide support for this_cpu_cmpxchg.
> 
> Signed-off-by: Christoph Lameter <cl@linux-foundation.org>
> 
> ---
>  include/linux/percpu.h |   99 +++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 99 insertions(+)
> 
> Index: linux-2.6/include/linux/percpu.h
> ===================================================================
> --- linux-2.6.orig/include/linux/percpu.h	2009-12-18 15:17:05.000000000 -0600
> +++ linux-2.6/include/linux/percpu.h	2009-12-18 15:33:12.000000000 -0600
> @@ -443,6 +443,62 @@ do {									\
>  # define this_cpu_xor(pcp, val)		__pcpu_size_call(this_cpu_or_, (pcp), (val))
>  #endif
>  
> +static inline unsigned long __this_cpu_cmpxchg_generic(volatile void *pptr,
> +		unsigned long old, unsigned long new, int size)
> +{
> +	unsigned long prev;
> +	volatile void * ptr = __this_cpu_ptr(pptr);
> +
> +	switch (size) {
> +	case 1: prev = *(u8 *)ptr;
> +		if (prev == old)
> +			*(u8 *)ptr = (u8)new;
> +		break;
> +	case 2: prev = *(u16 *)ptr;
> +		if (prev == old)
> +			*(u16 *)ptr = (u16)new;
> +		break;
> +	case 4: prev = *(u32 *)ptr;
> +		if (prev == old)
> +			*(u32 *)ptr = (u32)new;
> +		break;
> +	case 8: prev = *(u64 *)ptr;
> +		if (prev == old)
> +			*(u64 *)ptr = (u64)new;
> +		break;
> +	default:
> +		__bad_size_call_parameter();
> +	}
> +	return prev;
> +}

Hi Christoph,

I am a bit concerned about the "generic" version of this_cpu_cmpxchg.
Given that what LTTng needs is basically an atomic, nmi-safe version of
the primitive (on all architectures that have something close to a NMI),
this means that it could not switch over to your primitives until we add
the equivalent support we currently have with local_t to all
architectures. The transition would be faster if we create an
atomic_cpu_*() variant which would map to local_t operations in the
initial version.

Or maybe have I missed something in your patchset that address this ?

Thanks,

Mathieu

> +
> +static inline unsigned long this_cpu_cmpxchg_generic(volatile void *ptr,
> +		unsigned long old, unsigned long new, int size)
> +{
> +	unsigned long prev;
> +
> +	preempt_disable();
> +	prev = __this_cpu_cmpxchg_generic(ptr, old, new, size);
> +	preempt_enable();
> +	return prev;
> +}
> +
> +#ifndef this_cpu_cmpxchg
> +# ifndef this_cpu_cmpxchg_1
> +#  define this_cpu_cmpxchg_1(pcp, old, new) this_cpu_cmpxchg_generic((pcp), (old), (new), 1)
> +# endif
> +# ifndef this_cpu_cmpxchg_2
> +#  define this_cpu_cmpxchg_2(pcp, old, new) this_cpu_cmpxchg_generic((pcp), (old), (new), 2)
> +# endif
> +# ifndef this_cpu_cmpxchg_4
> +#  define this_cpu_cmpxchg_4(pcp, old, new) this_cpu_cmpxchg_generic((pcp), (old), (new), 4)
> +# endif
> +# ifndef this_cpu_cmpxchg_8
> +#  define this_cpu_cmpxchg_8(pcp, old, new) this_cpu_cmpxchg_generic((pcp), (old), (new), 8)
> +# endif
> +# define this_cpu_cmpxchg(pcp, old, new) __pcpu_size_call_return(__this_cpu_cmpxchg_, (old), (new))
> +#endif
> +
>  /*
>   * Generic percpu operations that do not require preemption handling.
>   * Either we do not care about races or the caller has the
> @@ -594,6 +650,22 @@ do {									\
>  # define __this_cpu_xor(pcp, val)	__pcpu_size_call(__this_cpu_xor_, (pcp), (val))
>  #endif
>  
> +#ifndef __this_cpu_cmpxchg
> +# ifndef __this_cpu_cmpxchg_1
> +#  define __this_cpu_cmpxchg_1(pcp, old, new) __this_cpu_cmpxchg_generic((pcp), (old), (new), 1)
> +# endif
> +# ifndef __this_cpu_cmpxchg_2
> +#  define __this_cpu_cmpxchg_2(pcp, old, new) __this_cpu_cmpxchg_generic((pcp), (old), (new), 2)
> +# endif
> +# ifndef __this_cpu_cmpxchg_4
> +#  define __this_cpu_cmpxchg_4(pcp, old, new) __this_cpu_cmpxchg_generic((pcp), (old), (new), 4)
> +# endif
> +# ifndef __this_cpu_cmpxchg_8
> +#  define __this_cpu_cmpxchg_8(pcp, old, new) __this_cpu_cmpxchg_generic((pcp), (old), (new), 8)
> +# endif
> +# define __this_cpu_cmpxchg(pcp, old, new) __pcpu_size_call_return(__this_cpu_cmpxchg_, (old), (new))
> +#endif
> +
>  /*
>   * IRQ safe versions of the per cpu RMW operations. Note that these operations
>   * are *not* safe against modification of the same variable from another
> @@ -709,4 +781,31 @@ do {									\
>  # define irqsafe_cpu_xor(pcp, val) __pcpu_size_call(irqsafe_cpu_xor_, (val))
>  #endif
>  
> +static inline unsigned long irqsafe_cpu_cmpxchg_generic(volatile void *ptr,
> +		unsigned long old, unsigned long new, int size)
> +{
> +	unsigned long flags, prev;
> +
> +	local_irq_save(flags);
> +	prev = __this_cpu_cmpxchg_generic(ptr, old, new, size);
> +	local_irq_restore(flags);
> +	return prev;
> +}
> +
> +#ifndef irqsafe_cpu_cmpxchg
> +# ifndef irqsafe_cpu_cmpxchg_1
> +#  define irqsafe_cpu_cmpxchg_1(pcp, old, new) irqsafe_cpu_cmpxchg_generic(((pcp), (old), (new), 1)
> +# endif
> +# ifndef irqsafe_cpu_cmpxchg_2
> +#  define irqsafe_cpu_cmpxchg_2(pcp, old, new) irqsafe_cpu_cmpxchg_generic(((pcp), (old), (new), 2)
> +# endif
> +# ifndef irqsafe_cpu_cmpxchg_4
> +#  define irqsafe_cpu_cmpxchg_4(pcp, old, new) irqsafe_cpu_cmpxchg_generic(((pcp), (old), (new), 4)
> +# endif
> +# ifndef irqsafe_cpu_cmpxchg_8
> +#  define irqsafe_cpu_cmpxchg_8(pcp, old, new) irqsafe_cpu_cmpxchg_generic(((pcp), (old), (new), 8)
> +# endif
> +# define irqsafe_cpu_cmpxchg(pcp, old, new) __pcpu_size_call_return(irqsafe_cpu_cmpxchg_, (old), (new))
> +#endif
> +
>  #endif /* __LINUX_PERCPU_H */
> 
> -- 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
