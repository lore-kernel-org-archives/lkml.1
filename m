Return-Path: <linux-kernel-owner+w=401wt.eu-S1755247AbYBII3r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755247AbYBII3r (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 03:29:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751109AbYBII3j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 03:29:39 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:48720 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751072AbYBII3i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 03:29:38 -0500
Date: Sat, 9 Feb 2008 09:27:48 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Len Brown <lenb@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       Zhang Rui <rui.zhang@intel.com>,
       Thomas Sujith <sujith.thomas@intel.com>
Subject: Re: [GIT PATCH] ACPI patches for 2.6.25-rc0
Message-ID: <20080209082748.GA7792@elte.hu>
References: <200802070450.09098.lenb@kernel.org> <20080209063439.GA19995@elte.hu> <20080209063619.GA20225@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080209063619.GA20225@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> > i suspect it might be this one:
> > 
> > >       ACPI: register ACPI thermal zone as generic thermal zone devices
> > 
> > config attached.
> 
> yep, reverting 05a83d972293f3 fixes the build failure.

that fixed the build failure on 32-bit, but there's another one i just 
hit on 64-bit x86:

drivers/built-in.o: In function `acpi_video_bus_put_devices':
video.c:(.text+0x5540d): undefined reference to `thermal_cooling_device_unregister'
drivers/built-in.o: In function `acpi_video_bus_add':
video.c:(.text+0x56994): undefined reference to `thermal_cooling_device_register'

which is due to:

  commit 702ed512de9c8a67a69a981c73b7337c2131f198
  Date:   Thu Jan 17 15:51:22 2008 +0800

      ACPI: register ACPI Video LCD as generic thermal cooling device

the commit couldnt be reverted cleanly, i've done a manual fixup of the 
revert (find the patch below).

but i suspect the third "generic thermal cooling device" patch might be 
broken too:

  commit d9460fd227ed2ce52941b6a12ad4de05c195f6aa
  Date:   Thu Jan 17 15:51:23 2008 +0800

      ACPI: register ACPI Processor as generic thermal cooling device

so i've preventively reverted that too, to keep x86-qa running. (that 
reverts cleanly without manual merging)

	Ingo

-------------------->
Subject: x86: acpi-revert2
From: Ingo Molnar <mingo@elte.hu>

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 drivers/acpi/video.c |   78 ---------------------------------------------------
 1 file changed, 1 insertion(+), 77 deletions(-)

Index: linux/drivers/acpi/video.c
===================================================================
--- linux.orig/drivers/acpi/video.c
+++ linux/drivers/acpi/video.c
@@ -34,7 +34,6 @@
 #include <linux/seq_file.h>
 #include <linux/input.h>
 #include <linux/backlight.h>
-#include <linux/thermal.h>
 #include <linux/video_output.h>
 #include <asm/uaccess.h>
 
@@ -185,7 +184,6 @@ struct acpi_video_device {
 	struct acpi_device *dev;
 	struct acpi_video_device_brightness *brightness;
 	struct backlight_device *backlight;
-	struct thermal_cooling_device *cdev;
 	struct output_device *output_dev;
 };
 
@@ -348,54 +346,6 @@ static struct output_properties acpi_out
 	.set_state = acpi_video_output_set,
 	.get_status = acpi_video_output_get,
 };
-
-
-/* thermal cooling device callbacks */
-static int video_get_max_state(struct thermal_cooling_device *cdev, char *buf)
-{
-	struct acpi_device *device = cdev->devdata;
-	struct acpi_video_device *video = acpi_driver_data(device);
-
-	return sprintf(buf, "%d\n", video->brightness->count - 3);
-}
-
-static int video_get_cur_state(struct thermal_cooling_device *cdev, char *buf)
-{
-	struct acpi_device *device = cdev->devdata;
-	struct acpi_video_device *video = acpi_driver_data(device);
-	unsigned long level;
-	int state;
-
-	acpi_video_device_lcd_get_level_current(video, &level);
-	for (state = 2; state < video->brightness->count; state++)
-		if (level == video->brightness->levels[state])
-			return sprintf(buf, "%d\n",
-				       video->brightness->count - state - 1);
-
-	return -EINVAL;
-}
-
-static int
-video_set_cur_state(struct thermal_cooling_device *cdev, unsigned int state)
-{
-	struct acpi_device *device = cdev->devdata;
-	struct acpi_video_device *video = acpi_driver_data(device);
-	int level;
-
-	if ( state >= video->brightness->count - 2)
-		return -EINVAL;
-
-	state = video->brightness->count - state;
-	level = video->brightness->levels[state -1];
-	return acpi_video_device_lcd_set_level(video, level);
-}
-
-static struct thermal_cooling_device_ops video_cooling_ops = {
-	.get_max_state = video_get_max_state,
-	.get_cur_state = video_get_cur_state,
-	.set_cur_state = video_set_cur_state,
-};
-
 /* --------------------------------------------------------------------------
                                Video Management
    -------------------------------------------------------------------------- */
@@ -714,7 +664,6 @@ static void acpi_video_device_find_cap(s
 	kfree(obj);
 
 	if (device->cap._BCL && device->cap._BCM && device->cap._BQC && max_level > 0){
-		int result;
 		static int count = 0;
 		char *name;
 		name = kzalloc(MAX_NAME_LEN, GFP_KERNEL);
@@ -727,25 +676,8 @@ static void acpi_video_device_find_cap(s
 		device->backlight->props.max_brightness = device->brightness->count-3;
 		device->backlight->props.brightness = acpi_video_get_brightness(device->backlight);
 		backlight_update_status(device->backlight);
-		kfree(name);
 
-		device->cdev = thermal_cooling_device_register("LCD",
-					device->dev, &video_cooling_ops);
-		if (device->cdev) {
-			printk(KERN_INFO PREFIX
-				"%s is registered as cooling_device%d\n",
-				device->dev->dev.bus_id, device->cdev->id);
-			result = sysfs_create_link(&device->dev->dev.kobj,
-					  &device->cdev->device.kobj,
-					  "thermal_cooling");
-			if (result)
-				printk(KERN_ERR PREFIX "Create sysfs link\n");
-			result = sysfs_create_link(&device->cdev->device.kobj,
-					  &device->dev->dev.kobj,
-					  "device");
-                        if (result)
-				printk(KERN_ERR PREFIX "Create sysfs link\n");
-		}
+		kfree(name);
 	}
 	if (device->cap._DCS && device->cap._DSS){
 		static int count = 0;
@@ -1807,14 +1739,6 @@ static int acpi_video_bus_put_one_device
 					    ACPI_DEVICE_NOTIFY,
 					    acpi_video_device_notify);
 	backlight_device_unregister(device->backlight);
-	if (device->cdev) {
-		sysfs_remove_link(&device->dev->dev.kobj,
-				  "thermal_cooling");
-		sysfs_remove_link(&device->cdev->device.kobj,
-				  "device");
-		thermal_cooling_device_unregister(device->cdev);
-		device->cdev = NULL;
-	}
 	video_output_unregister(device->output_dev);
 
 	return 0;
