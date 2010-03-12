Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933297Ab0CLRKp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 12:10:45 -0500
Received: from p01c11o145.mxlogic.net ([208.65.144.68]:58303 "EHLO
	p01c11o145.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932245Ab0CLRKo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 12:10:44 -0500
X-MXL-Hash: 4b9a75940f1274fd-58112c0be9c4964425b5bc08cf7ee3a0b22d4f11
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
CC: "rpurdie@rpsys.net" <rpurdie@rpsys.net>
Date: Fri, 12 Mar 2010 11:10:35 -0600
Subject: [PATCH] backlight: provide sysfs percent brightness attribute
Thread-Topic: [PATCH] backlight: provide sysfs percent brightness attribute
Thread-Index: AcrCBu4QelPBanz1SO+YLv+P4Kcx0Q==
Message-ID: <0D753D10438DA54287A00B02708426976368437C8D@AUSP01VMBX24.collaborationhost.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-Spam: [F=0.2000000000; CM=0.500; S=0.200(2010030401)]
X-MAIL-FROM: <hartleys@visionengravers.com>
X-SOURCE-IP: [(unknown)]
X-AnalysisOut: [v=1.0 c=1 a=BuG6rG04yhgA:10 a=VphdPIyG4kEA:10 a=IkcTkHD0fZ]
X-AnalysisOut: [MA:10 a=TYbMNos9eHUa9bm6/o8foQ==:17 a=i00gxMtYAAAA:8 a=-sM]
X-AnalysisOut: [3sDvmAAAA:8 a=zUgfCeZ8dgXclGF-qp0A:9 a=0WAFTzg72vq3bftNfN4]
X-AnalysisOut: [8IZMY-_8A:4 a=QEXdDO2ut3YA:10 a=x1WnkoZAwusA:10 a=130E6OD_]
X-AnalysisOut: [8ZAA:10]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id o2CHB0mE011818

It's usually more convenient to set the backlight brightness
as a 'percent' of total brightness rather than using the raw
'brightness' value.

This provides the necessary sysfs attributes to handle this.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Richard Purdie <rpurdie@rpsys.net>

---

diff --git a/drivers/video/backlight/backlight.c b/drivers/video/backlight/backlight.c
index 18829cf..af25bfa 100644
--- a/drivers/video/backlight/backlight.c
+++ b/drivers/video/backlight/backlight.c
@@ -190,6 +190,50 @@ static ssize_t backlight_show_actual_brightness(struct device *dev,
 	return rc;
 }
 
+static ssize_t backlight_show_percent(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct backlight_device *bd = to_backlight_device(dev);
+	int percent;
+
+	percent = bd->props.brightness * 100 / bd->props.max_brightness;
+	return sprintf(buf, "%d\n", percent);
+}
+
+static ssize_t backlight_store_percent(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t count)
+{
+	struct backlight_device *bd = to_backlight_device(dev);
+	unsigned long percent, brightness;
+	int rc;
+
+	rc = strict_strtoul(buf, 0, &percent);
+	if (rc)
+		return rc;
+
+	brightness = percent * bd->props.max_brightness / 100;
+
+	rc = -ENXIO;
+
+	mutex_lock(&bd->ops_lock);
+	if (bd->ops) {
+		if (brightness > bd->props.max_brightness)
+			rc = -EINVAL;
+		else {
+			pr_debug("backlight: set to %lu%% (brightness of %lu)\n",
+				 percent, brightness);
+			bd->props.brightness = brightness;
+			backlight_update_status(bd);
+			rc = count;
+		}
+	}
+	mutex_unlock(&bd->ops_lock);
+
+	backlight_generate_event(bd, BACKLIGHT_UPDATE_SYSFS);
+
+	return rc;
+}
+
 static struct class *backlight_class;
 
 static int backlight_suspend(struct device *dev, pm_message_t state)
@@ -233,6 +277,7 @@ static struct device_attribute bl_device_attributes[] = {
 	__ATTR(actual_brightness, 0444, backlight_show_actual_brightness,
 		     NULL),
 	__ATTR(max_brightness, 0444, backlight_show_max_brightness, NULL),
+	__ATTR(percent, 0644, backlight_show_percent, backlight_store_percent),
 	__ATTR_NULL,
 };
 
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
