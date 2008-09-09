Return-Path: <linux-kernel-owner+w=401wt.eu-S1754885AbYIIKAr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754885AbYIIKAr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 06:00:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752238AbYIIKAM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 06:00:12 -0400
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:39956 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751824AbYIIKAI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 06:00:08 -0400
From: Alex Chiang <achiang@hp.com>
Subject: [PATCH v2 01/13] PCI Hotplug core: add 'name' param pci_hp_register
	interface
To: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: jbarnes@virtuousgeek.org, kristen.c.accardi@intel.com, matthew@wil.cx,
       kaneshige.kenji@jp.fujitsu.com, Alex Chiang <achiang@hp.com>
Date: Tue, 09 Sep 2008 04:00:07 -0600
Message-ID: <20080909100007.29542.27510.stgit@bob.kio>
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

Update pci_hp_register() to take a const char *name parameter.

The motivation for this is to clean up the individual hotplug
drivers so that each one does not have to manage its own name.
The PCI core should be the place where we manage the name.

We update the interface and all callsites first, in a
"no functional change" manner, and clean up the drivers later.

Cc: jbarnes@virtuousgeek.org
Cc: kristen.c.accardi@intel.com
Cc: matthew@wil.cx
Cc: kaneshige.kenji@jp.fujitsu.com
Signed-off-by: Alex Chiang <achiang@hp.com>
---

 drivers/pci/hotplug/acpiphp_core.c      |    3 ++-
 drivers/pci/hotplug/cpci_hotplug_core.c |    3 ++-
 drivers/pci/hotplug/cpqphp_core.c       |    3 ++-
 drivers/pci/hotplug/fakephp.c           |    3 ++-
 drivers/pci/hotplug/ibmphp_ebda.c       |    3 ++-
 drivers/pci/hotplug/pci_hotplug_core.c  |   15 ++++++++-------
 drivers/pci/hotplug/pciehp_core.c       |    3 ++-
 drivers/pci/hotplug/rpaphp_slot.c       |    2 +-
 drivers/pci/hotplug/sgi_hotplug.c       |    3 ++-
 drivers/pci/hotplug/shpchp_core.c       |    3 ++-
 include/linux/pci_hotplug.h             |    5 ++++-
 11 files changed, 29 insertions(+), 17 deletions(-)

diff --git a/drivers/pci/hotplug/acpiphp_core.c b/drivers/pci/hotplug/acpiphp_core.c
index 0e496e8..e984176 100644
--- a/drivers/pci/hotplug/acpiphp_core.c
+++ b/drivers/pci/hotplug/acpiphp_core.c
@@ -340,7 +340,8 @@ int acpiphp_register_hotplug_slot(struct acpiphp_slot *acpiphp_slot)
 
 	retval = pci_hp_register(slot->hotplug_slot,
 					acpiphp_slot->bridge->pci_bus,
-					acpiphp_slot->device);
+					acpiphp_slot->device,
+					slot->name);
 	if (retval == -EBUSY)
 		goto error_hpslot;
 	if (retval) {
diff --git a/drivers/pci/hotplug/cpci_hotplug_core.c b/drivers/pci/hotplug/cpci_hotplug_core.c
index 9359479..5e5dee8 100644
--- a/drivers/pci/hotplug/cpci_hotplug_core.c
+++ b/drivers/pci/hotplug/cpci_hotplug_core.c
@@ -285,7 +285,8 @@ cpci_hp_register_bus(struct pci_bus *bus, u8 first, u8 last)
 		info->attention_status = cpci_get_attention_status(slot);
 
 		dbg("registering slot %s", slot->hotplug_slot->name);
-		status = pci_hp_register(slot->hotplug_slot, bus, i);
+		status = pci_hp_register(slot->hotplug_slot, bus, i,
+					 slot->hotplug_slot->name);
 		if (status) {
 			err("pci_hp_register failed with error %d", status);
 			goto error_name;
diff --git a/drivers/pci/hotplug/cpqphp_core.c b/drivers/pci/hotplug/cpqphp_core.c
index 54defec..a7fe458 100644
--- a/drivers/pci/hotplug/cpqphp_core.c
+++ b/drivers/pci/hotplug/cpqphp_core.c
@@ -436,7 +436,8 @@ static int ctrl_slot_setup(struct controller *ctrl,
 				slot_number);
 		result = pci_hp_register(hotplug_slot,
 					 ctrl->pci_dev->subordinate,
-					 slot->device);
+					 slot->device,
+					 hotplug_slot->name);
 		if (result) {
 			err("pci_hp_register failed with error %d\n", result);
 			goto error_name;
diff --git a/drivers/pci/hotplug/fakephp.c b/drivers/pci/hotplug/fakephp.c
index 40337a0..f1c1817 100644
--- a/drivers/pci/hotplug/fakephp.c
+++ b/drivers/pci/hotplug/fakephp.c
@@ -126,7 +126,8 @@ static int add_slot(struct pci_dev *dev)
 	slot->release = &dummy_release;
 	slot->private = dslot;
 
-	retval = pci_hp_register(slot, dev->bus, PCI_SLOT(dev->devfn));
+	retval = pci_hp_register(slot, dev->bus, PCI_SLOT(dev->devfn),
+				 slot->name);
 	if (retval) {
 		err("pci_hp_register failed with error %d\n", retval);
 		goto error_dslot;
diff --git a/drivers/pci/hotplug/ibmphp_ebda.c b/drivers/pci/hotplug/ibmphp_ebda.c
index 8f286ac..85528d6 100644
--- a/drivers/pci/hotplug/ibmphp_ebda.c
+++ b/drivers/pci/hotplug/ibmphp_ebda.c
@@ -966,7 +966,8 @@ static int __init ebda_rsrc_controller (void)
 	list_for_each_entry(tmp_slot, &ibmphp_slot_head, ibm_slot_list) {
 		snprintf (tmp_slot->hotplug_slot->name, 30, "%s", create_file_name (tmp_slot));
 		pci_hp_register(tmp_slot->hotplug_slot,
-			pci_find_bus(0, tmp_slot->bus), tmp_slot->device);
+			pci_find_bus(0, tmp_slot->bus), tmp_slot->device,
+			tmp_slot->hotplug_slot->name);
 	}
 
 	print_ebda_hpc ();
diff --git a/drivers/pci/hotplug/pci_hotplug_core.c b/drivers/pci/hotplug/pci_hotplug_core.c
index 5f85b1b..3e37d63 100644
--- a/drivers/pci/hotplug/pci_hotplug_core.c
+++ b/drivers/pci/hotplug/pci_hotplug_core.c
@@ -547,13 +547,15 @@ out:
  * @bus: bus this slot is on
  * @slot: pointer to the &struct hotplug_slot to register
  * @slot_nr: slot number
+ * @name: name registered with kobject core
  *
  * Registers a hotplug slot with the pci hotplug subsystem, which will allow
  * userspace interaction to the slot.
  *
  * Returns 0 if successful, anything else for an error.
  */
-int pci_hp_register(struct hotplug_slot *slot, struct pci_bus *bus, int slot_nr)
+int pci_hp_register(struct hotplug_slot *slot, struct pci_bus *bus, int slot_nr,
+			const char *name)
 {
 	int result;
 	struct pci_slot *pci_slot;
@@ -569,7 +571,7 @@ int pci_hp_register(struct hotplug_slot *slot, struct pci_bus *bus, int slot_nr)
 	}
 
 	/* Check if we have already registered a slot with the same name. */
-	if (get_slot_from_name(slot->name))
+	if (get_slot_from_name(name))
 		return -EEXIST;
 
 	/*
@@ -577,7 +579,7 @@ int pci_hp_register(struct hotplug_slot *slot, struct pci_bus *bus, int slot_nr)
 	 * driver and call it here again. If we've already created the
 	 * pci_slot, the interface will simply bump the refcount.
 	 */
-	pci_slot = pci_create_slot(bus, slot_nr, slot->name);
+	pci_slot = pci_create_slot(bus, slot_nr, name);
 	if (IS_ERR(pci_slot))
 		return PTR_ERR(pci_slot);
 
@@ -593,8 +595,8 @@ int pci_hp_register(struct hotplug_slot *slot, struct pci_bus *bus, int slot_nr)
 	/*
 	 * Allow pcihp drivers to override the ACPI_PCI_SLOT name.
 	 */
-	if (strcmp(kobject_name(&pci_slot->kobj), slot->name)) {
-		result = kobject_rename(&pci_slot->kobj, slot->name);
+	if (strcmp(kobject_name(&pci_slot->kobj), name)) {
+		result = kobject_rename(&pci_slot->kobj, name);
 		if (result) {
 			pci_destroy_slot(pci_slot);
 			return result;
@@ -607,8 +609,7 @@ int pci_hp_register(struct hotplug_slot *slot, struct pci_bus *bus, int slot_nr)
 
 	result = fs_add_slot(pci_slot);
 	kobject_uevent(&pci_slot->kobj, KOBJ_ADD);
-	dbg("Added slot %s to the list\n", slot->name);
-
+	dbg("Added slot %s to the list\n", name);
 
 	return result;
 }
diff --git a/drivers/pci/hotplug/pciehp_core.c b/drivers/pci/hotplug/pciehp_core.c
index 4fd5355..cbd84f8 100644
--- a/drivers/pci/hotplug/pciehp_core.c
+++ b/drivers/pci/hotplug/pciehp_core.c
@@ -221,7 +221,8 @@ static int init_slots(struct controller *ctrl)
 duplicate_name:
 		retval = pci_hp_register(hotplug_slot,
 					 ctrl->pci_dev->subordinate,
-					 slot->device);
+					 slot->device,
+					 slot->name);
 		if (retval) {
 			/*
 			 * If slot N already exists, we'll try to create
diff --git a/drivers/pci/hotplug/rpaphp_slot.c b/drivers/pci/hotplug/rpaphp_slot.c
index 5088450..736d3b4 100644
--- a/drivers/pci/hotplug/rpaphp_slot.c
+++ b/drivers/pci/hotplug/rpaphp_slot.c
@@ -137,7 +137,7 @@ int rpaphp_register_slot(struct slot *slot)
 		slotno = PCI_SLOT(PCI_DN(slot->dn->child)->devfn);
 	else
 		slotno = -1;
-	retval = pci_hp_register(php_slot, slot->bus, slotno);
+	retval = pci_hp_register(php_slot, slot->bus, slotno, slot->name);
 	if (retval) {
 		err("pci_hp_register failed with error %d\n", retval);
 		return retval;
diff --git a/drivers/pci/hotplug/sgi_hotplug.c b/drivers/pci/hotplug/sgi_hotplug.c
index 410fe03..6d20bbd 100644
--- a/drivers/pci/hotplug/sgi_hotplug.c
+++ b/drivers/pci/hotplug/sgi_hotplug.c
@@ -653,7 +653,8 @@ static int sn_hotplug_slot_register(struct pci_bus *pci_bus)
 		bss_hotplug_slot->ops = &sn_hotplug_slot_ops;
 		bss_hotplug_slot->release = &sn_release_slot;
 
-		rc = pci_hp_register(bss_hotplug_slot, pci_bus, device);
+		rc = pci_hp_register(bss_hotplug_slot, pci_bus, device,
+				     bss_hotplug_slot->name);
 		if (rc)
 			goto register_err;
 
diff --git a/drivers/pci/hotplug/shpchp_core.c b/drivers/pci/hotplug/shpchp_core.c
index cc38615..bf50966 100644
--- a/drivers/pci/hotplug/shpchp_core.c
+++ b/drivers/pci/hotplug/shpchp_core.c
@@ -146,7 +146,8 @@ static int init_slots(struct controller *ctrl)
 		    slot->hp_slot, slot->number, ctrl->slot_device_offset);
 duplicate_name:
 		retval = pci_hp_register(slot->hotplug_slot,
-				ctrl->pci_dev->subordinate, slot->device);
+				ctrl->pci_dev->subordinate, slot->device,
+				hotplug_slot->name);
 		if (retval) {
 			/*
 			 * If slot N already exists, we'll try to create
diff --git a/include/linux/pci_hotplug.h b/include/linux/pci_hotplug.h
index a08cd06..303834b 100644
--- a/include/linux/pci_hotplug.h
+++ b/include/linux/pci_hotplug.h
@@ -165,7 +165,10 @@ struct hotplug_slot {
 };
 #define to_hotplug_slot(n) container_of(n, struct hotplug_slot, kobj)
 
-extern int pci_hp_register(struct hotplug_slot *, struct pci_bus *, int nr);
+extern int pci_hp_register(struct hotplug_slot *,
+			   struct pci_bus *,
+			   int nr,
+			   const char *name);
 extern int pci_hp_deregister(struct hotplug_slot *slot);
 extern int __must_check pci_hp_change_slot_info	(struct hotplug_slot *slot,
 						 struct hotplug_slot_info *info);

