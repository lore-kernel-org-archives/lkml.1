Return-Path: <linux-kernel-owner+w=401wt.eu-S1760921AbYCZVl2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760921AbYCZVl2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 17:41:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755785AbYCZVlS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 17:41:18 -0400
Received: from smtp4.int-evry.fr ([157.159.10.71]:52996 "EHLO
	smtp4.int-evry.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755382AbYCZVlR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 17:41:17 -0400
From: Florian Fainelli <florian.fainelli@telecomint.eu>
Date: Wed, 26 Mar 2008 22:39:15 +0100
Subject: [PATCH] [x86] rdc321x: GPIO routines bugfixes
MIME-Version: 1.0
X-Length: 10490
To: Ingo Molnar <mingo@elte.hu>
Cc: Volker Weiss <volker@tintuc.de>, linux-kernel@vger.kernel.org
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803262239.15568.florian.fainelli@telecomint.eu>
X-int-MailScanner-Information: Please contact the ISP for more information
X-int-MailScanner: Found to be clean
X-int-MailScanner-SpamCheck: 
X-int-MailScanner-From: florian.fainelli@telecomint.eu
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

This should be in 2.6.25 if possible. Thanks !
--
From: Florian Fainelli <florian.fainelli@telecomint.eu>
Subject: [PATCH] [x86] rdc321x: GPIO routines bugfixes

This patch fixes the use of GPIO routines which are in the PCI
configuration space of the RDC321x, therefore reading/writing
to this space without spinlock protection can be problematic.

We also now request and free GPIOs and support the MGB100
board, previous code was very AR525W-centric.

Signed-off-by: Volker Weiss <volker@tintuc.de>
Signed-off-by: Florian Fainelli <florian.fainelli@telecomint.eu>
---
diff --git a/arch/x86/mach-rdc321x/gpio.c b/arch/x86/mach-rdc321x/gpio.c
index 0312691..247f33d 100644
--- a/arch/x86/mach-rdc321x/gpio.c
+++ b/arch/x86/mach-rdc321x/gpio.c
@@ -1,91 +1,194 @@
 /*
- *  Copyright (C) 2007, OpenWrt.org, Florian Fainelli <florian@openwrt.org>
- *  	RDC321x architecture specific GPIO support
+ *  GPIO support for RDC SoC R3210/R8610
+ *
+ *  Copyright (C) 2007, Florian Fainelli <florian@openwrt.org>
+ *  Copyright (C) 2008, Volker Weiss <dev@tintuc.de>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  *
- *  This program is free software; you can redistribute  it and/or modify it
- *  under  the terms of  the GNU General  Public License as published by the
- *  Free Software Foundation;  either version 2 of the  License, or (at your
- *  option) any later version.
  */
 
-#include <linux/autoconf.h>
-#include <linux/init.h>
+
+#include <linux/spinlock.h>
 #include <linux/io.h>
 #include <linux/types.h>
 #include <linux/module.h>
-#include <linux/delay.h>
 
+#include <asm/gpio.h>
 #include <asm/mach-rdc321x/rdc321x_defs.h>
 
-static inline int rdc_gpio_is_valid(unsigned gpio)
+
+/* spin lock to protect our private copy of GPIO data register plus
+   the access to PCI conf registers. */
+static DEFINE_SPINLOCK(gpio_lock);
+
+/* copy of GPIO data registers */
+static u32 gpio_data_reg1;
+static u32 gpio_data_reg2;
+
+static u32 gpio_request_data[2];
+
+
+static inline void rdc321x_conf_write(unsigned addr, u32 value)
 {
-	return (gpio <= RDC_MAX_GPIO);
+	outl((1 << 31) | (7 << 11) | addr, RDC3210_CFGREG_ADDR);
+	outl(value, RDC3210_CFGREG_DATA);
 }
 
-static unsigned int rdc_gpio_read(unsigned gpio)
+static inline void rdc321x_conf_or(unsigned addr, u32 value)
 {
-	unsigned int val;
-
-	val = 0x80000000 | (7 << 11) | ((gpio&0x20?0x84:0x48));
-	outl(val, RDC3210_CFGREG_ADDR);
-	udelay(10);
-	val = inl(RDC3210_CFGREG_DATA);
-	val |= (0x1 << (gpio & 0x1F));
-	outl(val, RDC3210_CFGREG_DATA);
-	udelay(10);
-	val = 0x80000000 | (7 << 11) | ((gpio&0x20?0x88:0x4C));
-	outl(val, RDC3210_CFGREG_ADDR);
-	udelay(10);
-	val = inl(RDC3210_CFGREG_DATA);
-
-	return val;
+	outl((1 << 31) | (7 << 11) | addr, RDC3210_CFGREG_ADDR);
+	value |= inl(RDC3210_CFGREG_DATA);
+	outl(value, RDC3210_CFGREG_DATA);
 }
 
-static void rdc_gpio_write(unsigned int val)
+static inline u32 rdc321x_conf_read(unsigned addr)
 {
-	if (val) {
-		outl(val, RDC3210_CFGREG_DATA);
-		udelay(10);
-	}
+	outl((1 << 31) | (7 << 11) | addr, RDC3210_CFGREG_ADDR);
+
+	return inl(RDC3210_CFGREG_DATA);
 }
 
-int rdc_gpio_get_value(unsigned gpio)
+/* configure pin as GPIO */
+static void rdc321x_configure_gpio(unsigned gpio)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&gpio_lock, flags);
+	rdc321x_conf_or(gpio < 32
+		? RDC321X_GPIO_CTRL_REG1 : RDC321X_GPIO_CTRL_REG2,
+		1 << (gpio & 0x1f));
+	spin_unlock_irqrestore(&gpio_lock, flags);
+}
+
+/* initially setup the 2 copies of the gpio data registers.
+   This function must be called by the platform setup code. */
+void __init rdc321x_gpio_setup()
+{
+	/* this might not be, what others (BIOS, bootloader, etc.)
+	   wrote to these registers before, but it's a good guess. Still
+	   better than just using 0xffffffff. */
+
+	gpio_data_reg1 = rdc321x_conf_read(RDC321X_GPIO_DATA_REG1);
+	gpio_data_reg2 = rdc321x_conf_read(RDC321X_GPIO_DATA_REG2);
+}
+
+/* determine, if gpio number is valid */
+static inline int rdc321x_is_gpio(unsigned gpio)
+{
+	return gpio <= RDC321X_MAX_GPIO;
+}
+
+/* request GPIO */
+int rdc_gpio_request(unsigned gpio, const char *label)
 {
-	if (rdc_gpio_is_valid(gpio))
-		return (int)rdc_gpio_read(gpio);
-	else
+	unsigned long flags;
+
+	if (!rdc321x_is_gpio(gpio))
 		return -EINVAL;
+
+	spin_lock_irqsave(&gpio_lock, flags);
+	if (gpio_request_data[(gpio & 0x20) ? 1 : 0] & (1 << (gpio & 0x1f)))
+		goto inuse;
+	gpio_request_data[(gpio & 0x20) ? 1 : 0] |= (1 << (gpio & 0x1f));
+	spin_unlock_irqrestore(&gpio_lock, flags);
+
+	return 0;
+inuse:
+	spin_unlock_irqrestore(&gpio_lock, flags);
+	return -EINVAL;
 }
-EXPORT_SYMBOL(rdc_gpio_get_value);
+EXPORT_SYMBOL(rdc_gpio_request);
 
-void rdc_gpio_set_value(unsigned gpio, int value)
+/* release previously-claimed GPIO */
+void rdc_gpio_free(unsigned gpio)
 {
-	unsigned int val;
+	unsigned long flags;
 
-	if (!rdc_gpio_is_valid(gpio))
+	if (!rdc321x_is_gpio(gpio))
 		return;
 
-	val = rdc_gpio_read(gpio);
+	spin_lock_irqsave(&gpio_lock, flags);
+	gpio_request_data[(gpio & 0x20) ? 1 : 0] &= ~(1 << (gpio & 0x1f));
+	spin_unlock_irqrestore(&gpio_lock, flags);
+}
+EXPORT_SYMBOL(rdc_gpio_free);
+
+/* read GPIO pin */
+int rdc_gpio_get_value(unsigned gpio)
+{
+	u32 reg;
+	unsigned long flags;
+
+	spin_lock_irqsave(&gpio_lock, flags);
+	reg = rdc321x_conf_read(gpio < 32
+		? RDC321X_GPIO_DATA_REG1 : RDC321X_GPIO_DATA_REG2);
+	spin_unlock_irqrestore(&gpio_lock, flags);
 
-	if (value)
-		val &= ~(0x1 << (gpio & 0x1F));
-	else
-		val |= (0x1 << (gpio & 0x1F));
+	return (1 << (gpio & 0x1f)) & reg ? 1 : 0;
+}
+EXPORT_SYMBOL(rdc_gpio_get_value);
 
-	rdc_gpio_write(val);
+/* set GPIO pin to value */
+void rdc_gpio_set_value(unsigned gpio, int value)
+{
+	unsigned long flags;
+	u32 reg;
+
+	reg = 1 << (gpio & 0x1f);
+	if (gpio < 32) {
+		spin_lock_irqsave(&gpio_lock, flags);
+		if (value)
+			gpio_data_reg1 |= reg;
+		else
+			gpio_data_reg1 &= ~reg;
+		rdc321x_conf_write(RDC321X_GPIO_DATA_REG1, gpio_data_reg1);
+		spin_unlock_irqrestore(&gpio_lock, flags);
+	} else {
+		spin_lock_irqsave(&gpio_lock, flags);
+		if (value)
+			gpio_data_reg2 |= reg;
+		else
+			gpio_data_reg2 &= ~reg;
+		rdc321x_conf_write(RDC321X_GPIO_DATA_REG2, gpio_data_reg2);
+		spin_unlock_irqrestore(&gpio_lock, flags);
+	}
 }
 EXPORT_SYMBOL(rdc_gpio_set_value);
 
+/* configure GPIO pin as input */
 int rdc_gpio_direction_input(unsigned gpio)
 {
+	if (!rdc321x_is_gpio(gpio))
+		return -EINVAL;
+
+	rdc321x_configure_gpio(gpio);
+
 	return 0;
 }
 EXPORT_SYMBOL(rdc_gpio_direction_input);
 
+/* configure GPIO pin as output and set value */
 int rdc_gpio_direction_output(unsigned gpio, int value)
 {
+	if (!rdc321x_is_gpio(gpio))
+		return -EINVAL;
+
+	gpio_set_value(gpio, value);
+	rdc321x_configure_gpio(gpio);
+
 	return 0;
 }
 EXPORT_SYMBOL(rdc_gpio_direction_output);
-
-
diff --git a/arch/x86/mach-rdc321x/platform.c b/arch/x86/mach-rdc321x/platform.c
index dda6024..a037041 100644
--- a/arch/x86/mach-rdc321x/platform.c
+++ b/arch/x86/mach-rdc321x/platform.c
@@ -62,6 +62,8 @@ static struct platform_device *rdc321x_devs[] = {
 
 static int __init rdc_board_setup(void)
 {
+	rdc321x_gpio_setup();
+
 	return platform_add_devices(rdc321x_devs, ARRAY_SIZE(rdc321x_devs));
 }
 
diff --git a/include/asm-x86/mach-rdc321x/gpio.h b/include/asm-x86/mach-rdc321x/gpio.h
index db31b92..acce0b7 100644
--- a/include/asm-x86/mach-rdc321x/gpio.h
+++ b/include/asm-x86/mach-rdc321x/gpio.h
@@ -5,19 +5,20 @@ extern int rdc_gpio_get_value(unsigned gpio);
 extern void rdc_gpio_set_value(unsigned gpio, int value);
 extern int rdc_gpio_direction_input(unsigned gpio);
 extern int rdc_gpio_direction_output(unsigned gpio, int value);
-
+extern int rdc_gpio_request(unsigned gpio, const char *label);
+extern void rdc_gpio_free(unsigned gpio);
+extern void __init rdc321x_gpio_setup(void);
 
 /* Wrappers for the arch-neutral GPIO API */
 
 static inline int gpio_request(unsigned gpio, const char *label)
 {
-	/* Not yet implemented */
-	return 0;
+	return rdc_gpio_request(gpio, label);
 }
 
 static inline void gpio_free(unsigned gpio)
 {
-	/* Not yet implemented */
+	rdc_gpio_free(gpio);
 }
 
 static inline int gpio_direction_input(unsigned gpio)
diff --git a/include/asm-x86/mach-rdc321x/rdc321x_defs.h b/include/asm-x86/mach-rdc321x/rdc321x_defs.h
index 838ba8f..c8e9c8b 100644
--- a/include/asm-x86/mach-rdc321x/rdc321x_defs.h
+++ b/include/asm-x86/mach-rdc321x/rdc321x_defs.h
@@ -3,4 +3,10 @@
 /* General purpose configuration and data registers */
 #define RDC3210_CFGREG_ADDR     0x0CF8
 #define RDC3210_CFGREG_DATA     0x0CFC
-#define RDC_MAX_GPIO		0x3A
+
+#define RDC321X_GPIO_CTRL_REG1	0x48
+#define RDC321X_GPIO_CTRL_REG2	0x84
+#define RDC321X_GPIO_DATA_REG1	0x4c
+#define RDC321X_GPIO_DATA_REG2	0x88
+
+#define RDC321X_MAX_GPIO	58
