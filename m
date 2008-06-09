Return-Path: <linux-kernel-owner+w=401wt.eu-S1760829AbYFIW1g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760829AbYFIW1g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 18:27:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760871AbYFIWYv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 18:24:51 -0400
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:42873 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760848AbYFIWYs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 18:24:48 -0400
Date: Mon, 9 Jun 2008 16:24:46 -0600
From: Alex Chiang <achiang@hp.com>
To: jbarnes@virtuousgeek.org, Andrew Morton <akpm@linux-foundation.org>,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Matthew Wilcox <matthew@wil.cx>, kristen.c.accardi@intel.com,
       greg@kroah.com, lenb@kernel.org, pbadari@us.ibm.com,
       linux-pci@vger.kernel.org, pcihpd-discuss@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] Construct one fakephp slot per PCI slot
Message-ID: <20080609222446.GC16588@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>, jbarnes@virtuousgeek.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	Matthew Wilcox <matthew@wil.cx>, kristen.c.accardi@intel.com,
	greg@kroah.com, lenb@kernel.org, pbadari@us.ibm.com,
	linux-pci@vger.kernel.org, pcihpd-discuss@lists.sourceforge.net,
	linux-kernel@vger.kernel.org
References: <20080609222202.GB16588@ldl.fc.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080609222202.GB16588@ldl.fc.hp.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Register one slot per slot, rather than one slot per function.  Change the
name of the slot to fake%d instead of the pci address.

Signed-off-by: Alex Chiang <achiang@hp.com>
Signed-off-by: Matthew Wilcox <matthew@wil.cx>
Cc: Greg KH <greg@kroah.com>
Cc: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Cc: Len Brown <lenb@kernel.org>
Cc: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---
 drivers/pci/hotplug/fakephp.c |   90 ++++++++++++++---------------------------
 1 files changed, 30 insertions(+), 60 deletions(-)

diff --git a/drivers/pci/hotplug/fakephp.c b/drivers/pci/hotplug/fakephp.c
index d3393f4..e066959 100644
--- a/drivers/pci/hotplug/fakephp.c
+++ b/drivers/pci/hotplug/fakephp.c
@@ -66,6 +66,7 @@ struct dummy_slot {
 	struct pci_dev *dev;
 	struct work_struct remove_work;
 	unsigned long removed;
+	char name[8];
 };
 
 static int debug;
@@ -101,6 +102,7 @@ static int add_slot(struct pci_dev *dev)
 	struct dummy_slot *dslot;
 	struct hotplug_slot *slot;
 	int retval = -ENOMEM;
+	static int count = 1;
 
 	slot = kzalloc(sizeof(struct hotplug_slot), GFP_KERNEL);
 	if (!slot)
@@ -114,15 +116,13 @@ static int add_slot(struct pci_dev *dev)
 	slot->info->max_bus_speed = PCI_SPEED_UNKNOWN;
 	slot->info->cur_bus_speed = PCI_SPEED_UNKNOWN;
 
-	slot->name = kstrdup(dev_name(&dev->dev), GFP_KERNEL);
-	if (!slot->name)
-		goto error_info;
-	dbg("slot->name = %s\n", slot->name);
-
 	dslot = kzalloc(sizeof(struct dummy_slot), GFP_KERNEL);
 	if (!dslot)
-		goto error_name;
+		goto error_info;
 
+	slot->name = dslot->name;
+	snprintf(slot->name, sizeof(dslot->name), "fake%d", count++);
+	dbg("slot->name = %s\n", slot->name);
 	slot->ops = &dummy_hotplug_slot_ops;
 	slot->release = &dummy_release;
 	slot->private = dslot;
@@ -140,8 +140,6 @@ static int add_slot(struct pci_dev *dev)
 
 error_dslot:
 	kfree(dslot);
-error_name:
-	kfree(slot->name);
 error_info:
 	kfree(slot->info);
 error_slot:
@@ -153,17 +151,17 @@ error:
 static int __init pci_scan_buses(void)
 {
 	struct pci_dev *dev = NULL;
-	int retval = 0;
+	int lastslot = 0;
 
 	while ((dev = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, dev)) != NULL) {
-		retval = add_slot(dev);
-		if (retval) {
-			pci_dev_put(dev);
-			break;
-		}
+		if (PCI_FUNC(dev->devfn) > 0 &&
+				lastslot == PCI_SLOT(dev->devfn))
+			continue;
+		lastslot = PCI_SLOT(dev->devfn);
+		add_slot(dev);
 	}
 
-	return retval;
+	return 0;
 }
 
 static void remove_slot(struct dummy_slot *dslot)
@@ -301,23 +299,9 @@ static int enable_slot(struct hotplug_slot *hotplug_slot)
 	return 0;
 }
 
-/* find the hotplug_slot for the pci_dev */
-static struct hotplug_slot *get_slot_from_dev(struct pci_dev *dev)
-{
-	struct dummy_slot *dslot;
-
-	list_for_each_entry(dslot, &slot_list, node) {
-		if (dslot->dev == dev)
-			return dslot->slot;
-	}
-	return NULL;
-}
-
-
 static int disable_slot(struct hotplug_slot *slot)
 {
 	struct dummy_slot *dslot;
-	struct hotplug_slot *hslot;
 	struct pci_dev *dev;
 	int func;
 
@@ -327,41 +311,27 @@ static int disable_slot(struct hotplug_slot *slot)
 
 	dbg("%s - physical_slot = %s\n", __func__, slot->name);
 
-	/* don't disable bridged devices just yet, we can't handle them easily... */
-	if (dslot->dev->subordinate) {
-		err("Can't remove PCI devices with other PCI devices behind it yet.\n");
-		return -ENODEV;
-	}
-	if (test_and_set_bit(0, &dslot->removed)) {
-		dbg("Slot already scheduled for removal\n");
-		return -ENODEV;
-	}
-	/* search for subfunctions and disable them first */
-	if (!(dslot->dev->devfn & 7)) {
-		for (func = 1; func < 8; func++) {
-			dev = pci_get_slot(dslot->dev->bus,
-					dslot->dev->devfn + func);
-			if (dev) {
-				hslot = get_slot_from_dev(dev);
-				if (hslot)
-					disable_slot(hslot);
-				else {
-					err("Hotplug slot not found for subfunction of PCI device\n");
-					return -ENODEV;
-				}
-				pci_dev_put(dev);
-			} else
-				dbg("No device in slot found\n");
+	for (func = 7; func >= 0; func--) {
+		dev = pci_get_slot(dslot->dev->bus, dslot->dev->devfn + func);
+		if (!dev)
+			continue;
+
+		if (test_and_set_bit(0, &dslot->removed)) {
+			dbg("Slot already scheduled for removal\n");
+			return -ENODEV;
 		}
-	}
 
-	/* remove the device from the pci core */
-	pci_remove_bus_device(dslot->dev);
+		/* queue work item to blow away this sysfs entry and other
+		 * parts.
+		 */
+		INIT_WORK(&dslot->remove_work, remove_slot_worker);
+		queue_work(dummyphp_wq, &dslot->remove_work);
 
-	/* queue work item to blow away this sysfs entry and other parts. */
-	INIT_WORK(&dslot->remove_work, remove_slot_worker);
-	queue_work(dummyphp_wq, &dslot->remove_work);
+		/* blow away this sysfs entry and other parts. */
+		remove_slot(dslot);
 
+		pci_dev_put(dev);
+	}
 	return 0;
 }
 
-- 
1.5.3.1.1.g1e61

