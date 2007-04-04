Return-Path: <linux-kernel-owner+w=401wt.eu-S1753961AbXDDSdM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753961AbXDDSdM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 14:33:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753939AbXDDSJT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 14:09:19 -0400
Received: from nlpi001.sbcis.sbc.com ([207.115.36.30]:37332 "EHLO
	nlpi001.sbcis.sbc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753941AbXDDSJL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 14:09:11 -0400
X-ORBL: [67.117.73.34]
From: Tony Lindgren <tony@atomide.com>
To: linux-kernel@vger.kernel.org
Cc: David Brownell <dbrownell@users.sourceforge.net>,
       Tony Lindgren <tony@atomide.com>
Subject: [PATCH 35/90] ARM: OMAP: speed up gpio irq handling
Date: Wed,  4 Apr 2007 14:05:14 -0400
Message-Id: <11757100641006-git-send-email-tony@atomide.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <11757100623383-git-send-email-tony@atomide.com>
References: 11757088953851-git-send-email-tony@atomide.com <11757099691323-git-send-email-tony@atomide.com> <11757099743984-git-send-email-tony@atomide.com> <1175709977545-git-send-email-tony@atomide.com> <1175709988265-git-send-email-tony@atomide.com> <11757099942493-git-send-email-tony@atomide.com> <11757100011056-git-send-email-tony@atomide.com> <1175710003925-git-send-email-tony@atomide.com> <11757100063945-git-send-email-tony@atomide.com> <11757100092910-git-send-email-tony@atomide.com> <11757100112473-git-send-email-tony@atomide.com> <11757100143517-git-send-email-tony@atomide.com> <11757100163760-git-send-email-tony@atomide.com> <11757100181189-git-send-email-tony@atomide.com> <11757100214151-git-send-email-tony@atomide.com> <11757100242980-git-send-email-tony@atomide.com> <1175710026446-git-send-email-tony@atomide.com> <11757100281957-git-send-email-tony@atomide.com> <11757100302964-git-send-email-tony@atomide.com> <1175710033286-git-send-email-tony@atomide.com> <117!
 57100403021-git-send-email-tony@atomide.com> <11757100423982-git-send-email-tony@atomide.com> <117571004562-git-send-email-tony@atomide.com> <11757100491583-git-send-email-tony@atomide.com> <11757100511172-git-send-email-tony@atomide.com> <1175710059333-git-send-email-tony@atomide.com> <11757100623383-git-send-email-tony@atomide.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Brownell <dbrownell@users.sourceforge.net>

Speedup and shrink GPIO irq handling code, by using a pointer
that's available in the irq_chip structure instead of calling
the get_gpio_bank() function.  On OMAP1 this saves 44 words,
most of which were in IRQ critical path methods.  Hey, every
few instructions help.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm/plat-omap/gpio.c |   17 +++++++++--------
 1 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/arch/arm/plat-omap/gpio.c b/arch/arm/plat-omap/gpio.c
index eb9245b..83613f7 100644
--- a/arch/arm/plat-omap/gpio.c
+++ b/arch/arm/plat-omap/gpio.c
@@ -584,7 +584,7 @@ static int gpio_irq_type(unsigned irq, unsigned type)
 			&& (type & (IRQ_TYPE_LEVEL_LOW|IRQ_TYPE_LEVEL_HIGH)))
 		return -EINVAL;
 
-	bank = get_gpio_bank(gpio);
+	bank = get_irq_chip_data(irq);
 	spin_lock(&bank->lock);
 	retval = _set_gpio_triggering(bank, get_gpio_index(gpio), type);
 	if (retval == 0) {
@@ -823,7 +823,7 @@ static int gpio_wake_enable(unsigned int irq, unsigned int enable)
 
 	if (check_gpio(gpio) < 0)
 		return -ENODEV;
-	bank = get_gpio_bank(gpio);
+	bank = get_irq_chip_data(irq);
 	retval = _set_gpio_wakeup(bank, get_gpio_index(gpio), enable);
 
 	return retval;
@@ -1038,7 +1038,7 @@ static void gpio_irq_handler(unsigned int irq, struct irq_desc *desc)
 static void gpio_irq_shutdown(unsigned int irq)
 {
 	unsigned int gpio = irq - IH_GPIO_BASE;
-	struct gpio_bank *bank = get_gpio_bank(gpio);
+	struct gpio_bank *bank = get_irq_chip_data(irq);
 
 	_reset_gpio(bank, gpio);
 }
@@ -1046,7 +1046,7 @@ static void gpio_irq_shutdown(unsigned int irq)
 static void gpio_ack_irq(unsigned int irq)
 {
 	unsigned int gpio = irq - IH_GPIO_BASE;
-	struct gpio_bank *bank = get_gpio_bank(gpio);
+	struct gpio_bank *bank = get_irq_chip_data(irq);
 
 	_clear_gpio_irqstatus(bank, gpio);
 }
@@ -1054,7 +1054,7 @@ static void gpio_ack_irq(unsigned int irq)
 static void gpio_mask_irq(unsigned int irq)
 {
 	unsigned int gpio = irq - IH_GPIO_BASE;
-	struct gpio_bank *bank = get_gpio_bank(gpio);
+	struct gpio_bank *bank = get_irq_chip_data(irq);
 
 	_set_gpio_irqenable(bank, gpio, 0);
 }
@@ -1063,7 +1063,7 @@ static void gpio_unmask_irq(unsigned int irq)
 {
 	unsigned int gpio = irq - IH_GPIO_BASE;
 	unsigned int gpio_idx = get_gpio_index(gpio);
-	struct gpio_bank *bank = get_gpio_bank(gpio);
+	struct gpio_bank *bank = get_irq_chip_data(irq);
 
 	_set_gpio_irqenable(bank, gpio_idx, 1);
 }
@@ -1092,7 +1092,7 @@ static void mpuio_ack_irq(unsigned int irq)
 static void mpuio_mask_irq(unsigned int irq)
 {
 	unsigned int gpio = OMAP_MPUIO(irq - IH_MPUIO_BASE);
-	struct gpio_bank *bank = get_gpio_bank(gpio);
+	struct gpio_bank *bank = get_irq_chip_data(irq);
 
 	_set_gpio_irqenable(bank, gpio, 0);
 }
@@ -1100,7 +1100,7 @@ static void mpuio_mask_irq(unsigned int irq)
 static void mpuio_unmask_irq(unsigned int irq)
 {
 	unsigned int gpio = OMAP_MPUIO(irq - IH_MPUIO_BASE);
-	struct gpio_bank *bank = get_gpio_bank(gpio);
+	struct gpio_bank *bank = get_irq_chip_data(irq);
 
 	_set_gpio_irqenable(bank, gpio, 1);
 }
@@ -1275,6 +1275,7 @@ static int __init _omap_gpio_init(void)
 #endif
 		for (j = bank->virtual_irq_start;
 		     j < bank->virtual_irq_start + gpio_count; j++) {
+			set_irq_chip_data(j, bank);
 			if (bank_is_mpuio(bank))
 				set_irq_chip(j, &mpuio_irq_chip);
 			else
-- 
1.4.4.2

