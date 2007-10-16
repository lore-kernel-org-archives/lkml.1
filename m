Return-Path: <linux-kernel-owner+w=401wt.eu-S933837AbXJPRqg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933837AbXJPRqg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 13:46:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755958AbXJPRq2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 13:46:28 -0400
Received: from mba.ocn.ne.jp ([122.1.235.107]:54072 "EHLO smtp.mba.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752966AbXJPRq1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 13:46:27 -0400
Date: Wed, 17 Oct 2007 02:48:12 +0900 (JST)
Message-Id: <20071017.024812.11596022.anemo@mba.ocn.ne.jp>
To: jason.wessel@windriver.com
Cc: linux-kernel@vger.kernel.org, ralf@linux-mips.org
Subject: Re: [PATCH 9/21] KGDB: This adds basic support to the MIPS
 architecture
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
In-Reply-To: <4713B263.5090909@windriver.com>
	<mailman.0.1192554001.20421.linux-kernel-daily-digest@lists.us.dell.com>
References: <4713B263.5090909@windriver.com>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 5.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Oct 2007 13:33:07 -0500, Jason Wessel <jason.wessel@windriver.com> wrote:
> --- /dev/null
> +++ b/drivers/serial/serial_txx9_kgdb.c
> @@ -0,0 +1,152 @@

Thank you for attempting to mainline it.  I have some cosmetic comments.

> +static inline unsigned int sio_in(struct uart_port *port, int offset)
> +{
> +	return *(volatile u32 *)(port->membase + offset);
> +}
> +
> +static inline void sio_out(struct uart_port *port, int offset,
> +	unsigned int value)
> +{
> +	*(volatile u32 *)(port->membase + offset) = value;
> +}

It would be better to avoid volatile.

static inline unsigned int sio_in(struct uart_port *port, int offset)
{
	return __raw_readl(port->membase + offset);
}

static inline void sio_out(struct uart_port *port, int offset,
	unsigned int value)
{
	__raw_writel(value, port->membase + offset);
}

> +	/* Reset the UART. */
> +	sio_out(kgdb_port, TXX9_SIFCR, TXX9_SIFCR_SWRST);
> +#ifdef CONFIG_CPU_TX49XX
> +	/*
> +	 * TX4925 BUG WORKAROUND.  Accessing SIOC register
> +	 * immediately after soft reset causes bus error.
> +	 */
> +	iob();
> +	udelay(1);
> +#endif
> +	/* Wait until reset is complete. */
> +	while (sio_in(kgdb_port, TXX9_SIFCR) & TXX9_SIFCR_SWRST);

A while ago, this part of serial_txx9.c was changed a bit (no ifdefs,
avoid endless loop).  Could you change it to:

	unsigned int tmout = 10000;

	sio_out(kgdb_port, TXX9_SIFCR, TXX9_SIFCR_SWRST);
	/* TX4925 BUG WORKAROUND.  Accessing SIOC register
	 * immediately after soft reset causes bus error. */
	mmiowb();
	udelay(1);
	while ((sio_in(kgdb_port, TXX9_SIFCR) & TXX9_SIFCR_SWRST) && --tmout)
		udelay(1);

> +	/* Select the input clock prescaler that fits the baud rate. */
> +	quot = (kgdb_port->uartclk + 8 * kgdb_txx9_baud) /
> +		(16 * kgdb_txx9_baud);

uart_get_divisor() can be used here:

	quot = uart_get_divisor(kgdb_port, kgdb_txx9_baud);

> +	if (quot < (256 << 1))
> +		sibgr = (quot >> 1) | TXX9_SIBGR_BCLK_T0;
> +	else if (quot < ( 256 << 3))
> +		sibgr = (quot >> 3) | TXX9_SIBGR_BCLK_T2;
> +	else if (quot < ( 256 << 5))
> +		sibgr = (quot >> 5) | TXX9_SIBGR_BCLK_T4;
> +	else if (quot < ( 256 << 7))
> +		sibgr = (quot >> 7) | TXX9_SIBGR_BCLK_T6;
> +	else
> +		sibgr = 0xff | TXX9_SIBGR_BCLK_T6;

It would be better to do it more similar to serial_txx9.c:

	quot >>= 1;
	if (quot < 256)
		sibgr = quot | TXX9_SIBGR_BCLK_T0;
	else if (quot < (256 << 2))
		sibgr = (quot >> 2) | TXX9_SIBGR_BCLK_T2;
	else if (quot < (256 << 4))
		sibgr = (quot >> 4) | TXX9_SIBGR_BCLK_T4;
	else if (quot < (256 << 6))
		sibgr = (quot >> 6) | TXX9_SIBGR_BCLK_T6;
	else
		sibgr = 0xff | TXX9_SIBGR_BCLK_T6;

---
Atsushi Nemoto
