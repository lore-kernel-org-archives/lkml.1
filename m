Return-Path: <linux-kernel-owner+w=401wt.eu-S1755523AbYEZNK2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755523AbYEZNK2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 09:10:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751437AbYEZNKQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 09:10:16 -0400
Received: from rtsoft3.corbina.net ([85.21.88.6]:12134 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751280AbYEZNKN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 09:10:13 -0400
Date: Mon, 26 May 2008 17:10:09 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Pierre Ossman <drzeus-mmc@drzeus.cx>
Cc: David Brownell <dbrownell@users.sourceforge.net>,
       Grant Likely <grant.likely@secretlab.ca>,
       Gary Jennejohn <garyj@denx.de>,
       Guennadi Liakhovetski <g.liakhovetski@gmx.de>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 1/2] mmc_spi: export probe and remove functions
Message-ID: <20080526131009.GA19861@polina.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <20080523182754.GA26891@polina.dev.rtsoft.ru> <20080523182834.GA469@polina.dev.rtsoft.ru> <20080526141836.72db0623@mjolnir.drzeus.cx> <20080526122533.GA9595@polina.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <20080526122533.GA9595@polina.dev.rtsoft.ru>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 26, 2008 at 04:25:33PM +0400, Anton Vorontsov wrote:
> On Mon, May 26, 2008 at 02:18:36PM +0200, Pierre Ossman wrote:
> > On Fri, 23 May 2008 22:28:34 +0400
> > Anton Vorontsov <avorontsov@ru.mvista.com> wrote:
> > 
> > > ...so we'll able to write bindings for the OpenFirmware without
> > > messing with #ifdefs in the driver itself.
> > > 
> > > Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
> > 
> > This looks extremely wrong. Encapsulating probe functions isn't exactly
> > in line with the device model and bound to confuse people.

Btw, this isn't actually drivers encapsulating. This is about making
mmc_spi export some "library" function which could be used by other
bindings.

Think of usb_add_hcd() used by various drivers' bindings for e.g.
drivers/usb/host/ehci-*.c. Though usb_add_hcd() is more generic
than just "EHCI" bindings, but only because there is nothing to
share between them. (for MMC over SPI bindings all we want to do is fill
the platform data).

Another example is drivers/ata/pata_platform.c which exports "library"
function used by the drivers/ata/pata_of_platform.c. This is simply to
avoid code duplication across the bindings.

> > Your patches doesn't give a complete picture of the OF side of things,
> > but can't you solve this by having an init callback somewhere?
> 
> Easily, I think this is good (better) idea. Will do.

Maybe something like this? I don't like it so much, but given that
you don't like to export functions from mmc_spi, we'll have to place
some calls into the driver itself. :-/ And there is no easy way to do
generic callbacks, since that way we'll have implement "mmc_spi
callbacks subsystem". :-)

diff --git a/drivers/mmc/host/Kconfig b/drivers/mmc/host/Kconfig
index dead617..f468544 100644
--- a/drivers/mmc/host/Kconfig
+++ b/drivers/mmc/host/Kconfig
@@ -130,3 +130,10 @@ config MMC_SPI
 
 	  If unsure, or if your system has no SPI master driver, say N.
 
+config OF_MMC_SPI
+	tristate "MMC/SD over SPI OpenFirmware bindings"
+	depends on MMC_SPI && SPI_MASTER_OF && OF_GPIO
+	default y
+	help
+	  Say Y here to enable OpenFirmware bindings for the MMC/SD over SPI
+	  driver.
diff --git a/drivers/mmc/host/Makefile b/drivers/mmc/host/Makefile
index 3877c87..d77f880 100644
--- a/drivers/mmc/host/Makefile
+++ b/drivers/mmc/host/Makefile
@@ -17,4 +17,4 @@ obj-$(CONFIG_MMC_OMAP)		+= omap.o
 obj-$(CONFIG_MMC_AT91)		+= at91_mci.o
 obj-$(CONFIG_MMC_TIFM_SD)	+= tifm_sd.o
 obj-$(CONFIG_MMC_SPI)		+= mmc_spi.o
-
+obj-$(CONFIG_OF_MMC_SPI)	+= of_mmc_spi.o
diff --git a/drivers/mmc/host/mmc_spi.c b/drivers/mmc/host/mmc_spi.c
index 85d9853..395dd77 100644
--- a/drivers/mmc/host/mmc_spi.c
+++ b/drivers/mmc/host/mmc_spi.c
@@ -40,6 +40,7 @@
 
 #include <asm/unaligned.h>
 
+#include "mmc_spi.h"
 
 /* NOTES:
  *
@@ -1191,6 +1192,10 @@ static int mmc_spi_probe(struct spi_device *spi)
 	struct mmc_spi_host	*host;
 	int			status;
 
+	status = of_mmc_spi_probe(spi);
+	if (status)
+		return status;
+
 	/* MMC and SD specs only seem to care that sampling is on the
 	 * rising edge ... meaning SPI modes 0 or 3.  So either SPI mode
 	 * should be legit.  We'll use mode 0 since it seems to be a
@@ -1364,6 +1369,7 @@ fail_nobuf1:
 
 nomem:
 	kfree(ones);
+	of_mmc_spi_remove(spi);
 	return status;
 }
 
@@ -1395,6 +1401,7 @@ static int __devexit mmc_spi_remove(struct spi_device *spi)
 		spi->max_speed_hz = mmc->f_max;
 		mmc_free_host(mmc);
 		dev_set_drvdata(&spi->dev, NULL);
+		of_mmc_spi_remove(spi);
 	}
 	return 0;
 }
diff --git a/drivers/mmc/host/mmc_spi.h b/drivers/mmc/host/mmc_spi.h
new file mode 100644
index 0000000..a780761
--- /dev/null
+++ b/drivers/mmc/host/mmc_spi.h
@@ -0,0 +1,18 @@
+#ifndef __DRIVERS_MMC_HOST_MMC_SPI_H
+#define __DRIVERS_MMC_HOST_MMC_SPI_H
+
+#ifdef CONFIG_OF_MMC_SPI
+extern int of_mmc_spi_probe(struct spi_device *spi);
+extern int __devexit of_mmc_spi_remove(struct spi_device *spi);
+#else
+static inline int of_mmc_spi_probe(struct spi_device *spi)
+{
+	return 0;
+}
+static inline int __devexit of_mmc_spi_remove(struct spi_device *spi)
+{
+	return 0;
+}
+#endif /* CONFIG_OF_MMC_SPI */
+
+#endif /* __DRIVERS_MMC_HOST_MMC_SPI_H */
diff --git a/drivers/mmc/host/of_mmc_spi.c b/drivers/mmc/host/of_mmc_spi.c
new file mode 100644
index 0000000..7512f8b
--- /dev/null
+++ b/drivers/mmc/host/of_mmc_spi.c
@@ -0,0 +1,135 @@
+/*
+ * OpenFirmware bindings for the MMC-over-SPI driver
+ *
+ * Copyright (c) MontaVista Software, Inc. 2008.
+ *
+ * Author: Anton Vorontsov <avorontsov@ru.mvista.com>
+ *
+ * This program is free software; you can redistribute  it and/or modify it
+ * under  the terms of  the GNU General  Public License as published by the
+ * Free Software Foundation;  either version 2 of the  License, or (at your
+ * option) any later version.
+ */
+
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/of.h>
+#include <linux/of_platform.h>
+#include <linux/spi/spi.h>
+#include <linux/spi/spi_of.h>
+#include <linux/spi/mmc_spi.h>
+#include <linux/mmc/host.h>
+#include <linux/gpio.h>
+#include <linux/of_gpio.h>
+#include "mmc_spi.h"
+
+struct of_mmc_spi {
+	int wp_gpio;
+	int cd_gpio;
+	struct mmc_spi_platform_data mmc_pdata;
+};
+
+static int mmc_get_ro(struct device *dev)
+{
+	struct of_mmc_spi *oms = dev->archdata.of_node->data;
+
+	return gpio_get_value(oms->wp_gpio);
+}
+
+static int mmc_get_cd(struct device *dev)
+{
+	struct of_mmc_spi *oms = dev->archdata.of_node->data;
+
+	return gpio_get_value(oms->cd_gpio);
+}
+
+int of_mmc_spi_probe(struct spi_device *spi)
+{
+	int ret = -EINVAL;
+	struct device_node *np = spi->dev.archdata.of_node;
+	struct device *dev = &spi->dev;
+	struct of_mmc_spi *oms;
+	const u32 *ocr_mask;
+	int size;
+
+	/* not an OF SPI device, this isn't error though */
+	if (!np)
+		return 0;
+
+	oms = kzalloc(sizeof(*oms), GFP_KERNEL);
+	if (!oms)
+		return -ENOMEM;
+
+	/* Somebody occupied node's data? */
+	WARN_ON(np->data);
+
+	/*
+	 * mmc_spi_probe will use drvdata, so we can't use it. Use node's
+	 * data instead.
+	 */
+	np->data = oms;
+
+	/* We don't support interrupts yet, let's poll. */
+	oms->mmc_pdata.caps |= MMC_CAP_NEEDS_POLL;
+
+	ocr_mask = of_get_property(np, "linux,mmc-ocr-mask", &size);
+	if (ocr_mask && size >= sizeof(ocr_mask))
+		oms->mmc_pdata.ocr_mask = *ocr_mask;
+
+	oms->wp_gpio = of_get_gpio(np, 0);
+	if (gpio_is_valid(oms->wp_gpio)) {
+		ret = gpio_request(oms->wp_gpio, dev->bus_id);
+		if (ret < 0)
+			goto err_wp_gpio;
+		oms->mmc_pdata.get_ro = &mmc_get_ro;
+	}
+
+	oms->cd_gpio = of_get_gpio(np, 1);
+	if (gpio_is_valid(oms->cd_gpio)) {
+		ret = gpio_request(oms->cd_gpio, dev->bus_id);
+		if (ret < 0)
+			goto err_cd_gpio;
+		oms->mmc_pdata.get_cd = &mmc_get_cd;
+	}
+
+	spi->dev.platform_data = &oms->mmc_pdata;
+
+	return 0;
+
+	if (gpio_is_valid(oms->cd_gpio))
+		gpio_free(oms->cd_gpio);
+err_cd_gpio:
+	if (gpio_is_valid(oms->wp_gpio))
+		gpio_free(oms->wp_gpio);
+err_wp_gpio:
+	np->data = NULL;
+	kfree(oms);
+	return ret;
+}
+EXPORT_SYMBOL(of_mmc_spi_probe);
+
+int __devexit of_mmc_spi_remove(struct spi_device *spi)
+{
+	struct device_node *np = spi->dev.archdata.of_node;
+	struct of_mmc_spi *oms;
+
+	/* not an OF SPI device, this isn't error though */
+	if (!np)
+		return 0;
+
+	oms = np->data;
+
+	if (gpio_is_valid(oms->cd_gpio))
+		gpio_free(oms->cd_gpio);
+	if (gpio_is_valid(oms->wp_gpio))
+		gpio_free(oms->wp_gpio);
+
+	spi->dev.archdata.of_node->data = NULL;
+	kfree(oms);
+	return 0;
+}
+EXPORT_SYMBOL(of_mmc_spi_remove);
+
+MODULE_DESCRIPTION("OpenFirmware bindings for the MMC-over-SPI driver");
+MODULE_AUTHOR("Anton Vorontsov <avorontsov@ru.mvista.com>");
+MODULE_LICENSE("GPL");
-- 
1.5.5.1

