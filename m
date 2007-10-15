Return-Path: <linux-kernel-owner+w=401wt.eu-S934976AbXJOSsD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934976AbXJOSsD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 14:48:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934269AbXJOSjH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 14:39:07 -0400
Received: from az33egw02.freescale.net ([192.88.158.103]:38058 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934183AbXJOSjB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 14:39:01 -0400
Date: Mon, 15 Oct 2007 13:31:07 -0500
From: Scott Wood <scottwood@freescale.com>
To: Jochen Friedrich <jochen@scram.de>
Cc: "linuxppc-embedded@ozlabs.org" <linuxppc-embedded@ozlabs.org>,
       linux-kernel@vger.kernel.org, i2c@lm-sensors.org,
       Carsten Juttner <carjay@gmx.net>
Subject: Re: [PATCH take2] [POWERPC] i2c: adds support for i2c bus on 8xx
Message-ID: <20071015183107.GA4361@loki.buserror.net>
References: <47134A94.60606@scram.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47134A94.60606@scram.de>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 15, 2007 at 01:10:12PM +0200, Jochen Friedrich wrote:
> Using the port of 2.4 code from Vitaly Bordug <vitb@kernel.crashing.org>
> and the actual algorithm used by the i2c driver of the DBox code on
> cvs.tuxboc.org from Tmbinc, Gillem (htoa@gmx.net). Renamed
> i2c-algo-8xx.c to i2c-algo-cpm.c and i2c-rpx.c to i2c-8xx.c. Added
> original i2c-rpx.c as i2c-8xx-ppc.c for pre-OF (arch ppc) devices.

Do we really need to be adding features for arch/ppc at this point?  It'll
be going away in June.  arch/ppc-specific things outside of arch/ppc itself
will also be more likely to be missed in the removal.

Also, please post inline rather than as an attachment; attachments are
harder to quote in a reply.

> diff --git a/arch/powerpc/boot/dts/mpc885ads.dts b/arch/powerpc/boot/dts/mpc885ads.dts
> index 8848e63..a526c02 100644
> --- a/arch/powerpc/boot/dts/mpc885ads.dts
> +++ b/arch/powerpc/boot/dts/mpc885ads.dts
> @@ -213,6 +213,15 @@
>  				fsl,cpm-command = <0080>;
>  				linux,network-index = <2>;
>  			};
> +
> +			i2c@860 {
> +				device_type = "i2c";

No device_type.

> +				compatible = "fsl-i2c-cpm";

Should be fsl,cpm-i2c.  Is cpm2 i2c the same?  If not, it should be
fsl,cpm1-i2c.  It's probably best to specify it anyway, along with
fsl,mpc885-i2c.

> diff --git a/arch/powerpc/platforms/8xx/mpc885ads_setup.c b/arch/powerpc/platforms/8xx/mpc885ads_setup.c
> index 2cf1b6a..350018b 100644
> --- a/arch/powerpc/platforms/8xx/mpc885ads_setup.c
> +++ b/arch/powerpc/platforms/8xx/mpc885ads_setup.c
> @@ -175,6 +175,12 @@ static void __init init_ioports(void)
>  
>  	/* Set FEC1 and FEC2 to MII mode */
>  	clrbits32(&mpc8xx_immr->im_cpm.cp_cptr, 0x00000180);
> +
> +#ifdef CONFIG_I2C_8XX
> +	setbits32(&mpc8xx_immr->im_cpm.cp_pbpar, 0x00000030);
> +	setbits32(&mpc8xx_immr->im_cpm.cp_pbdir, 0x00000030);
> +	setbits16(&mpc8xx_immr->im_cpm.cp_pbodr, 0x0030);
> +#endif

Please add this to mpc885ads_pins, rather than poking the registers
directly.  The relevant lines are:

	{CPM_PORTB, 26, CPM_PIN_OUTPUT},
	{CPM_PORTB, 27, CPM_PIN_OUTPUT},

> +static const char *i2c_regs = "regs";
> +static const char *i2c_pram = "pram";
> +static const char *i2c_irq = "interrupt";
> +
> +static int __init fsl_i2c_cpm_of_init(void)
> +{
> +	struct device_node *np;
> +	unsigned int i;
> +	struct platform_device *i2c_dev;
> +	int ret;
> +
> +	for (np = NULL, i = 0;
> +	     (np = of_find_compatible_node(np, "i2c", "fsl-i2c-cpm")) != NULL;
> +	     i++) {

Why not just make an of_platform device instead of this glue code?

> diff --git a/drivers/i2c/algos/Kconfig b/drivers/i2c/algos/Kconfig
> index 014dfa5..7a8200e 100644
> --- a/drivers/i2c/algos/Kconfig
> +++ b/drivers/i2c/algos/Kconfig
> @@ -14,6 +14,18 @@ config I2C_ALGOBIT
>  	  This support is also available as a module.  If so, the module 
>  	  will be called i2c-algo-bit.
>  
> +config I2C_ALGOCPM
> +	tristate "I2C MPC8xx CPM and MPC8260 CPM2 interfaces"
> +	depends on ( 8xx || 8260 ) && I2C
> +	help
> +	  CPM I2C Algorithm, supports the CPM I2C interface for mpc8xx
> +	  and mpc8260 CPUs. Say Y if you own a CPU of this class 

What if I'm just borrowing it? :-)

> +static irqreturn_t cpm_iic_interrupt(int irq, void *dev_id)
> +{
> +	struct i2c_adapter *adap;
> +	struct i2c_algo_cpm_data *cpm;
> +	i2c8xx_t *i2c;
> +	int i;
> +
> +	adap = (struct i2c_adapter *) dev_id;
> +	cpm = adap->algo_data;
> +	i2c = cpm->i2c;
> +
> +	/* Clear interrupt.
> +	 */
> +	i = in_8(&i2c->i2c_i2cer);
> +	out_8(&i2c->i2c_i2cer, i);
> +
> +	if (cpm_debug)
> +		dev_dbg(&adap->dev, "Interrupt: %x\n", i);
> +
> +	/* Get 'me going again.
> +	 */
> +	wake_up_interruptible(&cpm->iic_wait);
> +
> +	return IRQ_HANDLED;
> +}

Should only return IRQ_HANDLED if the event register was non-zero.

> +static int cpm_iic_init(struct i2c_adapter *adap)
> +{
> +	struct i2c_algo_cpm_data *cpm = adap->algo_data;
> +	iic_t *iip = cpm->iip;
> +	i2c8xx_t *i2c = cpm->i2c;
> +	unsigned char brg;
> +	int ret, i;
> +
> +	if (cpm_debug)
> +		dev_dbg(&adap->dev, "cpm_iic_init()\n");

Can you fold the if statement into a macro?  Or just do a raw dev_dbg with
no test, like most drivers do.

> +	ret = 0;
> +	init_waitqueue_head(&cpm->iic_wait);
> +	mutex_init(&cpm->iic_mutex);
> +	/* Initialize the parameter ram.
> +	 * We need to make sure many things are initialized to zero,
> +	 * especially in the case of a microcode patch.
> +	 */
> +	out_be32(&iip->iic_rstate, 0);
> +	out_be32(&iip->iic_rdp, 0);
> +	out_be16(&iip->iic_rbptr, 0);
> +	out_be16(&iip->iic_rbc, 0);
> +	out_be32(&iip->iic_rxtmp, 0);
> +	out_be32(&iip->iic_tstate, 0);
> +	out_be32(&iip->iic_tdp, 0);
> +	out_be16(&iip->iic_tbptr, 0);
> +	out_be16(&iip->iic_tbc, 0);
> +	out_be32(&iip->iic_txtmp, 0);

This appears to be done twice, here and in cpm_reset_iic_params.

> +		u16 v = mk_cr_cmd(CPM_CR_CH_I2C, CPM_CR_INIT_TRX) | CPM_CR_FLG;

Should use fsl,cpm-command rather than hardcoded constants.

> +	/* Select an arbitrary address.  Just make sure it is unique.
> +	 */
> +	out_8(&i2c->i2c_i2add, 0xfe);

It's a 7-bit address...  and are you sure that 0x7e is unique?  Does this
driver even support slave operation?

> +	/* Make clock run at 60 kHz.
> +	 */
> +	/* brg = ppc_proc_freq / (32 * 2 * 60000) - 3; */
> +	brg = 7;
> +	out_8(&i2c->i2c_i2brg, brg);

Why is this hardcoded?

> +	out_8(&i2c->i2c_i2mod, 0x00);
> +	out_8(&i2c->i2c_i2com, 0x01);	/* Master mode */
> +
> +	/* Disable interrupts.
> +	 */
> +	out_8(&i2c->i2c_i2cmr, 0);
> +	out_8(&i2c->i2c_i2cer, 0xff);
> +
> +	/* Allocate TX and RX buffers */
> +	for (i = 0; i < CPM_MAXBD; i++) {
> +		cpm->rxbuf[i] = (unsigned char *)dma_alloc_coherent(
> +			NULL, CPM_MAX_READ + 1, &cpm->rxdma[i], GFP_KERNEL);
> +		if (!cpm->rxbuf[i]) {
> +			ret = -ENOMEM;
> +			goto out;
> +		}
> +		cpm->txbuf[i] = (unsigned char *)dma_alloc_coherent(
> +			NULL, CPM_MAX_READ + 1, &cpm->txdma[i], GFP_KERNEL);
> +		if (!cpm->txbuf[i]) {
> +			ret = -ENOMEM;
> +			goto out;
> +		}
> +	}
> +
> +	/* Install interrupt handler.
> +	 */
> +	if (request_irq(cpm->irq, cpm_iic_interrupt, 0, "8xx_i2c", adap)) {

cpm-i2c, not 8xx.

> +		ret = -EIO;
> +		goto out;
> +	}
> +
> +	return 0;
> +out:
> +	for (i = 0; i < CPM_MAXBD; i++) {
> +		if (cpm->rxbuf[i]) dma_free_coherent(NULL, CPM_MAX_READ + 1,
> +			cpm->rxbuf[i], cpm->rxdma[i]);
> +		if (cpm->txbuf[i]) dma_free_coherent(NULL, CPM_MAX_READ + 1,
> +			cpm->txbuf[i], cpm->txdma[i]);
> +	}

Please put a newline between the if test and the if body.

> +static void force_close(struct i2c_adapter *adap)
> +{
> +	struct i2c_algo_cpm_data *cpm = adap->algo_data;
> +	i2c8xx_t *i2c = cpm->i2c;
> +	if (cpm->reloc == 0) {	/* micro code disabled */
> +		cpm8xx_t *cp = cpm->cp;
> +		u16 v =
> +		    mk_cr_cmd(CPM_CR_CH_I2C, CPM_CR_CLOSE_RXBD) | CPM_CR_FLG;

Why only if there's no microcode relocation?

> +static void cpm_parse_message(struct i2c_adapter *adap, struct i2c_msg *pmsg,
> +	int num, int tx, int rx)
> +{
> +	cbd_t *tbdf, *rbdf;
> +	u_char addr;
> +	u_char *tb;
> +	u_char *rb;
> +	struct i2c_algo_cpm_data *cpm = adap->algo_data;
> +	iic_t *iip = cpm->iip;
> +	int i, dscan;
> +
> +	tbdf = (cbd_t *) cpm_dpram_addr(in_be16(&iip->iic_tbase));
> +	rbdf = (cbd_t *) cpm_dpram_addr(in_be16(&iip->iic_rbase));
> +
> +	/* This chip can't do zero lenth writes. However, the i2c core uses

s/lenth/length/

> +	if (pmsg->flags & I2C_M_RD) {
> +		if (cpm_debug)
> +			dev_dbg(&adap->dev, "rx sc %04x, rx sc %04x\n",
> +				tbdf[tx].cbd_sc, rbdf[rx].cbd_sc);
> +		if (tbdf[tx].cbd_sc & BD_SC_NAK) {
> +			if (cpm_debug)
> +				dev_dbg(&adap->dev, "IIC read; no ack\n");
> +			if (pmsg->flags & I2C_M_IGNORE_NAK)
> +				return 0;
> +			else
> +				return -EREMOTEIO;

s/EREMOTEIO/EIO/

> +static int cpm_xfer(struct i2c_adapter *adap, struct i2c_msg *msgs, int num)
> +{
> +	struct i2c_algo_cpm_data *cpm = adap->algo_data;
> +	i2c8xx_t *i2c = cpm->i2c;
> +	iic_t *iip = cpm->iip;
> +	struct i2c_msg *pmsg, *rmsg;
> +	int ret, i;
> +	int tptr;
> +	int rptr;
> +	cbd_t *tbdf, *rbdf;
> +
> +	if (num > CPM_MAXBD)
> +		return -EREMOTEIO;
> +
> +	/* Check if we have any oversized READ requests */
> +	for (i = 0; i < num; i++) {
> +		pmsg = &msgs[i];
> +		if (pmsg->len >= CPM_MAX_READ)
> +			return -EREMOTEIO;
> +	}

s/EREMOTEIO/EINVAL/

> +
> +	mutex_lock(&cpm->iic_mutex);
> +
> +	/* check for and use a microcode relocation patch */
> +	if (cpm->reloc)
> +		cpm_reset_iic_params(cpm);

On every transfer?

> +	while (tptr < num) {
> +		/* Check for outstanding messages */
> +		dev_dbg(&adap->dev, "test ready.\n");
> +		if (!(tbdf[tptr].cbd_sc & BD_SC_READY)) {
> +			dev_dbg(&adap->dev, "ready.\n");
> +			rmsg = &msgs[tptr];
> +			ret = cpm_check_message(adap, rmsg, tptr, rptr);
> +			tptr++;
> +			if (rmsg->flags & I2C_M_RD)
> +				rptr++;
> +			if (ret) {
> +				force_close(adap);
> +				mutex_unlock(&cpm->iic_mutex);
> +				return -EREMOTEIO;

s/-EREMOTEIO/ret/

> +config I2C_8XX
> +	tristate "MPC8xx CPM with Open Firmware"

It's not really Open Firmware... just a flat device tree.

> diff --git a/drivers/i2c/busses/i2c-8xx.c b/drivers/i2c/busses/i2c-8xx.c
> new file mode 100644
> index 0000000..c38b52e
> --- /dev/null
> +++ b/drivers/i2c/busses/i2c-8xx.c
> @@ -0,0 +1,170 @@
> +/*
> + * Embedded Planet RPX Lite MPC8xx CPM I2C interface.
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
> + * This should work for most any 8xx board.  The console messages have been
> + * changed to eliminate RPXLite references.

So let's change the title at the top of the file...

> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/init.h>
> +#include <linux/io.h>
> +#include <linux/stddef.h>
> +#include <linux/platform_device.h>
> +#include <linux/i2c.h>
> +#include <linux/i2c-algo-cpm.h>
> +#include <linux/of_device.h>

Why are you including platform_device, and running glue code in fsl_soc.c,
if this is an of_platform driver?

> +#include <linux/of_platform.h>
> +#include <asm/mpc8xx.h>
> +#include <asm/commproc.h>
> +#include <asm/fs_pd.h>
> +
> +
> +struct m8xx_i2c {
> +	char *base;
> +	struct of_device *ofdev;
> +	struct i2c_adapter adap;
> +	struct i2c_algo_cpm_data *algo_8xx;
> +};
> +
> +static struct i2c_algo_cpm_data m8xx_data;
> +
> +static const struct i2c_adapter m8xx_ops = {
> +	.owner		= THIS_MODULE,
> +	.name		= "i2c-8xx",
> +	.id		= I2C_HW_MPC8XX_EPON,
> +	.algo_data	= &m8xx_data,
> +	.dev.parent	= &platform_bus,
> +	.class		= I2C_CLASS_HWMON,
> +};

It's not on the platform bus; it's on the soc of_platform bus.  Why is this
embedded in the i2c_adapter struct anyway?  i2c_adapter should hold a
pointer to whatever the probe function gives you.

> +	data->irq = irq_of_parse_and_map(np, 0);
> +	if (data->irq < 0)
> +		return -EINVAL;
> +
> +	if (of_address_to_resource(np, 1, &r))
> +		return -EINVAL;
> +
> +	data->iip = ioremap(r.start, r.end - r.start + 1);
> +	if (data->iip == NULL)
> +		return -EINVAL;
> +
> +	/* Check for and use a microcode relocation patch.
> +	 */
> +	data->reloc = data->iip->iic_rpbase;
> +	if (data->reloc)
> +		data->iip = (iic_t *)&cp->cp_dpmem[data->iip->iic_rpbase];
> +
> +	if (of_address_to_resource(np, 0, &r))
> +		return -EINVAL;
> +
> +	data->i2c = ioremap(r.start, r.end - r.start + 1);

Use of_iomap.

> +	if (data->i2c == NULL)
> +		return -EINVAL;
> +
> +	/* Allocate space for two transmit and two receive buffer
> +	 * descriptors in the DP ram.
> +	 */
> +	data->dp_addr = cpm_dpalloc(sizeof(cbd_t) * 4, 8);

Please use the new muram_dpalloc name.

> +	if (!data->dp_addr)
> +		return -ENOMEM;
> +
> +	return 0;
> +}
> +
> +static int i2c_8xx_probe(struct of_device *ofdev,
> +			 const struct of_device_id *match)
> +{
> +	int result;
> +	struct m8xx_i2c *i2c;
> +
> +	i2c = kzalloc(sizeof(*i2c), GFP_KERNEL);
> +	if (!i2c)
> +		return -ENOMEM;
> +
> +	i2c->ofdev = ofdev;
> +	i2c->algo_8xx = &m8xx_data;
> +
> +	m8xx_iic_init(i2c);
> +
> +	dev_set_drvdata(&ofdev->dev, i2c);
> +
> +	i2c->adap = m8xx_ops;
> +	i2c_set_adapdata(&i2c->adap, i2c);
> +	i2c->adap.dev.parent = &ofdev->dev;
> +
> +	result = i2c_cpm_add_bus(&i2c->adap);
> +	if (result < 0) {
> +		printk(KERN_ERR "i2c-8xx: Unable to register with I2C\n");
> +		kfree(i2c);
> +	}
> +
> +	return result;
> +}
> +
> +static int i2c_8xx_remove(struct of_device *ofdev)
> +{
> +	struct m8xx_i2c *i2c = dev_get_drvdata(&ofdev->dev);
> +
> +	i2c_cpm_del_bus(&i2c->adap);
> +	dev_set_drvdata(&ofdev->dev, NULL);
> +
> +	kfree(i2c);
> +	return 0;
> +}
> +
> +static struct of_device_id i2c_8xx_match[] = {
> +	{
> +		.type = "i2c",
> +		.compatible = "fsl,i2c-cpm",
> +	},
> +	{},
> +};
> +

Why is an 8xx driver matching all i2c cpm (i.e. what about cpm2)?

-Scot
