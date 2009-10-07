Return-Path: <linux-kernel-owner+w=401wt.eu-S1751577AbZJJEm3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751577AbZJJEm3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Oct 2009 00:42:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751419AbZJJEm2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Oct 2009 00:42:28 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:41053 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751402AbZJJEm1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Oct 2009 00:42:27 -0400
From: Daniel Mack <daniel@caiaq.de>
To: linux-kernel@vger.kernel.org
Cc: Daniel Mack <daniel@caiaq.de>, Andrew Morton <akpm@linux-foundation.org>,
       David Brownell <dbrownell@users.sourceforge.net>,
       spi-devel-general@lists.sourceforge.net
Subject: [PATCH] drivers/misc: add driver for Texas Instruments DAC7512
Date: Thu,  8 Oct 2009 04:01:05 +0800
Message-Id: <1254945665-28053-1-git-send-email-daniel@caiaq.de>
X-Mailer: git-send-email 1.6.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is actually too trivial to publish, but to export the function of
that chip to the userspace, a module like this is needed.

Signed-off-by: Daniel Mack <daniel@caiaq.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: David Brownell <dbrownell@users.sourceforge.net>
Cc: spi-devel-general@lists.sourceforge.net
---
 drivers/misc/Kconfig      |   10 ++++
 drivers/misc/Makefile     |    1 +
 drivers/misc/ti_dac7512.c |  102 +++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 113 insertions(+), 0 deletions(-)
 create mode 100644 drivers/misc/ti_dac7512.c

diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
index df1f86b..1191446 100644
--- a/drivers/misc/Kconfig
+++ b/drivers/misc/Kconfig
@@ -246,6 +246,16 @@ config EP93XX_PWM
 	  To compile this driver as a module, choose M here: the module will
 	  be called ep93xx_pwm.
 
+config TI_DAC7512
+	tristate "Texas Instruments DAC7512"
+	depends on SPI && SYSFS
+	help
+	  If you say yes here you get support for the Texas Instruments
+	  DAC7512 16-bit digital-to-analog converter.
+
+	  This driver can also be built as a module. If so, the module
+	  will be calles ti_dac7512.
+
 source "drivers/misc/c2port/Kconfig"
 source "drivers/misc/eeprom/Kconfig"
 source "drivers/misc/cb710/Kconfig"
diff --git a/drivers/misc/Makefile b/drivers/misc/Makefile
index f982d2e..d59830e 100644
--- a/drivers/misc/Makefile
+++ b/drivers/misc/Makefile
@@ -20,6 +20,7 @@ obj-$(CONFIG_SGI_GRU)		+= sgi-gru/
 obj-$(CONFIG_HP_ILO)		+= hpilo.o
 obj-$(CONFIG_ISL29003)		+= isl29003.o
 obj-$(CONFIG_EP93XX_PWM)	+= ep93xx_pwm.o
+obj-$(CONFIG_TI_DAC7512)	+= ti_dac7512.o
 obj-$(CONFIG_C2PORT)		+= c2port/
 obj-y				+= eeprom/
 obj-y				+= cb710/
diff --git a/drivers/misc/ti_dac7512.c b/drivers/misc/ti_dac7512.c
new file mode 100644
index 0000000..3c60dcf
--- /dev/null
+++ b/drivers/misc/ti_dac7512.c
@@ -0,0 +1,102 @@
+/*
+ *  dac7512.c - Linux kernel module for
+ * 	Texas Instruments DAC7512
+ *
+ *  Copyright (c) 2009 Daniel Mack <daniel@caiaq.de>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/spi/spi.h>
+
+#define DAC7512_DRV_NAME	"dac7512"
+#define DRIVER_VERSION		"1.0"
+
+static ssize_t dac7512_store_val(struct device *dev,
+				 struct device_attribute *attr,
+				 const char *buf, size_t count)
+{
+	struct spi_device *spi = to_spi_device(dev);
+	unsigned char tmp[2];
+	unsigned long val;
+
+	if (strict_strtoul(buf, 10, &val) < 0)
+		return -EINVAL;
+
+	tmp[0] = val >> 8;
+	tmp[1] = val & 0xff;
+	spi_write(spi, tmp, sizeof(tmp));
+	return count;
+}
+
+static DEVICE_ATTR(value, S_IWUSR | S_IRUGO,
+		   NULL, dac7512_store_val);
+
+static struct attribute *dac7512_attributes[] = {
+	&dev_attr_value.attr,
+	NULL
+};
+
+static const struct attribute_group dac7512_attr_group = {
+	.attrs = dac7512_attributes,
+};
+
+static int __devinit dac7512_probe(struct spi_device *spi)
+{
+	int ret;
+
+	spi->bits_per_word = 8;
+	spi->mode = SPI_MODE_0;
+	ret = spi_setup(spi);
+	if (ret < 0)
+		return ret;
+
+	return sysfs_create_group(&spi->dev.kobj, &dac7512_attr_group);
+}
+
+static int __devexit dac7512_remove(struct spi_device *spi)
+{
+	sysfs_remove_group(&spi->dev.kobj, &dac7512_attr_group);
+	return 0;
+}
+
+static struct spi_driver dac7512_driver = {
+	.driver = {
+		.name	= DAC7512_DRV_NAME,
+		.owner	= THIS_MODULE,
+	},
+	.probe	= dac7512_probe,
+	.remove	= __devexit_p(dac7512_remove),
+};
+
+static int __init dac7512_init(void)
+{
+	return spi_register_driver(&dac7512_driver);
+}
+
+static void __exit dac7512_exit(void)
+{
+	spi_unregister_driver(&dac7512_driver);
+}
+
+MODULE_AUTHOR("Daniel Mack <daniel@caiaq.de>");
+MODULE_DESCRIPTION("DAC7512 16-bit DAC");
+MODULE_LICENSE("GPL v2");
+MODULE_VERSION(DRIVER_VERSION);
+
+module_init(dac7512_init);
+module_exit(dac7512_exit);
-- 
1.6.0.4

