Return-Path: <linux-kernel-owner+w=401wt.eu-S1762079AbZJOVVL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762079AbZJOVVL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 17:21:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752250AbZJOVVK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 17:21:10 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:33259 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751442AbZJOVVJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 17:21:09 -0400
Date: Thu, 15 Oct 2009 23:20:24 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Stanislav Brabec <utx@penguin.cz>
Cc: Eric Miao <eric.y.miao@gmail.com>, Andrew Morton <akpm@osdl.org>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>, rpurdie@rpsys.net,
       lenz@cs.wisc.edu, kernel list <linux-kernel@vger.kernel.org>,
       Dirk@opfer-online.de, arminlitzel@web.de, Cyril Hrubis <metan@ucw.cz>,
       thommycheck@gmail.com,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       dbaryshkov@gmail.com, omegamoon@gmail.com
Subject: Re: spitz: add gpio button support (fixes regression)
Message-ID: <20091015212024.GC15898@elf.ucw.cz>
References: <20091006074635.GA2775@ucw.cz>
 <1254829732.3546.35.camel@utx.utx.cz>
 <20091007085806.GB28807@elf.ucw.cz>
 <1254914991.4213.80.camel@hammer.suse.cz>
 <20091007120643.GA17069@rakim.wolfsonmicro.main>
 <f17812d70910070727x47b2a22h8e9f9304740d5abf@mail.gmail.com>
 <20091006200933.GA1606@ucw.cz>
 <1255641385.3985.55.camel@utx.utx.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1255641385.3985.55.camel@utx.utx.cz>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > So what's the conclusion of the patch? Any ACK/NAK or patch needs updating?
> 
> Well, AK_INT as it is implemented does not give any useful information,
> but it does not break anything. When inserting or removing remote, or
> (any) remote key is pressed, it generates one or more switch events.
> This code will have to be removed after implementing full remote support
> (turning pull-up resistor may cause false events, ???insert/remove needs
> more aggressive debounce), so I would prefer not adding AK_INT support.
> (See patch below.)

Ok.

> > Please take this updated version.
> 
> > Spitz switched to generic matrix-gpio keyboard driver in 2.6.32-rc0,
> > but that means that support for power button and lid switches was
> > lost. This restores it, using button-gpio code.
> 
> I just tested it. It returns keys function, but suspend button does not
> cause suspend. Just an input event occurs, see below for output from
> evtest. Resume after "echo mem >/sys/power/state" is impossible. I think
> it is not intended behavior.
> ???

Well, resume is hit by second regression.

Suspend key.... I restored it to the level of functionality in
2.6.31 :-).

> diff --git a/arch/arm/mach-pxa/spitz.c b/arch/arm/mach-pxa/spitz.c
> index ee8d603..a8ef058 100644
> --- a/arch/arm/mach-pxa/spitz.c
> +++ b/arch/arm/mach-pxa/spitz.c
> @@ -15,6 +15,7 @@
>  #include <linux/kernel.h>
>  #include <linux/platform_device.h>
>  #include <linux/delay.h>
> +#include <linux/gpio_keys.h>
>  #include <linux/gpio.h>
>  #include <linux/leds.h>
>  #include <linux/mtd/physmap.h>
> @@ -375,6 +376,43 @@ static struct platform_device spitzkbd_device = {
>  };
>  
>  
> +static struct gpio_keys_button spitz_gpio_keys[] = {
> +	{
> +		.type	= EV_KEY,
> +		.code	= KEY_SUSPEND,
> +		.gpio	= SPITZ_GPIO_ON_KEY,
> +		.desc	= "Power button",
> +		.wakeup	= 1,
> +	},
> +	/* Two buttons detecting the LID state */
> +	{
> +		.type	= EV_SW,
> +		.code	= 0,
> +		.gpio	= SPITZ_GPIO_SWA,
> +		.desc	= "Lid SWA",
> +	},
> +	{
> +		.type	= EV_SW,
> +		.code	= 1,
> +		.gpio	= SPITZ_GPIO_SWB,
> +		.desc	= "Lid SWB",
> +	},
> +};
> +
> +static struct gpio_keys_platform_data spitz_gpio_keys_platform_data = {
> +	.buttons	= spitz_gpio_keys,
> +	.nbuttons	= ARRAY_SIZE(spitz_gpio_keys),
> +};
> +
> +static struct platform_device spitz_gpio_keys_device = {
> +	.name	= "gpio-keys",
> +	.id	= -1,
> +	.dev	= {
> +		.platform_data	= &spitz_gpio_keys_platform_data,
> +	},
> +};
> +
> +
>  /*
>   * Spitz LEDs
>   */
> @@ -689,6 +727,7 @@ static struct platform_device sharpsl_rom_device = {
>  static struct platform_device *devices[] __initdata = {
>  	&spitzscoop_device,
>  	&spitzkbd_device,
> +	&spitz_gpio_keys_device,
>  	&spitzled_device,
>  	&sharpsl_nand_device,
>  	&sharpsl_rom_device,
> 

Ack. Someone please apply it.
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
