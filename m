Return-Path: <linux-kernel-owner+w=401wt.eu-S932274AbXDDSJ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932274AbXDDSJ6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 14:09:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932195AbXDDSJw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 14:09:52 -0400
Received: from nlpi001.sbcis.sbc.com ([207.115.36.30]:37439 "EHLO
	nlpi001.sbcis.sbc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753945AbXDDSJV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 14:09:21 -0400
X-ORBL: [67.117.73.34]
From: Tony Lindgren <tony@atomide.com>
To: linux-kernel@vger.kernel.org
Cc: David Brownell <dbrownell@users.sourceforge.net>,
       Tony Lindgren <tony@atomide.com>
Subject: [PATCH 37/90] ARM: OMAP: MPUIO wake updates
Date: Wed,  4 Apr 2007 14:05:16 -0400
Message-Id: <11757100691131-git-send-email-tony@atomide.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <11757100661228-git-send-email-tony@atomide.com>
References: 11757088953851-git-send-email-tony@atomide.com <11757099691323-git-send-email-tony@atomide.com> <11757099743984-git-send-email-tony@atomide.com> <1175709977545-git-send-email-tony@atomide.com> <1175709988265-git-send-email-tony@atomide.com> <11757099942493-git-send-email-tony@atomide.com> <11757100011056-git-send-email-tony@atomide.com> <1175710003925-git-send-email-tony@atomide.com> <11757100063945-git-send-email-tony@atomide.com> <11757100092910-git-send-email-tony@atomide.com> <11757100112473-git-send-email-tony@atomide.com> <11757100143517-git-send-email-tony@atomide.com> <11757100163760-git-send-email-tony@atomide.com> <11757100181189-git-send-email-tony@atomide.com> <11757100214151-git-send-email-tony@atomide.com> <11757100242980-git-send-email-tony@atomide.com> <1175710026446-git-send-email-tony@atomide.com> <11757100281957-git-send-email-tony@atomide.com> <11757100302964-git-send-email-tony@atomide.com> <1175710033286-git-send-email-tony@atomide.com> <117!
 57100403021-git-send-email-tony@atomide.com> <11757100423982-git-send-email-tony@atomide.com> <117571004562-git-send-email-tony@atomide.com> <11757100491583-git-send-email-tony@atomide.com> <11757100511172-git-send-email-tony@atomide.com> <1175710059333-git-send-email-tony@atomide.com> <11757100623383-git-send-email-tony@atomide.com> <11757100641006-git-send-email-tony@atomide.com> <11757100661228-git-send-email-tony@atomide.com>
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

diff --git a/arch/arm/plat-omap/gpio.c b/arch/arm/plat-omap/gpio.c
index 83613f7..7e90cea 100644
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

