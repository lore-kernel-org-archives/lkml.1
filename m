Return-Path: <linux-kernel-owner+w=401wt.eu-S1755298AbZEUJfq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755298AbZEUJfq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 05:35:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752792AbZEUJe4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 05:34:56 -0400
Received: from mailservice.tudelft.nl ([130.161.131.5]:26635 "EHLO
	mailservice.tudelft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753341AbZEUJey (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 05:34:54 -0400
X-Spam-Flag: NO
X-Spam-Score: -12.589
Message-ID: <4A151F87.3020408@tremplin-utc.net>
Date: Thu, 21 May 2009 11:31:51 +0200
From: =?UTF-8?B?w4lyaWMgUGllbA==?= <eric.piel@tremplin-utc.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.21) Gecko/20090319 Mandriva/2.0.0.21-1mdv2009.1 (2009.1) Thunderbird/2.0.0.21 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>
Subject: [PATCH 3/4] lis3: use input_polled_device
References: <4A151E9F.1080405@tremplin-utc.net>
In-Reply-To: <4A151E9F.1080405@tremplin-utc.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that there is no need to hookup on the open/close of the joystick,
it's possible to use the simplified interface input_polled_device,
instead of creating our own kthread.

Signed-off-by: Éric Piel <eric.piel@tremplin-utc.net>
---
 drivers/hwmon/hp_accel.c  |    3 --
 drivers/hwmon/lis3lv02d.c |   74 ++++++++++++++------------------------------
 drivers/hwmon/lis3lv02d.h |    5 ++-
 3 files changed, 27 insertions(+), 55 deletions(-)

diff --git a/drivers/hwmon/hp_accel.c b/drivers/hwmon/hp_accel.c
index 0ebd009..92db68e 100644
--- a/drivers/hwmon/hp_accel.c
+++ b/drivers/hwmon/hp_accel.c
@@ -27,9 +27,6 @@
 #include <linux/types.h>
 #include <linux/platform_device.h>
 #include <linux/interrupt.h>
-#include <linux/input.h>
-#include <linux/kthread.h>
-#include <linux/semaphore.h>
 #include <linux/delay.h>
 #include <linux/wait.h>
 #include <linux/poll.h>
diff --git a/drivers/hwmon/lis3lv02d.c b/drivers/hwmon/lis3lv02d.c
index df3f586..3661906 100644
--- a/drivers/hwmon/lis3lv02d.c
+++ b/drivers/hwmon/lis3lv02d.c
@@ -27,9 +27,7 @@
 #include <linux/types.h>
 #include <linux/platform_device.h>
 #include <linux/interrupt.h>
-#include <linux/input.h>
-#include <linux/kthread.h>
-#include <linux/semaphore.h>
+#include <linux/input-polldev.h>
 #include <linux/delay.h>
 #include <linux/wait.h>
 #include <linux/poll.h>
@@ -270,43 +268,16 @@ static struct miscdevice lis3lv02d_misc_device = {
 	.fops    = &lis3lv02d_misc_fops,
 };
 
-/**
- * lis3lv02d_joystick_kthread - Kthread polling function
- * @data: unused - here to conform to threadfn prototype
- */
-static int lis3lv02d_joystick_kthread(void *data)
+static void lis3lv02d_joystick_poll(struct input_polled_dev *pidev)
 {
 	int x, y, z;
 
-	while (!kthread_should_stop()) {
-		lis3lv02d_get_xyz(&lis3_dev, &x, &y, &z);
-		input_report_abs(lis3_dev.idev, ABS_X, x - lis3_dev.xcalib);
-		input_report_abs(lis3_dev.idev, ABS_Y, y - lis3_dev.ycalib);
-		input_report_abs(lis3_dev.idev, ABS_Z, z - lis3_dev.zcalib);
-
-		input_sync(lis3_dev.idev);
-
-		try_to_freeze();
-		msleep_interruptible(MDPS_POLL_INTERVAL);
-	}
-
-	return 0;
-}
-
-static int lis3lv02d_joystick_open(struct input_dev *input)
-{
-	lis3_dev.kthread = kthread_run(lis3lv02d_joystick_kthread, NULL, "klis3lv02d");
-	if (IS_ERR(lis3_dev.kthread)) {
-		return PTR_ERR(lis3_dev.kthread);
-	}
-
-	return 0;
+	lis3lv02d_get_xyz(&lis3_dev, &x, &y, &z);
+	input_report_abs(pidev->input, ABS_X, x - lis3_dev.xcalib);
+	input_report_abs(pidev->input, ABS_Y, y - lis3_dev.ycalib);
+	input_report_abs(pidev->input, ABS_Z, z - lis3_dev.zcalib);
 }
 
-static void lis3lv02d_joystick_close(struct input_dev *input)
-{
-	kthread_stop(lis3_dev.kthread);
-}
 
 static inline void lis3lv02d_calibrate_joystick(void)
 {
@@ -316,33 +287,36 @@ static inline void lis3lv02d_calibrate_joystick(void)
 
 int lis3lv02d_joystick_enable(void)
 {
+	struct input_dev *input_dev;
 	int err;
 
 	if (lis3_dev.idev)
 		return -EINVAL;
 
-	lis3_dev.idev = input_allocate_device();
+	lis3_dev.idev = input_allocate_polled_device();
 	if (!lis3_dev.idev)
 		return -ENOMEM;
 
+	lis3_dev.idev->poll = lis3lv02d_joystick_poll;
+	lis3_dev.idev->poll_interval = MDPS_POLL_INTERVAL;
+	input_dev = lis3_dev.idev->input;
+
 	lis3lv02d_calibrate_joystick();
 
-	lis3_dev.idev->name       = "ST LIS3LV02DL Accelerometer";
-	lis3_dev.idev->phys       = DRIVER_NAME "/input0";
-	lis3_dev.idev->id.bustype = BUS_HOST;
-	lis3_dev.idev->id.vendor  = 0;
-	lis3_dev.idev->dev.parent = &lis3_dev.pdev->dev;
-	lis3_dev.idev->open       = lis3lv02d_joystick_open;
-	lis3_dev.idev->close      = lis3lv02d_joystick_close;
+	input_dev->name       = "ST LIS3LV02DL Accelerometer";
+	input_dev->phys       = DRIVER_NAME "/input0";
+	input_dev->id.bustype = BUS_HOST;
+	input_dev->id.vendor  = 0;
+	input_dev->dev.parent = &lis3_dev.pdev->dev;
 
-	set_bit(EV_ABS, lis3_dev.idev->evbit);
-	input_set_abs_params(lis3_dev.idev, ABS_X, -lis3_dev.mdps_max_val, lis3_dev.mdps_max_val, 3, 3);
-	input_set_abs_params(lis3_dev.idev, ABS_Y, -lis3_dev.mdps_max_val, lis3_dev.mdps_max_val, 3, 3);
-	input_set_abs_params(lis3_dev.idev, ABS_Z, -lis3_dev.mdps_max_val, lis3_dev.mdps_max_val, 3, 3);
+	set_bit(EV_ABS, input_dev->evbit);
+	input_set_abs_params(input_dev, ABS_X, -lis3_dev.mdps_max_val, lis3_dev.mdps_max_val, 3, 3);
+	input_set_abs_params(input_dev, ABS_Y, -lis3_dev.mdps_max_val, lis3_dev.mdps_max_val, 3, 3);
+	input_set_abs_params(input_dev, ABS_Z, -lis3_dev.mdps_max_val, lis3_dev.mdps_max_val, 3, 3);
 
-	err = input_register_device(lis3_dev.idev);
+	err = input_register_polled_device(lis3_dev.idev);
 	if (err) {
-		input_free_device(lis3_dev.idev);
+		input_free_polled_device(lis3_dev.idev);
 		lis3_dev.idev = NULL;
 	}
 
@@ -357,7 +331,7 @@ void lis3lv02d_joystick_disable(void)
 
 	if (lis3_dev.irq)
 		misc_deregister(&lis3lv02d_misc_device);
-	input_unregister_device(lis3_dev.idev);
+	input_unregister_polled_device(lis3_dev.idev);
 	lis3_dev.idev = NULL;
 }
 EXPORT_SYMBOL_GPL(lis3lv02d_joystick_disable);
diff --git a/drivers/hwmon/lis3lv02d.h b/drivers/hwmon/lis3lv02d.h
index b007d81..5a5a196 100644
--- a/drivers/hwmon/lis3lv02d.h
+++ b/drivers/hwmon/lis3lv02d.h
@@ -18,6 +18,8 @@
  *  along with this program; if not, write to the Free Software
  *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
+#include <linux/platform_device.h>
+#include <linux/input-polldev.h>
 
 /*
  * The actual chip is STMicroelectronics LIS3LV02DL or LIS3LV02DQ that seems to
@@ -169,8 +171,7 @@ struct lis3lv02d {
 	s16 (*read_data) (struct lis3lv02d *lis3, int reg);
 	int			mdps_max_val;
 
-	struct input_dev	*idev;     /* input device */
-	struct task_struct	*kthread;  /* kthread for input */
+	struct input_polled_dev	*idev;     /* input device */
 	struct platform_device	*pdev;     /* platform device */
 	atomic_t		count;     /* interrupt count after last read */
 	int			xcalib;    /* calibrated null value for x */
-- 
1.6.2.4


