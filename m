Return-Path: <linux-kernel-owner+w=401wt.eu-S1755424AbXHRJu0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755424AbXHRJu0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2007 05:50:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752387AbXHRJuO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Aug 2007 05:50:14 -0400
Received: from ns1.suse.de ([195.135.220.2]:52301 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750833AbXHRJuM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2007 05:50:12 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Stephen Hemminger <shemminger@linux-foundation.org>
Subject: Re: [PATCH] x86-64: memset optimization
Date: Sat, 18 Aug 2007 11:46:24 +0200
User-Agent: KMail/1.9.6
Cc: discuss@x86-64.org, linux-kernel@vger.kernel.org, jh@suse.cz
References: <20070817163446.3e63f208@freepuppy.rosehill.hemminger.net>
In-Reply-To: <20070817163446.3e63f208@freepuppy.rosehill.hemminger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708181146.24399.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 18 August 2007 01:34:46 Stephen Hemminger wrote:
> Optimize uses of memset with small constant offsets.
> This will generate smaller code, and avoid the slow rep/string instructions.
> Code copied from i386 with a little cleanup.


Newer gcc should do all this on its own.  That is why I intentionally
didn't implement it on 64bit.

On what compiler version did you see smaller code?

-Andi


> 
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
> 


