Return-Path: <linux-kernel-owner+w=401wt.eu-S1757586AbZCTNxh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757586AbZCTNxh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 09:53:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757037AbZCTNxR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 09:53:17 -0400
Received: from smtp.nokia.com ([192.100.122.233]:18459 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756841AbZCTNxQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 09:53:16 -0400
From: Jani Nikula <ext-jani.1.nikula@nokia.com>
To: david-b@pacbell.net
Cc: linux-kernel@vger.kernel.org, juha.yrjola@solidboot.com,
       ext-jani.1.nikula@nokia.com
Subject: [RFC PATCH 1/3] GPIOLIB: Add new gpio_device_create function
Date: Fri, 20 Mar 2009 15:50:48 +0200
Message-Id: <0240a0c7d8fd8419ba1665f678978b0fa4c1a257.1237555607.git.ext-jani.1.nikula@nokia.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1237557050-13742-1-git-send-email-ext-jani.1.nikula@nokia.com>
References: <1237557050-13742-1-git-send-email-ext-jani.1.nikula@nokia.com>
X-OriginalArrivalTime: 20 Mar 2009 13:51:46.0130 (UTC) FILETIME=[023EDB20:01C9A963]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support function for creating additional sysfs entries within the
gpiolib sysfs structure. Initially required for GPIO switch framework
entries.

Signed-off-by: Jani Nikula <ext-jani.1.nikula@nokia.com>
---
 drivers/gpio/gpiolib.c     |   52 ++++++++++++++++++++++++++++++++++++++++++++
 include/asm-generic/gpio.h |   12 ++++++++++
 2 files changed, 64 insertions(+), 0 deletions(-)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index 42fb2fd..b531edd 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -643,6 +643,58 @@ static inline void gpiochip_unexport(struct gpio_chip *chip)
 
 #endif /* CONFIG_GPIO_SYSFS */
 
+#if defined(CONFIG_GPIO_SWITCH) || defined(CONFIG_GPIO_SWITCH_MODULE)
+/**
+ * gpio_device_create - Create a sysfs entry for GPIO
+ * @gpio:
+ * @drvdata:
+ * @fmt:
+ *
+ */
+struct device *gpio_device_create(unsigned gpio, void *drvdata,
+				const char *fmt, ...)
+{
+	unsigned long		flags;
+	struct gpio_desc	*desc;
+	int			status = -EINVAL;
+	struct device		*dev = NULL;
+
+	/* can't export until sysfs is available ... */
+	if (!gpio_class.p) {
+		pr_debug("%s: called too early!\n", __func__);
+		goto done;
+	}
+
+	if (!gpio_is_valid(gpio))
+		goto done;
+
+	mutex_lock(&sysfs_lock);
+
+	spin_lock_irqsave(&gpio_lock, flags);
+	desc = &gpio_desc[gpio];
+	if (test_bit(FLAG_REQUESTED, &desc->flags))
+		status = 0;
+	spin_unlock_irqrestore(&gpio_lock, flags);
+
+	if (status == 0) {
+		va_list vargs;
+
+		va_start(vargs, fmt);
+		dev = device_create_vargs(&gpio_class, desc->chip->dev,
+					MKDEV(0, 0), drvdata, fmt, vargs);
+		va_end(vargs);
+	}
+	mutex_unlock(&sysfs_lock);
+
+	return dev;
+done:
+	pr_debug("%s: gpio%d status %d\n", __func__, gpio, status);
+
+	return ERR_PTR(status);
+}
+EXPORT_SYMBOL_GPL(gpio_device_create);
+#endif /* defined(CONFIG_GPIO_SWITCH) || defined(CONFIG_GPIO_SWITCH_MODULE) */
+
 /**
  * gpiochip_add() - register a gpio_chip
  * @chip: the chip to register, with chip->base initialized
diff --git a/include/asm-generic/gpio.h b/include/asm-generic/gpio.h
index 81797ec..c4380d7 100644
--- a/include/asm-generic/gpio.h
+++ b/include/asm-generic/gpio.h
@@ -7,6 +7,7 @@
 #ifdef CONFIG_GPIOLIB
 
 #include <linux/compiler.h>
+#include <linux/err.h>
 
 /* Platforms may implement their GPIO interface with library code,
  * at a small performance cost for non-inlined operations and some
@@ -185,4 +186,15 @@ static inline void gpio_unexport(unsigned gpio)
 }
 #endif	/* CONFIG_GPIO_SYSFS */
 
+#if defined(CONFIG_GPIO_SWITCH) || defined(CONFIG_GPIO_SWITCH_MODULE)
+struct device *gpio_device_create(unsigned gpio, void *drvdata,
+				const char *fmt, ...);
+#else
+static inline struct device *gpio_device_create(unsigned gpio, void *drvdata,
+				const char *fmt, ...)
+{
+	return ERR_PTR(-EINVAL);
+}
+#endif
+
 #endif /* _ASM_GENERIC_GPIO_H */
-- 
1.6.0.4

