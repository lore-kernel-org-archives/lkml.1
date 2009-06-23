Return-Path: <linux-kernel-owner+w=401wt.eu-S1758501AbZFWXMU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758501AbZFWXMU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 19:12:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754021AbZFWXMG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 19:12:06 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40838 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756308AbZFWXMF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 19:12:05 -0400
Date: Tue, 23 Jun 2009 16:11:51 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, david-b@pacbell.net, s.hauer@pengutronix.de
Subject: Re: [PATCH 2/2] SPI: Add SPI driver for most known i.MX SoCs
Message-Id: <20090623161151.e77a6700.akpm@linux-foundation.org>
In-Reply-To: <1245308072-14392-3-git-send-email-s.hauer@pengutronix.de>
References: <1245308072-14392-1-git-send-email-s.hauer@pengutronix.de>
	<1245308072-14392-2-git-send-email-s.hauer@pengutronix.de>
	<1245308072-14392-3-git-send-email-s.hauer@pengutronix.de>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Jun 2009 08:54:32 +0200
Sascha Hauer <s.hauer@pengutronix.de> wrote:

> v2: Updated and tested on i.MX35
> 
> While there already is a SPI driver for i.MX1 in the tree there are
> good reasons to replace it:
> 
> - The inkernel driver implements a full blown SPI driver, but
>   the hardware can be fully supported using a bitbang driver.
>   This greatly reduces the size and complexity of the driver.
> - The inkernel driver only works on i.MX1 SoCs. Unfortunately
>   Freescale decided to randomly mix the register bits for each
>   new SoC, This is quite hard to handle with the current driver
>   since it has register accesses in many places.
> - The DMA API of the durrent driver is broken for arch-mx1 (as opposed
>   to arch-imx) and nobody cared to fix it yet.

ah, there's some detail.  I'l move this into the changelog for
spi-remove-imx-spi-driver.patch.

Still, it seesm that the current driver does work for some people. 
Removing it in this manner seems a bit risky.  Unnecessarily risky?

> This driver has been tested on i.MX1/i.MX27/i.MX35 with an AT25 type
> EEPROM and on i.MX27/i.MX31 with a Freescale MC13783 PMIC.
> 
> Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
> Tested-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
>
> ...
>
> +#define MXC_SPI_BUF_RX(type)						\
> +static void mxc_spi_buf_rx_##type(struct mxc_spi_data *mxc_spi)		\
> +{									\
> +	unsigned int val = readl(mxc_spi->base + MXC_CSPIRXDATA);	\
> +									\
> +	if (mxc_spi->rx_buf) {						\
> +		*(type *)mxc_spi->rx_buf = val;				\
> +		mxc_spi->rx_buf += sizeof(type);			\
> +	}								\
> +}
> +
> +#define MXC_SPI_BUF_TX(type)						\
> +static void mxc_spi_buf_tx_##type(struct mxc_spi_data *mxc_spi)		\
> +{									\
> +	type val = 0;							\
> +									\
> +	if (mxc_spi->tx_buf) {						\
> +		val = *(type *)mxc_spi->tx_buf;				\

Are these operations endian-safe?  Seems not.  Should they be?  It
would be pretty simple to do.

> +		mxc_spi->tx_buf += sizeof(type);			\
> +	}								\
> +									\
> +	mxc_spi->count -= sizeof(type);					\
> +									\
> +	writel(val, mxc_spi->base + MXC_CSPITXDATA);			\
> +}
> +
> +MXC_SPI_BUF_RX(u8)
> +MXC_SPI_BUF_TX(u8)
> +MXC_SPI_BUF_RX(u16)
> +MXC_SPI_BUF_TX(u16)
> +MXC_SPI_BUF_RX(u32)
> +MXC_SPI_BUF_TX(u32)
> +
> +/* First entry is reserved, second entry is valid only if SDHC_SPIEN is set
> + * (which is currently not the case in this driver)
> + */
> +static int mxc_clkdivs[] = {0, 3, 4, 6, 8, 12, 16, 24, 32, 48, 64, 96, 128, 192,
> +	256, 384, 512, 768, 1024};

Could be made const - it's slightly preferable to have data in
read-only locations if possible.  It means that we'll get a nice oops
if someone accidentally writes to them and sometimes it means that the
data doesn't need to be copied out to read/write memory at boot-time.

Perhaps the compiler does this anyway.

>
> ...
>
> +static void mx27_trigger(struct mxc_spi_data *mxc_spi)
> +{
> +	unsigned int reg;
> +
> +	reg = readl(mxc_spi->base + MXC_CSPICTRL);
> +	reg |= MX27_CSPICTRL_XCH;
> +	writel(reg, mxc_spi->base + MXC_CSPICTRL);
> +}

This all looks rather SMP/preempt/interrupt-unsafe.  Or does the SPI core
provide the needed locking?

> +static int mx27_config(struct mxc_spi_data *mxc_spi,
> +		struct mxc_spi_config *config)
> +{
> +	unsigned int reg = MX27_CSPICTRL_ENABLE | MX27_CSPICTRL_MASTER;
> +
> +	reg |= mxc_spi_clkdiv_1(mxc_spi->spi_clk, config->speed_hz) <<
> +		MX27_CSPICTRL_DR_SHIFT;
> +	reg |= config->bpw - 1;
> +
> +	if (config->mode & SPI_CPHA)
> +		reg |= MX27_CSPICTRL_PHA;
> +	if (config->mode & SPI_CPOL)
> +		reg |= MX27_CSPICTRL_POL;
> +	if (config->mode & SPI_CS_HIGH)
> +		reg |= MX27_CSPICTRL_SSPOL;
> +	if (config->cs < 0)
> +		reg |= (config->cs + 32) << MX27_CSPICTRL_CS_SHIFT;
> +
> +	writel(reg, mxc_spi->base + MXC_CSPICTRL);
> +
> +	return 0;
> +}

Dittoes everywhere.

> +static int mx27_rx_available(struct mxc_spi_data *mxc_spi)
> +{
> +	return readl(mxc_spi->base + MXC_CSPIINT) & MX27_INTREG_RR;
> +}
> +
>
> ...
>
> +static int __init mxc_spi_probe(struct platform_device *pdev)
> +{
> +	struct spi_imx_master *mxc_platform_info;
> +	struct spi_master *master;
> +	struct mxc_spi_data *mxc_spi;
> +	struct resource *res;
> +	int i, ret;
> +
> +	mxc_platform_info = (struct spi_imx_master *)pdev->dev.platform_data;

Unneeded and undesirable cast of a void*.

> +	if (!mxc_platform_info) {
> +		dev_err(&pdev->dev, "can't get the platform data\n");
> +		return -EINVAL;

Can this happen?

> +	}
> +
> +	master = spi_alloc_master(&pdev->dev, sizeof(struct mxc_spi_data));
> +	if (!master)
> +		return -ENOMEM;
> +
>
> ...
>
