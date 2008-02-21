Return-Path: <linux-kernel-owner+w=401wt.eu-S1765181AbYBUMFm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765181AbYBUMFm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 07:05:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752154AbYBUMFa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 07:05:30 -0500
Received: from smtp-104-thursday.noc.nerim.net ([62.4.17.104]:1689 "EHLO
	mallaury.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752148AbYBUMF0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 07:05:26 -0500
Date: Thu, 21 Feb 2008 13:05:20 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Jochen Friedrich <jochen@scram.de>
Cc: Scott Wood <scottwood@freescale.com>,
       Kumar Gala <galak@kernel.crashing.org>,
       Vitaly Bordug <vitb@kernel.crashing.org>, linux-kernel@vger.kernel.org,
       linuxppc-dev list <linuxppc-dev@ozlabs.org>, i2c@lm-sensors.org
Subject: Re: [PATCHv4 2.6.25] i2c: adds support for i2c bus on Freescale
 CPM1/CPM2 controllers
Message-ID: <20080221130520.12b01553@hyperion.delvare>
In-Reply-To: <47A1C4E9.4000003@scram.de>
References: <47A1C4E9.4000003@scram.de>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hallo Jochen,

On Thu, 31 Jan 2008 13:54:01 +0100, Jochen Friedrich wrote:
> Using the port of 2.4 code from Vitaly Bordug <vitb@kernel.crashing.org>
> and the actual algorithm used by the i2c driver of the DBox code on
> cvs.tuxboc.org from Tmbinc, Gillem (htoa@gmx.net). Renamed i2c-rpx.c and
> i2c-algo-8xx.c to i2c-cpm.c and converted the driver to an
> of_platform_driver.
> 
> Signed-off-by: Jochen Friedrich <jochen@scram.de>
> ---
>  drivers/i2c/busses/Kconfig   |   10 +
>  drivers/i2c/busses/Makefile  |    1 +
>  drivers/i2c/busses/i2c-cpm.c |  759 ++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 770 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/i2c/busses/i2c-cpm.c
> 
> diff --git a/drivers/i2c/busses/Kconfig b/drivers/i2c/busses/Kconfig
> index b61f56b..1d18db7 100644
> --- a/drivers/i2c/busses/Kconfig
> +++ b/drivers/i2c/busses/Kconfig
> @@ -114,6 +114,16 @@ config I2C_BLACKFIN_TWI_CLK_KHZ
>  	help
>  	  The unit of the TWI clock is kHz.
>  
> +config I2C_CPM
> +	tristate "Freescale CPM1 or CPM2 (MPC8xx/826x)"
> +	depends on (CPM1 || CPM2) && I2C && PPC_OF

The dependency on I2C is now handled at menu level, you no longer need
to mention it here.

> +	help
> +	  This supports the use of the I2C interface on Freescale
> +	  processors with CPM1 or CPM2.
> +
> +	  This driver can also be built as a module.  If so, the module
> +	  will be called i2c-cpm.
> +
>  config I2C_DAVINCI
>  	tristate "DaVinci I2C driver"
>  	depends on ARCH_DAVINCI
> diff --git a/drivers/i2c/busses/Makefile b/drivers/i2c/busses/Makefile
> index ea7068f..1291e2b 100644
> --- a/drivers/i2c/busses/Makefile
> +++ b/drivers/i2c/busses/Makefile
> @@ -11,6 +11,7 @@ obj-$(CONFIG_I2C_AMD8111)	+= i2c-amd8111.o
>  obj-$(CONFIG_I2C_AT91)		+= i2c-at91.o
>  obj-$(CONFIG_I2C_AU1550)	+= i2c-au1550.o
>  obj-$(CONFIG_I2C_BLACKFIN_TWI)	+= i2c-bfin-twi.o
> +obj-$(CONFIG_I2C_CPM)		+= i2c-cpm.o
>  obj-$(CONFIG_I2C_DAVINCI)	+= i2c-davinci.o
>  obj-$(CONFIG_I2C_ELEKTOR)	+= i2c-elektor.o
>  obj-$(CONFIG_I2C_GPIO)		+= i2c-gpio.o
> diff --git a/drivers/i2c/busses/i2c-cpm.c b/drivers/i2c/busses/i2c-cpm.c
> new file mode 100644
> index 0000000..7191427
> --- /dev/null
> +++ b/drivers/i2c/busses/i2c-cpm.c
> @@ -0,0 +1,759 @@
> +/*
> + * Freescale CPM1/CPM2 I2C interface.
> + * Copyright (c) 1999 Dan Malek (dmalek@jlc.net).
> + *
> + * moved into proper i2c interface;
> + * Brad Parker (brad@heeltoe.com)
> + *
> + * (C) 2007 Montavista Software, Inc.
> + * Vitaly Bordug <vitb@kernel.crashing.org>
> + *
> + * RPX lite specific parts of the i2c interface
> + * Update:  There actually isn't anything RPXLite-specific about this module.
> + * This should work for most any CPM board.  The console messages have been
> + * changed to eliminate RPXLite references.

Maybe this block comment can be removed entirely? It adds more
confusion than value IMHO.

> + *
> +    This program is free software; you can redistribute it and/or modify
> +    it under the terms of the GNU General Public License as published by
> +    the Free Software Foundation; either version 2 of the License, or
> +    (at your option) any later version.
> +
> +    This program is distributed in the hope that it will be useful,
> +    but WITHOUT ANY WARRANTY; without even the implied warranty of
> +    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> +    GNU General Public License for more details.
> +
> +    You should have received a copy of the GNU General Public License
> +    along with this program; if not, write to the Free Software
> +    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
> + *
> + * moved into proper i2c interface; separated out platform specific
> + * parts into i2c-8xx.c
> + * Brad Parker (brad@heeltoe.com)

Redundant with one of the block comments above.

> + *
> + * Parts from dbox2_i2c.c (cvs.tuxbox.org)
> + * (C) 2000-2001 Tmbinc, Gillem (htoa@gmx.net)
> + *
> + * (C) 2007 Montavista Software, Inc.
> + * Vitaly Bordug <vitb@kernel.crashing.org>

Redundant as well.

> + *
> + * Converted to of_platform_device. Renamed to i2c-cpm.c.
> + * (C) 2007 Jochen Friedrich <jochen@scram.de>
> + */

Please group all the copyright statements together, having some before
the GPL boilerplate and some after is rather confusing.

> +
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/delay.h>
> +#include <linux/slab.h>
> +#include <linux/init.h>
> +#include <linux/interrupt.h>
> +#include <linux/errno.h>
> +#include <linux/sched.h>

It's not obvious to me why you need to include <linux/sched.h>, please
clarify.

> +#include <linux/stddef.h>
> +#include <linux/i2c.h>
> +#include <linux/io.h>
> +#include <linux/time.h>

I don't think that you need <linux/time.h> either?

> +#include <linux/dma-mapping.h>
> +#include <linux/of_device.h>
> +#include <linux/of_platform.h>
> +#include <sysdev/fsl_soc.h>
> +#include <asm/cpm.h>
> +
> +/*
> + * Wait for patch from Jon Smirl
> + * #include "powerpc-common.h"
> + */

It doesn't make sense to merge this comment upstream.

> +
> +/* Try to define this if you have an older CPU (earlier than rev D4) */
> +/* However, better use a GPIO based bitbang driver in this case :/   */
> +#undef	I2C_CHIP_ERRATA
> +
> +#define CPM_MAX_READ    513
> +#define CPM_MAXBD       4
> +
> +#define CPM_CR_INIT_TRX		(0x00)
> +#define CPM_CR_CLOSE_RXBD	(0x07)
> +
> +#define I2C_EB			(0x10) /* Big endian mode */
> +
> +/* I2C parameter RAM. */
> +struct i2c_ram {
> +	ushort  rbase;		/* Rx Buffer descriptor base address */
> +	ushort  tbase;		/* Tx Buffer descriptor base address */
> +	u_char  rfcr;		/* Rx function code */
> +	u_char  tfcr;		/* Tx function code */
> +	ushort  mrblr;		/* Max receive buffer length */
> +	uint    rstate;		/* Internal */
> +	uint    rdp;		/* Internal */
> +	ushort  rbptr;		/* Rx Buffer descriptor pointer */
> +	ushort  rbc;		/* Internal */
> +	uint    rxtmp;		/* Internal */
> +	uint    tstate;		/* Internal */
> +	uint    tdp;		/* Internal */
> +	ushort  tbptr;		/* Tx Buffer descriptor pointer */
> +	ushort  tbc;		/* Internal */
> +	uint    txtmp;		/* Internal */
> +	char    res1[4];	/* Reserved */
> +	ushort  rpbase;		/* Relocation pointer */
> +	char    res2[2];	/* Reserved */
> +};
> +
> +/* I2C Registers */
> +struct i2c_reg {
> +	u8	i2mod;
> +	u8	res1[3];
> +	u8	i2add;
> +	u8	res2[3];
> +	u8	i2brg;
> +	u8	res3[3];
> +	u8	i2com;
> +	u8	res4[3];
> +	u8	i2cer;
> +	u8	res5[3];
> +	u8	i2cmr;
> +};
> +
> +struct cpm_i2c {
> +	char *base;
> +	struct of_device *ofdev;
> +	struct i2c_adapter adap;
> +	uint dp_addr;
> +	int version; /* CPM1=1, CPM2=2 */
> +	int irq;
> +	int cp_command;
> +	struct i2c_reg __iomem *i2c_reg;
> +	struct i2c_ram __iomem *i2c_ram;
> +	u16 i2c_addr;
> +	wait_queue_head_t i2c_wait;
> +	struct mutex i2c_mutex; /* Protects I2C CPM */

"I2C CPM" isn't very descriptive. Best would be to list the structure
fields which are protected.

> +	u_char *txbuf[CPM_MAXBD];
> +	u_char *rxbuf[CPM_MAXBD];
> +	u32 txdma[CPM_MAXBD];
> +	u32 rxdma[CPM_MAXBD];
> +};
> +
> +static irqreturn_t cpm_i2c_interrupt(int irq, void *dev_id)
> +{
> +	struct cpm_i2c *cpm;
> +	struct i2c_reg __iomem *i2c_reg;
> +	struct i2c_adapter *adap = dev_id;
> +	int i;
> +
> +	cpm = i2c_get_adapdata(dev_id);
> +	i2c_reg = cpm->i2c_reg;
> +
> +	/* Clear interrupt. */
> +	i = in_8(&i2c_reg->i2cer);
> +	out_8(&i2c_reg->i2cer, i);
> +
> +	dev_dbg(&adap->dev, "Interrupt: %x\n", i);
> +
> +	/* Get 'me going again. */

Extra '.

> +	wake_up_interruptible(&cpm->i2c_wait);
> +
> +	return i ? IRQ_HANDLED : IRQ_NONE;
> +}
> +
> +static void cpm_reset_i2c_params(struct cpm_i2c *cpm)
> +{
> +	struct i2c_ram __iomem *i2c_ram = cpm->i2c_ram;
> +
> +	/* Set up the IIC parameters in the parameter ram. */
> +	out_be16(&i2c_ram->tbase, cpm->dp_addr);
> +	out_be16(&i2c_ram->rbase, cpm->dp_addr + sizeof(cbd_t) * CPM_MAXBD);
> +
> +	out_8(&i2c_ram->tfcr, I2C_EB);
> +	out_8(&i2c_ram->rfcr, I2C_EB);
> +
> +	out_be16(&i2c_ram->mrblr, CPM_MAX_READ);
> +
> +	out_be32(&i2c_ram->rstate, 0);
> +	out_be32(&i2c_ram->rdp, 0);
> +	out_be16(&i2c_ram->rbptr, in_be16(&i2c_ram->rbase));
> +	out_be16(&i2c_ram->rbc, 0);
> +	out_be32(&i2c_ram->rxtmp, 0);
> +	out_be32(&i2c_ram->tstate, 0);
> +	out_be32(&i2c_ram->tdp, 0);
> +	out_be16(&i2c_ram->tbptr, in_be16(&i2c_ram->tbase));
> +	out_be16(&i2c_ram->tbc, 0);
> +	out_be32(&i2c_ram->txtmp, 0);
> +}
> +
> +static void cpm_i2c_force_close(struct i2c_adapter *adap)
> +{
> +	struct cpm_i2c *cpm = i2c_get_adapdata(adap);
> +	struct i2c_reg __iomem *i2c_reg = cpm->i2c_reg;
> +
> +	dev_dbg(&adap->dev, "cpm_i2c_force_close()\n");
> +
> +	cpm_command(cpm->cp_command, CPM_CR_CLOSE_RXBD);
> +
> +	out_8(&i2c_reg->i2cmr, 0x00);	/* Disable all interrupts */
> +	out_8(&i2c_reg->i2cer, 0xff);
> +}
> +
> +static void cpm_i2c_parse_message(struct i2c_adapter *adap,
> +	struct i2c_msg *pmsg, int num, int tx, int rx)
> +{
> +	cbd_t *tbdf, *rbdf;
> +	u_char addr;
> +	u_char *tb;
> +	u_char *rb;
> +	struct cpm_i2c *cpm = i2c_get_adapdata(adap);
> +	struct i2c_ram __iomem *i2c_ram = cpm->i2c_ram;
> +	int i, dscan;
> +
> +	tbdf = (cbd_t *) cpm_muram_addr(in_be16(&i2c_ram->tbase));
> +	rbdf = (cbd_t *) cpm_muram_addr(in_be16(&i2c_ram->rbase));
> +
> +	/*
> +	 * This chip can't do zero length writes. However, the i2c core uses
> +	 * them to scan for devices. The best we can do is to convert them
> +	 * into 1 byte reads
> +	 */

Nack. New-style i2c drivers don't require this probing mechanism,
that's what you want to use if your I2C master doesn't support
zero-byte messages. Well, that's most probably what you want to use on
embedded platforms anyway.

So, please no hack for zero-byte messages. If they aren't supported by
the hardware, they aren't supported by the driver either.

> +
> +	dscan = ((pmsg->len == 0) && (num == 1));
> +
> +	addr = pmsg->addr << 1;
> +	if ((pmsg->flags & I2C_M_RD) || dscan)
> +		addr |= 1;
> +
> +	tb = cpm->txbuf[tx];
> +	rb = cpm->rxbuf[rx];
> +
> +	/* Align read buffer */
> +	rb = (u_char *) (((ulong) rb + 1) & ~1);
> +
> +	if ((pmsg->flags & I2C_M_RD) || dscan) {
> +		/*
> +		 * To read, we need an empty buffer of the proper length.
> +		 * All that is used is the first byte for address, the remainder
> +		 * is just used for timing (and doesn't really have to exist).
> +		 */
> +		tb[0] = addr;		/* Device address byte w/rw flag */
> +
> +		dev_dbg(&adap->dev, "cpm_i2c_read(abyte=0x%x)\n", addr);
> +
> +		if (dscan)
> +			tbdf[tx].cbd_datlen = 2;
> +		else
> +			tbdf[tx].cbd_datlen = pmsg->len + 1;
> +
> +		tbdf[tx].cbd_sc = 0;
> +
> +		if (!(pmsg->flags & I2C_M_NOSTART))
> +			tbdf[tx].cbd_sc |= BD_I2C_START;
> +		if (tx + 1 == num)
> +			tbdf[tx].cbd_sc |= BD_SC_LAST | BD_SC_WRAP;
> +
> +		rbdf[rx].cbd_datlen = 0;
> +		rbdf[rx].cbd_sc = BD_SC_EMPTY | BD_SC_INTRPT;
> +
> +		if (rx + 1 == CPM_MAXBD)
> +			tbdf[rx].cbd_sc |= BD_SC_WRAP;
> +
> +		eieio();
> +		tbdf[tx].cbd_sc |= BD_SC_READY;
> +	} else {
> +		tb[0] = addr;		/* Device address byte w/rw flag */
> +		for (i = 0; i < pmsg->len; i++)
> +			tb[i+1] = pmsg->buf[i];
> +
> +		dev_dbg(&adap->dev, "cpm_iic_write(abyte=0x%x)\n", addr);
> +
> +		tbdf[tx].cbd_datlen = pmsg->len + 1;
> +		tbdf[tx].cbd_sc = 0;
> +
> +		if (!(pmsg->flags & I2C_M_NOSTART))
> +			tbdf[tx].cbd_sc |= BD_I2C_START;
> +
> +		if (tx + 1 == num)
> +			tbdf[tx].cbd_sc |= BD_SC_LAST | BD_SC_WRAP;
> +
> +		eieio();
> +		tbdf[tx].cbd_sc |= BD_SC_READY | BD_SC_INTRPT;
> +
> +		dev_dbg(&adap->dev, "tx sc %d %04x\n",
> +			tx, tbdf[tx].cbd_sc);
> +	}
> +}
> +
> +static int cpm_i2c_check_message(struct i2c_adapter *adap,
> +	struct i2c_msg *pmsg, int tx, int rx)
> +{
> +	cbd_t *tbdf, *rbdf;
> +	u_char *tb;
> +	u_char *rb;
> +	struct cpm_i2c *cpm = i2c_get_adapdata(adap);
> +	struct i2c_ram __iomem *i2c_ram = cpm->i2c_ram;
> +	int i;
> +
> +	tbdf = (cbd_t *) cpm_muram_addr(in_be16(&i2c_ram->tbase));
> +	rbdf = (cbd_t *) cpm_muram_addr(in_be16(&i2c_ram->rbase));
> +
> +	tb = cpm->txbuf[tx];
> +	rb = cpm->rxbuf[rx];
> +
> +	/* Align read buffer */
> +	rb = (u_char *) (((uint) rb + 1) & ~1);
> +
> +	if (pmsg->flags & I2C_M_RD) {
> +		dev_dbg(&adap->dev, "rx sc %04x, rx sc %04x\n",
> +			tbdf[tx].cbd_sc, rbdf[rx].cbd_sc);
> +
> +		if (tbdf[tx].cbd_sc & BD_SC_NAK) {
> +			dev_dbg(&adap->dev, "IIC read; No ack\n");
> +
> +			if (pmsg->flags & I2C_M_IGNORE_NAK)
> +				return 0;

Are there known I2C chips on this platform which need this flag? Its
implementation is purely optional, only a few broken I2C chips need it,
so it should really only be implemented when strictly needed.

> +			else
> +				return -EIO;
> +		}
> +		if (rbdf[rx].cbd_sc & BD_SC_EMPTY) {
> +			dev_dbg(&adap->dev,
> +				"IIC read; complete but rbuf empty\n");
> +			return -EREMOTEIO;
> +		}
> +		if (rbdf[rx].cbd_sc & BD_SC_OV) {
> +			dev_dbg(&adap->dev, "IIC read; Overrun\n");
> +			return -EREMOTEIO;
> +		}
> +		for (i = 0; i < pmsg->len; i++)
> +			pmsg->buf[i] = rb[i];
> +	} else {
> +		dev_dbg(&adap->dev, "tx sc %d %04x\n", tx, tbdf[tx].cbd_sc);
> +
> +		if (tbdf[tx].cbd_sc & BD_SC_NAK) {
> +			dev_dbg(&adap->dev, "IIC write; No ack\n");
> +
> +			if (pmsg->flags & I2C_M_IGNORE_NAK)
> +				return 0;
> +			else
> +				return -EIO;
> +		}
> +		if (tbdf[tx].cbd_sc & BD_SC_UN) {
> +			dev_dbg(&adap->dev, "IIC write; Underrun\n");
> +			return -EIO;
> +		}
> +		if (tbdf[tx].cbd_sc & BD_SC_CL) {
> +			dev_dbg(&adap->dev, "IIC write; Collision\n");
> +			return -EIO;
> +		}
> +	}
> +	return 0;
> +}

Many of the dev_dbg() calls in the function above could be replaced
with dev_err(), methinks.

> +
> +static int cpm_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg *msgs, int num)
> +{
> +	struct cpm_i2c *cpm = i2c_get_adapdata(adap);
> +	struct i2c_reg __iomem *i2c_reg = cpm->i2c_reg;
> +	struct i2c_ram __iomem *i2c_ram = cpm->i2c_ram;
> +	struct i2c_msg *pmsg, *rmsg;
> +	int ret, i;
> +	int tptr;
> +	int rptr;
> +	cbd_t *tbdf, *rbdf;
> +
> +	if (num > CPM_MAXBD)
> +		return -EINVAL;
> +
> +	/* Check if we have any oversized READ requests */
> +	for (i = 0; i < num; i++) {
> +		pmsg = &msgs[i];
> +		if (pmsg->len >= CPM_MAX_READ)
> +			return -EINVAL;
> +	}
> +
> +	mutex_lock(&cpm->i2c_mutex);
> +
> +	/* Reset to use first buffer */
> +	out_be16(&i2c_ram->rbptr, in_be16(&i2c_ram->rbase));
> +	out_be16(&i2c_ram->tbptr, in_be16(&i2c_ram->tbase));
> +
> +	tbdf = (cbd_t *) cpm_muram_addr(in_be16(&i2c_ram->tbase));
> +	rbdf = (cbd_t *) cpm_muram_addr(in_be16(&i2c_ram->rbase));
> +
> +	tptr = 0;
> +	rptr = 0;
> +
> +	while (tptr < num) {
> +		pmsg = &msgs[tptr];
> +		dev_dbg(&adap->dev, "i2c-algo-cpm.o: " "R: %d T: %d\n",

Incorrect (and unneeded) file name reference.

> +			rptr, tptr);
> +
> +		cpm_i2c_parse_message(adap, pmsg, num, tptr, rptr);
> +		if (pmsg->flags & I2C_M_RD)
> +			rptr++;
> +		tptr++;
> +	}
> +	/* Start transfer now */
> +	/* Chip bug, set enable here */
> +	out_8(&i2c_reg->i2cmr, 0x13);	/* Enable RX/TX/Error interupts */
> +	out_8(&i2c_reg->i2cer, 0xff);	/* Clear interrupt status */
> +	out_8(&i2c_reg->i2mod, in_8(&i2c_reg->i2mod) | 1);	/* Enable */
> +	/* Begin transmission */
> +	out_8(&i2c_reg->i2com, in_8(&i2c_reg->i2com) | 0x80);
> +
> +	tptr = 0;
> +	rptr = 0;
> +
> +	while (tptr < num) {
> +		/* Check for outstanding messages */
> +		dev_dbg(&adap->dev, "test ready.\n");
> +		if (!(tbdf[tptr].cbd_sc & BD_SC_READY)) {
> +			dev_dbg(&adap->dev, "ready.\n");
> +			rmsg = &msgs[tptr];
> +			ret = cpm_i2c_check_message(adap, rmsg, tptr, rptr);
> +			tptr++;
> +			if (rmsg->flags & I2C_M_RD)
> +				rptr++;
> +			if (ret)
> +				goto out_err;
> +		} else {
> +			dev_dbg(&adap->dev, "not ready.\n");
> +			ret = wait_event_interruptible_timeout(cpm->i2c_wait,
> +				!(tbdf[tptr].cbd_sc & BD_SC_READY), 1 * HZ);
> +			if (ret == 0) {
> +				ret = -EREMOTEIO;
> +				dev_dbg(&adap->dev, "I2C read: timeout!\n");
> +				goto out_err;
> +			}
> +		}
> +	}
> +#ifdef I2C_CHIP_ERRATA
> +	/*
> +	 * Chip errata, clear enable. This is not needed on rev D4 CPUs.
> +	 * Disabling I2C too early may cause too short stop condition
> +	 */
> +	udelay(4);
> +	out_8(&i2c_reg->i2mod, in_8(&i2c_reg->i2mod) | ~1);
> +#endif
> +	mutex_unlock(&cpm->i2c_mutex);
> +	return (num);
> +
> +out_err:
> +	cpm_i2c_force_close(adap);
> +#ifdef I2C_CHIP_ERRATA
> +	/*
> +	 * Chip errata, clear enable. This is not needed on rev D4 CPUs.
> +	 */
> +	out_8(&i2c_reg->i2mod, in_8(&i2c_reg->i2mod) | ~1);
> +#endif
> +	mutex_unlock(&cpm->i2c_mutex);
> +	return ret;
> +}
> +
> +static u32 cpm_i2c_func(struct i2c_adapter *adap)
> +{
> +	return I2C_FUNC_I2C | I2C_FUNC_SMBUS_EMUL;

Actually I2C_FUNC_I2C | (I2C_FUNC_SMBUS_EMUL & ~I2C_FUNC_SMBUS_QUICK)
according to my comment above.

> +}
> +
> +/* -----exported algorithm data: -------------------------------------	*/
> +
> +static const struct i2c_algorithm cpm_i2c_algo = {
> +	.master_xfer = cpm_i2c_xfer,
> +	.functionality = cpm_i2c_func,
> +};
> +
> +static const struct i2c_adapter cpm_ops = {
> +	.owner		= THIS_MODULE,
> +	.name		= "i2c-cpm",
> +	.id		= I2C_HW_MPC8XX_EPON,

Not defined anywhere, so this won't build. This ID is optional, so if
you don't need it, just don't set it. With the advent of new-style i2c
device drivers, the use of these IDs will hopefully phase out.

> +	.algo		= &cpm_i2c_algo,
> +	.class		= I2C_CLASS_HWMON,
> +};
> +
> +static int cpm_i2c_setup(struct cpm_i2c *cpm)

Could be __devinit.

> +{
> +	struct of_device *ofdev = cpm->ofdev;
> +	const u32 *data;
> +	int len, ret, i;
> +	void __iomem *i2c_base;
> +	cbd_t *tbdf, *rbdf;
> +	unsigned char brg;
> +
> +	pr_debug("i2c-cpm: cpm_i2c_setup()\n");

dev_dbg()

> +
> +	init_waitqueue_head(&cpm->i2c_wait);
> +	mutex_init(&cpm->i2c_mutex);
> +
> +	cpm->irq = of_irq_to_resource(ofdev->node, 0, NULL);
> +	if (cpm->irq == NO_IRQ)
> +		return -EINVAL;
> +
> +	/* Install interrupt handler. */
> +	ret = request_irq(cpm->irq, cpm_i2c_interrupt, 0, "cpm_i2c",
> +			  &cpm->adap);
> +	if (ret)
> +		goto out_irq;
> +
> +	/* IIC parameter RAM */
> +	i2c_base = of_iomap(ofdev->node, 1);
> +	if (i2c_base == NULL) {
> +		ret = -EINVAL;
> +		goto out_irq;
> +	}
> +
> +	if (of_device_is_compatible(ofdev->node, "fsl,cpm1-i2c")) {
> +
> +		/* Check for and use a microcode relocation patch. */
> +		cpm->i2c_ram = i2c_base;
> +		cpm->i2c_addr = in_be16(&cpm->i2c_ram->rpbase);
> +
> +		/*
> +		 * Maybe should use cpm_muram_alloc instead of hardcoding
> +		 * this in micropatch.c
> +		 */
> +		if (cpm->i2c_addr) {
> +			cpm->i2c_ram = cpm_muram_addr(cpm->i2c_addr);
> +			iounmap(i2c_base);
> +		}
> +
> +		cpm->version = 1;
> +
> +	} else if (of_device_is_compatible(ofdev->node, "fsl,cpm2-i2c")) {
> +		cpm->i2c_addr = cpm_muram_alloc(sizeof(struct i2c_ram), 64);
> +		cpm->i2c_ram = cpm_muram_addr(cpm->i2c_addr);
> +		out_be16(i2c_base, cpm->i2c_addr);
> +		iounmap(i2c_base);
> +
> +		cpm->version = 2;
> +
> +	} else {
> +		iounmap(i2c_base);
> +		ret = -EINVAL;
> +		goto out_irq;
> +	}
> +
> +	/* I2C control/status registers */
> +	cpm->i2c_reg = of_iomap(ofdev->node, 0);
> +	if (cpm->i2c_reg == NULL) {
> +		ret = -EINVAL;
> +		goto out_ram;
> +	}
> +
> +	data = of_get_property(ofdev->node, "fsl,cpm-command", &len);
> +	if (!data || len != 4) {
> +		ret = -EINVAL;
> +		goto out_reg;
> +	}
> +	cpm->cp_command = *data;
> +
> +	data = of_get_property(ofdev->node, "linux,i2c-class", &len);
> +	if (data && len == 4)
> +		cpm->adap.class = *data;
> +
> +	/*
> +	 * Allocate space for CPM_MAXBD transmit and receive buffer
> +	 * descriptors in the DP ram.
> +	 */
> +	cpm->dp_addr = cpm_muram_alloc(sizeof(cbd_t) * 2 * CPM_MAXBD, 8);
> +	if (!cpm->dp_addr) {
> +		ret = -ENOMEM;
> +		goto out_reg;
> +	}
> +
> +	/* Initialize Tx/Rx parameters. */
> +
> +	cpm_reset_i2c_params(cpm);
> +
> +	pr_debug("i2c-cpm: i2c_ram %x, dp_addr 0x%x\n", (uint) cpm->i2c_ram,
> +		cpm->dp_addr);
> +	pr_debug("i2c-cpm: tbase %d, rbase %d\n",
> +		in_be16(&cpm->i2c_ram->tbase), in_be16(&cpm->i2c_ram->rbase));

dev_dbg()

> +
> +	tbdf = (cbd_t *) cpm_muram_addr(in_be16(&cpm->i2c_ram->tbase));
> +	rbdf = (cbd_t *) cpm_muram_addr(in_be16(&cpm->i2c_ram->rbase));
> +
> +	/* Allocate TX and RX buffers */
> +
> +	for (i = 0; i < CPM_MAXBD; i++) {
> +		cpm->rxbuf[i] = dma_alloc_coherent(
> +			NULL, CPM_MAX_READ + 1, &cpm->rxdma[i], GFP_KERNEL);
> +		if (!cpm->rxbuf[i]) {
> +			ret = -ENOMEM;
> +			goto out_muram;
> +		}
> +		rbdf[i].cbd_bufaddr = ((cpm->rxdma[i] + 1) & ~1);
> +		cpm->txbuf[i] = (unsigned char *)dma_alloc_coherent(
> +			NULL, CPM_MAX_READ + 1, &cpm->txdma[i], GFP_KERNEL);
> +		if (!cpm->txbuf[i]) {
> +			ret = -ENOMEM;
> +			goto out_muram;
> +		}
> +		tbdf[i].cbd_bufaddr = cpm->txdma[i];
> +	}
> +
> +	cpm_command(cpm->cp_command, CPM_CR_INIT_TRX);
> +
> +	/*
> +	 * Select an invalid address. Just make sure we don't use loopback mode
> +	 */
> +	out_8(&cpm->i2c_reg->i2add, 0xfe);
> +
> +	/* Make clock run at 60 kHz. */
> +
> +	brg = get_brgfreq() / (32 * 2 * 60000) - 3;
> +	out_8(&cpm->i2c_reg->i2brg, brg);
> +
> +	out_8(&cpm->i2c_reg->i2mod, 0x00);
> +	out_8(&cpm->i2c_reg->i2com, 0x01);	/* Master mode */
> +
> +	/* Disable interrupts. */
> +	out_8(&cpm->i2c_reg->i2cmr, 0);
> +	out_8(&cpm->i2c_reg->i2cer, 0xff);
> +
> +	return 0;
> +
> +out_muram:
> +	for (i = 0; i < CPM_MAXBD; i++) {
> +		if (cpm->rxbuf[i])
> +			dma_free_coherent(NULL, CPM_MAX_READ + 1,
> +				cpm->rxbuf[i], cpm->rxdma[i]);
> +		if (cpm->txbuf[i])
> +			dma_free_coherent(NULL, CPM_MAX_READ + 1,
> +				cpm->txbuf[i], cpm->txdma[i]);
> +	}
> +	cpm_muram_free(cpm->dp_addr);
> +out_reg:
> +	iounmap(cpm->i2c_reg);
> +out_ram:
> +	if ((cpm->version == 1) && (!cpm->i2c_addr))
> +		iounmap(cpm->i2c_ram);
> +	if (cpm->version == 2)
> +		cpm_muram_free(cpm->i2c_addr);
> +out_irq:
> +	free_irq(cpm->irq, &cpm->adap);
> +	return ret;
> +}
> +
> +static void cpm_i2c_shutdown(struct cpm_i2c *cpm)
> +{
> +	int i;
> +
> +	/* Shut down I2C. */
> +	out_8(&cpm->i2c_reg->i2mod, in_8(&cpm->i2c_reg->i2mod) | ~1);
> +
> +	/* Disable interrupts */
> +	out_8(&cpm->i2c_reg->i2cmr, 0);
> +	out_8(&cpm->i2c_reg->i2cer, 0xff);
> +
> +	free_irq(cpm->irq, &cpm->adap);
> +
> +	/* Free all memory */
> +	for (i = 0; i < CPM_MAXBD; i++) {
> +		dma_free_coherent(NULL, CPM_MAX_READ + 1,
> +			cpm->rxbuf[i], cpm->rxdma[i]);
> +		dma_free_coherent(NULL, CPM_MAX_READ + 1,
> +			cpm->txbuf[i], cpm->txdma[i]);
> +	}
> +
> +	cpm_muram_free(cpm->dp_addr);
> +	iounmap(cpm->i2c_reg);
> +
> +	if ((cpm->version == 1) && (!cpm->i2c_addr))
> +		iounmap(cpm->i2c_ram);
> +	if (cpm->version == 2)
> +		cpm_muram_free(cpm->i2c_addr);
> +
> +	return;
> +}
> +
> +static int __devinit cpm_i2c_probe(struct of_device *ofdev,
> +			 const struct of_device_id *match)
> +{
> +	int result;
> +	struct cpm_i2c *cpm;
> +
> +	cpm = kzalloc(sizeof(struct cpm_i2c), GFP_KERNEL);
> +	if (!cpm)
> +		return -ENOMEM;
> +
> +	cpm->ofdev = ofdev;
> +
> +	dev_set_drvdata(&ofdev->dev, cpm);
> +
> +	cpm->adap = cpm_ops;
> +	i2c_set_adapdata(&cpm->adap, cpm);
> +	cpm->adap.dev.parent = &ofdev->dev;
> +
> +	result = cpm_i2c_setup(cpm);
> +	if (result) {
> +		printk(KERN_ERR "i2c-cpm: Unable to init hardware\n");

dev_err()

> +		goto out;
> +	}
> +
> +	/* register new adapter to i2c module... */
> +
> +	result = i2c_add_adapter(&cpm->adap);
> +	if (result < 0) {
> +		printk(KERN_ERR "i2c-cpm: Unable to register with I2C\n");

dev_err()

> +		goto out2;
> +	}
> +
> +	pr_debug("i2c-cpm: hw routines for %s registered.\n", cpm->adap.name);

dev_dbg()

> +
> +	/*
> +	 * Wait for patch from Jon Smirl
> +	 * of_register_i2c_devices(&cpm->adap, ofdev->node);
> +	 */

Again I won't merge this comment upstream.

> +
> +	return 0;
> +out2:
> +	cpm_i2c_shutdown(cpm);
> +out:

Better give more explicit names to your labels (for example
err_shutdown and err_free).

> +	dev_set_drvdata(&ofdev->dev, NULL);
> +	kfree(cpm);
> +
> +	return result;
> +}
> +
> +static int __devexit cpm_i2c_remove(struct of_device *ofdev)
> +{
> +	struct cpm_i2c *cpm = dev_get_drvdata(&ofdev->dev);
> +
> +	i2c_del_adapter(&cpm->adap);
> +
> +	cpm_i2c_shutdown(cpm);
> +
> +	dev_set_drvdata(&ofdev->dev, NULL);
> +	kfree(cpm);
> +
> +	return 0;
> +}
> +
> +static const struct of_device_id cpm_i2c_match[] = {
> +	{
> +		.compatible = "fsl,cpm-i2c",
> +	},
> +	{},
> +};
> +
> +MODULE_DEVICE_TABLE(of, cpm_i2c_match);
> +
> +static struct of_platform_driver cpm_i2c_driver = {
> +	.match_table	= cpm_i2c_match,
> +	.probe		= cpm_i2c_probe,
> +	.remove		= __devexit_p(cpm_i2c_remove),
> +	.driver		= {
> +		.name	= "fsl-i2c-cpm",
> +		.owner	= THIS_MODULE,
> +	}
> +};
> +
> +static int __init cpm_i2c_init(void)
> +{
> +	return of_register_platform_driver(&cpm_i2c_driver);
> +}
> +
> +static void __exit cpm_i2c_exit(void)
> +{
> +	of_unregister_platform_driver(&cpm_i2c_driver);
> +}
> +
> +module_init(cpm_i2c_init);
> +module_exit(cpm_i2c_exit);
> +
> +MODULE_AUTHOR("Dan Malek <dmalek@jlc.net>");

Why not your own name?

> +MODULE_DESCRIPTION("I2C-Bus adapter routines for CPM boards");
> +MODULE_LICENSE("GPL");


-- 
Jean Delvare
