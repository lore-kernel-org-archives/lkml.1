Return-Path: <linux-kernel-owner+w=401wt.eu-S1755576AbXD0KUk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755576AbXD0KUk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 06:20:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755570AbXD0KUj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 06:20:39 -0400
Received: from mx2.suse.de ([195.135.220.15]:54164 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755568AbXD0KUB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 06:20:01 -0400
From: Danny Kukawka <dkukawka@suse.de>
To: linux-acpi@vger.kernel.org
Subject: [PATCH] ACPI video: Don't export sysfs backlight interface if query _BCL fail
Date: Fri, 27 Apr 2007 12:18:06 +0200
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, luming.yu@intel.com
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200704271218.07411.dkukawka@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

currently the acpi video module export the backlight interface to sysfs also
if acpi_video_device_lcd_query_levels() fails to read _BLC method (e.g. 
because the method is not available). In this case the userspace don't know 
which brightness level are supported and can't set a brightness level (echo 
return with: "write error: Invalid Argument"). This happend e.g. on a ASUS
RF1 (correct supported by the asus-laptop module).

The video module should not export the backlight interface if query _BLC fail,
because you can't set anything from userspace and this make it useless.

See also: http://bugzilla.kernel.org/show_bug.cgi?id=8375

Danny

From: Danny Kukawka <dkukawka@suse.de>
Subject: ACPI video: Don't export sysfs backlight interface if query _BLC fail

if qeuery _BCL fail (e.g. because the method is missing in BIOS) don't 
export the backlight interface to sysfs.

Signed-off-by: Danny Kukawka <dkukawka@suse.de>
---
 video.c |   78 ++++++++++++++++++++++++++++--------------------------
 1 file changed, 41 insertions(+), 37 deletions(-)

--- linux-2.6.21/drivers/acpi/video.c	2007-04-26 13:50:51.000000000 +0200
+++ linux-2.6.21/drivers/acpi/video.c	2007-04-26 13:50:53.000000000 +0200
@@ -531,7 +531,6 @@
 
 static void acpi_video_device_find_cap(struct acpi_video_device *device)
 {
-	acpi_integer status;
 	acpi_handle h_dummy1;
 	int i;
 	u32 max_level = 0;
@@ -565,50 +564,55 @@
 		device->cap._DSS = 1;
 	}
 
-	status = acpi_video_device_lcd_query_levels(device, &obj);
+	if (ACPI_SUCCESS(acpi_video_device_lcd_query_levels(device, &obj))) {
 
-	if (obj && obj->type == ACPI_TYPE_PACKAGE && obj->package.count >= 2) {
-		int count = 0;
-		union acpi_object *o;
-
-		br = kzalloc(sizeof(*br), GFP_KERNEL);
-		if (!br) {
-			printk(KERN_ERR "can't allocate memory\n");
-		} else {
-			br->levels = kmalloc(obj->package.count *
-					     sizeof *(br->levels), GFP_KERNEL);
-			if (!br->levels)
-				goto out;
-
-			for (i = 0; i < obj->package.count; i++) {
-				o = (union acpi_object *)&obj->package.
-				    elements[i];
-				if (o->type != ACPI_TYPE_INTEGER) {
-					printk(KERN_ERR PREFIX "Invalid data\n");
-					continue;
-				}
-				br->levels[count] = (u32) o->integer.value;
-				if (br->levels[count] > max_level)
-					max_level = br->levels[count];
-				count++;
-			}
-		      out:
-			if (count < 2) {
-				kfree(br->levels);
-				kfree(br);
+		if (obj->package.count >= 2) {
+			int count = 0;
+			union acpi_object *o;
+
+			br = kzalloc(sizeof(*br), GFP_KERNEL);
+			if (!br) {
+				printk(KERN_ERR "can't allocate memory\n");
 			} else {
-				br->count = count;
-				device->brightness = br;
-				ACPI_DEBUG_PRINT((ACPI_DB_INFO,
-						  "found %d brightness levels\n",
-						  count));
+				br->levels = kmalloc(obj->package.count *
+						     sizeof *(br->levels), GFP_KERNEL);
+				if (!br->levels) 
+					goto out;
+
+				for (i = 0; i < obj->package.count; i++) {
+					o = (union acpi_object *)&obj->package.
+					    elements[i];
+					if (o->type != ACPI_TYPE_INTEGER) {
+						printk(KERN_ERR PREFIX "Invalid data\n");
+						continue;
+					}
+					br->levels[count] = (u32) o->integer.value;
+
+					if (br->levels[count] > max_level)
+						max_level = br->levels[count];
+					count++;
+				}
+			      out:
+				if (count < 2) {
+					kfree(br->levels);
+					kfree(br);
+				} else {
+					br->count = count;
+					device->brightness = br;
+					ACPI_DEBUG_PRINT((ACPI_DB_INFO,
+							  "found %d brightness levels\n",
+							  count));
+				}
 			}
 		}
+
+	} else {
+		ACPI_DEBUG_PRINT((ACPI_DB_INFO, "Could not query available LCD brightness level\n"));
 	}
 
 	kfree(obj);
 
-	if (device->cap._BCL && device->cap._BCM && device->cap._BQC){
+	if (device->cap._BCL && device->cap._BCM && device->cap._BQC && max_level > 0){
 		unsigned long tmp;
 		static int count = 0;
 		char *name;

