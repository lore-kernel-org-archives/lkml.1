Return-Path: <linux-kernel-owner+w=401wt.eu-S934804AbZJJTs5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934804AbZJJTs5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Oct 2009 15:48:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934790AbZJJTsz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Oct 2009 15:48:55 -0400
Received: from vena.lwn.net ([206.168.112.25]:58813 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934750AbZJJTsz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Oct 2009 15:48:55 -0400
Date: Sat, 10 Oct 2009 13:48:14 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: LKML <linux-kernel@vger.kernel.org>
Cc: David Brownell <dbrownell@users.sourceforge.net>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] GPIO: Add gpio_lookup
Message-ID: <20091010134814.0bac8624@bike.lwn.net>
Organization: LWN.net
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.6; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

GPIOs have names associated with them, but drivers cannot use those names
and must thus rely on hardwired GPIO numbers.  That, in turn, makes dynamic
assignment hard to use.  This patch adds a little function gpio_lookup()
which returns the GPIO number associated with a name.

This function will be used by the viafb camera driver.

Signed-off-by: Jonathan Corbet <corbet@lwn.net>
---
 Documentation/gpio.txt     |    8 ++++++++
 drivers/gpio/gpiolib.c     |   25 +++++++++++++++++++++++++
 include/asm-generic/gpio.h |    1 +
 include/linux/gpio.h       |    5 +++++
 4 files changed, 39 insertions(+), 0 deletions(-)

diff --git a/Documentation/gpio.txt b/Documentation/gpio.txt
index fa4dc07..b3b3dd5 100644
--- a/Documentation/gpio.txt
+++ b/Documentation/gpio.txt
@@ -253,6 +253,14 @@ pin setup (e.g. controlling which pin the GPIO uses, pullup/pulldown).
 Also note that it's your responsibility to have stopped using a GPIO
 before you free it.
 
+GPIO users can look up GPIO numbers using the names which were provided by
+the GPIO driver, using:
+
+	int gpio_lookup(const char *name);
+
+The return value will be the associated GPIO number, or -EINVAL if no GPIO
+with the given name is found.
+
 
 GPIOs mapped to IRQs
 --------------------
diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index 662ed92..b95c9e3 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -1102,6 +1102,31 @@ void gpio_free(unsigned gpio)
 }
 EXPORT_SYMBOL_GPL(gpio_free);
 
+/**
+ * gpio_lookup - Look up a GPIO by name
+ * @name: the name of the desired GPIO
+ *
+ * Returns the GPIO number associated with name, or -EINVAL if
+ * the GPIO is not found.
+ */
+int gpio_lookup(const char *name)
+{
+	int i;
+
+	for (i = 0; i < ARCH_NR_GPIOS; i++) {
+		struct gpio_chip *chip = gpio_desc[i].chip;
+
+		if (chip == NULL || chip->names == NULL)
+			continue;
+		if (!strcmp (name, chip->names[i - chip->base])) {
+			printk(KERN_NOTICE "grbn found %d\n", i);
+			return i;
+		}
+	}
+	return -EINVAL;
+}
+EXPORT_SYMBOL_GPL(gpio_lookup);
+
 
 /**
  * gpiochip_is_requested - return string iff signal was requested
diff --git a/include/asm-generic/gpio.h b/include/asm-generic/gpio.h
index 66d6106..667b86a 100644
--- a/include/asm-generic/gpio.h
+++ b/include/asm-generic/gpio.h
@@ -116,6 +116,7 @@ extern int __must_check gpiochip_remove(struct gpio_chip *chip);
  */
 extern int gpio_request(unsigned gpio, const char *label);
 extern void gpio_free(unsigned gpio);
+extern int gpio_lookup(const char *name);
 
 extern int gpio_direction_input(unsigned gpio);
 extern int gpio_direction_output(unsigned gpio, int value);
diff --git a/include/linux/gpio.h b/include/linux/gpio.h
index 059bd18..2c3f179 100644
--- a/include/linux/gpio.h
+++ b/include/linux/gpio.h
@@ -41,6 +41,11 @@ static inline void gpio_free(unsigned gpio)
 	WARN_ON(1);
 }
 
+static inline int gpio_lookup(const char *name)
+{
+	return -ENOSYS;
+}
+
 static inline int gpio_direction_input(unsigned gpio)
 {
 	return -ENOSYS;
-- 
1.6.2.5

