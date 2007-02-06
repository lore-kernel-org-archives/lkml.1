Return-Path: <linux-kernel-owner+w=401wt.eu-S1751887AbXBFJhZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751887AbXBFJhZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 04:37:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751892AbXBFJhZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 04:37:25 -0500
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:2534 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751887AbXBFJhX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 04:37:23 -0500
Date: Tue, 6 Feb 2007 09:37:00 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: "Wu, Bryan" <bryan.wu@analog.com>
Cc: alan@lxorguk.ukuu.org.uk, aubreylee@gmail.com, akpm@osdl.org,
       rdunlap@xenotime.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3, try #2] Blackfin: serial driver for Blackfin architecture against Linux kernel 2.6.20
Message-ID: <20070206093700.GA27827@flint.arm.linux.org.uk>
Mail-Followup-To: "Wu, Bryan" <bryan.wu@analog.com>,
	alan@lxorguk.ukuu.org.uk, aubreylee@gmail.com, akpm@osdl.org,
	rdunlap@xenotime.net, linux-kernel@vger.kernel.org
References: <1170732011.31450.49.camel@roc-desktop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1170732011.31450.49.camel@roc-desktop>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I think you have a bit of work to do on this driver; it seems to be
missing all termios handling apart from setting the baud rate.
Moreover, it's re-using the 8250 driver port range despite claiming
to have a proper allocation.

(I don't maintain serial anymore but I do reserve the right to
occasionally review serial code.)

On Tue, Feb 06, 2007 at 11:20:11AM +0800, Wu, Bryan wrote:
> +/* We've been assigned a range on the "Low-density serial ports" major */
> +#define SERIAL_BFIN_MAJOR	TTY_MAJOR
> +#define MINOR_START		64

If you've been assigned a range in the low density serial ports major,
why aren't you using it instead of taking the 8250 drivers range (thereby
preventing PCMCIA cards from ever being used) ?

> +#if defined(CONFIG_BAUD_9600)
> +#define CONSOLE_BAUD_RATE       9600
> +#elif defined(CONFIG_BAUD_19200)
> +#define CONSOLE_BAUD_RATE       19200
> +#elif defined(CONFIG_BAUD_38400)
> +#define CONSOLE_BAUD_RATE       38400
> +#elif defined(CONFIG_BAUD_57600)
> +#define CONSOLE_BAUD_RATE       57600
> +#elif defined(CONFIG_BAUD_115200)
> +#define CONSOLE_BAUD_RATE       115200
> +#endif

What's wrong with passing console=ttyblackfin0,115200 to the kernel or
via some default command line?

> +/*
> + * interrupts are disabled on entry
> + */
> +static void bfin_serial_stop_tx(struct uart_port *port)
> +{
> +	struct bfin_serial_port *uart = (struct bfin_serial_port *)port;
> +
> +#ifdef CONFIG_SERIAL_BFIN_DMA
> +        disable_dma(uart->tx_dma_channel);

It's far better to stop transmission as soon as possible to prevent
overruns at the remote end.  I doubt disabling DMA achieves that.

> +#else
> +	unsigned short ier;
> +
> +	ier = UART_GET_IER(uart);
> +	ier &= ~ETBEI;
> +	UART_PUT_IER(uart, ier);
> +#endif
> +}
...
> +static void bfin_serial_rx_chars(struct bfin_serial_port *uart)
> +{
> +	struct tty_struct *tty = uart->port.info?uart->port.info->tty:0;
> +	unsigned int status, ch, flg;
> +#if defined(CONFIG_BF531) || defined(CONFIG_BF532) || defined(CONFIG_BF533)
> +	static int in_break = 0;
> +#endif
> +
> +	status = UART_GET_LSR(uart);
> + 	ch = UART_GET_CHAR(uart);
> + 	uart->port.icount.rx++;
> +
> +#if defined(CONFIG_BF531) || defined(CONFIG_BF532) || defined(CONFIG_BF533)
> +	if (in_break) {
> +		if (ch != 0) {
> +			in_break = 0;
> +			ch = UART_GET_CHAR(uart);
> +		}
> +		return;
> +	}
> +#endif
> +
> +	if (status & BI) {
> +#if defined(CONFIG_BF531) || defined(CONFIG_BF532) || defined(CONFIG_BF533)
> +		in_break = 1;
> +#endif
> +		uart->port.icount.brk++;
> +		if (uart_handle_break(&uart->port))
> +			goto ignore_char;
> +		flg = TTY_BREAK;
> +	} else if (status & PE) {
> +		flg = TTY_PARITY;
> +		uart->port.icount.parity++;
> +	} else if (status & OE) {
> +		flg = TTY_OVERRUN;
> +		uart->port.icount.overrun++;
> +	} else if (status & FE) {
> +		flg = TTY_FRAME;
> +		uart->port.icount.frame++;
> +	} else
> +		flg = TTY_NORMAL;

Why do many serial drivers when they're first written utterly ignore
termios modes in their reception path by not using port.read_status_mask?
It's broken as stands.

> +
> +	if (uart_handle_sysrq_char(&uart->port, ch))
> +		goto ignore_char;
> +	if (tty)
> +		uart_insert_char(&uart->port, status, 2, ch, flg);
> +
> +ignore_char:
> +	if (tty)
> +		tty_flip_buffer_push(tty);
> +}
...
> +static irqreturn_t bfin_serial_int(int irq, void *dev_id)
> +{
> +	struct bfin_serial_port *uart = dev_id;
> +	unsigned short status;
> +
> +	spin_lock(&uart->port.lock);
> +	status = UART_GET_IIR(uart);
> +	do {
> +		if ((status & IIR_STATUS) == IIR_TX_READY)
> +			bfin_serial_tx_chars(uart);
> +		if ((status & IIR_STATUS) == IIR_RX_READY)
> +			bfin_serial_rx_chars(uart);
> +		status = UART_GET_IIR(uart);
> +	} while (status &(IIR_TX_READY | IIR_RX_READY));

Space between '&' and '(' please.

> +	spin_unlock(&uart->port.lock);
> +	return IRQ_HANDLED;
> +}
...
> +static void bfin_serial_dma_rx_chars(struct bfin_serial_port * uart)
> +{
> +	struct tty_struct *tty = uart->port.info->tty;
> +	int i, flg, status;
> +
> +	status = UART_GET_LSR(uart);
> +	uart->port.icount.rx += CIRC_CNT(uart->rx_dma_buf.head, uart->rx_dma_buf.tail, UART_XMIT_SIZE);;
> +
> +        if (status & BI) {
> +                uart->port.icount.brk++;
> +                if (uart_handle_break(&uart->port))
> +                        goto dma_ignore_char;
> +                flg = TTY_BREAK;
> +        } else if (status & PE) {
> +                flg = TTY_PARITY;
> +                uart->port.icount.parity++;
> +        } else if (status & OE) {
> +                flg = TTY_OVERRUN;
> +                uart->port.icount.overrun++;
> +        } else if (status & FE) {
> +                flg = TTY_FRAME;
> +                uart->port.icount.frame++;
> +        } else
> +                flg = TTY_NORMAL;

No termios handling.

> +
> +	for (i = uart->rx_dma_buf.head; i < uart->rx_dma_buf.tail; i++) {
> +		if (uart_handle_sysrq_char(&uart->port, uart->rx_dma_buf.buf[i]))
> +			goto dma_ignore_char;
> +		uart_insert_char(&uart->port, status, 2, uart->rx_dma_buf.buf[i], flg);
> +	}
> +dma_ignore_char:
> +	tty_flip_buffer_push(tty);
> +}
...
> +/*
> + * Handle any change of modem status signal since we were last called.
> + */
> +static void bfin_serial_mctrl_check(struct bfin_serial_port *uart)
> +{
> +#ifdef CONFIG_SERIAL_BFIN_CTSRTS
> +	unsigned int status;
> +# ifdef CONFIG_SERIAL_BFIN_DMA
> +	struct uart_info *info = uart->port.info;
> +	struct tty_struct *tty = info->tty;
> +
> +	status = bfin_serial_get_mctrl(&uart->port);
> +	if (!(status & TIOCM_CTS)) {
> +		tty->hw_stopped = 1;
> +	} else {
> +		tty->hw_stopped = 0;
> +	}

A change of CTS doesn't always mean transmission has to stop.
uart_handle_cts_change() knows when this has to happen.  Use it.

> +# else
> +	status = bfin_serial_get_mctrl(&uart->port);
> +	uart_handle_cts_change(&uart->port, status & TIOCM_CTS);
> +	if (!(status & TIOCM_CTS))
> +		schedule_work(&uart->cts_workqueue);
> +# endif
> +#endif
> +}
...
> +static void
> +bfin_serial_set_termios(struct uart_port *port, struct ktermios *termios,
> +		   struct ktermios *old)
> +{
> +	struct bfin_serial_port *uart = (struct bfin_serial_port *)port;
> +	unsigned long flags;
> +	unsigned int baud, quot;
> +	unsigned short val, ier;
> +
> +	baud = uart_get_baud_rate(port, termios, old, 0, port->uartclk/16);
> +	quot = bfin_serial_calc_baud(port->uartclk, baud);
> +	spin_lock_irqsave(&uart->port.lock, flags);

Doesn't set port.ignore_status_mask nor port.read_status_mask, so *NONE*
of the termios modes to do with error handling will work with this driver.
In fact, I doubt it's possible to even change the parity, length or stop
bit settings as this code stands.

> +
> +	/* Disable UART */
> +	ier = UART_GET_IER(uart);
> +	UART_PUT_IER(uart, 0);
> +
> +	/* Set DLAB in LCR to Access DLL and DLH */
> +	val = UART_GET_LCR(uart);
> +	val |= DLAB;
> +	UART_PUT_LCR(uart, val);
> +	__builtin_bfin_ssync();
> +
> +	UART_PUT_DLL(uart, quot & 0xFF);
> +	__builtin_bfin_ssync();
> +	UART_PUT_DLH(uart, (quot >> 8) & 0xFF);
> +	__builtin_bfin_ssync();
> +	
> +	/* Clear DLAB in LCR to Access THR RBR IER */
> +	val = UART_GET_LCR(uart);
> +	val &= ~DLAB;
> +	UART_PUT_LCR(uart, val);
> +	__builtin_bfin_ssync();
> +
> +	/* Enable UART */
> +	UART_PUT_IER(uart, ier);
> +
> +	val = UART_GET_GCTL(uart);
> +	val |= UCEN;
> +	UART_PUT_GCTL(uart, val);
> +
> +	spin_unlock_irqrestore(&uart->port.lock, flags);
> +}
...
> +static int bfin_serial_calc_baud(unsigned int uartclk, unsigned int baud)
> +{
> +	int quot;
> +
> +	quot = uartclk / (baud * 8);
> +	if ((quot & 0x1) == 1) {
> +		quot++;
> +	}
> +	return quot/2;

Something wrong with the standard function (uart_get_divisor)?  If so, what?

> +}
...
> +#ifdef CONFIG_SERIAL_BFIN_CONSOLE
> +/*
> + * Interrupts are disabled on entering
> + */
> +static void
> +bfin_serial_console_write(struct console *co, const char *s, unsigned int count)
> +{
> +	struct bfin_serial_port *uart = &bfin_serial_ports[co->index];
> +	int flags = 0;
> +	unsigned short status, tmp;
> +	int i;
> +
> +	spin_lock_irqsave(&uart->port.lock, flags);
> +	for (i = 0; i < count; i++) {
> +		do {
> +			status = UART_GET_LSR(uart);
> +		} while (!(status & THRE));
> +
> +		tmp = UART_GET_LCR(uart);
> +		tmp &= ~DLAB;
> +		UART_PUT_LCR(uart, tmp);
> +
> +		UART_PUT_CHAR(uart, s[i]);
> +		if (s[i] == '\n') {
> +			do {
> +				status = UART_GET_LSR(uart);
> +			} while(!(status & THRE));
> +			UART_PUT_CHAR(uart, '\r');
> +		}

Use uart_console_write()

> +	}
> +	spin_unlock_irqrestore(&uart->port.lock, flags);
> +
> +}
> +
> +/*
> + * If the port was already initialised (eg, by a boot loader),
> + * try to determine the current setup.
> + */
> +static void __init
> +bfin_serial_console_get_options(struct bfin_serial_port *uart, int *baud,
> +			   int *parity, int *bits)
> +{
> +	unsigned short status;
> +
> +	status = UART_GET_IER(uart) & (ERBFI | ETBEI);
> +	if (status == (ERBFI | ETBEI)) {
> +		/* ok, the port was enabled */
> +		unsigned short lcr, val;
> +		unsigned short dlh, dll;
> +
> +		lcr = UART_GET_LCR(uart);
> +
> +		*parity = 'n';
> +		if (lcr & PEN) {
> +			if (lcr & EPS)
> +				*parity = 'e';
> +			else
> +				*parity = 'o';
> +		}
> +		switch (lcr & 0x03) {
> +			case 0:	*bits = 5; break;
> +			case 1:	*bits = 6; break;
> +			case 2:	*bits = 7; break;
> +			case 3:	*bits = 8; break;
> +		}

You do have length and parity settings on this port, yet you don't
have code in your set_termios method to set them from the termios...

> +		/* Set DLAB in LCR to Access DLL and DLH */
> +		val = UART_GET_LCR(uart);
> +		val |= DLAB;
> +		UART_PUT_LCR(uart, val);
> +
> +		dll = UART_GET_DLL(uart);
> +		dlh = UART_GET_DLH(uart);
> +
> +		/* Clear DLAB in LCR to Access THR RBR IER */
> +		val = UART_GET_LCR(uart);
> +		val &= ~DLAB;
> +		UART_PUT_LCR(uart, val);
> +
> +		*baud = get_sclk() / (16*(dll | dlh << 8));
> +	}
> +	pr_debug("%s:baud = %d, parity = %c, bits= %d\n", __FUNCTION__, *baud, *parity, *bits);
> +}

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
