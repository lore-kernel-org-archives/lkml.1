Return-Path: <linux-kernel-owner+w=401wt.eu-S1758053AbZBMMnc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758053AbZBMMnc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 07:43:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752266AbZBMMnY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 07:43:24 -0500
Received: from mx1.suse.de ([195.135.220.2]:35413 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752138AbZBMMnX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 07:43:23 -0500
Message-ID: <499569A9.5030202@suse.de>
Date: Fri, 13 Feb 2009 13:38:01 +0100
From: Frank Seidel <fseidel@suse.de>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: linux kernel <linux-kernel@vger.kernel.org>
Cc: akpm@linux-foundation.org, rlove@rlove.org,
       Jean Delvare <khali@linux-fr.org>, protasnb@gmail.com,
       Michael Ruoss <miruoss@student.ethz.ch>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Tim Gardner <tim.gardner@canonical.com>, Frank Seidel <fseidel@suse.de>,
       Frank Seidel <frank@f-seidel.de>
Subject: [PATCH] hwmon/hdaps: Fix bug 7154 inversion of separate axis
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Frank Seidel <frank@f-seidel.de>

Fix for kernel.org bug #7154:hdaps inversion of
each axis. This version is based on the work
from Michael Ruoss <miruoss@student.ethz.ch>.

Signed-off-by: Frank Seidel <frank@f-seidel.de>
---
 drivers/hwmon/hdaps.c |   49 ++++++++++++++++++++++++++++---------------------
 1 file changed, 28 insertions(+), 21 deletions(-)

--- a/drivers/hwmon/hdaps.c
+++ b/drivers/hwmon/hdaps.c
@@ -65,6 +65,10 @@
 #define HDAPS_INPUT_FUZZ	4	/* input event threshold */
 #define HDAPS_INPUT_FLAT	4
 
+#define HDAPS_X_AXIS		1UL
+#define HDAPS_Y_AXIS		2UL
+#define HDAPS_BOTH_AXES		3UL
+
 static struct platform_device *pdev;
 static struct input_polled_dev *hdaps_idev;
 static unsigned int hdaps_invert;
@@ -182,11 +186,11 @@ static int __hdaps_read_pair(unsigned in
 	km_activity = inb(HDAPS_PORT_KMACT);
 	__device_complete();
 
-	/* if hdaps_invert is set, negate the two values */
-	if (hdaps_invert) {
+	/* hdaps_invert is a bitvector to negate the axes */
+	if (hdaps_invert & 1)
 		*x = -*x;
+	if (hdaps_invert & 2)
 		*y = -*y;
-	}
 
 	return 0;
 }
@@ -436,7 +440,7 @@ static ssize_t hdaps_invert_store(struct
 {
 	int invert;
 
-	if (sscanf(buf, "%d", &invert) != 1 || (invert != 1 && invert != 0))
+	if (sscanf(buf, "%d", &invert) != 1 || invert < 0 || invert > 3)
 		return -EINVAL;
 
 	hdaps_invert = invert;
@@ -483,7 +487,7 @@ static int __init hdaps_dmi_match(const
 /* hdaps_dmi_match_invert - found an inverted match. */
 static int __init hdaps_dmi_match_invert(const struct dmi_system_id *id)
 {
-	hdaps_invert = 1;
+	hdaps_invert = (int)id->driver_data;
 	printk(KERN_INFO "hdaps: inverting axis readings.\n");
 	return hdaps_dmi_match(id);
 }
@@ -491,15 +495,17 @@ static int __init hdaps_dmi_match_invert
 #define HDAPS_DMI_MATCH_NORMAL(vendor, model) {		\
 	.ident = vendor " " model,			\
 	.callback = hdaps_dmi_match,			\
+	.driver_data = (void *)0UL,			\
 	.matches = {					\
 		DMI_MATCH(DMI_BOARD_VENDOR, vendor),	\
 		DMI_MATCH(DMI_PRODUCT_VERSION, model)	\
 	}						\
 }
 
-#define HDAPS_DMI_MATCH_INVERT(vendor, model) {		\
+#define HDAPS_DMI_MATCH_INVERT(vendor, model, axes) {	\
 	.ident = vendor " " model,			\
 	.callback = hdaps_dmi_match_invert,		\
+	.driver_data = (void *)axes,			\
 	.matches = {					\
 		DMI_MATCH(DMI_BOARD_VENDOR, vendor),	\
 		DMI_MATCH(DMI_PRODUCT_VERSION, model)	\
@@ -511,28 +517,28 @@ static int __init hdaps_dmi_match_invert
    If your ThinkPad is not recognized, please update to latest
    BIOS. This is especially the case for some R52 ThinkPads. */
 static struct dmi_system_id __initdata hdaps_whitelist[] = {
-	HDAPS_DMI_MATCH_INVERT("IBM", "ThinkPad R50p"),
+	HDAPS_DMI_MATCH_INVERT("IBM", "ThinkPad R50p", HDAPS_BOTH_AXES),
 	HDAPS_DMI_MATCH_NORMAL("IBM", "ThinkPad R50"),
 	HDAPS_DMI_MATCH_NORMAL("IBM", "ThinkPad R51"),
 	HDAPS_DMI_MATCH_NORMAL("IBM", "ThinkPad R52"),
-	HDAPS_DMI_MATCH_INVERT("LENOVO", "ThinkPad R61i"),
-	HDAPS_DMI_MATCH_INVERT("LENOVO", "ThinkPad R61"),
-	HDAPS_DMI_MATCH_INVERT("IBM", "ThinkPad T41p"),
+	HDAPS_DMI_MATCH_INVERT("LENOVO", "ThinkPad R61i", HDAPS_BOTH_AXES),
+	HDAPS_DMI_MATCH_INVERT("LENOVO", "ThinkPad R61", HDAPS_BOTH_AXES),
+	HDAPS_DMI_MATCH_INVERT("IBM", "ThinkPad T41p", HDAPS_BOTH_AXES),
 	HDAPS_DMI_MATCH_NORMAL("IBM", "ThinkPad T41"),
-	HDAPS_DMI_MATCH_INVERT("IBM", "ThinkPad T42p"),
+	HDAPS_DMI_MATCH_INVERT("IBM", "ThinkPad T42p", HDAPS_BOTH_AXES),
 	HDAPS_DMI_MATCH_NORMAL("IBM", "ThinkPad T42"),
 	HDAPS_DMI_MATCH_NORMAL("IBM", "ThinkPad T43"),
-	HDAPS_DMI_MATCH_INVERT("LENOVO", "ThinkPad T60"),
-	HDAPS_DMI_MATCH_INVERT("LENOVO", "ThinkPad T61p"),
-	HDAPS_DMI_MATCH_INVERT("LENOVO", "ThinkPad T61"),
+	HDAPS_DMI_MATCH_INVERT("LENOVO", "ThinkPad T60", HDAPS_BOTH_AXES),
+	HDAPS_DMI_MATCH_INVERT("LENOVO", "ThinkPad T61p", HDAPS_BOTH_AXES),
+	HDAPS_DMI_MATCH_INVERT("LENOVO", "ThinkPad T61", HDAPS_BOTH_AXES),
 	HDAPS_DMI_MATCH_NORMAL("IBM", "ThinkPad X40"),
 	HDAPS_DMI_MATCH_NORMAL("IBM", "ThinkPad X41"),
-	HDAPS_DMI_MATCH_INVERT("LENOVO", "ThinkPad X60"),
-	HDAPS_DMI_MATCH_INVERT("LENOVO", "ThinkPad X61s"),
-	HDAPS_DMI_MATCH_INVERT("LENOVO", "ThinkPad X61"),
+	HDAPS_DMI_MATCH_INVERT("LENOVO", "ThinkPad X60", HDAPS_BOTH_AXES),
+	HDAPS_DMI_MATCH_INVERT("LENOVO", "ThinkPad X61s", HDAPS_BOTH_AXES),
+	HDAPS_DMI_MATCH_INVERT("LENOVO", "ThinkPad X61", HDAPS_BOTH_AXES),
 	HDAPS_DMI_MATCH_NORMAL("IBM", "ThinkPad Z60m"),
-	HDAPS_DMI_MATCH_INVERT("LENOVO", "ThinkPad Z61m"),
-	HDAPS_DMI_MATCH_INVERT("LENOVO", "ThinkPad Z61p"),
+	HDAPS_DMI_MATCH_INVERT("LENOVO", "ThinkPad Z61m", HDAPS_BOTH_AXES),
+	HDAPS_DMI_MATCH_INVERT("LENOVO", "ThinkPad Z61p", HDAPS_BOTH_AXES),
 	{ .ident = NULL }
 };
 
@@ -627,8 +633,9 @@ static void __exit hdaps_exit(void)
 module_init(hdaps_init);
 module_exit(hdaps_exit);
 
-module_param_named(invert, hdaps_invert, bool, 0);
-MODULE_PARM_DESC(invert, "invert data along each axis");
+module_param_named(invert, hdaps_invert, int, 0);
+MODULE_PARM_DESC(invert, "invert data along each axis. 1 invert x-axis, "
+		 "2 invert y-axis, 3 invert both axes.");
 
 MODULE_AUTHOR("Robert Love");
 MODULE_DESCRIPTION("IBM Hard Drive Active Protection System (HDAPS) driver");
