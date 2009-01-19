Return-Path: <linux-kernel-owner+w=401wt.eu-S1757186AbZASCLG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757186AbZASCLG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 21:11:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756589AbZASCKv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 21:10:51 -0500
Received: from hera.kernel.org ([140.211.167.34]:41106 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756273AbZASCKu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 21:10:50 -0500
Subject: Re: [GIT PULL -tip v3] fix 39 'make headers_check' warnings
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>, Sam Ravnborg <sam@ravnborg.org>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20090118185034.GA26908@elte.hu>
References: <1232287474.3130.19.camel@localhost.localdomain>
	 <20090118172800.GB22624@elte.hu>  <20090118185034.GA26908@elte.hu>
Content-Type: text/plain
Date: Mon, 19 Jan 2009 07:40:11 +0530
Message-Id: <1232331011.3129.4.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 (2.24.2-3.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-01-18 at 19:50 +0100, Ingo Molnar wrote:
>  
>  static inline __attribute_const__ __u32 __arch_swab32(__u32 val)
>  {
>  #ifdef __i386__
> +#ifdef __KERNEL__
>  # ifdef CONFIG_X86_BSWAP
>  	asm("bswap %0" : "=r" (val) : "0" (val));
>  # else
> @@ -16,7 +19,13 @@ static inline __attribute_const__ __u32 __arch_swab32(__u32 val)
>  	    : "=q" (val)
>  	    : "0" (val));
>  # endif
> -
> +#else /* __KERNEL__ */
> +	asm("xchgb %b0,%h0\n\t"	/* swap lower bytes	*/
> +	    "rorl $16,%0\n\t"	/* swap words		*/
> +	    "xchgb %b0,%h0"	/* swap higher bytes	*/
> +	    : "=q" (val)
> +	    : "0" (val));
> +#endif /* __KERNEL__ */
>  #else /* __i386__ */
>  	asm("bswapl %0"
>  	    : "=r" (val)
> @@ -37,6 +46,7 @@ static inline __attribute_const__ __u64 __arch_swab64(__u64 val)
>  		__u64 u;
>  	} v;
>  	v.u = val;
> +#ifdef __KERNEL__
>  # ifdef CONFIG_X86_BSWAP
>  	asm("bswapl %0 ; bswapl %1 ; xchgl %0,%1"
>  	    : "=r" (v.s.a), "=r" (v.s.b)
> @@ -48,6 +58,13 @@ static inline __attribute_const__ __u64 __arch_swab64(__u64 val)
>  	    : "=r" (v.s.a), "=r" (v.s.b)
>  	    : "0" (v.s.a), "1" (v.s.b));
>  # endif
> +#else /* __KERNEL__ */
> +	v.s.a = __arch_swab32(v.s.a);
> +	v.s.b = __arch_swab32(v.s.b);
> +	asm("xchgl %0,%1"
> +	    : "=r" (v.s.a), "=r" (v.s.b)
> +	    : "0" (v.s.a), "1" (v.s.b));
> +#endif /* __KERNEL__ */
>  	return v.u;
>  #else /* __i386__ */
>  	asm("bswapq %0"
> 
> 
> why does such a change introduce new code? It is duplicating existing code 
> instead of cleaning it all up.
> 

That's why I was requesting you to check asm/swab.h because I was in
doubt whether we need these functions in userspace or not.

If we do not need these functions in userspace then I will clean these
up.

--
JSR

