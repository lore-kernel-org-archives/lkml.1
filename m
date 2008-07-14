Return-Path: <linux-kernel-owner+w=401wt.eu-S1757877AbYGNUzo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757877AbYGNUzo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 16:55:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756180AbYGNUzf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 16:55:35 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48486 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755891AbYGNUze (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 16:55:34 -0400
Date: Mon, 14 Jul 2008 13:54:41 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Michael Buesch <mb@bu3sch.de>
Cc: sfr@canb.auug.org.au, linux-kernel@vger.kernel.org, david-b@pacbell.net,
       piotr.skamruk@gmail.com, drzeus-mmc@drzeus.cx,
       openwrt-devel@lists.openwrt.org
Subject: Re: [PATCH] Add dynamic MMC-over-SPI-GPIO driver
Message-Id: <20080714135441.e3ef9b0b.akpm@linux-foundation.org>
In-Reply-To: <200807142109.19360.mb@bu3sch.de>
References: <200807142109.19360.mb@bu3sch.de>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Jul 2008 21:09:18 +0200
Michael Buesch <mb@bu3sch.de> wrote:

> This driver provides a sysfs interface to dynamically create
> and destroy GPIO-based MMC/SD card interfaces.
> So an MMC or SD card can be connected to generic GPIO pins
> and be configured dynamically from userspace.
> 
> Signed-off-by: Michael Buesch <mb@bu3sch.de>
> 
> ---
> 
> This driver is used in OpenWrt since quite some time, so please
> consider for inclusion in mainline.
> 
> See the attached OpenWrt initscript for an example on how to use
> the sysfs interface. Documentation should also be added. I'll submit
> a patch for that, later.
> 
> ...
>
> +static int gpiommc_probe(struct platform_device *pdev)
> +{
> +	static int instance;
> +	struct gpiommc_device *d = platform_get_drvdata(pdev);
> +	struct spi_gpio_platform_data pdata;
> +	int err = -ENOMEM;
> +
> +	d->spi_pdev = platform_device_alloc("spi-gpio", instance++);
> +	if (!d->spi_pdev)
> +		goto out;

I guess that incrementing `instance' even if the allocation failed is
somewhat wrong.

> +	memset(&pdata, 0, sizeof(pdata));
> +	pdata.pin_clk = d->pins.gpio_clk;
> +	pdata.pin_miso = d->pins.gpio_do;
> +	pdata.pin_mosi = d->pins.gpio_di;
> +	pdata.pin_cs = d->pins.gpio_cs;
> +	pdata.cs_activelow = 1;
> +	pdata.no_spi_delay = 1;
> +	pdata.boardinfo_setup = gpiommc_boardinfo_setup;
> +	pdata.boardinfo_setup_data = d;
> +
> +	err = platform_device_add_data(d->spi_pdev, &pdata, sizeof(pdata));
> +	if (err)
> +		goto err_free_pdev;
> +	err = platform_device_register(d->spi_pdev);
> +	if (err)
> +		goto err_free_pdata;
> +
> +	printk(KERN_INFO PFX "MMC-Card \"%s\" "
> +	       "attached to GPIO pins %u,%u,%u,%u\n",
> +	       d->name, d->pins.gpio_di, d->pins.gpio_do,
> +	       d->pins.gpio_clk, d->pins.gpio_cs);
> +out:
> +	return err;
> +
> +err_free_pdata:
> +	kfree(d->spi_pdev->dev.platform_data);
> +	d->spi_pdev->dev.platform_data = NULL;
> +err_free_pdev:
> +	platform_device_put(d->spi_pdev);
> +	return err;
> +}
> +
> 
> ...
>
> +static struct gpiommc_device *gpiommc_alloc(struct platform_device *pdev,
> +					    const char *name,
> +					    const struct gpiommc_pins *pins,
> +					    u8 mode)
> +{
> +	struct gpiommc_device *d;
> +
> +	d = kmalloc(sizeof(*d), GFP_KERNEL);
> +	if (!d)
> +		return NULL;
> +
> +	strcpy(d->name, name);

No check for overruns?

> +	memcpy(&d->pins, pins, sizeof(d->pins));

If this had used the typesafe

	d->pins = *pins;

I wouldn't have needed to run all around the place working out if
overflow/underflow checks were needed here.

> +	d->mode = mode;
> +	INIT_LIST_HEAD(&d->list);
> +
> +	return d;
> +}
> +
> 
> ...
>
> +static ssize_t gpiommc_add_store(struct device_driver *drv,
> +				 const char *buf, size_t count)
> +{
> +	int res, err;
> +	char name[GPIOMMC_MAX_NAMELEN + 1];
> +	struct gpiommc_pins pins;
> +	unsigned int mode;
> +
> +	res = sscanf(buf, "%" GPIOMMC_MAX_NAMELEN_STR "s %u,%u,%u,%u %u",
> +		     name, &pins.gpio_di, &pins.gpio_do,
> +		     &pins.gpio_clk, &pins.gpio_cs, &mode);

What's going on here?  So new kernel/userspace ABI.  Not documented in
changelog, not documented in code comments, not documented in
Documentation/ABI.  This forces reviewers to reverse-engineer the
interface design from the implementation and then attempt to review
that design.  Reviewers not happy!

Userspace interfaces are the things which we care about most, because
they are the things which we can never change.  Please document them
prominently.

> +	if (res == 5)
> +		mode = 0;
> +	else if (res != 6)
> +		return -EINVAL;
> +	switch (mode) {
> +	case 0:
> +		mode = SPI_MODE_0;
> +		break;
> +	case 1:
> +		mode = SPI_MODE_1;
> +		break;
> +	case 2:
> +		mode = SPI_MODE_2;
> +		break;
> +	case 3:
> +		mode = SPI_MODE_3;
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +	err = gpiommc_create_device(name, &pins, mode);
> +
> +	return err ? err : count;
> +}
> +
> +static ssize_t gpiommc_remove_show(struct device_driver *drv,
> +				   char *buf)
> +{
> +	return snprintf(buf, PAGE_SIZE, "write device-name to remove the device\n");
> +}

Now that is one weird way in which to document the interface!  What a
waste of kernel text :(

> +static ssize_t gpiommc_remove_store(struct device_driver *drv,
> +				    const char *buf, size_t count)
> +{
> +	int err;
> +
> +	err = gpiommc_destroy_device(buf);
> +
> +	return err ? err : count;
> +}
> +
> +static DRIVER_ATTR(add, 0600,
> +		   gpiommc_add_show, gpiommc_add_store);
> +static DRIVER_ATTR(remove, 0600,
> +		   gpiommc_remove_show, gpiommc_remove_store);
> +
> +static struct platform_driver gpiommc_plat_driver = {
> +	.probe	= gpiommc_probe,
> +	.remove	= gpiommc_remove,
> +	.driver	= {
> +		.name	= DRIVER_NAME,
> +		.owner	= THIS_MODULE,
> +	},
> +};
> +

I'll skip this, pending suitable documentation of the proposed
interface design, and review of that design.

