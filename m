Return-Path: <linux-kernel-owner+w=401wt.eu-S1754276AbZGDI6r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754276AbZGDI6r (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jul 2009 04:58:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753280AbZGDI6e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Jul 2009 04:58:34 -0400
Received: from smtp.nokia.com ([192.100.122.230]:33816 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753181AbZGDI6c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jul 2009 04:58:32 -0400
Date: Sat, 4 Jul 2009 11:57:21 +0300
From: Felipe Balbi <felipe.balbi@nokia.com>
To: ext Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Cc: Jonathan McDowell <noodles@earth.li>, Tony Lindgren <tony@atomide.com>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
       "linux-arm-kernel@lists.arm.linux.org.uk" 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] [RFC] OMAP1: AMS_DELTA: add modem support
Message-ID: <20090704085721.GA29751@nokia.com>
Reply-To: felipe.balbi@nokia.com
References: <200907040206.42940.jkrzyszt@tis.icnet.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200907040206.42940.jkrzyszt@tis.icnet.pl>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 04 Jul 2009 08:57:33.0526 (UTC) FILETIME=[7842BF60:01C9FC85]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sat, Jul 04, 2009 at 02:06:42AM +0200, ext Janusz Krzysztofik wrote:
> This patch adds support for modem device found on Amstrad E3 (Delta) board.
> 
> Patch created against linux-2.6.31-rc1.
> 
> Based on earlier patch by Jonathan McDowell, available at 
> http://the.earth.li/pub/e3/2.6.19/ams-delta-modem.patch.
> Modified after Ladislav Michl's arch/arm/mach-omap1/board-voiceblue.c.
> 
> Signed-off-by: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
> ---
> Registering the modem platform device from a separate arch_initcall (and not from machine_init() callback) preserves serial console port 
> at ttyS0.
> 
> --- linux-2.6.31-rc1/arch/arm/mach-omap1/board-ams-delta.c.orig	2009-06-27 20:19:50.000000000 +0200
> +++ linux-2.6.31-rc1/arch/arm/mach-omap1/board-ams-delta.c	2009-07-04 00:50:46.000000000 +0200
> @@ -15,8 +15,11 @@
>  #include <linux/kernel.h>
>  #include <linux/init.h>
>  #include <linux/input.h>
> +#include <linux/irq.h>
>  #include <linux/platform_device.h>
> +#include <linux/serial_8250.h>
>  
> +#include <asm/serial.h>
>  #include <mach/hardware.h>
>  #include <asm/mach-types.h>
>  #include <asm/mach/arch.h>
> @@ -233,7 +236,39 @@ static void __init ams_delta_init(void)
>  
>  	omap_usb_init(&ams_delta_usb_config);
>  	platform_add_devices(ams_delta_devices, ARRAY_SIZE(ams_delta_devices));
> +
> +}
> +
> +static struct plat_serial8250_port ams_delta_modem_ports[] = {
> +	{
> +		.membase	= (void *) AMS_DELTA_MODEM_VIRT,
> +		.mapbase	= AMS_DELTA_MODEM_PHYS,
> +		.irq		= OMAP_GPIO_IRQ(2),

you should avoid OMAP_GPIO_IRQ() and use gpio_to_irq(), but for that
you're gonna need to change ams_delta_modem_init as well:

ams_delta_modem_ports[] = {
	{
		...
		.irq = -EINVAL; /* changed later */
		...
	},

};

> +static int __init ams_delta_modem_init(void)
> +{

	ams_delta_modem_ports[0].irq = gpio_to_irq(2);

> +	set_irq_type(OMAP_GPIO_IRQ(2), IRQ_TYPE_EDGE_RISING);

gpio_to_irq(2);

> +	ams_delta_latch2_write(
> +		AMS_DELTA_LATCH2_MODEM_NRESET | AMS_DELTA_LATCH2_MODEM_CODEC,
> +		AMS_DELTA_LATCH2_MODEM_NRESET | AMS_DELTA_LATCH2_MODEM_CODEC);
> +	return platform_device_register(&ams_delta_modem_device);
>  }
> +arch_initcall(ams_delta_modem_init);

-- 
balbi
