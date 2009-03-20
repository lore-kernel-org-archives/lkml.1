Return-Path: <linux-kernel-owner+w=401wt.eu-S1757924AbZCTVAG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757924AbZCTVAG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 17:00:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752074AbZCTU4v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 16:56:51 -0400
Received: from g4t0017.houston.hp.com ([15.201.24.20]:25593 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759348AbZCTU4s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 16:56:48 -0400
From: Alex Chiang <achiang@hp.com>
Subject: [PATCH v5 11/13] PCI Hotplug: restore fakephp interface with complete
	reimplementation
To: jbarnes@virtuousgeek.org
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       Trent Piepho <xyzzy@speakeasy.org>, Alex Chiang <achiang@hp.com>
Date: Fri, 20 Mar 2009 14:56:46 -0600
Message-ID: <20090320205646.12275.24978.stgit@bob.kio>
In-Reply-To: <20090320204327.12275.43010.stgit@bob.kio>
References: <20090320204327.12275.43010.stgit@bob.kio>
User-Agent: StGIT/0.14.3.215.gff3d
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Trent Piepho <xyzzy@speakeasy.org>

A complete re-implementation of fakephp is necessary if it is to
present its former interface (pre-2.6.27, when it broke). The
reason is that PCI hotplug drivers call pci_hp_register(), which
enforces the rule that only one /sys/bus/pci/slots/ file may be
created per physical slot.

The change breaks the old fakephp's assumption that it could
create a file per function. So we re-implement fakephp to avoid
using the standard PCI hotplug API so that we can restore the old
fakephp user interface.

It puts entries in /sys/bus/pci/slots with the names of all PCI
devices/functions, exactly symmetrical to what is shown in
/sys/bus/pci/devices. Each slots/ entry has a "power" attribute,
which works the same way as the fakephp driver's power attribute
has worked.

There are a few improvements over old fakephp, which couldn't handle
PCI devices being added or removed via a means outside of
fakephp's knowledge.  If a device was added another way, old fakephp
didn't notice and didn't create the fake slot for it.  If a
device was removed another way, old fakephp didn't delete the fake
slot for it (and accessing the stale slot caused an oops).

The new implementation overcomes these limitations. As a
consequence, removing a bridge with other devices behind it now
works as well, which is something else old fakephp couldn't do
previously.

This duplicates a tiny bit of the code in the PCI core that does
this same function.  Re-using that code ends up being more
complex than duplicating it, and it makes code in the PCI core
more ugly just to support this legacy fakephp interface
compatibility layer.

[achiang@hp.com: rewrite changelog]
[achiang@hp.com: use pci_rescan_bus()]
Reviewed-by: James Cameron <qz@hp.com>
Signed-off-by: Trent Piepho <xyzzy@speakeasy.org>
Signed-off-by: Alex Chiang <achiang@hp.com>
---

 drivers/pci/hotplug/Makefile         |    2 
 drivers/pci/hotplug/fakephp.c        |  395 ----------------------------------
 drivers/pci/hotplug/legacy_fakephp.c |  162 ++++++++++++++
 3 files changed, 163 insertions(+), 396 deletions(-)
 delete mode 100644 drivers/pci/hotplug/fakephp.c
 create mode 100644 drivers/pci/hotplug/legacy_fakephp.c

diff --git a/drivers/pci/hotplug/Makefile b/drivers/pci/hotplug/Makefile
index 2aa117c..3314fe8 100644
--- a/drivers/pci/hotplug/Makefile
+++ b/drivers/pci/hotplug/Makefile
@@ -20,7 +20,7 @@ obj-$(CONFIG_HOTPLUG_PCI_RPA_DLPAR)	+= rpadlpar_io.o
 obj-$(CONFIG_HOTPLUG_PCI_SGI)		+= sgi_hotplug.o
 
 # Link this last so it doesn't claim devices that have a real hotplug driver
-obj-$(CONFIG_HOTPLUG_PCI_FAKE)		+= fakephp.o
+obj-$(CONFIG_HOTPLUG_PCI_FAKE)		+= legacy_fakephp.o
 
 pci_hotplug-objs	:=	pci_hotplug_core.o
 
diff --git a/drivers/pci/hotplug/fakephp.c b/drivers/pci/hotplug/fakephp.c
deleted file mode 100644
index 1606374..0000000
--- a/drivers/pci/hotplug/fakephp.c
+++ /dev/null
@@ -1,395 +0,0 @@
-/*
- * Fake PCI Hot Plug Controller Driver
- *
- * Copyright (C) 2003 Greg Kroah-Hartman <greg@kroah.com>
- * Copyright (C) 2003 IBM Corp.
- * Copyright (C) 2003 Rolf Eike Beer <eike-kernel@sf-tec.de>
- *
- * Based on ideas and code from:
- * 	Vladimir Kondratiev <vladimir.kondratiev@intel.com>
- *	Rolf Eike Beer <eike-kernel@sf-tec.de>
- *
- * All rights reserved.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation, version 2 of the License.
- *
- * Send feedback to <greg@kroah.com>
- */
-
-/*
- *
- * This driver will "emulate" removing PCI devices from the system.  If
- * the "power" file is written to with "0" then the specified PCI device
- * will be completely removed from the kernel.
- *
- * WARNING, this does NOT turn off the power to the PCI device.  This is
- * a "logical" removal, not a physical or electrical removal.
- *
- * Use this module at your own risk, you have been warned!
- *
- * Enabling PCI devices is left as an exercise for the reader...
- *
- */
-#include <linux/kernel.h>
-#include <linux/module.h>
-#include <linux/pci.h>
-#include <linux/pci_hotplug.h>
-#include <linux/init.h>
-#include <linux/string.h>
-#include <linux/slab.h>
-#include <linux/workqueue.h>
-#include "../pci.h"
-
-#if !defined(MODULE)
-	#define MY_NAME	"fakephp"
-#else
-	#define MY_NAME	THIS_MODULE->name
-#endif
-
-#define dbg(format, arg...)					\
-	do {							\
-		if (debug)					\
-			printk(KERN_DEBUG "%s: " format,	\
-				MY_NAME , ## arg); 		\
-	} while (0)
-#define err(format, arg...) printk(KERN_ERR "%s: " format, MY_NAME , ## arg)
-#define info(format, arg...) printk(KERN_INFO "%s: " format, MY_NAME , ## arg)
-
-#define DRIVER_AUTHOR	"Greg Kroah-Hartman <greg@kroah.com>"
-#define DRIVER_DESC	"Fake PCI Hot Plug Controller Driver"
-
-struct dummy_slot {
-	struct list_head node;
-	struct hotplug_slot *slot;
-	struct pci_dev *dev;
-	struct work_struct remove_work;
-	unsigned long removed;
-};
-
-static int debug;
-static int dup_slots;
-static LIST_HEAD(slot_list);
-static struct workqueue_struct *dummyphp_wq;
-
-static void pci_rescan_worker(struct work_struct *work);
-static DECLARE_WORK(pci_rescan_work, pci_rescan_worker);
-
-static int enable_slot (struct hotplug_slot *slot);
-static int disable_slot (struct hotplug_slot *slot);
-
-static struct hotplug_slot_ops dummy_hotplug_slot_ops = {
-	.owner			= THIS_MODULE,
-	.enable_slot		= enable_slot,
-	.disable_slot		= disable_slot,
-};
-
-static void dummy_release(struct hotplug_slot *slot)
-{
-	struct dummy_slot *dslot = slot->private;
-
-	list_del(&dslot->node);
-	kfree(dslot->slot->info);
-	kfree(dslot->slot);
-	pci_dev_put(dslot->dev);
-	kfree(dslot);
-}
-
-#define SLOT_NAME_SIZE	8
-
-static int add_slot(struct pci_dev *dev)
-{
-	struct dummy_slot *dslot;
-	struct hotplug_slot *slot;
-	char name[SLOT_NAME_SIZE];
-	int retval = -ENOMEM;
-	static int count = 1;
-
-	slot = kzalloc(sizeof(struct hotplug_slot), GFP_KERNEL);
-	if (!slot)
-		goto error;
-
-	slot->info = kzalloc(sizeof(struct hotplug_slot_info), GFP_KERNEL);
-	if (!slot->info)
-		goto error_slot;
-
-	slot->info->power_status = 1;
-	slot->info->max_bus_speed = PCI_SPEED_UNKNOWN;
-	slot->info->cur_bus_speed = PCI_SPEED_UNKNOWN;
-
-	dslot = kzalloc(sizeof(struct dummy_slot), GFP_KERNEL);
-	if (!dslot)
-		goto error_info;
-
-	if (dup_slots)
-		snprintf(name, SLOT_NAME_SIZE, "fake");
-	else
-		snprintf(name, SLOT_NAME_SIZE, "fake%d", count++);
-	dbg("slot->name = %s\n", name);
-	slot->ops = &dummy_hotplug_slot_ops;
-	slot->release = &dummy_release;
-	slot->private = dslot;
-
-	retval = pci_hp_register(slot, dev->bus, PCI_SLOT(dev->devfn), name);
-	if (retval) {
-		err("pci_hp_register failed with error %d\n", retval);
-		goto error_dslot;
-	}
-
-	dbg("slot->name = %s\n", hotplug_slot_name(slot));
-	dslot->slot = slot;
-	dslot->dev = pci_dev_get(dev);
-	list_add (&dslot->node, &slot_list);
-	return retval;
-
-error_dslot:
-	kfree(dslot);
-error_info:
-	kfree(slot->info);
-error_slot:
-	kfree(slot);
-error:
-	return retval;
-}
-
-static int __init pci_scan_buses(void)
-{
-	struct pci_dev *dev = NULL;
-	int lastslot = 0;
-
-	while ((dev = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, dev)) != NULL) {
-		if (PCI_FUNC(dev->devfn) > 0 &&
-				lastslot == PCI_SLOT(dev->devfn))
-			continue;
-		lastslot = PCI_SLOT(dev->devfn);
-		add_slot(dev);
-	}
-
-	return 0;
-}
-
-static void remove_slot(struct dummy_slot *dslot)
-{
-	int retval;
-
-	dbg("removing slot %s\n", hotplug_slot_name(dslot->slot));
-	retval = pci_hp_deregister(dslot->slot);
-	if (retval)
-		err("Problem unregistering a slot %s\n",
-			hotplug_slot_name(dslot->slot));
-}
-
-/* called from the single-threaded workqueue handler to remove a slot */
-static void remove_slot_worker(struct work_struct *work)
-{
-	struct dummy_slot *dslot =
-		container_of(work, struct dummy_slot, remove_work);
-	remove_slot(dslot);
-}
-
-/**
- * pci_rescan_slot - Rescan slot
- * @temp: Device template. Should be set: bus and devfn.
- *
- * Tries hard not to re-enable already existing devices;
- * also handles scanning of subfunctions.
- */
-static int pci_rescan_slot(struct pci_dev *temp)
-{
-	struct pci_bus *bus = temp->bus;
-	struct pci_dev *dev;
-	int func;
-	u8 hdr_type;
-	int count = 0;
-
-	if (!pci_read_config_byte(temp, PCI_HEADER_TYPE, &hdr_type)) {
-		temp->hdr_type = hdr_type & 0x7f;
-		if ((dev = pci_get_slot(bus, temp->devfn)) != NULL)
-			pci_dev_put(dev);
-		else {
-			dev = pci_scan_single_device(bus, temp->devfn);
-			if (dev) {
-				dbg("New device on %s function %x:%x\n",
-					bus->name, temp->devfn >> 3,
-					temp->devfn & 7);
-				count++;
-			}
-		}
-		/* multifunction device? */
-		if (!(hdr_type & 0x80))
-			return count;
-
-		/* continue scanning for other functions */
-		for (func = 1, temp->devfn++; func < 8; func++, temp->devfn++) {
-			if (pci_read_config_byte(temp, PCI_HEADER_TYPE, &hdr_type))
-				continue;
-			temp->hdr_type = hdr_type & 0x7f;
-
-			if ((dev = pci_get_slot(bus, temp->devfn)) != NULL)
-				pci_dev_put(dev);
-			else {
-				dev = pci_scan_single_device(bus, temp->devfn);
-				if (dev) {
-					dbg("New device on %s function %x:%x\n",
-						bus->name, temp->devfn >> 3,
-						temp->devfn & 7);
-					count++;
-				}
-			}
-		}
-	}
-
-	return count;
-}
-
-
-/**
- * pci_rescan_bus_local - fakephp version of rescan PCI bus
- * @bus: the PCI bus to rescan
- *
- * Call pci_rescan_slot for each possible function of the bus.
- */
-static void pci_rescan_bus_local(const struct pci_bus *bus)
-{
-	unsigned int devfn;
-	struct pci_dev *dev;
-	int retval;
-	int found = 0;
-	dev = alloc_pci_dev();
-	if (!dev)
-		return;
-
-	dev->bus = (struct pci_bus*)bus;
-	dev->sysdata = bus->sysdata;
-	for (devfn = 0; devfn < 0x100; devfn += 8) {
-		dev->devfn = devfn;
-		found += pci_rescan_slot(dev);
-	}
-
-	if (found) {
-		pci_bus_assign_resources(bus);
-		list_for_each_entry(dev, &bus->devices, bus_list) {
-			/* Skip already-added devices */
-			if (dev->is_added)
-					continue;
-			retval = pci_bus_add_device(dev);
-			if (retval)
-				dev_err(&dev->dev,
-					"Error adding device, continuing\n");
-			else
-				add_slot(dev);
-		}
-		pci_bus_add_devices(bus);
-	}
-	kfree(dev);
-}
-
-/* recursively scan all buses */
-static void pci_rescan_buses(const struct list_head *list)
-{
-	const struct list_head *l;
-	list_for_each(l,list) {
-		const struct pci_bus *b = pci_bus_b(l);
-		pci_rescan_bus_local(b);
-		pci_rescan_buses(&b->children);
-	}
-}
-
-/* initiate rescan of all pci buses */
-static inline void pci_rescan(void) {
-	pci_rescan_buses(&pci_root_buses);
-}
-
-/* called from the single-threaded workqueue handler to rescan all pci buses */
-static void pci_rescan_worker(struct work_struct *work)
-{
-	pci_rescan();
-}
-
-static int enable_slot(struct hotplug_slot *hotplug_slot)
-{
-	/* mis-use enable_slot for rescanning of the pci bus */
-	cancel_work_sync(&pci_rescan_work);
-	queue_work(dummyphp_wq, &pci_rescan_work);
-	return 0;
-}
-
-static int disable_slot(struct hotplug_slot *slot)
-{
-	struct dummy_slot *dslot;
-	struct pci_dev *dev;
-	int func;
-
-	if (!slot)
-		return -ENODEV;
-	dslot = slot->private;
-
-	dbg("%s - physical_slot = %s\n", __func__, hotplug_slot_name(slot));
-
-	for (func = 7; func >= 0; func--) {
-		dev = pci_get_slot(dslot->dev->bus, dslot->dev->devfn + func);
-		if (!dev)
-			continue;
-
-		if (test_and_set_bit(0, &dslot->removed)) {
-			dbg("Slot already scheduled for removal\n");
-			pci_dev_put(dev);
-			return -ENODEV;
-		}
-
-		/* remove the device from the pci core */
-		pci_remove_bus_device(dev);
-
-		/* queue work item to blow away this sysfs entry and other
-		 * parts.
-		 */
-		INIT_WORK(&dslot->remove_work, remove_slot_worker);
-		queue_work(dummyphp_wq, &dslot->remove_work);
-
-		pci_dev_put(dev);
-	}
-	return 0;
-}
-
-static void cleanup_slots (void)
-{
-	struct list_head *tmp;
-	struct list_head *next;
-	struct dummy_slot *dslot;
-
-	destroy_workqueue(dummyphp_wq);
-	list_for_each_safe (tmp, next, &slot_list) {
-		dslot = list_entry (tmp, struct dummy_slot, node);
-		remove_slot(dslot);
-	}
-	
-}
-
-static int __init dummyphp_init(void)
-{
-	info(DRIVER_DESC "\n");
-
-	dummyphp_wq = create_singlethread_workqueue(MY_NAME);
-	if (!dummyphp_wq)
-		return -ENOMEM;
-
-	return pci_scan_buses();
-}
-
-
-static void __exit dummyphp_exit(void)
-{
-	cleanup_slots();
-}
-
-module_init(dummyphp_init);
-module_exit(dummyphp_exit);
-
-MODULE_AUTHOR(DRIVER_AUTHOR);
-MODULE_DESCRIPTION(DRIVER_DESC);
-MODULE_LICENSE("GPL");
-module_param(debug, bool, S_IRUGO | S_IWUSR);
-MODULE_PARM_DESC(debug, "Debugging mode enabled or not");
-module_param(dup_slots, bool, S_IRUGO | S_IWUSR);
-MODULE_PARM_DESC(dup_slots, "Force duplicate slot names for debugging");
diff --git a/drivers/pci/hotplug/legacy_fakephp.c b/drivers/pci/hotplug/legacy_fakephp.c
new file mode 100644
index 0000000..2dc7828
--- /dev/null
+++ b/drivers/pci/hotplug/legacy_fakephp.c
@@ -0,0 +1,162 @@
+/* Works like the fakephp driver used to, except a little better.
+ *
+ * - It's possible to remove devices with subordinate busses.
+ * - New PCI devices that appear via any method, not just a fakephp triggered
+ *   rescan, will be noticed.
+ * - Devices that are removed via any method, not just a fakephp triggered
+ *   removal, will also be noticed.
+ *
+ * Uses nothing from the pci-hotplug subsystem.
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/types.h>
+#include <linux/list.h>
+#include <linux/kobject.h>
+#include <linux/sysfs.h>
+#include <linux/init.h>
+#include <linux/pci.h>
+#include "../pci.h"
+
+struct legacy_slot {
+	struct kobject		kobj;
+	struct pci_dev		*dev;
+	struct list_head	list;
+};
+
+static LIST_HEAD(legacy_list);
+
+static ssize_t legacy_show(struct kobject *kobj, struct attribute *attr,
+			   char *buf)
+{
+	struct legacy_slot *slot = container_of(kobj, typeof(*slot), kobj);
+	strcpy(buf, "1\n");
+	return 2;
+}
+
+static void remove_callback(void *data)
+{
+	pci_remove_bus_device((struct pci_dev *)data);
+}
+
+static ssize_t legacy_store(struct kobject *kobj, struct attribute *attr,
+			    const char *buf, size_t len)
+{
+	struct legacy_slot *slot = container_of(kobj, typeof(*slot), kobj);
+	unsigned long val;
+
+	if (strict_strtoul(buf, 0, &val) < 0)
+		return -EINVAL;
+
+	if (val)
+		pci_rescan_bus(slot->dev->bus);
+	else
+		sysfs_schedule_callback(&slot->dev->dev.kobj, remove_callback,
+					slot->dev, THIS_MODULE);
+	return len;
+}
+
+static struct attribute *legacy_attrs[] = {
+	&(struct attribute){ .name = "power", .mode = 0644 },
+	NULL,
+};
+
+static void legacy_release(struct kobject *kobj)
+{
+	struct legacy_slot *slot = container_of(kobj, typeof(*slot), kobj);
+
+	pci_dev_put(slot->dev);
+	kfree(slot);
+}
+
+static struct kobj_type legacy_ktype = {
+	.sysfs_ops = &(struct sysfs_ops){
+		.store = legacy_store, .show = legacy_show
+	},
+	.release = &legacy_release,
+	.default_attrs = legacy_attrs,
+};
+
+static int legacy_add_slot(struct pci_dev *pdev)
+{
+	struct legacy_slot *slot = kzalloc(sizeof(*slot), GFP_KERNEL);
+
+	if (!slot)
+		return -ENOMEM;
+
+	if (kobject_init_and_add(&slot->kobj, &legacy_ktype,
+				 &pci_slots_kset->kobj, "%s",
+				 pdev->dev.bus_id)) {
+		dev_warn(&pdev->dev, "Failed to created legacy fake slot\n");
+		return -EINVAL;
+	}
+	slot->dev = pci_dev_get(pdev);
+
+	list_add(&slot->list, &legacy_list);
+
+	return 0;
+}
+
+static int legacy_notify(struct notifier_block *nb,
+			 unsigned long action, void *data)
+{
+	struct pci_dev *pdev = to_pci_dev(data);
+
+	if (action == BUS_NOTIFY_ADD_DEVICE) {
+		legacy_add_slot(pdev);
+	} else if (action == BUS_NOTIFY_DEL_DEVICE) {
+		struct legacy_slot *slot;
+
+		list_for_each_entry(slot, &legacy_list, list)
+			if (slot->dev == pdev)
+				goto found;
+
+		dev_warn(&pdev->dev, "Missing legacy fake slot?");
+		return -ENODEV;
+found:
+		kobject_del(&slot->kobj);
+		list_del(&slot->list);
+		kobject_put(&slot->kobj);
+	}
+
+	return 0;
+}
+
+static struct notifier_block legacy_notifier = {
+	.notifier_call = legacy_notify
+};
+
+static int __init init_legacy(void)
+{
+	struct pci_dev *pdev = NULL;
+
+	/* Add existing devices */
+	while ((pdev = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, pdev)))
+		legacy_add_slot(pdev);
+
+	/* Be alerted of any new ones */
+	bus_register_notifier(&pci_bus_type, &legacy_notifier);
+	return 0;
+}
+module_init(init_legacy);
+
+static void __exit remove_legacy(void)
+{
+	struct legacy_slot *slot, *tmp;
+
+	bus_unregister_notifier(&pci_bus_type, &legacy_notifier);
+
+	list_for_each_entry_safe(slot, tmp, &legacy_list, list) {
+		list_del(&slot->list);
+		kobject_del(&slot->kobj);
+		kobject_put(&slot->kobj);
+	}
+}
+module_exit(remove_legacy);
+
+
+MODULE_AUTHOR("Trent Piepho <xyzzy@speakeasy.org>");
+MODULE_DESCRIPTION("Legacy version of the fakephp interface");
+MODULE_LICENSE("GPL");

