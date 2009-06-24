Return-Path: <linux-kernel-owner+w=401wt.eu-S1757366AbZFXJJV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757366AbZFXJJV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 05:09:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755980AbZFXJJG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 05:09:06 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:52624 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757216AbZFXJJC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 05:09:02 -0400
Date: Wed, 24 Jun 2009 11:09:02 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, david-b@pacbell.net
Subject: Re: [PATCH 2/2] SPI: Add SPI driver for most known i.MX SoCs
Message-ID: <20090624090902.GV31396@pengutronix.de>
References: <1245308072-14392-1-git-send-email-s.hauer@pengutronix.de> <1245308072-14392-2-git-send-email-s.hauer@pengutronix.de> <1245308072-14392-3-git-send-email-s.hauer@pengutronix.de> <20090623161151.e77a6700.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090623161151.e77a6700.akpm@linux-foundation.org>
X-Sent-From: Pengutronix Entwicklungszentrum Nord - Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Impressum: Pengutronix - Linux Solutions for Science and Industry
	Handelsregister:  Amtsgericht Hildesheim, HRA 2686 Peiner Strasse
	6-8, 31137 Hildesheim, Germany Phone: +49-5121-206917-0 |  Fax:
	+49-5121-206917-5555 Inhaber: Dipl.-Ing. Robert Schwebel
X-Message-Flag: See Message Headers for Impressum
X-Uptime: 09:44:28 up 43 days, 22:08, 14 users,  load average: 0.08, 0.03,
	0.01
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 23, 2009 at 04:11:51PM -0700, Andrew Morton wrote:
> On Thu, 18 Jun 2009 08:54:32 +0200
> Sascha Hauer <s.hauer@pengutronix.de> wrote:
> 
> > v2: Updated and tested on i.MX35
> > 
> > While there already is a SPI driver for i.MX1 in the tree there are
> > good reasons to replace it:
> > 
> > - The inkernel driver implements a full blown SPI driver, but
> >   the hardware can be fully supported using a bitbang driver.
> >   This greatly reduces the size and complexity of the driver.
> > - The inkernel driver only works on i.MX1 SoCs. Unfortunately
> >   Freescale decided to randomly mix the register bits for each
> >   new SoC, This is quite hard to handle with the current driver
> >   since it has register accesses in many places.
> > - The DMA API of the durrent driver is broken for arch-mx1 (as opposed
> >   to arch-imx) and nobody cared to fix it yet.
> 
> ah, there's some detail.  I'l move this into the changelog for
> spi-remove-imx-spi-driver.patch.
> 
> Still, it seesm that the current driver does work for some people. 
> Removing it in this manner seems a bit risky.  Unnecessarily risky?

ATM the old driver does not even compile, but we could keep both drivers
parallel for some time to see if somebody cares to fix it.

> 
> > This driver has been tested on i.MX1/i.MX27/i.MX35 with an AT25 type
> > EEPROM and on i.MX27/i.MX31 with a Freescale MC13783 PMIC.
> > 
> > Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
> > Tested-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> >
> > ...
> >
> > +#define MXC_SPI_BUF_RX(type)						\
> > +static void mxc_spi_buf_rx_##type(struct mxc_spi_data *mxc_spi)		\
> > +{									\
> > +	unsigned int val = readl(mxc_spi->base + MXC_CSPIRXDATA);	\
> > +									\
> > +	if (mxc_spi->rx_buf) {						\
> > +		*(type *)mxc_spi->rx_buf = val;				\
> > +		mxc_spi->rx_buf += sizeof(type);			\
> > +	}								\
> > +}
> > +
> > +#define MXC_SPI_BUF_TX(type)						\
> > +static void mxc_spi_buf_tx_##type(struct mxc_spi_data *mxc_spi)		\
> > +{									\
> > +	type val = 0;							\
> > +									\
> > +	if (mxc_spi->tx_buf) {						\
> > +		val = *(type *)mxc_spi->tx_buf;				\
> 
> Are these operations endian-safe?  Seems not.  Should they be?  It
> would be pretty simple to do.

Honestly, I don't know if they should be endian-safe. So far i.MX only
works in little endian mode on Linux. I prefer making these functions
being obviously not endian-safe rather than pretending that I really
know what I'm doing.

> 
> > +		mxc_spi->tx_buf += sizeof(type);			\
> > +	}								\
> > +									\
> > +	mxc_spi->count -= sizeof(type);					\
> > +									\
> > +	writel(val, mxc_spi->base + MXC_CSPITXDATA);			\
> > +}
> > +
> > +MXC_SPI_BUF_RX(u8)
> > +MXC_SPI_BUF_TX(u8)
> > +MXC_SPI_BUF_RX(u16)
> > +MXC_SPI_BUF_TX(u16)
> > +MXC_SPI_BUF_RX(u32)
> > +MXC_SPI_BUF_TX(u32)
> > +
> > +/* First entry is reserved, second entry is valid only if SDHC_SPIEN is set
> > + * (which is currently not the case in this driver)
> > + */
> > +static int mxc_clkdivs[] = {0, 3, 4, 6, 8, 12, 16, 24, 32, 48, 64, 96, 128, 192,
> > +	256, 384, 512, 768, 1024};
> 
> Could be made const - it's slightly preferable to have data in
> read-only locations if possible.  It means that we'll get a nice oops
> if someone accidentally writes to them and sometimes it means that the
> data doesn't need to be copied out to read/write memory at boot-time.
> 
> Perhaps the compiler does this anyway.

Ok, I'll change this.

> 
> >
> > ...
> >
> > +static void mx27_trigger(struct mxc_spi_data *mxc_spi)
> > +{
> > +	unsigned int reg;
> > +
> > +	reg = readl(mxc_spi->base + MXC_CSPICTRL);
> > +	reg |= MX27_CSPICTRL_XCH;
> > +	writel(reg, mxc_spi->base + MXC_CSPICTRL);
> > +}
> 
> This all looks rather SMP/preempt/interrupt-unsafe.  Or does the SPI core
> provide the needed locking?

The spi core serialises accesses to the driver. The trigger/config
functions are only called with chip interrupts disabled or from the
interrupt handler. I think it should be safe.

> 
> > +static int mx27_config(struct mxc_spi_data *mxc_spi,
> > +		struct mxc_spi_config *config)
> > +{
> > +	unsigned int reg = MX27_CSPICTRL_ENABLE | MX27_CSPICTRL_MASTER;
> > +
> > +	reg |= mxc_spi_clkdiv_1(mxc_spi->spi_clk, config->speed_hz) <<
> > +		MX27_CSPICTRL_DR_SHIFT;
> > +	reg |= config->bpw - 1;
> > +
> > +	if (config->mode & SPI_CPHA)
> > +		reg |= MX27_CSPICTRL_PHA;
> > +	if (config->mode & SPI_CPOL)
> > +		reg |= MX27_CSPICTRL_POL;
> > +	if (config->mode & SPI_CS_HIGH)
> > +		reg |= MX27_CSPICTRL_SSPOL;
> > +	if (config->cs < 0)
> > +		reg |= (config->cs + 32) << MX27_CSPICTRL_CS_SHIFT;
> > +
> > +	writel(reg, mxc_spi->base + MXC_CSPICTRL);
> > +
> > +	return 0;
> > +}
> 
> Dittoes everywhere.
> 
> > +static int mx27_rx_available(struct mxc_spi_data *mxc_spi)
> > +{
> > +	return readl(mxc_spi->base + MXC_CSPIINT) & MX27_INTREG_RR;
> > +}
> > +
> >
> > ...
> >
> > +static int __init mxc_spi_probe(struct platform_device *pdev)
> > +{
> > +	struct spi_imx_master *mxc_platform_info;
> > +	struct spi_master *master;
> > +	struct mxc_spi_data *mxc_spi;
> > +	struct resource *res;
> > +	int i, ret;
> > +
> > +	mxc_platform_info = (struct spi_imx_master *)pdev->dev.platform_data;
> 
> Unneeded and undesirable cast of a void*.

Ok,

> 
> > +	if (!mxc_platform_info) {
> > +		dev_err(&pdev->dev, "can't get the platform data\n");
> > +		return -EINVAL;
> 
> Can this happen?

Yes, it happens when the platform code doesn't provide platform data.

Sascha


-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
