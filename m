Return-Path: <linux-kernel-owner+w=401wt.eu-S1764824AbXKNVEX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764824AbXKNVEX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 16:04:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755252AbXKNVEI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 16:04:08 -0500
Received: from palrel11.hp.com ([156.153.255.246]:35165 "EHLO palrel11.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754857AbXKNVEG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 16:04:06 -0500
Date: Wed, 14 Nov 2007 14:04:04 -0700
From: Alex Chiang <achiang@hp.com>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Gary Hade <garyhade@us.ibm.com>, Greg KH <greg@kroah.com>, gregkh@suse.de,
       kristen.c.accardi@intel.com, lenb@kernel.org, rick.jones2@hp.com,
       linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       kaneshige.kenji@jp.fujitsu.com, pcihpd-discuss@lists.sourceforge.net,
       linux-acpi@vger.kernel.org
Subject: Re: [PATCH 2/5] Construct one fakephp slot per pci slot
Message-ID: <20071114210404.GA6575@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>,
	Matthew Wilcox <matthew@wil.cx>, Gary Hade <garyhade@us.ibm.com>,
	Greg KH <greg@kroah.com>, gregkh@suse.de,
	kristen.c.accardi@intel.com, lenb@kernel.org, rick.jones2@hp.com,
	linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
	kaneshige.kenji@jp.fujitsu.com, pcihpd-discuss@lists.sourceforge.net,
	linux-acpi@vger.kernel.org
References: <20071114193605.GA25002@ldl.fc.hp.com> <20071114193729.GC25002@ldl.fc.hp.com> <20071114201246.GZ17785@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071114201246.GZ17785@parisc-linux.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Matthew Wilcox <matthew@wil.cx>:
> On Wed, Nov 14, 2007 at 12:37:29PM -0700, Alex Chiang wrote:
> > Register one slot per slot, rather than one slot per function.
> > Change the name of the slot to fake%d instead of the pci address.
> 
> > +#define SLOT_NAME_SIZE KOBJ_NAME_LEN
> 
> Defined, then never used ... how about s/KOBJ_NAME_LEN/8/, then use
> SLOT_NAME_SIZE throughout?

Here's another try with your suggestion.

From: Alex Chiang <achiang@hp.com>

Register one slot per slot, rather than one slot per function.
Change the name of the slot to fake%d instead of the pci address.

Signed-off-by: Alex Chiang <achiang@hp.com>
Signed-off-by: Matthew Wilcox <matthew@wil.cx>
---
 drivers/pci/hotplug/fakephp.c |   82 ++++++++++++++++-------------------------
 1 files changed, 32 insertions(+), 50 deletions(-)

diff --git a/drivers/pci/hotplug/fakephp.c b/drivers/pci/hotplug/fakephp.c
index 027f686..1759ea1 100644
--- a/drivers/pci/hotplug/fakephp.c
+++ b/drivers/pci/hotplug/fakephp.c
@@ -59,10 +59,13 @@
 #define DRIVER_AUTHOR	"Greg Kroah-Hartman <greg@kroah.com>"
 #define DRIVER_DESC	"Fake PCI Hot Plug Controller Driver"
 
+#define SLOT_NAME_SIZE 8
+
 struct dummy_slot {
 	struct list_head node;
 	struct hotplug_slot *slot;
 	struct pci_dev *dev;
+	char name[SLOT_NAME_SIZE];
 };
 
 static int debug;
@@ -93,6 +96,7 @@ static int add_slot(struct pci_dev *dev)
 	struct dummy_slot *dslot;
 	struct hotplug_slot *slot;
 	int retval = -ENOMEM;
+	static int count = 1;
 
 	slot = kzalloc(sizeof(struct hotplug_slot), GFP_KERNEL);
 	if (!slot)
@@ -106,13 +110,14 @@ static int add_slot(struct pci_dev *dev)
 	slot->info->max_bus_speed = PCI_SPEED_UNKNOWN;
 	slot->info->cur_bus_speed = PCI_SPEED_UNKNOWN;
 
-	slot->name = &dev->dev.bus_id[0];
-	dbg("slot->name = %s\n", slot->name);
-
 	dslot = kmalloc(sizeof(struct dummy_slot), GFP_KERNEL);
 	if (!dslot)
 		goto error_info;
 
+	slot->name = dslot->name;
+	snprintf(slot->name, SLOT_NAME_SIZE, "fake%d", count++);
+	dbg("slot->name = %s\n", slot->name);
+
 	slot->ops = &dummy_hotplug_slot_ops;
 	slot->release = &dummy_release;
 	slot->private = dslot;
@@ -141,17 +146,17 @@ error:
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
@@ -275,23 +280,9 @@ static int enable_slot(struct hotplug_slot *hotplug_slot)
 	return -ENODEV;
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
 
@@ -301,36 +292,27 @@ static int disable_slot(struct hotplug_slot *slot)
 
 	dbg("%s - physical_slot = %s\n", __FUNCTION__, slot->name);
 
-	/* don't disable bridged devices just yet, we can't handle them easily... */
-	if (dslot->dev->subordinate) {
-		err("Can't remove PCI devices with other PCI devices behind it yet.\n");
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
+		/* don't disable bridged devices just yet, we can't handle
+		 * them easily... */
+		if (dev->subordinate) {
+			err("Can't remove PCI devices with other PCI devices behind it yet.\n");
+			return -ENODEV;
 		}
-	}
 
-	/* remove the device from the pci core */
-	pci_remove_bus_device(dslot->dev);
 
-	/* blow away this sysfs entry and other parts. */
-	remove_slot(dslot);
+		/* remove the device from the pci core */
+		pci_remove_bus_device(dslot->dev);
 
+		/* blow away this sysfs entry and other parts. */
+		remove_slot(dslot);
+
+		pci_dev_put(dev);
+	}
 	return 0;
 }
 
-- 
1.5.3.1.1.g1e61

