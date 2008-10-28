Return-Path: <linux-kernel-owner+w=401wt.eu-S1752788AbYJ1EvW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752788AbYJ1EvW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 00:51:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751742AbYJ1EvL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 00:51:11 -0400
Received: from vms173007pub.verizon.net ([206.46.173.7]:35448 "EHLO
	vms173007pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751461AbYJ1EvK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 00:51:10 -0400
X-Greylist: delayed 3600 seconds by postgrey-1.27 at vger.kernel.org; Tue, 28 Oct 2008 00:51:10 EDT
Date: Mon, 27 Oct 2008 23:50:57 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
Subject: [PATCH 2.6.25.stable]
X-X-Sender: lenb@localhost.localdomain
To: stable@kernel.org
Cc: Arjan van de Ven <arjan@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org,
       Julia Jomantaite <julia.jomantaite@gmail.com>
Message-id: <alpine.LFD.2.00.0810272345580.21631@localhost.localdomain>
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Jomantaite <julia.jomantaite@gmail.com>

Thanks to Arjan for spotting this for .stable:
http://www.kerneloops.org/search.php?search=acpi_video_switch_brightness

upstream commit 469778c1740fcf3113498b6fdf4559bdec25c58f

    ACPI: video: fix brightness allocation
    
    Fix use of uninitialized device->brightness.
    
    Signed-off-by: Julia Jomantaite <julia.jomantaite@gmail.com>
    Signed-off-by: Andi Kleen <ak@linux.intel.com>
    Acked-by: Zhang Rui <rui.zhang@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

---
in addition to the 2.6.26.stable patch i sent a moment ago,
here is a version refreshed against 2.6.25.stable

Index: linux-2.6.26.y/drivers/acpi/video.c
===================================================================
--- linux-2.6.26.y.orig/drivers/acpi/video.c
+++ linux-2.6.26.y/drivers/acpi/video.c
@@ -631,6 +631,76 @@ acpi_video_bus_DOS(struct acpi_video_bus
  *  	device	: video output device (LCD, CRT, ..)
  *
  *  Return Value:
+ *	Maximum brightness level
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
+		ACPI_DEBUG_PRINT((ACPI_DB_INFO, "Could not query available "
+						"LCD brightness level\n"));
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
+	br->levels = kmalloc(obj->package.count * sizeof *(br->levels),
+				GFP_KERNEL);
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
+	ACPI_DEBUG_PRINT((ACPI_DB_INFO, "found %d brightness levels\n", count));
+	kfree(obj);
+	return max_level;
+
+out_free_levels:
+	kfree(br->levels);
+out_free:
+	kfree(br);
+out:
+	device->brightness = NULL;
+	kfree(obj);
+	return 0;
+}
+
+/*
+ *  Arg:
+ *	device	: video output device (LCD, CRT, ..)
+ *
+ *  Return Value:
  *  	None
  *
  *  Find out all required AML methods defined under the output
@@ -640,10 +710,7 @@ acpi_video_bus_DOS(struct acpi_video_bus
 static void acpi_video_device_find_cap(struct acpi_video_device *device)
 {
 	acpi_handle h_dummy1;
-	int i;
 	u32 max_level = 0;
-	union acpi_object *obj = NULL;
-	struct acpi_video_device_brightness *br = NULL;
 
 
 	memset(&device->cap, 0, sizeof(device->cap));
@@ -672,53 +739,7 @@ static void acpi_video_device_find_cap(s
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
-	}
-
-	kfree(obj);
+	max_level = acpi_video_init_brightness(device);
 
 	if (device->cap._BCL && device->cap._BCM && max_level > 0) {
 		int result;
@@ -1705,6 +1726,8 @@ static void
 acpi_video_switch_brightness(struct acpi_video_device *device, int event)
 {
 	unsigned long level_current, level_next;
+	if (!device->brightness)
+		return;
 	acpi_video_device_lcd_get_level_current(device, &level_current);
 	level_next = acpi_video_get_next_level(device, level_current, event);
 	acpi_video_device_lcd_set_level(device, level_next);
