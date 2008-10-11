Return-Path: <linux-kernel-owner+w=401wt.eu-S1759689AbYJKG6K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759689AbYJKG6K (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2008 02:58:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756573AbYJKGkX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Oct 2008 02:40:23 -0400
Received: from vms172069pub.verizon.net ([206.46.172.69]:32774 "EHLO
	vms172069pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752299AbYJKGg7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2008 02:36:59 -0400
Date: Sat, 11 Oct 2008 02:35:52 -0400
From: Len Brown <lenb@kernel.org>
Subject: [PATCH 32/85] ACPI: introduce notifier change to avoid duplicates
In-reply-to: <1223707005-26864-1-git-send-email-lenb@kernel.org>
In-reply-to: <1d80ebdb81444701024ad9b9f026516561496a43.1223706853.git.len.brown@intel.com>
To: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Shaohua Li <shaohua.li@intel.com>, Len Brown <len.brown@intel.com>
Message-id: <6bd00a61ab63d4ceb635ae0316353c11c900b8d8.1223706853.git.len.brown@intel.com>
Organization: Intel Open Source Technology Center
X-Mailer: git-send-email 1.6.0.2.307.gc427
References: <1223707005-26864-1-git-send-email-lenb@kernel.org>
References: <1d80ebdb81444701024ad9b9f026516561496a43.1223706853.git.len.brown@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Shaohua Li <shaohua.li@intel.com>

The battery driver already registers notification handler.
To avoid registering notification handler again,
introduce a notifier chain in global system notifier handler
and use it in dock driver.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/acpi/bus.c      |   15 +++++++++++++++
 drivers/acpi/dock.c     |   46 ++++++++++++++++++++++++----------------------
 include/acpi/acpi_bus.h |    3 +++
 3 files changed, 42 insertions(+), 22 deletions(-)

diff --git a/drivers/acpi/bus.c b/drivers/acpi/bus.c
index ccae305..0dc4494 100644
--- a/drivers/acpi/bus.c
+++ b/drivers/acpi/bus.c
@@ -496,6 +496,19 @@ static int acpi_bus_check_scope(struct acpi_device *device)
 	return 0;
 }
 
+static BLOCKING_NOTIFIER_HEAD(acpi_bus_notify_list);
+int register_acpi_bus_notifier(struct notifier_block *nb)
+{
+	return blocking_notifier_chain_register(&acpi_bus_notify_list, nb);
+}
+EXPORT_SYMBOL_GPL(register_acpi_bus_notifier);
+
+void unregister_acpi_bus_notifier(struct notifier_block *nb)
+{
+	blocking_notifier_chain_unregister(&acpi_bus_notify_list, nb);
+}
+EXPORT_SYMBOL_GPL(unregister_acpi_bus_notifier);
+
 /**
  * acpi_bus_notify
  * ---------------
@@ -506,6 +519,8 @@ static void acpi_bus_notify(acpi_handle handle, u32 type, void *data)
 	int result = 0;
 	struct acpi_device *device = NULL;
 
+	blocking_notifier_call_chain(&acpi_bus_notify_list,
+		type, (void *)handle);
 
 	if (acpi_bus_get_device(handle, &device))
 		return;
diff --git a/drivers/acpi/dock.c b/drivers/acpi/dock.c
index 799a0fd..2563bc6 100644
--- a/drivers/acpi/dock.c
+++ b/drivers/acpi/dock.c
@@ -748,6 +748,28 @@ static void dock_notify(acpi_handle handle, u32 event, void *data)
 	}
 }
 
+static int acpi_dock_notifier_call(struct notifier_block *this,
+	unsigned long event, void *data)
+{
+	struct dock_station *dock_station;
+	acpi_handle handle = (acpi_handle)data;
+
+	if (event != ACPI_NOTIFY_BUS_CHECK && event != ACPI_NOTIFY_DEVICE_CHECK
+	   && event != ACPI_NOTIFY_EJECT_REQUEST)
+		return 0;
+	list_for_each_entry(dock_station, &dock_stations, sibiling) {
+		if (dock_station->handle == handle) {
+			dock_notify(handle, event, dock_station);
+			return 0 ;
+		}
+	}
+	return 0;
+}
+
+static struct notifier_block dock_acpi_notifier = {
+	.notifier_call = acpi_dock_notifier_call,
+};
+
 /**
  * find_dock_devices - find devices on the dock station
  * @handle: the handle of the device we are examining
@@ -861,7 +883,6 @@ static DEVICE_ATTR(uid, S_IRUGO, show_dock_uid, NULL);
 static int dock_add(acpi_handle handle)
 {
 	int ret;
-	acpi_status status;
 	struct dock_dependent_device *dd;
 	struct dock_station *dock_station;
 	struct platform_device *dock_device;
@@ -956,23 +977,10 @@ static int dock_add(acpi_handle handle)
 	}
 	add_dock_dependent_device(dock_station, dd);
 
-	/* register for dock events */
-	status = acpi_install_notify_handler(dock_station->handle,
-					     ACPI_SYSTEM_NOTIFY,
-					     dock_notify, dock_station);
-
-	if (ACPI_FAILURE(status)) {
-		printk(KERN_ERR PREFIX "Error installing notify handler\n");
-		ret = -ENODEV;
-		goto dock_add_err;
-	}
-
 	dock_station_count++;
 	list_add(&dock_station->sibiling, &dock_stations);
 	return 0;
 
-dock_add_err:
-	kfree(dd);
 dock_add_err_unregister:
 	device_remove_file(&dock_device->dev, &dev_attr_docked);
 	device_remove_file(&dock_device->dev, &dev_attr_undock);
@@ -990,7 +998,6 @@ dock_add_err_unregister:
 static int dock_remove(struct dock_station *dock_station)
 {
 	struct dock_dependent_device *dd, *tmp;
-	acpi_status status;
 	struct platform_device *dock_device = dock_station->dock_device;
 
 	if (!dock_station_count)
@@ -1001,13 +1008,6 @@ static int dock_remove(struct dock_station *dock_station)
 				 list)
 	    kfree(dd);
 
-	/* remove dock notify handler */
-	status = acpi_remove_notify_handler(dock_station->handle,
-					    ACPI_SYSTEM_NOTIFY,
-					    dock_notify);
-	if (ACPI_FAILURE(status))
-		printk(KERN_ERR "Error removing notify handler\n");
-
 	/* cleanup sysfs */
 	device_remove_file(&dock_device->dev, &dev_attr_docked);
 	device_remove_file(&dock_device->dev, &dev_attr_undock);
@@ -1069,6 +1069,7 @@ static int __init dock_init(void)
 		return 0;
 	}
 
+	register_acpi_bus_notifier(&dock_acpi_notifier);
 	printk(KERN_INFO PREFIX "%s: %d docks/bays found\n",
 		ACPI_DOCK_DRIVER_DESCRIPTION, dock_station_count);
 	return 0;
@@ -1078,6 +1079,7 @@ static void __exit dock_exit(void)
 {
 	struct dock_station *dock_station;
 
+	unregister_acpi_bus_notifier(&dock_acpi_notifier);
 	list_for_each_entry(dock_station, &dock_stations, sibiling)
 		dock_remove(dock_station);
 }
diff --git a/include/acpi/acpi_bus.h b/include/acpi/acpi_bus.h
index a5ac0bc..f74f882 100644
--- a/include/acpi/acpi_bus.h
+++ b/include/acpi/acpi_bus.h
@@ -327,6 +327,9 @@ int acpi_bus_get_private_data(acpi_handle, void **);
 extern int acpi_notifier_call_chain(struct acpi_device *, u32, u32);
 extern int register_acpi_notifier(struct notifier_block *);
 extern int unregister_acpi_notifier(struct notifier_block *);
+
+extern int register_acpi_bus_notifier(struct notifier_block *nb);
+extern void unregister_acpi_bus_notifier(struct notifier_block *nb);
 /*
  * External Functions
  */
-- 
1.5.5.1

