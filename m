Return-Path: <linux-kernel-owner+w=401wt.eu-S1756565AbXL2EGR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756565AbXL2EGR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2007 23:06:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755126AbXL2EEn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Dec 2007 23:04:43 -0500
Received: from smtp123.sbc.mail.sp1.yahoo.com ([69.147.64.96]:21917 "HELO
	smtp123.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754804AbXL2EEl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2007 23:04:41 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Disposition:Message-Id:Content-Type:Content-Transfer-Encoding;
  b=OnTLbEqwBJ/776uPMVX8uRRW5twRkUrzLrUpA9hAl16bcp52Iirkvr4WmaeSsvQqYcryCKkar9s+HimyA3TEZAg/YjMtW0BvJtNqjrER7kzHHDzXhSPq56j87wG9hoFry4XsyDYZFwyk8y/YQH1o2Ea/z9k1KfbvCNNfuH86XNk=  ;
X-YMail-OSG: y7.5wHEVM1kguisBANsQAcsV5zt0K1zTMAjpS0uAhaGLf4DP_E8mR5S8oAI8cRZeQfQDRWM4uw--
From: David Brownell <david-b@pacbell.net>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: [patch 2.6.24-rc6-mm 4/9] gpiolib: avr32 at32ap platform support
Date: Fri, 28 Dec 2007 19:56:32 -0800
User-Agent: KMail/1.9.6
Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>
References: <200712281927.32575.david-b@pacbell.net>
In-Reply-To: <200712281927.32575.david-b@pacbell.net>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200712281956.33051.david-b@pacbell.net>
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Brownell <dbrownell@users.sourceforge.net>

Teach AVR32 to use the "GPIO Library" when exposing its GPIOs, so that
signals on external chips (like GPIO expanders) can easily be used.

This mostly just reorganizes some existing logic, with two minor changes
in behavior:

 - The PSR registers are used instead of the previous "gpio_mask" values,
   matching AT91 behavior and removing some duplication between that role
   and that of "pinmux_mask".

 - NR_IRQs grew to acommodate a bank of external GPIOs.  Eventually this
   number should probably become a board-specific config option.

There's a debugfs dump of status for the built-in GPIOs, showing which
pins have deglitching, pullups, or open drain drive enabled, as well as
the ID string used when requesting each IRQ.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>
---
 arch/avr32/Kconfig                         |    1 
 arch/avr32/mach-at32ap/pio.c               |  172 +++++++++++++++--------------
 arch/avr32/mach-at32ap/pio.h               |    2 
 include/asm-avr32/arch-at32ap/at32ap7000.h |    2 
 include/asm-avr32/arch-at32ap/gpio.h       |   36 ++++--
 include/asm-avr32/arch-at32ap/irq.h        |    4 
 6 files changed, 122 insertions(+), 95 deletions(-)

--- at91.orig/arch/avr32/Kconfig
+++ at91/arch/avr32/Kconfig
@@ -80,6 +80,7 @@ config PLATFORM_AT32AP
 	select SUBARCH_AVR32B
 	select MMU
 	select PERFORMANCE_COUNTERS
+	select GPIO_LIB
 
 choice
 	prompt "AVR32 CPU type"
--- at91.orig/arch/avr32/mach-at32ap/pio.c
+++ at91/arch/avr32/mach-at32ap/pio.c
@@ -24,11 +24,11 @@
 #define MAX_NR_PIO_DEVICES		8
 
 struct pio_device {
+	struct gpio_chip chip;
 	void __iomem *regs;
 	const struct platform_device *pdev;
 	struct clk *clk;
 	u32 pinmux_mask;
-	u32 gpio_mask;
 	char name[8];
 };
 
@@ -64,7 +64,8 @@ void __init at32_select_periph(unsigned 
 		goto fail;
 	}
 
-	if (unlikely(test_and_set_bit(pin_index, &pio->pinmux_mask))) {
+	if (unlikely(test_and_set_bit(pin_index, &pio->pinmux_mask)
+			 || gpiochip_is_requested(&pio->chip, pin_index))) {
 		printk("%s: pin %u is busy\n", pio->name, pin_index);
 		goto fail;
 	}
@@ -79,9 +80,6 @@ void __init at32_select_periph(unsigned 
 	if (!(flags & AT32_GPIOF_PULLUP))
 		pio_writel(pio, PUDR, mask);
 
-	/* gpio_request NOT allowed */
-	set_bit(pin_index, &pio->gpio_mask);
-
 	return;
 
 fail:
@@ -130,9 +128,6 @@ void __init at32_select_gpio(unsigned in
 
 	pio_writel(pio, PER, mask);
 
-	/* gpio_request now allowed */
-	clear_bit(pin_index, &pio->gpio_mask);
-
 	return;
 
 fail:
@@ -166,96 +161,50 @@ fail:
 
 /* GPIO API */
 
-int gpio_request(unsigned int gpio, const char *label)
+static int direction_input(struct gpio_chip *chip, unsigned offset)
 {
-	struct pio_device *pio;
-	unsigned int pin;
+	struct pio_device *pio = container_of(chip, struct pio_device, chip);
+	u32 mask = 1 << offset;
 
-	pio = gpio_to_pio(gpio);
-	if (!pio)
-		return -ENODEV;
-
-	pin = gpio & 0x1f;
-	if (test_and_set_bit(pin, &pio->gpio_mask))
-		return -EBUSY;
+	if (!(pio_readl(pio, PSR) & mask))
+		return -EINVAL;
 
+	pio_writel(pio, ODR, mask);
 	return 0;
 }
-EXPORT_SYMBOL(gpio_request);
 
-void gpio_free(unsigned int gpio)
+static int gpio_get(struct gpio_chip *chip, unsigned offset)
 {
-	struct pio_device *pio;
-	unsigned int pin;
-
-	pio = gpio_to_pio(gpio);
-	if (!pio) {
-		printk(KERN_ERR
-		       "gpio: attempted to free invalid pin %u\n", gpio);
-		return;
-	}
+	struct pio_device *pio = container_of(chip, struct pio_device, chip);
 
-	pin = gpio & 0x1f;
-	if (!test_and_clear_bit(pin, &pio->gpio_mask))
-		printk(KERN_ERR "gpio: freeing free or non-gpio pin %s-%u\n",
-		       pio->name, pin);
+	return (pio_readl(pio, PDSR) >> offset) & 1;
 }
-EXPORT_SYMBOL(gpio_free);
 
-int gpio_direction_input(unsigned int gpio)
-{
-	struct pio_device *pio;
-	unsigned int pin;
-
-	pio = gpio_to_pio(gpio);
-	if (!pio)
-		return -ENODEV;
+static void gpio_set(struct gpio_chip *chip, unsigned offset, int value);
 
-	pin = gpio & 0x1f;
-	pio_writel(pio, ODR, 1 << pin);
-
-	return 0;
-}
-EXPORT_SYMBOL(gpio_direction_input);
-
-int gpio_direction_output(unsigned int gpio, int value)
+static int direction_output(struct gpio_chip *chip, unsigned offset, int value)
 {
-	struct pio_device *pio;
-	unsigned int pin;
-
-	pio = gpio_to_pio(gpio);
-	if (!pio)
-		return -ENODEV;
+	struct pio_device *pio = container_of(chip, struct pio_device, chip);
+	u32 mask = 1 << offset;
 
-	gpio_set_value(gpio, value);
-
-	pin = gpio & 0x1f;
-	pio_writel(pio, OER, 1 << pin);
+	if (!(pio_readl(pio, PSR) & mask))
+		return -EINVAL;
 
+	gpio_set(chip, offset, value);
+	pio_writel(pio, OER, mask);
 	return 0;
 }
-EXPORT_SYMBOL(gpio_direction_output);
 
-int gpio_get_value(unsigned int gpio)
+static void gpio_set(struct gpio_chip *chip, unsigned offset, int value)
 {
-	struct pio_device *pio = &pio_dev[gpio >> 5];
+	struct pio_device *pio = container_of(chip, struct pio_device, chip);
+	u32 mask = 1 << offset;
 
-	return (pio_readl(pio, PDSR) >> (gpio & 0x1f)) & 1;
-}
-EXPORT_SYMBOL(gpio_get_value);
-
-void gpio_set_value(unsigned int gpio, int value)
-{
-	struct pio_device *pio = &pio_dev[gpio >> 5];
-	u32 mask;
-
-	mask = 1 << (gpio & 0x1f);
 	if (value)
 		pio_writel(pio, SODR, mask);
 	else
 		pio_writel(pio, CODR, mask);
 }
-EXPORT_SYMBOL(gpio_set_value);
 
 /*--------------------------------------------------------------------------*/
 
@@ -339,6 +288,63 @@ gpio_irq_setup(struct pio_device *pio, i
 
 /*--------------------------------------------------------------------------*/
 
+#ifdef CONFIG_DEBUG_FS
+
+#include <linux/seq_file.h>
+
+/*
+ * This shows more info than the generic gpio dump code:
+ * pullups, deglitching, open drain drive.
+ */
+static void pio_bank_show(struct seq_file *s, struct gpio_chip *chip)
+{
+	struct pio_device *pio = container_of(chip, struct pio_device, chip);
+	u32			psr, osr, imr, pdsr, pusr, ifsr, mdsr;
+	unsigned		i;
+	u32			mask;
+	char			bank;
+
+	psr = pio_readl(pio, PSR);
+	osr = pio_readl(pio, OSR);
+	imr = pio_readl(pio, IMR);
+	pdsr = pio_readl(pio, PDSR);
+	pusr = pio_readl(pio, PUSR);
+	ifsr = pio_readl(pio, IFSR);
+	mdsr = pio_readl(pio, MDSR);
+
+	bank = 'A' + pio->pdev->id;
+
+	for (i = 0, mask = 1; i < 32; i++, mask <<= 1) {
+		const char *label;
+
+		label = gpiochip_is_requested(chip, i);
+		if (!label)
+			continue;
+
+		seq_printf(s, " gpio-%-3d P%c%-2d (%-12s) %s %s %s",
+			chip->base + i, bank, i,
+			label,
+			(osr & mask) ? "out" : "in ",
+			(mask & pdsr) ? "hi" : "lo",
+			(mask & pusr) ? "  " : "up");
+		if (ifsr & mask)
+			seq_printf(s, " deglitch");
+		if ((osr & mdsr) & mask)
+			seq_printf(s, " open-drain");
+		if (imr & mask)
+			seq_printf(s, " irq-%d edge-both",
+				gpio_to_irq(chip->base + i));
+		seq_printf(s, "\n");
+	}
+}
+
+#else
+#define pio_bank_show	NULL
+#endif
+
+
+/*--------------------------------------------------------------------------*/
+
 static int __init pio_probe(struct platform_device *pdev)
 {
 	struct pio_device *pio = NULL;
@@ -349,6 +355,18 @@ static int __init pio_probe(struct platf
 	pio = &pio_dev[pdev->id];
 	BUG_ON(!pio->regs);
 
+	pio->chip.label = pio->name;
+	pio->chip.base = pdev->id * 32;
+	pio->chip.ngpio = 32;
+
+	pio->chip.direction_input = direction_input;
+	pio->chip.get = gpio_get;
+	pio->chip.direction_output = direction_output;
+	pio->chip.set = gpio_set;
+	pio->chip.dbg_show = pio_bank_show;
+
+	gpiochip_add(&pio->chip);
+
 	gpio_irq_setup(pio, irq, gpio_irq_base);
 
 	platform_set_drvdata(pdev, pio);
@@ -406,12 +424,6 @@ void __init at32_init_pio(struct platfor
 	pio->pdev = pdev;
 	pio->regs = ioremap(regs->start, regs->end - regs->start + 1);
 
-	/*
-	 * request_gpio() is only valid for pins that have been
-	 * explicitly configured as GPIO and not previously requested
-	 */
-	pio->gpio_mask = ~0UL;
-
 	/* start with irqs disabled and acked */
 	pio_writel(pio, IDR, ~0UL);
 	(void) pio_readl(pio, ISR);
--- at91.orig/arch/avr32/mach-at32ap/pio.h
+++ at91/arch/avr32/mach-at32ap/pio.h
@@ -19,7 +19,7 @@
 #define PIO_OSR                                0x0018
 #define PIO_IFER                               0x0020
 #define PIO_IFDR                               0x0024
-#define PIO_ISFR                               0x0028
+#define PIO_IFSR                               0x0028
 #define PIO_SODR                               0x0030
 #define PIO_CODR                               0x0034
 #define PIO_ODSR                               0x0038
--- at91.orig/include/asm-avr32/arch-at32ap/at32ap7000.h
+++ at91/include/asm-avr32/arch-at32ap/at32ap7000.h
@@ -13,8 +13,6 @@
 #define GPIO_PERIPH_A	0
 #define GPIO_PERIPH_B	1
 
-#define NR_GPIO_CONTROLLERS	4
-
 /*
  * Pin numbers identifying specific GPIO pins on the chip. They can
  * also be converted to IRQ numbers by passing them through
--- at91.orig/include/asm-avr32/arch-at32ap/gpio.h
+++ at91/include/asm-avr32/arch-at32ap/gpio.h
@@ -5,20 +5,36 @@
 #include <asm/irq.h>
 
 
-/* Arch-neutral GPIO API */
-int __must_check gpio_request(unsigned int gpio, const char *label);
-void gpio_free(unsigned int gpio);
-
-int gpio_direction_input(unsigned int gpio);
-int gpio_direction_output(unsigned int gpio, int value);
-int gpio_get_value(unsigned int gpio);
-void gpio_set_value(unsigned int gpio, int value);
+/* Some GPIO chips can manage IRQs; some can't.  The exact numbers can
+ * be changed if needed, but for the moment they're not configurable.
+ */
+#define ARCH_NR_GPIOS	(NR_GPIO_IRQS + 2 * 32)
+
+
+/* Arch-neutral GPIO API, supporting both "native" and external GPIOs. */
+#include <asm-generic/gpio.h>
+
+static inline int gpio_get_value(unsigned int gpio)
+{
+	return __gpio_get_value(gpio);
+}
+
+static inline void gpio_set_value(unsigned int gpio, int value)
+{
+	__gpio_set_value(gpio, value);
+}
+
+static inline int gpio_cansleep(unsigned int gpio)
+{
+	return __gpio_cansleep(gpio);
+}
 
-#include <asm-generic/gpio.h>		/* cansleep wrappers */
 
 static inline int gpio_to_irq(unsigned int gpio)
 {
-	return gpio + GPIO_IRQ_BASE;
+	if (gpio < NR_GPIO_IRQS)
+		return gpio + GPIO_IRQ_BASE;
+	return -EINVAL;
 }
 
 static inline int irq_to_gpio(unsigned int irq)
--- at91.orig/include/asm-avr32/arch-at32ap/irq.h
+++ at91/include/asm-avr32/arch-at32ap/irq.h
@@ -3,11 +3,11 @@
 
 #define EIM_IRQ_BASE	NR_INTERNAL_IRQS
 #define NR_EIM_IRQS	32
-
 #define AT32_EXTINT(n)	(EIM_IRQ_BASE + (n))
 
 #define GPIO_IRQ_BASE	(EIM_IRQ_BASE + NR_EIM_IRQS)
-#define NR_GPIO_IRQS	(5 * 32)
+#define NR_GPIO_CTLR	(5 /*internal*/ + 1 /*external*/)
+#define NR_GPIO_IRQS	(NR_GPIO_CTLR * 32)
 
 #define NR_IRQS		(GPIO_IRQ_BASE + NR_GPIO_IRQS)
 
