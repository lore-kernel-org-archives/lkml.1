Return-Path: <linux-kernel-owner+w=401wt.eu-S1763363AbYFEDHk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763363AbYFEDHk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 23:07:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750769AbYFEDHc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 23:07:32 -0400
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:47831 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750743AbYFEDHb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 23:07:31 -0400
Date: Wed, 4 Jun 2008 21:07:28 -0600
From: Alex Chiang <achiang@hp.com>
To: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Cc: jbarnes@virtuousgeek.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Matthew Wilcox <matthew@wil.cx>,
       Andrew Morton <akpm@linux-foundation.org>, kristen.c.accardi@intel.com,
       greg@kroah.com, lenb@kernel.org, pbadari@us.ibm.com,
       linux-pci@vger.kernel.org, pcihpd-discuss@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4, v14] PCI, ACPI: Physical PCI slot objects
Message-ID: <20080605030728.GA11528@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>,
	Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
	jbarnes@virtuousgeek.org,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	Matthew Wilcox <matthew@wil.cx>,
	Andrew Morton <akpm@linux-foundation.org>,
	kristen.c.accardi@intel.com, greg@kroah.com, lenb@kernel.org,
	pbadari@us.ibm.com, linux-pci@vger.kernel.org,
	pcihpd-discuss@lists.sourceforge.net, linux-kernel@vger.kernel.org
References: <20080604200829.GC379@ldl.fc.hp.com> <48475056.6040300@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48475056.6040300@jp.fujitsu.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kenji-san,

* Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>:
>
> I tried to test your patch using latest linux-next, but I could
> not apply your patch with the following messages:

Sorry, that latest patch series was against Linus' tree, not
linux-next.

> I think maybe your patch is conflicting with the following patch.
>
> commit 372fa8fa0a77c47c7bcfae0ccd14e0c5f97d17fe
> Author: Kay Sievers <kay.sievers@vrfy.org>
> Date:   Fri May 2 06:02:41 2008 +0200
>
>    driver-core: prepare for removal of 20 char limit from struct device
>
>    The access of struct device->bus_id is replaced by dev_name(), to
>    be able to use the non-limited kobject name after the conversion
>    of the device register callers.

Yes, thanks for pointing this out. I've fixed patch 1/4.

I verified that patches 2, 3 and 4 apply cleanly against
linux-next, so this should be the only fix you'll need.

Sorry for the confusion.

/ac

commit c0175afea14cdaff3c33d894eb474eed1dcfa65d
Author: Alex Chiang <achiang@hp.com>
Date:   Wed Jun 4 21:04:46 2008 -0600

    Construct one fakephp slot per PCI slot
    
    Register one slot per slot, rather than one slot per function.  Change the
    name of the slot to fake%d instead of the pci address.
    
    Signed-off-by: Alex Chiang <achiang@hp.com>
    Signed-off-by: Matthew Wilcox <matthew@wil.cx>
    Cc: Greg KH <greg@kroah.com>
    Cc: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
    Cc: Len Brown <lenb@kernel.org>
    Cc: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

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
 
