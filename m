Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936409Ab0CMBXL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 20:23:11 -0500
Received: from kroah.org ([198.145.64.141]:60881 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934923Ab0CMAUS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 19:20:18 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Mar 12 16:15:10 2010
Message-Id: <20100313001510.600378013@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 12 Mar 2010 16:12:40 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Ben Gardner <gardner.ben@gmail.com>,
       Andres Salomon <dilinger@collabora.co.uk>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [patch 062/123] gpio: cs5535-gpio: fix input direction
In-Reply-To: <20100313001618.GA9811@kroah.com>
In-Reply-To: <20100313001618.GA9811@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let me know.

-----------------

From: Ben Gardner <gardner.ben@gmail.com>

commit a8a5164c297c16c2f4be776714ca47dba252cc3d upstream.

The cs5535-gpio driver's get() function was returning the output value.
This means that the GPIO pins would never work as an input, even if
configured as an input.

The driver should return the READ_BACK value, which is the sensed line
value.  To make that work when the direction is 'output', INPUT_ENABLE
needs to be set.

In addition, the driver was not disabling OUTPUT_ENABLE when the direction
is set to 'input'.  That would cause the GPIO to continue to drive the pin
if the direction was ever set to output.

This issue was noticed when attempting to use the gpiolib driver to read
an external input.  I had previously been using the char/cs5535-gpio
driver.

Signed-off-by: Ben Gardner <gardner.ben@gmail.com>
Acked-by: Andres Salomon <dilinger@collabora.co.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: David Brownell <dbrownell@users.sourceforge.net>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpio/cs5535-gpio.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/gpio/cs5535-gpio.c
+++ b/drivers/gpio/cs5535-gpio.c
@@ -154,7 +154,7 @@ static int chip_gpio_request(struct gpio
 
 static int chip_gpio_get(struct gpio_chip *chip, unsigned offset)
 {
-	return cs5535_gpio_isset(offset, GPIO_OUTPUT_VAL);
+	return cs5535_gpio_isset(offset, GPIO_READ_BACK);
 }
 
 static void chip_gpio_set(struct gpio_chip *chip, unsigned offset, int val)
@@ -172,6 +172,7 @@ static int chip_direction_input(struct g
 
 	spin_lock_irqsave(&chip->lock, flags);
 	__cs5535_gpio_set(chip, offset, GPIO_INPUT_ENABLE);
+	__cs5535_gpio_clear(chip, offset, GPIO_OUTPUT_ENABLE);
 	spin_unlock_irqrestore(&chip->lock, flags);
 
 	return 0;
@@ -184,6 +185,7 @@ static int chip_direction_output(struct
 
 	spin_lock_irqsave(&chip->lock, flags);
 
+	__cs5535_gpio_set(chip, offset, GPIO_INPUT_ENABLE);
 	__cs5535_gpio_set(chip, offset, GPIO_OUTPUT_ENABLE);
 	if (val)
 		__cs5535_gpio_set(chip, offset, GPIO_OUTPUT_VAL);


