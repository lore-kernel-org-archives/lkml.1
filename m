Return-Path: <linux-kernel-owner+w=401wt.eu-S1754742AbYJHGgA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754742AbYJHGgA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 02:36:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751723AbYJHGfy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 02:35:54 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:37892 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751314AbYJHGfx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 02:35:53 -0400
Message-ID: <48EC5452.8050009@jp.fujitsu.com>
Date: Wed, 08 Oct 2008 15:33:54 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Alex Chiang <achiang@hp.com>
CC: jbarnes@virtuousgeek.org, kristen.c.accardi@intel.com, matthew@wil.cx,
       linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [01/03] Sample patch for [PATCH v4 02/15] 
References: <20081003230125.9989.31145.stgit@bob.kio> <48EC53D3.9020203@jp.fujitsu.com>
In-Reply-To: <48EC53D3.9020203@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 drivers/pci/hotplug/pci_hotplug_core.c |   49 +++++++++++++++++----------------
 1 file changed, 26 insertions(+), 23 deletions(-)

Index: hotplug/drivers/pci/hotplug/pci_hotplug_core.c
===================================================================
--- hotplug.orig/drivers/pci/hotplug/pci_hotplug_core.c
+++ hotplug/drivers/pci/hotplug/pci_hotplug_core.c
@@ -37,6 +37,7 @@
 #include <linux/init.h>
 #include <linux/mount.h>
 #include <linux/namei.h>
+#include <linux/mutex.h>
 #include <linux/pci.h>
 #include <linux/pci_hotplug.h>
 #include <asm/uaccess.h>
@@ -61,7 +62,7 @@ static int debug;
 //////////////////////////////////////////////////////////////////
 
 static LIST_HEAD(pci_hotplug_slot_list);
-static DEFINE_SPINLOCK(pci_hotplug_slot_list_lock);
+static DEFINE_MUTEX(pci_hp_mutex);
 
 /* these strings match up with the values in pci_bus_speed */
 static char *pci_bus_speed_strings[] = {
@@ -530,16 +531,12 @@ static struct hotplug_slot *get_slot_fro
 	struct hotplug_slot *slot;
 	struct list_head *tmp;
 
-	spin_lock(&pci_hotplug_slot_list_lock);
 	list_for_each (tmp, &pci_hotplug_slot_list) {
 		slot = list_entry (tmp, struct hotplug_slot, slot_list);
 		if (strcmp(slot->name, name) == 0)
-			goto out;
+			return slot;
 	}
-	slot = NULL;
-out:
-	spin_unlock(&pci_hotplug_slot_list_lock);
-	return slot;
+	return NULL;
 }
 
 /**
@@ -570,9 +567,13 @@ int pci_hp_register(struct hotplug_slot 
 		return -EINVAL;
 	}
 
+	mutex_lock(&pci_hp_mutex);
+
 	/* Check if we have already registered a slot with the same name. */
-	if (get_slot_from_name(name))
-		return -EEXIST;
+	if (get_slot_from_name(name)) {
+		result = -EEXIST;
+		goto out;
+	}
 
 	/*
 	 * No problems if we call this interface from both ACPI_PCI_SLOT
@@ -580,13 +581,13 @@ int pci_hp_register(struct hotplug_slot 
 	 * pci_slot, the interface will simply bump the refcount.
 	 */
 	pci_slot = pci_create_slot(bus, slot_nr, name);
-	if (IS_ERR(pci_slot))
-		return PTR_ERR(pci_slot);
+	if ((result = IS_ERR(pci_slot)))
+		goto out;
 
 	if (pci_slot->hotplug) {
 		dbg("%s: already claimed\n", __func__);
-		pci_destroy_slot(pci_slot);
-		return -EBUSY;
+		result = -EBUSY;
+		goto cleanup;
 	}
 
 	slot->pci_slot = pci_slot;
@@ -597,21 +598,21 @@ int pci_hp_register(struct hotplug_slot 
 	 */
 	if (strcmp(kobject_name(&pci_slot->kobj), name)) {
 		result = kobject_rename(&pci_slot->kobj, name);
-		if (result) {
-			pci_destroy_slot(pci_slot);
-			return result;
-		}
+		if (result)
+			goto cleanup;
 	}
 
-	spin_lock(&pci_hotplug_slot_list_lock);
 	list_add(&slot->slot_list, &pci_hotplug_slot_list);
-	spin_unlock(&pci_hotplug_slot_list_lock);
 
 	result = fs_add_slot(pci_slot);
 	kobject_uevent(&pci_slot->kobj, KOBJ_ADD);
 	dbg("Added slot %s to the list\n", name);
-
+out:
+	mutex_unlock(&pci_hp_mutex);
 	return result;
+cleanup:
+	pci_destroy_slot(pci_slot);
+	goto out;
 }
 
 /**
@@ -631,13 +632,14 @@ int pci_hp_deregister(struct hotplug_slo
 	if (!hotplug)
 		return -ENODEV;
 
+	mutex_lock(&pci_hp_mutex);
 	temp = get_slot_from_name(hotplug->name);
-	if (temp != hotplug)
+	if (temp != hotplug) {
+		mutex_unlock(&pci_hp_mutex);
 		return -ENODEV;
+	}
 
-	spin_lock(&pci_hotplug_slot_list_lock);
 	list_del(&hotplug->slot_list);
-	spin_unlock(&pci_hotplug_slot_list_lock);
 
 	slot = hotplug->pci_slot;
 	fs_remove_slot(slot);
@@ -646,6 +648,7 @@ int pci_hp_deregister(struct hotplug_slo
 	hotplug->release(hotplug);
 	slot->hotplug = NULL;
 	pci_destroy_slot(slot);
+	mutex_unlock(&pci_hp_mutex);
 
 	return 0;
 }


