Return-Path: <linux-kernel-owner+w=401wt.eu-S932718AbZJAOlO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932718AbZJAOlO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 10:41:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932709AbZJAOlO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 10:41:14 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:34125 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932704AbZJAOlM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 10:41:12 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 1/4] mfd: Refactor WM831x chip identification
Date: Thu,  1 Oct 2009 15:41:04 +0100
Message-Id: <1254408067-15908-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.6.4.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Better support future device revisions by moving some of the output
around and making the chip ID enumeration be the value expected in
the ID register.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/wm831x-core.c |   58 ++++++++++++++-------------------------------
 1 files changed, 18 insertions(+), 40 deletions(-)

diff --git a/drivers/mfd/wm831x-core.c b/drivers/mfd/wm831x-core.c
index 49b7885..143ab83 100644
--- a/drivers/mfd/wm831x-core.c
+++ b/drivers/mfd/wm831x-core.c
@@ -90,9 +90,9 @@ int wm831x_isinkv_values[WM831X_ISINK_MAX_ISEL] = {
 EXPORT_SYMBOL_GPL(wm831x_isinkv_values);
 
 enum wm831x_parent {
-	WM8310 = 0,
-	WM8311 = 1,
-	WM8312 = 2,
+	WM8310 = 0x8310,
+	WM8311 = 0x8311,
+	WM8312 = 0x8312,
 };
 
 static int wm831x_reg_locked(struct wm831x *wm831x, unsigned short reg)
@@ -1282,50 +1282,28 @@ static int wm831x_device_init(struct wm831x *wm831x, unsigned long id, int irq)
 		goto err;
 	}
 
+	/* Some engineering samples do not have the ID set, rely on
+	 * the device being registered correctly.
+	 */
+	if (ret == 0) {
+		dev_info(wm831x->dev, "Device is an engineering sample\n");
+		ret = id;
+	}
+
 	switch (ret) {
-	case 0x8310:
+	case WM8310:
 		parent = WM8310;
-		switch (rev) {
-		case 0:
-			dev_info(wm831x->dev, "WM8310 revision %c\n",
-				 'A' + rev);
-			break;
-		}
+		dev_info(wm831x->dev, "WM8310 revision %c\n", 'A' + rev);
 		break;
 
-	case 0x8311:
+	case WM8311:
 		parent = WM8311;
-		switch (rev) {
-		case 0:
-			dev_info(wm831x->dev, "WM8311 revision %c\n",
-				 'A' + rev);
-			break;
-		}
+		dev_info(wm831x->dev, "WM8311 revision %c\n", 'A' + rev);
 		break;
 
-	case 0x8312:
+	case WM8312:
 		parent = WM8312;
-		switch (rev) {
-		case 0:
-			dev_info(wm831x->dev, "WM8312 revision %c\n",
-				 'A' + rev);
-			break;
-		}
-		break;
-
-	case 0:
-		/* Some engineering samples do not have the ID set,
-		 * rely on the device being registered correctly.
-		 * This will need revisiting for future devices with
-		 * multiple dies.
-		 */
-		parent = id;
-		switch (rev) {
-		case 0:
-			dev_info(wm831x->dev, "WM831%d ES revision %c\n",
-				 parent, 'A' + rev);
-			break;
-		}
+		dev_info(wm831x->dev, "WM8312 revision %c\n", 'A' + rev);
 		break;
 
 	default:
@@ -1338,7 +1316,7 @@ static int wm831x_device_init(struct wm831x *wm831x, unsigned long id, int irq)
 	 * current parts.
 	 */
 	if (parent != id)
-		dev_warn(wm831x->dev, "Device was registered as a WM831%lu\n",
+		dev_warn(wm831x->dev, "Device was registered as a WM%lx\n",
 			 id);
 
 	/* Bootstrap the user key */
-- 
1.6.4.3

