Return-Path: <linux-kernel-owner+w=401wt.eu-S1758498AbYBDNtp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758498AbYBDNtp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 08:49:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756330AbYBDNnZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 08:43:25 -0500
Received: from mail.mev.co.uk ([62.49.15.74]:51433 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756288AbYBDNnV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 08:43:21 -0500
Message-ID: <47A71671.7080306@mev.co.uk>
Date: Mon, 04 Feb 2008 13:43:13 +0000
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Thunderbird 2.0.0.9 (X11/20071116)
MIME-Version: 1.0
To: stable@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz
Subject: [PATCH 2.6.24.stable] PCI:  Fix fakephp deadlock
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 04 Feb 2008 13:43:13.0581 (UTC) FILETIME=[E36095D0:01C86733]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian Abbott <abbotti@mev.co.uk>

Stable request for 2.6.24.

This patch works around a problem in the fakephp driver when a process
writing "0" to a "power" sysfs file to fake removal of a PCI device ends
up deadlocking itself in the sysfs code.

The patch was recently accepted into Linus' tree after the 2.6.24 release:
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=5c796ae7a7ebe56967ed9b9963d7c16d733635ff

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

