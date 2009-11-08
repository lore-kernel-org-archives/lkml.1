Return-Path: <linux-kernel-owner+w=401wt.eu-S1751057AbZKHGAU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751057AbZKHGAU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 01:00:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750760AbZKHGAT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 01:00:19 -0500
Received: from bhuna.collabora.co.uk ([93.93.128.226]:58571 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750AbZKHGAR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 01:00:17 -0500
Date: Sun, 8 Nov 2009 01:00:09 -0500
From: Andres Salomon <dilinger@collabora.co.uk>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-geode@lists.infradead.org,
       cjb@laptop.org, deepak@laptop.org,
       Jordan Crouse <jordan@cosmicpenguin.net>
Subject: [PATCH 1/6] CS5535: add a generic MFGPT driver
Message-ID: <20091108010009.56d3f37f@mycelium.queued.net>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.18.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Note: these patches are based on the cs5535-gpio patches currently in
the -mm tree.


This is based on the old code on arch/x86/kernel/mfgpt_32.c, except it's not
x86 specific, it's modular, and it makes use of a PCI BAR rather than a
random MSR.  Currently module unloading is not supported; it's uncertain
whether or not it can be made work with the hardware.

Signed-off-by: Andres Salomon <dilinger@collabora.co.uk>
---
 arch/x86/include/asm/geode.h |   40 -----
 drivers/misc/Kconfig         |   23 +++
 drivers/misc/Makefile        |    1 +
 drivers/misc/cs5535-mfgpt.c  |  370 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/cs5535.h       |   67 ++++++++
 5 files changed, 461 insertions(+), 40 deletions(-)
 create mode 100644 drivers/misc/cs5535-mfgpt.c

diff --git a/arch/x86/include/asm/geode.h b/arch/x86/include/asm/geode.h
index 5716214..547e964 100644
--- a/arch/x86/include/asm/geode.h
+++ b/arch/x86/include/asm/geode.h
@@ -47,16 +47,6 @@ extern int geode_get_dev_base(unsigned int dev);
 
 #define MSR_DIVIL_SOFT_RESET	0x51400017
 
-#define MSR_PIC_YSEL_LOW	0x51400020
-#define MSR_PIC_YSEL_HIGH	0x51400021
-#define MSR_PIC_ZSEL_LOW	0x51400022
-#define MSR_PIC_ZSEL_HIGH	0x51400023
-#define MSR_PIC_IRQM_LPC	0x51400025
-
-#define MSR_MFGPT_IRQ		0x51400028
-#define MSR_MFGPT_NR		0x51400029
-#define MSR_MFGPT_SETUP		0x5140002B
-
 #define MSR_LX_SPARE_MSR	0x80000011	/* DC-specific */
 
 #define MSR_GX_GLD_MSR_CONFIG	0xC0002001
@@ -169,36 +159,6 @@ static inline int geode_has_vsa2(void)
 }
 #endif
 
-/* MFGPTs */
-
-#define MFGPT_MAX_TIMERS	8
-#define MFGPT_TIMER_ANY		(-1)
-
-#define MFGPT_DOMAIN_WORKING	1
-#define MFGPT_DOMAIN_STANDBY	2
-#define MFGPT_DOMAIN_ANY	(MFGPT_DOMAIN_WORKING | MFGPT_DOMAIN_STANDBY)
-
-#define MFGPT_CMP1		0
-#define MFGPT_CMP2		1
-
-#define MFGPT_EVENT_IRQ		0
-#define MFGPT_EVENT_NMI		1
-#define MFGPT_EVENT_RESET	3
-
-#define MFGPT_REG_CMP1		0
-#define MFGPT_REG_CMP2		2
-#define MFGPT_REG_COUNTER	4
-#define MFGPT_REG_SETUP		6
-
-#define MFGPT_SETUP_CNTEN	(1 << 15)
-#define MFGPT_SETUP_CMP2	(1 << 14)
-#define MFGPT_SETUP_CMP1	(1 << 13)
-#define MFGPT_SETUP_SETUP	(1 << 12)
-#define MFGPT_SETUP_STOPEN	(1 << 11)
-#define MFGPT_SETUP_EXTEN	(1 << 10)
-#define MFGPT_SETUP_REVEN	(1 << 5)
-#define MFGPT_SETUP_CLKSEL	(1 << 4)
-
 static inline void geode_mfgpt_write(int timer, u16 reg, u16 value)
 {
 	u32 base = geode_get_dev_base(GEODE_DEV_MFGPT);
diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
index df1f86b..e8cc9b2 100644
--- a/drivers/misc/Kconfig
+++ b/drivers/misc/Kconfig
@@ -173,6 +173,29 @@ config SGI_XP
 	  this feature will allow for direct communication between SSIs
 	  based on a network adapter and DMA messaging.
 
+config CS5535_MFGPT
+	tristate "CS5535/CS5536 Geode Multi-Function General Purpose Timer (MFGPT) support"
+	depends on PCI && !MGEODE_LX
+	default n
+	help
+	  This driver provides access to MFGPT functionality for other
+	  drivers that need timers.  MFGPTs are available in the CS5535 and
+	  CS5536 companion chips that are found in AMD Geode and several
+	  other platforms.  They have a better resolution and max interval
+	  than the generic PIT, and are suitable for use as high-res timers.
+	  You probably don't want to enable this manually; other drivers that
+	  make use of it should enable it.
+
+config CS5535_MFGPT_DEFAULT_IRQ
+	int
+	default 7
+	help
+	  MFGPTs on the CS5535 require an interrupt.  The selected IRQ
+	  can be overridden as a module option as well as by driver that
+	  use the cs5535_mfgpt_ API; however, different architectures might
+	  want to use a different IRQ by default.  This is here for
+	  architectures to set as necessary.
+
 config HP_ILO
 	tristate "Channel interface driver for HP iLO/iLO2 processor"
 	depends on PCI
diff --git a/drivers/misc/Makefile b/drivers/misc/Makefile
index f982d2e..df487a2 100644
--- a/drivers/misc/Makefile
+++ b/drivers/misc/Makefile
@@ -17,6 +17,7 @@ obj-$(CONFIG_ENCLOSURE_SERVICES) += enclosure.o
 obj-$(CONFIG_KGDB_TESTS)	+= kgdbts.o
 obj-$(CONFIG_SGI_XP)		+= sgi-xp/
 obj-$(CONFIG_SGI_GRU)		+= sgi-gru/
+obj-$(CONFIG_CS5535_MFGPT)	+= cs5535-mfgpt.o
 obj-$(CONFIG_HP_ILO)		+= hpilo.o
 obj-$(CONFIG_ISL29003)		+= isl29003.o
 obj-$(CONFIG_EP93XX_PWM)	+= ep93xx_pwm.o
diff --git a/drivers/misc/cs5535-mfgpt.c b/drivers/misc/cs5535-mfgpt.c
new file mode 100644
index 0000000..8110460
--- /dev/null
+++ b/drivers/misc/cs5535-mfgpt.c
@@ -0,0 +1,370 @@
+/*
+ * Driver for the CS5535/CS5536 Multi-Function General Purpose Timers (MFGPT)
+ *
+ * Copyright (C) 2006, Advanced Micro Devices, Inc.
+ * Copyright (C) 2007  Andres Salomon <dilinger@debian.org>
+ * Copyright (C) 2009  Andres Salomon <dilinger@collabora.co.uk>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of version 2 of the GNU General Public License
+ * as published by the Free Software Foundation.
+ *
+ * The MFGPTs are documented in AMD Geode CS5536 Companion Device Data Book.
+ */
+
+#include <linux/kernel.h>
+#include <linux/spinlock.h>
+#include <linux/interrupt.h>
+#include <linux/module.h>
+#include <linux/pci.h>
+#include <linux/cs5535.h>
+
+#define DRV_NAME "cs5535-mfgpt"
+#define MFGPT_BAR 2
+
+static int mfgpt_reset_timers;
+module_param_named(mfgptfix, mfgpt_reset_timers, int, 0644);
+MODULE_PARM_DESC(mfgptfix, "Reset the MFGPT timers during init; "
+		"required by some broken BIOSes (ie, TinyBIOS < 0.99).");
+
+struct cs5535_mfgpt_timer {
+	struct cs5535_mfgpt_chip *chip;
+	int nr;
+};
+
+static struct cs5535_mfgpt_chip {
+	DECLARE_BITMAP(avail, MFGPT_MAX_TIMERS);
+	resource_size_t base;
+
+	struct pci_dev *pdev;
+	spinlock_t lock;
+	int initialized;
+} cs5535_mfgpt_chip;
+
+int cs5535_mfgpt_toggle_event(struct cs5535_mfgpt_timer *timer, int cmp,
+		int event, int enable)
+{
+	uint32_t msr, mask, value, dummy;
+	int shift = (cmp == MFGPT_CMP1) ? 0 : 8;
+
+	if (!timer) {
+		WARN_ON(1);
+		return -EIO;
+	}
+
+	/*
+	 * The register maps for these are described in sections 6.17.1.x of
+	 * the AMD Geode CS5536 Companion Device Data Book.
+	 */
+	switch (event) {
+	case MFGPT_EVENT_RESET:
+		/*
+		 * XXX: According to the docs, we cannot reset timers above
+		 * 6; that is, resets for 7 and 8 will be ignored.  Is this
+		 * a problem?   -dilinger
+		 */
+		msr = MSR_MFGPT_NR;
+		mask = 1 << (timer->nr + 24);
+		break;
+
+	case MFGPT_EVENT_NMI:
+		msr = MSR_MFGPT_NR;
+		mask = 1 << (timer->nr + shift);
+		break;
+
+	case MFGPT_EVENT_IRQ:
+		msr = MSR_MFGPT_IRQ;
+		mask = 1 << (timer->nr + shift);
+		break;
+
+	default:
+		return -EIO;
+	}
+
+	rdmsr(msr, value, dummy);
+
+	if (enable)
+		value |= mask;
+	else
+		value &= ~mask;
+
+	wrmsr(msr, value, dummy);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(cs5535_mfgpt_toggle_event);
+
+int cs5535_mfgpt_set_irq(struct cs5535_mfgpt_timer *timer, int cmp, int *irq,
+		int enable)
+{
+	uint32_t zsel, lpc, dummy;
+	int shift;
+
+	if (!timer) {
+		WARN_ON(1);
+		return -EIO;
+	}
+
+	/*
+	 * Unfortunately, MFGPTs come in pairs sharing their IRQ lines. If VSA
+	 * is using the same CMP of the timer's Siamese twin, the IRQ is set to
+	 * 2, and we mustn't use nor change it.
+	 * XXX: Likewise, 2 Linux drivers might clash if the 2nd overwrites the
+	 * IRQ of the 1st. This can only happen if forcing an IRQ, calling this
+	 * with *irq==0 is safe. Currently there _are_ no 2 drivers.
+	 */
+	rdmsr(MSR_PIC_ZSEL_LOW, zsel, dummy);
+	shift = ((cmp == MFGPT_CMP1 ? 0 : 4) + timer->nr % 4) * 4;
+	if (((zsel >> shift) & 0xF) == 2)
+		return -EIO;
+
+	/* Choose IRQ: if none supplied, keep IRQ already set or use default */
+	if (!*irq)
+		*irq = (zsel >> shift) & 0xF;
+	if (!*irq)
+		*irq = CONFIG_CS5535_MFGPT_DEFAULT_IRQ;
+
+	/* Can't use IRQ if it's 0 (=disabled), 2, or routed to LPC */
+	if (*irq < 1 || *irq == 2 || *irq > 15)
+		return -EIO;
+	rdmsr(MSR_PIC_IRQM_LPC, lpc, dummy);
+	if (lpc & (1 << *irq))
+		return -EIO;
+
+	/* All chosen and checked - go for it */
+	if (cs5535_mfgpt_toggle_event(timer, cmp, MFGPT_EVENT_IRQ, enable))
+		return -EIO;
+	if (enable) {
+		zsel = (zsel & ~(0xF << shift)) | (*irq << shift);
+		wrmsr(MSR_PIC_ZSEL_LOW, zsel, dummy);
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(cs5535_mfgpt_set_irq);
+
+struct cs5535_mfgpt_timer *cs5535_mfgpt_alloc_timer(int timer_nr, int domain)
+{
+	struct cs5535_mfgpt_chip *mfgpt = &cs5535_mfgpt_chip;
+	struct cs5535_mfgpt_timer *timer = NULL;
+	unsigned long flags;
+	int max;
+
+	if (!mfgpt->initialized)
+		goto done;
+
+	/* only allocate timers from the working domain if requested */
+	if (domain == MFGPT_DOMAIN_WORKING)
+		max = 6;
+	else
+		max = MFGPT_MAX_TIMERS;
+
+	if (timer_nr >= max) {
+		/* programmer error.  silly programmers! */
+		WARN_ON(1);
+		goto done;
+	}
+
+	spin_lock_irqsave(&mfgpt->lock, flags);
+	if (timer_nr < 0) {
+		unsigned long t;
+
+		/* try to find any available timer */
+		t = find_first_bit(mfgpt->avail, max);
+		/* set timer_nr to -1 if no timers available */
+		timer_nr = t < max ? (int) t : -1;
+	} else {
+		/* check if the requested timer's available */
+		if (test_bit(timer_nr, mfgpt->avail))
+			timer_nr = -1;
+	}
+
+	if (timer_nr >= 0)
+		/* if timer_nr is not -1, it's an available timer */
+		__clear_bit(timer_nr, mfgpt->avail);
+	spin_unlock_irqrestore(&mfgpt->lock, flags);
+
+	if (timer_nr < 0)
+		goto done;
+
+	timer = kmalloc(sizeof(*timer), GFP_KERNEL);
+	if (!timer) {
+		/* aw hell */
+		spin_lock_irqsave(&mfgpt->lock, flags);
+		__set_bit(timer_nr, mfgpt->avail);
+		spin_unlock_irqrestore(&mfgpt->lock, flags);
+		goto done;
+	}
+	timer->chip = mfgpt;
+	timer->nr = timer_nr;
+	dev_info(&mfgpt->pdev->dev, "registered timer %d\n", timer_nr);
+
+done:
+	return timer;
+}
+EXPORT_SYMBOL_GPL(cs5535_mfgpt_alloc_timer);
+
+/*
+ * XXX: This frees the timer memory, but never resets the actual hardware
+ * timer.  The old geode_mfgpt code did this; it would be good to figure
+ * out a way to actually release the hardware timer.  See comments below.
+ */
+void cs5535_mfgpt_free_timer(struct cs5535_mfgpt_timer *timer)
+{
+	kfree(timer);
+}
+EXPORT_SYMBOL_GPL(cs5535_mfgpt_free_timer);
+
+uint16_t cs5535_mfgpt_read(struct cs5535_mfgpt_timer *timer, uint16_t reg)
+{
+	return inw(timer->chip->base + reg + (timer->nr * 8));
+}
+EXPORT_SYMBOL_GPL(cs5535_mfgpt_read);
+
+void cs5535_mfgpt_write(struct cs5535_mfgpt_timer *timer, uint16_t reg,
+		uint16_t value)
+{
+	outw(value, timer->chip->base + reg + (timer->nr * 8));
+}
+EXPORT_SYMBOL_GPL(cs5535_mfgpt_write);
+
+/*
+ * This is a sledgehammer that resets all MFGPT timers. This is required by
+ * some broken BIOSes which leave the system in an unstable state
+ * (TinyBIOS 0.98, for example; fixed in 0.99).  It's uncertain as to
+ * whether or not this secret MSR can be used to release individual timers.
+ * Jordan tells me that he and Mitch once played w/ it, but it's unclear
+ * what the results of that were (and they experienced some instability).
+ */
+static void __init reset_all_timers(void)
+{
+	uint32_t val, dummy;
+
+	/* The following undocumented bit resets the MFGPT timers */
+	val = 0xFF; dummy = 0;
+	wrmsr(MSR_MFGPT_SETUP, val, dummy);
+}
+
+/*
+ * Check whether any MFGPTs are available for the kernel to use.  In most
+ * cases, firmware that uses AMD's VSA code will claim all timers during
+ * bootup; we certainly don't want to take them if they're already in use.
+ * In other cases (such as with VSAless OpenFirmware), the system firmware
+ * leaves timers available for us to use.
+ */
+static int __init scan_timers(struct cs5535_mfgpt_chip *mfgpt)
+{
+	struct cs5535_mfgpt_timer timer = { .chip = mfgpt };
+	unsigned long flags;
+	int timers = 0;
+	uint16_t val;
+	int i;
+
+	/* bios workaround */
+	if (mfgpt_reset_timers)
+		reset_all_timers();
+
+	/* just to be safe, protect this section w/ lock */
+	spin_lock_irqsave(&mfgpt->lock, flags);
+	for (i = 0; i < MFGPT_MAX_TIMERS; i++) {
+		timer.nr = i;
+		val = cs5535_mfgpt_read(&timer, MFGPT_REG_SETUP);
+		if (!(val & MFGPT_SETUP_SETUP)) {
+			__set_bit(i, mfgpt->avail);
+			timers++;
+		}
+	}
+	spin_unlock_irqrestore(&mfgpt->lock, flags);
+
+	return timers;
+}
+
+static int __init cs5535_mfgpt_probe(struct pci_dev *pdev,
+		const struct pci_device_id *pci_id)
+{
+	int err, t;
+
+	/* There are two ways to get the MFGPT base address; one is by
+	 * fetching it from MSR_LBAR_MFGPT, the other is by reading the
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
+	err = pci_request_region(pdev, MFGPT_BAR, DRV_NAME);
+	if (err) {
+		dev_err(&pdev->dev, "can't alloc PCI BAR #%d\n", MFGPT_BAR);
+		goto done;
+	}
+
+	/* set up the driver-specific struct */
+	cs5535_mfgpt_chip.base = pci_resource_start(pdev, MFGPT_BAR);
+	cs5535_mfgpt_chip.pdev = pdev;
+	spin_lock_init(&cs5535_mfgpt_chip.lock);
+
+	dev_info(&pdev->dev, "allocated PCI BAR #%d: base 0x%llx\n", MFGPT_BAR,
+			(unsigned long long) cs5535_mfgpt_chip.base);
+
+	/* detect the available timers */
+	t = scan_timers(&cs5535_mfgpt_chip);
+	dev_info(&pdev->dev, DRV_NAME ": %d MFGPT timers available\n", t);
+	cs5535_mfgpt_chip.initialized = 1;
+	return 0;
+
+done:
+	return err;
+}
+
+static struct pci_device_id cs5535_mfgpt_pci_tbl[] = {
+	{ PCI_DEVICE(PCI_VENDOR_ID_NS, PCI_DEVICE_ID_NS_CS5535_ISA) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_CS5536_ISA) },
+	{ 0, },
+};
+MODULE_DEVICE_TABLE(pci, cs5535_mfgpt_pci_tbl);
+
+/*
+ * Just like with the cs5535-gpio driver, we can't use the standard PCI driver
+ * registration stuff.  It only allows only one driver to bind to each PCI
+ * device, and we want the GPIO and MFGPT drivers to be able to share a PCI
+ * device.  Instead, we manually scan for the PCI device, request a single
+ * region, and keep track of the devices that we're using.
+ */
+
+static int __init cs5535_mfgpt_scan_pci(void)
+{
+	struct pci_dev *pdev;
+	int err = -ENODEV;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(cs5535_mfgpt_pci_tbl); i++) {
+		pdev = pci_get_device(cs5535_mfgpt_pci_tbl[i].vendor,
+				cs5535_mfgpt_pci_tbl[i].device, NULL);
+		if (pdev) {
+			err = cs5535_mfgpt_probe(pdev,
+					&cs5535_mfgpt_pci_tbl[i]);
+			if (err)
+				pci_dev_put(pdev);
+
+			/* we only support a single CS5535/6 southbridge */
+			break;
+		}
+	}
+
+	return err;
+}
+
+static int __init cs5535_mfgpt_init(void)
+{
+	return cs5535_mfgpt_scan_pci();
+}
+
+module_init(cs5535_mfgpt_init);
+
+MODULE_AUTHOR("Andres Salomon <dilinger@collabora.co.uk>");
+MODULE_DESCRIPTION("CS5535/CS5536 MFGPT timer driver");
+MODULE_LICENSE("GPL");
diff --git a/include/linux/cs5535.h b/include/linux/cs5535.h
index cfea689..30ecb04 100644
--- a/include/linux/cs5535.h
+++ b/include/linux/cs5535.h
@@ -18,6 +18,16 @@
 #define MSR_LBAR_ACPI		0x5140000E
 #define MSR_LBAR_PMS		0x5140000F
 
+#define MSR_PIC_YSEL_LOW	0x51400020
+#define MSR_PIC_YSEL_HIGH	0x51400021
+#define MSR_PIC_ZSEL_LOW	0x51400022
+#define MSR_PIC_ZSEL_HIGH	0x51400023
+#define MSR_PIC_IRQM_LPC	0x51400025
+
+#define MSR_MFGPT_IRQ		0x51400028
+#define MSR_MFGPT_NR		0x51400029
+#define MSR_MFGPT_SETUP		0x5140002B
+
 /* resource sizes */
 #define LBAR_GPIO_SIZE		0xFF
 #define LBAR_MFGPT_SIZE		0x40
@@ -55,4 +65,61 @@ void cs5535_gpio_set(unsigned offset, unsigned int reg);
 void cs5535_gpio_clear(unsigned offset, unsigned int reg);
 int cs5535_gpio_isset(unsigned offset, unsigned int reg);
 
+/* MFGPTs */
+
+#define MFGPT_MAX_TIMERS	8
+#define MFGPT_TIMER_ANY		(-1)
+
+#define MFGPT_DOMAIN_WORKING	1
+#define MFGPT_DOMAIN_STANDBY	2
+#define MFGPT_DOMAIN_ANY	(MFGPT_DOMAIN_WORKING | MFGPT_DOMAIN_STANDBY)
+
+#define MFGPT_CMP1		0
+#define MFGPT_CMP2		1
+
+#define MFGPT_EVENT_IRQ		0
+#define MFGPT_EVENT_NMI		1
+#define MFGPT_EVENT_RESET	3
+
+#define MFGPT_REG_CMP1		0
+#define MFGPT_REG_CMP2		2
+#define MFGPT_REG_COUNTER	4
+#define MFGPT_REG_SETUP		6
+
+#define MFGPT_SETUP_CNTEN	(1 << 15)
+#define MFGPT_SETUP_CMP2	(1 << 14)
+#define MFGPT_SETUP_CMP1	(1 << 13)
+#define MFGPT_SETUP_SETUP	(1 << 12)
+#define MFGPT_SETUP_STOPEN	(1 << 11)
+#define MFGPT_SETUP_EXTEN	(1 << 10)
+#define MFGPT_SETUP_REVEN	(1 << 5)
+#define MFGPT_SETUP_CLKSEL	(1 << 4)
+
+struct cs5535_mfgpt_timer;
+
+extern uint16_t cs5535_mfgpt_read(struct cs5535_mfgpt_timer *timer,
+		uint16_t reg);
+extern void cs5535_mfgpt_write(struct cs5535_mfgpt_timer *timer, uint16_t reg,
+		uint16_t value);
+
+extern int cs5535_mfgpt_toggle_event(struct cs5535_mfgpt_timer *timer, int cmp,
+		int event, int enable);
+extern int cs5535_mfgpt_set_irq(struct cs5535_mfgpt_timer *timer, int cmp,
+		int *irq, int enable);
+extern struct cs5535_mfgpt_timer *cs5535_mfgpt_alloc_timer(int timer,
+		int domain);
+extern void cs5535_mfgpt_free_timer(struct cs5535_mfgpt_timer *timer);
+
+static inline int cs5535_mfgpt_setup_irq(struct cs5535_mfgpt_timer *timer,
+		int cmp, int *irq)
+{
+	return cs5535_mfgpt_set_irq(timer, cmp, irq, 1);
+}
+
+static inline int cs5535_mfgpt_release_irq(struct cs5535_mfgpt_timer *timer,
+		int cmp, int *irq)
+{
+	return cs5535_mfgpt_set_irq(timer, cmp, irq, 0);
+}
+
 #endif
-- 
1.5.6.5

