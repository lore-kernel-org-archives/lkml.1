Return-Path: <linux-kernel-owner+w=401wt.eu-S1754422AbYISNO3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754422AbYISNO3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 09:14:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752537AbYISNOU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 09:14:20 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:62838 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751415AbYISNOT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 09:14:19 -0400
Date: Fri, 19 Sep 2008 15:09:38 +0200
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Anti Sullin <anti.sullin@artecdesign.ee>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] AT91 Serial: update the powersave handler to match
 serial core
Message-ID: <20080919150938.08b2c7be@hskinnemo-gx745.norway.atmel.com>
In-Reply-To: <48CE42C8.1090608@artecdesign.ee>
References: <48CE42C8.1090608@artecdesign.ee>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 19 Sep 2008 13:09:28.0376 (UTC) FILETIME=[F271D380:01C91A58]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Anti Sullin <anti.sullin@artecdesign.ee> wrote:
> This problem seems to be unnoticed so far:
> 
> Patch http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=b3b708fa2780cd2b5d8266a8f0c3a1cab364d4d2
> has changed the serial core behavior to not to suspend the port if the device is enabled as a wakeup source. If the
> AT91 system goes to slow clock mode, the port should be suspended always and the clocks should be switched off. 
> The patch attached updates the atmel_serial driver to match the changes in serial core.

Right...I guess this might also help get rid of the warning about
unbalanced irqwake that I've been meaning to look at for a while now...

> Also, the interrupts are disabled when the clock is disabled. If we disable the clock with interrupts enabled, an interrupt
> may get stuck. If this is the DBGU interrupt, this blocks the OR logic at system controller and thus all other sysc interrupts.

Not good. I suspect we need to stop DMA as well though...or wait until
it's drained.

> The patch is against 2.6.25.3 + at91 patchset at maxim.org.za. 

It doesn't apply to latest mainline, but I'll try to cram it in somehow.

A few questions though...

> diff -purN linux-2.6.25.3/drivers/serial/atmel_serial.c linux-2.6.25.3_ok/drivers/serial/atmel_serial.c
> --- linux-2.6.25.3/drivers/serial/atmel_serial.c	2008-05-10 07:48:50.000000000 +0300
> +++ linux-2.6.25.3_ok/drivers/serial/atmel_serial.c	2008-09-08 12:35:35.000000000 +0300
> @@ -132,7 +132,8 @@ struct atmel_uart_char {
>  struct atmel_uart_port {
>  	struct uart_port	uart;		/* uart */
>  	struct clk		*clk;		/* uart clock */
> -	unsigned short		suspended;	/* is port suspended? */
> +	int			may_wakeup;		/* cached value of device_may_wakeup for times we need to disable it */
> +	int			backup_imr;		/* back up the IMR during suspend */

Since this is a hardware register, shouldn't it be u32?

> @@ -1264,6 +1273,8 @@ void __init atmel_register_uart_fns(stru
>  #ifdef CONFIG_SERIAL_ATMEL_CONSOLE
>  static void atmel_console_putchar(struct uart_port *port, int ch)
>  {
> +	if (port->suspended) return;
> +
>  	while (!(UART_GET_CSR(port) & ATMEL_US_TXRDY))
>  		cpu_relax();
>  	UART_PUT_CHAR(port, ch);
> @@ -1278,6 +1289,8 @@ static void atmel_console_write(struct c
>  	unsigned int status, imr;
>  	unsigned int pdc_tx;
>  
> +	if (port->suspended) return;
> +

Are both of these checks necessary? It doesn't look like
atmel_console_putchar() can be called from anywhere else than
atmel_console_write().

Also, does the no_console_suspend parameter still work after this?

Haavard
