Return-Path: <linux-kernel-owner+w=401wt.eu-S933805AbXCUTXz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933805AbXCUTXz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 15:23:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933807AbXCUTXz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 15:23:55 -0400
Received: from smtp-103-wednesday.noc.nerim.net ([62.4.17.103]:2985 "EHLO
	mallaury.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933805AbXCUTXy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 15:23:54 -0400
Date: Wed, 21 Mar 2007 20:22:31 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Bryan Wu <bryan.wu@analog.com>
Cc: David Brownell <david-b@pacbell.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alexey Dobriyan <adobriyan@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm 4/4] Blackfin: on-chip Two Wire Interface I2C driver
Message-Id: <20070321202231.2eac1cf9.khali@linux-fr.org>
In-Reply-To: <1174471688.5648.56.camel@roc-desktop>
References: <1174471688.5648.56.camel@roc-desktop>
X-Mailer: Sylpheed version 2.2.10 (GTK+ 2.8.20; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bryan,

On Wed, 21 Mar 2007 18:08:08 +0800, Wu, Bryan wrote:
> As GPIO based blackfin driver will be replaced by I2C-GPIO generic
> driver, we just update this latest version of blackfin on-chip TWI I2C
> driver according to LKML review.
> 
> [PATCH] Blackfin: on-chip Two Wire Interface I2C driver
> 
> The i2c linux driver for blackfin architecture which supports blackfin
> on-chip TWI controller i2c operation.
> 
> Signed-off-by: Bryan Wu <bryan.wu@analog.com>
> Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
> Reviewed-by: Alexey Dobriyan <adobriyan@gmail.com>
> Reviewed-by: Jean Delvare <khali@linux-fr.org>
> Cc: David Brownell <david-b@pacbell.net>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  drivers/i2c/busses/Kconfig        |   16 
>  drivers/i2c/busses/Makefile       |    1 
>  drivers/i2c/busses/i2c-bfin-twi.c |  653 ++++++++++++++++++++++++++++++++++++++
>  3 files changed, 670 insertions(+)

I overlooked a number of problems in the probe function, sorry.

> Index: linux-2.6/drivers/i2c/busses/Makefile
> ===================================================================
> --- linux-2.6.orig/drivers/i2c/busses/Makefile
> +++ linux-2.6/drivers/i2c/busses/Makefile
> @@ -10,6 +10,7 @@
>  obj-$(CONFIG_I2C_AMD8111)	+= i2c-amd8111.o
>  obj-$(CONFIG_I2C_AT91)		+= i2c-at91.o
>  obj-$(CONFIG_I2C_AU1550)	+= i2c-au1550.o
> +obj-$(CONFIG_I2C_BLACKFIN_TWI)  += i2c-bfin-twi.o

Please align with a tab, not spaces.

>  obj-$(CONFIG_I2C_ELEKTOR)	+= i2c-elektor.o
>  obj-$(CONFIG_I2C_HYDRA)		+= i2c-hydra.o
>  obj-$(CONFIG_I2C_I801)		+= i2c-i801.o
> Index: linux-2.6/drivers/i2c/busses/i2c-bfin-twi.c
> ===================================================================
> --- /dev/null
> +++ linux-2.6/drivers/i2c/busses/i2c-bfin-twi.c
> (...)
> +static int i2c_bfin_twi_probe(struct platform_device *dev)
> +{
> +	struct bfin_twi_iface *iface = &twi_iface;
> +	struct i2c_adapter *p_adap;
> +	int rc;
> +
> +	mutex_init(&(iface->twi_lock));
> +	spin_lock_init(&(iface->lock));
> +	init_completion(&(iface->complete));
> +	iface->irq = IRQ_TWI;
> +
> +	init_timer(&(iface->timeout_timer));
> +	iface->timeout_timer.function = bfin_twi_timeout;
> +	iface->timeout_timer.data = (unsigned long)iface;
> +
> +	p_adap = &(iface->adap);
> +	p_adap->id = I2C_DRIVERID_BLACKFINTWI;

This isn't defined anywhere, and isn't valid anyway. I2C_DRIVERID_* are
for I2C chip drivers, not bus drivers.

> +	strlcpy(p_adap->name, dev->name, I2C_NAME_SIZE);

I2C_NAME_SIZE changed recently, it no longer applies to
i2c_adapter.name. Please use sizeof(p_adap->name) instead.

> +	p_adap->algo = &bfin_twi_algorithm;
> +	p_adap->algo_data = iface;
> +	p_adap->class = I2C_CLASS_ALL;

This pretty much voids the point of these probing classes. You should
only select the classes matching devices which may actually be probed
for on this bus. If different boards have different needs, get the
right classes from the platform data.

> +	p_adap->dev.parent = &(dev->dev);

Note that parentheses are not needed.

> +
> +	rc = request_irq(iface->irq, bfin_twi_interrupt_entry,
> +		SA_INTERRUPT, dev->name, iface);
> +	if (rc) {
> +		printk(KERN_ERR"i2c-bfin-twi: can't get IRQ %d !\n",
> +			iface->irq);

Usually we leave a space between KERN_* and the beginning of the string
- I'm even surprised that it compiles without it. OTOH there is no
space before exclamation marks in English.

Oh, and it should be dev_err() anyway.

> +		return -ENODEV;
> +	}
> +
> +	/* Set TWI internal clock as 10MHz */
> +	bfin_write_TWI_CONTROL(((get_sclk() / 1024 / 1024 + 5) / 10) & 0x7F);
> +
> +	/* Set Twi interface clock as specified */
> +	if (CONFIG_I2C_BLACKFIN_TWI_CLK_KHZ > 400)
> +		bfin_write_TWI_CLKDIV((( 5*1024 / 400 ) << 8) |
> +			(( 5*1024 / 400 ) & 0xFF));

This can never happen, as you have a range defined in Kconfig.

> +	else
> +		bfin_write_TWI_CLKDIV((( 5*1024 / CONFIG_I2C_BLACKFIN_TWI_CLK_KHZ )
> +			<< 8) | (( 5*1024 / CONFIG_I2C_BLACKFIN_TWI_CLK_KHZ )
> +			& 0xFF));
> +
> +	/* Enable TWI */
> +	bfin_write_TWI_CONTROL(bfin_read_TWI_CONTROL() | TWI_ENA);
> +	SSYNC();
> +
> +	rc = i2c_add_adapter(p_adap);
> +	if (rc < 0)
> +		free_irq(iface->irq, iface);
> +	else
> +		platform_set_drvdata(dev, iface);
> +
> +	return rc;
> +}

> +static struct platform_driver i2c_bfin_twi_driver = {
> +	.probe		= i2c_bfin_twi_probe,
> +	.remove		= i2c_bfin_twi_remove,
> +	.suspend	= i2c_bfin_twi_suspend,
> +	.resume		= i2c_bfin_twi_resume,
> +	.driver		= {
> +		.name	= "i2c-bfin-twi",
> +	},
> +};

Missing .owner = THIS_MODULE.

Thanks,
-- 
Jean Delvare
