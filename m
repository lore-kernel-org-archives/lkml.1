Return-Path: <linux-kernel-owner+w=401wt.eu-S1753983AbYKQNla@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753983AbYKQNla (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 08:41:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751792AbYKQNlU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 08:41:20 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:39293 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751232AbYKQNlT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 08:41:19 -0500
Date: Mon, 17 Nov 2008 13:41:13 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Corentin Chary <corentin.chary@gmail.com>, ecc@cmu.edu
Cc: linux acpi <linux-acpi@vger.kernel.org>, linux-kernel@vger.kernel.org
Subject: [Patch 3/3] eeepc-laptop: Implement rfkill hotplugging in eeepc-laptop
Message-ID: <20081117134112.GE12303@srcf.ucam.org>
References: <20081117133325.GB12303@srcf.ucam.org> <20081117133510.GC12303@srcf.ucam.org> <20081117133804.GD12303@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081117133804.GD12303@srcf.ucam.org>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Eee implements rfkill by logically unplugging the wireless card from 
the PCI bus. Despite sending ACPI notifications, this does not appear to 
be implemented using standard ACPI hotplug - nor does the firmware 
provide the _OSC method required to support native PCIe hotplug. The 
only sensible choice appears to be to handle the hotplugging directly in 
the eeepc-laptop driver. Tested successfully on a 700, 900 and 901.

Signed-off-by: Matthew Garrett <mjg@redhat.com>

---

diff --git a/drivers/misc/eeepc-laptop.c b/drivers/misc/eeepc-laptop.c
index 4d70626..136c742 100644
--- a/drivers/misc/eeepc-laptop.c
+++ b/drivers/misc/eeepc-laptop.c
@@ -30,6 +30,7 @@
 #include <linux/uaccess.h>
 #include <linux/input.h>
 #include <linux/rfkill.h>
+#include <linux/pci.h>
 
 #define EEEPC_LAPTOP_VERSION	"0.1"
 
@@ -517,6 +518,41 @@ static void notify_brn(void)
 	bd->props.brightness = read_brightness(bd);
 }
 
+static void eeepc_rfkill_notify(acpi_handle handle, u32 event, void *data)
+{
+	struct pci_dev *dev;
+	struct pci_bus *bus = pci_find_bus(0, 1);
+
+	if (event != ACPI_NOTIFY_BUS_CHECK)
+		return;
+
+	if (!bus) {
+		printk(EEEPC_WARNING "Unable to find PCI bus 1?\n");
+		return;
+	}
+
+	if (get_acpi(CM_ASL_WLAN) == 1) {
+		dev = pci_get_slot(bus, 0);
+		if (dev) {
+			/* Device already present */
+			pci_dev_put(dev);
+			return;
+		}
+		dev = pci_scan_single_device(bus, 0);
+		if (dev) {
+			pci_bus_assign_resources(bus);
+			if (pci_bus_add_device(dev))
+				printk(EEEPC_ERR "Unable to hotplug wifi\n");
+		}
+	} else {
+		dev = pci_get_slot(bus, 0);
+		if (dev) {
+			pci_remove_bus_device(dev);
+			pci_dev_put(dev);
+		}
+	}
+}
+
 static void eeepc_hotk_notify(acpi_handle handle, u32 event, void *data)
 {
 	static struct key_entry *key;
@@ -543,6 +579,45 @@ static void eeepc_hotk_notify(acpi_handle handle, u32 event, void *data)
 	}
 }
 
+static int eeepc_register_rfkill_notifier(char *node)
+{
+	acpi_status status = AE_OK;
+	acpi_handle handle;
+
+	status = acpi_get_handle(NULL, node, &handle);
+
+	if (ACPI_SUCCESS(status)) {
+		status = acpi_install_notify_handler(handle,
+						     ACPI_SYSTEM_NOTIFY,
+						     eeepc_rfkill_notify,
+						     NULL);
+		if (ACPI_FAILURE(status))
+			printk(EEEPC_WARNING
+			       "Failed to register notify on %s\n", node);
+	} else
+		return -ENODEV;
+
+	return 0;
+}
+
+static void eeepc_unregister_rfkill_notifier(char *node)
+{
+	acpi_status status = AE_OK;
+	acpi_handle handle;
+
+	status = acpi_get_handle(NULL, node, &handle);
+
+	if (ACPI_SUCCESS(status)) {
+		status = acpi_remove_notify_handler(handle,
+						     ACPI_SYSTEM_NOTIFY,
+						     eeepc_rfkill_notify);
+		if (ACPI_FAILURE(status))
+			printk(EEEPC_ERR
+			       "Error removing rfkill notify handler %s\n",
+				node);
+	}
+}
+
 static int eeepc_hotk_add(struct acpi_device *device)
 {
 	acpi_status status = AE_OK;
@@ -622,6 +697,10 @@ static int eeepc_hotk_add(struct acpi_device *device)
 		if (result)
 			goto bluetooth_fail;
 	}
+
+	eeepc_register_rfkill_notifier("\\_SB.PCI0.P0P6");
+	eeepc_register_rfkill_notifier("\\_SB.PCI0.P0P7");
+
 	return 0;
 
  bluetooth_fail:
@@ -650,6 +729,10 @@ static int eeepc_hotk_remove(struct acpi_device *device, int type)
 					    eeepc_hotk_notify);
 	if (ACPI_FAILURE(status))
 		printk(EEEPC_ERR "Error removing notify handler\n");
+
+	eeepc_unregister_rfkill_notifier("\\_SB.PCI0.P0P6");
+	eeepc_unregister_rfkill_notifier("\\_SB.PCI0.P0P7");
+
 	kfree(ehotk);
 	return 0;
 }


-- 
Matthew Garrett | mjg59@srcf.ucam.org
