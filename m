Return-Path: <linux-kernel-owner+w=401wt.eu-S1761603AbXE1KwV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761603AbXE1KwV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 06:52:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750807AbXE1KwN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 06:52:13 -0400
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:2601 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750700AbXE1KwM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 06:52:12 -0400
Date: Mon, 28 May 2007 11:51:53 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Yinghai Lu <Yinghai.Lu@Sun.COM>
Cc: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       bjorn.helgaas@hp.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: PATCH] serial: convert early_uart to earlycon for 8250
Message-ID: <20070528105153.GE26046@flint.arm.linux.org.uk>
Mail-Followup-To: Yinghai Lu <Yinghai.Lu@Sun.COM>,
	Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
	bjorn.helgaas@hp.com,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <86802c440705122233y327756e7te534199f46b2059d@mail.gmail.com> <4648B2CC.2020403@sun.com> <200705151348.15355.yinghai.lu@sun.com> <200705221231.59694.yinghai.lu@sun.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200705221231.59694.yinghai.lu@sun.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I can't comment on the arch specific bits.  As a general note, I think
this is over complex.  For instance, the additional hook in serial_core
to call the find_port_for_earlycon method isn't needed because you can
call serial8250_find_port_for_earlycon() from within
serial8250_console_setup().  You can also modify co->index from
within there without needing update_console_cmdline_console_index().

Bjorn needs to review the 8250_early changes.

Apart from that, two other comments:

On Tue, May 22, 2007 at 12:31:59PM -0700, Yinghai Lu wrote:
> diff --git a/drivers/serial/8250.c b/drivers/serial/8250.c
> index c84dab0..e341fb9 100644
> --- a/drivers/serial/8250.c
> +++ b/drivers/serial/8250.c
> @@ -2402,6 +2405,7 @@ static void __init serial8250_isa_init_ports(void)
>  	for (i = 0, up = serial8250_ports;
>  	     i < ARRAY_SIZE(old_serial_port) && i < nr_uarts;
>  	     i++, up++) {
> +		printk(KERN_INFO "serial8250_isa_init_ports 2  idx=%d\n",i);

Is this a debugging printk?

>  		up->port.iobase   = old_serial_port[i].port;
>  		up->port.irq      = irq_canonicalize(old_serial_port[i].irq);
>  		up->port.uartclk  = old_serial_port[i].baud_base * 16;
> @@ -2533,7 +2537,7 @@ static int __init serial8250_console_init(void)
>  }
>  console_initcall(serial8250_console_init);
>  
> -static int __init find_port(struct uart_port *p)
> +int __init find_port_serial8250(struct uart_port *p)

If this is going to become globally visible, please name it
serial8250_find_port to match the style of the rest of the file.

>  {
>  	int line;
>  	struct uart_port *port;
> diff --git a/include/linux/serial.h b/include/linux/serial.h
> index 33fc8cb..deb7143 100644
> --- a/include/linux/serial.h
> +++ b/include/linux/serial.h
> @@ -177,11 +177,5 @@ struct serial_icounter_struct {
>  #ifdef __KERNEL__
>  #include <linux/compiler.h>
>  
> -/* Allow architectures to override entries in serial8250_ports[] at run time: */
> -struct uart_port;	/* forward declaration */
> -extern int early_serial_setup(struct uart_port *port);
> -extern int early_serial_console_init(char *options);
> -extern int serial8250_start_console(struct uart_port *port, char *options);
> -
>  #endif /* __KERNEL__ */
>  #endif /* _LINUX_SERIAL_H */

Good - this needed to be killed.


-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
