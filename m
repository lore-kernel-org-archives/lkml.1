Return-Path: <linux-kernel-owner+w=401wt.eu-S1754757AbYJHGhw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754757AbYJHGhw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 02:37:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751289AbYJHGho
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 02:37:44 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:57262 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751021AbYJHGhm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 02:37:42 -0400
Message-ID: <48EC548B.5020704@jp.fujitsu.com>
Date: Wed, 08 Oct 2008 15:34:51 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Alex Chiang <achiang@hp.com>
CC: jbarnes@virtuousgeek.org, kristen.c.accardi@intel.com, matthew@wil.cx,
       linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [02/03] Sample patch for [PATCH v4 03/15]
References: <20081003230125.9989.31145.stgit@bob.kio> <48EC53D3.9020203@jp.fujitsu.com>
In-Reply-To: <48EC53D3.9020203@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

NOTE:This doesn't target the comment about changing exported
symbol name.

---
 drivers/pci/hotplug/pci_hotplug_core.c |   18 +---
 drivers/pci/hotplug/pciehp_core.c      |   15 ----
 drivers/pci/hotplug/shpchp_core.c      |   15 ----
 drivers/pci/slot.c                     |  123 ++++++++++++++++++++++++++-------
 include/linux/pci.h                    |    4 -
 5 files changed, 107 insertions(+), 68 deletions(-)

Index: hotplug/drivers/pci/hotplug/pciehp_core.c
===================================================================
--- hotplug.orig/drivers/pci/hotplug/pciehp_core.c
+++ hotplug/drivers/pci/hotplug/pciehp_core.c
@@ -196,7 +196,6 @@ static int init_slots(struct controller 
 	struct slot *slot;
 	struct hotplug_slot *hotplug_slot;
 	struct hotplug_slot_info *info;
-	int len, dup = 1;
 	int retval = -ENOMEM;
 
 	list_for_each_entry(slot, &ctrl->slot_list, slot_list) {
@@ -223,25 +222,11 @@ static int init_slots(struct controller 
 		ctrl_dbg(ctrl, "Registering bus=%x dev=%x hp_slot=%x sun=%x "
 			 "slot_device_offset=%x\n", slot->bus, slot->device,
 			 slot->hp_slot, slot->number, ctrl->slot_device_offset);
-duplicate_name:
 		retval = pci_hp_register(hotplug_slot,
 					 ctrl->pci_dev->subordinate,
 					 slot->device,
 					 slot->name);
 		if (retval) {
-			/*
-			 * If slot N already exists, we'll try to create
-			 * slot N-1, N-2 ... N-M, until we overflow.
-			 */
-			if (retval == -EEXIST) {
-				len = snprintf(slot->name, SLOT_NAME_SIZE,
-					       "%d-%d", slot->number, dup++);
-				if (len < SLOT_NAME_SIZE)
-					goto duplicate_name;
-				else
-					ctrl_err(ctrl, "duplicate slot name "
-						 "overflow\n");
-			}
 			ctrl_err(ctrl, "pci_hp_register failed with error %d\n",
 				 retval);
 			goto error_info;
Index: hotplug/drivers/pci/hotplug/shpchp_core.c
===================================================================
--- hotplug.orig/drivers/pci/hotplug/shpchp_core.c
+++ hotplug/drivers/pci/hotplug/shpchp_core.c
@@ -102,7 +102,7 @@ static int init_slots(struct controller 
 	struct hotplug_slot *hotplug_slot;
 	struct hotplug_slot_info *info;
 	int retval = -ENOMEM;
-	int i, len, dup = 1;
+	int i;
 
 	for (i = 0; i < ctrl->num_slots; i++) {
 		slot = kzalloc(sizeof(*slot), GFP_KERNEL);
@@ -144,23 +144,10 @@ static int init_slots(struct controller 
 		dbg("Registering bus=%x dev=%x hp_slot=%x sun=%x "
 		    "slot_device_offset=%x\n", slot->bus, slot->device,
 		    slot->hp_slot, slot->number, ctrl->slot_device_offset);
-duplicate_name:
 		retval = pci_hp_register(slot->hotplug_slot,
 				ctrl->pci_dev->subordinate, slot->device,
 				hotplug_slot->name);
 		if (retval) {
-			/*
-			 * If slot N already exists, we'll try to create
-			 * slot N-1, N-2 ... N-M, until we overflow.
-			 */
-			if (retval == -EEXIST) {
-				len = snprintf(slot->name, SLOT_NAME_SIZE,
-					       "%d-%d", slot->number, dup++);
-				if (len < SLOT_NAME_SIZE)
-					goto duplicate_name;
-				else
-					err("duplicate slot name overflow\n");
-			}
 			err("pci_hp_register failed with error %d\n", retval);
 			goto error_info;
 		}
Index: hotplug/include/linux/pci.h
===================================================================
--- hotplug.orig/include/linux/pci.h
+++ hotplug/include/linux/pci.h
@@ -509,8 +509,10 @@ struct pci_bus *pci_add_new_bus(struct p
 				int busnr);
 struct pci_slot *pci_create_slot(struct pci_bus *parent, int slot_nr,
 				 const char *name);
+struct pci_slot *pci_get_pci_slot(struct pci_bus *parent, int slot_nr);
 void pci_destroy_slot(struct pci_slot *slot);
-void pci_update_slot_number(struct pci_slot *slot, int slot_nr);
+int pci_rename_slot(struct pci_slot *slot, const char *name);
+void pci_renumber_slot(struct pci_slot *slot, int slot_nr);
 int pci_scan_slot(struct pci_bus *bus, int devfn);
 struct pci_dev *pci_scan_single_device(struct pci_bus *bus, int devfn);
 void pci_device_add(struct pci_dev *dev, struct pci_bus *bus);
Index: hotplug/drivers/pci/hotplug/pci_hotplug_core.c
===================================================================
--- hotplug.orig/drivers/pci/hotplug/pci_hotplug_core.c
+++ hotplug/drivers/pci/hotplug/pci_hotplug_core.c
@@ -569,12 +569,6 @@ int pci_hp_register(struct hotplug_slot 
 
 	mutex_lock(&pci_hp_mutex);
 
-	/* Check if we have already registered a slot with the same name. */
-	if (get_slot_from_name(name)) {
-		result = -EEXIST;
-		goto out;
-	}
-
 	/*
 	 * No problems if we call this interface from both ACPI_PCI_SLOT
 	 * driver and call it here again. If we've already created the
@@ -590,18 +584,14 @@ int pci_hp_register(struct hotplug_slot 
 		goto cleanup;
 	}
 
-	slot->pci_slot = pci_slot;
-	pci_slot->hotplug = slot;
-
 	/*
 	 * Allow pcihp drivers to override the ACPI_PCI_SLOT name.
 	 */
-	if (strcmp(kobject_name(&pci_slot->kobj), name)) {
-		result = kobject_rename(&pci_slot->kobj, name);
-		if (result)
-			goto cleanup;
-	}
+	if ((result = pci_rename_slot(pci_slot, name)))
+		goto cleanup;
 
+	slot->pci_slot = pci_slot;
+	pci_slot->hotplug = slot;
 	list_add(&slot->slot_list, &pci_hotplug_slot_list);
 
 	result = fs_add_slot(pci_slot);
Index: hotplug/drivers/pci/slot.c
===================================================================
--- hotplug.orig/drivers/pci/slot.c
+++ hotplug/drivers/pci/slot.c
@@ -78,6 +78,46 @@ static struct kobj_type pci_slot_ktype =
 	.default_attrs = pci_slot_default_attrs,
 };
 
+static char *make_slot_name(struct pci_slot *slot, const char *name)
+{
+	char *new_name;
+	int len, max, dup;
+
+	new_name = kstrdup(name, GFP_KERNEL);
+	if (!new_name)
+		return NULL;
+
+	/*
+	 * Make sure we hit the realloc case the first time through the
+	 * loop.  'len' will be strlen(name) + 3 at that point which is
+	 * enough space for "name-X" and the trailing NUL.
+	 */
+	len = strlen(name) + 2;
+	max = 1;
+	dup = 1;
+
+	for (;;) {
+		struct kobject *dup_slot;
+		dup_slot = kset_find_obj(pci_slots_kset, new_name);
+		if (!dup_slot)
+			break;
+		kobject_put(dup_slot);
+		if (dup_slot == &slot->kobj)
+			break;
+		if (dup == max) {
+			len++;
+			max *= 10;
+			kfree(new_name);
+			new_name = kmalloc(len, GFP_KERNEL);
+			if (!new_name)
+				break;
+		}
+		sprintf(new_name, "%s-%d", name, dup++);
+	}
+
+	return new_name;
+}
+
 /**
  * pci_create_slot - create or increment refcount for physical PCI slot
  * @parent: struct pci_bus of parent bridge
@@ -89,7 +129,19 @@ static struct kobj_type pci_slot_ktype =
  * either return a new &struct pci_slot to the caller, or if the pci_slot
  * already exists, its refcount will be incremented.
  *
- * Slots are uniquely identified by a @pci_bus, @slot_nr, @name tuple.
+ * Slots are uniquely identified by a @pci_bus, @slot_nr tuple.
+ *
+ * The kobject API imposes a restriction on us, and does not allow sysfs
+ * entries with duplicate names. There are known platforms with broken
+ * firmware that assign the same name to multiple slots.
+ *
+ * We workaround these broken platforms by renaming the slots on behalf
+ * of the caller. If firmware assigns name N to multiple slots:
+ *
+ * The first slot is assigned N
+ * The second slot is assigned N-1
+ * The third slot is assigned N-2
+ * etc.
  *
  * Placeholder slots:
  * In most cases, @pci_bus, @slot_nr will be sufficient to uniquely identify
@@ -98,24 +150,20 @@ static struct kobj_type pci_slot_ktype =
  * the slot. In this scenario, the caller may pass -1 for @slot_nr.
  *
  * The following semantics are imposed when the caller passes @slot_nr ==
- * -1. First, the check for existing %struct pci_slot is skipped, as the
- * caller may know about several unpopulated slots on a given %struct
- * pci_bus, and each slot would have a @slot_nr of -1.  Uniqueness for
- * these slots is then determined by the @name parameter. We expect
- * kobject_init_and_add() to warn us if the caller attempts to create
- * multiple slots with the same name. The other change in semantics is
+ * -1. First, we no longer check for an existing %struct pci_slot, as there
+ * may be many slots with @slot_nr of -1.  The other change in semantics is
  * user-visible, which is the 'address' parameter presented in sysfs will
  * consist solely of a dddd:bb tuple, where dddd is the PCI domain of the
  * %struct pci_bus and bb is the bus number. In other words, the devfn of
  * the 'placeholder' slot will not be displayed.
  */
-
 struct pci_slot *pci_create_slot(struct pci_bus *parent, int slot_nr,
 				 const char *name)
 {
 	struct pci_dev *dev;
 	struct pci_slot *slot;
 	int err;
+	char *slot_name = NULL;
 
 	down_write(&pci_bus_sem);
 
@@ -144,18 +192,23 @@ placeholder:
 
 	slot->bus = parent;
 	slot->number = slot_nr;
-
 	slot->kobj.kset = pci_slots_kset;
+
+	slot_name = make_slot_name(slot, name);
+	if (!slot_name) {
+		err = -ENOMEM;
+		goto err;
+	}
+
 	err = kobject_init_and_add(&slot->kobj, &pci_slot_ktype, NULL,
-				   "%s", name);
+				   "%s", slot_name);
 	if (err) {
-		printk(KERN_ERR "Unable to register kobject %s\n", name);
+		printk(KERN_ERR "Unable to register kobject %s\n", slot_name);
 		goto err;
 	}
 
 	INIT_LIST_HEAD(&slot->list);
 	list_add(&slot->list, &parent->slots);
-
 	list_for_each_entry(dev, &parent->devices, bus_list)
 		if (PCI_SLOT(dev->devfn) == slot_nr)
 			dev->slot = slot;
@@ -166,6 +219,7 @@ placeholder:
 
  out:
 	up_write(&pci_bus_sem);
+	kfree(slot_name);
 	return slot;
  err:
 	kfree(slot);
@@ -175,7 +229,35 @@ placeholder:
 EXPORT_SYMBOL_GPL(pci_create_slot);
 
 /**
- * pci_update_slot_number - update %struct pci_slot -> number
+ * pci_rename_slot - update %struct pci_slot -> name
+ * @slot - %struct pci_slot to update
+ * @name - new requested name for slot
+ *
+ * Allow caller to safely rename a %struct pci_slot without making
+ * the kobject core complain about duplicate names.
+ */
+int pci_rename_slot(struct pci_slot *slot, const char *name)
+{
+	int result = 0;
+	char *slot_name;
+
+	down_write(&pci_bus_sem);
+	slot_name = make_slot_name(slot, name);
+	if (!slot_name) {
+		result = -ENOMEM;
+		goto out;
+	}
+	if (strcmp(kobject_name(&slot->kobj), slot_name))
+		result = kobject_rename(&slot->kobj, slot_name);
+	kfree(slot_name);
+out:
+	up_write(&pci_bus_sem);
+	return result;
+}
+EXPORT_SYMBOL_GPL(pci_rename_slot);
+
+/**
+ * pci_renumber_slot - update %struct pci_slot -> number
  * @slot - %struct pci_slot to update
  * @slot_nr - new number for slot
  *
@@ -183,27 +265,21 @@ EXPORT_SYMBOL_GPL(pci_create_slot);
  * created a placeholder slot in pci_create_slot() by passing a -1 as
  * slot_nr, to update their %struct pci_slot with the correct @slot_nr.
  */
-
-void pci_update_slot_number(struct pci_slot *slot, int slot_nr)
+void pci_renumber_slot(struct pci_slot *slot, int slot_nr)
 {
-	int name_count = 0;
 	struct pci_slot *tmp;
 
 	down_write(&pci_bus_sem);
 
 	list_for_each_entry(tmp, &slot->bus->slots, list) {
 		WARN_ON(tmp->number == slot_nr);
-		if (!strcmp(kobject_name(&tmp->kobj), kobject_name(&slot->kobj)))
-			name_count++;
+		goto out;
 	}
-
-	if (name_count > 1)
-		printk(KERN_WARNING "pci_update_slot_number found %d slots with the same name: %s\n", name_count, kobject_name(&slot->kobj));
-
 	slot->number = slot_nr;
+out:
 	up_write(&pci_bus_sem);
 }
-EXPORT_SYMBOL_GPL(pci_update_slot_number);
+EXPORT_SYMBOL_GPL(pci_renumber_slot);
 
 /**
  * pci_destroy_slot - decrement refcount for physical PCI slot
@@ -213,7 +289,6 @@ EXPORT_SYMBOL_GPL(pci_update_slot_number
  * just call kobject_put on its kobj and let our release methods do the
  * rest.
  */
-
 void pci_destroy_slot(struct pci_slot *slot)
 {
 	pr_debug("%s: dec refcount to %d on %04x:%02x:%02x\n", __func__,


