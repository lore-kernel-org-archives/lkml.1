Return-Path: <linux-kernel-owner+w=401wt.eu-S1756772AbYA0Kn1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756772AbYA0Kn1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 05:43:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753287AbYA0KnT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 05:43:19 -0500
Received: from mx02.qsc.de ([213.148.130.14]:54322 "EHLO mx02.qsc.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751831AbYA0KnR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 05:43:17 -0500
X-Greylist: delayed 1345 seconds by postgrey-1.27 at vger.kernel.org; Sun, 27 Jan 2008 05:43:16 EST
From: =?iso-8859-1?q?Ren=E9_Rebe?= <rene@exactcode.de>
Organization: ExactCODE
To: Nicolas Boichat <nicolas@boichat.ch>
Subject: [PATCH] applesmc case led and SCSI LED activity trigger
Date: Sun, 27 Jan 2008 11:20:46 +0100
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200801271120.46240.rene@exactcode.de>
X-Spam-Score: -2.3 (--)
X-Spam-Report: Spam detection software, running on the system "exactcode.de", has
	identified this incoming email as possible spam.  The original message
	has been attached to this so you can view it (if it isn't spam) or label
	similar future email.  If you have any questions, see
	the administrator of that system for details.
	Content preview:  Hi all, Nicolas: Do you still have your modified applesmc
	driver for OS X and could trace which key OS X tweaks when the screensaver
	switches the display off and lights the case LED to indicate the machine
	is still alife? Would be best to use the same key but with some quick pokes
	I did not found it last night. [...] 
	Content analysis details:   (-2.3 points, 5.0 required)
	pts rule name              description
	---- ---------------------- --------------------------------------------------
	-1.5 ALL_TRUSTED            Passed through trusted hosts only via SMTP
	-2.6 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	1.8 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Nicolas: Do you still have your modified applesmc driver for OS X
and could trace which key OS X tweaks when the screensaver
switches the display off and lights the case LED to indicate the
machine is still alife? Would be best to use the same key but
with some quick pokes I did not found it last night.


Please find below a modification for the applesmc to allow controlling
the system's case LED, e.g. to indicate disk access as Linux allows
for the former PowerPC based books as well.

If anyone knows a better SMC key to control the light please let me
know (this key appears to rise the off level and was the only one I
found working last night).

Also, please let me know if the SCSI activity trigger is at the right place
as right now there only is the IDE trigger I could get inspiration from
(I reused the IDE trigger, maybe we could just rename it to disk?).

That said, it works for me on a MacBook Pro, but I could also test
on a normal MacBook as well as a Mac Pro later in the office.

The patch touched the existing backlight related variables and
function naming intetionally for consistency.

Signed-off-by: René Rebe <rene@exactcode.de>

--- ./drivers/hwmon/applesmc.c.orig	2008-01-26 21:04:43.000000000 +0100
+++ ./drivers/hwmon/applesmc.c	2008-01-26 21:22:36.000000000 +0100
@@ -63,6 +63,8 @@
 
 #define CLAMSHELL_KEY 		"MSLD" /* r-o ui8 (unused) */
 
+#define LED_KEY			"LSLF" /* r-w ui16 */
+
 #define MOTION_SENSOR_X_KEY	"MO_X" /* r-o sp78 (2 bytes) */
 #define MOTION_SENSOR_Y_KEY	"MO_Y" /* r-o sp78 (2 bytes) */
 #define MOTION_SENSOR_Z_KEY	"MO_Z" /* r-o sp78 (2 bytes) */
@@ -152,7 +154,7 @@
  */
 static unsigned int key_at_index;
 
-static struct workqueue_struct *applesmc_led_wq;
+static struct workqueue_struct *applesmc_led_wq, *applesmc_backlight_wq;
 
 /*
  * __wait_status - Wait up to 2ms for the status port to get a certain value
@@ -760,18 +762,45 @@
 }
 static DECLARE_WORK(backlight_work, &applesmc_backlight_set);
 
-static void applesmc_brightness_set(struct led_classdev *led_cdev,
-						enum led_brightness value)
+static void applesmc_backlight_brightness_set(struct led_classdev *led_cdev,
+					      enum led_brightness value)
 {
 	int ret;
 
 	backlight_value = value;
-	ret = queue_work(applesmc_led_wq, &backlight_work);
+	ret = queue_work(applesmc_backlight_wq, &backlight_work);
 
 	if (debug && (!ret))
 		printk(KERN_DEBUG "applesmc: work was already on the queue.\n");
 }
 
+/* Store the next LED value to be written by the work */
+static unsigned int led_value;
+
+static void applesmc_led_set(struct work_struct *work)
+{
+	u8 buffer[2];
+
+	mutex_lock(&applesmc_lock);
+	buffer[0] = led_value;
+	buffer[1] = 0x00;
+	applesmc_write_key(LED_KEY, buffer, 2);
+	mutex_unlock(&applesmc_lock);
+}
+static DECLARE_WORK(led_work, &applesmc_led_set);
+
+static void applesmc_led_brightness_set(struct led_classdev *led_cdev,
+					 enum led_brightness value)
+{
+	int ret;
+
+	led_value = value;
+	ret = queue_work(applesmc_led_wq, &led_work);
+
+	if (debug && (!ret))
+		printk(KERN_DEBUG "applesmc: work was already on the queue.\n");
+}
+
 static ssize_t applesmc_key_count_show(struct device *dev,
 				struct device_attribute *attr, char *sysfsbuf)
 {
@@ -923,10 +952,16 @@
 	return count;
 }
 
+static struct led_classdev applesmc_led = {
+	.name			= "smc:case-led",
+	.default_trigger	= "ide-disk",
+	.brightness_set		= applesmc_led_brightness_set,
+};
+
 static struct led_classdev applesmc_backlight = {
-	.name			= "smc:kbd_backlight",
-	.default_trigger	= "nand-disk",
-	.brightness_set		= applesmc_brightness_set,
+	.name			= "smc:kbd_backlight",
+	.default_trigger	= "nand-disk",
+	.brightness_set		= applesmc_backlight_brightness_set,
 };
 
 static DEVICE_ATTR(name, 0444, applesmc_name_show, NULL);
@@ -1363,15 +1398,28 @@
 			goto out_temperature;
 	}
 
+        /* Create the workqueue */
+        applesmc_led_wq = create_singlethread_workqueue("applesmc-led");
+        if (!applesmc_led_wq) {
+                ret = -ENOMEM;
+                goto out_accelerometer;
+        }
+
+        /* register as a led device */
+        ret = led_classdev_register(&pdev->dev, &applesmc_led);
+        if (ret < 0)
+                goto out_led_wq;
+
+
 	if (applesmc_light) {
 		/* Add light sensor file */
 		ret = sysfs_create_file(&pdev->dev.kobj, &dev_attr_light.attr);
 		if (ret)
-			goto out_accelerometer;
+			goto out_led_ledclass;
 
 		/* Create the workqueue */
-		applesmc_led_wq = create_singlethread_workqueue("applesmc-led");
-		if (!applesmc_led_wq) {
+		applesmc_backlight_wq = create_singlethread_workqueue("applesmc-backlight");
+		if (!applesmc_backlight_wq) {
 			ret = -ENOMEM;
 			goto out_light_sysfs;
 		}
@@ -1397,10 +1445,14 @@
 		led_classdev_unregister(&applesmc_backlight);
 out_light_wq:
 	if (applesmc_light)
-		destroy_workqueue(applesmc_led_wq);
+		destroy_workqueue(applesmc_backlight_wq);
 out_light_sysfs:
 	if (applesmc_light)
 		sysfs_remove_file(&pdev->dev.kobj, &dev_attr_light.attr);
+out_led_ledclass:
+        led_classdev_unregister(&applesmc_led);
+out_led_wq:
+        destroy_workqueue(applesmc_led_wq);
 out_accelerometer:
 	if (applesmc_accelerometer)
 		applesmc_release_accelerometer();
--- ./drivers/scsi/sd.c.orig	2008-01-26 22:04:06.000000000 +0100
+++ ./drivers/scsi/sd.c	2008-01-26 22:02:08.000000000 +0100
@@ -60,6 +60,8 @@
 #include <scsi/scsicam.h>
 #include <scsi/sd.h>
 
+#include <linux/leds.h>
+
 #include "scsi_logging.h"
 
 MODULE_AUTHOR("Eric Youngdale");
@@ -907,6 +909,8 @@
 	int sense_deferred = 0;
 	int info_valid;
 
+	ledtrig_ide_activity();
+
 	if (result) {
 		sense_valid = scsi_command_normalize_sense(SCpnt, &sshdr);
 		if (sense_valid)


-- 
  René Rebe - ExactCODE GmbH - Europe, Germany, Berlin
  Geschäftsführer: Susanne Klaus, René Rebe
  Sitz: Berlin, Amtsgericht Charlottenburg HRB 105 123 B
  USt-IdNr.: DE251602478
  http://exactcode.de | http://t2-project.org | http://rene.rebe.name
