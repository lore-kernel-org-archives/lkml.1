Return-Path: <linux-kernel-owner+w=401wt.eu-S1754430AbYJPRO2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754430AbYJPRO2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 13:14:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755007AbYJPRND
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 13:13:03 -0400
Received: from rtsoft3.corbina.net ([85.21.88.6]:7141 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754921AbYJPRNB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 13:13:01 -0400
Date: Thu, 16 Oct 2008 21:12:59 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: linux-kernel@vger.kernel.org
Cc: David Brownell <dbrownell@users.sourceforge.net>,
       "Steven A. Falco" <sfalco@harris.com>,
       Grant Likely <grant.likely@secretlab.ca>,
       Jean Delvare <khali@linux-fr.org>, David Miller <davem@davemloft.net>,
       i2c@lm-sensors.org, linuxppc-dev@ozlabs.org
Subject: [PATCH 4/7] gpiolib: implement dev_gpiochip_{add,remove} calls
Message-ID: <20081016171259.GD5515@oksana.dev.rtsoft.ru>
References: <20081016171222.GA24812@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=windows-1251
Content-Disposition: inline
In-Reply-To: <20081016171222.GA24812@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Any GPIO controller that have a device associated with it is encouraged to
register/unregister the gpiochips with dev_gpiochip_*() calls.

Platform may redefine these calls to glue the gpiochips with the
architecture-specific code.

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
---
 include/asm-generic/gpio.h |   44 ++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 44 insertions(+), 0 deletions(-)

diff --git a/include/asm-generic/gpio.h b/include/asm-generic/gpio.h
index 0f99ad3..f31c7ae 100644
--- a/include/asm-generic/gpio.h
+++ b/include/asm-generic/gpio.h
@@ -89,6 +89,50 @@ extern int __must_check gpiochip_reserve(int start, int ngpio);
 extern int gpiochip_add(struct gpio_chip *chip);
 extern int __must_check gpiochip_remove(struct gpio_chip *chip);
 
+/*
+ * Platforms can define their own __dev_ versions to glue gpio_chips with the
+ * architecture-specific code.
+ */
+#ifndef __dev_gpiochip_add
+#define __dev_gpiochip_add __dev_gpiochip_add
+static inline int __dev_gpiochip_add(struct device *dev,
+				     struct gpio_chip *chip)
+{
+	chip->dev = dev;
+	return gpiochip_add(chip);
+}
+#endif /* __dev_gpiochip_add */
+
+#ifndef __dev_gpiochip_remove
+#define __dev_gpiochip_remove __dev_gpiochip_remove
+static inline int __dev_gpiochip_remove(struct device *dev,
+					struct gpio_chip *chip)
+{
+	return gpiochip_remove(chip);
+}
+#endif /* __dev_gpiochip_remove */
+
+/**
+ * dev_gpiochip_add - register a gpio_chip for a device
+ * @dev: device to register gpio_chip for
+ * @chip: the chip to register
+ * Context: potentially before irqs or kmalloc will work
+ *
+ * This function takes the extra @dev argument that is used to associate
+ * the chip with a device. Otherwise it behaves the same way as the
+ * gpiochip_add().
+ */
+#define dev_gpiochip_add(dev, chip) __dev_gpiochip_add((dev), (chip))
+
+/**
+ * dev_gpiochip_remove - unregister a gpio_chip
+ * @dev: device to remove the chip from
+ * @chip: the chip to unregister
+ *
+ * Use this function to unregister the chip that was registered using
+ * dev_gpiochip_add().
+ */
+#define dev_gpiochip_remove(dev, chip) __dev_gpiochip_remove((dev), (chip))
 
 /* Always use the library code for GPIO management calls,
  * or when sleeping may be involved.
-- 
1.5.6.3

