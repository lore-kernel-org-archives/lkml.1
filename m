Return-Path: <linux-kernel-owner+w=401wt.eu-S1753883AbXDDSH4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753883AbXDDSH4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 14:07:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753905AbXDDSHd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 14:07:33 -0400
Received: from nlpi001.sbcis.sbc.com ([207.115.36.30]:36299 "EHLO
	nlpi001.sbcis.sbc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753879AbXDDSHP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 14:07:15 -0400
X-ORBL: [67.117.73.34]
From: Tony Lindgren <tony@atomide.com>
To: linux-kernel@vger.kernel.org
Cc: David Brownell <dbrownell@users.sourceforge.net>,
       Tony Lindgren <tony@atomide.com>
Subject: [PATCH 13/90] ARM: OMAP: /sys/kernel/debug/omap_gpio
Date: Wed,  4 Apr 2007 14:04:52 -0400
Message-Id: <11757099942493-git-send-email-tony@atomide.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <1175709988265-git-send-email-tony@atomide.com>
References: 11757088953851-git-send-email-tony@atomide.com <11757099691323-git-send-email-tony@atomide.com> <11757099743984-git-send-email-tony@atomide.com> <1175709977545-git-send-email-tony@atomide.com> <1175709988265-git-send-email-tony@atomide.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Brownell <dbrownell@users.sourceforge.net>

Add some GPIO debug support:  /sys/kernel/debug/omap_gpio dumps the state
of all GPIOs that have been claimed, including basic IRQ info if relevant.
Tested on 24xx, 16xx.

Includes minor bugfixes:  recording IRQ trigger mode (this should probably
be a genirq patch), adding missing space to non-wakeup warning

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm/plat-omap/gpio.c |  130 ++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 129 insertions(+), 1 deletions(-)

diff --git a/arch/arm/plat-omap/gpio.c b/arch/arm/plat-omap/gpio.c
index c6cded5..78ba1d3 100644
--- a/arch/arm/plat-omap/gpio.c
+++ b/arch/arm/plat-omap/gpio.c
@@ -536,6 +536,10 @@ static int gpio_irq_type(unsigned irq, unsigned type)
 	bank = get_gpio_bank(gpio);
 	spin_lock(&bank->lock);
 	retval = _set_gpio_triggering(bank, get_gpio_index(gpio), type);
+	if (retval == 0) {
+		irq_desc[irq].status &= ~IRQ_TYPE_SENSE_MASK;
+		irq_desc[irq].status |= type;
+	}
 	spin_unlock(&bank->lock);
 	return retval;
 }
@@ -702,7 +706,7 @@ static int _set_gpio_wakeup(struct gpio_bank *bank, int gpio, int enable)
 		spin_lock(&bank->lock);
 		if (enable) {
 			if (bank->non_wakeup_gpios & (1 << gpio)) {
-				printk(KERN_ERR "Unable to enable wakeup on"
+				printk(KERN_ERR "Unable to enable wakeup on "
 						"non-wakeup GPIO%d\n",
 						(bank - gpio_bank) * 32 + gpio);
 				spin_unlock(&bank->lock);
@@ -1360,3 +1364,127 @@ EXPORT_SYMBOL(omap_set_gpio_dataout);
 EXPORT_SYMBOL(omap_get_gpio_datain);
 
 arch_initcall(omap_gpio_sysinit);
+
+
+#ifdef	CONFIG_DEBUG_FS
+
+#include <linux/debugfs.h>
+#include <linux/seq_file.h>
+
+static int gpio_is_input(struct gpio_bank *bank, int mask)
+{
+	void __iomem *reg = bank->base;
+
+	switch (bank->method) {
+	case METHOD_MPUIO:
+		reg += OMAP_MPUIO_IO_CNTL;
+		break;
+	case METHOD_GPIO_1510:
+		reg += OMAP1510_GPIO_DIR_CONTROL;
+		break;
+	case METHOD_GPIO_1610:
+		reg += OMAP1610_GPIO_DIRECTION;
+		break;
+	case METHOD_GPIO_730:
+		reg += OMAP730_GPIO_DIR_CONTROL;
+		break;
+	case METHOD_GPIO_24XX:
+		reg += OMAP24XX_GPIO_OE;
+		break;
+	}
+	return __raw_readl(reg) & mask;
+}
+
+
+static int dbg_gpio_show(struct seq_file *s, void *unused)
+{
+	unsigned	i, j, gpio;
+
+	for (i = 0, gpio = 0; i < gpio_bank_count; i++) {
+		struct gpio_bank	*bank = gpio_bank + i;
+		unsigned		bankwidth = 16;
+		u32			mask = 1;
+
+		if (!cpu_is_omap24xx() && bank->method == METHOD_MPUIO)
+			gpio = OMAP_MPUIO(0);
+		else if (cpu_is_omap24xx() || cpu_is_omap730())
+			bankwidth = 32;
+
+		for (j = 0; j < bankwidth; j++, gpio++, mask <<= 1) {
+			unsigned	irq, value, is_in, irqstat;
+
+			if (!(bank->reserved_map & mask))
+				continue;
+
+			irq = bank->virtual_irq_start + j;
+			value = omap_get_gpio_datain(gpio);
+			is_in = gpio_is_input(bank, mask);
+
+			if (!cpu_is_omap24xx() && bank->method == METHOD_MPUIO)
+				seq_printf(s, "MPUIO %2d: ", j);
+			else
+				seq_printf(s, "GPIO %3d: ", gpio);
+			seq_printf(s, "%s %s",
+					is_in ? "in " : "out",
+					value ? "hi"  : "lo");
+
+			irqstat = irq_desc[irq].status;
+			if (is_in && ((bank->suspend_wakeup & mask)
+					|| irqstat & IRQ_TYPE_SENSE_MASK)) {
+				char	*trigger = NULL;
+
+				switch (irqstat & IRQ_TYPE_SENSE_MASK) {
+				case IRQ_TYPE_EDGE_FALLING:
+					trigger = "falling";
+					break;
+				case IRQ_TYPE_EDGE_RISING:
+					trigger = "rising";
+					break;
+				case IRQ_TYPE_EDGE_BOTH:
+					trigger = "bothedge";
+					break;
+				case IRQ_TYPE_LEVEL_LOW:
+					trigger = "low";
+					break;
+				case IRQ_TYPE_LEVEL_HIGH:
+					trigger = "high";
+					break;
+				case IRQ_TYPE_NONE:
+					trigger = "(unspecified)";
+					break;
+				}
+				seq_printf(s, ", irq-%d %s%s",
+						irq, trigger,
+						(bank->suspend_wakeup & mask)
+							? " wakeup" : "");
+			}
+			seq_printf(s, "\n");
+		}
+
+		if (!cpu_is_omap24xx() && bank->method == METHOD_MPUIO) {
+			seq_printf(s, "\n");
+			gpio = 0;
+		}
+	}
+	return 0;
+}
+
+static int dbg_gpio_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, dbg_gpio_show, inode->u.generic_ip/*i_private*/);
+}
+
+static const struct file_operations debug_fops = {
+	.open		= dbg_gpio_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
+static int __init omap_gpio_debuginit(void)
+{
+	(void) debugfs_create_file("omap_gpio", S_IRUGO, NULL, NULL, &debug_fops);
+	return 0;
+}
+late_initcall(omap_gpio_debuginit);
+#endif
-- 
1.4.4.2

