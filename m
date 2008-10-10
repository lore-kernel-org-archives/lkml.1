Return-Path: <linux-kernel-owner+w=401wt.eu-S1755102AbYJJCNP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755102AbYJJCNP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 22:13:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753753AbYJJCM7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 22:12:59 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:15718 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753549AbYJJCM6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 22:12:58 -0400
Date: Thu, 9 Oct 2008 20:12:30 -0600
From: Alex Chiang <achiang@hp.com>
To: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       jbarnes@virtuousgeek.org, kristen.c.accardi@intel.com, matthew@wil.cx
Subject: Re: [PATCH v5 04/16] PCI: prevent duplicate slot names
Message-ID: <20081010021230.GC13292@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>,
	Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
	linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
	jbarnes@virtuousgeek.org, kristen.c.accardi@intel.com,
	matthew@wil.cx
References: <20081009043140.8678.44164.stgit@bob.kio> <20081009044649.8678.30990.stgit@bob.kio> <48ED9716.3040301@jp.fujitsu.com> <20081009055654.GA30972@ldl.fc.hp.com> <48EDF9F5.9020802@jp.fujitsu.com> <20081010021034.GA13292@ldl.fc.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081010021034.GA13292@ldl.fc.hp.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Note, the comments might be a bit stale...

Also note the change in rename_slot() so we don't try and rename
something with the same name.

/ac

commit eb00679613b5e5b7d7b4ebd82d4a229fff1ecefa
Author: Alex Chiang <achiang@hp.com>
Date:   Thu Oct 9 20:06:49 2008 -0600

    PCI: prevent duplicate slot names
    
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
    prominent. The -EBUSY was getting masked previously by -EEXIST in
    the event of duplicate slot names; this is no longer so.
    
    This is the permanent fix mentioned in earlier commits d6a9e9b4 and
    167e782e (shpchp/pciehp: Rename duplicate slot name...).
    
    Finally, we take advantage of the new 'rename' parameter in
    pci_create_slot() to prevent a slot create/rename race between hotplug
    drivers and detection drivers.
    
    	Scenario A:
    	hotplug driver                  detection_driver
    	--------------                  ----------------
    	pci_create_slot(rename=1)
    					pci_create_slot(rename=0)
    
    The hotplug driver creates the slot with its desired name, and then
    releases the semaphore. Now, the detection driver tries to create
    the same slot, but it already exists. We don't care about renaming,
    so return the existing slot.
    
    	Scenario B:
    	hotplug driver                  detection_driver
    	--------------                  ----------------
    					pci_create_slot(rename=0)
    	pci_create_slot(rename=1)
    
    The detection driver creates the slot with name "X". Then the hotplug
    driver tries to create the same slot, but wants the name "Y" instead.
    We detect that we're trying to create the same slot and that we also
    want a rename, so rename the slot to "Y" and return.
    
    Cc: jbarnes@virtuousgeek.org
    Cc: kristen.c.accardi@intel.com
    Cc: matthew@wil.cx
    Cc: kaneshige.kenji@jp.fujitsu.com
    Signed-off-by: Alex Chiang <achiang@hp.com>

diff --git a/drivers/pci/hotplug/pci_hotplug_core.c b/drivers/pci/hotplug/pci_hotplug_core.c
index 191b58e..b4e3a43 100644
--- a/drivers/pci/hotplug/pci_hotplug_core.c
+++ b/drivers/pci/hotplug/pci_hotplug_core.c
@@ -570,10 +570,6 @@ int pci_hp_register(struct hotplug_slot *slot, struct pci_bus *bus, int slot_nr,
 		return -EINVAL;
 	}
 
-	/* Check if we have already registered a slot with the same name. */
-	if (get_slot_from_name(name))
-		return -EEXIST;
-
 	/*
 	 * No problems if we call this interface from both ACPI_PCI_SLOT
 	 * driver and call it here again. If we've already created the
@@ -583,25 +579,7 @@ int pci_hp_register(struct hotplug_slot *slot, struct pci_bus *bus, int slot_nr,
 	if (IS_ERR(pci_slot))
 		return PTR_ERR(pci_slot);
 
-	if (pci_slot->hotplug) {
-		dbg("%s: already claimed\n", __func__);
-		pci_destroy_slot(pci_slot);
-		return -EBUSY;
-	}
-
 	slot->pci_slot = pci_slot;
-	pci_slot->hotplug = slot;
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
index 0e009c3..0b0a79f 100644
--- a/drivers/pci/slot.c
+++ b/drivers/pci/slot.c
@@ -78,6 +78,77 @@ static struct kobj_type pci_slot_ktype = {
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
+static int rename_slot(struct pci_slot *slot, const char *name)
+{
+	int result;
+	char *slot_name;
+
+	if (strcmp(kobject_name(&slot->kobj), name) == 0)
+		return;
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
+
+static struct pci_slot *get_slot(struct pci_bus *parent, int slot_nr)
+{
+	struct pci_slot *slot;
+	/*
+	 * We already hold pci_bus_sem so don't worry
+	 */
+	list_for_each_entry(slot, &parent->slots, list)
+		if (slot->number == slot_nr) {
+			kobject_get(&slot->kobj);
+			return slot;
+		}
+
+	return NULL;
+}
+
 /**
  * pci_create_slot - create or increment refcount for physical PCI slot
  * @parent: struct pci_bus of parent bridge
@@ -90,7 +161,17 @@ static struct kobj_type pci_slot_ktype = {
  * either return a new &struct pci_slot to the caller, or if the pci_slot
  * already exists, its refcount will be incremented.
  *
- * Slots are uniquely identified by a @pci_bus, @slot_nr, @name tuple.
+ * Slots are uniquely identified by a @pci_bus, @slot_nr tuple.
+ *
+ * There are known platforms with broken firmware that assign the same
+ * name to multiple slots. Workaround these broken platforms by renaming
+ * the slots on behalf of the caller. If firmware assigns name N to
+ * multiple slots:
+ *
+ * The first slot is assigned N
+ * The second slot is assigned N-1
+ * The third slot is assigned N-2
+ * etc.
  *
  * Placeholder slots:
  * In most cases, @pci_bus, @slot_nr will be sufficient to uniquely identify
@@ -99,43 +180,43 @@ static struct kobj_type pci_slot_ktype = {
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
 				 const char *name,
 				 struct hotplug_slot *hotplug)
 {
 	struct pci_dev *dev;
 	struct pci_slot *slot;
-	int err;
+	int err = 0;
+	char *slot_name = NULL;
 
 	down_write(&pci_bus_sem);
 
 	if (slot_nr == -1)
 		goto placeholder;
 
-	/* If we've already created this slot, bump refcount and return. */
-	list_for_each_entry(slot, &parent->slots, list) {
-		if (slot->number == slot_nr) {
-			kobject_get(&slot->kobj);
-			pr_debug("%s: inc refcount to %d on %04x:%02x:%02x\n",
-				 __func__,
-				 atomic_read(&slot->kobj.kref.refcount),
-				 pci_domain_nr(parent), parent->number,
-				 slot_nr);
+	/*
+	 * Get existing slot and add hotplug callback if necessary.
+	 */
+	slot = get_slot(parent, slot_nr);
+	if (slot && hotplug) {
+		if ((err = slot->hotplug ? -EBUSY : 0)
+		     || (err = rename_slot(slot,name))) {
+			kobject_put(&slot->kobj);
+			slot = NULL;
+			goto err;
+		} else {
+			slot->hotplug = hotplug;
 			goto out;
 		}
-	}
+	} else if (slot)
+		goto out;
 
 placeholder:
 	slot = kzalloc(sizeof(*slot), GFP_KERNEL);
@@ -148,10 +229,17 @@ placeholder:
 	slot->number = slot_nr;
 
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
 
@@ -166,10 +254,10 @@ placeholder:
 	pr_debug("%s: created pci_slot on %04x:%02x:%02x\n",
 		 __func__, pci_domain_nr(parent), parent->number, slot_nr);
 
- out:
+out:
 	up_write(&pci_bus_sem);
 	return slot;
- err:
+err:
 	kfree(slot);
 	slot = ERR_PTR(err);
 	goto out;
@@ -210,7 +298,6 @@ EXPORT_SYMBOL_GPL(pci_renumber_slot);
  * just call kobject_put on its kobj and let our release methods do the
  * rest.
  */
-
 void pci_destroy_slot(struct pci_slot *slot)
 {
 	pr_debug("%s: dec refcount to %d on %04x:%02x:%02x\n", __func__,
