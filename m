Return-Path: <linux-kernel-owner+w=401wt.eu-S1756369AbZA2Kzj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756369AbZA2Kzj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 05:55:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752156AbZA2Kz2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 05:55:28 -0500
Received: from mail2.sea5.speakeasy.net ([69.17.117.4]:50677 "EHLO
	mail2.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751716AbZA2Kz1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 05:55:27 -0500
From: Trent Piepho <xyzzy@speakeasy.org>
To: linux-kernel@vger.kernel.org
Cc: linux-pci@vger.kernel.org, jbarnes@virtuousgeek.org,
       Alex Chiang <achiang@hp.com>, djwong@us.ibm.com,
       Trent Piepho <xyzzy@speakeasy.org>
Subject: [PATCH 1/3] PCI: Method for removing PCI devices
Date: Thu, 29 Jan 2009 02:55:13 -0800
Message-Id: <1233226515-4906-1-git-send-email-xyzzy@speakeasy.org>
X-Mailer: git-send-email 1.5.4.1
In-Reply-To: <Pine.LNX.4.58.0901290221480.17300@shell2.speakeasy.net>
References: <Pine.LNX.4.58.0901290221480.17300@shell2.speakeasy.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds an attribute named "remove" to a PCI device's sysfs
directory.  Writing a non-zero value to this attribute will remove the PCI
device and any children of it.
---
 Documentation/filesystems/sysfs-pci.txt |    9 +++++++++
 drivers/pci/pci-sysfs.c                 |   26 ++++++++++++++++++++++++++
 2 files changed, 35 insertions(+), 0 deletions(-)

diff --git a/Documentation/filesystems/sysfs-pci.txt b/Documentation/filesystems/sysfs-pci.txt
index 68ef488..54e014f 100644
--- a/Documentation/filesystems/sysfs-pci.txt
+++ b/Documentation/filesystems/sysfs-pci.txt
@@ -11,6 +11,7 @@ that support it.  For example, a given bus might look like this:
      |   |-- device
      |   |-- irq
      |   |-- local_cpus
+     |   |-- remove
      |   |-- resource
      |   |-- resource0
      |   |-- resource1
@@ -34,6 +35,7 @@ files, each with their own function.
        device		   PCI device (ascii, ro)
        irq		   IRQ number (ascii, ro)
        local_cpus	   nearby CPU mask (cpumask, ro)
+       remove		   remove device from kernel's list (ascii, wo)
        resource		   PCI resource host addresses (ascii, ro)
        resource0..N	   PCI resource N, if present (binary, mmap)
        resource0_wc..N_wc  PCI WC map resource N, if prefetchable (binary, mmap)
@@ -44,6 +46,7 @@ files, each with their own function.
 
   ro - read only file
   rw - file is readable and writable
+  wo - write only file
   mmap - file is mmapable
   ascii - file contains ascii text
   binary - file contains binary data
@@ -62,6 +65,12 @@ ROM file, if available.  It's disabled by default, however, so applications
 should write the string "1" to the file to enable it before attempting a read
 call, and disable it following the access by writing "0" to the file.
 
+The 'remove' file is used to remove the PCI device, by writing a non-zero
+integer to the file.  This does not involve any kind of hot-plug functionality,
+e.g. powering off the device.  The device is removed from the kernel's list of
+PCI devices, the sysfs directory for it removed, and the device will be removed
+from any drivers attached to it.
+
 Accessing legacy resources through sysfs
 ----------------------------------------
 
diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
index 3ddee7f..d422f37 100644
--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -219,6 +219,31 @@ msi_bus_store(struct device *dev, struct device_attribute *attr,
 	return count;
 }
 
+static void remove_callback(void *data)
+{
+	pci_remove_bus_device((struct pci_dev *)data);
+}
+
+static ssize_t
+remove_store(struct device *dev, struct device_attribute *dummy,
+	     const char *buf, size_t count)
+{
+	struct pci_dev *pdev = to_pci_dev(dev);
+	unsigned long val;
+
+	if (strict_strtoul(buf, 0, &val) < 0)
+		return -EINVAL;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	if (val)
+		sysfs_schedule_callback(&dev->kobj, remove_callback, pdev,
+		                        THIS_MODULE);
+
+	return count;
+}
+
 struct device_attribute pci_dev_attrs[] = {
 	__ATTR_RO(resource),
 	__ATTR_RO(vendor),
@@ -237,6 +262,7 @@ struct device_attribute pci_dev_attrs[] = {
 	__ATTR(broken_parity_status,(S_IRUGO|S_IWUSR),
 		broken_parity_status_show,broken_parity_status_store),
 	__ATTR(msi_bus, 0644, msi_bus_show, msi_bus_store),
+	__ATTR(remove, S_IWUSR, NULL, remove_store),
 	__ATTR_NULL,
 };
 
-- 
1.5.4.3

