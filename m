Return-Path: <linux-kernel-owner+w=401wt.eu-S1752890AbXDIVDy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752890AbXDIVDy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 17:03:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965847AbXDIVCg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 17:02:36 -0400
Received: from nlpi015.sbcis.sbc.com ([207.115.36.44]:12119 "EHLO
	nlpi015.sbcis.sbc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965756AbXDIVCY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 17:02:24 -0400
X-ORBL: [67.117.73.34]
From: Tony Lindgren <tony@atomide.com>
To: linux-kernel@vger.kernel.org
Cc: David Brownell <dbrownell@users.sourceforge.net>,
       Tony Lindgren <tony@atomide.com>
Subject: [PATCH 7/10] ARM: OMAP: speed up gpio irq handling
Date: Mon,  9 Apr 2007 17:01:09 -0400
Message-Id: <1176152514395-git-send-email-tony@atomide.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <11761525101796-git-send-email-tony@atomide.com>
References: <11761524713580-git-send-email-tony@atomide.com> <1176152483689-git-send-email-tony@atomide.com> <11761524911912-git-send-email-tony@atomide.com> <1176152494436-git-send-email-tony@atomide.com> <11761525022200-git-send-email-tony@atomide.com> <11761525051719-git-send-email-tony@atomide.com> <11761525101796-git-send-email-tony@atomide.com>
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

