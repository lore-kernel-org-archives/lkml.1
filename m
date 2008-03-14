Return-Path: <linux-kernel-owner+w=401wt.eu-S1758210AbYCNXch@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758210AbYCNXch (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 19:32:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755505AbYCNXca
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 19:32:30 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:39002 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754566AbYCNXc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 19:32:29 -0400
Date: Fri, 14 Mar 2008 16:30:37 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Alexander van Heukelum <heukelum@mailshack.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Ingo Molnar <mingo@elte.hu>,
       Alexander van Heukelum <heukelum@fastmail.fm>,
       Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] x86: merge the simple bitops and move them to
 bitops.h
Message-Id: <20080314163037.e15a49db.randy.dunlap@oracle.com>
In-Reply-To: <20080314203526.GA13959@mailshack.com>
References: <20080312200128.GA24983@mailshack.com>
	<47DABEFB.3050704@goop.org>
	<1205523826.7441.1242464129@webmail.messagingengine.com>
	<20080314203526.GA13959@mailshack.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Mar 2008 21:35:26 +0100 Alexander van Heukelum wrote:

> x86: merge the simple bitops and move them to bitops.h.
> 
> 
> Improved comments for ffs and fls.

There is still room for some comment improvements IMO.  See below.


> Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>
> 
> ---
> 
> diff --git a/include/asm-x86/bitops.h b/include/asm-x86/bitops.h
> index 1a23ce1..363a4ff 100644
> --- a/include/asm-x86/bitops.h
> +++ b/include/asm-x86/bitops.h
> @@ -310,6 +309,104 @@ static int test_bit(int nr, const volatile unsigned long *addr);
>  	 constant_test_bit((nr),(addr)) :	\
>  	 variable_test_bit((nr),(addr)))
>  
> +/**
> + * __ffs - find first bit in word.

              find first bit set in word

[The "first bit in word" could have any value in {0, 1}, so the
return value would depend on which end you considered "first".  ;]

> + * @word: The word to search
> + *
> + * Undefined if no bit exists, so code should check against 0 first.
> + */
> +static inline unsigned long __ffs(unsigned long word)
> +{
> +	__asm__("bsf %1,%0"
> +		:"=r" (word)
> +		:"rm" (word));
> +	return word;
> +}
> +
> +/**
> + * ffz - find first zero in word.

            find first zero bit in word

> + * @word: The word to search
> + *
> + * Undefined if no zero exists, so code should check against ~0UL first.
> + */
> +static inline unsigned long ffz(unsigned long word)
> +{
> +	__asm__("bsf %1,%0"
> +		:"=r" (word)
> +		:"r" (~word));
> +	return word;
> +}
> +
> +/*
> + * __fls: find last bit set.

      __fls - find last bit set in word

> + * @word: The word to search
> + *
> + * Undefined if no zero exists, so code should check against ~0UL first.
> + */
> +static inline unsigned long __fls(unsigned long word)
> +{
> +	__asm__("bsr %1,%0"
> +		:"=r" (word)
> +		:"rm" (word));
> +	return word;
> +}
> +
> +#ifdef __KERNEL__
> +/**
> + * ffs - find first bit set

                               in word

> + * @x: the word to search
> + *
> + * This is defined the same way as the libc and compiler builtin ffs
> + * routines, therefore differs in spirit from the other bitops.
> + *
> + * ffs(value) returns 0 if value is 0 or the position of the first
> + * set bit if value is nonzero. The first (least significant) bit
> + * is at position 1.
> + */
> +static inline int ffs(int x)
> +{
> +	int r;
> +#ifdef CONFIG_X86_CMOV
> +	__asm__("bsfl %1,%0\n\t"
> +		"cmovzl %2,%0"
> +		: "=r" (r) : "rm" (x), "r" (-1));
> +#else
> +	__asm__("bsfl %1,%0\n\t"
> +		"jnz 1f\n\t"
> +		"movl $-1,%0\n"
> +		"1:" : "=r" (r) : "rm" (x));
> +#endif
> +	return r + 1;
> +}
> +
> +/**
> + * fls - find last bit set

                              in word

> + * @x: the word to search
> + *
> + * This is defined in a similar way as the libc and compiler builtin
> + * ffs, but returns the position of the most significant set bit.
> + *
> + * fls(value) returns 0 if value is 0 or the position of the last
> + * set bit if value is nonzero. The last (most significant) bit is
> + * at position 32.
> + */
> +static inline int fls(int x)
> +{
> +	int r;
> +#ifdef CONFIG_X86_CMOV
> +	__asm__("bsrl %1,%0\n\t"
> +		"cmovzl %2,%0"
> +		: "=&r" (r) : "rm" (x), "rm" (-1));
> +#else
> +	__asm__("bsrl %1,%0\n\t"
> +		"jnz 1f\n\t"
> +		"movl $-1,%0\n"
> +		"1:" : "=r" (r) : "rm" (x));
> +#endif
> +	return r + 1;
> +}
> +#endif /* __KERNEL__ */


---
~Randy
