Return-Path: <linux-kernel-owner+w=401wt.eu-S1422714AbXCBCim@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422714AbXCBCim (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 21:38:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422715AbXCBCim
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 21:38:42 -0500
Received: from smtp105.sbc.mail.mud.yahoo.com ([68.142.198.204]:25456 "HELO
	smtp105.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1422714AbXCBCil (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 21:38:41 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=JWZ8KAKhnpARixWm7beKCYI4smyD6QoWpW4xHwA3PGpkWNKbG/t48CrkPUpgpzO1FUH/Zz33GUaUokSendyC09fbTl0MsncI+2XG7rvhXzcq9+6zZchF2yVX2Hwx63yHBeCooGdWydiGI7G89X1TxojtikrFF0+MqgXgX6VjBlA=  ;
X-YMail-OSG: LKObNEUVM1ka8J6MpQ0fNp8x2Nne8soXDQNikD07Z_gni4CFGLyPjJd9nfE8LORhLwEBwQl8JyebMSXidqvDYJpNGWAmvExoBYmR2xSKeK.2x6h5dqnMHyLYEZB9cNYgKBq3UljNC46wUkSr9YSPg0RNVg--
From: David Brownell <david-b@pacbell.net>
To: Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: [patch 2.6.20-rc2] gpio_direction_output() needs an initial value
Date: Thu, 1 Mar 2007 18:25:09 -0800
User-Agent: KMail/1.7.1
Cc: Andrew Victor <andrew@sanpeople.com>,
       Milan Svoboda <msvoboda@ra.rockwell.com>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703011825.10370.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

It's been pointed out that output GPIOs should have an initial value, to
avoid signal glitching ... among other things, it can be some time before
a driver is ready.  This patch corrects that oversight, fixing

 - documentation
 - platforms supporting the GPIO interface
 - users of that call (just one for now, others are pending)

Note that most platforms are clear about the hardware letting the output
value be set before the pin direction is changed, but the s3c241x docs
are vague on that topic ... so those chips might not avoid the glitches.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
---
Please merge for 2.6.21 ... better to get these API details
sorted out now, while the relevant patch is small.

 Documentation/gpio.txt               |    5 ++++-
 arch/arm/mach-at91/gpio.c            |    3 ++-
 arch/arm/mach-sa1100/generic.c       |    3 ++-
 arch/avr32/mach-at32ap/pio.c         |    4 +++-
 drivers/spi/atmel_spi.c              |    2 +-
 include/asm-arm/arch-at91/gpio.h     |    2 +-
 include/asm-arm/arch-omap/gpio.h     |    3 ++-
 include/asm-arm/arch-pxa/gpio.h      |    4 ++--
 include/asm-arm/arch-s3c2410/gpio.h  |    4 +++-
 include/asm-arm/arch-sa1100/gpio.h   |    2 +-
 include/asm-avr32/arch-at32ap/gpio.h |    2 +-
 11 files changed, 22 insertions(+), 12 deletions(-)

Index: g26/Documentation/gpio.txt
===================================================================
--- g26.orig/Documentation/gpio.txt	2007-02-18 09:07:59.000000000 -0800
+++ g26/Documentation/gpio.txt	2007-03-01 14:33:56.000000000 -0800
@@ -105,12 +105,15 @@ setting up a platform_device using the G
 
 	/* set as input or output, returning 0 or negative errno */
 	int gpio_direction_input(unsigned gpio);
-	int gpio_direction_output(unsigned gpio);
+	int gpio_direction_output(unsigned gpio, int value);
 
 The return value is zero for success, else a negative errno.  It should
 be checked, since the get/set calls don't have error returns and since
 misconfiguration is possible.  (These calls could sleep.)
 
+For output GPIOs, the value provided becomes the initial value.  This
+helps avoid signal glitching during system startup.
+
 Setting the direction can fail if the GPIO number is invalid, or when
 that particular GPIO can't be used in that mode.  It's generally a bad
 idea to rely on boot firmware to have set the direction correctly, since
Index: g26/include/asm-arm/arch-at91/gpio.h
===================================================================
--- g26.orig/include/asm-arm/arch-at91/gpio.h	2007-02-19 13:43:00.000000000 -0800
+++ g26/include/asm-arm/arch-at91/gpio.h	2007-03-01 14:36:02.000000000 -0800
@@ -223,7 +223,7 @@ static inline void gpio_free(unsigned gp
 }
 
 extern int gpio_direction_input(unsigned gpio);
-extern int gpio_direction_output(unsigned gpio);
+extern int gpio_direction_output(unsigned gpio, int value);
 
 static inline int gpio_get_value(unsigned gpio)
 {
Index: g26/arch/arm/mach-at91/gpio.c
===================================================================
--- g26.orig/arch/arm/mach-at91/gpio.c	2007-02-28 12:46:00.000000000 -0800
+++ g26/arch/arm/mach-at91/gpio.c	2007-03-01 14:37:15.000000000 -0800
@@ -215,13 +215,14 @@ int gpio_direction_input(unsigned pin)
 }
 EXPORT_SYMBOL(gpio_direction_input);
 
-int gpio_direction_output(unsigned pin)
+int gpio_direction_output(unsigned pin, int value)
 {
 	void __iomem	*pio = pin_to_controller(pin);
 	unsigned	mask = pin_to_mask(pin);
 
 	if (!pio || !(__raw_readl(pio + PIO_PSR) & mask))
 		return -EINVAL;
+	__raw_writel(mask, pio + (value ? PIO_SODR : PIO_CODR));
 	__raw_writel(mask, pio + PIO_OER);
 	return 0;
 }
Index: g26/include/asm-arm/arch-omap/gpio.h
===================================================================
--- g26.orig/include/asm-arm/arch-omap/gpio.h	2007-02-12 15:53:17.000000000 -0800
+++ g26/include/asm-arm/arch-omap/gpio.h	2007-03-01 14:38:36.000000000 -0800
@@ -113,8 +113,9 @@ static inline int gpio_direction_input(u
 	return __gpio_set_direction(gpio, 1);
 }
 
-static inline int gpio_direction_output(unsigned gpio)
+static inline int gpio_direction_output(unsigned gpio, int value)
 {
+	omap_set_gpio_dataout(gpio, value);
 	return __gpio_set_direction(gpio, 0);
 }
 
Index: g26/include/asm-arm/arch-pxa/gpio.h
===================================================================
--- g26.orig/include/asm-arm/arch-pxa/gpio.h	2007-02-20 22:17:28.000000000 -0800
+++ g26/include/asm-arm/arch-pxa/gpio.h	2007-03-01 14:41:36.000000000 -0800
@@ -43,9 +43,9 @@ static inline int gpio_direction_input(u
 	return pxa_gpio_mode(gpio | GPIO_IN);
 }
 
-static inline int gpio_direction_output(unsigned gpio)
+static inline int gpio_direction_output(unsigned gpio, int value)
 {
-	return pxa_gpio_mode(gpio | GPIO_OUT);
+	return pxa_gpio_mode(gpio | GPIO_OUT | (value ? 0 : GPIO_DFLT_LOW));
 }
 
 static inline int __gpio_get_value(unsigned gpio)
Index: g26/include/asm-arm/arch-s3c2410/gpio.h
===================================================================
--- g26.orig/include/asm-arm/arch-s3c2410/gpio.h	2007-02-20 22:17:28.000000000 -0800
+++ g26/include/asm-arm/arch-s3c2410/gpio.h	2007-03-01 14:49:29.000000000 -0800
@@ -44,9 +44,11 @@ static inline int gpio_direction_input(u
 	return 0;
 }
 
-static inline int gpio_direction_output(unsigned gpio)
+static inline int gpio_direction_output(unsigned gpio, int value)
 {
 	s3c2410_gpio_cfgpin(gpio, S3C2410_GPIO_OUTPUT);
+	/* could we write the value first, to avoid glitching? */
+	s3c2410_gpio_setpin(gpio, value);
 	return 0;
 }
 
Index: g26/include/asm-arm/arch-sa1100/gpio.h
===================================================================
--- g26.orig/include/asm-arm/arch-sa1100/gpio.h	2007-02-20 22:17:28.000000000 -0800
+++ g26/include/asm-arm/arch-sa1100/gpio.h	2007-03-01 14:53:13.000000000 -0800
@@ -38,7 +38,7 @@ static inline void gpio_free(unsigned gp
 }
 
 extern int gpio_direction_input(unsigned gpio);
-extern int gpio_direction_output(unsigned gpio);
+extern int gpio_direction_output(unsigned gpio, int value);
 
 
 static inline int gpio_get_value(unsigned gpio)
Index: g26/arch/arm/mach-sa1100/generic.c
===================================================================
--- g26.orig/arch/arm/mach-sa1100/generic.c	2007-02-20 22:17:27.000000000 -0800
+++ g26/arch/arm/mach-sa1100/generic.c	2007-03-01 14:55:00.000000000 -0800
@@ -153,7 +153,7 @@ int gpio_direction_input(unsigned gpio)
 
 EXPORT_SYMBOL(gpio_direction_input);
 
-int gpio_direction_output(unsigned gpio)
+int gpio_direction_output(unsigned gpio, int value)
 {
 	unsigned long flags;
 
@@ -161,6 +161,7 @@ int gpio_direction_output(unsigned gpio)
 		return -EINVAL;
 
 	local_irq_save(flags);
+	gpio_set_value(gpio, value);
 	GPDR |= GPIO_GPIO(gpio);
 	local_irq_restore(flags);
 	return 0;
Index: g26/include/asm-avr32/arch-at32ap/gpio.h
===================================================================
--- g26.orig/include/asm-avr32/arch-at32ap/gpio.h	2007-02-12 00:31:25.000000000 -0800
+++ g26/include/asm-avr32/arch-at32ap/gpio.h	2007-03-01 14:56:49.000000000 -0800
@@ -10,7 +10,7 @@ int __must_check gpio_request(unsigned i
 void gpio_free(unsigned int gpio);
 
 int gpio_direction_input(unsigned int gpio);
-int gpio_direction_output(unsigned int gpio);
+int gpio_direction_output(unsigned int gpio, int value);
 int gpio_get_value(unsigned int gpio);
 void gpio_set_value(unsigned int gpio, int value);
 
Index: g26/arch/avr32/mach-at32ap/pio.c
===================================================================
--- g26.orig/arch/avr32/mach-at32ap/pio.c	2007-02-12 00:31:18.000000000 -0800
+++ g26/arch/avr32/mach-at32ap/pio.c	2007-03-01 14:58:32.000000000 -0800
@@ -214,7 +214,7 @@ int gpio_direction_input(unsigned int gp
 }
 EXPORT_SYMBOL(gpio_direction_input);
 
-int gpio_direction_output(unsigned int gpio)
+int gpio_direction_output(unsigned int gpio, int value)
 {
 	struct pio_device *pio;
 	unsigned int pin;
@@ -223,6 +223,8 @@ int gpio_direction_output(unsigned int g
 	if (!pio)
 		return -ENODEV;
 
+	gpio_set_value(gpio, value);
+
 	pin = gpio & 0x1f;
 	pio_writel(pio, OER, 1 << pin);
 
Index: g26/drivers/spi/atmel_spi.c
===================================================================
--- g26.orig/drivers/spi/atmel_spi.c	2007-02-28 12:47:43.000000000 -0800
+++ g26/drivers/spi/atmel_spi.c	2007-03-01 15:29:30.000000000 -0800
@@ -425,7 +425,7 @@ static int atmel_spi_setup(struct spi_de
 		if (ret)
 			return ret;
 		spi->controller_state = (void *)npcs_pin;
-		gpio_direction_output(npcs_pin);
+		gpio_direction_output(npcs_pin, !(spi->mode & SPI_CS_HIGH));
 	}
 
 	dev_dbg(&spi->dev,
