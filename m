Return-Path: <linux-kernel-owner+w=401wt.eu-S1764111AbYHFFNe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764111AbYHFFNe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 01:13:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763387AbYHFFMq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 01:12:46 -0400
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:15482 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762445AbYHFFMn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 01:12:43 -0400
Date: Tue, 5 Aug 2008 23:12:41 -0600
From: Alex Chiang <achiang@hp.com>
To: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Matthew Wilcox <matthew@wil.cx>, Pierre Ossman <drzeus-list@drzeus.cx>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org
Subject: [PATCH 7/7] PCI Hotplug core: fixups for duplicate slot names
Message-ID: <20080806051241.GH31319@ldl.fc.hp.com>
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

Commit a86161b3134465f072d965ca7508ec9c1e2e52c7 added a check
to detect platforms with broken firmware that attempt to assign
identical slot names to multiple slots.

This approach is suboptimal because it prints a scary message
and forces the user to reload a hotplug driver with a module
parameter. We can do better here by attempting to rename these
duplicate slots on behalf of the user.

If firmware assigns the name N to multiple slots, then:

	The first registered slot is assigned N
	The second registered slot is assigned N-1
	The third registered slot is assigned N-2
	The Mth registered slot becomes N-M

This patch also has the effect of making attempts by multiple
drivers claiming the same slot become a more prominent error,
returning -EBUSY in those cases.

Signed-off-by: Alex Chiang <achiang@hp.com>
---
 drivers/pci/hotplug/pci_hotplug_core.c |    4 --
 drivers/pci/slot.c                     |   65 ++++++++++++++++++++++++++++---
 include/linux/pci.h                    |    2 +-
 3 files changed, 59 insertions(+), 12 deletions(-)

diff --git a/drivers/pci/hotplug/pci_hotplug_core.c b/drivers/pci/hotplug/pci_hotplug_core.c
index 5f85b1b..4476f0c 100644
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
diff --git a/drivers/pci/slot.c b/drivers/pci/slot.c
index 7e5b85c..e35dcae 100644
--- a/drivers/pci/slot.c
+++ b/drivers/pci/slot.c
@@ -84,7 +84,19 @@ static struct kobj_type pci_slot_ktype = {
  * either return a new &struct pci_slot to the caller, or if the pci_slot
  * already exists, its refcount will be incremented.
  *
- * Slots are uniquely identified by a @pci_bus, @slot_nr, @name tuple.
+ * Slots are uniquely identified by a @pci_bus, @slot_nr tuple.
+ *
+ * The kobject API imposes a restriction on us, and does not allow sysfs
+ * entries with duplicate names. There are known platforms with broken
+ * firmware that assign the same name to multiple slots.
+ *
+ * We workaround these broken platforms by renaming the slots on behalf
+ * of the caller. If firmware assigns name N to multiple slots:
+ *
+ * The first slot is assigned N
+ * The second slot is assigned N-1
+ * The third slot is assigned N-2
+ * The Mth slot is assigned N-M
  *
  * Placeholder slots:
  * In most cases, @pci_bus, @slot_nr will be sufficient to uniquely identify
@@ -103,13 +115,15 @@ static struct kobj_type pci_slot_ktype = {
  * consist solely of a dddd:bb tuple, where dddd is the PCI domain of the
  * %struct pci_bus and bb is the bus number. In other words, the devfn of
  * the 'placeholder' slot will not be displayed.
- */
+ **/
 
 struct pci_slot *pci_create_slot(struct pci_bus *parent, int slot_nr,
-				 const char *name)
+				 char *name)
 {
+	struct kobject *dup_slot;
 	struct pci_slot *slot;
-	int err;
+	char *old_name;
+	int err, len, width, dup = 1;
 
 	down_write(&pci_bus_sem);
 
@@ -138,8 +152,43 @@ placeholder:
 
 	slot->bus = parent;
 	slot->number = slot_nr;
-
 	slot->kobj.kset = pci_slots_kset;
+
+	old_name = kstrdup(name, GFP_KERNEL);
+	if (!old_name) {
+		err = -ENOMEM;
+		goto err_oldname;
+	}
+
+	/*
+	 * Start off allocating enough room for "name-X"
+	 */
+	len = strlen(name) + 2;
+	width = 1;
+duplicate_name:
+	dup_slot = kset_find_obj(pci_slots_kset, name);
+	if (dup_slot) {
+		/*
+		 * We hit this the first time through, which gives us
+		 * space for terminating NULL, and then every power of 10
+		 * afterwards, which gives us space to add another digit
+		 * to "name-XX..."
+		 */
+		if (dup % width == 0) {
+			len++;
+			width *= 10;
+		}
+		kfree(name);
+		name = kzalloc(len, GFP_KERNEL);
+		if (!name) {
+			err = -ENOMEM;
+			goto err;
+		}
+
+		snprintf(name, len, "%s-%d", old_name, dup++);
+		goto duplicate_name;
+	}
+
 	err = kobject_init_and_add(&slot->kobj, &pci_slot_ktype, NULL,
 				   "%s", name);
 	if (err) {
@@ -158,6 +207,8 @@ placeholder:
 	up_write(&pci_bus_sem);
 	return slot;
  err:
+	kfree(old_name);
+ err_oldname:
 	kfree(slot);
 	slot = ERR_PTR(err);
 	goto out;
@@ -172,7 +223,7 @@ EXPORT_SYMBOL_GPL(pci_create_slot);
  * The primary purpose of this interface is to allow callers who earlier
  * created a placeholder slot in pci_create_slot() by passing a -1 as
  * slot_nr, to update their %struct pci_slot with the correct @slot_nr.
- */
+ **/
 
 void pci_update_slot_number(struct pci_slot *slot, int slot_nr)
 {
@@ -202,7 +253,7 @@ EXPORT_SYMBOL_GPL(pci_update_slot_number);
  * %struct pci_slot is refcounted, so destroying them is really easy; we
  * just call kobject_put on its kobj and let our release methods do the
  * rest.
- */
+ **/
 
 void pci_destroy_slot(struct pci_slot *slot)
 {
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 825be38..4b6e847 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -509,7 +509,7 @@ struct pci_bus *pci_create_bus(struct device *parent, int bus,
 struct pci_bus *pci_add_new_bus(struct pci_bus *parent, struct pci_dev *dev,
 				int busnr);
 struct pci_slot *pci_create_slot(struct pci_bus *parent, int slot_nr,
-				 const char *name);
+				 char *name);
 void pci_destroy_slot(struct pci_slot *slot);
 void pci_update_slot_number(struct pci_slot *slot, int slot_nr);
 int pci_scan_slot(struct pci_bus *bus, int devfn);
-- 
1.6.0.rc0.g95f8

