Return-Path: <linux-kernel-owner+w=401wt.eu-S1161194AbXDNNjZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161194AbXDNNjZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2007 09:39:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030842AbXDNNjZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Apr 2007 09:39:25 -0400
Received: from 27.mail-out.ovh.net ([213.186.38.137]:43998 "HELO
	27.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1030403AbXDNNjY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2007 09:39:24 -0400
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Sat, 14 Apr 2007 09:39:24 EDT
Message-ID: <4620D7C9.8040303@boichat.ch>
Date: Sat, 14 Apr 2007 21:31:53 +0800
From: Nicolas Boichat <nicolas@boichat.ch>
User-Agent: Thunderbird 1.5.0.10 (X11/20070309)
MIME-Version: 1.0
To: Richard Purdie <rpurdie@rpsys.net>,
       Andrew Morton <akpm@linux-foundation.org>
CC: Bradley Hook <bdhook@gmail.com>, mactel-linux-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: [PATCH] applesmc - fix crash when activating a led trigger on the
 keyboard backlight - use a workqueue
References: <45F7C083.7090504@boichat.ch>	 <b6c5339f0703191443l5f8c5271pf43ea62e0c79a614@mail.gmail.com>	 <45FF86F6.7050200@boichat.ch>	 <eb4a44160703200016i74786682n41f87f3d88f90409@mail.gmail.com>	 <46208B40.1060809@boichat.ch> <1176540311.6818.9.camel@localhost.localdomain>
In-Reply-To: <1176540311.6818.9.camel@localhost.localdomain>
X-Enigmail-Version: 0.94.3.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Ovh-Remote: 137.132.199.102 ()
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|H 0.5/N
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi again,

Richard Purdie wrote:
> Hi,
>
> On Sat, 2007-04-14 at 16:05 +0800, Nicolas Boichat wrote:
>   
>> Bradley Hook wrote:
>>     
>>> Slightly off-topic, but I've been experiencing a minor bug in the
>>> keyboard backlight feature.
>>>
>>> I say it is "minor" only because the feature serves no real functional
>>> purpose. You can activate a trigger called "heartbeat" that will cause
>>> the keyboard light to pulse at a speed based on the CPU usage. On my
>>> MBP17, after activating this trigger the machine will either lock-up
>>> or core dump within about a minute (timing is not consistent).
>>>   
>>>       
>> This is caused by the fact applesmc_backlight_set locks a mutex (or more
>> precisely sleeps while trying to lock a mutex) while being in a softirq
>> context.
>>
>> This might be obvious for others, but it was not for me, and there is
>> absolutely no mention in the documentation of the fact it is not always
>> safe to sleep in the brightness_set handler of a led_class device (it is
>> safe when it is called because someone wrote to the brightness sysfs file).
>>     
>
> Its never safe for a brightness_set handler to sleep. They're designed
> to be called from interrupt context and as you've noted, several
> triggers do that.
>
> The solution if you have locks like your case is to offload the work to
> a workqueue, there is simply no other way to do it.
>   

Ok, I used a workqueue. Andrew, please ignore the previous patch
("[PATCH] applesmc - fix crash when activating a led trigger on the
keyboard backlight"), and use this one instead, thanks.


> I'll have a look to see if I can improve the documentation (patches
> welcome).
>
>   
>> Also, the led-trigger code seems buggy when it comes to locking. Setting
>> CONFIG_DEBUG_SPINLOCK_SLEEP causes a lot a warnings. The problem is that
>> the list of triggers is locked using a rw spinlock, but the rest of the
>> code seems to ignore that, and calls a lot of functions which can sleep
>> (kzalloc with GFP_KERNEL, sysfs_add_file, mutex_lock, etc...). I think
>> the list lock should be converted to a mutex (or maybe modified to use
>> RCU). I'm not very experienced in that domain, but if you want I can
>> provide a patch for this.
>>     
>
> Someone else has mentioned this within the past few days and there is a
> problem with the trigger->activate and ->deactivate calls occurring
> within a spinlock. Its not a simple problem to solve unfortunately and
> you can't just convert to a mutex but I'm looking at it. Again, patches
> welcome but its going to need careful thought.
>   

Ok you know your code better so maybe it's easier and better if you do
it. I'll tell you if I suddenly decide to work on that, so we don't
duplicate our work.

Best regards,

Nicolas

- Cannot sleep in led->brightness_set handler, as it might be called from a
softirq, so we use a workqueue to change the brightness (as recommended by
Richard Purdie)
- Reduce wait_status timetout from 100ms to 2ms, as wait_status either takes less
than 1.5 ms, or fails.

Signed-off-by: Nicolas Boichat <nicolas@boichat.ch>
---

 drivers/hwmon/applesmc.c |   61 +++++++++++++++++++++++++++++++++++++---------
 1 files changed, 49 insertions(+), 12 deletions(-)

diff --git a/drivers/hwmon/applesmc.c b/drivers/hwmon/applesmc.c
index 4ec38ef..ea0a004 100644
--- a/drivers/hwmon/applesmc.c
+++ b/drivers/hwmon/applesmc.c
@@ -38,6 +38,7 @@
 #include <asm/io.h>
 #include <linux/leds.h>
 #include <linux/hwmon.h>
+#include <linux/workqueue.h>
 
 /* data port used by Apple SMC */
 #define APPLESMC_DATA_PORT	0x300
@@ -116,7 +117,7 @@ struct dmi_match_data {
 	int temperature_set;
 };
 
-static int debug = 0;
+static const int debug = 0;
 static struct platform_device *pdev;
 static s16 rest_x;
 static s16 rest_y;
@@ -141,8 +142,10 @@ static struct mutex applesmc_lock;
  */
 static unsigned int key_at_index;
 
+static struct workqueue_struct *applesmc_led_wq;
+
 /*
- * __wait_status - Wait up to 100ms for the status port to get a certain value
+ * __wait_status - Wait up to 2ms for the status port to get a certain value
  * (masked with 0x0f), returning zero if the value is obtained.  Callers must
  * hold applesmc_lock.
  */
@@ -152,9 +155,14 @@ static int __wait_status(u8 val)
 
 	val = val & APPLESMC_STATUS_MASK;
 
-	for (i = 0; i < 10000; i++) {
-		if ((inb(APPLESMC_CMD_PORT) & APPLESMC_STATUS_MASK) == val)
+	for (i = 0; i < 200; i++) {
+		if ((inb(APPLESMC_CMD_PORT) & APPLESMC_STATUS_MASK) == val) {
+			if (debug)
+				printk(KERN_DEBUG
+						"Waited %d us for status %x\n",
+						i*10, val);
 			return 0;
+		}
 		udelay(10);
 	}
 
@@ -721,17 +729,33 @@ static ssize_t applesmc_calibrate_store(struct device *dev,
 	return count;
 }
 
-static void applesmc_backlight_set(struct led_classdev *led_cdev,
-						enum led_brightness value)
+/* Store the next backlight value to be written by the work */
+static unsigned int backlight_value;
+
+static void applesmc_backlight_set(struct work_struct *work)
 {
 	u8 buffer[2];
 	
 	mutex_lock(&applesmc_lock);
-	buffer[0] = value;
+	buffer[0] = backlight_value;
 	buffer[1] = 0x00;
 	applesmc_write_key(BACKLIGHT_KEY, buffer, 2);
 	mutex_unlock(&applesmc_lock);
 }
+DECLARE_WORK(backlight_work, &applesmc_backlight_set);
+
+static void applesmc_brightness_set(struct led_classdev *led_cdev,
+						enum led_brightness value)
+{
+	int ret;
+
+	backlight_value = value;
+	ret = queue_work(applesmc_led_wq, &backlight_work);
+
+	if (debug && (!ret)) {
+		printk(KERN_DEBUG "applesmc: work was already on the queue.\n");
+	}
+}
 
 static ssize_t applesmc_key_count_show(struct device *dev,
 				struct device_attribute *attr, char *sysfsbuf)
@@ -887,7 +911,7 @@ static ssize_t applesmc_key_at_index_store(struct device *dev,
 static struct led_classdev applesmc_backlight = {
 	.name			= "smc:kbd_backlight",
 	.default_trigger	= "nand-disk",
-	.brightness_set		= applesmc_backlight_set,
+	.brightness_set		= applesmc_brightness_set,
 };
 
 static DEVICE_ATTR(position, 0444, applesmc_position_show, NULL);
@@ -1234,25 +1258,35 @@ static int __init applesmc_init(void)
 		if (ret)
 			goto out_accelerometer;
 
+		/* Create the workqueue */
+		applesmc_led_wq = create_singlethread_workqueue("applesmc-led");
+		if (!applesmc_led_wq) {
+			ret = -ENOMEM;
+			goto out_light_sysfs;
+		}
+
 		/* register as a led device */
 		ret = led_classdev_register(&pdev->dev, &applesmc_backlight);
 		if (ret < 0)
-			goto out_light_sysfs;
+			goto out_light_wq;
 	}
 
 	hwmon_class_dev = hwmon_device_register(&pdev->dev);
 	if (IS_ERR(hwmon_class_dev)) {
 		ret = PTR_ERR(hwmon_class_dev);
-		goto out_light;
+		goto out_light_ledclass;
 	}
 
 	printk(KERN_INFO "applesmc: driver successfully loaded.\n");
 
 	return 0;
 
-out_light:
+out_light_ledclass:
 	if (applesmc_light)
 		led_classdev_unregister(&applesmc_backlight);
+out_light_wq:
+	if (applesmc_light)
+		destroy_workqueue(applesmc_led_wq);
 out_light_sysfs:
 	if (applesmc_light)
 		sysfs_remove_file(&pdev->dev.kobj, &dev_attr_light.attr);
@@ -1280,8 +1314,11 @@ out:
 static void __exit applesmc_exit(void)
 {
 	hwmon_device_unregister(hwmon_class_dev);	
-	if (applesmc_light)
+	if (applesmc_light) {
 		led_classdev_unregister(&applesmc_backlight);
+		destroy_workqueue(applesmc_led_wq);
+		sysfs_remove_file(&pdev->dev.kobj, &dev_attr_light.attr);
+	}
 	if (applesmc_accelerometer)
 		applesmc_release_accelerometer();
 	sysfs_remove_group(&pdev->dev.kobj, &temperature_attributes_group);


