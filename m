Return-Path: <linux-kernel-owner+w=401wt.eu-S1758027AbZD2Ms6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758027AbZD2Ms6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 08:48:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752654AbZD2Msp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 08:48:45 -0400
Received: from tomts40.bellnexxia.net ([209.226.175.97]:60183 "EHLO
	tomts40-srv.bellnexxia.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754106AbZD2Mso (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 08:48:44 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhsFAOvk90lMQW1W/2dsb2JhbACBUM1Eg3UF
Date: Wed, 29 Apr 2009 08:48:42 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] atomic: fix atomic_long_cmpxchg/xchg for 64 bit
	architectures
Message-ID: <20090429124842.GB32163@Krystal>
References: <20090429143601.1a79ab8f@osiris.boeblingen.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20090429143601.1a79ab8f@osiris.boeblingen.de.ibm.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 08:44:05 up 60 days,  9:10,  1 user,  load average: 0.60, 0.50,
	0.48
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Heiko Carstens (heiko.carstens@de.ibm.com) wrote:
> From: Heiko Carstens <heiko.carstens@de.ibm.com>
> 
> On a linux-next allyesconfig build:
> 
> kernel/trace/ring_buffer.c:1726:
> 	warning: passing argument 1 of 'atomic_cmpxchg' from incompatible pointer type
> linux-next/arch/s390/include/asm/atomic.h:112:
> 	note: expected 'struct atomic_t *' but argument is of type 'struct atomic64_t *'
> 
> atomic_long_cmpxchg and atomic_long_xchg are incorrectly defined for
> 64 bit architectures. They should be mapped to the atomic64_* variants.
> 
> Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
> ---
>  include/asm-generic/atomic.h |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> Index: linux-next/include/asm-generic/atomic.h
> ===================================================================
> --- linux-next.orig/include/asm-generic/atomic.h
> +++ linux-next/include/asm-generic/atomic.h
> @@ -132,9 +132,9 @@ static inline long atomic_long_add_unles
>  #define atomic_long_inc_not_zero(l) atomic64_inc_not_zero((atomic64_t *)(l))
>  
>  #define atomic_long_cmpxchg(l, old, new) \
> -	(atomic_cmpxchg((atomic64_t *)(l), (old), (new)))
> +	(atomic64_cmpxchg((atomic64_t *)(l), (old), (new)))
>  #define atomic_long_xchg(v, new) \
> -	(atomic_xchg((atomic64_t *)(l), (new)))
> +	(atomic64_xchg((atomic64_t *)(l), (new)))

Other architectures usually define something along the lines of :

include/asm/atomic.h:#define atomic64_cmpxchg(v, o, n) (cmpxchg(&((v)->counter), (o), (n)))

This is why they did not care about calling atomic_cmpxchg or
atomic64_cmpxchg.

This fix looks good. Thanks !

Acked-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>


>  
>  #else  /*  BITS_PER_LONG == 64  */
>  

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
