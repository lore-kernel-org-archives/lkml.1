Return-Path: <linux-kernel-owner+w=401wt.eu-S1753224AbYL2EMT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753224AbYL2EMT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2008 23:12:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751308AbYL2EMJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Dec 2008 23:12:09 -0500
Received: from ey-out-2122.google.com ([74.125.78.26]:24835 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750737AbYL2EMG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2008 23:12:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=jRUIFt0XvWo6Hc+2sPv2h2iDsP6aYmn9EPYx+1fwBDDZaqLcZtiNW5vWXGioYsBjYl
         5Q7GCqd3sSz6ZadTPkjlPoSw/bDO7oS0/7vujh/XHWA4WWmavSmjsPI8ag2320SpHf+q
         2X/X4ts9VjtfcmZI8YRf7NXfDy45I2N4UJaio=
Message-ID: <45a44e480812282012m6ebcc648h9eaaa6a6973fd27c@mail.gmail.com>
Date: Sun, 28 Dec 2008 23:12:04 -0500
From: "Jaya Kumar" <jayakumar.lkml@gmail.com>
To: "Eric Miao" <eric.y.miao@gmail.com>
Subject: Re: [RFC 2.6.27 1/1] gpiolib: add batch set/get
Cc: "David Brownell" <dbrownell@users.sourceforge.net>,
       "Eric Miao" <eric.miao@marvell.com>,
       "Paulius Zaleckas" <paulius.zaleckas@teltonika.lt>,
       "Geert Uytterhoeven" <geert@linux-m68k.org>,
       "David Brownell" <david-b@pacbell.net>,
       "Sam Ravnborg" <sam@ravnborg.org>,
       "Haavard Skinnemoen" <hskinnemoen@atmel.com>,
       "Philipp Zabel" <philipp.zabel@gmail.com>,
       "Russell King" <rmk@arm.linux.org.uk>,
       "Ben Gardner" <bgardner@wabtec.com>, "Greg KH" <greg@kroah.com>,
       linux-arm-kernel@lists.arm.linux.org.uk,
       linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <f17812d70812281938h1b8ad9ecq49a460ac7786ae76@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1230395048446-git-send-email-jayakumar.lkml@gmail.com>
	 <f17812d70812281938h1b8ad9ecq49a460ac7786ae76@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 28, 2008 at 10:38 PM, Eric Miao <eric.y.miao@gmail.com> wrote:
> On Sun, Dec 28, 2008 at 12:24 AM, Jaya Kumar <jayakumar.lkml@gmail.com> wrote:
>> +#ifdef CONFIG_GPIOLIB_BATCH
>> +       gpio_set_batch(DB0_GPIO_PIN, data, 0xFFFF, 16);
>> +#else
>>        for (i = 0; i <= (DB15_GPIO_PIN - DB0_GPIO_PIN) ; i++)
>>                gpio_set_value(DB0_GPIO_PIN + i, (data >> i) & 0x01);
>> +#endif
>
> Well, if AM300 selects GPIOLIB_BATCH, I don't think we need the
> gpio_set_value() stuffs, and get rid of this #ifdef completely.

Good point. Will do.

>> +       /* shift the bits into our register specific position */
>> +       values <<= offset;
>> +       bitmask <<= offset;
>> +
>> +       values &= bitmask;
>
> or a single 'values = (values & bitmask) << offset' ?

Yup, good point. Will do.

>
>> +       if (values)
>> +               __raw_writel(values, pxa->regbase + GPSR_OFFSET);
>> +
>> +       values = ~values;
>> +       values &= bitmask;
>
> ditto

Will do.

>
>> +       if (values)
>> +               __raw_writel(values, pxa->regbase + GPCR_OFFSET);
>> +}
>> +
>> +/*
>> + * Get output GPIO level in batches
>> + */
>> +static u32 pxa_gpio_get_batch(struct gpio_chip *chip, unsigned offset,
>> +                               u32 bitmask)
>> +{
>> +       u32 values;
>> +       struct pxa_gpio_chip *pxa;
>> +
>> +       /* we're guaranteed by the caller that offset + bitmask remains
>> +        * in this chip.
>> +        */
>> +       pxa = container_of(chip, struct pxa_gpio_chip, chip);
>> +
>> +       values = __raw_readl(pxa->regbase + GPLR_OFFSET);
>> +
>> +       /* shift the result back into original position */
>> +       values >>= offset;
>> +       /* no need to shift bitmask since we've already shifted values */
>> +       values &= bitmask;
>> +
>> +       return values;
>
> or a single 'return (values >> offset) & bitmask;' should be enough.

Agreed.

>
>> +}
>> +#endif
>> +
>> +#ifdef CONFIG_GPIOLIB_BATCH
>> +#define GPIO_CHIP(_n)                                                  \
>> +       [_n] = {                                                        \
>> +               .regbase = GPIO##_n##_BASE,                             \
>> +               .chip = {                                               \
>> +                       .label            = "gpio-" #_n,                \
>> +                       .direction_input  = pxa_gpio_direction_input,   \
>> +                       .direction_output = pxa_gpio_direction_output,  \
>> +                       .get              = pxa_gpio_get,               \
>> +                       .set              = pxa_gpio_set,               \
>> +                       .base             = (_n) * 32,                  \
>> +                       .ngpio            = 32,                         \
>> +                       .set_batch        = pxa_gpio_set_batch,         \
>> +                       .get_batch        = pxa_gpio_get_batch,         \
>
> This is a bit ugly, define pxa_gpio_set_batch to NULL #ifndef GPIOLIB_BATCH
> in the above code, and force .{set,get}_batch assignment anyway, this will
> look a bit better, the same way as PM. However, this requires a modification
> to gpio_chip to always allow these two pointers, which might be a concern.

I think I tried that but then encountered the problem that I can't put
ifdefs within the define GPIO_CHIP macro. Will try to find a different
way. How about if I do:
#ifdef GPIOLIB_BATCH
#define SET_BATCH_MACRO .set_batch = pxa_gpio_set_batch \
#else
#define SET_BATCH_MACRO
#endif

then leave SET_BATCH_MACRO in the GPIO_CHIP macro. I think that would work.

>> +               if (!chip->set_batch) {
>> +                       while (((gpio + i) < (chip->base + chip->ngpio))
>> +                               && bitwidth) {
>> +                               mask = 1 << i;
>> +                               value = values & mask;
>> +                               if (bitmask & mask)
>> +                                       chip->set(chip, gpio + i - chip->base,
>> +                                                       value);
>> +                               i++;
>> +                               bitwidth--;
>
> I recommend this being put into something like 'default_gpio_set_batch', and
> assign this to 'chip->set_batch' when the gpio chip is being registered and
> found 'chip->set_batch == NULL', so to keep this block consistent.
>
> Same comment to the 'get_batch' implementation below.

Ok, that should also make the code nicer, will do.

Thanks,
jaya
