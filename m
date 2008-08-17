Return-Path: <linux-kernel-owner+w=401wt.eu-S1755708AbYHQAU0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755708AbYHQAU0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2008 20:20:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755272AbYHQARy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Aug 2008 20:17:54 -0400
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:10072 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755335AbYHQARx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2008 20:17:53 -0400
From: Alex Chiang <achiang@hp.com>
Subject: [PATCH 13/13] PCI: Hotplug core: remove 'name'
To: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Cc: jbarnes@virtuousgeek.org, kristen.c.accardi@intel.com, matthew@wil.cx,
       kaneshige.kenji@jp.fujitsu.com, Alex Chiang <achiang@hp.com>
Date: Sat, 16 Aug 2008 18:17:52 -0600
Message-ID: <20080817001750.5461.12934.stgit@blender.achiang>
In-Reply-To: <20080816235504.5461.20733.stgit@blender.achiang>
References: <20080816235504.5461.20733.stgit@blender.achiang>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that the PCI core manages the 'name' for each individual
hotplug driver, and all drivers have been converted to use
hotplug_slot_name(), there is no need for the PCI hotplug
core to drag around its own copy of name either.

Cc: jbarnes@virtuousgeek.org
Cc: kristen.c.accardi@intel.com
Cc: matthew@wil.cx
Cc: kaneshige.kenji@jp.fujitsu.com
Signed-off-by: Alex Chiang <achiang@hp.com>
---

 drivers/pci/hotplug/pci_hotplug_core.c |    6 +++---
 include/linux/pci_hotplug.h            |    3 ---
 2 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/pci/hotplug/pci_hotplug_core.c b/drivers/pci/hotplug/pci_hotplug_core.c
index da5908f..eb2437c 100644
--- a/drivers/pci/hotplug/pci_hotplug_core.c
+++ b/drivers/pci/hotplug/pci_hotplug_core.c
@@ -533,7 +533,7 @@ static struct hotplug_slot *get_slot_from_name (const char *name)
 	spin_lock(&pci_hotplug_slot_list_lock);
 	list_for_each (tmp, &pci_hotplug_slot_list) {
 		slot = list_entry (tmp, struct hotplug_slot, slot_list);
-		if (strcmp(slot->name, name) == 0)
+		if (strcmp(hotplug_slot_name(slot), name) == 0)
 			goto out;
 	}
 	slot = NULL;
@@ -627,7 +627,7 @@ int pci_hp_deregister(struct hotplug_slot *hotplug)
 	if (!hotplug)
 		return -ENODEV;
 
-	temp = get_slot_from_name(hotplug->name);
+	temp = get_slot_from_name(hotplug_slot_name(hotplug));
 	if (temp != hotplug)
 		return -ENODEV;
 
@@ -637,7 +637,7 @@ int pci_hp_deregister(struct hotplug_slot *hotplug)
 
 	slot = hotplug->pci_slot;
 	fs_remove_slot(slot);
-	dbg("Removed slot %s from the list\n", hotplug->name);
+	dbg("Removed slot %s from the list\n", hotplug_slot_name(hotplug));
 
 	hotplug->release(hotplug);
 	slot->hotplug = NULL;
diff --git a/include/linux/pci_hotplug.h b/include/linux/pci_hotplug.h
index 7184bee..9899ea3 100644
--- a/include/linux/pci_hotplug.h
+++ b/include/linux/pci_hotplug.h
@@ -142,8 +142,6 @@ struct hotplug_slot_info {
 
 /**
  * struct hotplug_slot - used to register a physical slot with the hotplug pci core
- * @name: the name of the slot being registered.  This string must
- * be unique amoung slots registered on this system.
  * @ops: pointer to the &struct hotplug_slot_ops to be used for this slot
  * @info: pointer to the &struct hotplug_slot_info for the initial values for
  * this slot.
@@ -153,7 +151,6 @@ struct hotplug_slot_info {
  * needs.
  */
 struct hotplug_slot {
-	char				*name;
 	struct hotplug_slot_ops		*ops;
 	struct hotplug_slot_info	*info;
 	void (*release) (struct hotplug_slot *slot);

