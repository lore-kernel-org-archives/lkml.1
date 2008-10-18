Return-Path: <linux-kernel-owner+w=401wt.eu-S1752120AbYJREhd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752120AbYJREhd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2008 00:37:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751280AbYJREhZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Oct 2008 00:37:25 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45346 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751189AbYJREhX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2008 00:37:23 -0400
Date: Fri, 17 Oct 2008 21:36:31 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Michael Buesch <mb@bu3sch.de>
Cc: "Magnus Damm" <magnus.damm@gmail.com>,
       "David Brownell" <david-b@pacbell.net>,
       "Stephen Rothwell" <sfr@canb.auug.org.au>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Piot Skamruk" <piotr.skamruk@gmail.com>
Subject: Re: [PATCH v3] Add SPI over GPIO driver
Message-Id: <20081017213631.82c49b3a.akpm@linux-foundation.org>
In-Reply-To: <200810171318.32306.mb@bu3sch.de>
References: <200807202146.12759.mb@bu3sch.de>
	<200810171052.54823.mb@bu3sch.de>
	<aec7e5c30810170252t5790af36hfc754d28e69f5159@mail.gmail.com>
	<200810171318.32306.mb@bu3sch.de>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Oct 2008 13:18:32 +0200 Michael Buesch <mb@bu3sch.de> wrote:

> On Friday 17 October 2008 11:52:32 Magnus Damm wrote:
> > [removed closed openwrt-devel list]
> > 
> > On Fri, Oct 17, 2008 at 5:52 PM, Michael Buesch <mb@bu3sch.de> wrote:
> > > On Friday 17 October 2008 05:14:26 Magnus Damm wrote:
> > >> On Mon, Jul 21, 2008 at 4:46 AM, Michael Buesch <mb@bu3sch.de> wrote:
> > >> > This adds a driver that lets you drive an SPI bus over
> > >> > generic GPIO pins.
> > >> >
> > >> > Signed-off-by: Michael Buesch <mb@bu3sch.de>
> > >>
> > >> Very useful. Fits my shiny new GPIO implementation for SuperH like a glove.
> > >>
> > >> Michael, as you know, I have some SuperH board code that makes use of
> > >> this driver. Are there any outstanding issues with this driver that I
> > >> can help resolving?
> > >
> > > bool cs_activelow should probably be removed from struct spi_gpio_platform_data.
> > >
> > > I think cs always is activelow, so we can simply hardcode this in spi_gpio_chipselect()
> > 
> > Really? There _must_ be chips out there that want active high CS!
> > I'd rather keep the activelow option or maybe turn in into activehigh instead.
> 
> Ok, I dunno. I never saw one. All of my SPI stuff is activelow.
> So well, let's keep it.
> 
> > > If you want to do this, please feel free to do so.
> > > I currently don't have the time for this.
> > > The rest of the driver is fine with me.
> > 
> > Ok, thank you.
> > 
> > David or Andrew, any change of getting this merged as-is somehow? Thanks!
> 
> Yes, please merge it.

This patch has some "issues" a month or so ago.  Current status is that
I've pinged David to see if he's OK with a 2.6.28 merge and he hasn't
yet replied.

Let's not bust a gut to get this into 2.6.28-rc1 - let's get it right
rather than fast.  If we end up deciding to merge it into, say,
2.6.28-rc2 then that should be OK under the circumstances.


From: Michael Buesch <mb@bu3sch.de>

This adds a driver that lets you drive an SPI bus over generic GPIO pins.

Signed-off-by: Michael Buesch <mb@bu3sch.de>
Cc: David Brownell <david-b@pacbell.net>
Cc: Pierre Ossman <drzeus-list@drzeus.cx>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS                  |    5 
 drivers/spi/Kconfig          |   13 +
 drivers/spi/Makefile         |    1 
 drivers/spi/spi_gpio.c       |  252 +++++++++++++++++++++++++++++++++
 include/linux/spi/spi_gpio.h |   73 +++++++++
 5 files changed, 344 insertions(+)

diff -puN MAINTAINERS~spi-add-spi-over-gpio-driver MAINTAINERS
--- a/MAINTAINERS~spi-add-spi-over-gpio-driver
+++ a/MAINTAINERS
@@ -3911,6 +3911,11 @@ M:	jens@de.ibm.com
 L:	netdev@vger.kernel.org
 S:	Supported
 
+SPI GPIO MASTER DRIVER
+P:	Michael Buesch
+M:	mb@bu3sch.de
+S:	Maintained
+
 SPU FILE SYSTEM
 P:	Jeremy Kerr
 M:	jk@ozlabs.org
diff -puN drivers/spi/Kconfig~spi-add-spi-over-gpio-driver drivers/spi/Kconfig
--- a/drivers/spi/Kconfig~spi-add-spi-over-gpio-driver
+++ a/drivers/spi/Kconfig
@@ -100,6 +100,19 @@ config SPI_BUTTERFLY
 	  inexpensive battery powered microcontroller evaluation board.
 	  This same cable can be used to flash new firmware.
 
+config SPI_GPIO
+	tristate "GPIO API based bitbanging SPI controller"
+	depends on SPI_MASTER && GENERIC_GPIO
+	select SPI_BITBANG
+	help
+	  This is a platform driver that can be used for bitbanging
+	  an SPI bus over GPIO pins.
+	  Select this if you have any SPI device that is connected via
+	  GPIO pins.
+	  The module will be called spi_gpio.
+
+	  If unsure, say N.
+
 config SPI_IMX
 	tristate "Freescale iMX SPI controller"
 	depends on ARCH_IMX && EXPERIMENTAL
diff -puN drivers/spi/Makefile~spi-add-spi-over-gpio-driver drivers/spi/Makefile
--- a/drivers/spi/Makefile~spi-add-spi-over-gpio-driver
+++ a/drivers/spi/Makefile
@@ -16,6 +16,7 @@ obj-$(CONFIG_SPI_BFIN)			+= spi_bfin5xx.
 obj-$(CONFIG_SPI_BITBANG)		+= spi_bitbang.o
 obj-$(CONFIG_SPI_AU1550)		+= au1550_spi.o
 obj-$(CONFIG_SPI_BUTTERFLY)		+= spi_butterfly.o
+obj-$(CONFIG_SPI_GPIO)			+= spi_gpio.o
 obj-$(CONFIG_SPI_IMX)			+= spi_imx.o
 obj-$(CONFIG_SPI_LM70_LLP)		+= spi_lm70llp.o
 obj-$(CONFIG_SPI_PXA2XX)		+= pxa2xx_spi.o
diff -puN /dev/null drivers/spi/spi_gpio.c
--- /dev/null
+++ a/drivers/spi/spi_gpio.c
@@ -0,0 +1,252 @@
+/*
+ * Bitbanging SPI bus driver using GPIO API
+ *
+ * Copyright (c) 2008 Piotr Skamruk
+ * Copyright (c) 2008 Michael Buesch
+ *
+ * based on spi_s3c2410_gpio.c
+ *   Copyright (c) 2006 Ben Dooks
+ *   Copyright (c) 2006 Simtec Electronics
+ * and on i2c-gpio.c
+ *   Copyright (C) 2007 Atmel Corporation
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/delay.h>
+#include <linux/spinlock.h>
+#include <linux/workqueue.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/spi/spi.h>
+#include <linux/spi/spi_bitbang.h>
+#include <linux/spi/spi_gpio.h>
+#include <linux/gpio.h>
+#include <asm/atomic.h>
+
+
+struct spi_gpio {
+	struct spi_bitbang bitbang;
+	struct spi_gpio_platform_data *info;
+	struct platform_device *pdev;
+	struct spi_board_info bi;
+};
+
+
+static inline struct spi_gpio *spidev_to_sg(struct spi_device *dev)
+{
+	return dev->controller_data;
+}
+
+static inline void setsck(struct spi_device *dev, int val)
+{
+	struct spi_gpio *sp = spidev_to_sg(dev);
+	gpio_set_value(sp->info->pin_clk, val ? 1 : 0);
+}
+
+static inline void setmosi(struct spi_device *dev, int val)
+{
+	struct spi_gpio *sp = spidev_to_sg(dev);
+	gpio_set_value(sp->info->pin_mosi, val ? 1 : 0);
+}
+
+static inline u32 getmiso(struct spi_device *dev)
+{
+	struct spi_gpio *sp = spidev_to_sg(dev);
+	return gpio_get_value(sp->info->pin_miso) ? 1 : 0;
+}
+
+static inline void do_spidelay(struct spi_device *dev, unsigned nsecs)
+{
+	struct spi_gpio *sp = spidev_to_sg(dev);
+
+	if (!sp->info->no_spi_delay)
+		ndelay(nsecs);
+}
+
+#define spidelay(nsecs) do {					\
+	/* Steal the spi_device pointer from our caller.	\
+	 * The bitbang-API should probably get fixed here... */	\
+	do_spidelay(spi, nsecs);				\
+  } while (0)
+
+#define EXPAND_BITBANG_TXRX
+#include <linux/spi/spi_bitbang.h>
+
+static u32 spi_gpio_txrx_mode0(struct spi_device *spi,
+			       unsigned nsecs, u32 word, u8 bits)
+{
+	return bitbang_txrx_be_cpha0(spi, nsecs, 0, word, bits);
+}
+
+static u32 spi_gpio_txrx_mode1(struct spi_device *spi,
+			       unsigned nsecs, u32 word, u8 bits)
+{
+	return bitbang_txrx_be_cpha1(spi, nsecs, 0, word, bits);
+}
+
+static u32 spi_gpio_txrx_mode2(struct spi_device *spi,
+			       unsigned nsecs, u32 word, u8 bits)
+{
+	return bitbang_txrx_be_cpha0(spi, nsecs, 1, word, bits);
+}
+
+static u32 spi_gpio_txrx_mode3(struct spi_device *spi,
+			       unsigned nsecs, u32 word, u8 bits)
+{
+	return bitbang_txrx_be_cpha1(spi, nsecs, 1, word, bits);
+}
+
+static void spi_gpio_chipselect(struct spi_device *dev, int on)
+{
+	struct spi_gpio *sp = spidev_to_sg(dev);
+
+	if (sp->info->cs_activelow)
+		on = !on;
+	gpio_set_value(sp->info->pin_cs, on ? 1 : 0);
+}
+
+static int spi_gpio_probe(struct platform_device *pdev)
+{
+	struct spi_master *master;
+	struct spi_gpio_platform_data *pdata;
+	struct spi_gpio *sp;
+	struct spi_device *spidev;
+	int err;
+
+	pdata = pdev->dev.platform_data;
+	if (!pdata)
+		return -ENXIO;
+
+	err = -ENOMEM;
+	master = spi_alloc_master(&pdev->dev, sizeof(struct spi_gpio));
+	if (!master)
+		goto err_alloc_master;
+
+	sp = spi_master_get_devdata(master);
+	platform_set_drvdata(pdev, sp);
+	sp->info = pdata;
+
+	err = gpio_request(pdata->pin_clk, "spi_clock");
+	if (err)
+		goto err_request_clk;
+	err = gpio_request(pdata->pin_mosi, "spi_mosi");
+	if (err)
+		goto err_request_mosi;
+	err = gpio_request(pdata->pin_miso, "spi_miso");
+	if (err)
+		goto err_request_miso;
+	err = gpio_request(pdata->pin_cs, "spi_cs");
+	if (err)
+		goto err_request_cs;
+
+	sp->bitbang.master = spi_master_get(master);
+	sp->bitbang.master->bus_num = -1;
+	sp->bitbang.master->num_chipselect = 1;
+	sp->bitbang.chipselect = spi_gpio_chipselect;
+	sp->bitbang.txrx_word[SPI_MODE_0] = spi_gpio_txrx_mode0;
+	sp->bitbang.txrx_word[SPI_MODE_1] = spi_gpio_txrx_mode1;
+	sp->bitbang.txrx_word[SPI_MODE_2] = spi_gpio_txrx_mode2;
+	sp->bitbang.txrx_word[SPI_MODE_3] = spi_gpio_txrx_mode3;
+
+	gpio_direction_output(pdata->pin_clk, 0);
+	gpio_direction_output(pdata->pin_mosi, 0);
+	gpio_direction_output(pdata->pin_cs,
+			      pdata->cs_activelow ? 1 : 0);
+	gpio_direction_input(pdata->pin_miso);
+
+	err = spi_bitbang_start(&sp->bitbang);
+	if (err)
+		goto err_no_bitbang;
+	err = pdata->boardinfo_setup(&sp->bi, master,
+				     pdata->boardinfo_setup_data);
+	if (err)
+		goto err_bi_setup;
+	sp->bi.controller_data = sp;
+	err = -ENOMEM;
+	spidev = spi_new_device(master, &sp->bi);
+	if (!spidev)
+		goto err_new_dev;
+
+	return 0;
+
+err_new_dev:
+err_bi_setup:
+	spi_bitbang_stop(&sp->bitbang);
+err_no_bitbang:
+	spi_master_put(sp->bitbang.master);
+	gpio_free(pdata->pin_cs);
+err_request_cs:
+	gpio_free(pdata->pin_miso);
+err_request_miso:
+	gpio_free(pdata->pin_mosi);
+err_request_mosi:
+	gpio_free(pdata->pin_clk);
+err_request_clk:
+	kfree(master);
+
+err_alloc_master:
+	return err;
+}
+
+static int __devexit spi_gpio_remove(struct platform_device *pdev)
+{
+	struct spi_gpio *sp;
+	struct spi_gpio_platform_data *pdata;
+
+	pdata = pdev->dev.platform_data;
+	sp = platform_get_drvdata(pdev);
+
+	gpio_free(pdata->pin_clk);
+	gpio_free(pdata->pin_mosi);
+	gpio_free(pdata->pin_miso);
+	gpio_free(pdata->pin_cs);
+	spi_bitbang_stop(&sp->bitbang);
+	spi_master_put(sp->bitbang.master);
+
+	return 0;
+}
+
+static struct platform_driver spi_gpio_driver = {
+	.driver		= {
+		.name	= SPI_GPIO_PLATDEV_NAME,
+		.owner	= THIS_MODULE,
+	},
+	.probe		= spi_gpio_probe,
+	.remove		= __devexit_p(spi_gpio_remove),
+};
+
+int spi_gpio_next_id(void)
+{
+	static atomic_t counter = ATOMIC_INIT(-1);
+
+	return atomic_inc_return(&counter);
+}
+EXPORT_SYMBOL(spi_gpio_next_id);
+
+static int __init spi_gpio_init(void)
+{
+	int err;
+
+	err = platform_driver_register(&spi_gpio_driver);
+	if (err)
+		printk(KERN_ERR "spi-gpio: register failed: %d\n", err);
+
+	return err;
+}
+module_init(spi_gpio_init);
+
+static void __exit spi_gpio_exit(void)
+{
+	platform_driver_unregister(&spi_gpio_driver);
+}
+module_exit(spi_gpio_exit);
+
+MODULE_AUTHOR("Piot Skamruk <piotr.skamruk at gmail.com>");
+MODULE_AUTHOR("Michael Buesch");
+MODULE_DESCRIPTION("Platform independent GPIO bitbanging SPI driver");
+MODULE_LICENSE("GPL v2");
diff -puN /dev/null include/linux/spi/spi_gpio.h
--- /dev/null
+++ a/include/linux/spi/spi_gpio.h
@@ -0,0 +1,73 @@
+/*
+ * spi_gpio interface to platform code
+ *
+ * Copyright (c) 2008 Piotr Skamruk
+ * Copyright (c) 2008 Michael Buesch
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#ifndef _LINUX_SPI_SPI_GPIO
+#define _LINUX_SPI_SPI_GPIO
+
+#include <linux/types.h>
+#include <linux/spi/spi.h>
+
+
+/**
+ * struct spi_gpio_platform_data - Data definitions for a SPI-GPIO device.
+ *
+ * This structure holds information about a GPIO-based SPI device.
+ *
+ * @pin_clk: The GPIO pin number of the CLOCK pin.
+ *
+ * @pin_miso: The GPIO pin number of the MISO pin.
+ *
+ * @pin_mosi: The GPIO pin number of the MOSI pin.
+ *
+ * @pin_cs: The GPIO pin number of the CHIPSELECT pin.
+ *
+ * @cs_activelow: If true, the chip is selected when the CS line is low.
+ *
+ * @no_spi_delay: If true, no delay is done in the lowlevel bitbanging.
+ *                Note that doing no delay is not standards compliant,
+ *                but it might be needed to speed up transfers on some
+ *                slow embedded machines.
+ *
+ * @boardinfo_setup: This callback is called after the
+ *                   SPI master device was registered, but before the
+ *                   device is registered.
+ * @boardinfo_setup_data: Data argument passed to boardinfo_setup().
+ */
+struct spi_gpio_platform_data {
+	unsigned int pin_clk;
+	unsigned int pin_miso;
+	unsigned int pin_mosi;
+	unsigned int pin_cs;
+	bool cs_activelow;
+	bool no_spi_delay;
+	int (*boardinfo_setup)(struct spi_board_info *bi,
+			       struct spi_master *master,
+			       void *data);
+	void *boardinfo_setup_data;
+};
+
+/**
+ * SPI_GPIO_PLATDEV_NAME - The platform device name string.
+ *
+ * The name string that has to be used for platform_device_alloc
+ * when allocating a spi-gpio device.
+ */
+#define SPI_GPIO_PLATDEV_NAME	"spi-gpio"
+
+/**
+ * spi_gpio_next_id - Get another platform device ID number.
+ *
+ * This returns the next platform device ID number that has to be used
+ * for platform_device_alloc. The ID is opaque and should not be used for
+ * anything else.
+ */
+int spi_gpio_next_id(void);
+
+#endif /* _LINUX_SPI_SPI_GPIO */
_


