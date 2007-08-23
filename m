Return-Path: <linux-kernel-owner+w=401wt.eu-S1759477AbXHWHlp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759477AbXHWHlp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 03:41:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755423AbXHWHlh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 03:41:37 -0400
Received: from smtp2.actcom.co.il ([192.114.47.35]:56768 "EHLO
	smtp2.actcom.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755281AbXHWHlg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 03:41:36 -0400
Message-ID: <46CD38E6.4000401@compulab.co.il>
Date: Thu, 23 Aug 2007 10:36:06 +0300
From: Mike Rapoport <mike@compulab.co.il>
User-Agent: Thunderbird 2.0.0.6 (X11/20070822)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: Raphael Assenat <raph@8d.com>, Alessandro Zummo <a.zummo@towertech.it>
Subject: [PATCH, RESEND] RTC v3020 fixes
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fix off-by-one in month calculations
Add delay for bus accesses to satisfy Tw > 500ns

Signed-off-by: Mike Rapoport <mike@compulab.co.il>
Acked-by: Raphael Assenat <raph@8d.com>

 drivers/rtc/rtc-v3020.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/rtc/rtc-v3020.c b/drivers/rtc/rtc-v3020.c
index 3b58d3d..e96d667 100644
--- a/drivers/rtc/rtc-v3020.c
+++ b/drivers/rtc/rtc-v3020.c
@@ -26,6 +26,7 @@
 #include <linux/types.h>
 #include <linux/bcd.h>
 #include <linux/rtc-v3020.h>
+#include <linux/delay.h>

 #include <asm/io.h>

@@ -47,6 +48,7 @@ static void v3020_set_reg(struct v3020 *chip, unsigned char address,
     for (i = 0; i < 4; i++) {
         writel((tmp & 1) << chip->leftshift, chip->ioaddress);
         tmp >>= 1;
+        udelay(1);
     }

     /* Commands dont have data */
@@ -54,6 +56,7 @@ static void v3020_set_reg(struct v3020 *chip, unsigned char address,
         for (i = 0; i < 8; i++) {
             writel((data & 1) << chip->leftshift, chip->ioaddress);
             data >>= 1;
+            udelay(1);
         }
     }
 }
@@ -66,12 +69,14 @@ static unsigned char v3020_get_reg(struct v3020 *chip, unsigned char address)
     for (i = 0; i < 4; i++) {
         writel((address & 1) << chip->leftshift, chip->ioaddress);
         address >>= 1;
+        udelay(1);
     }

     for (i = 0; i < 8; i++) {
         data >>= 1;
         if (readl(chip->ioaddress) & (1 << chip->leftshift))
             data |= 0x80;
+        udelay(1);
     }

     return data;
@@ -95,7 +100,7 @@ static int v3020_read_time(struct device *dev, struct rtc_time *dt)
     tmp = v3020_get_reg(chip, V3020_MONTH_DAY);
     dt->tm_mday    = BCD2BIN(tmp);
     tmp = v3020_get_reg(chip, V3020_MONTH);
-    dt->tm_mon    = BCD2BIN(tmp);
+    dt->tm_mon    = BCD2BIN(tmp) - 1;
     tmp = v3020_get_reg(chip, V3020_WEEK_DAY);
     dt->tm_wday    = BCD2BIN(tmp);
     tmp = v3020_get_reg(chip, V3020_YEAR);
@@ -135,7 +140,7 @@ static int v3020_set_time(struct device *dev, struct rtc_time *dt)
     v3020_set_reg(chip, V3020_MINUTES,     BIN2BCD(dt->tm_min));
     v3020_set_reg(chip, V3020_HOURS,     BIN2BCD(dt->tm_hour));
     v3020_set_reg(chip, V3020_MONTH_DAY,    BIN2BCD(dt->tm_mday));
-    v3020_set_reg(chip, V3020_MONTH,     BIN2BCD(dt->tm_mon));
+    v3020_set_reg(chip, V3020_MONTH,     BIN2BCD(dt->tm_mon + 1));
     v3020_set_reg(chip, V3020_WEEK_DAY,     BIN2BCD(dt->tm_wday));
     v3020_set_reg(chip, V3020_YEAR,     BIN2BCD(dt->tm_year % 100));

