Return-Path: <linux-kernel-owner+w=401wt.eu-S1754888AbYHQAQe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754888AbYHQAQe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2008 20:16:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752511AbYHQAQ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Aug 2008 20:16:26 -0400
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:9645 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751878AbYHQAQZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2008 20:16:25 -0400
From: Alex Chiang <achiang@hp.com>
Subject: [PATCH 02/13] PCI: prevent duplicate slot names
To: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Cc: jbarnes@virtuousgeek.org, kristen.c.accardi@intel.com, matthew@wil.cx,
       kaneshige.kenji@jp.fujitsu.com, Alex Chiang <achiang@hp.com>
Date: Sat, 16 Aug 2008 18:16:23 -0600
Message-ID: <20080817001516.5461.59384.stgit@blender.achiang>
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

Prevent callers of pci_create_slot() from registering slots with
duplicate names. This condition occurs most often when PCI hotplug
drivers are loaded on platforms with broken firmware that assigns
identical names to multiple slots.

We now rename these duplicate slots on behalf of the user.

If firmware assigns the name N to multiple slots, then:

	The first registered slot is assigned N
	The second registered slot is assigned N-1
	The third registered slot is assigned N-2
	The Mth registered slot becomes N-M

A side effect of this patch is that the error condition for when
multiple drivers attempt to claim the same slot becomes much more
prominent.

In other words, the previous error condition returned for
duplicate slot names (-EEXIST) masked the case when multiple
drivers attempted to claim the same slot. Now, the -EBUSY return
makes the true error more obvious.

Finally, since we now prevent duplicate slot names, we remove
the logic introduced by the following commits:

	pci hotplug core: add check of duplicate slot name
	a86161b3134465f072d965ca7508ec9c1e2e52c7

	pciehp: fix slot name
	3800345f723fd130d50434d4717b99d4a9f383c8

	pciehp: add message about pciehp_slot_with_bus option
	9e4f2e8d4ddb04ad16a3828cd9a369a5a5287009

	shpchp: fix slot name
	ef0ff95f136f0f2d035667af5d18b824609de320

	shpchp: add message about shpchp_slot_with_bus option
	b3bd307c628af2f0a581c42d5d7e4bcdbbf64b6a

Cc: jbarnes@virtuousgeek.org
Cc: kristen.c.accardi@intel.com
Cc: matthew@wil.cx
Cc: kaneshige.kenji@jp.fujitsu.com
Signed-off-by: Alex Chiang <achiang@hp.com>
---

 drivers/pci/hotplug/pci_hotplug_core.c |    4 -
 drivers/pci/hotplug/pciehp.h           |    1 
 drivers/pci/hotplug/pciehp_core.c      |    7 --
 drivers/pci/hotplug/pciehp_hpc.c       |    6 --
 drivers/pci/hotplug/shpchp_core.c      |   14 -----
 drivers/pci/slot.c                     |   93 +++++++++++++++++++++++++-------
 6 files changed, 76 insertions(+), 49 deletions(-)

diff --git a/drivers/pci/hotplug/pci_hotplug_core.c b/drivers/pci/hotplug/pci_hotplug_core.c
index 96f274e..da5908f 100644
--- a/drivers/pci/hotplug/pci_hotplug_core.c
+++ b/drivers/pci/hotplug/pci_hotplug_core.c
@@ -570,10 +570,6 @@ int pci_hp_register(struct hotplug_slot *slot, struct pci_bus *bus, int slot_nr,
 		return -EINVAL;
 	}
 
-	/* Check if we have already registered a slot with the same name. */
-	if (get_slot_from_name(name))
-		return -EEXIST;
-
 	/*
 	 * No problems if we call this interface from both ACPI_PCI_SLOT
 	 * driver and call it here again. If we've already created the
diff --git a/drivers/pci/hotplug/pciehp.h b/drivers/pci/hotplug/pciehp.h
index e3a1e7e..9e6cec6 100644
--- a/drivers/pci/hotplug/pciehp.h
+++ b/drivers/pci/hotplug/pciehp.h
@@ -43,7 +43,6 @@ extern int pciehp_poll_mode;
 extern int pciehp_poll_time;
 extern int pciehp_debug;
 extern int pciehp_force;
-extern int pciehp_slot_with_bus;
 extern struct workqueue_struct *pciehp_wq;
 
 #define dbg(format, arg...)						\
diff --git a/drivers/pci/hotplug/pciehp_core.c b/drivers/pci/hotplug/pciehp_core.c
index 5952315..bed77af 100644
--- a/drivers/pci/hotplug/pciehp_core.c
+++ b/drivers/pci/hotplug/pciehp_core.c
@@ -41,7 +41,6 @@ int pciehp_debug;
 int pciehp_poll_mode;
 int pciehp_poll_time;
 int pciehp_force;
-int pciehp_slot_with_bus;
 struct workqueue_struct *pciehp_wq;
 
 #define DRIVER_VERSION	"0.4"
@@ -56,12 +55,10 @@ module_param(pciehp_debug, bool, 0644);
 module_param(pciehp_poll_mode, bool, 0644);
 module_param(pciehp_poll_time, int, 0644);
 module_param(pciehp_force, bool, 0644);
-module_param(pciehp_slot_with_bus, bool, 0644);
 MODULE_PARM_DESC(pciehp_debug, "Debugging mode enabled or not");
 MODULE_PARM_DESC(pciehp_poll_mode, "Using polling mechanism for hot-plug events or not");
 MODULE_PARM_DESC(pciehp_poll_time, "Polling mechanism frequency, in seconds");
 MODULE_PARM_DESC(pciehp_force, "Force pciehp, even if _OSC and OSHP are missing");
-MODULE_PARM_DESC(pciehp_slot_with_bus, "Use bus number in the slot name");
 
 #define PCIE_MODULE_NAME "pciehp"
 
@@ -226,10 +223,6 @@ static int init_slots(struct controller *ctrl)
 					 slot->name);
 		if (retval) {
 			err("pci_hp_register failed with error %d\n", retval);
-			if (retval == -EEXIST)
-				err("Failed to register slot because of name "
-				    "collision. Try \'pciehp_slot_with_bus\' "
-				    "module option.\n");
 			goto error_info;
 		}
 		/* create additional sysfs entries */
diff --git a/drivers/pci/hotplug/pciehp_hpc.c b/drivers/pci/hotplug/pciehp_hpc.c
index ad27e9e..43ff979 100644
--- a/drivers/pci/hotplug/pciehp_hpc.c
+++ b/drivers/pci/hotplug/pciehp_hpc.c
@@ -1032,11 +1032,7 @@ static void pcie_shutdown_notification(struct controller *ctrl)
 
 static void make_slot_name(struct slot *slot)
 {
-	if (pciehp_slot_with_bus)
-		snprintf(slot->name, SLOT_NAME_SIZE, "%04d_%04d",
-			 slot->bus, slot->number);
-	else
-		snprintf(slot->name, SLOT_NAME_SIZE, "%d", slot->number);
+	snprintf(slot->name, SLOT_NAME_SIZE, "%d", slot->number);
 }
 
 static int pcie_init_slot(struct controller *ctrl)
diff --git a/drivers/pci/hotplug/shpchp_core.c b/drivers/pci/hotplug/shpchp_core.c
index 7bc06c0..136d9ea 100644
--- a/drivers/pci/hotplug/shpchp_core.c
+++ b/drivers/pci/hotplug/shpchp_core.c
@@ -39,7 +39,6 @@
 int shpchp_debug;
 int shpchp_poll_mode;
 int shpchp_poll_time;
-static int shpchp_slot_with_bus;
 struct workqueue_struct *shpchp_wq;
 
 #define DRIVER_VERSION	"0.4"
@@ -53,11 +52,9 @@ MODULE_LICENSE("GPL");
 module_param(shpchp_debug, bool, 0644);
 module_param(shpchp_poll_mode, bool, 0644);
 module_param(shpchp_poll_time, int, 0644);
-module_param(shpchp_slot_with_bus, bool, 0644);
 MODULE_PARM_DESC(shpchp_debug, "Debugging mode enabled or not");
 MODULE_PARM_DESC(shpchp_poll_mode, "Using polling mechanism for hot-plug events or not");
 MODULE_PARM_DESC(shpchp_poll_time, "Polling mechanism frequency, in seconds");
-MODULE_PARM_DESC(shpchp_slot_with_bus, "Use bus number in the slot name");
 
 #define SHPC_MODULE_NAME "shpchp"
 
@@ -101,12 +98,7 @@ static void release_slot(struct hotplug_slot *hotplug_slot)
 
 static void make_slot_name(struct slot *slot)
 {
-	if (shpchp_slot_with_bus)
-		snprintf(slot->hotplug_slot->name, SLOT_NAME_SIZE, "%04d_%04d",
-			 slot->bus, slot->number);
-	else
-		snprintf(slot->hotplug_slot->name, SLOT_NAME_SIZE, "%d",
-			 slot->number);
+	snprintf(slot->hotplug_slot->name, SLOT_NAME_SIZE, "%d", slot->number);
 }
 
 static int init_slots(struct controller *ctrl)
@@ -162,10 +154,6 @@ static int init_slots(struct controller *ctrl)
 				hotplug_slot->name);
 		if (retval) {
 			err("pci_hp_register failed with error %d\n", retval);
-			if (retval == -EEXIST)
-				err("Failed to register slot because of name "
-                                    "collision. Try \'shpchp_slot_with_bus\' "
-				    "module option.\n");
 			goto error_info;
 		}
 
diff --git a/drivers/pci/slot.c b/drivers/pci/slot.c
index 7e5b85c..42f0e12 100644
--- a/drivers/pci/slot.c
+++ b/drivers/pci/slot.c
@@ -73,6 +73,50 @@ static struct kobj_type pci_slot_ktype = {
 	.default_attrs = pci_slot_default_attrs,
 };
 
+static char *make_slot_name(const char *name)
+{
+	char *new_name;
+	int len, width, dup = 1;
+	struct kobject *dup_slot;
+
+	new_name = kstrdup(name, GFP_KERNEL);
+	if (!new_name)
+		goto out;
+
+	/*
+	 * Start off allocating enough room for "name-X"
+	 */
+	len = strlen(name) + 2;
+	width = 1;
+
+try_again:
+	dup_slot = kset_find_obj(pci_slots_kset, new_name);
+	if (!dup_slot)
+		goto out;
+
+	/*
+	 * We hit this the first time through, which gives us
+	 * space for terminating NULL, and then every power of 10
+	 * afterwards, which gives us space to add another digit
+	 * to "name-XX..."
+	 */
+	if (dup % width == 0) {
+		len++;
+		width *= 10;
+	}
+
+	new_name = krealloc(new_name, len, GFP_KERNEL);
+	if (!new_name)
+		goto out;
+
+	memset(new_name, 0, len);
+	snprintf(new_name, len, "%s-%d", name, dup++);
+	goto try_again;
+
+out:
+	return new_name;
+}
+
 /**
  * pci_create_slot - create or increment refcount for physical PCI slot
  * @parent: struct pci_bus of parent bridge
@@ -84,7 +128,19 @@ static struct kobj_type pci_slot_ktype = {
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
@@ -103,13 +159,13 @@ static struct kobj_type pci_slot_ktype = {
  * consist solely of a dddd:bb tuple, where dddd is the PCI domain of the
  * %struct pci_bus and bb is the bus number. In other words, the devfn of
  * the 'placeholder' slot will not be displayed.
- */
-
+ **/
 struct pci_slot *pci_create_slot(struct pci_bus *parent, int slot_nr,
 				 const char *name)
 {
 	struct pci_slot *slot;
-	int err;
+	int err = 0;
+	char *slot_name = NULL;
 
 	down_write(&pci_bus_sem);
 
@@ -138,12 +194,18 @@ placeholder:
 
 	slot->bus = parent;
 	slot->number = slot_nr;
-
 	slot->kobj.kset = pci_slots_kset;
+
+	slot_name = make_slot_name(name);
+	if (!slot_name) {
+		slot = ERR_PTR(-ENOMEM);
+		goto err;
+	}
+
 	err = kobject_init_and_add(&slot->kobj, &pci_slot_ktype, NULL,
-				   "%s", name);
+				   "%s", slot_name);
 	if (err) {
-		printk(KERN_ERR "Unable to register kobject %s\n", name);
+		printk(KERN_ERR "Unable to register kobject %s\n", slot_name);
 		goto err;
 	}
 
@@ -155,6 +217,8 @@ placeholder:
 		 __func__, pci_domain_nr(parent), parent->number, slot_nr);
 
  out:
+	if (slot_name)
+		kfree(slot_name);
 	up_write(&pci_bus_sem);
 	return slot;
  err:
@@ -172,23 +236,15 @@ EXPORT_SYMBOL_GPL(pci_create_slot);
  * The primary purpose of this interface is to allow callers who earlier
  * created a placeholder slot in pci_create_slot() by passing a -1 as
  * slot_nr, to update their %struct pci_slot with the correct @slot_nr.
- */
-
+ **/
 void pci_update_slot_number(struct pci_slot *slot, int slot_nr)
 {
-	int name_count = 0;
 	struct pci_slot *tmp;
 
 	down_write(&pci_bus_sem);
 
-	list_for_each_entry(tmp, &slot->bus->slots, list) {
+	list_for_each_entry(tmp, &slot->bus->slots, list)
 		WARN_ON(tmp->number == slot_nr);
-		if (!strcmp(kobject_name(&tmp->kobj), kobject_name(&slot->kobj)))
-			name_count++;
-	}
-
-	if (name_count > 1)
-		printk(KERN_WARNING "pci_update_slot_number found %d slots with the same name: %s\n", name_count, kobject_name(&slot->kobj));
 
 	slot->number = slot_nr;
 	up_write(&pci_bus_sem);
@@ -202,8 +258,7 @@ EXPORT_SYMBOL_GPL(pci_update_slot_number);
  * %struct pci_slot is refcounted, so destroying them is really easy; we
  * just call kobject_put on its kobj and let our release methods do the
  * rest.
- */
-
+ **/
 void pci_destroy_slot(struct pci_slot *slot)
 {
 	pr_debug("%s: dec refcount to %d on %04x:%02x:%02x\n", __func__,

