Return-Path: <linux-kernel-owner+w=401wt.eu-S1754579AbYE2IWb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754579AbYE2IWb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 04:22:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751974AbYE2IWW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 04:22:22 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:58837 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751384AbYE2IWU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 04:22:20 -0400
Date: Thu, 29 May 2008 09:22:02 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: linux-input@vger.kernel.org
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       kristen.c.accardi@intel.com
Message-ID: <20080529082202.GD16444@srcf.ucam.org>
References: <20080528130621.GA32646@srcf.ucam.org> <20080528132152.GB32646@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080528132152.GB32646@srcf.ucam.org>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: Version 2: [PATCH 2/3] ACPI: Send switch event on dock events
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Send a switch event on docking for consistency with docks that don't 
present as a separate device.

Signed-off-by: Matthew Garrett <mjg@redhat.com>

---

Added a dependency on CONFIG_INPUT for the dock driver. This is 
consistent with the other ACPI modules that send input events.

diff --git a/drivers/acpi/Kconfig b/drivers/acpi/Kconfig
index c52fca8..df8de04 100644
--- a/drivers/acpi/Kconfig
+++ b/drivers/acpi/Kconfig
@@ -160,6 +160,7 @@ config ACPI_FAN
 
 config ACPI_DOCK
 	tristate "Dock"
+	depends on INPUT
 	depends on EXPERIMENTAL
 	help
 	  This driver adds support for ACPI controlled docking stations
diff --git a/drivers/acpi/dock.c b/drivers/acpi/dock.c
index fa44fb9..a67e74c 100644
--- a/drivers/acpi/dock.c
+++ b/drivers/acpi/dock.c
@@ -25,6 +25,7 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/init.h>
+#include <linux/input.h>
 #include <linux/types.h>
 #include <linux/notifier.h>
 #include <linux/platform_device.h>
@@ -65,6 +66,7 @@ struct dock_station {
 	struct mutex hp_lock;
 	struct list_head dependent_devices;
 	struct list_head hotplug_devices;
+	struct input_dev *dock_input;
 };
 
 struct dock_dependent_device {
@@ -345,10 +347,13 @@ static void dock_event(struct dock_station *ds, u32 event, int num)
 	char event_string[13];
 	char *envp[] = { event_string, NULL };
 
-	if (num == UNDOCK_EVENT)
+	if (num == UNDOCK_EVENT) {
+		input_report_switch(dock_station->dock_input, SW_DOCK, 0);
 		sprintf(event_string, "EVENT=undock");
-	else
+	} else {
+		input_report_switch(dock_station->dock_input, SW_DOCK, 1);
 		sprintf(event_string, "EVENT=dock");
+	}
 
 	/*
 	 * Indicate that the status of the dock station has
@@ -834,6 +839,19 @@ static int dock_add(acpi_handle handle)
 		goto dock_add_err;
 	}
 
+	/* Set up input device */
+	dock_station->dock_input = input_allocate_device();
+	dock_station->dock_input->name = "ACPI dock";
+	dock_station->dock_input->phys = "dock/input0";
+	dock_station->dock_input->id.bustype = BUS_HOST;
+	dock_station->dock_input->dev.parent = &dock_device->dev;
+	set_bit(EV_SW, dock_station->dock_input->evbit);
+	set_bit(SW_DOCK, dock_station->dock_input->swbit);
+	ret = input_register_device(dock_station->dock_input);
+
+	if (ret)
+		input_free_device(dock_station->dock_input);
+
 	printk(KERN_INFO PREFIX "%s \n", ACPI_DOCK_DRIVER_DESCRIPTION);
 
 	return 0;
@@ -881,6 +899,8 @@ static int dock_remove(void)
 	device_remove_file(&dock_device->dev, &dev_attr_flags);
 	platform_device_unregister(dock_device);
 
+	input_unregister_device(dock_station->dock_input);
+
 	/* free dock station memory */
 	kfree(dock_station);
 	dock_station = NULL;

-- 
Matthew Garrett | mjg59@srcf.ucam.org
