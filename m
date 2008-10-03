Return-Path: <linux-kernel-owner+w=401wt.eu-S1755002AbYJCXTh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755002AbYJCXTh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 19:19:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754506AbYJCXSD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 19:18:03 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:3417 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753480AbYJCXR7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 19:17:59 -0400
From: Alex Chiang <achiang@hp.com>
Subject: [PATCH v4 06/15] PCI: cpci_hotplug: stop managing hotplug_slot->name
To: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: jbarnes@virtuousgeek.org, kristen.c.accardi@intel.com,
       scottm@somanetworks.com, Alex Chiang <achiang@hp.com>
Date: Fri, 03 Oct 2008 17:17:57 -0600
Message-ID: <20081003231757.9989.9590.stgit@bob.kio>
In-Reply-To: <20081003230125.9989.31145.stgit@bob.kio>
References: <20081003230125.9989.31145.stgit@bob.kio>
User-Agent: StGIT/0.14.3.215.gff3d
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We no longer need to manage our version of hotplug_slot->name
since the PCI and hotplug core manage it on our behalf.

Now, we simply advise the PCI core of the name that we would
like, and let the core take care of the rest.

Cc: jbarnes@virtuousgeek.org
Cc: kristen.c.accardi@intel.com
Cc: scottm@somanetworks.com
Signed-off-by: Alex Chiang <achiang@hp.com>
---

 drivers/pci/hotplug/cpci_hotplug.h      |    6 ++
 drivers/pci/hotplug/cpci_hotplug_core.c |   76 ++++++++++++-------------------
 drivers/pci/hotplug/cpci_hotplug_pci.c  |    4 +-
 3 files changed, 37 insertions(+), 49 deletions(-)

diff --git a/drivers/pci/hotplug/cpci_hotplug.h b/drivers/pci/hotplug/cpci_hotplug.h
index d9769b3..9fff878 100644
--- a/drivers/pci/hotplug/cpci_hotplug.h
+++ b/drivers/pci/hotplug/cpci_hotplug.h
@@ -30,6 +30,7 @@
 
 #include <linux/types.h>
 #include <linux/pci.h>
+#include <linux/pci_hotplug.h>
 
 /* PICMG 2.1 R2.0 HS CSR bits: */
 #define HS_CSR_INS	0x0080
@@ -69,6 +70,11 @@ struct cpci_hp_controller {
 	struct cpci_hp_controller_ops *ops;
 };
 
+static inline const char *slot_name(struct slot *slot)
+{
+	return hotplug_slot_name(slot->hotplug_slot);
+}
+
 extern int cpci_hp_register_controller(struct cpci_hp_controller *controller);
 extern int cpci_hp_unregister_controller(struct cpci_hp_controller *controller);
 extern int cpci_hp_register_bus(struct pci_bus *bus, u8 first, u8 last);
diff --git a/drivers/pci/hotplug/cpci_hotplug_core.c b/drivers/pci/hotplug/cpci_hotplug_core.c
index 5e5dee8..de94f4f 100644
--- a/drivers/pci/hotplug/cpci_hotplug_core.c
+++ b/drivers/pci/hotplug/cpci_hotplug_core.c
@@ -108,7 +108,7 @@ enable_slot(struct hotplug_slot *hotplug_slot)
 	struct slot *slot = hotplug_slot->private;
 	int retval = 0;
 
-	dbg("%s - physical_slot = %s", __func__, hotplug_slot->name);
+	dbg("%s - physical_slot = %s", __func__, slot_name(slot));
 
 	if (controller->ops->set_power)
 		retval = controller->ops->set_power(slot, 1);
@@ -121,25 +121,23 @@ disable_slot(struct hotplug_slot *hotplug_slot)
 	struct slot *slot = hotplug_slot->private;
 	int retval = 0;
 
-	dbg("%s - physical_slot = %s", __func__, hotplug_slot->name);
+	dbg("%s - physical_slot = %s", __func__, slot_name(slot));
 
 	down_write(&list_rwsem);
 
 	/* Unconfigure device */
-	dbg("%s - unconfiguring slot %s",
-	    __func__, slot->hotplug_slot->name);
+	dbg("%s - unconfiguring slot %s", __func__, slot_name(slot));
 	if ((retval = cpci_unconfigure_slot(slot))) {
 		err("%s - could not unconfigure slot %s",
-		    __func__, slot->hotplug_slot->name);
+		    __func__, slot_name(slot));
 		goto disable_error;
 	}
-	dbg("%s - finished unconfiguring slot %s",
-	    __func__, slot->hotplug_slot->name);
+	dbg("%s - finished unconfiguring slot %s", __func__, slot_name(slot));
 
 	/* Clear EXT (by setting it) */
 	if (cpci_clear_ext(slot)) {
 		err("%s - could not clear EXT for slot %s",
-		    __func__, slot->hotplug_slot->name);
+		    __func__, slot_name(slot));
 		retval = -ENODEV;
 		goto disable_error;
 	}
@@ -214,7 +212,6 @@ static void release_slot(struct hotplug_slot *hotplug_slot)
 	struct slot *slot = hotplug_slot->private;
 
 	kfree(slot->hotplug_slot->info);
-	kfree(slot->hotplug_slot->name);
 	kfree(slot->hotplug_slot);
 	if (slot->dev)
 		pci_dev_put(slot->dev);
@@ -222,12 +219,6 @@ static void release_slot(struct hotplug_slot *hotplug_slot)
 }
 
 #define SLOT_NAME_SIZE	6
-static void
-make_slot_name(struct slot *slot)
-{
-	snprintf(slot->hotplug_slot->name,
-		 SLOT_NAME_SIZE, "%02x:%02x", slot->bus->number, slot->number);
-}
 
 int
 cpci_hp_register_bus(struct pci_bus *bus, u8 first, u8 last)
@@ -235,7 +226,7 @@ cpci_hp_register_bus(struct pci_bus *bus, u8 first, u8 last)
 	struct slot *slot;
 	struct hotplug_slot *hotplug_slot;
 	struct hotplug_slot_info *info;
-	char *name;
+	char name[SLOT_NAME_SIZE];
 	int status = -ENOMEM;
 	int i;
 
@@ -262,35 +253,31 @@ cpci_hp_register_bus(struct pci_bus *bus, u8 first, u8 last)
 			goto error_hpslot;
 		hotplug_slot->info = info;
 
-		name = kmalloc(SLOT_NAME_SIZE, GFP_KERNEL);
-		if (!name)
-			goto error_info;
-		hotplug_slot->name = name;
-
 		slot->bus = bus;
 		slot->number = i;
 		slot->devfn = PCI_DEVFN(i, 0);
 
+		snprintf(name, SLOT_NAME_SIZE, "%02x:%02x", bus->number, i);
+
 		hotplug_slot->private = slot;
 		hotplug_slot->release = &release_slot;
-		make_slot_name(slot);
 		hotplug_slot->ops = &cpci_hotplug_slot_ops;
 
 		/*
 		 * Initialize the slot info structure with some known
 		 * good values.
 		 */
-		dbg("initializing slot %s", slot->hotplug_slot->name);
+		dbg("initializing slot %s", name);
 		info->power_status = cpci_get_power_status(slot);
 		info->attention_status = cpci_get_attention_status(slot);
 
-		dbg("registering slot %s", slot->hotplug_slot->name);
-		status = pci_hp_register(slot->hotplug_slot, bus, i,
-					 slot->hotplug_slot->name);
+		dbg("registering slot %s", name);
+		status = pci_hp_register(slot->hotplug_slot, bus, i, name);
 		if (status) {
 			err("pci_hp_register failed with error %d", status);
-			goto error_name;
+			goto error_info;
 		}
+		dbg("slot registered with name: %s", slot_name(slot));
 
 		/* Add slot to our internal list */
 		down_write(&list_rwsem);
@@ -299,8 +286,6 @@ cpci_hp_register_bus(struct pci_bus *bus, u8 first, u8 last)
 		up_write(&list_rwsem);
 	}
 	return 0;
-error_name:
-	kfree(name);
 error_info:
 	kfree(info);
 error_hpslot:
@@ -328,7 +313,7 @@ cpci_hp_unregister_bus(struct pci_bus *bus)
 			list_del(&slot->slot_list);
 			slots--;
 
-			dbg("deregistering slot %s", slot->hotplug_slot->name);
+			dbg("deregistering slot %s", slot_name(slot));
 			status = pci_hp_deregister(slot->hotplug_slot);
 			if (status) {
 				err("pci_hp_deregister failed with error %d",
@@ -380,11 +365,10 @@ init_slots(int clear_ins)
 		return -1;
 	}
 	list_for_each_entry(slot, &slot_list, slot_list) {
-		dbg("%s - looking at slot %s",
-		    __func__, slot->hotplug_slot->name);
+		dbg("%s - looking at slot %s", __func__, slot_name(slot));
 		if (clear_ins && cpci_check_and_clear_ins(slot))
 			dbg("%s - cleared INS for slot %s",
-			    __func__, slot->hotplug_slot->name);
+			    __func__, slot_name(slot));
 		dev = pci_get_slot(slot->bus, PCI_DEVFN(slot->number, 0));
 		if (dev) {
 			if (update_adapter_status(slot->hotplug_slot, 1))
@@ -415,8 +399,7 @@ check_slots(void)
 	}
 	extracted = inserted = 0;
 	list_for_each_entry(slot, &slot_list, slot_list) {
-		dbg("%s - looking at slot %s",
-		    __func__, slot->hotplug_slot->name);
+		dbg("%s - looking at slot %s", __func__, slot_name(slot));
 		if (cpci_check_and_clear_ins(slot)) {
 			/*
 			 * Some broken hardware (e.g. PLX 9054AB) asserts
@@ -424,35 +407,34 @@ check_slots(void)
 			 */
 			if (slot->dev) {
 				warn("slot %s already inserted",
-				     slot->hotplug_slot->name);
+				     slot_name(slot));
 				inserted++;
 				continue;
 			}
 
 			/* Process insertion */
-			dbg("%s - slot %s inserted",
-			    __func__, slot->hotplug_slot->name);
+			dbg("%s - slot %s inserted", __func__, slot_name(slot));
 
 			/* GSM, debug */
 			hs_csr = cpci_get_hs_csr(slot);
 			dbg("%s - slot %s HS_CSR (1) = %04x",
-			    __func__, slot->hotplug_slot->name, hs_csr);
+			    __func__, slot_name(slot), hs_csr);
 
 			/* Configure device */
 			dbg("%s - configuring slot %s",
-			    __func__, slot->hotplug_slot->name);
+			    __func__, slot_name(slot));
 			if (cpci_configure_slot(slot)) {
 				err("%s - could not configure slot %s",
-				    __func__, slot->hotplug_slot->name);
+				    __func__, slot_name(slot));
 				continue;
 			}
 			dbg("%s - finished configuring slot %s",
-			    __func__, slot->hotplug_slot->name);
+			    __func__, slot_name(slot));
 
 			/* GSM, debug */
 			hs_csr = cpci_get_hs_csr(slot);
 			dbg("%s - slot %s HS_CSR (2) = %04x",
-			    __func__, slot->hotplug_slot->name, hs_csr);
+			    __func__, slot_name(slot), hs_csr);
 
 			if (update_latch_status(slot->hotplug_slot, 1))
 				warn("failure to update latch file");
@@ -465,18 +447,18 @@ check_slots(void)
 			/* GSM, debug */
 			hs_csr = cpci_get_hs_csr(slot);
 			dbg("%s - slot %s HS_CSR (3) = %04x",
-			    __func__, slot->hotplug_slot->name, hs_csr);
+			    __func__, slot_name(slot), hs_csr);
 
 			inserted++;
 		} else if (cpci_check_ext(slot)) {
 			/* Process extraction request */
 			dbg("%s - slot %s extracted",
-			    __func__, slot->hotplug_slot->name);
+			    __func__, slot_name(slot));
 
 			/* GSM, debug */
 			hs_csr = cpci_get_hs_csr(slot);
 			dbg("%s - slot %s HS_CSR = %04x",
-			    __func__, slot->hotplug_slot->name, hs_csr);
+			    __func__, slot_name(slot), hs_csr);
 
 			if (!slot->extracting) {
 				if (update_latch_status(slot->hotplug_slot, 0)) {
@@ -494,7 +476,7 @@ check_slots(void)
 				 * bother trying to tell the driver or not?
 				 */
 				err("card in slot %s was improperly removed",
-				    slot->hotplug_slot->name);
+				    slot_name(slot));
 				if (update_adapter_status(slot->hotplug_slot, 0))
 					warn("failure to update adapter file");
 				slot->extracting = 0;
diff --git a/drivers/pci/hotplug/cpci_hotplug_pci.c b/drivers/pci/hotplug/cpci_hotplug_pci.c
index df82b95..829c327 100644
--- a/drivers/pci/hotplug/cpci_hotplug_pci.c
+++ b/drivers/pci/hotplug/cpci_hotplug_pci.c
@@ -209,7 +209,7 @@ int cpci_led_on(struct slot* slot)
 					      hs_cap + 2,
 					      hs_csr)) {
 			err("Could not set LOO for slot %s",
-			    slot->hotplug_slot->name);
+			    hotplug_slot_name(slot->hotplug_slot));
 			return -ENODEV;
 		}
 	}
@@ -238,7 +238,7 @@ int cpci_led_off(struct slot* slot)
 					      hs_cap + 2,
 					      hs_csr)) {
 			err("Could not clear LOO for slot %s",
-			    slot->hotplug_slot->name);
+			    hotplug_slot_name(slot->hotplug_slot));
 			return -ENODEV;
 		}
 	}

