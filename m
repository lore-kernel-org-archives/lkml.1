Return-Path: <linux-kernel-owner+w=401wt.eu-S1753070AbZIJSeE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753070AbZIJSeE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 14:34:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753050AbZIJSeD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 14:34:03 -0400
Received: from g4t0017.houston.hp.com ([15.201.24.20]:44315 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752994AbZIJSeA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 14:34:00 -0400
Subject: [PATCH v2 2/2] PCI Hotplug: convert acpi_pci_detect_ejectable() to
	take an acpi_handle
To: jbarnes@virtuousgeek.org
From: Alex Chiang <achiang@hp.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Date: Thu, 10 Sep 2009 12:34:09 -0600
Message-ID: <20090910183409.20011.76128.stgit@bob.kio>
In-Reply-To: <20090910183219.20011.41679.stgit@bob.kio>
References: <20090910183219.20011.41679.stgit@bob.kio>
User-Agent: StGit/0.14.3.386.gb02d
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

acpi_pci_detect_ejectable() goes through effort to convert its
struct pci_bus arg to an acpi_handle, but every time we use this
interface, we already have the handle available.

So let's just use the handle instead of converting back and forth.

Cc: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Signed-off-by: Alex Chiang <achiang@hp.com>
---

 drivers/pci/hotplug/acpi_pcihp.c   |   12 ++++++------
 drivers/pci/hotplug/acpiphp_glue.c |   33 +++++++++++----------------------
 drivers/pci/hotplug/pciehp_acpi.c  |    7 ++++---
 include/linux/pci_hotplug.h        |    2 +-
 4 files changed, 22 insertions(+), 32 deletions(-)

diff --git a/drivers/pci/hotplug/acpi_pcihp.c b/drivers/pci/hotplug/acpi_pcihp.c
index eb15958..ec3c039 100644
--- a/drivers/pci/hotplug/acpi_pcihp.c
+++ b/drivers/pci/hotplug/acpi_pcihp.c
@@ -500,18 +500,18 @@ check_hotplug(acpi_handle handle, u32 lvl, void *context, void **rv)
 
 /**
  * acpi_pci_detect_ejectable - check if the PCI bus has ejectable slots
- * @pbus - PCI bus to scan
+ * @handle - handle of the PCI bus to scan
  *
  * Returns 1 if the PCI bus has ACPI based ejectable slots, 0 otherwise.
  */
-int acpi_pci_detect_ejectable(struct pci_bus *pbus)
+int acpi_pci_detect_ejectable(acpi_handle handle)
 {
-	acpi_handle handle;
 	int found = 0;
 
-	if (!(handle = acpi_pci_get_bridge_handle(pbus)))
-		return 0;
-	acpi_walk_namespace(ACPI_TYPE_DEVICE, handle, (u32)1,
+	if (!handle)
+		return found;
+
+	acpi_walk_namespace(ACPI_TYPE_DEVICE, handle, 1,
 			    check_hotplug, (void *)&found, NULL);
 	return found;
 }
diff --git a/drivers/pci/hotplug/acpiphp_glue.c b/drivers/pci/hotplug/acpiphp_glue.c
index e72e0ad..680c336 100644
--- a/drivers/pci/hotplug/acpiphp_glue.c
+++ b/drivers/pci/hotplug/acpiphp_glue.c
@@ -62,22 +62,6 @@ static void acpiphp_sanitize_bus(struct pci_bus *bus);
 static void acpiphp_set_hpp_values(acpi_handle handle, struct pci_bus *bus);
 static void handle_hotplug_event_func(acpi_handle handle, u32 type, void *context);
 
-static struct pci_bus *pci_bus_from_handle(acpi_handle handle)
-{
-	struct pci_bus *pbus;
-	struct acpi_pci_root *root;
-
-	root = acpi_pci_find_root(handle);
-	if (root)
-		pbus = root->bus;
-	else {
-		struct pci_dev *pdev = acpi_get_pci_dev(handle);
-		pbus = pdev->subordinate;
-		pci_dev_put(pdev);
-	}
-	return pbus;
-}
-
 /* callback routine to check for the existence of a pci dock device */
 static acpi_status
 is_pci_dock_device(acpi_handle handle, u32 lvl, void *context, void **rv)
@@ -279,11 +263,7 @@ register_slot(acpi_handle handle, u32 lvl, void *context, void **rv)
 /* see if it's worth looking at this bridge */
 static int detect_ejectable_slots(acpi_handle handle)
 {
-	int found;
-	struct pci_bus *pbus;
-
-	pbus = pci_bus_from_handle(handle);
-	found = acpi_pci_detect_ejectable(pbus);
+	int found = acpi_pci_detect_ejectable(handle);
 	if (!found) {
 		acpi_walk_namespace(ACPI_TYPE_DEVICE, handle, (u32)1,
 				    is_pci_dock_device, (void *)&found, NULL);
@@ -1364,7 +1344,16 @@ static void acpiphp_sanitize_bus(struct pci_bus *bus)
 /* Program resources in newly inserted bridge */
 static int acpiphp_configure_bridge (acpi_handle handle)
 {
-	struct pci_bus *bus = pci_bus_from_handle(handle);
+	struct pci_bus *bus;
+
+	if (acpi_is_root_bridge(handle)) {
+		struct acpi_pci_root *root = acpi_pci_find_root(handle);
+		bus = root->bus;
+	} else {
+		struct pci_dev *pdev = acpi_get_pci_dev(handle);
+		bus = pdev->subordinate;
+		pci_dev_put(pdev);
+	}
 
 	pci_bus_size_bridges(bus);
 	pci_bus_assign_resources(bus);
diff --git a/drivers/pci/hotplug/pciehp_acpi.c b/drivers/pci/hotplug/pciehp_acpi.c
index 9604801..7163e6a 100644
--- a/drivers/pci/hotplug/pciehp_acpi.c
+++ b/drivers/pci/hotplug/pciehp_acpi.c
@@ -47,7 +47,7 @@ int pciehp_acpi_slot_detection_check(struct pci_dev *dev)
 {
 	if (slot_detection_mode != PCIEHP_DETECT_ACPI)
 		return 0;
-	if (acpi_pci_detect_ejectable(dev->subordinate))
+	if (acpi_pci_detect_ejectable(DEVICE_ACPI_HANDLE(&dev->dev)))
 		return 0;
 	return -ENODEV;
 }
@@ -76,9 +76,9 @@ static int __init dummy_probe(struct pcie_device *dev)
 {
 	int pos;
 	u32 slot_cap;
+	acpi_handle handle;
 	struct slot *slot, *tmp;
 	struct pci_dev *pdev = dev->port;
-	struct pci_bus *pbus = pdev->subordinate;
 	/* Note: pciehp_detect_mode != PCIEHP_DETECT_ACPI here */
 	if (pciehp_get_hp_hw_control_from_firmware(pdev))
 		return -ENODEV;
@@ -94,7 +94,8 @@ static int __init dummy_probe(struct pcie_device *dev)
 			dup_slot_id++;
 	}
 	list_add_tail(&slot->slot_list, &dummy_slots);
-	if (!acpi_slot_detected && acpi_pci_detect_ejectable(pbus))
+	handle = DEVICE_ACPI_HANDLE(&pdev->dev);
+	if (!acpi_slot_detected && acpi_pci_detect_ejectable(handle))
 		acpi_slot_detected = 1;
 	return -ENODEV;         /* dummy driver always returns error */
 }
diff --git a/include/linux/pci_hotplug.h b/include/linux/pci_hotplug.h
index 1b00cc3..f0c31ae 100644
--- a/include/linux/pci_hotplug.h
+++ b/include/linux/pci_hotplug.h
@@ -231,7 +231,7 @@ extern acpi_status acpi_get_hp_params_from_firmware(struct pci_bus *bus,
 				struct hotplug_params *hpp);
 int acpi_get_hp_hw_control_from_firmware(struct pci_dev *dev, u32 flags);
 int acpi_pci_check_ejectable(struct pci_bus *pbus, acpi_handle handle);
-int acpi_pci_detect_ejectable(struct pci_bus *pbus);
+int acpi_pci_detect_ejectable(acpi_handle handle);
 #endif
 #endif
 

