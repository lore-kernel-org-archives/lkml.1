Return-Path: <linux-kernel-owner+w=401wt.eu-S1752401AbZAFTS3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752401AbZAFTS3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 14:18:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751001AbZAFTST
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 14:18:19 -0500
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:42699 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750961AbZAFTSS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 14:18:18 -0500
Date: Tue, 6 Jan 2009 19:17:45 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.anvils
To: Andi Kleen <andi@firstfloor.org>
cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [3/5] Mark complex bitops.h inlines as __always_inline
In-Reply-To: <20090104233640.6A7453E6653@basil.firstfloor.org>
Message-ID: <Pine.LNX.4.64.0901061847110.29408@blonde.anvils>
References: <200901051236.281008835@firstfloor.org>
 <20090104233640.6A7453E6653@basil.firstfloor.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 Jan 2009, Andi Kleen wrote:
> 
> Hugh Dickins noticed that older gcc versions when the kernel
> is built for code size didn't inline some of the bitops.
> 
> Mark all complex x86 bitops that have more than a single
> asm statement or two as always inline to avoid this problem.
> 
> Probably should be done for other architectures too.
> 
> Signed-off-by: Andi Kleen <ak@linux.intel.com>

Thanks for pursuing this again, Andi.  Yes, this patch certainly
helped in my case.  But could we please change the first sentence
of that comment?  Though I did first notice the problem while
CONFIG_CC_OPTIMIZE_FOR_SIZE=y, it persisted to a greater or
lesser extent without that, so long as CONFIG_OPTIMIZE_INLINING=y:
it's a problem with that option, not with building for code size.

I haven't actually been using your patch since testing it, I just
switched CONFIG_OPTIMIZE_INLINING off: I'm surprised it remained
=y in the x86 defconfigs (though default N in the Kconfig, phew),
and still worry what other silliness that option may be doing, while
it seems that there isn't yet an actual gcc release that behaves well
with it (I see from later mail that you do expect 4.4 to fix it).

So far as I've been able to tell, the right wording for the first
sentence would be:

Hugh Dickins noticed that released gcc versions building the kernel
with CONFIG_OPTIMIZE_INLINING=y don't inline some of the bitops -
sometimes generating very inefficient pageflag tests, and many
instances of constant_test_bit().

Hugh

> 
> ---
>  arch/x86/include/asm/bitops.h      |   15 +++++++++++----
>  include/asm-generic/bitops/__ffs.h |    2 +-
>  include/asm-generic/bitops/__fls.h |    2 +-
>  include/asm-generic/bitops/fls.h   |    2 +-
>  include/asm-generic/bitops/fls64.h |    4 ++--
>  5 files changed, 16 insertions(+), 9 deletions(-)
> 
> Index: linux-2.6.28-test/arch/x86/include/asm/bitops.h
> ===================================================================
> --- linux-2.6.28-test.orig/arch/x86/include/asm/bitops.h	2008-10-24 13:34:40.000000000 +0200
> +++ linux-2.6.28-test/arch/x86/include/asm/bitops.h	2009-01-02 16:01:00.000000000 +0100
> @@ -3,6 +3,9 @@
>  
>  /*
>   * Copyright 1992, Linus Torvalds.
> + *
> + * Note: inlines with more than a single statement should be marked
> + * __always_inline to avoid problems with older gcc's inlining heuristics.
>   */
>  
>  #ifndef _LINUX_BITOPS_H
> @@ -53,7 +56,8 @@
>   * Note that @nr may be almost arbitrarily large; this function is not
>   * restricted to acting on a single-word quantity.
>   */
> -static inline void set_bit(unsigned int nr, volatile unsigned long *addr)
> +static __always_inline void
> +set_bit(unsigned int nr, volatile unsigned long *addr)
>  {
>  	if (IS_IMMEDIATE(nr)) {
>  		asm volatile(LOCK_PREFIX "orb %1,%0"
> @@ -90,7 +94,8 @@
>   * you should call smp_mb__before_clear_bit() and/or smp_mb__after_clear_bit()
>   * in order to ensure changes are visible on other processors.
>   */
> -static inline void clear_bit(int nr, volatile unsigned long *addr)
> +static __always_inline void
> +clear_bit(int nr, volatile unsigned long *addr)
>  {
>  	if (IS_IMMEDIATE(nr)) {
>  		asm volatile(LOCK_PREFIX "andb %1,%0"
> @@ -196,7 +201,8 @@
>   *
>   * This is the same as test_and_set_bit on x86.
>   */
> -static inline int test_and_set_bit_lock(int nr, volatile unsigned long *addr)
> +static __always_inline int
> +test_and_set_bit_lock(int nr, volatile unsigned long *addr)
>  {
>  	return test_and_set_bit(nr, addr);
>  }
> @@ -292,7 +298,8 @@
>  	return oldbit;
>  }
>  
> -static inline int constant_test_bit(int nr, const volatile unsigned long *addr)
> +static __always_inline int
> +constant_test_bit(int nr, const volatile unsigned long *addr)
>  {
>  	return ((1UL << (nr % BITS_PER_LONG)) &
>  		(((unsigned long *)addr)[nr / BITS_PER_LONG])) != 0;
> Index: linux-2.6.28-test/include/asm-generic/bitops/__ffs.h
> ===================================================================
> --- linux-2.6.28-test.orig/include/asm-generic/bitops/__ffs.h	2006-04-03 16:06:13.000000000 +0200
> +++ linux-2.6.28-test/include/asm-generic/bitops/__ffs.h	2009-01-02 16:01:00.000000000 +0100
> @@ -9,7 +9,7 @@
>   *
>   * Undefined if no bit exists, so code should check against 0 first.
>   */
> -static inline unsigned long __ffs(unsigned long word)
> +static __always_inline unsigned long __ffs(unsigned long word)
>  {
>  	int num = 0;
>  
> Index: linux-2.6.28-test/include/asm-generic/bitops/__fls.h
> ===================================================================
> --- linux-2.6.28-test.orig/include/asm-generic/bitops/__fls.h	2008-05-08 12:56:05.000000000 +0200
> +++ linux-2.6.28-test/include/asm-generic/bitops/__fls.h	2009-01-02 16:01:00.000000000 +0100
> @@ -9,7 +9,7 @@
>   *
>   * Undefined if no set bit exists, so code should check against 0 first.
>   */
> -static inline unsigned long __fls(unsigned long word)
> +static __always_inline unsigned long __fls(unsigned long word)
>  {
>  	int num = BITS_PER_LONG - 1;
>  
> Index: linux-2.6.28-test/include/asm-generic/bitops/fls.h
> ===================================================================
> --- linux-2.6.28-test.orig/include/asm-generic/bitops/fls.h	2006-04-03 16:06:13.000000000 +0200
> +++ linux-2.6.28-test/include/asm-generic/bitops/fls.h	2009-01-02 16:01:00.000000000 +0100
> @@ -9,7 +9,7 @@
>   * Note fls(0) = 0, fls(1) = 1, fls(0x80000000) = 32.
>   */
>  
> -static inline int fls(int x)
> +static __always_inline int fls(int x)
>  {
>  	int r = 32;
>  
> Index: linux-2.6.28-test/include/asm-generic/bitops/fls64.h
> ===================================================================
> --- linux-2.6.28-test.orig/include/asm-generic/bitops/fls64.h	2008-05-08 12:56:05.000000000 +0200
> +++ linux-2.6.28-test/include/asm-generic/bitops/fls64.h	2009-01-02 16:01:00.000000000 +0100
> @@ -15,7 +15,7 @@
>   * at position 64.
>   */
>  #if BITS_PER_LONG == 32
> -static inline int fls64(__u64 x)
> +static __always_inline int fls64(__u64 x)
>  {
>  	__u32 h = x >> 32;
>  	if (h)
> @@ -23,7 +23,7 @@
>  	return fls(x);
>  }
>  #elif BITS_PER_LONG == 64
> -static inline int fls64(__u64 x)
> +static __always_inline int fls64(__u64 x)
>  {
>  	if (x == 0)
>  		return 0;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
