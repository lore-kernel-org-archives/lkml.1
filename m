Return-Path: <linux-kernel-owner+w=401wt.eu-S1755558AbYLJWcf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755558AbYLJWcf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 17:32:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753185AbYLJWcZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 17:32:25 -0500
Received: from tim.rpsys.net ([194.106.48.114]:57485 "EHLO tim.rpsys.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751448AbYLJWcY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 17:32:24 -0500
Subject: Re: [PATCH] video: mbp_nvidia_bl: Fix brightness after
	suspend/hibernation
From: Richard Purdie <rpurdie@rpsys.net>
To: Mario Schwalbe <schwalbe@inf.tu-dresden.de>
Cc: Matthew Garrett <mjg@redhat.com>, linux-kernel@vger.kernel.org
In-Reply-To: <494026CD.5020102@inf.tu-dresden.de>
References: <494026CD.5020102@inf.tu-dresden.de>
Content-Type: text/plain
Date: Wed, 10 Dec 2008 22:31:53 +0000
Message-Id: <1228948313.5423.34.camel@dax.rpnet.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-12-10 at 21:30 +0100, Mario Schwalbe wrote:
> The mbp_nvidia_bl driver allows to change the display brightness on
> Apple MacBook Pro with Nvidia graphics adapters. However, after
> resuming from suspend the brightness is at its maximum instead of
> the last recently used value. This patch converts the driver into a
> platform_driver in order to register a resume hook to re-send brightness.
> In addition, resources will be allocated through platform_driver means
> instead of calling request_region/release_region directly.

I understand the problem, I'm not sure adding more platform devices and
drivers into the equation is a good way to solve it. I've been thinking
of adding suspend/resume support into the backlight core for a while and
this would solve this problem. How about the following patch (only
compile tested so far)?

diff --git a/drivers/video/backlight/backlight.c b/drivers/video/backlight/backlight.c
index 592d714..fc95829 100644
--- a/drivers/video/backlight/backlight.c
+++ b/drivers/video/backlight/backlight.c
@@ -40,6 +40,10 @@ static int fb_notifier_callback(struct notifier_block *self,
 		if (!bd->ops->check_fb ||
 		    bd->ops->check_fb(evdata->info)) {
 			bd->props.fb_blank = *(int *)evdata->data;
+			if (bd->props.fb_blank == FB_BLANK_UNBLANK)
+				bd->props.flags &= ~BL_CORE_FBBLANK;
+			else
+				bd->props.flags |= BL_CORE_FBBLANK;
 			backlight_update_status(bd);
 		}
 	mutex_unlock(&bd->ops_lock);
@@ -167,6 +171,34 @@ static ssize_t backlight_show_actual_brightness(struct device *dev,
 
 static struct class *backlight_class;
 
+static int backlight_suspend(struct device *dev, pm_message_t state)
+{
+	struct backlight_device *bd = to_backlight_device(dev);
+
+	if (bd->ops->flags & BL_CORE_SUSPENDRESUME) {
+		mutex_lock(&bd->ops_lock);
+		bd->props.flags |= BL_CORE_SUSPENDED;
+		backlight_update_status(bd);
+		mutex_unlock(&bd->ops_lock);
+	}
+
+	return 0;
+}
+
+static int backlight_resume(struct device *dev)
+{
+	struct backlight_device *bd = to_backlight_device(dev);
+
+	if (bd->ops->flags & BL_CORE_SUSPENDRESUME) {
+		mutex_lock(&bd->ops_lock);
+		bd->props.flags &= ~BL_CORE_SUSPENDED;
+		backlight_update_status(bd);
+		mutex_unlock(&bd->ops_lock);
+	}
+
+	return 0;
+}
+
 static void bl_device_release(struct device *dev)
 {
 	struct backlight_device *bd = to_backlight_device(dev);
@@ -283,6 +315,8 @@ static int __init backlight_class_init(void)
 	}
 
 	backlight_class->dev_attrs = bl_device_attributes;
+	backlight_class->suspend = backlight_suspend;
+	backlight_class->resume = backlight_resume;
 	return 0;
 }
 
diff --git a/drivers/video/backlight/corgi_bl.c b/drivers/video/backlight/corgi_bl.c
index 4d4d037..02ff4bb 100644
--- a/drivers/video/backlight/corgi_bl.c
+++ b/drivers/video/backlight/corgi_bl.c
@@ -25,8 +25,7 @@ static struct backlight_device *corgi_backlight_device;
 static struct generic_bl_info *bl_machinfo;
 
 static unsigned long corgibl_flags;
-#define CORGIBL_SUSPENDED     0x01
-#define CORGIBL_BATTLOW       0x02
+#define CORGIBL_BATTLOW       0x01
 
 static int corgibl_send_intensity(struct backlight_device *bd)
 {
@@ -34,9 +33,9 @@ static int corgibl_send_intensity(struct backlight_device *bd)
 
 	if (bd->props.power != FB_BLANK_UNBLANK)
 		intensity = 0;
-	if (bd->props.fb_blank != FB_BLANK_UNBLANK)
+	if (bd->props.flags & BL_CORE_FBBLANK)
 		intensity = 0;
-	if (corgibl_flags & CORGIBL_SUSPENDED)
+	if (bd->props.flags & BL_CORE_SUSPENDED)
 		intensity = 0;
 	if (corgibl_flags & CORGIBL_BATTLOW)
 		intensity &= bl_machinfo->limit_mask;
@@ -51,29 +50,6 @@ static int corgibl_send_intensity(struct backlight_device *bd)
 	return 0;
 }
 
-#ifdef CONFIG_PM
-static int corgibl_suspend(struct platform_device *pdev, pm_message_t state)
-{
-	struct backlight_device *bd = platform_get_drvdata(pdev);
-
-	corgibl_flags |= CORGIBL_SUSPENDED;
-	backlight_update_status(bd);
-	return 0;
-}
-
-static int corgibl_resume(struct platform_device *pdev)
-{
-	struct backlight_device *bd = platform_get_drvdata(pdev);
-
-	corgibl_flags &= ~CORGIBL_SUSPENDED;
-	backlight_update_status(bd);
-	return 0;
-}
-#else
-#define corgibl_suspend	NULL
-#define corgibl_resume	NULL
-#endif
-
 static int corgibl_get_intensity(struct backlight_device *bd)
 {
 	return corgibl_intensity;
@@ -95,6 +71,7 @@ EXPORT_SYMBOL(corgibl_limit_intensity);
 
 
 static struct backlight_ops corgibl_ops = {
+	.flags = BL_CORE_SUSPENDRESUME,
 	.get_brightness = corgibl_get_intensity,
 	.update_status  = corgibl_send_intensity,
 };
@@ -144,8 +121,6 @@ static int corgibl_remove(struct platform_device *pdev)
 static struct platform_driver corgibl_driver = {
 	.probe		= corgibl_probe,
 	.remove		= corgibl_remove,
-	.suspend	= corgibl_suspend,
-	.resume		= corgibl_resume,
 	.driver		= {
 		.name	= "generic-bl",
 	},
diff --git a/drivers/video/backlight/mbp_nvidia_bl.c b/drivers/video/backlight/mbp_nvidia_bl.c
index 06964af..f5bd0b4 100644
--- a/drivers/video/backlight/mbp_nvidia_bl.c
+++ b/drivers/video/backlight/mbp_nvidia_bl.c
@@ -70,6 +70,7 @@ static int mbp_get_intensity(struct backlight_device *bd)
 }
 
 static struct backlight_ops mbp_ops = {
+	.flags = BL_CORE_SUSPENDRESUME,
 	.get_brightness = mbp_get_intensity,
 	.update_status  = mbp_send_intensity,
 };
diff --git a/include/linux/backlight.h b/include/linux/backlight.h
index 1ee9488..516fbc7 100644
--- a/include/linux/backlight.h
+++ b/include/linux/backlight.h
@@ -31,6 +31,10 @@ struct backlight_device;
 struct fb_info;
 
 struct backlight_ops {
+	unsigned int flags;
+
+#define BL_CORE_SUSPENDRESUME	(1 << 0)
+
 	/* Notify the backlight driver some property has changed */
 	int (*update_status)(struct backlight_device *);
 	/* Return the current backlight brightness (accounting for power,
@@ -52,6 +56,12 @@ struct backlight_properties {
 	int power;
 	/* FB Blanking active? (values as for power) */
 	int fb_blank;
+	/* Flags used to signal drivers of state changes */
+	unsigned int flags;
+
+#define BL_CORE_SUSPENDED	(1 << 0)	/* backlight is suspended */
+#define BL_CORE_FBBLANK		(1 << 1)	/* backlight is under an fb blank event */
+
 };
 
 struct backlight_device {


-- 
Richard Purdie
Intel Open Source Technology Centre

