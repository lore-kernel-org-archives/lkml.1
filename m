Return-Path: <linux-kernel-owner+w=401wt.eu-S1757626AbZBLH4j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757626AbZBLH4j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 02:56:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757019AbZBLH4X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 02:56:23 -0500
Received: from mail-fx0-f20.google.com ([209.85.220.20]:54892 "EHLO
	mail-fx0-f20.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756819AbZBLH4V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 02:56:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=TDUvB6RgY9o2/9IT10OqGRPFo5W6CwlGBOn6mvKccaaJiu5A1sUnHyyDV2YbfroQxV
         OM/ydBgsremFs0k1KmNllrKPHj3qMsO36xG/Rv5hOX2K57PmfNb5j33P+X5DcYNyAvCv
         H/WfcNtywRSZSnRo1SuAqpxhyAnpezCGWgFT4=
From: Giuseppe Bilotta <giuseppe.bilotta@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: =?utf-8?q?=C3=89ric=20Piel?= <eric.piel@tremplin-utc.net>,
       Pavel Machek <pavel@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
       Palatis Tseng <palatis@gmail.com>,
       Giuseppe Bilotta <giuseppe.bilotta@gmail.com>
Subject: [PATCHv2] lis3lv02d: add axes knowledge of HP Pavilion dv5 models
Date: Thu, 12 Feb 2009 08:56:15 +0100
Message-Id: <1234425375-6545-1-git-send-email-giuseppe.bilotta@gmail.com>
X-Mailer: git-send-email 1.6.2.rc0.173.g5e148
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for HP Pavilion dv5.

Since Intel-based models have an inverted x axis, while AMD-based models
have an inverted y axis, we introduce a new macro that special-cases
axis orientation based on two DMI entries: HP dv5 axis configuration is
then based on both the PRODUCT and BOARD name.

Signed-off-by: Giuseppe Bilotta <giuseppe.bilotta@gmail.com>
---

This is a replacement for the
lis3lv02d-add-axes-knowledge-of-hp-pavilion-dv5-models.patch currently
on -mm.

Palatis Tseng confirmed that this fixes the sensor orientation for him, too.

 drivers/hwmon/hp_accel.c |   22 ++++++++++++++++++++++
 1 files changed, 22 insertions(+), 0 deletions(-)

diff --git a/drivers/hwmon/hp_accel.c b/drivers/hwmon/hp_accel.c
index e2970ff..958018e 100644
--- a/drivers/hwmon/hp_accel.c
+++ b/drivers/hwmon/hp_accel.c
@@ -166,6 +166,18 @@ static struct axis_conversion lis3lv02d_axis_xy_swap_yz_inverted = {2, -1, -3};
 	},						\
 	.driver_data = &lis3lv02d_axis_##_axis		\
 }
+
+#define AXIS_DMI_MATCH2(_ident, _class1, _name1,	\
+				_class2, _name2,	\
+				_axis) {		\
+	.ident = _ident,				\
+	.callback = lis3lv02d_dmi_matched,		\
+	.matches = {					\
+		DMI_MATCH(DMI_##_class1, _name1),	\
+		DMI_MATCH(DMI_##_class2, _name2),	\
+	},						\
+	.driver_data = &lis3lv02d_axis_##_axis		\
+}
 static struct dmi_system_id lis3lv02d_dmi_ids[] = {
 	/* product names are truncated to match all kinds of a same model */
 	AXIS_DMI_MATCH("NC64x0", "HP Compaq nc64", x_inverted),
@@ -179,6 +191,16 @@ static struct dmi_system_id lis3lv02d_dmi_ids[] = {
 	AXIS_DMI_MATCH("NC673x", "HP Compaq 673", xy_rotated_left_usd),
 	AXIS_DMI_MATCH("NC651xx", "HP Compaq 651", xy_rotated_right),
 	AXIS_DMI_MATCH("NC671xx", "HP Compaq 671", xy_swap_yz_inverted),
+	/* Intel-based HP Pavilion dv5 */
+	AXIS_DMI_MATCH2("HPDV5_I",
+			PRODUCT_NAME, "HP Pavilion dv5",
+			BOARD_NAME, "3603",
+			x_inverted),
+	/* AMD-based HP Pavilion dv5 */
+	AXIS_DMI_MATCH2("HPDV5_A",
+			PRODUCT_NAME, "HP Pavilion dv5",
+			BOARD_NAME, "3600",
+			y_inverted),
 	{ NULL, }
 /* Laptop models without axis info (yet):
  * "NC6910" "HP Compaq 6910"
-- 
1.6.2.rc0.173.g5e148

