Return-Path: <linux-kernel-owner+w=401wt.eu-S1761316AbYJJOuk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761316AbYJJOuk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 10:50:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759294AbYJJOu1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 10:50:27 -0400
Received: from sperry-02.control.lth.se ([130.235.83.189]:53262 "EHLO
	sperry-02.control.lth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757651AbYJJOuZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 10:50:25 -0400
X-Greylist: delayed 1095 seconds by postgrey-1.27 at vger.kernel.org; Fri, 10 Oct 2008 10:50:25 EDT
Message-ID: <48EF6762.2080205@control.lth.se>
Date: Fri, 10 Oct 2008 16:32:02 +0200
From: Anders Blomdell <anders.blomdell@control.lth.se>
User-Agent: Thunderbird 2.0.0.17 (Macintosh/20080914)
MIME-Version: 1.0
To: hskinnemoen@atmel.com
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] Make ATNGW100 serial ports configurable
Content-Type: multipart/mixed;
 boundary="------------080002070903090607010000"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080002070903090607010000
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit


--------------080002070903090607010000
Content-Type: text/plain; x-mac-type="0"; x-mac-creator="0";
 name="atngw100_serial.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="atngw100_serial.patch"

Make configuration of ATNGW100 serial ports selectable in kernel configuration.

Signed-off-by: Anders Blomdell <anders.blomdell@control.lth.se>



diff -urb orig/arch/avr32/boards/atngw100/Kconfig linux-2.6.27-rc6/arch/avr32/boards/atngw100/Kconfig
--- orig/arch/avr32/boards/atngw100/Kconfig	2008-10-09 17:56:14.000000000 +0200
+++ linux-2.6.27-rc6/arch/avr32/boards/atngw100/Kconfig	2008-10-09 16:26:08.000000000 +0200
@@ -0,0 +1,18 @@
+config SERIAL_ATMEL_USART0
+	bool "Enable USART0"
+	depends on SERIAL_ATMEL
+	help
+	  Enable USART0 (on expansion header J5, pins 12, 11)
+
+config SERIAL_ATMEL_USART2
+	bool "Enable USART2"
+	depends on SERIAL_ATMEL
+	help
+	  Enable USART2 (on expansion header J6, pins 27, 26)
+
+config SERIAL_ATMEL_USART3
+	bool "Enable USART3"
+	depends on SERIAL_ATMEL
+	help
+	  Enable USART3 (on expansion header J6, pins 17, 18)
+
diff -urb orig/arch/avr32/boards/atngw100/setup.c linux-2.6.27-rc6/arch/avr32/boards/atngw100/setup.c
--- orig/arch/avr32/boards/atngw100/setup.c	2008-10-09 17:54:55.000000000 +0200
+++ linux-2.6.27-rc6/arch/avr32/boards/atngw100/setup.c	2008-10-09 16:33:50.000000000 +0200
@@ -114,8 +114,20 @@
 
 void __init setup_board(void)
 {
-	at32_map_usart(1, 0);	/* USART 1: /dev/ttyS0, DB9 */
+	int i = 0;
+
+	at32_map_usart(1, i++);	/* USART 1: /dev/ttyS0, DB9 */
 	at32_setup_serial_console(0);
+
+#ifdef CONFIG_SERIAL_ATMEL_USART0
+	at32_map_usart(0, i++);	/* USART 0: /dev/ttySX, J5, pins 12, 11 */
+#endif
+#ifdef CONFIG_SERIAL_ATMEL_USART2
+	at32_map_usart(2, i++);	/* USART 2: /dev/ttySX, J6, pins 27, 26 */
+#endif
+#ifdef CONFIG_SERIAL_ATMEL_USART3
+	at32_map_usart(3, i++);	/* USART 3: /dev/ttySX, J6, pins 17, 18 */
+#endif
 }
 
 static const struct gpio_led ngw_leds[] = {
@@ -170,7 +182,17 @@
 
 	at32_add_system_devices();
 
-	at32_add_device_usart(0);
+	i = 0;
+	at32_add_device_usart(i++);
+#ifdef CONFIG_SERIAL_ATMEL_USART0
+	at32_add_device_usart(i++);
+#endif
+#ifdef CONFIG_SERIAL_ATMEL_USART2
+	at32_add_device_usart(i++);
+#endif
+#ifdef CONFIG_SERIAL_ATMEL_USART3
+	at32_add_device_usart(i++);
+#endif
 
 	set_hw_addr(at32_add_device_eth(0, &eth_data[0]));
 	set_hw_addr(at32_add_device_eth(1, &eth_data[1]));
diff -urb orig/arch/avr32/Kconfig linux-2.6.27-rc6/arch/avr32/Kconfig
--- orig/arch/avr32/Kconfig	2008-10-09 17:54:55.000000000 +0200
+++ linux-2.6.27-rc6/arch/avr32/Kconfig	2008-10-09 16:21:49.000000000 +0200
@@ -125,6 +125,10 @@
 source "arch/avr32/boards/atstk1000/Kconfig"
 endif
 
+if BOARD_ATNGW100
+source "arch/avr32/boards/atngw100/Kconfig"
+endif
+
 choice
 	prompt "Boot loader type"
 	default LOADER_U_BOOT

--------------080002070903090607010000--
