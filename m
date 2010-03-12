Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758689Ab0CLViZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 16:38:25 -0500
Received: from mail-qy0-f179.google.com ([209.85.221.179]:37136 "EHLO
	mail-qy0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753521Ab0CLViY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 16:38:24 -0500
MIME-Version: 1.0
In-Reply-To: <20100312130723.43308ccd.akpm@linux-foundation.org>
References: <20100205203201.GA32281@oksana.dev.rtsoft.ru> <20100205203236.GC1475@oksana.dev.rtsoft.ru> 
	<20100312130723.43308ccd.akpm@linux-foundation.org>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Fri, 12 Mar 2010 14:38:02 -0700
X-Google-Sender-Auth: b2e88192948106cb
Message-ID: <fa686aa41003121338oe34eb89o22177cb0a309cc85@mail.gmail.com>
Subject: Re: [PATCH 3/4] of/gpio: Implement GPIOLIB notifier hooks
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Anton Vorontsov <avorontsov@ru.mvista.com>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Bill Gatliff <bgat@billgatliff.com>,
       Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 12, 2010 at 2:07 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Fri, 5 Feb 2010 23:32:36 +0300
> Anton Vorontsov <avorontsov@ru.mvista.com> wrote:
>
>> This patch implements GPIOLIB notifier hooks, and thus makes device-enabled
>> GPIO chips (i.e. the ones that have gpio_chip->dev specified) automatically
>> attached to the OpenFirmware subsystem. Which means that now we can handle
>> I2C and SPI GPIO chips almost* transparently.
>>
>> ...
>>
>> +static int of_gpiochip_register_simple(struct gpio_chip *chip,
>> +                                    struct device_node *np)
>
> Why is this called "register_simple" but the unregistration function
> isn't called "unregister_simple"?
>
>> +{
>> +     struct of_gpio_chip *of_gc;
>> +
>> +     if (np->data) {
>> +             WARN_ON(1);
>> +             return -EBUSY;
>> +     }
>> +
>> +     of_gc = kzalloc(sizeof(*of_gc), GFP_KERNEL);
>> +     if (!of_gc)
>> +             return -ENOMEM;
>> +
>> +     of_gc->gpio_cells = 2;
>> +     of_gc->xlate = of_gpio_simple_xlate;
>> +     of_gc->chip = chip;
>> +     np->data = of_gc;
>> +     of_node_get(np);
>> +
>> +     return 0;
>> +}
>> +EXPORT_SYMBOL(of_gpiochip_register_simple);
>
> Makes no sense to export a static symbol and to provide no declaration
> of it in a .h file.  I assume the export was unintended.
>
>
> My plot is somewhat lost.  Grant, could you please summarise in
> easy-for-akpm-to-understand terms what your issues are with this
> patchset and how you think we should proceed?

Sure.
I suggested the notifier approach in the first place, but now that I
see what is required to implement it I don't like it.  I also don't
like the potential race condition between registering GPIO devices and
registering the OF gpio notifier.  It is simpler and less code to put
the of_gpio hook directly into the GPIO registration path.  If
CONFIG_OF is not set, then the OF hooks can resolve to empty static
inline functions.

How to proceed:  I'd like to leave this series out for the 2.6.34
cycle and I'll pick it into my OF tree before the 2.6.35 merge window,
but I'll probably modify it to call the OF hooks directly and leave
out the unnecessary notifier infrastructure.

g.

-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
