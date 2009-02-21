Return-Path: <linux-kernel-owner+w=401wt.eu-S1756216AbZBUDMV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756216AbZBUDMV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 22:12:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753501AbZBUDMN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 22:12:13 -0500
Received: from LUNGE.MIT.EDU ([18.54.1.69]:43596 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753368AbZBUDML (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 22:12:11 -0500
Date: Fri, 20 Feb 2009 22:12:02 -0500
From: Andres Salomon <dilinger@queued.net>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
       Jeremy Katz <katzj@redhat.com>, cjb@laptop.org,
       jayakumar.alsa@gmail.com, Jordan Crouse <jordan@cosmicpenguin.net>,
       linux-geode@lists.infradead.org, perex@perex.cz
Subject: [PATCH 1/2] cs553x-gpio: add AMD CS5535/CS5536 GPIO driver support
Message-ID: <20090220221202.667fbb79@ephemeral>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This creates a CS5535/CS5536 GPIO driver which uses a gpio_chip backend
(allowing GPIO users to use the generic GPIO API if desired) while also
allowing architecture-specific users directly (via the cs553x_gpio_*
functions).

Tested on an OLPC machine.  Some Leemotes also use CS5536 (with a mips
cpu), which is why this is in drivers/gpio rather than arch/x86.  Currently,
it conflicts with older geode GPIO support; once MFGPT support is reworked
to also be more generic, the older geode code will be removed.

Signed-off-by: Andres Salomon <dilinger@debian.org>
---
 arch/x86/include/asm/geode.h |   28 +----
 drivers/gpio/Kconfig         |   10 ++
 drivers/gpio/Makefile        |    1 +
 drivers/gpio/cs553x-gpio.c   |  282 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/cs553x.h       |   58 +++++++++
 5 files changed, 352 insertions(+), 27 deletions(-)
 create mode 100644 drivers/gpio/cs553x-gpio.c
 create mode 100644 include/linux/cs553x.h

diff --git a/arch/x86/include/asm/geode.h b/arch/x86/include/asm/geode.h
index ad3c2ed..0798699 100644
--- a/arch/x86/include/asm/geode.h
+++ b/arch/x86/include/asm/geode.h
@@ -12,6 +12,7 @@
 
 #include <asm/processor.h>
 #include <linux/io.h>
+#include <linux/cs553x.h>
 
 /* Generic southbridge functions */
 
@@ -115,33 +116,6 @@ extern int geode_get_dev_base(unsigned int dev);
 #define VSA_VR_MEM_SIZE		0x0200
 #define AMD_VSA_SIG		0x4132	/* signature is ascii 'VSA2' */
 #define GSW_VSA_SIG		0x534d  /* General Software signature */
-/* GPIO */
-
-#define GPIO_OUTPUT_VAL		0x00
-#define GPIO_OUTPUT_ENABLE	0x04
-#define GPIO_OUTPUT_OPEN_DRAIN	0x08
-#define GPIO_OUTPUT_INVERT	0x0C
-#define GPIO_OUTPUT_AUX1	0x10
-#define GPIO_OUTPUT_AUX2	0x14
-#define GPIO_PULL_UP		0x18
-#define GPIO_PULL_DOWN		0x1C
-#define GPIO_INPUT_ENABLE	0x20
-#define GPIO_INPUT_INVERT	0x24
-#define GPIO_INPUT_FILTER	0x28
-#define GPIO_INPUT_EVENT_COUNT	0x2C
-#define GPIO_READ_BACK		0x30
-#define GPIO_INPUT_AUX1		0x34
-#define GPIO_EVENTS_ENABLE	0x38
-#define GPIO_LOCK_ENABLE	0x3C
-#define GPIO_POSITIVE_EDGE_EN	0x40
-#define GPIO_NEGATIVE_EDGE_EN	0x44
-#define GPIO_POSITIVE_EDGE_STS	0x48
-#define GPIO_NEGATIVE_EDGE_STS	0x4C
-
-#define GPIO_MAP_X		0xE0
-#define GPIO_MAP_Y		0xE4
-#define GPIO_MAP_Z		0xE8
-#define GPIO_MAP_W		0xEC
 
 static inline u32 geode_gpio(unsigned int nr)
 {
diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index 3d25654..797ff45 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -145,6 +145,16 @@ config GPIO_TWL4030
 
 comment "PCI GPIO expanders:"
 
+config GPIO_CS553X
+	tristate "AMD cs5535/cs5536 GPIO support"
+	depends on PCI && !CS5535_GPIO && !MGEODE_LX
+	help
+	  The AMD cs5535 and cs5536 southbridges support 28 GPIO pins that
+	  can be used for quite a number of things.  The cs553x is found on
+	  AMD Geode and Lemote Yeeloong devices.
+
+	  If unsure, say N.
+
 config GPIO_BT8XX
 	tristate "BT8XX GPIO abuser"
 	depends on PCI && VIDEO_BT848=n
diff --git a/drivers/gpio/Makefile b/drivers/gpio/Makefile
index 49ac64e..9690809 100644
--- a/drivers/gpio/Makefile
+++ b/drivers/gpio/Makefile
@@ -11,4 +11,5 @@ obj-$(CONFIG_GPIO_PCA953X)	+= pca953x.o
 obj-$(CONFIG_GPIO_PCF857X)	+= pcf857x.o
 obj-$(CONFIG_GPIO_TWL4030)	+= twl4030-gpio.o
 obj-$(CONFIG_GPIO_XILINX)	+= xilinx_gpio.o
+obj-$(CONFIG_GPIO_CS553X)	+= cs553x-gpio.o
 obj-$(CONFIG_GPIO_BT8XX)	+= bt8xxgpio.o
diff --git a/drivers/gpio/cs553x-gpio.c b/drivers/gpio/cs553x-gpio.c
new file mode 100644
index 0000000..cbb942e
--- /dev/null
+++ b/drivers/gpio/cs553x-gpio.c
@@ -0,0 +1,282 @@
+/*
+ * AMD CS5535/CS5536 GPIO driver
+ * Copyright (C) 2006  Advanced Micro Devices, Inc.
+ * Copyright (C) 2007-2008  Andres Salomon <dilinger@debian.org>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of version 2 of the GNU General Public License
+ * as published by the Free Software Foundation.
+ */
+
+#include <linux/kernel.h>
+#include <linux/spinlock.h>
+#include <linux/module.h>
+#include <linux/pci.h>
+#include <linux/gpio.h>
+#include <linux/io.h>
+#include <linux/cs553x.h>
+
+#define DRV_NAME "cs553x-gpio"
+#define GPIO_BAR 1
+
+static struct cs553x_gpio_chip {
+	struct gpio_chip chip;
+	resource_size_t base;
+
+	struct pci_dev *pdev;
+	spinlock_t lock;
+} cs553x_gpio_chip;
+
+/*
+ * The cs5535/cs5536 GPIOs support a number of extra features not defined
+ * by the gpio_chip API, so these are exported.  For a full list of the
+ * registers, see include/linux/cs553x.h.
+ */
+
+static void __cs553x_gpio_set(struct cs553x_gpio_chip *chip, unsigned offset,
+		unsigned int reg)
+{
+	if (offset < 16)
+		/* low bank register */
+		outl(1 << offset, chip->base + reg);
+	else
+		/* high bank register */
+		outl(1 << (offset - 16), chip->base + 0x80 + reg);
+}
+
+void cs553x_gpio_set(unsigned offset, unsigned int reg)
+{
+	struct cs553x_gpio_chip *chip = &cs553x_gpio_chip;
+	unsigned long flags;
+
+	spin_lock_irqsave(&chip->lock, flags);
+	__cs553x_gpio_set(chip, offset, reg);
+	spin_unlock_irqrestore(&chip->lock, flags);
+}
+EXPORT_SYMBOL_GPL(cs553x_gpio_set);
+
+static void __cs553x_gpio_clear(struct cs553x_gpio_chip *chip, unsigned offset,
+		unsigned int reg)
+{
+	if (offset < 16)
+		/* low bank register */
+		outl(1 << (offset + 16), chip->base + reg);
+	else
+		/* high bank register */
+		outl(1 << offset, chip->base + 0x80 + reg);
+}
+
+void cs553x_gpio_clear(unsigned offset, unsigned int reg)
+{
+	struct cs553x_gpio_chip *chip = &cs553x_gpio_chip;
+	unsigned long flags;
+
+	spin_lock_irqsave(&chip->lock, flags);
+	__cs553x_gpio_clear(chip, offset, reg);
+	spin_unlock_irqrestore(&chip->lock, flags);
+}
+EXPORT_SYMBOL_GPL(cs553x_gpio_clear);
+
+int cs553x_gpio_isset(unsigned offset, unsigned int reg)
+{
+	struct cs553x_gpio_chip *chip = &cs553x_gpio_chip;
+	unsigned long flags;
+	long val;
+
+	spin_lock_irqsave(&chip->lock, flags);
+	if (offset < 16)
+		/* low bank register */
+		val = inl(chip->base + reg);
+	else {
+		/* high bank register */
+		val = inl(chip->base + 0x80 + reg);
+		offset -= 16;
+	}
+	spin_unlock_irqrestore(&chip->lock, flags);
+
+	return (val & (1 << offset)) ? 1 : 0;
+}
+EXPORT_SYMBOL_GPL(cs553x_gpio_isset);
+
+/*
+ * Generic gpio_chip API support.
+ */
+
+static int chip_gpio_get(struct gpio_chip *chip, unsigned offset)
+{
+	return cs553x_gpio_isset(offset, GPIO_OUTPUT_VAL);
+}
+
+static void chip_gpio_set(struct gpio_chip *chip, unsigned offset, int val)
+{
+	if (val)
+		cs553x_gpio_set(offset, GPIO_OUTPUT_VAL);
+	else
+		cs553x_gpio_clear(offset, GPIO_OUTPUT_VAL);
+}
+
+static int chip_direction_input(struct gpio_chip *c, unsigned offset)
+{
+	struct cs553x_gpio_chip *chip = (struct cs553x_gpio_chip *) c;
+	unsigned long flags;
+
+	spin_lock_irqsave(&chip->lock, flags);
+	__cs553x_gpio_set(chip, offset, GPIO_INPUT_ENABLE);
+	spin_unlock_irqrestore(&chip->lock, flags);
+
+	return 0;
+}
+
+static int chip_direction_output(struct gpio_chip *c, unsigned offset, int val)
+{
+	struct cs553x_gpio_chip *chip = (struct cs553x_gpio_chip *) c;
+	unsigned long flags;
+
+	spin_lock_irqsave(&chip->lock, flags);
+
+	__cs553x_gpio_set(chip, offset, GPIO_OUTPUT_ENABLE);
+	if (val)
+		__cs553x_gpio_set(chip, offset, GPIO_OUTPUT_VAL);
+	else
+		__cs553x_gpio_clear(chip, offset, GPIO_OUTPUT_VAL);
+
+	spin_unlock_irqrestore(&chip->lock, flags);
+
+	return 0;
+}
+
+static struct cs553x_gpio_chip cs553x_gpio_chip = {
+	.chip = {
+		.owner = THIS_MODULE,
+		.label = DRV_NAME,
+
+		.base = 0,
+		.ngpio = 28,
+
+		.get = chip_gpio_get,
+		.set = chip_gpio_set,
+
+		.direction_input = chip_direction_input,
+		.direction_output = chip_direction_output,
+	},
+};
+
+static int __init cs553x_gpio_probe(struct pci_dev *pdev,
+		const struct pci_device_id *pci_id)
+{
+	int err;
+
+	/* There are two ways to get the GPIO base address; one is by
+	 * fetching it from MSR_LBAR_GPIO, the other is by reading the
+	 * PCI BAR info.  The latter method is easier (especially across
+	 * different architectures), so we'll stick with that for now.  If
+	 * it turns out to be unreliable in the face of crappy BIOSes, we
+	 * can always go back to using MSRs.. */
+
+	err = pci_enable_device_io(pdev);
+	if (err) {
+		dev_err(&pdev->dev, "can't enable device IO\n");
+		goto done;
+	}
+
+	err = pci_request_region(pdev, GPIO_BAR, DRV_NAME);
+	if (err) {
+		dev_err(&pdev->dev, "can't alloc PCI BAR #%d\n", GPIO_BAR);
+		goto done;
+	}
+
+	/* set up the driver-specific struct */
+	cs553x_gpio_chip.base = pci_resource_start(pdev, GPIO_BAR);
+	cs553x_gpio_chip.pdev = pdev;
+	spin_lock_init(&cs553x_gpio_chip.lock);
+
+	dev_info(&pdev->dev, "allocated PCI BAR #%d: base 0x%x\n", GPIO_BAR,
+			cs553x_gpio_chip.base);
+
+	/* finally, register with the generic GPIO API */
+	err = gpiochip_add(&cs553x_gpio_chip.chip);
+	if (err) {
+		dev_err(&pdev->dev, "failed to register gpio chip\n");
+		goto release_region;
+	}
+
+	printk(KERN_INFO DRV_NAME ": GPIO support successfully loaded.\n");
+	return 0;
+
+release_region:
+	pci_release_region(pdev, GPIO_BAR);
+done:
+	return err;
+}
+
+static void __exit cs553x_gpio_remove(struct pci_dev *pdev)
+{
+	int err;
+
+	err = gpiochip_remove(&cs553x_gpio_chip.chip);
+	if (err) {
+		/* uhh? */
+		dev_err(&pdev->dev, "unable to remove gpio_chip?\n");
+	}
+	pci_release_region(pdev, GPIO_BAR);
+}
+
+static struct pci_device_id cs553x_gpio_pci_tbl[] = {
+	{ PCI_DEVICE(PCI_VENDOR_ID_NS, PCI_DEVICE_ID_NS_CS5535_ISA) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_CS5536_ISA) },
+	{ 0, },
+};
+MODULE_DEVICE_TABLE(pci, cs553x_gpio_pci_tbl);
+
+/*
+ * We can't use the standard PCI driver registration stuff here, since
+ * that allows only one driver to bind to each PCI device (and we want
+ * multiple drivers to be able to bind to the device).  Instead, manually
+ * scan for the PCI device, request a single region, and keep track of the
+ * devices that we're using.
+ */
+
+static int __init cs553x_gpio_scan_pci(void)
+{
+	struct pci_dev *pdev;
+	int err = -ENODEV;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(cs553x_gpio_pci_tbl); i++) {
+		pdev = pci_get_device(cs553x_gpio_pci_tbl[i].vendor,
+				cs553x_gpio_pci_tbl[i].device, NULL);
+		if (pdev) {
+			err = cs553x_gpio_probe(pdev, &cs553x_gpio_pci_tbl[i]);
+			if (err)
+				pci_dev_put(pdev);
+
+			/* we only support a single cs553x southbridge */
+			break;
+		}
+	}
+
+	return err;
+}
+
+static void __exit cs553x_gpio_free_pci(void)
+{
+	cs553x_gpio_remove(cs553x_gpio_chip.pdev);
+	pci_dev_put(cs553x_gpio_chip.pdev);
+}
+
+static int __init cs553x_gpio_init(void)
+{
+	return cs553x_gpio_scan_pci();
+}
+
+static void __exit cs553x_gpio_exit(void)
+{
+	cs553x_gpio_free_pci();
+}
+
+module_init(cs553x_gpio_init);
+module_exit(cs553x_gpio_exit);
+
+MODULE_AUTHOR("Andres Salomon <dilinger@debian.org>");
+MODULE_DESCRIPTION("AMD cs5535/cs5536 GPIO driver");
+MODULE_LICENSE("GPL");
diff --git a/include/linux/cs553x.h b/include/linux/cs553x.h
new file mode 100644
index 0000000..036cfd2
--- /dev/null
+++ b/include/linux/cs553x.h
@@ -0,0 +1,58 @@
+/*
+ * AMD cs5535/cs5536 definitions
+ * Copyright (C) 2006  Advanced Micro Devices, Inc.
+ * Copyright (C) 2009  Andres Salomon <dilinger@debian.org>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of version 2 of the GNU General Public License
+ * as published by the Free Software Foundation.
+ */
+
+#ifndef _CS553X_H
+#define _CS553X_H
+
+/* MSRs */
+#define MSR_LBAR_SMB		0x5140000B
+#define MSR_LBAR_GPIO		0x5140000C
+#define MSR_LBAR_MFGPT		0x5140000D
+#define MSR_LBAR_ACPI		0x5140000E
+#define MSR_LBAR_PMS		0x5140000F
+
+/* resource sizes */
+#define LBAR_GPIO_SIZE		0xFF
+#define LBAR_MFGPT_SIZE		0x40
+#define LBAR_ACPI_SIZE		0x40
+#define LBAR_PMS_SIZE		0x80
+
+/* GPIOs */
+#define GPIO_OUTPUT_VAL		0x00
+#define GPIO_OUTPUT_ENABLE	0x04
+#define GPIO_OUTPUT_OPEN_DRAIN	0x08
+#define GPIO_OUTPUT_INVERT	0x0C
+#define GPIO_OUTPUT_AUX1	0x10
+#define GPIO_OUTPUT_AUX2	0x14
+#define GPIO_PULL_UP		0x18
+#define GPIO_PULL_DOWN		0x1C
+#define GPIO_INPUT_ENABLE	0x20
+#define GPIO_INPUT_INVERT	0x24
+#define GPIO_INPUT_FILTER	0x28
+#define GPIO_INPUT_EVENT_COUNT	0x2C
+#define GPIO_READ_BACK		0x30
+#define GPIO_INPUT_AUX1		0x34
+#define GPIO_EVENTS_ENABLE	0x38
+#define GPIO_LOCK_ENABLE	0x3C
+#define GPIO_POSITIVE_EDGE_EN	0x40
+#define GPIO_NEGATIVE_EDGE_EN	0x44
+#define GPIO_POSITIVE_EDGE_STS	0x48
+#define GPIO_NEGATIVE_EDGE_STS	0x4C
+
+#define GPIO_MAP_X		0xE0
+#define GPIO_MAP_Y		0xE4
+#define GPIO_MAP_Z		0xE8
+#define GPIO_MAP_W		0xEC
+
+void cs553x_gpio_set(unsigned offset, unsigned int reg);
+void cs553x_gpio_clear(unsigned offset, unsigned int reg);
+int cs553x_gpio_isset(unsigned offset, unsigned int reg);
+
+#endif
-- 
1.5.6.5

