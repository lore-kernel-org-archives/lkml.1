Return-Path: <linux-kernel-owner+w=401wt.eu-S1758747AbYJIEr2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758747AbYJIEr2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 00:47:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758172AbYJIEqr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 00:46:47 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:19795 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758118AbYJIEqp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 00:46:45 -0400
From: Alex Chiang <achiang@hp.com>
Subject: [PATCH v5 03/16] PCI: update pci_create_slot() to take a 'rename'
	param
To: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: jbarnes@virtuousgeek.org, kristen.c.accardi@intel.com, matthew@wil.cx,
       kaneshige.kenji@jp.fujitsu.com, Alex Chiang <achiang@hp.com>
Date: Wed, 08 Oct 2008 22:46:44 -0600
Message-ID: <20081009044644.8678.86491.stgit@bob.kio>
In-Reply-To: <20081009043140.8678.44164.stgit@bob.kio>
References: <20081009043140.8678.44164.stgit@bob.kio>
User-Agent: StGIT/0.14.3.215.gff3d
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Slot detection drivers can co-exist with hotplug drivers. The names
of the detected/claimed slots may be different depending on module
load order.

For legacy reasons, we need to allow hotplug drivers to override
the slot name if a detection driver is loaded first (and they find
the same slots).

Creating and overriding slot names should be an atomic operation,
otherwise you get a locking nightmare as various drivers race to
call pci_create_slot().

pci_create_slot() is already serialized by grabbing the pci_bus_sem.

We update the API and add a 'rename' param, which is:

	set if the caller wants to rename an already existing slot
	unset if the caller doesn't care

The hotplug drivers care about renaming; the detection drivers do not.

pci_create_slot() does not actually use the 'rename' parameter in this
patch. A later patch will add the logic that uses it.

Cc: jbarnes@virtuousgeek.org
Cc: kristen.c.accardi@intel.com
Cc: matthew@wil.cx
Cc: kaneshige.kenji@jp.fujitsu.com
Signed-off-by: Alex Chiang <achiang@hp.com>
---

 drivers/acpi/pci_slot.c                |    2 +-
 drivers/pci/hotplug/pci_hotplug_core.c |    2 +-
 drivers/pci/slot.c                     |    3 ++-
 include/linux/pci.h                    |    2 +-
 4 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/acpi/pci_slot.c b/drivers/acpi/pci_slot.c
index d5b4ef8..0946890 100644
--- a/drivers/acpi/pci_slot.c
+++ b/drivers/acpi/pci_slot.c
@@ -150,7 +150,7 @@ register_slot(acpi_handle handle, u32 lvl, void *context, void **rv)
 	}
 
 	snprintf(name, sizeof(name), "%u", (u32)sun);
-	pci_slot = pci_create_slot(pci_bus, device, name);
+	pci_slot = pci_create_slot(pci_bus, device, name, 0);
 	if (IS_ERR(pci_slot)) {
 		err("pci_create_slot returned %ld\n", PTR_ERR(pci_slot));
 		kfree(slot);
diff --git a/drivers/pci/hotplug/pci_hotplug_core.c b/drivers/pci/hotplug/pci_hotplug_core.c
index 0e7a511..a5e01bc 100644
--- a/drivers/pci/hotplug/pci_hotplug_core.c
+++ b/drivers/pci/hotplug/pci_hotplug_core.c
@@ -579,7 +579,7 @@ int pci_hp_register(struct hotplug_slot *slot, struct pci_bus *bus, int slot_nr,
 	 * driver and call it here again. If we've already created the
 	 * pci_slot, the interface will simply bump the refcount.
 	 */
-	pci_slot = pci_create_slot(bus, slot_nr, name);
+	pci_slot = pci_create_slot(bus, slot_nr, name, 1);
 	if (IS_ERR(pci_slot))
 		return PTR_ERR(pci_slot);
 
diff --git a/drivers/pci/slot.c b/drivers/pci/slot.c
index b9b90ab..8379c50 100644
--- a/drivers/pci/slot.c
+++ b/drivers/pci/slot.c
@@ -83,6 +83,7 @@ static struct kobj_type pci_slot_ktype = {
  * @parent: struct pci_bus of parent bridge
  * @slot_nr: PCI_SLOT(pci_dev->devfn) or -1 for placeholder
  * @name: user visible string presented in /sys/bus/pci/slots/<name>
+ * @rename: 1 if driver wants to rename an existing slot, 0 otherwise
  *
  * PCI slots have first class attributes such as address, speed, width,
  * and a &struct pci_slot is used to manage them. This interface will
@@ -111,7 +112,7 @@ static struct kobj_type pci_slot_ktype = {
  */
 
 struct pci_slot *pci_create_slot(struct pci_bus *parent, int slot_nr,
-				 const char *name)
+				 const char *name, int rename)
 {
 	struct pci_dev *dev;
 	struct pci_slot *slot;
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 5d96b7a..aa49fb9 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -508,7 +508,7 @@ struct pci_bus *pci_create_bus(struct device *parent, int bus,
 struct pci_bus *pci_add_new_bus(struct pci_bus *parent, struct pci_dev *dev,
 				int busnr);
 struct pci_slot *pci_create_slot(struct pci_bus *parent, int slot_nr,
-				 const char *name);
+				 const char *name, int rename);
 void pci_destroy_slot(struct pci_slot *slot);
 void pci_renumber_slot(struct pci_slot *slot, int slot_nr);
 int pci_scan_slot(struct pci_bus *bus, int devfn);

