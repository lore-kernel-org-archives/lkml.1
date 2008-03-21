Return-Path: <linux-kernel-owner+w=401wt.eu-S1753739AbYCUEUk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753739AbYCUEUk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 00:20:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752246AbYCUEUN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 00:20:13 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:39268 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751126AbYCUEUK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 00:20:10 -0400
Message-ID: <47E336FA.2060104@jp.fujitsu.com>
Date: Fri, 21 Mar 2008 13:18:02 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
MIME-Version: 1.0
To: Alex Chiang <achiang@hp.com>, Greg KH <gregkh@suse.de>
CC: Gary Hade <garyhade@us.ibm.com>,
       Kristen Carlson Accardi <kristen.c.accardi@intel.com>,
       Matthew Wilcox <matthew@wil.cx>, warthog19@eaglescrag.net,
       rick.jones2@hp.com, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz, linux-acpi@vger.kernel.org
Subject: [PATCH 11/16] PCI slot: Remove useless release handler (Not for mainline!)
References: <20080318210539.GA30421@ldl.fc.hp.com> <47E33472.1000602@jp.fujitsu.com>
In-Reply-To: <47E33472.1000602@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The release() handler of struct pci_slot never be called because
pci_hp_deregister() calls pci_slot_destroy() after setting
slot->release with NULL. So we don't need release() handler of struct
pci_slot. In addition, we don't need pci_slot_add_hotplug().

Signed-off-by: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>

---
 drivers/pci/hotplug/pci_hotplug_core.c |   15 -----------
 drivers/pci/slot.c                     |   44 ---------------------------------
 include/linux/pci.h                    |    3 --
 3 files changed, 1 insertion(+), 61 deletions(-)

Index: linux-2.6.25-rc6/drivers/pci/slot.c
===================================================================
--- linux-2.6.25-rc6.orig/drivers/pci/slot.c
+++ linux-2.6.25-rc6/drivers/pci/slot.c
@@ -67,9 +67,6 @@ static void pci_slot_release(struct kobj
 
 	list_del(&slot->list);
 
-	if (slot->release)
-		slot->release(slot);
-
 	remove_sysfs_files(slot);
 	kfree(slot);
 }
@@ -79,47 +76,6 @@ static struct kobj_type pci_slot_ktype =
 	.release = &pci_slot_release,
 };
 
-int pci_slot_add_hotplug(struct pci_bus *parent, int slot_nr,
-			 void (*release)(struct pci_slot *))
-{
-	struct pci_slot *slot;
-	int retval, found;
-
-	retval = found = 0;
-
-	down_write(&pci_bus_sem);
-
-	/* This slot should have already been created, so look for it. If
-	 * we can't find it, return -EEXIST.
-	 */
-	list_for_each_entry(slot, &parent->slots, list) {
-		if (slot->number == slot_nr) {
-			found = 1;
-			break;
-		}
-	}
-
-	if (!found) {
-		pr_debug("%s: slot not found\n", __func__);
-		retval = -EEXIST;
-		goto out;
-	}
-
-	if (slot->release) {
-		pr_debug("%s: already claimed\n", __func__);
-		retval = -EBUSY;
-		goto out;
-	}
-
-	pr_debug("%s: adding release function to %x:%d\n",
-		 __func__, parent->number, slot_nr);
-	slot->release = release;
- out:
-	up_write(&pci_bus_sem);
-	return retval;
-}
-EXPORT_SYMBOL_GPL(pci_slot_add_hotplug);
-
 struct pci_slot *pci_create_slot(struct pci_bus *parent, int slot_nr,
 				 const char *name)
 {
Index: linux-2.6.25-rc6/include/linux/pci.h
===================================================================
--- linux-2.6.25-rc6.orig/include/linux/pci.h
+++ linux-2.6.25-rc6/include/linux/pci.h
@@ -135,7 +135,6 @@ struct pci_slot {
 	struct hotplug_slot *hotplug;	/* Hotplug info (migrate over time) */
 	unsigned char number;		/* PCI_SLOT(pci_dev->devfn) */
 	struct kobject kobj;
-	void (*release)(struct pci_slot *);
 };
 
 /*
@@ -494,8 +493,6 @@ struct pci_bus *pci_add_new_bus(struct p
 				int busnr);
 struct pci_slot *pci_create_slot(struct pci_bus *parent, int slot_nr,
 				 const char *name);
-int pci_slot_add_hotplug(struct pci_bus *parent, int slot_nr,
-			 void (*release)(struct pci_slot *));
 int pci_destroy_slot(struct pci_slot *slot);
 int pci_scan_slot(struct pci_bus *bus, int devfn);
 struct pci_dev *pci_scan_single_device(struct pci_bus *bus, int devfn);
Index: linux-2.6.25-rc6/drivers/pci/hotplug/pci_hotplug_core.c
===================================================================
--- linux-2.6.25-rc6.orig/drivers/pci/hotplug/pci_hotplug_core.c
+++ linux-2.6.25-rc6/drivers/pci/hotplug/pci_hotplug_core.c
@@ -537,12 +537,6 @@ static struct hotplug_slot *get_slot_fro
 	return NULL;
 }
 
-static void hotplug_release(struct pci_slot *slot)
-{
-	struct hotplug_slot *hotplug = slot->hotplug;
-	hotplug->release(hotplug);
-}
-
 /**
  * pci_hp_register - register a hotplug_slot with the PCI hotplug subsystem
  * @slot: pointer to the &struct hotplug_slot to register
@@ -576,12 +570,6 @@ int pci_hp_register(struct hotplug_slot 
 	if (IS_ERR(pci_slot))
 		return PTR_ERR(pci_slot);
 
-	result = pci_slot_add_hotplug(bus, slot_nr, hotplug_release);
-	if (result) {
-		pci_destroy_slot(pci_slot);
-		return result;
-	}
-
 	slot->pci_slot = pci_slot;
 	pci_slot->hotplug = slot;
 
@@ -631,8 +619,7 @@ int pci_hp_deregister(struct hotplug_slo
 	fs_remove_slot(slot);
 	dbg("Removed slot %s from the list\n", hotplug->name);
 
-	hotplug_release(slot);
-	slot->release = NULL;
+	hotplug->release(hotplug);
 	pci_destroy_slot(slot);
 
 	return 0;


