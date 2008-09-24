Return-Path: <linux-kernel-owner+w=401wt.eu-S1753251AbYIXCqC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753251AbYIXCqC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 22:46:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751415AbYIXCpy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 22:45:54 -0400
Received: from rv-out-0506.google.com ([209.85.198.235]:7379 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751128AbYIXCpx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 22:45:53 -0400
Message-ID: <a700c9740809231945j643b226fv30d87521045078b1@mail.gmail.com>
Date: Wed, 24 Sep 2008 11:45:49 +0900
From: "Alexey Kopytko" <alexey@kopytko.ru>
To: "Alessandro Zummo" <a.zummo@towertech.it>
Subject: [PATCH] RTC: Add platform data structure to Ricoh RS5C372 driver
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexey Kopytko <alexey@kopytko.ru>

This patch enables a platform developer to choose which alarm register to use.
It adds and properly initializes platform data structure.

---
RS5C_REG_ALARM_B_MIN is used to store power state in
Buffalo Linkstation Mini and some other Linkstations.
Tested with and without platform data.

Signed-off-by: Alexey Kopytko <alexey@kopytko.ru>

diff --git a/drivers/rtc/rtc-rs5c372.c b/drivers/rtc/rtc-rs5c372.c
index 56caf6b..97519a0 100644
--- a/drivers/rtc/rtc-rs5c372.c
+++ b/drivers/rtc/rtc-rs5c372.c
@@ -12,6 +12,7 @@
 #include <linux/i2c.h>
 #include <linux/rtc.h>
 #include <linux/bcd.h>
+#include <linux/rtc/rs5c372.h>

 #define DRV_VERSION "0.5"

@@ -33,14 +34,6 @@
 #	define RS5C372_TRIM_XSL		0x80
 #	define RS5C372_TRIM_MASK	0x7F

-#define RS5C_REG_ALARM_A_MIN	8			/* or ALARM_W */
-#define RS5C_REG_ALARM_A_HOURS	9
-#define RS5C_REG_ALARM_A_WDAY	10
-
-#define RS5C_REG_ALARM_B_MIN	11			/* or ALARM_D */
-#define RS5C_REG_ALARM_B_HOURS	12
-#define RS5C_REG_ALARM_B_WDAY	13			/* (ALARM_B only) */
-
 #define RS5C_REG_CTRL1		14
 #	define RS5C_CTRL1_AALE		(1 << 7)	/* or WALE */
 #	define RS5C_CTRL1_BALE		(1 << 6)	/* or DALE */
@@ -91,6 +84,7 @@ struct rs5c372 {
 	unsigned		has_irq:1;
 	char			buf[17];
 	char			*regs;
+	struct rs5c_plat_data	pdata;
 };

 static int rs5c_get_regs(struct rs5c372 *rs5c)
@@ -344,8 +338,8 @@ static int rs5c_read_alarm(struct device *dev,
struct rtc_wkalrm *t)

 	/* report alarm time */
 	t->time.tm_sec = 0;
-	t->time.tm_min = BCD2BIN(rs5c->regs[RS5C_REG_ALARM_A_MIN] & 0x7f);
-	t->time.tm_hour = rs5c_reg2hr(rs5c, rs5c->regs[RS5C_REG_ALARM_A_HOURS]);
+	t->time.tm_min = BCD2BIN(rs5c->regs[rs5c->pdata.alarm_min] & 0x7f);
+	t->time.tm_hour = rs5c_reg2hr(rs5c, rs5c->regs[rs5c->pdata.alarm_hours]);
 	t->time.tm_mday = -1;
 	t->time.tm_mon = -1;
 	t->time.tm_year = -1;
@@ -390,7 +384,7 @@ static int rs5c_set_alarm(struct device *dev,
struct rtc_wkalrm *t)
 	}

 	/* set alarm */
-	buf[0] = RS5C_ADDR(RS5C_REG_ALARM_A_MIN);
+	buf[0] = RS5C_ADDR(rs5c->pdata.alarm_min);
 	buf[1] = BIN2BCD(t->time.tm_min);
 	buf[2] = rs5c_hr2reg(rs5c, t->time.tm_hour);
 	buf[3] = 0x7f;	/* any/all days */
@@ -521,6 +515,13 @@ static int rs5c372_probe(struct i2c_client *client,
 		err = -ENOMEM;
 		goto exit;
 	}
+
+	if (client->dev.platform_data) {
+		rs5c372->pdata = *(struct rs5c_plat_data *)client->dev.platform_data;
+	} else {
+		rs5c372->pdata.alarm_min = RS5C_REG_ALARM_A_MIN;
+		rs5c372->pdata.alarm_hours = RS5C_REG_ALARM_A_HOURS;
+	}

 	rs5c372->client = client;
 	i2c_set_clientdata(client, rs5c372);
diff --git a/include/linux/rtc/rs5c372.h b/include/linux/rtc/rs5c372.h
index e69de29..573cd2a 100644
--- a/include/linux/rtc/rs5c372.h
+++ b/include/linux/rtc/rs5c372.h
@@ -0,0 +1,28 @@
+/*
+ * include/linux/rtc/rs5c372.h
+ *
+ * Definitions for the platform data of Ricoh RS5C372 and RV5C38[67] RTCs chips
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef _LINUX_RTC_RS5C372_H_
+#define _LINUX_RTC_RS5C372_H_
+
+#define RS5C_REG_ALARM_A_MIN	8			/* or ALARM_W */
+#define RS5C_REG_ALARM_A_HOURS	9
+#define RS5C_REG_ALARM_A_WDAY	10
+
+#define RS5C_REG_ALARM_B_MIN	11			/* or ALARM_D */
+#define RS5C_REG_ALARM_B_HOURS	12
+#define RS5C_REG_ALARM_B_WDAY	13			/* (ALARM_B only) */
+
+struct rs5c_plat_data {
+	/* What alarm regs to use */
+	int alarm_min;
+	int alarm_hours;
+};
+
+#endif /* _LINUX_RTC_RS5C372_H_ */
