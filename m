Return-Path: <linux-kernel-owner+w=401wt.eu-S1754743AbZI3P6S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754743AbZI3P6S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 11:58:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754265AbZI3P6S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 11:58:18 -0400
Received: from gw1.cosmosbay.com ([212.99.114.194]:54524 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754447AbZI3P6R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 11:58:17 -0400
Message-ID: <4AC37FE5.7020200@gmail.com>
Date: Wed, 30 Sep 2009 17:57:25 +0200
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
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Wed, 30 Sep 2009 17:57:28 +0200 (CEST)
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
>>From 5a76986c5dd272ea16a9b8abb7349ff3d6791c2b Mon Sep 17 00:00:00 2001
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


Note:

lock; cmpxchg8b (%%esi)

gives 4 bytes opcode : f0 0f c7 0e
Because alternative (call cmpxchg8b_emu) uses 5 bytes, a nop will be added.

Choosing ".byte 0xf0, 0x0f, 0xc7, 0x4e, 0x00"  aka "lock cmpxchg8b 0x0(%esi)" is a litle bit better ?

