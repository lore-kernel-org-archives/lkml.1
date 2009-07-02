Return-Path: <linux-kernel-owner+w=401wt.eu-S1756795AbZGBVwc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756795AbZGBVwc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 17:52:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754563AbZGBVwZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 17:52:25 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:56944 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752912AbZGBVwZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 17:52:25 -0400
Date: Thu, 2 Jul 2009 22:53:12 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: Alan Cox <alan@linux.intel.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] 8250: Now honours baud rate lower bounds
Message-ID: <20090702225312.02f78ec4@lxorguk.ukuu.org.uk>
In-Reply-To: <20090702213624.GA23193@oksana.dev.rtsoft.ru>
References: <20090702213624.GA23193@oksana.dev.rtsoft.ru>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 3 Jul 2009 01:36:24 +0400
Anton Vorontsov <avorontsov@ru.mvista.com> wrote:

> A platform clock drives 8250 ports in most SOC systems, the clock
> might run at high frequencies, and so it's not always possible to
> downscale uart clock to a desired value.

> This patch fixes the issue by passing minimum baud rate to the
> uart_get_baud_rate() call, the call should take care of all bounds,
> so userspace should now report:

We ought to be able to deduce the minimum baud rate from the divisor
being bigger than the chip supports - or do some of these devices not
support the full hw divisor range of the real chip which is what I assume
from your patch ?

> +static unsigned int _serial_dl_max(struct uart_8250_port *up)
> +{
> +	return 0xffff;
> +}
> +

We have far too many magic ifdef routines for this sort of stuff already.
Is there any reason we can't put info on the true divisor or at least the
baud rate range into the uart_8250_port structure so that we get rid of
all of 

> +static unsigned int serial_dl_max(struct uart_8250_port *up)
> +{
> +	if (up->port.iotype == UPIO_AU)
> +		return 0xffffffff;
> +	else
> +		return _serial_dl_max(up);
> +}
>  #elif defined(CONFIG_SERIAL_8250_RM9K)
>  static int serial_dl_read(struct uart_8250_port *up)
>  {
> @@ -602,9 +615,15 @@ static void serial_dl_write(struct uart_8250_port *up, int value)
>  		_serial_dl_write(up, value);
>  	}
>  }
> +
> +static unsigned int serial_dl_max(struct uart_8250_port *up)
> +{
> +	return _serial_dl_max(up);
> +}
>  #else
>  #define serial_dl_read(up) _serial_dl_read(up)
>  #define serial_dl_write(up, value) _serial_dl_write(up, value)
> +#define serial_dl_max(up) _serial_dl_max(up)
>  #endif
>  
>  /*
> @@ -2272,7 +2291,9 @@ serial8250_set_termios(struct uart_port *port, struct ktermios *termios,
>  	/*
>  	 * Ask the core to calculate the divisor for us.
>  	 */
> -	baud = uart_get_baud_rate(port, termios, old, 0, port->uartclk/16);
> +	baud = uart_get_baud_rate(port, termios, old,
> +				  port->uartclk / 16 / serial_dl_max(up),
> +				  port->uartclk / 16);
>  	quot = serial8250_get_divisor(port, baud);

in favour of

		uart_get_baud_rate(port, termios, old, port->uartclk / 16,
				port->uartclk / 16 / port->uartdivider)

Alan
