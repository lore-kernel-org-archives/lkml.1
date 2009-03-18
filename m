Return-Path: <linux-kernel-owner+w=401wt.eu-S1759982AbZCRWmf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759982AbZCRWmf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 18:42:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755343AbZCRWkN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 18:40:13 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:2845 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755865AbZCRWkL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 18:40:11 -0400
From: Alex Chiang <achiang@hp.com>
Subject: [PATCH v4 07/12] PCI: Introduce /sys/bus/pci/rescan
To: jbarnes@virtuousgeek.org
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       Trent Piepho <xyzzy@speakeasy.org>, Alex Chiang <achiang@hp.com>
Date: Wed, 18 Mar 2009 16:40:01 -0600
Message-ID: <20090318224001.887.63554.stgit@bob.kio>
In-Reply-To: <20090318222426.887.1008.stgit@bob.kio>
References: <20090318222426.887.1008.stgit@bob.kio>
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
 drivers/pci/pci-sysfs.c                 |   29 +++++++++++++++++++++++++++++
 drivers/pci/pci.h                       |    6 ++++++
 4 files changed, 45 insertions(+), 0 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-bus-pci b/Documentation/ABI/testing/sysfs-bus-pci
index e638e15..ea4aee2 100644
--- a/Documentation/ABI/testing/sysfs-bus-pci
+++ b/Documentation/ABI/testing/sysfs-bus-pci
@@ -41,6 +41,15 @@ Description:
 		for the device and attempt to bind to it.  For example:
 		# echo "8086 10f5" > /sys/bus/pci/drivers/foo/new_id
 
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
index a5f11ad..62ed864 100644
--- a/drivers/pci/pci-driver.c
+++ b/drivers/pci/pci-driver.c
@@ -973,6 +973,7 @@ struct bus_type pci_bus_type = {
 	.remove		= pci_device_remove,
 	.shutdown	= pci_device_shutdown,
 	.dev_attrs	= pci_dev_attrs,
+	.bus_attrs	= pci_bus_attrs,
 	.pm		= PCI_PM_OPS_PTR,
 };
 
diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
index 1c89298..22dbc65 100644
--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -219,6 +219,35 @@ msi_bus_store(struct device *dev, struct device_attribute *attr,
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
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
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
+	__ATTR(rescan, S_IWUSR, NULL, bus_rescan_store),
+	__ATTR_NULL
+};
+#endif
+
 struct device_attribute pci_dev_attrs[] = {
 	__ATTR_RO(resource),
 	__ATTR_RO(vendor),
diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
index 07c0aa5..6dea35f 100644
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

