Return-Path: <linux-kernel-owner+w=401wt.eu-S1751921AbZADXDo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751921AbZADXDo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 18:03:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754409AbZADXBi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 18:01:38 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:49618 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752522AbZADXBe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 18:01:34 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [PATCH 7/8] PCI PCIe portdrv: Simplily probe callback of service drivers
Date: Sun, 4 Jan 2009 23:59:39 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.28-rjw; KDE/4.1.3; x86_64; ; )
Cc: Linux PCI <linux-pci@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
References: <200901042346.42723.rjw@sisk.pl>
In-Reply-To: <200901042346.42723.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901042359.40195.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

The second argument of the ->probe() callback in
struct pcie_port_service_driver is unnecessary and never used.
Remove it.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/pci/hotplug/pciehp_core.c |    2 +-
 drivers/pci/pcie/aer/aerdrv.c     |    6 ++----
 drivers/pci/pcie/portdrv_core.c   |    2 +-
 include/linux/pcieport_if.h       |    3 +--
 4 files changed, 5 insertions(+), 8 deletions(-)

Index: linux-2.6/include/linux/pcieport_if.h
===================================================================
--- linux-2.6.orig/include/linux/pcieport_if.h
+++ linux-2.6/include/linux/pcieport_if.h
@@ -57,8 +57,7 @@ static inline void* get_service_data(str
 
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
@@ -461,7 +461,7 @@ static int pcie_port_probe_service(struc
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

