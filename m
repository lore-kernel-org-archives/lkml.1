Return-Path: <linux-kernel-owner+w=401wt.eu-S1754027AbZBIF30@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754027AbZBIF30 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 00:29:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750829AbZBIF3R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 00:29:17 -0500
Received: from rv-out-0506.google.com ([209.85.198.228]:52128 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750741AbZBIF3Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 00:29:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=KFEoU9utuGk19hRg+vKuScbLif+ChLANb1EMCkzPgpDXp5bCHca/DmMYdYGN6VUAam
         JL0TkjcPB7KT7Tjm+X6mEfgEgLLNlhyOldvp2aIfqWtqIwMH6Ua0vCG2Pj7DqSsrO7my
         eRYaaG3RP9CARSQK1NkkcBWbrFvSpI/NxW9ic=
MIME-Version: 1.0
In-Reply-To: <200902082011.36500.david-b@pacbell.net>
References: <4e1455be0902062015i1ff94b28p93588e61b7860618@mail.gmail.com>
	 <200902081156.15950.david-b@pacbell.net>
	 <4e1455be0902081838y27b34dc4ia283768bbc16408c@mail.gmail.com>
	 <200902082011.36500.david-b@pacbell.net>
Date: Mon, 9 Feb 2009 14:29:15 +0900
Message-ID: <4e1455be0902082129i2c038477g886c8de03d3073dd@mail.gmail.com>
Subject: Re: [PATCH] OMAP3 GPIO: Fix getting the value of the GPIO output pin
From: Joonyoung Shim <dofmind@gmail.com>
To: David Brownell <david-b@pacbell.net>
Cc: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org,
       linux-omap@vger.kernel.org, Tony Lindgren <tony@atomide.com>,
       kyungmin.park@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry, I added CC.

2009/2/9 David Brownell <david-b@pacbell.net>:
> On Sunday 08 February 2009, Joonyoung Shim wrote:
>> I have knew if gpio pin is configured as an output, the value of the
>> corresponding bit
>> in the GPIO_DATAOUT register is driven on the corresponding gpio pin.
>> But the implemented API only reports the value of the corresponding bit in the
>> GPIO_DATAIN register. This can report a wrong value.
>>
>> For example, even though the gpio 141pin is configured as an output and assigns
>> the gpio's value to 1 through gpio_set_value(), the result of
>> "# cat /sys/kernel/debug/gpio" reports to me as follows.
>>
>> GPIOs 128-159, gpio:
>>  gpio-141 (motor enable        ) out lo
>>
>> but it should have reported "hi" instead of "lo".
>
> I happen to observe that mach-omap2/mux.c there are a bunch
> of pins that are wrongly multiplexed.  Like:
>
> MUX_CFG_34XX("AE6_34XX_GPIO141", 0x16e,
>                OMAP34XX_MUX_MODE4 | OMAP34XX_PIN_OUTPUT)

I think that it is right because i want to use gpio141 pin as output,

>
> Which should clearly be AE6_34XX_GPIO141_OUT since it does
> not enable the input driver.  Try making that ...PIN_OUTPUT
> read ...PIN_INPUT and see if things behave.

Of course, it will be better if the name is clear as AE6_34XX_GPIO141_OUT.
but, the core of this problem is not it, the chip->get() called in
gpiolib_dbg_show()
of drivers/gpio/gpiolib.c or dbg_gpio_show() of arch/arm/plat-omap/gpio.c
can return the wrong value when gpio pin is configured as an output.

the reason as i say at former email, is because __omap_get_gpio_datain()
called by gpio_get() of arch/arm/plat-omap/gpio.c reports only value of
OMAP24XX_GPIO_DATAIN register.

- Joonyoung

>
> - Dave
>
>
>
