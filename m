Return-Path: <linux-kernel-owner+w=401wt.eu-S933054AbXDINzB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933054AbXDINzB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 09:55:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933058AbXDINzA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 09:55:00 -0400
Received: from 42.mail-out.ovh.net ([213.251.189.42]:57839 "HELO
	42.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933054AbXDINy7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 09:54:59 -0400
Message-ID: <461A455C.9040508@boichat.ch>
Date: Mon, 09 Apr 2007 21:53:32 +0800
From: Nicolas Boichat <nicolas@boichat.ch>
User-Agent: Thunderbird 1.5.0.10 (X11/20070309)
MIME-Version: 1.0
To: Dmitry Torokhov <dtor@insightbb.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       lm-sensors@lm-sensors.org, rlove@rlove.org, linux-kernel@hansmi.ch
Subject: [PATCH] Apple SMC driver - fix input device
References: <45F7C083.7090504@boichat.ch> <45FE1D44.8000805@boichat.ch> <200703221137.35906.dtor@insightbb.com>
In-Reply-To: <200703221137.35906.dtor@insightbb.com>
X-Enigmail-Version: 0.94.3.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Ovh-Remote: 137.132.232.72 (nusnet-232-72.dynip.nus.edu.sg)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|H 0.5/N
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry,

Sorry I did not receive your message originally, someone else pointed it
to me recently, and I recovered it from LKML archives.

Dmitry Torokhov wrote:
> Hi Nicolas,
>
> On Monday 19 March 2007 01:19, Nicolas Boichat wrote:
>   
>> +       /* initialize the input class */
>> +       applesmc_idev->name = "applesmc";
>>     
>
> You may want to set applesmc_idev->id.bus = BUS_HOST;
>
>   
>> +       applesmc_idev->cdev.dev = &pdev->dev;
>> +       applesmc_idev->evbit[0] = BIT(EV_ABS);
>> +       input_set_abs_params(applesmc_idev, ABS_X,
>> +                       -256, 256, APPLESMC_INPUT_FUZZ, APPLESMC_INPUT_FLAT);
>> +       input_set_abs_params(applesmc_idev, ABS_Y,
>> +                       -256, 256, APPLESMC_INPUT_FUZZ, APPLESMC_INPUT_FLAT);
>> +
>> +       input_register_device(applesmc_idev);
>>     
>
> Please add error hanling here.
>
>   
>> +
>> +       /* start up our timer for the input device */
>> +       init_timer(&applesmc_timer);
>> +       applesmc_timer.function = applesmc_mousedev_poll;
>> +       applesmc_timer.expires = jiffies + APPLESMC_POLL_PERIOD;
>> +       add_timer(&applesmc_timer);
>>
>>     
>
> Please consider implemention open and close methods for the input
> device and start/stop timer from there - there is no point of checking
> hardware state if noone is listening to events. 
>   

Fixed all these. Thanks.

Andrew, could you please push this patch in mm too?

Best regards,

Nicolas

- Invert y axis on input device.
- Only activate the input device polling timer when the device is open.
- Others minor fixes asked by Dmitry Torokhov.

Signed-off-by: Nicolas Boichat <nicolas@boichat.ch>


---

 drivers/hwmon/applesmc.c |   29 +++++++++++++++++++++++++----
 1 files changed, 25 insertions(+), 4 deletions(-)

diff --git a/drivers/hwmon/applesmc.c b/drivers/hwmon/applesmc.c
index 4060667..f7b59fc 100644
--- a/drivers/hwmon/applesmc.c
+++ b/drivers/hwmon/applesmc.c
@@ -349,9 +349,22 @@ static void applesmc_calibrate(void)
 {
 	applesmc_read_motion_sensor(SENSOR_X, &rest_x);
 	applesmc_read_motion_sensor(SENSOR_Y, &rest_y);
+	rest_x = -rest_x;
 }
 
-static void applesmc_mousedev_poll(unsigned long unused)
+static int applesmc_idev_open(struct input_dev *dev)
+{
+	add_timer(&applesmc_timer);
+
+	return 0;
+}
+
+static void applesmc_idev_close(struct input_dev *dev)
+{
+	del_timer_sync(&applesmc_timer);
+}
+
+static void applesmc_idev_poll(unsigned long unused)
 {
 	s16 x, y;
 
@@ -366,6 +379,7 @@ static void applesmc_mousedev_poll(unsigned long unused)
 	if (applesmc_read_motion_sensor(SENSOR_Y, &y))
 		goto out;
 
+	x = -x;
 	input_report_abs(applesmc_idev, ABS_X, x - rest_x);
 	input_report_abs(applesmc_idev, ABS_Y, y - rest_y);
 	input_sync(applesmc_idev);
@@ -739,23 +753,30 @@ static int applesmc_create_accelerometer(void)
 
 	/* initialize the input class */
 	applesmc_idev->name = "applesmc";
+	applesmc_idev->id.bustype = BUS_HOST;
 	applesmc_idev->cdev.dev = &pdev->dev;
 	applesmc_idev->evbit[0] = BIT(EV_ABS);
+	applesmc_idev->open = applesmc_idev_open;
+	applesmc_idev->close = applesmc_idev_close;
 	input_set_abs_params(applesmc_idev, ABS_X,
 			-256, 256, APPLESMC_INPUT_FUZZ, APPLESMC_INPUT_FLAT);
 	input_set_abs_params(applesmc_idev, ABS_Y,
 			-256, 256, APPLESMC_INPUT_FUZZ, APPLESMC_INPUT_FLAT);
 
-	input_register_device(applesmc_idev);
+	ret = input_register_device(applesmc_idev);
+	if (ret)
+		goto out_idev;
 
 	/* start up our timer for the input device */
 	init_timer(&applesmc_timer);
-	applesmc_timer.function = applesmc_mousedev_poll;
+	applesmc_timer.function = applesmc_idev_poll;
 	applesmc_timer.expires = jiffies + APPLESMC_POLL_PERIOD;
-	add_timer(&applesmc_timer);
 
 	return 0;
 
+out_idev:
+	input_free_device(applesmc_idev);
+
 out:
 	printk(KERN_WARNING "applesmc: driver init failed (ret=%d)!\n", ret);
 	return ret;


