Return-Path: <linux-kernel-owner+w=401wt.eu-S1758497AbYCNSKM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758497AbYCNSKM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 14:10:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755507AbYCNSJ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 14:09:59 -0400
Received: from gw.goop.org ([64.81.55.164]:45309 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757324AbYCNSJ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 14:09:58 -0400
Message-ID: <47DABEFB.3050704@goop.org>
Date: Fri, 14 Mar 2008 11:07:55 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Alexander van Heukelum <heukelum@mailshack.com>
CC: Ingo Molnar <mingo@elte.hu>, Alexander van Heukelum <heukelum@fastmail.fm>,
       Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: merge the simple bitops and move them to bitops.h
References: <20080312200128.GA24983@mailshack.com>
In-Reply-To: <20080312200128.GA24983@mailshack.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexander van Heukelum wrote:
> x86: merge the simple bitops and move them to bitops.h
>
> Some of those can be written in such a way that the same
> inline assembly can be used to generate both 32 bit and
> 64 bit code.
>
> For ffs and fls, x86_64 unconditionally used the cmov
> instruction and i386 unconditionally used a conditional
> branch over a mov instruction. In the current patch I
> chose to select the version based on the availability
> of the cmov instruction instead. A small detail here is
> that x86_64 did not previously set CONFIG_X86_CMOV=y.
>   

Looks good in general.  What's left in bitops_{32,64}.h now?

(Some comments below.)
> Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>
>
> ---
>
>  arch/x86/Kconfig.cpu        |    2 +-
>  include/asm-x86/bitops.h    |   90 +++++++++++++++++++++++++++++++++++++++++++
>  include/asm-x86/bitops_32.h |   64 ------------------------------
>  include/asm-x86/bitops_64.h |   76 ------------------------------------
>  4 files changed, 91 insertions(+), 141 deletions(-)
>
> Hi Ingo,
>
> On a 64-bit machine the cmov instruction is always available. I made
> that explicit by turning on CONFIG_X86_CMOV for all 64-bit builds.
>
> This patch introduces a change in behaviour for 32-bit builds: if
> the selected cpu has the cmov instruction, it will now be used by
> the functions ffs and fls.
>
> For the i386 defconfig the number of occurrences of cmov increases
> from 4336 to 4429 and vmlinux text size increases 15 bytes. When
> building for 486 no cmovs are generated, as expected.
>
> Greetings,
> 	Alexander
>
> diff --git a/arch/x86/Kconfig.cpu b/arch/x86/Kconfig.cpu
> index 31e92fb..fb7399b 100644
> --- a/arch/x86/Kconfig.cpu
> +++ b/arch/x86/Kconfig.cpu
> @@ -399,7 +399,7 @@ config X86_TSC
>  # generates cmov.
>  config X86_CMOV
>  	def_bool y
> -	depends on (MK7 || MPENTIUM4 || MPENTIUMM || MPENTIUMIII || MPENTIUMII || M686 || MVIAC3_2 || MVIAC7)
> +	depends on (MK7 || MPENTIUM4 || MPENTIUMM || MPENTIUMIII || MPENTIUMII || M686 || MVIAC3_2 || MVIAC7 || X86_64)
>  
>  config X86_MINIMUM_CPU_FAMILY
>  	int
> diff --git a/include/asm-x86/bitops.h b/include/asm-x86/bitops.h
> index 1a23ce1..bbdecee 100644
> --- a/include/asm-x86/bitops.h
> +++ b/include/asm-x86/bitops.h
> @@ -310,6 +310,96 @@ static int test_bit(int nr, const volatile unsigned long *addr);
>  	 constant_test_bit((nr),(addr)) :	\
>  	 variable_test_bit((nr),(addr)))
>  
> +/**
> + * __ffs - find first bit in word.
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
> + * @x: the word to search
> + *
> + * This is defined the same way as
> + * the libc and compiler builtin ffs routines, therefore
> + * differs in spirit from the above ffz() (man ffs).
>   

This comment seems wrong.  My "man ffs" says that it returns 1-32 for 
non-zero inputs, and 0 for a zero input.  This function returns 0-31, or 
-1 for a zero input.

DESCRIPTION
       The ffs() function returns the position of the first (least significant)
       bit set in the word i.  The least significant bit is position 1 and  the
       most  significant  position  is,  for example, 32 or 64.   The functions
       ffsll() and ffsl() do the same but take arguments of possibly  different
       size.

RETURN VALUE
       These  functions  return  the  position of the first bit set, or 0 if no
       bits are set in i.



> + */
> +static inline int ffs(int x)
> +{
> +	int r;
> +#ifdef CONFIG_X86_CMOV
> +	__asm__("bsfl %1,%0\n\t"
> +		"cmovzl %2,%0"
>   

The prevailing style in bitops.h is to use "bsf"/"cmovz" and let the 
compiler work out the size from the register names.

> +		: "=r" (r) : "rm" (x), "r" (-1));
> +#else
> +	__asm__("bsfl %1,%0\n\t"
> +		"jnz 1f\n\t"
> +		"movl $-1,%0\n"
> +		"1:" : "=r" (r) : "rm" (x));
> +#endif
> +	return r+1;
> +}
> +
> +/**
> + * fls - find last bit set
> + * @x: the word to search
> + *
> + * This is defined the same way as ffs().
>   

And this comment is even more wrong, given that ffs and fls are 
completely different functions ;)

I know these are from the original, but its worth fixing given that 
you're touching it anyway.

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
> +	return r+1;
> +}
> +#endif /* __KERNEL__ */
> +
>  #undef ADDR
>  
>  #ifdef CONFIG_X86_32

    J
