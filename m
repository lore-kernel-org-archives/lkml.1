Return-Path: <linux-kernel-owner+w=401wt.eu-S1754051AbXGGJtO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754051AbXGGJtO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2007 05:49:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752145AbXGGJtD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jul 2007 05:49:03 -0400
Received: from gate.crashing.org ([63.228.1.57]:44049 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751295AbXGGJtA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2007 05:49:00 -0400
To: linux-ide@vger.kernel.org
Cc: linuxppc-dev@ozlabs.org
Cc: linux-kernel@vger.kernel.org
Cc: linuxppc-dev@ozlabs.org
From: Vitaly Bordug <vitb@kernel.crashing.org>
Subject: [PATCH 1/2] [ide] mmio ide support
Date: Sat, 07 Jul 2007 13:48:52 +0400
Message-ID: <20070707094852.9473.21013.stgit@localhost.localdomain>
User-Agent: StGIT/0.12
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This adds support for MMIO IDE device like CompactFlash 
in TrueIDE mode.
 
Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com> 
Signed-off-by: Vitaly Bordug <vitb@kernel.crashing.org>

---

 drivers/ide/Kconfig           |    6 +
 drivers/ide/legacy/Makefile   |    2 
 drivers/ide/legacy/mmio-ide.c |  211 +++++++++++++++++++++++++++++++++++++++++
 3 files changed, 219 insertions(+), 0 deletions(-)

diff --git a/drivers/ide/Kconfig b/drivers/ide/Kconfig
index b1a9b81..0dab799 100644
--- a/drivers/ide/Kconfig
+++ b/drivers/ide/Kconfig
@@ -946,6 +946,12 @@ config BLK_DEV_MPC8xx_IDE
 
 	  If unsure, say N.
 
+config BLK_DEV_MMIOIDE
+	tristate "Memory Mapped IDE support"
+	help
+	  This is the IDE driver for Memory Mapped IDE devices. Like
+	  Compact Flash running in True IDE mode.
+
 choice
 	prompt "Type of MPC8xx IDE interface"
 	depends on BLK_DEV_MPC8xx_IDE
diff --git a/drivers/ide/legacy/Makefile b/drivers/ide/legacy/Makefile
index c797106..61bd21e 100644
--- a/drivers/ide/legacy/Makefile
+++ b/drivers/ide/legacy/Makefile
@@ -7,6 +7,8 @@ obj-$(CONFIG_BLK_DEV_UMC8672)		+= umc8672.o
 
 obj-$(CONFIG_BLK_DEV_IDECS)		+= ide-cs.o
 
+obj-$(CONFIG_BLK_DEV_MMIOIDE)		+= mmio-ide.o
+
 # Last of all
 obj-$(CONFIG_BLK_DEV_HD)		+= hd.o
 
diff --git a/drivers/ide/legacy/mmio-ide.c b/drivers/ide/legacy/mmio-ide.c
new file mode 100644
index 0000000..77fb7dd
--- /dev/null
+++ b/drivers/ide/legacy/mmio-ide.c
@@ -0,0 +1,211 @@
+/*
+ * Memory Mapped IDE driver
+ *
+ * Author: Kumar Gala <galak@kernel.crashing.org>
+ *
+ * 2007 (c) MontaVista Software, Inc.  
+ * Vitaly Bordug <vitb@kernel.crashing.org> 
+ * Anton Vorontsov <avorontsov@ru.mvista.com>
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
+#include <linux/mmio-ide.h>
+#include <asm/io.h>
+
+static struct {
+	void __iomem *mmio_ide_mapbase;
+	void __iomem *mmio_ide_alt_mapbase;
+	ide_hwif_t *hwif;
+	int index;
+} hwif_prop;
+
+static ide_hwif_t * __devinit mmio_ide_locate_hwif(void __iomem * base,
+            void __iomem * ctrl, struct mmio_ide_platform_data *pdata, int irq)
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
+	port += pdata->regaddr_step + pdata->byte_lanes_swapping;
+	for (i = IDE_ERROR_OFFSET; i <= IDE_STATUS_OFFSET;
+	     i++, port += pdata->regaddr_step)
+		hwif->hw.io_ports[i] = port;
+
+	hwif->hw.io_ports[IDE_CONTROL_OFFSET] = (unsigned long)ctrl +
+		6 * pdata->regaddr_step + pdata->byte_lanes_swapping;
+
+	memcpy(hwif->io_ports, hwif->hw.io_ports, sizeof(hwif->hw.io_ports));
+	hwif->hw.irq = hwif->irq = irq;
+	hwif->selectproc = pdata->selectproc;
+
+	hwif->hw.dma = NO_DMA;
+	hwif->hw.chipset = ide_generic;
+
+	hwif->mmio = 2;
+	pdata->mmiops(hwif);
+	hwif_prop.hwif = hwif;
+	hwif_prop.index = index;
+
+	return hwif;
+}
+
+static int __devinit mmio_ide_probe(struct platform_device *pdev)
+{
+	struct resource *res_base, *res_alt, *res_irq;
+	ide_hwif_t *hwif;
+	struct mmio_ide_platform_data *pdata;
+	int ret = 0;
+
+	pdata = (struct mmio_ide_platform_data*)pdev->dev.platform_data;
+
+	/* get a pointer to the register memory */
+	res_base = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	res_alt = platform_get_resource(pdev, IORESOURCE_MEM, 1);
+	res_irq = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
+
+	if ((!res_base) || (!res_alt) || (!res_irq)) {
+		ret = -ENODEV;
+		goto out;
+	}
+
+	if (!request_mem_region(res_base->start, res_base->end -
+	                                   res_base->start + 1, pdev->name)) {
+		dev_dbg(&pdev->dev, "%s: request_mem_region of base failed\n",
+		        pdev->name);
+		ret = -EBUSY;
+		goto out;
+	}
+
+	if (!request_mem_region(res_alt->start, res_alt->end -
+	                                    res_alt->start + 1, pdev->name)) {
+		dev_dbg(&pdev->dev, "%s: request_mem_region of alt failed\n",
+		        pdev->name);
+		ret = -EBUSY;
+		goto release_base;
+	}
+
+	hwif_prop.mmio_ide_mapbase = ioremap(res_base->start, res_base->end -
+	                                     res_base->start + 1);
+	if (!hwif_prop.mmio_ide_mapbase) {
+		ret = -ENOMEM;
+		goto release_alt;
+	}
+
+	hwif_prop.mmio_ide_alt_mapbase = ioremap(res_alt->start, res_alt->end -
+	                                         res_alt->start + 1);
+	if (!hwif_prop.mmio_ide_alt_mapbase) {
+		ret = -ENOMEM;
+		goto unmap_base;
+	}
+
+	hwif = mmio_ide_locate_hwif(hwif_prop.mmio_ide_mapbase,
+	               hwif_prop.mmio_ide_alt_mapbase, pdata, res_irq->start);
+
+	if (!hwif) {
+		ret = -ENODEV;
+		goto unmap_alt;
+	}
+	hwif->gendev.parent = &pdev->dev;
+	hwif->noprobe = 0;
+
+	probe_hwif_init(hwif);
+
+	platform_set_drvdata(pdev, hwif);
+	create_proc_ide_interfaces();
+
+	return 0;
+
+unmap_alt:
+	iounmap(hwif_prop.mmio_ide_alt_mapbase);
+unmap_base:
+	iounmap(hwif_prop.mmio_ide_mapbase);
+release_alt:
+	release_mem_region(res_alt->start, res_alt->end - res_alt->start + 1);
+release_base:
+	release_mem_region(res_base->start,
+	                   res_base->end - res_base->start + 1);
+out:
+	return ret;
+}
+
+static int __devexit mmio_ide_remove(struct platform_device *pdev)
+{
+	ide_hwif_t *hwif = pdev->dev.driver_data;
+	struct resource *res_base, *res_alt;
+
+	/* get a pointer to the register memory */
+	res_base = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	res_alt = platform_get_resource(pdev, IORESOURCE_MEM, 1);
+
+	release_mem_region(res_base->start,
+	                   res_base->end - res_base->start + 1);
+	release_mem_region(res_alt->start, res_alt->end - res_alt->start + 1);
+
+	platform_set_drvdata(pdev, NULL);
+
+	if (hwif != hwif_prop.hwif)
+		dev_printk(KERN_DEBUG, &pdev->dev, "%s: hwif value error",
+		           pdev->name);
+	else {
+		ide_unregister (hwif_prop.index);
+		hwif_prop.index = 0;
+		hwif_prop.hwif = NULL;
+	}
+
+	iounmap(hwif_prop.mmio_ide_mapbase);
+	iounmap(hwif_prop.mmio_ide_alt_mapbase);
+
+	return 0;
+}
+
+static struct platform_driver mmio_ide_driver = {
+	.driver {
+		.name = "mmio-ide",
+	},
+	.probe = mmio_ide_probe,
+	.remove = __devexit_p(mmio_ide_remove),
+};
+
+static int __init mmio_ide_init(void)
+{
+	return platform_driver_register(&mmio_ide_driver);
+}
+
+static void __exit mmio_ide_exit(void)
+{
+	platform_driver_unregister(&mmio_ide_driver);
+}
+
+MODULE_DESCRIPTION("Memory Mapped IDE driver");
+MODULE_LICENSE("GPL");
+
+module_init(mmio_ide_init);
+module_exit(mmio_ide_exit);

