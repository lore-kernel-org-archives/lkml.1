Return-Path: <linux-kernel-owner+w=401wt.eu-S1757317AbYGaPrf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757317AbYGaPrf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 11:47:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752755AbYGaPr0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 11:47:26 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:5669 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752769AbYGaPrZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 11:47:25 -0400
Date: Thu, 31 Jul 2008 09:47:23 -0600
From: Alex Chiang <achiang@hp.com>
To: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Cc: Matthew Wilcox <matthew@wil.cx>, Pierre Ossman <drzeus-list@drzeus.cx>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org
Subject: Re: post 2.6.26 requires pciehp_slot_with_bus
Message-ID: <20080731154723.GA26577@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>,
	Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
	Matthew Wilcox <matthew@wil.cx>,
	Pierre Ossman <drzeus-list@drzeus.cx>,
	Jesse Barnes <jbarnes@virtuousgeek.org>,
	LKML <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org
References: <20080724235127.40bd0ac9@mjolnir.drzeus.cx> <200807241506.58973.jbarnes@virtuousgeek.org> <20080724222914.GG5307@ldl.fc.hp.com> <20080725004926.5f201c70@mjolnir.drzeus.cx> <20080724230827.GA30302@ldl.fc.hp.com> <20080725012916.06679a6d@mjolnir.drzeus.cx> <20080725032909.GA6701@parisc-linux.org> <48895D3C.7040100@jp.fujitsu.com> <20080730023842.GA4269@ldl.fc.hp.com> <48919471.6010304@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48919471.6010304@jp.fujitsu.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>:
> Thank you for patches, Alex-san!
>
> I've reviewed those patches and tested them on my ia64 machine
> that have both shpc and pcie hotplug slots. Your patch looks
> good.

Thank you for reviewing and testing.

> As you mentioned, we are considering the problem also from the
> view point of slot detection. But I think your patch is needed
> regardless of that because there might be platforms whose slots
> are detected properly but firmware assigns the physical slot
> number wrongly. I think Alex's patch should go to mainline.

That is a good point.

> P.S.: I found a possible improvement, though it is not a big
> problem and we don't not need to fix it soon. I'd like to tell
> you about it just in case. Current pci_hp_register() checks if
> name is duplicated first, before checking if another hotplug
> driver is already registered to the slot. So, if shpchp/pciehp
> driver tries to register hotplug slot that is already registered
> by the other hotplug driver (e.g. acpiphp) with the same name,
> shpchp/pciehp driver will do as follows:
>
> (1) shpchp/pciehp call pci_hp_register()
> (2) pci_hp_register() returns -EEXIST
> (3) shpchp/pciehp call pci_hp_register() with other name ("M-1")
> (4) pci_hp_register() returns -EBUSY
>
> if pci_hp_register() checked if another hotplug driver is already
> registered first, step (2) and (3) could be removed.

Thanks, that seems pretty easy to do.

Would you mind testing this patch as well? You should probably
apply it on top of the other two patches to see how all three
patches interact.

Thanks!

/ac


From: Alex Chiang <achiang@dl580g5.kio>
Subject: [PATCH] PCI hotplug: check for claimed slot before duplicate named slot

Kenji Kaneshige observes that:

If shpchp/pciehp driver tries to register hotplug slot that is
already registered by the other hotplug driver (e.g. acpiphp) with
the same name, shpchp/pciehp driver will do as follows:

(1) shpchp/pciehp call pci_hp_register()
(2) pci_hp_register() returns -EEXIST
(3) shpchp/pciehp call pci_hp_register() with other name ("M-1")
(4) pci_hp_register() returns -EBUSY

If pci_hp_register() checked if another hotplug driver is already
registered first, step (2) and (3) could be removed.

This patch does not prevent the *same* driver from attempting
to register multiple slots with the same name (on systems with
broken firmware). For that situation, we still need to detect
a name collision and return -EEXIST if so.

Signed-off-by: Alex Chiang <achiang@hp.com>
---
 drivers/pci/hotplug/pci_hotplug_core.c |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/pci/hotplug/pci_hotplug_core.c b/drivers/pci/hotplug/pci_hotplug_core.c
index 5f85b1b..9c379b6 100644
--- a/drivers/pci/hotplug/pci_hotplug_core.c
+++ b/drivers/pci/hotplug/pci_hotplug_core.c
@@ -568,10 +568,6 @@ int pci_hp_register(struct hotplug_slot *slot, struct pci_bus *bus, int slot_nr)
 		return -EINVAL;
 	}
 
-	/* Check if we have already registered a slot with the same name. */
-	if (get_slot_from_name(slot->name))
-		return -EEXIST;
-
 	/*
 	 * No problems if we call this interface from both ACPI_PCI_SLOT
 	 * driver and call it here again. If we've already created the
@@ -587,6 +583,12 @@ int pci_hp_register(struct hotplug_slot *slot, struct pci_bus *bus, int slot_nr)
 		return -EBUSY;
 	}
 
+	/* Check if we have already registered a slot with the same name. */
+	if (get_slot_from_name(slot->name)) {
+		pci_destroy_slot(pci_slot);
+		return -EEXIST;
+	}
+
 	slot->pci_slot = pci_slot;
 	pci_slot->hotplug = slot;
 
@@ -609,7 +611,6 @@ int pci_hp_register(struct hotplug_slot *slot, struct pci_bus *bus, int slot_nr)
 	kobject_uevent(&pci_slot->kobj, KOBJ_ADD);
 	dbg("Added slot %s to the list\n", slot->name);
 
-
 	return result;
 }
 
-- 
1.6.0.rc0.g95f8

