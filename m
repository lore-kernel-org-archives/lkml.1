Return-Path: <linux-kernel-owner+w=401wt.eu-S1752317AbYKSG5u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752317AbYKSG5u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 01:57:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752854AbYKSG5W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 01:57:22 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52953 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752712AbYKSG5T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 01:57:19 -0500
Date: Tue, 18 Nov 2008 22:56:29 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Bryan Wu <cooloney@kernel.org>
Cc: torvalds@linux-foundation.org, mingo@elte.hu, linux-kernel@vger.kernel.org,
       Graf Yang <graf.yang@analog.com>
Subject: Re: [PATCH 2/5] Blackfin arch: SMP supporting patchset: Blackfin
 header files and machine common code
Message-Id: <20081118225629.eddd23ae.akpm@linux-foundation.org>
In-Reply-To: <1226999108-13839-3-git-send-email-cooloney@kernel.org>
References: <1226999108-13839-1-git-send-email-cooloney@kernel.org>
	<1226999108-13839-3-git-send-email-cooloney@kernel.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Nov 2008 17:05:05 +0800 Bryan Wu <cooloney@kernel.org> wrote:

> From: Graf Yang <graf.yang@analog.com>
> 
> Blackfin dual core BF561 processor can support SMP like features.
> https://docs.blackfin.uclinux.org/doku.php?id=linux-kernel:smp-like
> 
> In this patch, we provide SMP extend to Blackfin header files
> and machine common code
> 
>
> ...
>
> +#define atomic_add_unless(v, a, u)				\
> +({								\
> +	int c, old;						\
> +	c = atomic_read(v);					\
> +	while (c != (u) && (old = atomic_cmpxchg((v), c, c + (a))) != c) \
> +		c = old;					\
> +	c != (u);						\
> +})

The macro references its args multiple times and will do weird or
inefficient things when called with expressions which have
side-effects, or which do slow things.

>
> ...
>
> +#include <asm/system.h>		/* save_flags */
> +
> +static inline void set_bit(int nr, volatile unsigned long *addr)
>  {
>  	int *a = (int *)addr;
>  	int mask;
> @@ -57,21 +91,23 @@ static __inline__ void clear_bit(int nr, volatile unsigned long *addr)
>  	a += nr >> 5;
>  	mask = 1 << (nr & 0x1f);
>  	local_irq_save(flags);
> -	*a &= ~mask;
> +	*a |= mask;

I think you just broke clear_bit().  Maybe I'm misreading the diff.

>  	local_irq_restore(flags);
>  }
>
>
> ...
>
> +#define smp_mb__before_clear_bit()	barrier()
> +#define smp_mb__after_clear_bit()	barrier()
> +
> +static inline void __set_bit(int nr, volatile unsigned long *addr)
> +{
> +	int *a = (int *)addr;
> +	int mask;
> +
> +	a += nr >> 5;
> +	mask = 1 << (nr & 0x1f);
> +	*a |= mask;
> +}
> +
> +static inline void __clear_bit(int nr, volatile unsigned long *addr)
> +{
> +	int *a = (int *)addr;
> +	int mask;
> +
> +	a += nr >> 5;
> +	mask = 1 << (nr & 0x1f);
> +	*a &= ~mask;
> +}
> +
> +static inline void __change_bit(int nr, volatile unsigned long *addr)
> +{
> +	int mask;
> +	unsigned long *ADDR = (unsigned long *)addr;
> +
> +	ADDR += nr >> 5;
> +	mask = 1 << (nr & 31);
> +	*ADDR ^= mask;
> +}

I'm surprised there isn't any generic code which can be used for the above.

>
> ...
>

Gad what a lot of code.  I don't think I have time to read it all, sorry.
