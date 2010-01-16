Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755649Ab0APRsz (ORCPT <rfc822;list-kernel77@spinics.net>);
	Sat, 16 Jan 2010 12:48:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755263Ab0APRsy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jan 2010 12:48:54 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:45316 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754717Ab0APRsw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jan 2010 12:48:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=GNGnUv59Sl9EzMANlBh4uuLs73l3r8lieWjR48Y4DHf+6VjeSWRXnlePCpQsz6/Xk0
         /wq9zfTpreXfkVv902q/7QDMw8jRDfmO4PRoCwbWAafdjl7HG6jlgRKVEV61yAnyngZ5
         OI7GGFMw2ov5Fap1GXSI5n4pZ+rwFAJ6xmRWo=
Subject: [PATCH v2] input: MXC: add mxc-keypad driver to support the Keypad
 Port present in the mxc application processors family.
From: Alberto Panizzo <maramaopercheseimorto@gmail.com>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: linux-input@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-arm-kernel-infradead <linux-arm-kernel@lists.infradead.org>,
        Sascha linux-arm <s.hauer@pengutronix.de>
In-Reply-To: <BD79186B4FD85F4B8E60E381CAEE190902089738@mi8nycmail19.Mi8.com>
References: <1262977099.2050.75.camel@climbing-alby>
	 <BD79186B4FD85F4B8E60E381CAEE190902089738@mi8nycmail19.Mi8.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 16 Jan 2010 18:48:45 +0100
Message-ID: <1263664125.4350.18.camel@realization>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Version 2 for this driver proposal.
--------------------------------------------------------------------------------
The MXC family of Application Processors is shipped with a Keypad Port 
supported now by this driver.

The peripheral can control up to an 8x8 matrix key pad where all the scanning 
procedure is done via software.

The hardware provide two interrupts: one for a key pressed (KDI) and one for 
all key releases (KRI). There is also a simple circuit for glitch reduction 
(said for synchronization) made by two series of 3 D-latches clocked by the 
keypad-clock that stabilize the interrupts sources.
KDI and KRI are fired only if the respective conditions are maintained for at 
last 4 keypad-clock cycle.

Those simple synchronization circuits are used also for multiple key pressures: 
between a KDI and a KRI the driver reset the sync circuit and re-enable the KDI
interrupt so after 3 keypad-clock cycle another KDI is fired making possible to
repeat the matrix scan operation.

This algorithm is done via a threaded management of the keypad interrupt source
and delayed by a proper (and longer) debounce interval controlled by the 
platform initialization.
If a key is pressed for a lot of time, the driver relaxes the interrupt repeat 
interval to not over load the cpu in a long time keypad interaction.

Changes in v2:
-This driver completely apply to matrix_keypad interface.
-Rearranged remove procedure.
-Automated hardware configuration, based on matrix_keypad_data.
-Removed useless macro.

This driver is tested to build in kernel or as a module and follow the 
specification of Freescale Application processors:
i.MX25 i.MX27 i.MX31 i.MX35 i.MX51 especially tested on i.MX31.

Signed-off-by: Alberto Panizzo <maramaopercheseimorto@gmail.com>
---
 arch/arm/plat-mxc/include/mach/mxc_keypad.h |   18 +
 drivers/input/keyboard/Kconfig              |    9 +
 drivers/input/keyboard/Makefile             |    1 +
 drivers/input/keyboard/mxc_keypad.c         |  496 +++++++++++++++++++++++++++
 4 files changed, 524 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/plat-mxc/include/mach/mxc_keypad.h
 create mode 100644 drivers/input/keyboard/mxc_keypad.c

diff --git a/arch/arm/plat-mxc/include/mach/mxc_keypad.h b/arch/arm/plat-mxc/include/mach/mxc_keypad.h
new file mode 100644
index 0000000..4509103
--- /dev/null
+++ b/arch/arm/plat-mxc/include/mach/mxc_keypad.h
@@ -0,0 +1,18 @@
+#ifndef __MACH_MXC_KEYPAD_H
+#define __MACH_MXC_KEYPAD_H
+
+#include <linux/input/matrix_keypad.h>
+
+#define MAX_MATRIX_KEY_ROWS	(8)
+#define MAX_MATRIX_KEY_COLS	(8)
+#define MATRIX_ROW_SHIFT	(3)
+
+struct mxc_keypad_platform_data {
+
+	const struct matrix_keymap_data *keymap_data;
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
index 0000000..13e8823
--- /dev/null
+++ b/drivers/input/keyboard/mxc_keypad.c
@@ -0,0 +1,494 @@
+/*
+ * linux/drivers/input/keyboard/mxc_keypad.c
+ *
+ * Driver for the MXC keypad port.
+ * Copyright (C) 2009 Alberto Panizzo <maramaopercheseimorto@gmail.com>
+ *  based on Rodolfo Giometti work in pxa27x_keypad.c
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
+#define MXC_IRQ_KDI		1
+#define MXC_IRQ_KRI		2
+	unsigned int		irq_type;
+	int 			irq_since_last_change;
+
+	/* Masks for enabled rows/cols */
+	unsigned short		rows_en_mask;
+	unsigned short		cols_en_mask;
+
+	unsigned short 		keycodes[MAX_MATRIX_KEY_NUM];
+
+	/* state row bits of each column scan */
+	unsigned short 		matrix_key_state[MAX_MATRIX_KEY_COLS];
+};
+
+/* Return 0 if no changes are detected in matrix */
+static int mxc_keypad_scan_matrix(struct mxc_keypad *keypad)
+{
+	struct input_dev *input_dev = keypad->input_dev;
+	int row, col, changed = 0;
+	unsigned short new_state[MAX_MATRIX_KEY_COLS];
+	unsigned short reg_val;
+
+	memset(new_state, 0, sizeof(new_state));
+
+	for (col = 0; col < MAX_MATRIX_KEY_COLS; col++) {
+		if ((keypad->cols_en_mask & (1 << col)) == 0)
+			continue;
+		/* Discharge keypad capacitance:
+		 * 2. write 1s on column data.
+		 * 3. configure columns as totem-pole to discharge capacitance.
+		 * 4. configure columns as open-drain.*/
+		reg_val = readw(keypad->mmio_base + KPDR);
+		reg_val |= 0xff00;
+		writew(reg_val, keypad->mmio_base + KPDR);
+
+		reg_val = readw(keypad->mmio_base + KPCR);
+		reg_val &= ~((keypad->cols_en_mask & 0xff) << 8);
+		writew(reg_val, keypad->mmio_base + KPCR);
+
+		udelay(2);
+
+		reg_val = readw(keypad->mmio_base + KPCR);
+		reg_val |= (keypad->cols_en_mask & 0xff) << 8;
+		writew(reg_val, keypad->mmio_base + KPCR);
+
+		/*
+		 * 5. Write a single column to 0, others to 1.
+		 * 6. Sample row inputs and save data.
+		 * 7. Repeat steps 2 - 6 for remaining columns.
+		 */
+		reg_val = readw(keypad->mmio_base + KPDR);
+		reg_val &= ~(1 << (8 + col));
+		writew(reg_val, keypad->mmio_base + KPDR);
+
+		/* Delay added to avoid propagating the 0 from column to row
+		 * when scanning. */
+		udelay(5);
+
+		/* 1s in state detect a key pressure */
+		new_state[col] = (~readw(keypad->mmio_base + KPDR)) & 0x00ff;
+	}
+
+	/* Test the state changes */
+	for (col = 0; col < MAX_MATRIX_KEY_COLS; col++) {
+		unsigned short bits_changed;
+		int code;
+
+		if ((keypad->cols_en_mask & (1 << col)) == 0)
+			continue;
+
+		bits_changed = keypad->matrix_key_state[col] ^ new_state[col];
+		if (bits_changed == 0)
+			continue;
+
+		changed = 1;
+		for (row = 0; row < MAX_MATRIX_KEY_ROWS; row++) {
+			if ((keypad->rows_en_mask & (1 << row)) == 0)
+				continue;
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
+	reg_val = readw(keypad->mmio_base + KPDR);
+	reg_val &= 0x00ff;
+	writew(reg_val, keypad->mmio_base + KPDR);
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
+	reg_val = readw(keypad->mmio_base + KPSR);
+	reg_val |= KBD_STAT_KPKD | KBD_STAT_KPKR |
+		   KBD_STAT_KDSC | KBD_STAT_KRSS;
+	writew(reg_val, keypad->mmio_base + KPSR);
+
+	/* Re enable interrupts and clear sync reset bits.
+	 * Next KDI is used for detect multiple pressures. */
+	reg_val = readw(keypad->mmio_base + KPSR);
+	reg_val &= ~(KBD_STAT_KDSC | KBD_STAT_KRSS);
+	writew(reg_val, keypad->mmio_base + KPSR);
+
+	reg_val |= KBD_STAT_KDIE | KBD_STAT_KRIE;
+	if (keypad->irq_type == MXC_IRQ_KRI)
+		reg_val &= ~KBD_STAT_KRIE;
+	writew(reg_val, keypad->mmio_base + KPSR);
+
+	return IRQ_HANDLED;
+}
+
+static irqreturn_t mxc_keypad_irq_handler(int irq, void *dev_id)
+{
+	struct mxc_keypad *keypad = dev_id;
+	unsigned short reg_val;
+
+	/* Disable every interrupt */
+	reg_val = readw(keypad->mmio_base + KPSR);
+	reg_val &= ~(KBD_STAT_KRIE | KBD_STAT_KDIE);
+	writew(reg_val, keypad->mmio_base + KPSR);
+
+	keypad->irq_type = reg_val & KBD_STAT_KPKD ?
+			   MXC_IRQ_KDI : MXC_IRQ_KRI;
+
+	return IRQ_WAKE_THREAD;
+}
+
+static void mxc_keypad_config(struct mxc_keypad *keypad)
+{
+	unsigned short reg_val;
+
+	/* Enable number of rows in keypad (KPCR[7:0])
+	 * Configure keypad columns as open-drain (KPCR[15:8])
+	 */
+	reg_val = readw(keypad->mmio_base + KPCR);
+	reg_val |= keypad->rows_en_mask & 0xff;		/* rows */
+	reg_val |= (keypad->cols_en_mask & 0xff) << 8;	/* cols */
+	writew(reg_val, keypad->mmio_base + KPCR);
+
+	/* Write 0's to KPDR[15:8] (Colums)*/
+	reg_val = readw(keypad->mmio_base + KPDR);
+	reg_val &= 0x00ff;
+	writew(reg_val, keypad->mmio_base + KPDR);
+
+	/* Configure columns as output, rows as input (KDDR[15:0]) */
+	reg_val = readw(keypad->mmio_base + KDDR);
+	reg_val |= 0xff00;
+	reg_val &= 0xff00;
+	writew(reg_val, keypad->mmio_base + KDDR);
+
+	/* Clear Key Depress and Key Release status bit.
+	 * Clear synchronizer chain.
+	 * */
+	reg_val = readw(keypad->mmio_base + KPSR);
+	reg_val |= KBD_STAT_KPKR | KBD_STAT_KPKD |
+		   KBD_STAT_KDSC | KBD_STAT_KRSS;
+	writew(reg_val, keypad->mmio_base + KPSR);
+
+	/* Set the KDIE control bit, and clear the KRIE control bit
+	 * (avoid false release events). */
+	reg_val |= KBD_STAT_KDIE;
+	reg_val &= ~KBD_STAT_KRIE;
+	writew(reg_val, keypad->mmio_base + KPSR);
+}
+
+static void mxc_keypad_inhibit(struct mxc_keypad *keypad)
+{
+	unsigned short reg_val;
+
+	/* Colums as open drain and disable rows */
+	writew(0xff00, keypad->mmio_base + KPCR);
+
+	/* Clear the KPKD status flag and synchronizer chain.
+	 * Clear KDIE control bit and KRIE control bit.
+	 */
+	reg_val = readw(keypad->mmio_base + KPSR);
+	reg_val |= KBD_STAT_KPKD | KBD_STAT_KDSC;
+	reg_val &= ~(KBD_STAT_KRIE | KBD_STAT_KDIE);
+	writew(reg_val, keypad->mmio_base + KPSR);
+}
+
+static int mxc_keypad_open(struct input_dev *dev)
+{
+	struct mxc_keypad *keypad = input_get_drvdata(dev);
+
+	dev_dbg(&dev->dev, "%s\n", __func__);
+
+	/* Enable unit clock */
+	clk_enable(keypad->clk);
+	mxc_keypad_config(keypad);
+
+	/* Sanity control, not all the rows must be to 0s now. */
+	if ((readw(keypad->mmio_base + KPDR) & keypad->rows_en_mask) == 0) {
+		dev_err(&dev->dev, "Too much keys pressed for now, "
+				"control pins initialisation\n");
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
+	int irq, error, i;
+	struct matrix_keymap_data *keymap_data;
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
+	res = request_mem_region(res->start, resource_size(res), pdev->name);
+	if (res == NULL) {
+		dev_err(&pdev->dev, "failed to request I/O memory\n");
+		return -EBUSY;
+	}
+
+	input_dev = input_allocate_device();
+	if (!input_dev) {
+		dev_err(&pdev->dev, "failed to allocate the input device\n");
+		error = -ENOMEM;
+		goto failed_rel_mem;
+	}
+
+	keypad = kzalloc(sizeof(struct mxc_keypad), GFP_KERNEL);
+	if (!keypad) {
+		dev_err(&pdev->dev, "not enough memory for driver data\n");
+		error = -ENOMEM;
+		goto failed_free_input;
+	}
+
+	keypad->pdata = pdata;
+	keypad->input_dev = input_dev;
+	keypad->irq = irq;
+
+	keypad->mmio_base = ioremap(res->start, resource_size(res));
+	if (keypad->mmio_base == NULL) {
+		dev_err(&pdev->dev, "failed to remap I/O memory\n");
+		error = -ENXIO;
+		goto failed_free_priv;
+	}
+
+	keypad->clk = clk_get(NULL, "kpp");
+	if (IS_ERR(keypad->clk)) {
+		dev_err(&pdev->dev, "failed to get keypad clock\n");
+		error = PTR_ERR(keypad->clk);
+		goto failed_unmap;
+	}
+
+	input_dev->name = pdev->name;
+	input_dev->id.bustype = BUS_HOST;
+	input_dev->dev.parent = &pdev->dev;
+	input_dev->open = mxc_keypad_open;
+	input_dev->close = mxc_keypad_close;
+	input_dev->evbit[0] = BIT_MASK(EV_KEY) | BIT_MASK(EV_REP);
+
+	/*
+	 * Search for rows and cols enabled
+	 */
+	keymap_data = (struct matrix_keymap_data *) pdata->keymap_data;
+	for (i = 0; i < keymap_data->keymap_size; i++) {
+		keypad->rows_en_mask |= 1 << KEY_ROW(keymap_data->keymap[i]);
+		keypad->cols_en_mask |= 1 << KEY_COL(keymap_data->keymap[i]);
+	}
+
+	if (keypad->rows_en_mask > ((1 << MAX_MATRIX_KEY_ROWS) - 1) ||
+	   keypad->cols_en_mask > ((1 << MAX_MATRIX_KEY_COLS) - 1)) {
+		dev_err(&pdev->dev, "Invalid key data (too rows or colums)\n");
+		error = -EINVAL;
+		goto failed_clock_put;
+	}
+	dev_dbg(&pdev->dev, "enabled rows mask: %x\n", keypad->rows_en_mask);
+	dev_dbg(&pdev->dev, "enabled cols mask: %x\n", keypad->cols_en_mask);
+
+	input_dev->keycode = keypad->keycodes;
+	input_dev->keycodesize = sizeof(keypad->keycodes[0]);
+	input_dev->keycodemax = ARRAY_SIZE(keypad->keycodes);
+
+	matrix_keypad_build_keymap(pdata->keymap_data, MATRIX_ROW_SHIFT,
+				keypad->keycodes, input_dev->keybit);
+
+	input_set_capability(input_dev, EV_MSC, MSC_SCAN);
+	input_set_drvdata(input_dev, keypad);
+
+	error = request_threaded_irq(irq, mxc_keypad_irq_handler,
+			mxc_keypad_irq_handler_thread, IRQF_DISABLED,
+			pdev->name, keypad);
+	if (error) {
+		dev_err(&pdev->dev, "failed to request IRQ\n");
+		goto failed_clock_put;
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
+	dev_info(&pdev->dev, "device probed\n");
+
+	return 0;
+
+failed_free_irq:
+	free_irq(irq, pdev);
+failed_clock_put:
+	clk_put(keypad->clk);
+failed_unmap:
+	iounmap(keypad->mmio_base);
+failed_free_priv:
+	kfree(keypad);
+failed_free_input:
+	input_free_device(input_dev);
+failed_rel_mem:
+	release_mem_region(res->start, resource_size(res));
+	return error;
+}
+
+static int __devexit mxc_keypad_remove(struct platform_device *pdev)
+{
+	struct mxc_keypad *keypad = platform_get_drvdata(pdev);
+	struct resource *res;
+
+	platform_set_drvdata(pdev, NULL);
+
+	free_irq(keypad->irq, keypad);
+	clk_put(keypad->clk);
+
+	iounmap(keypad->mmio_base);
+
+	input_unregister_device(keypad->input_dev);
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	release_mem_region(res->start, resource_size(res));
+
+	kfree(keypad);
+
+	dev_info(&pdev->dev, "device removed\n");
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



