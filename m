Return-Path: <linux-kernel-owner+w=401wt.eu-S1754499AbZJHG6y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754499AbZJHG6y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 02:58:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754161AbZJHG6y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 02:58:54 -0400
Received: from msr23.hinet.net ([168.95.4.123]:46077 "EHLO msr23.hinet.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751003AbZJHG6x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 02:58:53 -0400
From: Thomas Chou <thomas@wytron.com.tw>
To: linux-input@vger.kernel.org
Cc: Nios2 development list <nios2-dev@sopc.et.ntust.edu.tw>,
       linux-kernel@vger.kernel.org, Thomas Chou <thomas@wytron.com.tw>
Subject: [PATCH] input: New driver for Altera PS/2 controller
Date: Thu,  8 Oct 2009 14:59:12 +0800
Message-Id: <1254985152-32407-1-git-send-email-thomas@wytron.com.tw>
X-Mailer: git-send-email 1.6.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a new SERIO driver to support the Altera University
Program PS/2 controller.

Signed-off-by: Thomas Chou <thomas@wytron.com.tw>
---
 drivers/input/serio/Kconfig      |    9 ++
 drivers/input/serio/Makefile     |    1 +
 drivers/input/serio/altera_ps2.c |  185 ++++++++++++++++++++++++++++++++++++++
 3 files changed, 195 insertions(+), 0 deletions(-)
 create mode 100644 drivers/input/serio/altera_ps2.c

diff --git a/drivers/input/serio/Kconfig b/drivers/input/serio/Kconfig
index c4b3fbd..1e9f9ea 100644
--- a/drivers/input/serio/Kconfig
+++ b/drivers/input/serio/Kconfig
@@ -200,4 +200,13 @@ config SERIO_XILINX_XPS_PS2
 	  To compile this driver as a module, choose M here: the
 	  module will be called xilinx_ps2.
 
+config SERIO_ALTERA_PS2
+	tristate "Altera UP PS/2 controller"
+	depends on EMBEDDED
+	help
+	  Say Y here if you have Altera University Program PS/2 ports.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called altera_ps2.
+
 endif
diff --git a/drivers/input/serio/Makefile b/drivers/input/serio/Makefile
index 9b6c813..bf945f7 100644
--- a/drivers/input/serio/Makefile
+++ b/drivers/input/serio/Makefile
@@ -22,3 +22,4 @@ obj-$(CONFIG_SERIO_MACEPS2)	+= maceps2.o
 obj-$(CONFIG_SERIO_LIBPS2)	+= libps2.o
 obj-$(CONFIG_SERIO_RAW)		+= serio_raw.o
 obj-$(CONFIG_SERIO_XILINX_XPS_PS2)	+= xilinx_ps2.o
+obj-$(CONFIG_SERIO_ALTERA_PS2)	+= altera_ps2.o
diff --git a/drivers/input/serio/altera_ps2.c b/drivers/input/serio/altera_ps2.c
new file mode 100644
index 0000000..6a7ef09
--- /dev/null
+++ b/drivers/input/serio/altera_ps2.c
@@ -0,0 +1,185 @@
+/*
+ * Altera University Program PS2 controller driver
+ *
+ * Copyright (C) 2008 Thomas Chou <thomas@wytron.com.tw>
+ *
+ * Based on sa1111ps2.c, which is:
+ * Copyright (C) 2002 Russell King
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/input.h>
+#include <linux/serio.h>
+#include <linux/interrupt.h>
+#include <linux/platform_device.h>
+#include <linux/io.h>
+
+#define DRV_NAME "altera_ps2"
+
+struct ps2if {
+	struct serio		*io;
+	struct platform_device	*dev;
+	unsigned base;
+	unsigned irq;
+};
+
+/*
+ * Read all bytes waiting in the PS2 port.  There should be
+ * at the most one, but we loop for safety.
+ */
+static irqreturn_t ps2_rxint(int irq, void *dev_id)
+{
+	struct ps2if *ps2if = dev_id;
+	unsigned int status;
+	int handled = IRQ_NONE;
+
+	while ((status = readl(ps2if->base)) & 0xffff0000) {
+		serio_interrupt(ps2if->io, status & 0xff, 0);
+		handled = IRQ_HANDLED;
+	}
+	return handled;
+}
+
+/*
+ * Write a byte to the PS2 port.
+ */
+static int ps2_write(struct serio *io, unsigned char val)
+{
+	struct ps2if *ps2if = io->port_data;
+
+	writel(val, ps2if->base);
+	return 0;
+}
+
+static int ps2_open(struct serio *io)
+{
+	struct ps2if *ps2if = io->port_data;
+	int ret;
+
+	ret = request_irq(ps2if->irq, ps2_rxint, 0,
+			  DRV_NAME, ps2if);
+	if (ret) {
+		printk(KERN_ERR DRV_NAME ": could not allocate IRQ%d: %d\n",
+			ps2if->irq, ret);
+		return ret;
+	}
+	writel(1, ps2if->base + 4); /* enable rx irq */
+	return 0;
+}
+
+static void ps2_close(struct serio *io)
+{
+	struct ps2if *ps2if = io->port_data;
+
+	writel(0, ps2if->base); /* disable rx irq */
+	free_irq(ps2if->irq, ps2if);
+}
+
+/*
+ * Add one device to this driver.
+ */
+static int ps2_probe(struct platform_device *dev)
+{
+	struct ps2if *ps2if;
+	struct serio *serio;
+	struct resource *res;
+	int ret;
+
+	ps2if = kzalloc(sizeof(struct ps2if), GFP_KERNEL);
+	serio = kzalloc(sizeof(struct serio), GFP_KERNEL);
+	if (!ps2if || !serio) {
+		ret = -ENOMEM;
+		goto free;
+	}
+
+	serio->id.type		= SERIO_8042;
+	serio->write		= ps2_write;
+	serio->open		= ps2_open;
+	serio->close		= ps2_close;
+	strlcpy(serio->name, dev_name(&dev->dev), sizeof(serio->name));
+	strlcpy(serio->phys, dev_name(&dev->dev), sizeof(serio->phys));
+	serio->port_data	= ps2if;
+	serio->dev.parent	= &dev->dev;
+	ps2if->io		= serio;
+	ps2if->dev		= dev;
+	platform_set_drvdata(dev, ps2if);
+
+	res = platform_get_resource(dev, IORESOURCE_MEM, 0);
+	if (res == NULL) {
+		ret = -ENOENT;
+		goto free;
+	}
+	ps2if->irq  = platform_get_irq(dev, 0);
+	if (ps2if->irq < 0) {
+		ret = -ENXIO;
+		goto free;
+	}
+	ps2if->base = (unsigned) ioremap(res->start,
+					 (res->end - res->start) + 1);
+	if (!ps2if->base) {
+		ret = -ENOMEM;
+		goto free;
+	}
+	printk(KERN_INFO DRV_NAME ": base %08x irq %d\n",
+	       ps2if->base, ps2if->irq);
+	/* clear fifo */
+	while (readl(ps2if->base) & 0xffff0000)
+		;
+	serio_register_port(ps2if->io);
+	return 0;
+
+ free:
+	platform_set_drvdata(dev, NULL);
+	kfree(ps2if);
+	kfree(serio);
+	return ret;
+}
+
+/*
+ * Remove one device from this driver.
+ */
+static int ps2_remove(struct platform_device *dev)
+{
+	struct ps2if *ps2if = platform_get_drvdata(dev);
+
+	platform_set_drvdata(dev, NULL);
+	serio_unregister_port(ps2if->io);
+	iounmap((void *)ps2if->base);
+	kfree(ps2if);
+
+	return 0;
+}
+
+/*
+ * Our device driver structure
+ */
+static struct platform_driver ps2_driver = {
+	.probe		= ps2_probe,
+	.remove		= ps2_remove,
+	.driver	= {
+		.name	= DRV_NAME,
+	},
+};
+
+static int __init ps2_init(void)
+{
+	return platform_driver_register(&ps2_driver);
+}
+
+static void __exit ps2_exit(void)
+{
+	platform_driver_unregister(&ps2_driver);
+}
+
+module_init(ps2_init);
+module_exit(ps2_exit);
+
+MODULE_DESCRIPTION("Altera University Program PS2 controller driver");
+MODULE_AUTHOR("Thomas Chou <thomas@wytron.com.tw>");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:" DRV_NAME);
-- 
1.6.2.5

