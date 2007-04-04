Return-Path: <linux-kernel-owner+w=401wt.eu-S1753887AbXDDSi2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753887AbXDDSi2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 14:38:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753916AbXDDSH5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 14:07:57 -0400
Received: from nlpi001.sbcis.sbc.com ([207.115.36.30]:36622 "EHLO
	nlpi001.sbcis.sbc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753915AbXDDSHw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 14:07:52 -0400
X-ORBL: [67.117.73.34]
From: Tony Lindgren <tony@atomide.com>
To: linux-kernel@vger.kernel.org
Cc: David Brownell <dbrownell@users.sourceforge.net>,
       Tony Lindgren <tony@atomide.com>
Subject: [PATCH 21/90] ARM: OMAP: gpio object shrinkage, cleanup
Date: Wed,  4 Apr 2007 14:05:00 -0400
Message-Id: <11757100181189-git-send-email-tony@atomide.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <11757100163760-git-send-email-tony@atomide.com>
References: 11757088953851-git-send-email-tony@atomide.com <11757099691323-git-send-email-tony@atomide.com> <11757099743984-git-send-email-tony@atomide.com> <1175709977545-git-send-email-tony@atomide.com> <1175709988265-git-send-email-tony@atomide.com> <11757099942493-git-send-email-tony@atomide.com> <11757100011056-git-send-email-tony@atomide.com> <1175710003925-git-send-email-tony@atomide.com> <11757100063945-git-send-email-tony@atomide.com> <11757100092910-git-send-email-tony@atomide.com> <11757100112473-git-send-email-tony@atomide.com> <11757100143517-git-send-email-tony@atomide.com> <11757100163760-git-send-email-tony@atomide.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Brownell <dbrownell@users.sourceforge.net>

More GPIO/IRQ cleanup:

  - compile-time removal of much useless code
      * mpuio support on non-OMAP1.
      * 15xx/730/24xx gpio support on 1610
      * 15xx/730/16xx gpio support on 24xx
      * etc

  - remove all BUG() calls, which are always bad news ... replaced some
    with normal fault reports for that call, others with WARN_ON(1).

  - small mpuio bugfix:  add missing set_type() method

Oh, and fix a minor merge issue: inode->u.generic_ip is now gone.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm/plat-omap/gpio.c |  166 +++++++++++++++++++++++++++++++++++----------
 1 files changed, 130 insertions(+), 36 deletions(-)

diff --git a/arch/arm/plat-omap/gpio.c b/arch/arm/plat-omap/gpio.c
index 970439e..948185e 100644
--- a/arch/arm/plat-omap/gpio.c
+++ b/arch/arm/plat-omap/gpio.c
@@ -267,21 +267,34 @@ static void _set_gpio_direction(struct gpio_bank *bank, int gpio, int is_input)
 	u32 l;
 
 	switch (bank->method) {
+#ifdef CONFIG_ARCH_OMAP1
 	case METHOD_MPUIO:
 		reg += OMAP_MPUIO_IO_CNTL;
 		break;
+#endif
+#ifdef CONFIG_ARCH_OMAP15XX
 	case METHOD_GPIO_1510:
 		reg += OMAP1510_GPIO_DIR_CONTROL;
 		break;
+#endif
+#ifdef CONFIG_ARCH_OMAP16XX
 	case METHOD_GPIO_1610:
 		reg += OMAP1610_GPIO_DIRECTION;
 		break;
+#endif
+#ifdef CONFIG_ARCH_OMAP730
 	case METHOD_GPIO_730:
 		reg += OMAP730_GPIO_DIR_CONTROL;
 		break;
+#endif
+#ifdef CONFIG_ARCH_OMAP24XX
 	case METHOD_GPIO_24XX:
 		reg += OMAP24XX_GPIO_OE;
 		break;
+#endif
+	default:
+		WARN_ON(1);
+		return;
 	}
 	l = __raw_readl(reg);
 	if (is_input)
@@ -309,6 +322,7 @@ static void _set_gpio_dataout(struct gpio_bank *bank, int gpio, int enable)
 	u32 l = 0;
 
 	switch (bank->method) {
+#ifdef CONFIG_ARCH_OMAP1
 	case METHOD_MPUIO:
 		reg += OMAP_MPUIO_OUTPUT;
 		l = __raw_readl(reg);
@@ -317,6 +331,8 @@ static void _set_gpio_dataout(struct gpio_bank *bank, int gpio, int enable)
 		else
 			l &= ~(1 << gpio);
 		break;
+#endif
+#ifdef CONFIG_ARCH_OMAP15XX
 	case METHOD_GPIO_1510:
 		reg += OMAP1510_GPIO_DATA_OUTPUT;
 		l = __raw_readl(reg);
@@ -325,6 +341,8 @@ static void _set_gpio_dataout(struct gpio_bank *bank, int gpio, int enable)
 		else
 			l &= ~(1 << gpio);
 		break;
+#endif
+#ifdef CONFIG_ARCH_OMAP16XX
 	case METHOD_GPIO_1610:
 		if (enable)
 			reg += OMAP1610_GPIO_SET_DATAOUT;
@@ -332,6 +350,8 @@ static void _set_gpio_dataout(struct gpio_bank *bank, int gpio, int enable)
 			reg += OMAP1610_GPIO_CLEAR_DATAOUT;
 		l = 1 << gpio;
 		break;
+#endif
+#ifdef CONFIG_ARCH_OMAP730
 	case METHOD_GPIO_730:
 		reg += OMAP730_GPIO_DATA_OUTPUT;
 		l = __raw_readl(reg);
@@ -340,6 +360,8 @@ static void _set_gpio_dataout(struct gpio_bank *bank, int gpio, int enable)
 		else
 			l &= ~(1 << gpio);
 		break;
+#endif
+#ifdef CONFIG_ARCH_OMAP24XX
 	case METHOD_GPIO_24XX:
 		if (enable)
 			reg += OMAP24XX_GPIO_SETDATAOUT;
@@ -347,8 +369,9 @@ static void _set_gpio_dataout(struct gpio_bank *bank, int gpio, int enable)
 			reg += OMAP24XX_GPIO_CLEARDATAOUT;
 		l = 1 << gpio;
 		break;
+#endif
 	default:
-		BUG();
+		WARN_ON(1);
 		return;
 	}
 	__raw_writel(l, reg);
@@ -372,28 +395,37 @@ int omap_get_gpio_datain(int gpio)
 	void __iomem *reg;
 
 	if (check_gpio(gpio) < 0)
-		return -1;
+		return -EINVAL;
 	bank = get_gpio_bank(gpio);
 	reg = bank->base;
 	switch (bank->method) {
+#ifdef CONFIG_ARCH_OMAP1
 	case METHOD_MPUIO:
 		reg += OMAP_MPUIO_INPUT_LATCH;
 		break;
+#endif
+#ifdef CONFIG_ARCH_OMAP15XX
 	case METHOD_GPIO_1510:
 		reg += OMAP1510_GPIO_DATA_INPUT;
 		break;
+#endif
+#ifdef CONFIG_ARCH_OMAP16XX
 	case METHOD_GPIO_1610:
 		reg += OMAP1610_GPIO_DATAIN;
 		break;
+#endif
+#ifdef CONFIG_ARCH_OMAP730
 	case METHOD_GPIO_730:
 		reg += OMAP730_GPIO_DATA_INPUT;
 		break;
+#endif
+#ifdef CONFIG_ARCH_OMAP24XX
 	case METHOD_GPIO_24XX:
 		reg += OMAP24XX_GPIO_DATAIN;
 		break;
+#endif
 	default:
-		BUG();
-		return -1;
+		return -EINVAL;
 	}
 	return (__raw_readl(reg)
 			& (1 << get_gpio_index(gpio))) != 0;
@@ -443,6 +475,7 @@ static int _set_gpio_triggering(struct gpio_bank *bank, int gpio, int trigger)
 	u32 l = 0;
 
 	switch (bank->method) {
+#ifdef CONFIG_ARCH_OMAP1
 	case METHOD_MPUIO:
 		reg += OMAP_MPUIO_GPIO_INT_EDGE;
 		l = __raw_readl(reg);
@@ -453,6 +486,8 @@ static int _set_gpio_triggering(struct gpio_bank *bank, int gpio, int trigger)
 		else
 			goto bad;
 		break;
+#endif
+#ifdef CONFIG_ARCH_OMAP15XX
 	case METHOD_GPIO_1510:
 		reg += OMAP1510_GPIO_INT_CONTROL;
 		l = __raw_readl(reg);
@@ -463,6 +498,7 @@ static int _set_gpio_triggering(struct gpio_bank *bank, int gpio, int trigger)
 		else
 			goto bad;
 		break;
+#endif
 #ifdef CONFIG_ARCH_OMAP16XX
 	case METHOD_GPIO_1610:
 		if (gpio & 0x08)
@@ -470,9 +506,6 @@ static int _set_gpio_triggering(struct gpio_bank *bank, int gpio, int trigger)
 		else
 			reg += OMAP1610_GPIO_EDGE_CTRL1;
 		gpio &= 0x07;
-		/* We allow only edge triggering, i.e. two lowest bits */
-		if (trigger & (__IRQT_LOWLVL | __IRQT_HIGHLVL))
-			BUG();
 		l = __raw_readl(reg);
 		l &= ~(3 << (gpio << 1));
 		if (trigger & __IRQT_RISEDGE)
@@ -504,7 +537,6 @@ static int _set_gpio_triggering(struct gpio_bank *bank, int gpio, int trigger)
 		break;
 #endif
 	default:
-		BUG();
 		goto bad;
 	}
 	__raw_writel(l, reg);
@@ -519,7 +551,7 @@ static int gpio_irq_type(unsigned irq, unsigned type)
 	unsigned gpio;
 	int retval;
 
-	if (irq > IH_MPUIO_BASE)
+	if (!cpu_is_omap24xx() && irq > IH_MPUIO_BASE)
 		gpio = OMAP_MPUIO(irq - IH_MPUIO_BASE);
 	else
 		gpio = irq - IH_GPIO_BASE;
@@ -527,9 +559,12 @@ static int gpio_irq_type(unsigned irq, unsigned type)
 	if (check_gpio(gpio) < 0)
 		return -EINVAL;
 
-	if (type & IRQT_PROBE)
+	if (type & ~IRQ_TYPE_SENSE_MASK)
 		return -EINVAL;
-	if (!cpu_is_omap24xx() && (type & (__IRQT_LOWLVL|__IRQT_HIGHLVL)))
+
+	/* OMAP1 allows only only edge triggering */
+	if (!cpu_is_omap24xx()
+			&& (type & (IRQ_TYPE_LEVEL_LOW|IRQ_TYPE_LEVEL_HIGH)))
 		return -EINVAL;
 
 	bank = get_gpio_bank(gpio);
@@ -548,24 +583,34 @@ static void _clear_gpio_irqbank(struct gpio_bank *bank, int gpio_mask)
 	void __iomem *reg = bank->base;
 
 	switch (bank->method) {
+#ifdef CONFIG_ARCH_OMAP1
 	case METHOD_MPUIO:
 		/* MPUIO irqstatus is reset by reading the status register,
 		 * so do nothing here */
 		return;
+#endif
+#ifdef CONFIG_ARCH_OMAP15XX
 	case METHOD_GPIO_1510:
 		reg += OMAP1510_GPIO_INT_STATUS;
 		break;
+#endif
+#ifdef CONFIG_ARCH_OMAP16XX
 	case METHOD_GPIO_1610:
 		reg += OMAP1610_GPIO_IRQSTATUS1;
 		break;
+#endif
+#ifdef CONFIG_ARCH_OMAP730
 	case METHOD_GPIO_730:
 		reg += OMAP730_GPIO_INT_STATUS;
 		break;
+#endif
+#ifdef CONFIG_ARCH_OMAP24XX
 	case METHOD_GPIO_24XX:
 		reg += OMAP24XX_GPIO_IRQSTATUS1;
 		break;
+#endif
 	default:
-		BUG();
+		WARN_ON(1);
 		return;
 	}
 	__raw_writel(gpio_mask, reg);
@@ -588,31 +633,41 @@ static u32 _get_gpio_irqbank_mask(struct gpio_bank *bank)
 	u32 mask;
 
 	switch (bank->method) {
+#ifdef CONFIG_ARCH_OMAP1
 	case METHOD_MPUIO:
 		reg += OMAP_MPUIO_GPIO_MASKIT;
 		mask = 0xffff;
 		inv = 1;
 		break;
+#endif
+#ifdef CONFIG_ARCH_OMAP15XX
 	case METHOD_GPIO_1510:
 		reg += OMAP1510_GPIO_INT_MASK;
 		mask = 0xffff;
 		inv = 1;
 		break;
+#endif
+#ifdef CONFIG_ARCH_OMAP16XX
 	case METHOD_GPIO_1610:
 		reg += OMAP1610_GPIO_IRQENABLE1;
 		mask = 0xffff;
 		break;
+#endif
+#ifdef CONFIG_ARCH_OMAP730
 	case METHOD_GPIO_730:
 		reg += OMAP730_GPIO_INT_MASK;
 		mask = 0xffffffff;
 		inv = 1;
 		break;
+#endif
+#ifdef CONFIG_ARCH_OMAP24XX
 	case METHOD_GPIO_24XX:
 		reg += OMAP24XX_GPIO_IRQENABLE1;
 		mask = 0xffffffff;
 		break;
+#endif
 	default:
-		BUG();
+		WARN_ON(1);
 		return 0;
 	}
 
@@ -629,6 +684,7 @@ static void _enable_gpio_irqbank(struct gpio_bank *bank, int gpio_mask, int enab
 	u32 l;
 
 	switch (bank->method) {
+#ifdef CONFIG_ARCH_OMAP1
 	case METHOD_MPUIO:
 		reg += OMAP_MPUIO_GPIO_MASKIT;
 		l = __raw_readl(reg);
@@ -637,6 +693,8 @@ static void _enable_gpio_irqbank(struct gpio_bank *bank, int gpio_mask, int enab
 		else
 			l |= gpio_mask;
 		break;
+#endif
+#ifdef CONFIG_ARCH_OMAP15XX
 	case METHOD_GPIO_1510:
 		reg += OMAP1510_GPIO_INT_MASK;
 		l = __raw_readl(reg);
@@ -645,6 +703,8 @@ static void _enable_gpio_irqbank(struct gpio_bank *bank, int gpio_mask, int enab
 		else
 			l |= gpio_mask;
 		break;
+#endif
+#ifdef CONFIG_ARCH_OMAP16XX
 	case METHOD_GPIO_1610:
 		if (enable)
 			reg += OMAP1610_GPIO_SET_IRQENABLE1;
@@ -652,6 +712,8 @@ static void _enable_gpio_irqbank(struct gpio_bank *bank, int gpio_mask, int enab
 			reg += OMAP1610_GPIO_CLEAR_IRQENABLE1;
 		l = gpio_mask;
 		break;
+#endif
+#ifdef CONFIG_ARCH_OMAP730
 	case METHOD_GPIO_730:
 		reg += OMAP730_GPIO_INT_MASK;
 		l = __raw_readl(reg);
@@ -660,6 +722,8 @@ static void _enable_gpio_irqbank(struct gpio_bank *bank, int gpio_mask, int enab
 		else
 			l |= gpio_mask;
 		break;
+#endif
+#ifdef CONFIG_ARCH_OMAP24XX
 	case METHOD_GPIO_24XX:
 		if (enable)
 			reg += OMAP24XX_GPIO_SETIRQENABLE1;
@@ -667,8 +731,9 @@ static void _enable_gpio_irqbank(struct gpio_bank *bank, int gpio_mask, int enab
 			reg += OMAP24XX_GPIO_CLEARIRQENABLE1;
 		l = gpio_mask;
 		break;
+#endif
 	default:
-		BUG();
+		WARN_ON(1);
 		return;
 	}
 	__raw_writel(l, reg);
@@ -837,8 +902,10 @@ static void gpio_irq_handler(unsigned int irq, struct irq_desc *desc)
 	desc->chip->ack(irq);
 
 	bank = get_irq_data(irq);
+#ifdef CONFIG_ARCH_OMAP1
 	if (bank->method == METHOD_MPUIO)
 		isr_reg = bank->base + OMAP_MPUIO_GPIO_INT;
+#endif
 #ifdef CONFIG_ARCH_OMAP15XX
 	if (bank->method == METHOD_GPIO_1510)
 		isr_reg = bank->base + OMAP1510_GPIO_INT_STATUS;
@@ -984,6 +1051,22 @@ static void gpio_unmask_irq(unsigned int irq)
 	_set_gpio_irqenable(bank, gpio_idx, 1);
 }
 
+static struct irq_chip gpio_irq_chip = {
+	.name		= "GPIO",
+	.shutdown	= gpio_irq_shutdown,
+	.ack		= gpio_ack_irq,
+	.mask		= gpio_mask_irq,
+	.unmask		= gpio_unmask_irq,
+	.set_type	= gpio_irq_type,
+	.set_wake	= gpio_wake_enable,
+};
+
+/*---------------------------------------------------------------------*/
+
+#ifdef CONFIG_ARCH_OMAP1
+
+/* MPUIO uses the always-on 32k clock */
+
 static void mpuio_ack_irq(unsigned int irq)
 {
 	/* The ISR is reset automatically, so do nothing here. */
@@ -1005,23 +1088,26 @@ static void mpuio_unmask_irq(unsigned int irq)
 	_set_gpio_irqenable(bank, gpio, 1);
 }
 
-static struct irq_chip gpio_irq_chip = {
-	.name		= "GPIO",
-	.shutdown	= gpio_irq_shutdown,
-	.ack		= gpio_ack_irq,
-	.mask		= gpio_mask_irq,
-	.unmask		= gpio_unmask_irq,
+static struct irq_chip mpuio_irq_chip = {
+	.name		= "MPUIO",
+	.ack		= mpuio_ack_irq,
+	.mask		= mpuio_mask_irq,
+	.unmask		= mpuio_unmask_irq
 	.set_type	= gpio_irq_type,
-	.set_wake	= gpio_wake_enable,
 };
 
-static struct irq_chip mpuio_irq_chip = {
-	.name	  = "MPUIO",
-	.ack	  = mpuio_ack_irq,
-	.mask	  = mpuio_mask_irq,
-	.unmask	  = mpuio_unmask_irq,
-	.set_type = gpio_irq_type,
-};
+
+#define bank_is_mpuio(bank)	((bank)->method == METHOD_MPUIO)
+
+#else
+
+extern struct irq_chip mpuio_irq_chip;
+
+#define bank_is_mpuio(bank)	0
+
+#endif
+
+/*---------------------------------------------------------------------*/
 
 static int initialized;
 static struct clk * gpio_ick;
@@ -1097,9 +1183,8 @@ static int __init _omap_gpio_init(void)
 		bank->reserved_map = 0;
 		bank->base = IO_ADDRESS(bank->base);
 		spin_lock_init(&bank->lock);
-		if (bank->method == METHOD_MPUIO) {
+		if (bank_is_mpuio(bank))
 			omap_writew(0xFFFF, OMAP_MPUIO_BASE + OMAP_MPUIO_GPIO_MASKIT);
-		}
 #ifdef CONFIG_ARCH_OMAP15XX
 		if (bank->method == METHOD_GPIO_1510) {
 			__raw_writew(0xffff, bank->base + OMAP1510_GPIO_INT_MASK);
@@ -1140,7 +1225,7 @@ static int __init _omap_gpio_init(void)
 #endif
 		for (j = bank->virtual_irq_start;
 		     j < bank->virtual_irq_start + gpio_count; j++) {
-			if (bank->method == METHOD_MPUIO)
+			if (bank_is_mpuio(bank))
 				set_irq_chip(j, &mpuio_irq_chip);
 			else
 				set_irq_chip(j, &gpio_irq_chip);
@@ -1180,16 +1265,20 @@ static int omap_gpio_suspend(struct sys_device *dev, pm_message_t mesg)
 		void __iomem *wake_set;
 
 		switch (bank->method) {
+#ifdef CONFIG_ARCH_OMAP16XX
 		case METHOD_GPIO_1610:
 			wake_status = bank->base + OMAP1610_GPIO_WAKEUPENABLE;
 			wake_clear = bank->base + OMAP1610_GPIO_CLEAR_WAKEUPENA;
 			wake_set = bank->base + OMAP1610_GPIO_SET_WAKEUPENA;
 			break;
+#endif
+#ifdef CONFIG_ARCH_OMAP24XX
 		case METHOD_GPIO_24XX:
 			wake_status = bank->base + OMAP24XX_GPIO_SETWKUENA;
 			wake_clear = bank->base + OMAP24XX_GPIO_CLEARWKUENA;
 			wake_set = bank->base + OMAP24XX_GPIO_SETWKUENA;
 			break;
+#endif
 		default:
 			continue;
 		}
@@ -1217,14 +1306,18 @@ static int omap_gpio_resume(struct sys_device *dev)
 		void __iomem *wake_set;
 
 		switch (bank->method) {
+#ifdef CONFIG_ARCH_OMAP16XX
 		case METHOD_GPIO_1610:
 			wake_clear = bank->base + OMAP1610_GPIO_CLEAR_WAKEUPENA;
 			wake_set = bank->base + OMAP1610_GPIO_SET_WAKEUPENA;
 			break;
+#endif
+#ifdef CONFIG_ARCH_OMAP24XX
 		case METHOD_GPIO_24XX:
 			wake_clear = bank->base + OMAP24XX_GPIO_CLEARWKUENA;
 			wake_set = bank->base + OMAP24XX_GPIO_SETWKUENA;
 			break;
+#endif
 		default:
 			continue;
 		}
@@ -1404,7 +1497,7 @@ static int dbg_gpio_show(struct seq_file *s, void *unused)
 		unsigned		bankwidth = 16;
 		u32			mask = 1;
 
-		if (!cpu_is_omap24xx() && bank->method == METHOD_MPUIO)
+		if (bank_is_mpuio(bank))
 			gpio = OMAP_MPUIO(0);
 		else if (cpu_is_omap24xx() || cpu_is_omap730())
 			bankwidth = 32;
@@ -1419,7 +1512,7 @@ static int dbg_gpio_show(struct seq_file *s, void *unused)
 			value = omap_get_gpio_datain(gpio);
 			is_in = gpio_is_input(bank, mask);
 
-			if (!cpu_is_omap24xx() && bank->method == METHOD_MPUIO)
+			if (bank_is_mpuio(bank))
 				seq_printf(s, "MPUIO %2d: ", j);
 			else
 				seq_printf(s, "GPIO %3d: ", gpio);
@@ -1460,7 +1553,7 @@ static int dbg_gpio_show(struct seq_file *s, void *unused)
 			seq_printf(s, "\n");
 		}
 
-		if (!cpu_is_omap24xx() && bank->method == METHOD_MPUIO) {
+		if (bank_is_mpuio(bank)) {
 			seq_printf(s, "\n");
 			gpio = 0;
 		}
@@ -1470,7 +1563,7 @@ static int dbg_gpio_show(struct seq_file *s, void *unused)
 
 static int dbg_gpio_open(struct inode *inode, struct file *file)
 {
-	return single_open(file, dbg_gpio_show, inode->u.generic_ip/*i_private*/);
+	return single_open(file, dbg_gpio_show, &inode->i_private);
 }
 
 static const struct file_operations debug_fops = {
@@ -1482,7 +1575,8 @@ static const struct file_operations debug_fops = {
 
 static int __init omap_gpio_debuginit(void)
 {
-	(void) debugfs_create_file("omap_gpio", S_IRUGO, NULL, NULL, &debug_fops);
+	(void) debugfs_create_file("omap_gpio", S_IRUGO,
+					NULL, NULL, &debug_fops);
 	return 0;
 }
 late_initcall(omap_gpio_debuginit);
-- 
1.4.4.2

