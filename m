Return-Path: <linux-kernel-owner+w=401wt.eu-S965932AbXHGV1V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965932AbXHGV1V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 17:27:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935847AbXHGU5J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 16:57:09 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:59957 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935872AbXHGU5F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 16:57:05 -0400
Date: Tue, 7 Aug 2007 13:49:16 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Len Brown <len.brown@intel.com>,
       Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Subject: [2.6.22.2 review 75/84] ACPI: dock: fix opps after dock driver
	fails to initialize
Message-ID: <20070807204916.GY23028@kroah.com>
References: <20070807204034.882009319@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="acpi-dock-fix-opps-after-dock-driver-fails-to-initialize.patch"
In-Reply-To: <20070807204157.GA23028@kroah.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Chuck Ebbert <cebbert@redhat.com>

ACPI: dock: fix opps after dock driver fails to initialize

The driver tests the dock_station pointer for nonnull
to check whether it has initialized properly. But in
some cases dock_station will be non-null after being
freed when driver init fails. Fix by zeroing the
pointer after freeing.

Signed-off-by: Chuck Ebbert <cebbert@redhat.com>
Signed-off-by: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/acpi/dock.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/acpi/dock.c
+++ b/drivers/acpi/dock.c
@@ -716,6 +716,7 @@ static int dock_add(acpi_handle handle)
 	if (ret) {
 		printk(KERN_ERR PREFIX "Error %d registering dock device\n", ret);
 		kfree(dock_station);
+		dock_station = NULL;
 		return ret;
 	}
 	ret = device_create_file(&dock_device.dev, &dev_attr_docked);
@@ -723,6 +724,7 @@ static int dock_add(acpi_handle handle)
 		printk("Error %d adding sysfs file\n", ret);
 		platform_device_unregister(&dock_device);
 		kfree(dock_station);
+		dock_station = NULL;
 		return ret;
 	}
 	ret = device_create_file(&dock_device.dev, &dev_attr_undock);
@@ -731,6 +733,7 @@ static int dock_add(acpi_handle handle)
 		device_remove_file(&dock_device.dev, &dev_attr_docked);
 		platform_device_unregister(&dock_device);
 		kfree(dock_station);
+		dock_station = NULL;
 		return ret;
 	}
 	ret = device_create_file(&dock_device.dev, &dev_attr_uid);
@@ -738,6 +741,7 @@ static int dock_add(acpi_handle handle)
 		printk("Error %d adding sysfs file\n", ret);
 		platform_device_unregister(&dock_device);
 		kfree(dock_station);
+		dock_station = NULL;
 		return ret;
 	}
 
@@ -750,6 +754,7 @@ static int dock_add(acpi_handle handle)
 	dd = alloc_dock_dependent_device(handle);
 	if (!dd) {
 		kfree(dock_station);
+		dock_station = NULL;
 		ret = -ENOMEM;
 		goto dock_add_err_unregister;
 	}
@@ -777,6 +782,7 @@ dock_add_err_unregister:
 	device_remove_file(&dock_device.dev, &dev_attr_undock);
 	platform_device_unregister(&dock_device);
 	kfree(dock_station);
+	dock_station = NULL;
 	return ret;
 }
 
@@ -810,6 +816,7 @@ static int dock_remove(void)
 
 	/* free dock station memory */
 	kfree(dock_station);
+	dock_station = NULL;
 	return 0;
 }
 

-- 
