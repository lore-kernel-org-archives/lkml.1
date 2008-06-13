Return-Path: <linux-kernel-owner+w=401wt.eu-S1760812AbYFMBA2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760812AbYFMBA2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 21:00:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757634AbYFMBAQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 21:00:16 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34660 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757590AbYFMBAO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 21:00:14 -0400
Date: Thu, 12 Jun 2008 18:00:06 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Julia Jomantaite" <julia.jomantaite@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
       Zhang Rui <rui.zhang@intel.com>
Subject: Re: [PATCH] drivers/acpi/video: fix brightness allocation
Message-Id: <20080612180006.7cc946b2.akpm@linux-foundation.org>
In-Reply-To: <8265cb9e0806120947o4f39f78aqa3ace61a1ec1d6e3@mail.gmail.com>
References: <8265cb9e0806120947o4f39f78aqa3ace61a1ec1d6e3@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Jun 2008 17:47:09 +0100
"Julia Jomantaite" <julia.jomantaite@gmail.com> wrote:

> ACPI Video Driver module (drivers/acpi/video.c) produces Oops message
> after pressing one of two Fn+<key> combinations responsible for switching
> the brightness level on my laptop.
> 
> The source of this problem is in the function acpi_video_switch_brightness
> which can access device->brightness when it is not allocated. Function
> "acpi_video_device_find_cap" which is responsible for allocating
> device->brightness can leave it unallocated in some cases.
> 
> Function acpi_video_switch_brightness isn't called if modules's parameter
> "brightness_switch_enabled" is equal to zero so i've decided to add
> zeroing of this parameter to the part of the code where unsuccessfull
> allocation of device->brightness was handled.
> 
> Also i've moved initialization of brightness to a separate function
> "acpi_video_init_brightness" to improve readability of the code and
> to simplify error handling.
> 

(cc's added)

Thanks.  Which kernel version were you running?

The patch was a bit wordwrapped.  Here's the fixed up version:

 drivers/acpi/video.c |  122 ++++++++++++++++++++++++-----------------
 1 file changed, 72 insertions(+), 50 deletions(-)

diff -puN drivers/acpi/video.c~drivers-acpi-video-fix-brightness-allocation drivers/acpi/video.c
--- a/drivers/acpi/video.c~drivers-acpi-video-fix-brightness-allocation
+++ a/drivers/acpi/video.c
@@ -631,6 +631,74 @@ acpi_video_bus_DOS(struct acpi_video_bus
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
+		ACPI_DEBUG_PRINT((ACPI_DB_INFO, "Could not query available LCD brightness level\n"));
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
@@ -640,10 +708,7 @@ acpi_video_bus_DOS(struct acpi_video_bus
 static void acpi_video_device_find_cap(struct acpi_video_device *device)
 {
 	acpi_handle h_dummy1;
-	int i;
 	u32 max_level = 0;
-	union acpi_object *obj = NULL;
-	struct acpi_video_device_brightness *br = NULL;
 
 
 	memset(&device->cap, 0, sizeof(device->cap));
@@ -657,8 +722,9 @@ static void acpi_video_device_find_cap(s
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
@@ -672,54 +738,10 @@ static void acpi_video_device_find_cap(s
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
-		ACPI_DEBUG_PRINT((ACPI_DB_INFO, "Could not query available LCD brightness level\n"));
+	if (brightness_switch_enabled) {
+		max_level = acpi_video_init_brightness(device);
 	}
 
-	kfree(obj);
-
 	if (device->cap._BCL && device->cap._BCM && device->cap._BQC && max_level > 0){
 		int result;
 		static int count = 0;
_

