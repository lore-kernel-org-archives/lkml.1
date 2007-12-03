Return-Path: <linux-kernel-owner+w=401wt.eu-S1752214AbXLCXyZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752214AbXLCXyZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 18:54:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750964AbXLCXyR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 18:54:17 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36454 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750808AbXLCXyQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 18:54:16 -0500
Date: Mon, 3 Dec 2007 15:53:17 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: linux-kernel@vger.kernel.org, linux-mips@linux-mips.org,
       Andy Whitcroft <apw@shadowen.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] SC26XX: New serial driver for SC2681 uarts
Message-Id: <20071203155317.772231f9.akpm@linux-foundation.org>
In-Reply-To: <20071202194346.36E3FDE4C4@solo.franken.de>
References: <20071202194346.36E3FDE4C4@solo.franken.de>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun,  2 Dec 2007 20:43:46 +0100 (CET)
Thomas Bogendoerfer <tsbogend@alpha.franken.de> wrote:

> New serial driver for SC2681/SC2691 uarts. Older SNI RM400 machines are
> using these chips for onboard serial ports.
> 

Little things...

> --- /dev/null
> +++ b/drivers/serial/sc26xx.c
> @@ -0,0 +1,757 @@
> +/*
> + * SC268xx.c: Serial driver for Philiphs SC2681/SC2692 devices.
> + *
> + * Copyright (C) 2006,2007 Thomas Bogend__rfer (tsbogend@alpha.franken.de)
> + */
> +
> +#include <linux/module.h>
> +#include <linux/kernel.h>
> +#include <linux/errno.h>
> +#include <linux/tty.h>
> +#include <linux/tty_flip.h>
> +#include <linux/major.h>
> +#include <linux/circ_buf.h>
> +#include <linux/serial.h>
> +#include <linux/sysrq.h>
> +#include <linux/console.h>
> +#include <linux/spinlock.h>
> +#include <linux/slab.h>
> +#include <linux/delay.h>
> +#include <linux/init.h>
> +#include <linux/platform_device.h>
> +#include <linux/irq.h>
> +
> +#if defined(CONFIG_MAGIC_SYSRQ)
> +#define SUPPORT_SYSRQ
> +#endif
> +
> +#include <linux/serial_core.h>
> +
> +#define SC26XX_MAJOR         204
> +#define SC26XX_MINOR_START   205
> +#define SC26XX_NR            2
> +
> +struct uart_sc26xx_port {
> +	struct uart_port      port[2];
> +	u8     dsr_mask[2];
> +	u8     cts_mask[2];
> +	u8     dcd_mask[2];
> +	u8     ri_mask[2];
> +	u8     dtr_mask[2];
> +	u8     rts_mask[2];
> +	u8     imr;
> +};
> +
> +/* register common to both ports */
> +#define RD_ISR      0x14
> +#define RD_IPR      0x34
> +
> +#define WR_ACR      0x10
> +#define WR_IMR      0x14
> +#define WR_OPCR     0x34
> +#define WR_OPR_SET  0x38
> +#define WR_OPR_CLR  0x3C
> +
> +/* access common register */
> +#define READ_SC(p, r)        readb ((p)->membase + RD_##r)
> +#define WRITE_SC(p, r, v)    writeb ((v), (p)->membase + WR_##r)

No space before the (.  checkpatch misses this.

> +/* register per port */
> +#define RD_PORT_MRx 0x00
> +#define RD_PORT_SR  0x04
> +#define RD_PORT_RHR 0x0c
> +
> +#define WR_PORT_MRx 0x00
> +#define WR_PORT_CSR 0x04
> +#define WR_PORT_CR  0x08
> +#define WR_PORT_THR 0x0c
> +
> +/* access port register */
> +#define READ_SC_PORT(p, r)     \
> +		readb((p)->membase + (p)->line * 0x20 + RD_PORT_##r)
> +#define WRITE_SC_PORT(p, r, v) \
> +		writeb((v), (p)->membase + (p)->line * 0x20 + WR_PORT_##r)

eww, ugly.  Why not have a nice C function which is passed RD_PORT_SR,
RD_PORT_RHR, etc?

That has the (minor) advantage that it won't malfunction if someone does

	WRITE_SC_PORT(foo++, r, v);

(the macro references an arg more than once)

> +/* SR bits */
> +#define SR_BREAK    (1 << 7)
> +#define SR_FRAME    (1 << 6)
> +#define SR_PARITY   (1 << 5)
> +#define SR_OVERRUN  (1 << 4)
> +#define SR_TXRDY    (1 << 2)
> +#define SR_RXRDY    (1 << 0)
> +
> +#define CR_RES_MR   (1 << 4)
> +#define CR_RES_RX   (2 << 4)
> +#define CR_RES_TX   (3 << 4)
> +#define CR_STRT_BRK (6 << 4)
> +#define CR_STOP_BRK (7 << 4)
> +#define CR_DIS_TX   (1 << 3)
> +#define CR_ENA_TX   (1 << 2)
> +#define CR_DIS_RX   (1 << 1)
> +#define CR_ENA_RX   (1 << 0)
> +
> +/* ISR bits */
> +#define ISR_RXRDYB  (1 << 5)
> +#define ISR_TXRDYB  (1 << 4)
> +#define ISR_RXRDYA  (1 << 1)
> +#define ISR_TXRDYA  (1 << 0)
> +
> +/* IMR bits */
> +#define IMR_RXRDY   (1 << 1)
> +#define IMR_TXRDY   (1 << 0)
> +
> +static void sc26xx_enable_irq(struct uart_port *port, int mask)
> +{
> +	struct uart_sc26xx_port *up;
> +	int line = port->line;
> +
> +	port -= line;
> +	up = (struct uart_sc26xx_port *)port;

Yeah, lots of serial drivers do this and it's old-fashioned.  It would be
clearer to use container_of() rather than the open-coded typecast.  That
way, the uart_port doesn't need to be the first member of uart_sc26xx_port,
too.


> +	up->imr |= mask << (line * 4);
> +	WRITE_SC(port, IMR, up->imr);
> +}
>
> ...
>
> +
> +/* port->lock is not held.  */
> +static unsigned int sc26xx_tx_empty(struct uart_port *port)
> +{
> +	unsigned long flags;
> +	unsigned int ret;
> +
> +	spin_lock_irqsave(&port->lock, flags);
> +	ret = (READ_SC_PORT(port, SR) & SR_TXRDY) ? TIOCSER_TEMT : 0;
> +	spin_unlock_irqrestore(&port->lock, flags);
> +	return ret;
> +}

I suspect the locking here doesn't actually do anything?

> +/* port->lock is not held.  */
> +static void sc26xx_set_termios(struct uart_port *port, struct ktermios *termios,
> +			      struct ktermios *old)

hm, termios stuff.  I'll cc Alan on the commit...

> +static struct uart_port *sc26xx_port;
> +
> +#ifdef CONFIG_SERIAL_SC26XX_CONSOLE
> +static inline void sc26xx_console_putchar(struct uart_port *port, char c)
> +{
> +	unsigned long flags;
> +	int limit = 1000000;
> +
> +	spin_lock_irqsave(&port->lock, flags);
> +
> +	while (limit-- > 0) {
> +		if (READ_SC_PORT(port, SR) & SR_TXRDY) {
> +			WRITE_SC_PORT(port, THR, c);
> +			break;
> +		}
> +		udelay(2);
> +	}
> +
> +	spin_unlock_irqrestore(&port->lock, flags);
> +}

This is far too large to be inlined.

> +static void sc26xx_console_write(struct console *con, const char *s, unsigned n)
> +{
> +	struct uart_port *port = sc26xx_port;
> +	int i;
> +
> +	for (i = 0; i < n; i++) {
> +		if (*s == '\n')
> +			sc26xx_console_putchar(port, '\r');
> +		sc26xx_console_putchar(port, *s++);
> +	}
> +}
> +
> +static int __init sc26xx_console_setup(struct console *con, char *options)
> +{
> +	struct uart_port *port = sc26xx_port;
> +	int baud = 9600;
> +	int bits = 8;
> +	int parity = 'n';
> +	int flow = 'n';
> +
> +	if (port->type != PORT_SC26XX)
> +		return -1;
> +
> +	printk(KERN_INFO "Console: ttySC%d (SC26XX)\n", con->index);
> +	if (options)
> +		uart_parse_options(options, &baud, &parity, &bits, &flow);
> +
> +	return uart_set_options(port, con, baud, parity, bits, flow);
> +}
> +
> +static struct uart_driver sc26xx_reg;
> +static struct console sc26xx_console = {
> +	.name	=	"ttySC",
> +	.write	=	sc26xx_console_write,
> +	.device	=	uart_console_device,
> +	.setup  =       sc26xx_console_setup,
> +	.flags	=	CON_PRINTBUFFER,
> +	.index	=	-1,
> +	.data	=	&sc26xx_reg,
> +};
> +#define SC26XX_CONSOLE   &sc26xx_console
> +#else
> +#define SC26XX_CONSOLE   NULL
> +#endif
> +
> +static struct uart_driver sc26xx_reg = {
> +	.owner			= THIS_MODULE,
> +	.driver_name		= "SC26xx",
> +	.dev_name		= "ttySC",
> +	.major			= SC26XX_MAJOR,
> +	.minor			= SC26XX_MINOR_START,
> +	.nr			= SC26XX_NR,
> +	.cons                   = SC26XX_CONSOLE,
> +};
> +
> +static inline u8 sc26xx_flags2mask(unsigned int flags, unsigned int bitpos)
> +{
> +	unsigned int bit = (flags >> bitpos) & 15;
> +
> +	return bit ? (1 << (bit - 1)) : 0;
> +}

This might be too big as well.  It's less of an issue for __devinit text
though.


