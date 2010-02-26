Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759547Ab0BZX0y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 18:26:54 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:44614 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753691Ab0BZX0s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 18:26:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=s9ANVe1gR1jEKApjDZB+WfWHPLQkKPfa5JMsCfNLtI81+LuT1ZVQnD1H4lc/gJ2vMn
         lcdr2kAiig5QNMUobrqOK4UCMwmAEAtyhkQoqx9p/9JghARVg20kLS20BvL5hHxv93B/
         qxJmCBWVMfugHM6uY8ta09BJGN/X4JrTf8Vzk=
From: Ben Gardner <gardner.ben@gmail.com>
To: linux-kernel@vger.kernel.org, Andres Salomon <dilinger@collabora.co.uk>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Ben Gardner <gardner.ben@gmail.com>,
       Andres Salomon <dilinger@collabora.co.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Jani Nikula <ext-jani.1.nikula@nokia.com>
Subject: [PATCH 2/3] cs5535-gpio: Use set_direction
Date: Fri, 26 Feb 2010 17:26:25 -0600
Message-Id: <6787cce8528c344c496724509762b2a11dea4bfb.1267225701.git.gardner.ben@gmail.com>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <cover.1267225701.git.gardner.ben@gmail.com>
References: <cover.1267225701.git.gardner.ben@gmail.com>
In-Reply-To: <cover.1267225701.git.gardner.ben@gmail.com>
References: <cover.1267225701.git.gardner.ben@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The CS5535 GPIO has independant controls for input and output enable.
Use the set_direction method instead of direction_input and direction_output
to enable use of the bidirectional mode.

Signed-off-by: Ben Gardner <gardner.ben@gmail.com>
CC: Andres Salomon <dilinger@collabora.co.uk>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: David Brownell <dbrownell@users.sourceforge.net>
CC: Jani Nikula <ext-jani.1.nikula@nokia.com>
---
 drivers/gpio/cs5535-gpio.c |   34 +++++++++++++++-------------------
 1 files changed, 15 insertions(+), 19 deletions(-)

diff --git a/drivers/gpio/cs5535-gpio.c b/drivers/gpio/cs5535-gpio.c
index 0fdbe94..0cb1462 100644
--- a/drivers/gpio/cs5535-gpio.c
+++ b/drivers/gpio/cs5535-gpio.c
@@ -165,30 +165,27 @@ static void chip_gpio_set(struct gpio_chip *chip, unsigned offset, int val)
 		cs5535_gpio_clear(offset, GPIO_OUTPUT_VAL);
 }
 
-static int chip_direction_input(struct gpio_chip *c, unsigned offset)
-{
-	struct cs5535_gpio_chip *chip = (struct cs5535_gpio_chip *) c;
-	unsigned long flags;
-
-	spin_lock_irqsave(&chip->lock, flags);
-	__cs5535_gpio_set(chip, offset, GPIO_INPUT_ENABLE);
-	spin_unlock_irqrestore(&chip->lock, flags);
-
-	return 0;
-}
-
-static int chip_direction_output(struct gpio_chip *c, unsigned offset, int val)
+static int chip_set_direction(struct gpio_chip *c, unsigned offset,
+		int direction, int value)
 {
 	struct cs5535_gpio_chip *chip = (struct cs5535_gpio_chip *) c;
 	unsigned long flags;
 
 	spin_lock_irqsave(&chip->lock, flags);
 
-	__cs5535_gpio_set(chip, offset, GPIO_OUTPUT_ENABLE);
-	if (val)
-		__cs5535_gpio_set(chip, offset, GPIO_OUTPUT_VAL);
+	if (direction & 1)
+		__cs5535_gpio_set(chip, offset, GPIO_INPUT_ENABLE);
 	else
-		__cs5535_gpio_clear(chip, offset, GPIO_OUTPUT_VAL);
+		__cs5535_gpio_clear(chip, offset, GPIO_INPUT_ENABLE);
+
+	if (direction & 2) {
+		if (value)
+			__cs5535_gpio_set(chip, offset, GPIO_OUTPUT_VAL);
+		else
+			__cs5535_gpio_clear(chip, offset, GPIO_OUTPUT_VAL);
+		__cs5535_gpio_set(chip, offset, GPIO_OUTPUT_ENABLE);
+	} else
+		__cs5535_gpio_clear(chip, offset, GPIO_OUTPUT_ENABLE);
 
 	spin_unlock_irqrestore(&chip->lock, flags);
 
@@ -219,8 +216,7 @@ static struct cs5535_gpio_chip cs5535_gpio_chip = {
 		.get = chip_gpio_get,
 		.set = chip_gpio_set,
 
-		.direction_input = chip_direction_input,
-		.direction_output = chip_direction_output,
+		.set_direction = chip_set_direction,
 	},
 };
 
-- 
1.7.0

