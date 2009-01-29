Return-Path: <linux-kernel-owner+w=401wt.eu-S1758225AbZA2Kzz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758225AbZA2Kzz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 05:55:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753728AbZA2Kzb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 05:55:31 -0500
Received: from mail2.sea5.speakeasy.net ([69.17.117.4]:34693 "EHLO
	mail2.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751756AbZA2Kz2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 05:55:28 -0500
From: Trent Piepho <xyzzy@speakeasy.org>
To: linux-kernel@vger.kernel.org
Cc: linux-pci@vger.kernel.org, jbarnes@virtuousgeek.org,
       Alex Chiang <achiang@hp.com>, djwong@us.ibm.com,
       Trent Piepho <xyzzy@speakeasy.org>
Subject: [PATCH 2/3] PCI: Add ability to rescan PCI busses
Date: Thu, 29 Jan 2009 02:55:14 -0800
Message-Id: <1233226515-4906-2-git-send-email-xyzzy@speakeasy.org>
X-Mailer: git-send-email 1.5.4.1
In-Reply-To: <Pine.LNX.4.58.0901290221480.17300@shell2.speakeasy.net>
References: <Pine.LNX.4.58.0901290221480.17300@shell2.speakeasy.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds a bus attribute named "scan" to the PCI bus, which will
appear in sysfs at "/sys/bus/pci/scan".  Writing to this file will
trigger a rescan of all PCI busses.

To do this pci_scan_single_device() is modified to first check if the
device to be scanned is already known to Linux.  In which case it just
returns the existing device.  The old behavior was to create a new
device anyway that would conflict with the existing one, causing all
manner of Bad Things to happen.

pci_scan_slot() has been rewritten to be less complex and will now
return the number of *new* devices found.  It didn't used to work to
call pci_scan_slot() on a previously scanned slot, so returning all
devices found was effectivly the same as returning new devices.
---
 drivers/pci/pci-driver.c |    1 +
 drivers/pci/pci-sysfs.c  |   14 +++++++++++
 drivers/pci/pci.h        |    6 +++++
 drivers/pci/probe.c      |   55 +++++++++++++++++++++++++++------------------
 4 files changed, 54 insertions(+), 22 deletions(-)

diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
index 2bec651..fcfd445 100644
--- a/drivers/pci/pci-driver.c
+++ b/drivers/pci/pci-driver.c
@@ -847,6 +847,7 @@ struct bus_type pci_bus_type = {
 	.remove		= pci_device_remove,
 	.shutdown	= pci_device_shutdown,
 	.dev_attrs	= pci_dev_attrs,
+	.bus_attrs	= pci_bus_attrs,
 	.pm		= PCI_PM_OPS_PTR,
 };
 
diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
index d422f37..0781ab7 100644
--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -266,6 +266,20 @@ struct device_attribute pci_dev_attrs[] = {
 	__ATTR_NULL,
 };
 
+#ifdef CONFIG_HOTPLUG
+static ssize_t __ref scan(struct bus_type *type, const char *buf, size_t count)
+{
+	pci_rescan_busses();
+
+	return count;
+}
+
+struct bus_attribute pci_bus_attrs[] = {
+	__ATTR(scan, S_IWUSR, NULL, scan),
+	__ATTR_NULL
+};
+#endif
+
 static ssize_t
 pci_read_config(struct kobject *kobj, struct bin_attribute *bin_attr,
 		char *buf, loff_t off, size_t count)
diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
index 65deed8..49d7bb4 100644
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -87,6 +87,7 @@ static inline int pci_proc_detach_bus(struct pci_bus *bus) { return 0; }
 
 /* Functions for PCI Hotplug drivers to use */
 extern unsigned int pci_do_scan_bus(struct pci_bus *bus);
+extern void pci_rescan_busses(void) __devinit;
 
 #ifdef HAVE_PCI_LEGACY
 extern void pci_create_legacy_files(struct pci_bus *bus);
@@ -128,6 +129,11 @@ extern int pcie_mch_quirk;
 extern struct device_attribute pci_dev_attrs[];
 extern struct device_attribute dev_attr_cpuaffinity;
 extern struct device_attribute dev_attr_cpulistaffinity;
+#ifdef CONFIG_HOTPLUG
+extern struct bus_attribute pci_bus_attrs[];
+#else
+#define pci_bus_attrs NULL
+#endif
 
 /**
  * pci_match_one_device - Tell if a PCI device structure has a matching
diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 251c2b1..6e6172d 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -1006,6 +1006,13 @@ struct pci_dev *__ref pci_scan_single_device(struct pci_bus *bus, int devfn)
 {
 	struct pci_dev *dev;
 
+	/* Check to see if the device is already known */
+	dev = pci_get_slot(bus, devfn);
+	if (dev) {
+		pci_dev_put(dev);
+		return dev;
+	}
+
 	dev = pci_scan_device(bus, devfn);
 	if (!dev)
 		return NULL;
@@ -1024,35 +1031,26 @@ EXPORT_SYMBOL(pci_scan_single_device);
  * Scan a PCI slot on the specified PCI bus for devices, adding
  * discovered devices to the @bus->devices list.  New devices
  * will not have is_added set.
+ *
+ * Returns the number of new devices found.
  */
 int pci_scan_slot(struct pci_bus *bus, int devfn)
 {
-	int func, nr = 0;
-	int scan_all_fns;
-
-	scan_all_fns = pcibios_scan_all_fns(bus, devfn);
-
-	for (func = 0; func < 8; func++, devfn++) {
-		struct pci_dev *dev;
+	int fn, nr = 0;
+	struct pci_dev *dev;
 
-		dev = pci_scan_single_device(bus, devfn);
-		if (dev) {
+	if ((dev = pci_scan_single_device(bus, devfn)))
+		if (!dev->is_added)	/* new device? */
 			nr++;
 
-			/*
-		 	 * If this is a single function device,
-		 	 * don't scan past the first function.
-		 	 */
-			if (!dev->multifunction) {
-				if (func > 0) {
-					dev->multifunction = 1;
-				} else {
- 					break;
-				}
+	if ((dev && dev->multifunction) ||
+	    (!dev && pcibios_scan_all_fns(bus, devfn))) {
+		for (fn = 1; fn < 8; fn++) {
+			if ((dev = pci_scan_single_device(bus, devfn + fn))) {
+				if (!dev->is_added)
+					nr++;
+				dev->multifunction = 1;
 			}
-		} else {
-			if (func == 0 && !scan_all_fns)
-				break;
 		}
 	}
 
@@ -1192,11 +1190,24 @@ struct pci_bus * __devinit pci_scan_bus_parented(struct device *parent,
 }
 EXPORT_SYMBOL(pci_scan_bus_parented);
 
+/* Does a recursive rescan of all PCI busses. */
+void __devinit pci_rescan_busses(void)
+{
+	struct pci_bus *bus = NULL;
+
+	while ((bus = pci_find_next_bus(bus)) != NULL) {
+		pci_scan_child_bus(bus);
+		pci_bus_assign_resources(bus);
+		pci_bus_add_devices(bus);
+	}
+}
+
 #ifdef CONFIG_HOTPLUG
 EXPORT_SYMBOL(pci_add_new_bus);
 EXPORT_SYMBOL(pci_scan_slot);
 EXPORT_SYMBOL(pci_scan_bridge);
 EXPORT_SYMBOL_GPL(pci_scan_child_bus);
+EXPORT_SYMBOL_GPL(pci_rescan_busses);
 #endif
 
 static int __init pci_sort_bf_cmp(const struct device *d_a, const struct device *d_b)
-- 
1.5.4.3

