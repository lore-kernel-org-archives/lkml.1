Return-Path: <linux-kernel-owner+w=401wt.eu-S1756596AbYDDG3u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756596AbYDDG3u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 02:29:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751974AbYDDG3l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 02:29:41 -0400
Received: from oss.sgi.com ([192.48.170.157]:47937 "EHLO oss.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751752AbYDDG3k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 02:29:40 -0400
Date: Fri, 4 Apr 2008 07:29:25 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Alchemy: move UART platform code to its proper place
Message-ID: <20080404062924.GA12086@linux-mips.org>
References: <200804040002.53757.sshtylyov@ru.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200804040002.53757.sshtylyov@ru.mvista.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 04, 2008 at 12:02:53AM +0400, Sergei Shtylyov wrote:

> Move the code registering the Alchemy UART platform devices from drivers/serial/
> to its proper place, into the Alchemy platform code.  Fix the related Kconfig
> entry, while at it...
> 
> Signed-off-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>
> 
> ---
> Ralf, could you take this patch thru your queue -- it ahould apply atop of my
> former #include /extern cleanup?
> 
> I don't know how the platform code ended up accepted into the serial drivers in
> the first place -- it's high time to amend this.

Andrew, I'd like to queue this patch, ok?

  Ralf

>  drivers/serial/8250_au1x00.c       |  100 -------------------------------------
>  arch/mips/au1000/common/platform.c |   55 ++++++++++++++++++++
>  drivers/serial/Kconfig             |    8 +-
>  drivers/serial/Makefile            |    1 
>  4 files changed, 59 insertions(+), 105 deletions(-)
> 
> Index: linux-2.6/arch/mips/au1000/common/platform.c
> ===================================================================
> --- linux-2.6.orig/arch/mips/au1000/common/platform.c
> +++ linux-2.6/arch/mips/au1000/common/platform.c
> @@ -3,16 +3,63 @@
>   *
>   * Copyright 2004, Matt Porter <mporter@kernel.crashing.org>
>   *
> + * (C) Copyright Embedded Alley Solutions, Inc 2005
> + * Author: Pantelis Antoniou <pantelis@embeddedalley.com>
> + *
>   * This file is licensed under the terms of the GNU General Public
>   * License version 2.  This program is licensed "as is" without any
>   * warranty of any kind, whether express or implied.
>   */
>  
>  #include <linux/platform_device.h>
> +#include <linux/serial_8250.h>
>  #include <linux/init.h>
>  
>  #include <asm/mach-au1x00/au1xxx.h>
>  
> +#define PORT(_base, _irq)				\
> +	{						\
> +		.iobase		= _base,		\
> +		.membase	= (void __iomem *)_base,\
> +		.mapbase	= CPHYSADDR(_base),	\
> +		.irq		= _irq,			\
> +		.regshift	= 2,			\
> +		.iotype		= UPIO_AU,		\
> +		.flags		= UPF_SKIP_TEST 	\
> +	}
> +
> +static struct plat_serial8250_port au1x00_uart_data[] = {
> +#if defined(CONFIG_SOC_AU1000)
> +	PORT(UART0_ADDR, AU1000_UART0_INT),
> +	PORT(UART1_ADDR, AU1000_UART1_INT),
> +	PORT(UART2_ADDR, AU1000_UART2_INT),
> +	PORT(UART3_ADDR, AU1000_UART3_INT),
> +#elif defined(CONFIG_SOC_AU1500)
> +	PORT(UART0_ADDR, AU1500_UART0_INT),
> +	PORT(UART3_ADDR, AU1500_UART3_INT),
> +#elif defined(CONFIG_SOC_AU1100)
> +	PORT(UART0_ADDR, AU1100_UART0_INT),
> +	PORT(UART1_ADDR, AU1100_UART1_INT),
> +	PORT(UART3_ADDR, AU1100_UART3_INT),
> +#elif defined(CONFIG_SOC_AU1550)
> +	PORT(UART0_ADDR, AU1550_UART0_INT),
> +	PORT(UART1_ADDR, AU1550_UART1_INT),
> +	PORT(UART3_ADDR, AU1550_UART3_INT),
> +#elif defined(CONFIG_SOC_AU1200)
> +	PORT(UART0_ADDR, AU1200_UART0_INT),
> +	PORT(UART1_ADDR, AU1200_UART1_INT),
> +#endif
> +	{ },
> +};
> +
> +static struct platform_device au1xx0_uart_device = {
> +	.name			= "serial8250",
> +	.id			= PLAT8250_DEV_AU1X00,
> +	.dev			= {
> +		.platform_data	= au1x00_uart_data,
> +	},
> +};
> +
>  /* OHCI (USB full speed host controller) */
>  static struct resource au1xxx_usb_ohci_resources[] = {
>  	[0] = {
> @@ -287,6 +334,7 @@ static struct platform_device pbdb_smbus
>  #endif
>  
>  static struct platform_device *au1xxx_platform_devices[] __initdata = {
> +	&au1xx0_uart_device,
>  	&au1xxx_usb_ohci_device,
>  	&au1x00_pcmcia_device,
>  #ifdef CONFIG_FB_AU1100
> @@ -310,6 +358,13 @@ static struct platform_device *au1xxx_pl
>  
>  int __init au1xxx_platform_init(void)
>  {
> +	unsigned int uartclk = get_au1x00_uart_baud_base() * 16;
> +	int i;
> +
> +	/* Fill up uartclk. */
> +	for (i = 0; au1x00_uart_data[i].flags ; i++)
> +		au1x00_uart_data[i].uartclk = uartclk;
> +
>  	return platform_add_devices(au1xxx_platform_devices, ARRAY_SIZE(au1xxx_platform_devices));
>  }
>  
> Index: linux-2.6/drivers/serial/8250_au1x00.c
> ===================================================================
> --- linux-2.6.orig/drivers/serial/8250_au1x00.c
> +++ /dev/null
> @@ -1,100 +0,0 @@
> -/*
> - * Serial Device Initialisation for Au1x00
> - *
> - * (C) Copyright Embedded Alley Solutions, Inc 2005
> - * Author: Pantelis Antoniou <pantelis@embeddedalley.com>
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published by
> - * the Free Software Foundation; either version 2 of the License, or
> - * (at your option) any later version.
> - */
> -
> -#include <linux/errno.h>
> -#include <linux/init.h>
> -#include <linux/interrupt.h>
> -#include <linux/ioport.h>
> -#include <linux/module.h>
> -#include <linux/serial_core.h>
> -#include <linux/signal.h>
> -#include <linux/slab.h>
> -#include <linux/types.h>
> -
> -#include <linux/serial_8250.h>
> -
> -#include <asm/mach-au1x00/au1000.h>
> -
> -#include "8250.h"
> -
> -#define PORT(_base, _irq)				\
> -	{						\
> -		.iobase		= _base,		\
> -		.membase	= (void __iomem *)_base,\
> -		.mapbase	= CPHYSADDR(_base),	\
> -		.irq		= _irq,			\
> -		.uartclk	= 0,	/* filled */	\
> -		.regshift	= 2,			\
> -		.iotype		= UPIO_AU,		\
> -		.flags		= UPF_SKIP_TEST 	\
> -	}
> -
> -static struct plat_serial8250_port au1x00_data[] = {
> -#if defined(CONFIG_SOC_AU1000)
> -	PORT(UART0_ADDR, AU1000_UART0_INT),
> -	PORT(UART1_ADDR, AU1000_UART1_INT),
> -	PORT(UART2_ADDR, AU1000_UART2_INT),
> -	PORT(UART3_ADDR, AU1000_UART3_INT),
> -#elif defined(CONFIG_SOC_AU1500)
> -	PORT(UART0_ADDR, AU1500_UART0_INT),
> -	PORT(UART3_ADDR, AU1500_UART3_INT),
> -#elif defined(CONFIG_SOC_AU1100)
> -	PORT(UART0_ADDR, AU1100_UART0_INT),
> -	PORT(UART1_ADDR, AU1100_UART1_INT),
> -	/* The internal UART2 does not exist on the AU1100 processor. */
> -	PORT(UART3_ADDR, AU1100_UART3_INT),
> -#elif defined(CONFIG_SOC_AU1550)
> -	PORT(UART0_ADDR, AU1550_UART0_INT),
> -	PORT(UART1_ADDR, AU1550_UART1_INT),
> -	PORT(UART3_ADDR, AU1550_UART3_INT),
> -#elif defined(CONFIG_SOC_AU1200)
> -	PORT(UART0_ADDR, AU1200_UART0_INT),
> -	PORT(UART1_ADDR, AU1200_UART1_INT),
> -#endif
> -	{ },
> -};
> -
> -static struct platform_device au1x00_device = {
> -	.name			= "serial8250",
> -	.id			= PLAT8250_DEV_AU1X00,
> -	.dev			= {
> -		.platform_data	= au1x00_data,
> -	},
> -};
> -
> -static int __init au1x00_init(void)
> -{
> -	int i;
> -	unsigned int uartclk;
> -
> -	/* get uart clock */
> -	uartclk = get_au1x00_uart_baud_base() * 16;
> -
> -	/* fill up uartclk */
> -	for (i = 0; au1x00_data[i].flags ; i++)
> -		au1x00_data[i].uartclk = uartclk;
> -
> -	return platform_device_register(&au1x00_device);
> -}
> -
> -/* XXX: Yes, I know this doesn't yet work. */
> -static void __exit au1x00_exit(void)
> -{
> -	platform_device_unregister(&au1x00_device);
> -}
> -
> -module_init(au1x00_init);
> -module_exit(au1x00_exit);
> -
> -MODULE_AUTHOR("Pantelis Antoniou <pantelis@embeddedalley.com>");
> -MODULE_DESCRIPTION("8250 serial probe module for Au1x000 cards");
> -MODULE_LICENSE("GPL");
> Index: linux-2.6/drivers/serial/Kconfig
> ===================================================================
> --- linux-2.6.orig/drivers/serial/Kconfig
> +++ linux-2.6/drivers/serial/Kconfig
> @@ -262,12 +262,12 @@ config SERIAL_8250_ACORN
>  	  cards.  If unsure, say N.
>  
>  config SERIAL_8250_AU1X00
> -	bool "AU1X00 serial port support"
> +	bool "Au1x00 serial port support"
>  	depends on SERIAL_8250 != n && SOC_AU1X00
>  	help
> -	  If you have an Au1x00 board and want to use the serial port, say Y
> -	  to this option.  The driver can handle 1 or 2 serial ports.
> -	  If unsure, say N.
> +	  If you have an Au1x00 SOC based board and want to use the serial port,
> +	  say Y to this option. The driver can handle up to 4 serial ports,
> +	  depending on the SOC. If unsure, say N.
>  
>  config SERIAL_8250_RM9K
>  	bool "Support for MIPS RM9xxx integrated serial port"
> Index: linux-2.6/drivers/serial/Makefile
> ===================================================================
> --- linux-2.6.orig/drivers/serial/Makefile
> +++ linux-2.6/drivers/serial/Makefile
> @@ -20,7 +20,6 @@ obj-$(CONFIG_SERIAL_8250_BOCA) += 8250_b
>  obj-$(CONFIG_SERIAL_8250_EXAR_ST16C554) += 8250_exar_st16c554.o
>  obj-$(CONFIG_SERIAL_8250_HUB6) += 8250_hub6.o
>  obj-$(CONFIG_SERIAL_8250_MCA) += 8250_mca.o
> -obj-$(CONFIG_SERIAL_8250_AU1X00) += 8250_au1x00.o
>  obj-$(CONFIG_SERIAL_AMBA_PL010) += amba-pl010.o
>  obj-$(CONFIG_SERIAL_AMBA_PL011) += amba-pl011.o
>  obj-$(CONFIG_SERIAL_CLPS711X) += clps711x.o
