Return-Path: <linux-kernel-owner+w=401wt.eu-S1755156AbYJ3BR5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755156AbYJ3BR5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 21:17:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752149AbYJ3BRt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 21:17:49 -0400
Received: from qb-out-0506.google.com ([72.14.204.238]:51686 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751773AbYJ3BRs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 21:17:48 -0400
Subject: pci: struct device - replace bus_id with dev_name(), dev_set_name()
From: Kay Sievers <kay.sievers@vrfy.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>
Content-Type: text/plain
Date: Thu, 30 Oct 2008 02:17:49 +0100
Message-Id: <1225329469.5970.69.camel@nga.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is part of a larger patch series which will remove
the "char bus_id[20]" name string from struct device. The device
name is managed in the kobject anyway, and without any size
limitation, and just needlessly copied into "struct device".

To set and read the device name dev_name(dev) and dev_set_name(dev)
must be used. If your code uses static kobjects, which it shouldn't
do, "const char *init_name" can be used to statically provide the
name the registered device should have. At registration time, the
init_name field is cleared, to enforce the use of dev_name(dev) to
access the device name at a later time.

We need to get rid of all occurrences of bus_id in the entire tree
to be able to enable the new interface. Please apply this patch,
and possibly convert any remaining remaining occurrences of bus_id.

We want to submit a patch to -next, which will remove bus_id from
"struct device", to find the remaining pieces to convert, and finally
switch over to the new api, which will remove the 20 bytes array
and does no longer have a size limitation.

Thanks,
Kay


From: Kay Sievers <kay.sievers@vrfy.org>
Subject: pci: struct device - replace bus_id with dev_name(), dev_set_name()

CC: Jesse Barnes <jbarnes@virtuousgeek.org>
Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-Off-By: Kay Sievers <kay.sievers@vrfy.org>
---


diff --git a/drivers/pci/hotplug/acpiphp_ibm.c b/drivers/pci/hotplug/acpiphp_ibm.c
index 881fdd2..5befa7e 100644
--- a/drivers/pci/hotplug/acpiphp_ibm.c
+++ b/drivers/pci/hotplug/acpiphp_ibm.c
@@ -271,7 +271,7 @@ static void ibm_handle_events(acpi_handle handle, u32 event, void *context)
 		dbg("%s: generationg bus event\n", __func__);
 		acpi_bus_generate_proc_event(note->device, note->event, detail);
 		acpi_bus_generate_netlink_event(note->device->pnp.device_class,
-						  note->device->dev.bus_id,
+						  dev_name(&note->device->dev),
 						  note->event, detail);
 	} else
 		note->event = event;
diff --git a/drivers/pci/irq.c b/drivers/pci/irq.c
index 6441dfa..de01174 100644
--- a/drivers/pci/irq.c
+++ b/drivers/pci/irq.c
@@ -15,7 +15,7 @@ static void pci_note_irq_problem(struct pci_dev *pdev, const char *reason)
 
 	dev_printk(KERN_ERR, &pdev->dev,
 		   "Potentially misrouted IRQ (Bridge %s %04x:%04x)\n",
-		   parent->dev.bus_id, parent->vendor, parent->device);
+		   dev_name(&parent->dev), parent->vendor, parent->device);
 	dev_printk(KERN_ERR, &pdev->dev, "%s\n", reason);
 	dev_printk(KERN_ERR, &pdev->dev, "Please report to linux-kernel@vger.kernel.org\n");
 	WARN_ON(1);
diff --git a/drivers/pci/pci-acpi.c b/drivers/pci/pci-acpi.c
index dfe7c8e..1f2b1b7 100644
--- a/drivers/pci/pci-acpi.c
+++ b/drivers/pci/pci-acpi.c
@@ -371,7 +371,7 @@ static int acpi_pci_find_root_bridge(struct device *dev, acpi_handle *handle)
 	 * The string should be the same as root bridge's name
 	 * Please look at 'pci_scan_bus_parented'
 	 */
-	num = sscanf(dev->bus_id, "pci%04x:%02x", &seg, &bus);
+	num = sscanf(dev_name(dev), "pci%04x:%02x", &seg, &bus);
 	if (num != 2)
 		return -ENODEV;
 	*handle = acpi_get_pci_rootbridge_handle(seg, bus);
diff --git a/drivers/pci/pcie/portdrv_core.c b/drivers/pci/pcie/portdrv_core.c
index 2e091e0..75f501a 100644
--- a/drivers/pci/pcie/portdrv_core.c
+++ b/drivers/pci/pcie/portdrv_core.c
@@ -224,7 +224,7 @@ static void pcie_device_init(struct pci_dev *parent, struct pcie_device *dev,
 	device->driver = NULL;
 	device->driver_data = NULL;
 	device->release = release_pcie_device;	/* callback to free pcie dev */
-	snprintf(device->bus_id, sizeof(device->bus_id), "%s:pcie%02x",
+	dev_set_name(device, "%s:pcie%02x",
 		 pci_name(parent), get_descriptor_id(port_type, service_type));
 	device->parent = &parent->dev;
 }
diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 003a9b3..73040c0 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -412,7 +412,7 @@ static struct pci_bus *pci_alloc_child_bus(struct pci_bus *parent,
 	 * registered later in pci_bus_add_devices()
 	 */
 	child->dev.class = &pcibus_class;
-	sprintf(child->dev.bus_id, "%04x:%02x", pci_domain_nr(child), busnr);
+	dev_set_name(&child->dev, "%04x:%02x", pci_domain_nr(child), busnr);
 
 	/*
 	 * Set up the primary, secondary and subordinate
@@ -1130,7 +1130,7 @@ struct pci_bus * pci_create_bus(struct device *parent,
 	memset(dev, 0, sizeof(*dev));
 	dev->parent = parent;
 	dev->release = pci_release_bus_bridge_dev;
-	sprintf(dev->bus_id, "pci%04x:%02x", pci_domain_nr(b), bus);
+	dev_set_name(dev, "pci%04x:%02x", pci_domain_nr(b), bus);
 	error = device_register(dev);
 	if (error)
 		goto dev_reg_err;
@@ -1141,7 +1141,7 @@ struct pci_bus * pci_create_bus(struct device *parent,
 
 	b->dev.class = &pcibus_class;
 	b->dev.parent = b->bridge;
-	sprintf(b->dev.bus_id, "%04x:%02x", pci_domain_nr(b), bus);
+	dev_set_name(&b->dev, "%04x:%02x", pci_domain_nr(b), bus);
 	error = device_register(&b->dev);
 	if (error)
 		goto class_dev_reg_err;
diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
index 1972266..aeb933d 100644
--- a/arch/x86/kernel/pci-dma.c
+++ b/arch/x86/kernel/pci-dma.c
@@ -40,7 +40,7 @@ EXPORT_SYMBOL(bad_dma_address);
    be probably a smaller DMA mask, but this is bug-to-bug compatible
    to older i386. */
 struct device x86_dma_fallback_dev = {
-	.bus_id = "fallback device",
+	.init_name = "fallback device",
 	.coherent_dma_mask = DMA_32BIT_MASK,
 	.dma_mask = &x86_dma_fallback_dev.coherent_dma_mask,
 };


