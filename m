Return-Path: <linux-kernel-owner+w=401wt.eu-S1753940AbXDOU4b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753940AbXDOU4b (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2007 16:56:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753943AbXDOUz5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Apr 2007 16:55:57 -0400
Received: from smtp101.sbc.mail.mud.yahoo.com ([68.142.198.200]:26738 "HELO
	smtp101.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753933AbXDOUz1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2007 16:55:27 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=aQds84CgeuZLaSlQvl/MkzutqquiYUsXOWGz+hidYDgnn5FHZUbb1D+4IKt1BRepp4X9xp6JC1j9P5iDyiCFaJr11irDZjFm3OQ5QFrIGE6B86l8JoQCwoamDJNhawhosmn4pKylyo4PC1TpeQv7ib50Wg+PvQQugSHPthcENBk=  ;
X-YMail-OSG: XN8w8CMVM1mquKk1BODlZpxo580.IFKc5oXHTnJJFzUFkYfIGYCY_V96qAj4MUygwaTh1Z.2l0IV3EWvH74HKmkvOCQTqYm4bYHTkz6jZ_BFM0efuDmJUEmAHw0yIw--
From: David Brownell <david-b@pacbell.net>
To: Paul Sokolovsky <pmiscml@gmail.com>
Subject: Re: is there any generic GPIO chip framework like IRQ chips?
Date: Sun, 15 Apr 2007 12:58:50 -0700
User-Agent: KMail/1.7.1
Cc: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org
References: <f17812d70704090309l8dd764cxc06fbd7b765c55d8@mail.gmail.com> <200704102152.21287.david-b@pacbell.net> <1686019041.20070412165702@gmail.com>
In-Reply-To: <1686019041.20070412165702@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704151258.51146.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Makes OMAP use the infrastructure in the preceding patch; slightly
slows down the code, because it adds an indirect function call and
uses a non-table lookup, but GPIOs aren't accessed on critical paths.

===============	CUT HERE
Update OMAP to use the new GPIO implementation framework.  This is just a
quick'n'dirty update; more code could now be removed.  Plus, it'd really
be better to shift the entire OMAP GPIO infrastructure over to cleaner
code, this all sort of "just growed" over time.

Note:  against current Linux-OMAP tree.  The code at the end of gpio.c
isn't yet upstream; remove that segment and it may apply against kernel.org
trees too.

---
 arch/arm/plat-omap/Kconfig       |    2 
 arch/arm/plat-omap/gpio.c        |  201 ++++++++++++++-------------------------
 include/asm-arm/arch-omap/gpio.h |   52 ++--------
 3 files changed, 88 insertions(+), 167 deletions(-)

--- osk2.orig/arch/arm/plat-omap/Kconfig	2007-04-15 10:59:51.000000000 -0700
+++ osk2/arch/arm/plat-omap/Kconfig	2007-04-15 11:00:40.000000000 -0700
@@ -11,9 +11,11 @@ choice
 
 config ARCH_OMAP1
 	bool "TI OMAP1"
+	select GPIO_LIB
 
 config ARCH_OMAP2
 	bool "TI OMAP2"
+	select GPIO_LIB
 
 endchoice
 
--- osk2.orig/arch/arm/plat-omap/gpio.c	2007-04-15 10:59:51.000000000 -0700
+++ osk2/arch/arm/plat-omap/gpio.c	2007-04-15 11:02:54.000000000 -0700
@@ -137,6 +137,7 @@ struct gpio_bank {
 	u32 saved_risingdetect;
 #endif
 	spinlock_t lock;
+	struct gpio_chip chip;
 };
 
 #define METHOD_MPUIO		0
@@ -838,17 +839,23 @@ static int gpio_wake_enable(unsigned int
 int omap_request_gpio(int gpio)
 {
 	struct gpio_bank *bank;
+	int status;
 
 	if (check_gpio(gpio) < 0)
 		return -EINVAL;
 
+	status = gpio_request(gpio, NULL);
+	if (status < 0)
+		return status;
+
 	bank = get_gpio_bank(gpio);
 	spin_lock(&bank->lock);
 	if (unlikely(bank->reserved_map & (1 << get_gpio_index(gpio)))) {
 		printk(KERN_ERR "omap-gpio: GPIO %d is already reserved!\n", gpio);
 		dump_stack();
 		spin_unlock(&bank->lock);
-		return -1;
+		gpio_free(gpio);
+		return -EBUSY;
 	}
 	bank->reserved_map |= (1 << get_gpio_index(gpio));
 
@@ -902,6 +909,7 @@ void omap_free_gpio(int gpio)
 	bank->reserved_map &= ~(1 << get_gpio_index(gpio));
 	_reset_gpio(bank, gpio);
 	spin_unlock(&bank->lock);
+	gpio_free(gpio);
 }
 
 /*
@@ -1199,6 +1207,50 @@ static inline void mpuio_init(void) {}
 
 /*---------------------------------------------------------------------*/
 
+/* REVISIT these are stupid implementations!  replace by ones that
+ * don't switch on METHOD_* and which mostly avoid spinlocks
+ */
+
+static int gpio_get(struct gpio_chip *chip, unsigned offset)
+{
+	return omap_get_gpio_datain(chip->base + offset);
+}
+
+static void gpio_set(struct gpio_chip *chip, unsigned offset, int value)
+{
+	struct gpio_bank *bank;
+
+	bank = container_of(chip, struct gpio_bank, chip);
+	spin_lock(&bank->lock);
+	_set_gpio_dataout(bank, offset, value);
+	spin_unlock(&bank->lock);
+}
+
+static int gpio_input(struct gpio_chip *chip, unsigned offset)
+{
+	struct gpio_bank *bank;
+
+	bank = container_of(chip, struct gpio_bank, chip);
+	spin_lock(&bank->lock);
+	_set_gpio_direction(bank, offset, 1);
+	spin_unlock(&bank->lock);
+	return 0;
+}
+
+static int gpio_output(struct gpio_chip *chip, unsigned offset, int value)
+{
+	struct gpio_bank *bank;
+
+	bank = container_of(chip, struct gpio_bank, chip);
+	spin_lock(&bank->lock);
+	_set_gpio_dataout(bank, offset, value);
+	_set_gpio_direction(bank, offset, 0);
+	spin_unlock(&bank->lock);
+	return 0;
+}
+
+/*---------------------------------------------------------------------*/
+
 static int initialized;
 static struct clk * gpio_ick;
 static struct clk * gpio_fck;
@@ -1212,6 +1264,7 @@ static int __init _omap_gpio_init(void)
 {
 	int i;
 	struct gpio_bank *bank;
+	int gpio = 0;
 
 	initialized = 1;
 
@@ -1346,6 +1399,27 @@ static int __init _omap_gpio_init(void)
 			gpio_count = 32;
 		}
 #endif
+		/* REVISIT just switch from OMAP-specific gpio
+		 * interfaces over to the generic ones
+		 */
+		bank->chip.get = gpio_get;
+		bank->chip.set = gpio_set;
+		bank->chip.direction_input = gpio_input;
+		bank->chip.direction_output = gpio_output;
+		if (bank_is_mpuio(bank)) {
+			bank->chip.base = OMAP_MPUIO(0);
+			bank->chip.name = "MPUIO";
+		} else {
+			bank->chip.base = gpio;
+			bank->chip.name = "GPIO";
+			gpio += gpio_count;
+		}
+		bank->chip.irqs = irq_desc + bank->virtual_irq_start;
+		bank->chip.irq_base = bank->virtual_irq_start;
+		bank->chip.ngpio = gpio_count;
+
+		gpio_chip_declare(&bank->chip);
+
 		for (j = bank->virtual_irq_start;
 		     j < bank->virtual_irq_start + gpio_count; j++) {
 			set_irq_chip_data(j, bank);
@@ -1582,128 +1656,3 @@ EXPORT_SYMBOL(omap_set_gpio_dataout);
 EXPORT_SYMBOL(omap_get_gpio_datain);
 
 arch_initcall(omap_gpio_sysinit);
-
-
-#ifdef	CONFIG_DEBUG_FS
-
-#include <linux/debugfs.h>
-#include <linux/seq_file.h>
-
-static int gpio_is_input(struct gpio_bank *bank, int mask)
-{
-	void __iomem *reg = bank->base;
-
-	switch (bank->method) {
-	case METHOD_MPUIO:
-		reg += OMAP_MPUIO_IO_CNTL;
-		break;
-	case METHOD_GPIO_1510:
-		reg += OMAP1510_GPIO_DIR_CONTROL;
-		break;
-	case METHOD_GPIO_1610:
-		reg += OMAP1610_GPIO_DIRECTION;
-		break;
-	case METHOD_GPIO_730:
-		reg += OMAP730_GPIO_DIR_CONTROL;
-		break;
-	case METHOD_GPIO_24XX:
-		reg += OMAP24XX_GPIO_OE;
-		break;
-	}
-	return __raw_readl(reg) & mask;
-}
-
-
-static int dbg_gpio_show(struct seq_file *s, void *unused)
-{
-	unsigned	i, j, gpio;
-
-	for (i = 0, gpio = 0; i < gpio_bank_count; i++) {
-		struct gpio_bank	*bank = gpio_bank + i;
-		unsigned		bankwidth = 16;
-		u32			mask = 1;
-
-		if (bank_is_mpuio(bank))
-			gpio = OMAP_MPUIO(0);
-		else if (cpu_is_omap24xx() || cpu_is_omap730())
-			bankwidth = 32;
-
-		for (j = 0; j < bankwidth; j++, gpio++, mask <<= 1) {
-			unsigned	irq, value, is_in, irqstat;
-
-			if (!(bank->reserved_map & mask))
-				continue;
-
-			irq = bank->virtual_irq_start + j;
-			value = omap_get_gpio_datain(gpio);
-			is_in = gpio_is_input(bank, mask);
-
-			if (bank_is_mpuio(bank))
-				seq_printf(s, "MPUIO %2d: ", j);
-			else
-				seq_printf(s, "GPIO %3d: ", gpio);
-			seq_printf(s, "%s %s",
-					is_in ? "in " : "out",
-					value ? "hi"  : "lo");
-
-			irqstat = irq_desc[irq].status;
-			if (is_in && ((bank->suspend_wakeup & mask)
-					|| irqstat & IRQ_TYPE_SENSE_MASK)) {
-				char	*trigger = NULL;
-
-				switch (irqstat & IRQ_TYPE_SENSE_MASK) {
-				case IRQ_TYPE_EDGE_FALLING:
-					trigger = "falling";
-					break;
-				case IRQ_TYPE_EDGE_RISING:
-					trigger = "rising";
-					break;
-				case IRQ_TYPE_EDGE_BOTH:
-					trigger = "bothedge";
-					break;
-				case IRQ_TYPE_LEVEL_LOW:
-					trigger = "low";
-					break;
-				case IRQ_TYPE_LEVEL_HIGH:
-					trigger = "high";
-					break;
-				case IRQ_TYPE_NONE:
-					trigger = "(unspecified)";
-					break;
-				}
-				seq_printf(s, ", irq-%d %s%s",
-						irq, trigger,
-						(bank->suspend_wakeup & mask)
-							? " wakeup" : "");
-			}
-			seq_printf(s, "\n");
-		}
-
-		if (bank_is_mpuio(bank)) {
-			seq_printf(s, "\n");
-			gpio = 0;
-		}
-	}
-	return 0;
-}
-
-static int dbg_gpio_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, dbg_gpio_show, &inode->i_private);
-}
-
-static const struct file_operations debug_fops = {
-	.open		= dbg_gpio_open,
-	.read		= seq_read,
-	.llseek		= seq_lseek,
-	.release	= single_release,
-};
-
-static int __init omap_gpio_debuginit(void)
-{
-	(void) debugfs_create_file("omap_gpio", S_IRUGO,
-					NULL, NULL, &debug_fops);
-	return 0;
-}
-late_initcall(omap_gpio_debuginit);
-#endif
--- osk2.orig/include/asm-arm/arch-omap/gpio.h	2007-04-15 10:59:51.000000000 -0700
+++ osk2/include/asm-arm/arch-omap/gpio.h	2007-04-15 11:00:40.000000000 -0700
@@ -78,58 +78,28 @@ extern int omap_get_gpio_datain(int gpio
 
 /*-------------------------------------------------------------------------*/
 
-/* wrappers for "new style" GPIO calls. the old OMAP-specfic ones should
- * eventually be removed (along with this errno.h inclusion), and maybe
- * gpios should put MPUIOs last too.
+/* Wrappers for "new style" GPIO calls, using the new infrastructure
+ * which lets us plug in FPGA, I2C, and other implementations.
+ * *
+ * The original OMAP-specfic calls should eventually be removed.
  */
 
-#include <asm/errno.h>
-
-static inline int gpio_request(unsigned gpio, const char *label)
-{
-	return omap_request_gpio(gpio);
-}
-
-static inline void gpio_free(unsigned gpio)
-{
-	omap_free_gpio(gpio);
-}
-
-static inline int __gpio_set_direction(unsigned gpio, int is_input)
-{
-	if (cpu_class_is_omap2()) {
-		if (gpio > OMAP_MAX_GPIO_LINES)
-			return -EINVAL;
-	} else {
-		if (gpio > (OMAP_MAX_GPIO_LINES + 16 /* MPUIO */))
-			return -EINVAL;
-	}
-	omap_set_gpio_direction(gpio, is_input);
-	return 0;
-}
-
-static inline int gpio_direction_input(unsigned gpio)
-{
-	return __gpio_set_direction(gpio, 1);
-}
-
-static inline int gpio_direction_output(unsigned gpio, int value)
-{
-	omap_set_gpio_dataout(gpio, value);
-	return __gpio_set_direction(gpio, 0);
-}
+#include <asm-generic/gpio.h>
 
 static inline int gpio_get_value(unsigned gpio)
 {
-	return omap_get_gpio_datain(gpio);
+	return __gpio_get_value(gpio);
 }
 
 static inline void gpio_set_value(unsigned gpio, int value)
 {
-	omap_set_gpio_dataout(gpio, value);
+	__gpio_set_value(gpio, value);
 }
 
-#include <asm-generic/gpio.h>		/* cansleep wrappers */
+static inline int gpio_cansleep(unsigned gpio)
+{
+	return __gpio_cansleep(gpio);
+}
 
 static inline int gpio_to_irq(unsigned gpio)
 {
