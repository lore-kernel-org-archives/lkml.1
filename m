Return-Path: <linux-kernel-owner+w=401wt.eu-S1757674AbXH2Raj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757674AbXH2Raj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 13:30:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753597AbXH2RaZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 13:30:25 -0400
Received: from mx01.qsc.de ([213.148.129.14]:46009 "EHLO mx01.qsc.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757198AbXH2RaL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 13:30:11 -0400
X-Greylist: delayed 1378 seconds by postgrey-1.27 at vger.kernel.org; Wed, 29 Aug 2007 13:30:10 EDT
From: =?iso-8859-1?q?Ren=E9_Rebe?= <rene@exactcode.de>
Organization: ExactCODE
To: Nicolas Boichat <nicolas@boichat.ch>
Subject: [PATCH] applesmc for Mac Pro 2 x Quad-Core
Date: Wed, 29 Aug 2007 19:06:47 +0200
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200708291906.47991.rene@exactcode.de>
X-Spam-Score: -4.1 (----)
X-Spam-Report: Spam detection software, running on the system "exactcode.de", has
	identified this incoming email as possible spam.  The original message
	has been attached to this so you can view it (if it isn't spam) or label
	similar future email.  If you have any questions, see
	the administrator of that system for details.
	Content preview:  Hi all, at least the 2x Quad-Core Apple Mac Pro appears to
	have some over-heat protection which suddenly powers off the whole box under
	load. This adds support for the fans and temerature sensors in the Mac Pro
	- later some "windwarm" a-like code should probably monitor the values. For
	now manually tweaking the fans prevents the sudden shutdown for me. [...]
	Content analysis details:   (-4.1 points, 5.0 required)
	pts rule name              description
	---- ---------------------- --------------------------------------------------
	-1.5 ALL_TRUSTED            Passed through trusted hosts only via SMTP
	-2.6 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

at least the 2x Quad-Core Apple Mac Pro appears to have some over-heat
protection which suddenly powers off the whole box under load. This
adds support for the fans and temerature sensors in the Mac Pro - later
some "windwarm" a-like code should probably monitor the values. For now
manually tweaking the fans prevents the sudden shutdown for me.

cd /sys/devices/platform/applesmc.768
for x in fan{1,2,3,4}; do
	echo 1 > ${x}_manual
	echo 1285 > ${x}_output
done

Two sensors are 0, while four are 129 °C, those might be removed again,
later.

Signed-off-by: René Rebe <rene@exactcode.de>

--- linux-2.6.22/drivers/hwmon/applesmc.c	2007-08-29 18:38:56.000000000 +0200
+++ linux-2.6.22.5-dist-applesmc/drivers/hwmon/applesmc.c	2007-08-29 18:04:34.000000000 +0200
@@ -101,7 +101,7 @@
 /*
  * Temperature sensors keys (sp78 - 2 bytes).
  */
-static const char* temperature_sensors_sets[][13] = {
+static const char* temperature_sensors_sets[][36] = {
 /* Set 0: Macbook Pro */
 	{ "TA0P", "TB0T", "TC0D", "TC0P", "TG0H", "TG0P", "TG0T", "Th0H",
 	  "Th1H", "Tm0P", "Ts0P", "Ts1P", NULL },
@@ -109,7 +109,13 @@
 	{ "TB0T", "TC0D", "TC0P", "TM0P", "TN0P", "TN1P", "Th0H", "Th0S",
 	  "Th1H", "Ts0P", NULL },
 /* Set 2: Macmini set */
-	{ "TC0D", "TC0P", NULL }
+	{ "TC0D", "TC0P", NULL },
+/* Set 3: Mac Pro (2 x Quad-Core) */
+	{ "TA0P", "TCAG", "TCAH", "TCBG", "TCBH", "TC0C", "TC0D", "TC0P",
+	  "TC1C", "TC1D", "TC2C", "TC2D", "TC3C", "TC3D", "THTG", "TH0P",
+	  "TH1P", "TH2P", "TH3P", "TMAP", "TMAS", "TMBS", "TM0P", "TM0S",
+	  "TM1P", "TM1S", "TM2P", "TM2S", "TM3S", "TM8P", "TM8S", "TM9P",
+	  "TM9S", "TN0H", "TS0C", NULL },
 };
 
 /* List of keys used to read/write fan speeds */
@@ -1265,14 +1271,18 @@
 
 /*
  * Create the needed functions for each fan using the macro defined above
- * (2 fans are supported)
+ * (4 fans are supported)
  */
 sysfs_fan_speeds_offset(1);
 sysfs_fan_speeds_offset(2);
+sysfs_fan_speeds_offset(3);
+sysfs_fan_speeds_offset(4);
 
 static const struct attribute_group fan_attribute_groups[] = {
 	{ .attrs = fan1_attributes },
-	{ .attrs = fan2_attributes }
+	{ .attrs = fan2_attributes },
+	{ .attrs = fan3_attributes },
+	{ .attrs = fan4_attributes }
 };
 
 /*
@@ -1302,6 +1312,52 @@
 					applesmc_show_temperature, NULL, 10);
 static SENSOR_DEVICE_ATTR(temp12_input, S_IRUGO,
 					applesmc_show_temperature, NULL, 11);
+static SENSOR_DEVICE_ATTR(temp13_input, S_IRUGO,
+					applesmc_show_temperature, NULL, 12);
+static SENSOR_DEVICE_ATTR(temp14_input, S_IRUGO,
+					applesmc_show_temperature, NULL, 13);
+static SENSOR_DEVICE_ATTR(temp15_input, S_IRUGO,
+					applesmc_show_temperature, NULL, 14);
+static SENSOR_DEVICE_ATTR(temp16_input, S_IRUGO,
+					applesmc_show_temperature, NULL, 15);
+static SENSOR_DEVICE_ATTR(temp17_input, S_IRUGO,
+					applesmc_show_temperature, NULL, 16);
+static SENSOR_DEVICE_ATTR(temp18_input, S_IRUGO,
+					applesmc_show_temperature, NULL, 17);
+static SENSOR_DEVICE_ATTR(temp19_input, S_IRUGO,
+					applesmc_show_temperature, NULL, 18);
+static SENSOR_DEVICE_ATTR(temp20_input, S_IRUGO,
+					applesmc_show_temperature, NULL, 19);
+static SENSOR_DEVICE_ATTR(temp21_input, S_IRUGO,
+					applesmc_show_temperature, NULL, 20);
+static SENSOR_DEVICE_ATTR(temp22_input, S_IRUGO,
+					applesmc_show_temperature, NULL, 21);
+static SENSOR_DEVICE_ATTR(temp23_input, S_IRUGO,
+					applesmc_show_temperature, NULL, 22);
+static SENSOR_DEVICE_ATTR(temp24_input, S_IRUGO,
+					applesmc_show_temperature, NULL, 23);
+static SENSOR_DEVICE_ATTR(temp25_input, S_IRUGO,
+					applesmc_show_temperature, NULL, 24);
+static SENSOR_DEVICE_ATTR(temp26_input, S_IRUGO,
+					applesmc_show_temperature, NULL, 25);
+static SENSOR_DEVICE_ATTR(temp27_input, S_IRUGO,
+					applesmc_show_temperature, NULL, 26);
+static SENSOR_DEVICE_ATTR(temp28_input, S_IRUGO,
+					applesmc_show_temperature, NULL, 27);
+static SENSOR_DEVICE_ATTR(temp29_input, S_IRUGO,
+					applesmc_show_temperature, NULL, 28);
+static SENSOR_DEVICE_ATTR(temp30_input, S_IRUGO,
+					applesmc_show_temperature, NULL, 29);
+static SENSOR_DEVICE_ATTR(temp31_input, S_IRUGO,
+					applesmc_show_temperature, NULL, 30);
+static SENSOR_DEVICE_ATTR(temp32_input, S_IRUGO,
+					applesmc_show_temperature, NULL, 31);
+static SENSOR_DEVICE_ATTR(temp33_input, S_IRUGO,
+					applesmc_show_temperature, NULL, 32);
+static SENSOR_DEVICE_ATTR(temp34_input, S_IRUGO,
+					applesmc_show_temperature, NULL, 33);
+static SENSOR_DEVICE_ATTR(temp35_input, S_IRUGO,
+					applesmc_show_temperature, NULL, 34);
 
 static struct attribute *temperature_attributes[] = {
 	&sensor_dev_attr_temp1_input.dev_attr.attr,
@@ -1316,6 +1372,29 @@
 	&sensor_dev_attr_temp10_input.dev_attr.attr,
 	&sensor_dev_attr_temp11_input.dev_attr.attr,
 	&sensor_dev_attr_temp12_input.dev_attr.attr,
+	&sensor_dev_attr_temp13_input.dev_attr.attr,
+	&sensor_dev_attr_temp14_input.dev_attr.attr,
+	&sensor_dev_attr_temp15_input.dev_attr.attr,
+	&sensor_dev_attr_temp16_input.dev_attr.attr,
+	&sensor_dev_attr_temp17_input.dev_attr.attr,
+	&sensor_dev_attr_temp18_input.dev_attr.attr,
+	&sensor_dev_attr_temp19_input.dev_attr.attr,
+	&sensor_dev_attr_temp20_input.dev_attr.attr,
+	&sensor_dev_attr_temp21_input.dev_attr.attr,
+	&sensor_dev_attr_temp22_input.dev_attr.attr,
+	&sensor_dev_attr_temp23_input.dev_attr.attr,
+	&sensor_dev_attr_temp24_input.dev_attr.attr,
+	&sensor_dev_attr_temp25_input.dev_attr.attr,
+	&sensor_dev_attr_temp26_input.dev_attr.attr,
+	&sensor_dev_attr_temp27_input.dev_attr.attr,
+	&sensor_dev_attr_temp28_input.dev_attr.attr,
+	&sensor_dev_attr_temp29_input.dev_attr.attr,
+	&sensor_dev_attr_temp30_input.dev_attr.attr,
+	&sensor_dev_attr_temp31_input.dev_attr.attr,
+	&sensor_dev_attr_temp32_input.dev_attr.attr,
+	&sensor_dev_attr_temp33_input.dev_attr.attr,
+	&sensor_dev_attr_temp34_input.dev_attr.attr,
+	&sensor_dev_attr_temp35_input.dev_attr.attr,
 	NULL
 };
 
@@ -1412,6 +1491,8 @@
 	{ .accelerometer = 1, .light = 0, .temperature_set = 1 },
 /* MacMini: temperature set 2 */
 	{ .accelerometer = 0, .light = 0, .temperature_set = 2 },
+/* MacPro: temperature set 3 */
+	{ .accelerometer = 0, .light = 0, .temperature_set = 3 },
 };
 
 /* Note that DMI_MATCH(...,"MacBook") will match "MacBookPro1,1".
@@ -1429,6 +1510,10 @@
 	  DMI_MATCH(DMI_BOARD_VENDOR,"Apple"),
 	  DMI_MATCH(DMI_PRODUCT_NAME,"Macmini") },
 		(void*)&applesmc_dmi_data[2]},
+	{ applesmc_dmi_match, "Apple MacPro2", {
+	  DMI_MATCH(DMI_BOARD_VENDOR,"Apple"),
+	  DMI_MATCH(DMI_PRODUCT_NAME,"MacPro2") },
+		(void*)&applesmc_dmi_data[3]},
 	{ .ident = NULL }
 };
 
@@ -1479,9 +1564,19 @@
 
 		switch (count) {
 		default:
-			printk(KERN_WARNING "applesmc: More than 2 fans found,"
-					" but at most 2 fans are supported"
+			printk(KERN_WARNING "applesmc: More than 4 fans found,"
+					" but at most 4 fans are supported"
 						" by the driver.\n");
+		case 4:
+			ret = sysfs_create_group(&pdev->dev.kobj,
+						 &fan_attribute_groups[3]);
+			if (ret)
+				goto out_key_enumeration;
+		case 3:
+			ret = sysfs_create_group(&pdev->dev.kobj,
+						 &fan_attribute_groups[2]);
+			if (ret)
+				goto out_key_enumeration;
 		case 2:
 			ret = sysfs_create_group(&pdev->dev.kobj,
 						 &fan_attribute_groups[1]);


-- 
  René Rebe - ExactCODE GmbH - Europe, Germany, Berlin
  Geschäftsführer: Susanne Klaus, René Rebe
  Sitz: Berlin, Amtsgericht Charlottenburg HRB 105 123 B
  USt-IdNr.: DE251602478
  http://exactcode.de | http://t2-project.org | http://rene.rebe.name
