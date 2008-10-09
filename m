Return-Path: <linux-kernel-owner+w=401wt.eu-S1758552AbYJIEq7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758552AbYJIEq7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 00:46:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758008AbYJIEqm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 00:46:42 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:19770 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757955AbYJIEql (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 00:46:41 -0400
From: Alex Chiang <achiang@hp.com>
Subject: [PATCH v5 02/16] PCI: rename pci_update_slot_number to
	pci_renumber_slot
To: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: jbarnes@virtuousgeek.org, kristen.c.accardi@intel.com, matthew@wil.cx,
       kaneshige.kenji@jp.fujitsu.com, Alex Chiang <achiang@hp.com>
Date: Wed, 08 Oct 2008 22:46:39 -0600
Message-ID: <20081009044639.8678.76971.stgit@bob.kio>
In-Reply-To: <20081009043140.8678.44164.stgit@bob.kio>
References: <20081009043140.8678.44164.stgit@bob.kio>
User-Agent: StGIT/0.14.3.215.gff3d
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The GPL exported symbol pci_update_slot_number has been renamed to
pci_renumber_slot. Some of the safety checks were unnecessary and
were removed.

Cc: jbarnes@virtuousgeek.org
Cc: kristen.c.accardi@intel.com
Cc: matthew@wil.cx
Cc: kaneshige.kenji@jp.fujitsu.com
Signed-off-by: Alex Chiang <achiang@hp.com>
---

 drivers/pci/slot.c  |   15 +++++----------
 include/linux/pci.h |    2 +-
 2 files changed, 6 insertions(+), 11 deletions(-)

diff --git a/drivers/pci/slot.c b/drivers/pci/slot.c
index 0c6db03..b9b90ab 100644
--- a/drivers/pci/slot.c
+++ b/drivers/pci/slot.c
@@ -175,7 +175,7 @@ placeholder:
 EXPORT_SYMBOL_GPL(pci_create_slot);
 
 /**
- * pci_update_slot_number - update %struct pci_slot -> number
+ * pci_renumber_slot - update %struct pci_slot -> number
  * @slot - %struct pci_slot to update
  * @slot_nr - new number for slot
  *
@@ -183,27 +183,22 @@ EXPORT_SYMBOL_GPL(pci_create_slot);
  * created a placeholder slot in pci_create_slot() by passing a -1 as
  * slot_nr, to update their %struct pci_slot with the correct @slot_nr.
  */
-
-void pci_update_slot_number(struct pci_slot *slot, int slot_nr)
+void pci_renumber_slot(struct pci_slot *slot, int slot_nr)
 {
-	int name_count = 0;
 	struct pci_slot *tmp;
 
 	down_write(&pci_bus_sem);
 
 	list_for_each_entry(tmp, &slot->bus->slots, list) {
 		WARN_ON(tmp->number == slot_nr);
-		if (!strcmp(kobject_name(&tmp->kobj), kobject_name(&slot->kobj)))
-			name_count++;
+		goto out;
 	}
 
-	if (name_count > 1)
-		printk(KERN_WARNING "pci_update_slot_number found %d slots with the same name: %s\n", name_count, kobject_name(&slot->kobj));
-
 	slot->number = slot_nr;
+out:
 	up_write(&pci_bus_sem);
 }
-EXPORT_SYMBOL_GPL(pci_update_slot_number);
+EXPORT_SYMBOL_GPL(pci_renumber_slot);
 
 /**
  * pci_destroy_slot - decrement refcount for physical PCI slot
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 79dc7ce..5d96b7a 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -510,7 +510,7 @@ struct pci_bus *pci_add_new_bus(struct pci_bus *parent, struct pci_dev *dev,
 struct pci_slot *pci_create_slot(struct pci_bus *parent, int slot_nr,
 				 const char *name);
 void pci_destroy_slot(struct pci_slot *slot);
-void pci_update_slot_number(struct pci_slot *slot, int slot_nr);
+void pci_renumber_slot(struct pci_slot *slot, int slot_nr);
 int pci_scan_slot(struct pci_bus *bus, int devfn);
 struct pci_dev *pci_scan_single_device(struct pci_bus *bus, int devfn);
 void pci_device_add(struct pci_dev *dev, struct pci_bus *bus);

