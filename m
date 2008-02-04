Return-Path: <linux-kernel-owner+w=401wt.eu-S1754697AbYBDOlh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754697AbYBDOlh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 09:41:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750911AbYBDOl3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 09:41:29 -0500
Received: from mail.mev.co.uk ([62.49.15.74]:51592 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750896AbYBDOl3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 09:41:29 -0500
Message-ID: <47A723FB.4050009@mev.co.uk>
Date: Mon, 04 Feb 2008 14:40:59 +0000
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Thunderbird 2.0.0.9 (X11/20071116)
MIME-Version: 1.0
To: stable@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz
Subject: [PATCH 2.6.21.stable] PCI: Fix fakephp deadlock
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 04 Feb 2008 14:40:59.0594 (UTC) FILETIME=[F54832A0:01C8673B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian Abbott <abbotti@mev.co.uk>

Stable request for 2.6.21.

This patch works around a problem in the fakephp driver when a process
writing "0" to a "power" sysfs file to fake removal of a PCI device ends
up deadlocking itself in the sysfs code.

This patch is *not* functionally identical to the one in Linus' post
2.6.24 git tree, so requires more careful review.  The differences are
the addition of a call to flush_workqueue() in disable_slot() just before
queueing the work item to remove the sysfs files, and the removal of a
call to cancel_work_sync() in enable_slot() as this function does not
exist in this kernel version.  Consider the case of a call to enable_slot(),
followed by a call to disable_slot(), followed by another call to
enable_slot().  If the work queue were not flushed in disable_slot(), the
second call to enable_slot() could be ineffective due to the pci_rescan_work
work item being on the queue already.  Of course, the results of calling
enable_slot() and disable_slot() *simultaneously* is still undefined, but
that has always been true for this driver.

The call to flush_workqueue() cannot be moved to enable_slot() easily as it
could deadlock if some other task disabled the slot - it would need a
global mutex in the driver to prevent this but the recursion in disable_slot()
would add further complication (to be avoided in the stable trees).

One alternative to calling flush_workqueue() in disable_slot() would be to
allocate pci_rescan_work dynamically in enable_slot() (I did that in an earlier
version of the patch).

I have tested the patch on a 2.6.21 kernel.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
--- linux-2.6.21/drivers/pci/hotplug/fakephp.c.orig	2007-04-26 04:08:32.000000000 +0100
+++ linux-2.6.21/drivers/pci/hotplug/fakephp.c	2008-02-04 12:46:59.000000000 +0000
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
  * Rescan slot.
  * Tries hard not to re-enable already existing devices
@@ -267,11 +282,16 @@ static inline void pci_rescan(void) {
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
+	queue_work(dummyphp_wq, &pci_rescan_work);
 	return -ENODEV;
 }
 
@@ -306,6 +326,10 @@ static int disable_slot(struct hotplug_s
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
@@ -328,8 +352,12 @@ static int disable_slot(struct hotplug_s
 	/* remove the device from the pci core */
 	pci_remove_bus_device(dslot->dev);
 
-	/* blow away this sysfs entry and other parts. */
-	remove_slot(dslot);
+	/* run earlier work queue items */
+	flush_workqueue(dummyphp_wq);
+
+	/* queue work item to blow away this sysfs entry and other parts. */
+	INIT_WORK(&dslot->remove_work, remove_slot_worker);
+	queue_work(dummyphp_wq, &dslot->remove_work);
 
 	return 0;
 }
@@ -340,6 +368,7 @@ static void cleanup_slots (void)
 	struct list_head *next;
 	struct dummy_slot *dslot;
 
+	destroy_workqueue(dummyphp_wq);
 	list_for_each_safe (tmp, next, &slot_list) {
 		dslot = list_entry (tmp, struct dummy_slot, node);
 		remove_slot(dslot);
@@ -351,6 +380,10 @@ static int __init dummyphp_init(void)
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

