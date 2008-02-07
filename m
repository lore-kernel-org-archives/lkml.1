Return-Path: <linux-kernel-owner+w=401wt.eu-S1758269AbYBGE6R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758269AbYBGE6R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 23:58:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751177AbYBGE6G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 23:58:06 -0500
Received: from mail.velocitynet.com.au ([203.17.154.25]:37631 "EHLO
	m0.velocity.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751373AbYBGE6F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 23:58:05 -0500
X-Greylist: delayed 1731 seconds by postgrey-1.27 at vger.kernel.org; Wed, 06 Feb 2008 23:58:05 EST
Message-ID: <47AA8909.3040706@niasdigital.com>
Date: Thu, 07 Feb 2008 15:28:57 +1100
From: Ben Nizette <bn@niasdigital.com>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Haavard Skinnemoen <hskinnemoen@atmel.com>
CC: kernel@avr32linux.org, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] AVR32: pass i2c board info through at32_add_device_twi
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


New-style I2C drivers require that motherboard-mounted I2C devices are
registered with the I2C core, typically at arch_initcall time.  This can be
done nice and neat by passing the struct i2c_board_info[] through
at32_add_device_twi just like we do for the SPI board info.

While we've got the hood up, remove a duplicate declaration of
at32_add_device_twi() in board.h.

Signed-Off-By: Ben Nizette <bn@niasdigital.com>


---
Index: linux-2.6.23.atmel.4/arch/avr32/boards/atngw100/setup.c
===================================================================
--- linux-2.6.23.atmel.4.orig/arch/avr32/boards/atngw100/setup.c
+++ linux-2.6.23.atmel.4/arch/avr32/boards/atngw100/setup.c
@@ -180,7 +180,7 @@
 		AT32_GPIOF_MULTIDRV | AT32_GPIOF_OUTPUT | AT32_GPIOF_HIGH);
 	platform_device_register(&i2c_gpio_device);
 #else
-	at32_add_device_twi(0);
+	at32_add_device_twi(0, NULL, 0);
 #endif

 	return 0;
Index: linux-2.6.23.atmel.4/arch/avr32/mach-at32ap/at32ap700x.c
===================================================================
--- linux-2.6.23.atmel.4.orig/arch/avr32/mach-at32ap/at32ap700x.c
+++ linux-2.6.23.atmel.4/arch/avr32/mach-at32ap/at32ap700x.c
@@ -988,7 +988,9 @@
 	.index		= 2,
 };

-struct platform_device *__init at32_add_device_twi(unsigned int id)
+struct platform_device *__init at32_add_device_twi(unsigned int id,
+						    struct i2c_board_info *b,
+						    unsigned int n)
 {
 	struct platform_device *pdev;

@@ -1008,6 +1010,9 @@

 	atmel_twi0_pclk.dev = &pdev->dev;

+	if (b)
+		i2c_register_board_info(id, b, n);
+
 	platform_device_add(pdev);
 	return pdev;

Index: linux-2.6.23.atmel.4/arch/avr32/boards/atstk1000/atstk1002.c
===================================================================
--- linux-2.6.23.atmel.4.orig/arch/avr32/boards/atstk1000/atstk1002.c
+++ linux-2.6.23.atmel.4/arch/avr32/boards/atstk1000/atstk1002.c
@@ -245,7 +245,7 @@
 #ifdef CONFIG_BOARD_ATSTK100X_SPI1
 	at32_add_device_spi(1, spi1_board_info, ARRAY_SIZE(spi1_board_info));
 #endif
-	at32_add_device_twi(0);
+	at32_add_device_twi(0, NULL, 0);
 #ifndef CONFIG_BOARD_ATSTK100X_SW2_CUSTOM
 	at32_add_device_mci(0, &mci0_data);
 #endif
Index: linux-2.6.23.atmel.4/include/asm-avr32/arch-at32ap/board.h
===================================================================
--- linux-2.6.23.atmel.4.orig/include/asm-avr32/arch-at32ap/board.h
+++ linux-2.6.23.atmel.4/include/asm-avr32/arch-at32ap/board.h
@@ -33,7 +33,9 @@
 struct platform_device *
 at32_add_device_spi(unsigned int id, struct spi_board_info *b, unsigned int n);

-struct platform_device *at32_add_device_twi(unsigned int id);
+struct platform_device *at32_add_device_twi(unsigned int id,
+					     struct i2c_board_info *b,
+					     unsigned int n);

 struct atmel_lcdfb_info;
 struct platform_device *
@@ -67,8 +69,6 @@
 struct platform_device *
 at32_add_device_ssc(unsigned int id, unsigned int flags);

-struct platform_device *at32_add_device_twi(unsigned int id);
-
 struct mci_platform_data {
 	int detect_pin;
 	int wp_pin;
