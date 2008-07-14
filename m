Return-Path: <linux-kernel-owner+w=401wt.eu-S1754736AbYGNTMU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754736AbYGNTMU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 15:12:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754388AbYGNTMM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 15:12:12 -0400
Received: from bu3sch.de ([62.75.166.246]:34119 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753260AbYGNTML (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 15:12:11 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>
Subject: [PATCH] Add dynamic MMC-over-SPI-GPIO driver
Date: Mon, 14 Jul 2008 21:09:18 +0200
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>,
       David Brownell <david-b@pacbell.net>,
       Piot Skamruk <piotr.skamruk@gmail.com>,
       Pierre Ossman <drzeus-mmc@drzeus.cx>, openwrt-devel@lists.openwrt.org
MIME-Version: 1.0
Message-Id: <200807142109.19360.mb@bu3sch.de>
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_fR6eIFcU8uJTHkc"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_fR6eIFcU8uJTHkc
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

This driver provides a sysfs interface to dynamically create
and destroy GPIO-based MMC/SD card interfaces.
So an MMC or SD card can be connected to generic GPIO pins
and be configured dynamically from userspace.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

---

This driver is used in OpenWrt since quite some time, so please
consider for inclusion in mainline.

See the attached OpenWrt initscript for an example on how to use
the sysfs interface. Documentation should also be added. I'll submit
a patch for that, later.


Index: linux-next/drivers/mmc/host/mmc_over_spigpio.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-next/drivers/mmc/host/mmc_over_spigpio.c	2008-07-14 21:04:51.000000000 +0200
@@ -0,0 +1,339 @@
+/*
+ * Driver for driving an MMC card over a bitbanging GPIO SPI bus.
+ *
+ * Copyright 2008 Michael Buesch <mb@bu3sch.de>
+ *
+ * Licensed under the GNU/GPL. See COPYING for details.
+ */
+
+#include <linux/platform_device.h>
+#include <linux/list.h>
+#include <linux/mutex.h>
+#include <linux/spi/spi_gpio.h>
+
+
+/* This is the maximum speed in Hz */
+#define GPIOMMC_MAXSPEED	5000000 /* Hz */
+
+
+#define DRIVER_NAME		"spi-gpio-mmc"
+#define PFX			DRIVER_NAME ": "
+
+
+#define GPIOMMC_MAX_NAMELEN		15
+#define GPIOMMC_MAX_NAMELEN_STR		__stringify(GPIOMMC_MAX_NAMELEN)
+
+struct gpiommc_pins {
+	unsigned int gpio_di;	/* Card DI pin */
+	unsigned int gpio_do;	/* Card DO pin */
+	unsigned int gpio_clk;	/* Card CLK pin */
+	unsigned int gpio_cs;	/* Card CS pin */
+};
+
+struct gpiommc_device {
+	char name[GPIOMMC_MAX_NAMELEN + 1];
+	struct platform_device *pdev;
+	struct platform_device *spi_pdev;
+	struct gpiommc_pins pins;
+	u8 mode; /* SPI_MODE_X */
+	struct spi_board_info boardinfo;
+
+	struct list_head list;
+};
+
+
+static LIST_HEAD(gpiommc_devices_list);
+static DEFINE_MUTEX(gpiommc_mutex);
+
+
+MODULE_DESCRIPTION("SPI-GPIO based MMC driver");
+MODULE_AUTHOR("Michael Buesch");
+MODULE_LICENSE("GPL");
+
+
+static int gpiommc_boardinfo_setup(struct spi_board_info *bi,
+				   struct spi_master *master,
+				   void *data)
+{
+	struct gpiommc_device *d = data;
+
+	/* Bind the SPI master to the MMC-SPI host driver. */
+	strlcpy(bi->modalias, "mmc_spi", sizeof(bi->modalias));
+
+	bi->max_speed_hz = GPIOMMC_MAXSPEED;
+	bi->bus_num = master->bus_num;
+	bi->mode = d->mode;
+
+	return 0;
+}
+
+static int gpiommc_probe(struct platform_device *pdev)
+{
+	static int instance;
+	struct gpiommc_device *d = platform_get_drvdata(pdev);
+	struct spi_gpio_platform_data pdata;
+	int err = -ENOMEM;
+
+	d->spi_pdev = platform_device_alloc("spi-gpio", instance++);
+	if (!d->spi_pdev)
+		goto out;
+
+	memset(&pdata, 0, sizeof(pdata));
+	pdata.pin_clk = d->pins.gpio_clk;
+	pdata.pin_miso = d->pins.gpio_do;
+	pdata.pin_mosi = d->pins.gpio_di;
+	pdata.pin_cs = d->pins.gpio_cs;
+	pdata.cs_activelow = 1;
+	pdata.no_spi_delay = 1;
+	pdata.boardinfo_setup = gpiommc_boardinfo_setup;
+	pdata.boardinfo_setup_data = d;
+
+	err = platform_device_add_data(d->spi_pdev, &pdata, sizeof(pdata));
+	if (err)
+		goto err_free_pdev;
+	err = platform_device_register(d->spi_pdev);
+	if (err)
+		goto err_free_pdata;
+
+	printk(KERN_INFO PFX "MMC-Card \"%s\" "
+	       "attached to GPIO pins %u,%u,%u,%u\n",
+	       d->name, d->pins.gpio_di, d->pins.gpio_do,
+	       d->pins.gpio_clk, d->pins.gpio_cs);
+out:
+	return err;
+
+err_free_pdata:
+	kfree(d->spi_pdev->dev.platform_data);
+	d->spi_pdev->dev.platform_data = NULL;
+err_free_pdev:
+	platform_device_put(d->spi_pdev);
+	return err;
+}
+
+static int gpiommc_remove(struct platform_device *pdev)
+{
+	struct gpiommc_device *d = platform_get_drvdata(pdev);
+
+	platform_device_unregister(d->spi_pdev);
+	printk(KERN_INFO PFX "MMC-Card \"%s\" removed\n", d->name);
+
+	return 0;
+}
+
+static void gpiommc_free(struct gpiommc_device *d)
+{
+	kfree(d);
+}
+
+static struct gpiommc_device *gpiommc_alloc(struct platform_device *pdev,
+					    const char *name,
+					    const struct gpiommc_pins *pins,
+					    u8 mode)
+{
+	struct gpiommc_device *d;
+
+	d = kmalloc(sizeof(*d), GFP_KERNEL);
+	if (!d)
+		return NULL;
+
+	strcpy(d->name, name);
+	memcpy(&d->pins, pins, sizeof(d->pins));
+	d->mode = mode;
+	INIT_LIST_HEAD(&d->list);
+
+	return d;
+}
+
+/* List must be locked. */
+static struct gpiommc_device *gpiommc_find_device(const char *name)
+{
+	struct gpiommc_device *d;
+
+	list_for_each_entry(d, &gpiommc_devices_list, list) {
+		if (strcmp(d->name, name) == 0)
+			return d;
+	}
+
+	return NULL;
+}
+
+static void gpiommc_do_destroy_device(struct gpiommc_device *d)
+{
+	list_del(&d->list);
+	platform_device_unregister(d->pdev);
+	gpiommc_free(d);
+}
+
+static int gpiommc_destroy_device(const char *name)
+{
+	struct gpiommc_device *d;
+	int err = -ENODEV;
+
+	mutex_lock(&gpiommc_mutex);
+	d = gpiommc_find_device(name);
+	if (!d)
+		goto out_unlock;
+	gpiommc_do_destroy_device(d);
+	err = 0;
+out_unlock:
+	mutex_unlock(&gpiommc_mutex);
+
+	return err;
+}
+
+static int gpiommc_create_device(const char *name,
+				 const struct gpiommc_pins *pins,
+				 u8 mode)
+{
+	static int instance;
+	struct platform_device *pdev;
+	struct gpiommc_device *d;
+	int err;
+
+	mutex_lock(&gpiommc_mutex);
+	err = -EEXIST;
+	if (gpiommc_find_device(name))
+		goto out_unlock;
+	err = -ENOMEM;
+	pdev = platform_device_alloc(DRIVER_NAME, instance++);
+	if (!pdev)
+		goto out_unlock;
+	d = gpiommc_alloc(pdev, name, pins, mode);
+	if (!d)
+		goto err_free_pdev;
+	platform_set_drvdata(pdev, d);
+	d->pdev = pdev;
+	err = platform_device_register(pdev);
+	if (err)
+		goto err_free_mdev;
+	list_add(&d->list, &gpiommc_devices_list);
+
+	err = 0;
+out_unlock:
+	mutex_unlock(&gpiommc_mutex);
+
+	return err;
+
+err_free_mdev:
+	gpiommc_free(d);
+err_free_pdev:
+	platform_device_put(pdev);
+	goto out_unlock;
+}
+
+static ssize_t gpiommc_add_show(struct device_driver *drv,
+				char *buf)
+{
+	return snprintf(buf, PAGE_SIZE, "NAME  DI_pin,DO_pin,CLK_pin,CS_pin  [MODE]\n");
+}
+
+static ssize_t gpiommc_add_store(struct device_driver *drv,
+				 const char *buf, size_t count)
+{
+	int res, err;
+	char name[GPIOMMC_MAX_NAMELEN + 1];
+	struct gpiommc_pins pins;
+	unsigned int mode;
+
+	res = sscanf(buf, "%" GPIOMMC_MAX_NAMELEN_STR "s %u,%u,%u,%u %u",
+		     name, &pins.gpio_di, &pins.gpio_do,
+		     &pins.gpio_clk, &pins.gpio_cs, &mode);
+	if (res == 5)
+		mode = 0;
+	else if (res != 6)
+		return -EINVAL;
+	switch (mode) {
+	case 0:
+		mode = SPI_MODE_0;
+		break;
+	case 1:
+		mode = SPI_MODE_1;
+		break;
+	case 2:
+		mode = SPI_MODE_2;
+		break;
+	case 3:
+		mode = SPI_MODE_3;
+		break;
+	default:
+		return -EINVAL;
+	}
+	err = gpiommc_create_device(name, &pins, mode);
+
+	return err ? err : count;
+}
+
+static ssize_t gpiommc_remove_show(struct device_driver *drv,
+				   char *buf)
+{
+	return snprintf(buf, PAGE_SIZE, "write device-name to remove the device\n");
+}
+
+static ssize_t gpiommc_remove_store(struct device_driver *drv,
+				    const char *buf, size_t count)
+{
+	int err;
+
+	err = gpiommc_destroy_device(buf);
+
+	return err ? err : count;
+}
+
+static DRIVER_ATTR(add, 0600,
+		   gpiommc_add_show, gpiommc_add_store);
+static DRIVER_ATTR(remove, 0600,
+		   gpiommc_remove_show, gpiommc_remove_store);
+
+static struct platform_driver gpiommc_plat_driver = {
+	.probe	= gpiommc_probe,
+	.remove	= gpiommc_remove,
+	.driver	= {
+		.name	= DRIVER_NAME,
+		.owner	= THIS_MODULE,
+	},
+};
+
+static int __init gpiommc_modinit(void)
+{
+	int err;
+
+	err = platform_driver_register(&gpiommc_plat_driver);
+	if (err)
+		return err;
+	err = driver_create_file(&gpiommc_plat_driver.driver,
+				 &driver_attr_add);
+	if (err)
+		goto err_drv_unreg;
+	err = driver_create_file(&gpiommc_plat_driver.driver,
+				 &driver_attr_remove);
+	if (err)
+		goto err_remove_add;
+
+	return 0;
+
+err_remove_add:
+	driver_remove_file(&gpiommc_plat_driver.driver,
+			   &driver_attr_add);
+err_drv_unreg:
+	platform_driver_unregister(&gpiommc_plat_driver);
+	return err;
+}
+module_init(gpiommc_modinit);
+
+static void __exit gpiommc_modexit(void)
+{
+	struct gpiommc_device *d, *tmp;
+
+	driver_remove_file(&gpiommc_plat_driver.driver,
+			   &driver_attr_remove);
+	driver_remove_file(&gpiommc_plat_driver.driver,
+			   &driver_attr_add);
+
+	mutex_lock(&gpiommc_mutex);
+	list_for_each_entry_safe(d, tmp, &gpiommc_devices_list, list)
+		gpiommc_do_destroy_device(d);
+	mutex_unlock(&gpiommc_mutex);
+
+	platform_driver_unregister(&gpiommc_plat_driver);
+}
+module_exit(gpiommc_modexit);
Index: linux-next/drivers/mmc/host/Kconfig
===================================================================
--- linux-next.orig/drivers/mmc/host/Kconfig	2008-07-14 21:02:13.000000000 +0200
+++ linux-next/drivers/mmc/host/Kconfig	2008-07-14 21:04:10.000000000 +0200
@@ -153,6 +153,18 @@ config MMC_SPI
 
 	  If unsure, or if your system has no SPI master driver, say N.
 
+config MMC_OVER_SPIGPIO
+	tristate "MMC/SD over GPIO-based SPI"
+	depends on MMC && MMC_SPI && SPI_GPIO
+	help
+	  This driver provides a sysfs interface to dynamically create
+	  and destroy GPIO-based MMC/SD card interfaces.
+	  So an MMC or SD card can be connected to generic GPIO pins
+	  and be configured dynamically from userspace.
+	  The module will be called mmc_over_spigpio.
+
+	  If unsure, say N.
+
 config MMC_S3C
 	tristate "Samsung S3C SD/MMC Card Interface support"
 	depends on ARCH_S3C2410 && MMC
Index: linux-next/drivers/mmc/host/Makefile
===================================================================
--- linux-next.orig/drivers/mmc/host/Makefile	2008-07-14 21:02:13.000000000 +0200
+++ linux-next/drivers/mmc/host/Makefile	2008-07-14 21:04:10.000000000 +0200
@@ -20,3 +20,4 @@ obj-$(CONFIG_MMC_ATMELMCI)	+= atmel-mci.
 obj-$(CONFIG_MMC_TIFM_SD)	+= tifm_sd.o
 obj-$(CONFIG_MMC_SPI)		+= mmc_spi.o
 obj-$(CONFIG_MMC_S3C)   	+= s3cmci.o
+obj-$(CONFIG_MMC_OVER_SPIGPIO)	+= mmc_over_spigpio.o

-- 
Greetings Michael.

--Boundary-00=_fR6eIFcU8uJTHkc
Content-Type: application/x-shellscript;
  name="mmc_over_gpio.init"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="mmc_over_gpio.init"

#!/bin/sh /etc/rc.common
# Copyright (C) 2008 OpenWrt.org
START=90

SYSFS="/sys"
SYSFS_DRIVERDIR="$SYSFS/bus/platform/drivers/spi-gpio-mmc"

# add_device(name, DI_pin, DO_pin, CLK_pin, CS_pin, mode)
add_device() {
	echo -n "$1" "$2","$3","$4","$5" "$6" > $SYSFS_DRIVERDIR/add
}

# remove_device(name)
remove_device() {
	echo -n "$1" > $SYSFS_DRIVERDIR/remove
}

start() {
	#FIXME we should use a config file, but I dunno how that parser works.
	add_device "default" 5 4 3 7 0
}

stop() {
	remove_device "default"
}

--Boundary-00=_fR6eIFcU8uJTHkc--
