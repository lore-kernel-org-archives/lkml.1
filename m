Return-Path: <linux-kernel-owner+w=401wt.eu-S1754101AbYHQQ5Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754101AbYHQQ5Q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2008 12:57:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752491AbYHQQ5E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Aug 2008 12:57:04 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54001 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752454AbYHQQ5C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2008 12:57:02 -0400
Date: Sun, 17 Aug 2008 09:56:35 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Rusty Russell <rusty@rustcorp.com.au>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH] debug: fix BUILD_BUG_ON() for non-constant expressions
In-Reply-To: <20080817103241.GB21303@elte.hu>
Message-ID: <alpine.LFD.1.10.0808170936260.3324@nehalem.linux-foundation.org>
References: <20080816100948.GB19926@martell.zuzino.mipt.ru> <200808162055.45136.rusty@rustcorp.com.au> <alpine.LFD.1.10.0808161305170.3324@nehalem.linux-foundation.org> <20080817103241.GB21303@elte.hu>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 17 Aug 2008, Ingo Molnar wrote:
> +/*
> + * Force a compilation error if condition is true [array index becomes
> + * negative], and a linker error if condition is not constant [non-defined
> + * variable is used as an array index]:
> + *
> + * ( The linker trick relies on gcc optimizing out a multiplication with
> + *   constant zero - which should be reasonable enough. )
> + */
> +extern unsigned int __BUILD_BUG_ON_non_constant;
> +
> +#define BUILD_BUG_ON(condition)					\
> +do {								\
> +	(void)sizeof(char[1 - 2*!!(condition)]);		\
> +	if (!__builtin_constant_p(condition))			\
> +		__BUILD_BUG_ON_non_constant++;			\
> +} while (0)

Gag me now.

Why not just do

 #define __BBO(c)                sizeof(const char[1 - 2*!!(c)])
 #define __BBONC(c)              __BBO(!__builtin_constant_p(c))
 #define BUILD_BUG_ON_ZERO(c)    (__BBO(c) - __BBONC(c))
 #define BUILD_BUG_ON(c)         (void)BUILD_BUG_ON_ZERO(c)

and be done with it?

The rules are trivial:

 - __BBO() causes a warning if 'c' is a constant non-zero, returns a
   (size_t) 1 otherwise

 - __BBONC() causes a warning if 'c' is not a constant, returns a
   (size_t) 1 otherwise

And then BUILD_BUG_ON[_ZERO] are totally _trivial_ on top of those.

Yeah, yeah, I didn't test this, but it looks a hell of a lot simpler, and 
gives the warning about non-constant issues at compile time with line 
numbers rather than at link-time.

		Linus
