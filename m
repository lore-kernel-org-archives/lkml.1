Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757361Ab0BEUcf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 15:32:35 -0500
Received: from mail.dev.rtsoft.ru ([213.79.90.226]:43929 "HELO
	mail.dev.rtsoft.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754410Ab0BEUce (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 15:32:34 -0500
Date: Fri, 5 Feb 2010 23:32:32 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Grant Likely <grant.likely@secretlab.ca>,
       David Brownell <dbrownell@users.sourceforge.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Bill Gatliff <bgat@billgatliff.com>,
       Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] gpiolib: Introduce chip addition/removal notifier
Message-ID: <20100205203232.GA1475@oksana.dev.rtsoft.ru>
References: <20100205203201.GA32281@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20100205203201.GA32281@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some platforms (e.g. OpenFirmware) want to know when a particular chip
added or removed, so that the platforms could add their specifics for
non-platform devices, like I2C or SPI GPIO chips.

This patch implements the notifier for chip addition and removal events.

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
---
 drivers/gpio/gpiolib.c     |   14 ++++++++++++++
 include/asm-generic/gpio.h |    8 ++++++++
 2 files changed, 22 insertions(+), 0 deletions(-)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index 350842a..375c03a 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -9,6 +9,7 @@
 #include <linux/seq_file.h>
 #include <linux/gpio.h>
 #include <linux/idr.h>
+#include <linux/notifier.h>
 
 
 /* Optional implementation infrastructure for GPIO interfaces.
@@ -1029,6 +1030,9 @@ static inline void gpiochip_unexport(struct gpio_chip *chip)
 
 #endif /* CONFIG_GPIO_SYSFS */
 
+BLOCKING_NOTIFIER_HEAD(gpio_notifier);
+EXPORT_SYMBOL_GPL(gpio_notifier);
+
 /**
  * gpiochip_add() - register a gpio_chip
  * @chip: the chip to register, with chip->base initialized
@@ -1103,6 +1107,9 @@ fail:
 		pr_err("gpiochip_add: gpios %d..%d (%s) not registered\n",
 			chip->base, chip->base + chip->ngpio - 1,
 			chip->label ? : "generic");
+	else
+		blocking_notifier_call_chain(&gpio_notifier,
+					     GPIO_NOTIFY_CHIP_ADDED, chip);
 	return status;
 }
 EXPORT_SYMBOL_GPL(gpiochip_add);
@@ -1119,6 +1126,13 @@ int gpiochip_remove(struct gpio_chip *chip)
 	int		status = 0;
 	unsigned	id;
 
+	/* Ask external subsystems to release the chip. */
+	status = blocking_notifier_call_chain(&gpio_notifier,
+					      GPIO_NOTIFY_CHIP_REMOVE, chip);
+	status = notifier_to_errno(status);
+	if (status)
+		return status;
+
 	spin_lock_irqsave(&gpio_lock, flags);
 
 	for (id = chip->base; id < chip->base + chip->ngpio; id++) {
diff --git a/include/asm-generic/gpio.h b/include/asm-generic/gpio.h
index 485eeb6..84faae4 100644
--- a/include/asm-generic/gpio.h
+++ b/include/asm-generic/gpio.h
@@ -4,6 +4,7 @@
 #include <linux/kernel.h>
 #include <linux/types.h>
 #include <linux/errno.h>
+#include <linux/notifier.h>
 
 #ifdef CONFIG_GPIOLIB
 
@@ -208,4 +209,11 @@ static inline void gpio_unexport(unsigned gpio)
 }
 #endif	/* CONFIG_GPIO_SYSFS */
 
+enum gpio_notify_msg {
+	GPIO_NOTIFY_CHIP_ADDED = 0,
+	GPIO_NOTIFY_CHIP_REMOVE = 1,
+};
+
+extern struct blocking_notifier_head gpio_notifier;
+
 #endif /* _ASM_GENERIC_GPIO_H */
-- 
1.6.5.7

