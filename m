Return-Path: <linux-kernel-owner+w=401wt.eu-S1757988AbZFBPZW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757988AbZFBPZW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 11:25:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757603AbZFBPYq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 11:24:46 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:7979 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757438AbZFBPYo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 11:24:44 -0400
Subject: [PATCH 02/10] ACPI: Introduce acpi_is_root_bridge()
To: lenb@kernel.org
From: Alex Chiang <achiang@hp.com>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org
Date: Tue, 02 Jun 2009 09:24:46 -0600
Message-ID: <20090602152446.7346.31536.stgit@bob.kio>
In-Reply-To: <20090602152351.7346.48697.stgit@bob.kio>
References: <20090602152351.7346.48697.stgit@bob.kio>
User-Agent: StGit/0.14.3.347.g594a
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Returns whether an ACPI CA node is a PCI root bridge or not.

This API is generically useful, and shouldn't just be a hotplug function.

Note that this patch does not simply move code around. The old
implementation did not check for PCIe _HIDs. The new implementation
does check, similar to the logic in acpi_ev_is_pci_root_bridge().

Signed-off-by: Alex Chiang <achiang@hp.com>
---

 drivers/acpi/pci_root.c            |   41 ++++++++++++++++++++++++++++++++++++
 drivers/pci/hotplug/acpi_pcihp.c   |   40 ++---------------------------------
 drivers/pci/hotplug/acpiphp_glue.c |    2 +-
 include/acpi/acpi_bus.h            |    1 +
 include/linux/pci_hotplug.h        |    1 -
 5 files changed, 45 insertions(+), 40 deletions(-)

diff --git a/drivers/acpi/pci_root.c b/drivers/acpi/pci_root.c
index ca8dba3..853a6e4 100644
--- a/drivers/acpi/pci_root.c
+++ b/drivers/acpi/pci_root.c
@@ -142,6 +142,47 @@ acpi_handle acpi_get_pci_rootbridge_handle(unsigned int seg, unsigned int bus)
 
 EXPORT_SYMBOL_GPL(acpi_get_pci_rootbridge_handle);
 
+/**
+ * acpi_is_root_bridge - determine whether an ACPI CA node is a PCI root bridge
+ * @handle - the ACPI CA node in question.
+ */
+int acpi_is_root_bridge(acpi_handle handle)
+{
+	acpi_status status;
+	struct acpi_device_info *info;
+	struct acpi_buffer buffer = {ACPI_ALLOCATE_BUFFER, NULL};
+	int i, ret = 0;
+
+	status = acpi_get_object_info(handle, &buffer);
+	if (ACPI_FAILURE(status))
+		goto out;
+
+	info = buffer.pointer;
+	if ((info->valid & ACPI_VALID_HID) &&
+		!strcmp(PCI_ROOT_HID_STRING, info->hardware_id.value)) {
+		ret = 1;
+		goto out;
+	}
+	if ((info->valid & ACPI_VALID_HID) &&
+		!strcmp(PCI_EXPRESS_ROOT_HID_STRING, info->hardware_id.value)) {
+		ret = 1;
+		goto out;
+	}
+	if (info->valid & ACPI_VALID_CID) {
+		for (i = 0; i < info->compatibility_id.count; i++) {
+			if (!strcmp(PCI_ROOT_HID_STRING,
+				info->compatibility_id.id[i].value)) {
+				ret = 1;
+				goto out;
+			}
+		}
+	}
+out:
+	kfree(buffer.pointer);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(acpi_is_root_bridge);
+
 static acpi_status
 get_root_bridge_busnr_callback(struct acpi_resource *resource, void *data)
 {
diff --git a/drivers/pci/hotplug/acpi_pcihp.c b/drivers/pci/hotplug/acpi_pcihp.c
index fbc63d5..eb15958 100644
--- a/drivers/pci/hotplug/acpi_pcihp.c
+++ b/drivers/pci/hotplug/acpi_pcihp.c
@@ -354,7 +354,7 @@ acpi_status acpi_get_hp_params_from_firmware(struct pci_bus *bus,
 		status = acpi_run_hpp(handle, hpp);
 		if (ACPI_SUCCESS(status))
 			break;
-		if (acpi_root_bridge(handle))
+		if (acpi_is_root_bridge(handle))
 			break;
 		status = acpi_get_parent(handle, &phandle);
 		if (ACPI_FAILURE(status))
@@ -428,7 +428,7 @@ int acpi_get_hp_hw_control_from_firmware(struct pci_dev *pdev, u32 flags)
 		status = acpi_run_oshp(handle);
 		if (ACPI_SUCCESS(status))
 			goto got_one;
-		if (acpi_root_bridge(handle))
+		if (acpi_is_root_bridge(handle))
 			break;
 		chandle = handle;
 		status = acpi_get_parent(chandle, &handle);
@@ -449,42 +449,6 @@ got_one:
 }
 EXPORT_SYMBOL(acpi_get_hp_hw_control_from_firmware);
 
-/* acpi_root_bridge - check to see if this acpi object is a root bridge
- *
- * @handle - the acpi object in question.
- */
-int acpi_root_bridge(acpi_handle handle)
-{
-	acpi_status status;
-	struct acpi_device_info *info;
-	struct acpi_buffer buffer = {ACPI_ALLOCATE_BUFFER, NULL};
-	int i;
-
-	status = acpi_get_object_info(handle, &buffer);
-	if (ACPI_SUCCESS(status)) {
-		info = buffer.pointer;
-		if ((info->valid & ACPI_VALID_HID) &&
-			!strcmp(PCI_ROOT_HID_STRING,
-					info->hardware_id.value)) {
-			kfree(buffer.pointer);
-			return 1;
-		}
-		if (info->valid & ACPI_VALID_CID) {
-			for (i=0; i < info->compatibility_id.count; i++) {
-				if (!strcmp(PCI_ROOT_HID_STRING,
-					info->compatibility_id.id[i].value)) {
-					kfree(buffer.pointer);
-					return 1;
-				}
-			}
-		}
-		kfree(buffer.pointer);
-	}
-	return 0;
-}
-EXPORT_SYMBOL_GPL(acpi_root_bridge);
-
-
 static int is_ejectable(acpi_handle handle)
 {
 	acpi_status status;
diff --git a/drivers/pci/hotplug/acpiphp_glue.c b/drivers/pci/hotplug/acpiphp_glue.c
index 3a6064b..fc6636e 100644
--- a/drivers/pci/hotplug/acpiphp_glue.c
+++ b/drivers/pci/hotplug/acpiphp_glue.c
@@ -1631,7 +1631,7 @@ find_root_bridges(acpi_handle handle, u32 lvl, void *context, void **rv)
 {
 	int *count = (int *)context;
 
-	if (acpi_root_bridge(handle)) {
+	if (acpi_is_root_bridge(handle)) {
 		acpi_install_notify_handler(handle, ACPI_SYSTEM_NOTIFY,
 				handle_hotplug_event_bridge, NULL);
 			(*count)++;
diff --git a/include/acpi/acpi_bus.h b/include/acpi/acpi_bus.h
index 0f50167..494088b 100644
--- a/include/acpi/acpi_bus.h
+++ b/include/acpi/acpi_bus.h
@@ -372,6 +372,7 @@ struct device *acpi_get_physical_pci_device(acpi_handle);
 
 /* helper */
 acpi_handle acpi_get_child(acpi_handle, acpi_integer);
+int acpi_is_root_bridge(acpi_handle);
 acpi_handle acpi_get_pci_rootbridge_handle(unsigned int, unsigned int);
 #define DEVICE_ACPI_HANDLE(dev) ((acpi_handle)((dev)->archdata.acpi_handle))
 
diff --git a/include/linux/pci_hotplug.h b/include/linux/pci_hotplug.h
index 2099874..a3576ef 100644
--- a/include/linux/pci_hotplug.h
+++ b/include/linux/pci_hotplug.h
@@ -226,7 +226,6 @@ struct hotplug_params {
 extern acpi_status acpi_get_hp_params_from_firmware(struct pci_bus *bus,
 				struct hotplug_params *hpp);
 int acpi_get_hp_hw_control_from_firmware(struct pci_dev *dev, u32 flags);
-int acpi_root_bridge(acpi_handle handle);
 int acpi_pci_check_ejectable(struct pci_bus *pbus, acpi_handle handle);
 int acpi_pci_detect_ejectable(struct pci_bus *pbus);
 #endif

