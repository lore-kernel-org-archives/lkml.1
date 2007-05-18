Return-Path: <linux-kernel-owner+w=401wt.eu-S1761222AbXERU5P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761222AbXERU5P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 16:57:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757491AbXERU46
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 16:56:58 -0400
Received: from mga01.intel.com ([192.55.52.88]:27934 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756833AbXERU4z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 16:56:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.14,553,1170662400"; 
   d="scan'208";a="247212469"
Date: Fri, 18 May 2007 13:53:26 -0700
From: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
To: lenb@kernel.org
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ACPI: bay: send envp with uevent
Message-Id: <20070518135326.52aa7e91.kristen.c.accardi@intel.com>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Make the bay driver send env information on bay events.  

Upon any bay event, we will send the string "BAY_EVENT=%d" along with the 
KOBJ_CHANGE, and report the event number.  What the event number means will 
be platform specific.  Event 3 is always an eject request, but an insert 
may be either event 1, or it may be event 0.  Event 1 may also be a
remove request.  It would be best if you check the number of your event 
with udevmonitor before writing any udev scripts for inserting and 
removing drive bays.

Signed-off-by:  Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Cc:  Stephan Berberig <s.berberig@arcor.de>

Index: 2.6-git/drivers/acpi/bay.c
===================================================================
--- 2.6-git.orig/drivers/acpi/bay.c
+++ 2.6-git/drivers/acpi/bay.c
@@ -328,18 +328,12 @@ static void bay_notify(acpi_handle handl
 {
 	struct bay *bay_dev = (struct bay *)data;
 	struct device *dev = &bay_dev->pdev->dev;
+	char event_string[12];
+	char *envp[] = { event_string, NULL };
 
 	bay_dprintk(handle, "Bay event");
-
-	switch(event) {
-	case ACPI_NOTIFY_BUS_CHECK:
-	case ACPI_NOTIFY_DEVICE_CHECK:
-	case ACPI_NOTIFY_EJECT_REQUEST:
-		kobject_uevent(&dev->kobj, KOBJ_CHANGE);
-		break;
-	default:
-		printk(KERN_ERR PREFIX "Bay: unknown event %d\n", event);
-	}
+	sprintf(event_string, "BAY_EVENT=%d\n", event);
+	kobject_uevent_env(&dev->kobj, KOBJ_CHANGE, envp);
 }
 
 static acpi_status
