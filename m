Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936420Ab0CMBXT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 20:23:19 -0500
Received: from kroah.org ([198.145.64.141]:60876 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934932Ab0CMAUS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 19:20:18 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Mar 12 16:15:10 2010
Message-Id: <20100313001510.512481091@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 12 Mar 2010 16:12:39 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Samuel Ortiz <sameo@linux.intel.com>
Subject: [patch 061/123] gpiolib: Actually set output state in wm831x_gpio_direction_output()
In-Reply-To: <20100313001618.GA9811@kroah.com>
In-Reply-To: <20100313001618.GA9811@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let me know.

-----------------

From: Mark Brown <broonie@opensource.wolfsonmicro.com>

commit 3383d23d86791503559cb87837491af37469d9e5 upstream.

wm831x_gpio_direction_output() ignored the state passed into it.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpio/wm831x-gpio.c |   22 +++++++++++++++-------
 1 file changed, 15 insertions(+), 7 deletions(-)

--- a/drivers/gpio/wm831x-gpio.c
+++ b/drivers/gpio/wm831x-gpio.c
@@ -60,23 +60,31 @@ static int wm831x_gpio_get(struct gpio_c
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


