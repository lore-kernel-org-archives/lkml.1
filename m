Return-Path: <linux-kernel-owner+w=401wt.eu-S1757995AbZCRWmT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757995AbZCRWmT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 18:42:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758211AbZCRWkL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 18:40:11 -0400
Received: from g4t0017.houston.hp.com ([15.201.24.20]:12003 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756989AbZCRWkI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 18:40:08 -0400
From: Alex Chiang <achiang@hp.com>
Subject: [PATCH v4 08/12] PCI: Introduce /sys/bus/pci/devices/.../remove
To: jbarnes@virtuousgeek.org
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       Trent Piepho <xyzzy@speakeasy.org>, Alex Chiang <achiang@hp.com>
Date: Wed, 18 Mar 2009 16:40:06 -0600
Message-ID: <20090318224006.887.91805.stgit@bob.kio>
In-Reply-To: <20090318222426.887.1008.stgit@bob.kio>
References: <20090318222426.887.1008.stgit@bob.kio>
User-Agent: StGIT/0.14.3.215.gff3d
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds an attribute named "remove" to a PCI device's sysfs
directory.  Writing a non-zero value to this attribute will remove the PCI
device and any children of it.

Trent Piepho wrote the original implementation and documentation.

Thanks to Vegard Nossum for testing under kmemcheck and finding locking
issues with the sysfs interface.

Cc: Trent Piepho <xyzzy@speakeasy.org>
Signed-off-by: Alex Chiang <achiang@hp.com>
---

 Documentation/ABI/testing/sysfs-bus-pci |    8 ++++++
 Documentation/filesystems/sysfs-pci.txt |   10 +++++++
 drivers/pci/pci-sysfs.c                 |   44 +++++++++++++++++++++++++++++++
 3 files changed, 62 insertions(+), 0 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-bus-pci b/Documentation/ABI/testing/sysfs-bus-pci
index ea4aee2..5b1ddde 100644
--- a/Documentation/ABI/testing/sysfs-bus-pci
+++ b/Documentation/ABI/testing/sysfs-bus-pci
@@ -50,6 +50,14 @@ Description:
 		re-discover previously removed devices.
 		Depends on CONFIG_HOTPLUG.
 
+What:		/sys/bus/pci/devices/.../remove
+Date:		January 2009
+Contact:	Linux PCI developers <linux-pci@vger.kernel.org>
+Description:
+		Writing a non-zero value to this attribute will
+		hot-remove the PCI device and any of its children.
+		Depends on CONFIG_HOTPLUG.
+
 What:		/sys/bus/pci/devices/.../vpd
 Date:		February 2008
 Contact:	Ben Hutchings <bhutchings@solarflare.com>
diff --git a/Documentation/filesystems/sysfs-pci.txt b/Documentation/filesystems/sysfs-pci.txt
index 9f8740c..26e4b8b 100644
--- a/Documentation/filesystems/sysfs-pci.txt
+++ b/Documentation/filesystems/sysfs-pci.txt
@@ -12,6 +12,7 @@ that support it.  For example, a given bus might look like this:
      |   |-- enable
      |   |-- irq
      |   |-- local_cpus
+     |   |-- remove
      |   |-- resource
      |   |-- resource0
      |   |-- resource1
@@ -36,6 +37,7 @@ files, each with their own function.
        enable	           Whether the device is enabled (ascii, rw)
        irq		   IRQ number (ascii, ro)
        local_cpus	   nearby CPU mask (cpumask, ro)
+       remove		   remove device from kernel's list (ascii, wo)
        resource		   PCI resource host addresses (ascii, ro)
        resource0..N	   PCI resource N, if present (binary, mmap)
        resource0_wc..N_wc  PCI WC map resource N, if prefetchable (binary, mmap)
@@ -46,6 +48,7 @@ files, each with their own function.
 
   ro - read only file
   rw - file is readable and writable
+  wo - write only file
   mmap - file is mmapable
   ascii - file contains ascii text
   binary - file contains binary data
@@ -73,6 +76,13 @@ that the device must be enabled for a rom read to return data succesfully.
 In the event a driver is not bound to the device, it can be enabled using the
 'enable' file, documented above.
 
+The 'remove' file is used to remove the PCI device, by writing a non-zero
+integer to the file.  This does not involve any kind of hot-plug functionality,
+e.g. powering off the device.  The device is removed from the kernel's list of
+PCI devices, the sysfs directory for it is removed, and the device will be
+removed from any drivers attached to it. Removal of PCI root buses is
+disallowed.
+
 Accessing legacy resources through sysfs
 ----------------------------------------
 
diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
index 22dbc65..6e2b1fd 100644
--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -246,6 +246,47 @@ struct bus_attribute pci_bus_attrs[] = {
 	__ATTR(rescan, S_IWUSR, NULL, bus_rescan_store),
 	__ATTR_NULL
 };
+
+static void remove_callback(struct device *dev)
+{
+	int bridge = 0;
+	struct pci_dev *pdev = to_pci_dev(dev);
+
+	mutex_lock(&pci_remove_rescan_mutex);
+
+	if (pdev->subordinate)
+		bridge = 1;
+
+	pci_remove_bus_device(pdev);
+	if (bridge && list_empty(&pdev->bus->devices))
+		pci_remove_bus(pdev->bus);
+
+	mutex_unlock(&pci_remove_rescan_mutex);
+}
+
+static ssize_t
+remove_store(struct device *dev, struct device_attribute *dummy,
+	     const char *buf, size_t count)
+{
+	int ret = 0;
+	unsigned long val;
+	struct pci_dev *pdev = to_pci_dev(dev);
+
+	if (strict_strtoul(buf, 0, &val) < 0)
+		return -EINVAL;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	if (pdev->subordinate && pci_is_root_bus(pdev->bus))
+		return -EBUSY;
+
+	if (val)
+		ret = device_schedule_callback(dev, remove_callback);
+	if (ret)
+		count = ret;
+	return count;
+}
 #endif
 
 struct device_attribute pci_dev_attrs[] = {
@@ -266,6 +307,9 @@ struct device_attribute pci_dev_attrs[] = {
 	__ATTR(broken_parity_status,(S_IRUGO|S_IWUSR),
 		broken_parity_status_show,broken_parity_status_store),
 	__ATTR(msi_bus, 0644, msi_bus_show, msi_bus_store),
+#ifdef CONFIG_HOTPLUG
+	__ATTR(remove, S_IWUSR, NULL, remove_store),
+#endif
 	__ATTR_NULL,
 };
 

