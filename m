Return-Path: <linux-kernel-owner+w=401wt.eu-S1030721AbXCFXnF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030721AbXCFXnF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 18:43:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030720AbXCFXnF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 18:43:05 -0500
Received: from mga09.intel.com ([134.134.136.24]:1706 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030706AbXCFXnD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 18:43:03 -0500
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,255,1170662400"; 
   d="scan'208"; a="54041049:sNHT28746774"
Date: Tue, 6 Mar 2007 15:40:46 -0800
From: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
To: lenb@kernel.org
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ACPI: eliminate useless bay events
Message-Id: <20070306154046.942b0706.kristen.c.accardi@intel.com>
X-Mailer: Sylpheed version 2.2.10 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eliminate bay events on resume if nothing has changed.

Signed-off-by: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Index: 2.6-git/drivers/acpi/bay.c
===================================================================
--- 2.6-git.orig/drivers/acpi/bay.c
+++ 2.6-git/drivers/acpi/bay.c
@@ -51,6 +51,7 @@ struct bay {
 	char *name;
 	struct list_head list;
 	struct platform_device *pdev;
+	int present;
 };
 
 static LIST_HEAD(drive_bays);
@@ -125,7 +126,7 @@ static ssize_t show_present(struct devic
 			   struct device_attribute *attr, char *buf)
 {
 	struct bay *bay = dev_get_drvdata(dev);
-	return snprintf(buf, PAGE_SIZE, "%d\n", bay_present(bay));
+	return snprintf(buf, PAGE_SIZE, "%d\n", bay->present);
 
 }
 DEVICE_ATTR(present, S_IRUGO, show_present, NULL);
@@ -142,6 +143,7 @@ static ssize_t write_eject(struct device
 		return -EINVAL;
 
 	eject_device(bay->handle);
+	bay->present = bay_present(bay);
 	return count;
 }
 DEVICE_ATTR(eject, S_IWUSR, NULL, write_eject);
@@ -195,6 +197,8 @@ static int is_ejectable_bay(acpi_handle 
 	return 0;
 }
 
+/* not needed right now */
+#if 0
 /**
  * eject_removable_drive - try to eject this drive
  * @dev : the device structure of the drive
@@ -219,6 +223,7 @@ int eject_removable_drive(struct device 
 	return 0;
 }
 EXPORT_SYMBOL_GPL(eject_removable_drive);
+#endif
 
 static int acpi_bay_add_fs(struct bay *bay)
 {
@@ -308,6 +313,9 @@ static int bay_add(acpi_handle handle, i
 		register_hotplug_dock_device(handle, bay_notify, new_bay);
 	}
 	list_add(&new_bay->list, &drive_bays);
+
+	new_bay->present = bay_present(new_bay);
+
 	printk(KERN_INFO PREFIX "Bay [%s] Added\n", new_bay->name);
 	return 0;
 
@@ -329,10 +337,14 @@ static void bay_notify(acpi_handle handl
 	struct bay *bay_dev = (struct bay *)data;
 	struct device *dev = &bay_dev->pdev->dev;
 
-	bay_dprintk(handle, "Bay event");
+	bay_dprintk(handle, "Bay event\n");
 
 	switch(event) {
 	case ACPI_NOTIFY_BUS_CHECK:
+		/* eliminate notifications on resumes */
+		if (bay_dev->present && bay_present(bay_dev))
+			break;
+		bay_dev->present = bay_present(bay_dev);
 	case ACPI_NOTIFY_DEVICE_CHECK:
 	case ACPI_NOTIFY_EJECT_REQUEST:
 		kobject_uevent(&dev->kobj, KOBJ_CHANGE);
