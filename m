Return-Path: <linux-kernel-owner+w=401wt.eu-S1753110AbYHPNbS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753110AbYHPNbS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2008 09:31:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752006AbYHPNbG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Aug 2008 09:31:06 -0400
Received: from nf-out-0910.google.com ([64.233.182.188]:52917 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751946AbYHPNbE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2008 09:31:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=GNZbTFggl3tGoW5fvpJcw60r4z8wZWKIUSfc3TJYuUdpgLgp1li5Nj4BHZcnTdDGkn
         zSJki+NPv/HhgLFzU0GGtL6tm4B3/olGkapZzpWKYEqf+busV/6/UytDEbikB554gW3Y
         fQiFKQtNUSiwjN5rKx4sdBSEJZyiZhd8yrAMA=
Message-ID: <48A6D694.4070302@gmail.com>
Date: Sat, 16 Aug 2008 15:31:00 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080720)
MIME-Version: 1.0
To: Alexey Dobriyan <adobriyan@gmail.com>
CC: torvalds@osdl.org, akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] De-macro spin_trylock_irq, spin_trylock_irqsave,	write_trylock_irqsave
References: <20080816095951.GA19926@martell.zuzino.mipt.ru>
In-Reply-To: <20080816095951.GA19926@martell.zuzino.mipt.ru>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/16/2008 11:59 AM, Alexey Dobriyan wrote:
> 1) de-macro, remove ({ usages as side-effect,
> 2) change calling convention to not accept "flags" by value -- trylock
>    functions can modify them, so by-value is misleading, and number of users
>    is relatively low.
> 3) de-macro spin_trylock_irq() for a change.

Doesn't this break on sparc -- is it tested there? Shouldn't all that be 
__always_inline?

> --- a/include/linux/spinlock.h
> +++ b/include/linux/spinlock.h
> @@ -320,26 +320,38 @@ do {						\
>  
>  #define spin_trylock_bh(lock)	__cond_lock(lock, _spin_trylock_bh(lock))
>  
> -#define spin_trylock_irq(lock) \
> -({ \
> -	local_irq_disable(); \
> -	spin_trylock(lock) ? \
> -	1 : ({ local_irq_enable(); 0;  }); \
> -})
> -
> -#define spin_trylock_irqsave(lock, flags) \
> -({ \
> -	local_irq_save(flags); \
> -	spin_trylock(lock) ? \
> -	1 : ({ local_irq_restore(flags); 0; }); \
> -})
> -
> -#define write_trylock_irqsave(lock, flags) \
> -({ \
> -	local_irq_save(flags); \
> -	write_trylock(lock) ? \
> -	1 : ({ local_irq_restore(flags); 0; }); \
> -})
> +static inline int spin_trylock_irq(spinlock_t *lock)
> +{
> +	local_irq_disable();
> +	if (spin_trylock(lock))
> +		return 1;
> +	else {
> +		local_irq_enable();
> +		return 0;
> +	}
> +}
> +
> +static inline int spin_trylock_irqsave(spinlock_t *lock, unsigned long *flags)
> +{
> +	local_irq_save(*flags);
> +	if (spin_trylock(lock))
> +		return 1;
> +	else {
> +		local_irq_restore(*flags);
> +		return 0;
> +	}
> +}
> +
> +static inline int write_trylock_irqsave(rwlock_t *lock, unsigned long *flags)
> +{
> +	local_irq_save(*flags);
> +	if (write_trylock(lock))
> +		return 1;
> +	else {
> +		local_irq_restore(*flags);
> +		return 0;
> +	}
> +}
>  
>  /*
>   * Pull the atomic_t declaration:

