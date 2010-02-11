Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752811Ab0BKKwx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 05:52:53 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:48008 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752296Ab0BKKwu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 05:52:50 -0500
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: rtc-linux@googlegroups.com
Cc: Paul Gortmaker <p_gortmaker@yahoo.com>,
       Alessandro Zummo <a.zummo@towertech.it>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH RESEND] rtc/hctosys: only claim the RTC provided the system time if it did
Date: Thu, 11 Feb 2010 11:52:29 +0100
Message-Id: <1265885549-23920-1-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <1265663419-10165-1-git-send-email-u.kleine-koenig@pengutronix.de>
References: <1265663419-10165-1-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Moreover change error handling in rtc_hctosys() to use goto and so
reduce the indention level.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
Hello,

this time the patch is complete.

What do you think about it?

Best regards
Uwe

 drivers/rtc/hctosys.c   |   59 +++++++++++++++++++++++++++--------------------
 drivers/rtc/rtc-sysfs.c |    5 ++-
 include/linux/rtc.h     |    6 ++++
 3 files changed, 43 insertions(+), 27 deletions(-)

diff --git a/drivers/rtc/hctosys.c b/drivers/rtc/hctosys.c
index 33c0e98..bc90b09 100644
--- a/drivers/rtc/hctosys.c
+++ b/drivers/rtc/hctosys.c
@@ -22,48 +22,57 @@
  * the best guess is to add 0.5s.
  */
 
+int rtc_hctosys_ret = -ENODEV;
+
 static int __init rtc_hctosys(void)
 {
-	int err;
+	int err = -ENODEV;
 	struct rtc_time tm;
+	struct timespec tv = {
+		.tv_nsec = NSEC_PER_SEC >> 1,
+	};
 	struct rtc_device *rtc = rtc_class_open(CONFIG_RTC_HCTOSYS_DEVICE);
 
 	if (rtc == NULL) {
-		printk("%s: unable to open rtc device (%s)\n",
+		pr_err("%s: unable to open rtc device (%s)\n",
 			__FILE__, CONFIG_RTC_HCTOSYS_DEVICE);
-		return -ENODEV;
+		goto err_open;
 	}
 
 	err = rtc_read_time(rtc, &tm);
-	if (err == 0) {
-		err = rtc_valid_tm(&tm);
-		if (err == 0) {
-			struct timespec tv;
+	if (err) {
+		dev_err(rtc->dev.parent,
+			"hctosys: unable to read the hardware clock\n");
+		goto err_read;
 
-			tv.tv_nsec = NSEC_PER_SEC >> 1;
+	}
 
-			rtc_tm_to_time(&tm, &tv.tv_sec);
+	err = rtc_valid_tm(&tm);
+	if (err) {
+		dev_err(rtc->dev.parent,
+			"hctosys: invalid date/time\n");
+		goto err_invalid;
+	}
 
-			do_settimeofday(&tv);
+	rtc_tm_to_time(&tm, &tv.tv_sec);
 
-			dev_info(rtc->dev.parent,
-				"setting system clock to "
-				"%d-%02d-%02d %02d:%02d:%02d UTC (%u)\n",
-				tm.tm_year + 1900, tm.tm_mon + 1, tm.tm_mday,
-				tm.tm_hour, tm.tm_min, tm.tm_sec,
-				(unsigned int) tv.tv_sec);
-		}
-		else
-			dev_err(rtc->dev.parent,
-				"hctosys: invalid date/time\n");
-	}
-	else
-		dev_err(rtc->dev.parent,
-			"hctosys: unable to read the hardware clock\n");
+	do_settimeofday(&tv);
 
+	dev_info(rtc->dev.parent,
+		"setting system clock to "
+		"%d-%02d-%02d %02d:%02d:%02d UTC (%u)\n",
+		tm.tm_year + 1900, tm.tm_mon + 1, tm.tm_mday,
+		tm.tm_hour, tm.tm_min, tm.tm_sec,
+		(unsigned int) tv.tv_sec);
+
+err_invalid:
+err_read:
 	rtc_class_close(rtc);
 
-	return 0;
+err_open:
+	rtc_hctosys_ret = err;
+
+	return err;
 }
 
 late_initcall(rtc_hctosys);
diff --git a/drivers/rtc/rtc-sysfs.c b/drivers/rtc/rtc-sysfs.c
index 7dd23a6..380083c 100644
--- a/drivers/rtc/rtc-sysfs.c
+++ b/drivers/rtc/rtc-sysfs.c
@@ -107,8 +107,9 @@ rtc_sysfs_show_hctosys(struct device *dev, struct device_attribute *attr,
 		char *buf)
 {
 #ifdef CONFIG_RTC_HCTOSYS_DEVICE
-	if (strcmp(dev_name(&to_rtc_device(dev)->dev),
-		   CONFIG_RTC_HCTOSYS_DEVICE) == 0)
+	if (rtc_hctosys_ret == 0 &&
+			strcmp(dev_name(&to_rtc_device(dev)->dev),
+				CONFIG_RTC_HCTOSYS_DEVICE) == 0)
 		return sprintf(buf, "1\n");
 	else
 #endif
diff --git a/include/linux/rtc.h b/include/linux/rtc.h
index 60f88a7..14dbc83 100644
--- a/include/linux/rtc.h
+++ b/include/linux/rtc.h
@@ -238,6 +238,12 @@ static inline bool is_leap_year(unsigned int year)
 	return (!(year % 4) && (year % 100)) || !(year % 400);
 }
 
+#ifdef CONFIG_RTC_HCTOSYS
+extern int rtc_hctosys_ret;
+#else
+#define rtc_hctosys_ret -ENODEV
+#endif
+
 #endif /* __KERNEL__ */
 
 #endif /* _LINUX_RTC_H_ */
-- 
1.6.6

