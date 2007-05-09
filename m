Return-Path: <linux-kernel-owner+w=401wt.eu-S1759573AbXEIWHl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759573AbXEIWHl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 18:07:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759206AbXEIWH1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 18:07:27 -0400
Received: from mga09.intel.com ([134.134.136.24]:19158 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759373AbXEIWHZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 18:07:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.14,512,1170662400"; 
   d="scan'208";a="85448472"
Date: Wed, 9 May 2007 15:04:24 -0700
From: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
To: lenb@kernel.org
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       ilya@total-knowledge.com
Subject: [PATCH] ACPI: dock: cleanup the uid patch
Message-Id: <20070509150424.5511a56f.kristen.c.accardi@intel.com>
X-Mailer: Sylpheed version 2.2.10 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

ACPI: dock: cleanup the uid patch

Make uid sysfs file error path free memory, and cleanup sysfs file
when removing driver.  Also fix CodingStyle violations.

Signed-off-by:  Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Cc: Illya A. Volynets-Evenbakh <ilya@total-knowledge.com>
Index: 2.6-git/drivers/acpi/dock.c
===================================================================
--- 2.6-git.orig/drivers/acpi/dock.c
+++ 2.6-git/drivers/acpi/dock.c
@@ -675,16 +675,15 @@ static ssize_t show_dock_uid(struct devi
 			     struct device_attribute *attr, char *buf)
 {
 	unsigned long lbuf;
-	acpi_status status = acpi_evaluate_integer(dock_station->handle, "_UID", NULL, &lbuf);
-	if(ACPI_FAILURE(status)) {
+	acpi_status status = acpi_evaluate_integer(dock_station->handle,
+					"_UID", NULL, &lbuf);
+	if (ACPI_FAILURE(status))
 	    return 0;
-	}
+
 	return snprintf(buf, PAGE_SIZE, "%lx\n", lbuf);
 }
 DEVICE_ATTR(uid, S_IRUGO, show_dock_uid, NULL);
 
-
-
 /**
  * dock_add - add a new dock station
  * @handle: the dock station handle
@@ -736,6 +735,8 @@ static int dock_add(acpi_handle handle)
 	ret = device_create_file(&dock_device.dev, &dev_attr_uid);
 	if (ret) {
 		printk("Error %d adding sysfs file\n", ret);
+		device_remove_file(&dock_device.dev, &dev_attr_docked);
+		device_remove_file(&dock_device.dev, &dev_attr_undock);
 		platform_device_unregister(&dock_device);
 		kfree(dock_station);
 		return ret;
@@ -775,6 +776,7 @@ dock_add_err:
 dock_add_err_unregister:
 	device_remove_file(&dock_device.dev, &dev_attr_docked);
 	device_remove_file(&dock_device.dev, &dev_attr_undock);
+	device_remove_file(&dock_device.dev, &dev_attr_uid);
 	platform_device_unregister(&dock_device);
 	kfree(dock_station);
 	return ret;
@@ -806,6 +808,7 @@ static int dock_remove(void)
 	/* cleanup sysfs */
 	device_remove_file(&dock_device.dev, &dev_attr_docked);
 	device_remove_file(&dock_device.dev, &dev_attr_undock);
+	device_remove_file(&dock_device.dev, &dev_attr_uid);
 	platform_device_unregister(&dock_device);
 
 	/* free dock station memory */
