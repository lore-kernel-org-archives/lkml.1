Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757252Ab0BXQCb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 11:02:31 -0500
Received: from legolas.restena.lu ([158.64.1.34]:43229 "EHLO
	legolas.restena.lu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757171Ab0BXQCZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 11:02:25 -0500
Date: Wed, 24 Feb 2010 17:01:25 +0100
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-input@vger.kernel.org, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       "Rick L. Vinyard Jr." <rvinyard@cs.nmsu.edu>,
       Nicu Pavel <npavel@ituner.com>
Subject: [PATCH 3/3] hid-picolcd: make use of new suspend/resume hooks
Message-ID: <20100224170125.65f8bdfc@neptune.home>
In-Reply-To: <20100224163101.3622d69f@neptune.home>
References: <20100221002001.0a7e05a7@neptune.home>
 <20100224163101.3622d69f@neptune.home>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.16.6; i686-pc-linux-gnu)
References: <20100224170049.0d04af3c@neptune.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make use of new suspend/resume hooks to disable backlight on suspend
and restore backlight on simple resume or backlight, contrast and
framebuffer content on reset-resume.

Signed-off-by: Bruno Prémont <bonbons@linux-vserver.org>
Cc: Nicu Pavel <npavel@ituner.com>
---
 drivers/hid/hid-picolcd.c           |   45 +++
 1 files changed, 45 insertions(+), 0 deletions(-)

diff --git a/drivers/hid/hid-picolcd.c b/drivers/hid/hid-picolcd.c
index e69de29..90f6be5 100644
--- a/drivers/hid/hid-picolcd.c
+++ b/drivers/hid/hid-picolcd.c
@@ -833,6 +833,46 @@
 };
 
 
+#ifdef CONFIG_PM
+static int picolcd_suspend(struct hid_device *hdev)
+{
+	struct picolcd_data *data = hid_get_drvdata(hdev);
+	int bl_power = data->lcd_power;
+
+	data->backlight->props.power = FB_BLANK_POWERDOWN;
+	picolcd_set_brightness(data->backlight);
+	data->lcd_power = data->backlight->props.power = bl_power;
+	dbg_hid(PICOLCD_NAME " device ready for suspend, lcd_power=%d\n", bl_power);
+	return 0;
+}
+
+static int picolcd_resume(struct hid_device *hdev)
+{
+	struct picolcd_data *data = hid_get_drvdata(hdev);
+	int ret;
+	ret = picolcd_set_brightness(data->backlight);
+	if (ret)
+		dbg_hid(PICOLCD_NAME " restoring brightness failed: %d\n", ret);
+	ret = picolcd_set_contrast(data->lcd, data->lcd_contrast);
+	if (ret)
+		dbg_hid(PICOLCD_NAME " restoring contrast failed: %d\n", ret);
+	return 0;
+}
+
+static int picolcd_reset_resume(struct hid_device *hdev)
+{
+	int ret;
+	ret = picolcd_reset(hdev);
+	if (ret)
+		dbg_hid(PICOLCD_NAME " resetting our device failed: %d\n", ret);
+	ret = picolcd_fb_reset(hdev, 0);
+	if (ret)
+		dbg_hid(PICOLCD_NAME " restoring framebuffer content failed: %d\n", ret);
+	return 0;
+}
+#endif
+
+
 static int picolcd_probe(struct hid_device *hdev,
 		     const struct hid_device_id *id)
 {
@@ -1057,6 +1097,11 @@
 	.probe =         picolcd_probe,
 	.remove =        picolcd_remove,
 	.raw_event =     picolcd_raw_event,
+#ifdef CONFIG_PM
+	.suspend =       picolcd_suspend,
+	.resume =        picolcd_resume,
+	.reset_resume =  picolcd_reset_resume,
+#endif
 };
 
 static int __init picolcd_init(void)
