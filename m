Return-Path: <linux-kernel-owner+w=401wt.eu-S1754687AbYJCXSm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754687AbYJCXSm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 19:18:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754354AbYJCXRr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 19:17:47 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:1974 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754284AbYJCXRp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 19:17:45 -0400
From: Alex Chiang <achiang@hp.com>
Subject: [PATCH v4 03/15] PCI: prevent duplicate slot names
To: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: jbarnes@virtuousgeek.org, kristen.c.accardi@intel.com, matthew@wil.cx,
       kaneshige.kenji@jp.fujitsu.com, Alex Chiang <achiang@hp.com>
Date: Fri, 03 Oct 2008 17:17:42 -0600
Message-ID: <20081003231742.9989.89860.stgit@bob.kio>
In-Reply-To: <20081003230125.9989.31145.stgit@bob.kio>
References: <20081003230125.9989.31145.stgit@bob.kio>
User-Agent: StGIT/0.14.3.215.gff3d
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prevent callers of pci_create_slot() from registering slots with
duplicate names. This condition occurs most often when PCI hotplug
drivers are loaded on platforms with broken firmware that assigns
identical names to multiple slots.

We now rename these duplicate slots on behalf of the user.

If firmware assigns the name N to multiple slots, then:

	The first registered slot is assigned N
	The second registered slot is assigned N-1
	The third registered slot is assigned N-2
	etc.

A side effect of this patch is that the error condition for when
multiple drivers attempt to claim the same slot becomes much more
prominent.

In other words, the previous error condition returned for
duplicate slot names (-EEXIST) masked the case when multiple
drivers attempted to claim the same slot. Now, the -EBUSY return
makes the true error more obvious.

This is the permanent fix mentioned in earlier commits:

	shpchp: Rename duplicate slot name N as N-1, N-2, N-M...
	d6a9e9b40be7da84f82eb414c2ad98c5bb69986b

	pciehp: Rename duplicate slot name N as N-1, N-2, N-M...
	167e782e301188c7c7e31e486bbeea5f918324c1

This commit also introduces two new PCI core interfaces:

	struct pci_slot *pci_get_pci_slot(struct pci_bus *parent, int slot_nr);
	void pci_renumber_slot(struct pci_slot *slot, int slot_nr);

And removes the old, unused pci_update_slot_number() API.

Cc: jbarnes@virtuousgeek.org
Cc: kristen.c.accardi@intel.com
Cc: matthew@wil.cx
Cc: kaneshige.kenji@jp.fujitsu.com
Signed-off-by: Alex Chiang <achiang@hp.com>
---

 drivers/pci/hotplug/pci_hotplug_core.c |   52 ++++-----
 drivers/pci/hotplug/pciehp_core.c      |   15 ---
 drivers/pci/hotplug/shpchp_core.c      |   15 ---
 drivers/pci/slot.c                     |  177 ++++++++++++++++++++++++--------
 include/linux/pci.h                    |    4 +
 5 files changed, 160 insertions(+), 103 deletions(-)

diff --git a/drivers/pci/hotplug/pci_hotplug_core.c b/drivers/pci/hotplug/pci_hotplug_core.c
index e00266b..b196ea1 100644
--- a/drivers/pci/hotplug/pci_hotplug_core.c
+++ b/drivers/pci/hotplug/pci_hotplug_core.c
@@ -572,41 +572,32 @@ int pci_hp_register(struct hotplug_slot *slot, struct pci_bus *bus, int slot_nr,
 		return -EINVAL;
 	}
 
-	/* Check if we have already registered a slot with the same name. */
-	if (get_slot_from_name(name))
-		return -EEXIST;
-
 	/*
-	 * No problems if we call this interface from both ACPI_PCI_SLOT
-	 * driver and call it here again. If we've already created the
-	 * pci_slot, the interface will simply bump the refcount.
+	 * Look for existing slot. If we find it, and it was created by a
+	 * slot detection driver (ie, doesn't have a ->hotplug()) then we
+	 * allow the hotplug driver calling us to rename the slot if desired.
+	 *
+	 * Otherwise, create the slot and carry on with life.
 	 */
-	pci_slot = pci_create_slot(bus, slot_nr, name);
-	if (IS_ERR(pci_slot))
-		return PTR_ERR(pci_slot);
-
 	mutex_lock(&pci_hp_mutex);
-	if (pci_slot->hotplug) {
-		mutex_unlock(&pci_hp_mutex);
-		dbg("%s: already claimed\n", __func__);
-		pci_destroy_slot(pci_slot);
-		return -EBUSY;
+	pci_slot = pci_get_pci_slot(bus, slot_nr);
+	if (pci_slot) {
+		if (pci_slot->hotplug) {
+			result = -EBUSY;
+			goto err;
+		}
+
+		if (strcmp(kobject_name(&pci_slot->kobj), name))
+			if ((result = pci_rename_slot(pci_slot, name)))
+				goto err;
+	} else {
+		pci_slot = pci_create_slot(bus, slot_nr, name);
+		if ((result = IS_ERR(pci_slot)))
+			goto out;
 	}
 
 	slot->pci_slot = pci_slot;
 	pci_slot->hotplug = slot;
-	mutex_unlock(&pci_hp_mutex);
-
-	/*
-	 * Allow pcihp drivers to override the ACPI_PCI_SLOT name.
-	 */
-	if (strcmp(kobject_name(&pci_slot->kobj), name)) {
-		result = kobject_rename(&pci_slot->kobj, name);
-		if (result) {
-			pci_destroy_slot(pci_slot);
-			return result;
-		}
-	}
 
 	spin_lock(&pci_hotplug_slot_list_lock);
 	list_add(&slot->slot_list, &pci_hotplug_slot_list);
@@ -616,7 +607,12 @@ int pci_hp_register(struct hotplug_slot *slot, struct pci_bus *bus, int slot_nr,
 	kobject_uevent(&pci_slot->kobj, KOBJ_ADD);
 	dbg("Added slot %s to the list\n", name);
 
+out:
+	mutex_unlock(&pci_hp_mutex);
 	return result;
+err:
+	pci_destroy_slot(pci_slot);
+	goto out;
 }
 
 /**
diff --git a/drivers/pci/hotplug/pciehp_core.c b/drivers/pci/hotplug/pciehp_core.c
index 3ace5e0..af89d7b 100644
--- a/drivers/pci/hotplug/pciehp_core.c
+++ b/drivers/pci/hotplug/pciehp_core.c
@@ -196,7 +196,6 @@ static int init_slots(struct controller *ctrl)
 	struct slot *slot;
 	struct hotplug_slot *hotplug_slot;
 	struct hotplug_slot_info *info;
-	int len, dup = 1;
 	int retval = -ENOMEM;
 
 	list_for_each_entry(slot, &ctrl->slot_list, slot_list) {
@@ -223,25 +222,11 @@ static int init_slots(struct controller *ctrl)
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
diff --git a/drivers/pci/hotplug/shpchp_core.c b/drivers/pci/hotplug/shpchp_core.c
index bf50966..cfdd079 100644
--- a/drivers/pci/hotplug/shpchp_core.c
+++ b/drivers/pci/hotplug/shpchp_core.c
@@ -102,7 +102,7 @@ static int init_slots(struct controller *ctrl)
 	struct hotplug_slot *hotplug_slot;
 	struct hotplug_slot_info *info;
 	int retval = -ENOMEM;
-	int i, len, dup = 1;
+	int i;
 
 	for (i = 0; i < ctrl->num_slots; i++) {
 		slot = kzalloc(sizeof(*slot), GFP_KERNEL);
@@ -144,23 +144,10 @@ static int init_slots(struct controller *ctrl)
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
diff --git a/drivers/pci/slot.c b/drivers/pci/slot.c
index 1fffb27..e6af4f9 100644
--- a/drivers/pci/slot.c
+++ b/drivers/pci/slot.c
@@ -78,6 +78,73 @@ static struct kobj_type pci_slot_ktype = {
 	.default_attrs = pci_slot_default_attrs,
 };
 
+static char *make_slot_name(const char *name)
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
+/**
+ * pci_get_pci_slot - search for and get a %struct pci_slot
+ * @parent: %struct pci_bus of parent bridge
+ * @slot_nr: PCI_SLOT(pci_dev->devfn) we're looking for
+ *
+ * Search a %struct pci_bus for a given @slot_nr. If we find one,
+ * increment its refcount and return it. Callers are responsible for
+ * calling pci_destroy_slot() if we find one.
+ *
+ * If we don't find it, return NULL.
+ */
+struct pci_slot *pci_get_pci_slot(struct pci_bus *parent, int slot_nr)
+{
+	struct pci_slot *slot;
+
+	down_read(&pci_bus_sem);
+	list_for_each_entry(slot, &parent->slots, list)
+		if (slot->number == slot_nr)
+			goto out;
+
+	slot = NULL;
+out:
+	if (slot)
+		kobject_get(&slot->kobj);
+	up_read(&pci_bus_sem);
+	return slot;
+}
+EXPORT_SYMBOL_GPL(pci_get_pci_slot);
+
 /**
  * pci_create_slot - create or increment refcount for physical PCI slot
  * @parent: struct pci_bus of parent bridge
@@ -89,7 +156,19 @@ static struct kobj_type pci_slot_ktype = {
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
@@ -98,44 +177,27 @@ static struct kobj_type pci_slot_ktype = {
  * the slot. In this scenario, the caller may pass -1 for @slot_nr.
  *
  * The following semantics are imposed when the caller passes @slot_nr ==
- * -1. First, the check for existing %struct pci_slot is skipped, as the
- * caller may know about several unpopulated slots on a given %struct
- * pci_bus, and each slot would have a @slot_nr of -1.  Uniqueness for
- * these slots is then determined by the @name parameter. We expect
- * kobject_init_and_add() to warn us if the caller attempts to create
- * multiple slots with the same name. The other change in semantics is
- * user-visible, which is the 'address' parameter presented in sysfs will
- * consist solely of a dddd:bb tuple, where dddd is the PCI domain of the
- * %struct pci_bus and bb is the bus number. In other words, the devfn of
- * the 'placeholder' slot will not be displayed.
+ * -1. First, we no longer check for an existing %struct pci_slot, as there
+ *  may be many slots with @slot_nr of -1.  The other change in semantics is
+ *  user-visible, which is the 'address' parameter presented in sysfs will
+ *  consist solely of a dddd:bb tuple, where dddd is the PCI domain of the
+ *  %struct pci_bus and bb is the bus number. In other words, the devfn of
+ *  the 'placeholder' slot will not be displayed.
  */
-
 struct pci_slot *pci_create_slot(struct pci_bus *parent, int slot_nr,
 				 const char *name)
 {
 	struct pci_dev *dev;
 	struct pci_slot *slot;
-	int err;
+	int err = 0;
+	char *slot_name = NULL;
 
-	down_write(&pci_bus_sem);
-
-	if (slot_nr == -1)
-		goto placeholder;
-
-	/* If we've already created this slot, bump refcount and return. */
-	list_for_each_entry(slot, &parent->slots, list) {
-		if (slot->number == slot_nr) {
-			kobject_get(&slot->kobj);
-			pr_debug("%s: inc refcount to %d on %04x:%02x:%02x\n",
-				 __func__,
-				 atomic_read(&slot->kobj.kref.refcount),
-				 pci_domain_nr(parent), parent->number,
-				 slot_nr);
+	if (slot_nr != -1) {
+		slot = pci_get_pci_slot(parent, slot_nr);
+		if (slot)
 			goto out;
-		}
 	}
 
-placeholder:
 	slot = kzalloc(sizeof(*slot), GFP_KERNEL);
 	if (!slot) {
 		slot = ERR_PTR(-ENOMEM);
@@ -144,28 +206,35 @@ placeholder:
 
 	slot->bus = parent;
 	slot->number = slot_nr;
-
 	slot->kobj.kset = pci_slots_kset;
+
+	slot_name = make_slot_name(name);
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
 
+	down_write(&pci_bus_sem);
 	INIT_LIST_HEAD(&slot->list);
 	list_add(&slot->list, &parent->slots);
-
 	list_for_each_entry(dev, &parent->devices, bus_list)
 		if (PCI_SLOT(dev->devfn) == slot_nr)
 			dev->slot = slot;
+	up_write(&pci_bus_sem);
 
 	/* Don't care if debug printk has a -1 for slot_nr */
 	pr_debug("%s: created pci_slot on %04x:%02x:%02x\n",
 		 __func__, pci_domain_nr(parent), parent->number, slot_nr);
 
 out:
-	up_write(&pci_bus_sem);
+	kfree(slot_name);
 	return slot;
 err:
 	kfree(slot);
@@ -175,7 +244,31 @@ err:
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
+	int result;
+	char *slot_name;
+
+	slot_name = make_slot_name(name);
+	if (!slot_name)
+		return -ENOMEM;
+
+	result = kobject_rename(&slot->kobj, slot_name);
+	kfree(slot_name);
+
+	return result;
+}
+EXPORT_SYMBOL_GPL(pci_rename_slot);
+
+/**
+ * pci_renumber_slot - update %struct pci_slot -> number
  * @slot - %struct pci_slot to update
  * @slot_nr - new number for slot
  *
@@ -183,27 +276,22 @@ EXPORT_SYMBOL_GPL(pci_create_slot);
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
@@ -213,7 +301,6 @@ EXPORT_SYMBOL_GPL(pci_update_slot_number);
  * just call kobject_put on its kobj and let our release methods do the
  * rest.
  */
-
 void pci_destroy_slot(struct pci_slot *slot)
 {
 	pr_debug("%s: dec refcount to %d on %04x:%02x:%02x\n", __func__,
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 79dc7ce..5617a4d 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -509,8 +509,10 @@ struct pci_bus *pci_add_new_bus(struct pci_bus *parent, struct pci_dev *dev,
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

