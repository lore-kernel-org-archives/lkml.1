Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754020Ab0BQSpi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 13:45:38 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:56902 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753844Ab0BQSpd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 13:45:33 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 2/3] mfd: Add WM831x revision B support
Date: Wed, 17 Feb 2010 18:45:25 +0000
Message-Id: <1266432326-13030-2-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.6.6.1
In-Reply-To: <1266432326-13030-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1266432326-13030-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Revision B of the WM831x devices changes the sense of the tristate
bit for GPIO configuration, inverting it to become an enable instead.
Take account of this in the gpiolib driver.

A current sink regulation status bit has also been added in revision B,
add a flag indicating if it's present but don't use it yet.

This revision also adds an interrupt on key up for the ON pin event
which the existing code is able to take advantage of.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/gpio/wm831x-gpio.c      |   21 ++++++++++++++++-----
 drivers/mfd/wm831x-core.c       |   15 +++++++++++++++
 include/linux/mfd/wm831x/core.h |    4 ++++
 include/linux/mfd/wm831x/gpio.h |    4 ++++
 4 files changed, 39 insertions(+), 5 deletions(-)

diff --git a/drivers/gpio/wm831x-gpio.c b/drivers/gpio/wm831x-gpio.c
index 2554180..5b8dc09 100644
--- a/drivers/gpio/wm831x-gpio.c
+++ b/drivers/gpio/wm831x-gpio.c
@@ -38,10 +38,13 @@ static int wm831x_gpio_direction_in(struct gpio_chip *chip, unsigned offset)
 {
 	struct wm831x_gpio *wm831x_gpio = to_wm831x_gpio(chip);
 	struct wm831x *wm831x = wm831x_gpio->wm831x;
+	int val = WM831X_GPN_DIR;
+
+	if (wm831x->has_gpio_ena)
+		val |= WM831X_GPN_TRI;
 
 	return wm831x_set_bits(wm831x, WM831X_GPIO1_CONTROL + offset,
-			       WM831X_GPN_DIR | WM831X_GPN_TRI,
-			       WM831X_GPN_DIR);
+			       WM831X_GPN_DIR | WM831X_GPN_TRI, val);
 }
 
 static int wm831x_gpio_get(struct gpio_chip *chip, unsigned offset)
@@ -74,10 +77,14 @@ static int wm831x_gpio_direction_out(struct gpio_chip *chip,
 {
 	struct wm831x_gpio *wm831x_gpio = to_wm831x_gpio(chip);
 	struct wm831x *wm831x = wm831x_gpio->wm831x;
+	int val = 0;
 	int ret;
 
+	if (wm831x->has_gpio_ena)
+		val |= WM831X_GPN_TRI;
+
 	ret = wm831x_set_bits(wm831x, WM831X_GPIO1_CONTROL + offset,
-			      WM831X_GPN_DIR | WM831X_GPN_TRI, 0);
+			      WM831X_GPN_DIR | WM831X_GPN_TRI, val);
 	if (ret < 0)
 		return ret;
 
@@ -103,7 +110,7 @@ static void wm831x_gpio_dbg_show(struct seq_file *s, struct gpio_chip *chip)
 {
 	struct wm831x_gpio *wm831x_gpio = to_wm831x_gpio(chip);
 	struct wm831x *wm831x = wm831x_gpio->wm831x;
-	int i;
+	int i, tristated;
 
 	for (i = 0; i < chip->ngpio; i++) {
 		int gpio = i + chip->base;
@@ -170,6 +177,10 @@ static void wm831x_gpio_dbg_show(struct seq_file *s, struct gpio_chip *chip)
 			break;
 		}
 
+		tristated = reg & WM831X_GPN_TRI;
+		if (wm831x->has_gpio_ena)
+			tristated = !tristated;
+
 		seq_printf(s, " %s %s %s %s%s\n"
 			   "                                  %s%s (0x%4x)\n",
 			   reg & WM831X_GPN_DIR ? "in" : "out",
@@ -178,7 +189,7 @@ static void wm831x_gpio_dbg_show(struct seq_file *s, struct gpio_chip *chip)
 			   powerdomain,
 			   reg & WM831X_GPN_POL ? "" : " inverted",
 			   reg & WM831X_GPN_OD ? "open-drain" : "CMOS",
-			   reg & WM831X_GPN_TRI ? " tristated" : "",
+			   tristated ? " tristated" : "",
 			   reg);
 	}
 }
diff --git a/drivers/mfd/wm831x-core.c b/drivers/mfd/wm831x-core.c
index 2c93679..07101e9 100644
--- a/drivers/mfd/wm831x-core.c
+++ b/drivers/mfd/wm831x-core.c
@@ -1459,18 +1459,33 @@ static int wm831x_device_init(struct wm831x *wm831x, unsigned long id, int irq)
 	case WM8310:
 		parent = WM8310;
 		wm831x->num_gpio = 16;
+		if (rev > 0) {
+			wm831x->has_gpio_ena = 1;
+			wm831x->has_cs_sts = 1;
+		}
+
 		dev_info(wm831x->dev, "WM8310 revision %c\n", 'A' + rev);
 		break;
 
 	case WM8311:
 		parent = WM8311;
 		wm831x->num_gpio = 16;
+		if (rev > 0) {
+			wm831x->has_gpio_ena = 1;
+			wm831x->has_cs_sts = 1;
+		}
+
 		dev_info(wm831x->dev, "WM8311 revision %c\n", 'A' + rev);
 		break;
 
 	case WM8312:
 		parent = WM8312;
 		wm831x->num_gpio = 16;
+		if (rev > 0) {
+			wm831x->has_gpio_ena = 1;
+			wm831x->has_cs_sts = 1;
+		}
+
 		dev_info(wm831x->dev, "WM8312 revision %c\n", 'A' + rev);
 		break;
 
diff --git a/include/linux/mfd/wm831x/core.h b/include/linux/mfd/wm831x/core.h
index a95d2da..5915f6e 100644
--- a/include/linux/mfd/wm831x/core.h
+++ b/include/linux/mfd/wm831x/core.h
@@ -255,6 +255,10 @@ struct wm831x {
 	int irq_masks_cur[WM831X_NUM_IRQ_REGS];   /* Currently active value */
 	int irq_masks_cache[WM831X_NUM_IRQ_REGS]; /* Cached hardware value */
 
+	/* Chip revision based flags */
+	unsigned has_gpio_ena:1;  /* Has GPIO enable bit */
+	unsigned has_cs_sts:1;    /* Has current sink status bit */
+
 	int num_gpio;
 
 	struct mutex auxadc_lock;
diff --git a/include/linux/mfd/wm831x/gpio.h b/include/linux/mfd/wm831x/gpio.h
index 2835614..9b163c5 100644
--- a/include/linux/mfd/wm831x/gpio.h
+++ b/include/linux/mfd/wm831x/gpio.h
@@ -41,6 +41,10 @@
 #define WM831X_GPN_OD_MASK                      0x0200  /* GPN_OD */
 #define WM831X_GPN_OD_SHIFT                          9  /* GPN_OD */
 #define WM831X_GPN_OD_WIDTH                          1  /* GPN_OD */
+#define WM831X_GPN_ENA                          0x0080  /* GPN_ENA */
+#define WM831X_GPN_ENA_MASK                     0x0080  /* GPN_ENA */
+#define WM831X_GPN_ENA_SHIFT                         7  /* GPN_ENA */
+#define WM831X_GPN_ENA_WIDTH                         1  /* GPN_ENA */
 #define WM831X_GPN_TRI                          0x0080  /* GPN_TRI */
 #define WM831X_GPN_TRI_MASK                     0x0080  /* GPN_TRI */
 #define WM831X_GPN_TRI_SHIFT                         7  /* GPN_TRI */
-- 
1.6.6.1

