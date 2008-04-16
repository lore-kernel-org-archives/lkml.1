Return-Path: <linux-kernel-owner+w=401wt.eu-S932279AbYDPUxa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932279AbYDPUxa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 16:53:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753274AbYDPUxR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 16:53:17 -0400
Received: from hu-out-0506.google.com ([72.14.214.225]:7931 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932157AbYDPUxP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 16:53:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=wS92y3u2Xh4Wiz4i4JA6+vNyEemFZig5vD1QKOSJEO+IOnMEAzEahJnReQ7iu1gXlhJpL1U6CxMlnsLr+GVCyWKbcVEjm7VTFtCalQPptTYiGqwtkF1rWgnqgrkX8m0YXn04cQLL0to9JxZdLjxBaLTFaDNzeW63PL7Xf+VFrvs=
Date: Wed, 16 Apr 2008 22:53:04 +0200
From: Cezary Jackiewicz <cezary.jackiewicz@gmail.com>
To: Andrew Morton <akpm@osdl.org>
Cc: Len Brown <lenb@kernel.org>, Richard Purdie <rpurdie@rpsys.net>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: [PATCH -mm 2/3] misc,acpi,backlight: Compal Laptop Extras - use
 bitmask, not hex
Message-ID: <20080416225304.3dc5b9d2@debian>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cezary Jackiewicz <cezary.jackiewicz@gmail.com>

Clean up code. Use bitmask for operations.

Signed-off-by: Cezary Jackiewicz <cezary.jackiewicz@gmail.com>
---
diff -Nuar a/drivers/misc/compal-laptop.c b/drivers/misc/compal-laptop.c
--- a/drivers/misc/compal-laptop.c	2008-04-16 19:42:45.000000000 +0200
+++ b/drivers/misc/compal-laptop.c	2008-04-16 20:19:09.000000000 +0200
@@ -1,7 +1,7 @@
 /*-*-linux-c-*-*/
 
 /*
-  Copyright (C) 2008 Cezary Jackiewicz <cezary.Jackiewicz (at) gmail.com>
+  Copyright (C) 2008 Cezary Jackiewicz <cezary.jackiewicz (at) gmail.com>
 
   based on MSI driver
 
@@ -56,13 +56,17 @@
 #include <linux/platform_device.h>
 #include <linux/autoconf.h>
 
-#define COMPAL_DRIVER_VERSION "0.2.2"
+#define COMPAL_DRIVER_VERSION "0.2.5"
 
 #define COMPAL_LCD_LEVEL_MAX 8
 
 #define COMPAL_EC_COMMAND_WIRELESS 0xBB
 #define COMPAL_EC_COMMAND_LCD_LEVEL 0xB9
 
+#define KILLSWITCH_MASK	0x10
+#define WLAN_MASK	0x01
+#define BT_MASK		0x02
+
 static int force;
 module_param(force, bool, 0);
 MODULE_PARM_DESC(force, "Force driver load, ignore DMI data");
@@ -94,13 +98,13 @@
 
 	ec_read(COMPAL_EC_COMMAND_WIRELESS, &result);
 
-	if ((result & 0x10) == 0)
+	if ((result & KILLSWITCH_MASK) == 0)
 		return -EINVAL;
 	else {
 		if (state)
-			value = (u8) (result | 0x01);
+			value = (u8) (result | WLAN_MASK);
 		else
-			value = (u8) (result & 0xFE);
+			value = (u8) (result & ~WLAN_MASK);
 		ec_write(COMPAL_EC_COMMAND_WIRELESS, value);
 	}
 
@@ -113,13 +117,13 @@
 
 	ec_read(COMPAL_EC_COMMAND_WIRELESS, &result);
 
-	if ((result & 0x10) == 0)
+	if ((result & KILLSWITCH_MASK) == 0)
 		return -EINVAL;
 	else {
 		if (state)
-			value = (u8) (result | 0x02);
+			value = (u8) (result | BT_MASK);
 		else
-			value = (u8) (result & 0xFD);
+			value = (u8) (result & ~BT_MASK);
 		ec_write(COMPAL_EC_COMMAND_WIRELESS, value);
 	}
 
@@ -133,17 +137,17 @@
 	ec_read(COMPAL_EC_COMMAND_WIRELESS, &result);
 
 	if (wlan) {
-		if ((result & 0x10) == 0)
+		if ((result & KILLSWITCH_MASK) == 0)
 			*wlan = 0;
 		else
-			*wlan = result & 0x01;
+			*wlan = result & WLAN_MASK;
 	}
 
 	if (bluetooth) {
-		if ((result & 0x10) == 0)
+		if ((result & KILLSWITCH_MASK) == 0)
 			*bluetooth = 0;
 		else
-			*bluetooth = (result >> 1) & 0x01;
+			*bluetooth = (result & BT_MASK) >> 1;
 	}
 
 	return 0;
