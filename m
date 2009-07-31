Return-Path: <linux-kernel-owner+w=401wt.eu-S1751849AbZGaUce@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751849AbZGaUce (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jul 2009 16:32:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751538AbZGaUce
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Jul 2009 16:32:34 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:14427 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751152AbZGaUcd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jul 2009 16:32:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=hL7QKrR5/hLo98YUeNXQJ5Hj2FEkqHHAw2uCjw1zTlWVRNCyjrlrXCzzUJKO7wtTCA
         c2zuMqvlFKhrGXl3o+zl9dvTagbcrbAIT47f9ADXLGZJHvycyRXV9WYPdI4MAqGeDBh5
         mG1dVWSj0kR2zfJ4JKLLeAGXxFLbbDIgbVYbY=
MIME-Version: 1.0
In-Reply-To: <74d0deb30907311038w1b6cdd23iec3cfb2175fdedd0@mail.gmail.com>
References: <1249057189-11992-1-git-send-email-quadros.roger@gmail.com>
	 <20090731172002.GA32578@rakim.wolfsonmicro.main>
	 <74d0deb30907311038w1b6cdd23iec3cfb2175fdedd0@mail.gmail.com>
Date: Fri, 31 Jul 2009 23:32:32 +0300
Message-ID: <b90c0690907311332o958b7f4nd025aa7a8b273a88@mail.gmail.com>
Subject: Re: [PATCH v2] regulator: Add GPIO enable control to fixed voltage 
	regulator driver
From: Roger Quadros <quadros.roger@gmail.com>
To: pHilipp Zabel <philipp.zabel@gmail.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 31, 2009 at 8:38 PM, pHilipp Zabel<philipp.zabel@gmail.com> wrote:
> On Fri, Jul 31, 2009 at 7:20 PM, Mark
> Brown<broonie@opensource.wolfsonmicro.com> wrote:
>> On Fri, Jul 31, 2009 at 07:19:49PM +0300, Roger Quadros wrote:
>>
>>
>>> +             ret = gpio_get_value(config->gpio);
>>
>> Can this fail?  It returns an int...
>
> No, gpio_get_value(_cansleep) return either zero or non-zero.
> I think some I2C gpio chips just return zero when the read fails.
> Also that's the return value if a gpiochip doesn't define the .get method.
>
> Only problem: drivers/gpio/gpiolib.c contains this piece of wisdom:
>
> /* Drivers MUST set GPIO direction before making get/set calls.  In
>  * some cases this is done in early boot, before IRQs are enabled.
>  [...]
>  */
>

Not having gpio_get_direction() in gpiolib is a limitation I think.
Can we just do the following for now ? (i.e. disable regulator by default)
Will there be any glitch? If yes, then how?

                ret = gpio_request(config->gpio, config->supply_name);
                ...

-               ret = gpio_get_value(config->gpio);
-               ret = gpio_direction_output(config->gpio, ret);
+               ret = gpio_direction_output(config->gpio, !config->enable_high);
                if (ret) {
                        dev_err(&pdev->dev, "Could not configure
enable GPIO %d direction: %d\n",
                                                        config->gpio, ret);
                        goto err_gpio;
                }
