Return-Path: <linux-kernel-owner+w=401wt.eu-S1751048AbXBMUf7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751048AbXBMUf7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 15:35:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751060AbXBMUf7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 15:35:59 -0500
Received: from moutng.kundenserver.de ([212.227.126.183]:49852 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751048AbXBMUf5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 15:35:57 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] Open Firmware serial port driver
Date: Tue, 13 Feb 2007 21:35:38 +0100
User-Agent: KMail/1.9.5
Cc: paulus@samba.org, linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       linux-serial@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702132135.39056.arnd@arndb.de>
X-Provags-ID: kundenserver.de abuse@kundenserver.de login:c48f057754fc1b1a557605ab9fa6da41
X-Provags-ID2: V01U2FsdGVkX1+CphPZnGsjBgSm/MDMDNM4SFvqdQ6cKHYje0bnJhwRqrdOWE1jNaqvFSpbCnwcrZz2Pb0lWDBsRKeMLzurvyaKautHiFYQ5+IbAFt4Ifm2zQ==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This can be used for serial ports that are connected to an
OF platform bus but are not autodetected by the lecacy
serial support.
It will automatically take over devices that come from the
legacy serial detection, which usually is only one device.

In some cases, rtas may be set up to use the serial port
in the firmware, which allows easier debugging before probing
the serial ports. In this case, the "used-by-rtas" property
must be set by the firmware. This patch also adds code to the
legacy serial driver to check for this.

Signed-off-by: Arnd Bergmann <arnd.bergmann@de.ibm.com>

---

Who will handle this driver? It is powerpc specific and
hooks into powerpc code at one place, but it's also a 
new driver for the (orphaned) serial layer.

Could either Paul or Andrew merge this, or whoever
else feels responsible?

 arch/powerpc/kernel/legacy_serial.c |   15 +
 drivers/serial/Kconfig              |   10 +
 drivers/serial/Makefile             |    1
 drivers/serial/of_serial.c          |  143 ++++++++++++++++
 4 files changed, 169 insertions(+)

Index: linux-2.6/drivers/serial/Makefile
===================================================================
--- linux-2.6.orig/drivers/serial/Makefile
+++ linux-2.6/drivers/serial/Makefile
@@ -58,3 +58,4 @@ obj-$(CONFIG_SERIAL_SGI_IOC3) += ioc3_se
 obj-$(CONFIG_SERIAL_ATMEL) += atmel_serial.o
 obj-$(CONFIG_SERIAL_UARTLITE) += uartlite.o
 obj-$(CONFIG_SERIAL_NETX) += netx-serial.o
+obj-$(CONFIG_SERIAL_OF_PLATFORM) += of_serial.o
Index: linux-2.6/drivers/serial/of_serial.c
===================================================================
--- /dev/null
+++ linux-2.6/drivers/serial/of_serial.c
@@ -0,0 +1,143 @@
+/*
+ *  Serial Port driver for Open Firmware platform devices
+ *
+ *    Copyright (C) 2006 Arnd Bergmann <arnd@arndb.de>, IBM Corp.
+ *
+ *  This program is free software; you can redistribute it and/or
+ *  modify it under the terms of the GNU General Public License
+ *  as published by the Free Software Foundation; either version
+ *  2 of the License, or (at your option) any later version.
+ *
+ */
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/serial_core.h>
+#include <linux/serial_8250.h>
+
+#include <asm/of_platform.h>
+#include <asm/prom.h>
+
+/*
+ * Fill a struct uart_port for a given device node
+ */
+static int __devinit of_platform_serial_setup(struct of_device *ofdev,
+					int type, struct uart_port *port)
+{
+	struct resource resource;
+	struct device_node *np = ofdev->node;
+	const unsigned int *clk, *spd;
+	int ret;
+
+	memset(port, 0, sizeof *port);
+	spd = get_property(np, "current-speed", NULL);
+	clk = get_property(np, "clock-frequency", NULL);
+	if (!clk) {
+		dev_warn(&ofdev->dev, "no clock-frequency property set\n");
+		return -ENODEV;
+	}
+
+	ret = of_address_to_resource(np, 0, &resource);
+	if (ret) {
+		dev_warn(&ofdev->dev, "invalid address\n");
+		return ret;
+	}
+
+	spin_lock_init(&port->lock);
+	port->mapbase = resource.start;
+	port->irq = irq_of_parse_and_map(np, 0);
+	port->iotype = UPIO_MEM;
+	port->type = type;
+	port->uartclk = *clk;
+	port->flags = UPF_SHARE_IRQ | UPF_BOOT_AUTOCONF | UPF_IOREMAP;
+	port->dev = &ofdev->dev;
+	port->custom_divisor = *clk / (16 * (*spd));
+
+	return 0;
+}
+
+/*
+ * Try to register a serial port
+ */
+static int __devinit of_platform_serial_probe(struct of_device *ofdev,
+						const struct of_device_id *id)
+{
+	struct uart_port port;
+	int port_type;
+	int ret;
+
+	if (of_find_property(ofdev->node, "used-by-rtas", NULL))
+		return -EBUSY;
+
+	port_type = (unsigned long)id->data;
+	ret = of_platform_serial_setup(ofdev, port_type, &port);
+	if (ret)
+		goto out;
+
+	switch (port_type) {
+	case PORT_UNKNOWN:
+		dev_info(&ofdev->dev, "Unknown serial port found, "
+			"attempting to use 8250 driver\n");
+		/* fallthrough */
+	case PORT_8250 ... PORT_MAX_8250:
+		ret = serial8250_register_port(&port);
+		break;
+	default:
+		/* need to add code for these */
+		ret = -ENODEV;
+		break;
+	}
+	if (ret < 0)
+		goto out;
+
+	ofdev->dev.driver_data = (void *)(unsigned long)ret;
+	return 0;
+out:
+	irq_dispose_mapping(port.irq);
+	return ret;
+}
+
+/*
+ * Release a line
+ */
+static int of_platform_serial_remove(struct of_device *ofdev)
+{
+	int line = (unsigned long)ofdev->dev.driver_data;
+	serial8250_unregister_port(line);
+	return 0;
+}
+
+/*
+ * A few common types, add more as needed.
+ */
+static struct of_device_id __devinitdata of_platform_serial_table[] = {
+	{ .type = "serial", .compatible = "ns8250",   .data = (void *)PORT_8250, },
+	{ .type = "serial", .compatible = "ns16450",  .data = (void *)PORT_16450, },
+	{ .type = "serial", .compatible = "ns16550",  .data = (void *)PORT_16550, },
+	{ .type = "serial", .compatible = "ns16750",  .data = (void *)PORT_16750, },
+	{ .type = "serial",			      .data = (void *)PORT_UNKNOWN, },
+	{ /* end of list */ },
+};
+
+static struct of_platform_driver __devinitdata of_platform_serial_driver = {
+	.owner = THIS_MODULE,
+	.name = "of_serial",
+	.probe = of_platform_serial_probe,
+	.remove = of_platform_serial_remove,
+	.match_table = of_platform_serial_table,
+};
+
+static int __init of_platform_serial_init(void)
+{
+	return of_register_platform_driver(&of_platform_serial_driver);
+}
+module_init(of_platform_serial_init);
+
+static void __exit of_platform_serial_exit(void)
+{
+	return of_unregister_platform_driver(&of_platform_serial_driver);
+};
+module_exit(of_platform_serial_exit);
+
+MODULE_AUTHOR("Arnd Bergmann <arnd@arndb.de>");
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("Serial Port driver for Open Firmware platform devices");
Index: linux-2.6/drivers/serial/Kconfig
===================================================================
--- linux-2.6.orig/drivers/serial/Kconfig
+++ linux-2.6/drivers/serial/Kconfig
@@ -999,4 +999,14 @@ config SERIAL_NETX_CONSOLE
 	  If you have enabled the serial port on the Motorola IMX
 	  CPU you can make it the console by answering Y to this option.
 
+config SERIAL_OF_PLATFORM
+	tristate "Serial port on Open Firmware platform bus"
+	depends on PPC_OF
+	depends on SERIAL_8250
+	help
+	  If you have a PowerPC based system that has serial ports
+	  on a platform specific bus, you should enable this option.
+	  Currently, only 8250 compatible ports are supported, but
+	  others can easily be added.
+
 endmenu
Index: linux-2.6/arch/powerpc/kernel/legacy_serial.c
===================================================================
--- linux-2.6.orig/arch/powerpc/kernel/legacy_serial.c
+++ linux-2.6/arch/powerpc/kernel/legacy_serial.c
@@ -124,6 +124,10 @@ static int __init add_legacy_soc_port(st
 	if (get_property(np, "clock-frequency", NULL) == NULL)
 		return -1;
 
+	/* if rtas uses this device, don't try to use it as well */
+	if (get_property(np, "used-by-rtas", NULL) != NULL)
+		return -1;
+
 	/* Get the address */
 	addrp = of_get_address(soc_dev, 0, NULL, NULL);
 	if (addrp == NULL)
@@ -334,6 +338,17 @@ void __init find_legacy_serial_ports(voi
 		of_node_put(tsi);
 	}
 
+	/* First fill our array with opb bus ports */
+	for (np = NULL; (np = of_find_compatible_node(np, "serial", "ns16750")) != NULL;) {
+		struct device_node *opb = of_get_parent(np);
+		if (opb && !strcmp(opb->type, "opb")) {
+			index = add_legacy_soc_port(np, np);
+			if (index >= 0 && np == stdout)
+				legacy_serial_console = index;
+		}
+		of_node_put(opb);
+	}
+
 #ifdef CONFIG_PCI
 	/* Next, try to locate PCI ports */
 	for (np = NULL; (np = of_find_all_nodes(np));) {
