Return-Path: <linux-kernel-owner+w=401wt.eu-S1773227AbYBOArW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1773227AbYBOArW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 19:47:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933451AbYBOAmv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 19:42:51 -0500
Received: from ns2.suse.de ([195.135.220.15]:54098 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934843AbYBOAmu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 19:42:50 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-pci@atrey.karlin.mff.cuni.cz
Cc: linux-kernel@vger.kernel.org, pcihpd-discuss@lists.sourceforge.net,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 10/12] PCI: add is_added flag to struct pci_dev
Date: Thu, 14 Feb 2008 16:40:08 -0800
Message-Id: <1203036010-27988-10-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.4
In-Reply-To: <20080215003909.GA27981@kroah.com>
References: <20080215003909.GA27981@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This lets us check if the device is really added to the driver core or
not, which is what we need when walking some of the bus lists.  The flag
is there in anticipation of getting rid of the other PCI device list,
which is what we used to check in this situation.

Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/powerpc/platforms/pseries/pci_dlpar.c |    7 ++-----
 drivers/pci/bus.c                          |   11 ++++-------
 drivers/pci/probe.c                        |    2 +-
 drivers/pci/remove.c                       |    6 ++----
 include/linux/pci.h                        |    1 +
 5 files changed, 10 insertions(+), 17 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/pci_dlpar.c b/arch/powerpc/platforms/pseries/pci_dlpar.c
index 5a5a19e..d26a7bc 100644
--- a/arch/powerpc/platforms/pseries/pci_dlpar.c
+++ b/arch/powerpc/platforms/pseries/pci_dlpar.c
@@ -88,11 +88,8 @@ pcibios_fixup_new_pci_devices(struct pci_bus *bus)
 	struct pci_dev *dev;
 
 	list_for_each_entry(dev, &bus->devices, bus_list) {
-		/*
-		 * Skip already-present devices (which are on the
-		 * global device list.)
-		 */
-		if (list_empty(&dev->global_list)) {
+		/* Skip already-added devices */
+		if (!dev->is_added) {
 			int i;
 
 			/* Fill device archdata and setup iommu table */
diff --git a/drivers/pci/bus.c b/drivers/pci/bus.c
index ef5a6a2..f2eae65 100644
--- a/drivers/pci/bus.c
+++ b/drivers/pci/bus.c
@@ -84,6 +84,7 @@ int pci_bus_add_device(struct pci_dev *dev)
 	if (retval)
 		return retval;
 
+	dev->is_added = 1;
 	down_write(&pci_bus_sem);
 	list_add_tail(&dev->global_list, &pci_devices);
 	up_write(&pci_bus_sem);
@@ -112,11 +113,8 @@ void pci_bus_add_devices(struct pci_bus *bus)
 	int retval;
 
 	list_for_each_entry(dev, &bus->devices, bus_list) {
-		/*
-		 * Skip already-present devices (which are on the
-		 * global device list.)
-		 */
-		if (!list_empty(&dev->global_list))
+		/* Skip already-added devices */
+		if (dev->is_added)
 			continue;
 		retval = pci_bus_add_device(dev);
 		if (retval)
@@ -124,8 +122,7 @@ void pci_bus_add_devices(struct pci_bus *bus)
 	}
 
 	list_for_each_entry(dev, &bus->devices, bus_list) {
-
-		BUG_ON(list_empty(&dev->global_list));
+		BUG_ON(!dev->is_added);
 
 		/*
 		 * If there is an unattached subordinate bus, attach
diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 5fd662e..7a1efc1 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -984,7 +984,7 @@ EXPORT_SYMBOL(pci_scan_single_device);
  *
  * Scan a PCI slot on the specified PCI bus for devices, adding
  * discovered devices to the @bus->devices list.  New devices
- * will have an empty dev->global_list head.
+ * will not have is_added set.
  */
 int pci_scan_slot(struct pci_bus *bus, int devfn)
 {
diff --git a/drivers/pci/remove.c b/drivers/pci/remove.c
index 9684e1b..d3c77cb 100644
--- a/drivers/pci/remove.c
+++ b/drivers/pci/remove.c
@@ -18,13 +18,11 @@ static void pci_free_resources(struct pci_dev *dev)
 
 static void pci_stop_dev(struct pci_dev *dev)
 {
-	if (!dev->global_list.next)
-		return;
-
-	if (!list_empty(&dev->global_list)) {
+	if (dev->is_added) {
 		pci_proc_detach_device(dev);
 		pci_remove_sysfs_dev_files(dev);
 		device_unregister(&dev->dev);
+		dev->is_added = 0;
 		down_write(&pci_bus_sem);
 		list_del(&dev->global_list);
 		dev->global_list.next = dev->global_list.prev = NULL;
diff --git a/include/linux/pci.h b/include/linux/pci.h
index a38c855..b567d37 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -181,6 +181,7 @@ struct pci_dev {
 	unsigned int	transparent:1;	/* Transparent PCI bridge */
 	unsigned int	multifunction:1;/* Part of multi-function device */
 	/* keep track of device state */
+	unsigned int	is_added:1;
 	unsigned int	is_busmaster:1; /* device is busmaster */
 	unsigned int	no_msi:1;	/* device may not use msi */
 	unsigned int	no_d1d2:1;   /* only allow d0 or d3 */
-- 
1.5.4

