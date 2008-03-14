Return-Path: <linux-kernel-owner+w=401wt.eu-S1756614AbYCNS6U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756614AbYCNS6U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 14:58:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752937AbYCNS6I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 14:58:08 -0400
Received: from gw.goop.org ([64.81.55.164]:32956 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752710AbYCNS6G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 14:58:06 -0400
Message-ID: <47DACA43.2000700@goop.org>
Date: Fri, 14 Mar 2008 11:56:03 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Jan Beulich <jbeulich@novell.com>
CC: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] x86: bitops asm constraint fixes
References: <47D8FD33.76E4.0078.0@novell.com>
In-Reply-To: <47D8FD33.76E4.0078.0@novell.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Beulich wrote:
> This (simplified) piece of code didn't behave as expected due to
> incorrect constraints in some of the bitops functions, when
> X86_FEATURE_xxx is referring to other than the first long:
>
> int test(struct cpuinfo_x86 *c) {
> 	if (cpu_has(c, X86_FEATURE_xxx))
> 		clear_cpu_cap(c, X86_FEATURE_xxx);
> 	return cpu_has(c, X86_FEATURE_xxx);
> }
>
> I'd really like understand, though, what the policy of (not) having a
> "memory" clobber in these operations is - currently, this appears to
> be totally inconsistent.
I think there's years of history here, much of it involving rites with 
chicken entrails.

"memory" clobber is generally needed because the bit operations can 
touch memory beyond their apparent arguments.  Proper "m" constraints 
are the way to go.

>  Also, many comments of the non-atomic
> functions say those may also be re-ordered - this contradicts the use
> of "asm volatile" in there, which again I'd like to understand.
>   

"asm volatile" has no effect on ordering.  It's only necessary to force 
an asm with no apparent side-effects to get emitted (ie, an asm with 
outputs which don't get used; asms without outputs are implicitly volatile).

All these operations should either explicitly list memory modification 
as an output.  The bit tests have no side-effects, so there's no problem 
if gcc decides they don't need to be emitted.

> As much as all of these, using 'int' for the 'nr' parameter and
> 'void *' for the 'addr' one is in conflict with
> Documentation/atomic_ops.txt, especially because bt{,c,r,s} indeed
> take the bit index as signed (which hence would really need special
> precaution) and access the full 32 bits (if 'unsigned long' was used
> properly here, 64 bits for x86-64) pointed at, so invalid uses like
> referencing a 'char' array cannot currently be caught.
>   

What's the problem with accessing a char array as bits?

> Finally, the code with and without this patch relies heavily on the
> -fno-strict-aliasing compiler switch and I'm not certain this really
> is a good idea.
>   

Doesn't the casting via void * stomp all that?

> In the light of all of this I'm sending this as RFC, as fixing the
> above might warrant a much bigger patch...
>
> Signed-off-by: Jan Beulich <jbeulich@novell.com>
>
> ---
>  include/asm-x86/bitops.h |   43 ++++++++++++++++++++++++-------------------
>  1 file changed, 24 insertions(+), 19 deletions(-)
>
> --- linux-2.6.25-rc5/include/asm-x86/bitops.h	2008-03-10 13:24:33.000000000 +0100
> +++ 2.6.25-rc5-x86-clear-bit/include/asm-x86/bitops.h	2008-03-13 08:45:40.000000000 +0100
> @@ -24,9 +24,12 @@
>  /* Technically wrong, but this avoids compilation errors on some gcc
>     versions. */
>  #define ADDR "=m" (*(volatile long *) addr)
> +#define BIT_ADDR "=m" (((volatile int *) addr)[nr >> 5])
>  #else
>  #define ADDR "+m" (*(volatile long *) addr)
> +#define BIT_ADDR "+m" (((volatile int *) addr)[nr >> 5])
>  #endif
> +#define BASE_ADDR "m" (*(volatile int *) addr)
>   

Hm, hardcoding ">> 5" seems like asking for trouble.  At least make the 
"int" an explicitly sized type.  It should also pass "nr" in as an 
explicit macro argument rather than just picking it up.

Does plain ADDR still get used?

It's unfortunate that gcc will runtime-compute the address of 
addr[nr>>5] even though we only need it for proper compile-time constraints.

    J

>  
>  /**
>   * set_bit - Atomically set a bit in memory
> @@ -79,9 +82,8 @@ static inline void __set_bit(int nr, vol
>   */
>  static inline void clear_bit(int nr, volatile void *addr)
>  {
> -	asm volatile(LOCK_PREFIX "btr %1,%0"
> -		     : ADDR
> -		     : "Ir" (nr));
> +	asm volatile(LOCK_PREFIX "btr %1,%2"
> +		     : BIT_ADDR : "Ir" (nr), BASE_ADDR);
>  }
>  
>  /*
> @@ -100,7 +102,7 @@ static inline void clear_bit_unlock(unsi
>  
>  static inline void __clear_bit(int nr, volatile void *addr)
>  {
> -	asm volatile("btr %1,%0" : ADDR : "Ir" (nr));
> +	asm volatile("btr %1,%2" : BIT_ADDR : "Ir" (nr), BASE_ADDR);
>  }
>  
>  /*
> @@ -135,7 +137,7 @@ static inline void __clear_bit_unlock(un
>   */
>  static inline void __change_bit(int nr, volatile void *addr)
>  {
> -	asm volatile("btc %1,%0" : ADDR : "Ir" (nr));
> +	asm volatile("btc %1,%2" : BIT_ADDR : "Ir" (nr), BASE_ADDR);
>  }
>  
>  /**
> @@ -149,8 +151,8 @@ static inline void __change_bit(int nr, 
>   */
>  static inline void change_bit(int nr, volatile void *addr)
>  {
> -	asm volatile(LOCK_PREFIX "btc %1,%0"
> -		     : ADDR : "Ir" (nr));
> +	asm volatile(LOCK_PREFIX "btc %1,%2"
> +		     : BIT_ADDR : "Ir" (nr), BASE_ADDR);
>  }
>  
>  /**
> @@ -198,10 +200,10 @@ static inline int __test_and_set_bit(int
>  {
>  	int oldbit;
>  
> -	asm("bts %2,%1\n\t"
> -	    "sbb %0,%0"
> -	    : "=r" (oldbit), ADDR
> -	    : "Ir" (nr));
> +	asm volatile("bts %2,%3\n\t"
> +		     "sbb %0,%0"
> +		     : "=r" (oldbit), BIT_ADDR
> +		     : "Ir" (nr), BASE_ADDR);
>  	return oldbit;
>  }
>  
> @@ -238,10 +240,10 @@ static inline int __test_and_clear_bit(i
>  {
>  	int oldbit;
>  
> -	asm volatile("btr %2,%1\n\t"
> +	asm volatile("btr %2,%3\n\t"
>  		     "sbb %0,%0"
> -		     : "=r" (oldbit), ADDR
> -		     : "Ir" (nr));
> +		     : "=r" (oldbit), BIT_ADDR
> +		     : "Ir" (nr), BASE_ADDR);
>  	return oldbit;
>  }
>  
> @@ -250,10 +252,10 @@ static inline int __test_and_change_bit(
>  {
>  	int oldbit;
>  
> -	asm volatile("btc %2,%1\n\t"
> +	asm volatile("btc %2,%3\n\t"
>  		     "sbb %0,%0"
> -		     : "=r" (oldbit), ADDR
> -		     : "Ir" (nr) : "memory");
> +		     : "=r" (oldbit), BIT_ADDR
> +		     : "Ir" (nr), BASE_ADDR);
>  
>  	return oldbit;
>  }
> @@ -288,10 +290,11 @@ static inline int variable_test_bit(int 
>  {
>  	int oldbit;
>  
> -	asm volatile("bt %2,%1\n\t"
> +	asm volatile("bt %2,%3\n\t"
>  		     "sbb %0,%0"
>  		     : "=r" (oldbit)
> -		     : "m" (*(unsigned long *)addr), "Ir" (nr));
> +		     : "m" (((volatile const int *)addr)[nr >> 5]),
> +		       "Ir" (nr), BASE_ADDR);
>  
>  	return oldbit;
>  }
> @@ -310,6 +313,8 @@ static int test_bit(int nr, const volati
>  	 constant_test_bit((nr),(addr)) :	\
>  	 variable_test_bit((nr),(addr)))
>  
> +#undef BASE_ADDR
> +#undef BIT_ADDR
>  #undef ADDR
>  
>  #ifdef CONFIG_X86_32
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>   

