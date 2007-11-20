Return-Path: <linux-kernel-owner+w=401wt.eu-S1763322AbXKTUtq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763322AbXKTUtq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 15:49:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760923AbXKTUtg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 15:49:36 -0500
Received: from outmail1.freedom2surf.net ([194.106.33.237]:37303 "EHLO
	outmail1.freedom2surf.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760639AbXKTUtf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 15:49:35 -0500
X-Greylist: delayed 339 seconds by postgrey-1.27 at vger.kernel.org; Tue, 20 Nov 2007 15:49:34 EST
Subject: [patch] 2/4 Support for Toshiba TMIO multifunction devices
From: ian <spyro@f2s.com>
To: ARM Linux <linux-arm-kernel@lists.arm.linux.org.uk>,
       linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary="=-J67jF5uahArmjS+rcfDI"
Date: Tue, 20 Nov 2007 20:46:20 +0000
Message-Id: <1195591580.2329.60.camel@wirenth>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-J67jF5uahArmjS+rcfDI
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hi guys.

This patchset contains support for three toshiba multifunction devices.

This patch adds the core support code for three TMIO based MFDs.

There are no complete datasheets for these chips so their drivers are not
100% complete, however they do work.

--=-J67jF5uahArmjS+rcfDI
Content-Disposition: attachment; filename*0=0002-Preliminary-support-for-Toshibas-TMIO-based-multifun.pat; filename*1=ch
Content-Type: application/mbox; name=0002-Preliminary-support-for-Toshibas-TMIO-based-multifun.patch
Content-Transfer-Encoding: 7bit

>From e7ac11dbe1d89b80c0f52ef486173c394874604c Mon Sep 17 00:00:00 2001
From: Ian Molton <spyro@f2s.com>
Date: Tue, 20 Nov 2007 18:56:14 +0000
Subject: [PATCH] Preliminary support for Toshibas TMIO based multifunction chips.

    Includes support for:
     * t7l66xb
     * tc6387xb
     * tc6393xb
---
 drivers/mfd/Kconfig       |   25 +++
 drivers/mfd/Makefile      |    3 +
 drivers/mfd/t7l66xb.c     |  291 +++++++++++++++++++++++++++++++++++
 drivers/mfd/tc6387xb.c    |  143 +++++++++++++++++
 drivers/mfd/tc6393xb.c    |  374 +++++++++++++++++++++++++++++++++++++++++++++
 include/linux/t7l66xb.h   |   61 ++++++++
 include/linux/tc6387xb.h  |   40 +++++
 include/linux/tc6393.h    |  147 ++++++++++++++++++
 include/linux/tmio_mmc.h  |   17 ++
 include/linux/tmio_nand.h |    6 +
 include/linux/tmio_ohci.h |    6 +
 11 files changed, 1113 insertions(+), 0 deletions(-)
 create mode 100644 drivers/mfd/t7l66xb.c
 create mode 100644 drivers/mfd/tc6387xb.c
 create mode 100644 drivers/mfd/tc6393xb.c
 create mode 100644 include/linux/t7l66xb.h
 create mode 100644 include/linux/tc6387xb.h
 create mode 100644 include/linux/tc6393.h
 create mode 100644 include/linux/tmio_mmc.h
 create mode 100644 include/linux/tmio_nand.h
 create mode 100644 include/linux/tmio_ohci.h

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 2571619..301b237 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -15,6 +15,31 @@ config MFD_SM501
 	  interface. The device may be connected by PCI or local bus with
 	  varying functions enabled.
 
+config SOC_T7L66XB
+	bool "Toshiba T7L66XB SoC support"
+	---help---
+	  This driver supports the T7L66XB, which incorporates SD/MMC, and
+	  USB host functionality. associated subdevices are:
+	      tmio_mmc
+	      tmio_ohci
+
+config SOC_TC6387XB
+	bool "Toshiba TC6387XB SoC support"
+	---help---
+	  This driver supports the TC6393XB, which incorporates SD/MMC, NAND,
+	  Video, and USB host functionality. associated subdevices are:
+	      tmio_mmc
+
+config SOC_TC6393XB
+	bool "Toshiba TC6393XB SoC support"
+	---help---
+	  This driver supports the TC6393XB, which incorporates SD/MMC, NAND,
+	  Video, and USB host functionality. associated subdevices are:
+	      tmio_mmc
+	      tmio_nand
+	      tmio_fb
+	      tmio_ohci
+
 endmenu
 
 menu "Multimedia Capabilities Port drivers"
diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index 5143209..6fee649 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -8,6 +8,9 @@ obj-$(CONFIG_MCP)		+= mcp-core.o
 obj-$(CONFIG_MCP_SA11X0)	+= mcp-sa11x0.o
 obj-$(CONFIG_MCP_UCB1200)	+= ucb1x00-core.o
 obj-$(CONFIG_MCP_UCB1200_TS)	+= ucb1x00-ts.o
+obj-$(CONFIG_SOC_TC6387XB)      += tc6387xb.o soc-core.o
+obj-$(CONFIG_SOC_T7L66XB)       += t7l66xb.o soc-core.o
+obj-$(CONFIG_SOC_TC6393XB)      += tc6393xb.o soc-core.o
 
 ifeq ($(CONFIG_SA1100_ASSABET),y)
 obj-$(CONFIG_MCP_UCB1200)	+= ucb1x00-assabet.o
diff --git a/drivers/mfd/t7l66xb.c b/drivers/mfd/t7l66xb.c
new file mode 100644
index 0000000..fa9cd6f
--- /dev/null
+++ b/drivers/mfd/t7l66xb.c
@@ -0,0 +1,291 @@
+/*
+ * t7l66xb.c
+ *
+ * Toshiba T7L66XB support
+ * Copyright (c) 2005 Ian Molton
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This is based on my and Dirk Opfers work on the tc6393xb SoC.
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/delay.h>
+#include <linux/errno.h>
+#include <linux/ioport.h>
+#include <linux/irq.h>
+#include <linux/device.h>
+#include <linux/slab.h>
+#include <linux/spinlock.h>
+
+#include <asm/hardware.h>
+#include <asm/mach-types.h>
+#include <asm/io.h>
+#include <asm/arch/pxa-regs.h>
+
+#include <linux/t7l66xb.h>
+#include <linux/tmio_mmc.h>
+#include "soc-core.h"
+
+#define platform_get_platdata(_dev)      ((_dev)->dev.platform_data)
+
+struct t7l66xb_data
+{
+	int irq_base, irq_nr;
+	void *mapbase;
+	struct platform_device *devices;
+	int ndevices;
+};
+
+struct tmio_ohci_hwconfig t7l66xb_ohci_hwconfig = {
+	.start = NULL,
+};
+
+static struct resource t7l66xb_mmc_resources[] = {
+	{
+		.name = "control",
+		.start = T7L66XB_MMC_CTL_BASE,
+		.end   = T7L66XB_MMC_CTL_BASE + 0x1ff,
+		.flags = IORESOURCE_MEM,
+	},
+	{
+		.name = "config",
+		.start = T7L66XB_MMC_CNF_BASE,
+		.end   = T7L66XB_MMC_CNF_BASE + 0xff,
+		.flags = IORESOURCE_MEM,
+	},
+	{
+		.start = T7L66XB_MMC_IRQ,
+		.end = T7L66XB_MMC_IRQ,
+		.flags = IORESOURCE_IRQ | IORESOURCE_IRQ_SOC_SUBDEVICE,
+	},
+};
+
+static struct soc_device_data t7l66xb_devices[] = {
+	{
+		.name = "tmio_mmc",
+		.res = t7l66xb_mmc_resources,
+		.num_resources = ARRAY_SIZE(t7l66xb_mmc_resources),
+	},
+};
+
+/* Handle the T7L66XB interrupt mux */
+static void t7l66xb_irq_handler(unsigned int irq, struct irq_desc *desc)
+{
+	int req, i;
+	struct t7l66xb_data *data = get_irq_data(irq);
+
+	/* Acknowledge the parent IRQ */
+	desc->chip->ack(irq);
+  
+	while ( (req = (readb(data->mapbase + T7L66XB_SYS_ISR)
+			& ~(readb(data->mapbase + T7L66XB_SYS_IMR)))) ) {
+		for (i = 0; i <= 7; i++) {
+			int dev_irq = data->irq_base + i;
+			struct irq_desc *d = NULL;
+			if ((req & (1<<i))) {
+				d = irq_desc + dev_irq;
+				d->handle_irq(dev_irq, d);
+			}
+		}
+	}
+}
+
+
+static void t7l66xb_mask_irq(unsigned int irq)
+{
+	struct t7l66xb_data *data = get_irq_chip_data(irq);
+
+	writeb(readb(data->mapbase + T7L66XB_SYS_IMR) | 1 << (irq - data->irq_base), data->mapbase + T7L66XB_SYS_IMR);
+}
+
+static void t7l66xb_unmask_irq(unsigned int irq)
+{
+	struct t7l66xb_data *data = get_irq_chip_data(irq);
+
+	writeb(readb(data->mapbase + T7L66XB_SYS_IMR) & ~( 1 << (irq - data->irq_base)),data->mapbase + T7L66XB_SYS_IMR);
+}
+
+static struct irq_chip t7l66xb_chip = {
+	.name   = "t7l66xb",
+	.ack	= t7l66xb_mask_irq,
+	.mask	= t7l66xb_mask_irq,
+	.unmask	= t7l66xb_unmask_irq,
+};
+
+/* Install the IRQ handler */
+static void t7l66xb_setup_irq(struct t7l66xb_data *tchip)
+{
+	int i;
+
+	for (i = 0; i < T7L66XB_NR_IRQS; i++) {
+		int irq = tchip->irq_base + i;
+		set_irq_chip (irq, &t7l66xb_chip);
+		set_irq_chip_data (irq, tchip);
+		set_irq_handler(irq, handle_level_irq);
+		set_irq_flags(irq, IRQF_VALID | IRQF_PROBE);
+	}
+
+	set_irq_data (tchip->irq_nr, tchip);
+        set_irq_chained_handler (tchip->irq_nr, t7l66xb_irq_handler);
+	set_irq_type (tchip->irq_nr, IRQT_FALLING);
+}
+
+static void t7l66xb_hwinit(struct platform_device *dev)
+{
+	struct t7l66xb_platform_data *pdata = platform_get_platdata(dev);
+
+	if (pdata && pdata->hw_init)
+		pdata->hw_init();
+}
+
+
+#ifdef CONFIG_PM
+
+static int t7l66xb_suspend(struct platform_device *dev, pm_message_t state)
+{
+	struct t7l66xb_platform_data *pdata = platform_get_platdata(dev);
+
+
+	if (pdata && pdata->suspend)
+		pdata->suspend();
+
+	return 0;
+}
+
+static int t7l66xb_resume(struct platform_device *dev)
+{
+	struct t7l66xb_platform_data *pdata = platform_get_platdata(dev);
+
+	if (pdata && pdata->resume)
+		pdata->resume();
+
+	t7l66xb_hwinit(dev);
+
+	return 0;
+}
+#endif
+
+static int t7l66xb_probe(struct platform_device *dev)
+{
+	struct t7l66xb_platform_data *pdata = dev->dev.platform_data;
+	unsigned long pbase = (unsigned long)dev->resource[0].start;
+	unsigned long plen = dev->resource[0].end - dev->resource[0].start;
+	int err = -ENOMEM;
+	struct t7l66xb_data *data;
+
+	data = kmalloc (sizeof (struct t7l66xb_data), GFP_KERNEL);
+	if (!data)
+		goto out;
+
+	data->irq_base = pdata->irq_base;
+	data->irq_nr   = dev->resource[1].start;
+
+	if (!data->irq_base) {
+		printk("t7166xb: uninitialized irq_base!\n");
+		goto out_free_data;
+	}
+
+	data->mapbase = ioremap(pbase, plen);
+	if(!data->mapbase)
+		goto out_free_irqs;
+
+	platform_set_drvdata(dev, data);
+	t7l66xb_setup_irq(data);
+	t7l66xb_hwinit(dev);
+
+	/* Mask IRQs  -- should we mask/unmask on suspend/resume? */
+	writew(0xbf, data->mapbase + T7L66XB_SYS_IMR);
+
+	printk(KERN_INFO "%s rev %d @ 0x%08lx using irq %d-%d on irq %d\n",
+	       dev->name,  readw(data->mapbase + T7L66XB_SYS_RIDR),
+	       (unsigned long)data->mapbase, data->irq_base,
+	       data->irq_base + T7L66XB_NR_IRQS - 1, data->irq_nr);
+
+	data->devices = soc_add_devices(dev, t7l66xb_devices,
+	                                ARRAY_SIZE(t7l66xb_devices),
+	                                &dev->resource[0], 0, data->irq_base);
+
+	if(!data->devices){
+		printk(KERN_INFO "%s: Failed to allocate devices!\n",
+		       dev->name);
+		goto out_free_devices;
+	}
+
+	return 0;
+
+out_free_devices:
+	soc_free_devices(data->devices, ARRAY_SIZE(t7l66xb_devices));
+out_free_irqs:
+out_free_data:
+	kfree(data);
+out:
+	return err;
+}
+
+static int t7l66xb_remove(struct platform_device *dev)
+{
+	struct t7l66xb_data *tchip = platform_get_drvdata(dev);
+	int i;
+
+	/* Free the subdevice resources */
+	for (i = 0; i < tchip->ndevices; i++) {
+		platform_device_unregister (&tchip->devices[i]);
+		kfree (tchip->devices[i].resource);
+	}
+
+	/* Take down IRQ handling */
+        for (i = 0; i < T7L66XB_NR_IRQS; i++) {
+                int irq = i + tchip->irq_base;
+                set_irq_handler (irq, NULL);
+                set_irq_chip (irq, NULL);
+                set_irq_chip_data (irq, NULL);
+        }
+	set_irq_chained_handler (tchip->irq_nr, NULL);
+	
+	/* Free core resources */
+	iounmap (tchip->mapbase);
+	soc_free_devices(tchip->devices, ARRAY_SIZE(t7l66xb_devices));
+	kfree (tchip);
+
+	return 0;
+}
+
+
+static struct platform_driver t7l66xb_platform_driver = {
+	.driver = {
+		.name		= "t7l66xb",
+	},
+	.probe		= t7l66xb_probe,
+	.remove		= t7l66xb_remove,
+#ifdef CONFIG_PM
+	.suspend	= t7l66xb_suspend,
+	.resume		= t7l66xb_resume,
+#endif
+};
+
+
+static int __init t7l66xb_init(void)
+{
+	int retval = 0;
+		
+	retval = platform_driver_register (&t7l66xb_platform_driver);
+	return retval;
+}
+
+static void __exit t7l66xb_exit(void)
+{
+	platform_driver_unregister(&t7l66xb_platform_driver);
+}
+
+module_init(t7l66xb_init);
+module_exit(t7l66xb_exit);
+
+MODULE_DESCRIPTION("Toshiba T7L66XB core driver");
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Ian Molton and Dirk Opfer");
diff --git a/drivers/mfd/tc6387xb.c b/drivers/mfd/tc6387xb.c
new file mode 100644
index 0000000..1de4554
--- /dev/null
+++ b/drivers/mfd/tc6387xb.c
@@ -0,0 +1,143 @@
+/*
+ * linux/arch/arm/common/tc6387xb_soc.c
+ *
+ * Toshiba TC6387XB support
+ * Copyright (c) 2005 Ian Molton
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/delay.h>
+#include <linux/errno.h>
+#include <linux/ioport.h>
+#include <linux/device.h>
+#include <linux/slab.h>
+#include <linux/spinlock.h>
+
+#include <asm/hardware.h>
+#include <asm/mach-types.h>
+
+#include <linux/tmio_mmc.h>
+#include <linux/tc6387xb.h>
+#include "soc-core.h"
+
+struct tc6387xb_data {
+	int irq;
+	struct tc6387xb_platform_data *platform;
+};
+
+static void tc6387xb_hwinit(struct platform_device *dev)
+{
+	struct tc6387xb_data *data = platform_get_drvdata(dev);
+
+	if (data && data->platform && data->platform->hw_init)
+		data->platform->hw_init();
+
+}
+
+#ifdef CONFIG_PM
+
+static int tc6387xb_suspend(struct platform_device *dev, pm_message_t state)
+{
+	struct tc6387xb_data *data = platform_get_drvdata(dev);
+
+	if (data && data->platform && data->platform->suspend)
+		data->platform->suspend();
+
+	return 0;
+}
+
+static int tc6387xb_resume(struct platform_device *dev)
+{
+	struct tc6387xb_data *data = platform_get_drvdata(dev);
+
+	if (data && data->platform && data->platform->resume)
+		data->platform->resume();
+
+	return 0;
+}
+#endif
+
+static struct resource tc6387xb_mmc_resources[] = {
+        {
+                .name = "control",
+                .start = TC6387XB_MMC_CTL_BASE,
+                .end   = TC6387XB_MMC_CTL_BASE + 0x1ff,
+                .flags = IORESOURCE_MEM,
+        },
+        {
+                .name = "config",
+                .start = TC6387XB_MMC_CNF_BASE,
+                .end   = TC6387XB_MMC_CNF_BASE + 0xff,
+                .flags = IORESOURCE_MEM,
+        },
+        {
+                .start = TC6387XB_MMC_IRQ,
+                .end   = TC6387XB_MMC_IRQ,
+                .flags = IORESOURCE_IRQ | IORESOURCE_IRQ_SOC_SUBDEVICE,
+        },
+};
+
+static struct soc_device_data tc6387xb_devices[] = {
+        {
+                .name = "tmio_mmc",
+                .res = tc6387xb_mmc_resources,
+                .num_resources = ARRAY_SIZE(tc6387xb_mmc_resources),
+        },
+};
+
+
+static int tc6387xb_probe(struct platform_device *pdev)
+{
+	struct tc6387xb_data *data;
+
+	data = kmalloc(sizeof(struct tc6387xb_data), GFP_KERNEL);
+	if(!data)
+		return -ENOMEM;
+
+	data->irq = pdev->resource[1].start;
+	data->platform = pdev->dev.platform_data;
+	platform_set_drvdata(pdev, data);
+
+	tc6387xb_hwinit(pdev);
+	
+	soc_add_devices(pdev, tc6387xb_devices, ARRAY_SIZE(tc6387xb_devices), &pdev->resource[0], 0, data->irq);
+
+	/* Init finished. */
+	return 0;
+}
+
+static struct platform_driver tc6387xb_platform_driver = {
+	.driver = {
+		.name		= "tc6387xb",
+	},
+	.probe		= tc6387xb_probe,
+#ifdef CONFIG_PM
+	.suspend	= tc6387xb_suspend,
+	.resume		= tc6387xb_resume,
+#endif
+};
+
+
+static int __init tc6387xb_init(void)
+{
+	return platform_driver_register (&tc6387xb_platform_driver);
+}
+
+static void __exit tc6387xb_exit(void)
+{
+	platform_driver_unregister(&tc6387xb_platform_driver);
+}
+
+module_init(tc6387xb_init);
+module_exit(tc6387xb_exit);
+
+MODULE_DESCRIPTION("Toshiba TC6387XB core driver");
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Ian Molton");
diff --git a/drivers/mfd/tc6393xb.c b/drivers/mfd/tc6393xb.c
new file mode 100644
index 0000000..9525073
--- /dev/null
+++ b/drivers/mfd/tc6393xb.c
@@ -0,0 +1,374 @@
+/*
+ * linux/arch/arm/common/tc6393xb_soc.c
+ *
+ * Toshiba TC6393 support
+ * Copyright (c) 2005 Dirk Opfer
+ * Copyright (c) 2005 Ian Molton <spyro@f2s.com>
+ *
+ *	Based on code written by Sharp/Lineo for 2.4 kernels
+ *	Based on locomo.c
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/delay.h>
+#include <linux/errno.h>
+#include <linux/ioport.h>
+#include <linux/irq.h>
+#include <linux/device.h>
+#include <linux/slab.h>
+#include <linux/spinlock.h>
+
+#include <asm/hardware.h>
+#include <asm/mach-types.h>
+#include <asm/io.h>
+#include <asm/arch/pxa-regs.h>
+
+#include <linux/tmio_mmc.h>
+#include <linux/tmio_nand.h>
+#include <linux/tmio_ohci.h>
+#include <linux/tc6393.h>
+#include "soc-core.h"
+
+#define platform_get_platdata(_dev)      ((_dev)->dev.platform_data)
+
+struct tc6393xb_data
+{
+	int irq_base, irq_nr;
+	void *mapbase;
+	struct platform_device *devices;
+	int ndevices;
+};
+
+/* Setup the TC6393XB NAND flash controllers configuration registers */
+static void tc6393xb_nand_hwinit(struct platform_device *sdev) {
+	
+	struct tc6393xb_data *chip = platform_get_drvdata(sdev);
+	
+	/* Sequence: 
+	 * SMD Buffer ON (gpio related)
+	 * Enable the clock (SCRUNEN)
+	 * Set the ctl reg base address
+	 * Enable the ctl reg
+	 * Configure power control (control bt PCNT[1,0] 4ms startup delay)
+	 */
+	/* (89h) SMD Buffer ON By TC6393XB SystemConfig gpibfc1*/
+	writew(0xff, chip->mapbase + TC6393_SYS_GPIBCR1);
+
+}
+
+static struct tmio_nand_hwconfig tc6393xb_nand_hwconfig = {
+	.hwinit  = tc6393xb_nand_hwinit,
+};
+
+static void tc6393xb_mmc_set_clock(struct platform_device *sdev, int state) {
+	struct tc6393xb_data *chip = platform_get_drvdata(sdev);
+	unsigned char tmp;
+
+	if(state == MMC_CLOCK_ENABLED){
+		tmp = readw(chip->mapbase + TC6393_SYS_GPIBCR1);
+		writew(tmp | CK32KEN, chip->mapbase + TC6393_SYS_GPIBCR1);
+	}
+}
+
+static struct tmio_mmc_hwconfig tc6393xb_mmc_hwconfig = {
+        .set_mmc_clock  = tc6393xb_mmc_set_clock,
+};
+
+static struct resource tc6393xb_mmc_resources[] = {
+	{
+		.name = "control",
+		.start = TC6393XB_MMC_CTL_BASE,
+		.end   = TC6393XB_MMC_CTL_BASE + 0x1ff,
+		.flags = IORESOURCE_MEM,
+	},
+	{
+		.name = "config",
+		.start = TC6393XB_MMC_CNF_BASE,
+		.end   = TC6393XB_MMC_CNF_BASE + 0xff,
+		.flags = IORESOURCE_MEM,
+	},
+	{
+		.start = TC6393XB_MMC_IRQ,
+		.end   = TC6393XB_MMC_IRQ,
+		.flags = IORESOURCE_IRQ | IORESOURCE_IRQ_SOC_SUBDEVICE,
+	},
+};
+
+static struct resource tc6393xb_nand_resources[] = {
+	{
+		.name = "control",
+		.start = TC6393XB_NAND_CTL_BASE,
+		.end   = TC6393XB_NAND_CTL_BASE + 0x1ff,
+		.flags = IORESOURCE_MEM,
+	},
+	{
+		.name = "config",
+		.start = TC6393XB_NAND_CNF_BASE,
+		.end   = TC6393XB_NAND_CNF_BASE + 0xff,
+		.flags = IORESOURCE_MEM,
+	},
+};
+
+static struct soc_device_data tc6393xb_devices[] = {
+	{
+		.name = "tmio_mmc",
+		.res = tc6393xb_mmc_resources,
+		.num_resources = ARRAY_SIZE(tc6393xb_mmc_resources),
+		.hwconfig = &tc6393xb_mmc_hwconfig,
+	},
+	{
+		.name = "tmio-nand",
+		.res = tc6393xb_nand_resources,
+		.num_resources = ARRAY_SIZE(tc6393xb_nand_resources),
+		.hwconfig = &tc6393xb_nand_hwconfig,
+	},
+};
+
+/** TC6393 interrupt handling stuff.
+ * NOTE: TC6393 has a 1 to many mapping on all of its IRQs.
+ * that is, there is only one real hardware interrupt
+ * we determine which interrupt it is by reading some IO memory.
+ * We have two levels of expansion, first in the handler for the
+ * hardware interrupt we generate an interrupt
+ * IRQ_TC6393_*_BASE and those handlers generate more interrupts
+ *
+ */
+static void tc6393xb_irq_handler(unsigned int irq, struct irq_desc *desc)
+{
+	int req, i;
+	struct tc6393xb_data *data = get_irq_data(irq);
+	
+	/* Acknowledge the parent IRQ */
+	desc->chip->ack(irq);
+  
+	while ( (req = (readb(data->mapbase + TC6393_SYS_ISR)
+			& ~(readb(data->mapbase + TC6393_SYS_IMR)))) ) {
+		for (i = 0; i <= 7; i++) {
+			int dev_irq = data->irq_base + i;
+			struct irq_desc *d = NULL;
+			if ((req & (1<<i))) {
+				if(i != 1)  printk("IRQ! from %d\n", i);
+				d = irq_desc + dev_irq;
+				d->handle_irq(dev_irq, d);
+			}
+		}
+	}
+}
+
+static void tc6393xb_mask_irq(unsigned int irq)
+{
+	struct tc6393xb_data *tc6393 = get_irq_chip_data(irq);
+
+	writeb(readb(tc6393->mapbase + TC6393_SYS_IMR) | 1 << (irq - tc6393->irq_base),tc6393->mapbase + TC6393_SYS_IMR);
+}
+
+static void tc6393xb_unmask_irq(unsigned int irq)
+{
+	struct tc6393xb_data *tc6393 = get_irq_chip_data(irq);
+
+	writeb(readb(tc6393->mapbase + TC6393_SYS_IMR) & ~( 1 << (irq - tc6393->irq_base)),tc6393->mapbase + TC6393_SYS_IMR);
+}
+
+static struct irq_chip tc6393xb_chip = {
+	.ack	= tc6393xb_mask_irq,
+	.mask	= tc6393xb_mask_irq,
+	.unmask	= tc6393xb_unmask_irq,
+};
+
+
+static void tc6393xb_setup_irq(struct tc6393xb_data *tchip)
+{
+	int i;
+	
+	for (i = 0; i < TC6393XB_NR_IRQS; i++) {
+		int irq = tchip->irq_base + i;
+		set_irq_chip (irq, &tc6393xb_chip);
+		set_irq_chip_data (irq, tchip);
+		set_irq_handler(irq, handle_level_irq);
+		set_irq_flags(irq, IRQF_VALID | IRQF_PROBE);
+	}
+
+	set_irq_data (tchip->irq_nr, tchip);
+	set_irq_chained_handler (tchip->irq_nr, tc6393xb_irq_handler);
+	set_irq_type (tchip->irq_nr, IRQT_FALLING);
+}
+
+void tc6393xb_hwinit(struct platform_device *dev)
+{
+	struct tc6393xb_platform_data *pdata = platform_get_platdata(dev);
+	struct tc6393xb_data *tchip =  platform_get_drvdata(dev);
+
+	if(!pdata || !tchip){
+		BUG_ON("no driver data!\n");
+		return;
+	}
+
+	if (pdata->hw_init)
+		pdata->hw_init();
+		
+	writew(0, tchip->mapbase + TC6393_SYS_FER);
+
+	/* Clock setting */
+	writew(pdata->sys_pll2cr,   tchip->mapbase + TC6393_SYS_PLL2CR);
+	writew(pdata->sys_ccr,      tchip->mapbase + TC6393_SYS_CCR);
+	writew(pdata->sys_mcr,      tchip->mapbase + TC6393_SYS_MCR);
+
+  	/* GPIO */
+	writew(pdata->sys_gper,     tchip->mapbase + TC6393_SYS_GPER);
+	writew(pdata->sys_gpodsr1,  tchip->mapbase + TC6393_SYS_GPODSR1);
+	writew(pdata->sys_gpooecr1, tchip->mapbase + TC6393_SYS_GPOOECR1);
+}
+
+
+#ifdef CONFIG_PM
+
+static int tc6393xb_suspend(struct platform_device *dev, pm_message_t state)
+{
+	struct tc6393xb_platform_data *pdata = platform_get_platdata(dev);
+
+	if (pdata && pdata->suspend)
+		pdata->suspend();
+
+	return 0;
+}
+
+static int tc6393xb_resume(struct platform_device *dev)
+{
+	struct tc6393xb_platform_data *pdata = platform_get_platdata(dev);
+
+	if (pdata && pdata->resume)
+		pdata->resume();
+
+	tc6393xb_hwinit(dev);
+
+	return 0;
+}
+
+#endif
+
+static int tc6393xb_probe(struct platform_device *dev)
+{
+	struct tc6393xb_platform_data *pdata = dev->dev.platform_data;
+	unsigned long pbase = (unsigned long)dev->resource[0].start;
+	unsigned long plen = dev->resource[0].end - dev->resource[0].start;
+	int err = -ENOMEM;
+	struct tc6393xb_data *data;
+
+	data = kmalloc (sizeof (struct tc6393xb_data), GFP_KERNEL);
+	if (!data)
+		goto out;
+
+	data->irq_base = pdata->irq_base;
+	data->irq_nr = dev->resource[1].start;
+
+	if (!data->irq_base) {
+		printk("tc6393xb: uninitialized irq_base!\n");
+		goto out_free_data;
+	}
+
+	data->mapbase = ioremap(pbase, plen);
+	if(!data->mapbase)
+		goto out_free_irqs;
+
+	platform_set_drvdata(dev, data);
+	tc6393xb_setup_irq (data);
+	tc6393xb_hwinit(dev);
+
+	/* Enable (but mask!) our IRQs */
+	writew(0,    data->mapbase + TC6393_SYS_IRR);
+	writew(0xbf, data->mapbase + TC6393_SYS_IMR);
+
+	printk(KERN_INFO "%s rev %d @ 0x%08lx using irq %d-%d on irq %d\n",
+	       dev->name,  readw(data->mapbase + TC6393_SYS_RIDR),
+	       (unsigned long)data->mapbase, data->irq_base,
+	       data->irq_base + TC6393XB_NR_IRQS - 1, data->irq_nr);
+
+	data->devices =  soc_add_devices(dev, tc6393xb_devices,
+	                                ARRAY_SIZE(tc6393xb_devices),
+	                                &dev->resource[0], 0, data->irq_base);
+
+	if(!data->devices) {
+		printk(KERN_INFO "%s: Failed to allocate devices!\n",
+		       dev->name);
+		goto out_free_devices;
+	}
+
+	return 0;
+
+out_free_devices:
+	soc_free_devices(data->devices, ARRAY_SIZE(tc6393xb_devices));
+out_free_irqs:
+out_free_data:
+	kfree(data);
+out:
+	return err;
+}
+
+static int tc6393xb_remove(struct platform_device *dev)
+{
+	struct tc6393xb_data *tchip = platform_get_drvdata(dev);
+	int i;
+
+	/* Free the subdevice resources */
+        for (i = 0; i < tchip->ndevices; i++) {
+                platform_device_unregister (&tchip->devices[i]);
+                kfree (tchip->devices[i].resource);
+        }
+
+	/* Take down IRQ handling */
+	for (i = 0; i < TC6393XB_NR_IRQS; i++) {
+		int irq = i + tchip->irq_base;
+		set_irq_handler (irq, NULL);
+		set_irq_chip (irq, NULL);
+		set_irq_chip_data (irq, NULL);
+	}
+	
+	set_irq_chained_handler (tchip->irq_nr, NULL);
+
+	/* Free core resources */
+        iounmap (tchip->mapbase);
+        soc_free_devices(tchip->devices, ARRAY_SIZE(tc6393xb_devices));
+        kfree (tchip);
+
+	return 0;
+}
+
+
+static struct platform_driver tc6393xb_device_driver = {
+	.driver = {
+		.name		= "tc6393xb",
+	},
+	.probe		= tc6393xb_probe,
+	.remove		= tc6393xb_remove,
+#ifdef CONFIG_PM
+	.suspend	= tc6393xb_suspend,
+	.resume		= tc6393xb_resume,
+#endif
+};
+
+
+static int __init tc6393xb_init(void)
+{
+	int retval = 0;
+	retval = platform_driver_register (&tc6393xb_device_driver);
+	return retval;
+}
+
+static void __exit tc6393xb_exit(void)
+{
+	platform_driver_unregister(&tc6393xb_device_driver);
+}
+
+module_init(tc6393xb_init);
+module_exit(tc6393xb_exit);
+
+MODULE_DESCRIPTION("Toshiba TC6393 core driver");
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Dirk Opfer and Ian Molton");
diff --git a/include/linux/t7l66xb.h b/include/linux/t7l66xb.h
new file mode 100644
index 0000000..f977058
--- /dev/null
+++ b/include/linux/t7l66xb.h
@@ -0,0 +1,61 @@
+/*
+ * linux/include/asm-arm/hardware/t7l66xb.h
+ *
+ * This file contains the definitions for the T7L66XB
+ *
+ * (C) Copyright 2005 Ian Molton <spyro@f2s.com>
+ *
+ * May be copied or modified under the terms of the GNU General Public
+ * License.  See linux/COPYING for more information.
+ *
+ */
+#ifndef _ASM_ARCH_T7L66XB_SOC
+#define _ASM_ARCH_T7L66XB_SOC
+
+#include <linux/platform_device.h>
+
+
+// FIXME - this needs to be a common struct to all TMIO based SoCs.
+struct tmio_hwconfig {
+	void (*hwinit)(struct platform_device *sdev);
+	void (*suspend)(struct platform_device *sdev);
+	void (*resume)(struct platform_device *sdev);
+};
+
+struct tmio_ohci_hwconfig {
+	void (*start)(struct platform_device *dev);
+};
+
+struct t7l66xb_platform_data
+{
+	/* Standard MFD properties */
+	int irq_base;
+	struct platform_device **child_devs;
+	int num_child_devs;
+
+	void (* hw_init) (void);
+	void (* suspend) (void);
+	void (* resume)  (void);
+};
+
+
+#define T7L66XB_NAND_CNF_BASE  (0x000100)
+#define T7L66XB_NAND_CTL_BASE  (0x001000)
+
+#define T7L66XB_MMC_CNF_BASE   (0x000200)
+#define T7L66XB_MMC_CTL_BASE   (0x000800)
+#define T7L66XB_MMC_IRQ        (1)
+
+#define T7L66XB_USB_CNF_BASE   (0x000300)
+#define T7L66XB_USB_CTL_BASE   (0x002000)
+#define T7L66XB_OHCI_IRQ       (0)
+
+/* System Configuration register */
+#define T7L66XB_SYS_RIDR    0x008        // Revision ID
+#define T7L66XB_SYS_ISR     0x0e1        // Interrupt Status
+#define T7L66XB_SYS_IMR     0x042        // Interrupt Mask
+//#define T7L66XB_SYS_IRR     0x054        // Interrupt Routing
+
+#define T7L66XB_NR_IRQS	8
+
+#endif
diff --git a/include/linux/tc6387xb.h b/include/linux/tc6387xb.h
new file mode 100644
index 0000000..c7a625e
--- /dev/null
+++ b/include/linux/tc6387xb.h
@@ -0,0 +1,40 @@
+/*
+ * linux/include/asm-arm/hardware/tc6387xb.h
+ *
+ * This file contains the definitions for the TC6393XB
+ *
+ * (C) Copyright 2005 Ian Molton <spyro@f2s.com>
+ *
+ * May be copied or modified under the terms of the GNU General Public
+ * License.  See linux/COPYING for more information.
+ *
+ */
+#ifndef _ASM_ARCH_T7L66XB_SOC
+#define _ASM_ARCH_T7L66XB_SOC
+
+#include <linux/platform_device.h>
+
+// FIXME - this needs to be a common struct to all TMIO based SoCs.
+struct tmio_hwconfig {
+	void (*hwinit)(struct platform_device *sdev);
+	void (*suspend)(struct platform_device *sdev);
+	void (*resume)(struct platform_device *sdev);
+};
+
+struct tc6387xb_platform_data
+{
+	/* Standard MFD properties */
+	int irq_base;
+	struct platform_device **child_devs;
+	int num_child_devs;
+
+	void (* hw_init) (void);
+	void (* suspend) (void);
+	void (* resume)  (void);
+};
+
+#define TC6387XB_MMC_CNF_BASE    (0x000200)
+#define TC6387XB_MMC_CTL_BASE    (0x000800)
+#define TC6387XB_MMC_IRQ         (0)
+
+#endif
diff --git a/include/linux/tc6393.h b/include/linux/tc6393.h
new file mode 100644
index 0000000..4bdaa24
--- /dev/null
+++ b/include/linux/tc6393.h
@@ -0,0 +1,147 @@
+/*
+ * linux/include/asm-arm/hardware/tc6393.h
+ *
+ * This file contains the definitions for the TC6393 
+ *
+ * (C) Copyright 2005 Dirk Opfer
+ *
+ * May be copied or modified under the terms of the GNU General Public
+ * License.  See linux/COPYING for more information.
+ *
+ */
+#ifndef _ASM_ARCH_TC6393XB_SOC
+#define _ASM_ARCH_TC6393XB_SOC
+
+struct tc6393xb_platform_data
+{
+	/* Standard MFD properties */
+	int irq_base;
+	struct platform_device **child_devs;
+	int num_child_devs;
+
+	u16 sys_gper;
+	u16 sys_gpodsr1;
+	u16 sys_gpooecr1;
+	u16 sys_pll2cr;
+	u16 sys_ccr;
+	u16 sys_mcr;
+	void (* hw_init) (void);
+	void (* suspend) (void);
+	void (* resume)  (void);
+};
+
+#define CK32KEN 0x1
+#define USBCLK  0x2
+
+//TC6393XB Resource Area Map (Offset)
+//  System Configration Register Area         0x00000000 - 0x000000FF 
+//  NAND Flash Host Controller Register Area  0x00000100 - 0x000001FF 
+//  USB Host Controller Register Area         0x00000300 - 0x000003FF
+//  LCD Host Controller Register Area         0x00000500 - 0x000005FF
+//  NAND Flash Control Register               0x00001000 - 0x00001007
+//  USB Control Register                      0x00003000 - 0x000031FF
+//  LCD Control Register                      0x00005000 - 0x000051FF
+//  Local Memory 0 (32KB)                     0x00010000 - 0x00017FFF
+//  Local Memory 0 (32KB) alias               0x00018000 - 0x0001FFFF
+//  Local Memory 1 (1MB)                      0x00100000 - 0x001FFFFF
+
+#define TC6393_SYS_BASE		0
+
+#define TC6393XB_NAND_CNF_BASE	(TC6393_SYS_BASE + 0x000100)
+#define TC6393XB_NAND_CTL_BASE  (TC6393_SYS_BASE + 0x001000)
+//#define TC6393XB_NAND_IRQ       -1
+
+#define TC6393XB_MMC_CNF_BASE	(TC6393_SYS_BASE + 0x000200)
+#define TC6393XB_MMC_CTL_BASE	(TC6393_SYS_BASE + 0x000800)
+#define TC6393XB_MMC_IRQ          (1)
+
+#define TC6393XB_USB_CNF_BASE   (TC6393_SYS_BASE + 0x000300)
+#define TC6393XB_USB_CTL_BASE   (TC6393_SYS_BASE + 0x000a00)
+#define TC6393XB_USB_IRQ        (0)
+
+#define TC6393_SERIAL_CONF_BASE	(TC6393_SYS_BASE + 0x000400)
+#define TC6393_GC_CONF_BASE	(TC6393_SYS_BASE + 0x000500)
+#define TC6393_RAM0_BASE	(TC6393_SYS_BASE + 0x010000)
+#define TC6393_RAM0_SIZE	(32*1024)
+#define TC6393_RAM1_BASE	(TC6393_SYS_BASE + 0x100000)
+#define TC6393_RAM1_SIZE	(64 * 1024 * 16)
+
+
+/* 
+ * Internal Local Memory use purpose
+ *   RAM0 is used for USB
+ *   RAM1 is used for GC
+ */
+/* Internal register mapping */
+#define TC6393_GC_INTERNAL_REG_BASE	0x000600	/* Length 0x200 */
+
+	
+/* System Configuration register */
+//#define TC6393_SYS_REG(ofst) (*(volatile unsigned short*)(TC6393_SYS_BASE+(ofst)))
+#define TC6393_SYS_RIDR		0x008			// Revision ID
+#define TC6393_SYS_ISR		0x050			// Interrupt Status
+#define TC6393_SYS_IMR		0x052			// Interrupt Mask
+#define TC6393_SYS_IRR		0x054			// Interrupt Routing
+#define TC6393_SYS_GPER		0x060			// GP Enable
+#define TC6393_SYS_GPAIOEN	0x061			// GP Alternative Enable
+#define TC6393_SYS_GPISR1	0x064			// GPI Status 1
+#define TC6393_SYS_GPISR2	0x066			// GPI Status 2
+#define TC6393_SYS_GPIIMR1	0x068			// GPI INT Mask 1
+#define TC6393_SYS_GPIIMR2	0x06A			// GPI INT Mask 2
+#define TC6393_SYS_GPIEDER1	0x06C			// GPI Edge Detect Enable 1
+#define TC6393_SYS_GPIEDER2	0x06E			// GPI Edge Detect Enable 2
+#define TC6393_SYS_GPILIR1	0x070			// GPI Level Invert 1
+#define TC6393_SYS_GPILIR2	0x072			// GPI Level Invert 2
+#define TC6393_SYS_GPODSR1	0x078			// GPO Data set 1
+#define TC6393_SYS_GPODSR2      0x07A			// GPO Data set 2
+#define TC6393_SYS_GPOOECR1     0x07C			// GPO Data OE Contorol 1
+#define TC6393_SYS_GPOOECR2     0x07E			// GPO Data OE Contorol 2
+#define TC6393_SYS_GPIARCR1     0x080			// GP Internal Active Register Contorol 1
+#define TC6393_SYS_GPIARCR2     0x082			// GP Internal Active Register Contorol 2
+#define TC6393_SYS_GPIARLCR1    0x084			// GP Internal Active Register Level Contorol 1
+#define TC6393_SYS_GPIARLCR2    0x086			// GP Internal Active Register Level Contorol 2
+
+#define TC6393_SYS_GPIBCR1      0x089			// GPa Internal Activ Register Contorol 1
+
+#define TC6393_SYS_GPIBCR2      0x08A			// GPa Internal Activ Register Contorol 2
+#define TC6393_SYS_GPaIARCR     0x08C			
+#define TC6393_SYS_GPaIARLCR    0x090
+#define TC6393_SYS_GPaIBCR      0x094
+#define TC6393_SYS_CCR          0x098			/* Clock Control Register */
+#define TC6393_SYS_PLL2CR       0x09A			// PLL2 Control
+#define TC6393_SYS_PLL1CR1      0x09C			// PLL1 Control 1
+#define TC6393_SYS_PLL1CR2      0x09E			// PLL1 Control 2
+#define TC6393_SYS_DCR          0x0A0
+#define TC6393_SYS_FER          0x0E0			/* Function Enable Register */
+#define TC6393_SYS_MCR          0x0E4
+#define TC6393_SYS_ConfigCR     0x0FC
+
+//#define IS_TC6393_RAM0(p)	(TC6393_RAM0_BASE <= (unsigned int)p && (unsigned int)p <= TC6393_RAM0_BASE + TC6393_RAM0_SIZE)
+//#define TC6393_RAM0_VAR_TO_OFFSET(x)	((unsigned int)x - TC6393_RAM0_BASE)
+//#define TC6393_RAM0_OFFSET_TO_VAR(x)	((unsigned int)x + TC6393_RAM0_BASE)
+
+/* GPIO bit */
+#define TC6393_GPIO19  ( 1 << 19 )
+#define TC6393_GPIO18  ( 1 << 18 )
+#define TC6393_GPIO17  ( 1 << 17 )
+#define TC6393_GPIO16  ( 1 << 16 )
+#define TC6393_GPIO15  ( 1 << 15 )
+#define TC6393_GPIO14  ( 1 << 14 )
+#define TC6393_GPIO13  ( 1 << 13 )
+#define TC6393_GPIO12  ( 1 << 12 )
+#define TC6393_GPIO11  ( 1 << 11 )
+#define TC6393_GPIO10  ( 1 << 10 )
+#define TC6393_GPIO9   ( 1 << 9 )
+#define TC6393_GPIO8   ( 1 << 8 )
+#define TC6393_GPIO7   ( 1 << 7 )
+#define TC6393_GPIO6   ( 1 << 6 )
+#define TC6393_GPIO5   ( 1 << 5 )
+#define TC6393_GPIO4   ( 1 << 4 )
+#define TC6393_GPIO3   ( 1 << 3 )
+#define TC6393_GPIO2   ( 1 << 2 )
+#define TC6393_GPIO1   ( 1 << 1 )
+#define TC6393_GPIO0   ( 1 << 0 )
+
+#define TC6393XB_NR_IRQS	8
+
+#endif
diff --git a/include/linux/tmio_mmc.h b/include/linux/tmio_mmc.h
new file mode 100644
index 0000000..b8c407c
--- /dev/null
+++ b/include/linux/tmio_mmc.h
@@ -0,0 +1,17 @@
+#include <linux/platform_device.h>
+
+#define MMC_CLOCK_DISABLED 0
+#define MMC_CLOCK_ENABLED  1
+
+#define TMIO_WP_ALWAYS_RW ((void*)-1)
+
+struct tmio_mmc_hwconfig {
+	void (*hwinit)(struct platform_device *sdev);
+	void (*set_mmc_clock)(struct platform_device *sdev, int state);
+
+	/* NULL - use ASIC3 signal, 
+	   TMIO_WP_ALWAYS_RW - assume always R/W (e.g. miniSD) 
+	   otherwise - machine-specific handler */
+	int (*mmc_get_ro)(struct platform_device *pdev);
+	short address_shift;
+};
diff --git a/include/linux/tmio_nand.h b/include/linux/tmio_nand.h
new file mode 100644
index 0000000..ebfd483
--- /dev/null
+++ b/include/linux/tmio_nand.h
@@ -0,0 +1,6 @@
+struct tmio_nand_hwconfig {
+        void (*hwinit)(struct platform_device *sdev);
+        void (*suspend)(struct platform_device *sdev);
+        void (*resume)(struct platform_device *sdev);
+};
+
diff --git a/include/linux/tmio_ohci.h b/include/linux/tmio_ohci.h
new file mode 100644
index 0000000..56e7c73
--- /dev/null
+++ b/include/linux/tmio_ohci.h
@@ -0,0 +1,6 @@
+struct tmio_ohci_hwconfig {
+        void (*hwinit)(struct platform_device *sdev);
+        void (*suspend)(struct platform_device *sdev);
+        void (*resume)(struct platform_device *sdev);
+};
+
-- 
1.5.3.5.737.gdee1b


--=-J67jF5uahArmjS+rcfDI--

