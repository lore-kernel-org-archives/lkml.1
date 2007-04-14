Return-Path: <linux-kernel-owner+w=401wt.eu-S1750712AbXDNIMz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750712AbXDNIMz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2007 04:12:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753058AbXDNIMz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Apr 2007 04:12:55 -0400
Received: from 23.mail-out.ovh.net ([213.186.41.17]:34227 "HELO
	23.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750712AbXDNIMx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2007 04:12:53 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Sat, 14 Apr 2007 04:12:53 EDT
Message-ID: <46208B40.1060809@boichat.ch>
Date: Sat, 14 Apr 2007 16:05:20 +0800
From: Nicolas Boichat <nicolas@boichat.ch>
User-Agent: Thunderbird 1.5.0.10 (X11/20070309)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>, rpurdie@rpsys.net
CC: Bradley Hook <bdhook@gmail.com>, mactel-linux-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: [PATCH] applesmc - fix crash when activating a led trigger on the
 keyboard backlight
References: <45F7C083.7090504@boichat.ch>	<b6c5339f0703191443l5f8c5271pf43ea62e0c79a614@mail.gmail.com>	<45FF86F6.7050200@boichat.ch> <eb4a44160703200016i74786682n41f87f3d88f90409@mail.gmail.com>
In-Reply-To: <eb4a44160703200016i74786682n41f87f3d88f90409@mail.gmail.com>
X-Enigmail-Version: 0.94.3.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Ovh-Remote: 137.132.199.102 ()
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|H 0.5/N
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I got this bug report a while ago:

Bradley Hook wrote:
> Slightly off-topic, but I've been experiencing a minor bug in the
> keyboard backlight feature.
>
> I say it is "minor" only because the feature serves no real functional
> purpose. You can activate a trigger called "heartbeat" that will cause
> the keyboard light to pulse at a speed based on the CPU usage. On my
> MBP17, after activating this trigger the machine will either lock-up
> or core dump within about a minute (timing is not consistent).
>   

This is caused by the fact applesmc_backlight_set locks a mutex (or more
precisely sleeps while trying to lock a mutex) while being in a softirq
context.

This might be obvious for others, but it was not for me, and there is
absolutely no mention in the documentation of the fact it is not always
safe to sleep in the brightness_set handler of a led_class device (it is
safe when it is called because someone wrote to the brightness sysfs file).

So, with the patch below, in case the mutex is locked for another
operation, the "brightness_set" called by the led trigger is simply
ignored. I don't think it is the behaviour we want, and I think it would
be a good idea to try again a little while afterwards. Richard, would
you like me to provide a patch for this? It would imply adding a
parameter to brightness_set indicating whether it's safe to sleep or
not, make it return an int, and modify the triggers code to retry if the
return value indicates an error.

Also, the led-trigger code seems buggy when it comes to locking. Setting
CONFIG_DEBUG_SPINLOCK_SLEEP causes a lot a warnings. The problem is that
the list of triggers is locked using a rw spinlock, but the rest of the
code seems to ignore that, and calls a lot of functions which can sleep
(kzalloc with GFP_KERNEL, sysfs_add_file, mutex_lock, etc...). I think
the list lock should be converted to a mutex (or maybe modified to use
RCU). I'm not very experienced in that domain, but if you want I can
provide a patch for this.

Best regards,

Nicolas

Cannot sleep in led->brightness_set handler if it is called from a softirq.
Reduce wait_status timetout from 100ms to 2ms, as wait_status either takes less
than 1.5 ms, or fails.

Signed-off-by: Nicolas Boichat <nicolas@boichat.ch>
---

 drivers/hwmon/applesmc.c |   25 ++++++++++++++++++++-----
 1 files changed, 20 insertions(+), 5 deletions(-)

diff --git a/drivers/hwmon/applesmc.c b/drivers/hwmon/applesmc.c
index 4ec38ef..c93c290 100644
--- a/drivers/hwmon/applesmc.c
+++ b/drivers/hwmon/applesmc.c
@@ -142,7 +142,7 @@ static struct mutex applesmc_lock;
 static unsigned int key_at_index;
 
 /*
- * __wait_status - Wait up to 100ms for the status port to get a certain value
+ * __wait_status - Wait up to 2ms for the status port to get a certain value
  * (masked with 0x0f), returning zero if the value is obtained.  Callers must
  * hold applesmc_lock.
  */
@@ -152,9 +152,14 @@ static int __wait_status(u8 val)
 
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
 
@@ -725,8 +730,18 @@ static void applesmc_backlight_set(struct led_classdev *led_cdev,
 						enum led_brightness value)
 {
 	u8 buffer[2];
-	
-	mutex_lock(&applesmc_lock);
+
+	if (in_interrupt()) {
+		/* Cannot sleep, as we are called from a timer. */
+		if (!mutex_trylock(&applesmc_lock)) {
+			printk(KERN_ERR "applesmc: Could not set the backlight,"
+							" mutex is locked.\n");
+			return;
+		}
+	} else {
+		mutex_lock(&applesmc_lock);
+	}
+
 	buffer[0] = value;
 	buffer[1] = 0x00;
 	applesmc_write_key(BACKLIGHT_KEY, buffer, 2);


