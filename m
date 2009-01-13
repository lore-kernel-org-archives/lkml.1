Return-Path: <linux-kernel-owner+w=401wt.eu-S1760473AbZAMNu7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760473AbZAMNu7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 08:50:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757176AbZAMNt7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 08:49:59 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:50461 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756561AbZAMNt4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 08:49:56 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [PATCH 5/7] PCI PCIe portdrv: Simplily probe callback of service drivers (rev. 2)
Date: Tue, 13 Jan 2009 14:44:19 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.29-rc1-rjw; KDE/4.1.3; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, Linux PCI <linux-pci@vger.kernel.org>
References: <200901131434.28340.rjw@sisk.pl>
In-Reply-To: <200901131434.28340.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901131444.19613.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

The second argument of the ->probe() callback in
struct pcie_port_service_driver is unnecessary and never used.
Remove it.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/pci/hotplug/pciehp_acpi.c |    3 +--
 drivers/pci/hotplug/pciehp_core.c |    2 +-
 drivers/pci/pcie/aer/aerdrv.c     |    6 ++----
 drivers/pci/pcie/portdrv_core.c   |    2 +-
 include/linux/pcieport_if.h       |    3 +--
 5 files changed, 6 insertions(+), 10 deletions(-)

Index: linux-2.6/include/linux/pcieport_if.h
===================================================================
--- linux-2.6.orig/include/linux/pcieport_if.h
+++ linux-2.6/include/linux/pcieport_if.h
@@ -56,8 +56,7 @@ static inline void* get_service_data(str
 
 struct pcie_port_service_driver {
 	const char *name;
-	int (*probe) (struct pcie_device *dev, 
-		const struct pcie_port_service_id *id);
+	int (*probe) (struct pcie_device *dev);
 	void (*remove) (struct pcie_device *dev);
 	int (*suspend) (struct pcie_device *dev, pm_message_t state);
 	int (*resume) (struct pcie_device *dev);
Index: linux-2.6/drivers/pci/pcie/aer/aerdrv.c
===================================================================
--- linux-2.6.orig/drivers/pci/pcie/aer/aerdrv.c
+++ linux-2.6/drivers/pci/pcie/aer/aerdrv.c
@@ -38,8 +38,7 @@ MODULE_AUTHOR(DRIVER_AUTHOR);
 MODULE_DESCRIPTION(DRIVER_DESC);
 MODULE_LICENSE("GPL");
 
-static int __devinit aer_probe (struct pcie_device *dev,
-	const struct pcie_port_service_id *id );
+static int __devinit aer_probe (struct pcie_device *dev);
 static void aer_remove(struct pcie_device *dev);
 static int aer_suspend(struct pcie_device *dev, pm_message_t state)
 {return 0;}
@@ -207,8 +206,7 @@ static void aer_remove(struct pcie_devic
  *
  * Invoked when PCI Express bus loads AER service driver.
  **/
-static int __devinit aer_probe (struct pcie_device *dev,
-				const struct pcie_port_service_id *id )
+static int __devinit aer_probe (struct pcie_device *dev)
 {
 	int status;
 	struct aer_rpc *rpc;
Index: linux-2.6/drivers/pci/pcie/portdrv_core.c
===================================================================
--- linux-2.6.orig/drivers/pci/pcie/portdrv_core.c
+++ linux-2.6/drivers/pci/pcie/portdrv_core.c
@@ -402,7 +402,7 @@ static int pcie_port_probe_service(struc
 		return -ENODEV;
 
 	pciedev = to_pcie_device(dev);
-	status = driver->probe(pciedev, driver->id_table);
+	status = driver->probe(pciedev);
 	if (!status) {
 		dev_printk(KERN_DEBUG, dev, "service driver %s loaded\n",
 			driver->name);
Index: linux-2.6/drivers/pci/hotplug/pciehp_core.c
===================================================================
--- linux-2.6.orig/drivers/pci/hotplug/pciehp_core.c
+++ linux-2.6/drivers/pci/hotplug/pciehp_core.c
@@ -399,7 +399,7 @@ static int get_cur_bus_speed(struct hotp
 	return 0;
 }
 
-static int pciehp_probe(struct pcie_device *dev, const struct pcie_port_service_id *id)
+static int pciehp_probe(struct pcie_device *dev)
 {
 	int rc;
 	struct controller *ctrl;
Index: linux-2.6/drivers/pci/hotplug/pciehp_acpi.c
===================================================================
--- linux-2.6.orig/drivers/pci/hotplug/pciehp_acpi.c
+++ linux-2.6/drivers/pci/hotplug/pciehp_acpi.c
@@ -82,8 +82,7 @@ static int __initdata acpi_slot_detected
 static struct list_head __initdata dummy_slots = LIST_HEAD_INIT(dummy_slots);
 
 /* Dummy driver for dumplicate name detection */
-static int __init dummy_probe(struct pcie_device *dev,
-			      const struct pcie_port_service_id *id)
+static int __init dummy_probe(struct pcie_device *dev)
 {
 	int pos;
 	u32 slot_cap;

