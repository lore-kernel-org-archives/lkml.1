Return-Path: <linux-kernel-owner+w=401wt.eu-S1758212AbZBSVSV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758212AbZBSVSV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 16:18:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753918AbZBSVSN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 16:18:13 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38310 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754403AbZBSVSM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 16:18:12 -0500
Date: Thu, 19 Feb 2009 13:17:58 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: linux-kernel@vger.kernel.org, ralf@linux-mips.org,
       jason.wessel@windriver.com
Subject: Re: [PATCH resend] kgdb: kgdboc console poll hooks for serial_txx9
 uart
Message-Id: <20090219131758.088381f3.akpm@linux-foundation.org>
In-Reply-To: <20090218.223641.128619445.anemo@mba.ocn.ne.jp>
References: <20090218.223641.128619445.anemo@mba.ocn.ne.jp>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Feb 2009 22:36:41 +0900 (JST)
Atsushi Nemoto <anemo@mba.ocn.ne.jp> wrote:

> Implement the serial polling hooks for the serial_txx9 uart for use
> with kgdboc.
> 
> ...
>
> diff --git a/drivers/serial/serial_txx9.c b/drivers/serial/serial_txx9.c
> index 8fcb4c5..6f18215 100644
> --- a/drivers/serial/serial_txx9.c
> +++ b/drivers/serial/serial_txx9.c
> @@ -461,6 +461,94 @@ static void serial_txx9_break_ctl(struct uart_port *port, int break_state)
>  	spin_unlock_irqrestore(&up->port.lock, flags);
>  }
>  
> +#if defined(CONFIG_SERIAL_TXX9_CONSOLE) || (CONFIG_CONSOLE_POLL)
> +/*
> + *	Wait for transmitter & holding register to empty
> + */
> +static void wait_for_xmitr(struct uart_txx9_port *up)
> +{
> +	unsigned int tmout = 10000;
> +
> +	/* Wait up to 10ms for the character(s) to be sent. */
> +	while (--tmout &&
> +	       !(sio_in(up, TXX9_SICISR) & TXX9_SICISR_TXALS))
> +		udelay(1);
> +
> +	/* Wait up to 1s for flow control if necessary */
> +	if (up->port.flags & UPF_CONS_FLOW) {
> +		tmout = 1000000;
> +		while (--tmout &&
> +		       (sio_in(up, TXX9_SICISR) & TXX9_SICISR_CTSS))
> +			udelay(1);
> +	}
> +}
> +#endif
> +
> +#ifdef CONFIG_CONSOLE_POLL
> +/*
> + * Console polling routines for writing and reading from the uart while
> + * in an interrupt or debug context.
> + */
> +
> +static int serial_txx9_get_poll_char(struct uart_port *port)
> +{
> +	unsigned int ier;
> +	unsigned char c;
> +	struct uart_txx9_port *up = (struct uart_txx9_port *)port;

It's nicer to use container_of() for this operation.

> ...
>
> +static void serial_txx9_put_poll_char(struct uart_port *port, unsigned char c)
> +{
> +	unsigned int ier;
> +	struct uart_txx9_port *up = (struct uart_txx9_port *)port;

ditto.

> +	/*
> +	 *	First save the IER then disable the interrupts
> +	 */
> +	ier = sio_in(up, TXX9_SIDICR);
> +	sio_out(up, TXX9_SIDICR, 0);
> +
> +	wait_for_xmitr(up);
> +	/*
> +	 *	Send the character out.
> +	 *	If a LF, also do CR...
> +	 */
> +	sio_out(up, TXX9_SITFIFO, c);
> +	if (c == 10) {
> +		wait_for_xmitr(up);
> +		sio_out(up, TXX9_SITFIFO, 13);
> +	}
> +
> +	/*
> +	 *	Finally, wait for transmitter to become empty
> +	 *	and restore the IER
> +	 */
> +	wait_for_xmitr(up);
> +	sio_out(up, TXX9_SIDICR, ier);
> +}
> +

