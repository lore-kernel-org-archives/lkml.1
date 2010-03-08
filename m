Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754125Ab0CHRY6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 12:24:58 -0500
Received: from g6t0184.atlanta.hp.com ([15.193.32.61]:5159 "EHLO
	g6t0184.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750987Ab0CHRYv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 12:24:51 -0500
Date: Mon, 8 Mar 2010 10:24:29 -0700
From: Alex Chiang <achiang@hp.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>,
       linux-pci <linux-pci@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Cc: willy@linux.intel.com
Subject: [PATCH] PCI: create function symlinks in /sys/bus/pci/slots/N/
Message-ID: <20100308172429.GA20953@ldl.fc.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Create convenience symlinks in sysfs, linking slots to device
functions, and vice versa. These links make it easier for users to
figure out which devices actually live in what slots.

For example:

sapphire:/sys/bus/pci/slots # ls
1  10  2  3  4  5  6  7  8  9

sapphire:/sys/bus/pci/slots # ls -l 3
total 0
-r--r--r-- 1 root root 65536 Aug 18 14:10 address
lrwxrwxrwx 1 root root     0 Aug 18 14:10 function0 ->
../../../../devices/pci0000:23/0000:23:01.0
lrwxrwxrwx 1 root root     0 Aug 18 14:10 function1 ->
../../../../devices/pci0000:23/0000:23:01.1

sapphire:/sys/bus/pci/slots # ls -l 3/function0/slot
lrwxrwxrwx 1 root root 0 Aug 18 14:13 3/function0/slot ->
../../../bus/pci/slots/3

The original form of this patch was written by Matthew Wilcox,
and was enhanced to include links from the sysfs slots/ directory
pointing back at the device functions.

Cc: willy@linux.intel.com
Signed-off-by: Alex Chiang <achiang@hp.com>
---
Not sure why I've been sitting on this patch for so long, but
I think it would be a useful thing to have upstream.

 Documentation/ABI/testing/sysfs-bus-pci |   40 ++++++++++++++++++++++++++
 drivers/pci/pci-sysfs.c                 |   37 ++++++++++++++++++++++++
 drivers/pci/slot.c                      |   48 ++++++++++++++++++++++++++++++++
 3 files changed, 125 insertions(+)
---
diff --git a/Documentation/ABI/testing/sysfs-bus-pci b/Documentation/ABI/testing/sysfs-bus-pci
index 25be325..428676c 100644
--- a/Documentation/ABI/testing/sysfs-bus-pci
+++ b/Documentation/ABI/testing/sysfs-bus-pci
@@ -133,6 +133,46 @@ Description:
 		The symbolic link points to the PCI device sysfs entry of the
 		Physical Function this device associates with.
 
+
+What:		/sys/bus/pci/slots/...
+Date:		April 2005 (possibly older)
+KernelVersion:	2.6.12 (possibly older)
+Contact:	linux-pci@vger.kernel.org
+Description:
+		When the appropriate driver is loaded, it will create a
+		directory per claimed physical PCI slot in
+		/sys/bus/pci/slots/.  The names of these directories are
+		specific to the driver, which in turn, are specific to the
+		platform, but in general, should match the label on the
+		machine's physical chassis.
+
+		The drivers that can create slot directories include the
+		PCI hotplug drivers, and as of 2.6.27, the pci_slot driver.
+
+		The slot directories contain, at a minimum, a file named
+		'address' which contains the PCI bus:device:function tuple.
+		Other files may appear as well, but are specific to the
+		driver.
+
+What:		/sys/bus/pci/slots/.../function[0-7]
+Date:		March 2010
+KernelVersion:	2.6.35
+Contact:	linux-pci@vger.kernel.org
+Description:
+		If PCI slot directories (as described above) are created,
+		and the physical slot is actually populated with a device,
+		symbolic links in the slot directory pointing to the
+		device's PCI functions are created as well.
+
+What:		/sys/bus/pci/devices/.../slot
+Date:		March 2010
+KernelVersion:	2.6.35
+Contact:	linux-pci@vger.kernel.org
+Description:
+		If PCI slot directories (as described above) are created,
+		a symbolic link pointing to the slot directory will be
+		created as well.
+
 What:		/sys/bus/pci/slots/.../module
 Date:		June 2009
 Contact:	linux-pci@vger.kernel.org
diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
index 807224e..d234234 100644
--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -1006,6 +1006,39 @@ error:
 	return retval;
 }
 
+static void pci_remove_slot_links(struct pci_dev *dev)
+{
+	char func[10];
+	struct pci_slot *slot;
+
+	sysfs_remove_link(&dev->dev.kobj, "slot");
+	list_for_each_entry(slot, &dev->bus->slots, list) {
+		if (slot->number != PCI_SLOT(dev->devfn))
+			continue;
+		snprintf(func, 10, "function%d", PCI_FUNC(dev->devfn));
+		sysfs_remove_link(&slot->kobj, func);
+	}
+}
+
+static int pci_create_slot_links(struct pci_dev *dev)
+{
+	int result = 0;
+	char func[10];
+	struct pci_slot *slot;
+
+	list_for_each_entry(slot, &dev->bus->slots, list) {
+		if (slot->number != PCI_SLOT(dev->devfn))
+			continue;
+		result = sysfs_create_link(&dev->dev.kobj, &slot->kobj, "slot");
+		if (result)
+			goto out;
+		snprintf(func, 10, "function%d", PCI_FUNC(dev->devfn));
+		result = sysfs_create_link(&slot->kobj, &dev->dev.kobj, func);
+	}
+out:
+	return result;
+}
+
 int __must_check pci_create_sysfs_dev_files (struct pci_dev *pdev)
 {
 	int retval;
@@ -1067,6 +1100,8 @@ int __must_check pci_create_sysfs_dev_files (struct pci_dev *pdev)
 	if (retval)
 		goto err_vga_file;
 
+	pci_create_slot_links(pdev);
+
 	return 0;
 
 err_vga_file:
@@ -1116,6 +1151,8 @@ void pci_remove_sysfs_dev_files(struct pci_dev *pdev)
 	if (!sysfs_initialized)
 		return;
 
+	pci_remove_slot_links(pdev);
+
 	pci_remove_capabilities_sysfs(pdev);
 
 	if (pdev->cfg_size < PCI_CFG_SPACE_EXP_SIZE)
diff --git a/drivers/pci/slot.c b/drivers/pci/slot.c
index 49c9e6c..a8e22c6 100644
--- a/drivers/pci/slot.c
+++ b/drivers/pci/slot.c
@@ -96,6 +96,50 @@ static ssize_t cur_speed_read_file(struct pci_slot *slot, char *buf)
 	return bus_speed_read(slot->bus->cur_bus_speed, buf);
 }
 
+static void remove_sysfs_files(struct pci_slot *slot)
+{
+	char func[10];
+	struct list_head *tmp;
+
+	list_for_each(tmp, &slot->bus->devices) {
+		struct pci_dev *dev = pci_dev_b(tmp);
+		if (PCI_SLOT(dev->devfn) != slot->number)
+			continue;
+		sysfs_remove_link(&dev->dev.kobj, "slot");
+
+		snprintf(func, 10, "function%d", PCI_FUNC(dev->devfn));
+		sysfs_remove_link(&slot->kobj, func);
+	}
+}
+
+static int create_sysfs_files(struct pci_slot *slot)
+{
+	int result;
+	char func[10];
+	struct list_head *tmp;
+
+	list_for_each(tmp, &slot->bus->devices) {
+		struct pci_dev *dev = pci_dev_b(tmp);
+		if (PCI_SLOT(dev->devfn) != slot->number)
+			continue;
+
+		result = sysfs_create_link(&dev->dev.kobj, &slot->kobj, "slot");
+		if (result)
+			goto fail;
+
+		snprintf(func, 10, "function%d", PCI_FUNC(dev->devfn));
+		result = sysfs_create_link(&slot->kobj, &dev->dev.kobj, func);
+		if (result)
+			goto fail;
+	}
+
+	return 0;
+
+fail:
+	remove_sysfs_files(slot);
+	return result;
+}
+
 static void pci_slot_release(struct kobject *kobj)
 {
 	struct pci_dev *dev;
@@ -108,6 +152,8 @@ static void pci_slot_release(struct kobject *kobj)
 		if (PCI_SLOT(dev->devfn) == slot->number)
 			dev->slot = NULL;
 
+	remove_sysfs_files(slot);
+
 	list_del(&slot->list);
 
 	kfree(slot);
@@ -299,6 +345,8 @@ placeholder:
 	INIT_LIST_HEAD(&slot->list);
 	list_add(&slot->list, &parent->slots);
 
+	create_sysfs_files(slot);
+
 	list_for_each_entry(dev, &parent->devices, bus_list)
 		if (PCI_SLOT(dev->devfn) == slot_nr)
 			dev->slot = slot;
