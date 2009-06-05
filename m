Return-Path: <linux-kernel-owner+w=401wt.eu-S1752275AbZFESvf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752275AbZFESvf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 14:51:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752144AbZFESv2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 14:51:28 -0400
Received: from [67.136.234.194] ([67.136.234.194]:16945 "EHLO
	visionfs1.visionengravers.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750893AbZFESv1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 14:51:27 -0400
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] gpiolib: add gpio_request/free_irq
Date: Fri, 5 Jun 2009 11:51:05 -0700
Cc: David Brownell <dbrownell@users.sourceforge.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906051151.05779.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support functions to gpiolib to request/free gpio irqs.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: David Brownell <dbrownell@users.sourceforge.net>

---

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index 51a8d41..5b4b864 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -1103,6 +1103,52 @@ int __gpio_to_irq(unsigned gpio)
 }
 EXPORT_SYMBOL_GPL(__gpio_to_irq);
 
+/**
+ * gpio_request_irq() - allocate a gpio interrupt line
+ * @gpio: gpio whose IRQ will be allocated
+ * @handler: function to be called when the IRQ occurs
+ * @irqflags: interrupt type flags
+ * @label: an ascii name for the claiming device
+ * @data: a cookie passed back to the handling function
+ */
+int gpio_request_irq(unsigned gpio, irq_handler_t handler,
+			unsigned long irqflags, const char *label, void *data)
+{
+	int err;
+
+	err = gpio_request(gpio, label);
+	if (err)
+		goto fail;
+
+	err = gpio_direction_input(gpio);
+	if (err)
+		goto free;
+
+	err = request_irq(gpio_to_irq(gpio), handler, irqflags, label, data);
+	if (err)
+		goto free;
+
+	return 0;
+
+free:
+	gpio_free(gpio);
+fail:
+	return err;
+}
+EXPORT_SYMBOL_GPL(gpio_request_irq);
+
+/**
+ * gpio_free_irq() - free an interrupt allocated with gpio_request_irq
+ * @irq: gpio interrupt line to free
+ * @data: device identity to free
+ */
+void gpio_free_irq(unsigned int irq, void *data)
+{
+	free_irq(irq, data);
+	gpio_free(irq_to_gpio(irq));
+}
+EXPORT_SYMBOL_GPL(gpio_free_irq);
+
 
 
 /* There's no value in making it easy to inline GPIO calls that may sleep.
diff --git a/include/asm-generic/gpio.h b/include/asm-generic/gpio.h
index d6c379d..c0ab7cf 100644
--- a/include/asm-generic/gpio.h
+++ b/include/asm-generic/gpio.h
@@ -3,6 +3,7 @@
 
 #include <linux/types.h>
 #include <linux/errno.h>
+#include <linux/interrupt.h>
 
 #ifdef CONFIG_GPIOLIB
 
@@ -134,6 +135,11 @@ extern int __gpio_cansleep(unsigned gpio);
 
 extern int __gpio_to_irq(unsigned gpio);
 
+/* request/free gpio interrupt */
+extern int gpio_request_irq(unsigned gpio, irq_handler_t handler,
+			unsigned long irqflags, const char *label, void *data);
+extern void gpio_free_irq(unsigned int irq, void *data);
+
 #ifdef CONFIG_GPIO_SYSFS
 
 /*
diff --git a/include/linux/gpio.h b/include/linux/gpio.h
index e10c49a..eaf7b27 100644
--- a/include/linux/gpio.h
+++ b/include/linux/gpio.h
@@ -109,6 +109,18 @@ static inline int irq_to_gpio(unsigned irq)
 	return -EINVAL;
 }
 
+static inline int gpio_request_irq(unsigned gpio, irq_handler_t handler,
+			unsigned long irqflags, const char *label, void *data)
+{
+	return -ENOSYS;
+}
+
+static inline void gpio_free_irq(unsigned int irq, void *data)
+{
+	/* GPIO irq can never have been requested */
+	WARN_ON(1);
+}
+
 #endif
 
 #endif /* __LINUX_GPIO_H */
