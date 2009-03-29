Return-Path: <linux-kernel-owner+w=401wt.eu-S1759475AbZC2Q4A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759475AbZC2Q4A (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 12:56:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754439AbZC2Qy6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 12:54:58 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:46905 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759060AbZC2Qy4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 12:54:56 -0400
Subject: [PATCH 3/3] PCI: pci_slot: grab refcount on slot's bus
To: jbarnes@virtuousgeek.org
From: Alex Chiang <achiang@hp.com>
Cc: linux-pci@vger.kernel.org,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, lenb@kernel.org
Date: Sun, 29 Mar 2009 10:54:54 -0600
Message-ID: <20090329165454.29073.1180.stgit@bob.kio>
In-Reply-To: <20090329165352.29073.5159.stgit@bob.kio>
References: <20090329165352.29073.5159.stgit@bob.kio>
User-Agent: StGit/0.14.3.347.g594a
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a logical hot unplug (remove) is performed on a physical PCI slot's
parent bridge, and then pci_slot is unloaded, we will encounter an oops:

  [<ffffffff803a788a>] kobject_release+0x9a/0x290
  [<ffffffff803a77f0>] ? kobject_release+0x0/0x290
  [<ffffffff803a8ce7>] kref_put+0x37/0x80
  [<ffffffff803a76f7>] kobject_put+0x27/0x60
  [<ffffffff803bebcc>] ? pci_destroy_slot+0x3c/0xc0
  [<ffffffff803bebd5>] pci_destroy_slot+0x45/0xc0
  [<ffffffffa000f05c>] acpi_pci_slot_remove+0x5c/0x91 [pci_slot]
  [<ffffffff8040064b>] acpi_pci_unregister_driver+0x4b/0x62
  [<ffffffffa000f5c8>] acpi_pci_slot_exit+0x10/0x12 [pci_slot]
  [<ffffffff80276ce1>] sys_delete_module+0x161/0x250

We need to grab a reference to the parent PCI bus, which will pin
the bus and prevent it from being released until pci_slot is unloaded.

Cc: lenb@kernel.org
Reported-by: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Signed-off-by: Alex Chiang <achiang@hp.com>
---

 drivers/acpi/pci_slot.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/acpi/pci_slot.c b/drivers/acpi/pci_slot.c
index cd1f446..c7ad9f2 100644
--- a/drivers/acpi/pci_slot.c
+++ b/drivers/acpi/pci_slot.c
@@ -63,6 +63,7 @@ struct acpi_pci_slot {
 	acpi_handle root_handle;	/* handle of the root bridge */
 	struct pci_slot *pci_slot;	/* corresponding pci_slot */
 	struct list_head list;		/* node in the list of slots */
+	struct pci_bus *bus;		/* bus the slot is on */
 };
 
 static int acpi_pci_slot_add(acpi_handle handle);
@@ -159,11 +160,14 @@ register_slot(acpi_handle handle, u32 lvl, void *context, void **rv)
 
 	slot->root_handle = parent_context->root_handle;
 	slot->pci_slot = pci_slot;
+	slot->bus = pci_bus;
 	INIT_LIST_HEAD(&slot->list);
 	mutex_lock(&slot_list_lock);
 	list_add(&slot->list, &slot_list);
 	mutex_unlock(&slot_list_lock);
 
+	get_device(&pci_bus->dev);
+
 	dbg("pci_slot: %p, pci_bus: %x, device: %d, name: %s\n",
 		pci_slot, pci_bus->number, device, name);
 
@@ -316,6 +320,7 @@ acpi_pci_slot_remove(acpi_handle handle)
 		if (slot->root_handle == handle) {
 			list_del(&slot->list);
 			pci_destroy_slot(slot->pci_slot);
+			put_device(&slot->bus->dev);
 			kfree(slot);
 		}
 	}

