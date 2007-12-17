Return-Path: <linux-kernel-owner+w=401wt.eu-S936231AbXLQMSz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936231AbXLQMSz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 07:18:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935720AbXLQMSd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 07:18:33 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:57495 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1763608AbXLQMSa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 07:18:30 -0500
Date: Mon, 17 Dec 2007 13:17:01 +0100
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: "Remy Bohmer" <linux@bohmer.net>
Cc: "Andrew Victor" <linux@maxim.org.za>, RT <linux-rt-users@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       ARM Linux Mailing List 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH]: Atmel Serial Console interrupt handler splitup
Message-ID: <20071217131701.6b2cdf2c@dhcp-252-066.norway.atmel.com>
In-Reply-To: <3efb10970712140346l1845d563k900d72d8788ac6f5@mail.gmail.com>
References: <3efb10970712070724i6fa66666t2b8422329759ce24@mail.gmail.com>
	<Pine.LNX.4.58.0712121606241.23712@gandalf.stny.rr.com>
	<3efb10970712121429l7b41d57md4f826f6aaf4b71@mail.gmail.com>
	<3efb10970712130840r7a2c5f72jca641d1cac545464@mail.gmail.com>
	<cd73a99e0712130933s6f601ef7sed90f48c08d9adaa@mail.gmail.com>
	<3efb10970712131232j5f747420g4aa8b5bd956e3dd3@mail.gmail.com>
	<3efb10970712131235t47a9ceb5y7d9a7d5023d07bf6@mail.gmail.com>
	<3efb10970712140346l1845d563k900d72d8788ac6f5@mail.gmail.com>
Organization: Atmel Norway
X-Mailer: Claws Mail 3.1.0 (GTK+ 2.12.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Dec 2007 12:46:09 +0100
"Remy Bohmer" <linux@bohmer.net> wrote:

> Hello Andrew,
> 
> So, to come to a conclusion about this complex patch series, I
> attached all the latest versions to this mail. The latest patches from
> yesterday including inline are also included to make the set complete.
> 
> So, this is the order in which the patches should be installed:
> 1) atmel_serial_cleanup.patch
> 2) atmel_serial_irq_splitup.patch
> 3) NEW: optional:  add-atmel-serial-dma.patch, this merged the DMA
> code (from Chip Coldwell) in your 2.6.23 patch back on top of this
> series. Because the AT32 bug is not been fixed for a very long time, I
> do not expect it to be fixed soon, so I think a reordering is better
> to make preempt-RT work on AT91.

I'll give it a shot, but first I have some comments on your other
patches.

Btw, it would be nice if patches that affect more or less
architecture-independent drivers were posted to linux-kernel (added to
Cc.)

Also, it would be easier to review if you posted just one patch per
e-mail. I'm going to cut & paste a bit from your attachments.

> 4) For RT only: atmel_serial_irqf_nodelay.patch can be applied
> anywhere after 1 and 2

I'll ignore this for now.

> +#define lread(port)		__raw_readl(port)
> +#define lwrite(v, port)		__raw_writel(v, port)

Why is this necessary, and what does 'l' stand for?

> -	struct uart_port	uart;		/* uart */
> -	struct clk		*clk;		/* uart clock */
> -	unsigned short		suspended;	/* is port suspended? */
> -	int			break_active;	/* break being received */
> +	struct uart_port 	uart;		/* uart */
> +	struct clk 	 	*clk;		/* uart clock */
> +	unsigned short 		suspended;	/* is port suspended? */
> +	int 			break_active;	/* break being received */

Looks like you're adding one or more spaces before each TAB here. Why
is that an improvement?

> static void atmel_stop_tx(struct uart_port *port)
>  {
> -	struct atmel_uart_port *atmel_port = (struct atmel_uart_port *) port;
> -
>  	UART_PUT_IDR(port, ATMEL_US_TXRDY);
>  }
>  
> @@ -214,8 +216,6 @@ static void atmel_stop_tx(struct uart_po
>   */
>  static void atmel_start_tx(struct uart_port *port)
>  {
> -	struct atmel_uart_port *atmel_port = (struct atmel_uart_port *) port;
> -
>  	UART_PUT_IER(port, ATMEL_US_TXRDY);
>  }
>  
> @@ -224,8 +224,6 @@ static void atmel_start_tx(struct uart_p
>   */
>  static void atmel_stop_rx(struct uart_port *port)
>  {
> -	struct atmel_uart_port *atmel_port = (struct atmel_uart_port *) port;
> -
>  	UART_PUT_IDR(port, ATMEL_US_RXRDY);
>  }

These conflict with David Brownell's "atmel_serial build warnings
begone" patch which was merged into mainline a few weeks ago.

> static void atmel_enable_ms(struct uart_port *port)
>  {
> -	UART_PUT_IER(port, ATMEL_US_RIIC | ATMEL_US_DSRIC | ATMEL_US_DCDIC | ATMEL_US_CTSIC);
> +	UART_PUT_IER(port,
> +		     ATMEL_US_RIIC | ATMEL_US_DSRIC | ATMEL_US_DCDIC |
> +		     ATMEL_US_CTSIC);

This looks a bit funny...IMO it would be better to keep a few of them
on the first line and indent the next line with an extra tab. But I'm
not going to be difficult about it if it conforms with the existing
style in the driver.

>  /*
> + * receive interrupt handler.
> + */
> +static inline void
> +atmel_handle_receive(struct uart_port *port, unsigned int pending)

Please drop "inline" here. The compiler will do it automatically if it
has only one caller, and if it at some point gets several callers, we
might not want to inline it after all.

> +{
> +	struct atmel_uart_port *atmel_port = (struct atmel_uart_port *)port;
> +
> +	/* Interrupt receive */
> +	if (pending & ATMEL_US_RXRDY)
> +		atmel_rx_chars(port);
> +	else if (pending & ATMEL_US_RXBRK) {
> +		/*
> +			* End of break detected. If it came along
> +			* with a character, atmel_rx_chars will
> +			* handle it.
> +			*/

Looks like the indentation got messed up here.

> +		UART_PUT_CR(port, ATMEL_US_RSTSTA);
> +		UART_PUT_IDR(port, ATMEL_US_RXBRK);
> +		atmel_port->break_active = 0;
> +	}
> +}
> +
> +/*
> + * transmit interrupt handler.
> + */
> +static inline void
> +atmel_handle_transmit(struct uart_port *port, unsigned int pending)
> +{
> +	/* Interrupt transmit */
> +	if (pending & ATMEL_US_TXRDY)
> +		atmel_tx_chars(port);
> +}
> +
> +/*
> + * status flags interrupt handler.
> + */
> +static inline void
> +atmel_handle_status(struct uart_port *port, unsigned int pending,
> +		    unsigned int status)
> +{
> +	/* TODO: All reads to CSR will clear these interrupts! */
> +	if (pending & ATMEL_US_RIIC)
> +		port->icount.rng++;
> +	if (pending & ATMEL_US_DSRIC)
> +		port->icount.dsr++;
> +	if (pending & ATMEL_US_DCDIC)
> +		uart_handle_dcd_change(port, !(status & ATMEL_US_DCD));
> +	if (pending & ATMEL_US_CTSIC)
> +		uart_handle_cts_change(port, !(status & ATMEL_US_CTS));
> +	if (pending &
> +		(ATMEL_US_RIIC | ATMEL_US_DSRIC | ATMEL_US_DCDIC |
> +		ATMEL_US_CTSIC))
> +		wake_up_interruptible(&port->info->delta_msr_wait);

Perhaps indent the big OR expression with another TAB to separate it
from the body?

> @@ -422,7 +454,9 @@ static int atmel_startup(struct uart_por
>  	/*
>  	 * Allocate the IRQ
>  	 */
> -	retval = request_irq(port->irq, atmel_interrupt, IRQF_SHARED, "atmel_serial", port);
> +	retval =
> +	    request_irq(port->irq, atmel_interrupt, IRQF_SHARED,
> +			"atmel_serial", port);

I think request_irq() belongs on the same line as "retval =".

>  static void atmel_shutdown(struct uart_port *port)
>  {
> -	struct atmel_uart_port *atmel_port = (struct atmel_uart_port *) port;
> -

Already in mainline.

>  	/* disable interrupts and drain transmitter */
> -	imr = UART_GET_IMR(port);	/* get interrupt mask */
> -	UART_PUT_IDR(port, -1);		/* disable all interrupts */
> -	while (!(UART_GET_CSR(port) & ATMEL_US_TXEMPTY)) { barrier(); }
> +	imr = UART_GET_IMR(port); /* get interrupt mask */
> +	UART_PUT_IDR(port, -1);	  /* disable all interrupts */

Please use TABs, not spaces. Might as well remove those comments...they
don't seem all that useful.

> +	while (!(UART_GET_CSR(port) & ATMEL_US_TXEMPTY))
> +		barrier();

Should probably use cpu_relax(), but it's probably out of scope for a
codingstyle cleanup patch (and I don't think it matters on AVR32 or
ARM.)

>  	/*
> -	 *	First, save IMR and then disable interrupts
> +	 *      First, save IMR and then disable interrupts
>  	 */
>  	imr = UART_GET_IMR(port);	/* get interrupt mask */
>  	UART_PUT_IDR(port, ATMEL_US_RXRDY | ATMEL_US_TXRDY);
> @@ -790,30 +828,32 @@ static void atmel_console_write(struct c
>  	uart_console_write(port, s, count, atmel_console_putchar);
>  
>  	/*
> -	 *	Finally, wait for transmitter to become empty
> -	 *	and restore IMR
> +	 *      Finally, wait for transmitter to become empty
> +	 *      and restore IMR
>  	 */

Looks like you're replacing TABs with spaces. Why?

> -// TODO: CR is a write-only register
> -//	unsigned int cr;
> +/* TODO: CR is a write-only register
> +//      unsigned int cr;
>  //
> -//	cr = UART_GET_CR(port) & (ATMEL_US_RXEN | ATMEL_US_TXEN);
> -//	if (cr == (ATMEL_US_RXEN | ATMEL_US_TXEN)) {
> -//		/* ok, the port was enabled */
> -//	}
> +//      cr = UART_GET_CR(port) & (ATMEL_US_RXEN | ATMEL_US_TXEN);
> +//      if (cr == (ATMEL_US_RXEN | ATMEL_US_TXEN)) {
> +//              / * ok, the port was enabled * /
> +//      }*/

That's a funny mix of C and C++ comments. Why not simply use #if 0 and
kill all the C++ comments?

That said, I don't understand what "TODO" means in this context. CR
isn't going to be readable any time soon.

> @@ -845,10 +885,10 @@ static int __init atmel_console_setup(st
>  	int parity = 'n';
>  	int flow = 'n';
>  
> -	if (port->membase == 0)		/* Port not initialized yet - delay setup */
> +	if (port->membase == 0)	/* Port not initialized yet - delay setup */
>  		return -ENODEV;

Looks better if you move the comment inside the body IMO.

> -	UART_PUT_IDR(port, -1);				/* disable interrupts */
> +	UART_PUT_IDR(port, -1);	/* disable interrupts */

Just kill that useless comment.

> @@ -880,13 +920,17 @@ static struct console atmel_console = {
>  static int __init atmel_console_init(void)
>  {
>  	if (atmel_default_console_device) {
> -		add_preferred_console(ATMEL_DEVICENAME, atmel_default_console_device->id, NULL);
> -		atmel_init_port(&(atmel_ports[atmel_default_console_device->id]), atmel_default_console_device);
> +		add_preferred_console(ATMEL_DEVICENAME,
> +				      atmel_default_console_device->id, NULL);
> +		atmel_init_port(
> +			      &(atmel_ports[atmel_default_console_device->id]),
> +			      atmel_default_console_device);

That looks a bit funny. If you're having trouble moving
&(atmel_ports... onto the same line as atmel_init_port, please consider
removing the redundant parentheses.

Moving on to the next patch...

> This patch splits up the interrupt handler of the serial port
> into a interrupt top-half and some tasklets.
> 
> The goal is to get the interrupt top-half as short as possible to
> minimize latencies on interrupts. But the old code also does some
> calls in the interrupt handler that are not allowed on preempt-RT
> in IRQF_NODELAY context. This handler is executed in this context
> because of the interrupt sharing with the timer interrupt.
> The timer interrupt on Preempt-RT runs in IRQF_NODELAY context.

What calls are we talking about here? uart_insert_char() and
tty_flip_buffer_push()?

> 2 tasklets are used:
> * one for handling the error statuses
> * one for pushing the incoming characters into the tty-layer.

Why is it necessary with two tasklets?

> +struct atmel_uart_char {
> +	unsigned int status;
> +	unsigned int overrun;
> +	unsigned int ch;
> +	unsigned int flg;
> +};

Hmm. 16 bytes per char is a bit excessive, isn't it? How about

struct atmel_uart_char {
	u16	ch;
	u16	status;
};

where ch is the received character (up to 9 bits) and status is the
lowest 16 bits of the status register?

> +#define ATMEL_SERIAL_RINGSIZE 1024
> +
> +struct atmel_uart_ring {
> +	unsigned int          head;
> +	unsigned int          tail;
> +	unsigned int          count;
> +	struct atmel_uart_char data[ATMEL_SERIAL_RINGSIZE];
> +};

Why not use struct circ_buf? Why do you need "count"?

Ok, that's all for now. I'm going to take a closer look at the DMA
patch and hopefully figure out why it isn't working on AVR32.

Thanks for your efforts in cleaning this stuff up.

Haavard
