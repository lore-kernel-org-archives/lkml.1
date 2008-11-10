Return-Path: <linux-kernel-owner+w=401wt.eu-S1755438AbYKJWbi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755438AbYKJWbi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 17:31:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754150AbYKJWas
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 17:30:48 -0500
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:47770 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753930AbYKJWaq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 17:30:46 -0500
From: Andrew Patterson <andrew.patterson@hp.com>
Subject: [PATCH 2/7] ACPI, PCI: call _OSC support during root bridge discovery
To: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       linux-acpi@vger.kernel.org
Cc: andrew.patterson@hp.com, matthew@wil.cx, kaneshige.kenji@jp.fujitsu.com,
       bjorn.helgaas@hp.com
Date: Mon, 10 Nov 2008 15:30:45 -0700
Message-ID: <20081110223045.30539.6794.stgit@bob.kio>
In-Reply-To: <20081110223035.30539.88942.stgit@bob.kio>
References: <20081110223035.30539.88942.stgit@bob.kio>
User-Agent: StGIT/0.14.3.215.gff3d
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ACPI, PCI: call _OSC support during root bridge discovery

Added pci_acpi_osc_support() which is called when a PCI bridge is
added, so individual PCI root bridge drivers do not have to call _OSC
support for every root bridge in their probe functions.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
---

diff --git a/drivers/acpi/pci_root.c b/drivers/acpi/pci_root.c
index 1b8f67d..7ca153e 100644
--- a/drivers/acpi/pci_root.c
+++ b/drivers/acpi/pci_root.c
@@ -31,6 +31,7 @@
 #include <linux/spinlock.h>
 #include <linux/pm.h>
 #include <linux/pci.h>
+#include <linux/pci-acpi.h>
 #include <linux/acpi.h>
 #include <acpi/acpi_bus.h>
 #include <acpi/acpi_drivers.h>
@@ -193,6 +194,7 @@ static int __devinit acpi_pci_root_add(struct acpi_device *device)
 	unsigned long long value = 0;
 	acpi_handle handle = NULL;
 	struct acpi_device *child;
+	u32 flags;
 
 
 	if (!device)
@@ -210,6 +212,13 @@ static int __devinit acpi_pci_root_add(struct acpi_device *device)
 
 	device->ops.bind = acpi_pci_bind;
 
+	/*
+	 * All supported architectures that use ACPI have support for
+	 * PCI domains, so we indicate this in _OSC support capabilities.
+	 */
+	flags = OSC_PCI_SEGMENT_GROUPS_SUPPORT;
+	pci_acpi_osc_support(device->handle, flags);
+
 	/* 
 	 * Segment
 	 * -------
diff --git a/drivers/pci/pci-acpi.c b/drivers/pci/pci-acpi.c
index dfe7c8e..f457387 100644
--- a/drivers/pci/pci-acpi.c
+++ b/drivers/pci/pci-acpi.c
@@ -139,28 +139,42 @@ static acpi_status __acpi_query_osc(u32 flags, struct acpi_osc_data *osc_data,
 	return status;
 }
 
-static acpi_status acpi_query_osc(acpi_handle handle,
-				  u32 level, void *context, void **retval)
+/*
+ * pci_acpi_osc_support: Invoke _OSC indicating support for the given feature
+ * @flags: Bitmask of flags to support
+ *
+ * See the ACPI spec for the definition of the flags
+ */
+int pci_acpi_osc_support(acpi_handle handle, u32 flags)
 {
+	u32 dummy;
 	acpi_status status;
-	struct acpi_osc_data *osc_data;
-	u32 flags = (unsigned long)context, dummy;
 	acpi_handle tmp;
+	struct acpi_osc_data *osc_data;
+	int rc = 0;
 
 	status = acpi_get_handle(handle, "_OSC", &tmp);
 	if (ACPI_FAILURE(status))
-		return AE_OK;
+		return -ENOTTY;
 
 	mutex_lock(&pci_acpi_lock);
 	osc_data = acpi_get_osc_data(handle);
 	if (!osc_data) {
 		printk(KERN_ERR "acpi osc data array is full\n");
+		rc = -ENOMEM;
 		goto out;
 	}
 
 	__acpi_query_osc(flags, osc_data, &dummy);
 out:
 	mutex_unlock(&pci_acpi_lock);
+	return rc;
+}
+
+static acpi_status acpi_query_osc(acpi_handle handle, u32 level,
+				  void *context, void **retval)
+{
+	pci_acpi_osc_support(handle, (unsigned long)context);
 	return AE_OK;
 }
 
diff --git a/include/linux/pci-acpi.h b/include/linux/pci-acpi.h
index a9e4c34..424f06f 100644
--- a/include/linux/pci-acpi.h
+++ b/include/linux/pci-acpi.h
@@ -51,6 +51,7 @@
 #ifdef CONFIG_ACPI
 extern acpi_status pci_osc_control_set(acpi_handle handle, u32 flags);
 extern acpi_status __pci_osc_support_set(u32 flags, const char *hid);
+int pci_acpi_osc_support(acpi_handle handle, u32 flags);
 static inline acpi_status pci_osc_support_set(u32 flags)
 {
 	return __pci_osc_support_set(flags, PCI_ROOT_HID_STRING);

