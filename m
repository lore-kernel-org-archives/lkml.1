Return-Path: <linux-kernel-owner+w=401wt.eu-S1763650AbXKNTi5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763650AbXKNTi5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 14:38:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764197AbXKNTik
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 14:38:40 -0500
Received: from palrel13.hp.com ([156.153.255.238]:42156 "EHLO palrel13.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762572AbXKNTii (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 14:38:38 -0500
Date: Wed, 14 Nov 2007 12:38:36 -0700
From: Alex Chiang <achiang@hp.com>
To: Gary Hade <garyhade@us.ibm.com>, Matthew Wilcox <matthew@wil.cx>,
       Greg KH <greg@kroah.com>, gregkh@suse.de, kristen.c.accardi@intel.com,
       lenb@kernel.org, rick.jones2@hp.com, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz, kaneshige.kenji@jp.fujitsu.com,
       pcihpd-discuss@lists.sourceforge.net, linux-acpi@vger.kernel.org
Subject: [PATCH 4/5] Add pci_slot_add_hotplug()
Message-ID: <20071114193836.GE25002@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>,
	Gary Hade <garyhade@us.ibm.com>, Matthew Wilcox <matthew@wil.cx>,
	Greg KH <greg@kroah.com>, gregkh@suse.de,
	kristen.c.accardi@intel.com, lenb@kernel.org, rick.jones2@hp.com,
	linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
	kaneshige.kenji@jp.fujitsu.com, pcihpd-discuss@lists.sourceforge.net,
	linux-acpi@vger.kernel.org
References: <20071114193605.GA25002@ldl.fc.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071114193605.GA25002@ldl.fc.hp.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Change the semantics of pci_create_slot() such that it does not
require a hotplug release() method when creating a slot. Now, we
can use this interface to create a pci_slot for any physical PCI
slots, not just hotpluggable ones.

Add new pci_slot_add_hotplug() interface so that various PCI hotplug
drivers can add hotplug release() methods to pre-existing physical
slots.

Signed-off-by: Alex Chiang <achiang@hp.com>
---
 drivers/pci/hotplug/pci_hotplug_core.c |    2 +-
 drivers/pci/slot.c                     |   36 +++++++++++++++++++++++++++----
 include/linux/pci.h                    |    4 ++-
 3 files changed, 35 insertions(+), 7 deletions(-)

diff --git a/drivers/pci/hotplug/pci_hotplug_core.c b/drivers/pci/hotplug/pci_hotplug_core.c
index c667684..c4b3e61 100644
--- a/drivers/pci/hotplug/pci_hotplug_core.c
+++ b/drivers/pci/hotplug/pci_hotplug_core.c
@@ -568,7 +568,7 @@ int pci_hp_register(struct hotplug_slot *slot, struct pci_bus *bus, int slot_nr)
 		return -EINVAL;
 	}
 
-	pci_slot = pci_create_slot(bus, slot_nr, slot->name, hotplug_release);
+	pci_slot = pci_slot_add_hotplug(bus, slot_nr, hotplug_release);
 	if (IS_ERR(pci_slot))
 		return PTR_ERR(pci_slot);
 	slot->pci_slot = pci_slot;
diff --git a/drivers/pci/slot.c b/drivers/pci/slot.c
index 5f0b69b..61e86b2 100644
--- a/drivers/pci/slot.c
+++ b/drivers/pci/slot.c
@@ -71,20 +71,47 @@ static int create_sysfs_files(struct pci_slot *slot)
 	return result;
 }
 
+struct pci_slot *pci_slot_add_hotplug(struct pci_bus *parent, int slot_nr,
+				      void (*release)(struct pci_slot *))
+{
+	struct pci_slot *slot;
+	int found = 0;
+
+	down_write(&pci_bus_sem);
+
+	/* This slot should have already been created, so look for it. If
+	 * we can't find it, return -EEXIST.
+	 */
+	for (slot = parent->slot; slot; slot = slot->next)
+		if (slot->number == slot_nr) {
+			found = 1;
+			break;
+		}
+
+	if (!found) {
+		slot = ERR_PTR(-EEXIST);
+		goto out;
+	}
+
+	slot->release = release;
+ out:
+	up_write(&pci_bus_sem);
+	return slot;
+}
+EXPORT_SYMBOL_GPL(pci_slot_add_hotplug);
+
 struct pci_slot *pci_create_slot(struct pci_bus *parent, int slot_nr,
-			const char *name, void (*release)(struct pci_slot *))
+				 const char *name)
 {
 	struct pci_slot *slot;
 	int err;
 
 	down_write(&pci_bus_sem);
 
-	/* If we've already created this slot, return -EEXIST.  The same slot
-	 * may be described twice (eg, by ACPI and PCIe) */
+	/* If we've already created this slot, just return. */
 	for (slot = parent->slot; slot; slot = slot->next) {
 		if (slot->number != slot_nr)
 			continue;
-		slot = ERR_PTR(-EEXIST);
 		goto out;
 	}
 
@@ -96,7 +123,6 @@ struct pci_slot *pci_create_slot(struct pci_bus *parent, int slot_nr,
 
 	slot->bus = parent;
 	slot->number = slot_nr;
-	slot->release = release;
 
 	kobject_set_name(&slot->kobj, "%s", name);
 	kobj_set_kset_s(slot, pci_slots_subsys);
diff --git a/include/linux/pci.h b/include/linux/pci.h
index a075667..62116a5 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -483,7 +483,9 @@ static inline struct pci_bus *pci_scan_bus(int bus, struct pci_ops *ops, void *s
 struct pci_bus *pci_create_bus(struct device *parent, int bus, struct pci_ops *ops, void *sysdata);
 struct pci_bus * pci_add_new_bus(struct pci_bus *parent, struct pci_dev *dev, int busnr);
 struct pci_slot *pci_create_slot(struct pci_bus *parent, int slot_nr,
-		const char *name, void (*release)(struct pci_slot *));
+				 const char *name);
+struct pci_slot *pci_slot_add_hotplug(struct pci_bus *parent, int slot_nr,
+				    void (*release)(struct pci_slot *));
 int pci_scan_slot(struct pci_bus *bus, int devfn);
 struct pci_dev * pci_scan_single_device(struct pci_bus *bus, int devfn);
 void pci_device_add(struct pci_dev *dev, struct pci_bus *bus);
-- 
1.5.3.1.1.g1e61

