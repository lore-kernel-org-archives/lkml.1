Return-Path: <linux-kernel-owner+w=401wt.eu-S1759829AbYAKLml@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759829AbYAKLml (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 06:42:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756823AbYAKLmd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 06:42:33 -0500
Received: from mail.mev.co.uk ([62.49.15.74]:36893 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755107AbYAKLmb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 06:42:31 -0500
Message-ID: <4787561F.6090100@mev.co.uk>
Date: Fri, 11 Jan 2008 11:42:23 +0000
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Thunderbird 2.0.0.9 (X11/20071116)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       pcihpd-discuss@lists.sourceforge.net, gregkh@suse.de,
       kristen.c.accardi@intel.com
Subject: [PATCH] Fix fakephp deadlock
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 11 Jan 2008 11:42:24.0756 (UTC) FILETIME=[08D3AB40:01C85447]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian Abbott <abbotti@mev.co.uk>

If the fakephp driver is used to emulate removal of a PCI device by
writing text string "0" to the "power" sysfs attribute file, this causes
its parent directory and its contents (including the "power" file) to be
deleted before the write operation returns.  Unfortunately, it ends up
in a deadlock waiting for itself to complete.

The deadlock is as follows: sysfs_write_file calls flush_write_buffer
which calls sysfs_get_active_two before calling power_write_file in
pci_hotplug_core.c via the sysfs store operation. The power_write_file
function calls disable_slot in fakephp.c via the slot operation.  The
disable_slot function calls remove_slot which calls pci_hp_deregister
(back in pci_hotplug_core.c) which calls fs_remove_slot which calls
sysfs_remove_file to remove the "power" file. The sysfs_remove_file
function calls sysfs_hash_and_remove which calls sysfs_addrm_finish
which calls sysfs_deactivate. The sysfs_deactivate function sees that
something has an active reference on the sysfs_dirent (from the
previous call to sysfs_get_active_two back up the call stack somewhere)
so waits for the active reference to go away, which is of course
impossible.

The problem has been present since 2.6.21.

This patch breaks the deadlock by queuing a work queue item on a single-
threaded workqueue to do the removal from sysfs.  There is also some
protection against performing store operations on the "power" file of a
slot that has already been disabled.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---

--- linux-2.6.24-rc7/drivers/pci/hotplug/fakephp.c.orig	2008-01-03 16:50:05.000000000 +0000
+++ linux-2.6.24-rc7/drivers/pci/hotplug/fakephp.c	2008-01-10 17:20:58.000000000 +0000
@@ -39,6 +39,7 @@
 #include <linux/init.h>
 #include <linux/string.h>
 #include <linux/slab.h>
+#include <linux/workqueue.h>
 #include "../pci.h"
 
 #if !defined(MODULE)
@@ -63,10 +64,13 @@
 	struct list_head node;
 	struct hotplug_slot *slot;
 	struct pci_dev *dev;
+	struct work_struct remove_work;
+	unsigned long removed;
 };
 
 static int debug;
 static LIST_HEAD(slot_list);
+static struct workqueue_struct *dummyphp_wq;
 
 static int enable_slot (struct hotplug_slot *slot);
 static int disable_slot (struct hotplug_slot *slot);
@@ -109,7 +113,7 @@
 	slot->name = &dev->dev.bus_id[0];
 	dbg("slot->name = %s\n", slot->name);
 
-	dslot = kmalloc(sizeof(struct dummy_slot), GFP_KERNEL);
+	dslot = kzalloc(sizeof(struct dummy_slot), GFP_KERNEL);
 	if (!dslot)
 		goto error_info;
 
@@ -164,6 +168,13 @@
 		err("Problem unregistering a slot %s\n", dslot->slot->name);
 }
 
+static void remove_slot_worker(struct work_struct *work)
+{
+	struct dummy_slot *dslot =
+		container_of(work, struct dummy_slot, remove_work);
+	remove_slot(dslot);
+}
+
 /**
  * pci_rescan_slot - Rescan slot
  * @temp: Device template. Should be set: bus and devfn.
@@ -271,6 +282,20 @@
 static int enable_slot(struct hotplug_slot *hotplug_slot)
 {
 	/* mis-use enable_slot for rescanning of the pci bus */
+	struct dummy_slot *dslot;
+
+	if (hotplug_slot) {
+		/* make sure slot is not scheduled for removal
+		 * otherwise flush_workqueue() could deadlock */
+		dslot = hotplug_slot->private;
+		if (test_bit(0, &dslot->removed)) {
+			/* FIXME: -ENODEV is also returned when function
+			 * succeeds. */
+			return -ENODEV;
+		}
+	}
+	/* first, complete any pending removals */
+	flush_workqueue(dummyphp_wq);
 	pci_rescan();
 	return -ENODEV;
 }
@@ -306,6 +331,10 @@
 		err("Can't remove PCI devices with other PCI devices behind it yet.\n");
 		return -ENODEV;
 	}
+	if (test_and_set_bit(0, &dslot->removed)) {
+		dbg("Slot already scheduled for removal\n");
+		return -ENODEV;
+	}
 	/* search for subfunctions and disable them first */
 	if (!(dslot->dev->devfn & 7)) {
 		for (func = 1; func < 8; func++) {
@@ -328,8 +357,9 @@
 	/* remove the device from the pci core */
 	pci_remove_bus_device(dslot->dev);
 
-	/* blow away this sysfs entry and other parts. */
-	remove_slot(dslot);
+	/* queue work item to blow away this sysfs entry and other parts. */
+	INIT_WORK(&dslot->remove_work, remove_slot_worker);
+	queue_work(dummyphp_wq, &dslot->remove_work);
 
 	return 0;
 }
@@ -340,6 +370,7 @@
 	struct list_head *next;
 	struct dummy_slot *dslot;
 
+	destroy_workqueue(dummyphp_wq);
 	list_for_each_safe (tmp, next, &slot_list) {
 		dslot = list_entry (tmp, struct dummy_slot, node);
 		remove_slot(dslot);
@@ -351,6 +382,10 @@
 {
 	info(DRIVER_DESC "\n");
 
+	dummyphp_wq = create_singlethread_workqueue(MY_NAME);
+	if (!dummyphp_wq)
+		return -ENOMEM;
+
 	return pci_scan_buses();
 }


---
Note that the return values from the enable_slot function needs some
attention.  The patch causes this to return -ENODEV if the slot has
already been disabled, but that is also the normal return value of the
function.  The return values should be different.  Is there any reason
why the normal return value can't be 0?

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-

