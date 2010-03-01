Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751316Ab0CASQE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 13:16:04 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:33668 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751087Ab0CASQA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 13:16:00 -0500
Date: Mon, 1 Mar 2010 18:19:20 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Tobias Klauser <tklauser@distanz.ch>
Cc: linux-serial@vger.kernel.org, nios2-dev@sopc.et.ntust.edu.tw,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2 2/2] serial: Add driver for the Altera UART
Message-ID: <20100301181920.3952c3e7@lxorguk.ukuu.org.uk>
In-Reply-To: <afb4f2a75a6a35853774b10f34635a1d52d4cebd.1267448534.git.klto@zhaw.ch>
References: <cover.1267448534.git.klto@zhaw.ch>
	<15dc056891fb785001073bab4f9a0d0f3bf99af1.1267448534.git.klto@zhaw.ch>
	<afb4f2a75a6a35853774b10f34635a1d52d4cebd.1267448534.git.klto@zhaw.ch>
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.18.6; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> + * Some boards implement the DTR/DCD lines using GPIO lines, most don't. Dummy
> + * out the access macros for those that don't. Those that do should define these
> + * macros somewhere in their board specific inlude files.
> + */
> +#if !defined(altera_uart_getppdcd)
> +# define altera_uart_getppdcd(p)	(1)
> +#endif
> +#if !defined(altera_uart_getppdtr)
> +# define altera_uart_getppdtr(p)	(1)
> +#endif
> +#if !defined(altera_uart_setppdtr)
> +# define altera_uart_setppdtr(p, v)	do { } while (0)
> +#endif

Those ought to be in the board stuff only - the problem you have
otherwise is that someone not noticing won't get an error.


> +static void altera_uart_set_termios(struct uart_port *port,
> +				    struct ktermios *termios,
> +				    struct ktermios *old)
> +{
> +	unsigned long flags;
> +	unsigned int baud, baudclk;
> +
> +	baud = uart_get_baud_rate(port, termios, old, 0, 4000000);
> +	baudclk = port->uartclk / baud;
> +
> +	spin_lock_irqsave(&port->lock, flags);
> +	writel(baudclk, port->membase + ALTERA_UART_DIVISOR_REG);
> +	spin_unlock_irqrestore(&port->lock, flags);

If you only support board setting then copy the old termios back as in
the other driver and the use tty_termios_encode_baud_rate() to report
set the baud rate accordingly.

Acked-by: Alan Cox <alan@linux.intel.com>

As the oddments that want adjusting can be done post merge and I'd rather
see this in now than later as there are some serial_core changes cooking
that will need to touch all drivers.
