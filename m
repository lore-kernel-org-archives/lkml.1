Return-Path: <linux-kernel-owner+w=401wt.eu-S1753590AbYL3PPk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753590AbYL3PPk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 10:15:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752196AbYL3PPb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 10:15:31 -0500
Received: from rtsoft3.corbina.net ([85.21.88.6]:6808 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751779AbYL3PPa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 10:15:30 -0500
Date: Tue, 30 Dec 2008 18:15:28 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Pierre Ossman <drzeus-mmc@drzeus.cx>
Cc: David Brownell <dbrownell@users.sourceforge.net>,
       linux-kernel@vger.kernel.org
Subject: [PATCH] mmc_spi: Add support for OpenFirmware bindings
Message-ID: <20081230151528.GA14950@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=windows-1251
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The support is implemented via platform data accessors, new module
(of_mmc_spi) will be created automatically when the driver compiles
on OpenFirmware platforms. Link-time dependency will load the module
automatically.

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
---

Hello Pierre,

All the needed patches were merged into Linus' tree, so I believe
it's time for the bindings.

Note that you need to pull Linus' tree into mmc.git's next branch
before applying this patch, otherwise it will break bisect, since
of_mmc_spi isn't buildable without some patches that are in Linus'
tree, but not in the current mmc.git next.

Thanks,

 drivers/mmc/host/Makefile     |    3 +
 drivers/mmc/host/mmc_spi.c    |    4 +-
 drivers/mmc/host/of_mmc_spi.c |  149 +++++++++++++++++++++++++++++++++++++++++
 include/linux/spi/mmc_spi.h   |   15 ++++-
 4 files changed, 169 insertions(+), 2 deletions(-)
 create mode 100644 drivers/mmc/host/of_mmc_spi.c

diff --git a/drivers/mmc/host/Makefile b/drivers/mmc/host/Makefile
index c794cc5..f485328 100644
--- a/drivers/mmc/host/Makefile
+++ b/drivers/mmc/host/Makefile
@@ -19,6 +19,9 @@ obj-$(CONFIG_MMC_AT91)		+= at91_mci.o
 obj-$(CONFIG_MMC_ATMELMCI)	+= atmel-mci.o
 obj-$(CONFIG_MMC_TIFM_SD)	+= tifm_sd.o
 obj-$(CONFIG_MMC_SPI)		+= mmc_spi.o
+ifeq ($(CONFIG_OF),y)
+obj-$(CONFIG_MMC_SPI)		+= of_mmc_spi.o
+endif
 obj-$(CONFIG_MMC_S3C)   	+= s3cmci.o
 obj-$(CONFIG_MMC_SDRICOH_CS)	+= sdricoh_cs.o
 obj-$(CONFIG_MMC_TMIO)		+= tmio_mmc.o
diff --git a/drivers/mmc/host/mmc_spi.c b/drivers/mmc/host/mmc_spi.c
index ad00e16..87e211d 100644
--- a/drivers/mmc/host/mmc_spi.c
+++ b/drivers/mmc/host/mmc_spi.c
@@ -1285,7 +1285,7 @@ static int mmc_spi_probe(struct spi_device *spi)
 	/* Platform data is used to hook up things like card sensing
 	 * and power switching gpios.
 	 */
-	host->pdata = spi->dev.platform_data;
+	host->pdata = mmc_spi_get_pdata(spi);
 	if (host->pdata)
 		mmc->ocr_avail = host->pdata->ocr_mask;
 	if (!mmc->ocr_avail) {
@@ -1368,6 +1368,7 @@ fail_glue_init:
 
 fail_nobuf1:
 	mmc_free_host(mmc);
+	mmc_spi_put_pdata(spi);
 	dev_set_drvdata(&spi->dev, NULL);
 
 nomem:
@@ -1402,6 +1403,7 @@ static int __devexit mmc_spi_remove(struct spi_device *spi)
 
 		spi->max_speed_hz = mmc->f_max;
 		mmc_free_host(mmc);
+		mmc_spi_put_pdata(spi);
 		dev_set_drvdata(&spi->dev, NULL);
 	}
 	return 0;
diff --git a/drivers/mmc/host/of_mmc_spi.c b/drivers/mmc/host/of_mmc_spi.c
new file mode 100644
index 0000000..fb2921f
--- /dev/null
+++ b/drivers/mmc/host/of_mmc_spi.c
@@ -0,0 +1,149 @@
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
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/device.h>
+#include <linux/gpio.h>
+#include <linux/of.h>
+#include <linux/of_gpio.h>
+#include <linux/spi/spi.h>
+#include <linux/spi/mmc_spi.h>
+#include <linux/mmc/core.h>
+#include <linux/mmc/host.h>
+
+enum {
+	CD_GPIO = 0,
+	WP_GPIO,
+	NUM_GPIOS,
+};
+
+struct of_mmc_spi {
+	int gpios[NUM_GPIOS];
+	bool alow_gpios[NUM_GPIOS];
+	struct mmc_spi_platform_data pdata;
+};
+
+static struct of_mmc_spi *to_of_mmc_spi(struct device *dev)
+{
+	return container_of(dev->platform_data, struct of_mmc_spi, pdata);
+}
+
+static int of_mmc_spi_read_gpio(struct device *dev, int gpio_num)
+{
+	struct of_mmc_spi *oms = to_of_mmc_spi(dev);
+	bool active_low = oms->alow_gpios[gpio_num];
+	bool value = gpio_get_value(oms->gpios[gpio_num]);
+
+	return active_low ^ value;
+}
+
+static int of_mmc_spi_get_cd(struct device *dev)
+{
+	return of_mmc_spi_read_gpio(dev, CD_GPIO);
+}
+
+static int of_mmc_spi_get_ro(struct device *dev)
+{
+	return of_mmc_spi_read_gpio(dev, WP_GPIO);
+}
+
+struct mmc_spi_platform_data *mmc_spi_get_pdata(struct spi_device *spi)
+{
+	struct device *dev = &spi->dev;
+	struct device_node *np = dev_archdata_get_node(&dev->archdata);
+	struct of_mmc_spi *oms;
+	const u32 *voltage_ranges;
+	int num_ranges;
+	int i;
+	int ret = -EINVAL;
+
+	if (dev->platform_data || !np)
+		return dev->platform_data;
+
+	oms = kzalloc(sizeof(*oms), GFP_KERNEL);
+	if (!oms)
+		return NULL;
+
+	voltage_ranges = of_get_property(np, "voltage-ranges", &num_ranges);
+	num_ranges = num_ranges / sizeof(*voltage_ranges) / 2;
+	if (!voltage_ranges || !num_ranges) {
+		dev_err(dev, "OF: voltage-ranges unspecified\n");
+		goto err_ocr;
+	}
+
+	for (i = 0; i < num_ranges; i++) {
+		const int j = i * 2;
+		u32 mask;
+
+		mask = mmc_vddrange_to_ocrmask(voltage_ranges[j],
+					       voltage_ranges[j + 1]);
+		if (!mask) {
+			ret = -EINVAL;
+			dev_err(dev, "OF: voltage-range #%d is invalid\n", i);
+			goto err_ocr;
+		}
+		oms->pdata.ocr_mask |= mask;
+	}
+
+	for (i = 0; i < ARRAY_SIZE(oms->gpios); i++) {
+		enum of_gpio_flags gpio_flags;
+
+		oms->gpios[i] = of_get_gpio_flags(np, i, &gpio_flags);
+		if (!gpio_is_valid(oms->gpios[i]))
+			continue;
+
+		ret = gpio_request(oms->gpios[i], dev->bus_id);
+		if (ret < 0) {
+			oms->gpios[i] = -EINVAL;
+			continue;
+		}
+
+		if (gpio_flags & OF_GPIO_ACTIVE_LOW)
+			oms->alow_gpios[i] = true;
+	}
+
+	if (gpio_is_valid(oms->gpios[CD_GPIO]))
+		oms->pdata.get_cd = of_mmc_spi_get_cd;
+	if (gpio_is_valid(oms->gpios[WP_GPIO]))
+		oms->pdata.get_ro = of_mmc_spi_get_ro;
+
+	/* We don't support interrupts yet, let's poll. */
+	oms->pdata.caps |= MMC_CAP_NEEDS_POLL;
+
+	dev->platform_data = &oms->pdata;
+	return dev->platform_data;
+err_ocr:
+	kfree(oms);
+	return NULL;
+}
+EXPORT_SYMBOL(mmc_spi_get_pdata);
+
+void mmc_spi_put_pdata(struct spi_device *spi)
+{
+	struct device *dev = &spi->dev;
+	struct device_node *np = dev_archdata_get_node(&dev->archdata);
+	struct of_mmc_spi *oms = to_of_mmc_spi(dev);
+	int i;
+
+	if (!dev->platform_data || !np)
+		return;
+
+	for (i = 0; i < ARRAY_SIZE(oms->gpios); i++) {
+		if (gpio_is_valid(oms->gpios[i]))
+			gpio_free(oms->gpios[i]);
+	}
+	kfree(oms);
+	dev->platform_data = NULL;
+}
+EXPORT_SYMBOL(mmc_spi_put_pdata);
diff --git a/include/linux/spi/mmc_spi.h b/include/linux/spi/mmc_spi.h
index a3626ae..0f4eb16 100644
--- a/include/linux/spi/mmc_spi.h
+++ b/include/linux/spi/mmc_spi.h
@@ -1,9 +1,10 @@
 #ifndef __LINUX_SPI_MMC_SPI_H
 #define __LINUX_SPI_MMC_SPI_H
 
+#include <linux/device.h>
+#include <linux/spi/spi.h>
 #include <linux/interrupt.h>
 
-struct device;
 struct mmc_host;
 
 /* Put this in platform_data of a device being used to manage an MMC/SD
@@ -41,4 +42,16 @@ struct mmc_spi_platform_data {
 	void (*setpower)(struct device *, unsigned int maskval);
 };
 
+#ifdef CONFIG_OF
+extern struct mmc_spi_platform_data *mmc_spi_get_pdata(struct spi_device *spi);
+extern void mmc_spi_put_pdata(struct spi_device *spi);
+#else
+static inline struct mmc_spi_platform_data *
+mmc_spi_get_pdata(struct spi_device *spi)
+{
+	return spi->dev.platform_data;
+}
+static inline void mmc_spi_put_pdata(struct spi_device *spi) {}
+#endif /* CONFIG_OF */
+
 #endif /* __LINUX_SPI_MMC_SPI_H */
-- 
1.5.6.5
