Return-Path: <linux-kernel-owner+w=401wt.eu-S1754071AbXHRHSZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754071AbXHRHSZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2007 03:18:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752041AbXHRHSQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Aug 2007 03:18:16 -0400
Received: from gw1.cosmosbay.com ([86.65.150.130]:55152 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750997AbXHRHSP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2007 03:18:15 -0400
Message-ID: <46C69D26.3000200@cosmosbay.com>
Date: Sat, 18 Aug 2007 09:17:58 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Stephen Hemminger <shemminger@linux-foundation.org>
CC: Andi Kleen <ak@suse.de>, discuss@x86-64.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86-64: memset optimization
References: <20070817163446.3e63f208@freepuppy.rosehill.hemminger.net>
In-Reply-To: <20070817163446.3e63f208@freepuppy.rosehill.hemminger.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [86.65.150.130]); Sat, 18 Aug 2007 09:18:08 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Hemminger a écrit :
> Optimize uses of memset with small constant offsets.
> This will generate smaller code, and avoid the slow rep/string instructions.
> Code copied from i386 with a little cleanup.
> 

You obviously didnt test it, did you ?

How can you be sure this is going to speedup things then ?

> Signed-off-by: Stephen Hemminger <shemminger@linux-foundation.org>
> 
> --- a/include/asm-x86_64/string.h	2007-08-17 15:14:32.000000000 -0700
> +++ b/include/asm-x86_64/string.h	2007-08-17 15:36:30.000000000 -0700
> @@ -42,9 +42,51 @@ extern void *__memcpy(void *to, const vo
>  		 __ret = __builtin_memcpy((dst),(src),__len);	\
>  	   __ret; }) 
>  #endif
> -
>  #define __HAVE_ARCH_MEMSET
> -void *memset(void *s, int c, size_t n);
> +void *__memset(void *s, int c, size_t n);
> +
> +/* Optimize for cases of trivial memset's
> + * Compiler should optimize away all but the case used.
> + */
> +static __always_inline void *
> +__constant_c_and_count_memset(void *s, int c, size_t count)
> +{
> +	unsigned long pattern = 0x01010101UL * (unsigned char) c;

Main difference between x86_64 and i386 is sizeof(long) being 8 instead of 4

Why not let gcc do its job about memset() ?

On x86_64 at least, modern gcc are smart enough.

> +
> +	switch (count) {
> +	case 0:
> +		return s;
> +	case 1:
> +		*(unsigned char *)s = pattern;
> +		return s;
> +	case 2:
> +		*(unsigned short *)s = pattern;
> +		return s;
> +	case 3:
> +		*(unsigned short *)s = pattern;
> +		*(2+(unsigned char *)s) = pattern;
> +		return s;
> +	case 4:
> +		*(unsigned long *)s = pattern;
> +		return s;
> +	case 6:
> +		*(unsigned long *)s = pattern;
> +		*(2+(unsigned short *)s) = pattern;
> +		return s;
> +	case 8:
> +		*(unsigned long *)s = pattern;
> +		*(1+(unsigned long *)s) = pattern;
> +		return s;
> +	default:
> +		return __memset(s, c, count);
> +	}
> +}
> +#define memset(s, c, count)					\
> +	(__builtin_constant_p(c)				\
> +	 ? __constant_c_and_count_memset((s),(c),(count))	\
> +	 : __memset((s),(c),(count)))
> +
> +
>  
>  #define __HAVE_ARCH_MEMMOVE
>  void * memmove(void * dest,const void *src,size_t count);
> --- a/arch/x86_64/kernel/x8664_ksyms.c	2007-08-17 15:14:32.000000000 -0700
> +++ b/arch/x86_64/kernel/x8664_ksyms.c	2007-08-17 15:44:58.000000000 -0700
> @@ -48,10 +48,12 @@ EXPORT_SYMBOL(__read_lock_failed);
>  #undef memmove
>  
>  extern void * memset(void *,int,__kernel_size_t);
> +extern void * __memset(void *,int,__kernel_size_t);
>  extern void * memcpy(void *,const void *,__kernel_size_t);
>  extern void * __memcpy(void *,const void *,__kernel_size_t);
>  
>  EXPORT_SYMBOL(memset);
> +EXPORT_SYMBOL(__memset);
>  EXPORT_SYMBOL(memcpy);
>  EXPORT_SYMBOL(__memcpy);
>  

