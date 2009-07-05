Return-Path: <linux-kernel-owner+w=401wt.eu-S1752960AbZGEEIa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752960AbZGEEIa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jul 2009 00:08:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751254AbZGEEIX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Jul 2009 00:08:23 -0400
Received: from liberdade.minaslivre.org ([72.232.18.203]:34824 "EHLO
	liberdade.minaslivre.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751121AbZGEEIX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jul 2009 00:08:23 -0400
From: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
To: rtc-linux@googlegroups.com
Cc: linux-kernel@vger.kernel.org, dbrownell@users.sourceforge.net,
       bjorn.helgaas@hp.com,
       Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Subject: [PATCH] RTC: mark if rtc-cmos drivers were successfully registered.
Date: Sun,  5 Jul 2009 01:07:59 -0300
Message-Id: <1246766879-5784-1-git-send-email-cascardo@holoscopio.com>
X-Mailer: git-send-email 1.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rtc-cmos has two drivers, one PNP and one platform. When PNP has not
succeeded probing, platform is registered. However, it tries to
unregister both drivers unconditionally, instead of only unregistering
those that were successfully registered. Fix that with a boolean
variable for each driver indicating whether registering was successful.

Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
---
 drivers/rtc/rtc-cmos.c |   23 ++++++++++++++++++-----
 1 files changed, 18 insertions(+), 5 deletions(-)

diff --git a/drivers/rtc/rtc-cmos.c b/drivers/rtc/rtc-cmos.c
index 23e10b6..f7a4701 100644
--- a/drivers/rtc/rtc-cmos.c
+++ b/drivers/rtc/rtc-cmos.c
@@ -1174,23 +1174,34 @@ static struct platform_driver cmos_platform_driver = {
 	}
 };
 
+#ifdef CONFIG_PNP
+static bool pnp_driver_registered;
+#endif
+static bool platform_driver_registered;
+
 static int __init cmos_init(void)
 {
 	int retval = 0;
 
 #ifdef	CONFIG_PNP
-	pnp_register_driver(&cmos_pnp_driver);
+	retval = pnp_register_driver(&cmos_pnp_driver);
+	if (retval == 0)
+		pnp_driver_registered = true;
 #endif
 
-	if (!cmos_rtc.dev)
+	if (!cmos_rtc.dev) {
 		retval = platform_driver_probe(&cmos_platform_driver,
 					       cmos_platform_probe);
+		if (retval == 0)
+			platform_driver_registered = true;
+	}
 
 	if (retval == 0)
 		return 0;
 
 #ifdef	CONFIG_PNP
-	pnp_unregister_driver(&cmos_pnp_driver);
+	if (pnp_driver_registered)
+		pnp_unregister_driver(&cmos_pnp_driver);
 #endif
 	return retval;
 }
@@ -1199,9 +1210,11 @@ module_init(cmos_init);
 static void __exit cmos_exit(void)
 {
 #ifdef	CONFIG_PNP
-	pnp_unregister_driver(&cmos_pnp_driver);
+	if (pnp_driver_registered)
+		pnp_unregister_driver(&cmos_pnp_driver);
 #endif
-	platform_driver_unregister(&cmos_platform_driver);
+	if (platform_driver_registered)
+		platform_driver_unregister(&cmos_platform_driver);
 }
 module_exit(cmos_exit);
 
-- 
1.6.3

