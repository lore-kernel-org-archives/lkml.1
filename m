Return-Path: <linux-kernel-owner+w=401wt.eu-S1754458AbYCKRll@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754458AbYCKRll (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 13:41:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752699AbYCKRlW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 13:41:22 -0400
Received: from rtsoft3.corbina.net ([85.21.88.6]:24411 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752676AbYCKRlU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 13:41:20 -0400
Date: Tue, 11 Mar 2008 20:41:16 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: David Brownell <dbrownell@users.sourceforge.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] gpiolib: implement dynamic base allocation
Message-ID: <20080311174116.GA12397@localhost.localdomain>
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

To avoid reusing any numbers that may have been explicitly assigned,
but not yet registered, dynamic gpio base allocator will assign GPIO
numbers from the biggest number on down, instead of from the smallest
on up.

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
---

Rebased on top of v2.6.25-rc3-mm1

 drivers/gpio/gpiolib.c |   43 ++++++++++++++++++++++++++++++++++++++-----
 1 files changed, 38 insertions(+), 5 deletions(-)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index 623fcd9..81d81c9 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -80,6 +80,33 @@ static inline struct gpio_chip *gpio_to_chip(unsigned gpio)
 	return gpio_desc[gpio].chip;
 }
 
+static int gpiochip_find_base(int ngpio)
+{
+	int i;
+	int spare = 0;
+	int base = -ENOSPC;
+
+	for (i = ARCH_NR_GPIOS - 1; i >= 0 ; i--) {
+		struct gpio_chip *chip = gpio_desc[i].chip;
+
+		if (!chip) {
+			spare++;
+			if (spare == ngpio) {
+				base = i;
+				break;
+			}
+		} else {
+			spare = 0;
+			i -= chip->ngpio - 1;
+		}
+	}
+
+	if (gpio_is_valid(base))
+		pr_debug("%s: found new base at %d\n", __func__, base);
+
+	return base;
+}
+
 /**
  * gpiochip_add() - register a gpio_chip
  * @chip: the chip to register, with chip->base initialized
@@ -95,17 +122,22 @@ int gpiochip_add(struct gpio_chip *chip)
 	int		status = 0;
 	unsigned	id;
 
-	/* NOTE chip->base negative is reserved to mean a request for
-	 * dynamic allocation.  We don't currently support that.
-	 */
-
-	if (chip->base < 0 || !gpio_is_valid(chip->base  + chip->ngpio)) {
+	if (gpio_is_valid(chip->base) &&
+			!gpio_is_valid(chip->base  + chip->ngpio)) {
 		status = -EINVAL;
 		goto fail;
 	}
 
 	spin_lock_irqsave(&gpio_lock, flags);
 
+	if (!gpio_is_valid(chip->base)) {
+		chip->base = gpiochip_find_base(chip->ngpio);
+		if (!gpio_is_valid(chip->base)) {
+			status = chip->base;
+			goto fail_unlock;
+		}
+	}
+
 	/* these GPIO numbers must not be managed by another gpio_chip */
 	for (id = chip->base; id < chip->base + chip->ngpio; id++) {
 		if (gpio_desc[id].chip != NULL) {
@@ -120,6 +152,7 @@ int gpiochip_add(struct gpio_chip *chip)
 		}
 	}
 
+fail_unlock:
 	spin_unlock_irqrestore(&gpio_lock, flags);
 fail:
 	/* failures here can mean systems won't boot... */
-- 
1.5.2.2

