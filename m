Return-Path: <linux-kernel-owner+w=401wt.eu-S932732AbZJAOlU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932732AbZJAOlU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 10:41:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932723AbZJAOlT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 10:41:19 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:34127 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932720AbZJAOlR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 10:41:17 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       David Brownell <dbrownell@users.sourceforge.net>
Subject: [PATCH 2/4] gpiolib: Make WM831x GPIO count dynamic
Date: Thu,  1 Oct 2009 15:41:05 +0100
Message-Id: <1254408067-15908-2-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.6.4.3
In-Reply-To: <1254408067-15908-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1254408067-15908-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This supports future devices with fewer GPIOs.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: David Brownell <dbrownell@users.sourceforge.net>
---
 drivers/gpio/wm831x-gpio.c      |    4 +---
 drivers/mfd/wm831x-core.c       |    3 +++
 include/linux/mfd/wm831x/core.h |    2 ++
 3 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/gpio/wm831x-gpio.c b/drivers/gpio/wm831x-gpio.c
index f9c09a5..f5e4934 100644
--- a/drivers/gpio/wm831x-gpio.c
+++ b/drivers/gpio/wm831x-gpio.c
@@ -23,8 +23,6 @@
 #include <linux/mfd/wm831x/pdata.h>
 #include <linux/mfd/wm831x/gpio.h>
 
-#define WM831X_GPIO_MAX 16
-
 struct wm831x_gpio {
 	struct wm831x *wm831x;
 	struct gpio_chip gpio_chip;
@@ -192,7 +190,7 @@ static int __devinit wm831x_gpio_probe(struct platform_device *pdev)
 
 	wm831x_gpio->wm831x = wm831x;
 	wm831x_gpio->gpio_chip = template_chip;
-	wm831x_gpio->gpio_chip.ngpio = WM831X_GPIO_MAX;
+	wm831x_gpio->gpio_chip.ngpio = wm831x->num_gpio;
 	wm831x_gpio->gpio_chip.dev = &pdev->dev;
 	if (pdata && pdata->gpio_base)
 		wm831x_gpio->gpio_chip.base = pdata->gpio_base;
diff --git a/drivers/mfd/wm831x-core.c b/drivers/mfd/wm831x-core.c
index 143ab83..fa651e5 100644
--- a/drivers/mfd/wm831x-core.c
+++ b/drivers/mfd/wm831x-core.c
@@ -1293,16 +1293,19 @@ static int wm831x_device_init(struct wm831x *wm831x, unsigned long id, int irq)
 	switch (ret) {
 	case WM8310:
 		parent = WM8310;
+		wm831x->num_gpio = 16;
 		dev_info(wm831x->dev, "WM8310 revision %c\n", 'A' + rev);
 		break;
 
 	case WM8311:
 		parent = WM8311;
+		wm831x->num_gpio = 16;
 		dev_info(wm831x->dev, "WM8311 revision %c\n", 'A' + rev);
 		break;
 
 	case WM8312:
 		parent = WM8312;
+		wm831x->num_gpio = 16;
 		dev_info(wm831x->dev, "WM8312 revision %c\n", 'A' + rev);
 		break;
 
diff --git a/include/linux/mfd/wm831x/core.h b/include/linux/mfd/wm831x/core.h
index 91eb493..c1bc59f 100644
--- a/include/linux/mfd/wm831x/core.h
+++ b/include/linux/mfd/wm831x/core.h
@@ -253,6 +253,8 @@ struct wm831x {
 	unsigned int irq_base;
 	int irq_masks[5];
 
+	int num_gpio;
+
 	struct mutex auxadc_lock;
 
 	/* The WM831x has a security key blocking access to certain
-- 
1.6.4.3

