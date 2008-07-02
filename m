Return-Path: <linux-kernel-owner+w=401wt.eu-S1761628AbYGBDRN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761628AbYGBDRN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 23:17:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753070AbYGBDQ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 23:16:56 -0400
Received: from smtp115.sbc.mail.sp1.yahoo.com ([69.147.64.88]:43147 "HELO
	smtp115.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752600AbYGBDQz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 23:16:55 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=JBNF9WNXhlcmIHzm/FZXK2og0nevpRMLkFYG6zqlI503w4tdDkSneQlPgqMh9wjTqqf3P8CK1n+cX2qEGaKsEgsxJBtWMWe6P9Iyev2RP7gO0Yno4sr88Xnl1LLzl1PtAPeXfIkNQs/enjVU+0UGoH19lLQwfKFfxXYu/5DPNS8=  ;
X-YMail-OSG: 8XPs0jEVM1nYgTCeDp8Ja18SgvqA4yTWHLeq6dTM6NHzDflHTektxPWf6SnlKcsHxMJtcPiX9sArBDdewmussPXaPSt5Ju63xS6MQ.wGuOmxNlClMRkGwXgJvV5LjgZxGyI-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC] x86: Add user configurable GPIO-lib support
Date: Tue, 1 Jul 2008 19:57:41 -0700
User-Agent: KMail/1.9.9
Cc: Florian Fainelli <florian.fainelli@telecomint.eu>,
       Michael Buesch <mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807011957.41837.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

More food for thought ... 

This makes the rdc321x support switch over to using gpiolib,
along with all of x86.  Quick'n'dirty.

It's perhaps best done in conjunction with something to
make GPIOLIB be user-configurable on systems where it's not
already selected by platform code.  The rdc321x stuff needs
more working, but this is a start.

- Dave

---
 arch/x86/Kconfig                            |    6 +
 arch/x86/mach-rdc321x/gpio.c                |  107 ++++++++--------------------
 arch/x86/mach-rdc321x/platform.c            |    3 
 include/asm-x86/gpio.h                      |   22 +++++
 include/asm-x86/mach-rdc321x/gpio.h         |   52 -------------
 include/asm-x86/mach-rdc321x/rdc321x_defs.h |    2 
 6 files changed, 62 insertions(+), 130 deletions(-)

--- a/arch/x86/Kconfig	2008-07-01 16:46:11.000000000 -0700
+++ b/arch/x86/Kconfig	2008-07-01 16:46:13.000000000 -0700
@@ -87,7 +87,10 @@ config GENERIC_HWEIGHT
 	def_bool y
 
 config GENERIC_GPIO
-	def_bool n
+	def_bool y
+
+config HAVE_GPIO_LIB
+	def_bool y
 
 config ARCH_MAY_HAVE_PC_FDC
 	def_bool y
@@ -325,7 +328,6 @@ config X86_RDC321X
 	depends on X86_32
 	select M486
 	select X86_REBOOTFIXUPS
-	select GENERIC_GPIO
 	select LEDS_CLASS
 	select LEDS_GPIO
 	select NEW_LEDS
--- a/arch/x86/mach-rdc321x/gpio.c	2008-07-01 16:46:11.000000000 -0700
+++ b/arch/x86/mach-rdc321x/gpio.c	2008-07-01 17:06:48.000000000 -0700
@@ -25,8 +25,9 @@
 #include <linux/io.h>
 #include <linux/types.h>
 #include <linux/module.h>
+#include <linux/gpio.h>
 
-#include <asm/gpio.h>
+#include <asm/mach-rdc321x/gpio.h>
 #include <asm/mach-rdc321x/rdc321x_defs.h>
 
 
@@ -38,8 +39,6 @@ static DEFINE_SPINLOCK(gpio_lock);
 static u32 gpio_data_reg1;
 static u32 gpio_data_reg2;
 
-static u32 gpio_request_data[2];
-
 
 static inline void rdc321x_conf_write(unsigned addr, u32 value)
 {
@@ -73,61 +72,8 @@ static void rdc321x_configure_gpio(unsig
 	spin_unlock_irqrestore(&gpio_lock, flags);
 }
 
-/* initially setup the 2 copies of the gpio data registers.
-   This function must be called by the platform setup code. */
-void __init rdc321x_gpio_setup()
-{
-	/* this might not be, what others (BIOS, bootloader, etc.)
-	   wrote to these registers before, but it's a good guess. Still
-	   better than just using 0xffffffff. */
-
-	gpio_data_reg1 = rdc321x_conf_read(RDC321X_GPIO_DATA_REG1);
-	gpio_data_reg2 = rdc321x_conf_read(RDC321X_GPIO_DATA_REG2);
-}
-
-/* determine, if gpio number is valid */
-static inline int rdc321x_is_gpio(unsigned gpio)
-{
-	return gpio <= RDC321X_MAX_GPIO;
-}
-
-/* request GPIO */
-int rdc_gpio_request(unsigned gpio, const char *label)
-{
-	unsigned long flags;
-
-	if (!rdc321x_is_gpio(gpio))
-		return -EINVAL;
-
-	spin_lock_irqsave(&gpio_lock, flags);
-	if (gpio_request_data[(gpio & 0x20) ? 1 : 0] & (1 << (gpio & 0x1f)))
-		goto inuse;
-	gpio_request_data[(gpio & 0x20) ? 1 : 0] |= (1 << (gpio & 0x1f));
-	spin_unlock_irqrestore(&gpio_lock, flags);
-
-	return 0;
-inuse:
-	spin_unlock_irqrestore(&gpio_lock, flags);
-	return -EINVAL;
-}
-EXPORT_SYMBOL(rdc_gpio_request);
-
-/* release previously-claimed GPIO */
-void rdc_gpio_free(unsigned gpio)
-{
-	unsigned long flags;
-
-	if (!rdc321x_is_gpio(gpio))
-		return;
-
-	spin_lock_irqsave(&gpio_lock, flags);
-	gpio_request_data[(gpio & 0x20) ? 1 : 0] &= ~(1 << (gpio & 0x1f));
-	spin_unlock_irqrestore(&gpio_lock, flags);
-}
-EXPORT_SYMBOL(rdc_gpio_free);
-
 /* read GPIO pin */
-int rdc_gpio_get_value(unsigned gpio)
+static int rdc_gpio_get_value(struct gpio_chip *g, unsigned gpio)
 {
 	u32 reg;
 	unsigned long flags;
@@ -139,56 +85,69 @@ int rdc_gpio_get_value(unsigned gpio)
 
 	return (1 << (gpio & 0x1f)) & reg ? 1 : 0;
 }
-EXPORT_SYMBOL(rdc_gpio_get_value);
 
 /* set GPIO pin to value */
-void rdc_gpio_set_value(unsigned gpio, int value)
+static void rdc_gpio_set_value(struct gpio_chip *g, unsigned gpio, int value)
 {
 	unsigned long flags;
 	u32 reg;
 
 	reg = 1 << (gpio & 0x1f);
+	spin_lock_irqsave(&gpio_lock, flags);
 	if (gpio < 32) {
-		spin_lock_irqsave(&gpio_lock, flags);
 		if (value)
 			gpio_data_reg1 |= reg;
 		else
 			gpio_data_reg1 &= ~reg;
 		rdc321x_conf_write(RDC321X_GPIO_DATA_REG1, gpio_data_reg1);
-		spin_unlock_irqrestore(&gpio_lock, flags);
 	} else {
-		spin_lock_irqsave(&gpio_lock, flags);
 		if (value)
 			gpio_data_reg2 |= reg;
 		else
 			gpio_data_reg2 &= ~reg;
 		rdc321x_conf_write(RDC321X_GPIO_DATA_REG2, gpio_data_reg2);
-		spin_unlock_irqrestore(&gpio_lock, flags);
 	}
+	spin_unlock_irqrestore(&gpio_lock, flags);
 }
-EXPORT_SYMBOL(rdc_gpio_set_value);
 
 /* configure GPIO pin as input */
-int rdc_gpio_direction_input(unsigned gpio)
+static int rdc_gpio_direction_input(struct gpio_chip *g, unsigned gpio)
 {
-	if (!rdc321x_is_gpio(gpio))
-		return -EINVAL;
-
 	rdc321x_configure_gpio(gpio);
 
 	return 0;
 }
-EXPORT_SYMBOL(rdc_gpio_direction_input);
 
 /* configure GPIO pin as output and set value */
-int rdc_gpio_direction_output(unsigned gpio, int value)
+static int rdc_gpio_direction_output(struct gpio_chip *g, unsigned gpio, int value)
 {
-	if (!rdc321x_is_gpio(gpio))
-		return -EINVAL;
-
 	gpio_set_value(gpio, value);
 	rdc321x_configure_gpio(gpio);
 
 	return 0;
 }
-EXPORT_SYMBOL(rdc_gpio_direction_output);
+
+static struct gpio_chip rdc_gpio_chip = {
+	.label			= "rdc321x",
+	.direction_input	= rdc_gpio_direction_input,
+	.get			= rdc_gpio_get_value,
+	.direction_output	= rdc_gpio_direction_output,
+	.set			= rdc_gpio_set_value,
+	.base			= 0,
+	.ngpio			= RDC321X_MAX_GPIO + 1,
+};
+
+/* initially setup the 2 copies of the gpio data registers.
+   This function must be called by the platform setup code. */
+void __init rdc321x_gpio_setup()
+{
+	/* this might not be, what others (BIOS, bootloader, etc.)
+	   wrote to these registers before, but it's a good guess. Still
+	   better than just using 0xffffffff. */
+
+	gpio_data_reg1 = rdc321x_conf_read(RDC321X_GPIO_DATA_REG1);
+	gpio_data_reg2 = rdc321x_conf_read(RDC321X_GPIO_DATA_REG2);
+
+	gpiochip_add(&rdc_gpio_chip);
+}
+
--- a/arch/x86/mach-rdc321x/platform.c	2008-07-01 16:46:11.000000000 -0700
+++ b/arch/x86/mach-rdc321x/platform.c	2008-07-01 16:46:13.000000000 -0700
@@ -27,8 +27,7 @@
 #include <linux/platform_device.h>
 #include <linux/version.h>
 #include <linux/leds.h>
-
-#include <asm/gpio.h>
+#include <linux/gpio.h>
 
 /* LEDS */
 static struct gpio_led default_leds[] = {
--- a/include/asm-x86/gpio.h	2008-07-01 16:46:11.000000000 -0700
+++ b/include/asm-x86/gpio.h	2008-07-01 16:46:13.000000000 -0700
@@ -1,6 +1,26 @@
 #ifndef _ASM_I386_GPIO_H
 #define _ASM_I386_GPIO_H
 
-#include <gpio.h>
+#include <linux/errno.h>
+
+#ifdef CONFIG_X86_RDC321X
+#include <asm/mach-rdc321x/gpio.h>
+#endif
+
+#include <asm-generic/gpio.h>
+
+#define gpio_get_value	__gpio_get_value
+#define gpio_set_value	__gpio_set_value
+#define gpio_cansleep	__gpio_cansleep
+
+static inline int gpio_to_irq(unsigned gpio)
+{
+	return -ENOSYS;
+}
+
+static inline int irq_to_gpio(unsigned irq)
+{
+	return -EINVAL;
+}
 
 #endif /* _ASM_I386_GPIO_H */
--- a/include/asm-x86/mach-rdc321x/gpio.h	2008-07-01 16:46:11.000000000 -0700
+++ b/include/asm-x86/mach-rdc321x/gpio.h	2008-07-01 17:08:38.000000000 -0700
@@ -1,57 +1,11 @@
 #ifndef _RDC321X_GPIO_H
 #define _RDC321X_GPIO_H
 
-extern int rdc_gpio_get_value(unsigned gpio);
-extern void rdc_gpio_set_value(unsigned gpio, int value);
-extern int rdc_gpio_direction_input(unsigned gpio);
-extern int rdc_gpio_direction_output(unsigned gpio, int value);
-extern int rdc_gpio_request(unsigned gpio, const char *label);
-extern void rdc_gpio_free(unsigned gpio);
 extern void __init rdc321x_gpio_setup(void);
 
-/* Wrappers for the arch-neutral GPIO API */
-
-static inline int gpio_request(unsigned gpio, const char *label)
-{
-	return rdc_gpio_request(gpio, label);
-}
-
-static inline void gpio_free(unsigned gpio)
-{
-	rdc_gpio_free(gpio);
-}
-
-static inline int gpio_direction_input(unsigned gpio)
-{
-	return rdc_gpio_direction_input(gpio);
-}
-
-static inline int gpio_direction_output(unsigned gpio, int value)
-{
-	return rdc_gpio_direction_output(gpio, value);
-}
-
-static inline int gpio_get_value(unsigned gpio)
-{
-	return rdc_gpio_get_value(gpio);
-}
-
-static inline void gpio_set_value(unsigned gpio, int value)
-{
-	rdc_gpio_set_value(gpio, value);
-}
-
-static inline int gpio_to_irq(unsigned gpio)
-{
-	return gpio;
-}
-
-static inline int irq_to_gpio(unsigned irq)
-{
-	return irq;
-}
+#define RDC321X_MAX_GPIO	58
 
-/* For cansleep */
-#include <asm-generic/gpio.h>
+/* allow for a few external GPIO expanders */
+#define	ARCH_NR_GPIOS		(RDC321X_MAX_GPIO + 64)
 
 #endif /* _RDC321X_GPIO_H_ */
--- a/include/asm-x86/mach-rdc321x/rdc321x_defs.h	2008-07-01 16:46:11.000000000 -0700
+++ b/include/asm-x86/mach-rdc321x/rdc321x_defs.h	2008-07-01 16:46:13.000000000 -0700
@@ -8,5 +8,3 @@
 #define RDC321X_GPIO_CTRL_REG2	0x84
 #define RDC321X_GPIO_DATA_REG1	0x4c
 #define RDC321X_GPIO_DATA_REG2	0x88
-
-#define RDC321X_MAX_GPIO	58
