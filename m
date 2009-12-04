Return-Path: <linux-kernel-owner+w=401wt.eu-S1755876AbZLDCrR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755876AbZLDCrR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 21:47:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755834AbZLDCrP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 21:47:15 -0500
Received: from fg-out-1718.google.com ([72.14.220.159]:20159 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755691AbZLDCrK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 21:47:10 -0500
From: Amit Kucheria <amit.kucheria@canonical.com>
To: List Linux Kernel <linux-kernel@vger.kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, s.hauer@pengutronix.de,
       valentin.longchamp@epfl.ch, daniel@caiaq.de, grant.likely@secretlab.ca,
       Dinh.Nguyen@freescale.com, r.herring@freescale.com
Subject: [RFC][PATCH 01/10] arm: mxc: New interrupt controller (TZIC) for i.MX5 family
Date: Fri,  4 Dec 2009 04:47:01 +0200
Message-Id: <e99e70e2a619693064130a747b6ee3a93273337b.1259893118.git.amit.kucheria@canonical.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <cover.1259893118.git.amit.kucheria@canonical.com>
References: <cover.1259893118.git.amit.kucheria@canonical.com>
In-Reply-To: <cover.1259893118.git.amit.kucheria@canonical.com>
References: <cover.1259893118.git.amit.kucheria@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Freescale i.MX51 processor uses a different interrupt controller. Add the
driver and fix the Makefile to account for it.

Signed-off-by: Amit Kucheria <amit.kucheria@canonical.com>
---
 arch/arm/plat-mxc/Kconfig  |    4 +
 arch/arm/plat-mxc/Makefile |    9 ++-
 arch/arm/plat-mxc/tzic.c   |  180 ++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 192 insertions(+), 1 deletions(-)
 create mode 100644 arch/arm/plat-mxc/tzic.c

diff --git a/arch/arm/plat-mxc/Kconfig b/arch/arm/plat-mxc/Kconfig
index ca5c7c2..11bf691 100644
--- a/arch/arm/plat-mxc/Kconfig
+++ b/arch/arm/plat-mxc/Kconfig
@@ -75,4 +75,8 @@ config ARCH_HAS_RNGA
 
 config ARCH_MXC_IOMUX_V3
 	bool
+
+config MXC_TZIC
+	bool
+	depends on ARCH_MXC
 endif
diff --git a/arch/arm/plat-mxc/Makefile b/arch/arm/plat-mxc/Makefile
index e3212c8..5be53ca 100644
--- a/arch/arm/plat-mxc/Makefile
+++ b/arch/arm/plat-mxc/Makefile
@@ -3,7 +3,14 @@
 #
 
 # Common support
-obj-y := irq.o clock.o gpio.o time.o devices.o cpu.o system.o
+obj-y := clock.o gpio.o time.o devices.o cpu.o system.o
+
+# MX51 uses the TZIC interrupt controller, older platforms use AVIC
+ifeq ($(CONFIG_MXC_TZIC),y)
+obj-y += tzic.o
+else
+obj-y += irq.o
+endif
 
 obj-$(CONFIG_ARCH_MX1) += iomux-mx1-mx2.o dma-mx1-mx2.o
 obj-$(CONFIG_ARCH_MX2) += iomux-mx1-mx2.o dma-mx1-mx2.o
diff --git a/arch/arm/plat-mxc/tzic.c b/arch/arm/plat-mxc/tzic.c
new file mode 100644
index 0000000..3af8fc6
--- /dev/null
+++ b/arch/arm/plat-mxc/tzic.c
@@ -0,0 +1,180 @@
+/*
+ * Copyright 2004-2009 Freescale Semiconductor, Inc. All Rights Reserved.
+ *
+ * The code contained herein is licensed under the GNU General Public
+ * License. You may obtain a copy of the GNU General Public License
+ * Version 2 or later at the following locations:
+ *
+ * http://www.opensource.org/licenses/gpl-license.html
+ * http://www.gnu.org/copyleft/gpl.html
+ */
+
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/init.h>
+#include <linux/device.h>
+#include <linux/errno.h>
+#include <mach/hardware.h>
+#include <linux/io.h>
+#include <asm/mach/irq.h>
+
+/*
+ *****************************************
+ * TZIC Registers                        *
+ *****************************************
+ */
+
+#define TZIC_INTCNTL            0x0000	/* control register */
+#define TZIC_INTTYPE            0x0004	/* Controller type register */
+#define TZIC_IMPID              0x0008	/* Distributor Implementer Identification Register */
+#define TZIC_PRIOMASK           0x000C	/* Priority Mask Reg */
+#define TZIC_SYNCCTRL           0x0010	/* Synchronizer Control register */
+#define TZIC_DSMINT             0x0014	/* DSM interrupt Holdoffregister */
+#define TZIC_INTSEC0            0x0080	/* interrupt security register 0 */
+#define TZIC_ENSET0             0x0100	/* Enable Set Register 0 */
+#define TZIC_ENCLEAR0           0x0180	/* Enable Clear Register 0 */
+#define TZIC_SRCSET0            0x0200	/* Source Set Register 0 */
+#define TZIC_SRCCLAR0           0x0280	/* Source Clear Register 0 */
+#define TZIC_PRIORITY0          0x0400	/* Priority Register 0 */
+#define TZIC_PND0               0x0D00	/* Pending Register 0 */
+#define TZIC_HIPND0             0x0D80	/* High Priority Pending Register */
+#define TZIC_WAKEUP0            0x0E00	/* Wakeup Config Register */
+#define TZIC_SWINT              0x0F00	/* Software Interrupt Rigger Register */
+#define TZIC_ID0                0x0FD0	/* Indentification Register 0 */
+
+void __iomem *tzic_base;
+
+/*!
+ * Disable interrupt number "irq" in the TZIC
+ *
+ * @param  irq          interrupt source number
+ */
+static void mxc_mask_irq(unsigned int irq)
+{
+	int index, off;
+
+	index = irq >> 5;
+	off = irq & 0x1F;
+	__raw_writel(1 << off, tzic_base + TZIC_ENCLEAR0 + (index << 2));
+}
+
+/*!
+ * Enable interrupt number "irq" in the TZIC
+ *
+ * @param  irq          interrupt source number
+ */
+static void mxc_unmask_irq(unsigned int irq)
+{
+	int index, off;
+
+	index = irq >> 5;
+	off = irq & 0x1F;
+	__raw_writel(1 << off, tzic_base + TZIC_ENSET0 + (index << 2));
+}
+
+static unsigned int wakeup_intr[4];
+
+/*
+ * Set interrupt number "irq" in the TZIC as a wake-up source.
+ *
+ * @param  irq          interrupt source number
+ * @param  enable       enable as wake-up if equal to non-zero
+ * 			disble as wake-up if equal to zero
+ *
+ * @return       This function returns 0 on success.
+ */
+static int mxc_set_wake_irq(unsigned int irq, unsigned int enable)
+{
+	unsigned int index, off;
+
+	index = irq >> 5;
+	off = irq & 0x1F;
+
+	if (index > 3)
+		return -1;
+
+	if (enable)
+		wakeup_intr[index] |= (1 << off);
+	else
+		wakeup_intr[index] &= ~(1 << off);
+
+	return 0;
+}
+
+static struct irq_chip mxc_tzic_chip = {
+	.name = "MXC_TZIC",
+	.ack = mxc_mask_irq,
+	.mask = mxc_mask_irq,
+	.unmask = mxc_unmask_irq,
+	.set_wake = mxc_set_wake_irq,
+};
+
+/*
+ * This function initializes the TZIC hardware and disables all the
+ * interrupts. It registers the interrupt enable and disable functions
+ * to the kernel for each interrupt source.
+ */
+void __init mxc_init_irq(void __iomem *irqbase)
+{
+	int i;
+
+	tzic_base = irqbase;
+	/* put the TZIC into the reset value with
+	 * all interrupts disabled
+	 */
+	i = __raw_readl(tzic_base + TZIC_INTCNTL);
+
+	__raw_writel(0x80010001, tzic_base + TZIC_INTCNTL);
+	i = __raw_readl(tzic_base + TZIC_INTCNTL);
+	__raw_writel(0x1f, tzic_base + TZIC_PRIOMASK);
+	i = __raw_readl(tzic_base + TZIC_PRIOMASK);
+	__raw_writel(0x02, tzic_base + TZIC_SYNCCTRL);
+	i = __raw_readl(tzic_base + TZIC_SYNCCTRL);
+	for (i = 0; i < 4; i++) {
+		__raw_writel(0xFFFFFFFF, tzic_base + TZIC_INTSEC0 + i * 4);
+	}
+	/* disable all interrupts */
+	for (i = 0; i < 4; i++) {
+		__raw_writel(0xFFFFFFFF, tzic_base + TZIC_ENCLEAR0 + i * 4);
+	}
+
+	/* all IRQ no FIQ Warning :: No selection */
+
+	for (i = 0; i < MXC_INTERNAL_IRQS; i++) {
+		set_irq_chip(i, &mxc_tzic_chip);
+		set_irq_handler(i, handle_level_irq);
+		set_irq_flags(i, IRQF_VALID);
+	}
+
+	printk(KERN_INFO "MXC IRQ initialized\n");
+}
+
+/*
+ * enable wakeup interrupt
+ *
+ * @param is_idle		1 if called in idle loop (enset registers);
+ *				0 to be used when called from low power entry
+ * @return			0 if successful; non-zero otherwise
+ *
+ */
+int tzic_enable_wake(int is_idle)
+{
+	unsigned int i, v;
+
+	__raw_writel(1, tzic_base + TZIC_DSMINT);
+	if (unlikely(__raw_readl(tzic_base + TZIC_DSMINT) == 0))
+		return -EAGAIN;
+
+	if (likely(is_idle)) {
+		for (i = 0; i < 4; i++) {
+			v = __raw_readl(tzic_base + TZIC_ENSET0 + i * 4);
+			__raw_writel(v, tzic_base + TZIC_WAKEUP0 + i * 4);
+		}
+	} else {
+		for (i = 0; i < 4; i++) {
+			v = wakeup_intr[i];
+			__raw_writel(v, tzic_base + TZIC_WAKEUP0 + i * 4);
+		}
+	}
+	return 0;
+}
-- 
1.6.3.3

