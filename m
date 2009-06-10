Return-Path: <linux-kernel-owner+w=401wt.eu-S1761927AbZFJT57@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761927AbZFJT57 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 15:57:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761527AbZFJT4A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 15:56:00 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:4164 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760994AbZFJTz1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 15:55:27 -0400
Subject: [PATCH v3 05/12] ACPI: eviscerate pci_bind.c
To: lenb@kernel.org
From: Alex Chiang <achiang@hp.com>
Cc: linux-acpi@vger.kernel.org, Bjorn Helgaas <bjorn.helgaas@hp.com>,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Date: Wed, 10 Jun 2009 13:55:30 -0600
Message-ID: <20090610195530.28982.71990.stgit@bob.kio>
In-Reply-To: <20090610194714.28982.51363.stgit@bob.kio>
References: <20090610194714.28982.51363.stgit@bob.kio>
User-Agent: StGit/0.14.3.347.g594a
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that we can dynamically convert an ACPI CA handle to a
struct pci_dev at runtime, there's no need to statically bind
them during boot.

acpi_pci_bind/unbind are vastly simplified, and are only used
to evaluate _PRT methods on P2P bridges and non-bridge children.

This patch also changes the time-space tradeoff ever so slightly.

Looking up the ACPI-PCI binding is never in the performance path, and by
eliminating this caching, we save 24 bytes for each _ADR device in the
ACPI namespace.

This patch lays further groundwork to eventually eliminate
the acpi_driver_ops.bind callback.

Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
Signed-off-by: Alex Chiang <achiang@hp.com>
---

 drivers/acpi/pci_bind.c     |  245 ++++++-------------------------------------
 drivers/acpi/pci_root.c     |    2 
 include/acpi/acpi_drivers.h |    3 -
 3 files changed, 39 insertions(+), 211 deletions(-)

diff --git a/drivers/acpi/pci_bind.c b/drivers/acpi/pci_bind.c
index c283c29..703d2a3 100644
--- a/drivers/acpi/pci_bind.c
+++ b/drivers/acpi/pci_bind.c
@@ -24,12 +24,7 @@
  */
 
 #include <linux/kernel.h>
-#include <linux/module.h>
-#include <linux/init.h>
 #include <linux/types.h>
-#include <linux/proc_fs.h>
-#include <linux/spinlock.h>
-#include <linux/pm.h>
 #include <linux/pci.h>
 #include <linux/acpi.h>
 #include <acpi/acpi_bus.h>
@@ -111,238 +106,72 @@ EXPORT_SYMBOL(acpi_get_pci_id);
 
 static int acpi_pci_unbind(struct acpi_device *device)
 {
-	int result = 0;
-	acpi_status status;
-	struct acpi_pci_data *data;
-	struct acpi_buffer buffer = { ACPI_ALLOCATE_BUFFER, NULL };
-
-
-	if (!device || !device->parent)
-		return -EINVAL;
-
-	status = acpi_get_name(device->handle, ACPI_FULL_PATHNAME, &buffer);
-	if (ACPI_FAILURE(status))
-		return -ENODEV;
-
-	ACPI_DEBUG_PRINT((ACPI_DB_INFO, "Unbinding PCI device [%s]...\n",
-			  (char *) buffer.pointer));
-	kfree(buffer.pointer);
+	struct pci_dev *dev;
 
-	status =
-	    acpi_get_data(device->handle, acpi_pci_data_handler,
-			  (void **)&data);
-	if (ACPI_FAILURE(status)) {
-		result = -ENODEV;
-		goto end;
-	}
+	dev = acpi_get_pci_dev(device->handle);
+	if (!dev)
+		return 0;
 
-	status = acpi_detach_data(device->handle, acpi_pci_data_handler);
-	if (ACPI_FAILURE(status)) {
-		ACPI_EXCEPTION((AE_INFO, status,
-				"Unable to detach data from device %s",
-				acpi_device_bid(device)));
-		result = -ENODEV;
-		goto end;
-	}
-	if (data->dev->subordinate) {
-		acpi_pci_irq_del_prt(data->id.segment, data->bus->number);
-	}
-	pci_dev_put(data->dev);
-	kfree(data);
+	if (dev->subordinate)
+		acpi_pci_irq_del_prt(pci_domain_nr(dev->bus),
+				     dev->subordinate->number);
 
-      end:
-	return result;
+	pci_dev_put(dev);
+	return 0;
 }
 
 static int acpi_pci_bind(struct acpi_device *device)
 {
-	int result = 0;
 	acpi_status status;
-	struct acpi_pci_data *data;
-	struct acpi_pci_data *pdata;
-	struct acpi_buffer buffer = { ACPI_ALLOCATE_BUFFER, NULL };
 	acpi_handle handle;
+	unsigned char bus;
+	struct pci_dev *dev;
 
-	if (!device || !device->parent)
-		return -EINVAL;
-
-	data = kzalloc(sizeof(struct acpi_pci_data), GFP_KERNEL);
-	if (!data)
-		return -ENOMEM;
-
-	status = acpi_get_name(device->handle, ACPI_FULL_PATHNAME, &buffer);
-	if (ACPI_FAILURE(status)) {
-		kfree(data);
-		return -ENODEV;
-	}
-
-	ACPI_DEBUG_PRINT((ACPI_DB_INFO, "Binding PCI device [%s]...\n",
-			  (char *)buffer.pointer));
-
-	/* 
-	 * Segment & Bus
-	 * -------------
-	 * These are obtained via the parent device's ACPI-PCI context.
-	 */
-	status = acpi_get_data(device->parent->handle, acpi_pci_data_handler,
-			       (void **)&pdata);
-	if (ACPI_FAILURE(status) || !pdata || !pdata->bus) {
-		ACPI_EXCEPTION((AE_INFO, status,
-				"Invalid ACPI-PCI context for parent device %s",
-				acpi_device_bid(device->parent)));
-		result = -ENODEV;
-		goto end;
-	}
-	data->id.segment = pdata->id.segment;
-	data->id.bus = pdata->bus->number;
-
-	/*
-	 * Device & Function
-	 * -----------------
-	 * These are simply obtained from the device's _ADR method.  Note
-	 * that a value of zero is valid.
-	 */
-	data->id.device = device->pnp.bus_address >> 16;
-	data->id.function = device->pnp.bus_address & 0xFFFF;
-
-	ACPI_DEBUG_PRINT((ACPI_DB_INFO, "...to %04x:%02x:%02x.%d\n",
-			  data->id.segment, data->id.bus, data->id.device,
-			  data->id.function));
-
-	/*
-	 * TBD: Support slot devices (e.g. function=0xFFFF).
-	 */
-
-	/* 
-	 * Locate PCI Device
-	 * -----------------
-	 * Locate matching device in PCI namespace.  If it doesn't exist
-	 * this typically means that the device isn't currently inserted
-	 * (e.g. docking station, port replicator, etc.).
-	 */
-	data->dev = pci_get_slot(pdata->bus,
-				PCI_DEVFN(data->id.device, data->id.function));
-	if (!data->dev) {
-		ACPI_DEBUG_PRINT((ACPI_DB_INFO,
-				  "Device %04x:%02x:%02x.%d not present in PCI namespace\n",
-				  data->id.segment, data->id.bus,
-				  data->id.device, data->id.function));
-		result = -ENODEV;
-		goto end;
-	}
-	if (!data->dev->bus) {
-		printk(KERN_ERR PREFIX
-			    "Device %04x:%02x:%02x.%d has invalid 'bus' field\n",
-			    data->id.segment, data->id.bus,
-			    data->id.device, data->id.function);
-		result = -ENODEV;
-		goto end;
-	}
+	dev = acpi_get_pci_dev(device->handle);
+	if (!dev)
+		return 0;
 
 	/*
-	 * PCI Bridge?
-	 * -----------
-	 * If so, set the 'bus' field and install the 'bind' function to 
-	 * facilitate callbacks for all of its children.
+	 * Install the 'bind' function to facilitate callbacks for
+	 * children of the P2P bridge.
 	 */
-	if (data->dev->subordinate) {
+	if (dev->subordinate) {
 		ACPI_DEBUG_PRINT((ACPI_DB_INFO,
 				  "Device %04x:%02x:%02x.%d is a PCI bridge\n",
-				  data->id.segment, data->id.bus,
-				  data->id.device, data->id.function));
-		data->bus = data->dev->subordinate;
+				  pci_domain_nr(dev->bus), dev->bus->number,
+				  PCI_SLOT(dev->devfn), PCI_FUNC(dev->devfn)));
 		device->ops.bind = acpi_pci_bind;
 		device->ops.unbind = acpi_pci_unbind;
 	}
 
 	/*
-	 * Attach ACPI-PCI Context
-	 * -----------------------
-	 * Thus binding the ACPI and PCI devices.
-	 */
-	status = acpi_attach_data(device->handle, acpi_pci_data_handler, data);
-	if (ACPI_FAILURE(status)) {
-		ACPI_EXCEPTION((AE_INFO, status,
-				"Unable to attach ACPI-PCI context to device %s",
-				acpi_device_bid(device)));
-		result = -ENODEV;
-		goto end;
-	}
-
-	/*
-	 * PCI Routing Table
-	 * -----------------
-	 * Evaluate and parse _PRT, if exists.  This code is independent of 
-	 * PCI bridges (above) to allow parsing of _PRT objects within the
-	 * scope of non-bridge devices.  Note that _PRTs within the scope of
-	 * a PCI bridge assume the bridge's subordinate bus number.
+	 * Evaluate and parse _PRT, if exists.  This code allows parsing of
+	 * _PRT objects within the scope of non-bridge devices.  Note that
+	 * _PRTs within the scope of a PCI bridge assume the bridge's
+	 * subordinate bus number.
 	 *
 	 * TBD: Can _PRTs exist within the scope of non-bridge PCI devices?
 	 */
 	status = acpi_get_handle(device->handle, METHOD_NAME__PRT, &handle);
-	if (ACPI_SUCCESS(status)) {
-		if (data->bus)	/* PCI-PCI bridge */
-			acpi_pci_irq_add_prt(device->handle, data->id.segment,
-					     data->bus->number);
-		else		/* non-bridge PCI device */
-			acpi_pci_irq_add_prt(device->handle, data->id.segment,
-					     data->id.bus);
-	}
-
-      end:
-	kfree(buffer.pointer);
-	if (result) {
-		pci_dev_put(data->dev);
-		kfree(data);
-	}
-	return result;
-}
+	if (ACPI_FAILURE(status))
+		goto out;
 
-int
-acpi_pci_bind_root(struct acpi_device *device,
-		   struct acpi_pci_id *id, struct pci_bus *bus)
-{
-	int result = 0;
-	acpi_status status;
-	struct acpi_pci_data *data = NULL;
-	struct acpi_buffer buffer = { ACPI_ALLOCATE_BUFFER, NULL };
+	if (dev->subordinate)
+		bus = dev->subordinate->number;
+	else
+		bus = dev->bus->number;
 
-	if (!device || !id || !bus) {
-		return -EINVAL;
-	}
+	acpi_pci_irq_add_prt(device->handle, pci_domain_nr(dev->bus), bus);
 
-	data = kzalloc(sizeof(struct acpi_pci_data), GFP_KERNEL);
-	if (!data)
-		return -ENOMEM;
+out:
+	pci_dev_put(dev);
+	return 0;
+}
 
-	data->id = *id;
-	data->bus = bus;
+int acpi_pci_bind_root(struct acpi_device *device)
+{
 	device->ops.bind = acpi_pci_bind;
 	device->ops.unbind = acpi_pci_unbind;
 
-	status = acpi_get_name(device->handle, ACPI_FULL_PATHNAME, &buffer);
-	if (ACPI_FAILURE(status)) {
-		kfree (data);
-		return -ENODEV;
-	}
-
-	ACPI_DEBUG_PRINT((ACPI_DB_INFO, "Binding PCI root bridge [%s] to "
-			"%04x:%02x\n", (char *)buffer.pointer,
-			id->segment, id->bus));
-
-	status = acpi_attach_data(device->handle, acpi_pci_data_handler, data);
-	if (ACPI_FAILURE(status)) {
-		ACPI_EXCEPTION((AE_INFO, status,
-				"Unable to attach ACPI-PCI context to device %s",
-				(char *)buffer.pointer));
-		result = -ENODEV;
-		goto end;
-	}
-
-      end:
-	kfree(buffer.pointer);
-	if (result != 0)
-		kfree(data);
-
-	return result;
+	return 0;
 }
diff --git a/drivers/acpi/pci_root.c b/drivers/acpi/pci_root.c
index e509991..f23fcc5 100644
--- a/drivers/acpi/pci_root.c
+++ b/drivers/acpi/pci_root.c
@@ -603,7 +603,7 @@ static int __devinit acpi_pci_root_add(struct acpi_device *device)
 	 * -----------------------
 	 * Thus binding the ACPI and PCI devices.
 	 */
-	result = acpi_pci_bind_root(device, &root->id, root->bus);
+	result = acpi_pci_bind_root(device);
 	if (result)
 		goto end;
 
diff --git a/include/acpi/acpi_drivers.h b/include/acpi/acpi_drivers.h
index 1ef529b..01d9ce4 100644
--- a/include/acpi/acpi_drivers.h
+++ b/include/acpi/acpi_drivers.h
@@ -99,8 +99,7 @@ struct pci_bus;
 
 struct pci_dev *acpi_get_pci_dev(acpi_handle);
 acpi_status acpi_get_pci_id(acpi_handle handle, struct acpi_pci_id *id);
-int acpi_pci_bind_root(struct acpi_device *device, struct acpi_pci_id *id,
-		       struct pci_bus *bus);
+int acpi_pci_bind_root(struct acpi_device *device);
 
 /* Arch-defined function to add a bus to the system */
 

