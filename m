Return-Path: <linux-kernel-owner+w=401wt.eu-S1754309AbZJPVPZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754309AbZJPVPZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 17:15:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754917AbZJPVPU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 17:15:20 -0400
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:28968 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753806AbZJPVPQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 17:15:16 -0400
Subject: [PATCH v3 5/6] ACPI: dock: add struct dock_station * directly to
	platform device data
To: lenb@kernel.org
From: Alex Chiang <achiang@hp.com>
Cc: shaohua.li@intel.com, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org
Date: Fri, 16 Oct 2009 15:15:19 -0600
Message-ID: <20091016211519.12126.21369.stgit@bob.kio>
In-Reply-To: <20091016211323.12126.58457.stgit@bob.kio>
References: <20091016211323.12126.58457.stgit@bob.kio>
User-Agent: StGit/0.14.3.386.gb02d
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of adding a (struct dock_station **) to our dock device's
platform data, we can add the (struct dock_station *) directly.

This change saves us some ugly casting and improves readability.

The cost of making this change is an extra 290 bytes of stack usage,
but this is an infrequently called code-path and unlikely to cause
the kernel to blow up.

Signed-off-by: Alex Chiang <achiang@hp.com>
---

 drivers/acpi/dock.c |   40 +++++++++++++---------------------------
 1 files changed, 13 insertions(+), 27 deletions(-)

diff --git a/drivers/acpi/dock.c b/drivers/acpi/dock.c
index 939babe..e0441fb 100644
--- a/drivers/acpi/dock.c
+++ b/drivers/acpi/dock.c
@@ -843,8 +843,7 @@ static ssize_t show_docked(struct device *dev,
 {
 	struct acpi_device *tmp;
 
-	struct dock_station *dock_station = *((struct dock_station **)
-		dev->platform_data);
+	struct dock_station *dock_station = dev->platform_data;
 
 	if (ACPI_SUCCESS(acpi_bus_get_device(dock_station->handle, &tmp)))
 		return snprintf(buf, PAGE_SIZE, "1\n");
@@ -858,8 +857,7 @@ static DEVICE_ATTR(docked, S_IRUGO, show_docked, NULL);
 static ssize_t show_flags(struct device *dev,
 			  struct device_attribute *attr, char *buf)
 {
-	struct dock_station *dock_station = *((struct dock_station **)
-		dev->platform_data);
+	struct dock_station *dock_station = dev->platform_data;
 	return snprintf(buf, PAGE_SIZE, "%d\n", dock_station->flags);
 
 }
@@ -872,8 +870,7 @@ static ssize_t write_undock(struct device *dev, struct device_attribute *attr,
 			   const char *buf, size_t count)
 {
 	int ret;
-	struct dock_station *dock_station = *((struct dock_station **)
-		dev->platform_data);
+	struct dock_station *dock_station = dev->platform_data;
 
 	if (!count)
 		return -EINVAL;
@@ -891,8 +888,7 @@ static ssize_t show_dock_uid(struct device *dev,
 			     struct device_attribute *attr, char *buf)
 {
 	unsigned long long lbuf;
-	struct dock_station *dock_station = *((struct dock_station **)
-		dev->platform_data);
+	struct dock_station *dock_station = dev->platform_data;
 	acpi_status status = acpi_evaluate_integer(dock_station->handle,
 					"_UID", NULL, &lbuf);
 	if (ACPI_FAILURE(status))
@@ -905,8 +901,7 @@ static DEVICE_ATTR(uid, S_IRUGO, show_dock_uid, NULL);
 static ssize_t show_dock_type(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
-	struct dock_station *dock_station = *((struct dock_station **)
-		dev->platform_data);
+	struct dock_station *dock_station = dev->platform_data;
 	char *type;
 
 	if (dock_station->flags & DOCK_IS_DOCK)
@@ -944,20 +939,18 @@ static struct attribute_group dock_attribute_group = {
  */
 static int dock_add(acpi_handle handle)
 {
-	int ret;
-	struct dock_station *dock_station;
+	int ret, id;
+	struct dock_station ds, *dock_station;
 	struct platform_device *dock_device;
 
+	id = dock_station_count;
 	dock_device =
-		platform_device_register_simple("dock",
-			dock_station_count, NULL, 0);
+		platform_device_register_data(NULL, "dock",
+			id, &ds, sizeof(ds));
 	if (IS_ERR(dock_device))
 		return PTR_ERR(dock_device);
 
-	/* allocate & initialize the dock_station private data */
-	dock_station = kzalloc(sizeof(*dock_station), GFP_KERNEL);
-	if (!dock_station)
-		return -ENOMEM;
+	dock_station = dock_device->dev.platform_data;
 	dock_station->handle = handle;
 	dock_station->dock_device = dock_device;
 	dock_station->last_dock_time = jiffies - HZ;
@@ -968,9 +961,6 @@ static int dock_add(acpi_handle handle)
 	mutex_init(&dock_station->hp_lock);
 	ATOMIC_INIT_NOTIFIER_HEAD(&dock_notifier_list);
 
-	platform_device_add_data(dock_device, &dock_station,
-		sizeof(struct dock_station *));
-
 	/* we want the dock device to send uevents */
 	dev_set_uevent_suppress(&dock_device->dev, 0);
 
@@ -1003,9 +993,6 @@ err_unregister:
 	printk(KERN_ERR "%s encountered error %d\n", __func__, ret);
 	sysfs_remove_group(&dock_device->dev.kobj, &dock_attribute_group);
 	platform_device_unregister(dock_device);
-out:
-	kfree(dock_station);
-	dock_station = NULL;
 	return ret;
 }
 
@@ -1025,13 +1012,12 @@ static int dock_remove(struct dock_station *dock_station)
 				 list)
 	    kfree(dd);
 
+	list_del(&dock_station->sibling);
+
 	/* cleanup sysfs */
 	sysfs_remove_group(&dock_device->dev.kobj, &dock_attribute_group);
 	platform_device_unregister(dock_device);
 
-	/* free dock station memory */
-	kfree(dock_station);
-	dock_station = NULL;
 	return 0;
 }
 

