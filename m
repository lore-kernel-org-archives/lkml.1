Return-Path: <linux-kernel-owner+w=401wt.eu-S932216AbZJPTGX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932216AbZJPTGX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 15:06:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932096AbZJPTGW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 15:06:22 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:43748 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932092AbZJPTGW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 15:06:22 -0400
Date: Fri, 16 Oct 2009 20:05:21 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Stanislav Brabec <utx@penguin.cz>
Cc: Pavel Machek <pavel@ucw.cz>, Andrew Morton <akpm@osdl.org>,
       Eric Miao <eric.y.miao@gmail.com>, dbaryshkov@gmail.com,
       Cyril Hrubis <metan@ucw.cz>, arminlitzel@web.de,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       kernel list <linux-kernel@vger.kernel.org>, Dirk@opfer-online.de,
       lenz@cs.wisc.edu, rpurdie@rpsys.net, omegamoon@gmail.com,
       thommycheck@gmail.com,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] Re: spitz: add gpio button support (fixes regression)
Message-ID: <20091016190521.GB17849@n2100.arm.linux.org.uk>
References: <20091007120643.GA17069@rakim.wolfsonmicro.main> <f17812d70910070727x47b2a22h8e9f9304740d5abf@mail.gmail.com> <20091006200933.GA1606@ucw.cz> <1255641385.3985.55.camel@utx.utx.cz> <20091015212024.GC15898@elf.ucw.cz> <1255643252.3985.63.camel@utx.utx.cz> <20091015215215.GG15898@elf.ucw.cz> <1255685315.5470.3.camel@hammer.suse.cz> <20091016093950.GI15898@elf.ucw.cz> <1255719006.9583.31.camel@utx.utx.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1255719006.9583.31.camel@utx.utx.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm not sure we want to apply this patch - it has UTF <U+FEFF>
sequences embedded randomly in it.  I notice these because they
completely screw up the ability to read this email in mutt running
under a Linux VT (resulting in bits of the screen scrolling which
mutt didn't intend.)

I suggest you try re-sending it as an attachment.

On Fri, Oct 16, 2009 at 08:50:05PM +0200, Stanislav Brabec wrote:
> Pavel Machek wrote:
> >Ok, lets do it that way, then.
> 
> Updating desc for lid keys and resending patch with proper comments:
> ﻿
> Define Spitz buttons as GPIO keys in a way compatible with the old driver:
> 
> On/Off: As Suspend EV_PWR key
> 
> ﻿Raw values of﻿ lid sensors ﻿SWA and SWB: As EV_SW switches
> SWA: Display Down
> SWB: Lid Closed
> Recommended user space decoding:
> ﻿SWA==0 & SWB==0: lid opened (landscape mode)
> ﻿﻿SWA==1 & SWB==0: ﻿invalid (or mechanic race condition)
> SWA==0 & SWB==1: ﻿lid closed with display up (portrait mode or ﻿mechanic
>                  race condition while closing to ﻿display-less mode)
> SWA==1 & SWB==1: lid closed with display down (display-less mode)
> 
> ﻿AK_INT remote trigger is not mapped as input event. Without complete
> remote driver and remote pull-up control it has no useful
> interpretation.
> 
> Signed-off-by: Stanislav Brabec <utx@penguin.cz>
> Acked-by: Pavel Machek <pavel@ucw.cz>
> 
> diff --git a/arch/arm/mach-pxa/spitz.c b/arch/arm/mach-pxa/spitz.c
> index ee8d603..c690522 100644
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
> +		.type	= EV_PWR,
> +		.code	= KEY_SUSPEND,
> +		.gpio	= SPITZ_GPIO_ON_KEY,
> +		.desc	= "On/Off",
> +		.wakeup	= 1,
> +	},
> +	/* Two buttons detecting the lid state */
> +	{
> +		.type	= EV_SW,
> +		.code	= 0,
> +		.gpio	= SPITZ_GPIO_SWA,
> +		.desc	= "﻿Display Down",
> +	},
> +	{
> +		.type	= EV_SW,
> +		.code	= 1,
> +		.gpio	= SPITZ_GPIO_SWB,
> +		.desc	= "﻿Lid Closed",
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
> 
> ________________________________________________________________________
> Stanislav Brabec
> http://www.penguin.cz/~utx
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel

