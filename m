Return-Path: <linux-kernel-owner+w=401wt.eu-S1754736AbZI3P2J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754736AbZI3P2J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 11:28:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754687AbZI3P2I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 11:28:08 -0400
Received: from gw1.cosmosbay.com ([212.99.114.194]:51208 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754676AbZI3P2H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 11:28:07 -0400
Message-ID: <4AC378C9.5050507@gmail.com>
Date: Wed, 30 Sep 2009 17:27:05 +0200
From: Eric Dumazet <eric.dumazet@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>, John Stultz <johnstul@us.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Subject: Re: Linux 2.6.32-rc1
References: <alpine.LFD.2.01.0909271511190.3349@localhost.localdomain>	<4AC060AE.1090401@gmail.com>	<alpine.LFD.2.01.0909280829100.3349@localhost.localdomain>	<20090928191506.40b61793@mschwide.boeblingen.de.ibm.com>	<4AC10365.7090802@gmail.com>	<4AC2712C.4080901@gmail.com>	<alpine.LFD.2.01.0909291410440.6996@localhost.localdomain>	<20090929232248.735bf4df@infradead.org>	<alpine.LFD.2.01.0909291429570.6996@localhost.localdomain> <20090930170754.0886ff2e@infradead.org>
In-Reply-To: <20090930170754.0886ff2e@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Wed, 30 Sep 2009 17:27:06 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven a écrit :
> On Tue, 29 Sep 2009 14:56:28 -0700 (PDT)
> Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
>>
>> On Tue, 29 Sep 2009, Arjan van de Ven wrote:
>>> can't we use alternatives() for this, to patch cmpxchg64 in ?
>>> I mean.. it'll be commonly supported nowadays.. the fallback to it
>>> not being supported could be a bit slower by now...
>> Yes, we could. It would limit us to some fixed address format,
>> probably
>>
>> 	cmpxchg8b (%esi)
>>
>> or something. Use something like this as a starting point, perhaps?
>>
>> NOTE! Totally untested! And you'd actually need to implement the 
>> "cmpxchg8b_emu" function that takes it's arguments in %eax:%edx,
>> %ebx:%ecx and %esi and doesn't trash any other registers..
> 
> so I debugged this guy (had a few bugs ;-)
> 
> patch, including a new cmpxchg8b_emu below:
> 
> From 5a76986c5dd272ea16a9b8abb7349ff3d6791c2b Mon Sep 17 00:00:00 2001
> From: Arjan van de Ven <arjan@linux.intel.com>
> Date: Wed, 30 Sep 2009 17:04:35 +0200
> Subject: [PATCH] x86: Provide an alternative() based cmpxchg64()
> 
> Based on Linus' patch, this patch provides cmpxchg64() using
> the alternative() infrastructure.
> 
> Note: the fallback is NOT smp safe, just like the current fallback
> is not SMP safe.
> 
> Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
> ---
>  arch/x86/include/asm/cmpxchg_32.h |   29 ++++++++++--------
>  arch/x86/kernel/i386_ksyms_32.c   |    3 ++
>  arch/x86/lib/Makefile             |    2 +-
>  arch/x86/lib/cmpxchg8b_emu.S      |   61 +++++++++++++++++++++++++++++++++++++
>  4 files changed, 81 insertions(+), 14 deletions(-)
>  create mode 100644 arch/x86/lib/cmpxchg8b_emu.S
> 
> diff --git a/arch/x86/include/asm/cmpxchg_32.h b/arch/x86/include/asm/cmpxchg_32.h
> index 82ceb78..3b21afa 100644
> --- a/arch/x86/include/asm/cmpxchg_32.h
> +++ b/arch/x86/include/asm/cmpxchg_32.h
> @@ -312,19 +312,22 @@ static inline unsigned long cmpxchg_386(volatile void *ptr, unsigned long old,
>  
>  extern unsigned long long cmpxchg_486_u64(volatile void *, u64, u64);
>  
> -#define cmpxchg64(ptr, o, n)						\
> -({									\
> -	__typeof__(*(ptr)) __ret;					\
> -	if (likely(boot_cpu_data.x86 > 4))				\
> -		__ret = (__typeof__(*(ptr)))__cmpxchg64((ptr),		\
> -				(unsigned long long)(o),		\
> -				(unsigned long long)(n));		\
> -	else								\
> -		__ret = (__typeof__(*(ptr)))cmpxchg_486_u64((ptr),	\
> -				(unsigned long long)(o),		\
> -				(unsigned long long)(n));		\
> -	__ret;								\
> -})
> +#define cmpxchg64(ptr, o, n)					\
> +({								\
> +	__typeof__(*(ptr)) __ret;				\
> +	__typeof__(*(ptr)) __old = (o);				\
> +	__typeof__(*(ptr)) __new = (n);				\
> +	alternative_io("call cmpxchg8b_emu",			\
> +			"lock; cmpxchg8b (%%esi)" ,		\
> +		       X86_FEATURE_CX8,				\
> +		       "=A" (__ret),				\
> +		       "S" ((ptr)), "0" (__old),		\
> +		       "b" ((unsigned int)__new),		\
> +		       "c" ((unsigned int)(__new>>32)));	\
> +	__ret; })
> +
> +
> +
>  #define cmpxchg64_local(ptr, o, n)					\
>  ({									\
>  	__typeof__(*(ptr)) __ret;					\
> diff --git a/arch/x86/kernel/i386_ksyms_32.c b/arch/x86/kernel/i386_ksyms_32.c
> index 43cec6b..f17930e 100644
> --- a/arch/x86/kernel/i386_ksyms_32.c
> +++ b/arch/x86/kernel/i386_ksyms_32.c
> @@ -10,6 +10,9 @@
>  EXPORT_SYMBOL(mcount);
>  #endif
>  
> +extern void cmpxchg8b_emu(void); /* dummy proto */
> +EXPORT_SYMBOL(cmpxchg8b_emu);
> +
>  /* Networking helper routines. */
>  EXPORT_SYMBOL(csum_partial_copy_generic);
>  
> diff --git a/arch/x86/lib/Makefile b/arch/x86/lib/Makefile
> index 9e60920..3e549b8 100644
> --- a/arch/x86/lib/Makefile
> +++ b/arch/x86/lib/Makefile
> @@ -15,7 +15,7 @@ ifeq ($(CONFIG_X86_32),y)
>          obj-y += atomic64_32.o
>          lib-y += checksum_32.o
>          lib-y += strstr_32.o
> -        lib-y += semaphore_32.o string_32.o
> +        lib-y += semaphore_32.o string_32.o cmpxchg8b_emu.o
>  
>          lib-$(CONFIG_X86_USE_3DNOW) += mmx_32.o
>  else
> diff --git a/arch/x86/lib/cmpxchg8b_emu.S b/arch/x86/lib/cmpxchg8b_emu.S
> new file mode 100644
> index 0000000..b8af4c7
> --- /dev/null
> +++ b/arch/x86/lib/cmpxchg8b_emu.S
> @@ -0,0 +1,61 @@
> +/*
> + *	This program is free software; you can redistribute it and/or
> + *	modify it under the terms of the GNU General Public License
> + *	as published by the Free Software Foundation; version 2
> + *	of the License.
> + *
> + */
> +
> +#include <linux/linkage.h>
> +#include <asm/alternative-asm.h>
> +#include <asm/frame.h>
> +#include <asm/dwarf2.h>
> +
> +
> +.text
> +
> +/*
> + * Inputs:
> + * %esi : memory location to compare
> + * %eax : low 32 bits of old value
> + * %edx : high 32 bits of old value
> + * %ebx : low 32 bits of new value
> + * %ecx : high 32 bits of new value
> + */
> +ENTRY(cmpxchg8b_emu)
> +	CFI_STARTPROC
> +
> +	push %edi
> +	push %ebx
> +	push %ecx
> +	/* disable interrupts */
> +	pushf

> +	pop %edi
Why do you pop flags in edi, to later re-push them ?

> +	cli
> +
> +	cmpl %edx, 4(%esi)
> +	jne 1f
> +	cmpl %eax, (%esi)
> +	jne 1f
> +

So we dont have irq fro this cpu, ok.

And other cpus allowed, and xchg implies lock prefix, ok.


> +	xchg (%esi), %ebx
> +	xchg 4(%esi), %ecx
How this sequence is guaranteed to be atomic with other cpus ?

If it is a !SMP implementation, then you could replace xchg by mov instructions.

	mov %ebx,(%esi)
	mov %ecx,4(%esi)

> +	mov %ebx, %eax
> +	mov %ecx, %edx
and avoid these of course


> +
> +2:
> +	/* restore interrupts */
> +	push %edi
> +	popf
> +
> +	pop %ecx
> +	pop %ebx
> +	pop %edi
> +	ret
> +1:
> +	mov (%esi), %eax
> +	mov 4(%esi), %edx
> +	jmp 2b
> +	CFI_ENDPROC
> +ENDPROC(cmpxchg8b_emu)
> +


So I suggest :


ENTRY(cmpxchg8b_emu)
	CFI_STARTPROC

	/* disable interrupts */
	pushf
	cli

	cmpl  %eax,(%esi)
	jne   1f
	cmpl  %edx,4(%esi)
	jne   2f

	mov   %ebx,(%esi)
	mov   %ecx,4(%esi)

	/* restore interrupts */
	popf
	ret
1:
	mov (%esi), %eax
2:
	mov 4(%esi), %edx
	popf
	ret
	CFI_ENDPROC
ENDPROC(cmpxchg8b_emu)
