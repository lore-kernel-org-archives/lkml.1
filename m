Return-Path: <linux-kernel-owner+w=401wt.eu-S1754218AbYIXTvo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754218AbYIXTvo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 15:51:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752095AbYIXTvg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 15:51:36 -0400
Received: from smtp121.sbc.mail.sp1.yahoo.com ([69.147.64.94]:25553 "HELO
	smtp121.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752056AbYIXTvf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 15:51:35 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=O7UdIeqvjGpjqOAEtM6LvVMRpN1djot3fZPYPvjijv/KF4+b3av3yBwMar9zm+aoHRcnh6zYU2EkmBJ6CGgEmqDl50Leh+PQeJWPqUoS9vks2IiH5ZNndeCJWa7XpBKNXseDY/dBfX1nJP3X3vDcigQ9jv0owK/hjCE2a2V6XIc=  ;
X-YMail-OSG: WFqUd_QVM1mZsV0OOShFQ_ZeWabfhU1WUQtP4yh8F9xmbG3.QUflEa09qtAnU.RJZJabMnpzNTx5w5fDGQpyy2r46qd6itgZwNy4ed6zHtFDoBaUQ1QudEXSBsvSlKwQPWRwK.SUp.D5XR9_O7OOhn7sVtWT
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH/RFC] hardware irq debouncing support
Date: Wed, 24 Sep 2008 12:51:32 -0700
User-Agent: KMail/1.9.9
Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Andrew Victor <linux@maxim.org.za>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       Tony Lindgren <tony@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809241251.32606.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hardware IRQ debouncing is common for IRQ controllers which are
part of GPIO modules ... they often deal with mechanical switches,
buttons, and so forth.  This patch:

 - Provides simple support for that in genirq

 - Includes sample implementations for some Linux systems
   which already include non-generic support for this:

     * Atmel SOCs (AT91, AT32 -- the same GPIO module)
     * OMAP2/OMAP3 (not quite as simple)

Control over how long to debounce is less common, and often applies
to banks of GPIOs not individual signals ... not addressed here.

Drivers can request this (where available) with a new IRQF_DEBOUNCED
flag/hint passed to request_irq():

    IF that flag is set when a handler is registered
	AND the relevant irq_chip supports debouncing
	AND the IRQ isn't already flagged as being debounced
    THEN the irq_chip is asked to enable debouncing for this IRQ
	UNTIL the IRQ's last handler is unregistered.
    ELSE
        nothing is done ... the hint is ignored
    FI

Comments?

Having this mechanism in genirq would let boards remove a bunch of
nonportable code, and would let drivers like gpio_keys, gpio_mouse,
and various touchscreens work more reliably.  It'd also let various
SOC-specific MMC and CF card drivers switch over to more standard
(and widely understandable) mechanisms.

I'd like to submit such updates for the 2.6.28 merge window, in
part to let mainline avoid needing yet another driver-specific
programming interface for IRQ debouncing.  (For TWL4030/TPS659x0,
as used in most OMAP3 boards including the Gumstix Overo and the
BeagleBoard.)

 - Dave

p.s. Tony and Kevin:  note the locking bugfix in the OMAP2/3 bit.

---
 arch/arm/mach-at91/gpio.c    |   13 +++++++++++++
 arch/arm/plat-omap/gpio.c    |   15 ++++++++++++++-
 arch/avr32/mach-at32ap/pio.c |   14 ++++++++++++++
 include/linux/interrupt.h    |    2 ++
 include/linux/irq.h          |    3 +++
 kernel/irq/manage.c          |   27 +++++++++++++++++++++++++++
 6 files changed, 73 insertions(+), 1 deletion(-)

--- a/arch/arm/mach-at91/gpio.c
+++ b/arch/arm/mach-at91/gpio.c
@@ -368,12 +368,25 @@ static int gpio_irq_type(unsigned pin, u
 	}
 }
 
+static int gpio_irq_debounce(unsigned pin, bool is_on)
+{
+	void __iomem	*pio = pin_to_controller(pin);
+	unsigned	mask = pin_to_mask(pin);
+
+	if (is_on)
+		__raw_writel(mask, pio + PIO_IFER);
+	else
+		__raw_writel(mask, pio + PIO_IFDR);
+	return 0;
+}
+
 static struct irq_chip gpio_irqchip = {
 	.name		= "GPIO",
 	.mask		= gpio_irq_mask,
 	.unmask		= gpio_irq_unmask,
 	.set_type	= gpio_irq_type,
 	.set_wake	= gpio_irq_set_wake,
+	.debounce	= gpio_irq_debounce,
 };
 
 static void gpio_irq_handler(unsigned irq, struct irq_desc *desc)
--- a/arch/arm/plat-omap/gpio.c
+++ b/arch/arm/plat-omap/gpio.c
@@ -472,6 +472,7 @@ void omap_set_gpio_debounce(int gpio, in
 {
 	struct gpio_bank *bank;
 	void __iomem *reg;
+	unsigned long flags;
 	u32 val, l = 1 << get_gpio_index(gpio);
 
 	if (cpu_class_is_omap1())
@@ -479,8 +480,9 @@ void omap_set_gpio_debounce(int gpio, in
 
 	bank = get_gpio_bank(gpio);
 	reg = bank->base;
-
 	reg += OMAP24XX_GPIO_DEBOUNCE_EN;
+
+	spin_lock_irqsave(&bank->lock, flags);
 	val = __raw_readl(reg);
 
 	if (enable)
@@ -489,6 +491,7 @@ void omap_set_gpio_debounce(int gpio, in
 		val &= ~l;
 
 	__raw_writel(val, reg);
+	spin_unlock_irqrestore(&bank->lock, flags);
 }
 EXPORT_SYMBOL(omap_set_gpio_debounce);
 
@@ -1109,6 +1112,12 @@ static void gpio_unmask_irq(unsigned int
 	_set_gpio_irqenable(bank, gpio, 1);
 }
 
+static int gpio_irq_debounce(unsigned int irq, bool is_on)
+{
+	omap_set_gpio_debounce(irq - IH_GPIO_BASE, is_on);
+	return 0;
+}
+
 static struct irq_chip gpio_irq_chip = {
 	.name		= "GPIO",
 	.shutdown	= gpio_irq_shutdown,
@@ -1437,6 +1446,10 @@ static int __init _omap_gpio_init(void)
 			(rev >> 4) & 0x0f, rev & 0x0f);
 	}
 #endif
+
+	if (cpu_is_omap242x() || cpu_is_omap243x() || cpu_is_omap34xx())
+		gpio_irq_chip.debounce = gpio_irq_debounce;
+
 	for (i = 0; i < gpio_bank_count; i++) {
 		int j, gpio_count = 16;
 
--- a/arch/avr32/mach-at32ap/pio.c
+++ b/arch/avr32/mach-at32ap/pio.c
@@ -234,11 +234,25 @@ static int gpio_irq_type(unsigned irq, u
 	return 0;
 }
 
+static int gpio_irq_debounce(unsigned irq, bool is_on)
+{
+	unsigned		gpio = irq_to_gpio(irq);
+	struct pio_device	*pio = &pio_dev[gpio >> 5];
+	u32			mask = 1 << (gpio & 0x1f);
+
+	if (is_on)
+		pio_writel(pio, IFER, mask);
+	else
+		pio_writel(pio, IFDR, mask);
+	return 0;
+}
+
 static struct irq_chip gpio_irqchip = {
 	.name		= "gpio",
 	.mask		= gpio_irq_mask,
 	.unmask		= gpio_irq_unmask,
 	.set_type	= gpio_irq_type,
+	.debounce	= gpio_irq_debounce,
 };
 
 static void gpio_irq_handler(unsigned irq, struct irq_desc *desc)
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -45,6 +45,7 @@
  * IRQF_IRQPOLL - Interrupt is used for polling (only the interrupt that is
  *                registered first in an shared interrupt is considered for
  *                performance reasons)
+ * IRQF_DEBOUNCED - Interrupt should use hardware debouncing where possible
  */
 #define IRQF_DISABLED		0x00000020
 #define IRQF_SAMPLE_RANDOM	0x00000040
@@ -54,6 +55,7 @@
 #define IRQF_PERCPU		0x00000400
 #define IRQF_NOBALANCING	0x00000800
 #define IRQF_IRQPOLL		0x00001000
+#define IRQF_DEBOUNCED		0x00002000
 
 typedef irqreturn_t (*irq_handler_t)(int, void *);
 
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -44,6 +44,7 @@ typedef	void (*irq_flow_handler_t)(unsig
 #define IRQ_TYPE_LEVEL_LOW	0x00000008	/* Level low type */
 #define IRQ_TYPE_SENSE_MASK	0x0000000f	/* Mask of the above */
 #define IRQ_TYPE_PROBE		0x00000010	/* Probing in progress */
+#define IRQ_TYPE_DEBOUNCED	0x00000020	/* Hardware debouncing enabled */
 
 /* Internal flags */
 #define IRQ_INPROGRESS		0x00000100	/* IRQ handler active - do not enter! */
@@ -92,6 +93,7 @@ struct msi_desc;
  * @retrigger:		resend an IRQ to the CPU
  * @set_type:		set the flow type (IRQ_TYPE_LEVEL/etc.) of an IRQ
  * @set_wake:		enable/disable power-management wake-on of an IRQ
+ * @debounce:		enable/disable hardware debouncing of an IRQ
  *
  * @release:		release function solely used by UML
  * @typename:		obsoleted by name, kept as migration helper
@@ -114,6 +116,7 @@ struct irq_chip {
 	int		(*retrigger)(unsigned int irq);
 	int		(*set_type)(unsigned int irq, unsigned int flow_type);
 	int		(*set_wake)(unsigned int irq, unsigned int on);
+	int		(*debounce)(unsigned int irq, bool is_on);
 
 	/* Currently used only by UML, might disappear one day.*/
 #ifdef CONFIG_IRQ_RELEASE_METHOD
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -445,6 +445,18 @@ int setup_irq(unsigned int irq, struct i
 	desc->irq_count = 0;
 	desc->irqs_unhandled = 0;
 
+	/* Maybe enable hardware debouncing */
+	if ((new->flags & IRQF_DEBOUNCED)
+			&& desc->chip->debounce
+			&& !(desc->status & IRQ_TYPE_DEBOUNCED)) {
+		ret = desc->chip->debounce(irq, true);
+		if (ret < 0)
+			pr_debug("IRQ: can't debounce irq %d, err %d\n",
+					irq, ret);
+		else
+			desc->status |= IRQ_TYPE_DEBOUNCED;
+	}
+
 	/*
 	 * Check whether we disabled the irq via the spurious handler
 	 * before. Reenable it and give it another chance.
@@ -524,6 +536,21 @@ void free_irq(unsigned int irq, void *de
 
 			if (!desc->action) {
 				desc->status |= IRQ_DISABLED;
+
+				/* Maybe disable hardware debouncing */
+				if ((desc->status & IRQ_TYPE_DEBOUNCED)
+						&& desc->chip->debounce) {
+					int status;
+
+					status = desc->chip->debounce(irq, false);
+					if (status < 0)
+						pr_debug("IRQ: irq %d still "
+							"being debounced, err %d\n",
+							irq, status);
+					else
+						desc->status &= ~IRQ_TYPE_DEBOUNCED;
+				}
+
 				if (desc->chip->shutdown)
 					desc->chip->shutdown(irq);
 				else
