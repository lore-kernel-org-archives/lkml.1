Return-Path: <linux-kernel-owner+w=401wt.eu-S1756565AbYIIKBo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756565AbYIIKBo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 06:01:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753864AbYIIKAZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 06:00:25 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:38174 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753780AbYIIKAX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 06:00:23 -0400
From: Alex Chiang <achiang@hp.com>
Subject: [PATCH v2 04/13] PCI: acpiphp: remove 'name' parameter
To: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: jbarnes@virtuousgeek.org, kristen.c.accardi@intel.com,
       kaneshige.kenji@jp.fujitsu.com, Alex Chiang <achiang@hp.com>
Date: Tue, 09 Sep 2008 04:00:22 -0600
Message-ID: <20080909100022.29542.90739.stgit@bob.kio>
In-Reply-To: <20080909091813.29542.85613.stgit@bob.kio>
References: <20080909091813.29542.85613.stgit@bob.kio>
User-Agent: StGIT/0.14.3.215.gff3d
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We do not need to manage our own name parameter, especially since
the PCI core can change it on our behalf, in the case of duplicate
slot names.

Remove 'name' from acpiphp's version of struct slot.

Cc: jbarnes@virtuousgeek.org
Cc: kristen.c.accardi@intel.com
Cc: kaneshige.kenji@jp.fujitsu.com
Signed-off-by: Alex Chiang <achiang@hp.com>
---

 drivers/pci/hotplug/acpiphp.h      |    9 +++++----
 drivers/pci/hotplug/acpiphp_core.c |   31 ++++++++++++++++---------------
 2 files changed, 21 insertions(+), 19 deletions(-)

diff --git a/drivers/pci/hotplug/acpiphp.h b/drivers/pci/hotplug/acpiphp.h
index 5a58b07..f9e244d 100644
--- a/drivers/pci/hotplug/acpiphp.h
+++ b/drivers/pci/hotplug/acpiphp.h
@@ -50,9 +50,6 @@
 #define info(format, arg...) printk(KERN_INFO "%s: " format, MY_NAME , ## arg)
 #define warn(format, arg...) printk(KERN_WARNING "%s: " format, MY_NAME , ## arg)
 
-/* name size which is used for entries in pcihpfs */
-#define SLOT_NAME_SIZE	20		/* {_SUN} */
-
 struct acpiphp_bridge;
 struct acpiphp_slot;
 
@@ -63,9 +60,13 @@ struct slot {
 	struct hotplug_slot	*hotplug_slot;
 	struct acpiphp_slot	*acpi_slot;
 	struct hotplug_slot_info info;
-	char name[SLOT_NAME_SIZE];
 };
 
+static inline const char *slot_name(struct slot *slot)
+{
+	return hotplug_slot_name(slot->hotplug_slot);
+}
+
 /*
  * struct acpiphp_bridge - PCI bridge information
  *
diff --git a/drivers/pci/hotplug/acpiphp_core.c b/drivers/pci/hotplug/acpiphp_core.c
index e984176..55b2b77 100644
--- a/drivers/pci/hotplug/acpiphp_core.c
+++ b/drivers/pci/hotplug/acpiphp_core.c
@@ -44,6 +44,9 @@
 
 #define MY_NAME	"acpiphp"
 
+/* name size which is used for entries in pcihpfs */
+#define SLOT_NAME_SIZE  20              /* {_SUN} */
+
 static int debug;
 int acpiphp_debug;
 
@@ -84,7 +87,6 @@ static struct hotplug_slot_ops acpi_hotplug_slot_ops = {
 	.get_adapter_status	= get_adapter_status,
 };
 
-
 /**
  * acpiphp_register_attention - set attention LED callback
  * @info: must be completely filled with LED callbacks
@@ -136,7 +138,7 @@ static int enable_slot(struct hotplug_slot *hotplug_slot)
 {
 	struct slot *slot = hotplug_slot->private;
 
-	dbg("%s - physical_slot = %s\n", __func__, hotplug_slot->name);
+	dbg("%s - physical_slot = %s\n", __func__, slot_name(slot));
 
 	/* enable the specified slot */
 	return acpiphp_enable_slot(slot->acpi_slot);
@@ -154,7 +156,7 @@ static int disable_slot(struct hotplug_slot *hotplug_slot)
 	struct slot *slot = hotplug_slot->private;
 	int retval;
 
-	dbg("%s - physical_slot = %s\n", __func__, hotplug_slot->name);
+	dbg("%s - physical_slot = %s\n", __func__, slot_name(slot));
 
 	/* disable the specified slot */
 	retval = acpiphp_disable_slot(slot->acpi_slot);
@@ -177,7 +179,7 @@ static int disable_slot(struct hotplug_slot *hotplug_slot)
  {
 	int retval = -ENODEV;
 
- 	dbg("%s - physical_slot = %s\n", __func__, hotplug_slot->name);
+	dbg("%s - physical_slot = %s\n", __func__, hotplug_slot_name(hotplug_slot));
  
 	if (attention_info && try_module_get(attention_info->owner)) {
 		retval = attention_info->set_attn(hotplug_slot, status);
@@ -200,7 +202,7 @@ static int get_power_status(struct hotplug_slot *hotplug_slot, u8 *value)
 {
 	struct slot *slot = hotplug_slot->private;
 
-	dbg("%s - physical_slot = %s\n", __func__, hotplug_slot->name);
+	dbg("%s - physical_slot = %s\n", __func__, slot_name(slot));
 
 	*value = acpiphp_get_power_status(slot->acpi_slot);
 
@@ -222,7 +224,7 @@ static int get_attention_status(struct hotplug_slot *hotplug_slot, u8 *value)
 {
 	int retval = -EINVAL;
 
-	dbg("%s - physical_slot = %s\n", __func__, hotplug_slot->name);
+	dbg("%s - physical_slot = %s\n", __func__, hotplug_slot_name(hotplug_slot));
 
 	if (attention_info && try_module_get(attention_info->owner)) {
 		retval = attention_info->get_attn(hotplug_slot, value);
@@ -245,7 +247,7 @@ static int get_latch_status(struct hotplug_slot *hotplug_slot, u8 *value)
 {
 	struct slot *slot = hotplug_slot->private;
 
-	dbg("%s - physical_slot = %s\n", __func__, hotplug_slot->name);
+	dbg("%s - physical_slot = %s\n", __func__, slot_name(slot));
 
 	*value = acpiphp_get_latch_status(slot->acpi_slot);
 
@@ -265,7 +267,7 @@ static int get_adapter_status(struct hotplug_slot *hotplug_slot, u8 *value)
 {
 	struct slot *slot = hotplug_slot->private;
 
-	dbg("%s - physical_slot = %s\n", __func__, hotplug_slot->name);
+	dbg("%s - physical_slot = %s\n", __func__, slot_name(slot));
 
 	*value = acpiphp_get_adapter_status(slot->acpi_slot);
 
@@ -299,7 +301,7 @@ static void release_slot(struct hotplug_slot *hotplug_slot)
 {
 	struct slot *slot = hotplug_slot->private;
 
-	dbg("%s - physical_slot = %s\n", __func__, hotplug_slot->name);
+	dbg("%s - physical_slot = %s\n", __func__, slot_name(slot));
 
 	kfree(slot->hotplug_slot);
 	kfree(slot);
@@ -310,6 +312,7 @@ int acpiphp_register_hotplug_slot(struct acpiphp_slot *acpiphp_slot)
 {
 	struct slot *slot;
 	int retval = -ENOMEM;
+	char name[SLOT_NAME_SIZE];
 
 	slot = kzalloc(sizeof(*slot), GFP_KERNEL);
 	if (!slot)
@@ -321,8 +324,6 @@ int acpiphp_register_hotplug_slot(struct acpiphp_slot *acpiphp_slot)
 
 	slot->hotplug_slot->info = &slot->info;
 
-	slot->hotplug_slot->name = slot->name;
-
 	slot->hotplug_slot->private = slot;
 	slot->hotplug_slot->release = &release_slot;
 	slot->hotplug_slot->ops = &acpi_hotplug_slot_ops;
@@ -336,12 +337,12 @@ int acpiphp_register_hotplug_slot(struct acpiphp_slot *acpiphp_slot)
 	slot->hotplug_slot->info->cur_bus_speed = PCI_SPEED_UNKNOWN;
 
 	acpiphp_slot->slot = slot;
-	snprintf(slot->name, sizeof(slot->name), "%u", slot->acpi_slot->sun);
+	scnprintf(name, SLOT_NAME_SIZE, "%u", slot->acpi_slot->sun);
 
 	retval = pci_hp_register(slot->hotplug_slot,
 					acpiphp_slot->bridge->pci_bus,
 					acpiphp_slot->device,
-					slot->name);
+					name);
 	if (retval == -EBUSY)
 		goto error_hpslot;
 	if (retval) {
@@ -349,7 +350,7 @@ int acpiphp_register_hotplug_slot(struct acpiphp_slot *acpiphp_slot)
 		goto error_hpslot;
  	}
 
-	info("Slot [%s] registered\n", slot->hotplug_slot->name);
+	info("Slot [%s] registered\n", slot_name(slot));
 
 	return 0;
 error_hpslot:
@@ -366,7 +367,7 @@ void acpiphp_unregister_hotplug_slot(struct acpiphp_slot *acpiphp_slot)
 	struct slot *slot = acpiphp_slot->slot;
 	int retval = 0;
 
-	info ("Slot [%s] unregistered\n", slot->hotplug_slot->name);
+	info("Slot [%s] unregistered\n", slot_name(slot));
 
 	retval = pci_hp_deregister(slot->hotplug_slot);
 	if (retval)

