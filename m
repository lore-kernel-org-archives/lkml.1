Return-Path: <linux-kernel-owner+w=401wt.eu-S1757201AbXELFM7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757201AbXELFM7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2007 01:12:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755309AbXELFMw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 May 2007 01:12:52 -0400
Received: from gateway.insightbb.com ([74.128.0.19]:20181 "EHLO
	asav02.insightbb.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755200AbXELFMv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2007 01:12:51 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhQuAPTpREZKhRO4W2dsb2JhbACPdh0NBREB
From: Dmitry Torokhov <dtor@insightbb.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.21-mm2: HDAPS? BUG: at kernel/mutex.c:311
Date: Sat, 12 May 2007 01:12:52 -0400
User-Agent: KMail/1.9.3
Cc: Matt Mackall <mpm@selenic.com>, rlove@rlove.org,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
References: <20070512002115.GZ11166@waste.org> <20070511175335.092aa0af.akpm@linux-foundation.org>
In-Reply-To: <20070511175335.092aa0af.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200705120112.52859.dtor@insightbb.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 11 May 2007 20:53, Andrew Morton wrote:
> Ho hum.  I suppose a suitable workaround would be to convert hdaps_mtx back
> into a semaphore.  ug.

Actually I was looking for victimes^Wvolunteers to test the patch below.
It gets rid of _trylock business.

-- 
Dmitry

HWMON: hdaps - convert to use input-polldev

Switch to using input-polldev skeleton instead of implementing
polling loop by itself.

Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---

 drivers/hwmon/Kconfig |    1 
 drivers/hwmon/hdaps.c |   55 +++++++++++++++++++++-----------------------------
 2 files changed, 25 insertions(+), 31 deletions(-)

Index: work/drivers/hwmon/Kconfig
===================================================================
--- work.orig/drivers/hwmon/Kconfig
+++ work/drivers/hwmon/Kconfig
@@ -602,6 +602,7 @@ config SENSORS_W83627EHF
 config SENSORS_HDAPS
 	tristate "IBM Hard Drive Active Protection System (hdaps)"
 	depends on INPUT && X86
+	select INPUT_POLLDEV
 	default n
 	help
 	  This driver provides support for the IBM Hard Drive Active Protection
Index: work/drivers/hwmon/hdaps.c
===================================================================
--- work.orig/drivers/hwmon/hdaps.c
+++ work/drivers/hwmon/hdaps.c
@@ -28,7 +28,7 @@
 
 #include <linux/delay.h>
 #include <linux/platform_device.h>
-#include <linux/input.h>
+#include <linux/input-polldev.h>
 #include <linux/kernel.h>
 #include <linux/mutex.h>
 #include <linux/module.h>
@@ -61,13 +61,12 @@
 #define INIT_TIMEOUT_MSECS	4000	/* wait up to 4s for device init ... */
 #define INIT_WAIT_MSECS		200	/* ... in 200ms increments */
 
-#define HDAPS_POLL_PERIOD	(HZ/20)	/* poll for input every 1/20s */
+#define HDAPS_POLL_INTERVAL	50	/* poll for input every 1/20s (50 ms)*/
 #define HDAPS_INPUT_FUZZ	4	/* input event threshold */
 #define HDAPS_INPUT_FLAT	4
 
-static struct timer_list hdaps_timer;
 static struct platform_device *pdev;
-static struct input_dev *hdaps_idev;
+static struct input_polled_dev *hdaps_idev;
 static unsigned int hdaps_invert;
 static u8 km_activity;
 static int rest_x;
@@ -323,24 +322,19 @@ static void hdaps_calibrate(void)
 	__hdaps_read_pair(HDAPS_PORT_XPOS, HDAPS_PORT_YPOS, &rest_x, &rest_y);
 }
 
-static void hdaps_mousedev_poll(unsigned long unused)
+static void hdaps_mousedev_poll(struct input_polled_dev *dev)
 {
+	struct input_dev *input_dev = dev->input;
 	int x, y;
 
-	/* Cannot sleep.  Try nonblockingly.  If we fail, try again later. */
-	if (mutex_trylock(&hdaps_mtx)) {
-		mod_timer(&hdaps_timer,jiffies + HDAPS_POLL_PERIOD);
-		return;
-	}
+	mutex_lock(&hdaps_mtx);
 
 	if (__hdaps_read_pair(HDAPS_PORT_XPOS, HDAPS_PORT_YPOS, &x, &y))
 		goto out;
 
-	input_report_abs(hdaps_idev, ABS_X, x - rest_x);
-	input_report_abs(hdaps_idev, ABS_Y, y - rest_y);
-	input_sync(hdaps_idev);
-
-	mod_timer(&hdaps_timer, jiffies + HDAPS_POLL_PERIOD);
+	input_report_abs(input_dev, ABS_X, x - rest_x);
+	input_report_abs(input_dev, ABS_Y, y - rest_y);
+	input_sync(input_dev);
 
 out:
 	mutex_unlock(&hdaps_mtx);
@@ -536,6 +530,7 @@ static struct dmi_system_id __initdata h
 
 static int __init hdaps_init(void)
 {
+	struct input_dev *idev;
 	int ret;
 
 	if (!dmi_check_system(hdaps_whitelist)) {
@@ -563,39 +558,37 @@ static int __init hdaps_init(void)
 	if (ret)
 		goto out_device;
 
-	hdaps_idev = input_allocate_device();
+	hdaps_idev = input_allocate_polled_device();
 	if (!hdaps_idev) {
 		ret = -ENOMEM;
 		goto out_group;
 	}
 
+	hdaps_idev->poll = hdaps_mousedev_poll;
+	hdaps_idev->poll_interval = HDAPS_POLL_INTERVAL;
+
 	/* initial calibrate for the input device */
 	hdaps_calibrate();
 
 	/* initialize the input class */
-	hdaps_idev->name = "hdaps";
-	hdaps_idev->dev.parent = &pdev->dev;
-	hdaps_idev->evbit[0] = BIT(EV_ABS);
-	input_set_abs_params(hdaps_idev, ABS_X,
+	idev = hdaps_idev->input;
+	idev->name = "hdaps";
+	idev->dev.parent = &pdev->dev;
+	idev->evbit[0] = BIT(EV_ABS);
+	input_set_abs_params(idev, ABS_X,
 			-256, 256, HDAPS_INPUT_FUZZ, HDAPS_INPUT_FLAT);
-	input_set_abs_params(hdaps_idev, ABS_Y,
+	input_set_abs_params(idev, ABS_Y,
 			-256, 256, HDAPS_INPUT_FUZZ, HDAPS_INPUT_FLAT);
 
-	ret = input_register_device(hdaps_idev);
+	ret = input_register_polled_device(hdaps_idev);
 	if (ret)
 		goto out_idev;
 
-	/* start up our timer for the input device */
-	init_timer(&hdaps_timer);
-	hdaps_timer.function = hdaps_mousedev_poll;
-	hdaps_timer.expires = jiffies + HDAPS_POLL_PERIOD;
-	add_timer(&hdaps_timer);
-
 	printk(KERN_INFO "hdaps: driver successfully loaded.\n");
 	return 0;
 
 out_idev:
-	input_free_device(hdaps_idev);
+	input_free_polled_device(hdaps_idev);
 out_group:
 	sysfs_remove_group(&pdev->dev.kobj, &hdaps_attribute_group);
 out_device:
@@ -611,8 +604,8 @@ out:
 
 static void __exit hdaps_exit(void)
 {
-	del_timer_sync(&hdaps_timer);
-	input_unregister_device(hdaps_idev);
+	input_unregister_polled_device(hdaps_idev);
+	input_free_polled_device(hdaps_idev);
 	sysfs_remove_group(&pdev->dev.kobj, &hdaps_attribute_group);
 	platform_device_unregister(pdev);
 	platform_driver_unregister(&hdaps_driver);
