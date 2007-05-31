Return-Path: <linux-kernel-owner+w=401wt.eu-S1760576AbXEaXym@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760576AbXEaXym (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 19:54:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755765AbXEaXye
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 19:54:34 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:48993 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755498AbXEaXyd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 19:54:33 -0400
Date: Thu, 31 May 2007 16:54:28 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Yinghai Lu <Yinghai.Lu@Sun.COM>
Cc: Andi Kleen <ak@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/5] serial: convert early_uart to earlycon for 8250
Message-Id: <20070531165428.c6cdc042.akpm@linux-foundation.org>
In-Reply-To: <200705311401.33715.yinghai.lu@sun.com>
References: <200705311401.33715.yinghai.lu@sun.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 May 2007 14:01:33 -0700
Yinghai Lu <Yinghai.Lu@Sun.COM> wrote:

> Andrew,
> 
> Please don't drop others if there is problem with this one.
> 
> YH
> 
> [PATCH 4/5] serial: convert early_uart to earlycon for 8250
> 
> Beacuse SERIAL_PORT_DFNS is removed from include/asm-i386/serial.h and
> include/asm-x86_64/serial.h. the serial8250_ports need to be probed late
> in serial initializing stage. the console_init=>serial8250_console_init=>
> register_console=>serial8250_console_setup will return -ENDEV, and console
> ttyS0 can not be enabled at that time.
> need to wait till uart_add_one_port in drivers/serial/serial_core.c to call
> register_console to get console ttyS0. that is too late.
> 
> Make early_uart to use early_param, so uart console can be used earlier.
> Make it to be bootconsole with CON_BOOT flag, so can use console handover
> feature. and it will switch to corresponding normal serial console
> automatically.
> 
> new command line will be:
> 	console=uart8250,io,0x3f8,9600n8
> 	console=uart8250,mmio,0xff5e0000,115200n8
> or
> 	earlycon=uart8250,io,0x3f8,9600n8
> 	earlycon=uart8250,mmio,0xff5e0000,115200n8
> 
> it will print in very early stage:
> 	Early serial console at I/O port 0x3f8 (options '9600n8')
> 	console [uart0] enabled
> later for console it will print:
> 	console handover: boot [uart0] -> real [ttyS0]
> 
> ...
>
> --- a/drivers/serial/8250_early.c
> +++ b/drivers/serial/8250_early.c
> @@ -32,17 +30,21 @@
>  #include <linux/serial_core.h>
>  #include <linux/serial_reg.h>
>  #include <linux/serial.h>
> +#include <linux/serial_8250.h>
>  #include <asm/io.h>
>  #include <asm/serial.h>
> +#ifdef CONFIG_FIX_EARLYCON_MEM
> +#include <asm/pgtable.h>
> +#include <asm/fixmap.h>
> +#endif
>  
> ...
>
> @@ -143,12 +144,18 @@ static int __init parse_options(struct early_uart_device *device, char *options)
>  	if (!strncmp(options, "mmio,", 5)) {
>  		port->iotype = UPIO_MEM;
>  		port->mapbase = simple_strtoul(options + 5, &options, 0);
> -		port->membase = ioremap(port->mapbase, mapsize);
> +#ifdef CONFIG_FIX_EARLYCON_MEM
> +		set_fixmap_nocache(FIX_EARLYCON_MEM_BASE, port->mapbase & PAGE_MASK);
> +		port->membase = (void __iomem *)__fix_to_virt(FIX_EARLYCON_MEM_BASE);
> +		port->membase += port->mapbase & ~PAGE_MASK;
> +#else
> +		port->membase = ioremap(port->mapbase, 64);

ug.  OK, that'll work.  Simple and direct ;)

> --- a/drivers/serial/Kconfig
> +++ b/drivers/serial/Kconfig
>
> ...
>
> +config FIX_EARLYCON_MEM
> +	bool
> +	depends on X86
> +	default y
> +

It might have been nicer to do this in arch/i386/Kconfig and
arch/x86_64/Kconfig.  That way we don't end up with a great string of arch
selectors in non-arch Kconfig files (do "grep SPARC */Kconfig*")

otoh, doing that means that FIX_EARLYCON_MEM doesn't get mentioned in
drivers/serial/Kconfig and you need to go on a great hunting expedition to
find out who sets it.

