Return-Path: <linux-kernel-owner+w=401wt.eu-S1758421AbYHPUtv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758421AbYHPUtv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2008 16:49:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754881AbYHPUtH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Aug 2008 16:49:07 -0400
Received: from mu-out-0910.google.com ([209.85.134.190]:57568 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756287AbYHPUtF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2008 16:49:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=P0tM8yyaNHhg8aeavkaQgLLtx06DDPuDn+Y4cfy0zxFF7v6qMpqBnXqecZjjTrmy45
         hu9jduw3brbktmBB712wnsLr4uM4fqO/dxQo6i09p+aHhurrrcdDUWrR7Y4ZnIpGaZMr
         rgZDpaM5Gka7+7Mi4jwWknUMm2g+ztrO0WnIg=
Date: Sun, 17 Aug 2008 00:48:55 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: torvalds@osdl.org, akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] De-macro spin_trylock_irq, spin_trylock_irqsave,
	write_trylock_irqsave
Message-ID: <20080816204855.GA5151@martell.zuzino.mipt.ru>
References: <20080816095951.GA19926@martell.zuzino.mipt.ru> <48A6D694.4070302@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48A6D694.4070302@gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 16, 2008 at 03:31:00PM +0200, Jiri Slaby wrote:
> On 08/16/2008 11:59 AM, Alexey Dobriyan wrote:
>> 1) de-macro, remove ({ usages as side-effect,
>> 2) change calling convention to not accept "flags" by value -- trylock
>>    functions can modify them, so by-value is misleading, and number of 
>> users
>>    is relatively low.
>> 3) de-macro spin_trylock_irq() for a change.
>
> Doesn't this break on sparc -- is it tested there?

What's so special about sparc?

If you mean compile-tested, yes, compile-tested on

	sparc-allnoconfig
	sparc-defconfig
	sparc-smp-n-debug-n
	sparc-smp-n-debug-y
	sparc-smp-y-debug-n
	sparc-smp-y-debug-y

> Shouldn't all that be __always_inline?

I don't know, likely nobody cares if they are inline or not.

>> --- a/include/linux/spinlock.h
>> +++ b/include/linux/spinlock.h
>> @@ -320,26 +320,38 @@ do {						\
>>   #define spin_trylock_bh(lock)	__cond_lock(lock, _spin_trylock_bh(lock))
>>  -#define spin_trylock_irq(lock) \
>> -({ \
>> -	local_irq_disable(); \
>> -	spin_trylock(lock) ? \
>> -	1 : ({ local_irq_enable(); 0;  }); \
>> -})
>> -
>> -#define spin_trylock_irqsave(lock, flags) \
>> -({ \
>> -	local_irq_save(flags); \
>> -	spin_trylock(lock) ? \
>> -	1 : ({ local_irq_restore(flags); 0; }); \
>> -})
>> -
>> -#define write_trylock_irqsave(lock, flags) \
>> -({ \
>> -	local_irq_save(flags); \
>> -	write_trylock(lock) ? \
>> -	1 : ({ local_irq_restore(flags); 0; }); \
>> -})
>> +static inline int spin_trylock_irq(spinlock_t *lock)
>> +{
>> +	local_irq_disable();
>> +	if (spin_trylock(lock))
>> +		return 1;
>> +	else {
>> +		local_irq_enable();
>> +		return 0;
>> +	}
>> +}
>> +
>> +static inline int spin_trylock_irqsave(spinlock_t *lock, unsigned long 
>> *flags)
>> +{
>> +	local_irq_save(*flags);
>> +	if (spin_trylock(lock))
>> +		return 1;
>> +	else {
>> +		local_irq_restore(*flags);
>> +		return 0;
>> +	}
>> +}
>> +
>> +static inline int write_trylock_irqsave(rwlock_t *lock, unsigned long 
>> *flags)
>> +{
>> +	local_irq_save(*flags);
>> +	if (write_trylock(lock))
>> +		return 1;
>> +	else {
>> +		local_irq_restore(*flags);
>> +		return 0;
>> +	}
>> +}
>>   /*
>>   * Pull the atomic_t declaration:

