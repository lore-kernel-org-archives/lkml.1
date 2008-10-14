Return-Path: <linux-kernel-owner+w=401wt.eu-S1756554AbYJNH0y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756554AbYJNH0y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 03:26:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755174AbYJNHZZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 03:25:25 -0400
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:12364 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757373AbYJNHZX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 03:25:23 -0400
From: Alex Chiang <achiang@hp.com>
Subject: [PATCH v6-resend 04/17] PCI Hotplug: serialize pci_hp_register and
	pci_hp_deregister
To: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Alex Chiang <achiang@hp.com>
Date: Tue, 14 Oct 2008 01:25:22 -0600
Message-ID: <20081014072522.24319.61512.stgit@bob.kio>
In-Reply-To: <20081014072311.24319.27334.stgit@bob.kio>
References: <20081014072311.24319.27334.stgit@bob.kio>
User-Agent: StGIT/0.14.3.215.gff3d
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>

Convert the pci_hotplug_slot_list_lock, which only protected the
list of hotplug slots, to a pci_hp_mutex which now protects both
interfaces.

Signed-off-by: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Signed-off-by: Alex Chiang <achiang@hp.com>
---

 drivers/pci/hotplug/pci_hotplug_core.c |   51 ++++++++++++++++++--------------
 1 files changed, 28 insertions(+), 23 deletions(-)

diff --git a/drivers/pci/hotplug/pci_hotplug_core.c b/drivers/pci/hotplug/pci_hotplug_core.c
index 1cdeb64..e715248 100644
--- a/drivers/pci/hotplug/pci_hotplug_core.c
+++ b/drivers/pci/hotplug/pci_hotplug_core.c
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
@@ -530,16 +531,12 @@ static struct hotplug_slot *get_slot_from_name (const char *name)
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
@@ -570,9 +567,13 @@ int pci_hp_register(struct hotplug_slot *slot, struct pci_bus *bus, int slot_nr,
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
@@ -580,13 +581,15 @@ int pci_hp_register(struct hotplug_slot *slot, struct pci_bus *bus, int slot_nr,
 	 * pci_slot, the interface will simply bump the refcount.
 	 */
 	pci_slot = pci_create_slot(bus, slot_nr, name, slot);
-	if (IS_ERR(pci_slot))
-		return PTR_ERR(pci_slot);
+	if (IS_ERR(pci_slot)) {
+		result = PTR_ERR(pci_slot);
+		goto cleanup;
+	}
 
 	if (pci_slot->hotplug) {
 		dbg("%s: already claimed\n", __func__);
-		pci_destroy_slot(pci_slot);
-		return -EBUSY;
+		result = -EBUSY;
+		goto cleanup;
 	}
 
 	slot->pci_slot = pci_slot;
@@ -597,21 +600,21 @@ int pci_hp_register(struct hotplug_slot *slot, struct pci_bus *bus, int slot_nr,
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
@@ -631,13 +634,14 @@ int pci_hp_deregister(struct hotplug_slot *hotplug)
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
@@ -646,6 +650,7 @@ int pci_hp_deregister(struct hotplug_slot *hotplug)
 	hotplug->release(hotplug);
 	slot->hotplug = NULL;
 	pci_destroy_slot(slot);
+	mutex_unlock(&pci_hp_mutex);
 
 	return 0;
 }

