Return-Path: <linux-kernel-owner+w=401wt.eu-S1763425AbXJYQsl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763425AbXJYQsl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 12:48:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762518AbXJYQmo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 12:42:44 -0400
Received: from www.tglx.de ([62.245.132.106]:42881 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762774AbXJYQmn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 12:42:43 -0400
Date: Thu, 25 Oct 2007 18:42:32 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Randy Dunlap <rdunlap@xenotime.net>
cc: Nick Piggin <nickpiggin@yahoo.com.au>, mingo@redhat.com, hpa@zytor.com,
       lkml <linux-kernel@vger.kernel.org>,
       torvalds <torvalds@linux-foundation.org>,
       akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH v2] bitops kernel-doc: inline instead of macro
In-Reply-To: <20071025093159.3ea69d03.rdunlap@xenotime.net>
Message-ID: <alpine.LFD.0.9999.0710251840530.3186@localhost.localdomain>
References: <20071023220959.a359d57d.rdunlap@xenotime.net> <200710241800.19764.nickpiggin@yahoo.com.au> <20071025093159.3ea69d03.rdunlap@xenotime.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Oct 2007, Randy Dunlap wrote:

> On Wed, 24 Oct 2007 18:00:19 +1000 Nick Piggin wrote:
> 
> > On Wednesday 24 October 2007 15:09, Randy Dunlap wrote:
> > > From: Randy Dunlap <randy.dunlap@oracle.com>
> > >
> > > Can we expand this macro definition, or should I look for a way to
> > > fool^W teach kernel-doc about this?
> > >
> > > scripts/kernel-doc says:
> > > Error(linux-2.6.24-rc1//include/asm-x86/bitops_32.h:188): cannot understand
> > > prototype: 'test_and_set_bit_lock test_and_set_bit '
> > 
> > Actually, it probably looks a bit nicer like this anyway. If you grep
> > for it, then you can actually see the parameters...
> > 
> > On third thoughts, an inline function might be the best thing to do,
> > and also avoid setting a bad example. What do you think?
> 
> ---
> 
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Use duplicated inline functions for test_and_set_bit_lock() on x86
> instead of #define macros, thus avoiding a bad example.  This allows
> kernel-doc to run cleanly instead of terminating with an error:

Hmm, can we simply do

static inline int test_and_set_bit_lock(int nr, volatile unsigned long * addr)
{
	return test_and_set_bit(nr, addr);
}

please ?

       tglx
 
> Error(linux-2.6.24-rc1//include/asm-x86/bitops_32.h:188): cannot understand prototype: 'test_and_set_bit_lock test_and_set_bit '
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> ---
>  include/asm-x86/bitops_32.h |   13 +++++++++++--
>  include/asm-x86/bitops_64.h |   13 +++++++++++--
>  2 files changed, 22 insertions(+), 4 deletions(-)
> 
> --- linux-2.6.24-rc1.orig/include/asm-x86/bitops_32.h
> +++ linux-2.6.24-rc1/include/asm-x86/bitops_32.h
> @@ -183,9 +183,18 @@ static inline int test_and_set_bit(int n
>   * @nr: Bit to set
>   * @addr: Address to count from
>   *
> - * This is the same as test_and_set_bit on x86
> + * This is the same as test_and_set_bit on x86.
>   */
> -#define test_and_set_bit_lock test_and_set_bit
> +static inline int test_and_set_bit_lock(int nr, volatile unsigned long * addr)
> +{
> +	int oldbit;
> +
> +	__asm__ __volatile__( LOCK_PREFIX
> +		"btsl %2,%1\n\tsbbl %0,%0"
> +		:"=r" (oldbit),"+m" (ADDR)
> +		:"Ir" (nr) : "memory");
> +	return oldbit;
> +}
>  
>  /**
>   * __test_and_set_bit - Set a bit and return its old value
> --- linux-2.6.24-rc1.orig/include/asm-x86/bitops_64.h
> +++ linux-2.6.24-rc1/include/asm-x86/bitops_64.h
> @@ -173,9 +173,18 @@ static __inline__ int test_and_set_bit(i
>   * @nr: Bit to set
>   * @addr: Address to count from
>   *
> - * This is the same as test_and_set_bit on x86
> + * This is the same as test_and_set_bit on x86.
>   */
> -#define test_and_set_bit_lock test_and_set_bit
> +static __inline__ int test_and_set_bit_lock(int nr, volatile void * addr)
> +{
> +	int oldbit;
> +
> +	__asm__ __volatile__( LOCK_PREFIX
> +		"btsl %2,%1\n\tsbbl %0,%0"
> +		:"=r" (oldbit),ADDR
> +		:"dIr" (nr) : "memory");
> +	return oldbit;
> +}
>  
>  /**
>   * __test_and_set_bit - Set a bit and return its old value
> 
