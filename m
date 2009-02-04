Return-Path: <linux-kernel-owner+w=401wt.eu-S1756838AbZBDRv7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756838AbZBDRv7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 12:51:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751920AbZBDRvv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 12:51:51 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:56540 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751677AbZBDRvu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 12:51:50 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@openedhand.com>
Cc: linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] mfd: Use bulk read to fill WM8350 register cache
Date: Wed,  4 Feb 2009 17:51:48 +0000
Message-Id: <1233769908-1131-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some I2C controllers have high overheads for setting up I2C operations
which makes the register cache setup on startup excessively slow since
it does a lot of small transactions. Reduce this overhead by doing a
bulk read of the entire register bank and filtering out what we don't
need later.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/wm8350-core.c |   21 ++++++++++++---------
 1 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/drivers/mfd/wm8350-core.c b/drivers/mfd/wm8350-core.c
index cf8b9ed..c384cd2 100644
--- a/drivers/mfd/wm8350-core.c
+++ b/drivers/mfd/wm8350-core.c
@@ -1238,7 +1238,7 @@ static int wm8350_create_cache(struct wm8350 *wm8350, int type, int mode)
 	}
 
 	wm8350->reg_cache =
-	    kzalloc(sizeof(u16) * (WM8350_MAX_REGISTER + 1), GFP_KERNEL);
+		kmalloc(sizeof(u16) * (WM8350_MAX_REGISTER + 1), GFP_KERNEL);
 	if (wm8350->reg_cache == NULL)
 		return -ENOMEM;
 
@@ -1246,17 +1246,20 @@ static int wm8350_create_cache(struct wm8350 *wm8350, int type, int mode)
 	 * a PMIC so the device many not be in a virgin state and we
 	 * can't rely on the silicon values.
 	 */
+	ret = wm8350->read_dev(wm8350, 0,
+			       sizeof(u16) * (WM8350_MAX_REGISTER + 1),
+			       wm8350->reg_cache);
+	if (ret < 0) {
+		dev_err(wm8350->dev,
+			"failed to read initial cache values\n");
+		goto out;
+	}
+
+	/* Mask out uncacheable/unreadable bits and the audio. */
 	for (i = 0; i < WM8350_MAX_REGISTER; i++) {
-		/* audio register range */
 		if (wm8350_reg_io_map[i].readable &&
 		    (i < WM8350_CLOCK_CONTROL_1 || i > WM8350_AIF_TEST)) {
-			ret = wm8350->read_dev(wm8350, i, 2, (char *)&value);
-			if (ret < 0) {
-				dev_err(wm8350->dev,
-				       "failed to read initial cache value\n");
-				goto out;
-			}
-			value = be16_to_cpu(value);
+			value = be16_to_cpu(wm8350->reg_cache[i]);
 			value &= wm8350_reg_io_map[i].readable;
 			value &= ~wm8350_reg_io_map[i].vol;
 			wm8350->reg_cache[i] = value;
-- 
1.5.6.5

