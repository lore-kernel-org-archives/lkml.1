Return-Path: <linux-kernel-owner+w=401wt.eu-S933530AbYBVVox@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933530AbYBVVox (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 16:44:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933382AbYBVVnH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 16:43:07 -0500
Received: from mx2.suse.de ([195.135.220.15]:60350 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933322AbYBVVnE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 16:43:04 -0500
Date: Fri, 22 Feb 2008 13:40:12 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Ian Abbott <abbotti@mev.co.uk>
Subject: [patch 04/23] PCI: Fix fakephp deadlock
Message-ID: <20080222214012.GE8686@suse.de>
References: <20080222213114.583282464@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="pci-fix-fakephp-deadlock.patch"
In-Reply-To: <20080222213927.GA8686@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.22-stable review patch.  If anyone has any objections, please let us
know.

------------------

From: Ian Abbott <abbotti@mev.co.uk>

This patch works around a problem in the fakephp driver when a process
writing "0" to a "power" sysfs file to fake removal of a PCI device ends
up deadlocking itself in the sysfs code.

The patch is functionally identical to the one in Linus' tree post 2.6.24:
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=5c796ae7a7ebe56967ed9b9963d7c16d733635ff

I have tested it on a 2.6.22 kernel.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/pci/hotplug/fakephp.c |   39 +++++++++++++++++++++++++++++++++++----
 1 file changed, 35 insertions(+), 4 deletions(-)

--- a/drivers/pci/hotplug/fakephp.c
+++ b/drivers/pci/hotplug/fakephp.c
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
