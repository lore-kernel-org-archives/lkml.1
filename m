Return-Path: <linux-kernel-owner+w=401wt.eu-S1752885AbXDIVDy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752885AbXDIVDy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 17:03:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965828AbXDIVCi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 17:02:38 -0400
Received: from nlpi015.sbcis.sbc.com ([207.115.36.44]:12084 "EHLO
	nlpi015.sbcis.sbc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752869AbXDIVCU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 17:02:20 -0400
X-ORBL: [67.117.73.34]
From: Tony Lindgren <tony@atomide.com>
To: linux-kernel@vger.kernel.org
Cc: David Brownell <dbrownell@users.sourceforge.net>,
       Tony Lindgren <tony@atomide.com>
Subject: [PATCH 8/10] ARM: OMAP: MPUIO wake updates
Date: Mon,  9 Apr 2007 17:01:10 -0400
Message-Id: <11761525172279-git-send-email-tony@atomide.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <1176152514395-git-send-email-tony@atomide.com>
References: <11761524713580-git-send-email-tony@atomide.com> <1176152483689-git-send-email-tony@atomide.com> <11761524911912-git-send-email-tony@atomide.com> <1176152494436-git-send-email-tony@atomide.com> <11761525022200-git-send-email-tony@atomide.com> <11761525051719-git-send-email-tony@atomide.com> <11761525101796-git-send-email-tony@atomide.com> <1176152514395-git-send-email-tony@atomide.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Brownell <dbrownell@users.sourceforge.net>

GPIO and MPUIO wake updates:

 - Hook MPUIOs into the irq wakeup framework too.  This uses a platform
   device to update irq enables during system sleep states, instead of
   a sys_device, since the latter is no longer needed for such things.

 - Also forward enable/disable irq wake requests to the relevant GPIO
   controller, so the top level IRQ dispatcher can (eventually) handle
   these wakeup events automatically if more than one GPIO pin needs to
   be a wakeup event source.

 - Minor tweak to the 24xx non-wakeup gpio stuff: no need to check such
   read-only data under the spinlock.

This assumes (maybe wrongly?) that only 16xx can do GPIO wakeup; without
a 15xx I can't test such stuff.

Also this expects the top level IRQ dispatcher to properly handle requests
to enable/disable irq wake, which is currently known to be wrong:  omap1
saves the flags but ignores them, omap2 doesn't even save it.  (Wakeup
events are, wrongly, hardwired in the relevant mach-omapX/pm.c file ...)
So MPUIO irqs won't yet trigger system wakeup.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm/plat-omap/gpio.c |   93 ++++++++++++++++++++++++++++++++++++++++-----
 1 files changed, 83 insertions(+), 10 deletions(-)

--- a/arch/arm/plat-omap/gpio.c
+++ b/arch/arm/plat-omap/gpio.c
@@ -773,29 +773,35 @@ static int _set_gpio_wakeup(struct gpio_bank *bank, int gpio, int enable)
 {
 	switch (bank->method) {
 #ifdef CONFIG_ARCH_OMAP16XX
+	case METHOD_MPUIO:
 	case METHOD_GPIO_1610:
 		spin_lock(&bank->lock);
-		if (enable)
+		if (enable) {
 			bank->suspend_wakeup |= (1 << gpio);
-		else
+			enable_irq_wake(bank->irq);
+		} else {
+			disable_irq_wake(bank->irq);
 			bank->suspend_wakeup &= ~(1 << gpio);
+		}
 		spin_unlock(&bank->lock);
 		return 0;
 #endif
 #ifdef CONFIG_ARCH_OMAP24XX
 	case METHOD_GPIO_24XX:
+		if (bank->non_wakeup_gpios & (1 << gpio)) {
+			printk(KERN_ERR "Unable to modify wakeup on "
+					"non-wakeup GPIO%d\n",
+					(bank - gpio_bank) * 32 + gpio);
+			return -EINVAL;
+		}
 		spin_lock(&bank->lock);
 		if (enable) {
-			if (bank->non_wakeup_gpios & (1 << gpio)) {
-				printk(KERN_ERR "Unable to enable wakeup on "
-						"non-wakeup GPIO%d\n",
-						(bank - gpio_bank) * 32 + gpio);
-				spin_unlock(&bank->lock);
-				return -EINVAL;
-			}
 			bank->suspend_wakeup |= (1 << gpio);
-		} else
+			enable_irq_wake(bank->irq);
+		} else {
+			disable_irq_wake(bank->irq);
 			bank->suspend_wakeup &= ~(1 << gpio);
+		}
 		spin_unlock(&bank->lock);
 		return 0;
 #endif
@@ -1111,16 +1117,81 @@ static struct irq_chip mpuio_irq_chip = {
 	.mask		= mpuio_mask_irq,
 	.unmask		= mpuio_unmask_irq,
 	.set_type	= gpio_irq_type,
+#ifdef CONFIG_ARCH_OMAP16XX
+	/* REVISIT: assuming only 16xx supports MPUIO wake events */
+	.set_wake	= gpio_wake_enable,
+#endif
 };
 
 
 #define bank_is_mpuio(bank)	((bank)->method == METHOD_MPUIO)
 
+
+#ifdef CONFIG_ARCH_OMAP16XX
+
+#include <linux/platform_device.h>
+
+static int omap_mpuio_suspend_late(struct platform_device *pdev, pm_message_t mesg)
+{
+	struct gpio_bank	*bank = platform_get_drvdata(pdev);
+	void __iomem		*mask_reg = bank->base + OMAP_MPUIO_GPIO_MASKIT;
+
+	spin_lock(&bank->lock);
+	bank->saved_wakeup = __raw_readl(mask_reg);
+	__raw_writel(0xffff & ~bank->suspend_wakeup, mask_reg);
+	spin_unlock(&bank->lock);
+
+	return 0;
+}
+
+static int omap_mpuio_resume_early(struct platform_device *pdev)
+{
+	struct gpio_bank	*bank = platform_get_drvdata(pdev);
+	void __iomem		*mask_reg = bank->base + OMAP_MPUIO_GPIO_MASKIT;
+
+	spin_lock(&bank->lock);
+	__raw_writel(bank->saved_wakeup, mask_reg);
+	spin_unlock(&bank->lock);
+
+	return 0;
+}
+
+/* use platform_driver for this, now that there's no longer any
+ * point to sys_device (other than not disturbing old code).
+ */
+static struct platform_driver omap_mpuio_driver = {
+	.suspend_late	= omap_mpuio_suspend_late,
+	.resume_early	= omap_mpuio_resume_early,
+	.driver		= {
+		.name	= "mpuio",
+	},
+};
+
+static struct platform_device omap_mpuio_device = {
+	.name		= "mpuio",
+	.id		= -1,
+	.dev = {
+		.driver = &omap_mpuio_driver.driver,
+	}
+	/* could list the /proc/iomem resources */
+};
+
+static inline void mpuio_init(void)
+{
+	if (platform_driver_register(&omap_mpuio_driver) == 0)
+		(void) platform_device_register(&omap_mpuio_device);
+}
+
+#else
+static inline void mpuio_init(void) {}
+#endif	/* 16xx */
+
 #else
 
 extern struct irq_chip mpuio_irq_chip;
 
 #define bank_is_mpuio(bank)	0
+static inline void mpuio_init(void) {}
 
 #endif
 
@@ -1487,6 +1558,8 @@ static int __init omap_gpio_sysinit(void)
 	if (!initialized)
 		ret = _omap_gpio_init();
 
+	mpuio_init();
+
 #if defined(CONFIG_ARCH_OMAP16XX) || defined(CONFIG_ARCH_OMAP24XX)
 	if (cpu_is_omap16xx() || cpu_is_omap24xx()) {
 		if (ret == 0) {
-- 
1.4.4.2

