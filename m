Return-Path: <linux-kernel-owner+w=401wt.eu-S1755506AbYCUE17@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755506AbYCUE17 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 00:27:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752700AbYCUE1u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 00:27:50 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:39594 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752234AbYCUE1t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 00:27:49 -0400
Message-ID: <47E336BF.1010200@jp.fujitsu.com>
Date: Fri, 21 Mar 2008 13:17:03 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
MIME-Version: 1.0
To: Alex Chiang <achiang@hp.com>, Greg KH <gregkh@suse.de>
CC: Gary Hade <garyhade@us.ibm.com>,
       Kristen Carlson Accardi <kristen.c.accardi@intel.com>,
       Matthew Wilcox <matthew@wil.cx>, warthog19@eaglescrag.net,
       rick.jones2@hp.com, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz, linux-acpi@vger.kernel.org
Subject: [PATCH 10/16] PCI slot: Replace dbg with pr_debug (Not for mainline!)
References: <20080318210539.GA30421@ldl.fc.hp.com> <47E33472.1000602@jp.fujitsu.com>
In-Reply-To: <47E33472.1000602@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The dbg() macro doesn't work because the 'pci_slot_debug' flag never
be set unless we manually modify drivers/pci/slots.c. So we should use
pr_debug() instead. This patch replaces dbg() with pr_debug().

Signed-off-by: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>

---
 drivers/pci/slot.c |   38 +++++++++++++++-----------------------
 1 file changed, 15 insertions(+), 23 deletions(-)

Index: linux-2.6.25-rc6/drivers/pci/slot.c
===================================================================
--- linux-2.6.25-rc6.orig/drivers/pci/slot.c
+++ linux-2.6.25-rc6/drivers/pci/slot.c
@@ -9,15 +9,6 @@
 #include <linux/pci.h>
 #include "pci.h"
 
-static int pci_slot_debug;
-#define MY_NAME "slot"
-#define dbg(format, arg...)					\
-	do {							\
-		if (pci_slot_debug)				\
-			printk(KERN_DEBUG "%s: " format,	\
-				MY_NAME , ## arg);		\
-	} while (0)
-
 struct kset *pci_slots_kset;
 EXPORT_SYMBOL_GPL(pci_slots_kset);
 
@@ -71,8 +62,8 @@ static void pci_slot_release(struct kobj
 {
 	struct pci_slot *slot = to_pci_slot(kobj);
 
-	dbg("%s: releasing pci_slot on %x:%d\n", __func__,
-		slot->bus->number, slot->number);
+	pr_debug("%s: releasing pci_slot on %x:%d\n", __func__,
+		 slot->bus->number, slot->number);
 
 	list_del(&slot->list);
 
@@ -109,19 +100,19 @@ int pci_slot_add_hotplug(struct pci_bus 
 	}
 
 	if (!found) {
-		dbg("%s: slot not found\n", __func__);
+		pr_debug("%s: slot not found\n", __func__);
 		retval = -EEXIST;
 		goto out;
 	}
 
 	if (slot->release) {
-		dbg("%s: already claimed\n", __func__);
+		pr_debug("%s: already claimed\n", __func__);
 		retval = -EBUSY;
 		goto out;
 	}
 
-	dbg("%s: adding release function to %x:%d\n",
-		__func__, parent->number, slot_nr);
+	pr_debug("%s: adding release function to %x:%d\n",
+		 __func__, parent->number, slot_nr);
 	slot->release = release;
  out:
 	up_write(&pci_bus_sem);
@@ -141,9 +132,10 @@ struct pci_slot *pci_create_slot(struct 
 	list_for_each_entry(slot, &parent->slots, list) {
 		if (slot->number == slot_nr) {
 			kobject_get(&slot->kobj);
-			dbg("%s: bumped refcount to %d on %x:%d\n",
-			    __func__, atomic_read(&slot->kobj.kref.refcount),
-			    parent->number, slot_nr);
+			pr_debug("%s: bumped refcount to %d on %x:%d\n",
+				 __func__,
+				 atomic_read(&slot->kobj.kref.refcount),
+				 parent->number, slot_nr);
 			goto out;
 		}
 	}
@@ -173,8 +165,8 @@ struct pci_slot *pci_create_slot(struct 
 	INIT_LIST_HEAD(&slot->list);
 	list_add(&slot->list, &parent->slots);
 
-	dbg("%s: created pci_slot on %x:%d\n",
-		__func__, parent->number, slot_nr);
+	pr_debug("%s: created pci_slot on %x:%d\n",
+		 __func__, parent->number, slot_nr);
 
  out:
 	up_write(&pci_bus_sem);
@@ -191,9 +183,9 @@ EXPORT_SYMBOL_GPL(pci_create_slot);
 
 int pci_destroy_slot(struct pci_slot *slot)
 {
-	dbg("%s: decreased refcount to %d on %x:%d\n", __func__,
-	    atomic_read(&slot->kobj.kref.refcount) - 1, slot->bus->number,
-	    slot->number);
+	pr_debug("%s: decreased refcount to %d on %x:%d\n", __func__,
+		 atomic_read(&slot->kobj.kref.refcount) - 1, slot->bus->number,
+		 slot->number);
 
 	down_write(&pci_bus_sem);
 	kobject_put(&slot->kobj);


