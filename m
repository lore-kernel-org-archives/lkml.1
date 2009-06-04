Return-Path: <linux-kernel-owner+w=401wt.eu-S1757987AbZFDGB1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757987AbZFDGB1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 02:01:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757250AbZFDF7N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 01:59:13 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:3596 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757169AbZFDF7K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 01:59:10 -0400
Subject: [PATCH v2 11/11] ACPI: kill acpi_get_physical_pci_device()
To: lenb@kernel.org
From: Alex Chiang <achiang@hp.com>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       Thomas Renninger <trenn@suse.de>, linux-pci@vger.kernel.org
Date: Wed, 03 Jun 2009 23:59:12 -0600
Message-ID: <20090604055912.18802.35288.stgit@bob.kio>
In-Reply-To: <20090604054504.18802.21690.stgit@bob.kio>
References: <20090604054504.18802.21690.stgit@bob.kio>
User-Agent: StGit/0.14.3.347.g594a
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

acpi_get_pci_dev() is (hopefully) better, and all callers have been
converted, so let's get rid of this duplicated functionality.

Cc: Thomas Renninger <trenn@suse.de>
Signed-off-by: Alex Chiang <achiang@hp.com>
---

 drivers/acpi/glue.c     |   40 ----------------------------------------
 include/acpi/acpi_bus.h |    1 -
 2 files changed, 0 insertions(+), 41 deletions(-)

diff --git a/drivers/acpi/glue.c b/drivers/acpi/glue.c
index 8bd2c2a..a8a5c29 100644
--- a/drivers/acpi/glue.c
+++ b/drivers/acpi/glue.c
@@ -140,46 +140,6 @@ struct device *acpi_get_physical_device(acpi_handle handle)
 
 EXPORT_SYMBOL(acpi_get_physical_device);
 
-/* ToDo: When a PCI bridge is found, return the PCI device behind the bridge
- *       This should work in general, but did not on a Lenovo T61 for the
- *	 graphics card. But this must be fixed when the PCI device is
- *       bound and the kernel device struct is attached to the acpi device
- * Note: A success call will increase reference count by one
- *       Do call put_device(dev) on the returned device then
- */
-struct device *acpi_get_physical_pci_device(acpi_handle handle)
-{
-	struct device *dev;
-	long long device_id;
-	acpi_status status;
-
-	status =
-		acpi_evaluate_integer(handle, "_ADR", NULL, &device_id);
-
-	if (ACPI_FAILURE(status))
-		return NULL;
-
-	/* We need to attempt to determine whether the _ADR refers to a
-	   PCI device or not. There's no terribly good way to do this,
-	   so the best we can hope for is to assume that there'll never
-	   be a device in the host bridge */
-	if (device_id >= 0x10000) {
-		/* It looks like a PCI device. Does it exist? */
-		dev = acpi_get_physical_device(handle);
-	} else {
-		/* It doesn't look like a PCI device. Does its parent
-		   exist? */
-		acpi_handle phandle;
-		if (acpi_get_parent(handle, &phandle))
-			return NULL;
-		dev = acpi_get_physical_device(phandle);
-	}
-	if (!dev)
-		return NULL;
-	return dev;
-}
-EXPORT_SYMBOL(acpi_get_physical_pci_device);
-
 static int acpi_bind_one(struct device *dev, acpi_handle handle)
 {
 	struct acpi_device *acpi_dev;
diff --git a/include/acpi/acpi_bus.h b/include/acpi/acpi_bus.h
index 494088b..c65e4ce 100644
--- a/include/acpi/acpi_bus.h
+++ b/include/acpi/acpi_bus.h
@@ -368,7 +368,6 @@ struct acpi_bus_type {
 int register_acpi_bus_type(struct acpi_bus_type *);
 int unregister_acpi_bus_type(struct acpi_bus_type *);
 struct device *acpi_get_physical_device(acpi_handle);
-struct device *acpi_get_physical_pci_device(acpi_handle);
 
 /* helper */
 acpi_handle acpi_get_child(acpi_handle, acpi_integer);

