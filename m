Return-Path: <linux-kernel-owner+w=401wt.eu-S1754452AbZCKV61@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754452AbZCKV61 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 17:58:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754037AbZCKV57
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 17:57:59 -0400
Received: from smtp103.biz.mail.mud.yahoo.com ([68.142.200.238]:21680 "HELO
	smtp103.biz.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754011AbZCKV54 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 17:57:56 -0400
X-Yahoo-SMTP: Y9aU0H6swBAqsiryRZEA7xtDWlgllPfq7He2xMk-
X-YMail-OSG: lq2Hp1EVM1lkXTKiKQIfwoWI_b5.RWbi1hhkS39K12fVqFMuLyAlO9rTqJ2moqla6IbUnZALRClD3gkP4zpX36SEKb89Sfm7SYPt63l5ocU57dZElnhpSqXjnQUU92EDui1VGGVlsvfHQbQN7LzcCd_ZaT8xoGkAMqqOdqi9qbhToRG5SulQyTb5RunBI1modihrVOyidH10emJIzMGZAerve7kpLORyPgWdecScpLxrPpk-
X-Yahoo-Newman-Property: ymail-3
From: Steven King <sfking@fdwdc.com>
To: uClinux development list <uclinux-dev@uclinux.org>
Subject: [RFC 01/14] Coldfire generic GPIO (m68knommu)
Date: Wed, 11 Mar 2009 13:55:42 -0800
User-Agent: KMail/1.9.10
Organization: fdwdc.com
Cc: linux-kernel@vger.kernel.org, Greg Ungerer <gerg@snapgear.com>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200903111455.42856.sfking@fdwdc.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The basic Coldfire generic gpio implementation.

Signed-off-by: Steven King <sfking@fdwdc.com>

diff --git a/arch/m68k/include/asm/gpio.h b/arch/m68k/include/asm/gpio.h
new file mode 100644
index 0000000..704e101
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
+#ifndef mcfgpio_h
+#define mcfgpio_h
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
diff --git a/arch/m68knommu/platform/coldfire/gpio.c 
b/arch/m68knommu/platform/coldfire/gpio.c
new file mode 100644
index 0000000..c2504b9
--- /dev/null
+++ b/arch/m68knommu/platform/coldfire/gpio.c
@@ -0,0 +1,1969 @@
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
+#define MCF_CHIP(chip) container_of(chip, struct mcf_gpio_chip, gpio_chip)
+
+static int mcf_gpio_direction_input(struct gpio_chip *chip, unsigned offset)
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
+static int mcf_gpio_get_value(struct gpio_chip *chip, unsigned offset)
+{
+	struct mcf_gpio_chip *mcf_chip = MCF_CHIP(chip);
+
+	return mcfgpio_read(mcf_chip->ppdr) & mcfgpio_bit(chip->base + offset);
+}
+
+static int mcf_gpio_direction_output(struct gpio_chip *chip, unsigned offset,
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
+static void mcf_gpio_set_value(struct gpio_chip *chip, unsigned offset,
+		int value)
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
+#if defined(CONFIG_M520x) || defined(CONFIG_M523x) || \
+      defined(CONFIG_M527x) || defined(CONFIG_M528x) || defined(CONFIG_M532x)
+static void mcf_gpio_set_value_fast(struct gpio_chip *chip, unsigned offset,
+		int value)
+{
+	struct mcf_gpio_chip *mcf_chip = MCF_CHIP(chip);
+
+	if (value)
+		mcfgpio_write(mcfgpio_bit(chip->base + offset), mcf_chip->setr);
+	else
+		mcfgpio_write(~mcfgpio_bit(chip->base + offset), mcf_chip->clrr);
+}
+#endif
+static int mcf_gpio_request(struct gpio_chip *chip, unsigned offset)
+{
+	struct mcf_gpio_chip *mcf_chip = MCF_CHIP(chip);
+
+	return mcf_chip->gpio_to_pinmux ?
+		mcf_pinmux_request(mcf_chip->gpio_to_pinmux[offset], 0) : 0;
+}
+
+static void mcf_gpio_free(struct gpio_chip *chip, unsigned offset)
+{
+	struct mcf_gpio_chip *mcf_chip = MCF_CHIP(chip);
+
+	mcf_gpio_direction_input(chip, offset);
+
+	if (mcf_chip->gpio_to_pinmux)
+		mcf_pinmux_release(mcf_chip->gpio_to_pinmux[offset], 0);
+}
+
+static struct mcf_gpio_chip mcf_gpio_chips[] = {
+#if defined(CONFIG_M5206) || defined(CONFIG_M5206e)
+	{
+		.gpio_chip			= {
+			.label			= "PP",
+			.request		= mcf_gpio_request,
+			.free			= mcf_gpio_free,
+			.direction_input	= mcf_gpio_direction_input,
+			.direction_output	= mcf_gpio_direction_output,
+			.get			= mcf_gpio_get_value,
+			.set			= mcf_gpio_set_value,
+			.ngpio			= 8,
+		},
+		.pddr				= MCFSIM_PADDR,
+		.podr				= MCFSIM_PADAT,
+		.ppdr				= MCFSIM_PADAT,
+	},
+#elif defined(CONFIG_M520x)
+	{
+		.gpio_chip			= {
+			.label			= "PIRQ",
+			.request		= mcf_gpio_request,
+			.free			= mcf_gpio_free,
+			.direction_input	= mcf_gpio_direction_input,
+			.direction_output	= mcf_gpio_direction_output,
+			.get			= mcf_gpio_get_value,
+			.set			= mcf_gpio_set_value,
+			.ngpio			= 8,
+		},
+		.pddr				= MCFEPORT_EPDDR,
+		.podr				= MCFEPORT_EPDR,
+		.ppdr				= MCFEPORT_EPPDR,
+	},
+	{
+		.gpio_chip			= {
+			.label			= "BUSCTL",
+			.request		= mcf_gpio_request,
+			.free			= mcf_gpio_free,
+			.direction_input	= mcf_gpio_direction_input,
+			.direction_output	= mcf_gpio_direction_output,
+			.get			= mcf_gpio_get_value,
+			.set			= mcf_gpio_set_value_fast,
+			.base			= 8,
+			.ngpio			= 4,
+		},
+		.pddr				= MCFGPIO_PDDR_BUSCTL,
+		.podr				= MCFGPIO_PODR_BUSCTL,
+		.ppdr				= MCFGPIO_PPDSDR_BUSCTL,
+		.setr				= MCFGPIO_PPDSDR_BUSCTL,
+		.clrr				= MCFGPIO_PCLRR_BUSCTL,
+	},
+	{
+		.gpio_chip			= {
+			.label			= "BE",
+			.request		= mcf_gpio_request,
+			.free			= mcf_gpio_free,
+			.direction_input	= mcf_gpio_direction_input,
+			.direction_output	= mcf_gpio_direction_output,
+			.get			= mcf_gpio_get_value,
+			.set			= mcf_gpio_set_value_fast,
+			.base			= 16,
+			.ngpio			= 4,
+		},
+		.pddr				= MCFGPIO_PDDR_BE,
+		.podr				= MCFGPIO_PODR_BE,
+		.ppdr				= MCFGPIO_PPDSDR_BE,
+		.setr				= MCFGPIO_PPDSDR_BE,
+		.clrr				= MCFGPIO_PCLRR_BE,
+	},
+	{
+		.gpio_chip			= {
+			.label			= "CS",
+			.request		= mcf_gpio_request,
+			.free			= mcf_gpio_free,
+			.direction_input	= mcf_gpio_direction_input,
+			.direction_output	= mcf_gpio_direction_output,
+			.get			= mcf_gpio_get_value,
+			.set			= mcf_gpio_set_value_fast,
+			.base			= 25,
+			.ngpio			= 3,
+		},
+		.pddr				= MCFGPIO_PDDR_CS,
+		.podr				= MCFGPIO_PODR_CS,
+		.ppdr				= MCFGPIO_PPDSDR_CS,
+		.setr				= MCFGPIO_PPDSDR_CS,
+		.clrr				= MCFGPIO_PCLRR_CS,
+	},
+	{
+		.gpio_chip			= {
+			.label			= "FECI2C",
+			.request		= mcf_gpio_request,
+			.free			= mcf_gpio_free,
+			.direction_input	= mcf_gpio_direction_input,
+			.direction_output	= mcf_gpio_direction_output,
+			.get			= mcf_gpio_get_value,
+			.set			= mcf_gpio_set_value_fast,
+			.base			= 32,
+			.ngpio			= 4,
+		},
+		.pddr				= MCFGPIO_PDDR_FECI2C,
+		.podr				= MCFGPIO_PODR_FECI2C,
+		.ppdr				= MCFGPIO_PPDSDR_FECI2C,
+		.setr				= MCFGPIO_PPDSDR_FECI2C,
+		.clrr				= MCFGPIO_PCLRR_FECI2C,
+	},
+	{
+		.gpio_chip			= {
+			.label			= "QSPI",
+			.request		= mcf_gpio_request,
+			.free			= mcf_gpio_free,
+			.direction_input	= mcf_gpio_direction_input,
+			.direction_output	= mcf_gpio_direction_output,
+			.get			= mcf_gpio_get_value,
+			.set			= mcf_gpio_set_value_fast,
+			.base			= 40,
+			.ngpio			= 4,
+		},
+		.pddr				= MCFGPIO_PDDR_QSPI,
+		.podr				= MCFGPIO_PODR_QSPI,
+		.ppdr				= MCFGPIO_PPDSDR_QSPI,
+		.setr				= MCFGPIO_PPDSDR_QSPI,
+		.clrr				= MCFGPIO_PCLRR_QSPI,
+	},
+	{
+		.gpio_chip			= {
+			.label			= "TIMER",
+			.request		= mcf_gpio_request,
+			.free			= mcf_gpio_free,
+			.direction_input	= mcf_gpio_direction_input,
+			.direction_output	= mcf_gpio_direction_output,
+			.get			= mcf_gpio_get_value,
+			.set			= mcf_gpio_set_value_fast,
+			.base			= 48,
+			.ngpio			= 4,
+		},
+		.pddr				= MCFGPIO_PDDR_TIMER,
+		.podr				= MCFGPIO_PODR_TIMER,
+		.ppdr				= MCFGPIO_PPDSDR_TIMER,
+		.setr				= MCFGPIO_PPDSDR_TIMER,
+		.clrr				= MCFGPIO_PCLRR_TIMER,
+	},
+	{
+		.gpio_chip			= {
+			.label			= "UART",
+			.request		= mcf_gpio_request,
+			.free			= mcf_gpio_free,
+			.direction_input	= mcf_gpio_direction_input,
+			.direction_output	= mcf_gpio_direction_output,
+			.get			= mcf_gpio_get_value,
+			.set			= mcf_gpio_set_value_fast,
+			.base			= 56,
+			.ngpio			= 8,
+		},
+		.pddr				= MCFGPIO_PDDR_UART,
+		.podr				= MCFGPIO_PODR_UART,
+		.ppdr				= MCFGPIO_PPDSDR_UART,
+		.setr				= MCFGPIO_PPDSDR_UART,
+		.clrr				= MCFGPIO_PCLRR_UART,
+	},
+	{
+		.gpio_chip			= {
+			.label			= "FECH",
+			.request		= mcf_gpio_request,
+			.free			= mcf_gpio_free,
+			.direction_input	= mcf_gpio_direction_input,
+			.direction_output	= mcf_gpio_direction_output,
+			.get			= mcf_gpio_get_value,
+			.set			= mcf_gpio_set_value_fast,
+			.base			= 64,
+			.ngpio			= 8,
+		},
+		.pddr				= MCFGPIO_PDDR_FECH,
+		.podr				= MCFGPIO_PODR_FECH,
+		.ppdr				= MCFGPIO_PPDSDR_FECH,
+		.setr				= MCFGPIO_PPDSDR_FECH,
+		.clrr				= MCFGPIO_PCLRR_FECH,
+	},
+	{
+		.gpio_chip			= {
+			.label			= "FECL",
+			.request		= mcf_gpio_request,
+			.free			= mcf_gpio_free,
+			.direction_input	= mcf_gpio_direction_input,
+			.direction_output	= mcf_gpio_direction_output,
+			.get			= mcf_gpio_get_value,
+			.set			= mcf_gpio_set_value_fast,
+			.base			= 72,
+			.ngpio			= 8,
+		},
+		.pddr				= MCFGPIO_PDDR_FECL,
+		.podr				= MCFGPIO_PODR_FECL,
+		.ppdr				= MCFGPIO_PPDSDR_FECL,
+		.setr				= MCFGPIO_PPDSDR_FECL,
+		.clrr				= MCFGPIO_PCLRR_FECL,
+	},
+#elif defined(CONFIG_M523x)
+	{
+		.gpio_chip			= {
+			.label			= "PIRQ",
+			.request		= mcf_gpio_request,
+			.free			= mcf_gpio_free,
+			.direction_input	= mcf_gpio_direction_input,
+			.direction_output	= mcf_gpio_direction_output,
+			.get			= mcf_gpio_get_value,
+			.set			= mcf_gpio_set_value,
+			.ngpio			= 8,
+		},
+		.pddr				= MCFEPORT_EPDDR,
+		.podr				= MCFEPORT_EPDR,
+		.ppdr				= MCFEPORT_EPPDR,
+	},
+	{
+		.gpio_chip			= {
+			.label			= "ADDR",
+			.request		= mcf_gpio_request,
+			.free			= mcf_gpio_free,
+			.direction_input	= mcf_gpio_direction_input,
+			.direction_output	= mcf_gpio_direction_output,
+			.get			= mcf_gpio_get_value,
+			.set			= mcf_gpio_set_value_fast,
+			.base			= 13,
+			.ngpio			= 3,
+		},
+		.pddr				= MCFGPIO_PDDR_ADDR,
+		.podr				= MCFGPIO_PODR_ADDR,
+		.ppdr				= MCFGPIO_PPDSDR_ADDR,
+		.setr				= MCFGPIO_PPDSDR_ADDR,
+		.clrr				= MCFGPIO_PCLRR_ADDR,
+	},
+	{
+		.gpio_chip			= {
+			.label			= "DATAH",
+			.request		= mcf_gpio_request,
+			.free			= mcf_gpio_free,
+			.direction_input	= mcf_gpio_direction_input,
+			.direction_output	= mcf_gpio_direction_output,
+			.get			= mcf_gpio_get_value,
+			.set			= mcf_gpio_set_value_fast,
+			.base			= 16,
+			.ngpio			= 8,
+		},
+		.pddr				= MCFGPIO_PDDR_DATAH,
+		.podr				= MCFGPIO_PODR_DATAH,
+		.ppdr				= MCFGPIO_PPDSDR_DATAH,
+		.setr				= MCFGPIO_PPDSDR_DATAH,
+		.clrr				= MCFGPIO_PCLRR_DATAH,
+	},
+	{
+		.gpio_chip			= {
+			.label			= "DATAL",
+			.request		= mcf_gpio_request,
+			.free			= mcf_gpio_free,
+			.direction_input	= mcf_gpio_direction_input,
+			.direction_output	= mcf_gpio_direction_output,
+			.get			= mcf_gpio_get_value,
+			.set			= mcf_gpio_set_value_fast,
+			.base			= 24,
+			.ngpio			= 8,
+		},
+		.pddr				= MCFGPIO_PDDR_DATAL,
+		.podr				= MCFGPIO_PODR_DATAL,
+		.ppdr				= MCFGPIO_PPDSDR_DATAL,
+		.setr				= MCFGPIO_PPDSDR_DATAL,
+		.clrr				= MCFGPIO_PCLRR_DATAL,
+	},
+	{
+		.gpio_chip			= {
+			.label			= "BUSCTL",
+			.request		= mcf_gpio_request,
+			.free			= mcf_gpio_free,
+			.direction_input	= mcf_gpio_direction_input,
+			.direction_output	= mcf_gpio_direction_output,
+			.get			= mcf_gpio_get_value,
+			.set			= mcf_gpio_set_value_fast,
+			.base			= 32,
+			.ngpio			= 8,
+		},
+		.pddr				= MCFGPIO_PDDR_BUSCTL,
+		.podr				= MCFGPIO_PODR_BUSCTL,
+		.ppdr				= MCFGPIO_PPDSDR_BUSCTL,
+		.setr				= MCFGPIO_PPDSDR_BUSCTL,
+		.clrr				= MCFGPIO_PCLRR_BUSCTL,
+	},
+	{
+		.gpio_chip			= {
+			.label			= "BS",
+			.request		= mcf_gpio_request,
+			.free			= mcf_gpio_free,
+			.direction_input	= mcf_gpio_direction_input,
+			.direction_output	= mcf_gpio_direction_output,
+			.get			= mcf_gpio_get_value,
+			.set			= mcf_gpio_set_value_fast,
+			.base			= 40,
+			.ngpio			= 4,
+		},
+		.pddr				= MCFGPIO_PDDR_BS,
+		.podr				= MCFGPIO_PODR_BS,
+		.ppdr				= MCFGPIO_PPDSDR_BS,
+		.setr				= MCFGPIO_PPDSDR_BS,
+		.clrr				= MCFGPIO_PCLRR_BS,
+	},
+	{
+		.gpio_chip			= {
+			.label			= "CS",
+			.request		= mcf_gpio_request,
+			.free			= mcf_gpio_free,
+			.direction_input	= mcf_gpio_direction_input,
+			.direction_output	= mcf_gpio_direction_output,
+			.get			= mcf_gpio_get_value,
+			.set			= mcf_gpio_set_value_fast,
+			.base			= 49,
+			.ngpio			= 7,
+		},
+		.pddr				= MCFGPIO_PDDR_CS,
+		.podr				= MCFGPIO_PODR_CS,
+		.ppdr				= MCFGPIO_PPDSDR_CS,
+		.setr				= MCFGPIO_PPDSDR_CS,
+		.clrr				= MCFGPIO_PCLRR_CS,
+	},
+	{
+		.gpio_chip			= {
+			.label			= "SDRAM",
+			.request		= mcf_gpio_request,
+			.free			= mcf_gpio_free,
+			.direction_input	= mcf_gpio_direction_input,
+			.direction_output	= mcf_gpio_direction_output,
+			.get			= mcf_gpio_get_value,
+			.set			= mcf_gpio_set_value_fast,
+			.base			= 56,
+			.ngpio			= 6,
+		},
+		.pddr				= MCFGPIO_PDDR_SDRAM,
+		.podr				= MCFGPIO_PODR_SDRAM,
+		.ppdr				= MCFGPIO_PPDSDR_SDRAM,
+		.setr				= MCFGPIO_PPDSDR_SDRAM,
+		.clrr				= MCFGPIO_PCLRR_SDRAM,
+	},
+	{
+		.gpio_chip			= {
+			.label			= "FECI2C",
+			.request		= mcf_gpio_request,
+			.free			= mcf_gpio_free,
+			.direction_input	= mcf_gpio_direction_input,
+			.direction_output	= mcf_gpio_direction_output,
+			.get			= mcf_gpio_get_value,
+			.set			= mcf_gpio_set_value_fast,
+			.base			= 64,
+			.ngpio			= 4,
+		},
+		.pddr				= MCFGPIO_PDDR_FECI2C,
+		.podr				= MCFGPIO_PODR_FECI2C,
+		.ppdr				= MCFGPIO_PPDSDR_FECI2C,
+		.setr				= MCFGPIO_PPDSDR_FECI2C,
+		.clrr				= MCFGPIO_PCLRR_FECI2C,
+	},
+	{
+		.gpio_chip			= {
+			.label			= "UARTH",
+			.request		= mcf_gpio_request,
+			.free			= mcf_gpio_free,
+			.direction_input	= mcf_gpio_direction_input,
+			.direction_output	= mcf_gpio_direction_output,
+			.get			= mcf_gpio_get_value,
+			.set			= mcf_gpio_set_value_fast,
+			.base			= 72,
+			.ngpio			= 2,
+		},
+		.pddr				= MCFGPIO_PDDR_UARTH,
+		.podr				= MCFGPIO_PODR_UARTH,
+		.ppdr				= MCFGPIO_PPDSDR_UARTH,
+		.setr				= MCFGPIO_PPDSDR_UARTH,
+		.clrr				= MCFGPIO_PCLRR_UARTH,
+	},
+	{
+		.gpio_chip			= {
+			.label			= "UARTL",
+			.request		= mcf_gpio_request,
+			.free			= mcf_gpio_free,
+			.direction_input	= mcf_gpio_direction_input,
+			.direction_output	= mcf_gpio_direction_output,
+			.get			= mcf_gpio_get_value,
+			.set			= mcf_gpio_set_value_fast,
+			.base			= 80,
+			.ngpio			= 8,
+		},
+		.pddr				= MCFGPIO_PDDR_UARTL,
+		.podr				= MCFGPIO_PODR_UARTL,
+		.ppdr				= MCFGPIO_PPDSDR_UARTL,
+		.setr				= MCFGPIO_PPDSDR_UARTL,
+		.clrr				= MCFGPIO_PCLRR_UARTL,
+	},
+	{
+		.gpio_chip			= {
+			.label			= "QSPI",
+			.request		= mcf_gpio_request,
+			.free			= mcf_gpio_free,
+			.direction_input	= mcf_gpio_direction_input,
+			.direction_output	= mcf_gpio_direction_output,
+			.get			= mcf_gpio_get_value,
+			.set			= mcf_gpio_set_value_fast,
+			.base			= 88,
+			.ngpio			= 5,
+		},
+		.pddr				= MCFGPIO_PDDR_QSPI,
+		.podr				= MCFGPIO_PODR_QSPI,
+		.ppdr				= MCFGPIO_PPDSDR_QSPI,
+		.setr				= MCFGPIO_PPDSDR_QSPI,
+		.clrr				= MCFGPIO_PCLRR_QSPI,
+	},
+	{
+		.gpio_chip			= {
+			.label			= "TIMER",
+			.request		= mcf_gpio_request,
+			.free			= mcf_gpio_free,
+			.direction_input	= mcf_gpio_direction_input,
+			.direction_output	= mcf_gpio_direction_output,
+			.get			= mcf_gpio_get_value,
+			.set			= mcf_gpio_set_value_fast,
+			.base			= 96,
+			.ngpio			= 4,
+		},
+		.pddr				= MCFGPIO_PDDR_TIMER,
+		.podr				= MCFGPIO_PODR_TIMER,
+		.ppdr				= MCFGPIO_PPDSDR_TIMER,
+		.setr				= MCFGPIO_PPDSDR_TIMER,
+		.clrr				= MCFGPIO_PCLRR_TIMER,
+	},
+	{
+		.gpio_chip			= {
+			.label			= "ETPU",
+			.request		= mcf_gpio_request,
+			.free			= mcf_gpio_free,
+			.direction_input	= mcf_gpio_direction_input,
+			.direction_output	= mcf_gpio_direction_output,
+			.get			= mcf_gpio_get_value,
+			.set			= mcf_gpio_set_value_fast,
+			.base			= 104,
+			.ngpio			= 3,
+		},
+		.pddr				= MCFGPIO_PDDR_ETPU,
+		.podr				= MCFGPIO_PODR_ETPU,
+		.ppdr				= MCFGPIO_PPDSDR_ETPU,
+		.setr				= MCFGPIO_PPDSDR_ETPU,
+		.clrr				= MCFGPIO_PCLRR_ETPU,
+	},
+#elif defined(CONFIG_M5249)
+	{
+		.gpio_chip			= {
+			.label			= "GPIO0",
+			.request		= mcf_gpio_request,
+			.free			= mcf_gpio_free,
+			.direction_input	= mcf_gpio_direction_input,
+			.direction_output	= mcf_gpio_direction_output,
+			.get			= mcf_gpio_get_value,
+			.set			= mcf_gpio_set_value,
+			.ngpio			= 32,
+		},
+		.pddr				= MCFSIM2_GPIOENABLE,
+		.podr				= MCFSIM2_GPIOWRITE,
+		.ppdr				= MCFSIM2_GPIOREAD,
+	},
+	{
+		.gpio_chip			= {
+			.label			= "GPIO1",
+			.request		= mcf_gpio_request,
+			.free			= mcf_gpio_free,
+			.direction_input	= mcf_gpio_direction_input,
+			.direction_output	= mcf_gpio_direction_output,
+			.get			= mcf_gpio_get_value,
+			.set			= mcf_gpio_set_value,
+			.base			= 32,
+			.ngpio			= 32,
+		},
+		.pddr				= MCFSIM2_GPIO1ENABLE,
+		.podr				= MCFSIM2_GPIO1WRITE,
+		.ppdr				= MCFSIM2_GPIO1READ,
+	},
+#elif defined(CONFIG_M5271)
+	{
+		.gpio_chip			= {
+			.label			= "PIRQ",
+			.request		= mcf_gpio_request,
+			.free			= mcf_gpio_free,
+			.direction_input	= mcf_gpio_direction_input,
+			.direction_output	= mcf_gpio_direction_output,
+			.get			= mcf_gpio_get_value,
+			.set			= mcf_gpio_set_value,
+			.ngpio			= 8,
+		},
+		.pddr				= MCFEPORT_EPDDR,
+		.podr				= MCFEPORT_EPDR,
+		.ppdr				= MCFEPORT_EPPDR,
+	},
+	{
+		.gpio_chip			= {
+			.label			= "ADDR",
+			.request		= mcf_gpio_request,
+			.free			= mcf_gpio_free,
+			.direction_input	= mcf_gpio_direction_input,
+			.direction_output	= mcf_gpio_direction_output,
+			.get			= mcf_gpio_get_value,
+			.set			= mcf_gpio_set_value_fast,
+			.base			= 13,
+			.ngpio			= 3,
+		},
+		.pddr				= MCFGPIO_PDDR_ADDR,
+		.podr				= MCFGPIO_PODR_ADDR,
+		.ppdr				= MCFGPIO_PPDSDR_ADDR,
+		.setr				= MCFGPIO_PPDSDR_ADDR,
+		.clrr				= MCFGPIO_PCLRR_ADDR,
+	},
+	{
+		.gpio_chip			= {
+			.label			= "DATAH",
+			.request		= mcf_gpio_request,
+			.free			= mcf_gpio_free,
+			.direction_input	= mcf_gpio_direction_input,
+			.direction_output	= mcf_gpio_direction_output,
+			.get			= mcf_gpio_get_value,
+			.set			= mcf_gpio_set_value_fast,
+			.base			= 16,
+			.ngpio			= 8,
+		},
+		.pddr				= MCFGPIO_PDDR_DATAH,
+		.podr				= MCFGPIO_PODR_DATAH,
+		.ppdr				= MCFGPIO_PPDSDR_DATAH,
+		.setr				= MCFGPIO_PPDSDR_DATAH,
+		.clrr				= MCFGPIO_PCLRR_DATAH,
+	},
+	{
+		.gpio_chip			= {
+			.label			= "DATAL",
+			.request		= mcf_gpio_request,
+			.free			= mcf_gpio_free,
+			.direction_input	= mcf_gpio_direction_input,
+			.direction_output	= mcf_gpio_direction_output,
+			.get			= mcf_gpio_get_value,
+			.set			= mcf_gpio_set_value_fast,
+			.base			= 24,
+			.ngpio			= 8,
+		},
+		.pddr				= MCFGPIO_PDDR_DATAL,
+		.podr				= MCFGPIO_PODR_DATAL,
+		.ppdr				= MCFGPIO_PPDSDR_DATAL,
+		.setr				= MCFGPIO_PPDSDR_DATAL,
+		.clrr				= MCFGPIO_PCLRR_DATAL,
+	},
+	{
+		.gpio_chip			= {
+			.label			= "BUSCTL",
+			.request		= mcf_gpio_request,
+			.free			= mcf_gpio_free,
+			.direction_input	= mcf_gpio_direction_input,
+			.direction_output	= mcf_gpio_direction_output,
+			.get			= mcf_gpio_get_value,
+			.set			= mcf_gpio_set_value_fast,
+			.base			= 32,
+			.ngpio			= 8,
+		},
+		.pddr				= MCFGPIO_PDDR_BUSCTL,
+		.podr				= MCFGPIO_PODR_BUSCTL,
+		.ppdr				= MCFGPIO_PPDSDR_BUSCTL,
+		.setr				= MCFGPIO_PPDSDR_BUSCTL,
+		.clrr				= MCFGPIO_PCLRR_BUSCTL,
+	},
+	{
+		.gpio_chip			= {
+			.label			= "BS",
+			.request		= mcf_gpio_request,
+			.free			= mcf_gpio_free,
+			.direction_input	= mcf_gpio_direction_input,
+			.direction_output	= mcf_gpio_direction_output,
+			.get			= mcf_gpio_get_value,
+			.set			= mcf_gpio_set_value_fast,
+			.base			= 40,
+			.ngpio			= 4,
+		},
+		.pddr				= MCFGPIO_PDDR_BS,
+		.podr				= MCFGPIO_PODR_BS,
+		.ppdr				= MCFGPIO_PPDSDR_BS,
+		.setr				= MCFGPIO_PPDSDR_BS,
+		.clrr				= MCFGPIO_PCLRR_BS,
+	},
+	{
+		.gpio_chip			= {
+			.label			= "CS",
+			.request		= mcf_gpio_request,
+			.free			= mcf_gpio_free,
+			.direction_input	= mcf_gpio_direction_input,
+			.direction_output	= mcf_gpio_direction_output,
+			.get			= mcf_gpio_get_value,
+			.set			= mcf_gpio_set_value_fast,
+			.base			= 49,
+			.ngpio			= 7,
+		},
+		.pddr				= MCFGPIO_PDDR_CS,
+		.podr				= MCFGPIO_PODR_CS,
+		.ppdr				= MCFGPIO_PPDSDR_CS,
+		.setr				= MCFGPIO_PPDSDR_CS,
+		.clrr				= MCFGPIO_PCLRR_CS,
+	},
+	{
+		.gpio_chip			= {
+			.label			= "SDRAM",
+			.request		= mcf_gpio_request,
+			.free			= mcf_gpio_free,
+			.direction_input	= mcf_gpio_direction_input,
+			.direction_output	= mcf_gpio_direction_output,
+			.get			= mcf_gpio_get_value,
+			.set			= mcf_gpio_set_value_fast,
+			.base			= 56,
+			.ngpio			= 6,
+		},
+		.pddr				= MCFGPIO_PDDR_SDRAM,
+		.podr				= MCFGPIO_PODR_SDRAM,
+		.ppdr				= MCFGPIO_PPDSDR_SDRAM,
+		.setr				= MCFGPIO_PPDSDR_SDRAM,
+		.clrr				= MCFGPIO_PCLRR_SDRAM,
+	},
+	{
+		.gpio_chip			= {
+			.label			= "FECI2C",
+			.request		= mcf_gpio_request,
+			.free			= mcf_gpio_free,
+			.direction_input	= mcf_gpio_direction_input,
+			.direction_output	= mcf_gpio_direction_output,
+			.get			= mcf_gpio_get_value,
+			.set			= mcf_gpio_set_value_fast,
+			.base			= 64,
+			.ngpio			= 4,
+		},
+		.pddr				= MCFGPIO_PDDR_FECI2C,
+		.podr				= MCFGPIO_PODR_FECI2C,
+		.ppdr				= MCFGPIO_PPDSDR_FECI2C,
+		.setr				= MCFGPIO_PPDSDR_FECI2C,
+		.clrr				= MCFGPIO_PCLRR_FECI2C,
+	},
+	{
+		.gpio_chip			= {
+			.label			= "UARTH",
+			.request		= mcf_gpio_request,
+			.free			= mcf_gpio_free,
+			.direction_input	= mcf_gpio_direction_input,
+			.direction_output	= mcf_gpio_direction_output,
+			.get			= mcf_gpio_get_value,
+			.set			= mcf_gpio_set_value_fast,
+			.base			= 72,
+			.ngpio			= 2,
+		},
+		.pddr				= MCFGPIO_PDDR_UARTH,
+		.podr				= MCFGPIO_PODR_UARTH,
+		.ppdr				= MCFGPIO_PPDSDR_UARTH,
+		.setr				= MCFGPIO_PPDSDR_UARTH,
+		.clrr				= MCFGPIO_PCLRR_UARTH,
+	},
+	{
+		.gpio_chip			= {
+			.label			= "UARTL",
+			.request		= mcf_gpio_request,
+			.free			= mcf_gpio_free,
+			.direction_input	= mcf_gpio_direction_input,
+			.direction_output	= mcf_gpio_direction_output,
+			.get			= mcf_gpio_get_value,
+			.set			= mcf_gpio_set_value_fast,
+			.base			= 80,
+			.ngpio			= 8,
+		},
+		.pddr				= MCFGPIO_PDDR_UARTL,
+		.podr				= MCFGPIO_PODR_UARTL,
+		.ppdr				= MCFGPIO_PPDSDR_UARTL,
+		.setr				= MCFGPIO_PPDSDR_UARTL,
+		.clrr				= MCFGPIO_PCLRR_UARTL,
+	},
+	{
+		.gpio_chip			= {
+			.label			= "QSPI",
+			.request		= mcf_gpio_request,
+			.free			= mcf_gpio_free,
+			.direction_input	= mcf_gpio_direction_input,
+			.direction_output	= mcf_gpio_direction_output,
+			.get			= mcf_gpio_get_value,
+			.set			= mcf_gpio_set_value_fast,
+			.base			= 88,
+			.ngpio			= 5,
+		},
+		.pddr				= MCFGPIO_PDDR_QSPI,
+		.podr				= MCFGPIO_PODR_QSPI,
+		.ppdr				= MCFGPIO_PPDSDR_QSPI,
+		.setr				= MCFGPIO_PPDSDR_QSPI,
+		.clrr				= MCFGPIO_PCLRR_QSPI,
+	},
+	{
+		.gpio_chip			= {
+			.label			= "TIMER",
+			.request		= mcf_gpio_request,
+			.free			= mcf_gpio_free,
+			.direction_input	= mcf_gpio_direction_input,
+			.direction_output	= mcf_gpio_direction_output,
+			.get			= mcf_gpio_get_value,
+			.set			= mcf_gpio_set_value_fast,
+			.base			= 96,
+			.ngpio			= 4,
+		},
+		.pddr				= MCFGPIO_PDDR_TIMER,
+		.podr				= MCFGPIO_PODR_TIMER,
+		.ppdr				= MCFGPIO_PPDSDR_TIMER,
+		.setr				= MCFGPIO_PPDSDR_TIMER,
+		.clrr				= MCFGPIO_PCLRR_TIMER,
+	},
+#elif defined(CONFIG_M5272)
+	{
+		.gpio_chip			= {
+			.label			= "PA",
+			.request		= mcf_gpio_request,
+			.free			= mcf_gpio_free,
+			.direction_input	= mcf_gpio_direction_input,
+			.direction_output	= mcf_gpio_direction_output,
+			.get			= mcf_gpio_get_value,
+			.set			= mcf_gpio_set_value,
+			.ngpio			= 16,
+		},
+		.pddr				= MCFSIM_PADDR,
+		.podr				= MCFSIM_PADAT,
+		.ppdr				= MCFSIM_PADAT,
+	},
+	{
+		.gpio_chip			= {
+			.label			= "PB",
+			.request		= mcf_gpio_request,
+			.free			= mcf_gpio_free,
+			.direction_input	= mcf_gpio_direction_input,
+			.direction_output	= mcf_gpio_direction_output,
+			.get			= mcf_gpio_get_value,
+			.set			= mcf_gpio_set_value,
+			.base			= 16,
+			.ngpio			= 16,
+		},
+		.pddr				= MCFSIM_PBDDR,
+		.podr				= MCFSIM_PBDAT,
+		.ppdr				= MCFSIM_PBDAT,
+	},
+	{
+		.gpio_chip			= {
+			.label			= "PC",
+			.request		= mcf_gpio_request,
+			.free			= mcf_gpio_free,
+			.direction_input	= mcf_gpio_direction_input,
+			.direction_output	= mcf_gpio_direction_output,
+			.get			= mcf_gpio_get_value,
+			.set			= mcf_gpio_set_value,
+			.base			= 32,
+			.ngpio			= 16,
+		},
+		.pddr				= MCFSIM_PCDDR,
+		.podr				= MCFSIM_PCDAT,
+		.ppdr				= MCFSIM_PCDAT,
+	},
+#elif defined(CONFIG_M5275)
+	{
+		.gpio_chip			= {
+			.label			= "PIRQ",
+			.request		= mcf_gpio_request,
+			.free			= mcf_gpio_free,
+			.direction_input	= mcf_gpio_direction_input,
+			.direction_output	= mcf_gpio_direction_output,
+			.get			= mcf_gpio_get_value,
+			.set			= mcf_gpio_set_value,
+			.ngpio			= 8,
+		},
+		.pddr				= MCFEPORT_EPDDR,
+		.podr				= MCFEPORT_EPDR,
+		.ppdr				= MCFEPORT_EPPDR,
+	},
+	{
+		.gpio_chip			= {
+			.label			= "BUSCTL",
+			.request		= mcf_gpio_request,
+			.free			= mcf_gpio_free,
+			.direction_input	= mcf_gpio_direction_input,
+			.direction_output	= mcf_gpio_direction_output,
+			.get			= mcf_gpio_get_value,
+			.set			= mcf_gpio_set_value_fast,
+			.base			= 8,
+			.ngpio			= 8,
+		},
+		.pddr				= MCFGPIO_PDDR_BUSCTL,
+		.podr				= MCFGPIO_PODR_BUSCTL,
+		.ppdr				= MCFGPIO_PPDSDR_BUSCTL,
+		.setr				= MCFGPIO_PPDSDR_BUSCTL,
+		.clrr				= MCFGPIO_PCLRR_BUSCTL,
+	},
+	{
+		.gpio_chip			= {
+			.label			= "ADDR",
+			.request		= mcf_gpio_request,
+			.free			= mcf_gpio_free,
+			.direction_input	= mcf_gpio_direction_input,
+			.direction_output	= mcf_gpio_direction_output,
+			.get			= mcf_gpio_get_value,
+			.set			= mcf_gpio_set_value_fast,
+			.base			= 21,
+			.ngpio			= 3,
+		},
+		.pddr				= MCFGPIO_PDDR_ADDR,
+		.podr				= MCFGPIO_PODR_ADDR,
+		.ppdr				= MCFGPIO_PPDSDR_ADDR,
+		.setr				= MCFGPIO_PPDSDR_ADDR,
+		.clrr				= MCFGPIO_PCLRR_ADDR,
+	},
+	{
+		.gpio_chip			= {
+			.label			= "CS",
+			.request		= mcf_gpio_request,
+			.free			= mcf_gpio_free,
+			.direction_input	= mcf_gpio_direction_input,
+			.direction_output	= mcf_gpio_direction_output,
+			.get			= mcf_gpio_get_value,
+			.set			= mcf_gpio_set_value_fast,
+			.base			= 25,
+			.ngpio			= 7,
+		},
+		.pddr				= MCFGPIO_PDDR_CS,
+		.podr				= MCFGPIO_PODR_CS,
+		.ppdr				= MCFGPIO_PPDSDR_CS,
+		.setr				= MCFGPIO_PPDSDR_CS,
+		.clrr				= MCFGPIO_PCLRR_CS,
+	},
+	{
+		.gpio_chip			= {
+			.label			= "FEC0H",
+			.request		= mcf_gpio_request,
+			.free			= mcf_gpio_free,
+			.direction_input	= mcf_gpio_direction_input,
+			.direction_output	= mcf_gpio_direction_output,
+			.get			= mcf_gpio_get_value,
+			.set			= mcf_gpio_set_value_fast,
+			.base			= 32,
+			.ngpio			= 8,
+		},
+		.pddr				= MCFGPIO_PDDR_FEC0H,
+		.podr				= MCFGPIO_PODR_FEC0H,
+		.ppdr				= MCFGPIO_PPDSDR_FEC0H,
+		.setr				= MCFGPIO_PPDSDR_FEC0H,
+		.clrr				= MCFGPIO_PCLRR_FEC0H,
+	},
+	{
+		.gpio_chip			= {
+			.label			= "FEC0L",
+			.request		= mcf_gpio_request,
+			.free			= mcf_gpio_free,
+			.direction_input	= mcf_gpio_direction_input,
+			.direction_output	= mcf_gpio_direction_output,
+			.get			= mcf_gpio_get_value,
+			.set			= mcf_gpio_set_value_fast,
+			.base			= 40,
+			.ngpio			= 8,
+		},
+		.pddr				= MCFGPIO_PDDR_FEC0L,
+		.podr				= MCFGPIO_PODR_FEC0L,
+		.ppdr				= MCFGPIO_PPDSDR_FEC0L,
+		.setr				= MCFGPIO_PPDSDR_FEC0L,
+		.clrr				= MCFGPIO_PCLRR_FEC0L,
+	},
+	{
+		.gpio_chip			= {
+			.label			= "FECI2C",
+			.request		= mcf_gpio_request,
+			.free			= mcf_gpio_free,
+			.direction_input	= mcf_gpio_direction_input,
+			.direction_output	= mcf_gpio_direction_output,
+			.get			= mcf_gpio_get_value,
+			.set			= mcf_gpio_set_value_fast,
+			.base			= 48,
+			.ngpio			= 6,
+		},
+		.pddr				= MCFGPIO_PDDR_FECI2C,
+		.podr				= MCFGPIO_PODR_FECI2C,
+		.ppdr				= MCFGPIO_PPDSDR_FECI2C,
+		.setr				= MCFGPIO_PPDSDR_FECI2C,
+		.clrr				= MCFGPIO_PCLRR_FECI2C,
+	},
+	{
+		.gpio_chip			= {
+			.label			= "QSPI",
+			.request		= mcf_gpio_request,
+			.free			= mcf_gpio_free,
+			.direction_input	= mcf_gpio_direction_input,
+			.direction_output	= mcf_gpio_direction_output,
+			.get			= mcf_gpio_get_value,
+			.set			= mcf_gpio_set_value_fast,
+			.base			= 56,
+			.ngpio			= 7,
+		},
+		.pddr				= MCFGPIO_PDDR_QSPI,
+		.podr				= MCFGPIO_PODR_QSPI,
+		.ppdr				= MCFGPIO_PPDSDR_QSPI,
+		.setr				= MCFGPIO_PPDSDR_QSPI,
+		.clrr				= MCFGPIO_PCLRR_QSPI,
+	},
+	{
+		.gpio_chip			= {
+			.label			= "SDRAM",
+			.request		= mcf_gpio_request,
+			.free			= mcf_gpio_free,
+			.direction_input	= mcf_gpio_direction_input,
+			.direction_output	= mcf_gpio_direction_output,
+			.get			= mcf_gpio_get_value,
+			.set			= mcf_gpio_set_value_fast,
+			.base			= 64,
+			.ngpio			= 8,
+		},
+		.pddr				= MCFGPIO_PDDR_SDRAM,
+		.podr				= MCFGPIO_PODR_SDRAM,
+		.ppdr				= MCFGPIO_PPDSDR_SDRAM,
+		.setr				= MCFGPIO_PPDSDR_SDRAM,
+		.clrr				= MCFGPIO_PCLRR_SDRAM,
+	},
+	{
+		.gpio_chip			= {
+			.label			= "TIMERH",
+			.request		= mcf_gpio_request,
+			.free			= mcf_gpio_free,
+			.direction_input	= mcf_gpio_direction_input,
+			.direction_output	= mcf_gpio_direction_output,
+			.get			= mcf_gpio_get_value,
+			.set			= mcf_gpio_set_value_fast,
+			.base			= 72,
+			.ngpio			= 4,
+		},
+		.pddr				= MCFGPIO_PDDR_TIMERH,
+		.podr				= MCFGPIO_PODR_TIMERH,
+		.ppdr				= MCFGPIO_PPDSDR_TIMERH,
+		.setr				= MCFGPIO_PPDSDR_TIMERH,
+		.clrr				= MCFGPIO_PCLRR_TIMERH,
+	},
+	{
+		.gpio_chip			= {
+			.label			= "TIMERL",
+			.request		= mcf_gpio_request,
+			.free			= mcf_gpio_free,
+			.direction_input	= mcf_gpio_direction_input,
+			.direction_output	= mcf_gpio_direction_output,
+			.get			= mcf_gpio_get_value,
+			.set			= mcf_gpio_set_value_fast,
+			.base			= 80,
+			.ngpio			= 4,
+		},
+		.pddr				= MCFGPIO_PDDR_TIMERL,
+		.podr				= MCFGPIO_PODR_TIMERL,
+		.ppdr				= MCFGPIO_PPDSDR_TIMERL,
+		.setr				= MCFGPIO_PPDSDR_TIMERL,
+		.clrr				= MCFGPIO_PCLRR_TIMERL,
+	},
+	{
+		.gpio_chip			= {
+			.label			= "UARTL",
+			.request		= mcf_gpio_request,
+			.free			= mcf_gpio_free,
+			.direction_input	= mcf_gpio_direction_input,
+			.direction_output	= mcf_gpio_direction_output,
+			.get			= mcf_gpio_get_value,
+			.set			= mcf_gpio_set_value_fast,
+			.base			= 88,
+			.ngpio			= 8,
+		},
+		.pddr				= MCFGPIO_PDDR_UARTL,
+		.podr				= MCFGPIO_PODR_UARTL,
+		.ppdr				= MCFGPIO_PPDSDR_UARTL,
+		.setr				= MCFGPIO_PPDSDR_UARTL,
+		.clrr				= MCFGPIO_PCLRR_UARTL,
+	},
+	{
+		.gpio_chip			= {
+			.label			= "FEC1H",
+			.request		= mcf_gpio_request,
+			.free			= mcf_gpio_free,
+			.direction_input	= mcf_gpio_direction_input,
+			.direction_output	= mcf_gpio_direction_output,
+			.get			= mcf_gpio_get_value,
+			.set			= mcf_gpio_set_value_fast,
+			.base			= 96,
+			.ngpio			= 8,
+		},
+		.pddr				= MCFGPIO_PDDR_FEC1H,
+		.podr				= MCFGPIO_PODR_FEC1H,
+		.ppdr				= MCFGPIO_PPDSDR_FEC1H,
+		.setr				= MCFGPIO_PPDSDR_FEC1H,
+		.clrr				= MCFGPIO_PCLRR_FEC1H,
+	},
+	{
+		.gpio_chip			= {
+			.label			= "FEC1L",
+			.request		= mcf_gpio_request,
+			.free			= mcf_gpio_free,
+			.direction_input	= mcf_gpio_direction_input,
+			.direction_output	= mcf_gpio_direction_output,
+			.get			= mcf_gpio_get_value,
+			.set			= mcf_gpio_set_value_fast,
+			.base			= 104,
+			.ngpio			= 8,
+		},
+		.pddr				= MCFGPIO_PDDR_FEC1L,
+		.podr				= MCFGPIO_PODR_FEC1L,
+		.ppdr				= MCFGPIO_PPDSDR_FEC1L,
+		.setr				= MCFGPIO_PPDSDR_FEC1L,
+		.clrr				= MCFGPIO_PCLRR_FEC1L,
+	},
+	{
+		.gpio_chip			= {
+			.label			= "BS",
+			.request		= mcf_gpio_request,
+			.free			= mcf_gpio_free,
+			.direction_input	= mcf_gpio_direction_input,
+			.direction_output	= mcf_gpio_direction_output,
+			.get			= mcf_gpio_get_value,
+			.set			= mcf_gpio_set_value_fast,
+			.base			= 114,
+			.ngpio			= 2,
+		},
+		.pddr				= MCFGPIO_PDDR_BS,
+		.podr				= MCFGPIO_PODR_BS,
+		.ppdr				= MCFGPIO_PPDSDR_BS,
+		.setr				= MCFGPIO_PPDSDR_BS,
+		.clrr				= MCFGPIO_PCLRR_BS,
+	},
+	{
+		.gpio_chip			= {
+			.label			= "IRQ",
+			.request		= mcf_gpio_request,
+			.free			= mcf_gpio_free,
+			.direction_input	= mcf_gpio_direction_input,
+			.direction_output	= mcf_gpio_direction_output,
+			.get			= mcf_gpio_get_value,
+			.set			= mcf_gpio_set_value_fast,
+			.base			= 121,
+			.ngpio			= 7,
+		},
+		.pddr				= MCFGPIO_PDDR_IRQ,
+		.podr				= MCFGPIO_PODR_IRQ,
+		.ppdr				= MCFGPIO_PPDSDR_IRQ,
+		.setr				= MCFGPIO_PPDSDR_IRQ,
+		.clrr				= MCFGPIO_PCLRR_IRQ,
+	},
+	{
+		.gpio_chip			= {
+			.label			= "USBH",
+			.request		= mcf_gpio_request,
+			.free			= mcf_gpio_free,
+			.direction_input	= mcf_gpio_direction_input,
+			.direction_output	= mcf_gpio_direction_output,
+			.get			= mcf_gpio_get_value,
+			.set			= mcf_gpio_set_value_fast,
+			.base			= 128,
+			.ngpio			= 1,
+		},
+		.pddr				= MCFGPIO_PDDR_USBH,
+		.podr				= MCFGPIO_PODR_USBH,
+		.ppdr				= MCFGPIO_PPDSDR_USBH,
+		.setr				= MCFGPIO_PPDSDR_USBH,
+		.clrr				= MCFGPIO_PCLRR_USBH,
+	},
+	{
+		.gpio_chip			= {
+			.label			= "USBL",
+			.request		= mcf_gpio_request,
+			.free			= mcf_gpio_free,
+			.direction_input	= mcf_gpio_direction_input,
+			.direction_output	= mcf_gpio_direction_output,
+			.get			= mcf_gpio_get_value,
+			.set			= mcf_gpio_set_value_fast,
+			.base			= 136,
+			.ngpio			= 8,
+		},
+		.pddr				= MCFGPIO_PDDR_USBL,
+		.podr				= MCFGPIO_PODR_USBL,
+		.ppdr				= MCFGPIO_PPDSDR_USBL,
+		.setr				= MCFGPIO_PPDSDR_USBL,
+		.clrr				= MCFGPIO_PCLRR_USBL,
+	},
+	{
+		.gpio_chip			= {
+			.label			= "UARTH",
+			.request		= mcf_gpio_request,
+			.free			= mcf_gpio_free,
+			.direction_input	= mcf_gpio_direction_input,
+			.direction_output	= mcf_gpio_direction_output,
+			.get			= mcf_gpio_get_value,
+			.set			= mcf_gpio_set_value_fast,
+			.base			= 144,
+			.ngpio			= 4,
+		},
+		.pddr				= MCFGPIO_PDDR_UARTH,
+		.podr				= MCFGPIO_PODR_UARTH,
+		.ppdr				= MCFGPIO_PPDSDR_UARTH,
+		.setr				= MCFGPIO_PPDSDR_UARTH,
+		.clrr				= MCFGPIO_PCLRR_UARTH,
+	},
+#elif defined(CONFIG_M528x)
+	{
+		.gpio_chip			= {
+			.label			= "NQ",
+			.request		= mcf_gpio_request,
+			.free			= mcf_gpio_free,
+			.direction_input	= mcf_gpio_direction_input,
+			.direction_output	= mcf_gpio_direction_output,
+			.get			= mcf_gpio_get_value,
+			.set			= mcf_gpio_set_value,
+			.base			= 1,
+			.ngpio			= 8,
+		},
+		.pddr				= MCFEPORT_EPDDR,
+		.podr				= MCFEPORT_EPDR,
+		.ppdr				= MCFEPORT_EPPDR,
+	},
+	{
+		.gpio_chip			= {
+			.label			= "TA",
+			.request		= mcf_gpio_request,
+			.free			= mcf_gpio_free,
+			.direction_input	= mcf_gpio_direction_input,
+			.direction_output	= mcf_gpio_direction_output,
+			.get			= mcf_gpio_get_value,
+			.set			= mcf_gpio_set_value_fast,
+			.base			= 8,
+			.ngpio			= 4,
+		},
+		.pddr				= MCFGPTA_GPTDDR,
+		.podr				= MCFGPTA_GPTPORT,
+		.ppdr				= MCFGPTB_GPTPORT,
+	},
+	{
+		.gpio_chip			= {
+			.label			= "TB",
+			.request		= mcf_gpio_request,
+			.free			= mcf_gpio_free,
+			.direction_input	= mcf_gpio_direction_input,
+			.direction_output	= mcf_gpio_direction_output,
+			.get			= mcf_gpio_get_value,
+			.set			= mcf_gpio_set_value_fast,
+			.base			= 16,
+			.ngpio			= 4,
+		},
+		.pddr				= MCFGPTB_GPTDDR,
+		.podr				= MCFGPTB_GPTPORT,
+		.ppdr				= MCFGPTB_GPTPORT,
+	},
+	{
+		.gpio_chip			= {
+			.label			= "QA",
+			.request		= mcf_gpio_request,
+			.free			= mcf_gpio_free,
+			.direction_input	= mcf_gpio_direction_input,
+			.direction_output	= mcf_gpio_direction_output,
+			.get			= mcf_gpio_get_value,
+			.set			= mcf_gpio_set_value_fast,
+			.base			= 24,
+			.ngpio			= 4,
+		},
+		.pddr				= MCFQADC_DDRQA,
+		.podr				= MCFQADC_PORTQA,
+		.ppdr				= MCFQADC_PORTQA,
+	},
+	{
+		.gpio_chip			= {
+			.label			= "QB",
+			.request		= mcf_gpio_request,
+			.free			= mcf_gpio_free,
+			.direction_input	= mcf_gpio_direction_input,
+			.direction_output	= mcf_gpio_direction_output,
+			.get			= mcf_gpio_get_value,
+			.set			= mcf_gpio_set_value_fast,
+			.base			= 32,
+			.ngpio			= 4,
+		},
+		.pddr				= MCFQADC_DDRQB,
+		.podr				= MCFQADC_PORTQB,
+		.ppdr				= MCFQADC_PORTQB,
+	},
+	{
+		.gpio_chip			= {
+			.label			= "A",
+			.request		= mcf_gpio_request,
+			.free			= mcf_gpio_free,
+			.direction_input	= mcf_gpio_direction_input,
+			.direction_output	= mcf_gpio_direction_output,
+			.get			= mcf_gpio_get_value,
+			.set			= mcf_gpio_set_value_fast,
+			.base			= 40,
+			.ngpio			= 8,
+		},
+		.pddr				= MCFGPIO_DDRA,
+		.podr				= MCFGPIO_PORTA,
+		.ppdr				= MCFGPIO_PORTAP,
+		.setr				= MCFGPIO_SETA,
+		.clrr				= MCFGPIO_CLRA,
+	},
+	{
+		.gpio_chip			= {
+			.label			= "B",
+			.request		= mcf_gpio_request,
+			.free			= mcf_gpio_free,
+			.direction_input	= mcf_gpio_direction_input,
+			.direction_output	= mcf_gpio_direction_output,
+			.get			= mcf_gpio_get_value,
+			.set			= mcf_gpio_set_value_fast,
+			.base			= 48,
+			.ngpio			= 8,
+		},
+		.pddr				= MCFGPIO_DDRB,
+		.podr				= MCFGPIO_PORTB,
+		.ppdr				= MCFGPIO_PORTBP,
+		.setr				= MCFGPIO_SETB,
+		.clrr				= MCFGPIO_CLRB,
+	},
+	{
+		.gpio_chip			= {
+			.label			= "C",
+			.request		= mcf_gpio_request,
+			.free			= mcf_gpio_free,
+			.direction_input	= mcf_gpio_direction_input,
+			.direction_output	= mcf_gpio_direction_output,
+			.get			= mcf_gpio_get_value,
+			.set			= mcf_gpio_set_value_fast,
+			.base			= 56,
+			.ngpio			= 8,
+		},
+		.pddr				= MCFGPIO_DDRC,
+		.podr				= MCFGPIO_PORTC,
+		.ppdr				= MCFGPIO_PORTCP,
+		.setr				= MCFGPIO_SETC,
+		.clrr				= MCFGPIO_CLRC,
+	},
+	{
+		.gpio_chip			= {
+			.label			= "D",
+			.request		= mcf_gpio_request,
+			.free			= mcf_gpio_free,
+			.direction_input	= mcf_gpio_direction_input,
+			.direction_output	= mcf_gpio_direction_output,
+			.get			= mcf_gpio_get_value,
+			.set			= mcf_gpio_set_value_fast,
+			.base			= 64,
+			.ngpio			= 8,
+		},
+		.pddr				= MCFGPIO_DDRD,
+		.podr				= MCFGPIO_PORTD,
+		.ppdr				= MCFGPIO_PORTDP,
+		.setr				= MCFGPIO_SETD,
+		.clrr				= MCFGPIO_CLRD,
+	},
+	{
+		.gpio_chip			= {
+			.label			= "E",
+			.request		= mcf_gpio_request,
+			.free			= mcf_gpio_free,
+			.direction_input	= mcf_gpio_direction_input,
+			.direction_output	= mcf_gpio_direction_output,
+			.get			= mcf_gpio_get_value,
+			.set			= mcf_gpio_set_value_fast,
+			.base			= 72,
+			.ngpio			= 8,
+		},
+		.pddr				= MCFGPIO_DDRE,
+		.podr				= MCFGPIO_PORTE,
+		.ppdr				= MCFGPIO_PORTEP,
+		.setr				= MCFGPIO_SETE,
+		.clrr				= MCFGPIO_CLRE,
+	},
+	{
+		.gpio_chip			= {
+			.label			= "F",
+			.request		= mcf_gpio_request,
+			.free			= mcf_gpio_free,
+			.direction_input	= mcf_gpio_direction_input,
+			.direction_output	= mcf_gpio_direction_output,
+			.get			= mcf_gpio_get_value,
+			.set			= mcf_gpio_set_value_fast,
+			.base			= 80,
+			.ngpio			= 8,
+		},
+		.pddr				= MCFGPIO_DDRF,
+		.podr				= MCFGPIO_PORTF,
+		.ppdr				= MCFGPIO_PORTFP,
+		.setr				= MCFGPIO_SETF,
+		.clrr				= MCFGPIO_CLRF,
+	},
+	{
+		.gpio_chip			= {
+			.label			= "G",
+			.request		= mcf_gpio_request,
+			.free			= mcf_gpio_free,
+			.direction_input	= mcf_gpio_direction_input,
+			.direction_output	= mcf_gpio_direction_output,
+			.get			= mcf_gpio_get_value,
+			.set			= mcf_gpio_set_value_fast,
+			.base			= 88,
+			.ngpio			= 8,
+		},
+		.pddr				= MCFGPIO_DDRG,
+		.podr				= MCFGPIO_PORTG,
+		.ppdr				= MCFGPIO_PORTGP,
+		.setr				= MCFGPIO_SETG,
+		.clrr				= MCFGPIO_CLRG,
+	},
+	{
+		.gpio_chip			= {
+			.label			= "H",
+			.request		= mcf_gpio_request,
+			.free			= mcf_gpio_free,
+			.direction_input	= mcf_gpio_direction_input,
+			.direction_output	= mcf_gpio_direction_output,
+			.get			= mcf_gpio_get_value,
+			.set			= mcf_gpio_set_value_fast,
+			.base			= 96,
+			.ngpio			= 8,
+		},
+		.pddr				= MCFGPIO_DDRH,
+		.podr				= MCFGPIO_PORTH,
+		.ppdr				= MCFGPIO_PORTHP,
+		.setr				= MCFGPIO_SETH,
+		.clrr				= MCFGPIO_CLRH,
+	},
+	{
+		.gpio_chip			= {
+			.label			= "J",
+			.request		= mcf_gpio_request,
+			.free			= mcf_gpio_free,
+			.direction_input	= mcf_gpio_direction_input,
+			.direction_output	= mcf_gpio_direction_output,
+			.get			= mcf_gpio_get_value,
+			.set			= mcf_gpio_set_value_fast,
+			.base			= 104,
+			.ngpio			= 8,
+		},
+		.pddr				= MCFGPIO_DDRJ,
+		.podr				= MCFGPIO_PORTJ,
+		.ppdr				= MCFGPIO_PORTJP,
+		.setr				= MCFGPIO_SETJ,
+		.clrr				= MCFGPIO_CLRJ,
+	},
+	{
+		.gpio_chip			= {
+			.label			= "DD",
+			.request		= mcf_gpio_request,
+			.free			= mcf_gpio_free,
+			.direction_input	= mcf_gpio_direction_input,
+			.direction_output	= mcf_gpio_direction_output,
+			.get			= mcf_gpio_get_value,
+			.set			= mcf_gpio_set_value_fast,
+			.base			= 112,
+			.ngpio			= 8,
+		},
+		.pddr				= MCFGPIO_DDRDD,
+		.podr				= MCFGPIO_PORTDD,
+		.ppdr				= MCFGPIO_PORTDDP,
+		.setr				= MCFGPIO_SETDD,
+		.clrr				= MCFGPIO_CLRDD,
+	},
+	{
+		.gpio_chip			= {
+			.label			= "EH",
+			.request		= mcf_gpio_request,
+			.free			= mcf_gpio_free,
+			.direction_input	= mcf_gpio_direction_input,
+			.direction_output	= mcf_gpio_direction_output,
+			.get			= mcf_gpio_get_value,
+			.set			= mcf_gpio_set_value_fast,
+			.base			= 120,
+			.ngpio			= 8,
+		},
+		.pddr				= MCFGPIO_DDREH,
+		.podr				= MCFGPIO_PORTEH,
+		.ppdr				= MCFGPIO_PORTEHP,
+		.setr				= MCFGPIO_SETEH,
+		.clrr				= MCFGPIO_CLREH,
+	},
+	{
+		.gpio_chip			= {
+			.label			= "EL",
+			.request		= mcf_gpio_request,
+			.free			= mcf_gpio_free,
+			.direction_input	= mcf_gpio_direction_input,
+			.direction_output	= mcf_gpio_direction_output,
+			.get			= mcf_gpio_get_value,
+			.set			= mcf_gpio_set_value_fast,
+			.base			= 128,
+			.ngpio			= 8,
+		},
+		.pddr				= MCFGPIO_DDREL,
+		.podr				= MCFGPIO_PORTEL,
+		.ppdr				= MCFGPIO_PORTELP,
+		.setr				= MCFGPIO_SETEL,
+		.clrr				= MCFGPIO_CLREL,
+	},
+	{
+		.gpio_chip			= {
+			.label			= "AS",
+			.request		= mcf_gpio_request,
+			.free			= mcf_gpio_free,
+			.direction_input	= mcf_gpio_direction_input,
+			.direction_output	= mcf_gpio_direction_output,
+			.get			= mcf_gpio_get_value,
+			.set			= mcf_gpio_set_value_fast,
+			.base			= 136,
+			.ngpio			= 6,
+		},
+		.pddr				= MCFGPIO_DDRAS,
+		.podr				= MCFGPIO_PORTAS,
+		.ppdr				= MCFGPIO_PORTASP,
+		.setr				= MCFGPIO_SETAS,
+		.clrr				= MCFGPIO_CLRAS,
+	},
+	{
+		.gpio_chip			= {
+			.label			= "QS",
+			.request		= mcf_gpio_request,
+			.free			= mcf_gpio_free,
+			.direction_input	= mcf_gpio_direction_input,
+			.direction_output	= mcf_gpio_direction_output,
+			.get			= mcf_gpio_get_value,
+			.set			= mcf_gpio_set_value_fast,
+			.base			= 144,
+			.ngpio			= 7,
+		},
+		.pddr				= MCFGPIO_DDRQS,
+		.podr				= MCFGPIO_PORTQS,
+		.ppdr				= MCFGPIO_PORTQSP,
+		.setr				= MCFGPIO_SETQS,
+		.clrr				= MCFGPIO_CLRQS,
+	},
+	{
+		.gpio_chip			= {
+			.label			= "SD",
+			.request		= mcf_gpio_request,
+			.free			= mcf_gpio_free,
+			.direction_input	= mcf_gpio_direction_input,
+			.direction_output	= mcf_gpio_direction_output,
+			.get			= mcf_gpio_get_value,
+			.set			= mcf_gpio_set_value_fast,
+			.base			= 152,
+			.ngpio			= 6,
+		},
+		.pddr				= MCFGPIO_DDRSD,
+		.podr				= MCFGPIO_PORTSD,
+		.ppdr				= MCFGPIO_PORTSDP,
+		.setr				= MCFGPIO_SETSD,
+		.clrr				= MCFGPIO_CLRSD,
+	},
+	{
+		.gpio_chip			= {
+			.label			= "TC",
+			.request		= mcf_gpio_request,
+			.free			= mcf_gpio_free,
+			.direction_input	= mcf_gpio_direction_input,
+			.direction_output	= mcf_gpio_direction_output,
+			.get			= mcf_gpio_get_value,
+			.set			= mcf_gpio_set_value_fast,
+			.base			= 160,
+			.ngpio			= 4,
+		},
+		.pddr				= MCFGPIO_DDRTC,
+		.podr				= MCFGPIO_PORTTC,
+		.ppdr				= MCFGPIO_PORTTCP,
+		.setr				= MCFGPIO_SETTC,
+		.clrr				= MCFGPIO_CLRTC,
+	},
+	{
+		.gpio_chip			= {
+			.label			= "TD",
+			.request		= mcf_gpio_request,
+			.free			= mcf_gpio_free,
+			.direction_input	= mcf_gpio_direction_input,
+			.direction_output	= mcf_gpio_direction_output,
+			.get			= mcf_gpio_get_value,
+			.set			= mcf_gpio_set_value_fast,
+			.base			= 168,
+			.ngpio			= 4,
+		},
+		.pddr				= MCFGPIO_DDRTD,
+		.podr				= MCFGPIO_PORTTD,
+		.ppdr				= MCFGPIO_PORTTDP,
+		.setr				= MCFGPIO_SETTD,
+		.clrr				= MCFGPIO_CLRTD,
+	},
+	{
+		.gpio_chip			= {
+			.label			= "UA",
+			.request		= mcf_gpio_request,
+			.free			= mcf_gpio_free,
+			.direction_input	= mcf_gpio_direction_input,
+			.direction_output	= mcf_gpio_direction_output,
+			.get			= mcf_gpio_get_value,
+			.set			= mcf_gpio_set_value_fast,
+			.base			= 176,
+			.ngpio			= 4,
+		},
+		.pddr				= MCFGPIO_DDRUA,
+		.podr				= MCFGPIO_PORTUA,
+		.ppdr				= MCFGPIO_PORTUAP,
+		.setr				= MCFGPIO_SETUA,
+		.clrr				= MCFGPIO_CLRUA,
+	},
+#elif defined(CONFIG_M5307) || defined(CONFIG_M5407)
+	{
+		.gpio_chip			= {
+			.label			= "PP",
+			.request		= mcf_gpio_request,
+			.free			= mcf_gpio_free,
+			.direction_input	= mcf_gpio_direction_input,
+			.direction_output	= mcf_gpio_direction_output,
+			.get			= mcf_gpio_get_value,
+			.set			= mcf_gpio_set_value,
+			.ngpio			= 16,
+		},
+		.pddr				= MCFSIM_PADDR,
+		.podr				= MCFSIM_PADAT,
+		.ppdr				= MCFSIM_PADAT,
+	},
+#elif defined(CONFIG_M532x)
+	{
+		.gpio_chip			= {
+			.label			= "PIRQ",
+			.request		= mcf_gpio_request,
+			.free			= mcf_gpio_free,
+			.direction_input	= mcf_gpio_direction_input,
+			.direction_output	= mcf_gpio_direction_output,
+			.get			= mcf_gpio_get_value,
+			.set			= mcf_gpio_set_value,
+			.ngpio			= 8,
+		},
+		.pddr				= MCFEPORT_EPDDR,
+		.podr				= MCFEPORT_EPDR,
+		.ppdr				= MCFEPORT_EPPDR,
+	},
+	{
+		.gpio_chip			= {
+			.label			= "FECH",
+			.request		= mcf_gpio_request,
+			.free			= mcf_gpio_free,
+			.direction_input	= mcf_gpio_direction_input,
+			.direction_output	= mcf_gpio_direction_output,
+			.get			= mcf_gpio_get_value,
+			.set			= mcf_gpio_set_value_fast,
+			.base			= 8,
+			.ngpio			= 8,
+		},
+		.pddr				= MCFGPIO_PDDR_FECH,
+		.podr				= MCFGPIO_PODR_FECH,
+		.ppdr				= MCFGPIO_PPDSDR_FECH,
+		.setr				= MCFGPIO_PPDSDR_FECH,
+		.clrr				= MCFGPIO_PCLRR_FECH,
+	},
+	{
+		.gpio_chip			= {
+			.label			= "FECL",
+			.request		= mcf_gpio_request,
+			.free			= mcf_gpio_free,
+			.direction_input	= mcf_gpio_direction_input,
+			.direction_output	= mcf_gpio_direction_output,
+			.get			= mcf_gpio_get_value,
+			.set			= mcf_gpio_set_value_fast,
+			.base			= 16,
+			.ngpio			= 8,
+		},
+		.pddr				= MCFGPIO_PDDR_FECL,
+		.podr				= MCFGPIO_PODR_FECL,
+		.ppdr				= MCFGPIO_PPDSDR_FECL,
+		.setr				= MCFGPIO_PPDSDR_FECL,
+		.clrr				= MCFGPIO_PCLRR_FECL,
+	},
+	{
+		.gpio_chip			= {
+			.label			= "SSI",
+			.request		= mcf_gpio_request,
+			.free			= mcf_gpio_free,
+			.direction_input	= mcf_gpio_direction_input,
+			.direction_output	= mcf_gpio_direction_output,
+			.get			= mcf_gpio_get_value,
+			.set			= mcf_gpio_set_value_fast,
+			.base			= 24,
+			.ngpio			= 5,
+		},
+		.pddr				= MCFGPIO_PDDR_SSI,
+		.podr				= MCFGPIO_PODR_SSI,
+		.ppdr				= MCFGPIO_PPDSDR_SSI,
+		.setr				= MCFGPIO_PPDSDR_SSI,
+		.clrr				= MCFGPIO_PCLRR_SSI,
+	},
+	{
+		.gpio_chip			= {
+			.label			= "BUSCTL",
+			.request		= mcf_gpio_request,
+			.free			= mcf_gpio_free,
+			.direction_input	= mcf_gpio_direction_input,
+			.direction_output	= mcf_gpio_direction_output,
+			.get			= mcf_gpio_get_value,
+			.set			= mcf_gpio_set_value_fast,
+			.base			= 32,
+			.ngpio			= 4,
+		},
+		.pddr				= MCFGPIO_PDDR_BUSCTL,
+		.podr				= MCFGPIO_PODR_BUSCTL,
+		.ppdr				= MCFGPIO_PPDSDR_BUSCTL,
+		.setr				= MCFGPIO_PPDSDR_BUSCTL,
+		.clrr				= MCFGPIO_PCLRR_BUSCTL,
+	},
+	{
+		.gpio_chip			= {
+			.label			= "BE",
+			.request		= mcf_gpio_request,
+			.free			= mcf_gpio_free,
+			.direction_input	= mcf_gpio_direction_input,
+			.direction_output	= mcf_gpio_direction_output,
+			.get			= mcf_gpio_get_value,
+			.set			= mcf_gpio_set_value_fast,
+			.base			= 40,
+			.ngpio			= 4,
+		},
+		.pddr				= MCFGPIO_PDDR_BE,
+		.podr				= MCFGPIO_PODR_BE,
+		.ppdr				= MCFGPIO_PPDSDR_BE,
+		.setr				= MCFGPIO_PPDSDR_BE,
+		.clrr				= MCFGPIO_PCLRR_BE,
+	},
+	{
+		.gpio_chip			= {
+			.label			= "CS",
+			.request		= mcf_gpio_request,
+			.free			= mcf_gpio_free,
+			.direction_input	= mcf_gpio_direction_input,
+			.direction_output	= mcf_gpio_direction_output,
+			.get			= mcf_gpio_get_value,
+			.set			= mcf_gpio_set_value_fast,
+			.base			= 49,
+			.ngpio			= 5,
+		},
+		.pddr				= MCFGPIO_PDDR_CS,
+		.podr				= MCFGPIO_PODR_CS,
+		.ppdr				= MCFGPIO_PPDSDR_CS,
+		.setr				= MCFGPIO_PPDSDR_CS,
+		.clrr				= MCFGPIO_PCLRR_CS,
+	},
+	{
+		.gpio_chip			= {
+			.label			= "PWM",
+			.request		= mcf_gpio_request,
+			.free			= mcf_gpio_free,
+			.direction_input	= mcf_gpio_direction_input,
+			.direction_output	= mcf_gpio_direction_output,
+			.get			= mcf_gpio_get_value,
+			.set			= mcf_gpio_set_value_fast,
+			.base			= 58,
+			.ngpio			= 4,
+		},
+		.pddr				= MCFGPIO_PDDR_PWM,
+		.podr				= MCFGPIO_PODR_PWM,
+		.ppdr				= MCFGPIO_PPDSDR_PWM,
+		.setr				= MCFGPIO_PPDSDR_PWM,
+		.clrr				= MCFGPIO_PCLRR_PWM,
+	},
+	{
+		.gpio_chip			= {
+			.label			= "FECI2C",
+			.request		= mcf_gpio_request,
+			.free			= mcf_gpio_free,
+			.direction_input	= mcf_gpio_direction_input,
+			.direction_output	= mcf_gpio_direction_output,
+			.get			= mcf_gpio_get_value,
+			.set			= mcf_gpio_set_value_fast,
+			.base			= 64,
+			.ngpio			= 4,
+		},
+		.pddr				= MCFGPIO_PDDR_FECI2C,
+		.podr				= MCFGPIO_PODR_FECI2C,
+		.ppdr				= MCFGPIO_PPDSDR_FECI2C,
+		.setr				= MCFGPIO_PPDSDR_FECI2C,
+		.clrr				= MCFGPIO_PCLRR_FECI2C,
+	},
+	{
+		.gpio_chip			= {
+			.label			= "UART",
+			.request		= mcf_gpio_request,
+			.free			= mcf_gpio_free,
+			.direction_input	= mcf_gpio_direction_input,
+			.direction_output	= mcf_gpio_direction_output,
+			.get			= mcf_gpio_get_value,
+			.set			= mcf_gpio_set_value_fast,
+			.base			= 72,
+			.ngpio			= 8,
+		},
+		.pddr				= MCFGPIO_PDDR_UART,
+		.podr				= MCFGPIO_PODR_UART,
+		.ppdr				= MCFGPIO_PPDSDR_UART,
+		.setr				= MCFGPIO_PPDSDR_UART,
+		.clrr				= MCFGPIO_PCLRR_UART,
+	},
+	{
+		.gpio_chip			= {
+			.label			= "QSPI",
+			.request		= mcf_gpio_request,
+			.free			= mcf_gpio_free,
+			.direction_input	= mcf_gpio_direction_input,
+			.direction_output	= mcf_gpio_direction_output,
+			.get			= mcf_gpio_get_value,
+			.set			= mcf_gpio_set_value_fast,
+			.base			= 80,
+			.ngpio			= 6,
+		},
+		.pddr				= MCFGPIO_PDDR_QSPI,
+		.podr				= MCFGPIO_PODR_QSPI,
+		.ppdr				= MCFGPIO_PPDSDR_QSPI,
+		.setr				= MCFGPIO_PPDSDR_QSPI,
+		.clrr				= MCFGPIO_PCLRR_QSPI,
+	},
+	{
+		.gpio_chip			= {
+			.label			= "TIMER",
+			.request		= mcf_gpio_request,
+			.free			= mcf_gpio_free,
+			.direction_input	= mcf_gpio_direction_input,
+			.direction_output	= mcf_gpio_direction_output,
+			.get			= mcf_gpio_get_value,
+			.set			= mcf_gpio_set_value_fast,
+			.base			= 88,
+			.ngpio			= 4,
+		},
+		.pddr				= MCFGPIO_PDDR_TIMER,
+		.podr				= MCFGPIO_PODR_TIMER,
+		.ppdr				= MCFGPIO_PPDSDR_TIMER,
+		.setr				= MCFGPIO_PPDSDR_TIMER,
+		.clrr				= MCFGPIO_PCLRR_TIMER,
+	},
+	{
+		.gpio_chip			= {
+			.label			= "LCDDATAH",
+			.request		= mcf_gpio_request,
+			.free			= mcf_gpio_free,
+			.direction_input	= mcf_gpio_direction_input,
+			.direction_output	= mcf_gpio_direction_output,
+			.get			= mcf_gpio_get_value,
+			.set			= mcf_gpio_set_value_fast,
+			.base			= 96,
+			.ngpio			= 2,
+		},
+		.pddr				= MCFGPIO_PDDR_LCDDATAH,
+		.podr				= MCFGPIO_PODR_LCDDATAH,
+		.ppdr				= MCFGPIO_PPDSDR_LCDDATAH,
+		.setr				= MCFGPIO_PPDSDR_LCDDATAH,
+		.clrr				= MCFGPIO_PCLRR_LCDDATAH,
+	},
+	{
+		.gpio_chip			= {
+			.label			= "LCDDATAM",
+			.request		= mcf_gpio_request,
+			.free			= mcf_gpio_free,
+			.direction_input	= mcf_gpio_direction_input,
+			.direction_output	= mcf_gpio_direction_output,
+			.get			= mcf_gpio_get_value,
+			.set			= mcf_gpio_set_value_fast,
+			.base			= 104,
+			.ngpio			= 8,
+		},
+		.pddr				= MCFGPIO_PDDR_LCDDATAM,
+		.podr				= MCFGPIO_PODR_LCDDATAM,
+		.ppdr				= MCFGPIO_PPDSDR_LCDDATAM,
+		.setr				= MCFGPIO_PPDSDR_LCDDATAM,
+		.clrr				= MCFGPIO_PCLRR_LCDDATAM,
+	},
+	{
+		.gpio_chip			= {
+			.label			= "LCDDATAL",
+			.request		= mcf_gpio_request,
+			.free			= mcf_gpio_free,
+			.direction_input	= mcf_gpio_direction_input,
+			.direction_output	= mcf_gpio_direction_output,
+			.get			= mcf_gpio_get_value,
+			.set			= mcf_gpio_set_value_fast,
+			.base			= 112,
+			.ngpio			= 8,
+		},
+		.pddr				= MCFGPIO_PDDR_LCDDATAL,
+		.podr				= MCFGPIO_PODR_LCDDATAL,
+		.ppdr				= MCFGPIO_PPDSDR_LCDDATAL,
+		.setr				= MCFGPIO_PPDSDR_LCDDATAL,
+		.clrr				= MCFGPIO_PCLRR_LCDDATAL,
+	},
+	{
+		.gpio_chip			= {
+			.label			= "LCDCTLH",
+			.request		= mcf_gpio_request,
+			.free			= mcf_gpio_free,
+			.direction_input	= mcf_gpio_direction_input,
+			.direction_output	= mcf_gpio_direction_output,
+			.get			= mcf_gpio_get_value,
+			.set			= mcf_gpio_set_value_fast,
+			.base			= 120,
+			.ngpio			= 1,
+		},
+		.pddr				= MCFGPIO_PDDR_LCDCTLH,
+		.podr				= MCFGPIO_PODR_LCDCTLH,
+		.ppdr				= MCFGPIO_PPDSDR_LCDCTLH,
+		.setr				= MCFGPIO_PPDSDR_LCDCTLH,
+		.clrr				= MCFGPIO_PCLRR_LCDCTLH,
+	},
+	{
+		.gpio_chip			= {
+			.label			= "LCDCTLL",
+			.request		= mcf_gpio_request,
+			.free			= mcf_gpio_free,
+			.direction_input	= mcf_gpio_direction_input,
+			.direction_output	= mcf_gpio_direction_output,
+			.get			= mcf_gpio_get_value,
+			.set			= mcf_gpio_set_value_fast,
+			.base			= 128,
+			.ngpio			= 8,
+		},
+		.pddr				= MCFGPIO_PDDR_LCDCTLL,
+		.podr				= MCFGPIO_PODR_LCDCTLL,
+		.ppdr				= MCFGPIO_PPDSDR_LCDCTLL,
+		.setr				= MCFGPIO_PPDSDR_LCDCTLL,
+		.clrr				= MCFGPIO_PCLRR_LCDCTLL,
+	},
+#endif
+};
+
+struct sysdev_class mcf_gpio_sysclass = {
+	.name	= "gpio",
+};
+
+static int __init mcf_gpio_sysinit(void)
+{
+	unsigned i = 0;
+	while (i < ARRAY_SIZE(mcf_gpio_chips))
+		(void)gpiochip_add((struct gpio_chip *)&mcf_gpio_chips[i++]);
+
+	return sysdev_class_register(&mcf_gpio_sysclass);
+}
+
+core_initcall(mcf_gpio_sysinit);
