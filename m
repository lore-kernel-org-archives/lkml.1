Return-Path: <linux-kernel-owner+w=401wt.eu-S1760063AbZFKT4R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760063AbZFKT4R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 15:56:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754967AbZFKT4C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 15:56:02 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:42180 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753248AbZFKT4B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 15:56:01 -0400
From: Daniel Mack <daniel@caiaq.de>
To: linux-kernel@vger.kernel.org
Cc: Daniel Mack <daniel@caiaq.de>, Pavel Machek <pavel@ucw.cz>,
       Eric Piel <eric.piel@tremplin-utc.net>
Subject: [PATCH] lis3: add click function
Date: Thu, 11 Jun 2009 21:55:46 +0200
Message-Id: <1244750146-31215-1-git-send-email-daniel@caiaq.de>
X-Mailer: git-send-email 1.6.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The LIS3 accelerometer chip has a 'click' feature which can be used to
detect sudden motion on any of the three axis. Configuration data is
passed via spi platform_data and no action is taken if that's not
specified, so it won't harm any existing platform.

To make the configuration effective, the IRQ lines need to be set up
appropriately. This patch also adds a way to do that from board support
code.

The DD_* definitions were removed because I couldn't find any reference
of them in the datasheet and the overlapped with the CLICK_ register
space.

Signed-off-by: Daniel Mack <daniel@caiaq.de>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Eric Piel <eric.piel@tremplin-utc.net>
---
 drivers/hwmon/lis3lv02d.c     |   20 ++++++++++++++++++++
 drivers/hwmon/lis3lv02d.h     |   18 +++++++++++-------
 drivers/hwmon/lis3lv02d_spi.c |   17 +++++++++--------
 include/linux/lis3lv02d.h     |   36 ++++++++++++++++++++++++++++++++++++
 4 files changed, 76 insertions(+), 15 deletions(-)
 create mode 100644 include/linux/lis3lv02d.h

diff --git a/drivers/hwmon/lis3lv02d.c b/drivers/hwmon/lis3lv02d.c
index 778eb77..e82203a 100644
--- a/drivers/hwmon/lis3lv02d.c
+++ b/drivers/hwmon/lis3lv02d.c
@@ -495,6 +495,26 @@ int lis3lv02d_init_device(struct lis3lv02d *dev)
 
 	printk("lis3_init_device: irq %d\n", dev->irq);
 
+	/* passing in platform specific data is purely optional and only
+	 * used by the SPI transport layer at the moment */
+	if (dev->pdata) {
+		struct lis3lv02d_platform_data *p = dev->pdata;
+
+		if (p->click_flags) {
+			dev->write(dev, CLICK_CFG, p->click_flags);
+			dev->write(dev, CLICK_TIMELIMIT, p->click_time_limit);
+			dev->write(dev, CLICK_LATENCY, p->click_latency);
+			dev->write(dev, CLICK_WINDOW, p->click_window);
+			dev->write(dev, CLICK_THSZ, p->click_thresh_z & 0xf);
+			dev->write(dev, CLICK_THSY_X,
+					(p->click_thresh_x & 0xf) |
+					(p->click_thresh_y << 4));
+		}
+
+		if (p->irq_cfg)
+			dev->write(dev, CTRL_REG3, p->irq_cfg);
+	}
+
 	/* bail if we did not get an IRQ from the bus layer */
 	if (!dev->irq) {
 		printk(KERN_ERR DRIVER_NAME
diff --git a/drivers/hwmon/lis3lv02d.h b/drivers/hwmon/lis3lv02d.h
index 745ec96..8fe731c 100644
--- a/drivers/hwmon/lis3lv02d.h
+++ b/drivers/hwmon/lis3lv02d.h
@@ -27,6 +27,8 @@
  * They can also be connected via I²C.
  */
 
+#include <linux/lis3lv02d.h>
+
 /* 2-byte registers */
 #define LIS_DOUBLE_ID	0x3A /* LIS3LV02D[LQ] */
 /* 1-byte registers */
@@ -60,13 +62,13 @@ enum lis3lv02d_reg {
 	FF_WU_THS_L	= 0x34,
 	FF_WU_THS_H	= 0x35,
 	FF_WU_DURATION	= 0x36,
-	DD_CFG		= 0x38,
-	DD_SRC		= 0x39,
-	DD_ACK		= 0x3A,
-	DD_THSI_L	= 0x3C,
-	DD_THSI_H	= 0x3D,
-	DD_THSE_L	= 0x3E,
-	DD_THSE_H	= 0x3F,
+	CLICK_CFG	= 0x38,
+	CLICK_SRC	= 0x39,
+	CLICK_THSY_X	= 0x3B,
+	CLICK_THSZ	= 0x3C,
+	CLICK_TIMELIMIT	= 0x3D,
+	CLICK_LATENCY	= 0x3E,
+	CLICK_WINDOW	= 0x3F,
 };
 
 enum lis3lv02d_ctrl1 {
@@ -185,6 +187,8 @@ struct lis3lv02d {
 	struct fasync_struct	*async_queue; /* queue for the misc device */
 	wait_queue_head_t	misc_wait; /* Wait queue for the misc device */
 	unsigned long		misc_opened; /* bit0: whether the device is open */
+
+	struct lis3lv02d_platform_data *pdata;	/* for passing board config */
 };
 
 int lis3lv02d_init_device(struct lis3lv02d *lis3);
diff --git a/drivers/hwmon/lis3lv02d_spi.c b/drivers/hwmon/lis3lv02d_spi.c
index 07ae74b..8d50ef2 100644
--- a/drivers/hwmon/lis3lv02d_spi.c
+++ b/drivers/hwmon/lis3lv02d_spi.c
@@ -66,21 +66,22 @@ static int __devinit lis302dl_spi_probe(struct spi_device *spi)
 	if (ret < 0)
 		return ret;
 
-	lis3_dev.bus_priv = spi;
-	lis3_dev.init = lis3_spi_init;
-	lis3_dev.read = lis3_spi_read;
-	lis3_dev.write = lis3_spi_write;
-	lis3_dev.irq = spi->irq;
-	lis3_dev.ac = lis3lv02d_axis_normal;
+	lis3_dev.bus_priv	= spi;
+	lis3_dev.init		= lis3_spi_init;
+	lis3_dev.read		= lis3_spi_read;
+	lis3_dev.write		= lis3_spi_write;
+	lis3_dev.irq		= spi->irq;
+	lis3_dev.ac		= lis3lv02d_axis_normal;
+	lis3_dev.pdata		= spi->dev.platform_data;
 	spi_set_drvdata(spi, &lis3_dev);
 
-	ret = lis3lv02d_init_device(&lis3_dev);
-	return ret;
+	return lis3lv02d_init_device(&lis3_dev);
 }
 
 static int __devexit lis302dl_spi_remove(struct spi_device *spi)
 {
 	struct lis3lv02d *lis3 = spi_get_drvdata(spi);
+
 	lis3lv02d_joystick_disable();
 	lis3lv02d_poweroff(lis3);
 	return 0;
diff --git a/include/linux/lis3lv02d.h b/include/linux/lis3lv02d.h
new file mode 100644
index 0000000..816364b
--- /dev/null
+++ b/include/linux/lis3lv02d.h
@@ -0,0 +1,36 @@
+#ifndef __LIS3LV02D_H_
+#define __LIS3LV02D_H_
+
+struct lis3lv02d_platform_data {
+#define LIS3_CLICK_SINGLE_X	(1 << 0)
+#define LIS3_CLICK_DOUBLE_X	(1 << 1)
+#define LIS3_CLICK_SINGLE_Y	(1 << 2)
+#define LIS3_CLICK_DOUBLE_Y	(1 << 3)
+#define LIS3_CLICK_SINGLE_Z	(1 << 4)
+#define LIS3_CLICK_DOUBLE_Z	(1 << 5)
+	unsigned char click_flags;
+	unsigned char click_thresh_x;
+	unsigned char click_thresh_y;
+	unsigned char click_thresh_z;
+	unsigned char click_time_limit;
+	unsigned char click_latency;
+	unsigned char click_window;
+
+#define LIS3_IRQ1_DISABLE	(0 << 0)
+#define LIS3_IRQ1_FF_WU_1	(1 << 0)
+#define LIS3_IRQ1_FF_WU_2	(2 << 0)
+#define LIS3_IRQ1_FF_WU_12	(3 << 0)
+#define LIS3_IRQ1_DATA_READY	(4 << 0)
+#define LIS3_IRQ1_CLICK		(7 << 0)
+#define LIS3_IRQ2_DISABLE	(0 << 3)
+#define LIS3_IRQ2_FF_WU_1	(1 << 3)
+#define LIS3_IRQ2_FF_WU_2	(2 << 3)
+#define LIS3_IRQ2_FF_WU_12	(3 << 3)
+#define LIS3_IRQ2_DATA_READY	(4 << 3)
+#define LIS3_IRQ2_CLICK		(7 << 3)
+#define LIS3_IRQ_OPEN_DRAIN	(1 << 6)
+#define LIS3_IRQ_ACTIVE_HIGH	(1 << 7)
+	unsigned char irq_cfg;
+};
+
+#endif /* __LIS3LV02D_H_ */
-- 
1.6.3.1

