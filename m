Return-Path: <linux-kernel-owner+w=401wt.eu-S1762049AbZJJRyt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762049AbZJJRyt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Oct 2009 13:54:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760300AbZJJRyr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Oct 2009 13:54:47 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:59683 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762017AbZJJRyo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Oct 2009 13:54:44 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org,
       Michael Hennerich <michael.hennerich@analog.com>
Subject: [PATCH 5/5] backlight: adp5520: rename common defines and typos
Date: Sat, 10 Oct 2009 13:54:04 -0400
Message-Id: <1255197244-20121-5-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.5.rc2
In-Reply-To: <1255197244-20121-1-git-send-email-vapier@gentoo.org>
References: <1255197244-20121-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Hennerich <michael.hennerich@analog.com>

The common adp5520 mfd defines were namespaced to avoid collisions, so
update the define used in this driver accordingly.  The structs were also
renamed to fix a spelling typo.

Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 drivers/video/backlight/adp5520_bl.c |  123 +++++++++++++++++++---------------
 1 files changed, 70 insertions(+), 53 deletions(-)

diff --git a/drivers/video/backlight/adp5520_bl.c b/drivers/video/backlight/adp5520_bl.c
index ad05da5..4c10ede 100644
--- a/drivers/video/backlight/adp5520_bl.c
+++ b/drivers/video/backlight/adp5520_bl.c
@@ -15,7 +15,7 @@
 
 struct adp5520_bl {
 	struct device *master;
-	struct adp5520_backlight_platfrom_data *pdata;
+	struct adp5520_backlight_platform_data *pdata;
 	struct mutex lock;
 	unsigned long cached_daylight_max;
 	int id;
@@ -31,29 +31,30 @@ static int adp5520_bl_set(struct backlight_device *bl, int brightness)
 	if (data->pdata->en_ambl_sens) {
 		if ((brightness > 0) && (brightness < ADP5020_MAX_BRIGHTNESS)) {
 			/* Disable Ambient Light auto adjust */
-			ret |= adp5520_clr_bits(master, BL_CONTROL,
-					BL_AUTO_ADJ);
-			ret |= adp5520_write(master, DAYLIGHT_MAX, brightness);
+			ret |= adp5520_clr_bits(master, ADP5520_BL_CONTROL,
+					ADP5520_BL_AUTO_ADJ);
+			ret |= adp5520_write(master, ADP5520_DAYLIGHT_MAX,
+					brightness);
 		} else {
 			/*
 			 * MAX_BRIGHTNESS -> Enable Ambient Light auto adjust
 			 * restore daylight l3 sysfs brightness
 			 */
-			ret |= adp5520_write(master, DAYLIGHT_MAX,
+			ret |= adp5520_write(master, ADP5520_DAYLIGHT_MAX,
 					 data->cached_daylight_max);
-			ret |= adp5520_set_bits(master, BL_CONTROL,
-					 BL_AUTO_ADJ);
+			ret |= adp5520_set_bits(master, ADP5520_BL_CONTROL,
+					 ADP5520_BL_AUTO_ADJ);
 		}
 	} else {
-		ret |= adp5520_write(master, DAYLIGHT_MAX, brightness);
+		ret |= adp5520_write(master, ADP5520_DAYLIGHT_MAX, brightness);
 	}
 
 	if (data->current_brightness && brightness == 0)
 		ret |= adp5520_set_bits(master,
-				MODE_STATUS, DIM_EN);
+				ADP5520_MODE_STATUS, ADP5520_DIM_EN);
 	else if (data->current_brightness == 0 && brightness)
 		ret |= adp5520_clr_bits(master,
-				MODE_STATUS, DIM_EN);
+				ADP5520_MODE_STATUS, ADP5520_DIM_EN);
 
 	if (!ret)
 		data->current_brightness = brightness;
@@ -79,7 +80,7 @@ static int adp5520_bl_get_brightness(struct backlight_device *bl)
 	int error;
 	uint8_t reg_val;
 
-	error = adp5520_read(data->master, BL_VALUE, &reg_val);
+	error = adp5520_read(data->master, ADP5520_BL_VALUE, &reg_val);
 
 	return error ? data->current_brightness : reg_val;
 }
@@ -93,33 +94,46 @@ static int adp5520_bl_setup(struct backlight_device *bl)
 {
 	struct adp5520_bl *data = bl_get_data(bl);
 	struct device *master = data->master;
-	struct adp5520_backlight_platfrom_data *pdata = data->pdata;
+	struct adp5520_backlight_platform_data *pdata = data->pdata;
 	int ret = 0;
 
-	ret |= adp5520_write(master, DAYLIGHT_MAX, pdata->l1_daylight_max);
-	ret |= adp5520_write(master, DAYLIGHT_DIM, pdata->l1_daylight_dim);
+	ret |= adp5520_write(master, ADP5520_DAYLIGHT_MAX,
+				pdata->l1_daylight_max);
+	ret |= adp5520_write(master, ADP5520_DAYLIGHT_DIM,
+				pdata->l1_daylight_dim);
 
 	if (pdata->en_ambl_sens) {
 		data->cached_daylight_max = pdata->l1_daylight_max;
-		ret |= adp5520_write(master, OFFICE_MAX, pdata->l2_office_max);
-		ret |= adp5520_write(master, OFFICE_DIM, pdata->l2_office_dim);
-		ret |= adp5520_write(master, DARK_MAX, pdata->l3_dark_max);
-		ret |= adp5520_write(master, DARK_DIM, pdata->l3_dark_dim);
-		ret |= adp5520_write(master, L2_TRIP, pdata->l2_trip);
-		ret |= adp5520_write(master, L2_HYS, pdata->l2_hyst);
-		ret |= adp5520_write(master, L3_TRIP, pdata->l3_trip);
-		ret |= adp5520_write(master, L3_HYS, pdata->l3_hyst);
-		ret |= adp5520_write(master, ALS_CMPR_CFG,
-			ALS_CMPR_CFG_VAL(pdata->abml_filt, L3_EN));
+		ret |= adp5520_write(master, ADP5520_OFFICE_MAX,
+				pdata->l2_office_max);
+		ret |= adp5520_write(master, ADP5520_OFFICE_DIM,
+				pdata->l2_office_dim);
+		ret |= adp5520_write(master, ADP5520_DARK_MAX,
+				pdata->l3_dark_max);
+		ret |= adp5520_write(master, ADP5520_DARK_DIM,
+				pdata->l3_dark_dim);
+		ret |= adp5520_write(master, ADP5520_L2_TRIP,
+				pdata->l2_trip);
+		ret |= adp5520_write(master, ADP5520_L2_HYS,
+				pdata->l2_hyst);
+		ret |= adp5520_write(master, ADP5520_L3_TRIP,
+				 pdata->l3_trip);
+		ret |= adp5520_write(master, ADP5520_L3_HYS,
+				pdata->l3_hyst);
+		ret |= adp5520_write(master, ADP5520_ALS_CMPR_CFG,
+				ALS_CMPR_CFG_VAL(pdata->abml_filt,
+				ADP5520_L3_EN));
 	}
 
-	ret |= adp5520_write(master, BL_CONTROL,
-			BL_CTRL_VAL(pdata->fade_led_law, pdata->en_ambl_sens));
+	ret |= adp5520_write(master, ADP5520_BL_CONTROL,
+			BL_CTRL_VAL(pdata->fade_led_law,
+					pdata->en_ambl_sens));
 
-	ret |= adp5520_write(master, BL_FADE, FADE_VAL(pdata->fade_in,
+	ret |= adp5520_write(master, ADP5520_BL_FADE, FADE_VAL(pdata->fade_in,
 			pdata->fade_out));
 
-	ret |= adp5520_set_bits(master, MODE_STATUS, BL_EN | DIM_EN);
+	ret |= adp5520_set_bits(master, ADP5520_MODE_STATUS,
+			ADP5520_BL_EN | ADP5520_DIM_EN);
 
 	return ret;
 }
@@ -156,29 +170,31 @@ static ssize_t adp5520_store(struct device *dev, const char *buf,
 }
 
 static ssize_t adp5520_bl_dark_max_show(struct device *dev,
-		struct device_attribute *attr, char *buf)
+			struct device_attribute *attr, char *buf)
 {
-	return adp5520_show(dev, buf, DARK_MAX);
+	return adp5520_show(dev, buf, ADP5520_DARK_MAX);
 }
 
 static ssize_t adp5520_bl_dark_max_store(struct device *dev,
-		struct device_attribute *attr, const char *buf, size_t count)
+			struct device_attribute *attr,
+			const char *buf, size_t count)
 {
-	return adp5520_store(dev, buf, count, DARK_MAX);
+	return adp5520_store(dev, buf, count, ADP5520_DARK_MAX);
 }
 static DEVICE_ATTR(dark_max, 0664, adp5520_bl_dark_max_show,
 			adp5520_bl_dark_max_store);
 
 static ssize_t adp5520_bl_office_max_show(struct device *dev,
-				     struct device_attribute *attr, char *buf)
+			struct device_attribute *attr, char *buf)
 {
-	return adp5520_show(dev, buf, OFFICE_MAX);
+	return adp5520_show(dev, buf, ADP5520_OFFICE_MAX);
 }
 
 static ssize_t adp5520_bl_office_max_store(struct device *dev,
-		struct device_attribute *attr, const char *buf, size_t count)
+			struct device_attribute *attr,
+			const char *buf, size_t count)
 {
-	return adp5520_store(dev, buf, count, OFFICE_MAX);
+	return adp5520_store(dev, buf, count, ADP5520_OFFICE_MAX);
 }
 static DEVICE_ATTR(office_max, 0664, adp5520_bl_office_max_show,
 			adp5520_bl_office_max_store);
@@ -186,16 +202,17 @@ static DEVICE_ATTR(office_max, 0664, adp5520_bl_office_max_show,
 static ssize_t adp5520_bl_daylight_max_show(struct device *dev,
 			struct device_attribute *attr, char *buf)
 {
-	return adp5520_show(dev, buf, DAYLIGHT_MAX);
+	return adp5520_show(dev, buf, ADP5520_DAYLIGHT_MAX);
 }
 
 static ssize_t adp5520_bl_daylight_max_store(struct device *dev,
-		struct device_attribute *attr, const char *buf, size_t count)
+			struct device_attribute *attr,
+			const char *buf, size_t count)
 {
 	struct adp5520_bl *data = dev_get_drvdata(dev);
 
 	strict_strtoul(buf, 10, &data->cached_daylight_max);
-	return adp5520_store(dev, buf, count, DAYLIGHT_MAX);
+	return adp5520_store(dev, buf, count, ADP5520_DAYLIGHT_MAX);
 }
 static DEVICE_ATTR(daylight_max, 0664, adp5520_bl_daylight_max_show,
 			adp5520_bl_daylight_max_store);
@@ -203,14 +220,14 @@ static DEVICE_ATTR(daylight_max, 0664, adp5520_bl_daylight_max_show,
 static ssize_t adp5520_bl_dark_dim_show(struct device *dev,
 			struct device_attribute *attr, char *buf)
 {
-	return adp5520_show(dev, buf, DARK_DIM);
+	return adp5520_show(dev, buf, ADP5520_DARK_DIM);
 }
 
 static ssize_t adp5520_bl_dark_dim_store(struct device *dev,
-				     struct device_attribute *attr,
-				     const char *buf, size_t count)
+			struct device_attribute *attr,
+			const char *buf, size_t count)
 {
-	return adp5520_store(dev, buf, count, DARK_DIM);
+	return adp5520_store(dev, buf, count, ADP5520_DARK_DIM);
 }
 static DEVICE_ATTR(dark_dim, 0664, adp5520_bl_dark_dim_show,
 			adp5520_bl_dark_dim_store);
@@ -218,29 +235,29 @@ static DEVICE_ATTR(dark_dim, 0664, adp5520_bl_dark_dim_show,
 static ssize_t adp5520_bl_office_dim_show(struct device *dev,
 			struct device_attribute *attr, char *buf)
 {
-	return adp5520_show(dev, buf, OFFICE_DIM);
+	return adp5520_show(dev, buf, ADP5520_OFFICE_DIM);
 }
 
 static ssize_t adp5520_bl_office_dim_store(struct device *dev,
-				     struct device_attribute *attr,
-				     const char *buf, size_t count)
+			struct device_attribute *attr,
+			const char *buf, size_t count)
 {
-	return adp5520_store(dev, buf, count, OFFICE_DIM);
+	return adp5520_store(dev, buf, count, ADP5520_OFFICE_DIM);
 }
 static DEVICE_ATTR(office_dim, 0664, adp5520_bl_office_dim_show,
 			adp5520_bl_office_dim_store);
 
 static ssize_t adp5520_bl_daylight_dim_show(struct device *dev,
-				     struct device_attribute *attr, char *buf)
+			struct device_attribute *attr, char *buf)
 {
-	return adp5520_show(dev, buf, DAYLIGHT_DIM);
+	return adp5520_show(dev, buf, ADP5520_DAYLIGHT_DIM);
 }
 
 static ssize_t adp5520_bl_daylight_dim_store(struct device *dev,
-				     struct device_attribute *attr,
-				     const char *buf, size_t count)
+			struct device_attribute *attr,
+			const char *buf, size_t count)
 {
-	return adp5520_store(dev, buf, count, DAYLIGHT_DIM);
+	return adp5520_store(dev, buf, count, ADP5520_DAYLIGHT_DIM);
 }
 static DEVICE_ATTR(daylight_dim, 0664, adp5520_bl_daylight_dim_show,
 			adp5520_bl_daylight_dim_store);
@@ -316,7 +333,7 @@ static int __devexit adp5520_bl_remove(struct platform_device *pdev)
 	struct backlight_device *bl = platform_get_drvdata(pdev);
 	struct adp5520_bl *data = bl_get_data(bl);
 
-	adp5520_clr_bits(data->master, MODE_STATUS, BL_EN);
+	adp5520_clr_bits(data->master, ADP5520_MODE_STATUS, ADP5520_BL_EN);
 
 	if (data->pdata->en_ambl_sens)
 		sysfs_remove_group(&bl->dev.kobj,
-- 
1.6.5.rc2

