Return-Path: <linux-kernel-owner+w=401wt.eu-S1759593AbYF3Jud@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759593AbYF3Jud (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 05:50:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754082AbYF3JuY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 05:50:24 -0400
Received: from www.tglx.de ([62.245.132.106]:34847 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753887AbYF3JuX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 05:50:23 -0400
Date: Mon, 30 Jun 2008 11:50:15 +0200
From: "Hans J. Koch" <hjk@linutronix.de>
To: Michael Buesch <mb@bu3sch.de>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Drivers for selfmade hardware
Message-ID: <20080630095014.GA3211@local>
References: <200806292147.52112.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200806292147.52112.mb@bu3sch.de>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 29, 2008 at 09:47:52PM +0200, Michael Buesch wrote:
> I'm wondering what the policy is for selfmade hardware
> or other hardware where only a few pieces exist. Is it desired
> to get drivers for this kind of hardware merged upstream into the
> mainline kernel?
> 
> I have a tiny driver that can be used to drive a modified
> Brooktree 8xx based card in 24-port GPIO mode.
> So the card can be used as a cheap digital PCI GPIO card.
> This hardware can be built with some soldering skills, a tiny
> soldering tip and a few hours of free time.

This driver is not only useful for PCI TV cards. With little
modification, it could be used for bttv chips integrated in embedded
systems as platform devices. You might have more users than you think
;-)

> 
> So what's the policy? Push to mainline or keep as seperate
> patch?

Definetly mainline. But don't forget to cc: other relevant
maintainers/lists (v4l, gpio, maybe linux-embedded).

hjk

> 
> (The following patch is not complete, but just what I have for now
> to show you...)
> 
> Index: linux-2.6/drivers/gpio/Kconfig
> ===================================================================
> --- linux-2.6.orig/drivers/gpio/Kconfig	2008-05-01 13:19:48.000000000 +0200
> +++ linux-2.6/drivers/gpio/Kconfig	2008-06-29 21:19:26.000000000 +0200
> @@ -61,6 +61,24 @@ config GPIO_PCF857X
>  	  This driver provides an in-kernel interface to those GPIOs using
>  	  platform-neutral GPIO calls.
>  
> +comment "PCI GPIO expanders:"
> +
> +config GPIO_BT8XX
> +	tristate "BT8XX GPIO abuser"
> +	depends on PCI && !VIDEO_BT848
> +	help
> +	  The BT8xx frame grabber chip has 24 GPIO pins than can be abused
> +	  as a cheap PCI GPIO card.
> +
> +	  This chip can be found on Miro, Hauppauge and STB TV-cards.
> +
> +	  The card needs to be physically altered for using it as a
> +	  GPIO card. For more information on how to build a GPIO card
> +	  from a BT8xx TV card, see the following link:
> +	  http://bu3sch.de/btgpio.php
> +
> +	  If unsure, say N.
> +
>  comment "SPI GPIO expanders:"
>  
>  config GPIO_MCP23S08
> Index: linux-2.6/drivers/gpio/Makefile
> ===================================================================
> --- linux-2.6.orig/drivers/gpio/Makefile	2008-05-01 13:19:48.000000000 +0200
> +++ linux-2.6/drivers/gpio/Makefile	2008-06-29 17:58:05.000000000 +0200
> @@ -7,3 +7,4 @@ obj-$(CONFIG_HAVE_GPIO_LIB)	+= gpiolib.o
>  obj-$(CONFIG_GPIO_MCP23S08)	+= mcp23s08.o
>  obj-$(CONFIG_GPIO_PCA953X)	+= pca953x.o
>  obj-$(CONFIG_GPIO_PCF857X)	+= pcf857x.o
> +obj-$(CONFIG_GPIO_BT8XX)	+= btgpio.o
> Index: linux-2.6/drivers/gpio/btgpio.c
> ===================================================================
> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ linux-2.6/drivers/gpio/btgpio.c	2008-06-29 19:21:23.000000000 +0200
> @@ -0,0 +1,334 @@
> +/*
> +
> +    bt8xx GPIO abuser
> +
> +    Copyright (C) 2008 Michael Buesch <mb@bu3sch.de>
> +
> +    Please do _only_ contact Michael Buesch with issues related to this driver.
> +    All the other people listed below are not related to this driver. Their names
> +    are only here, because this driver is derived from the bt848 driver.
> +
> +
> +    Derived from the bt848 driver:
> +
> +    Copyright (C) 1996,97,98 Ralph  Metzler
> +			   & Marcus Metzler
> +    (c) 1999-2002 Gerd Knorr
> +
> +    some v4l2 code lines are taken from Justin's bttv2 driver which is
> +    (c) 2000 Justin Schoeman
> +
> +    V4L1 removal from:
> +    (c) 2005-2006 Nickolay V. Shmyrev
> +
> +    Fixes to be fully V4L2 compliant by
> +    (c) 2006 Mauro Carvalho Chehab
> +
> +    Cropping and overscan support
> +    Copyright (C) 2005, 2006 Michael H. Schimek
> +    Sponsored by OPQ Systems AB
> +
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
> +*/
> +
> +#include <linux/module.h>
> +#include <linux/pci.h>
> +#include <linux/spinlock.h>
> +#include <asm/gpio.h>
> +
> +/* Steal the hardware definitions from the bttv driver. */
> +#include "../media/video/bt8xx/bt848.h"
> +
> +
> +struct btgpio {
> +	spinlock_t lock;
> +
> +	void __iomem *mmio;
> +	struct pci_dev *pdev;
> +	struct gpio_chip gpio;
> +
> +#ifdef CONFIG_PM
> +	u32 saved_outen;
> +	u32 saved_data;
> +#endif
> +};
> +
> +#define bgwrite(dat,adr)    writel((dat), bg->mmio+(adr))
> +#define bgread(adr)         readl(bg->mmio+(adr))
> +
> +
> +static int btgpio_gpio_direction_input(struct gpio_chip *gpio, unsigned nr)
> +{
> +	struct btgpio *bg = container_of(gpio, struct btgpio, gpio);
> +	unsigned long flags;
> +	u32 outen, data;
> +
> +	spin_lock_irqsave(&bg->lock, flags);
> +
> +	data = bgread(BT848_GPIO_DATA);
> +	data &= ~(1 << nr);
> +	bgwrite(data, BT848_GPIO_DATA);
> +
> +	outen = bgread(BT848_GPIO_OUT_EN);
> +	outen &= ~(1 << nr);
> +	bgwrite(outen, BT848_GPIO_OUT_EN);
> +
> +	spin_unlock_irqrestore(&bg->lock, flags);
> +
> +	return 0;
> +}
> +
> +static int btgpio_gpio_get(struct gpio_chip *gpio, unsigned nr)
> +{
> +	struct btgpio *bg = container_of(gpio, struct btgpio, gpio);
> +	unsigned long flags;
> +	u32 val;
> +
> +	spin_lock_irqsave(&bg->lock, flags);
> +	val = bgread(BT848_GPIO_DATA);
> +	spin_unlock_irqrestore(&bg->lock, flags);
> +
> +	return !!(val & (1 << nr));
> +}
> +
> +static int btgpio_gpio_direction_output(struct gpio_chip *gpio,
> +					unsigned nr, int val)
> +{
> +	struct btgpio *bg = container_of(gpio, struct btgpio, gpio);
> +	unsigned long flags;
> +	u32 outen, data;
> +
> +	spin_lock_irqsave(&bg->lock, flags);
> +
> +	data = bgread(BT848_GPIO_DATA);
> +	if (val)
> +		data |= (1 << nr);
> +	else
> +		data &= ~(1 << nr);
> +	bgwrite(data, BT848_GPIO_DATA);
> +
> +	outen = bgread(BT848_GPIO_OUT_EN);
> +	outen |= (1 << nr);
> +	bgwrite(outen, BT848_GPIO_OUT_EN);
> +
> +	spin_unlock_irqrestore(&bg->lock, flags);
> +
> +	return 0;
> +}
> +
> +static void btgpio_gpio_set(struct gpio_chip *gpio,
> +			    unsigned nr, int val)
> +{
> +	struct btgpio *bg = container_of(gpio, struct btgpio, gpio);
> +	unsigned long flags;
> +	u32 data;
> +
> +	spin_lock_irqsave(&bg->lock, flags);
> +
> +	data = bgread(BT848_GPIO_DATA);
> +	if (val)
> +		data |= (1 << nr);
> +	else
> +		data &= ~(1 << nr);
> +	bgwrite(data, BT848_GPIO_DATA);
> +
> +	spin_unlock_irqrestore(&bg->lock, flags);
> +}
> +
> +static void btgpio_gpio_setup(struct btgpio *bg)
> +{
> +	struct gpio_chip *c = &bg->gpio;
> +
> +	c->label = bg->pdev->dev.bus_id;
> +	c->owner = THIS_MODULE;
> +	c->direction_input = btgpio_gpio_direction_input;
> +	c->get = btgpio_gpio_get;
> +	c->direction_output = btgpio_gpio_direction_output;
> +	c->set = btgpio_gpio_set;
> +	c->dbg_show = NULL;
> +	c->base = -1;
> +	c->ngpio = 24;
> +	c->can_sleep = 0;
> +}
> +
> +static int btgpio_probe(struct pci_dev *dev,
> +			const struct pci_device_id *pci_id)
> +{
> +	struct btgpio *bg;
> +	int err;
> +
> +	bg = kzalloc(sizeof(*bg), GFP_KERNEL);
> +	if (!bg)
> +		return -ENOMEM;
> +
> +	bg->pdev = dev;
> +	spin_lock_init(&bg->lock);
> +
> +	err = pci_enable_device(dev);
> +	if (err) {
> +		printk(KERN_ERR "btgpio: Can't enable device.\n");
> +		goto err_freebg;
> +	}
> +	if (!request_mem_region(pci_resource_start(dev, 0),
> +				pci_resource_len(dev, 0),
> +				"btgpio")) {
> +		printk(KERN_WARNING "btgpio: can't request iomem (0x%llx).\n",
> +		       (unsigned long long)pci_resource_start(dev, 0));
> +		err = -EBUSY;
> +		goto err_disable;
> +	}
> +	pci_set_master(dev);
> +	pci_set_drvdata(dev, bg);
> +
> +	bg->mmio = ioremap(pci_resource_start(dev, 0), 0x1000);
> +	if (!bg->mmio) {
> +		printk(KERN_ERR "btgpio: ioremap() failed\n");
> +		err = -EIO;
> +		goto err_release_mem;
> +	}
> +
> +	/* Disable interrupts */
> +	bgwrite(0, BT848_INT_MASK);
> +
> +	/* gpio init */
> +	bgwrite(0, BT848_GPIO_REG_INP);
> +	bgwrite(0, BT848_GPIO_OUT_EN);
> +
> +	btgpio_gpio_setup(bg);
> +	err = gpiochip_add(&bg->gpio);
> +	if (err) {
> +		printk(KERN_ERR "btgpio: Failed to register GPIOs\n");
> +		goto err_release_mem;
> +	}
> +
> +	printk(KERN_INFO "btgpio: Abusing BT8xx card for GPIO\n");
> +
> +	return 0;
> +
> +err_release_mem:
> +	release_mem_region(pci_resource_start(dev, 0),
> +			   pci_resource_len(dev, 0));
> +	pci_set_drvdata(dev, NULL);
> +err_disable:
> +	pci_disable_device(dev);
> +err_freebg:
> +	kfree(bg);
> +
> +	return err;
> +}
> +
> +static void btgpio_remove(struct pci_dev *pdev)
> +{
> +	struct btgpio *bg = pci_get_drvdata(pdev);
> +
> +	gpiochip_remove(&bg->gpio);
> +
> +	bgwrite(0, BT848_INT_MASK);
> +	bgwrite(~0x0, BT848_INT_STAT);
> +	bgwrite(0x0, BT848_GPIO_OUT_EN);
> +
> +	iounmap(bg->mmio);
> +	release_mem_region(pci_resource_start(pdev,0),
> +			   pci_resource_len(pdev,0));
> +	pci_disable_device(pdev);
> +
> +	pci_set_drvdata(pdev, NULL);
> +	kfree(bg);
> +}
> +
> +#ifdef CONFIG_PM
> +static int btgpio_suspend(struct pci_dev *pdev, pm_message_t state)
> +{
> +	struct btgpio *bg = pci_get_drvdata(pdev);
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&bg->lock, flags);
> +
> +	bg->saved_outen = bgread(BT848_GPIO_OUT_EN);
> +	bg->saved_data = bgread(BT848_GPIO_DATA);
> +
> +	bgwrite(0, BT848_INT_MASK);
> +	bgwrite(~0x0, BT848_INT_STAT);
> +	bgwrite(0x0, BT848_GPIO_OUT_EN);
> +
> +	spin_unlock_irqrestore(&bg->lock, flags);
> +
> +	pci_save_state(pdev);
> +	pci_disable_device(pdev);
> +	pci_set_power_state(pdev, pci_choose_state(pdev, state));
> +
> +	return 0;
> +}
> +
> +static int btgpio_resume(struct pci_dev *pdev)
> +{
> +	struct btgpio *bg = pci_get_drvdata(pdev);
> +	unsigned long flags;
> +	int err;
> +
> +	pci_set_power_state(pdev, 0);
> +	err = pci_enable_device(pdev);
> +	if (err)
> +		return err;
> +	pci_restore_state(pdev);
> +
> +	spin_lock_irqsave(&bg->lock, flags);
> +
> +	bgwrite(0, BT848_INT_MASK);
> +	bgwrite(0, BT848_GPIO_REG_INP);
> +	bgwrite(bg->saved_outen, BT848_GPIO_OUT_EN);
> +	bgwrite(bg->saved_data, BT848_GPIO_DATA);
> +
> +	spin_unlock_irqrestore(&bg->lock, flags);
> +
> +	return 0;
> +}
> +#endif /* CONFIG_PM */
> +
> +static struct pci_device_id btgpio_pci_tbl[] = {
> +	{ PCI_DEVICE(PCI_VENDOR_ID_BROOKTREE, PCI_DEVICE_ID_BT848) },
> +	{ PCI_DEVICE(PCI_VENDOR_ID_BROOKTREE, PCI_DEVICE_ID_BT849) },
> +	{ PCI_DEVICE(PCI_VENDOR_ID_BROOKTREE, PCI_DEVICE_ID_BT878) },
> +	{ PCI_DEVICE(PCI_VENDOR_ID_BROOKTREE, PCI_DEVICE_ID_BT879) },
> +	{ 0, },
> +};
> +MODULE_DEVICE_TABLE(pci, btgpio_pci_tbl);
> +
> +static struct pci_driver btgpio_pci_driver = {
> +	.name		= "btgpio",
> +	.id_table	= btgpio_pci_tbl,
> +	.probe		= btgpio_probe,
> +	.remove		= btgpio_remove,
> +#ifdef CONFIG_PM
> +	.suspend	= btgpio_suspend,
> +	.resume		= btgpio_resume,
> +#endif
> +};
> +
> +static int btgpio_init(void)
> +{
> +	return pci_register_driver(&btgpio_pci_driver);
> +}
> +module_init(btgpio_init)
> +
> +static void btgpio_exit(void)
> +{
> +	pci_unregister_driver(&btgpio_pci_driver);
> +}
> +module_exit(btgpio_exit)
> +
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("Michael Buesch");
> +MODULE_DESCRIPTION("Abuse a BT8xx framegrabber card as generic GPIO card");
> 
> -- 
> Greetings Michael.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
