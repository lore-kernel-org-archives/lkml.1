Return-Path: <linux-kernel-owner+w=401wt.eu-S933708AbXGYQxj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933708AbXGYQxj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 12:53:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756376AbXGYQx3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 12:53:29 -0400
Received: from gate.crashing.org ([63.228.1.57]:50070 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755001AbXGYQx2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 12:53:28 -0400
To: linux-ide@vger.kernel.org
Cc: linuxppc-dev@ozlabs.org
Cc: linux-kernel@vger.kernel.org
Cc: linuxppc-dev@ozlabs.org
From: Vitaly Bordug <vitb@kernel.crashing.org>
Subject: [PATCH 1/2] [IDE] Platform IDE driver (was: MMIO IDE driver)
Date: Wed, 25 Jul 2007 20:53:18 +0400
Message-ID: <20070725165318.5331.23795.stgit@localhost.localdomain>
User-Agent: StGIT/0.12
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This is now very similar to pata_platform.c, they both use
same platform data structure and same resources.

To achieve that, byte_lanes_swapping platform data variable
and platform specified iops removed from that driver. It's fine,
since those were never used anyway.

pata_platform and ide_platform are carrying same driver names,
to easily switch between these drivers, without need to touch
platform code.

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
Signed-off-by: Vitaly Bordug <vitb@kernel.crashing.org>

---

 drivers/ide/Kconfig               |    8 ++
 drivers/ide/legacy/Makefile       |    2 
 drivers/ide/legacy/ide_platform.c |  181 +++++++++++++++++++++++++++++++++++++
 3 files changed, 191 insertions(+), 0 deletions(-)

diff --git a/drivers/ide/Kconfig b/drivers/ide/Kconfig
index b1a9b81..b5a44da 100644
--- a/drivers/ide/Kconfig
+++ b/drivers/ide/Kconfig
@@ -308,6 +308,14 @@ config IDE_GENERIC
 	help
 	  If unsure, say Y.
 
+config BLK_DEV_PLATFORM
+	tristate "Platform driver for IDE interfaces"
+	help
+	  This is the platform IDE driver, used mostly for Memory Mapped
+	  IDE devices, like Compact Flashes running in True IDE mode.
+
+	  If unsure, say N.
+
 config BLK_DEV_CMD640
 	bool "CMD640 chipset bugfix/support"
 	depends on X86
diff --git a/drivers/ide/legacy/Makefile b/drivers/ide/legacy/Makefile
index c797106..4098223 100644
--- a/drivers/ide/legacy/Makefile
+++ b/drivers/ide/legacy/Makefile
@@ -7,6 +7,8 @@ obj-$(CONFIG_BLK_DEV_UMC8672)		+= umc8672.o
 
 obj-$(CONFIG_BLK_DEV_IDECS)		+= ide-cs.o
 
+obj-$(CONFIG_BLK_DEV_PLATFORM)		+= ide_platform.o
+
 # Last of all
 obj-$(CONFIG_BLK_DEV_HD)		+= hd.o
 
diff --git a/drivers/ide/legacy/ide_platform.c b/drivers/ide/legacy/ide_platform.c
new file mode 100644
index 0000000..0b3f5b5
--- /dev/null
+++ b/drivers/ide/legacy/ide_platform.c
@@ -0,0 +1,181 @@
+/*
+ * Platform IDE driver
+ *
+ * Copyright (C) 2007 MontaVista Software
+ *
+ * Maintainer: Kumar Gala <galak@kernel.crashing.org>
+ *
+ * This program is free software; you can redistribute  it and/or modify it
+ * under  the terms of  the GNU General  Public License as published by the
+ * Free Software Foundation;  either version 2 of the  License, or (at your
+ * option) any later version.
+ */
+
+#include <linux/types.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/ide.h>
+#include <linux/ioport.h>
+#include <linux/module.h>
+#include <linux/pata_platform.h>
+#include <linux/io.h>
+
+static struct {
+	void __iomem *plat_ide_mapbase;
+	void __iomem *plat_ide_alt_mapbase;
+	ide_hwif_t *hwif;
+	int index;
+} hwif_prop;
+
+static ide_hwif_t *__devinit plat_ide_locate_hwif(void __iomem *base,
+	    void __iomem *ctrl, struct pata_platform_info *pdata, int irq,
+	    int mmio)
+{
+	unsigned long port = (unsigned long)base;
+	ide_hwif_t *hwif;
+	int index, i;
+
+	for (index = 0; index < MAX_HWIFS; ++index) {
+		hwif = ide_hwifs + index;
+		if (hwif->io_ports[IDE_DATA_OFFSET] == port)
+			goto found;
+	}
+
+	for (index = 0; index < MAX_HWIFS; ++index) {
+		hwif = ide_hwifs + index;
+		if (hwif->io_ports[IDE_DATA_OFFSET] == 0)
+			goto found;
+	}
+
+	return NULL;
+
+found:
+
+	hwif->hw.io_ports[IDE_DATA_OFFSET] = port;
+
+	port += (1 << pdata->ioport_shift);
+	for (i = IDE_ERROR_OFFSET; i <= IDE_STATUS_OFFSET;
+	     i++, port += (1 << pdata->ioport_shift))
+		hwif->hw.io_ports[i] = port;
+
+	hwif->hw.io_ports[IDE_CONTROL_OFFSET] = (unsigned long)ctrl;
+
+	memcpy(hwif->io_ports, hwif->hw.io_ports, sizeof(hwif->hw.io_ports));
+	hwif->hw.irq = hwif->irq = irq;
+
+	hwif->hw.dma = NO_DMA;
+	hwif->hw.chipset = ide_generic;
+
+	if (mmio) {
+		hwif->mmio = 1;
+		default_hwif_mmiops(hwif);
+	}
+
+	hwif_prop.hwif = hwif;
+	hwif_prop.index = index;
+
+	return hwif;
+}
+
+static int __devinit plat_ide_probe(struct platform_device *pdev)
+{
+	struct resource *res_base, *res_alt, *res_irq;
+	ide_hwif_t *hwif;
+	struct pata_platform_info *pdata;
+	int ret = 0;
+	int mmio = 0;
+
+	pdata = pdev->dev.platform_data;
+
+	/* get a pointer to the register memory */
+	res_base = platform_get_resource(pdev, IORESOURCE_IO, 0);
+	res_alt = platform_get_resource(pdev, IORESOURCE_IO, 1);
+
+	if (!res_base || !res_alt) {
+		res_base = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+		res_alt = platform_get_resource(pdev, IORESOURCE_MEM, 1);
+		if (!res_base || !res_alt) {
+			ret = -ENOMEM;
+			goto out;
+		}
+		mmio = 1;
+	}
+
+	res_irq = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
+	if (!res_irq) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	if (mmio) {
+		hwif_prop.plat_ide_mapbase = devm_ioremap(&pdev->dev,
+			res_base->start, res_base->end - res_base->start + 1);
+		hwif_prop.plat_ide_alt_mapbase = devm_ioremap(&pdev->dev,
+			res_alt->start, res_alt->end - res_alt->start + 1);
+	} else {
+		hwif_prop.plat_ide_mapbase = devm_ioport_map(&pdev->dev,
+			res_base->start, res_base->end - res_base->start + 1);
+		hwif_prop.plat_ide_alt_mapbase = devm_ioport_map(&pdev->dev,
+			res_alt->start, res_alt->end - res_alt->start + 1);
+	}
+
+	hwif = plat_ide_locate_hwif(hwif_prop.plat_ide_mapbase,
+	         hwif_prop.plat_ide_alt_mapbase, pdata, res_irq->start, mmio);
+
+	if (!hwif) {
+		ret = -ENODEV;
+		goto out;
+	}
+	hwif->gendev.parent = &pdev->dev;
+	hwif->noprobe = 0;
+
+	probe_hwif_init(hwif);
+
+	platform_set_drvdata(pdev, hwif);
+	ide_proc_register_port(hwif);
+
+	return 0;
+
+out:
+	return ret;
+}
+
+static int __devexit plat_ide_remove(struct platform_device *pdev)
+{
+	ide_hwif_t *hwif = pdev->dev.driver_data;
+
+	if (hwif != hwif_prop.hwif) {
+		dev_printk(KERN_DEBUG, &pdev->dev, "%s: hwif value error",
+		           pdev->name);
+	} else {
+		ide_unregister(hwif_prop.index);
+		hwif_prop.index = 0;
+		hwif_prop.hwif = NULL;
+	}
+
+	return 0;
+}
+
+static struct platform_driver platform_ide_driver = {
+	.driver {
+		.name = "pata_platform",
+	},
+	.probe = plat_ide_probe,
+	.remove = __devexit_p(plat_ide_remove),
+};
+
+static int __init platform_ide_init(void)
+{
+	return platform_driver_register(&platform_ide_driver);
+}
+
+static void __exit platform_ide_exit(void)
+{
+	platform_driver_unregister(&platform_ide_driver);
+}
+
+MODULE_DESCRIPTION("Platform IDE driver");
+MODULE_LICENSE("GPL");
+
+module_init(platform_ide_init);
+module_exit(platform_ide_exit);

