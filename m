Return-Path: <linux-kernel-owner+w=401wt.eu-S1032413AbXEHVyt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032413AbXEHVyt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 17:54:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967899AbXEHVyp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 17:54:45 -0400
Received: from mx1.redhat.com ([66.187.233.31]:39428 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967890AbXEHVyn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 17:54:43 -0400
Message-ID: <4640F1A0.6050700@redhat.com>
Date: Tue, 08 May 2007 17:54:40 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: kristen.c.accardi@intel.com
CC: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: kernel oops after ACPI dock initialization fails
References: <4640EF28.2000903@redhat.com>
In-Reply-To: <4640EF28.2000903@redhat.com>
Content-Type: multipart/mixed;
 boundary="------------060500010902030402050902"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060500010902030402050902
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Chuck Ebbert wrote:
> In 2.6.21.1 when dock driver initialization fails it does a kfree()
> of dock_station. (Below, this is due to some error installing a
> notify handler.) Later when a bay is discovered it calls 
> is_dock_device() which attempts to lock the (nonexistent)
> dock_station. Reason is this test in is_dock_device():
> 
>         if (!dock_station)
>                 return 0;
> 
> dock_station is 0x6b6b6b6b after being freed. Either it needs
> to be zeroed or some other flag should be used to decide
> whether a dock station is present...
> 

Untested patch attached.



--------------060500010902030402050902
Content-Type: text/plain;
 name="acpi_fix_bay-dock_oops.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="acpi_fix_bay-dock_oops.patch"

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
 

--------------060500010902030402050902--
