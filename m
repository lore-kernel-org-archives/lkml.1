Return-Path: <linux-kernel-owner+w=401wt.eu-S1753996Ab0AHS6a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753996Ab0AHS6a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 13:58:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753786Ab0AHS63
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 13:58:29 -0500
Received: from ey-out-2122.google.com ([74.125.78.25]:51701 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753964Ab0AHS61 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 13:58:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=COsokK63EbDaaEvopSNFwXXLPkoZSHcm9ohJuyPKen6QHF0lHXSirX4VOApZ5IhTUa
         aJfaVoUoNIA05B45fv7t8IUKwxesZ1wrcJYaKrREsxYK0jS7v4MilMGjt85o4lNW+hlj
         YBQUZnFkrcnhrlW51E35rBtGlZ3agYzF6Lhrg=
Subject: MXC: input: add mxc-keypad driver to support the keypad interface
 present in the mxc application processors family.
From: Alberto Panizzo <maramaopercheseimorto@gmail.com>
To: linux-input@vger.kernel.org
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       linux-arm-kernel-infradead <linux-arm-kernel@lists.infradead.org>,
       Sascha linux-arm <s.hauer@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 08 Jan 2010 19:58:19 +0100
Message-ID: <1262977099.2050.75.camel@climbing-alby>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The MXC family of Application Processors is shipped with a
Keypad Port supported now by this driver.

The peripheral can control up to an 8x8 matrix key pad where
all the scanning procedure is done via software. 

The hardware provide two interrupts: one for a key pressed (KDI)
and one for all key releases (KRI). There is also a simple circuit for glitch 
reduction (said for synchronization) made by two series of 3 D-latches
that stabilize the interrupts sources.
KDI and KRI are fired only if the respective conditions are maintained for 
at last 4 keypad-clock cycle.

Those simple synchronization circuits are used also for multiple
key pressures: between a KDI and a KRI the driver reset the 
sync circuit and re-enable the KDI interrupt so after 3
keypad-clock cycle another KDI is fired making possible to repeat
the matrix scan operation.

This algorithm is done via a threaded management of the keypad
interrupt source and delayed by a proper (and longer) debounce
interval controlled by the platform initialization.
If a key is pressed for a lot of time, the driver relaxes a bit
the timings to not over load the cpu in a long time keypad interaction.

Key configuration is done via platform initialization in 
a standard matrix_keypad manner.

This driver is tested for build in kernel or as a module
and follow the specification of freescale i.MX 25 27 31 35 51
especially it is tested in the mx31pdk board.


Signed-off-by: Alberto Panizzo <maramaopercheseimorto@gmail.com>
---
 arch/arm/plat-mxc/include/mach/mxc_keypad.h |   20 ++
 drivers/input/keyboard/Kconfig              |    9 +
 drivers/input/keyboard/Makefile             |    1 +
 drivers/input/keyboard/mxc_keypad.c         |  485 +++++++++++++++++++++++++++
 4 files changed, 515 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/plat-mxc/include/mach/mxc_keypad.h
 create mode 100644 drivers/input/keyboard/mxc_keypad.c

diff --git a/arch/arm/plat-mxc/include/mach/mxc_keypad.h b/arch/arm/plat-mxc/include/mach/mxc_keypad.h
new file mode 100644
index 0000000..1b05093
--- /dev/null
+++ b/arch/arm/plat-mxc/include/mach/mxc_keypad.h
@@ -0,0 +1,20 @@
+#ifndef __MACH_MXC_KEYPAD_H
+#define __MACH_MXC_KEYPAD_H
+
+#define MAX_MATRIX_KEY_ROWS	(8)
+#define MAX_MATRIX_KEY_COLS	(8)
+#define MATRIX_ROW_SHIFT	(3)
+
+struct mxc_keypad_platform_data {
+
+	/* code map for the matrix keys */
+	unsigned int	matrix_key_rows;
+	unsigned int	matrix_key_cols;
+	unsigned int	*matrix_key_map;
+	int		matrix_key_map_size;
+
+	/* key debounce interval */
+	unsigned int	debounce_ms;
+};
+
+#endif /* __MACH_MXC_KEYPAD_H */
diff --git a/drivers/input/keyboard/Kconfig b/drivers/input/keyboard/Kconfig
index ee98b1b..eff32fe 100644
--- a/drivers/input/keyboard/Kconfig
+++ b/drivers/input/keyboard/Kconfig
@@ -282,6 +282,15 @@ config KEYBOARD_MAX7359
 	  To compile this driver as a module, choose M here: the
 	  module will be called max7359_keypad.
 
+config KEYBOARD_MXC
+	tristate "MXC keypad support"
+	depends on ARCH_MXC
+	help
+	  Enable support for MXC keypad port.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called mxc_keypad.
+
 config KEYBOARD_NEWTON
 	tristate "Newton keyboard"
 	select SERIO
diff --git a/drivers/input/keyboard/Makefile b/drivers/input/keyboard/Makefile
index babad5e..9c7133a 100644
--- a/drivers/input/keyboard/Makefile
+++ b/drivers/input/keyboard/Makefile
@@ -23,6 +23,7 @@ obj-$(CONFIG_KEYBOARD_LOCOMO)		+= locomokbd.o
 obj-$(CONFIG_KEYBOARD_MAPLE)		+= maple_keyb.o
 obj-$(CONFIG_KEYBOARD_MATRIX)		+= matrix_keypad.o
 obj-$(CONFIG_KEYBOARD_MAX7359)		+= max7359_keypad.o
+obj-$(CONFIG_KEYBOARD_MXC)		+= mxc_keypad.o
 obj-$(CONFIG_KEYBOARD_NEWTON)		+= newtonkbd.o
 obj-$(CONFIG_KEYBOARD_OMAP)		+= omap-keypad.o
 obj-$(CONFIG_KEYBOARD_OPENCORES)	+= opencores-kbd.o
diff --git a/drivers/input/keyboard/mxc_keypad.c b/drivers/input/keyboard/mxc_keypad.c
new file mode 100644
index 0000000..4acd311
--- /dev/null
+++ b/drivers/input/keyboard/mxc_keypad.c
@@ -0,0 +1,485 @@
+/*
+ * linux/drivers/input/keyboard/mxc_keypad.c
+ *
+ * Driver for the MXC keypad port.
+ * Copyright (C) 2009 Alberto Panizzo <maramaopercheseimorto@gmail.com>
+ *  based on Rodolfo Giometti & others work in pxa27x_keypad.c
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * >>Power management need to be implemented<<.
+ */
+
+#include <linux/clk.h>
+#include <linux/delay.h>
+#include <linux/device.h>
+#include <linux/err.h>
+#include <linux/init.h>
+#include <linux/input.h>
+#include <linux/input/matrix_keypad.h>
+#include <linux/interrupt.h>
+#include <linux/io.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+
+#include <mach/mxc_keypad.h>
+
+/*
+ * Keypad Controller registers (halfword)
+ */
+#define KPCR		0x00 /* Keypad Control Register */
+
+#define KPSR		0x02 /* Keypad Status Register */
+#define KBD_STAT_KPKD	(0x1 << 0) /* Key Press Interrupt Status bit */
+#define KBD_STAT_KPKR	(0x1 << 1) /* Key Release Interrupt Status bit */
+#define KBD_STAT_KDSC	(0x1 << 2) /* Key Depress Synch Chain Status bit */
+#define KBD_STAT_KRSS	(0x1 << 3) /* Key Release Synch Status bit */
+#define KBD_STAT_KDIE	(0x1 << 8) /* Key Depress Interrupt Enable Status bit */
+#define KBD_STAT_KRIE	(0x1 << 9) /* Key Release Interrupt Enable */
+#define KBD_STAT_KPPEN	(0x1 << 10) /* Keypad Clock Enable */
+
+#define KDDR		0x04 /* Keypad Data Direction Register */
+#define KPDR		0x06 /* Keypad Data Register */
+
+#define keypad_readw(off)	__raw_readw(keypad->mmio_base + (off))
+#define keypad_writew(off, v)	__raw_writew((v), keypad->mmio_base + (off))
+
+#define MAX_MATRIX_KEY_NUM	(MAX_MATRIX_KEY_ROWS * MAX_MATRIX_KEY_COLS)
+
+struct mxc_keypad {
+	struct mxc_keypad_platform_data *pdata;
+
+	struct clk *clk;
+	struct input_dev *input_dev;
+	void __iomem *mmio_base;
+
+	int			irq;
+
+#define MXC_IRQ_DEPRESS		1
+#define MXC_IRQ_RELEASE		2
+	unsigned int		irq_type;
+
+	int 			irq_since_last_change;
+
+	unsigned short 		keycodes[MAX_MATRIX_KEY_NUM];
+
+	/* state row bits of each column scan */
+	unsigned short 		matrix_key_state[MAX_MATRIX_KEY_COLS];
+};
+
+static void mxc_keypad_build_keycode(struct mxc_keypad *keypad)
+{
+	struct mxc_keypad_platform_data *pdata = keypad->pdata;
+	struct input_dev *input_dev = keypad->input_dev;
+	unsigned short keycode;
+	int i;
+
+	for (i = 0; i < pdata->matrix_key_map_size; i++) {
+		unsigned int key = pdata->matrix_key_map[i];
+		unsigned int row = KEY_ROW(key);
+		unsigned int col = KEY_COL(key);
+		unsigned int scancode = MATRIX_SCAN_CODE(row, col,
+							 MATRIX_ROW_SHIFT);
+
+		keycode = KEY_VAL(key);
+		keypad->keycodes[scancode] = keycode;
+		__set_bit(keycode, input_dev->keybit);
+	}
+
+	__clear_bit(KEY_RESERVED, input_dev->keybit);
+}
+
+/* Return 0 if no changes are detected in matrix */
+static int mxc_keypad_scan_matrix(struct mxc_keypad *keypad)
+{
+	struct mxc_keypad_platform_data *pdata = keypad->pdata;
+	struct input_dev *input_dev = keypad->input_dev;
+	int row, col, changed = 0;
+	unsigned short new_state[MAX_MATRIX_KEY_COLS];
+	unsigned short reg_val;
+
+	memset(new_state, 0, sizeof(new_state));
+
+	for (col = 0; col < pdata->matrix_key_cols; col++) {
+		/* Discharge keypad capacitance:
+		 * 2. write 1s on column data.
+		 * 3. configure columns as totem-pole to discharge capacitance.
+		 * 4. configure columns as open-drain.*/
+		reg_val = keypad_readw(KPDR);
+		reg_val |= 0xff00;
+		keypad_writew(KPDR, reg_val);
+
+		reg_val = keypad_readw(KPCR);
+		reg_val &= ~(((1 << pdata->matrix_key_cols) - 1) << 8);
+		keypad_writew(KPCR, reg_val);
+
+		udelay(2);
+
+		reg_val = keypad_readw(KPCR);
+		reg_val |= ((1 << pdata->matrix_key_cols) - 1) << 8;
+		keypad_writew(KPCR, reg_val);
+
+		/*
+		 * 5. Write a single column to 0, others to 1.
+		 * 6. Sample row inputs and save data.
+		 * 7. Repeat steps 2 - 6 for remaining columns.
+		 */
+		reg_val = keypad_readw(KPDR);
+		reg_val &= ~(1 << (8 + col));
+		keypad_writew(KPDR, reg_val);
+
+		/* Delay added to avoid propagating the 0 from column to row
+		 * when scanning. */
+		udelay(5);
+
+		/* 1s in state detect a key pressure */
+		new_state[col] = (~keypad_readw(KPDR)) & 0x00ff;
+	}
+
+	/* Test the state changes */
+	for (col = 0; col < pdata->matrix_key_cols; col++) {
+		unsigned short bits_changed;
+		int code;
+
+		bits_changed = keypad->matrix_key_state[col] ^ new_state[col];
+		if (bits_changed == 0)
+			continue;
+
+		changed = 1;
+		for (row = 0; row < pdata->matrix_key_rows; row++) {
+			if ((bits_changed & (1 << row)) == 0)
+				continue;
+
+			code = MATRIX_SCAN_CODE(row, col, MATRIX_ROW_SHIFT);
+			input_event(input_dev, EV_MSC, MSC_SCAN, code);
+			input_report_key(input_dev, keypad->keycodes[code],
+					 new_state[col] & (1 << row));
+			dev_dbg(&input_dev->dev, "Event code: %d, val: %d",
+					keypad->keycodes[code],
+					new_state[col] & (1 << row));
+		}
+	}
+	input_sync(input_dev);
+	memcpy(keypad->matrix_key_state, new_state, sizeof(new_state));
+
+	/* Return in standby mode:
+	 * 9. write 0s to columns */
+	reg_val = keypad_readw(KPDR);
+	reg_val &= 0x00ff;
+	keypad_writew(KPDR, reg_val);
+
+	return changed;
+}
+
+static irqreturn_t mxc_keypad_irq_handler_thread(int irq, void *dev_id)
+{
+	struct mxc_keypad *keypad = dev_id;
+	struct mxc_keypad_platform_data *pdata = keypad->pdata;
+	struct input_dev *idev = keypad->input_dev;
+	unsigned short reg_val;
+
+	dev_dbg(&idev->dev, "Handling Interrupt of type %x\n",
+						keypad->irq_type);
+
+	/* Wait till debounce */
+	msleep(pdata->debounce_ms);
+
+	/* Do the scan routine and Keep track for how many time we got
+	 * interrupt that make no change */
+	if (mxc_keypad_scan_matrix(keypad))
+		keypad->irq_since_last_change = 0;
+	else
+		keypad->irq_since_last_change++;
+
+	/* If the key is pressed since too many time, relax the update period */
+	if (keypad->irq_since_last_change > 2)
+		msleep(100);
+
+	/* 10. Clear KPKD and KPKR status bits
+	 *     Set the KPKR sync chain and clear the KPKD sync chain */
+	reg_val = keypad_readw(KPSR);
+	reg_val |= KBD_STAT_KPKD | KBD_STAT_KPKR |
+		   KBD_STAT_KDSC | KBD_STAT_KRSS;
+	keypad_writew(KPSR, reg_val);
+
+	/* Re enable interrupts and clear sync reset bits.
+	 * Next KDI is used for detect multiple pressures. */
+	reg_val = keypad_readw(KPSR);
+	reg_val &= ~(KBD_STAT_KDSC | KBD_STAT_KRSS);
+	keypad_writew(KPSR, reg_val);
+
+	reg_val |= KBD_STAT_KDIE | KBD_STAT_KRIE;
+	if (keypad->irq_type == MXC_IRQ_RELEASE)
+		reg_val &= ~KBD_STAT_KRIE;
+	keypad_writew(KPSR, reg_val);
+
+	return IRQ_HANDLED;
+}
+static irqreturn_t mxc_keypad_irq_handler(int irq, void *dev_id)
+{
+	struct mxc_keypad *keypad = dev_id;
+	unsigned short reg_val;
+
+	/* Disable every interrupt */
+	reg_val = keypad_readw(KPSR);
+	reg_val &= ~(KBD_STAT_KRIE | KBD_STAT_KDIE);
+	keypad_writew(KPSR, reg_val);
+
+	keypad->irq_type = reg_val & KBD_STAT_KPKD ?
+			   MXC_IRQ_DEPRESS : MXC_IRQ_RELEASE;
+
+	return IRQ_WAKE_THREAD;
+}
+
+static void mxc_keypad_config(struct mxc_keypad *keypad)
+{
+	struct mxc_keypad_platform_data *pdata = keypad->pdata;
+	unsigned short reg_val;
+
+	/* Enable number of rows in keypad (KPCR[7:0])
+	 * Configure keypad columns as open-drain (KPCR[15:8])
+	 */
+	reg_val = keypad_readw(KPCR);
+	reg_val |= (1 << pdata->matrix_key_rows) - 1;		/* LSB */
+	reg_val |= ((1 << pdata->matrix_key_cols) - 1) << 8;	/* MSB */
+	keypad_writew(KPCR, reg_val);
+
+	/* Write 0's to KPDR[15:8] (Colums)*/
+	reg_val = keypad_readw(KPDR);
+	reg_val &= 0x00ff;
+	keypad_writew(KPDR, reg_val);
+
+	/* Configure columns as output, rows as input (KDDR[15:0]) */
+	reg_val = keypad_readw(KDDR);
+	reg_val |= 0xff00;
+	reg_val &= 0xff00;
+	keypad_writew(KDDR, reg_val);
+
+	/* Clear Key Depress and Key Release status bit.
+	 * Clear synchronizer chain.
+	 * */
+	reg_val = keypad_readw(KPSR);
+	reg_val |= KBD_STAT_KPKR | KBD_STAT_KPKD |
+		   KBD_STAT_KDSC | KBD_STAT_KRSS;
+	keypad_writew(KPSR, reg_val);
+
+	/* Set the KDIE control bit, and clear the KRIE control bit
+	 * (avoid false release events). */
+	reg_val |= KBD_STAT_KDIE;
+	reg_val &= ~KBD_STAT_KRIE;
+	keypad_writew(KPSR, reg_val);
+}
+
+static void mxc_keypad_inhibit(struct mxc_keypad *keypad)
+{
+	unsigned short reg_val;
+
+	/* Colums as open drain and disable rows */
+	keypad_writew(KPCR, 0xff00);
+
+	/* Clear the KPKD status flag and synchronizer chain.
+	 * Clear KDIE control bit and KRIE control bit.
+	 */
+	reg_val = keypad_readw(KPSR);
+	reg_val |= KBD_STAT_KPKD | KBD_STAT_KDSC;
+	reg_val &= ~(KBD_STAT_KRIE | KBD_STAT_KDIE);
+	keypad_writew(KPSR, reg_val);
+}
+
+static int mxc_keypad_open(struct input_dev *dev)
+{
+	struct mxc_keypad *keypad = input_get_drvdata(dev);
+	struct mxc_keypad_platform_data *pdata = keypad->pdata;
+
+	dev_dbg(&dev->dev, "%s\n", __func__);
+
+	/* Enable unit clock */
+	clk_enable(keypad->clk);
+	mxc_keypad_config(keypad);
+
+	/* Sanity control, not all the rows must be to 0s now. */
+	if ((keypad_readw(KPDR) & ((1 << pdata->matrix_key_rows) - 1)) == 0) {
+		dev_err(&dev->dev, "Too much keys pressed for now. "
+				"Control pins initialisation.\n");
+		goto open_err;
+	}
+
+	return 0;
+
+open_err:
+	mxc_keypad_inhibit(keypad);
+	return -EIO;
+}
+
+static void mxc_keypad_close(struct input_dev *dev)
+{
+	struct mxc_keypad *keypad = input_get_drvdata(dev);
+
+	mxc_keypad_inhibit(keypad);
+
+	/* Disable clock unit */
+	clk_disable(keypad->clk);
+}
+
+static int __devinit mxc_keypad_probe(struct platform_device *pdev)
+{
+	struct mxc_keypad_platform_data *pdata = pdev->dev.platform_data;
+	struct mxc_keypad *keypad;
+	struct input_dev *input_dev;
+	struct resource *res;
+	int irq, error;
+
+	if (pdata == NULL) {
+		dev_err(&pdev->dev, "no platform data defined\n");
+		return -EINVAL;
+	}
+
+	irq = platform_get_irq(pdev, 0);
+	if (irq < 0) {
+		dev_err(&pdev->dev, "failed to get keypad irq\n");
+		return -ENXIO;
+	}
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (res == NULL) {
+		dev_err(&pdev->dev, "failed to get I/O memory\n");
+		return -ENXIO;
+	}
+
+	keypad = kzalloc(sizeof(struct mxc_keypad), GFP_KERNEL);
+	input_dev = input_allocate_device();
+	if (!keypad || !input_dev) {
+		dev_err(&pdev->dev, "failed to allocate memory\n");
+		error = -ENOMEM;
+		goto failed_free;
+	}
+
+	keypad->pdata = pdata;
+	keypad->input_dev = input_dev;
+	keypad->irq = irq;
+
+	res = request_mem_region(res->start, resource_size(res), pdev->name);
+	if (res == NULL) {
+		dev_err(&pdev->dev, "failed to request I/O memory\n");
+		error = -EBUSY;
+		goto failed_free;
+	}
+
+	keypad->mmio_base = ioremap(res->start, resource_size(res));
+	if (keypad->mmio_base == NULL) {
+		dev_err(&pdev->dev, "failed to remap I/O memory\n");
+		error = -ENXIO;
+		goto failed_free_mem;
+	}
+
+	keypad->clk = clk_get(NULL, "kpp");
+	if (IS_ERR(keypad->clk)) {
+		dev_err(&pdev->dev, "failed to get keypad clock\n");
+		error = PTR_ERR(keypad->clk);
+		goto failed_free_io;
+	}
+
+	input_dev->name = pdev->name;
+	input_dev->id.bustype = BUS_HOST;
+	input_dev->open = mxc_keypad_open;
+	input_dev->close = mxc_keypad_close;
+	input_dev->dev.parent = &pdev->dev;
+
+	input_dev->keycode = keypad->keycodes;
+	input_dev->keycodesize = sizeof(keypad->keycodes[0]);
+	input_dev->keycodemax = ARRAY_SIZE(keypad->keycodes);
+
+	input_set_drvdata(input_dev, keypad);
+
+	input_dev->evbit[0] = BIT_MASK(EV_KEY) | BIT_MASK(EV_REP);
+	input_set_capability(input_dev, EV_MSC, MSC_SCAN);
+
+	mxc_keypad_build_keycode(keypad);
+
+	error = request_threaded_irq(irq, mxc_keypad_irq_handler,
+			mxc_keypad_irq_handler_thread, IRQF_DISABLED,
+			pdev->name, keypad);
+	if (error) {
+		dev_err(&pdev->dev, "failed to request IRQ\n");
+		goto failed_put_clk;
+	}
+
+	/* Register the input device */
+	error = input_register_device(input_dev);
+	if (error) {
+		dev_err(&pdev->dev, "failed to register input device\n");
+		goto failed_free_irq;
+	}
+
+	platform_set_drvdata(pdev, keypad);
+	device_init_wakeup(&pdev->dev, 1);
+
+	dev_info(&pdev->dev, "device probed.\n");
+
+	return 0;
+
+failed_free_irq:
+	free_irq(irq, pdev);
+failed_put_clk:
+	clk_put(keypad->clk);
+failed_free_io:
+	iounmap(keypad->mmio_base);
+failed_free_mem:
+	release_mem_region(res->start, resource_size(res));
+failed_free:
+	input_free_device(input_dev);
+	kfree(keypad);
+	return error;
+}
+
+static int __devexit mxc_keypad_remove(struct platform_device *pdev)
+{
+	struct mxc_keypad *keypad = platform_get_drvdata(pdev);
+	struct resource *res;
+
+	free_irq(keypad->irq, keypad);
+	clk_put(keypad->clk);
+
+	input_unregister_device(keypad->input_dev);
+	input_free_device(keypad->input_dev);
+
+	iounmap(keypad->mmio_base);
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	release_mem_region(res->start, resource_size(res));
+
+	platform_set_drvdata(pdev, NULL);
+	kfree(keypad);
+
+	return 0;
+}
+
+static struct platform_driver mxc_keypad_driver = {
+	.driver		= {
+		.name	= "mxc-keypad",
+		.owner	= THIS_MODULE,
+	},
+	.probe		= mxc_keypad_probe,
+	.remove		= __devexit_p(mxc_keypad_remove),
+};
+
+static int __init mxc_keypad_init(void)
+{
+	return platform_driver_register(&mxc_keypad_driver);
+}
+
+static void __exit mxc_keypad_exit(void)
+{
+	platform_driver_unregister(&mxc_keypad_driver);
+}
+
+module_init(mxc_keypad_init);
+module_exit(mxc_keypad_exit);
+
+MODULE_AUTHOR("Alberto Panizzo <maramaopercheseimorto@gmail.com>");
+MODULE_DESCRIPTION("MXC Keypad Port Driver");
+MODULE_LICENSE("GPL v2");
+MODULE_ALIAS("platform:mxc-keypad");
-- 
1.6.3.3



