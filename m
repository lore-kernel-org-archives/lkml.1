Return-Path: <linux-kernel-owner+w=401wt.eu-S1757598AbXKITx3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757598AbXKITx3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 14:53:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756815AbXKITwx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 14:52:53 -0500
Received: from smtp107.sbc.mail.mud.yahoo.com ([68.142.198.206]:32907 "HELO
	smtp107.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756726AbXKITwt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 14:52:49 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=Sh/yYRgm96X2vidhKrzruyXmRCuhnvBl+SpFRRI6hgptXYO2hpLaAH8UmkY0IBt8Y/4Cuzubmnf/6aMfnPUB2vUb9kOxUs5/nEkaknOX1Mqwac0QIy74s9np3+igIBKNZKi3GooZSwcOhoptiALD8djE8Ex4wiZpPURbADYLwd0=  ;
X-YMail-OSG: 26xC_40VM1lx3RccLehjh9bFAEXinuFpGylaUUKXCoyBxgia67ONAtPj6lOz7mlJipb8QLTZEA--
From: David Brownell <david-b@pacbell.net>
To: Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: [patch 2.6.24-rc2 2/3] avr32 uses gpio_chip
Date: Fri, 9 Nov 2007 11:41:36 -0800
User-Agent: KMail/1.9.6
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711091141.36821.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Teach AVR32 to use the "GPIO Library" when exposing its GPIOs, so that
signals on external chips (like GPIO expanders) can easily be used.

This mostly reorganizes some existing logic, with two minor changes
in behavior:

 - The PSR registers are used instead of the previous "gpio_mask" values,
   matching AT91 behavior and removing some duplication between that role
   and that of "pinmux_mask".

 - NR_IRQs grew to acommodate a bank of external GPIOs.  Eventually this
   number should probably become a config option.

There's a debugfs dump of status for the built-in GPIOs, showing which
pins have deglitching, pullups, or open drain drive enabled, as well as
the ID string used when requesting each IRQ.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
---
 arch/avr32/Kconfig                         |    1 
 arch/avr32/mach-at32ap/pio.c               |  169 +++++++++++++++--------------
 arch/avr32/mach-at32ap/pio.h               |    2 
 include/asm-avr32/arch-at32ap/at32ap7000.h |    2 
 include/asm-avr32/arch-at32ap/gpio.h       |   34 ++++-
 include/asm-avr32/arch-at32ap/irq.h        |    4 
 6 files changed, 118 insertions(+), 94 deletions(-)

--- a/arch/avr32/Kconfig	2007-11-02 14:25:24.000000000 -0700
+++ b/arch/avr32/Kconfig	2007-11-05 19:50:05.000000000 -0800
@@ -86,6 +86,7 @@ config PLATFORM_AT32AP
 	select SUBARCH_AVR32B
 	select MMU
 	select PERFORMANCE_COUNTERS
+	select GPIO_LIB
 
 choice
 	prompt "AVR32 CPU type"
--- a/arch/avr32/mach-at32ap/pio.c	2007-11-02 14:25:24.000000000 -0700
+++ b/arch/avr32/mach-at32ap/pio.c	2007-11-05 19:50:05.000000000 -0800
@@ -28,7 +28,7 @@ struct pio_device {
 	const struct platform_device *pdev;
 	struct clk *clk;
 	u32 pinmux_mask;
-	u32 gpio_mask;
+	struct gpio_chip chip;
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
-
-	pio = gpio_to_pio(gpio);
-	if (!pio)
-		return -ENODEV;
+	struct pio_device *pio = container_of(chip, struct pio_device, chip);
+	u32 mask = 1 << offset;
 
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
-
-	pin = gpio & 0x1f;
-	pio_writel(pio, ODR, 1 << pin);
-
-	return 0;
-}
-EXPORT_SYMBOL(gpio_direction_input);
+static void gpio_set(struct gpio_chip *chip, unsigned offset, int value);
 
-int gpio_direction_output(unsigned int gpio, int value)
+static int direction_output(struct gpio_chip *chip, unsigned offset, int value)
 {
-	struct pio_device *pio;
-	unsigned int pin;
-
-	pio = gpio_to_pio(gpio);
-	if (!pio)
-		return -ENODEV;
-
-	gpio_set_value(gpio, value);
+	struct pio_device *pio = container_of(chip, struct pio_device, chip);
+	u32 mask = 1 << offset;
 
-	pin = gpio & 0x1f;
-	pio_writel(pio, OER, 1 << pin);
+	if (!(pio_readl(pio, PSR) & mask))
+		return -EINVAL;
 
+	gpio_set(chip, offset, value);
+	pio_writel(pio, OER, mask);
 	return 0;
 }
-EXPORT_SYMBOL(gpio_direction_output);
-
-int gpio_get_value(unsigned int gpio)
-{
-	struct pio_device *pio = &pio_dev[gpio >> 5];
 
-	return (pio_readl(pio, PDSR) >> (gpio & 0x1f)) & 1;
-}
-EXPORT_SYMBOL(gpio_get_value);
-
-void gpio_set_value(unsigned int gpio, int value)
+static void gpio_set(struct gpio_chip *chip, unsigned offset, int value)
 {
-	struct pio_device *pio = &pio_dev[gpio >> 5];
-	u32 mask;
+	struct pio_device *pio = container_of(chip, struct pio_device, chip);
+	u32 mask = 1 << offset;
 
-	mask = 1 << (gpio & 0x1f);
 	if (value)
 		pio_writel(pio, SODR, mask);
 	else
 		pio_writel(pio, CODR, mask);
 }
-EXPORT_SYMBOL(gpio_set_value);
 
 /*--------------------------------------------------------------------------*/
 
@@ -339,6 +288,60 @@ gpio_irq_setup(struct pio_device *pio, i
 
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
+		if (!gpiochip_is_requested(chip, i))
+			continue;
+
+		seq_printf(s, " gpio-%-3d P%c%-2d (%-12s) %s %s %s",
+			chip->base + i, bank, i,
+			chip->requested[i],
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
@@ -349,6 +352,18 @@ static int __init pio_probe(struct platf
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
@@ -406,12 +421,6 @@ void __init at32_init_pio(struct platfor
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
--- a/arch/avr32/mach-at32ap/pio.h	2007-11-02 14:25:24.000000000 -0700
+++ b/arch/avr32/mach-at32ap/pio.h	2007-11-05 19:50:05.000000000 -0800
@@ -19,7 +19,7 @@
 #define PIO_OSR                                0x0018
 #define PIO_IFER                               0x0020
 #define PIO_IFDR                               0x0024
-#define PIO_ISFR                               0x0028
+#define PIO_IFSR                               0x0028
 #define PIO_SODR                               0x0030
 #define PIO_CODR                               0x0034
 #define PIO_ODSR                               0x0038
--- a/include/asm-avr32/arch-at32ap/at32ap7000.h	2007-11-02 14:25:24.000000000 -0700
+++ b/include/asm-avr32/arch-at32ap/at32ap7000.h	2007-11-05 19:50:05.000000000 -0800
@@ -13,8 +13,6 @@
 #define GPIO_PERIPH_A	0
 #define GPIO_PERIPH_B	1
 
-#define NR_GPIO_CONTROLLERS	4
-
 /*
  * Pin numbers identifying specific GPIO pins on the chip. They can
  * also be converted to IRQ numbers by passing them through
--- a/include/asm-avr32/arch-at32ap/gpio.h	2007-11-02 14:25:24.000000000 -0700
+++ b/include/asm-avr32/arch-at32ap/gpio.h	2007-11-05 19:56:33.000000000 -0800
@@ -5,20 +5,36 @@
 #include <asm/irq.h>
 
 
-/* Arch-neutral GPIO API */
-int __must_check gpio_request(unsigned int gpio, const char *label);
-void gpio_free(unsigned int gpio);
+/* Some GPIO chips can manage IRQs; some can't.  The exact numbers can
+ * be changed if needed, but for the moment they're not configurable.
+ */
+#define ARCH_NR_GPIOS	(NR_GPIO_IRQS + 2 * ARCH_GPIOS_PER_CHIP)
 
-int gpio_direction_input(unsigned int gpio);
-int gpio_direction_output(unsigned int gpio, int value);
-int gpio_get_value(unsigned int gpio);
-void gpio_set_value(unsigned int gpio, int value);
 
-#include <asm-generic/gpio.h>		/* cansleep wrappers */
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
+
 
 static inline int gpio_to_irq(unsigned int gpio)
 {
-	return gpio + GPIO_IRQ_BASE;
+	if (gpio < NR_GPIO_IRQS)
+		return gpio + GPIO_IRQ_BASE;
+	return -EINVAL;
 }
 
 static inline int irq_to_gpio(unsigned int irq)
--- a/include/asm-avr32/arch-at32ap/irq.h	2007-11-02 14:25:24.000000000 -0700
+++ b/include/asm-avr32/arch-at32ap/irq.h	2007-11-05 19:50:05.000000000 -0800
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
 
