Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755049Ab0CHMNv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 07:13:51 -0500
Received: from ey-out-2122.google.com ([74.125.78.24]:27327 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754917Ab0CHMNp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 07:13:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:date:subject:mime-version:x-tuid:x-uid:x-length
         :organization:to:cc:content-type:content-transfer-encoding
         :message-id;
        b=Kmxg3mx8jTQaioFFSrw6Zd0MmM17jGqV7EtmWTu2F96brnkYAwfJQFg0dTMzRoOzM1
         pxPsZi+lT9vO5CTDDnIFlHRlPYZ5Qrlf2zSE9cbOL+YShuy1qikGfLxRR5OHGEhe7J0P
         l1pGLArC+fUirr3lySHAbvQhg3Ra4rQarZ/AQ=
From: Florian Fainelli <florian@openwrt.org>
Date: Mon, 8 Mar 2010 13:12:45 +0100
Subject: [PATCH 2/4] MFD: add support for the RDC321x southbridge
MIME-Version: 1.0
X-TUID: 0fc58ffdc2989a86
X-Length: 7398
Organization: OpenWrt
To: linux-kernel@vger.kernel.org
Cc: Wim Van Sebroeck <wim@iguana.be>, Samuel Ortiz <sameo@linux.intel.com>,
       Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201003081312.45499.florian@openwrt.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a new MFD driver for the RDC321x southbridge. This southbridge
is always present in the RDC321x System-on-a-Chip and provides access to some
GPIOs as well as a watchdog. Access to these two functions is done using the
southbridge PCI device configuration space.

Signed-off-by: Regards, Florian Fainelli <florian@openwrt.org>
---
diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 413576a..ad119fc 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -358,6 +358,16 @@ config MFD_TIMBERDALE
 
 	The timberdale FPGA can be found on the Intel Atom development board
 	for in-vehicle infontainment, called Russellville.
+
+config MFD_RDC321X
+	tristate "Support for RDC-R321x southbridge"
+	select MFD_CORE
+	depends on PCI
+	help
+	  Say yes here if you want to have support for the RDC R-321x SoC
+	  southbridge which provides access to GPIOs and Watchdog using the
+	  southbridge PCI device configuration space.
+
 endmenu
 
 menu "Multimedia Capabilities Port drivers"
diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index 78295d6..d57ad38 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -57,3 +57,4 @@ obj-$(CONFIG_AB4500_CORE)	+= ab4500-core.o
 obj-$(CONFIG_MFD_TIMBERDALE)    += timberdale.o
 obj-$(CONFIG_MFD_88PM8607)	+= 88pm8607.o
 obj-$(CONFIG_PMIC_ADP5520)	+= adp5520.o
+obj-$(CONFIG_MFD_RDC321X)	+= rdc321x-southbridge.o
diff --git a/drivers/mfd/rdc321x-southbridge.c b/drivers/mfd/rdc321x-southbridge.c
new file mode 100644
index 0000000..05a56fb
--- /dev/null
+++ b/drivers/mfd/rdc321x-southbridge.c
@@ -0,0 +1,148 @@
+/*
+ * RDC321x MFD southbrige driver
+ *
+ * Copyright (C) 2007-2010 Florian Fainelli <florian@openwrt.org>
+ * Copyright (C) 2010 Bernhard Loos <bernhardloos@googlemail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ *
+ */
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/platform_device.h>
+#include <linux/pci.h>
+#include <linux/mfd/core.h>
+#include <linux/mfd/rdc321x.h>
+
+static struct pci_dev *rdc321x_sb_pdev;
+
+/*
+ * Unlocked PCI configuration space accessors
+ */
+int rdc321x_pci_read(int reg, u32 *val)
+{
+	int err;
+
+	err = pci_read_config_dword(rdc321x_sb_pdev, reg, val);
+	if (err)
+		return err;
+
+	return err;
+}
+EXPORT_SYMBOL(rdc321x_pci_read);
+
+int rdc321x_pci_write(int reg, u32 val)
+{
+	int err;
+
+	err = pci_write_config_dword(rdc321x_sb_pdev, reg, val);
+	if (err)
+		return err;
+
+	return err;
+}
+EXPORT_SYMBOL(rdc321x_pci_write);
+
+static struct resource rdc321x_wdt_resource[] = {
+	{
+		.name	= "wdt-reg",
+		.start	= RDC321X_WDT_CTRL,
+		.end	= RDC321X_WDT_CTRL + 0x3,
+		.flags	= IORESOURCE_MEM,
+	}
+};
+
+static struct rdc321x_gpio_pdata rdc321x_gpio_pdata = {
+	.max_gpios	= RDC321X_MAX_GPIO,
+};
+
+static struct resource rdc321x_gpio_resources[] = {
+	{
+		.name	= "gpio-reg1",
+		.start	= RDC321X_GPIO_CTRL_REG1,
+		.end	= RDC321X_GPIO_CTRL_REG1 + 0x7,
+		.flags	= IORESOURCE_MEM,
+	}, {
+		.name	= "gpio-reg2",
+		.start	= RDC321X_GPIO_CTRL_REG2,
+		.end	= RDC321X_GPIO_CTRL_REG2 + 0x7,
+		.flags	= IORESOURCE_MEM,
+	}
+};
+
+static struct mfd_cell rdc321x_sb_cells[] = {
+	{
+		.name		= "rdc321x-wdt",
+		.resources	= rdc321x_wdt_resource,
+		.num_resources	= ARRAY_SIZE(rdc321x_wdt_resource),
+	}, {
+		.name 		= "rdc321x-gpio",
+		.resources	= rdc321x_gpio_resources,
+		.num_resources	= ARRAY_SIZE(rdc321x_gpio_resources),
+		.driver_data	= &rdc321x_gpio_pdata,
+	},
+};
+
+static int __devinit rdc321x_sb_probe(struct pci_dev *pdev,
+					const struct pci_device_id *ent)
+{
+	int err;
+
+	err = pci_enable_device(pdev);
+	if (err) {
+		printk(KERN_ERR "failed to enable device\n");
+		return err;
+	}
+
+	rdc321x_sb_pdev = pdev;
+
+	return mfd_add_devices(&pdev->dev, -1,
+		rdc321x_sb_cells, ARRAY_SIZE(rdc321x_sb_cells), NULL, 0);
+}
+
+static void __devexit rdc321x_sb_remove(struct pci_dev *pdev)
+{
+	mfd_remove_devices(&pdev->dev);
+}
+
+static struct pci_device_id rdc321x_sb_table[] = {
+	{ PCI_DEVICE(PCI_VENDOR_ID_RDC, PCI_DEVICE_ID_RDC_R6030) },
+	{}
+};
+
+static struct pci_driver rdc321x_sb_driver = {
+	.name 		= "RDC321x Southbridge",
+	.id_table 	= rdc321x_sb_table,
+	.probe 		= rdc321x_sb_probe,
+	.remove		= __devexit_p(rdc321x_sb_remove),
+};
+
+static int __init rdc321x_sb_init(void)
+{
+	return pci_register_driver(&rdc321x_sb_driver);
+}
+
+static void __exit rdc321x_sb_exit(void)
+{
+	pci_unregister_driver(&rdc321x_sb_driver);
+}
+
+module_init(rdc321x_sb_init);
+module_exit(rdc321x_sb_exit);
+
+MODULE_AUTHOR("Florian Fainelli <florian@openwrt.org>");
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("RDC R-321x MFD southbridge driver");
diff --git a/include/linux/mfd/rdc321x.h b/include/linux/mfd/rdc321x.h
new file mode 100644
index 0000000..82c595f
--- /dev/null
+++ b/include/linux/mfd/rdc321x.h
@@ -0,0 +1,24 @@
+#ifndef __RDC321X_MFD_H
+#define __RDC321X_MFD_H
+
+#include <linux/types.h>
+
+/* Offsets to be accessed in the southbridge PCI
+ * device configuration register */
+#define RDC321X_WDT_CTRL	0x44
+#define RDC321X_GPIO_CTRL_REG1	0x48
+#define RDC321X_GPIO_DATA_REG1	0x4c
+#define RDC321X_GPIO_CTRL_REG2	0x84
+#define RDC321X_GPIO_DATA_REG2	0x88
+
+#define RDC321X_MAX_GPIO	58
+
+/* Definitions for the shared southbridge accessors */
+int rdc321x_pci_write(int reg, u32 val);
+int rdc321x_pci_read(int reg, u32 *val);
+
+struct rdc321x_gpio_pdata {
+	unsigned max_gpios;
+};
+
+#endif /* __RDC321X_MFD_H */
