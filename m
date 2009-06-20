Return-Path: <linux-kernel-owner+w=401wt.eu-S1759394AbZFTBSc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759394AbZFTBSc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 21:18:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759295AbZFTBRz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 21:17:55 -0400
Received: from smtp107.biz.mail.mud.yahoo.com ([68.142.200.255]:39066 "HELO
	smtp107.biz.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753252AbZFTBRw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 21:17:52 -0400
X-Yahoo-SMTP: Y9aU0H6swBAqsiryRZEA7xtDWlgllPfq7He2xMk-
X-YMail-OSG: CEhzh3IVM1knTt9LZywKr9PubEq9mmQBLbZcVOBrAxUyIC_R.d89HRFTgrB0nz1.yktVxp4ifX8ibtpPIBySgpSxQC6vUtfJDYRFCdEIm4j5fXLnU7v_mC9Hz_qgmMLPTo2rXe3DJ7zofqhxN0NEV5q3kkvFLCo1pVTPG66BcIgRt_t5d4Qhr6BpLUhBLkwEseitJale3P75yH.IhtvHKXQdg9yQV573F0Gq0VvYTNnPFcsiJbANFFbPkOqRxr5N_OUCZkkDJMwUowgGmxFyN33Hrm9Qw_0rwVKtNQv2wS2vQBl3wn6he0fhv1O8v1CKvQfmOJKpRGrWgMcFa2ezdD1zKXEWWTrvUwuLpR_YPw29b9sAwst2gKY-
X-Yahoo-Newman-Property: ymail-3
From: sfking@fdwdc.com
To: linux-kernel@vger.kernel.org
Cc: uclinux-dev@uclinux.org, linux-m68k@vger.kernel.org, gerg@snapgear.com,
       Steven King <sfking@fdwdc.com>
Subject: [PATCH 01/13] core generic GPIO support for Freescale Coldfire processors.
Date: Fri, 19 Jun 2009 18:11:00 -0700
Message-Id: <1245460272-4329-2-git-send-email-sfking@fdwdc.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1245460272-4329-1-git-send-email-sfking@fdwdc.com>
References: <1245460272-4329-1-git-send-email-sfking@fdwdc.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds the basic infrastructure used by all of the different Coldfire CPUs.

Signed-off-by: Steven King <sfking@fdwdc.com>
---
 arch/m68k/include/asm/gpio.h              |  238 +++++++++++++++++++++++++++++
 arch/m68k/include/asm/mcfgpio.h           |   40 +++++
 arch/m68k/include/asm/pinmux.h            |   30 ++++
 arch/m68knommu/Kconfig                    |    6 +
 arch/m68knommu/platform/coldfire/Makefile |    1 +
 arch/m68knommu/platform/coldfire/gpio.c   |  127 +++++++++++++++
 arch/m68knommu/platform/coldfire/pinmux.c |   28 ++++
 7 files changed, 470 insertions(+), 0 deletions(-)
 create mode 100644 arch/m68k/include/asm/gpio.h
 create mode 100644 arch/m68k/include/asm/mcfgpio.h
 create mode 100644 arch/m68k/include/asm/pinmux.h
 create mode 100644 arch/m68knommu/platform/coldfire/gpio.c
 create mode 100644 arch/m68knommu/platform/coldfire/pinmux.c

diff --git a/arch/m68k/include/asm/gpio.h b/arch/m68k/include/asm/gpio.h
new file mode 100644
index 0000000..283214d
--- /dev/null
+++ b/arch/m68k/include/asm/gpio.h
@@ -0,0 +1,238 @@
+/*
+ * Coldfire generic GPIO support
+ *
+ * (C) Copyright 2009, Steven King <sfking@fdwdc.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 of the License.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+*/
+
+#ifndef coldfire_gpio_h
+#define coldfire_gpio_h
+
+#include <linux/io.h>
+#include <asm-generic/gpio.h>
+#include <asm/coldfire.h>
+#include <asm/mcfsim.h>
+
+/*
+ * The Freescale Coldfire family is quite varied in how they implement GPIO.
+ * Some parts have 8 bit ports, some have 16bit and some have 32bit; some have
+ * only one port, others have multiple ports; some have a single data latch
+ * for both input and output, others have a separate pin data register to read
+ * input; some require a read-modify-write access to change an output, others
+ * have set and clear registers for some of the outputs; Some have all the
+ * GPIOs in a single control area, others have some GPIOs implemented in
+ * different modules.
+ *
+ * This implementation attempts accomodate the differences while presenting
+ * a generic interface that will optimize to as few instructions as possible.
+ */
+#if defined(CONFIG_M5206) || defined(CONFIG_M5206e) || \
+    defined(CONFIG_M520x) || defined(CONFIG_M523x) || \
+    defined(CONFIG_M527x) || defined(CONFIG_M528x) || defined(CONFIG_M532x)
+
+/* These parts have GPIO organized by 8 bit ports */
+
+#define MCFGPIO_PORTTYPE		u8
+#define MCFGPIO_PORTSIZE		8
+#define mcfgpio_read(port)		__raw_readb(port)
+#define mcfgpio_write(data, port)	__raw_writeb(data, port)
+
+#elif defined(CONFIG_M5307) || defined(CONFIG_M5407) || defined(CONFIG_M5272)
+
+/* These parts have GPIO organized by 16 bit ports */
+
+#define MCFGPIO_PORTTYPE		u16
+#define MCFGPIO_PORTSIZE		16
+#define mcfgpio_read(port)		__raw_readw(port)
+#define mcfgpio_write(data, port)	__raw_writew(data, port)
+
+#elif defined(CONFIG_M5249)
+
+/* These parts have GPIO organized by 32 bit ports */
+
+#define MCFGPIO_PORTTYPE		u32
+#define MCFGPIO_PORTSIZE		32
+#define mcfgpio_read(port)		__raw_readl(port)
+#define mcfgpio_write(data, port)	__raw_writel(data, port)
+
+#endif
+
+#define mcfgpio_bit(gpio)		(1 << ((gpio) %  MCFGPIO_PORTSIZE))
+#define mcfgpio_port(gpio)		((gpio) / MCFGPIO_PORTSIZE)
+
+#if defined(CONFIG_M520x) || defined(CONFIG_M523x) || \
+    defined(CONFIG_M527x) || defined(CONFIG_M528x) || defined(CONFIG_M532x)
+/*
+ * These parts have an 'Edge' Port module (external interrupt/GPIO) which uses
+ * read-modify-write to change an output and a GPIO module which has separate
+ * set/clr registers to directly change outputs with a single write access.
+ */
+#if defined(CONFIG_M528x)
+/*
+ * The 528x also has GPIOs in other modules (GPT, QADC) which use
+ * read-modify-write as well as those controlled by the EPORT and GPIO modules.
+ */
+#define MCFGPIO_SCR_START		40
+#else
+#define MCFGPIO_SCR_START		8
+#endif
+
+#define MCFGPIO_SETR_PORT(gpio)		(MCFGPIO_SETR + \
+					mcfgpio_port(gpio - MCFGPIO_SCR_START))
+
+#define MCFGPIO_CLRR_PORT(gpio)		(MCFGPIO_CLRR + \
+					mcfgpio_port(gpio - MCFGPIO_SCR_START))
+#else
+
+#define MCFGPIO_SCR_START		MCFGPIO_PIN_MAX
+/* with MCFGPIO_SCR == MCFGPIO_PIN_MAX, these will be optimized away */
+#define MCFGPIO_SETR_PORT(gpio)		0
+#define MCFGPIO_CLRR_PORT(gpio)		0
+
+#endif
+/*
+ * Coldfire specific helper functions
+ */
+
+/* return the port pin data register for a gpio */
+static inline u32 __mcf_gpio_ppdr(unsigned gpio)
+{
+#if defined(CONFIG_M5206) || defined(CONFIG_M5206e) || \
+    defined(CONFIG_M5307) || defined(CONFIG_M5407)
+	return MCFSIM_PADAT;
+#elif defined(CONFIG_M5272)
+	if (gpio < 16)
+		return MCFSIM_PADAT;
+	else if (gpio < 32)
+		return MCFSIM_PBDAT;
+	else
+		return MCFSIM_PCDAT;
+#elif defined(CONFIG_M5249)
+	if (gpio < 32)
+		return MCFSIM2_GPIOREAD;
+	else
+		return MCFSIM2_GPIO1READ;
+#elif defined(CONFIG_M520x) || defined(CONFIG_M523x) || \
+      defined(CONFIG_M527x) || defined(CONFIG_M528x) || defined(CONFIG_M532x)
+	if (gpio < 8)
+		return MCFEPORT_EPPDR;
+#if defined(CONFIG_M528x)
+	else if (gpio < 16)
+		return MCFGPTA_GPTPORT;
+	else if (gpio < 24)
+		return MCFGPTB_GPTPORT;
+	else if (gpio < 32)
+		return MCFQADC_PORTQA;
+	else if (gpio < 40)
+		return MCFQADC_PORTQB;
+#endif
+	else
+		return MCFGPIO_PPDR + mcfgpio_port(gpio - MCFGPIO_SCR_START);
+#endif
+}
+
+/* return the port output data register for a gpio */
+static inline u32 __mcf_gpio_podr(unsigned gpio)
+{
+#if defined(CONFIG_M5206) || defined(CONFIG_M5206e) || \
+    defined(CONFIG_M5307) || defined(CONFIG_M5407)
+	return MCFSIM_PADAT;
+#elif defined(CONFIG_M5272)
+	if (gpio < 16)
+		return MCFSIM_PADAT;
+	else if (gpio < 32)
+		return MCFSIM_PBDAT;
+	else
+		return MCFSIM_PCDAT;
+#elif defined(CONFIG_M5249)
+	if (gpio < 32)
+		return MCFSIM2_GPIOWRITE;
+	else
+		return MCFSIM2_GPIO1WRITE;
+#elif defined(CONFIG_M520x) || defined(CONFIG_M523x) || \
+      defined(CONFIG_M527x) || defined(CONFIG_M528x) || defined(CONFIG_M532x)
+	if (gpio < 8)
+		return MCFEPORT_EPDR;
+#if defined(CONFIG_M528x)
+	else if (gpio < 16)
+		return MCFGPTA_GPTPORT;
+	else if (gpio < 24)
+		return MCFGPTB_GPTPORT;
+	else if (gpio < 32)
+		return MCFQADC_PORTQA;
+	else if (gpio < 40)
+		return MCFQADC_PORTQB;
+#endif
+	else
+		return MCFGPIO_PODR + mcfgpio_port(gpio - MCFGPIO_SCR_START);
+#endif
+}
+
+/*
+ * The Generic GPIO functions
+ *
+ * If the gpio is a compile time constant and is one of the Coldfire gpios,
+ * use the inline version, otherwise dispatch thru gpiolib.
+ */
+
+static inline int gpio_get_value(unsigned gpio)
+{
+	if (__builtin_constant_p(gpio) && gpio < MCFGPIO_PIN_MAX)
+		return mcfgpio_read(__mcf_gpio_ppdr(gpio)) & mcfgpio_bit(gpio);
+	else
+		return __gpio_get_value(gpio);
+}
+
+static inline void gpio_set_value(unsigned gpio, int value)
+{
+	if (__builtin_constant_p(gpio) && gpio < MCFGPIO_PIN_MAX) {
+		if (gpio < MCFGPIO_SCR_START) {
+			unsigned long flags;
+			MCFGPIO_PORTTYPE data;
+
+			local_irq_save(flags);
+			data = mcfgpio_read(__mcf_gpio_podr(gpio));
+			if (value)
+				data |= mcfgpio_bit(gpio);
+			else
+				data &= ~mcfgpio_bit(gpio);
+			mcfgpio_write(data, __mcf_gpio_podr(gpio));
+			local_irq_restore(flags);
+		} else {
+			if (value)
+				mcfgpio_write(mcfgpio_bit(gpio),
+						MCFGPIO_SETR_PORT(gpio));
+			else
+				mcfgpio_write(~mcfgpio_bit(gpio),
+						MCFGPIO_CLRR_PORT(gpio));
+		}
+	} else
+		__gpio_set_value(gpio, value);
+}
+
+static inline int gpio_to_irq(unsigned gpio)
+{
+	return (gpio < MCFGPIO_IRQ_MAX) ? gpio + MCFGPIO_IRQ_VECBASE : -EINVAL;
+}
+
+static inline int irq_to_gpio(unsigned irq)
+{
+	return (irq >= MCFGPIO_IRQ_VECBASE &&
+		irq < (MCFGPIO_IRQ_VECBASE + MCFGPIO_IRQ_MAX)) ?
+		irq - MCFGPIO_IRQ_VECBASE : -ENXIO;
+}
+
+static inline int gpio_cansleep(unsigned gpio)
+{
+	return gpio < MCFGPIO_PIN_MAX ? 0 : __gpio_cansleep(gpio);
+}
+
+#endif
diff --git a/arch/m68k/include/asm/mcfgpio.h b/arch/m68k/include/asm/mcfgpio.h
new file mode 100644
index 0000000..ee5e4cc
--- /dev/null
+++ b/arch/m68k/include/asm/mcfgpio.h
@@ -0,0 +1,40 @@
+/*
+ * Coldfire generic GPIO support.
+ *
+ * (C) Copyright 2009, Steven King <sfking@fdwdc.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 of the License.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef mcfgpio_h
+#define mcfgpio_h
+
+#include <linux/io.h>
+#include <asm-generic/gpio.h>
+
+struct mcf_gpio_chip {
+	struct gpio_chip gpio_chip;
+	void __iomem *pddr;
+	void __iomem *podr;
+	void __iomem *ppdr;
+	void __iomem *setr;
+	void __iomem *clrr;
+	const u8 *gpio_to_pinmux;
+};
+
+int mcf_gpio_direction_input(struct gpio_chip *, unsigned);
+int mcf_gpio_get_value(struct gpio_chip *, unsigned);
+int mcf_gpio_direction_output(struct gpio_chip *, unsigned, int);
+void mcf_gpio_set_value(struct gpio_chip *, unsigned, int);
+void mcf_gpio_set_value_fast(struct gpio_chip *, unsigned, int);
+int mcf_gpio_request(struct gpio_chip *, unsigned);
+void mcf_gpio_free(struct gpio_chip *, unsigned);
+
+#endif
diff --git a/arch/m68k/include/asm/pinmux.h b/arch/m68k/include/asm/pinmux.h
new file mode 100644
index 0000000..80e86aa
--- /dev/null
+++ b/arch/m68k/include/asm/pinmux.h
@@ -0,0 +1,30 @@
+/*
+ * Coldfire generic GPIO pinmux support.
+ *
+ * (C) Copyright 2009, Steven King <sfking@fdwdc.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 of the License.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef pinmux_h
+#define pinmux_h
+
+#define MCFPINMUX_NONE		-1
+
+extern int mcf_pinmux_request(unsigned, unsigned);
+extern void mcf_pinmux_release(unsigned, unsigned);
+
+static inline int mcf_pinmux_is_valid(unsigned pinmux)
+{
+	return pinmux != MCFPINMUX_NONE;
+}
+
+#endif 
+
diff --git a/arch/m68knommu/Kconfig b/arch/m68knommu/Kconfig
index 5343762..e2201b9 100644
--- a/arch/m68knommu/Kconfig
+++ b/arch/m68knommu/Kconfig
@@ -47,6 +47,10 @@ config GENERIC_FIND_NEXT_BIT
 	bool
 	default y
 
+config GENERIC_GPIO
+	bool
+	default n
+
 config GENERIC_HWEIGHT
 	bool
 	default y
@@ -182,6 +186,8 @@ config M527x
 config COLDFIRE
 	bool
 	depends on (M5206 || M5206e || M520x || M523x || M5249 || M527x || M5272 || M528x || M5307 || M532x || M5407)
+	select GENERIC_GPIO
+	select ARCH_REQUIRE_GPIOLIB
 	default y
 
 config CLOCK_SET
diff --git a/arch/m68knommu/platform/coldfire/Makefile b/arch/m68knommu/platform/coldfire/Makefile
index 1bcb937..2667323 100644
--- a/arch/m68knommu/platform/coldfire/Makefile
+++ b/arch/m68knommu/platform/coldfire/Makefile
@@ -27,4 +27,5 @@ obj-$(CONFIG_M5307)	+= timers.o
 obj-$(CONFIG_M532x)	+= timers.o
 obj-$(CONFIG_M5407)	+= timers.o
 
+obj-y			+= pinmux.o gpio.o
 extra-y := head.o
diff --git a/arch/m68knommu/platform/coldfire/gpio.c b/arch/m68knommu/platform/coldfire/gpio.c
new file mode 100644
index 0000000..ff00457
--- /dev/null
+++ b/arch/m68knommu/platform/coldfire/gpio.c
@@ -0,0 +1,127 @@
+/*
+ * Coldfire generic GPIO support.
+ *
+ * (C) Copyright 2009, Steven King <sfking@fdwdc.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 of the License.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/sysdev.h>
+
+#include <asm/gpio.h>
+#include <asm/pinmux.h>
+#include <asm/mcfgpio.h>
+
+#define MCF_CHIP(chip) container_of(chip, struct mcf_gpio_chip, gpio_chip)
+
+int mcf_gpio_direction_input(struct gpio_chip *chip, unsigned offset)
+{
+	unsigned long flags;
+	MCFGPIO_PORTTYPE dir;
+	struct mcf_gpio_chip *mcf_chip = MCF_CHIP(chip);
+
+	local_irq_save(flags);
+	dir = mcfgpio_read(mcf_chip->pddr);
+	dir &= ~mcfgpio_bit(chip->base + offset);
+	mcfgpio_write(dir, mcf_chip->pddr);
+	local_irq_restore(flags);
+
+	return 0;
+}
+
+int mcf_gpio_get_value(struct gpio_chip *chip, unsigned offset)
+{
+	struct mcf_gpio_chip *mcf_chip = MCF_CHIP(chip);
+
+	return mcfgpio_read(mcf_chip->ppdr) & mcfgpio_bit(chip->base + offset);
+}
+
+int mcf_gpio_direction_output(struct gpio_chip *chip, unsigned offset,
+		int value)
+{
+	unsigned long flags;
+	MCFGPIO_PORTTYPE data;
+	struct mcf_gpio_chip *mcf_chip = MCF_CHIP(chip);
+
+	local_irq_save(flags);
+	/* write the value to the output latch */
+	data = mcfgpio_read(mcf_chip->podr);
+	if (value)
+		data |= mcfgpio_bit(chip->base + offset);
+	else
+		data &= ~mcfgpio_bit(chip->base + offset);
+	mcfgpio_write(data, mcf_chip->podr);
+
+	/* now set the direction to output */
+	data = mcfgpio_read(mcf_chip->pddr);
+	data |= mcfgpio_bit(chip->base + offset);
+	mcfgpio_write(data, mcf_chip->pddr);
+	local_irq_restore(flags);
+
+	return 0;
+}
+
+void mcf_gpio_set_value(struct gpio_chip *chip, unsigned offset, int value)
+{
+	struct mcf_gpio_chip *mcf_chip = MCF_CHIP(chip);
+
+	unsigned long flags;
+	MCFGPIO_PORTTYPE data;
+
+	local_irq_save(flags);
+	data = mcfgpio_read(mcf_chip->podr);
+	if (value)
+		data |= mcfgpio_bit(chip->base + offset);
+	else
+		data &= ~mcfgpio_bit(chip->base + offset);
+	mcfgpio_write(data, mcf_chip->podr);
+	local_irq_restore(flags);
+}
+
+void mcf_gpio_set_value_fast(struct gpio_chip *chip, unsigned offset, int value)
+{
+	struct mcf_gpio_chip *mcf_chip = MCF_CHIP(chip);
+
+	if (value)
+		mcfgpio_write(mcfgpio_bit(chip->base + offset), mcf_chip->setr);
+	else
+		mcfgpio_write(~mcfgpio_bit(chip->base + offset), mcf_chip->clrr);
+}
+
+int mcf_gpio_request(struct gpio_chip *chip, unsigned offset)
+{
+	struct mcf_gpio_chip *mcf_chip = MCF_CHIP(chip);
+
+	return mcf_chip->gpio_to_pinmux ?
+		mcf_pinmux_request(mcf_chip->gpio_to_pinmux[offset], 0) : 0;
+}
+
+void mcf_gpio_free(struct gpio_chip *chip, unsigned offset)
+{
+	struct mcf_gpio_chip *mcf_chip = MCF_CHIP(chip);
+
+	mcf_gpio_direction_input(chip, offset);
+
+	if (mcf_chip->gpio_to_pinmux)
+		mcf_pinmux_release(mcf_chip->gpio_to_pinmux[offset], 0);
+}
+
+struct sysdev_class mcf_gpio_sysclass = {
+	.name	= "gpio",
+};
+
+static int __init mcf_gpio_sysinit(void)
+{
+	return sysdev_class_register(&mcf_gpio_sysclass);
+}
+
+core_initcall(mcf_gpio_sysinit);
diff --git a/arch/m68knommu/platform/coldfire/pinmux.c b/arch/m68knommu/platform/coldfire/pinmux.c
new file mode 100644
index 0000000..8c62b82
--- /dev/null
+++ b/arch/m68knommu/platform/coldfire/pinmux.c
@@ -0,0 +1,28 @@
+/*
+ * Coldfire generic GPIO pinmux support.
+ *
+ * (C) Copyright 2009, Steven King <sfking@fdwdc.com>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *   it under the terms of the GNU General Public License as published by
+ *   the Free Software Foundation; version 2 of the License.
+ *
+ *   This program is distributed in the hope that it will be useful,
+ *   but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *   GNU General Public License for more details.
+ *
+ */
+
+#include <linux/kernel.h>
+
+#include <asm/pinmux.h>
+
+int mcf_pinmux_request(unsigned pinmux, unsigned func)
+{
+	return 0;
+}
+
+void mcf_pinmux_release(unsigned pinmux, unsigned func)
+{
+}
-- 
1.5.6.5

