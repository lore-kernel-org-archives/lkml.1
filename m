Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758696Ab0CLUs5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 15:48:57 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44864 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757208Ab0CLUsw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 15:48:52 -0500
Date: Fri, 12 Mar 2010 12:48:35 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Tobias Klauser <tklauser@distanz.ch>
Cc: linux-serial@vger.kernel.org, gregkh@suse.de,
       nios2-dev@sopc.et.ntust.edu.tw, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv3 1/2] serial: Add driver for the Altera JTAG UART
Message-Id: <20100312124835.724eb806.akpm@linux-foundation.org>
In-Reply-To: <15dc056891fb785001073bab4f9a0d0f3bf99af1.1267807169.git.klto@zhaw.ch>
References: <cover.1267807169.git.klto@zhaw.ch>
	<15dc056891fb785001073bab4f9a0d0f3bf99af1.1267807169.git.klto@zhaw.ch>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  5 Mar 2010 17:52:22 +0100
Tobias Klauser <tklauser@distanz.ch> wrote:

> Add an UART driver for the JTAG UART component available as a SOPC
> (System on Programmable Chip) component for Altera FPGAs.
> 
> ...
>
> --- a/drivers/serial/Kconfig
> +++ b/drivers/serial/Kconfig
> @@ -1490,4 +1490,25 @@ config SERIAL_GRLIB_GAISLER_APBUART_CONSOLE
>  	help
>  	Support for running a console on the GRLIB APBUART
>  
> +config SERIAL_ALTERA_JTAGUART
> +	bool "Altera JTAG UART support"
> +	select SERIAL_CORE
> +	help
> +	  This driver supports the Altera JTAG UART port.
> +
> +config SERIAL_ALTERA_JTAGUART_CONSOLE
> +	bool "Altera JTAG UART console support"
> +	depends on SERIAL_ALTERA_JTAGUART
> +	select SERIAL_CORE_CONSOLE
> +	help
> +	  Enable a Altera JTAG UART port to be the system console.
> +
> +config SERIAL_ALTERA_JTAGUART_CONSOLE_BYPASS
> +	bool "Bypass output when no connection"
> +	depends on SERIAL_ALTERA_JTAGUART_CONSOLE
> +	select SERIAL_CORE_CONSOLE
> +	help
> +	  Bypass console output and keep going even if there is no
> +	  JTAG terminal connection with the host.

So this driver will be available on all CPU architectures.

I'm guessing that the hardware _isn't_ available on all CPU
architectures?  Maybe that's wrong.

If this hardware is only available on certain CPUs then we face
tradeoffs.  By making it universally available, the code gets better
compile tesst coverage and that can detect problems (usually minor
ones).  otoh, it can increase your maintenance load a bit, and adds a
risk that people will ship unusable kernel modules and will see
increased build times.  I have no particular opinion either way.


>  endmenu
> diff --git a/drivers/serial/Makefile b/drivers/serial/Makefile
> index 5548fe7..6228b6e 100644
> --- a/drivers/serial/Makefile
> +++ b/drivers/serial/Makefile
> @@ -82,3 +82,4 @@ obj-$(CONFIG_KGDB_SERIAL_CONSOLE) += kgdboc.o
>  obj-$(CONFIG_SERIAL_QE) += ucc_uart.o
>  obj-$(CONFIG_SERIAL_TIMBERDALE)	+= timbuart.o
>  obj-$(CONFIG_SERIAL_GRLIB_GAISLER_APBUART) += apbuart.o
> +obj-$(CONFIG_SERIAL_ALTERA_JTAGUART) += altera_jtaguart.o
> diff --git a/drivers/serial/altera_jtaguart.c b/drivers/serial/altera_jtaguart.c
> new file mode 100644
> index 0000000..f9b49b5
> --- /dev/null
> +++ b/drivers/serial/altera_jtaguart.c
> @@ -0,0 +1,504 @@
> +/*
> + * altera_jtaguart.c -- Altera JTAG UART driver
> + *
> + * Based on mcf.c -- Freescale ColdFire UART driver
> + *
> + * (C) Copyright 2003-2007, Greg Ungerer <gerg@snapgear.com>
> + * (C) Copyright 2008, Thomas Chou <thomas@wytron.com.tw>
> + * (C) Copyright 2010, Tobias Klauser <tklauser@distanz.ch>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/init.h>
> +#include <linux/interrupt.h>
> +#include <linux/module.h>
> +#include <linux/console.h>
> +#include <linux/tty.h>
> +#include <linux/tty_flip.h>
> +#include <linux/serial.h>
> +#include <linux/serial_core.h>
> +#include <linux/platform_device.h>
> +#include <linux/io.h>
> +#include <linux/altera_jtaguart.h>

Does it make sense to put altera_jtaguart.h into include/linux?  Could
we put it in drivers/serial/?

>
> ...
>
