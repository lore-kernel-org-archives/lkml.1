Return-Path: <linux-kernel-owner+w=401wt.eu-S1757191AbZGDB50@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757191AbZGDB50 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 21:57:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756308AbZGDB5T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 21:57:19 -0400
Received: from mga03.intel.com ([143.182.124.21]:40116 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754910AbZGDB5T convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 21:57:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,345,1243839600"; 
   d="scan'208";a="161404243"
From: "Du, Alek" <alek.du@intel.com>
To: David Brownell <david-b@pacbell.net>,
       "peterz@infradead.org" <peterz@infradead.org>
CC: Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Date: Sat, 4 Jul 2009 09:57:17 +0800
Subject: RE: [PATCH] gpio: pca953x: add irq_chip for irq demuxing
Thread-Topic: [PATCH] gpio: pca953x: add irq_chip for irq demuxing
Thread-Index: Acn7/tvfSWQQfL0cTy6gLclo/CYH9AASZOeg
Message-ID: <EADF0A36011179459010BDF5142A457501C9F468C7@pdsmsx502.ccr.corp.intel.com>
References: <20090703211034.47fc0880@dxy.sh.intel.com>
 <200907030953.54006.david-b@pacbell.net>
In-Reply-To: <200907030953.54006.david-b@pacbell.net>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: zh-CN, en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David,

Thanks for the review.
Basically my idea is *not* actually demuxing the I2C gpio interrupts. Since the demuxing need send I2C command to the GPIO chip, which has big latency.
My idea is, when this GPIO chip hooked to an edge sensitive interrupt line, we could use this interrupt handler to call all second level IRQs. The hooked edge detect interrupt line "automatically" masks the interrupt when the GPIO pin state is not restored to original state.

>> +static void pca953x_irq_handler(unsigned irq, struct irq_desc *desc)
>> +{
>> +	struct pca953x_chip *chip = (struct pca953x_chip *)get_irq_data(irq);
>> +	int i;
>> +
>> +	if (desc->chip->ack)
>> +		desc->chip->ack(irq);
>
>This top-level IRQ chaining handler is clelarly incorrect.
>Reading from a pca9539 spec I have handy:
>
>	Resetting the interrupt circuit is achieved when
>	data on the port is changed to the original setting,
>	data is read from the port that generated the
>	interrupt, or in a Stop event.
>
>You're not guaranteeing *any* of those happens.  Since
>the chip's nINT output is level-active, it's possible
>that the hardware is still raising this interrupt when
>this hander returns ...

That's why we connected the nINT output to an edge sensitive interrupt line.
The IRQ would be triggered only once if the nINT keeps level-low. The driver that requires the gpio pin IRQ needs to clear the interrupt source.

>> +	/* we must call all sub-irqs, since there is no way to read
>> +	 * I2C gpio expander's status in irq context. The driver itself
>> +	 * would be reponsible to check if the irq is for him.
>> +	 */
>> +	for (i = 0; i < chip->gpio_chip.ngpio; i++)
>> +		generic_handle_irq(chip->irq_base + i);
>
>You should only do that for pins configured as inputs.
>The nIRQ signal is not triggered for changes on output pins.
Ok, but those output pins, actually nobody will install IRQ handlers for them.

>> +	if (chip->irq_base) {
>> +		int i;
>> +
>> +		set_irq_type(client->irq,
>> +				IRQ_TYPE_EDGE_FALLING | IRQ_TYPE_EDGE_RISING);
>
>Won't work on all hardware.  And surely you'd want just
>EDGE_FALLING, so you get only half as many IRQs, if you
>happen to be hooking this up to an interrupt line which
>supports edge-sensitive IRQ triggers (and not through
>some kind of signal inverter)?

I set the IRQ type to EDGE_FALLING and EDGE_RISING because the nINT signal of the GPIO is low-active. So when one of the input pins transit from high/low, it will trigger two interrupts on the hooked up interrupt line.


Thanks,
Alek
