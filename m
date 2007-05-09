Return-Path: <linux-kernel-owner+w=401wt.eu-S1759798AbXEIWLZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759798AbXEIWLZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 18:11:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758578AbXEIWLP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 18:11:15 -0400
Received: from mga03.intel.com ([143.182.124.21]:52811 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758030AbXEIWLN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 18:11:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.14,512,1170662400"; 
   d="scan'208";a="226336551"
Date: Wed, 9 May 2007 15:08:15 -0700
From: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
To: lenb@kernel.org
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ACPI: dock: add immediate_undock option
Message-Id: <20070509150815.32cb7192.kristen.c.accardi@intel.com>
X-Mailer: Sylpheed version 2.2.10 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

ACPI: dock: add immediate_undock option

Allow the driver to be loaded with an option that will allow userspace to
control whether the laptop is ejected immediately when the user presses the
button, or only when the syfs undock file is written.  

if immediate_undock == 1, then when the user presses the undock button, the
laptop will send an event to userspace to notify userspace of the undock, but
then immediately undock without waiting for userspace.  This is the current
behavior, and I set this to be the default.

if immediate_undock == 0, then when the user presses the undock button, the
laptop will send an event to userspace and do nothing.  User space can query
the "flags" sysfs entry to determine if an undock request has been made by
the user (if bit 1 is set).  User space will then need to write the undock 
sysfs entry to complete the undocking process.

Signed-off-by: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Index: 2.6-git/drivers/acpi/dock.c
===================================================================
--- 2.6-git.orig/drivers/acpi/dock.c
+++ 2.6-git/drivers/acpi/dock.c
@@ -40,6 +40,13 @@ MODULE_AUTHOR("Kristen Carlson Accardi")
 MODULE_DESCRIPTION(ACPI_DOCK_DRIVER_DESCRIPTION);
 MODULE_LICENSE("GPL");
 
+static int immediate_undock = 1;
+module_param(immediate_undock, bool, 0644);
+MODULE_PARM_DESC(immediate_undock, "1 (default) will cause the driver to "
+	"undock immediately when the undock button is pressed, 0 will cause"
+	" the driver to wait for userspace to write the undock sysfs file "
+	" before undocking");
+
 static struct atomic_notifier_head dock_notifier_list;
 static struct platform_device *dock_device;
 static char dock_device_name[] = "dock";
@@ -63,6 +70,7 @@ struct dock_dependent_device {
 };
 
 #define DOCK_DOCKING	0x00000001
+#define DOCK_UNDOCKING  0x00000002
 #define DOCK_EVENT	3
 #define UNDOCK_EVENT	2
 
@@ -420,6 +428,16 @@ static inline void complete_dock(struct 
 	ds->last_dock_time = jiffies;
 }
 
+static inline void begin_undock(struct dock_station *ds)
+{
+	ds->flags |= DOCK_UNDOCKING;
+}
+
+static inline void complete_undock(struct dock_station *ds)
+{
+	ds->flags &= ~(DOCK_UNDOCKING);
+}
+
 /**
  * dock_in_progress - see if we are in the middle of handling a dock event
  * @ds: the dock station
@@ -550,7 +568,7 @@ static int handle_eject_request(struct d
 		printk(KERN_ERR PREFIX "Unable to undock!\n");
 		return -EBUSY;
 	}
-
+	complete_undock(ds);
 	return 0;
 }
 
@@ -594,7 +612,11 @@ static void dock_notify(acpi_handle hand
 	 * to the driver who wish to hotplug.
          */
 	case ACPI_NOTIFY_EJECT_REQUEST:
-		handle_eject_request(ds, event);
+		begin_undock(ds);
+		if (immediate_undock)
+			handle_eject_request(ds, event);
+		else
+			dock_event(ds, event, UNDOCK_EVENT);
 		break;
 	default:
 		printk(KERN_ERR PREFIX "Unknown dock event %d\n", event);
@@ -653,6 +675,17 @@ static ssize_t show_docked(struct device
 DEVICE_ATTR(docked, S_IRUGO, show_docked, NULL);
 
 /*
+ * show_flags - read method for flags file in sysfs
+ */
+static ssize_t show_flags(struct device *dev,
+			  struct device_attribute *attr, char *buf)
+{
+	return snprintf(buf, PAGE_SIZE, "%d\n", dock_station->flags);
+
+}
+DEVICE_ATTR(flags, S_IRUGO, show_flags, NULL);
+
+/*
  * write_undock - write method for "undock" file in sysfs
  */
 static ssize_t write_undock(struct device *dev, struct device_attribute *attr,
@@ -717,6 +750,7 @@ static int dock_add(acpi_handle handle)
 		dock_station = NULL;
 		return PTR_ERR(dock_device);
 	}
+
 	ret = device_create_file(&dock_device->dev, &dev_attr_docked);
 	if (ret) {
 		printk("Error %d adding sysfs file\n", ret);
@@ -744,6 +778,17 @@ static int dock_add(acpi_handle handle)
 		dock_station = NULL;
 		return ret;
 	}
+	ret = device_create_file(&dock_device->dev, &dev_attr_flags);
+	if (ret) {
+		printk("Error %d adding sysfs file\n", ret);
+		device_remove_file(&dock_device->dev, &dev_attr_docked);
+		device_remove_file(&dock_device->dev, &dev_attr_undock);
+		device_remove_file(&dock_device->dev, &dev_attr_uid);
+		platform_device_unregister(dock_device);
+		kfree(dock_station);
+		dock_station = NULL;
+		return ret;
+	}
 
 	/* Find dependent devices */
 	acpi_walk_namespace(ACPI_TYPE_DEVICE, ACPI_ROOT_OBJECT,
@@ -781,6 +826,7 @@ dock_add_err_unregister:
 	device_remove_file(&dock_device->dev, &dev_attr_docked);
 	device_remove_file(&dock_device->dev, &dev_attr_undock);
 	device_remove_file(&dock_device->dev, &dev_attr_uid);
+	device_remove_file(&dock_device->dev, &dev_attr_flags);
 	platform_device_unregister(dock_device);
 	kfree(dock_station);
 	dock_station = NULL;
@@ -814,6 +860,7 @@ static int dock_remove(void)
 	device_remove_file(&dock_device->dev, &dev_attr_docked);
 	device_remove_file(&dock_device->dev, &dev_attr_undock);
 	device_remove_file(&dock_device->dev, &dev_attr_uid);
+	device_remove_file(&dock_device->dev, &dev_attr_flags);
 	platform_device_unregister(dock_device);
 
 	/* free dock station memory */
