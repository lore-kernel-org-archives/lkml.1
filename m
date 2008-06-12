Return-Path: <linux-kernel-owner+w=401wt.eu-S1755529AbYFLQrV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755529AbYFLQrV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 12:47:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752463AbYFLQrM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 12:47:12 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:30889 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751636AbYFLQrK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 12:47:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=YVmx5p4MXhovWCE4TfJWOOMye6utl50kmNot1Kezr+aQCkym8wspdpPbt1elFtRjbc
         ok00YSQrP7EWVTNBVkcyVrLda6pugo5uJLsAwCm2KGPvq5ds45NcNrg5ev4/TgK2M+Bh
         woCkJ3C046UOfTPZHi1SZgOIJspuc805DNxwY=
Message-ID: <8265cb9e0806120947o4f39f78aqa3ace61a1ec1d6e3@mail.gmail.com>
Date: Thu, 12 Jun 2008 17:47:09 +0100
From: "Julia Jomantaite" <julia.jomantaite@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] drivers/acpi/video: fix brightness allocation
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ACPI Video Driver module (drivers/acpi/video.c) produces Oops message
after pressing one of two Fn+<key> combinations responsible for switching
the brightness level on my laptop.

The source of this problem is in the function acpi_video_switch_brightness
which can access device->brightness when it is not allocated. Function
"acpi_video_device_find_cap" which is responsible for allocating
device->brightness can leave it unallocated in some cases.

Function acpi_video_switch_brightness isn't called if modules's parameter
"brightness_switch_enabled" is equal to zero so i've decided to add
zeroing of this parameter to the part of the code where unsuccessfull
allocation of device->brightness was handled.

Also i've moved initialization of brightness to a separate function
"acpi_video_init_brightness" to improve readability of the code and
to simplify error handling.

Julia


--- orig/drivers/acpi/video.c	2008-06-12 17:15:08.000000000 +0100
+++ linux-2.6/drivers/acpi/video.c	2008-06-12 17:04:09.000000000 +0100
@@ -631,6 +631,74 @@
  *  	device	: video output device (LCD, CRT, ..)
  *
  *  Return Value:
+ *  	Maximum brightness level
+ *
+ *  Allocate and initialize device->brightness.
+ */
+
+static int
+acpi_video_init_brightness(struct acpi_video_device *device)
+{
+	union acpi_object *obj = NULL;
+	int i, max_level = 0, count = 0;
+	union acpi_object *o;
+	struct acpi_video_device_brightness *br = NULL;
+
+	if (!ACPI_SUCCESS(acpi_video_device_lcd_query_levels(device, &obj))) {
+		ACPI_DEBUG_PRINT((ACPI_DB_INFO, "Could not query available LCD
brightness level\n"));
+		goto out;
+	}
+
+	if (obj->package.count < 2)
+		goto out;
+
+	br = kzalloc(sizeof(*br), GFP_KERNEL);
+	if (!br) {
+		printk(KERN_ERR "can't allocate memory\n");
+		goto out;
+	}
+
+	br->levels = kmalloc(obj->package.count * sizeof *(br->levels), GFP_KERNEL);
+	if (!br->levels)
+		goto out_free;
+
+	for (i = 0; i < obj->package.count; i++) {
+		o = (union acpi_object *)&obj->package.elements[i];
+		if (o->type != ACPI_TYPE_INTEGER) {
+			printk(KERN_ERR PREFIX "Invalid data\n");
+			continue;
+		}
+		br->levels[count] = (u32) o->integer.value;
+
+		if (br->levels[count] > max_level)
+			max_level = br->levels[count];
+		count++;
+	}
+
+	if (count < 2)
+		goto out_free_levels;
+
+	br->count = count;
+	device->brightness = br;
+	ACPI_DEBUG_PRINT((ACPI_DB_INFO,	"found %d brightness levels\n",	count));
+	kfree(obj);
+	return max_level;
+
+out_free_levels:
+	kfree(br->levels);
+out_free:
+	kfree(br);
+out:
+	brightness_switch_enabled = 0;
+	kfree(obj);
+	return 0;
+}
+
+/*
+ *  Arg:	
+ *  	device	: video output device (LCD, CRT, ..)
+ *
+ *  Return Value:
  *  	None
  *
  *  Find out all required AML methods defined under the output
@@ -640,10 +708,7 @@
 static void acpi_video_device_find_cap(struct acpi_video_device *device)
 {
 	acpi_handle h_dummy1;
-	int i;
 	u32 max_level = 0;
-	union acpi_object *obj = NULL;
-	struct acpi_video_device_brightness *br = NULL;


 	memset(&device->cap, 0, sizeof(device->cap));
@@ -657,8 +722,9 @@
 	if (ACPI_SUCCESS(acpi_get_handle(device->dev->handle, "_BCM", &h_dummy1))) {
 		device->cap._BCM = 1;
 	}
-	if (ACPI_SUCCESS(acpi_get_handle(device->dev->handle,"_BQC",&h_dummy1)))
+	if (ACPI_SUCCESS(acpi_get_handle(device->dev->handle, "_BQC", &h_dummy1))) {
 		device->cap._BQC = 1;
+	}
 	if (ACPI_SUCCESS(acpi_get_handle(device->dev->handle, "_DDC", &h_dummy1))) {
 		device->cap._DDC = 1;
 	}
@@ -672,54 +738,10 @@
 		device->cap._DSS = 1;
 	}

-	if (ACPI_SUCCESS(acpi_video_device_lcd_query_levels(device, &obj))) {
-
-		if (obj->package.count >= 2) {
-			int count = 0;
-			union acpi_object *o;
-
-			br = kzalloc(sizeof(*br), GFP_KERNEL);
-			if (!br) {
-				printk(KERN_ERR "can't allocate memory\n");
-			} else {
-				br->levels = kmalloc(obj->package.count *
-						     sizeof *(br->levels), GFP_KERNEL);
-				if (!br->levels)
-					goto out;
-
-				for (i = 0; i < obj->package.count; i++) {
-					o = (union acpi_object *)&obj->package.
-					    elements[i];
-					if (o->type != ACPI_TYPE_INTEGER) {
-						printk(KERN_ERR PREFIX "Invalid data\n");
-						continue;
-					}
-					br->levels[count] = (u32) o->integer.value;
-
-					if (br->levels[count] > max_level)
-						max_level = br->levels[count];
-					count++;
-				}
-			      out:
-				if (count < 2) {
-					kfree(br->levels);
-					kfree(br);
-				} else {
-					br->count = count;
-					device->brightness = br;
-					ACPI_DEBUG_PRINT((ACPI_DB_INFO,
-							  "found %d brightness levels\n",
-							  count));
-				}
-			}
-		}
-
-	} else {
-		ACPI_DEBUG_PRINT((ACPI_DB_INFO, "Could not query available LCD
brightness level\n"));
+	if (brightness_switch_enabled) {
+		max_level = acpi_video_init_brightness(device);
 	}

-	kfree(obj);
-
 	if (device->cap._BCL && device->cap._BCM && device->cap._BQC &&
max_level > 0){
 		int result;
 		static int count = 0;
