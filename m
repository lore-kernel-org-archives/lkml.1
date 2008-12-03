Return-Path: <linux-kernel-owner+w=401wt.eu-S1756658AbYLCUBi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756658AbYLCUBi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 15:01:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754397AbYLCTwW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 14:52:22 -0500
Received: from kroah.org ([198.145.64.141]:59794 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754803AbYLCTwU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 14:52:20 -0500
Date: Wed, 3 Dec 2008 11:50:44 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, kristen.c.accardi@intel.com,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Alex Chiang <achiang@hp.com>, Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [patch 028/104] PCI Hotplug core: add name param pci_hp_register
	interface
Message-ID: <20081203195044.GC8950@kroah.com>
References: <20081203193901.715896543@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="pci-hotplug-core-add-name-param-pci_hp_register-interface.patch"
In-Reply-To: <20081203194725.GA8950@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Alex Chiang <achiang@hp.com>

commit 1359f2701b96abd9bb69c1273fb995a093b6409a upstream.

Update pci_hp_register() to take a const char *name parameter.

The motivation for this is to clean up the individual hotplug
drivers so that each one does not have to manage its own name.
The PCI core should be the place where we manage the name.

We update the interface and all callsites first, in a
"no functional change" manner, and clean up the drivers later.

Cc: kristen.c.accardi@intel.com
Acked-by: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Reviewed-by: Matthew Wilcox <willy@linux.intel.com>
Signed-off-by: Alex Chiang <achiang@hp.com>
Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

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
 include/linux/pci_hotplug.h             |    3 ++-
 11 files changed, 27 insertions(+), 17 deletions(-)

--- a/drivers/pci/hotplug/acpiphp_core.c
+++ b/drivers/pci/hotplug/acpiphp_core.c
@@ -340,7 +340,8 @@ int acpiphp_register_hotplug_slot(struct
 
 	retval = pci_hp_register(slot->hotplug_slot,
 					acpiphp_slot->bridge->pci_bus,
-					acpiphp_slot->device);
+					acpiphp_slot->device,
+					slot->name);
 	if (retval == -EBUSY)
 		goto error_hpslot;
 	if (retval) {
--- a/drivers/pci/hotplug/cpci_hotplug_core.c
+++ b/drivers/pci/hotplug/cpci_hotplug_core.c
@@ -285,7 +285,8 @@ cpci_hp_register_bus(struct pci_bus *bus
 		info->attention_status = cpci_get_attention_status(slot);
 
 		dbg("registering slot %s", slot->hotplug_slot->name);
-		status = pci_hp_register(slot->hotplug_slot, bus, i);
+		status = pci_hp_register(slot->hotplug_slot, bus, i,
+					 slot->hotplug_slot->name);
 		if (status) {
 			err("pci_hp_register failed with error %d", status);
 			goto error_name;
--- a/drivers/pci/hotplug/cpqphp_core.c
+++ b/drivers/pci/hotplug/cpqphp_core.c
@@ -436,7 +436,8 @@ static int ctrl_slot_setup(struct contro
 				slot_number);
 		result = pci_hp_register(hotplug_slot,
 					 ctrl->pci_dev->bus,
-					 slot->device);
+					 slot->device,
+					 hotplug_slot->name);
 		if (result) {
 			err("pci_hp_register failed with error %d\n", result);
 			goto error_name;
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
--- a/drivers/pci/hotplug/ibmphp_ebda.c
+++ b/drivers/pci/hotplug/ibmphp_ebda.c
@@ -1002,7 +1002,8 @@ static int __init ebda_rsrc_controller (
 
 		snprintf (tmp_slot->hotplug_slot->name, 30, "%s", create_file_name (tmp_slot));
 		pci_hp_register(tmp_slot->hotplug_slot,
-			pci_find_bus(0, tmp_slot->bus), tmp_slot->device);
+			pci_find_bus(0, tmp_slot->bus), tmp_slot->device,
+			tmp_slot->hotplug_slot->name);
 	}
 
 	print_ebda_hpc ();
--- a/drivers/pci/hotplug/pciehp_core.c
+++ b/drivers/pci/hotplug/pciehp_core.c
@@ -221,7 +221,8 @@ static int init_slots(struct controller 
 duplicate_name:
 		retval = pci_hp_register(hotplug_slot,
 					 ctrl->pci_dev->subordinate,
-					 slot->device);
+					 slot->device,
+					 slot->name);
 		if (retval) {
 			/*
 			 * If slot N already exists, we'll try to create
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
@@ -569,7 +571,7 @@ int pci_hp_register(struct hotplug_slot 
 	}
 
 	/* Check if we have already registered a slot with the same name. */
-	if (get_slot_from_name(slot->name))
+	if (get_slot_from_name(name))
 		return -EEXIST;
 
 	/*
@@ -577,7 +579,7 @@ int pci_hp_register(struct hotplug_slot 
 	 * driver and call it here again. If we've already created the
 	 * pci_slot, the interface will simply bump the refcount.
 	 */
-	pci_slot = pci_create_slot(bus, slot_nr, slot->name);
+	pci_slot = pci_create_slot(bus, slot_nr, name);
 	if (IS_ERR(pci_slot))
 		return PTR_ERR(pci_slot);
 
@@ -593,8 +595,8 @@ int pci_hp_register(struct hotplug_slot 
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
@@ -607,8 +609,7 @@ int pci_hp_register(struct hotplug_slot 
 
 	result = fs_add_slot(pci_slot);
 	kobject_uevent(&pci_slot->kobj, KOBJ_ADD);
-	dbg("Added slot %s to the list\n", slot->name);
-
+	dbg("Added slot %s to the list\n", name);
 
 	return result;
 }
--- a/drivers/pci/hotplug/rpaphp_slot.c
+++ b/drivers/pci/hotplug/rpaphp_slot.c
@@ -137,7 +137,7 @@ int rpaphp_register_slot(struct slot *sl
 		slotno = PCI_SLOT(PCI_DN(slot->dn->child)->devfn);
 	else
 		slotno = -1;
-	retval = pci_hp_register(php_slot, slot->bus, slotno);
+	retval = pci_hp_register(php_slot, slot->bus, slotno, slot->name);
 	if (retval) {
 		err("pci_hp_register failed with error %d\n", retval);
 		return retval;
--- a/drivers/pci/hotplug/sgi_hotplug.c
+++ b/drivers/pci/hotplug/sgi_hotplug.c
@@ -653,7 +653,8 @@ static int sn_hotplug_slot_register(stru
 		bss_hotplug_slot->ops = &sn_hotplug_slot_ops;
 		bss_hotplug_slot->release = &sn_release_slot;
 
-		rc = pci_hp_register(bss_hotplug_slot, pci_bus, device);
+		rc = pci_hp_register(bss_hotplug_slot, pci_bus, device,
+				     bss_hotplug_slot->name);
 		if (rc)
 			goto register_err;
 
--- a/drivers/pci/hotplug/shpchp_core.c
+++ b/drivers/pci/hotplug/shpchp_core.c
@@ -146,7 +146,8 @@ static int init_slots(struct controller 
 		    slot->hp_slot, slot->number, ctrl->slot_device_offset);
 duplicate_name:
 		retval = pci_hp_register(slot->hotplug_slot,
-				ctrl->pci_dev->subordinate, slot->device);
+				ctrl->pci_dev->subordinate, slot->device,
+				hotplug_slot->name);
 		if (retval) {
 			/*
 			 * If slot N already exists, we'll try to create
--- a/include/linux/pci_hotplug.h
+++ b/include/linux/pci_hotplug.h
@@ -165,7 +165,8 @@ struct hotplug_slot {
 };
 #define to_hotplug_slot(n) container_of(n, struct hotplug_slot, kobj)
 
-extern int pci_hp_register(struct hotplug_slot *, struct pci_bus *, int nr);
+extern int pci_hp_register(struct hotplug_slot *, struct pci_bus *, int nr,
+			   const char *name);
 extern int pci_hp_deregister(struct hotplug_slot *slot);
 extern int __must_check pci_hp_change_slot_info	(struct hotplug_slot *slot,
 						 struct hotplug_slot_info *info);

