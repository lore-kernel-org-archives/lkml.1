Return-Path: <linux-kernel-owner+w=401wt.eu-S1757743AbZBEQyk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757743AbZBEQyk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 11:54:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757113AbZBEQxy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 11:53:54 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:24489 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755986AbZBEQxx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 11:53:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=hlR1ra3YpEFafuio0tTPa9qIO7qGC3/Y/svgOInUIFDZw3LgtKuww45QIxrJWU6oD0
         aIiTO5AISLLHZ5rZMob9kzVZdd89I1hVHJ4L+FmlhBlZwMJEE0bDFIjI8ghLUDwlWF40
         adCvngR5XfkE+G94ebmkeXa/B+6/lMz5RwQt0=
From: Philipp Zabel <philipp.zabel@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Samuel Ortiz <sameo@openedhand.com>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>, Matt Reimer <mreimer@vpop.net>,
       Philipp Zabel <philipp.zabel@gmail.com>
Subject: [PATCH 2/6] mfd: PASIC3: convert to use MFD core
Date: Thu,  5 Feb 2009 17:53:36 +0100
Message-Id: <1233852820-28549-3-git-send-email-philipp.zabel@gmail.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1233852820-28549-1-git-send-email-philipp.zabel@gmail.com>
References: <1233852820-28549-1-git-send-email-philipp.zabel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes htc-pasic3 register the DS1WM and LED cell drivers
through the MFD core infrastructure instead of allocating the platform
devices manually. It also calculates the bus_shift parameter from the
memory resource size.

Signed-off-by: Philipp Zabel <philipp.zabel@gmail.com>
---
 drivers/mfd/Kconfig      |    1 +
 drivers/mfd/htc-pasic3.c |  159 ++++++++++++++++++----------------------------
 2 files changed, 62 insertions(+), 98 deletions(-)

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 06a2b0f..da2d4c5 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -52,6 +52,7 @@ config HTC_EGPIO
 
 config HTC_PASIC3
 	tristate "HTC PASIC3 LED/DS1WM chip support"
+	select MFD_CORE
 	help
 	  This core driver provides register access for the LED/DS1WM
 	  chips labeled "AIC2" and "AIC3", found on HTC Blueangel and
diff --git a/drivers/mfd/htc-pasic3.c b/drivers/mfd/htc-pasic3.c
index 91b294d..92b6837 100644
--- a/drivers/mfd/htc-pasic3.c
+++ b/drivers/mfd/htc-pasic3.c
@@ -12,18 +12,17 @@
 #include <linux/module.h>
 #include <linux/platform_device.h>
 
-#include <linux/ds1wm.h>
 #include <linux/gpio.h>
 #include <linux/io.h>
 #include <linux/irq.h>
 #include <linux/interrupt.h>
+#include <linux/mfd/core.h>
+#include <linux/mfd/ds1wm.h>
 #include <linux/mfd/htc-pasic3.h>
 
 struct pasic3_data {
 	void __iomem *mapping;
 	unsigned int bus_shift;
-	struct platform_device *ds1wm_pdev;
-	struct platform_device *led_pdev;
 };
 
 #define REG_ADDR  5
@@ -65,46 +64,15 @@ EXPORT_SYMBOL(pasic3_read_register); /* for leds-pasic3 */
  * LEDs
  */
 
-static int led_device_add(struct device *pasic3_dev,
-				const struct pasic3_leds_machinfo *pdata)
-{
-	struct pasic3_data *asic = pasic3_dev->driver_data;
-	struct platform_device *pdev;
-	int ret;
-
-	pdev = platform_device_alloc("pasic3-led", -1);
-	if (!pdev) {
-		dev_dbg(pasic3_dev, "failed to allocate LED platform device\n");
-		return -ENOMEM;
-	}
-
-	ret = platform_device_add_data(pdev, pdata,
-					sizeof(struct pasic3_leds_machinfo));
-	if (ret < 0) {
-		dev_dbg(pasic3_dev, "failed to add LED platform data\n");
-		goto exit_pdev_put;
-	}
-
-	pdev->dev.parent = pasic3_dev;
-	ret = platform_device_add(pdev);
-	if (ret < 0) {
-		dev_dbg(pasic3_dev, "failed to add LED platform device\n");
-		goto exit_pdev_put;
-	}
-
-	asic->led_pdev = pdev;
-	return 0;
-
-exit_pdev_put:
-	platform_device_put(pdev);
-	return ret;
-}
+static struct mfd_cell led_cell __initdata = {
+	.name = "leds-pasic3",
+};
 
 /*
  * DS1WM
  */
 
-static void ds1wm_enable(struct platform_device *pdev)
+static int ds1wm_enable(struct platform_device *pdev)
 {
 	struct device *dev = pdev->dev.parent;
 	int c;
@@ -113,9 +81,10 @@ static void ds1wm_enable(struct platform_device *pdev)
 	pasic3_write_register(dev, 0x28, c & 0x7f);
 
 	dev_dbg(dev, "DS1WM OWM_EN low (active) %02x\n", c & 0x7f);
+	return 0;
 }
 
-static void ds1wm_disable(struct platform_device *pdev)
+static int ds1wm_disable(struct platform_device *pdev)
 {
 	struct device *dev = pdev->dev.parent;
 	int c;
@@ -124,56 +93,33 @@ static void ds1wm_disable(struct platform_device *pdev)
 	pasic3_write_register(dev, 0x28, c | 0x80);
 
 	dev_dbg(dev, "DS1WM OWM_EN high (inactive) %02x\n", c | 0x80);
+	return 0;
 }
 
-static struct ds1wm_platform_data ds1wm_pdata = {
-	.bus_shift = 2,
-	.enable    = ds1wm_enable,
-	.disable   = ds1wm_disable,
+static struct ds1wm_driver_data ds1wm_pdata = {
+	.active_high = 0,
 };
 
-static int ds1wm_device_add(struct platform_device *pasic3_pdev, int bus_shift)
-{
-	struct device *pasic3_dev = &pasic3_pdev->dev;
-	struct pasic3_data *asic = pasic3_dev->driver_data;
-	struct platform_device *pdev;
-	int ret;
-
-	pdev = platform_device_alloc("ds1wm", -1);
-	if (!pdev) {
-		dev_dbg(pasic3_dev, "failed to allocate DS1WM platform device\n");
-		return -ENOMEM;
-	}
-
-	ret = platform_device_add_resources(pdev, pasic3_pdev->resource,
-						pasic3_pdev->num_resources);
-	if (ret < 0) {
-		dev_dbg(pasic3_dev, "failed to add DS1WM resources\n");
-		goto exit_pdev_put;
-	}
-
-	ds1wm_pdata.bus_shift = asic->bus_shift;
-	ret = platform_device_add_data(pdev, &ds1wm_pdata,
-					sizeof(struct ds1wm_platform_data));
-	if (ret < 0) {
-		dev_dbg(pasic3_dev, "failed to add DS1WM platform data\n");
-		goto exit_pdev_put;
-	}
-
-	pdev->dev.parent = pasic3_dev;
-	ret = platform_device_add(pdev);
-	if (ret < 0) {
-		dev_dbg(pasic3_dev, "failed to add DS1WM platform device\n");
-		goto exit_pdev_put;
-	}
-
-	asic->ds1wm_pdev = pdev;
-	return 0;
+static struct resource ds1wm_resources[] __initdata = {
+	[0] = {
+		.start  = 0,
+		.flags  = IORESOURCE_MEM,
+	},
+	[1] = {
+		.start  = 0,
+		.end    = 0,
+		.flags  = IORESOURCE_IRQ,
+	},
+};
 
-exit_pdev_put:
-	platform_device_put(pdev);
-	return ret;
-}
+static struct mfd_cell ds1wm_cell __initdata = {
+	.name          = "ds1wm",
+	.enable        = ds1wm_enable,
+	.disable       = ds1wm_disable,
+	.driver_data   = &ds1wm_pdata,
+	.num_resources = 2,
+	.resources     = ds1wm_resources,
+};
 
 static int __init pasic3_probe(struct platform_device *pdev)
 {
@@ -182,12 +128,27 @@ static int __init pasic3_probe(struct platform_device *pdev)
 	struct pasic3_data *asic;
 	struct resource *r;
 	int ret;
+	int irq = 0;
+
+	r = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
+	if (r) {
+		ds1wm_resources[1].flags = IORESOURCE_IRQ | (r->flags &
+			(IORESOURCE_IRQ_HIGHEDGE | IORESOURCE_IRQ_LOWEDGE));
+		irq = r->start;
+	}
+
+	r = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
+	if (r) {
+		ds1wm_resources[1].flags = IORESOURCE_IRQ | (r->flags &
+			(IORESOURCE_IRQ_HIGHEDGE | IORESOURCE_IRQ_LOWEDGE));
+		irq = r->start;
+	}
 
 	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!r)
 		return -ENXIO;
 
-	if (!request_mem_region(r->start, r->end - r->start + 1, "pasic3"))
+	if (!request_mem_region(r->start, resource_size(r), "pasic3"))
 		return -EBUSY;
 
 	asic = kzalloc(sizeof(struct pasic3_data), GFP_KERNEL);
@@ -196,24 +157,29 @@ static int __init pasic3_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, asic);
 
-	if (pdata && pdata->bus_shift)
-		asic->bus_shift = pdata->bus_shift;
-	else
-		asic->bus_shift = 2;
-
-	asic->mapping = ioremap(r->start, r->end - r->start + 1);
+	asic->mapping = ioremap(r->start, resource_size(r));
 	if (!asic->mapping) {
 		dev_err(dev, "couldn't ioremap PASIC3\n");
 		kfree(asic);
 		return -ENOMEM;
 	}
 
-	ret = ds1wm_device_add(pdev, asic->bus_shift);
+	/* calculate bus shift from mem resource */
+	asic->bus_shift = (resource_size(r) - 5) >> 3;
+
+	/* the first 5 PASIC3 registers control the DS1WM */
+	ds1wm_resources[0].end = (5 << asic->bus_shift) - 1;
+	ds1wm_cell.platform_data = &ds1wm_cell;
+	ds1wm_cell.data_size = sizeof(ds1wm_cell);
+	ret = mfd_add_devices(&pdev->dev, pdev->id, &ds1wm_cell, 1, r, irq);
 	if (ret < 0)
 		dev_warn(dev, "failed to register DS1WM\n");
 
 	if (pdata->led_pdata) {
-		ret = led_device_add(dev, pdata->led_pdata);
+		led_cell.driver_data = pdata->led_pdata;
+		led_cell.platform_data = &led_cell;
+		led_cell.data_size = sizeof(ds1wm_cell);
+		ret = mfd_add_devices(&pdev->dev, pdev->id, &led_cell, 1, r, 0);
 		if (ret < 0)
 			dev_warn(dev, "failed to register LED device\n");
 	}
@@ -226,14 +192,11 @@ static int pasic3_remove(struct platform_device *pdev)
 	struct pasic3_data *asic = platform_get_drvdata(pdev);
 	struct resource *r;
 
-	if (asic->led_pdev)
-		platform_device_unregister(asic->led_pdev);
-	if (asic->ds1wm_pdev)
-		platform_device_unregister(asic->ds1wm_pdev);
+	mfd_remove_devices(&pdev->dev);
 
 	iounmap(asic->mapping);
 	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	release_mem_region(r->start, r->end - r->start + 1);
+	release_mem_region(r->start, resource_size(r));
 	kfree(asic);
 	return 0;
 }
-- 
1.5.6.5

