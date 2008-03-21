Return-Path: <linux-kernel-owner+w=401wt.eu-S1756032AbYCUERT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756032AbYCUERT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 00:17:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752246AbYCUEQ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 00:16:59 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:45045 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751502AbYCUEQ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 00:16:57 -0400
Message-ID: <47E335D6.5070909@jp.fujitsu.com>
Date: Fri, 21 Mar 2008 13:13:10 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
MIME-Version: 1.0
To: Alex Chiang <achiang@hp.com>, Greg KH <gregkh@suse.de>
CC: Gary Hade <garyhade@us.ibm.com>,
       Kristen Carlson Accardi <kristen.c.accardi@intel.com>,
       Matthew Wilcox <matthew@wil.cx>, warthog19@eaglescrag.net,
       rick.jones2@hp.com, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz, linux-acpi@vger.kernel.org
Subject: [PATCH  5/16] PCI slot: Use list_head for pci slot list (Not for
 mainline!)
References: <20080318210539.GA30421@ldl.fc.hp.com> <47E33472.1000602@jp.fujitsu.com>
In-Reply-To: <47E33472.1000602@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To make code simple, we should use list_head for physical slot list on
the bus.

Signed-off-by: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>

---
 drivers/acpi/pci_slot.c |    9 ++++++---
 drivers/pci/probe.c     |    1 +
 drivers/pci/slot.c      |   17 ++++++-----------
 include/linux/pci.h     |    4 ++--
 4 files changed, 15 insertions(+), 16 deletions(-)

Index: linux-2.6.25-rc6/drivers/pci/probe.c
===================================================================
--- linux-2.6.25-rc6.orig/drivers/pci/probe.c
+++ linux-2.6.25-rc6/drivers/pci/probe.c
@@ -384,6 +384,7 @@ static struct pci_bus * pci_alloc_bus(vo
 		INIT_LIST_HEAD(&b->node);
 		INIT_LIST_HEAD(&b->children);
 		INIT_LIST_HEAD(&b->devices);
+		INIT_LIST_HEAD(&b->slots);
 	}
 	return b;
 }
Index: linux-2.6.25-rc6/drivers/pci/slot.c
===================================================================
--- linux-2.6.25-rc6.orig/drivers/pci/slot.c
+++ linux-2.6.25-rc6/drivers/pci/slot.c
@@ -69,18 +69,12 @@ static int create_sysfs_files(struct pci
 
 static void pci_slot_release(struct kobject *kobj)
 {
-	struct pci_slot **pprev;
 	struct pci_slot *slot = to_pci_slot(kobj);
 
 	dbg("%s: releasing pci_slot on %x:%d\n", __func__,
 		slot->bus->number, slot->number);
 
-	for (pprev = &slot->bus->slot; *pprev; pprev = &(*pprev)->next) {
-		if (*pprev == slot) {
-			*pprev = slot->next;
-			break;
-		}
-	}
+	list_del(&slot->list);
 
 	if (slot->release)
 		slot->release(slot);
@@ -107,11 +101,12 @@ int pci_slot_add_hotplug(struct pci_bus 
 	/* This slot should have already been created, so look for it. If
 	 * we can't find it, return -EEXIST.
 	 */
-	for (slot = parent->slot; slot; slot = slot->next)
+	list_for_each_entry(slot, &parent->slots, list) {
 		if (slot->number == slot_nr) {
 			found = 1;
 			break;
 		}
+	}
 
 	if (!found) {
 		dbg("%s: slot not found\n", __func__);
@@ -143,7 +138,7 @@ struct pci_slot *pci_create_slot(struct 
 	down_write(&pci_bus_sem);
 
 	/* If we've already created this slot, bump refcount and return. */
-	for (slot = parent->slot; slot; slot = slot->next) {
+	list_for_each_entry(slot, &parent->slots, list) {
 		if (slot->number == slot_nr) {
 			kobject_get(&slot->kobj);
 			dbg("%s: bumped refcount to %d on %x:%d\n",
@@ -175,8 +170,8 @@ struct pci_slot *pci_create_slot(struct 
 	if (err)
 		goto unregister;
 
-	slot->next = parent->slot;
-	parent->slot = slot;
+	INIT_LIST_HEAD(&slot->list);
+	list_add(&slot->list, &parent->slots);
 
 	dbg("%s: created pci_slot on %x:%d\n",
 		__func__, parent->number, slot_nr);
Index: linux-2.6.25-rc6/include/linux/pci.h
===================================================================
--- linux-2.6.25-rc6.orig/include/linux/pci.h
+++ linux-2.6.25-rc6/include/linux/pci.h
@@ -131,7 +131,7 @@ struct pci_cap_saved_state {
 /* pci_slot represents a physical slot */
 struct pci_slot {
 	struct pci_bus *bus;		/* The bus this slot is on */
-	struct pci_slot *next;		/* Next slot on this bus */
+	struct list_head list;		/* node in list of slots on this bus */
 	struct hotplug_slot *hotplug;	/* Hotplug info (migrate over time) */
 	unsigned char number;		/* PCI_SLOT(pci_dev->devfn) */
 	struct kobject kobj;
@@ -269,7 +269,7 @@ struct pci_bus {
 	struct list_head children;	/* list of child buses */
 	struct list_head devices;	/* list of devices on this bus */
 	struct pci_dev	*self;		/* bridge device as seen by parent */
-	struct pci_slot	*slot;		/* First physical slot on this bus */
+	struct list_head slots;		/* list of slots on this bus */
 	struct resource	*resource[PCI_BUS_NUM_RESOURCES];
 					/* address space routed to this bus */
 
Index: linux-2.6.25-rc6/drivers/acpi/pci_slot.c
===================================================================
--- linux-2.6.25-rc6.orig/drivers/acpi/pci_slot.c
+++ linux-2.6.25-rc6/drivers/acpi/pci_slot.c
@@ -117,15 +117,18 @@ unregister_slot(acpi_handle handle, u32 
 {
 	int device;
 	unsigned long sun;
-	struct pci_slot *slot;
+	struct pci_slot *slot, *tmp;
 	struct pci_bus *pci_bus = context;
 
 	if (check_slot(handle, &device, &sun))
 		return AE_OK;
 
-	for (slot = pci_bus->slot; slot; slot = slot->next) {
-		if (slot->number == device)
+	/* FIXME - Need pci_bus_sem to be held */
+	list_for_each_entry_safe(slot, tmp, &pci_bus->slots, list) {
+		if (slot->number == device) {
 			pci_destroy_slot(slot);
+			break;
+		}
 	}
 
 	return AE_OK;


