Return-Path: <linux-kernel-owner+w=401wt.eu-S1762184AbYCDRDU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762184AbYCDRDU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 12:03:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752177AbYCDRDL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 12:03:11 -0500
Received: from rtsoft3.corbina.net ([85.21.88.6]:4629 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751960AbYCDRDK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 12:03:10 -0500
Date: Tue, 4 Mar 2008 20:03:07 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: David Brownell <dbrownell@users.sourceforge.net>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] gpiolib: implement dynamic base allocation
Message-ID: <20080304170307.GA29979@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If gpio_chip->base is negative during registration, gpiolib requests
dynamic base allocation. This is useful for devices being registered
at run-time (in contrast to platform devices).

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
---
 drivers/gpio/gpiolib.c |   42 ++++++++++++++++++++++++++++++++++++------
 1 files changed, 36 insertions(+), 6 deletions(-)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index d8db2f8..1d25104 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -77,6 +77,32 @@ static inline struct gpio_chip *gpio_to_chip(unsigned gpio)
 	return gpio_desc[gpio].chip;
 }
 
+static int gpiochip_find_base(int ngpio)
+{
+	int i;
+	int spare = 0;
+	int next_base = 0;
+	int base = -ENOSPC;
+
+	for (i = 0; i < ARCH_NR_GPIOS; i++) {
+		struct gpio_chip *c = gpio_desc[i].chip;
+
+		if (!c) {
+			spare++;
+			if (spare == ngpio) {
+				base = next_base;
+				break;
+			}
+		} else {
+			spare = 0;
+			i += c->ngpio;
+			next_base = i;
+		}
+	}
+
+	return base;
+}
+
 /**
  * gpiochip_add() - register a gpio_chip
  * @chip: the chip to register, with chip->base initialized
@@ -92,17 +118,21 @@ int gpiochip_add(struct gpio_chip *chip)
 	int		status = 0;
 	unsigned	id;
 
-	/* NOTE chip->base negative is reserved to mean a request for
-	 * dynamic allocation.  We don't currently support that.
-	 */
-
-	if (chip->base < 0 || (chip->base  + chip->ngpio) >= ARCH_NR_GPIOS) {
+	if (chip->base >= 0 && chip->base + chip->ngpio >= ARCH_NR_GPIOS) {
 		status = -EINVAL;
 		goto fail;
 	}
 
 	spin_lock_irqsave(&gpio_lock, flags);
 
+	if (chip->base < 0) {
+		chip->base = gpiochip_find_base(chip->ngpio);
+		if (chip->base < 0) {
+			status = chip->base;
+			goto fail_unlock;
+		}
+	}
+
 	/* these GPIO numbers must not be managed by another gpio_chip */
 	for (id = chip->base; id < chip->base + chip->ngpio; id++) {
 		if (gpio_desc[id].chip != NULL) {
@@ -116,7 +146,7 @@ int gpiochip_add(struct gpio_chip *chip)
 			gpio_desc[id].flags = 0;
 		}
 	}
-
+fail_unlock:
 	spin_unlock_irqrestore(&gpio_lock, flags);
 fail:
 	/* failures here can mean systems won't boot... */
-- 
1.5.2.2
