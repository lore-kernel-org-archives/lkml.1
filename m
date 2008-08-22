Return-Path: <linux-kernel-owner+w=401wt.eu-S1755117AbYHVQVA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755117AbYHVQVA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 12:21:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751893AbYHVQUv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 12:20:51 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:3402 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751247AbYHVQUu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 12:20:50 -0400
Date: Fri, 22 Aug 2008 10:20:49 -0600
From: Alex Chiang <achiang@hp.com>
To: jbarnes@virtuousgeek.org, matthew@wil.cx
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH, v2] PCI: create function symlinks in /sys/bus/pci/slots/N/
Message-ID: <20080822162048.GA20820@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>, jbarnes@virtuousgeek.org,
	matthew@wil.cx, linux-pci@vger.kernel.org,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a second attempt at creating some handy symlinks in
/sys/bus/pci/ between slots and devices.

It addresses the following concerns from last time:

	- does not create superfluous 'device' link
	- correctly adds and removes links after hotplug ops
	- adds a bunch of documentation ;)

It does not address Willy's concerns about not needing the
functionN back-links.  I kinda thought they were useful, no one
else seemed to express an opinion...

This patch is against linux-next, but do note that you'll need
gregkh's "pci_get_dev_by_id refleak" patch:

	http://lkml.org/lkml/2008/8/21/492

for this patch to work properly.

Thanks!

/ac

From: Alex Chiang <achiang@hp.com>

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
but did not have links from the sysfs slots/ directory pointing
back at the device functions.

Cc: matthew@wil.cx
Signed-off-by: Alex Chiang <achiang@hp.com>
---
 Documentation/ABI/testing/sysfs-bus-pci |   39 +++++++++++++++++++++++++
 drivers/pci/pci-sysfs.c                 |   37 +++++++++++++++++++++++
 drivers/pci/slot.c                      |   48 +++++++++++++++++++++++++++++++
 3 files changed, 124 insertions(+), 0 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-bus-pci b/Documentation/ABI/testing/sysfs-bus-pci
index ceddcff..122490f 100644
--- a/Documentation/ABI/testing/sysfs-bus-pci
+++ b/Documentation/ABI/testing/sysfs-bus-pci
@@ -9,3 +9,42 @@ Description:
 		that some devices may have malformatted data.  If the
 		underlying VPD has a writable section then the
 		corresponding section of this file will be writable.
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
+Date:		August 2008
+KernelVersion:	2.6.28
+Contact:	linux-pci@vger.kernel.org
+Description:
+		If PCI slot directories (as described above) are created,
+		and the physical slot is actually populated with a device,
+		symbolic links in the slot directory pointing to the
+		device's PCI functions are created as well.
+
+What:		/sys/bus/pci/devices/.../slot
+Date:		August 2008
+KernelVersion:	2.6.28
+Contact:	linux-pci@vger.kernel.org
+Description:
+		If PCI slot directories (as described above) are created,
+		a symbolic link pointing to the slot directory will be
+		created as well.
diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
index 9c71858..c162c61 100644
--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -716,6 +716,39 @@ int __attribute__ ((weak)) pcibios_add_platform_entries(struct pci_dev *dev)
 	return 0;
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
 	struct bin_attribute *attr = NULL;
@@ -779,6 +812,8 @@ int __must_check pci_create_sysfs_dev_files (struct pci_dev *pdev)
 
 	pcie_aspm_create_sysfs_dev_files(pdev);
 
+	pci_create_slot_links(pdev);
+
 	return 0;
 
 err_rom_file:
@@ -814,6 +849,8 @@ void pci_remove_sysfs_dev_files(struct pci_dev *pdev)
 	if (!sysfs_initialized)
 		return;
 
+	pci_remove_slot_links(pdev);
+
 	pcie_aspm_remove_sysfs_dev_files(pdev);
 
 	if (pdev->vpd) {
diff --git a/drivers/pci/slot.c b/drivers/pci/slot.c
index 7e5b85c..438c448 100644
--- a/drivers/pci/slot.c
+++ b/drivers/pci/slot.c
@@ -47,6 +47,50 @@ static ssize_t address_read_file(struct pci_slot *slot, char *buf)
 				slot->number);
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
 	struct pci_slot *slot = to_pci_slot(kobj);
@@ -54,6 +98,8 @@ static void pci_slot_release(struct kobject *kobj)
 	pr_debug("%s: releasing pci_slot on %x:%d\n", __func__,
 		 slot->bus->number, slot->number);
 
+	remove_sysfs_files(slot);
+
 	list_del(&slot->list);
 
 	kfree(slot);
@@ -150,6 +196,8 @@ placeholder:
 	INIT_LIST_HEAD(&slot->list);
 	list_add(&slot->list, &parent->slots);
 
+	create_sysfs_files(slot);
+
 	/* Don't care if debug printk has a -1 for slot_nr */
 	pr_debug("%s: created pci_slot on %04x:%02x:%02x\n",
 		 __func__, pci_domain_nr(parent), parent->number, slot_nr);
-- 
1.5.3.1.gbed62

