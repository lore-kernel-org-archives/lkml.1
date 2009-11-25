Return-Path: <linux-kernel-owner+w=401wt.eu-S934957AbZKYUMH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934957AbZKYUMH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 15:12:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934917AbZKYUMG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 15:12:06 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60999 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933519AbZKYUME (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 15:12:04 -0500
Date: Wed, 25 Nov 2009 12:11:52 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Magnus Damm <magnus.damm@gmail.com>
Cc: spi-devel-general@lists.sourceforge.net, dbrownell@users.sourceforge.net,
       linux-kernel@vger.kernel.org, Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH] spi: SuperH MSIOF SPI Master driver
Message-Id: <20091125121152.4ccf03dc.akpm@linux-foundation.org>
In-Reply-To: <20091124125531.14957.41264.sendpatchset@rxone.opensource.se>
References: <20091124125531.14957.41264.sendpatchset@rxone.opensource.se>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Nov 2009 21:55:31 +0900
Magnus Damm <magnus.damm@gmail.com> wrote:

> From: Magnus Damm <damm@opensource.se>
> 
> This patch adds SPI Master support for the SuperH MSIOF
> hardware block. Full duplex, spi mode 0-3, active high cs,
> 3-wire and lsb first should all be supported, but the driver
> has so far only been tested with "mmc_spi".
> 
> The MSIOF hardware comes with 32-bit FIFOs for receive and
> transmit, and this driver simply breaks the SPI messages
> into FIFO-sized chunks. The MSIOF hardware manages the pins
> for clock, receive and transmit (sck/miso/mosi), but the chip
> select pin is managed by software and must be configured as
> a regular GPIO pin by the board code.
> 
> Performance wise there is still room for improvement, but
> on a Ecovec board with the built-in sh7724 MSIOF0 this driver
> gets Mini-sd read speeds of about half a megabyte per second.
> 
> Future work include better clock setup and merging of 8-bit
> transfers into 32-bit words to reduce interrupt load and
> improve throughput.
> 
>
> ...
>
> --- 0001/drivers/spi/spi.c
> +++ work/drivers/spi/spi.c	2009-11-24 20:39:48.000000000 +0900
> @@ -17,7 +17,6 @@
>   * along with this program; if not, write to the Free Software
>   * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
>   */
> -
>  #include <linux/kernel.h>
>  #include <linux/device.h>
>  #include <linux/init.h>

whoops?

> --- /dev/null
> +++ work/drivers/spi/spi_sh_msiof.c	2009-11-24 20:39:49.000000000 +0900
> @@ -0,0 +1,675 @@
> +/*
> + * SuperH MSIOF SPI Master Interface
> + *
> + * Copyright (c) 2009 Magnus Damm
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + */
> +
> +#include <linux/kernel.h>

But not consistently.

> +#include <linux/init.h>
> +#include <linux/delay.h>
> +#include <linux/interrupt.h>
> +#include <linux/platform_device.h>
> +#include <linux/completion.h>
> +#include <linux/pm_runtime.h>
> +#include <linux/gpio.h>
> +#include <linux/bitmap.h>
> +#include <linux/clk.h>
> +#include <linux/io.h>
> +
> +#include <linux/spi/spi.h>
> +#include <linux/spi/spi_bitbang.h>
> +#include <linux/spi/sh_msiof.h>
> +
> +#include <asm/spi.h>
> +#include <asm/unaligned.h>
> +
> +struct sh_msiof_spi_priv {
> +	struct spi_bitbang bitbang; /* must be first for spi_bitbang.c */

Well if that's the case then spi_bitbang.c needs smacking.  What causes
this requirement?

> +	void __iomem *mapbase;
> +	struct clk *clk;
> +	struct platform_device *pdev;
> +	struct sh_msiof_spi_info *info;
> +	struct completion done;
> +	unsigned long flags;
> +	int tx_fifo_size;
> +	int rx_fifo_size;
> +};
> +
>
> ...
>
> +static void sh_msiof_modify_ctr_wait(struct sh_msiof_spi_priv *p,
> +				     unsigned long clr, unsigned long set)
> +{
> +	unsigned long mask = clr | set;
> +	unsigned long data;
> +
> +	data = sh_msiof_read(p, CTR);
> +	data &= ~clr;
> +	data |= set;
> +	sh_msiof_write(p, CTR, data);
> +
> +	while ((sh_msiof_read(p, CTR) & mask) != set)
> +		;

hm, confidence.  No timeout needed here?

> +}
> +
> +static irqreturn_t sh_msiof_spi_irq(int irq, void *data)
> +{
> +	struct sh_msiof_spi_priv *p = data;
> +
> +	/* just disable the interrupt and wake up */
> +	sh_msiof_write(p, IER, 0);
> +
> +	complete(&p->done);
> +
> +	return IRQ_HANDLED;
> +}
> +
> +static struct {
> +	unsigned short div;
> +	unsigned short scr;
> +} sh_msiof_spi_clk_table[] = {
> +	{ 1, 0x0007 },
> +	{ 2, 0x0000 },
> +	{ 4, 0x0001 },
> +	{ 8, 0x0002 },
> +	{ 16, 0x0003 },
> +	{ 32, 0x0004 },
> +	{ 64, 0x1f00 },
> +	{ 128, 0x1f01 },
> +	{ 256, 0x1f02 },
> +	{ 512, 0x1f03 },
> +	{ 1024, 0x1f04 },
> +};

Could be const (to save some .data) btu I think the compiler does that
itself nowadays.

> +static void sh_msiof_spi_set_clk_regs(struct sh_msiof_spi_priv *p,
> +				      unsigned long parent_rate,
> +				      unsigned long spi_hz)
> +{
> +	unsigned long div = 1024;
> +	int k;
> +
> +	if (!spi_hz || !parent_rate)
> +		WARN_ON(1);
> +	else
> +		div = parent_rate / spi_hz;

This could be more neatly coded as

	if (!WARN_ON(!spi_hz || !parent_rate))
		div = parent_rate / spi_hz;

also, if this warning ever triggers, you won't know whether it was due
to !spi_hx or to !parent_rate, which might make you sad.

Can spi_hz and parent_rate ever be zero here anyway?  If not, zap it. 
If so, why?  Programming bug?

> +	/* TODO: make more fine grained */
> +
> +	for (k = 0; k < ARRAY_SIZE(sh_msiof_spi_clk_table); k++) {
> +		if (sh_msiof_spi_clk_table[k].div >= div)
> +			break;
> +	}
> +
> +	k = min_t(int, k, ARRAY_SIZE(sh_msiof_spi_clk_table) - 1);

actually it's pretty obvious from all the above that k should have been
size_t.

> +	sh_msiof_write(p, TSCR, sh_msiof_spi_clk_table[k].scr);
> +	sh_msiof_write(p, RSCR, sh_msiof_spi_clk_table[k].scr);
> +}
> +
> +static void sh_msiof_spi_set_pin_regs(struct sh_msiof_spi_priv *p,
> +				      int cpol, int cpha,
> +				      int tx_hi_z, int lsb_first)
> +{
> +	unsigned long tmp;
> +	int edge;
> +
> +	/*
> +	 * CPOL CPHA     TSCKIZ RSCKIZ TEDG REDG(!)
> +	 *    0    0         10     10    1    0
> +	 *    0    1         10     10    0    1
> +	 *    1    0         11     11    0    1
> +	 *    1    1         11     11    1    0
> +	 *
> +	 * (!) Note: REDG is inverted recommended data sheet setting
> +	 */
> +
> +	sh_msiof_write(p, FCTR, 0);
> +	sh_msiof_write(p, TMDR1, 0xe2000005 | (lsb_first << 24));
> +	sh_msiof_write(p, RMDR1, 0x22000005 | (lsb_first << 24));
> +
> +	tmp = 0xa0000000;
> +	tmp |= cpol << 30; /* TSCKIZ */
> +	tmp |= cpol << 28; /* RSCKIZ */
> +
> +	edge = cpol ? cpha : !cpha;
> +
> +	tmp |= edge << 27; /* TEDG */
> +	tmp |= !edge << 26; /* REDG */

um, OK.  This mixture of logical-not with bit-operations is a bit woozy
but I don't see any actual bugs there.

> +	tmp |= (tx_hi_z ? 2 : 0) << 22; /* TXDIZ */
> +	sh_msiof_write(p, CTR, tmp);
> +}
> +
>
> ...
>
> +static u32 sh_msiof_spi_txrx_word(struct spi_device *spi, unsigned nsecs,
> +				  u32 word, u8 bits)
> +{
> +	BUG_ON(1); /* unused but needed by bitbang code */

	BUG();

> +	return 0;
> +}
> +
>
> ...
>

