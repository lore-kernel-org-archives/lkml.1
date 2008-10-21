Return-Path: <linux-kernel-owner+w=401wt.eu-S1754656AbYJUSwo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754656AbYJUSwo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 14:52:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751715AbYJUSwg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 14:52:36 -0400
Received: from gerard.telenet-ops.be ([195.130.132.48]:42051 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751518AbYJUSwf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 14:52:35 -0400
Date: Tue, 21 Oct 2008 20:05:29 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Harvey Harrison <harvey.harrison@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 09/20] m68k: use the new byteorder headers
In-Reply-To: <1224525138.31861.206.camel@brick>
Message-ID: <Pine.LNX.4.64.0810212003530.8356@anakin>
References: <1224525138.31861.206.camel@brick>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Oct 2008, Harvey Harrison wrote:
> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> ---
> The final prerequisite patches to prevent breakage of headers-install and
> usage of the swabb.h functions have gone into mainline, please move your arch
> to the new header.
> 
> b8e465f4945bc0e9f324e3bbe15f5180a8e9a6fe byteorder: add new headers for make headers-install
> acf0108a84edae22b99655eb2f6f6c9f7ec4d449 byteorder: use generic C version for value byteswapping
> 1d8cca44b6a244b7e378546d719041819049a0f9 byteorder: provide swabb.h generically in asm/byteorder.h
> 1a651a00e20fd4997f0b91258f6f95b7d96edcd9 byteorder: remove direct includes of linux/byteorder/swab[b].h
> 
>  include/asm-m68k/byteorder.h |   16 +++++-----------
>  1 files changed, 5 insertions(+), 11 deletions(-)
> 
> diff --git a/include/asm-m68k/byteorder.h b/include/asm-m68k/byteorder.h
> index 81d420b..b354acd 100644
> --- a/include/asm-m68k/byteorder.h
> +++ b/include/asm-m68k/byteorder.h
> @@ -4,22 +4,16 @@
>  #include <asm/types.h>
>  #include <linux/compiler.h>
>  
> -#ifdef __GNUC__
> +#define __BIG_ENDIAN
> +#define __SWAB_64_THRU_32__
>  
> -static __inline__ __attribute_const__ __u32 ___arch__swab32(__u32 val)
> +static inline __attribute_const__ __u32 __arch_swab32(__u32 val)
>  {
>  	__asm__("rolw #8,%0; swap %0; rolw #8,%0" : "=d" (val) : "0" (val));
>  	return val;
>  }
> -#define __arch__swab32(x) ___arch__swab32(x)
> +#define __arch_swab32 __arch_swab32
>  
> -#endif
> -
> -#if defined(__GNUC__) && !defined(__STRICT_ANSI__) || defined(__KERNEL__)
> -#  define __BYTEORDER_HAS_U64__
> -#  define __SWAB_64_THRU_32__
> -#endif
> -
> -#include <linux/byteorder/big_endian.h>
> +#include <linux/byteorder.h>
>  
>  #endif /* _M68K_BYTEORDER_H */
> -- 
> 1.6.0.2

This patch breaks rcutorture:

|   CC [M]  kernel/rcutorture.o
| In file included from kernel/rcutorture.c:45:
| include/linux/byteorder/swabb.h:82:1: warning: "__swahw32" redefined
| In file included from include/linux/byteorder.h:5,
|                  from include2/asm/byteorder.h:17,
|                  from include/linux/kernel.h:20,
|                  from kernel/rcutorture.c:26:
| include/linux/swab.h:128:1: warning: this is the location of the previous definition
| In file included from kernel/rcutorture.c:45:
| include/linux/byteorder/swabb.h:86:1: warning: "__swahb32" redefined
| In file included from include/linux/byteorder.h:5,
|                  from include2/asm/byteorder.h:17,
|                  from include/linux/kernel.h:20,
|                  from kernel/rcutorture.c:26:
| include/linux/swab.h:139:1: warning: this is the location of the previous definition
| In file included from kernel/rcutorture.c:46:
| include/linux/byteorder/swabb.h:98: error: conflicting types for '__swahw32p'
| include/linux/swab.h:190: error: previous definition of '__swahw32p' was here
| include/linux/byteorder/swabb.h:103: error: redefinition of '__swahw32s'
| include/linux/swab.h:258: error: previous definition of '__swahw32s' was here
| include/linux/byteorder/swabb.h:113: error: conflicting types for '__swahb32p'
| include/linux/swab.h:205: error: previous definition of '__swahb32p' was here
| include/linux/byteorder/swabb.h:118: error: redefinition of '__swahb32s'
| include/linux/swab.h:273: error: previous definition of '__swahb32s' was here
| make[3]: *** [kernel/rcutorture.o] Error 1
| make[2]: *** [kernel/rcutorture.o] Error 2

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
