Return-Path: <linux-kernel-owner+w=401wt.eu-S1755512AbZITUNY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755512AbZITUNY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Sep 2009 16:13:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755420AbZITUNX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Sep 2009 16:13:23 -0400
Received: from khc.piap.pl ([195.187.100.11]:58258 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755418AbZITUNX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Sep 2009 16:13:23 -0400
From: Krzysztof Halasa <khc@pm.waw.pl>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
       Russell King <linux@arm.linux.org.uk>
Subject: Re: [PATCH] [TRIVIAL] Changes to IRQs.
References: <m34oqx4s0e.fsf@intrepid.localdomain>
	<alpine.LNX.2.00.0909202042300.17028@wotan.suse.de>
Date: Sun, 20 Sep 2009 22:13:24 +0200
In-Reply-To: <alpine.LNX.2.00.0909202042300.17028@wotan.suse.de> (Jiri
	Kosina's message of "Sun, 20 Sep 2009 20:43:50 +0200 (CEST)")
Message-ID: <m3vdjds7bv.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Kosina <jkosina@suse.cz> writes:

> This doesn't really qualify for trivial queue, adding ARM addressess to CC
> (I hope I got them right after the latest flame :P) at least for the ARM
> bits.

(Fixed the arm ml address, and lkml too (my mistake)).

But you noticed, of course, that the only real change is that to the
arch/arm/plat-orion/gpio.c? Just asking to make sure as the patch may
look longer than it is.

>> +++ b/Documentation/DocBook/genericirq.tmpl
>> @@ -417,8 +417,8 @@ desc->chip->end();
>>        </para>
>>        <para>
>>  	To make use of the split implementation, replace the call to
>> -	__do_IRQ by a call to desc->chip->handle_irq() and associate
>> -        the appropriate handler function to desc->chip->handle_irq().
>> +	__do_IRQ by a call to desc->handle_irq() and associate
>> +        the appropriate handler function to desc->handle_irq().

Only the comment fix, the code has been changed long ago.

>> +++ b/arch/arm/include/asm/hw_irq.h
>> @@ -10,14 +10,6 @@ static inline void ack_bad_irq(int irq)
>>  	irq_err_count++;
>>  }
>>  
>> -/*
>> - * Obsolete inline function for calling irq descriptor handlers.
>> - */
>> -static inline void desc_handle_irq(unsigned int irq, struct irq_desc *desc)
>> -{
>> -	desc->handle_irq(irq, desc);
>> -}

IIRC there had been no users of this function for some time, one has
been added recently...

>> +++ b/arch/arm/plat-orion/gpio.c
>> @@ -354,6 +354,6 @@ void orion_gpio_irq_handler(int pinoff)
>>  			polarity ^= 1 << (pin & 31);
>>  			writel(polarity, GPIO_IN_POL(pin));
>>  		}
>> -		desc_handle_irq(irq, desc);
>> +		desc->handle_irq(irq, desc);
>>  	}
>>  }

That's the one. I've little doubt someone did that by mistake.

>> +++ b/include/linux/irq.h
>> @@ -281,7 +281,7 @@ extern irqreturn_t handle_IRQ_event(unsigned int irq, struct irqaction *action);
>>  
>>  /*
>>   * Built-in IRQ handlers for various IRQ types,
>> - * callable via desc->chip->handle_irq()
>> + * callable via desc->handle_irq()

The code has been changed long ago, the patch only fixes comments.

But of course I'm not insisting, just wanted to flush my queue of such
things out.
-- 
Krzysztof Halasa
