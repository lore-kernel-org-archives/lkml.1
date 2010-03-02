Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754287Ab0CBS36 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 13:29:58 -0500
Received: from mail.dev.rtsoft.ru ([213.79.90.226]:38749 "HELO
	mail.dev.rtsoft.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754360Ab0CBS3s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 13:29:48 -0500
Date: Tue, 2 Mar 2010 21:29:47 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Jeff Garzik <jgarzik@redhat.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 12/12] ahci: Add platform driver
Message-ID: <20100302182947.GL3445@oksana.dev.rtsoft.ru>
References: <20100302182850.GA32057@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20100302182850.GA32057@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This can be used for AHCI-compatible interfaces implemented inside
a System-On-Chip solutions, or AHCI devices connected via localbus.

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
---
 drivers/ata/Kconfig         |    9 ++
 drivers/ata/Makefile        |    1 +
 drivers/ata/ahci_platform.c |  196 +++++++++++++++++++++++++++++++++++++++++++
 drivers/ata/ahci_platform.h |   29 +++++++
 4 files changed, 235 insertions(+), 0 deletions(-)
 create mode 100644 drivers/ata/ahci_platform.c
 create mode 100644 drivers/ata/ahci_platform.h

diff --git a/drivers/ata/Kconfig b/drivers/ata/Kconfig
index 4656782..a81013d 100644
--- a/drivers/ata/Kconfig
+++ b/drivers/ata/Kconfig
@@ -61,6 +61,15 @@ config SATA_AHCI_PCI
 	help
 	  This option enables support for PCI AHCI Serial ATA controllers.
 
+config SATA_AHCI_PLATFORM
+	tristate "Platform AHCI SATA support"
+	depends on SATA_AHCI
+	help
+	  This option enables support for Platform AHCI Serial ATA
+	  controllers.
+
+	  If unsure, say N.
+
 config SATA_SIL24
 	tristate "Silicon Image 3124/3132 SATA support"
 	depends on PCI
diff --git a/drivers/ata/Makefile b/drivers/ata/Makefile
index a220e90..c734c75 100644
--- a/drivers/ata/Makefile
+++ b/drivers/ata/Makefile
@@ -3,6 +3,7 @@ obj-$(CONFIG_ATA)		+= libata.o
 
 obj-$(CONFIG_SATA_AHCI)		+= ahci.o
 obj-$(CONFIG_SATA_AHCI_PCI)	+= ahci_pci.o
+obj-$(CONFIG_SATA_AHCI_PLATFORM)+= ahci_platform.o
 obj-$(CONFIG_SATA_SVW)		+= sata_svw.o
 obj-$(CONFIG_ATA_PIIX)		+= ata_piix.o
 obj-$(CONFIG_SATA_PROMISE)	+= sata_promise.o
diff --git a/drivers/ata/ahci_platform.c b/drivers/ata/ahci_platform.c
new file mode 100644
index 0000000..f3f96d6
--- /dev/null
+++ b/drivers/ata/ahci_platform.c
@@ -0,0 +1,196 @@
+/*
+ * AHCI SATA platform driver
+ *
+ * Copyright 2004-2005  Red Hat, Inc.
+ *   Jeff Garzik <jgarzik@pobox.com>
+ * Copyright 2010  MontaVista Software, LLC.
+ *   Anton Vorontsov <avorontsov@ru.mvista.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2, or (at your option)
+ * any later version.
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/interrupt.h>
+#include <linux/device.h>
+#include <linux/libata.h>
+#include <linux/platform_device.h>
+#include "ahci.h"
+#include "ahci_platform.h"
+
+static int __devinit ahci_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct ahci_platform_data *pdata = pdev->dev.platform_data;
+	struct ata_port_info pi = {
+		.flags		= AHCI_FLAG_COMMON,
+		.pio_mask	= ATA_PIO4,
+		.udma_mask	= ATA_UDMA6,
+		.port_ops	= &ahci_ops,
+	};
+	const struct ata_port_info *ppi[] = { &pi, NULL };
+	struct ahci_host_priv *hpriv;
+	struct ata_host *host;
+	struct resource *res;
+	int n_ports;
+	int i;
+	int rc;
+
+	WARN_ON(ATA_MAX_QUEUE > AHCI_MAX_CMDS);
+
+	if (pdata && pdata->init) {
+		rc = pdata->init(dev);
+		if (rc)
+			return rc;
+	}
+
+	if (pdata && pdata->ata_port_info)
+		pi = *pdata->ata_port_info;
+
+	hpriv = devm_kzalloc(dev, sizeof(*hpriv), GFP_KERNEL);
+	if (!hpriv) {
+		rc = -ENOMEM;
+		goto err0;
+	}
+
+	hpriv->flags |= (unsigned long)pi.private_data;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res) {
+		dev_err(dev, "no mmio space\n");
+		rc = -ENODEV;
+		goto err0;
+	}
+
+	hpriv->mmio = devm_ioremap(dev, res->start, resource_size(res));
+	if (!hpriv->mmio) {
+		dev_err(dev, "can't map %pR\n", res);
+		rc = -ENODEV;
+		goto err0;
+	}
+
+	ahci_save_initial_config(dev, hpriv,
+		pdata ? pdata->force_port_map : 0,
+		pdata ? pdata->mask_port_map  : 0);
+
+	/* prepare host */
+	if (hpriv->cap & HOST_CAP_NCQ)
+		pi.flags |= ATA_FLAG_NCQ;
+
+	if (hpriv->cap & HOST_CAP_PMP)
+		pi.flags |= ATA_FLAG_PMP;
+
+	ahci_set_em_messages(hpriv, &pi);
+
+
+	/* CAP.NP sometimes indicate the index of the last enabled
+	 * port, at other times, that of the last possible port, so
+	 * determining the maximum port number requires looking at
+	 * both CAP.NP and port_map.
+	 */
+	n_ports = max(ahci_nr_ports(hpriv->cap), fls(hpriv->port_map));
+
+	host = ata_host_alloc_pinfo(dev, ppi, n_ports);
+	if (!host) {
+		rc = -ENOMEM;
+		goto err0;
+	}
+
+	host->private_data = hpriv;
+
+	if (!(hpriv->cap & HOST_CAP_SSS) || ahci_ignore_sss)
+		host->flags |= ATA_HOST_PARALLEL_SCAN;
+	else
+		printk(KERN_INFO "ahci: SSS flag set, parallel bus scan disabled\n");
+
+	if (pi.flags & ATA_FLAG_EM)
+		ahci_reset_em(host);
+
+	for (i = 0; i < host->n_ports; i++) {
+		struct ata_port *ap = host->ports[i];
+
+		ata_port_desc(ap, "mmio %pR", res);
+		ata_port_desc(ap, "port 0x%x", 0x100 + ap->port_no * 0x80);
+
+		/* set initial link pm policy */
+		ap->pm_policy = NOT_AVAILABLE;
+
+		/* set enclosure management message type */
+		if (ap->flags & ATA_FLAG_EM)
+			ap->em_message_type = ahci_em_messages;
+
+
+		/* disabled/not-implemented port */
+		if (!(hpriv->port_map & (1 << i)))
+			ap->ops = &ata_dummy_port_ops;
+	}
+
+	rc = ahci_reset_controller(host);
+	if (rc)
+		goto err0;
+
+	ahci_init_controller(host);
+	ahci_print_info(host, "platform");
+
+	res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
+	if (!res) {
+		dev_err(dev, "no irq\n");
+		rc = -EINVAL;
+		goto err0;
+	}
+
+	rc = ata_host_activate(host, res->start, ahci_interrupt, IRQF_SHARED,
+			       &ahci_sht);
+	if (rc)
+		goto err0;
+
+	return 0;
+err0:
+	if (pdata && pdata->exit)
+		pdata->exit(dev);
+	return rc;
+}
+
+static int __devexit ahci_remove(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct ata_host *host = dev_get_drvdata(dev);
+	struct ahci_platform_data *pdata = pdev->dev.platform_data;
+
+	ata_host_detach(host);
+
+	if (pdata && pdata->exit)
+		pdata->exit(dev);
+
+	return 0;
+}
+
+static struct platform_driver ahci_driver = {
+	.probe = ahci_probe,
+	.remove = __devexit_p(ahci_remove),
+	.driver = {
+		.name = DRV_NAME,
+		.owner = THIS_MODULE,
+	},
+};
+
+static int __init ahci_init(void)
+{
+	return platform_driver_register(&ahci_driver);
+}
+module_init(ahci_init);
+
+static void __exit ahci_exit(void)
+{
+	platform_driver_unregister(&ahci_driver);
+}
+module_exit(ahci_exit);
+
+MODULE_DESCRIPTION("AHCI SATA platform driver");
+MODULE_AUTHOR("Anton Vorontsov <avorontsov@ru.mvista.com>");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:" DRV_NAME);
diff --git a/drivers/ata/ahci_platform.h b/drivers/ata/ahci_platform.h
new file mode 100644
index 0000000..f7dd576
--- /dev/null
+++ b/drivers/ata/ahci_platform.h
@@ -0,0 +1,29 @@
+/*
+ * AHCI SATA platform driver
+ *
+ * Copyright 2004-2005  Red Hat, Inc.
+ *   Jeff Garzik <jgarzik@pobox.com>
+ * Copyright 2010  MontaVista Software, LLC.
+ *   Anton Vorontsov <avorontsov@ru.mvista.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2, or (at your option)
+ * any later version.
+ */
+
+#ifndef _AHCI_PLATFORM_H
+#define _AHCI_PLATFORM_H
+
+struct device;
+struct ata_port_info;
+
+struct ahci_platform_data {
+	int (*init)(struct device *dev);
+	void (*exit)(struct device *dev);
+	const struct ata_port_info *ata_port_info;
+	unsigned int force_port_map;
+	unsigned int mask_port_map;
+};
+
+#endif /* _AHCI_PLATFORM_H */
-- 
1.7.0
