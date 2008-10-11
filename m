Return-Path: <linux-kernel-owner+w=401wt.eu-S1763284AbYJKG4u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763284AbYJKG4u (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2008 02:56:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757209AbYJKGkM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Oct 2008 02:40:12 -0400
Received: from vms172071pub.verizon.net ([206.46.172.71]:52144 "EHLO
	vms172071pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752682AbYJKGhB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2008 02:37:01 -0400
Date: Sat, 11 Oct 2008 02:35:58 -0400
From: Len Brown <lenb@kernel.org>
Subject: [PATCH 38/85] dock: add 'type' sysfs file
In-reply-to: <1223707005-26864-1-git-send-email-lenb@kernel.org>
In-reply-to: <1d80ebdb81444701024ad9b9f026516561496a43.1223706853.git.len.brown@intel.com>
To: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Shaohua Li <shaohua.li@intel.com>, Len Brown <len.brown@intel.com>
Message-id: <8652b00fd6416773f113dab3dfa0d4509def825b.1223706853.git.len.brown@intel.com>
Organization: Intel Open Source Technology Center
X-Mailer: git-send-email 1.6.0.2.307.gc427
References: <1223707005-26864-1-git-send-email-lenb@kernel.org>
References: <1d80ebdb81444701024ad9b9f026516561496a43.1223706853.git.len.brown@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Shaohua Li <shaohua.li@intel.com>

add a sysfs file to present dock type. Suggested by Holger.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/acpi/dock.c |   25 +++++++++++++++++++++++++
 1 files changed, 25 insertions(+), 0 deletions(-)

diff --git a/drivers/acpi/dock.c b/drivers/acpi/dock.c
index c877cc5..b7d1581 100644
--- a/drivers/acpi/dock.c
+++ b/drivers/acpi/dock.c
@@ -911,6 +911,26 @@ static ssize_t show_dock_uid(struct device *dev,
 }
 static DEVICE_ATTR(uid, S_IRUGO, show_dock_uid, NULL);
 
+static ssize_t show_dock_type(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct dock_station *dock_station = *((struct dock_station **)
+		dev->platform_data);
+	char *type;
+
+	if (dock_station->flags & DOCK_IS_DOCK)
+		type = "dock_station";
+	else if (dock_station->flags & DOCK_IS_ATA)
+		type = "ata_bay";
+	else if (dock_station->flags & DOCK_IS_BAT)
+		type = "battery_bay";
+	else
+		type = "unknown";
+
+	return snprintf(buf, PAGE_SIZE, "%s\n", type);
+}
+static DEVICE_ATTR(type, S_IRUGO, show_dock_type, NULL);
+
 /**
  * dock_add - add a new dock station
  * @handle: the dock station handle
@@ -999,6 +1019,9 @@ static int dock_add(acpi_handle handle)
 		dock_station = NULL;
 		return ret;
 	}
+	ret = device_create_file(&dock_device->dev, &dev_attr_type);
+	if (ret)
+		printk(KERN_ERR"Error %d adding sysfs file\n", ret);
 
 	/* Find dependent devices */
 	acpi_walk_namespace(ACPI_TYPE_DEVICE, ACPI_ROOT_OBJECT,
@@ -1020,6 +1043,7 @@ static int dock_add(acpi_handle handle)
 	return 0;
 
 dock_add_err_unregister:
+	device_remove_file(&dock_device->dev, &dev_attr_type);
 	device_remove_file(&dock_device->dev, &dev_attr_docked);
 	device_remove_file(&dock_device->dev, &dev_attr_undock);
 	device_remove_file(&dock_device->dev, &dev_attr_uid);
@@ -1047,6 +1071,7 @@ static int dock_remove(struct dock_station *dock_station)
 	    kfree(dd);
 
 	/* cleanup sysfs */
+	device_remove_file(&dock_device->dev, &dev_attr_type);
 	device_remove_file(&dock_device->dev, &dev_attr_docked);
 	device_remove_file(&dock_device->dev, &dev_attr_undock);
 	device_remove_file(&dock_device->dev, &dev_attr_uid);
-- 
1.5.5.1

