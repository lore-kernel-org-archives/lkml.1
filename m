Return-Path: <linux-kernel-owner+w=401wt.eu-S1751998AbXCXO1u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751998AbXCXO1u (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2007 10:27:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752010AbXCXO1t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Mar 2007 10:27:49 -0400
Received: from smtp3.nextra.sk ([195.168.1.142]:4137 "EHLO mailhub3.nextra.sk"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751998AbXCXO1t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2007 10:27:49 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: daniel.ritz@gmx.ch
Subject: Invert X or Y axis options for usbtouchscreen
Date: Sat, 24 Mar 2007 15:27:39 +0100
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_bVTBGbIIIOayUIy"
Message-Id: <200703241527.39792.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_bVTBGbIIIOayUIy
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hello,
this patch adds support for inverting X or Y axis (or both) to the 
usbtouchscreen driver. Invert Y is needed (together with swap XY) for 
LeadingTouch screens (at least for some of them).

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>

-- 
Ondrej Zary

--Boundary-00=_bVTBGbIIIOayUIy
Content-Type: text/x-diff;
  charset="us-ascii";
  name="usbtouchscreen-invert.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
	filename="usbtouchscreen-invert.patch"

--- linux-2.6.20-orig/drivers/usb/input/usbtouchscreen.c	2007-03-23 15:49:35.000000000 +0100
+++ linux/drivers/usb/input/usbtouchscreen.c	2007-03-23 15:52:02.000000000 +0100
@@ -54,6 +54,12 @@
 static int swap_xy;
 module_param(swap_xy, bool, 0644);
 MODULE_PARM_DESC(swap_xy, "If set X and Y axes are swapped.");
+static int invert_x;
+module_param(invert_x, bool, 0644);
+MODULE_PARM_DESC(invert_x, "Invert X axis.");
+static int invert_y;
+module_param(invert_y, bool, 0644);
+MODULE_PARM_DESC(invert_y, "Invert Y axis.");
 
 /* device specifc data/functions */
 struct usbtouch_usb;
@@ -514,6 +520,7 @@
                                  unsigned char *pkt, int len)
 {
 	struct usbtouch_device_info *type = usbtouch->type;
+	int x, y;
 
 	if (!type->read_data(usbtouch, pkt))
 			return;
@@ -521,12 +528,20 @@
 	input_report_key(usbtouch->input, BTN_TOUCH, usbtouch->touch);
 
 	if (swap_xy) {
-		input_report_abs(usbtouch->input, ABS_X, usbtouch->y);
-		input_report_abs(usbtouch->input, ABS_Y, usbtouch->x);
+		x = usbtouch->y;
+		y = usbtouch->x;
 	} else {
-		input_report_abs(usbtouch->input, ABS_X, usbtouch->x);
-		input_report_abs(usbtouch->input, ABS_Y, usbtouch->y);
+		x = usbtouch->x;
+		y = usbtouch->y;
 	}
+	if (invert_x)
+		x = type->max_xc - x + type->min_xc;
+	if (invert_y)
+		y = type->max_yc - y + type->min_yc;
+
+	input_report_abs(usbtouch->input, ABS_X, x);
+	input_report_abs(usbtouch->input, ABS_Y, y);
+
 	if (type->max_press)
 		input_report_abs(usbtouch->input, ABS_PRESSURE, usbtouch->press);
 	input_sync(usbtouch->input);

--Boundary-00=_bVTBGbIIIOayUIy--
