Return-Path: <linux-kernel-owner+w=401wt.eu-S1754926AbYLCUC3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754926AbYLCUC3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 15:02:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754842AbYLCTwZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 14:52:25 -0500
Received: from kroah.org ([198.145.64.141]:59829 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752430AbYLCTwX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 14:52:23 -0500
Date: Wed, 3 Dec 2008 11:50:48 -0800
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
       alan@lxorguk.ukuu.org.uk,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Alex Chiang <achiang@hp.com>, Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [patch 030/104] PCI Hotplug: serialize pci_hp_register and
	pci_hp_deregister
Message-ID: <20081203195048.GE8950@kroah.com>
References: <20081203193901.715896543@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="pci-hotplug-serialize-pci_hp_register-and-pci_hp_deregister.patch"
In-Reply-To: <20081203194725.GA8950@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>

commit 95cb9093960b6249fdbe7417bf513a1358aaa51a upstream.

Convert the pci_hotplug_slot_list_lock, which only protected the
list of hotplug slots, to a pci_hp_mutex which now protects both
interfaces.

Signed-off-by: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Signed-off-by: Alex Chiang <achiang@hp.com>
Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/pci/hotplug/pci_hotplug_core.c |   51 ++++++++++++++++++---------------
 1 file changed, 28 insertions(+), 23 deletions(-)

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
@@ -580,13 +581,15 @@ int pci_hp_register(struct hotplug_slot 
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
@@ -597,21 +600,21 @@ int pci_hp_register(struct hotplug_slot 
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
@@ -631,13 +634,14 @@ int pci_hp_deregister(struct hotplug_slo
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
@@ -646,6 +650,7 @@ int pci_hp_deregister(struct hotplug_slo
 	hotplug->release(hotplug);
 	slot->hotplug = NULL;
 	pci_destroy_slot(slot);
+	mutex_unlock(&pci_hp_mutex);
 
 	return 0;
 }

