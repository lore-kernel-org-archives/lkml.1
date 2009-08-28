Return-Path: <linux-kernel-owner+w=401wt.eu-S1750969AbZH1PlY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750969AbZH1PlY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 11:41:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750770AbZH1PlY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 11:41:24 -0400
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:60298 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750759AbZH1PlW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 11:41:22 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 72.249.23.125
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+6ELsQWJfbHlaPMt49FnF/
Date: Fri, 28 Aug 2009 08:41:21 -0700
From: Tony Lindgren <tony@atomide.com>
To: vimal singh <vimal.newwork@gmail.com>
Cc: linux-omap@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       linux-serial@vger.kernel.org
Subject: Re: [RFC][PATCH]: Adding support for omap-serail driver
Message-ID: <20090828154121.GG25828@atomide.com>
References: <ce9ab5790908280649n77765dedm9161316a181b6a07@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ce9ab5790908280649n77765dedm9161316a181b6a07@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Some comments below.

* vimal singh <vimal.newwork@gmail.com> [090828 06:52]:
> From: Govindraj R <govindraj.raja@ti.com>
> 
> This patch adds support for OMAP3430-HIGH SPEED UART Controller.
> 
> It currently adds support for the following features.
> 
>         1. Supports Interrupt Mode for all three UARTs on SDP/ZOOM2.
>         2. Supports DMA Mode for all three UARTs on SDP/ZOOM2.
>         3. Supports Hardware flow control (CTS/RTS) on SDP/ZOOM2.
>         4. Supports 3.6Mbps baudrate on SDP/ZOOM2.
>         5. Debug Console support on all UARTs on SDP/ZOOM2.
>         6. Support for quad uart on ZOOM2 board.
> 
> The reason for adding this new driver alternative to 8250 is to avoid
> polluting 8250 driver with too many omap specific data as 8250 already
> supports more than 16 different uart controllers and may need too
> many omap-platform checks to implement feature like DMA support.

Just the DMA and PM features should be enough to justify having a
custom driver for sure.

> diff --git a/arch/arm/plat-omap/include/mach/omap-serial.h
> b/arch/arm/plat-omap/include/mach/omap-serial.h
> new file mode 100644
> index 0000000..d1b0bf2
> --- /dev/null
> +++ b/arch/arm/plat-omap/include/mach/omap-serial.h
> @@ -0,0 +1,84 @@
> +/*
> + * arch/arm/plat-omap/include/mach/omap-serial.h
> + *
> + * Driver for OMAP3430 UART controller.
> + *
> + * Copyright (C) 2009 Texas Instruments.
> + *
> + * Authors:
> + *	Thara Gopinath	<thara@ti.com>
> + *	Govindraj R	<govindraj.raja@ti.com>
> + *
> + * This file is licensed under the terms of the GNU General Public License
> + * version 2. This program is licensed "as is" without any warranty of any
> + * kind, whether express or implied.
> + */
> +
> +#ifndef __OMAP_SERIAL_H__
> +#define __OMAP_SERIAL_H__
> +
> +#include <linux/serial_core.h>
> +#include <linux/platform_device.h>
> +
> +/* TI OMAP CONSOLE */
> +#define PORT_OMAP       86
> +
> +#define DRIVER_NAME	"omap-hsuart"
> +
> +/*
> + * We default to IRQ0 for the "no irq" hack.   Some
> + * machine types want  others as well - they're free
> + * to redefine this in their header file.
> + */
> +#define is_real_interrupt(irq)  ((irq) != 0)
> +
> +#if defined(CONFIG_SERIAL_OMAP_CONSOLE) && defined(CONFIG_MAGIC_SYSRQ)
> +#define SUPPORT_SYSRQ
> +#endif
> +
> +#ifdef CONFIG_ARCH_OMAP34XX
> +#define OMAP_MDR1_DISABLE 	0x07
> +#define OMAP_MDR1_MODE13X 	0x03
> +#define OMAP_MDR1_MODE16X 	0x00
> +#define OMAP_MODE13X_SPEED	230400
> +#endif

Omap34xx specific things should be set dynamically during init rather
than using ifdefs. Maybe do the low level init in mach-omap2/serial.c?
That way the driver stays clean of any processor specific hacks.


> +
> +#define CONSOLE_NAME	"console="
> +
> +#define UART_CLK	(48000000)
> +#define QUART_CLK	(1843200)
> +
> +/* UART NUMBERS */
> +#define UART1		(0x0)
> +#define UART2		(0x1)
> +#define UART3		(0x2)
> +#define QUART		(0x3)
> +
> +#ifdef CONFIG_MACH_OMAP_ZOOM2
> +#define MAX_UARTS	QUART
> +#else
> +#define MAX_UARTS	UART3
> +#endif

This should be passed via platform_data.


> +
> +#define UART_BASE(uart_no)		(uart_no == UART1) ? OMAP_UART1_BASE :\
> +					(uart_no == UART2) ? OMAP_UART2_BASE :\
> +					 OMAP_UART3_BASE
> +
> +#define UART_MODULE_BASE(uart_no)	(UART1 == uart_no ? \
> +						IO_ADDRESS(OMAP_UART1_BASE) :\
> +					(UART2 == uart_no ? \
> +						IO_ADDRESS(OMAP_UART2_BASE) :\
> +						IO_ADDRESS(OMAP_UART3_BASE)))

These too you can easily set in mach-omap2/serial.c so similar.


> +extern unsigned int fcr[MAX_UARTS];
> +extern char *saved_command_line;
> +
> +struct plat_serialomap_port {
> +	void __iomem    *membase;       /* ioremap cookie or NULL */
> +	 resource_size_t mapbase;       /* resource base */

Extra space after tab. Please run through checkpatch.pl --strict.


> +	unsigned int    irq;            /* interrupt number */
> +	unsigned char   regshift;       /* register shift */
> +	upf_t           flags;          /* UPF_* flags */
> +	void            *private_data;
> +};
> +
> +#endif /* __OMAP_SERIAL_H__ */
> diff --git a/drivers/serial/Kconfig b/drivers/serial/Kconfig
> index 037c1e0..906fb61 100644
> --- a/drivers/serial/Kconfig
> +++ b/drivers/serial/Kconfig
> @@ -1359,6 +1359,98 @@ config SERIAL_OF_PLATFORM
>  	  Currently, only 8250 compatible ports are supported, but
>  	  others can easily be added.
> 
> +config SERIAL_OMAP
> +	bool "OMAP serial port support"
> +	depends on ARM && ARCH_OMAP
> +	select SERIAL_CORE
> +	help
> +	If you have a machine based on an Texas Instruments OMAP CPU you
> +	can enable its onboard serial ports by enabling this option.
> +
> +config SERIAL_OMAP_CONSOLE
> +	bool "Console on OMAP serial port"
> +	depends on SERIAL_OMAP
> +	select SERIAL_CORE_CONSOLE
> +	help
> +	If you have enabled the serial port on the Texas Instruments OMAP
> +	CPU you can make it the console by answering Y to this option.
> +
> +	Even if you say Y here, the currently visible virtual console
> +	(/dev/tty0) will still be used as the system console by default, but
> +	you can alter that using a kernel command line option such as
> +	"console=ttyS0". (Try "man bootparam" or see the documentation of
> +	your boot loader (lilo or loadlin) about how to pass options to the
> +	kernel at boot time.)
> +
> +config SERIAL_OMAP_DMA_UART1
> +	bool "UART1 DMA support"
> +	depends on SERIAL_OMAP
> +	help
> +	If you have enabled the serial port on the Texas Instruments OMAP
> +	CPU you can enable the DMA transfer on UART 1 by answering
> +	 to this option.
> +

No need for Kconfig option. Please pass from board-*.c files in platform_data.


> +config SERIAL_OMAP_UART1_RXDMA_TIMEOUT
> +	int "Timeout value for RX DMA in microseconds"
> +	depends on SERIAL_OMAP_DMA_UART1
> +	default "1"
> +	help
> +	  Set the timeout value in which you want the data pulled by RX dma to
> +	  be passed to the tty framework.

Ditto.


> +
> +config SERIAL_OMAP_UART1_RXDMA_BUFSIZE
> +	int "DMA buffer size for RX in bytes"
> +	depends on SERIAL_OMAP_DMA_UART1
> +	default "4096"
> +	help
> +	  Set the dma buffer size for UART Rx

Ditto for all other ports too.

<snip>

> diff --git a/drivers/serial/omap-serial.c b/drivers/serial/omap-serial.c
> new file mode 100644
> index 0000000..3b84740
> --- /dev/null
> +++ b/drivers/serial/omap-serial.c
> @@ -0,0 +1,1431 @@
> +/*
> + * drivers/serial/omap-serial.c
> + *
> + * Driver for OMAP3430 UART controller.
> + *
> + * Copyright (C) 2009 Texas Instruments.
> + *
> + * Authors:
> + *	Thara Gopinath	<thara@ti.com>
> + *	Govindraj R	<govindraj.raja@ti.com>
> + *
> + * This file is licensed under the terms of the GNU General Public License
> + * version 2. This program is licensed "as is" without any warranty of any
> + * kind, whether express or implied.
> + */
> +
> +#include <linux/module.h>
> +#include <linux/init.h>
> +#include <linux/console.h>
> +#include <linux/serial_reg.h>
> +#include <linux/delay.h>
> +#include <linux/tty.h>
> +#include <linux/tty_flip.h>
> +#include <linux/io.h>
> +#include <linux/dma-mapping.h>
> +
> +#include <asm/irq.h>
> +#include <mach/dma.h>
> +#include <mach/dmtimer.h>
> +#include <mach/omap-serial.h>
> +
> +#ifdef DEBUG
> +#define DPRINTK  printk
> +#else
> +#define DPRINTK(x...)
> +#endif

Please get rid of custom debug functions.

<snip>

> +			if (*status & UART_LSR_BI)
> +				flag = TTY_BREAK;
> +			else if (*status & UART_LSR_PE)
> +				flag = TTY_PARITY;
> +			else if (*status & UART_LSR_FE)
> +				flag = TTY_FRAME;
> +		}
> +
> +		if (uart_handle_sysrq_char(&up->port, ch))
> +			goto ignore_char;
> +
> +		uart_insert_char(&up->port, *status, UART_LSR_OE, ch, flag);
> +
> +ignore_char:
> +		*status = serial_in(up, UART_LSR);
> +	} while ((*status & UART_LSR_DR) && (max_count-- > 0));
> +	tty_flip_buffer_push(tty);
> +
> +
> +}

Extras lines at the end of function, you might want to remove.

<snip>

> +static struct console serial_omap_console = {
> +	.name		= "ttyS",
> +	.write		= serial_omap_console_write,
> +	.device		= uart_console_device,
> +	.setup		= serial_omap_console_setup,
> +	.flags		= CON_PRINTBUFFER,
> +	.index		= -1,
> +	.data		= &serial_omap_reg,
> +};

I believe you'll need to use some other name than ttyS. Otherwise
it will conflict with hotpluggable 8250 devices, such as bluetooth.


> +static struct uart_driver serial_omap_reg = {
> +	.owner		= THIS_MODULE,
> +	.driver_name	= "OMAP-SERIAL",
> +	.dev_name	= "ttyS",
> +	.major		= TTY_MAJOR,
> +	.minor		= 64,
> +	.nr		= 4,
> +	.cons		= OMAP_CONSOLE,
> +};

Here too. Maybe ttyO for the name?

Regards,

Tony
