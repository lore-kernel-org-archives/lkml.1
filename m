Return-Path: <linux-kernel-owner+w=401wt.eu-S966497AbZLHVwi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966497AbZLHVwi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 16:52:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756303AbZLHVwf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 16:52:35 -0500
Received: from mail.bluewatersys.com ([202.124.120.130]:36579 "EHLO
	hayes.bluewaternz.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756293AbZLHVwe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 16:52:34 -0500
Message-ID: <4B1ECAC2.5090009@bluewatersys.com>
Date: Wed, 09 Dec 2009 10:53:06 +1300
From: Ryan Mallon <ryan@bluewatersys.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: Arve Hj?nnev?g <arve@android.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       Brian Swetland <swetland@google.com>,
       Daniel Walker <dwalker@codeaurora.org>,
       Iliyan Malchev <malchev@google.com>
Subject: Re: GPIO support for HTC Dream
References: <20091208102842.GH12264@elf.ucw.cz> <4B1EB57D.6070408@bluewatersys.com> <20091208213727.GA4164@elf.ucw.cz>
In-Reply-To: <20091208213727.GA4164@elf.ucw.cz>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> Hi!
> 
>>> +#undef MODULE_PARAM_PREFIX
>>> +#define MODULE_PARAM_PREFIX "board_dream."
>> This looks a bit dodgy. Is this
>> (http://lkml.indiana.edu/hypermail/linux/kernel/0903.0/02768.html) the
>> preferred way?
> 
> I don't think that would help that much here....

Okay, but what is the reason for overriding MODULE_PARAM_PREFIX? Maybe a
comment explaining?

>>> +static void update_pwrsink(unsigned gpio, unsigned on)
>>> +{
>>> +	switch(gpio) {
>>> +	case DREAM_GPIO_UI_LED_EN:
>>> +		break;
>>> +	case DREAM_GPIO_QTKEY_LED_EN:
>>> +		break;
>>> +	}
>>> +}
>> What is this function for?
> 
> Power accounting... should be removed. Fixed.
> 
>>> +static void dream_gpio_irq_ack(unsigned int irq)
>>> +{
>>> +	int bank = DREAM_INT_TO_BANK(irq);
>>> +	uint8_t mask = DREAM_INT_TO_MASK(irq);
>>> +	int reg = DREAM_BANK_TO_STAT_REG(bank);
>>> +	/*printk(KERN_INFO "dream_gpio_irq_ack irq %d\n", irq);*/
>> pr_debug, or just remove it?
> 
> Remove.
> 
>>> +	desc->chip->ack(irq);
>>> +}
>> Some blank lines here and there would make this more readable. All your
>> code is wedged together :-).
> 
> Well, added some blank lines; not sure it is improvement.

This function was just an example, the patch lacked blank lines in
general. Squashed up code is hard to read.

>>> +#define DREAM_INT_TO_BANK(n) ((n - DREAM_INT_START) / DREAM_INT_BANK0_COUNT)
>>> +#define DREAM_INT_TO_MASK(n) (1U << ((n - DREAM_INT_START) & 7))
>>> +#define DREAM_BANK_TO_MASK_REG(bank) \
>>> +	(bank ? DREAM_GPIO_INT_MASK1_REG : DREAM_GPIO_INT_MASK0_REG)
>>> +#define DREAM_BANK_TO_STAT_REG(bank) \
>>> +	(bank ? DREAM_GPIO_INT_STAT1_REG : DREAM_GPIO_INT_STAT0_REG)
>> Are these needed outside of the gpiolib code? If not, they should be
>> moved there. I also think they should have lower case names since they
>> act like a function, and make the code where they are used nicer to
>> read.
> 
> I guess these logically belong here.
> 
> No, macros are macros, that means upcase.

container_of, min, swap, etc are macros too. It is easier to read this
if they are lower case because they are typically used for initialising
variables, ie:

	int bank = dream_int_to_bank(irq);

Is easier (IMHO) to read than:
	
	int bank = DREAM_INT_TO_BANK(irq);


>> Thats big, hard to read, has about 3 blank lines total and no comments.
> 
> I tried to improve it, but it needs more. Here are my cleanups.
> 									Pavel

Looks better overall.

> diff --git a/arch/arm/mach-msm/board-dream.c b/arch/arm/mach-msm/board-dream.c
> index 4758957..3e8e54a 100644
> --- a/arch/arm/mach-msm/board-dream.c
> +++ b/arch/arm/mach-msm/board-dream.c
> @@ -59,6 +59,23 @@ static void __init dream_fixup(struct machine_desc *desc, struct tag *tags,
>  
>  static void __init dream_init(void)
>  {
> +	gpio_set_value(DREAM_GPIO_UI_LED_EN, 1);
> +        mdelay(300);
> +	gpio_set_value(DREAM_GPIO_UI_LED_EN, 0);
> +        mdelay(300);
> +        gpio_set_value(DREAM_GPIO_UI_LED_EN, 1);
> +	mdelay(300);
> +        gpio_set_value(DREAM_GPIO_UI_LED_EN, 0);
> +	mdelay(300);
> +        gpio_set_value(DREAM_GPIO_UI_LED_EN, 1);
> +        mdelay(300);
> +        gpio_set_value(DREAM_GPIO_UI_LED_EN, 0);
> +        mdelay(300);
> +	gpio_set_value(DREAM_GPIO_UI_LED_EN, 1);
> +        mdelay(300);
> +	gpio_set_value(DREAM_GPIO_UI_LED_EN, 0);
> +        mdelay(300);
> +

Indentation looks screwy here. Also, is this meant to blink the leds?
There is a 2.4 second hard delay here, which is horrible.

~Ryan

-- 
Bluewater Systems Ltd - ARM Technology Solution Centre

Ryan Mallon         		5 Amuri Park, 404 Barbadoes St
ryan@bluewatersys.com         	PO Box 13 889, Christchurch 8013
http://www.bluewatersys.com	New Zealand
Phone: +64 3 3779127		Freecall: Australia 1800 148 751
Fax:   +64 3 3779135			  USA 1800 261 2934
