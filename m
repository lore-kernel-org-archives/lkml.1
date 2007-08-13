Return-Path: <linux-kernel-owner+w=401wt.eu-S1765254AbXHMNKk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765254AbXHMNKk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 09:10:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S969724AbXHMIfd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 04:35:33 -0400
Received: from mtagate5.uk.ibm.com ([195.212.29.138]:42711 "EHLO
	mtagate5.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S969838AbXHMIfa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 04:35:30 -0400
Date: Mon, 13 Aug 2007 10:35:01 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Christoph Lameter <clameter@sgi.com>, schwidefsky@de.ibm.com,
       linux390@de.ibm.com
Subject: Re: [patch 17/23] Add cmpxchg_local to s390
Message-ID: <20070813083501.GA30198@osiris.boeblingen.de.ibm.com>
References: <20070812145434.520271946@polymtl.ca> <20070812145841.788824151@polymtl.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070812145841.788824151@polymtl.ca>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 12, 2007 at 10:54:51AM -0400, Mathieu Desnoyers wrote:
> Use the standard __cmpxchg for every type that can be updated atomically.
> Use the new generic cmpxchg_local (disables interrupt) for other types.
> 
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> CC: clameter@sgi.com
> CC: schwidefsky@de.ibm.com
> CC: linux390@de.ibm.com
> ---
>  include/asm-s390/system.h |   34 ++++++++++++++++++++++++++++++++++
>  1 file changed, 34 insertions(+)
> 
> Index: linux-2.6-lttng/include/asm-s390/system.h
> ===================================================================
> --- linux-2.6-lttng.orig/include/asm-s390/system.h	2007-08-10 16:16:21.000000000 -0400
> +++ linux-2.6-lttng/include/asm-s390/system.h	2007-08-10 19:35:46.000000000 -0400
> @@ -353,6 +353,40 @@ __cmpxchg(volatile void *ptr, unsigned l
> 
>  #include <linux/irqflags.h>
> 
> +#include <asm-generic/cmpxchg-local.h>
> +
> +static inline unsigned long __cmpxchg_local(volatile void *ptr,
> +				      unsigned long old,
> +				      unsigned long new, int size)
> +{
> +	switch (size) {
> +	case 1:
> +	case 2:
> +	case 4:
> +#ifdef __s390x__
> +	case 8:
> +#endif
> +		return __cmpxchg(ptr, old, new, size);
> +	default:
> +		return __cmpxchg_local_generic(ptr, old, new, size);
> +	}
> +
> +	return old;
> +}
> +
> +/*
> + * cmpxchg_local and cmpxchg64_local are atomic wrt current CPU. Always make
> + * them available.
> + */
> +#define cmpxchg_local(ptr,o,n)						\
> +     (__typeof__(*(ptr)))__cmpxchg_local((ptr), (unsigned long)(o),	\
> +			   	 (unsigned long)(n), sizeof(*(ptr)))
> +#ifdef __s390x__
> +#define cmpxchg64_local(ptr,o,n) cmpxchg_local((ptr),(o),(n))
> +#else
> +#define cmpxchg64_local(ptr,o,n) __cmpxchg64_local_generic((ptr), (o), (n))
> +#endif
> +

What's the reason to have cmpxchg64_local on 32 bit architectures?
Without that need all this would just be a few simple defines.
