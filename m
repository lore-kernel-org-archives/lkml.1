Return-Path: <linux-kernel-owner+w=401wt.eu-S1759526AbYGJRTJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759526AbYGJRTJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 13:19:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759250AbYGJRSs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 13:18:48 -0400
Received: from bu3sch.de ([62.75.166.246]:40710 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758273AbYGJRSr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 13:18:47 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>
Subject: [PATCH v3] Add bt8xxgpio driver
Date: Thu, 10 Jul 2008 19:14:09 +0200
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: mchehab@infradead.org, linux-kernel <linux-kernel@vger.kernel.org>,
       Marcel Holtmann <marcel@holtmann.org>,
       David Brownell <david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807101914.10174.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds the bt8xxgpio driver.
The purpose of the bt8xxgpio driver is to export all of the 24 GPIO pins
available on Brooktree 8xx chips to the kernel GPIO infrastructure.

This makes it possible to use a physically modified BT8xx card as
cheap digital GPIO card.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

---

Please queue this patch for 2.6.27

checkpatch warnings were cleaned up since the last version.
defines were added for PM functions, as requested.

Index: linux-next/drivers/gpio/Kconfig
===================================================================
--- linux-next.orig/drivers/gpio/Kconfig	2008-07-10 19:01:37.000000000 +0200
+++ linux-next/drivers/gpio/Kconfig	2008-07-10 19:01:51.000000000 +0200
@@ -92,6 +92,24 @@ config GPIO_PCF857X
 	  This driver provides an in-kernel interface to those GPIOs using
 	  platform-neutral GPIO calls.
 
+comment "PCI GPIO expanders:"
+
+config GPIO_BT8XX
+	tristate "BT8XX GPIO abuser"
+	depends on PCI && VIDEO_BT848=n
+	help
+	  The BT8xx frame grabber chip has 24 GPIO pins than can be abused
+	  as a cheap PCI GPIO card.
+
+	  This chip can be found on Miro, Hauppauge and STB TV-cards.
+
+	  The card needs to be physically altered for using it as a
+	  GPIO card. For more information on how to build a GPIO card
+	  from a BT8xx TV card, see the documentation file at
+	  Documentation/bt8xxgpio.txt
+
+	  If unsure, say N.
+
 comment "SPI GPIO expanders:"
 
 config GPIO_MCP23S08
Index: linux-next/drivers/gpio/Makefile
===================================================================
--- linux-next.orig/drivers/gpio/Makefile	2008-07-10 19:01:37.000000000 +0200
+++ linux-next/drivers/gpio/Makefile	2008-07-10 19:01:51.000000000 +0200
@@ -7,3 +7,4 @@ obj-$(CONFIG_GPIOLIB)		+= gpiolib.o
 obj-$(CONFIG_GPIO_MCP23S08)	+= mcp23s08.o
 obj-$(CONFIG_GPIO_PCA953X)	+= pca953x.o
 obj-$(CONFIG_GPIO_PCF857X)	+= pcf857x.o
+obj-$(CONFIG_GPIO_BT8XX)	+= bt8xxgpio.o
Index: linux-next/drivers/gpio/bt8xxgpio.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-next/drivers/gpio/bt8xxgpio.c	2008-07-10 19:05:56.000000000 +0200
@@ -0,0 +1,348 @@
+/*
+
+    bt8xx GPIO abuser
+
+    Copyright (C) 2008 Michael Buesch <mb@bu3sch.de>
+
+    Please do _only_ contact the people listed _above_ with issues related to this driver.
+    All the other people listed below are not related to this driver. Their names
+    are only here, because this driver is derived from the bt848 driver.
+
+
+    Derived from the bt848 driver:
+
+    Copyright (C) 1996,97,98 Ralph  Metzler
+			   & Marcus Metzler
+    (c) 1999-2002 Gerd Knorr
+
+    some v4l2 code lines are taken from Justin's bttv2 driver which is
+    (c) 2000 Justin Schoeman
+
+    V4L1 removal from:
+    (c) 2005-2006 Nickolay V. Shmyrev
+
+    Fixes to be fully V4L2 compliant by
+    (c) 2006 Mauro Carvalho Chehab
+
+    Cropping and overscan support
+    Copyright (C) 2005, 2006 Michael H. Schimek
+    Sponsored by OPQ Systems AB
+
+    This program is free software; you can redistribute it and/or modify
+    it under the terms of the GNU General Public License as published by
+    the Free Software Foundation; either version 2 of the License, or
+    (at your option) any later version.
+
+    This program is distributed in the hope that it will be useful,
+    but WITHOUT ANY WARRANTY; without even the implied warranty of
+    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+    GNU General Public License for more details.
+
+    You should have received a copy of the GNU General Public License
+    along with this program; if not, write to the Free Software
+    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+*/
+
+#include <linux/module.h>
+#include <linux/pci.h>
+#include <linux/spinlock.h>
+#include <asm/gpio.h>
+
+/* Steal the hardware definitions from the bttv driver. */
+#include "../media/video/bt8xx/bt848.h"
+
+
+#define BT8XXGPIO_NR_GPIOS		24 /* We have 24 GPIO pins */
+
+
+struct bt8xxgpio {
+	spinlock_t lock;
+
+	void __iomem *mmio;
+	struct pci_dev *pdev;
+	struct gpio_chip gpio;
+
+#ifdef CONFIG_PM
+	u32 saved_outen;
+	u32 saved_data;
+#endif
+};
+
+#define bgwrite(dat, adr)	writel((dat), bg->mmio + (adr))
+#define bgread(adr)		readl(bg->mmio + (adr))
+
+
+static int modparam_gpiobase = -1/* dynamic */;
+module_param_named(gpiobase, modparam_gpiobase, int, 0444);
+MODULE_PARM_DESC(gpiobase, "The GPIO number base. -1 means dynamic, which is the default.");
+
+
+static int bt8xxgpio_gpio_direction_input(struct gpio_chip *gpio, unsigned nr)
+{
+	struct bt8xxgpio *bg = container_of(gpio, struct bt8xxgpio, gpio);
+	unsigned long flags;
+	u32 outen, data;
+
+	spin_lock_irqsave(&bg->lock, flags);
+
+	data = bgread(BT848_GPIO_DATA);
+	data &= ~(1 << nr);
+	bgwrite(data, BT848_GPIO_DATA);
+
+	outen = bgread(BT848_GPIO_OUT_EN);
+	outen &= ~(1 << nr);
+	bgwrite(outen, BT848_GPIO_OUT_EN);
+
+	spin_unlock_irqrestore(&bg->lock, flags);
+
+	return 0;
+}
+
+static int bt8xxgpio_gpio_get(struct gpio_chip *gpio, unsigned nr)
+{
+	struct bt8xxgpio *bg = container_of(gpio, struct bt8xxgpio, gpio);
+	unsigned long flags;
+	u32 val;
+
+	spin_lock_irqsave(&bg->lock, flags);
+	val = bgread(BT848_GPIO_DATA);
+	spin_unlock_irqrestore(&bg->lock, flags);
+
+	return !!(val & (1 << nr));
+}
+
+static int bt8xxgpio_gpio_direction_output(struct gpio_chip *gpio,
+					unsigned nr, int val)
+{
+	struct bt8xxgpio *bg = container_of(gpio, struct bt8xxgpio, gpio);
+	unsigned long flags;
+	u32 outen, data;
+
+	spin_lock_irqsave(&bg->lock, flags);
+
+	outen = bgread(BT848_GPIO_OUT_EN);
+	outen |= (1 << nr);
+	bgwrite(outen, BT848_GPIO_OUT_EN);
+
+	data = bgread(BT848_GPIO_DATA);
+	if (val)
+		data |= (1 << nr);
+	else
+		data &= ~(1 << nr);
+	bgwrite(data, BT848_GPIO_DATA);
+
+	spin_unlock_irqrestore(&bg->lock, flags);
+
+	return 0;
+}
+
+static void bt8xxgpio_gpio_set(struct gpio_chip *gpio,
+			    unsigned nr, int val)
+{
+	struct bt8xxgpio *bg = container_of(gpio, struct bt8xxgpio, gpio);
+	unsigned long flags;
+	u32 data;
+
+	spin_lock_irqsave(&bg->lock, flags);
+
+	data = bgread(BT848_GPIO_DATA);
+	if (val)
+		data |= (1 << nr);
+	else
+		data &= ~(1 << nr);
+	bgwrite(data, BT848_GPIO_DATA);
+
+	spin_unlock_irqrestore(&bg->lock, flags);
+}
+
+static void bt8xxgpio_gpio_setup(struct bt8xxgpio *bg)
+{
+	struct gpio_chip *c = &bg->gpio;
+
+	c->label = bg->pdev->dev.bus_id;
+	c->owner = THIS_MODULE;
+	c->direction_input = bt8xxgpio_gpio_direction_input;
+	c->get = bt8xxgpio_gpio_get;
+	c->direction_output = bt8xxgpio_gpio_direction_output;
+	c->set = bt8xxgpio_gpio_set;
+	c->dbg_show = NULL;
+	c->base = modparam_gpiobase;
+	c->ngpio = BT8XXGPIO_NR_GPIOS;
+	c->can_sleep = 0;
+}
+
+static int bt8xxgpio_probe(struct pci_dev *dev,
+			const struct pci_device_id *pci_id)
+{
+	struct bt8xxgpio *bg;
+	int err;
+
+	bg = kzalloc(sizeof(*bg), GFP_KERNEL);
+	if (!bg)
+		return -ENOMEM;
+
+	bg->pdev = dev;
+	spin_lock_init(&bg->lock);
+
+	err = pci_enable_device(dev);
+	if (err) {
+		printk(KERN_ERR "bt8xxgpio: Can't enable device.\n");
+		goto err_freebg;
+	}
+	if (!request_mem_region(pci_resource_start(dev, 0),
+				pci_resource_len(dev, 0),
+				"bt8xxgpio")) {
+		printk(KERN_WARNING
+		       "bt8xxgpio: Can't request iomem (0x%llx).\n",
+		       (unsigned long long)pci_resource_start(dev, 0));
+		err = -EBUSY;
+		goto err_disable;
+	}
+	pci_set_master(dev);
+	pci_set_drvdata(dev, bg);
+
+	bg->mmio = ioremap(pci_resource_start(dev, 0), 0x1000);
+	if (!bg->mmio) {
+		printk(KERN_ERR "bt8xxgpio: ioremap() failed\n");
+		err = -EIO;
+		goto err_release_mem;
+	}
+
+	/* Disable interrupts */
+	bgwrite(0, BT848_INT_MASK);
+
+	/* gpio init */
+	bgwrite(0, BT848_GPIO_DMA_CTL);
+	bgwrite(0, BT848_GPIO_REG_INP);
+	bgwrite(0, BT848_GPIO_OUT_EN);
+
+	bt8xxgpio_gpio_setup(bg);
+	err = gpiochip_add(&bg->gpio);
+	if (err) {
+		printk(KERN_ERR "bt8xxgpio: Failed to register GPIOs\n");
+		goto err_release_mem;
+	}
+
+	printk(KERN_INFO "bt8xxgpio: Abusing BT8xx card for GPIOs %d to %d\n",
+	       bg->gpio.base, bg->gpio.base + BT8XXGPIO_NR_GPIOS - 1);
+
+	return 0;
+
+err_release_mem:
+	release_mem_region(pci_resource_start(dev, 0),
+			   pci_resource_len(dev, 0));
+	pci_set_drvdata(dev, NULL);
+err_disable:
+	pci_disable_device(dev);
+err_freebg:
+	kfree(bg);
+
+	return err;
+}
+
+static void bt8xxgpio_remove(struct pci_dev *pdev)
+{
+	struct bt8xxgpio *bg = pci_get_drvdata(pdev);
+
+	gpiochip_remove(&bg->gpio);
+
+	bgwrite(0, BT848_INT_MASK);
+	bgwrite(~0x0, BT848_INT_STAT);
+	bgwrite(0x0, BT848_GPIO_OUT_EN);
+
+	iounmap(bg->mmio);
+	release_mem_region(pci_resource_start(pdev, 0),
+			   pci_resource_len(pdev, 0));
+	pci_disable_device(pdev);
+
+	pci_set_drvdata(pdev, NULL);
+	kfree(bg);
+}
+
+#ifdef CONFIG_PM
+static int bt8xxgpio_suspend(struct pci_dev *pdev, pm_message_t state)
+{
+	struct bt8xxgpio *bg = pci_get_drvdata(pdev);
+	unsigned long flags;
+
+	spin_lock_irqsave(&bg->lock, flags);
+
+	bg->saved_outen = bgread(BT848_GPIO_OUT_EN);
+	bg->saved_data = bgread(BT848_GPIO_DATA);
+
+	bgwrite(0, BT848_INT_MASK);
+	bgwrite(~0x0, BT848_INT_STAT);
+	bgwrite(0x0, BT848_GPIO_OUT_EN);
+
+	spin_unlock_irqrestore(&bg->lock, flags);
+
+	pci_save_state(pdev);
+	pci_disable_device(pdev);
+	pci_set_power_state(pdev, pci_choose_state(pdev, state));
+
+	return 0;
+}
+
+static int bt8xxgpio_resume(struct pci_dev *pdev)
+{
+	struct bt8xxgpio *bg = pci_get_drvdata(pdev);
+	unsigned long flags;
+	int err;
+
+	pci_set_power_state(pdev, 0);
+	err = pci_enable_device(pdev);
+	if (err)
+		return err;
+	pci_restore_state(pdev);
+
+	spin_lock_irqsave(&bg->lock, flags);
+
+	bgwrite(0, BT848_INT_MASK);
+	bgwrite(0, BT848_GPIO_DMA_CTL);
+	bgwrite(0, BT848_GPIO_REG_INP);
+	bgwrite(bg->saved_outen, BT848_GPIO_OUT_EN);
+	bgwrite(bg->saved_data & bg->saved_outen,
+		BT848_GPIO_DATA);
+
+	spin_unlock_irqrestore(&bg->lock, flags);
+
+	return 0;
+}
+#else /* CONFIG_PM */
+#define bt8xxgpio_suspend	NULL
+#define bt8xxgpio_resume	NULL
+#endif /* CONFIG_PM */
+
+static struct pci_device_id bt8xxgpio_pci_tbl[] = {
+	{ PCI_DEVICE(PCI_VENDOR_ID_BROOKTREE, PCI_DEVICE_ID_BT848) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_BROOKTREE, PCI_DEVICE_ID_BT849) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_BROOKTREE, PCI_DEVICE_ID_BT878) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_BROOKTREE, PCI_DEVICE_ID_BT879) },
+	{ 0, },
+};
+MODULE_DEVICE_TABLE(pci, bt8xxgpio_pci_tbl);
+
+static struct pci_driver bt8xxgpio_pci_driver = {
+	.name		= "bt8xxgpio",
+	.id_table	= bt8xxgpio_pci_tbl,
+	.probe		= bt8xxgpio_probe,
+	.remove		= bt8xxgpio_remove,
+	.suspend	= bt8xxgpio_suspend,
+	.resume		= bt8xxgpio_resume,
+};
+
+static int bt8xxgpio_init(void)
+{
+	return pci_register_driver(&bt8xxgpio_pci_driver);
+}
+module_init(bt8xxgpio_init)
+
+static void bt8xxgpio_exit(void)
+{
+	pci_unregister_driver(&bt8xxgpio_pci_driver);
+}
+module_exit(bt8xxgpio_exit)
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Michael Buesch");
+MODULE_DESCRIPTION("Abuse a BT8xx framegrabber card as generic GPIO card");
Index: linux-next/MAINTAINERS
===================================================================
--- linux-next.orig/MAINTAINERS	2008-07-10 18:56:01.000000000 +0200
+++ linux-next/MAINTAINERS	2008-07-10 19:01:51.000000000 +0200
@@ -1035,6 +1035,12 @@ M:	fujita.tomonori@lab.ntt.co.jp
 L:	linux-scsi@vger.kernel.org
 S:	Supported
 
+BT8XXGPIO DRIVER
+P:	Michael Buesch
+M:	mb@bu3sch.de
+W:	http://bu3sch.de/btgpio.php
+S:	Maintained
+
 BTTV VIDEO4LINUX DRIVER
 P:	Mauro Carvalho Chehab
 M:	mchehab@infradead.org
Index: linux-next/Documentation/bt8xxgpio.txt
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-next/Documentation/bt8xxgpio.txt	2008-07-10 19:01:51.000000000 +0200
@@ -0,0 +1,67 @@
+===============================================================
+==  BT8XXGPIO driver                                         ==
+==                                                           ==
+==  A driver for a selfmade cheap BT8xx based PCI GPIO-card  ==
+==                                                           ==
+==  For advanced documentation, see                          ==
+==  http://www.bu3sch.de/btgpio.php                          ==
+===============================================================
+
+
+A generic digital 24-port PCI GPIO card can be built out of an ordinary
+Brooktree bt848, bt849, bt878 or bt879 based analog TV tuner card. The
+Brooktree chip is used in old analog Hauppauge WinTV PCI cards. You can easily
+find them used for low prices on the net.
+
+The bt8xx chip does have 24 digital GPIO ports.
+These ports are accessible via 24 pins on the SMD chip package.
+
+
+==============================================
+==  How to physically access the GPIO pins  ==
+==============================================
+
+The are several ways to access these pins. One might unsolder the whole chip
+and put it on a custom PCI board, or one might only unsolder each individual
+GPIO pin and solder that to some tiny wire. As the chip package really is tiny
+there are some advanced soldering skills needed in any case.
+
+The physical pinouts are drawn in the following ASCII art.
+The GPIO pins are marked with G00-G23
+
+                                           G G G G G G G G G G G G     G G G G G G
+                                           0 0 0 0 0 0 0 0 0 0 1 1     1 1 1 1 1 1
+                                           0 1 2 3 4 5 6 7 8 9 0 1     2 3 4 5 6 7
+           | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | |
+           ---------------------------------------------------------------------------
+         --|                               ^                                     ^   |--
+         --|                               pin 86                           pin 67   |--
+         --|                                                                         |--
+         --|                                                               pin 61 >  |-- G18
+         --|                                                                         |-- G19
+         --|                                                                         |-- G20
+         --|                                                                         |-- G21
+         --|                                                                         |-- G22
+         --|                                                               pin 56 >  |-- G23
+         --|                                                                         |--
+         --|                           Brooktree 878/879                             |--
+         --|                                                                         |--
+         --|                                                                         |--
+         --|                                                                         |--
+         --|                                                                         |--
+         --|                                                                         |--
+         --|                                                                         |--
+         --|                                                                         |--
+         --|                                                                         |--
+         --|                                                                         |--
+         --|                                                                         |--
+         --|                                                                         |--
+         --|                                                                         |--
+         --|                                                                         |--
+         --|   O                                                                     |--
+         --|                                                                         |--
+           ---------------------------------------------------------------------------
+           | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | |
+           ^
+           This is pin 1
+


-- 
Greetings Michael.
