Return-Path: <linux-kernel-owner+w=401wt.eu-S1754563AbYHTNVY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754563AbYHTNVY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 09:21:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752879AbYHTNVN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 09:21:13 -0400
Received: from hs-out-0708.google.com ([64.233.178.243]:51100 "EHLO
	hs-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752629AbYHTNVL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 09:21:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding
         :sender;
        b=uf+l7hHYmAQ6qVbsib5iLgrPVaUp8t/A8sS+i7IsKqzpBeIt0cUF6e6vWhGhucYjZp
         qHYjaODN5JVrM1bqNTj1+jmp0Jp95oUL058qWdr2DBV6/iA/Nji2eonbJkR2+SUH5Lof
         P915mjd69gi15yZ7v6ObkBw6tXausq6wVgjwo=
Message-ID: <48AC1A41.60907@panasas.com>
Date: Wed, 20 Aug 2008 16:21:05 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Alexey Dobriyan <adobriyan@gmail.com>, torvalds@linuxfoundation.org,
       akpm@linuxfoundation.org, linux-kernel@vger.kernel.org,
       Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH] debug: fix BUILD_BUG_ON() for non-constant expressions
References: <20080816100948.GB19926@martell.zuzino.mipt.ru> <200808162055.45136.rusty@rustcorp.com.au> <alpine.LFD.1.10.0808161305170.3324@nehalem.linux-foundation.org> <20080817103241.GB21303@elte.hu>
In-Reply-To: <20080817103241.GB21303@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> From: Ingo Molnar <mingo@elte.hu>
> Date: Sun, 17 Aug 2008 12:18:01 +0200
> Subject: [PATCH] debug, x86: move BUILD_BUG_ON() and __FUNCTION__
> 
> move BUILD_BUG_ON variants and the __FUNCTION__ definition from
> kernel.h to compiler.h.
> 
> Besides being the correct location for such trivial wrappers around
> compiler functionality, this also allows the removal of a duplicate
> (and now slighly incompatible) definition of BUILD_BUG_ON from
> arch/x86/boot/boot.h.
> 
> [ boot.h cannot just include kernel.h to pick up the new definition of
>   BUILD_BUG_ON(), as it is also built into user-space utilities on the
>   host system. ]
> 
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  arch/x86/boot/boot.h     |    3 ---
>  include/linux/compiler.h |   30 ++++++++++++++++++++++++++++++
>  include/linux/kernel.h   |   26 --------------------------
>  3 files changed, 30 insertions(+), 29 deletions(-)
> 
> diff --git a/arch/x86/boot/boot.h b/arch/x86/boot/boot.h
> index 616b804..f09b79a 100644
> --- a/arch/x86/boot/boot.h
> +++ b/arch/x86/boot/boot.h
> @@ -27,9 +27,6 @@
>  #include "bitops.h"
>  #include <asm/cpufeature.h>
>  
> -/* Useful macros */
> -#define BUILD_BUG_ON(condition) ((void)sizeof(char[1 - 2*!!(condition)]))
> -
>  extern struct setup_header hdr;
>  extern struct boot_params boot_params;
>  
> diff --git a/include/linux/compiler.h b/include/linux/compiler.h
> index c8bd2da..727862f 100644
> --- a/include/linux/compiler.h
> +++ b/include/linux/compiler.h
> @@ -194,4 +194,34 @@ extern void __chk_io_ptr(const volatile void __iomem *);
>   */
>  #define ACCESS_ONCE(x) (*(volatile typeof(x) *)&(x))
>  
> +/*
> + * Force a compilation error if condition is true [array index becomes
> + * negative], and a linker error if condition is not constant [non-defined
> + * variable is used as an array index]:
> + *
> + * ( The linker trick relies on gcc optimizing out a multiplication with
> + *   constant zero - which should be reasonable enough. )
> + */
> +#ifndef __ASSEMBLY__
> +extern unsigned int __BUILD_BUG_ON_non_constant;
> +#endif
> +
> +#define BUILD_BUG_ON(condition)					\
> +do {								\
> +	(void)sizeof(char[1 - 2*!!(condition)]);		\
> +	if (!__builtin_constant_p(condition))			\
> +		__BUILD_BUG_ON_non_constant++;			\
> +} while (0)
> +
> +/*
> + * Force a compilation error if condition is true, but also produce a
> + * result (of value 0 and type size_t), so the expression can be used
> + * e.g. in a structure initializer (or where-ever else comma expressions
> + * aren't permitted):
> + */
> +#define BUILD_BUG_ON_ZERO(e) (sizeof(char[1 - 2 * !!(e)]) - 1)
> +
> +/* Trap pasters of __FUNCTION__ at compile-time */
> +#define __FUNCTION__ (__func__)
> +
>  #endif /* __LINUX_COMPILER_H */
> diff --git a/include/linux/kernel.h b/include/linux/kernel.h
> index 36c841e..1ceafa4 100644
> --- a/include/linux/kernel.h
> +++ b/include/linux/kernel.h
> @@ -467,32 +467,6 @@ struct sysinfo {
>  	char _f[20-2*sizeof(long)-sizeof(int)];	/* Padding: libc5 uses this.. */
>  };
>  
> -/*
> - * Force a compilation error if condition is true [array index becomes
> - * negative], and a linker error if condition is not constant [non-defined
> - * variable is used as an array index]:
> - *
> - * ( The linker trick relies on gcc optimizing out a multiplication with
> - *   constant zero - which should be reasonable enough. )
> - */
> -extern unsigned int __BUILD_BUG_ON_non_constant;
> -
> -#define BUILD_BUG_ON(condition)					\
> -do {								\
> -	(void)sizeof(char[1 - 2*!!(condition)]);		\
> -	if (!__builtin_constant_p(condition))			\
> -		__BUILD_BUG_ON_non_constant++;			\
> -} while (0)
> -
> -/* Force a compilation error if condition is true, but also produce a
> -   result (of value 0 and type size_t), so the expression can be used
> -   e.g. in a structure initializer (or where-ever else comma expressions
> -   aren't permitted). */
> -#define BUILD_BUG_ON_ZERO(e) (sizeof(char[1 - 2 * !!(e)]) - 1)
> -
> -/* Trap pasters of __FUNCTION__ at compile-time */
> -#define __FUNCTION__ (__func__)
> -
>  /* This helps us to avoid #ifdef CONFIG_NUMA */
>  #ifdef CONFIG_NUMA
>  #define NUMA_BUILD 1
> --
Ingo Hi!

I got bitten by this duplication too. Please submit an equivalent patch
for today's code. That could be nice.

Then later we can take care of BUILD_BUG_ON which ever variant.

Thanks
Boaz
