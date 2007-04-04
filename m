Return-Path: <linux-kernel-owner+w=401wt.eu-S1753639AbXDDSGs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753639AbXDDSGs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 14:06:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753867AbXDDSGr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 14:06:47 -0400
Received: from nlpi001.sbcis.sbc.com ([207.115.36.30]:36081 "EHLO
	nlpi001.sbcis.sbc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753639AbXDDSGp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 14:06:45 -0400
X-ORBL: [67.117.73.34]
From: Tony Lindgren <tony@atomide.com>
To: linux-kernel@vger.kernel.org
Cc: Juha Yrjola <juha.yrjola@solidboot.com>, Tony Lindgren <tony@atomide.com>
Subject: [PATCH 10/90] ARM: OMAP: Implement workaround for GPIO wakeup bug in OMAP2420 silicon
Date: Wed,  4 Apr 2007 14:04:49 -0400
Message-Id: <11757099743984-git-send-email-tony@atomide.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <11757099691323-git-send-email-tony@atomide.com>
References: 11757088953851-git-send-email-tony@atomide.com <11757099691323-git-send-email-tony@atomide.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Juha Yrjola <juha.yrjola@solidboot.com>

Some GPIOs on OMAP2420 do not have wakeup capabilities. If these GPIOs
are configured as IRQ sources, spurious interrupts will be generated
each time the core domain enters retention.

Signed-off-by: Juha Yrjola <juha.yrjola@solidboot.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm/plat-omap/gpio.c |  154 +++++++++++++++++++++++++++++++++++++++-----
 1 files changed, 136 insertions(+), 18 deletions(-)

diff --git a/arch/arm/plat-omap/gpio.c b/arch/arm/plat-omap/gpio.c
index e2547a7..c6cded5 100644
--- a/arch/arm/plat-omap/gpio.c
+++ b/arch/arm/plat-omap/gpio.c
@@ -118,8 +118,18 @@ struct gpio_bank {
 	u16 virtual_irq_start;
 	int method;
 	u32 reserved_map;
+#if defined (CONFIG_ARCH_OMAP16XX) || defined (CONFIG_ARCH_OMAP24XX)
 	u32 suspend_wakeup;
 	u32 saved_wakeup;
+#endif
+#ifdef CONFIG_ARCH_OMAP24XX
+	u32 non_wakeup_gpios;
+	u32 enabled_non_wakeup_gpios;
+
+	u32 saved_datain;
+	u32 saved_fallingdetect;
+	u32 saved_risingdetect;
+#endif
 	spinlock_t lock;
 };
 
@@ -398,8 +408,10 @@ do {	\
 	__raw_writel(l, base + reg); \
 } while(0)
 
-static inline void set_24xx_gpio_triggering(void __iomem *base, int gpio, int trigger)
+#ifdef CONFIG_ARCH_OMAP24XX
+static inline void set_24xx_gpio_triggering(struct gpio_bank *bank, int gpio, int trigger)
 {
+	void __iomem *base = bank->base;
 	u32 gpio_bit = 1 << gpio;
 
 	MOD_REG_BIT(OMAP24XX_GPIO_LEVELDETECT0, gpio_bit,
@@ -410,9 +422,21 @@ static inline void set_24xx_gpio_triggering(void __iomem *base, int gpio, int tr
 		trigger & __IRQT_RISEDGE);
 	MOD_REG_BIT(OMAP24XX_GPIO_FALLINGDETECT, gpio_bit,
 		trigger & __IRQT_FALEDGE);
+	if (likely(!(bank->non_wakeup_gpios & gpio_bit))) {
+		if (trigger != 0)
+			__raw_writel(1 << gpio, bank->base + OMAP24XX_GPIO_SETWKUENA);
+		else
+			__raw_writel(1 << gpio, bank->base + OMAP24XX_GPIO_CLEARWKUENA);
+	} else {
+		if (trigger != 0)
+			bank->enabled_non_wakeup_gpios |= gpio_bit;
+		else
+			bank->enabled_non_wakeup_gpios &= ~gpio_bit;
+	}
 	/* FIXME: Possibly do 'set_irq_handler(j, handle_level_irq)' if only level
 	 * triggering requested. */
 }
+#endif
 
 static int _set_gpio_triggering(struct gpio_bank *bank, int gpio, int trigger)
 {
@@ -440,6 +464,7 @@ static int _set_gpio_triggering(struct gpio_bank *bank, int gpio, int trigger)
 		else
 			goto bad;
 		break;
+#ifdef CONFIG_ARCH_OMAP16XX
 	case METHOD_GPIO_1610:
 		if (gpio & 0x08)
 			reg += OMAP1610_GPIO_EDGE_CTRL2;
@@ -455,7 +480,14 @@ static int _set_gpio_triggering(struct gpio_bank *bank, int gpio, int trigger)
 			l |= 2 << (gpio << 1);
 		if (trigger & __IRQT_FALEDGE)
 			l |= 1 << (gpio << 1);
+		if (trigger)
+			/* Enable wake-up during idle for dynamic tick */
+			__raw_writel(1 << gpio, bank->base + OMAP1610_GPIO_SET_WAKEUPENA);
+		else
+			__raw_writel(1 << gpio, bank->base + OMAP1610_GPIO_CLEAR_WAKEUPENA);
 		break;
+#endif
+#ifdef CONFIG_ARCH_OMAP730
 	case METHOD_GPIO_730:
 		reg += OMAP730_GPIO_INT_CONTROL;
 		l = __raw_readl(reg);
@@ -466,9 +498,12 @@ static int _set_gpio_triggering(struct gpio_bank *bank, int gpio, int trigger)
 		else
 			goto bad;
 		break;
+#endif
+#ifdef CONFIG_ARCH_OMAP24XX
 	case METHOD_GPIO_24XX:
-		set_24xx_gpio_triggering(reg, gpio, trigger);
+		set_24xx_gpio_triggering(bank, gpio, trigger);
 		break;
+#endif
 	default:
 		BUG();
 		goto bad;
@@ -652,8 +687,8 @@ static inline void _set_gpio_irqenable(struct gpio_bank *bank, int gpio, int ena
 static int _set_gpio_wakeup(struct gpio_bank *bank, int gpio, int enable)
 {
 	switch (bank->method) {
+#ifdef CONFIG_ARCH_OMAP16XX
 	case METHOD_GPIO_1610:
-	case METHOD_GPIO_24XX:
 		spin_lock(&bank->lock);
 		if (enable)
 			bank->suspend_wakeup |= (1 << gpio);
@@ -661,6 +696,24 @@ static int _set_gpio_wakeup(struct gpio_bank *bank, int gpio, int enable)
 			bank->suspend_wakeup &= ~(1 << gpio);
 		spin_unlock(&bank->lock);
 		return 0;
+#endif
+#ifdef CONFIG_ARCH_OMAP24XX
+	case METHOD_GPIO_24XX:
+		spin_lock(&bank->lock);
+		if (enable) {
+			if (bank->non_wakeup_gpios & (1 << gpio)) {
+				printk(KERN_ERR "Unable to enable wakeup on"
+						"non-wakeup GPIO%d\n",
+						(bank - gpio_bank) * 32 + gpio);
+				spin_unlock(&bank->lock);
+				return -EINVAL;
+			}
+			bank->suspend_wakeup |= (1 << gpio);
+		} else
+			bank->suspend_wakeup &= ~(1 << gpio);
+		spin_unlock(&bank->lock);
+		return 0;
+#endif
 	default:
 		printk(KERN_ERR "Can't enable GPIO wakeup for method %i\n",
 		       bank->method);
@@ -722,20 +775,6 @@ int omap_request_gpio(int gpio)
 		__raw_writel(__raw_readl(reg) | (1 << get_gpio_index(gpio)), reg);
 	}
 #endif
-#ifdef CONFIG_ARCH_OMAP16XX
-	if (bank->method == METHOD_GPIO_1610) {
-		/* Enable wake-up during idle for dynamic tick */
-		void __iomem *reg = bank->base + OMAP1610_GPIO_SET_WAKEUPENA;
-		__raw_writel(1 << get_gpio_index(gpio), reg);
-	}
-#endif
-#ifdef CONFIG_ARCH_OMAP24XX
-	if (bank->method == METHOD_GPIO_24XX) {
-		/* Enable wake-up during idle for dynamic tick */
-		void __iomem *reg = bank->base + OMAP24XX_GPIO_SETWKUENA;
-		__raw_writel(1 << get_gpio_index(gpio), reg);
-	}
-#endif
 	spin_unlock(&bank->lock);
 
 	return 0;
@@ -1081,13 +1120,18 @@ static int __init _omap_gpio_init(void)
 #endif
 #ifdef CONFIG_ARCH_OMAP24XX
 		if (bank->method == METHOD_GPIO_24XX) {
+			static const u32 non_wakeup_gpios[] = {
+				0xe203ffc0, 0x08700040
+			};
+
 			__raw_writel(0x00000000, bank->base + OMAP24XX_GPIO_IRQENABLE1);
 			__raw_writel(0xffffffff, bank->base + OMAP24XX_GPIO_IRQSTATUS1);
 			__raw_writew(0x0015, bank->base + OMAP24XX_GPIO_SYSCONFIG);
 
 			/* Initialize interface clock ungated, module enabled */
 			__raw_writel(0, bank->base + OMAP24XX_GPIO_CTRL);
-
+			if (i < ARRAY_SIZE(non_wakeup_gpios))
+				bank->non_wakeup_gpios = non_wakeup_gpios[i];
 			gpio_count = 32;
 		}
 #endif
@@ -1201,6 +1245,80 @@ static struct sys_device omap_gpio_device = {
 	.id		= 0,
 	.cls		= &omap_gpio_sysclass,
 };
+
+#endif
+
+#ifdef CONFIG_ARCH_OMAP24XX
+
+static int workaround_enabled;
+
+void omap2_gpio_prepare_for_retention(void)
+{
+	int i, c = 0;
+
+	/* Remove triggering for all non-wakeup GPIOs.  Otherwise spurious
+	 * IRQs will be generated.  See OMAP2420 Errata item 1.101. */
+	for (i = 0; i < gpio_bank_count; i++) {
+		struct gpio_bank *bank = &gpio_bank[i];
+		u32 l1, l2;
+
+		if (!(bank->enabled_non_wakeup_gpios))
+			continue;
+		bank->saved_datain = __raw_readl(bank->base + OMAP24XX_GPIO_DATAIN);
+		l1 = __raw_readl(bank->base + OMAP24XX_GPIO_FALLINGDETECT);
+		l2 = __raw_readl(bank->base + OMAP24XX_GPIO_RISINGDETECT);
+		bank->saved_fallingdetect = l1;
+		bank->saved_risingdetect = l2;
+		l1 &= ~bank->enabled_non_wakeup_gpios;
+		l2 &= ~bank->enabled_non_wakeup_gpios;
+		__raw_writel(l1, bank->base + OMAP24XX_GPIO_FALLINGDETECT);
+		__raw_writel(l2, bank->base + OMAP24XX_GPIO_RISINGDETECT);
+		c++;
+	}
+	if (!c) {
+		workaround_enabled = 0;
+		return;
+	}
+	workaround_enabled = 1;
+}
+
+void omap2_gpio_resume_after_retention(void)
+{
+	int i;
+
+	if (!workaround_enabled)
+		return;
+	for (i = 0; i < gpio_bank_count; i++) {
+		struct gpio_bank *bank = &gpio_bank[i];
+		u32 l;
+
+		if (!(bank->enabled_non_wakeup_gpios))
+			continue;
+		__raw_writel(bank->saved_fallingdetect,
+				 bank->base + OMAP24XX_GPIO_FALLINGDETECT);
+		__raw_writel(bank->saved_risingdetect,
+				 bank->base + OMAP24XX_GPIO_RISINGDETECT);
+		/* Check if any of the non-wakeup interrupt GPIOs have changed
+		 * state.  If so, generate an IRQ by software.  This is
+		 * horribly racy, but it's the best we can do to work around
+		 * this silicon bug. */
+		l = __raw_readl(bank->base + OMAP24XX_GPIO_DATAIN);
+		l ^= bank->saved_datain;
+		l &= bank->non_wakeup_gpios;
+		if (l) {
+			u32 old0, old1;
+
+			old0 = __raw_readl(bank->base + OMAP24XX_GPIO_LEVELDETECT0);
+			old1 = __raw_readl(bank->base + OMAP24XX_GPIO_LEVELDETECT1);
+			__raw_writel(old0 | l, bank->base + OMAP24XX_GPIO_LEVELDETECT0);
+			__raw_writel(old1 | l, bank->base + OMAP24XX_GPIO_LEVELDETECT1);
+			__raw_writel(old0, bank->base + OMAP24XX_GPIO_LEVELDETECT0);
+			__raw_writel(old1, bank->base + OMAP24XX_GPIO_LEVELDETECT1);
+		}
+	}
+
+}
+
 #endif
 
 /*
-- 
1.4.4.2

