Return-Path: <linux-kernel-owner+w=401wt.eu-S1756739AbYJXVLy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756739AbYJXVLy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 17:11:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754201AbYJXVLq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 17:11:46 -0400
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:14773 "EHLO
	WA4EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751985AbYJXVLp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 17:11:45 -0400
X-BigFish: VPS16(zz541L18c1Kc8kzzzzz2dh87il64h)
X-Spam-TCS-SCL: 3:0
X-FB-DOMAIN-IP-MATCH: fail
From: John Linn <john.linn@xilinx.com>
To: linux-kernel@vger.kernel.org
CC: John Linn <john.linn@xilinx.com>, Kiran Sutariya <kirans@xilinx.com>
Subject: [PATCH] [powerpc] GPIO: Adding new Xilinx driver
Date: Fri, 24 Oct 2008 14:11:38 -0700
X-Mailer: git-send-email 1.5.2.1
Message-ID: <20081024211138.38D477F0068@mail95-wa4.bigfish.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver supports the Xilinx XPS GPIO IP core which has the typical
GPIO features.

Signed-off-by: Kiran Sutariya <kirans@xilinx.com>
Signed-off-by: John Linn <john.linn@xilinx.com>
---
 drivers/gpio/Kconfig       |    8 ++
 drivers/gpio/Makefile      |    1 +
 drivers/gpio/xilinx_gpio.c |  240 ++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 249 insertions(+), 0 deletions(-)
 create mode 100644 drivers/gpio/xilinx_gpio.c

diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index 7f2ee27..f6b0da8 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -65,6 +65,14 @@ config GPIO_SYSFS
 
 # put expanders in the right section, in alphabetical order
 
+comment "Memory mapped GPIO expanders:"
+
+config GPIO_XILINX
+	bool "Xilinx GPIO support"
+	depends on OF
+	help
+	  Say yes here to support the Xilinx FPGA GPIO device
+
 comment "I2C GPIO expanders:"
 
 config GPIO_MAX732X
diff --git a/drivers/gpio/Makefile b/drivers/gpio/Makefile
index 6aafdeb..49ac64e 100644
--- a/drivers/gpio/Makefile
+++ b/drivers/gpio/Makefile
@@ -10,4 +10,5 @@ obj-$(CONFIG_GPIO_MCP23S08)	+= mcp23s08.o
 obj-$(CONFIG_GPIO_PCA953X)	+= pca953x.o
 obj-$(CONFIG_GPIO_PCF857X)	+= pcf857x.o
 obj-$(CONFIG_GPIO_TWL4030)	+= twl4030-gpio.o
+obj-$(CONFIG_GPIO_XILINX)	+= xilinx_gpio.o
 obj-$(CONFIG_GPIO_BT8XX)	+= bt8xxgpio.o
diff --git a/drivers/gpio/xilinx_gpio.c b/drivers/gpio/xilinx_gpio.c
new file mode 100644
index 0000000..224d0d5
--- /dev/null
+++ b/drivers/gpio/xilinx_gpio.c
@@ -0,0 +1,240 @@
+/*
+ * Xilinx gpio driver
+ *
+ * Copyright 2008 Xilinx, Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2
+ * as published by the Free Software Foundation.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+
+#include <linux/of_device.h>
+#include <linux/of_platform.h>
+#include <linux/of_gpio.h>
+#include <linux/io.h>
+#include <linux/gpio.h>
+
+/* Register Offset Definitions */
+#define XGPIO_DATA_OFFSET   (0x0)	/* Data register  */
+#define XGPIO_TRI_OFFSET    (0x4)	/* I/O direction register  */
+
+struct xgpio_instance {
+	struct of_mm_gpio_chip mmchip;
+	u32 gpio_state;		/* GPIO state shadow register */
+	u32 gpio_dir;		/* GPIO direction shadow register */
+	spinlock_t gpio_lock;	/* Lock used for synchronization */
+};
+
+/**
+ * xgpio_get - Read the specified signal of the GPIO device.
+ * @gc:     Pointer to gpio_chip device structure.
+ * @gpio:   GPIO signal number.
+ *
+ * This function reads the specified signal of the GPIO device. It returns 0 if
+ * the signal clear, 1 if signal is set or negative value on error.
+ */
+static int xgpio_get(struct gpio_chip *gc, unsigned int gpio)
+{
+	struct of_mm_gpio_chip *mm_gc = to_of_mm_gpio_chip(gc);
+
+	return (in_be32(mm_gc->regs + XGPIO_DATA_OFFSET) >> gpio) & 1;
+}
+
+/**
+ * xgpio_set - Write the specified signal of the GPIO device.
+ * @gc:     Pointer to gpio_chip device structure.
+ * @gpio:   GPIO signal number.
+ * @val:    Value to be written to specified signal.
+ *
+ * This function writes the specified value in to the specified signal of the
+ * GPIO device.
+ */
+static void xgpio_set(struct gpio_chip *gc, unsigned int gpio, int val)
+{
+	unsigned long flags;
+	struct of_mm_gpio_chip *mm_gc = to_of_mm_gpio_chip(gc);
+	struct xgpio_instance *chip =
+	    container_of(mm_gc, struct xgpio_instance, mmchip);
+
+	spin_lock_irqsave(&chip->gpio_lock, flags);
+
+	/* Write to GPIO signal and set its direction to output */
+	if (val)
+		chip->gpio_state |= 1 << gpio;
+	else
+		chip->gpio_state &= ~(1 << gpio);
+	out_be32(mm_gc->regs + XGPIO_DATA_OFFSET, chip->gpio_state);
+
+	spin_unlock_irqrestore(&chip->gpio_lock, flags);
+}
+
+/**
+ * xgpio_dir_in - Set the direction of the specified GPIO signal as input.
+ * @gc:     Pointer to gpio_chip device structure.
+ * @gpio:   GPIO signal number.
+ *
+ * This function sets the direction of specified GPIO signal as input.
+ * It returns 0 if direction of GPIO signals is set as input otherwise it
+ * returns negative error value.
+ */
+static int xgpio_dir_in(struct gpio_chip *gc, unsigned int gpio)
+{
+	unsigned long flags;
+	struct of_mm_gpio_chip *mm_gc = to_of_mm_gpio_chip(gc);
+	struct xgpio_instance *chip =
+	    container_of(mm_gc, struct xgpio_instance, mmchip);
+
+	spin_lock_irqsave(&chip->gpio_lock, flags);
+
+	/* Set the GPIO bit in shadow register and set direction as input */
+	chip->gpio_dir |= (1 << gpio);
+	out_be32(mm_gc->regs + XGPIO_TRI_OFFSET, chip->gpio_dir);
+
+	spin_unlock_irqrestore(&chip->gpio_lock, flags);
+
+	return 0;
+}
+
+/**
+ * xgpio_dir_out - Set the direction of the specified GPIO signal as output.
+ * @gc:     Pointer to gpio_chip device structure.
+ * @gpio:   GPIO signal number.
+ * @val:    Value to be written to specified signal.
+ *
+ * This function sets the direction of specified GPIO signal as output. If all
+ * GPIO signals of GPIO chip is configured as input then it returns
+ * error otherwise it returns 0.
+ */
+static int xgpio_dir_out(struct gpio_chip *gc, unsigned int gpio, int val)
+{
+	unsigned long flags;
+	struct of_mm_gpio_chip *mm_gc = to_of_mm_gpio_chip(gc);
+	struct xgpio_instance *chip =
+	    container_of(mm_gc, struct xgpio_instance, mmchip);
+
+	spin_lock_irqsave(&chip->gpio_lock, flags);
+
+	/* Write state of GPIO signal */
+	if (val)
+		chip->gpio_state |= 1 << gpio;
+	else
+		chip->gpio_state &= ~(1 << gpio);
+	out_be32(mm_gc->regs + XGPIO_DATA_OFFSET, chip->gpio_state);
+
+	/* Clear the GPIO bit in shadow register and set direction as output */
+	chip->gpio_dir &= (~(1 << gpio));
+	out_be32(mm_gc->regs + XGPIO_TRI_OFFSET, chip->gpio_dir);
+
+	spin_unlock_irqrestore(&chip->gpio_lock, flags);
+
+	return 0;
+}
+
+/**
+ * xgpio_of_probe - Probe method for the GPIO device.
+ * @of_dev: pointer to OF device structure.
+ * @match:  pointer to the structure used for matching a device.
+ *
+ * This function probes the GPIO device in the device tree. It initializes the
+ * driver data structure. It returns 0, if the driver is bound to the GPIO
+ * device, or a negative value if there is an error.
+ */
+static int __devinit xgpio_of_probe(struct of_device *ofdev,
+				    const struct of_device_id *match)
+{
+	struct xgpio_instance *chip;
+	struct of_gpio_chip *ofchip;
+	int status = 0;
+	const u32 *tree_info;
+
+	chip = kzalloc(sizeof(*chip), GFP_KERNEL);
+	if (!chip)
+		return -ENOMEM;
+	ofchip = &chip->mmchip.of_gc;
+
+	/* Update GPIO state shadow register with default value */
+	tree_info = of_get_property(ofdev->node, "xlnx,dout-default", NULL);
+	if (tree_info)
+		chip->gpio_state = *tree_info;
+
+	/* Update GPIO direction shadow register with default value */
+	chip->gpio_dir = 0xFFFFFFFF; /* By default, all pins are inputs */
+	tree_info = of_get_property(ofdev->node, "xlnx,tri-default", NULL);
+	if (tree_info)
+		chip->gpio_dir = *tree_info;
+
+	/* Check device node and parent device node for device width */
+	ofchip->gc.ngpio = 32; /* By default assume full GPIO controller */
+	tree_info = of_get_property(ofdev->node, "xlnx,gpio-width", NULL);
+	if (!tree_info)
+		tree_info = of_get_property(ofdev->node->parent,
+					    "xlnx,gpio-width", NULL);
+	if (tree_info)
+		ofchip->gc.ngpio = *tree_info;
+
+	spin_lock_init(&chip->gpio_lock);
+
+	ofchip->gpio_cells = 2;
+	ofchip->gc.direction_input = xgpio_dir_in;
+	ofchip->gc.direction_output = xgpio_dir_out;
+	ofchip->gc.get = xgpio_get;
+	ofchip->gc.set = xgpio_set;
+
+	/* Call the OF gpio helper to setup and register the GPIO device */
+	status = of_mm_gpiochip_add(ofdev->node, &chip->mmchip);
+	if (status) {
+		kfree(chip);
+		dev_err(&ofdev->dev, "Error in probe function error value %d\n",
+			status);
+		return status;
+	}
+
+	/* Finally, write the initial state to the device */
+	out_be32(chip->mmchip.regs + XGPIO_DATA_OFFSET, chip->gpio_state);
+	out_be32(chip->mmchip.regs + XGPIO_TRI_OFFSET, chip->gpio_dir);
+
+	dev_info(&ofdev->dev, "registered Xilinx GPIO controller\n");
+	return 0;
+}
+
+/**
+ * xgpio_of_remove - Remove method for the GPIO device.
+ * @of_dev: pointer to OF device structure.
+ *
+ * This function returns a negative error as we cannot unregister GPIO chips.
+ */
+static int __devexit xgpio_of_remove(struct of_device *ofdev)
+{
+	return -EBUSY;
+}
+
+static struct of_device_id xgpio_of_match[] __devinitdata = {
+	{ .compatible = "xlnx,xps-gpio-1.00.a", },
+	{ /* end of list */ },
+};
+
+MODULE_DEVICE_TABLE(of, xgpio_of_match);
+
+static struct of_platform_driver xgpio_of_driver = {
+	.name = "xilinx_gpio",
+	.match_table = xgpio_of_match,
+	.probe = xgpio_of_probe,
+	.remove = __devexit_p(xgpio_of_remove),
+};
+
+static int __init xgpio_init(void)
+{
+	return of_register_platform_driver(&xgpio_of_driver);
+}
+
+/* Make sure we get initialized before anyone else tries to use us */
+subsys_initcall(xgpio_init);
+/* No exit call at the moment as we cannot unregister of GPIO chips */
+
+MODULE_AUTHOR("Xilinx, Inc.");
+MODULE_DESCRIPTION("Xilinx GPIO driver");
+MODULE_LICENSE("GPL");
-- 
1.5.2.1



This email and any attachments are intended for the sole use of the named recipient(s) and contain(s) confidential information that may be proprietary, privileged or copyrighted under applicable law. If you are not the intended recipient, do not read, copy, or forward this email message or any attachments. Delete this email message and any attachments immediately.


