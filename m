Return-Path: <linux-kernel-owner+w=401wt.eu-S1764405AbYHFFNN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764405AbYHFFNN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 01:13:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762948AbYHFFMU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 01:12:20 -0400
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:28733 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754899AbYHFFMS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 01:12:18 -0400
Date: Tue, 5 Aug 2008 23:12:17 -0600
From: Alex Chiang <achiang@hp.com>
To: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Matthew Wilcox <matthew@wil.cx>, Pierre Ossman <drzeus-list@drzeus.cx>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org
Subject: [PATCH 6/7] pci_slot: convert to a kmalloc'ed slot name
Message-ID: <20080806051217.GG31319@ldl.fc.hp.com>
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

Callers of pci_create_slot() need to be converted from a
char name[] to a char *name.

This change allows pci_create_slot() to dynamically rename the
sysfs name of the slot in the event of a name collision.

Signed-off-by: Alex Chiang <achiang@hp.com>
---
 drivers/acpi/pci_slot.c |   14 ++++++++++++--
 1 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/pci_slot.c b/drivers/acpi/pci_slot.c
index d5b4ef8..b146b72 100644
--- a/drivers/acpi/pci_slot.c
+++ b/drivers/acpi/pci_slot.c
@@ -133,7 +133,7 @@ register_slot(acpi_handle handle, u32 lvl, void *context, void **rv)
 {
 	int device;
 	unsigned long sun;
-	char name[SLOT_NAME_SIZE];
+	char *name;
 	struct acpi_pci_slot *slot;
 	struct pci_slot *pci_slot;
 	struct callback_args *parent_context = context;
@@ -149,10 +149,18 @@ register_slot(acpi_handle handle, u32 lvl, void *context, void **rv)
 		return AE_OK;
 	}
 
-	snprintf(name, sizeof(name), "%u", (u32)sun);
+	name = kzalloc(SLOT_NAME_SIZE, GFP_KERNEL);
+	if (!name) {
+		err("%s: cannot allocate memory for name\n", __func__);
+		kfree(slot);
+		return AE_OK;
+	}
+
+	snprintf(name, SLOT_NAME_SIZE, "%u", (u32)sun);
 	pci_slot = pci_create_slot(pci_bus, device, name);
 	if (IS_ERR(pci_slot)) {
 		err("pci_create_slot returned %ld\n", PTR_ERR(pci_slot));
+		kfree(name);
 		kfree(slot);
 		return AE_OK;
 	}
@@ -167,6 +175,8 @@ register_slot(acpi_handle handle, u32 lvl, void *context, void **rv)
 	dbg("pci_slot: %p, pci_bus: %x, device: %d, name: %s\n",
 		pci_slot, pci_bus->number, device, name);
 
+	kfree(name);
+
 	return AE_OK;
 }
 
-- 
1.6.0.rc0.g95f8

