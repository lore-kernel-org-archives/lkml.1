Return-Path: <linux-kernel-owner+w=401wt.eu-S1756755AbYLKSQz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756755AbYLKSQz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 13:16:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755082AbYLKSQq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 13:16:46 -0500
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:38401 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754467AbYLKSQp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 13:16:45 -0500
Date: Thu, 11 Dec 2008 11:16:44 -0700
From: Alex Chiang <achiang@hp.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>, justin.chen@hp.com,
       linux-pci <linux-pci@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] PCI Hotplug: acpiphp wants a 64-bit _SUN
Message-ID: <20081211181644.GE18309@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>,
	Jesse Barnes <jbarnes@virtuousgeek.org>, justin.chen@hp.com,
	linux-pci <linux-pci@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>
References: <20081211181242.GD18309@ldl.fc.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081211181242.GD18309@ldl.fc.hp.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Justin Chen <justin.chen@hp.com>

Certain HP machines require the full 64 bits of _SUN as allowed
by the ACPI spec. Without this change, we get name collisions in
the lower 32 bits of the _SUN returned by firmware.

Signed-off-by: Justin Chen <justin.chen@hp.com>
Signed-off-by: Alex Chiang <achiang@hp.com>
---
diff --git a/drivers/pci/hotplug/acpiphp.h b/drivers/pci/hotplug/acpiphp.h
index f9e244d..9bcb6cb 100644
--- a/drivers/pci/hotplug/acpiphp.h
+++ b/drivers/pci/hotplug/acpiphp.h
@@ -113,7 +113,7 @@ struct acpiphp_slot {
 
 	u8		device;		/* pci device# */
 
-	u32		sun;		/* ACPI _SUN (slot unique number) */
+	unsigned long long sun;		/* ACPI _SUN (slot unique number) */
 	u32		flags;		/* see below */
 };
 
diff --git a/drivers/pci/hotplug/acpiphp_core.c b/drivers/pci/hotplug/acpiphp_core.c
index 95b536a..43c10bd 100644
--- a/drivers/pci/hotplug/acpiphp_core.c
+++ b/drivers/pci/hotplug/acpiphp_core.c
@@ -337,7 +337,7 @@ int acpiphp_register_hotplug_slot(struct acpiphp_slot *acpiphp_slot)
 	slot->hotplug_slot->info->cur_bus_speed = PCI_SPEED_UNKNOWN;
 
 	acpiphp_slot->slot = slot;
-	snprintf(name, SLOT_NAME_SIZE, "%u", slot->acpi_slot->sun);
+	snprintf(name, SLOT_NAME_SIZE, "%llu", slot->acpi_slot->sun);
 
 	retval = pci_hp_register(slot->hotplug_slot,
 					acpiphp_slot->bridge->pci_bus,
diff --git a/drivers/pci/hotplug/acpiphp_glue.c b/drivers/pci/hotplug/acpiphp_glue.c
index 955aae4..3affc64 100644
--- a/drivers/pci/hotplug/acpiphp_glue.c
+++ b/drivers/pci/hotplug/acpiphp_glue.c
@@ -255,13 +255,13 @@ register_slot(acpi_handle handle, u32 lvl, void *context, void **rv)
 
 		bridge->nr_slots++;
 
-		dbg("found ACPI PCI Hotplug slot %d at PCI %04x:%02x:%02x\n",
+		dbg("found ACPI PCI Hotplug slot %llu at PCI %04x:%02x:%02x\n",
 				slot->sun, pci_domain_nr(bridge->pci_bus),
 				bridge->pci_bus->number, slot->device);
 		retval = acpiphp_register_hotplug_slot(slot);
 		if (retval) {
 			if (retval == -EBUSY)
-				warn("Slot %d already registered by another "
+				warn("Slot %llu already registered by another "
 					"hotplug driver\n", slot->sun);
 			else
 				warn("acpiphp_register_hotplug_slot failed "
