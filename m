Return-Path: <linux-kernel-owner+w=401wt.eu-S1757251AbYIIKDl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757251AbYIIKDl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 06:03:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755473AbYIIKAz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 06:00:55 -0400
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:32991 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755366AbYIIKAx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 06:00:53 -0400
From: Alex Chiang <achiang@hp.com>
Subject: [PATCH v2 10/13] PCI: rpaphp: stop managing hotplug_slot->name
To: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: jbarnes@virtuousgeek.org, kristen.c.accardi@intel.com,
       benh@kernel.crashing.org, Alex Chiang <achiang@hp.com>
Date: Tue, 09 Sep 2008 04:00:52 -0600
Message-ID: <20080909100052.29542.19510.stgit@bob.kio>
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

We no longer need to manage our version of hotplug_slot->name
since the PCI and hotplug core manage it on our behalf.

This means that alloc_slot_struct() no longer needs to take
a 'name' param. On the other hand, we give rpaphp_register_slot()
a 'name' param now to simplify the hotplug registration process.
rpaphp_register_slot() can directly pass the drc_name to the
PCI hotplug core.

Cc: jbarnes@virtuousgeek.org
Cc: kristen.c.accardi@intel.com
Cc: benh@kernel.crashing.org
Signed-off-by: Alex Chiang <achiang@hp.com>
---

 drivers/pci/hotplug/rpaphp.h      |   10 +++++++---
 drivers/pci/hotplug/rpaphp_core.c |    6 +++---
 drivers/pci/hotplug/rpaphp_pci.c  |    4 ++--
 drivers/pci/hotplug/rpaphp_slot.c |   26 +++++++++-----------------
 4 files changed, 21 insertions(+), 25 deletions(-)

diff --git a/drivers/pci/hotplug/rpaphp.h b/drivers/pci/hotplug/rpaphp.h
index 7d5921b..12f8aa7 100644
--- a/drivers/pci/hotplug/rpaphp.h
+++ b/drivers/pci/hotplug/rpaphp.h
@@ -73,13 +73,17 @@ struct slot {
 	u32 index;
 	u32 type;
 	u32 power_domain;
-	char *name;
 	struct device_node *dn;
 	struct pci_bus *bus;
 	struct list_head *pci_devs;
 	struct hotplug_slot *hotplug_slot;
 };
 
+static inline const char *slot_name(struct slot *slot)
+{
+	return hotplug_slot_name(slot->hotplug_slot);
+}
+
 extern struct hotplug_slot_ops rpaphp_hotplug_slot_ops;
 extern struct list_head rpaphp_slot_head;
 
@@ -96,8 +100,8 @@ extern int rpaphp_get_drc_props(struct device_node *dn, int *drc_index,
 
 /* rpaphp_slot.c */
 extern void dealloc_slot_struct(struct slot *slot);
-extern struct slot *alloc_slot_struct(struct device_node *dn, int drc_index, char *drc_name, int power_domain);
-extern int rpaphp_register_slot(struct slot *slot);
+extern struct slot *alloc_slot_struct(struct device_node *dn, int drc_index, int power_domain);
+extern int rpaphp_register_slot(struct slot *slot, const char *name);
 extern int rpaphp_deregister_slot(struct slot *slot);
 	
 #endif				/* _PPC64PHP_H */
diff --git a/drivers/pci/hotplug/rpaphp_core.c b/drivers/pci/hotplug/rpaphp_core.c
index 1f84f40..c989005 100644
--- a/drivers/pci/hotplug/rpaphp_core.c
+++ b/drivers/pci/hotplug/rpaphp_core.c
@@ -324,7 +324,7 @@ int rpaphp_add_slot(struct device_node *dn)
 	type = (char *) &types[1];
 	for (i = 0; i < indexes[0]; i++) {
 
-		slot = alloc_slot_struct(dn, indexes[i + 1], name, power_domains[i + 1]);
+		slot = alloc_slot_struct(dn, indexes[i + 1], power_domains[i + 1]);
 		if (!slot)
 			return -ENOMEM;
 
@@ -335,7 +335,7 @@ int rpaphp_add_slot(struct device_node *dn)
 
 		retval = rpaphp_enable_slot(slot);
 		if (!retval)
-			retval = rpaphp_register_slot(slot);
+			retval = rpaphp_register_slot(slot, name);
 
 		if (retval)
 			dealloc_slot_struct(slot);
@@ -404,7 +404,7 @@ static int enable_slot(struct hotplug_slot *hotplug_slot)
 	} else if (state == EMPTY) {
 		slot->state = EMPTY;
 	} else {
-		err("%s: slot[%s] is in invalid state\n", __func__, slot->name);
+		err("%s: slot[%s] is in invalid state\n", __func__, slot_name(slot));
 		slot->state = NOT_VALID;
 		return -EINVAL;
 	}
diff --git a/drivers/pci/hotplug/rpaphp_pci.c b/drivers/pci/hotplug/rpaphp_pci.c
index 5acfd4f..46eed88 100644
--- a/drivers/pci/hotplug/rpaphp_pci.c
+++ b/drivers/pci/hotplug/rpaphp_pci.c
@@ -51,7 +51,7 @@ int rpaphp_get_sensor_state(struct slot *slot, int *state)
 						  &setlevel);
 			if (rc < 0) {
 				dbg("%s: power on slot[%s] failed rc=%d.\n",
-				    __func__, slot->name, rc);
+				    __func__, slot_name(slot), rc);
 			} else {
 				rc = rtas_get_sensor(DR_ENTITY_SENSE,
 						     slot->index, state);
@@ -111,7 +111,7 @@ int rpaphp_enable_slot(struct slot *slot)
 		/* non-empty slot has to have child */
 		if (!slot->dn->child) {
 			err("%s: slot[%s]'s device_node doesn't have child for adapter\n",
-			    __func__, slot->name);
+			    __func__, slot_name(slot));
 			return -EINVAL;
 		}
 
diff --git a/drivers/pci/hotplug/rpaphp_slot.c b/drivers/pci/hotplug/rpaphp_slot.c
index 736d3b4..2d167c3 100644
--- a/drivers/pci/hotplug/rpaphp_slot.c
+++ b/drivers/pci/hotplug/rpaphp_slot.c
@@ -43,13 +43,12 @@ static void rpaphp_release_slot(struct hotplug_slot *hotplug_slot)
 void dealloc_slot_struct(struct slot *slot)
 {
 	kfree(slot->hotplug_slot->info);
-	kfree(slot->hotplug_slot->name);
 	kfree(slot->hotplug_slot);
 	kfree(slot);
 }
 
 struct slot *alloc_slot_struct(struct device_node *dn,
-                       int drc_index, char *drc_name, int power_domain)
+			int drc_index, int power_domain)
 {
 	struct slot *slot;
 	
@@ -63,11 +62,6 @@ struct slot *alloc_slot_struct(struct device_node *dn,
 					   GFP_KERNEL);
 	if (!slot->hotplug_slot->info)
 		goto error_hpslot;
-	slot->hotplug_slot->name = kmalloc(strlen(drc_name) + 1, GFP_KERNEL);
-	if (!slot->hotplug_slot->name)
-		goto error_info;	
-	slot->name = slot->hotplug_slot->name;
-	strcpy(slot->name, drc_name);
 	slot->dn = dn;
 	slot->index = drc_index;
 	slot->power_domain = power_domain;
@@ -77,8 +71,6 @@ struct slot *alloc_slot_struct(struct device_node *dn,
 	
 	return (slot);
 
-error_info:
-	kfree(slot->hotplug_slot->info);
 error_hpslot:
 	kfree(slot->hotplug_slot);
 error_slot:
@@ -92,7 +84,7 @@ static int is_registered(struct slot *slot)
 	struct slot *tmp_slot;
 
 	list_for_each_entry(tmp_slot, &rpaphp_slot_head, rpaphp_slot_list) {
-		if (!strcmp(tmp_slot->name, slot->name))
+		if (!strcmp(slot_name(tmp_slot), slot_name(slot)))
 			return 1;
 	}	
 	return 0;
@@ -104,32 +96,32 @@ int rpaphp_deregister_slot(struct slot *slot)
 	struct hotplug_slot *php_slot = slot->hotplug_slot;
 
 	 dbg("%s - Entry: deregistering slot=%s\n",
-		__func__, slot->name);
+		__func__, slot_name(slot));
 
 	list_del(&slot->rpaphp_slot_list);
 	
 	retval = pci_hp_deregister(php_slot);
 	if (retval)
-		err("Problem unregistering a slot %s\n", slot->name);
+		err("Problem unregistering a slot %s\n", slot_name(slot));
 
 	dbg("%s - Exit: rc[%d]\n", __func__, retval);
 	return retval;
 }
 EXPORT_SYMBOL_GPL(rpaphp_deregister_slot);
 
-int rpaphp_register_slot(struct slot *slot)
+int rpaphp_register_slot(struct slot *slot, const char *name)
 {
 	struct hotplug_slot *php_slot = slot->hotplug_slot;
 	int retval;
 	int slotno;
 
 	dbg("%s registering slot:path[%s] index[%x], name[%s] pdomain[%x] type[%d]\n", 
-		__func__, slot->dn->full_name, slot->index, slot->name,
+		__func__, slot->dn->full_name, slot->index, slot_name(slot),
 		slot->power_domain, slot->type);
 
 	/* should not try to register the same slot twice */
 	if (is_registered(slot)) {
-		err("rpaphp_register_slot: slot[%s] is already registered\n", slot->name);
+		err("rpaphp_register_slot: slot[%s] is already registered\n", slot_name(slot));
 		return -EAGAIN;
 	}	
 
@@ -137,7 +129,7 @@ int rpaphp_register_slot(struct slot *slot)
 		slotno = PCI_SLOT(PCI_DN(slot->dn->child)->devfn);
 	else
 		slotno = -1;
-	retval = pci_hp_register(php_slot, slot->bus, slotno, slot->name);
+	retval = pci_hp_register(php_slot, slot->bus, slotno, name);
 	if (retval) {
 		err("pci_hp_register failed with error %d\n", retval);
 		return retval;
@@ -145,7 +137,7 @@ int rpaphp_register_slot(struct slot *slot)
 
 	/* add slot to our internal list */
 	list_add(&slot->rpaphp_slot_list, &rpaphp_slot_head);
-	info("Slot [%s] registered\n", slot->name);
+	info("Slot [%s] registered\n", name);
 	return 0;
 }
 

