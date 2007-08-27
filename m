Return-Path: <linux-kernel-owner+w=401wt.eu-S1762984AbXH0VFM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762984AbXH0VFM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 17:05:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760686AbXH0VE4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 17:04:56 -0400
Received: from colo.lackof.org ([198.49.126.79]:59135 "EHLO colo.lackof.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760674AbXH0VEz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 17:04:55 -0400
Date: Mon, 27 Aug 2007 15:04:32 -0600
From: Grant Grundler <grundler@parisc-linux.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       parisc-linux@parisc-linux.org, Christoph Lameter <clameter@sgi.com>
Subject: Re: [parisc-linux] [patch 15/23] Add cmpxchg_local to parisc
Message-ID: <20070827210432.GA22484@colo.lackof.org>
References: <20070812145434.520271946@polymtl.ca> <20070812145840.691277845@polymtl.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070812145840.691277845@polymtl.ca>
X-Home-Page: http://www.parisc-linux.org/
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 12, 2007 at 10:54:49AM -0400, Mathieu Desnoyers wrote:
> Use the new generic cmpxchg_local (disables interrupt). Also use the generic
> cmpxchg as fallback if SMP is not set.

Mathieu,
thanks for adding __cmpxchg_local to parisc.... but why do we need it?

By definition, atomic operators are, well, atomic.

I searched for __cmpxchg_local and found this reference:
    http://www.ussg.iu.edu/hypermail/linux/kernel/0612.2/1337.html

but the "root" of that thread (Dec 20, 2006):
    http://www.ussg.iu.edu/hypermail/linux/kernel/0612.2/1334.html

Doesn't explain the difference between "local" and "non-local" either.
Per CPU data should only need memory barriers (in some cases) and
protection against interrupts (in probably more cases). So I'm not
understanding why a new set of APIs is needed.

Can you add a description to Documentation/atomic_ops.txt ?
*sigh* sorry for being "late to the party" on this one...

cheers,
grant

> 
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> CC: clameter@sgi.com
> CC: parisc-linux@parisc-linux.org
> ---
>  include/asm-parisc/atomic.h |   29 +++++++++++++++++++++++++++++
>  1 file changed, 29 insertions(+)
> 
> Index: linux-2.6-lttng/include/asm-parisc/atomic.h
> ===================================================================
> --- linux-2.6-lttng.orig/include/asm-parisc/atomic.h	2007-07-20 19:44:40.000000000 -0400
> +++ linux-2.6-lttng/include/asm-parisc/atomic.h	2007-07-20 19:44:47.000000000 -0400
> @@ -122,6 +122,35 @@ __cmpxchg(volatile void *ptr, unsigned l
>  				    (unsigned long)_n_, sizeof(*(ptr))); \
>    })
>  
> +#include <asm-generic/cmpxchg-local.h>
> +
> +static inline unsigned long __cmpxchg_local(volatile void *ptr,
> +				      unsigned long old,
> +				      unsigned long new_, int size)
> +{
> +	switch (size) {
> +#ifdef CONFIG_64BIT
> +	case 8:	return __cmpxchg_u64((unsigned long *)ptr, old, new_);
> +#endif
> +	case 4:	return __cmpxchg_u32(ptr, old, new_);
> +	default:
> +		return __cmpxchg_local_generic(ptr, old, new_, size);
> +	}
> +}
> +
> +/*
> + * cmpxchg_local and cmpxchg64_local are atomic wrt current CPU. Always make
> + * them available.
> + */
> +#define cmpxchg_local(ptr,o,n)					  	\
> +     (__typeof__(*(ptr)))__cmpxchg_local((ptr), (unsigned long)(o),	\
> +			   	 (unsigned long)(n), sizeof(*(ptr)))
> +#ifdef CONFIG_64BIT
> +#define cmpxchg64_local(ptr,o,n) cmpxchg_local((ptr), (o), (n))
> +#else
> +#define cmpxchg64_local(ptr,o,n) __cmpxchg64_local_generic((ptr), (o), (n))
> +#endif
> +
>  /* Note that we need not lock read accesses - aligned word writes/reads
>   * are atomic, so a reader never sees unconsistent values.
>   *
> 
> -- 
> Mathieu Desnoyers
> Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
> OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
> _______________________________________________
> parisc-linux mailing list
> parisc-linux@lists.parisc-linux.org
> http://lists.parisc-linux.org/mailman/listinfo/parisc-linux
