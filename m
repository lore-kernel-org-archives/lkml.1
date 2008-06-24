Return-Path: <linux-kernel-owner+w=401wt.eu-S1755100AbYFXEFb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755100AbYFXEFb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 00:05:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751229AbYFXEFN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 00:05:13 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48540 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751127AbYFXEFK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 00:05:10 -0400
Date: Mon, 23 Jun 2008 21:04:27 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ben Dooks <ben-linux@fluff.org>
Cc: linux-kernel@vger.kernel.org, arnaud.patard@rtp-net.org
Subject: Re: [patch 2/4] SM501: Add gpiolib support
Message-Id: <20080623210427.a0fda079.akpm@linux-foundation.org>
In-Reply-To: <20080622211405.831466725@fluff.org.uk>
References: <20080622211247.734979275@fluff.org.uk>
	<20080622211405.831466725@fluff.org.uk>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 22 Jun 2008 22:12:49 +0100 Ben Dooks <ben-linux@fluff.org> wrote:

> Add support for exporting the GPIOs on the SM501
> via gpiolib.
> 
> ...
>
> +struct sm501_gpio_chip {
> +	struct gpio_chip	gpio;
> +	struct sm501_gpio	*ourgpio;	/* to get back to parent. */
> +	void __iomem		*regbase;
> +};
> +
> +struct sm501_gpio {
> +	struct sm501_gpio_chip	low;
> +	struct sm501_gpio_chip	high;
> +	spinlock_t		lock;
> +
> +	unsigned int		 registered : 1;
> +	void __iomem		*regs;
> +	struct resource		*regs_res;
> +};
> +
>
> ...
>
> +static int __devinit sm501_gpio_register_chip(struct sm501_devdata *sm,
> +					      struct sm501_gpio *gpio,
> +					      struct sm501_gpio_chip *chip)
> +{
> +	struct sm501_platdata *pdata = sm->platdata;
> +	struct gpio_chip *gchip = &chip->gpio;
> +	unsigned base = pdata->gpio_base;
> +
> +	memcpy(chip, &gpio_chip_template, sizeof(struct gpio_chip));

This memcpy is not particularly readable and the driver will explode if
someone adds a new member to the start of struct sm501_gpio_chip, as
they should be able to do.

Less risky would be:

	memcpy(&chip->gpio, &gpio_chip_template, sizeof(struct gpio_chip));

But why not actually be type-correct and do

	chip->gpio = gpio_chip_template;

?

> +
> +	dev_dbg(sm->dev, "registering gpio block %08llx\n",
> +		(unsigned long long)iobase);
> +
> +	spin_lock_init(&gpio->lock);
> +
> +	gpio->regs_res = request_mem_region(iobase, 0x20, "sm501-gpio");
> +	if (gpio->regs_res == NULL) {
> +		dev_err(sm->dev, "gpio: failed to request region\n");
> +		return -ENXIO;
> +	}
> +
> +	gpio->regs = ioremap(iobase, 0x20);
> +	if (gpio->regs == NULL) {
> +		dev_err(sm->dev, "gpio: failed to remap registers\n");
> +		ret = -ENXIO;
> +		goto err_mapped;
> +	}
> +
> +	/* Register both our chips. */
> +
> +	ret = sm501_gpio_register_chip(sm, gpio, &gpio->low);
> +	if (ret) {
> +		dev_err(sm->dev, "failed to add low chip\n");
> +		goto err_mapped;
> +	}
> +
> +	ret = sm501_gpio_register_chip(sm, gpio, &gpio->high);
> +	if (ret) {
> +		dev_err(sm->dev, "failed to add high chip\n");
> +		goto err_low_chip;
> +	}
> +
> +	gpio->registered = 1;
> +
> +	return 0;
> +
> + err_low_chip:
> +	tmp = gpiochip_remove(&gpio->low.gpio);
> +	if (tmp) {
> +		dev_err(sm->dev, "cannot remove low chip, cannot tidy up\n");
> +		return ret;
> +	}
> +
> + err_mapped:
> +	release_resource(gpio->regs_res);
> +	kfree(gpio->regs_res);
> +
> +	return ret;
> +}

I see an ioremap(), but no iounmap() on the error path.

Would it not be better to match request_mem_region() with
release_mem_region(), rather than the lower-level release_reource()?

> +static void sm501_gpio_remove(struct sm501_devdata *sm)
> +{
> +	int ret;
> +
> +	ret = gpiochip_remove(&sm->gpio.low.gpio);
> +	if (ret)
> +		dev_err(sm->dev, "cannot remove low chip, cannot tidy up\n");
> +
> +	ret = gpiochip_remove(&sm->gpio.high.gpio);
> +	if (ret)
> +		dev_err(sm->dev, "cannot remove high chip, cannot tidy up\n");
> +}

Did we free all the reources here?  I see no other
release_resource/release_mem_region/kfrees in the driver?

> +#else
> +static int sm501_register_gpio(struct sm501_devdata *sm)
> +{
> +	return 0;
> +}
> +
> +static void sm501_gpio_remove(struct sm501_devdata *sm)
> +{
> +}

Might be better to give these an explicit inline rather than trusting
gcc to not be silly.

> +#endif
> +
>  /* sm501_dbg_regs
>   *
>   * Debug attribute to attach to parent device to show core registers
> @@ -1059,6 +1249,8 @@ static int sm501_init_dev(struct sm501_d
>  			sm501_register_usbhost(sm, &mem_avail);
>  		if (idata->devices & (SM501_USE_UART0 | SM501_USE_UART1))
>  			sm501_register_uart(sm, idata->devices);
> +		if (idata->devices & SM501_USE_GPIO)
> +			sm501_register_gpio(sm);
>  	}
>  
>  	ret = sm501_check_clocks(sm);
> @@ -1366,6 +1558,9 @@ static void sm501_dev_remove(struct sm50
>  		sm501_remove_sub(sm, smdev);
>  
>  	device_remove_file(sm->dev, &dev_attr_dbg_regs);
> +
> +	if (sm->gpio.registered)
> +		sm501_gpio_remove(sm);
>  }
>  
>  static void sm501_pci_remove(struct pci_dev *dev)
> Index: linux-2.6.26-rc5-quilt1/drivers/mfd/Kconfig
> ===================================================================
> --- linux-2.6.26-rc5-quilt1.orig/drivers/mfd/Kconfig	2008-06-11 11:29:37.000000000 +0100
> +++ linux-2.6.26-rc5-quilt1/drivers/mfd/Kconfig	2008-06-11 11:31:57.000000000 +0100
> @@ -15,6 +15,14 @@ config MFD_SM501
>  	  interface. The device may be connected by PCI or local bus with
>  	  varying functions enabled.
>  
> +config MFD_SM501_GPIO
> +	bool "Export GPIO via GPIO layer"
> +	depends on MFD_SM501 && HAVE_GPIO_LIB
> +	 ---help---
> +	 This option uses the gpio library layer to export the 64 GPIO
> +	 lines on the SM501. The platform data is used to supply the
> +	 base number for the first GPIO line to register.
> +
>  config MFD_ASIC3
>  	bool "Support for Compaq ASIC3"
>  	depends on GENERIC_HARDIRQS && ARM

