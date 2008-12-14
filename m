Return-Path: <linux-kernel-owner+w=401wt.eu-S1754886AbYLNLhG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754886AbYLNLhG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2008 06:37:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754621AbYLNLfk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Dec 2008 06:35:40 -0500
Received: from mail.openmoko.org ([88.198.124.205]:34176 "EHLO
	mail.openmoko.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754595AbYLNLfj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2008 06:35:39 -0500
From: Balaji Rao <balajirrao@openmoko.org>
Subject: [PATCH 3/7] mfd: PCF50633 gpio support
To: linux-kernel@vger.kernel.org
Cc: Balaji Rao <balajirrao@openmoko.org>, Andy Green <andy@openmoko.com>,
       Samuel Ortiz <sameo@openedhand.com>
Date: Sun, 14 Dec 2008 16:32:47 +0530
Message-ID: <20081214110247.3307.20798.stgit@cff.thadambail>
In-Reply-To: <20081214110152.3307.50843.stgit@cff.thadambail>
References: <20081214110152.3307.50843.stgit@cff.thadambail>
User-Agent: StGIT/0.14.3.270.g0f36
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

What the PCF05633 calls as a 'GPIO' is much more than the GPIO in the linux
sense and there are only 4 of them - which means, the gpiolib is not used
here.

Signed-off-by: Balaji Rao <balajirrao@openmoko.org>
Cc: Andy Green <andy@openmoko.com>
Cc: Samuel Ortiz <sameo@openedhand.com>
---
 drivers/mfd/Kconfig         |    7 ++++
 drivers/mfd/Makefile        |    1 +
 drivers/mfd/pcf50633-gpio.c |   86 +++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 94 insertions(+), 0 deletions(-)
 create mode 100644 drivers/mfd/pcf50633-gpio.c

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 02e3d73..cdb178b 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -169,6 +169,13 @@ config PCF50633_ADC
 	 Say yes here if you want to include support for ADC in the
 	 NXP PCF50633 chip.
 
+config PCF50633_GPIO
+	tristate "Support for NXP PCF50633 GPIO"
+	depends on MFD_PCF50633
+	help
+	 Say yes here if you want to include support GPIO for pins on
+	 the PCF50633 chip.
+
 endmenu
 
 menu "Multimedia Capabilities Port drivers"
diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index 7a12b09..5bc7c9f 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -35,3 +35,4 @@ obj-$(CONFIG_PMIC_DA903X)	+= da903x.o
 
 obj-$(CONFIG_MFD_PCF50633)	+= pcf50633-core.o
 obj-$(CONFIG_PCF50633_ADC)	+= pcf50633-adc.o
+obj-$(CONFIG_PCF50633_GPIO)	+= pcf50633-gpio.o
diff --git a/drivers/mfd/pcf50633-gpio.c b/drivers/mfd/pcf50633-gpio.c
new file mode 100644
index 0000000..79cab89
--- /dev/null
+++ b/drivers/mfd/pcf50633-gpio.c
@@ -0,0 +1,86 @@
+/* NXP PCF50633 GPIO Driver
+ *
+ * (C) 2006-2008 by Openmoko, Inc.
+ * Author: Balaji Rao <balajirrao@openmoko.org>
+ * All rights reserved.
+ *
+ * Broken down from monstrous PCF50633 driver mainly by
+ * Harald Welte, Andy Green and Werner Almesberger
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation; either version 2 of
+ * the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston,
+ * MA 02111-1307 USA
+ */
+
+#include <linux/mfd/pcf50633/core.h>
+#include <linux/mfd/pcf50633/gpio.h>
+#include <linux/mfd/pcf50633/pmic.h>
+
+int pcf50633_gpio_set(struct pcf50633 *pcf, int gpio, u8 val)
+{
+	u8 reg;
+
+	reg = gpio - PCF50633_GPIO1 + PCF50633_REG_GPIO1CFG;
+
+	return pcf50633_reg_set_bit_mask(pcf, reg, 0x07, val);
+}
+EXPORT_SYMBOL_GPL(pcf50633_gpio_set);
+
+u8 pcf50633_gpio_get(struct pcf50633 *pcf, int gpio)
+{
+	u8 reg, val;
+
+	reg = gpio - PCF50633_GPIO1 + PCF50633_REG_GPIO1CFG;
+	val = pcf50633_reg_read(pcf, reg) & 0x07;
+
+	return val;
+}
+EXPORT_SYMBOL_GPL(pcf50633_gpio_get);
+
+int pcf50633_gpio_invert_set(struct pcf50633 *pcf, int gpio, int invert)
+{
+	u8 val, reg;
+
+	reg = gpio - PCF50633_GPIO1 + PCF50633_REG_GPIO1CFG;
+	val = !!invert << 3;
+
+	return pcf50633_reg_set_bit_mask(pcf, reg, 1 << 3, val);
+}
+EXPORT_SYMBOL_GPL(pcf50633_gpio_invert_set);
+
+int pcf50633_gpio_invert_get(struct pcf50633 *pcf, int gpio)
+{
+	u8 reg, val;
+
+	reg = gpio - PCF50633_GPIO1 + PCF50633_REG_GPIO1CFG;
+	val = pcf50633_reg_read(pcf, reg);
+
+	return val & (1 << 3);
+}
+EXPORT_SYMBOL_GPL(pcf50633_gpio_invert_get);
+
+int pcf50633_gpio_power_supply_set(struct pcf50633 *pcf,
+					int gpio, int regulator, int on)
+{
+	u8 reg, val, mask;
+
+	/* the *ENA register is always one after the *OUT register */
+	reg = pcf50633_regulator_registers[regulator] + 1;
+
+	val = !!on << (gpio - PCF50633_GPIO1);
+	mask = 1 << (gpio - PCF50633_GPIO1);
+
+	return pcf50633_reg_set_bit_mask(pcf, reg, mask, val);
+}
+EXPORT_SYMBOL_GPL(pcf50633_gpio_power_supply_set);

