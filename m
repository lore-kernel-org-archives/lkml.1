Return-Path: <linux-kernel-owner+w=401wt.eu-S1755013AbYAYQYS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755013AbYAYQYS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 11:24:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752482AbYAYQYJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 11:24:09 -0500
Received: from mail.mev.co.uk ([62.49.15.74]:50059 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752744AbYAYQYI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 11:24:08 -0500
Message-ID: <479A0D1C.8080401@mev.co.uk>
Date: Fri, 25 Jan 2008 16:23:56 +0000
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Thunderbird 2.0.0.9 (X11/20071116)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       pcihpd-discuss@lists.sourceforge.net, gregkh@suse.de,
       kristen.c.accardi@intel.com
Subject: [PATCH(v3) 2.6.24] Fix fakephp deadlock
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 25 Jan 2008 16:23:56.0552 (UTC) FILETIME=[AEE7B080:01C85F6E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian Abbott <abbotti@mev.co.uk>

This is the third version of my patch to fix the problem of a process
deadlocking itself when it uses the fakephp driver to fake the removal
of a PCI device.

This section describes the changes since the first version of the
patch.  Skip to the next section (after the "---") for the original
rationale and (slightly modified) patch description, and for the patch
itself.

Greg KH hinted at a race condition in the first version of the patch.
In the first version, the enable_slot() function checked that the slot
was still valid and then flushed the work queue to perform any pending
removals of slots from sysfs before it finally rescanned the PCI buses.
Another task could have come in and marked the slot as disabled after
the validity check but before flushing the work queue, and this would
cause the task to deadlock while flushing the work queue (for similar
reasons to the problem I was initially trying to fix).  (The sysfs
attribute file's buffer semaphore wouldn't necessarily protect against
that, because writing "0" to the "power" file can trigger a cascade of
other slot removals that don't have that protection.)

The second version of the patch rewrote the enable_slot() function so
it no longer flushes the work queue.  To maintain the proper sequencing,
it allocated and queued a work queue item to perform the PCI rescan (the
work queue is single-threaded).  I also removed the slot validity check
as we don't really care which slot was used to trigger a rescan.

This third version of the patch uses a single statically allocated work
queue item to perform the PCI rescan instead of allocating one
dynamically in the enable_slot() function.  When enable_slot() is
called, it first cancels any queued PCI rescan work item and then
requeues it.  This means a previously scheduled PCI rescan may be
skipped, but that shouldn't matter.  The important thing is that the
new PCI rescan is performed after any previously scheduled removals
of PCI slots from sysfs.

Greg KH also seemed to have a problem with my use of unsigned long for
the 'removed' member of 'struct dummy_slot'.  I need that for the
test_and_set_bit() and a narrower type wouldn't make 'struct dummy_slot'
any smaller (and there are other ways to save space in 'struct
dummy_slot' if it is a problem, but they make the code trickier).

On with the rationale and patch description....

---
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

This patch breaks the deadlock by queuing work queue items on a single-
threaded work queue to remove a slot from sysfs, and to rescan the PCI
buses.  There is also some protection against disabling a slot that is
already being removed.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---

--- linux-2.6.24/drivers/pci/hotplug/fakephp.c.orig	2008-01-24 22:58:37.000000000 +0000
+++ linux-2.6.24/drivers/pci/hotplug/fakephp.c	2008-01-25 15:58:21.000000000 +0000
@@ -39,6 +39,7 @@
 #include <linux/init.h>
 #include <linux/string.h>
 #include <linux/slab.h>
+#include <linux/workqueue.h>
 #include "../pci.h"

 #if !defined(MODULE)
@@ -63,10 +64,16 @@ struct dummy_slot {
 	struct list_head node;
 	struct hotplug_slot *slot;
 	struct pci_dev *dev;
+	struct work_struct remove_work;
+	unsigned long removed;
 };

 static int debug;
 static LIST_HEAD(slot_list);
+static struct workqueue_struct *dummyphp_wq;
+
+static void pci_rescan_worker(struct work_struct *work);
+static DECLARE_WORK(pci_rescan_work, pci_rescan_worker);

 static int enable_slot (struct hotplug_slot *slot);
 static int disable_slot (struct hotplug_slot *slot);
@@ -109,7 +116,7 @@ static int add_slot(struct pci_dev *dev)
 	slot->name = &dev->dev.bus_id[0];
 	dbg("slot->name = %s\n", slot->name);

-	dslot = kmalloc(sizeof(struct dummy_slot), GFP_KERNEL);
+	dslot = kzalloc(sizeof(struct dummy_slot), GFP_KERNEL);
 	if (!dslot)
 		goto error_info;

@@ -164,6 +171,14 @@ static void remove_slot(struct dummy_slo
 		err("Problem unregistering a slot %s\n", dslot->slot->name);
 }

+/* called from the single-threaded workqueue handler to remove a slot */
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
@@ -267,11 +282,17 @@ static inline void pci_rescan(void) {
 	pci_rescan_buses(&pci_root_buses);
 }

+/* called from the single-threaded workqueue handler to rescan all pci buses */
+static void pci_rescan_worker(struct work_struct *work)
+{
+	pci_rescan();
+}

 static int enable_slot(struct hotplug_slot *hotplug_slot)
 {
 	/* mis-use enable_slot for rescanning of the pci bus */
-	pci_rescan();
+	cancel_work_sync(&pci_rescan_work);
+	queue_work(dummyphp_wq, &pci_rescan_work);
 	return -ENODEV;
 }

@@ -306,6 +327,10 @@ static int disable_slot(struct hotplug_s
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
@@ -328,8 +353,9 @@ static int disable_slot(struct hotplug_s
 	/* remove the device from the pci core */
 	pci_remove_bus_device(dslot->dev);

-	/* blow away this sysfs entry and other parts. */
-	remove_slot(dslot);
+	/* queue work item to blow away this sysfs entry and other parts. */
+	INIT_WORK(&dslot->remove_work, remove_slot_worker);
+	queue_work(dummyphp_wq, &dslot->remove_work);

 	return 0;
 }
@@ -340,6 +366,7 @@ static void cleanup_slots (void)
 	struct list_head *next;
 	struct dummy_slot *dslot;

+	destroy_workqueue(dummyphp_wq);
 	list_for_each_safe (tmp, next, &slot_list) {
 		dslot = list_entry (tmp, struct dummy_slot, node);
 		remove_slot(dslot);
@@ -351,6 +378,10 @@ static int __init dummyphp_init(void)
 {
 	info(DRIVER_DESC "\n");

+	dummyphp_wq = create_singlethread_workqueue(MY_NAME);
+	if (!dummyphp_wq)
+		return -ENOMEM;
+
 	return pci_scan_buses();
 }


-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-
