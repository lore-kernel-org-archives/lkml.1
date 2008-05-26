Return-Path: <linux-kernel-owner+w=401wt.eu-S1756290AbYEZNnj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756290AbYEZNnj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 09:43:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752646AbYEZNmM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 09:42:12 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:54456 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751569AbYEZNmI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 09:42:08 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Rodolfo Giometti <giometti@enneenne.com>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 4/4] wm9713: Support five wire panels
Date: Mon, 26 May 2008 14:42:03 +0100
Message-Id: <1211809323-4742-4-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1211809323-4742-3-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1211809323-4742-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1211809323-4742-2-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1211809323-4742-3-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/input/touchscreen/wm9713.c |   22 ++++++++++++++++++++++
 include/linux/wm97xx.h             |    1 +
 2 files changed, 23 insertions(+), 0 deletions(-)

diff --git a/drivers/input/touchscreen/wm9713.c b/drivers/input/touchscreen/wm9713.c
index 01278bd..8384587 100644
--- a/drivers/input/touchscreen/wm9713.c
+++ b/drivers/input/touchscreen/wm9713.c
@@ -85,6 +85,15 @@ module_param(delay, int, 0);
 MODULE_PARM_DESC(delay, "Set adc sample delay.");
 
 /*
+ * Set five_wire = 1 to use a 5 wire touchscreen.
+ *
+ * NOTE: Five wire mode does not allow for readback of pressure.
+ */
+static int five_wire;
+module_param(five_wire, int, 0);
+MODULE_PARM_DESC(five_wire, "Set to '1' to use 5-wire touchscreen.");
+
+/*
  * Set adc mask function.
  *
  * Sources of glitch noise, such as signals driving an LCD display, may feed
@@ -162,6 +171,19 @@ static void wm9713_phy_init(struct wm97xx *wm)
 			 64000 / rpu);
 	}
 
+	/* Five wire panel? */
+	if (five_wire) {
+		dig3 |= WM9713_45W;
+		dev_info(wm->dev, "setting 5-wire touchscreen mode.");
+
+		if (pil) {
+			dev_warn(wm->dev,
+				 "Pressure measurement not supported in 5 "
+				 "wire mode, disabling\n");
+			pil = 0;
+		}
+	}
+
 	/* touchpanel pressure */
 	if (pil == 2) {
 		dig3 |= WM9712_PIL;
diff --git a/include/linux/wm97xx.h b/include/linux/wm97xx.h
index 4d13732..6f69968 100644
--- a/include/linux/wm97xx.h
+++ b/include/linux/wm97xx.h
@@ -100,6 +100,7 @@
 #define WM9713_ADCSEL_Y		0x0004	/* Y measurement */
 #define WM9713_ADCSEL_PRES	0x0008	/* Pressure measurement */
 #define WM9713_COO		0x0001	/* enable coordinate mode */
+#define WM9713_45W		0x1000  /* set for 5 wire panel */
 #define WM9713_PDEN		0x0800	/* measure only when pen down */
 #define WM9713_ADCSEL_MASK	0x00fe	/* ADC selection mask */
 #define WM9713_WAIT		0x0200	/* coordinate wait */
-- 
1.5.5.1

