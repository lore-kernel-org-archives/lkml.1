Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936110Ab0BZMVm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 07:21:42 -0500
Received: from legolas.restena.lu ([158.64.1.34]:58882 "EHLO
	legolas.restena.lu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935877Ab0BZMVh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 07:21:37 -0500
Date: Fri, 26 Feb 2010 13:04:54 +0100
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: Richard Purdie <rpurdie@linux.intel.com>,
       Mike Frysinger <vapier@gentoo.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fbdev@vger.kernel.org
Subject: [PATCH] backlight, blackfin: fix missing registration failure
 handling
Message-ID: <20100226130454.228af99a@neptune.home>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.16.6; i686-pc-linux-gnu)
References: <20100221002831.689bace8@neptune.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Check newly registered backlight_device for error and properly
return error to parent
Mark struct backlight_ops as const.

Signed-off-by: Bruno Prémont <bonbons@linux-vserver.org>
Acked-by: Mike Frysinger <vapier@gentoo.org> (constify struct backlight_ops)
---
 drivers/video/bf54x-lq043fb.c           |   10 +++++++++-
 drivers/video/bfin-t350mcqb-fb.c        |   10 +++++++++-
 2 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/drivers/video/bf54x-lq043fb.c b/drivers/video/bf54x-lq043fb.c
index db4e6f7..a589216 100644
--- a/drivers/video/bf54x-lq043fb.c
+++ b/drivers/video/bf54x-lq043fb.c
@@ -463,7 +463,7 @@ static int bl_get_brightness(struct backlight_device *bd)
 	return 0;
 }
 
-static struct backlight_ops bfin_lq043fb_bl_ops = {
+static const struct backlight_ops bfin_lq043fb_bl_ops = {
 	.get_brightness = bl_get_brightness,
 };
 
@@ -678,6 +678,12 @@ static int __devinit bfin_bf54x_probe(struct platform_device *pdev)
 	bl_dev =
 	    backlight_device_register("bf54x-bl", NULL, NULL,
 				      &bfin_lq043fb_bl_ops);
+	if (IS_ERR(bl_dev)) {
+		printk(KERN_ERR DRIVER_NAME
+		       ": unable to register backlight.\n");
+		ret = -EINVAL;
+		goto out9;
+	}
 	bl_dev->props.max_brightness = 255;
 
 	lcd_dev = lcd_device_register(DRIVER_NAME, &pdev->dev, NULL, &bfin_lcd_ops);
@@ -686,6 +692,8 @@ static int __devinit bfin_bf54x_probe(struct platform_device *pdev)
 
 	return 0;
 
+out9:
+	unregister_framebuffer(fbinfo);
 out8:
 	free_irq(info->irq, info);
 out7:
diff --git a/drivers/video/bfin-t350mcqb-fb.c b/drivers/video/bfin-t350mcqb-fb.c
index bc204c6..fe1492b 100644
--- a/drivers/video/bfin-t350mcqb-fb.c
+++ b/drivers/video/bfin-t350mcqb-fb.c
@@ -381,7 +381,7 @@ static int bl_get_brightness(struct backlight_device *bd)
 	return 0;
 }
 
-static struct backlight_ops bfin_lq043fb_bl_ops = {
+static const struct backlight_ops bfin_lq043fb_bl_ops = {
 	.get_brightness = bl_get_brightness,
 };
 
@@ -572,6 +572,12 @@ static int __devinit bfin_t350mcqb_probe(struct platform_device *pdev)
 	bl_dev =
 	    backlight_device_register("bf52x-bl", NULL, NULL,
 				      &bfin_lq043fb_bl_ops);
+	if (IS_ERR(bl_dev)) {
+		printk(KERN_ERR DRIVER_NAME
+		       ": unable to register backlight.\n");
+		ret = -EINVAL;
+		goto out9;
+	}
 	bl_dev->props.max_brightness = 255;
 
 	lcd_dev = lcd_device_register(DRIVER_NAME, NULL, &bfin_lcd_ops);
@@ -580,6 +586,8 @@ static int __devinit bfin_t350mcqb_probe(struct platform_device *pdev)
 
 	return 0;
 
+out9:
+	unregister_framebuffer(fbinfo);
 out8:
 	free_irq(info->irq, info);
 out7:
-- 
1.6.4.4

