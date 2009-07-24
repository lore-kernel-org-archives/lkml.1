Return-Path: <linux-kernel-owner+w=401wt.eu-S1752146AbZGXDBs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752146AbZGXDBs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 23:01:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752089AbZGXDBk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 23:01:40 -0400
Received: from mga01.intel.com ([192.55.52.88]:63828 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751962AbZGXDBg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 23:01:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,259,1246863600"; 
   d="scan'208";a="477569761"
Subject: [PATCH V2 3/4] ACPI battery: support async resume
From: Zhang Rui <rui.zhang@intel.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-pm <linux-pm@lists.linux-foundation.org>,
       linux-acpi <linux-acpi@vger.kernel.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Pavel Machek <pavel@ucw.cz>,
       Len Brown <lenb@kernel.org>, Alan Stern <stern@rowland.harvard.edu>,
       Arjan van de Ven <arjan@linux.intel.com>,
       "Zhang, Rui" <rui.zhang@intel.com>
Content-Type: text/plain
Date: Fri, 24 Jul 2009 11:02:10 +0800
Message-Id: <1248404530.2670.111.camel@rzhang-dt>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


ACPI battery supports device async actions.

Create an async domain for every ACPI battery device,
so that ACPI battery can be resumed asynchronously.

Signed-off-by: Zhang Rui <rui.zhang@intel.com>
---
 drivers/acpi/battery.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

Index: linux-2.6/drivers/acpi/battery.c
===================================================================
--- linux-2.6.orig/drivers/acpi/battery.c
+++ linux-2.6/drivers/acpi/battery.c
@@ -829,6 +829,17 @@ static int acpi_battery_add(struct acpi_
 	strcpy(acpi_device_class(device), ACPI_BATTERY_CLASS);
 	device->driver_data = battery;
 	mutex_init(&battery->lock);
+
+	/*
+	 * dev_async_register must be called before any of its child
+	 * device being registered, i.e. power supply sysfs class device.
+	 */
+	result = dev_async_register(&device->dev, DEV_ASYNC_RESUME);
+	if (result) {
+		kfree(battery);
+		return result;
+	}
+
 	acpi_battery_update(battery);
 #ifdef CONFIG_ACPI_PROCFS_POWER
 	result = acpi_battery_add_fs(device);
@@ -841,6 +852,7 @@ static int acpi_battery_add(struct acpi_
 #ifdef CONFIG_ACPI_PROCFS_POWER
 		acpi_battery_remove_fs(device);
 #endif
+		dev_async_unregister(&device->dev);
 		kfree(battery);
 	}
 	return result;
@@ -859,6 +871,7 @@ static int acpi_battery_remove(struct ac
 #ifdef CONFIG_ACPI_SYSFS_POWER
 	sysfs_remove_battery(battery);
 #endif
+	dev_async_unregister(&device->dev);
 	mutex_destroy(&battery->lock);
 	kfree(battery);
 	return 0;


