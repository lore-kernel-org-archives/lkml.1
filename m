Return-Path: <linux-kernel-owner+w=401wt.eu-S1755508AbYHAQHM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755508AbYHAQHM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 12:07:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751883AbYHAQHA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 12:07:00 -0400
Received: from colo.lackof.org ([198.49.126.79]:40426 "EHLO colo.lackof.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751581AbYHAQG7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 12:06:59 -0400
Date: Fri, 1 Aug 2008 10:06:47 -0600
From: Grant Grundler <grundler@parisc-linux.org>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Kyle McMartin <kyle@mcmartin.ca>, grundler <grundler@parisc-linux.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 14/20] parisc: use the new byteorder headers
Message-ID: <20080801160647.GA22049@colo.lackof.org>
References: <1216339783.6029.125.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1216339783.6029.125.camel@brick>
X-Home-Page: http://www.parisc-linux.org/
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 17, 2008 at 05:09:43PM -0700, Harvey Harrison wrote:
> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> ---
>  include/asm-parisc/byteorder.h |   37 ++++++++++++-------------------------
>  1 files changed, 12 insertions(+), 25 deletions(-)
> 
> diff --git a/include/asm-parisc/byteorder.h b/include/asm-parisc/byteorder.h
> index db14831..5e56b1b 100644
> --- a/include/asm-parisc/byteorder.h
> +++ b/include/asm-parisc/byteorder.h
> @@ -4,9 +4,10 @@
>  #include <asm/types.h>
>  #include <linux/compiler.h>
>  
> -#ifdef __GNUC__
> +#define __LITTLE_ENDIAN

Sorry, this looks wrong. parisc is big endian.

> +#define __SWAB_64_THRU_32__

Should this only be defined if BITS_PER_LONG is <=32  ?

thanks,
grant

>  
> -static __inline__ __attribute_const__ __u16 ___arch__swab16(__u16 x)
> +static inline __attribute_const__ __u16 __arch_swab16(__u16 x)
>  {
>  	__asm__("dep %0, 15, 8, %0\n\t"		/* deposit 00ab -> 0bab */
>  		"shd %%r0, %0, 8, %0"		/* shift 000000ab -> 00ba */
> @@ -14,8 +15,9 @@ static __inline__ __attribute_const__ __u16 ___arch__swab16(__u16 x)
>  		: "0" (x));
>  	return x;
>  }
> +#define HAVE_ARCH_SWAB16
>  
> -static __inline__ __attribute_const__ __u32 ___arch__swab24(__u32 x)
> +static inline __attribute_const__ __u32 __arch_swab24(__u32 x)
>  {
>  	__asm__("shd %0, %0, 8, %0\n\t"		/* shift xabcxabc -> cxab */
>  		"dep %0, 15, 8, %0\n\t"		/* deposit cxab -> cbab */
> @@ -25,7 +27,7 @@ static __inline__ __attribute_const__ __u32 ___arch__swab24(__u32 x)
>  	return x;
>  }
>  
> -static __inline__ __attribute_const__ __u32 ___arch__swab32(__u32 x)
> +static inline __attribute_const__ __u32 __arch_swab32(__u32 x)
>  {
>  	unsigned int temp;
>  	__asm__("shd %0, %0, 16, %1\n\t"	/* shift abcdabcd -> cdab */
> @@ -35,7 +37,7 @@ static __inline__ __attribute_const__ __u32 ___arch__swab32(__u32 x)
>  		: "0" (x));
>  	return x;
>  }
> -
> +#define HAVE_ARCH_SWAB32
>  
>  #if BITS_PER_LONG > 32
>  /*
> @@ -48,7 +50,8 @@ static __inline__ __attribute_const__ __u32 ___arch__swab32(__u32 x)
>  **      HSHR    67452301 -> *6*4*2*0 into %0
>  **      OR      %0 | %1  -> 76543210 into %0 (all done!)
>  */
> -static __inline__ __attribute_const__ __u64 ___arch__swab64(__u64 x) {
> +static inline __attribute_const__ __u64 __arch_swab64(__u64 x)
> +{
>  	__u64 temp;
>  	__asm__("permh,3210 %0, %0\n\t"
>  		"hshl %0, 8, %1\n\t"
> @@ -58,25 +61,9 @@ static __inline__ __attribute_const__ __u64 ___arch__swab64(__u64 x) {
>  		: "0" (x));
>  	return x;
>  }
> -#define __arch__swab64(x) ___arch__swab64(x)
> -#define __BYTEORDER_HAS_U64__
> -#elif !defined(__STRICT_ANSI__)
> -static __inline__ __attribute_const__ __u64 ___arch__swab64(__u64 x)
> -{
> -	__u32 t1 = ___arch__swab32((__u32) x);
> -	__u32 t2 = ___arch__swab32((__u32) (x >> 32));
> -	return (((__u64) t1 << 32) | t2);
> -}
> -#define __arch__swab64(x) ___arch__swab64(x)
> -#define __BYTEORDER_HAS_U64__
> -#endif
> -
> -#define __arch__swab16(x) ___arch__swab16(x)
> -#define __arch__swab24(x) ___arch__swab24(x)
> -#define __arch__swab32(x) ___arch__swab32(x)
> -
> -#endif /* __GNUC__ */
> +#define HAVE_ARCH_SWAB64
> +#endif /* BITS_PER_LONG > 32 */
>  
> -#include <linux/byteorder/big_endian.h>
> +#include <linux/byteorder.h>
>  
>  #endif /* _PARISC_BYTEORDER_H */
> -- 
> 1.5.6.3.569.ga9185
> 
