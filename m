Return-Path: <linux-kernel-owner+w=401wt.eu-S1758808AbYHFFLQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758808AbYHFFLQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 01:11:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754467AbYHFFLA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 01:11:00 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:43602 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753895AbYHFFK7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 01:10:59 -0400
Date: Tue, 5 Aug 2008 23:10:57 -0600
From: Alex Chiang <achiang@hp.com>
To: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Matthew Wilcox <matthew@wil.cx>, Pierre Ossman <drzeus-list@drzeus.cx>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org
Subject: [PATCH 1/7] acpiphp: convert to a kmalloc'ed slot name
Message-ID: <20080806051057.GB31319@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>,
	Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
	Matthew Wilcox <matthew@wil.cx>,
	Pierre Ossman <drzeus-list@drzeus.cx>,
	Jesse Barnes <jbarnes@virtuousgeek.org>,
	LKML <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org
References: <20080806050745.GA31319@ldl.fc.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080806050745.GA31319@ldl.fc.hp.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Callers of pci_hp_register() need to be converted from a
char name[] to a char *name.

This change allows pci_create_slot() to dynamically rename the
sysfs name of the slot in the event of a name collision.

Signed-off-by: Alex Chiang <achiang@hp.com>
---
 drivers/pci/hotplug/acpiphp.h      |    2 +-
 drivers/pci/hotplug/acpiphp_core.c |   17 ++++++++++-------
 2 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/pci/hotplug/acpiphp.h b/drivers/pci/hotplug/acpiphp.h
index 5a58b07..2ac519d 100644
--- a/drivers/pci/hotplug/acpiphp.h
+++ b/drivers/pci/hotplug/acpiphp.h
@@ -63,7 +63,7 @@ struct slot {
 	struct hotplug_slot	*hotplug_slot;
 	struct acpiphp_slot	*acpi_slot;
 	struct hotplug_slot_info info;
-	char name[SLOT_NAME_SIZE];
+	char *name;
 };
 
 /*
diff --git a/drivers/pci/hotplug/acpiphp_core.c b/drivers/pci/hotplug/acpiphp_core.c
index 0e496e8..ec164f4 100644
--- a/drivers/pci/hotplug/acpiphp_core.c
+++ b/drivers/pci/hotplug/acpiphp_core.c
@@ -301,6 +301,7 @@ static void release_slot(struct hotplug_slot *hotplug_slot)
 
 	dbg("%s - physical_slot = %s\n", __func__, hotplug_slot->name);
 
+	kfree(slot->name);
 	kfree(slot->hotplug_slot);
 	kfree(slot);
 }
@@ -315,9 +316,13 @@ int acpiphp_register_hotplug_slot(struct acpiphp_slot *acpiphp_slot)
 	if (!slot)
 		goto error;
 
+	slot->name = kzalloc(SLOT_NAME_SIZE, GFP_KERNEL);
+	if (!slot->name)
+		goto error_slot;
+
 	slot->hotplug_slot = kzalloc(sizeof(*slot->hotplug_slot), GFP_KERNEL);
 	if (!slot->hotplug_slot)
-		goto error_slot;
+		goto error_name;
 
 	slot->hotplug_slot->info = &slot->info;
 
@@ -336,23 +341,21 @@ int acpiphp_register_hotplug_slot(struct acpiphp_slot *acpiphp_slot)
 	slot->hotplug_slot->info->cur_bus_speed = PCI_SPEED_UNKNOWN;
 
 	acpiphp_slot->slot = slot;
-	snprintf(slot->name, sizeof(slot->name), "%u", slot->acpi_slot->sun);
+	snprintf(slot->name, SLOT_NAME_SIZE, "%u", slot->acpi_slot->sun);
 
 	retval = pci_hp_register(slot->hotplug_slot,
 					acpiphp_slot->bridge->pci_bus,
 					acpiphp_slot->device);
-	if (retval == -EBUSY)
-		goto error_hpslot;
-	if (retval) {
-		err("pci_hp_register failed with error %d\n", retval);
+	if (retval)
 		goto error_hpslot;
- 	}
 
 	info("Slot [%s] registered\n", slot->hotplug_slot->name);
 
 	return 0;
 error_hpslot:
 	kfree(slot->hotplug_slot);
+error_name:
+	kfree(slot->name);
 error_slot:
 	kfree(slot);
 error:
-- 
1.6.0.rc0.g95f8

