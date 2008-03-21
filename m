Return-Path: <linux-kernel-owner+w=401wt.eu-S1754977AbYCUEac@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754977AbYCUEac (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 00:30:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752641AbYCUEaW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 00:30:22 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:39763 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751443AbYCUEaV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 00:30:21 -0400
Message-ID: <47E33937.5050205@jp.fujitsu.com>
Date: Fri, 21 Mar 2008 13:27:35 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
MIME-Version: 1.0
To: Alex Chiang <achiang@hp.com>, Greg KH <gregkh@suse.de>
CC: Gary Hade <garyhade@us.ibm.com>,
       Kristen Carlson Accardi <kristen.c.accardi@intel.com>,
       Matthew Wilcox <matthew@wil.cx>, warthog19@eaglescrag.net,
       rick.jones2@hp.com, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz, linux-acpi@vger.kernel.org
Subject: [PATCH 16/16][BUG] PCI hotplug core: add missing lock for hotplug
 slot list (Not for mainline!)
References: <20080318210539.GA30421@ldl.fc.hp.com> <47E33472.1000602@jp.fujitsu.com>
In-Reply-To: <47E33472.1000602@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add missing lock for manipulating pci_hotplug_slot_list.

Signed-off-by: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>

---
 drivers/pci/hotplug/pci_hotplug_core.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

Index: linux-2.6.25-rc6/drivers/pci/hotplug/pci_hotplug_core.c
===================================================================
--- linux-2.6.25-rc6.orig/drivers/pci/hotplug/pci_hotplug_core.c
+++ linux-2.6.25-rc6/drivers/pci/hotplug/pci_hotplug_core.c
@@ -61,6 +61,7 @@ static int debug;
 //////////////////////////////////////////////////////////////////
 
 static LIST_HEAD(pci_hotplug_slot_list);
+static DEFINE_SPINLOCK(pci_hotplug_slot_list_lock);
 
 /* these strings match up with the values in pci_bus_speed */
 static char *pci_bus_speed_strings[] = {
@@ -529,12 +530,16 @@ static struct hotplug_slot *get_slot_fro
 	struct hotplug_slot *slot;
 	struct list_head *tmp;
 
+	spin_lock(&pci_hotplug_slot_list_lock);
 	list_for_each (tmp, &pci_hotplug_slot_list) {
 		slot = list_entry (tmp, struct hotplug_slot, slot_list);
 		if (strcmp(slot->name, name) == 0)
-			return slot;
+			goto out;
 	}
-	return NULL;
+	slot = NULL;
+out:
+	spin_unlock(&pci_hotplug_slot_list_lock);
+	return slot;
 }
 
 /**
@@ -584,7 +589,9 @@ int pci_hp_register(struct hotplug_slot 
 		}
 	}
 
+	spin_lock(&pci_hotplug_slot_list_lock);
 	list_add(&slot->slot_list, &pci_hotplug_slot_list);
+	spin_unlock(&pci_hotplug_slot_list_lock);
 
 	result = fs_add_slot(pci_slot);
 	kobject_uevent(&pci_slot->kobj, KOBJ_ADD);
@@ -613,7 +620,9 @@ int pci_hp_deregister(struct hotplug_slo
 	if (temp != hotplug)
 		return -ENODEV;
 
+	spin_lock(&pci_hotplug_slot_list_lock);
 	list_del(&hotplug->slot_list);
+	spin_unlock(&pci_hotplug_slot_list_lock);
 
 	slot = hotplug->pci_slot;
 	fs_remove_slot(slot);


