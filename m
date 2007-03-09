Return-Path: <linux-kernel-owner+w=401wt.eu-S1767495AbXCIUns@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767495AbXCIUns (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 15:43:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965819AbXCIUnr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 15:43:47 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:60069 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965821AbXCIUnq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 15:43:46 -0500
Message-ID: <52293.172.21.0.22.1173473006.squirrel@pat.norway.atmel.com>
In-Reply-To: <200703091130.13547.david-b@pacbell.net>
References: <200703090945.38880.david-b@pacbell.net>
    <11734661281633-git-send-email-hskinnemoen@atmel.com>
    <200703091130.13547.david-b@pacbell.net>
Date: Fri, 9 Mar 2007 21:43:26 +0100 (CET)
Subject: Re: [PATCH] Bitbanging i2c bus driver using the GPIO API
From: =?iso-8859-1?Q?H=E5vard_Skinnemoen?= <hskinnemoen@atmel.com>
To: "David Brownell" <david-b@pacbell.net>
Cc: "Haavard Skinnemoen" <hskinnemoen@atmel.com>,
       "Jean Delvare" <khali@linux-fr.org>, "Bryan Wu" <bryan.wu@analog.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Deepak Saxena" <dsaxena@plexity.net>, linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.5
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, March 9, 2007 20:30, David Brownell wrote:
> On Friday 09 March 2007 10:48 am, Haavard Skinnemoen wrote:
>> This is a very simple bitbanging i2c bus driver utilizing the new
>> arch-neutral GPIO API. Useful for chips that don't have a built-in
>> i2c controller, additional i2c busses, or testing purposes.
>
> That's the right idea!  But remember that not all GPIOs support
> reading back the actual value on SCL (it's an OUT pin, so lacking
> multidrive capability the values "should" be what you wrote), so
> getscl() support should depend on a flag in platform data.  In
> the same vein, if SCL is an output-only pin, you won't be able
> to change its direction ... but then, I'm not sure why you were
> changing its direction in setscl() rather than just its value.

The idea is to keep the output value at 0 and switch the output driver on
and off. I assumed that changing the direction was the easiest way to
achieve this.

I never really thought about output-only pins. Is it actually possible to
implement i2c properly on such hardware?

> I2C has another interesting special case.  at91_set_multi_drive()
> would be appropriate (yes?) for ARCH_AT91 to use on SCL, to best
> support both clock stretching and multi-master configurations.

Isn't it better to switch the direction to input since the driver needs to
watch the pin state in order to support clock stretching and multi-master?

>> +	gpio_direction_input(pdata->sda_pin);
>> +	gpio_direction_input(pdata->scl_pin);
>> +	gpio_set_value(pdata->sda_pin, 0);
>> +	gpio_set_value(pdata->scl_pin, 0);
>
> Surely you mean "output" in both cases.  So you can set the
> value.  Setting the value on an input pin is undefined.  ;)

No I really do mean input, as I want to put the bus into an idle state
initially, which means no output drivers and passive pullup on both lines.

The gpio_set_value() calls should go away and the output value should be
explicitly set to 0 when turning on the output drivers. In its present
form, the driver happens to work on my hardware, which is all I really
cared about when writing it ;-)

>> +	printk(KERN_INFO "i2c-gpio: using pins 0x%x (sda) 0x%x (scl)\n",
>> +	       pdata->sda_pin, pdata->scl_pin);
>
> Please, no hex there.  I think dev_info() would be better; and it
> might be nice to report whether clock stretching is supported.

Ok, but how do I inform i2c-algo-bit about whether or not clock stretching
is supported?

>> --- a/include/linux/i2c-id.h
>> +++ b/include/linux/i2c-id.h
>> @@ -194,6 +194,7 @@
>>  #define I2C_HW_B_EM28XX		0x01001f /* em28xx video capture cards */
>>  #define I2C_HW_B_CX2341X	0x010020 /* Conexant CX2341X MPEG encoder
>> cards */
>>  #define I2C_HW_B_INTELFB	0x010021 /* intel framebuffer driver */
>> +#define I2C_HW_B_GPIO		0x010022 /* Generic GPIO-based driver */
>
> It'd be nice to completely abolish those IDs, starting by not
> adding new ones.  Especially, not adding unused ones!

Sure.

Haavard

