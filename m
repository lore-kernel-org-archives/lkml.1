Return-Path: <linux-kernel-owner+w=401wt.eu-S968485AbXEHWkG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968485AbXEHWkG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 18:40:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S968480AbXEHWkA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 18:40:00 -0400
Received: from mx1.redhat.com ([66.187.233.31]:52890 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S968479AbXEHWj7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 18:39:59 -0400
Message-ID: <4640FC3B.3010005@redhat.com>
Date: Tue, 08 May 2007 18:39:55 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>
Subject: [patch] ACPI: fix oops after dock driver fails to initialize
Content-Type: multipart/mixed;
 boundary="------------050104070508010703020207"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050104070508010703020207
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit


--------------050104070508010703020207
Content-Type: text/plain;
 name="acpi_fix_bay-dock_oops.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="acpi_fix_bay-dock_oops.patch"

ACPI: fix oops after dock driver fails to initialize

The driver tests the dock_station pointer for nonnull
to check whether it has initialized properly. But in
some cases dock_station will be non-null after being
freed when driver init fails. Fix by zeroing the
pointer after freeing.

Signed-off-by: Chuck Ebbert <cebbert@redhat.com>

---
 drivers/acpi/dock.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- 2.6.21-d390.orig/drivers/acpi/dock.c
+++ 2.6.21-d390/drivers/acpi/dock.c
@@ -698,6 +698,7 @@ static int dock_add(acpi_handle handle)
 	if (ret) {
 		printk(KERN_ERR PREFIX "Error %d registering dock device\n", ret);
 		kfree(dock_station);
+		dock_station = NULL;
 		return ret;
 	}
 	ret = device_create_file(&dock_device.dev, &dev_attr_docked);
@@ -705,6 +706,7 @@ static int dock_add(acpi_handle handle)
 		printk("Error %d adding sysfs file\n", ret);
 		platform_device_unregister(&dock_device);
 		kfree(dock_station);
+		dock_station = NULL;
 		return ret;
 	}
 	ret = device_create_file(&dock_device.dev, &dev_attr_undock);
@@ -713,6 +715,7 @@ static int dock_add(acpi_handle handle)
 		device_remove_file(&dock_device.dev, &dev_attr_docked);
 		platform_device_unregister(&dock_device);
 		kfree(dock_station);
+		dock_station = NULL;
 		return ret;
 	}
 
@@ -725,6 +728,7 @@ static int dock_add(acpi_handle handle)
 	dd = alloc_dock_dependent_device(handle);
 	if (!dd) {
 		kfree(dock_station);
+		dock_station = NULL;
 		ret = -ENOMEM;
 		goto dock_add_err_unregister;
 	}
@@ -752,6 +756,7 @@ dock_add_err_unregister:
 	device_remove_file(&dock_device.dev, &dev_attr_undock);
 	platform_device_unregister(&dock_device);
 	kfree(dock_station);
+	dock_station = NULL;
 	return ret;
 }
 
@@ -785,6 +790,7 @@ static int dock_remove(void)
 
 	/* free dock station memory */
 	kfree(dock_station);
+	dock_station = NULL;
 	return 0;
 }
 

--------------050104070508010703020207--
