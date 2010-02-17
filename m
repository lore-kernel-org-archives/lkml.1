Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753510Ab0BQSEn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 13:04:43 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:35235 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753452Ab0BQSEm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 13:04:42 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>, stable@kernel.org
Subject: [PATCH] gpiolib: Actually set output state in wm831x_gpio_direction_output()
Date: Wed, 17 Feb 2010 18:04:35 +0000
Message-Id: <1266429875-4046-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.6.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

wm831x_gpio_direction_output() ignored the state passed into it.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: stable@kernel.org
---

Ideally this could make it into 2.6.33, though it's not super critical
and it's probably reasonable to handle it via the stable releases.

 drivers/gpio/wm831x-gpio.c |   22 +++++++++++++++-------
 1 files changed, 15 insertions(+), 7 deletions(-)

diff --git a/drivers/gpio/wm831x-gpio.c b/drivers/gpio/wm831x-gpio.c
index b4468b6..c5a00f7 100644
--- a/drivers/gpio/wm831x-gpio.c
+++ b/drivers/gpio/wm831x-gpio.c
@@ -60,23 +60,31 @@ static int wm831x_gpio_get(struct gpio_chip *chip, unsigned offset)
 		return 0;
 }
 
-static int wm831x_gpio_direction_out(struct gpio_chip *chip,
-				     unsigned offset, int value)
+static void wm831x_gpio_set(struct gpio_chip *chip, unsigned offset, int value)
 {
 	struct wm831x_gpio *wm831x_gpio = to_wm831x_gpio(chip);
 	struct wm831x *wm831x = wm831x_gpio->wm831x;
 
-	return wm831x_set_bits(wm831x, WM831X_GPIO1_CONTROL + offset,
-			       WM831X_GPN_DIR | WM831X_GPN_TRI, 0);
+	wm831x_set_bits(wm831x, WM831X_GPIO_LEVEL, 1 << offset,
+			value << offset);
 }
 
-static void wm831x_gpio_set(struct gpio_chip *chip, unsigned offset, int value)
+static int wm831x_gpio_direction_out(struct gpio_chip *chip,
+				     unsigned offset, int value)
 {
 	struct wm831x_gpio *wm831x_gpio = to_wm831x_gpio(chip);
 	struct wm831x *wm831x = wm831x_gpio->wm831x;
+	int ret;
 
-	wm831x_set_bits(wm831x, WM831X_GPIO_LEVEL, 1 << offset,
-			value << offset);
+	ret = wm831x_set_bits(wm831x, WM831X_GPIO1_CONTROL + offset,
+			      WM831X_GPN_DIR | WM831X_GPN_TRI, 0);
+	if (ret < 0)
+		return ret;
+
+	/* Can only set GPIO state once it's in output mode */
+	wm831x_gpio_set(chip, offset, value);
+
+	return 0;
 }
 
 static int wm831x_gpio_to_irq(struct gpio_chip *chip, unsigned offset)
-- 
1.6.6.1

