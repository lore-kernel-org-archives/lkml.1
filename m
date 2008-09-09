Return-Path: <linux-kernel-owner+w=401wt.eu-S1752291AbYIIKBJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752291AbYIIKBJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 06:01:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752866AbYIIKAR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 06:00:17 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:19910 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752518AbYIIKAO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 06:00:14 -0400
From: Alex Chiang <achiang@hp.com>
Subject: [PATCH v2 02/13] PCI: prevent duplicate slot names
To: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: jbarnes@virtuousgeek.org, kristen.c.accardi@intel.com, matthew@wil.cx,
       kaneshige.kenji@jp.fujitsu.com, Alex Chiang <achiang@hp.com>
Date: Tue, 09 Sep 2008 04:00:12 -0600
Message-ID: <20080909100012.29542.62582.stgit@bob.kio>
In-Reply-To: <20080909091813.29542.85613.stgit@bob.kio>
References: <20080909091813.29542.85613.stgit@bob.kio>
User-Agent: StGIT/0.14.3.215.gff3d
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
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
	The Mth registered slot becomes N-M

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

Cc: jbarnes@virtuousgeek.org
Cc: kristen.c.accardi@intel.com
Cc: matthew@wil.cx
Cc: kaneshige.kenji@jp.fujitsu.com
Signed-off-by: Alex Chiang <achiang@hp.com>
---

 drivers/pci/hotplug/pci_hotplug_core.c |   23 ++++--
 drivers/pci/hotplug/pciehp_core.c      |   14 ----
 drivers/pci/hotplug/shpchp_core.c      |   15 ----
 drivers/pci/slot.c                     |  117 +++++++++++++++++++++++++++-----
 include/linux/pci.h                    |    3 +
 5 files changed, 117 insertions(+), 55 deletions(-)

diff --git a/drivers/pci/hotplug/pci_hotplug_core.c b/drivers/pci/hotplug/pci_hotplug_core.c
index 3e37d63..2232608 100644
--- a/drivers/pci/hotplug/pci_hotplug_core.c
+++ b/drivers/pci/hotplug/pci_hotplug_core.c
@@ -558,7 +558,8 @@ int pci_hp_register(struct hotplug_slot *slot, struct pci_bus *bus, int slot_nr,
 			const char *name)
 {
 	int result;
-	struct pci_slot *pci_slot;
+	struct pci_dev *dev;
+	struct pci_slot *pci_slot, *tmp_slot = NULL;
 
 	if (slot == NULL)
 		return -ENODEV;
@@ -570,9 +571,17 @@ int pci_hp_register(struct hotplug_slot *slot, struct pci_bus *bus, int slot_nr,
 		return -EINVAL;
 	}
 
-	/* Check if we have already registered a slot with the same name. */
-	if (get_slot_from_name(name))
-		return -EEXIST;
+	/*
+	 * If we find a tmp_slot here, it means that another slot
+	 * driver has already created a pci_slot for this device.
+	 * We care (below) if the existing slot has a different name from
+	 * the new name that this particular hotplug driver is requesting.
+	 */
+	dev = pci_get_slot(bus, PCI_DEVFN(slot_nr, 0));
+	if (dev && dev->slot) {
+		tmp_slot = dev->slot;
+		pci_dev_put(dev);
+	}
 
 	/*
 	 * No problems if we call this interface from both ACPI_PCI_SLOT
@@ -593,10 +602,10 @@ int pci_hp_register(struct hotplug_slot *slot, struct pci_bus *bus, int slot_nr,
 	pci_slot->hotplug = slot;
 
 	/*
-	 * Allow pcihp drivers to override the ACPI_PCI_SLOT name.
+	 * Allow pcihp drivers to override existing slot name.
 	 */
-	if (strcmp(kobject_name(&pci_slot->kobj), name)) {
-		result = kobject_rename(&pci_slot->kobj, name);
+	if (tmp_slot && strcmp(kobject_name(&tmp_slot->kobj), name)) {
+		result = pci_rename_slot(pci_slot, name);
 		if (result) {
 			pci_destroy_slot(pci_slot);
 			return result;
diff --git a/drivers/pci/hotplug/pciehp_core.c b/drivers/pci/hotplug/pciehp_core.c
index cbd84f8..bed77af 100644
--- a/drivers/pci/hotplug/pciehp_core.c
+++ b/drivers/pci/hotplug/pciehp_core.c
@@ -191,7 +191,6 @@ static int init_slots(struct controller *ctrl)
 	struct slot *slot;
 	struct hotplug_slot *hotplug_slot;
 	struct hotplug_slot_info *info;
-	int len, dup = 1;
 	int retval = -ENOMEM;
 
 	list_for_each_entry(slot, &ctrl->slot_list, slot_list) {
@@ -218,24 +217,11 @@ static int init_slots(struct controller *ctrl)
 		dbg("Registering bus=%x dev=%x hp_slot=%x sun=%x "
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
-					err("duplicate slot name overflow\n");
-			}
 			err("pci_hp_register failed with error %d\n", retval);
 			goto error_info;
 		}
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
index 0c6db03..93c55ca 100644
--- a/drivers/pci/slot.c
+++ b/drivers/pci/slot.c
@@ -78,6 +78,51 @@ static struct kobj_type pci_slot_ktype = {
 	.default_attrs = pci_slot_default_attrs,
 };
 
+static char *make_slot_name(const char *name)
+{
+	char *new_name;
+	int len, width, dup = 1;
+	struct kobject *dup_slot;
+
+	new_name = kstrdup(name, GFP_KERNEL);
+	if (!new_name)
+		goto out;
+
+	/*
+	 * Start off allocating enough room for "name-X"
+	 */
+	len = strlen(name) + 2;
+	width = 1;
+
+try_again:
+	dup_slot = kset_find_obj(pci_slots_kset, new_name);
+	if (!dup_slot)
+		goto out;
+	kobject_put(dup_slot);
+
+	/*
+	 * We hit this the first time through, which gives us
+	 * space for terminating NULL, and then every power of 10
+	 * afterwards, which gives us space to add another digit
+	 * to "name-XX..."
+	 */
+	if (dup % width == 0) {
+		len++;
+		width *= 10;
+	}
+
+	new_name = krealloc(new_name, len, GFP_KERNEL);
+	if (!new_name)
+		goto out;
+
+	memset(new_name, 0, len);
+	scnprintf(new_name, len, "%s-%d", name, dup++);
+	goto try_again;
+
+out:
+	return new_name;
+}
+
 /**
  * pci_create_slot - create or increment refcount for physical PCI slot
  * @parent: struct pci_bus of parent bridge
@@ -89,7 +134,19 @@ static struct kobj_type pci_slot_ktype = {
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
+ * The Mth slot is assigned N-M
  *
  * Placeholder slots:
  * In most cases, @pci_bus, @slot_nr will be sufficient to uniquely identify
@@ -109,13 +166,13 @@ static struct kobj_type pci_slot_ktype = {
  * %struct pci_bus and bb is the bus number. In other words, the devfn of
  * the 'placeholder' slot will not be displayed.
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
 
 	down_write(&pci_bus_sem);
 
@@ -144,12 +201,18 @@ placeholder:
 
 	slot->bus = parent;
 	slot->number = slot_nr;
-
 	slot->kobj.kset = pci_slots_kset;
+
+	slot_name = make_slot_name(name);
+	if (!slot_name) {
+		slot = ERR_PTR(-ENOMEM);
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
 
@@ -165,6 +228,7 @@ placeholder:
 		 __func__, pci_domain_nr(parent), parent->number, slot_nr);
 
  out:
+	kfree(slot_name);
 	up_write(&pci_bus_sem);
 	return slot;
  err:
@@ -175,7 +239,31 @@ placeholder:
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
@@ -183,27 +271,19 @@ EXPORT_SYMBOL_GPL(pci_create_slot);
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
 
-	list_for_each_entry(tmp, &slot->bus->slots, list) {
+	list_for_each_entry(tmp, &slot->bus->slots, list)
 		WARN_ON(tmp->number == slot_nr);
-		if (!strcmp(kobject_name(&tmp->kobj), kobject_name(&slot->kobj)))
-			name_count++;
-	}
-
-	if (name_count > 1)
-		printk(KERN_WARNING "pci_update_slot_number found %d slots with the same name: %s\n", name_count, kobject_name(&slot->kobj));
 
 	slot->number = slot_nr;
 	up_write(&pci_bus_sem);
 }
-EXPORT_SYMBOL_GPL(pci_update_slot_number);
+EXPORT_SYMBOL_GPL(pci_renumber_slot);
 
 /**
  * pci_destroy_slot - decrement refcount for physical PCI slot
@@ -213,7 +293,6 @@ EXPORT_SYMBOL_GPL(pci_update_slot_number);
  * just call kobject_put on its kobj and let our release methods do the
  * rest.
  */
-
 void pci_destroy_slot(struct pci_slot *slot)
 {
 	pr_debug("%s: dec refcount to %d on %04x:%02x:%02x\n", __func__,
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 79dc7ce..fd6efbc 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -510,7 +510,8 @@ struct pci_bus *pci_add_new_bus(struct pci_bus *parent, struct pci_dev *dev,
 struct pci_slot *pci_create_slot(struct pci_bus *parent, int slot_nr,
 				 const char *name);
 void pci_destroy_slot(struct pci_slot *slot);
-void pci_update_slot_number(struct pci_slot *slot, int slot_nr);
+int pci_rename_slot(struct pci_slot *slot, const char *name);
+void pci_renumber_slot(struct pci_slot *slot, int slot_nr);
 int pci_scan_slot(struct pci_bus *bus, int devfn);
 struct pci_dev *pci_scan_single_device(struct pci_bus *bus, int devfn);
 void pci_device_add(struct pci_dev *dev, struct pci_bus *bus);

