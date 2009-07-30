Return-Path: <linux-kernel-owner+w=401wt.eu-S1750994AbZG3Hzz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750994AbZG3Hzz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 03:55:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750938AbZG3Hzx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 03:55:53 -0400
Received: from adelphi.physics.adelaide.edu.au ([129.127.102.1]:47545 "EHLO
	adelphi.physics.adelaide.edu.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750759AbZG3Hzw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 03:55:52 -0400
From: Jonathan Woithe <jwoithe@physics.adelaide.edu.au>
Message-Id: <200907300755.n6U7tM4e001263@mercury.physics.adelaide.edu.au>
Subject: Re: [PATCH] fujitsu-laptop: consolidated fixes (NULL pointer checks, [un]registration fixes, etc)
To: bzolnier@gmail.com (Bartlomiej Zolnierkiewicz)
Date: Thu, 30 Jul 2009 17:25:22 +0930 (CST)
Cc: jwoithe@physics.adelaide.edu.au (Jonathan Woithe),
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       error27@gmail.com (Dan Carpenter), corbet@lwn.net, eteo@redhat.com,
       julia@diku.dk (Julia Lawall)
In-Reply-To: <200907292214.31038.bzolnier@gmail.com> from "Bartlomiej Zolnierkiewicz" at Jul 29, 2009 10:14:30 PM
X-Mailer: ELM [version 2.5 PL6]
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all

This patch consolidates the two patches posted by Bartlomiej Zolnierkiewicz
and the NULL pointer patch which came out of a discussion with Julia Lawall.
Some additional NULL pointer check tidy-ups have also been done.

To summarise:

* Take care of the following entries from Dan's list:

  drivers/platform/x86/fujitsu-laptop.c +327 set_lcd_level(13) warning:       
    variable derefenced before check 'fujitsu'
  drivers/platform/x86/fujitsu-laptop.c +358 set_lcd_level_alt(13) warning:   
    variable derefenced before check 'fujitsu'

* Move led_classdev_unregister() calls from fujitsu_cleanup() to
  acpi_fujitsu_hotkey_remove().

* Fix ordering in fujitsu_cleanup().

* Fix backlight_device_register() failure handling in fujitsu_init().

* Add missing sysfs group removal on failure to fujitsu_init().

* Add input device unregistering on failure to acpi_fujitsu_add()
  and acpi_fujitsu_hotkey_add().

* Add input device unregistering/freeing to acpi_fujitsu_remove()   
  and acpi_fujitsu_hotkey_remove() (also remove superfluous 'device'
  and 'acpi_driver_data(device)' checks while at it).

* Do few minor cleanups.

* Fix some additional NULL pointer checks which should occur before the 
  initial dereference.

Patch is relative to linux-acpi-2.6.git head.


Reported-by: Dan Carpenter <error27@gmail.com>
Cc: corbet@lwn.net
Cc: eteo@redhat.com
Cc: Julia Lawall <julia@diku.dk>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Signed-off-by: Jonathan Woithe <jwoithe@physics.adelaide.edu.au>

--- a/drivers/platform/x86/fujitsu-laptop.c	2009-07-30 16:30:55.455795000 +0930
+++ b/drivers/platform/x86/fujitsu-laptop.c	2009-07-30 16:48:45.542784340 +0930
@@ -70,7 +70,7 @@
 #include <linux/leds.h>
 #endif
 
-#define FUJITSU_DRIVER_VERSION "0.5.0"
+#define FUJITSU_DRIVER_VERSION "0.6.0"
 
 #define FUJITSU_LCD_N_LEVELS 8
 
@@ -321,10 +321,7 @@ static int set_lcd_level(int level)
 	vdbg_printk(FUJLAPTOP_DBG_TRACE, "set lcd level via SBLL [%d]\n",
 		    level);
 
-	if (level < 0 || level >= fujitsu->max_brightness)
-		return -EINVAL;
-
-	if (!fujitsu)
+	if (!fujitsu || level < 0 || level >= fujitsu->max_brightness)
 		return -EINVAL;
 
 	status = acpi_get_handle(fujitsu->acpi_handle, "SBLL", &handle);
@@ -352,10 +349,7 @@ static int set_lcd_level_alt(int level)
 	vdbg_printk(FUJLAPTOP_DBG_TRACE, "set lcd level via SBL2 [%d]\n",
 		    level);
 
-	if (level < 0 || level >= fujitsu->max_brightness)
-		return -EINVAL;
-
-	if (!fujitsu)
+	if (!fujitsu || level < 0 || level >= fujitsu->max_brightness)
 		return -EINVAL;
 
 	status = acpi_get_handle(fujitsu->acpi_handle, "SBL2", &handle);
@@ -697,7 +691,7 @@ static int acpi_fujitsu_add(struct acpi_
 	result = acpi_bus_get_power(fujitsu->acpi_handle, &state);
 	if (result) {
 		printk(KERN_ERR "Error reading power state\n");
-		goto end;
+		goto err_unregister_input_dev;
 	}
 
 	printk(KERN_INFO PREFIX "%s [%s] (%s)\n",
@@ -728,25 +722,31 @@ static int acpi_fujitsu_add(struct acpi_
 
 	return result;
 
-end:
+err_unregister_input_dev:
+	input_unregister_device(input);
 err_free_input_dev:
 	input_free_device(input);
 err_stop:
-
 	return result;
 }
 
 static int acpi_fujitsu_remove(struct acpi_device *device, int type)
 {
 	struct fujitsu_t *fujitsu = NULL;
+	struct input_dev *input = NULL;
 
-	if (!device || !acpi_driver_data(device))
+	if (!device)
 		return -EINVAL;
 
-	fujitsu = acpi_driver_data(device);
-
-	if (!device || !acpi_driver_data(device))
-		return -EINVAL;
+        fujitsu = acpi_driver_data(device);
+        if (!fujitsu)
+        	return -EINVAL;
+        input = fujitsu->input;
+
+        if (input) {
+		input_unregister_device(input);
+		input_free_device(input);
+	}
 
 	fujitsu->acpi_handle = NULL;
 
@@ -871,7 +871,7 @@ static int acpi_fujitsu_hotkey_add(struc
 	result = acpi_bus_get_power(fujitsu_hotkey->acpi_handle, &state);
 	if (result) {
 		printk(KERN_ERR "Error reading power state\n");
-		goto end;
+		goto err_unregister_input_dev;
 	}
 
 	printk(KERN_INFO PREFIX "%s [%s] (%s)\n",
@@ -911,7 +911,7 @@ static int acpi_fujitsu_hotkey_add(struc
 	printk(KERN_INFO "fujitsu-laptop: BTNI: [0x%x]\n",
 		call_fext_func(FUNC_BUTTONS, 0x0, 0x0, 0x0));
 
-	#ifdef CONFIG_LEDS_CLASS
+#ifdef CONFIG_LEDS_CLASS
 	if (call_fext_func(FUNC_LEDS, 0x0, 0x0, 0x0) & LOGOLAMP_POWERON) {
 		result = led_classdev_register(&fujitsu->pf_device->dev,
 						&logolamp_led);
@@ -934,33 +934,50 @@ static int acpi_fujitsu_hotkey_add(struc
 			"LED handler for keyboard lamps, error %i\n", result);
 		}
 	}
-	#endif
+#endif
 
 	return result;
 
-end:
+err_unregister_input_dev:
+	input_unregister_device(input);
 err_free_input_dev:
 	input_free_device(input);
 err_free_fifo:
 	kfifo_free(fujitsu_hotkey->fifo);
 err_stop:
-
 	return result;
 }
 
 static int acpi_fujitsu_hotkey_remove(struct acpi_device *device, int type)
 {
 	struct fujitsu_hotkey_t *fujitsu_hotkey = NULL;
+	struct input_dev *input = NULL;
 
-	if (!device || !acpi_driver_data(device))
+	if (!device)
 		return -EINVAL;
-
 	fujitsu_hotkey = acpi_driver_data(device);
+	if (!fujitsu_hotkey)
+		return -EINVAL;
 
-	fujitsu_hotkey->acpi_handle = NULL;
+	input = fujitsu_hotkey->input;
+
+#ifdef CONFIG_LEDS_CLASS
+	if (fujitsu_hotkey->logolamp_registered)
+		led_classdev_unregister(&logolamp_led);
+
+	if (fujitsu_hotkey->kblamps_registered)
+		led_classdev_unregister(&kblamps_led);
+#endif
+
+	if (input) {
+		input_unregister_device(input);
+		input_free_device(input);
+	}
 
 	kfifo_free(fujitsu_hotkey->fifo);
 
+	fujitsu_hotkey->acpi_handle = NULL;
+
 	return 0;
 }
 
@@ -1130,8 +1147,11 @@ static int __init fujitsu_init(void)
 		fujitsu->bl_device =
 			backlight_device_register("fujitsu-laptop", NULL, NULL,
 						  &fujitsubl_ops);
-		if (IS_ERR(fujitsu->bl_device))
-			return PTR_ERR(fujitsu->bl_device);
+		if (IS_ERR(fujitsu->bl_device)) {
+			ret = PTR_ERR(fujitsu->bl_device);
+			fujitsu->bl_device = NULL;
+			goto fail_sysfs_group;
+		}
 		max_brightness = fujitsu->max_brightness;
 		fujitsu->bl_device->props.max_brightness = max_brightness - 1;
 		fujitsu->bl_device->props.brightness = fujitsu->brightness_level;
@@ -1171,32 +1191,22 @@ static int __init fujitsu_init(void)
 	return 0;
 
 fail_hotkey1:
-
 	kfree(fujitsu_hotkey);
-
 fail_hotkey:
-
 	platform_driver_unregister(&fujitsupf_driver);
-
 fail_backlight:
-
 	if (fujitsu->bl_device)
 		backlight_device_unregister(fujitsu->bl_device);
-
+fail_sysfs_group:
+	sysfs_remove_group(&fujitsu->pf_device->dev.kobj,
+			   &fujitsupf_attribute_group);
 fail_platform_device2:
-
 	platform_device_del(fujitsu->pf_device);
-
 fail_platform_device1:
-
 	platform_device_put(fujitsu->pf_device);
-
 fail_platform_driver:
-
 	acpi_bus_unregister_driver(&acpi_fujitsu_driver);
-
 fail_acpi:
-
 	kfree(fujitsu);
 
 	return ret;
@@ -1204,28 +1214,23 @@ fail_acpi:
 
 static void __exit fujitsu_cleanup(void)
 {
-	#ifdef CONFIG_LEDS_CLASS
-	if (fujitsu_hotkey->logolamp_registered != 0)
-		led_classdev_unregister(&logolamp_led);
+	acpi_bus_unregister_driver(&acpi_fujitsu_hotkey_driver);
 
-	if (fujitsu_hotkey->kblamps_registered != 0)
-		led_classdev_unregister(&kblamps_led);
-	#endif
+	kfree(fujitsu_hotkey);
 
-	sysfs_remove_group(&fujitsu->pf_device->dev.kobj,
-			   &fujitsupf_attribute_group);
-	platform_device_unregister(fujitsu->pf_device);
 	platform_driver_unregister(&fujitsupf_driver);
+
 	if (fujitsu->bl_device)
 		backlight_device_unregister(fujitsu->bl_device);
 
-	acpi_bus_unregister_driver(&acpi_fujitsu_driver);
+	sysfs_remove_group(&fujitsu->pf_device->dev.kobj,
+			   &fujitsupf_attribute_group);
 
-	kfree(fujitsu);
+	platform_device_unregister(fujitsu->pf_device);
 
-	acpi_bus_unregister_driver(&acpi_fujitsu_hotkey_driver);
+	acpi_bus_unregister_driver(&acpi_fujitsu_driver);
 
-	kfree(fujitsu_hotkey);
+	kfree(fujitsu);
 
 	printk(KERN_INFO "fujitsu-laptop: driver unloaded.\n");
 }
