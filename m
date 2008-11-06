Return-Path: <linux-kernel-owner+w=401wt.eu-S1754162AbYKFNYe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754162AbYKFNYe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 08:24:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753430AbYKFNY0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 08:24:26 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:51447 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751533AbYKFNY0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 08:24:26 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@openedhand.com>
Cc: linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 2.6.28] mfd: Correct WM8350 I2C return code usage
Date: Thu,  6 Nov 2008 13:24:23 +0000
Message-Id: <1225977863-11595-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The vendor BSP used for the WM8350 development provided an I2C driver
which incorrectly returned zero on succesful sends rather than the
number of transmitted bytes, an error which was then propagated into the
WM8350 I2C accessors.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/wm8350-i2c.c |   15 +++++++++++++--
 1 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/wm8350-i2c.c b/drivers/mfd/wm8350-i2c.c
index 8dfe21b..3e0ce0e 100644
--- a/drivers/mfd/wm8350-i2c.c
+++ b/drivers/mfd/wm8350-i2c.c
@@ -30,7 +30,12 @@ static int wm8350_i2c_read_device(struct wm8350 *wm8350, char reg,
 	ret = i2c_master_send(wm8350->i2c_client, &reg, 1);
 	if (ret < 0)
 		return ret;
-	return i2c_master_recv(wm8350->i2c_client, dest, bytes);
+	ret = i2c_master_recv(wm8350->i2c_client, dest, bytes);
+	if (ret < 0)
+		return ret;
+	if (ret != bytes)
+		return -EIO;
+	return 0;
 }
 
 static int wm8350_i2c_write_device(struct wm8350 *wm8350, char reg,
@@ -38,13 +43,19 @@ static int wm8350_i2c_write_device(struct wm8350 *wm8350, char reg,
 {
 	/* we add 1 byte for device register */
 	u8 msg[(WM8350_MAX_REGISTER << 1) + 1];
+	int ret;
 
 	if (bytes > ((WM8350_MAX_REGISTER << 1) + 1))
 		return -EINVAL;
 
 	msg[0] = reg;
 	memcpy(&msg[1], src, bytes);
-	return i2c_master_send(wm8350->i2c_client, msg, bytes + 1);
+	ret = i2c_master_send(wm8350->i2c_client, msg, bytes + 1);
+	if (ret < 0)
+		return ret;
+	if (ret != bytes + 1)
+		return -EIO;
+	return 0;
 }
 
 static int wm8350_i2c_probe(struct i2c_client *i2c,
-- 
1.5.6.5

