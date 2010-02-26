Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759549Ab0BZX1L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 18:27:11 -0500
Received: from mail-yx0-f182.google.com ([209.85.210.182]:61873 "EHLO
	mail-yx0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759529Ab0BZX0v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 18:26:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=so9giCB/XvRMXdqeoZUzeQeyAFthVlaNazGwlX8xWcvXURn6O553xIWOKR3+YsIbav
         c2HU4ww+eFVbfSKb/hhhMW0BJWGsNHT38Hc53wqBQL4M3wfQS2iN+CuXzW8jjMaTmdDx
         63uFWObARLrpGGGd3ZtSOTviWoGfLo3O6CAac=
From: Ben Gardner <gardner.ben@gmail.com>
To: linux-kernel@vger.kernel.org, Andres Salomon <dilinger@collabora.co.uk>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Ben Gardner <gardner.ben@gmail.com>,
       Andres Salomon <dilinger@collabora.co.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Jani Nikula <ext-jani.1.nikula@nokia.com>
Subject: [PATCH 1/3] gpiolib: add gpio_set_direction()
Date: Fri, 26 Feb 2010 17:26:24 -0600
Message-Id: <14e456b7d269efd860bb36c312de2bc4ad504dca.1267225701.git.gardner.ben@gmail.com>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <cover.1267225701.git.gardner.ben@gmail.com>
References: <cover.1267225701.git.gardner.ben@gmail.com>
In-Reply-To: <cover.1267225701.git.gardner.ben@gmail.com>
References: <cover.1267225701.git.gardner.ben@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Combine gpio_direction_input() and gpio_direction_output() into
gpio_set_direction().
Add 'none' and 'inout' directions to the sysfs interface.

Signed-off-by: Ben Gardner <gardner.ben@gmail.com>
CC: Andres Salomon <dilinger@collabora.co.uk>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: David Brownell <dbrownell@users.sourceforge.net>
CC: Jani Nikula <ext-jani.1.nikula@nokia.com>
---
 drivers/gpio/gpiolib.c     |  123 ++++++++++++++++++++++----------------------
 include/asm-generic/gpio.h |    6 ++
 include/linux/gpio.h       |    5 ++
 3 files changed, 73 insertions(+), 61 deletions(-)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index 350842a..4dd6e44 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -47,13 +47,14 @@ struct gpio_desc {
 	unsigned long		flags;
 /* flag symbols are bit numbers */
 #define FLAG_REQUESTED	0
-#define FLAG_IS_OUT	1
+#define FLAG_IS_OUT	1	/* output is enabled */
 #define FLAG_RESERVED	2
 #define FLAG_EXPORT	3	/* protected by sysfs_lock */
 #define FLAG_SYSFS	4	/* exported via /sys/class/gpio/control */
 #define FLAG_TRIG_FALL	5	/* trigger on falling edge */
 #define FLAG_TRIG_RISE	6	/* trigger on rising edge */
 #define FLAG_ACTIVE_LOW	7	/* sysfs value has active low */
+#define FLAG_IS_IN	8	/* input is enabled */
 
 #define PDESC_ID_SHIFT	16	/* add new flags before this one */
 
@@ -228,10 +229,14 @@ static ssize_t gpio_direction_show(struct device *dev,
 
 	if (!test_bit(FLAG_EXPORT, &desc->flags))
 		status = -EIO;
-	else
-		status = sprintf(buf, "%s\n",
-			test_bit(FLAG_IS_OUT, &desc->flags)
-				? "out" : "in");
+	else {
+		status = ((test_bit(FLAG_IS_IN, &desc->flags) ? 1 : 0) |
+			  (test_bit(FLAG_IS_OUT, &desc->flags) ? 2 : 0));
+		status = sprintf(buf, "%s%s%s\n",
+				 (status == 0) ? "none" : "",
+				 (status & 1) ? "in" : "",
+				 (status & 2) ? "out" : "");
+	}
 
 	mutex_unlock(&sysfs_lock);
 	return status;
@@ -249,11 +254,15 @@ static ssize_t gpio_direction_store(struct device *dev,
 	if (!test_bit(FLAG_EXPORT, &desc->flags))
 		status = -EIO;
 	else if (sysfs_streq(buf, "high"))
-		status = gpio_direction_output(gpio, 1);
+		status = gpio_set_direction(gpio, 2, 1);
 	else if (sysfs_streq(buf, "out") || sysfs_streq(buf, "low"))
-		status = gpio_direction_output(gpio, 0);
+		status = gpio_set_direction(gpio, 2, 0);
 	else if (sysfs_streq(buf, "in"))
-		status = gpio_direction_input(gpio);
+		status = gpio_set_direction(gpio, 1, 0);
+	else if (sysfs_streq(buf, "inout"))
+		status = gpio_set_direction(gpio, 3, 0);
+	else if (sysfs_streq(buf, "none"))
+		status = gpio_set_direction(gpio, 0, 0);
 	else
 		status = -EINVAL;
 
@@ -1277,7 +1286,7 @@ EXPORT_SYMBOL_GPL(gpiochip_is_requested);
  * rely on gpio_request() having been called beforehand.
  */
 
-int gpio_direction_input(unsigned gpio)
+int gpio_set_direction(unsigned gpio, int direction, int value)
 {
 	unsigned long		flags;
 	struct gpio_chip	*chip;
@@ -1289,7 +1298,13 @@ int gpio_direction_input(unsigned gpio)
 	if (!gpio_is_valid(gpio))
 		goto fail;
 	chip = desc->chip;
-	if (!chip || !chip->get || !chip->direction_input)
+	if (!chip)
+		goto fail;
+	if ((direction & 1) &&
+	    (!chip->get || (!chip->direction_input && !chip->set_direction)))
+		goto fail;
+	if ((direction & 2) &&
+	    (!chip->set || (!chip->direction_output && !chip->set_direction)))
 		goto fail;
 	gpio -= chip->base;
 	if (gpio >= chip->ngpio)
@@ -1316,9 +1331,36 @@ int gpio_direction_input(unsigned gpio)
 		}
 	}
 
-	status = chip->direction_input(chip, gpio);
-	if (status == 0)
-		clear_bit(FLAG_IS_OUT, &desc->flags);
+	if (chip->set_direction) {
+		status = chip->set_direction(chip, gpio, direction, value);
+		if (status == 0) {
+			if (direction & 1)
+				set_bit(FLAG_IS_IN, &desc->flags);
+			else
+				clear_bit(FLAG_IS_IN, &desc->flags);
+			if (direction & 2)
+				set_bit(FLAG_IS_OUT, &desc->flags);
+			else
+				clear_bit(FLAG_IS_OUT, &desc->flags);
+		}
+	}
+	else if (direction == 1) {
+		status = chip->direction_input(chip, gpio);
+		if (status == 0) {
+			clear_bit(FLAG_IS_OUT, &desc->flags);
+			set_bit(FLAG_IS_IN, &desc->flags);
+		}
+	}
+	else if (direction == 2) {
+		status = chip->direction_output(chip, gpio, value);
+		if (status == 0) {
+			clear_bit(FLAG_IS_IN, &desc->flags);
+			set_bit(FLAG_IS_OUT, &desc->flags);
+		}
+	}
+	else
+		/* cannot do 'none' or 'inout' without chip->set_direction */
+		status = -ENOTSUPP;
 lose:
 	return status;
 fail:
@@ -1328,58 +1370,17 @@ fail:
 			__func__, gpio, status);
 	return status;
 }
+EXPORT_SYMBOL_GPL(gpio_set_direction);
+
+int gpio_direction_input(unsigned gpio)
+{
+	return gpio_set_direction(gpio, 1, 0);
+}
 EXPORT_SYMBOL_GPL(gpio_direction_input);
 
 int gpio_direction_output(unsigned gpio, int value)
 {
-	unsigned long		flags;
-	struct gpio_chip	*chip;
-	struct gpio_desc	*desc = &gpio_desc[gpio];
-	int			status = -EINVAL;
-
-	spin_lock_irqsave(&gpio_lock, flags);
-
-	if (!gpio_is_valid(gpio))
-		goto fail;
-	chip = desc->chip;
-	if (!chip || !chip->set || !chip->direction_output)
-		goto fail;
-	gpio -= chip->base;
-	if (gpio >= chip->ngpio)
-		goto fail;
-	status = gpio_ensure_requested(desc, gpio);
-	if (status < 0)
-		goto fail;
-
-	/* now we know the gpio is valid and chip won't vanish */
-
-	spin_unlock_irqrestore(&gpio_lock, flags);
-
-	might_sleep_if(extra_checks && chip->can_sleep);
-
-	if (status) {
-		status = chip->request(chip, gpio);
-		if (status < 0) {
-			pr_debug("GPIO-%d: chip request fail, %d\n",
-				chip->base + gpio, status);
-			/* and it's not available to anyone else ...
-			 * gpio_request() is the fully clean solution.
-			 */
-			goto lose;
-		}
-	}
-
-	status = chip->direction_output(chip, gpio, value);
-	if (status == 0)
-		set_bit(FLAG_IS_OUT, &desc->flags);
-lose:
-	return status;
-fail:
-	spin_unlock_irqrestore(&gpio_lock, flags);
-	if (status)
-		pr_debug("%s: gpio-%d status %d\n",
-			__func__, gpio, status);
-	return status;
+	return gpio_set_direction(gpio, 2, value);
 }
 EXPORT_SYMBOL_GPL(gpio_direction_output);
 
diff --git a/include/asm-generic/gpio.h b/include/asm-generic/gpio.h
index 485eeb6..17c7642 100644
--- a/include/asm-generic/gpio.h
+++ b/include/asm-generic/gpio.h
@@ -41,6 +41,8 @@ struct module;
  *	enabling module power and clock; may sleep
  * @free: optional hook for chip-specific deactivation, such as
  *	disabling module power and clock; may sleep
+ * @set_direction: configures signal "offset" as "direction" (0-3, bit0=input,
+ *	bit1=output) or returns error
  * @direction_input: configures signal "offset" as input, or returns error
  * @get: returns value for signal "offset"; for output signals this
  *	returns either the value actually sensed, or zero
@@ -82,6 +84,9 @@ struct gpio_chip {
 	void			(*free)(struct gpio_chip *chip,
 						unsigned offset);
 
+	int			(*set_direction)(struct gpio_chip *chip,
+						unsigned offset,
+						int direction, int value);
 	int			(*direction_input)(struct gpio_chip *chip,
 						unsigned offset);
 	int			(*get)(struct gpio_chip *chip,
@@ -118,6 +123,7 @@ extern int __must_check gpiochip_remove(struct gpio_chip *chip);
 extern int gpio_request(unsigned gpio, const char *label);
 extern void gpio_free(unsigned gpio);
 
+extern int gpio_set_direction(unsigned gpio, int direction, int value);
 extern int gpio_direction_input(unsigned gpio);
 extern int gpio_direction_output(unsigned gpio, int value);
 
diff --git a/include/linux/gpio.h b/include/linux/gpio.h
index 4e949a5..cdc2117 100644
--- a/include/linux/gpio.h
+++ b/include/linux/gpio.h
@@ -41,6 +41,11 @@ static inline void gpio_free(unsigned gpio)
 	WARN_ON(1);
 }
 
+static inline int gpio_set_direction(unsigned gpio, int direction, int value)
+{
+	return -ENOSYS;
+}
+
 static inline int gpio_direction_input(unsigned gpio)
 {
 	return -ENOSYS;
-- 
1.7.0

