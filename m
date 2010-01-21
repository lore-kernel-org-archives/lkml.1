Return-Path: <linux-kernel-owner+w=401wt.eu-S1754374Ab0AUOI4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754374Ab0AUOI4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 09:08:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751657Ab0AUOIz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 09:08:55 -0500
Received: from compulab.co.il ([67.18.134.219]:57412 "EHLO compulab.co.il"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752189Ab0AUOIy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 09:08:54 -0500
Message-ID: <4B58603F.5030407@compulab.co.il>
Date: Thu, 21 Jan 2010 16:10:07 +0200
From: Denis Turischev <denis@compulab.co.il>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: Wim Van Sebroeck <wim@iguana.be>, Andrey Panin <pazke@centrinvest.ru>
Subject: SBC-FITPC2 watchdog driver fix
References: <4A6492EB.1080709@compulab.co.il> <4AF2B7D8.1010903@compulab.co.il>
In-Reply-To: <4AF2B7D8.1010903@compulab.co.il>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-ACL-Warn: {
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - compulab.site5.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - compulab.co.il
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sbc_fitpc2_wdt: fix I/O space access technique.

The mdelay function was used between I/O access commands, that causes peak
in CPU usage. Fix it by substitution mdelay to msleep.

Expand usage on fitPC2 compatible boards according to DMI identification.

Signed-off-by: Denis Turischev <denis@compulab.co.il>

diff -Nru linux-2.6.33-rc4.orig/drivers/watchdog/Kconfig linux-2.6.33-rc4/drivers/watchdog/Kconfig
--- linux-2.6.33-rc4.orig/drivers/watchdog/Kconfig	2010-01-13 07:15:00.000000000 +0200
+++ linux-2.6.33-rc4/drivers/watchdog/Kconfig	2010-01-20 13:47:18.000000000 +0200
@@ -396,8 +396,8 @@
 	tristate "Compulab SBC-FITPC2 watchdog"
 	depends on X86
 	---help---
-	  This is the driver for the built-in watchdog timer on the fit-PC2
-	  Single-board computer made by Compulab.
+	  This is the driver for the built-in watchdog timer on the fit-PC2,
+	  fit-PC2i, CM-iAM single-board computers made by Compulab.
 
 	  It`s possible to enable watchdog timer either from BIOS (F2) or from booted Linux.
 	  When "Watchdog Timer Value" enabled one can set 31-255 s operational range.
diff -Nru linux-2.6.33-rc4.orig/drivers/watchdog/sbc_fitpc2_wdt.c linux-2.6.33-rc4/drivers/watchdog/sbc_fitpc2_wdt.c
--- linux-2.6.33-rc4.orig/drivers/watchdog/sbc_fitpc2_wdt.c	2010-01-13 07:15:00.000000000 +0200
+++ linux-2.6.33-rc4/drivers/watchdog/sbc_fitpc2_wdt.c	2010-01-20 15:28:19.000000000 +0200
@@ -46,9 +46,9 @@
 static void wdt_send_data(unsigned char command, unsigned char data)
 {
 	outb(command, COMMAND_PORT);
-	mdelay(100);
+	msleep(100);
 	outb(data, DATA_PORT);
-	mdelay(200);
+	msleep(200);
 }
 
 static void wdt_enable(void)
@@ -202,11 +202,10 @@
 {
 	int err;
 
-	if (strcmp("SBC-FITPC2", dmi_get_system_info(DMI_BOARD_NAME))) {
-		pr_info("board name is: %s. Should be SBC-FITPC2\n",
-			dmi_get_system_info(DMI_BOARD_NAME));
+	if (!strstr(dmi_get_system_info(DMI_BOARD_NAME), "SBC-FITPC2"))
 		return -ENODEV;
-	}
+
+	pr_info("%s found\n", dmi_get_system_info(DMI_BOARD_NAME));
 
 	if (!request_region(COMMAND_PORT, 1, WATCHDOG_NAME)) {
 		pr_err("I/O address 0x%04x already in use\n", COMMAND_PORT);

