Return-Path: <linux-kernel-owner+w=401wt.eu-S1754682AbZIUHoA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754682AbZIUHoA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 03:44:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752200AbZIUHn7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 03:43:59 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:37493 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751820AbZIUHn7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 03:43:59 -0400
Date: Mon, 21 Sep 2009 09:43:52 +0200
From: Ingo Molnar <mingo@elte.hu>
To: akpm@linux-foundation.org
Cc: kilroyd@googlemail.com, a.p.zijlstra@chello.nl,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 1/2] spinlocks: check spinlock_t/rwlock_t argument type
	on non-SMP builds
Message-ID: <20090921074352.GA22122@elte.hu>
References: <200909181957.n8IJv94X001996@imap1.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200909181957.n8IJv94X001996@imap1.linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* akpm@linux-foundation.org <akpm@linux-foundation.org> wrote:

> From: David Kilroy <kilroyd@googlemail.com>
> 
> When writing code for UP without CONFIG_DEBUG_SPINLOCK it's easy to get
> the first argument to the spinlock/rwlock functions wrong.  This is
> because the parameter is not actually used in this configuration.
> 
> Typically you will only find out it's wrong
>  * by rebuilding with CONFIG_SMP or CONFIG_DEBUG_SPINLOCK
>  * after you've submitted your beautiful patch series.
> 
> The first means a long wait, and the latter is a bit late.
> 
> Change the intermediate macros into inline functions.
> 
> Signed-off-by: David Kilroy <kilroyd@googlemail.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  include/linux/spinlock.h        |    6 -
>  include/linux/spinlock_api_up.h |  118 ++++++++++++++++++++++--------
>  2 files changed, 92 insertions(+), 32 deletions(-)
> 
> diff -puN include/linux/spinlock.h~spinlocks-check-spinlock_t-rwlock_t-argument-type-on-non-smp-builds include/linux/spinlock.h
> --- a/include/linux/spinlock.h~spinlocks-check-spinlock_t-rwlock_t-argument-type-on-non-smp-builds
> +++ a/include/linux/spinlock.h
> @@ -240,17 +240,17 @@ static inline void smp_mb__after_lock(vo
>  #define spin_lock_irqsave(lock, flags)			\
>  	do {						\
>  		typecheck(unsigned long, flags);	\
> -		_spin_lock_irqsave(lock, flags);	\
> +		_spin_lock_irqsave(lock, &flags);	\
>  	} while (0)
>  #define read_lock_irqsave(lock, flags)			\
>  	do {						\
>  		typecheck(unsigned long, flags);	\
> -		_read_lock_irqsave(lock, flags);	\
> +		_read_lock_irqsave(lock, &flags);	\
>  	} while (0)

these bits broke the Alpha build:

/home/mingo/tip/arch/alpha/include/asm/core_t2.h: In function 't2_readb':
/home/mingo/tip/arch/alpha/include/asm/core_t2.h:451: error: '_spin_lock_irqsave' is static but used in inline function 't2_readb' which is not static
/home/mingo/tip/arch/alpha/include/asm/core_t2.h:456: error: '_spin_unlock_irqrestore' is static but used in inline function 't2_readb' which is not static
/home/mingo/tip/arch/alpha/include/asm/core_t2.h: In function 't2_readw':
/home/mingo/tip/arch/alpha/include/asm/core_t2.h:465: error: '_spin_lock_irqsave' is static but used in inline function 't2_readw' which is not static
/home/mingo/tip/arch/alpha/include/asm/core_t2.h:470: error: '_spin_unlock_irqrestore' is static but used in inline function 't2_readw' which is not static
/home/mingo/tip/arch/alpha/include/asm/core_t2.h: In function 't2_readl':
/home/mingo/tip/arch/alpha/include/asm/core_t2.h:483: error: '_spin_lock_irqsave' is static but used in inline function 't2_readl' which is not static
/home/mingo/tip/arch/alpha/include/asm/core_t2.h:488: error: '_spin_unlock_irqrestore' is static but used in inline function 't2_readl' which is not static
/home/mingo/tip/arch/alpha/include/asm/core_t2.h: In function 't2_readq':
/home/mingo/tip/arch/alpha/include/asm/core_t2.h:497: error: '_spin_lock_irqsave' is static but used in inline function 't2_readq' which is not static
/home/mingo/tip/arch/alpha/include/asm/core_t2.h:504: error: '_spin_unlock_irqrestore' is static but used in inline function 't2_readq' which is not static
/home/mingo/tip/arch/alpha/include/asm/core_t2.h: In function 't2_writeb':
/home/mingo/tip/arch/alpha/include/asm/core_t2.h:513: error: '_spin_lock_irqsave' is static but used in inline function 't2_writeb' which is not static
/home/mingo/tip/arch/alpha/include/asm/core_t2.h:519: error: '_spin_unlock_irqrestore' is static but used in inline function 't2_writeb' which is not static
/home/mingo/tip/arch/alpha/include/asm/core_t2.h: In function 't2_writew':
/home/mingo/tip/arch/alpha/include/asm/core_t2.h:527: error: '_spin_lock_irqsave' is static but used in inline function 't2_writew' which is not static
/home/mingo/tip/arch/alpha/include/asm/core_t2.h:533: error: '_spin_unlock_irqrestore' is static but used in inline function 't2_writew' which is not static
/home/mingo/tip/arch/alpha/include/asm/core_t2.h: In function 't2_writel':
/home/mingo/tip/arch/alpha/include/asm/core_t2.h:545: error: '_spin_lock_irqsave' is static but used in inline function 't2_writel' which is not static
/home/mingo/tip/arch/alpha/include/asm/core_t2.h:550: error: '_spin_unlock_irqrestore' is static but used in inline function 't2_writel' which is not static
/home/mingo/tip/arch/alpha/include/asm/core_t2.h: In function 't2_writeq':
/home/mingo/tip/arch/alpha/include/asm/core_t2.h:558: error: '_spin_lock_irqsave' is static but used in inline function 't2_writeq' which is not static
/home/mingo/tip/arch/alpha/include/asm/core_t2.h:565: error: '_spin_unlock_irqrestore' is static but used in inline function 't2_writeq' which is not static
make[2]: *** [arch/alpha/kernel/sys_sable.o] Error 1
make[2]: *** Waiting for unfinished jobs....
make[1]: *** [arch/alpha/kernel] Error 2
make[1]: *** Waiting for unfinished jobs....

so i've dropped them for now.

	Ingo
