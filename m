Return-Path: <linux-kernel-owner+w=401wt.eu-S1760858AbZCTU66@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760858AbZCTU66 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 16:58:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758668AbZCTU4e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 16:56:34 -0400
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:39094 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759192AbZCTU4d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 16:56:33 -0400
From: Alex Chiang <achiang@hp.com>
Subject: [PATCH v5 08/13] PCI: Introduce /sys/bus/pci/rescan
To: jbarnes@virtuousgeek.org
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       Trent Piepho <xyzzy@speakeasy.org>, Alex Chiang <achiang@hp.com>
Date: Fri, 20 Mar 2009 14:56:31 -0600
Message-ID: <20090320205631.12275.99348.stgit@bob.kio>
In-Reply-To: <20090320204327.12275.43010.stgit@bob.kio>
References: <20090320204327.12275.43010.stgit@bob.kio>
User-Agent: StGIT/0.14.3.215.gff3d
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This interface allows the user to force a rescan of all PCI buses
in system, and rediscover devices that have been removed earlier.

pci_bus_attrs implementation from Trent Piepho.

Thanks to Vegard Nossum for discovering locking issues with the
sysfs interface.

Cc: Trent Piepho <xyzzy@speakeasy.org>
Signed-off-by: Alex Chiang <achiang@hp.com>
---

 Documentation/ABI/testing/sysfs-bus-pci |    9 +++++++++
 drivers/pci/pci-driver.c                |    1 +
 drivers/pci/pci-sysfs.c                 |   26 ++++++++++++++++++++++++++
 drivers/pci/pci.h                       |    6 ++++++
 drivers/pci/probe.c                     |    4 ++--
 5 files changed, 44 insertions(+), 2 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-bus-pci b/Documentation/ABI/testing/sysfs-bus-pci
index 3d29793..1697a16 100644
--- a/Documentation/ABI/testing/sysfs-bus-pci
+++ b/Documentation/ABI/testing/sysfs-bus-pci
@@ -57,6 +57,15 @@ Description:
 		match the driver to the device.  For example:
 		# echo "8086 10f5" > /sys/bus/pci/drivers/foo/remove_id
 
+What:		/sys/bus/pci/rescan
+Date:		January 2009
+Contact:	Linux PCI developers <linux-pci@vger.kernel.org>
+Description:
+		Writing a non-zero value to this attribute will
+		force a rescan of all PCI buses in the system, and
+		re-discover previously removed devices.
+		Depends on CONFIG_HOTPLUG.
+
 What:		/sys/bus/pci/devices/.../vpd
 Date:		February 2008
 Contact:	Ben Hutchings <bhutchings@solarflare.com>
diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
index 87a5ddb..95d1985 100644
--- a/drivers/pci/pci-driver.c
+++ b/drivers/pci/pci-driver.c
@@ -1049,6 +1049,7 @@ struct bus_type pci_bus_type = {
 	.remove		= pci_device_remove,
 	.shutdown	= pci_device_shutdown,
 	.dev_attrs	= pci_dev_attrs,
+	.bus_attrs	= pci_bus_attrs,
 	.pm		= PCI_PM_OPS_PTR,
 };
 
diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
index ec7a175..be7468a 100644
--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -219,6 +219,32 @@ msi_bus_store(struct device *dev, struct device_attribute *attr,
 	return count;
 }
 
+#ifdef CONFIG_HOTPLUG
+static DEFINE_MUTEX(pci_remove_rescan_mutex);
+static ssize_t bus_rescan_store(struct bus_type *bus, const char *buf,
+				size_t count)
+{
+	unsigned long val;
+	struct pci_bus *b = NULL;
+
+	if (strict_strtoul(buf, 0, &val) < 0)
+		return -EINVAL;
+
+	if (val) {
+		mutex_lock(&pci_remove_rescan_mutex);
+		while ((b = pci_find_next_bus(b)) != NULL)
+			pci_rescan_bus(b);
+		mutex_unlock(&pci_remove_rescan_mutex);
+	}
+	return count;
+}
+
+struct bus_attribute pci_bus_attrs[] = {
+	__ATTR(rescan, (S_IWUSR|S_IWGRP), NULL, bus_rescan_store),
+	__ATTR_NULL
+};
+#endif
+
 struct device_attribute pci_dev_attrs[] = {
 	__ATTR_RO(resource),
 	__ATTR_RO(vendor),
diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
index 2cd1cba..5b2eb30 100644
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -136,6 +136,12 @@ extern int pcie_mch_quirk;
 extern struct device_attribute pci_dev_attrs[];
 extern struct device_attribute dev_attr_cpuaffinity;
 extern struct device_attribute dev_attr_cpulistaffinity;
+#ifdef CONFIG_HOTPLUG
+extern struct bus_attribute pci_bus_attrs[];
+#else
+#define pci_bus_attrs	NULL
+#endif
+
 
 /**
  * pci_match_one_device - Tell if a PCI device structure has a matching
diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 53edb7e..1541899 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -1219,13 +1219,13 @@ unsigned int __devinit pci_rescan_bus(struct pci_bus *bus)
 
 	max = pci_scan_child_bus(bus);
 
-	up_read(&pci_bus_sem);
+	down_read(&pci_bus_sem);
 	list_for_each_entry(dev, &bus->devices, bus_list)
 		if (dev->hdr_type == PCI_HEADER_TYPE_BRIDGE ||
 		    dev->hdr_type == PCI_HEADER_TYPE_CARDBUS)
 			if (dev->subordinate)
 				pci_bus_size_bridges(dev->subordinate);
-	down_read(&pci_bus_sem);
+	up_read(&pci_bus_sem);
 
 	pci_bus_assign_resources(bus);
 	pci_enable_bridges(bus);

