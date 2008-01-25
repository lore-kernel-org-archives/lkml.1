Return-Path: <linux-kernel-owner+w=401wt.eu-S1765609AbYAYIVk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765609AbYAYIVk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 03:21:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764051AbYAYIAz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 03:00:55 -0500
Received: from cantor2.suse.de ([195.135.220.15]:53695 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764087AbYAYH7y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 02:59:54 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
       Kristen Carlson Accardi <kristen.c.accardi@intel.com>,
       Kay Sievers <kay.sievers@vrfy.org>
Subject: [PATCH 116/196] Kobject: change drivers/pci/hotplug/pci_hotplug_core.c to use kobject_init_and_add
Date: Thu, 24 Jan 2008 23:32:25 -0800
Message-Id: <1201246425-5058-37-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <20080125071127.GA4860@kroah.com>
References: <20080125071127.GA4860@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stop using kobject_register, as this way we can control the sending of
the uevent properly, after everything is properly initialized.

Cc: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/pci/hotplug/pci_hotplug_core.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/pci/hotplug/pci_hotplug_core.c b/drivers/pci/hotplug/pci_hotplug_core.c
index 175e0c8..0f05e6a 100644
--- a/drivers/pci/hotplug/pci_hotplug_core.c
+++ b/drivers/pci/hotplug/pci_hotplug_core.c
@@ -630,19 +630,19 @@ int pci_hp_register (struct hotplug_slot *slot)
 		return -EINVAL;
 	}
 
-	kobject_set_name(&slot->kobj, "%s", slot->name);
-	slot->kobj.kset = pci_hotplug_slots_kset;
-	slot->kobj.ktype = &hotplug_slot_ktype;
-
 	/* this can fail if we have already registered a slot with the same name */
-	if (kobject_register(&slot->kobj)) {
-		err("Unable to register kobject");
+	slot->kobj.kset = pci_hotplug_slots_kset;
+	result = kobject_init_and_add(&slot->kobj, &hotplug_slot_ktype, NULL,
+				      "%s", slot->name);
+	if (result) {
+		err("Unable to register kobject '%s'", slot->name);
 		return -EINVAL;
 	}
-		
+
 	list_add (&slot->slot_list, &pci_hotplug_slot_list);
 
 	result = fs_add_slot (slot);
+	kobject_uevent(&slot->kobj, KOBJ_ADD);
 	dbg ("Added slot %s to the list\n", slot->name);
 	return result;
 }
-- 
1.5.3.8

