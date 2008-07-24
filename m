Return-Path: <linux-kernel-owner+w=401wt.eu-S1750737AbYGXH2r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750737AbYGXH2r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 03:28:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751117AbYGXH2m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 03:28:42 -0400
Received: from mail164.messagelabs.com ([216.82.253.131]:9722 "EHLO
	mail164.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750894AbYGXH2l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 03:28:41 -0400
X-VirusChecked: Checked
X-Env-Sender: Uwe.Kleine-Koenig@digi.com
X-Msg-Ref: server-5.tower-164.messagelabs.com!1216884519!18771421!1
X-StarScan-Version: 5.5.12.14.2; banners=-,-,-
X-Originating-IP: [66.77.174.14]
From: =?utf-8?q?Uwe=20Kleine-K=C3=B6nig?= <Uwe.Kleine-Koenig@digi.com>
To: <linux-kernel@vger.kernel.org>
CC: David Brownell <david-b@pacbell.net>,
       Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>,
       Greg KH <greg@kroah.com>, Kay Sievers <kay.sievers@vrfy.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [PATCH] add might_sleep() to all implementations of gpio_free
Date: Thu, 24 Jul 2008 09:28:35 +0200
Message-ID: <1216884515-12084-1-git-send-email-Uwe.Kleine-Koenig@digi.com>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <200807230916.48056.david-b@pacbell.net>
References: <200807230916.48056.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 24 Jul 2008 07:28:36.0251 (UTC) FILETIME=[E27B76B0:01C8ED5E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to Documentation gpio_free should only be called from task
context.  To make this more explicit add a might_sleep.

Signed-off-by: Uwe Kleine-König <Uwe.Kleine-Koenig@digi.com>
Cc: David Brownell <david-b@pacbell.net>
Cc: Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>
Cc: Greg KH <greg@kroah.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
---
Hello,

I added #include <linux/kernel.h> for all files that didn't already have
it.  And note I didn't test these changes.

Best regards
Uwe

 arch/arm/mach-davinci/gpio.c         |    2 ++
 arch/arm/mach-ns9xxx/gpio.c          |    2 ++
 arch/arm/mach-orion5x/gpio.c         |    2 ++
 drivers/gpio/gpiolib.c               |    2 ++
 include/asm-arm/arch-at91/gpio.h     |    2 ++
 include/asm-arm/arch-imx/gpio.h      |    3 +++
 include/asm-arm/arch-ixp4xx/gpio.h   |    3 +++
 include/asm-arm/arch-ks8695/gpio.h   |    3 +++
 include/asm-mips/mach-au1x00/gpio.h  |    2 ++
 include/asm-mips/mach-bcm47xx/gpio.h |    3 +++
 include/asm-mips/mach-rc32434/gpio.h |    2 ++
 include/asm-x86/mach-rdc321x/gpio.h  |    3 +++
 include/linux/gpio.h                 |    3 +++
 13 files changed, 32 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-davinci/gpio.c b/arch/arm/mach-davinci/gpio.c
index 9c67886..663e621 100644
--- a/arch/arm/mach-davinci/gpio.c
+++ b/arch/arm/mach-davinci/gpio.c
@@ -43,6 +43,8 @@ EXPORT_SYMBOL(gpio_request);
 
 void gpio_free(unsigned gpio)
 {
+	might_sleep();
+
 	if (gpio >= DAVINCI_N_GPIO)
 		return;
 
diff --git a/arch/arm/mach-ns9xxx/gpio.c b/arch/arm/mach-ns9xxx/gpio.c
index b3c963b..cc7141c 100644
--- a/arch/arm/mach-ns9xxx/gpio.c
+++ b/arch/arm/mach-ns9xxx/gpio.c
@@ -12,6 +12,7 @@
 #include <linux/init.h>
 #include <linux/spinlock.h>
 #include <linux/module.h>
+#include <linux/kernel.h>
 
 #include <asm/arch-ns9xxx/gpio.h>
 #include <asm/arch-ns9xxx/processor.h>
@@ -63,6 +64,7 @@ EXPORT_SYMBOL(gpio_request);
 
 void gpio_free(unsigned gpio)
 {
+	might_sleep();
 	clear_bit(gpio, gpiores);
 	return;
 }
diff --git a/arch/arm/mach-orion5x/gpio.c b/arch/arm/mach-orion5x/gpio.c
index d097979..f0ff5af 100644
--- a/arch/arm/mach-orion5x/gpio.c
+++ b/arch/arm/mach-orion5x/gpio.c
@@ -165,6 +165,8 @@ EXPORT_SYMBOL(gpio_request);
 
 void gpio_free(unsigned pin)
 {
+	might_sleep();
+
 	if (pin >= GPIO_MAX || !test_bit(pin, gpio_valid)) {
 		pr_debug("%s: invalid GPIO %d\n", __func__, pin);
 		return;
diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index beaf6b3..049d37d 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -291,6 +291,8 @@ void gpio_free(unsigned gpio)
 	unsigned long		flags;
 	struct gpio_desc	*desc;
 
+	might_sleep();
+
 	if (!gpio_is_valid(gpio)) {
 		WARN_ON(extra_checks);
 		return;
diff --git a/include/asm-arm/arch-at91/gpio.h b/include/asm-arm/arch-at91/gpio.h
index 0a241e2..2fd7a83 100644
--- a/include/asm-arm/arch-at91/gpio.h
+++ b/include/asm-arm/arch-at91/gpio.h
@@ -13,6 +13,7 @@
 #ifndef __ASM_ARCH_AT91RM9200_GPIO_H
 #define __ASM_ARCH_AT91RM9200_GPIO_H
 
+#include <linux/kernel.h>
 #include <asm/irq.h>
 
 #define PIN_BASE		NR_AIC_IRQS
@@ -220,6 +221,7 @@ static inline int gpio_request(unsigned gpio, const char *label)
 
 static inline void gpio_free(unsigned gpio)
 {
+	might_sleep();
 }
 
 extern int gpio_direction_input(unsigned gpio);
diff --git a/include/asm-arm/arch-imx/gpio.h b/include/asm-arm/arch-imx/gpio.h
index 4860232..55b896e 100644
--- a/include/asm-arm/arch-imx/gpio.h
+++ b/include/asm-arm/arch-imx/gpio.h
@@ -1,5 +1,6 @@
 #ifndef _IMX_GPIO_H
 
+#include <linux/kernel.h>
 #include <asm/arch/imx-regs.h>
 
 #define IMX_GPIO_ALLOC_MODE_NORMAL	0
@@ -63,6 +64,8 @@ static inline int gpio_request(unsigned gpio, const char *label)
 
 static inline void gpio_free(unsigned gpio)
 {
+	might_sleep();
+
 	imx_gpio_free(gpio);
 }
 
diff --git a/include/asm-arm/arch-ixp4xx/gpio.h b/include/asm-arm/arch-ixp4xx/gpio.h
index 3a4c5b8..d804661 100644
--- a/include/asm-arm/arch-ixp4xx/gpio.h
+++ b/include/asm-arm/arch-ixp4xx/gpio.h
@@ -25,6 +25,7 @@
 #ifndef __ASM_ARCH_IXP4XX_GPIO_H
 #define __ASM_ARCH_IXP4XX_GPIO_H
 
+#include <linux/kernel.h>
 #include <asm/hardware.h>
 
 static inline int gpio_request(unsigned gpio, const char *label)
@@ -34,6 +35,8 @@ static inline int gpio_request(unsigned gpio, const char *label)
 
 static inline void gpio_free(unsigned gpio)
 {
+	might_sleep();
+
 	return;
 }
 
diff --git a/include/asm-arm/arch-ks8695/gpio.h b/include/asm-arm/arch-ks8695/gpio.h
index 65ceea2..758df66 100644
--- a/include/asm-arm/arch-ks8695/gpio.h
+++ b/include/asm-arm/arch-ks8695/gpio.h
@@ -11,6 +11,8 @@
 #ifndef __ASM_ARCH_GPIO_H_
 #define __ASM_ARCH_GPIO_H_
 
+#include <linux/kernel.h>
+
 #define KS8695_GPIO_0		0
 #define KS8695_GPIO_1		1
 #define KS8695_GPIO_2		2
@@ -74,6 +76,7 @@ static inline int gpio_request(unsigned int pin, const char *label)
 
 static inline void gpio_free(unsigned int pin)
 {
+	might_sleep();
 }
 
 #endif
diff --git a/include/asm-mips/mach-au1x00/gpio.h b/include/asm-mips/mach-au1x00/gpio.h
index 2dc61e0..31eddba 100644
--- a/include/asm-mips/mach-au1x00/gpio.h
+++ b/include/asm-mips/mach-au1x00/gpio.h
@@ -1,6 +1,7 @@
 #ifndef _AU1XXX_GPIO_H_
 #define _AU1XXX_GPIO_H_
 
+#include <linux/kernel.h>
 #include <linux/types.h>
 
 #define AU1XXX_GPIO_BASE	200
@@ -31,6 +32,7 @@ static inline int gpio_request(unsigned gpio, const char *label)
 static inline void gpio_free(unsigned gpio)
 {
 	/* Not yet implemented */
+	might_sleep();
 }
 
 static inline int gpio_direction_input(unsigned gpio)
diff --git a/include/asm-mips/mach-bcm47xx/gpio.h b/include/asm-mips/mach-bcm47xx/gpio.h
index cfc8f4d..af17ccd 100644
--- a/include/asm-mips/mach-bcm47xx/gpio.h
+++ b/include/asm-mips/mach-bcm47xx/gpio.h
@@ -9,6 +9,8 @@
 #ifndef __BCM47XX_GPIO_H
 #define __BCM47XX_GPIO_H
 
+#include <linux/kernel.h>
+
 #define BCM47XX_EXTIF_GPIO_LINES	5
 #define BCM47XX_CHIPCO_GPIO_LINES	16
 
@@ -25,6 +27,7 @@ static inline int gpio_request(unsigned gpio, const char *label)
 
 static inline void gpio_free(unsigned gpio)
 {
+	might_sleep();
 }
 
 static inline int gpio_to_irq(unsigned gpio)
diff --git a/include/asm-mips/mach-rc32434/gpio.h b/include/asm-mips/mach-rc32434/gpio.h
index f946f5f..9b4722e 100644
--- a/include/asm-mips/mach-rc32434/gpio.h
+++ b/include/asm-mips/mach-rc32434/gpio.h
@@ -13,6 +13,7 @@
 #ifndef _RC32434_GPIO_H_
 #define _RC32434_GPIO_H_
 
+#include <linux/kernel.h>
 #include <linux/types.h>
 
 struct rb532_gpio_reg {
@@ -88,6 +89,7 @@ static inline int gpio_request(unsigned gpio, const char *label)
 static inline void gpio_free(unsigned gpio)
 {
 	/* Not yet implemented */
+	might_sleep();
 }
 
 static inline int gpio_direction_input(unsigned gpio)
diff --git a/include/asm-x86/mach-rdc321x/gpio.h b/include/asm-x86/mach-rdc321x/gpio.h
index acce0b7..3639ece 100644
--- a/include/asm-x86/mach-rdc321x/gpio.h
+++ b/include/asm-x86/mach-rdc321x/gpio.h
@@ -1,6 +1,8 @@
 #ifndef _RDC321X_GPIO_H
 #define _RDC321X_GPIO_H
 
+#include <linux/kernel.h>
+
 extern int rdc_gpio_get_value(unsigned gpio);
 extern void rdc_gpio_set_value(unsigned gpio, int value);
 extern int rdc_gpio_direction_input(unsigned gpio);
@@ -18,6 +20,7 @@ static inline int gpio_request(unsigned gpio, const char *label)
 
 static inline void gpio_free(unsigned gpio)
 {
+	might_sleep();
 	rdc_gpio_free(gpio);
 }
 
diff --git a/include/linux/gpio.h b/include/linux/gpio.h
index 98be6c5..570a4f3 100644
--- a/include/linux/gpio.h
+++ b/include/linux/gpio.h
@@ -8,6 +8,7 @@
 
 #else
 
+#include <linux/kernel.h>
 #include <linux/types.h>
 #include <linux/errno.h>
 
@@ -32,6 +33,8 @@ static inline int gpio_request(unsigned gpio, const char *label)
 
 static inline void gpio_free(unsigned gpio)
 {
+	might_sleep();
+
 	/* GPIO can never have been requested */
 	WARN_ON(1);
 }
-- 
1.5.6.3

