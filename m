Return-Path: <linux-kernel-owner+w=401wt.eu-S1751678AbXBVQhm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751678AbXBVQhm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 11:37:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751687AbXBVQhl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 11:37:41 -0500
Received: from 81-174-11-161.f5.ngi.it ([81.174.11.161]:50333 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751678AbXBVQhj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 11:37:39 -0500
Date: Thu, 22 Feb 2007 17:37:27 +0100
From: Rodolfo Giometti <giometti@enneenne.com>
To: Paul Sokolovsky <pmiscml@gmail.com>
Cc: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org,
       linux-fbdev-devel@lists.sourceforge.net,
       Richard Purdie <rpurdie@rpsys.net>
Message-ID: <20070222163727.GV13924@enneenne.com>
References: <20070221145353.GA23916@enneenne.com> <1056908425.20070221180037@gmail.com> <20070221161210.GL4641@enneenne.com> <1741775233.20070221182608@gmail.com> <20070222083204.GN4641@enneenne.com> <1868738509.20070222123335@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="owPIoVL9FiqC4k42"
Content-Disposition: inline
In-Reply-To: <1868738509.20070222123335@gmail.com>
Organization: GNU/Linux Device Drivers, Embedded Systems and Courses
X-PGP-Key: gpg --keyserver keyserver.linux.it --recv-keys D25A5633
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: 192.168.32.1
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: Re: [PATCH 1/1] PXAFB: Support for backlight control
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--owPIoVL9FiqC4k42
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Feb 22, 2007 at 12:33:35PM +0200, Paul Sokolovsky wrote:
> 
>   We in handhelds.org codebase have attached patch* to make corgi_bl
> more suitable for general use. This patch was submitted to Richard
> (so, more votes needed ;-) ). Otherwise, snippet I pasted is from real
> machine implementation, HP iPaq h4000.

You have my vote! :)

So let me suggest this patch who allows multiple driver instances (I
use it for both LCD and keypad backlighti devices).

Hope it could be merged into main line (maybe without the "corgi"
prefix ;-).

Ciao,

Rodolfo

-- 

GNU/Linux Solutions                  e-mail:    giometti@enneenne.com
Linux Device Driver                             giometti@gnudd.com
Embedded Systems                     		giometti@linux.it
UNIX programming                     phone:     +39 349 2432127

--owPIoVL9FiqC4k42
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=patch-multiple-backlight-devices

diff --git a/drivers/video/backlight/corgi_bl.c b/drivers/video/backlight/corgi_bl.c
index cc2ae61..063f0a1 100644
--- a/drivers/video/backlight/corgi_bl.c
+++ b/drivers/video/backlight/corgi_bl.c
@@ -15,24 +15,14 @@
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/platform_device.h>
-#include <linux/mutex.h>
 #include <linux/fb.h>
 #include <linux/backlight.h>
 #include <linux/corgi_bl.h>
 #include <asm/hardware/sharpsl_pm.h>
 
-static int corgibl_intensity;
-static DEFINE_MUTEX(bl_mutex);
-static struct backlight_properties corgibl_data;
-static struct backlight_device *corgi_backlight_device;
-static struct corgibl_machinfo *bl_machinfo;
-
-static unsigned long corgibl_flags;
-#define CORGIBL_SUSPENDED     0x01
-#define CORGIBL_BATTLOW       0x02
-
 static int corgibl_send_intensity(struct backlight_device *bd)
 {
+	struct corgibl_info *info = to_backlight_info(bd->props);
 	void (*corgi_kick_batt)(void);
 	int intensity = bd->props->brightness;
 
@@ -40,16 +30,16 @@ static int corgibl_send_intensity(struct backlight_device *bd)
 		intensity = 0;
 	if (bd->props->fb_blank != FB_BLANK_UNBLANK)
 		intensity = 0;
-	if (corgibl_flags & CORGIBL_SUSPENDED)
+	if (info->flags & CORGIBL_SUSPENDED)
 		intensity = 0;
-	if (corgibl_flags & CORGIBL_BATTLOW)
-		intensity &= bl_machinfo->limit_mask;
+	if (info->flags & CORGIBL_BATTLOW)
+		intensity &= info->machinfo->limit_mask;
 
- 	mutex_lock(&bl_mutex);
-	bl_machinfo->set_bl_intensity(intensity);
-	mutex_unlock(&bl_mutex);
+ 	mutex_lock(&info->mutex);
+	info->machinfo->set_bl_intensity(intensity);
+	mutex_unlock(&info->mutex);
 
-	corgibl_intensity = intensity;
+	info->intensity = intensity;
 
  	corgi_kick_batt = symbol_get(sharpsl_battery_kick);
  	if (corgi_kick_batt) {
@@ -61,17 +51,21 @@ static int corgibl_send_intensity(struct backlight_device *bd)
 }
 
 #ifdef CONFIG_PM
-static int corgibl_suspend(struct platform_device *dev, pm_message_t state)
+static int corgibl_suspend(struct platform_device *pdev, pm_message_t state)
 {
-	corgibl_flags |= CORGIBL_SUSPENDED;
-	corgibl_send_intensity(corgi_backlight_device);
+	struct corgibl_info *info = platform_get_drvdata(pdev);
+
+	info->flags |= CORGIBL_SUSPENDED;
+	corgibl_send_intensity(info->bd);
 	return 0;
 }
 
-static int corgibl_resume(struct platform_device *dev)
+static int corgibl_resume(struct platform_device *pdev)
 {
-	corgibl_flags &= ~CORGIBL_SUSPENDED;
-	corgibl_send_intensity(corgi_backlight_device);
+	struct corgibl_info *info = platform_get_drvdata(pdev);
+
+	info->flags &= ~CORGIBL_SUSPENDED;
+	corgibl_send_intensity(info->bd);
 	return 0;
 }
 #else
@@ -81,12 +75,14 @@ static int corgibl_resume(struct platform_device *dev)
 
 static int corgibl_get_intensity(struct backlight_device *bd)
 {
-	return corgibl_intensity;
+	struct corgibl_info *info = to_backlight_info(bd->props);
+
+	return info->intensity;
 }
 
 static int corgibl_set_intensity(struct backlight_device *bd)
 {
-	corgibl_send_intensity(corgi_backlight_device);
+	corgibl_send_intensity(bd);
 	return 0;
 }
 
@@ -94,52 +90,71 @@ static int corgibl_set_intensity(struct backlight_device *bd)
  * Called when the battery is low to limit the backlight intensity.
  * If limit==0 clear any limit, otherwise limit the intensity
  */
-void corgibl_limit_intensity(int limit)
+void corgibl_limit_intensity(struct backlight_device *bd, int limit)
 {
+	struct corgibl_info *info = to_backlight_info(bd->props);
+
 	if (limit)
-		corgibl_flags |= CORGIBL_BATTLOW;
+		info->flags |= CORGIBL_BATTLOW;
 	else
-		corgibl_flags &= ~CORGIBL_BATTLOW;
-	corgibl_send_intensity(corgi_backlight_device);
+		info->flags &= ~CORGIBL_BATTLOW;
+	corgibl_send_intensity(bd);
 }
 EXPORT_SYMBOL(corgibl_limit_intensity);
 
-
-static struct backlight_properties corgibl_data = {
-	.owner          = THIS_MODULE,
-	.get_brightness = corgibl_get_intensity,
-	.update_status  = corgibl_set_intensity,
-};
-
 static int corgibl_probe(struct platform_device *pdev)
 {
 	struct corgibl_machinfo *machinfo = pdev->dev.platform_data;
-
-	bl_machinfo = machinfo;
-	corgibl_data.max_brightness = machinfo->max_intensity;
+	struct corgibl_info *info;
+	char name[16];
+	int ret;
+
+	info = kmalloc(sizeof(struct corgibl_info), GFP_KERNEL);
+	if (IS_ERR(info))
+		return -ENOMEM;
+	memset(info, 0, sizeof(struct corgibl_info));
+	info->props.owner = THIS_MODULE;
+	info->props.get_brightness = corgibl_get_intensity;
+	info->props.update_status  = corgibl_set_intensity;
+	mutex_init(&info->mutex);
+
+	info->machinfo = machinfo;
+	info->props.max_brightness = machinfo->max_intensity;
 	if (!machinfo->limit_mask)
 		machinfo->limit_mask = -1;
 
-	corgi_backlight_device = backlight_device_register ("corgi-bl",
-		&pdev->dev, NULL, &corgibl_data);
-	if (IS_ERR (corgi_backlight_device))
-		return PTR_ERR (corgi_backlight_device);
+	snprintf(name, sizeof(name), "corgi-bl%d", pdev->id);
+	info->bd = backlight_device_register (name,
+		&pdev->dev, info, &info->props);
+	if (IS_ERR (info->bd)) {
+		ret = PTR_ERR(info->bd);
+		goto error;
+	}
 
-	corgibl_data.power = FB_BLANK_UNBLANK;
-	corgibl_data.brightness = machinfo->default_intensity;
-	corgibl_send_intensity(corgi_backlight_device);
+	info->props.power = FB_BLANK_UNBLANK;
+	info->props.brightness = machinfo->default_intensity;
+	corgibl_send_intensity(info->bd);
 
-	printk("Corgi Backlight Driver Initialized.\n");
+	platform_set_drvdata(pdev, info);
+
+	printk("Corgi Backlight Driver Initialized (%s).\n", name);
 	return 0;
+
+error:
+	kfree(info);
+	return ret;
 }
 
-static int corgibl_remove(struct platform_device *dev)
+static int corgibl_remove(struct platform_device *pdev)
 {
-	corgibl_data.power = 0;
-	corgibl_data.brightness = 0;
-	corgibl_send_intensity(corgi_backlight_device);
+	struct corgibl_info *info = platform_get_drvdata(pdev);
+	info->props.power = 0;
+	info->props.brightness = 0;
+	corgibl_send_intensity(info->bd);
+
+	backlight_device_unregister(info->bd);
 
-	backlight_device_unregister(corgi_backlight_device);
+	kfree(info);
 
 	printk("Corgi Backlight Driver Unloaded\n");
 	return 0;
diff --git a/include/linux/corgi_bl.h b/include/linux/corgi_bl.h
index 079fe65..2c6d0c4 100644
--- a/include/linux/corgi_bl.h
+++ b/include/linux/corgi_bl.h
@@ -1,10 +1,26 @@
 /*
  * Generic Backlight, from sharpsl.h
  */
+#include <linux/mutex.h>
+
 struct corgibl_machinfo {
 	int max_intensity;
 	int default_intensity;
 	int limit_mask;
 	void (*set_bl_intensity)(int intensity);
 };
-extern void corgibl_limit_intensity(int limit);
+extern void corgibl_limit_intensity(struct backlight_device *bd, int limit);
+
+struct corgibl_info {
+	int intensity;
+	struct mutex mutex;
+	struct backlight_properties props;
+	struct backlight_device *bd;
+	struct corgibl_machinfo *machinfo;
+
+	unsigned long flags;
+#define CORGIBL_SUSPENDED     0x01
+#define CORGIBL_BATTLOW       0x02
+};
+
+#define to_backlight_info(_p) container_of(_p, struct corgibl_info, props) 

--owPIoVL9FiqC4k42--
