Return-Path: <linux-kernel-owner+w=401wt.eu-S1757498AbYHRUVW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757498AbYHRUVW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 16:21:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752648AbYHRUVH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 16:21:07 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:48258 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752593AbYHRUVF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 16:21:05 -0400
Date: Mon, 18 Aug 2008 14:21:00 -0600
From: Alex Chiang <achiang@hp.com>
To: jbarnes@virtuousgeek.org, matthew@wil.cx
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] PCI: create device, function symlinks in
	/sys/bus/pci/slots/N/
Message-ID: <20080818202100.GE23155@ldl.fc.hp.com>
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

Create convenience symlinks in sysfs, linking slots to devices
and functions, and vice versa. These links make it easier for
users to figure out which devices actually live in what slots.

The device symlink points to the device's first function.

For example:

sapphire:/sys/bus/pci/slots # ls
1  10  2  3  4  5  6  7  8  9

sapphire:/sys/bus/pci/slots # ls -l 3
total 0
-r--r--r-- 1 root root 65536 Aug 18 14:10 address
lrwxrwxrwx 1 root root     0 Aug 18 14:10 device -> ../../../../devices/pci0000:23/0000:23:01.0
lrwxrwxrwx 1 root root     0 Aug 18 14:10 function0 -> ../../../../devices/pci0000:23/0000:23:01.0
lrwxrwxrwx 1 root root     0 Aug 18 14:10 function1 -> ../../../../devices/pci0000:23/0000:23:01.1

sapphire:/sys/bus/pci/slots # ls -l 3/device/slot
lrwxrwxrwx 1 root root 0 Aug 18 14:13 3/device/slot -> ../../../bus/pci/slots/3

The original form of this patch was written by Matthew Wilcox,
but did not have links from the sysfs slots/ directory pointing
back at devices and functions.

Cc: matthew@wil.cx
Signed-off-by: Alex Chiang <achiang@hp.com>
---
 slot.c |   58 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 58 insertions(+)

diff --git a/drivers/pci/slot.c b/drivers/pci/slot.c
index 7e5b85c..76095ac 100644
--- a/drivers/pci/slot.c
+++ b/drivers/pci/slot.c
@@ -47,6 +47,60 @@ static ssize_t address_read_file(struct pci_slot *slot, char *buf)
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
+	sysfs_remove_link(&slot->kobj, "device");
+}
+
+static int create_sysfs_files(struct pci_slot *slot)
+{
+	int result, lastdev = -1;
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
+		if (PCI_SLOT(dev->devfn) != lastdev) {
+			lastdev = PCI_SLOT(dev->devfn);
+			result = sysfs_create_link(&slot->kobj,
+						   &dev->dev.kobj,
+						   "device");
+			if (result)
+				goto fail;
+		}
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
@@ -54,6 +108,8 @@ static void pci_slot_release(struct kobject *kobj)
 	pr_debug("%s: releasing pci_slot on %x:%d\n", __func__,
 		 slot->bus->number, slot->number);
 
+	remove_sysfs_files(slot);
+
 	list_del(&slot->list);
 
 	kfree(slot);
@@ -150,6 +206,8 @@ placeholder:
 	INIT_LIST_HEAD(&slot->list);
 	list_add(&slot->list, &parent->slots);
 
+	create_sysfs_files(slot);
+
 	/* Don't care if debug printk has a -1 for slot_nr */
 	pr_debug("%s: created pci_slot on %04x:%02x:%02x\n",
 		 __func__, pci_domain_nr(parent), parent->number, slot_nr);
