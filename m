Return-Path: <linux-kernel-owner+w=401wt.eu-S1753667AbYJ2JEn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753667AbYJ2JEn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 05:04:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752924AbYJ2JEW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 05:04:22 -0400
Received: from nf-out-0910.google.com ([64.233.182.186]:42836 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752831AbYJ2JEV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 05:04:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=rdsQbR3Xnem2VuOUq2voTrt68w4folTsgYOzQPYjqzckAn00cSnDLN7ce9s1xzhPOF
         QflSpGF0If+pLK+byJBG/ub0fw/6EoHGAg3crlCBeD0R7yocJ9YweVWw1YN1EdlKOdoa
         oSmJOGco00MVqYo1BA0FBtmoT0QvI5YL8Hdts=
From: Dmitry Baryshkov <dbaryshkov@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: cbou@mail.ru, Andrew Morton <akpm@linux-foundation.org>,
       Dmitry Baryshkov <dbaryshkov@gmail.com>,
       Marek Vasut <marek.vasut@gmail.com>
Subject: [PATCH] power_supply: change the way how wm97xx-bat driver is registered
Date: Wed, 29 Oct 2008 12:04:10 +0300
Message-Id: <1225271050-21171-2-git-send-email-dbaryshkov@gmail.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1225271050-21171-1-git-send-email-dbaryshkov@gmail.com>
References: <1225271050-21171-1-git-send-email-dbaryshkov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Do register the driver from wm97xx_bat_set_pdata instead of module init.
This has several positive outcome points:
1) This driver for wm97xx-battery is now registered on demand, thus allowing
  other driver (e.g. tosa-battery) to claim the battery.
2) After dropping __init from wm97xx_bat_set_pdata(), the wm97xx_bat driver
  can be correctly built as a module. Then one can request it and set the
  battery data.

Signed-off-by: Dmitry Baryshkov <dbaryshkov@gmail.com>
Cc: Marek Vasut <marek.vasut@gmail.com>
---
 drivers/power/Kconfig          |    4 ++--
 drivers/power/wm97xx_battery.c |   12 +++++-------
 include/linux/wm97xx_batt.h    |    7 +++++--
 3 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/drivers/power/Kconfig b/drivers/power/Kconfig
index 8e0c2b4..053f20b 100644
--- a/drivers/power/Kconfig
+++ b/drivers/power/Kconfig
@@ -57,8 +57,8 @@ config BATTERY_TOSA
 	  SL-6000 (tosa) models.
 
 config BATTERY_WM97XX
-	bool "WM97xx generic battery driver"
-	depends on TOUCHSCREEN_WM97XX=y
+	tristate "WM97xx generic battery driver"
+	depends on TOUCHSCREEN_WM97XX
 	help
 	  Say Y to enable support for battery measured by WM97xx aux port.
 
diff --git a/drivers/power/wm97xx_battery.c b/drivers/power/wm97xx_battery.c
index 8bde921..94727dc 100644
--- a/drivers/power/wm97xx_battery.c
+++ b/drivers/power/wm97xx_battery.c
@@ -248,23 +248,21 @@ static struct platform_driver wm97xx_bat_driver = {
 	.resume		= wm97xx_bat_resume,
 };
 
-static int __init wm97xx_bat_init(void)
-{
-	return platform_driver_register(&wm97xx_bat_driver);
-}
-
 static void __exit wm97xx_bat_exit(void)
 {
 	platform_driver_unregister(&wm97xx_bat_driver);
 }
 
-void __init wm97xx_bat_set_pdata(struct wm97xx_batt_info *data)
+int wm97xx_bat_set_pdata(struct wm97xx_batt_info *data)
 {
+	if (pdata)
+		return -EEXIST;
+
 	pdata = data;
+	return platform_driver_register(&wm97xx_bat_driver);
 }
 EXPORT_SYMBOL_GPL(wm97xx_bat_set_pdata);
 
-module_init(wm97xx_bat_init);
 module_exit(wm97xx_bat_exit);
 
 MODULE_LICENSE("GPL");
diff --git a/include/linux/wm97xx_batt.h b/include/linux/wm97xx_batt.h
index 9681d1a..3e42526 100644
--- a/include/linux/wm97xx_batt.h
+++ b/include/linux/wm97xx_batt.h
@@ -18,9 +18,12 @@ struct wm97xx_batt_info {
 };
 
 #ifdef CONFIG_BATTERY_WM97XX
-void __init wm97xx_bat_set_pdata(struct wm97xx_batt_info *data);
+int wm97xx_bat_set_pdata(struct wm97xx_batt_info *data);
 #else
-static inline void wm97xx_bat_set_pdata(struct wm97xx_batt_info *data) {}
+static inline int wm97xx_bat_set_pdata(struct wm97xx_batt_info *data)
+{
+	return -ENODEV;
+}
 #endif
 
 #endif
-- 
1.5.6.5

