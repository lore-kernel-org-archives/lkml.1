Return-Path: <linux-kernel-owner+w=401wt.eu-S1755492AbYIIKCW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755492AbYIIKCW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 06:02:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752224AbYIIKAg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 06:00:36 -0400
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:40166 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754513AbYIIKAd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 06:00:33 -0400
From: Alex Chiang <achiang@hp.com>
Subject: [PATCH v2 06/13] PCI: cpqphp: stop managing hotplug_slot->name
To: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: jbarnes@virtuousgeek.org, kristen.c.accardi@intel.com,
       Alex Chiang <achiang@hp.com>
Date: Tue, 09 Sep 2008 04:00:32 -0600
Message-ID: <20080909100032.29542.18371.stgit@bob.kio>
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

We no longer need to manage our version of hotplug_slot->name
since the PCI and hotplug core manage it on our behalf.

Now, we simply advise the PCI core of the name that we would
like, and let the core take care of the rest.

Cc: jbarnes@virtuousgeek.org
Cc: kristen.c.accardi@intel.com
Signed-off-by: Alex Chiang <achiang@hp.com>
---

 drivers/pci/hotplug/cpqphp.h      |   13 +++++-------
 drivers/pci/hotplug/cpqphp_core.c |   39 +++++++++++++++++--------------------
 2 files changed, 23 insertions(+), 29 deletions(-)

diff --git a/drivers/pci/hotplug/cpqphp.h b/drivers/pci/hotplug/cpqphp.h
index b1decfa..afaf8f6 100644
--- a/drivers/pci/hotplug/cpqphp.h
+++ b/drivers/pci/hotplug/cpqphp.h
@@ -449,6 +449,11 @@ extern u8 cpqhp_disk_irq;
 
 /* inline functions */
 
+static inline char *slot_name(struct slot *slot)
+{
+	return hotplug_slot_name(slot->hotplug_slot);
+}
+
 /*
  * return_resource
  *
@@ -696,14 +701,6 @@ static inline int get_presence_status(struct controller *ctrl, struct slot *slot
 	return presence_save;
 }
 
-#define SLOT_NAME_SIZE 10
-
-static inline void make_slot_name(char *buffer, int buffer_size, struct slot *slot)
-{
-	snprintf(buffer, buffer_size, "%d", slot->number);
-}
-
-
 static inline int wait_for_ctrl_irq(struct controller *ctrl)
 {
         DECLARE_WAITQUEUE(wait, current);
diff --git a/drivers/pci/hotplug/cpqphp_core.c b/drivers/pci/hotplug/cpqphp_core.c
index a7fe458..008ae5d 100644
--- a/drivers/pci/hotplug/cpqphp_core.c
+++ b/drivers/pci/hotplug/cpqphp_core.c
@@ -315,14 +315,15 @@ static void release_slot(struct hotplug_slot *hotplug_slot)
 {
 	struct slot *slot = hotplug_slot->private;
 
-	dbg("%s - physical_slot = %s\n", __func__, hotplug_slot->name);
+	dbg("%s - physical_slot = %s\n", __func__, slot_name(slot));
 
 	kfree(slot->hotplug_slot->info);
-	kfree(slot->hotplug_slot->name);
 	kfree(slot->hotplug_slot);
 	kfree(slot);
 }
 
+#define SLOT_NAME_SIZE 10
+
 static int ctrl_slot_setup(struct controller *ctrl,
 			void __iomem *smbios_start,
 			void __iomem *smbios_table)
@@ -335,6 +336,7 @@ static int ctrl_slot_setup(struct controller *ctrl,
 	u8 slot_number;
 	u8 ctrl_slot;
 	u32 tempdword;
+	char name[SLOT_NAME_SIZE];
 	void __iomem *slot_entry= NULL;
 	int result = -ENOMEM;
 
@@ -363,10 +365,6 @@ static int ctrl_slot_setup(struct controller *ctrl,
 		if (!hotplug_slot->info)
 			goto error_hpslot;
 		hotplug_slot_info = hotplug_slot->info;
-		hotplug_slot->name = kmalloc(SLOT_NAME_SIZE, GFP_KERNEL);
-
-		if (!hotplug_slot->name)
-			goto error_info;
 
 		slot->ctrl = ctrl;
 		slot->bus = ctrl->bus;
@@ -418,8 +416,9 @@ static int ctrl_slot_setup(struct controller *ctrl,
 		/* register this slot with the hotplug pci core */
 		hotplug_slot->release = &release_slot;
 		hotplug_slot->private = slot;
-		make_slot_name(hotplug_slot->name, SLOT_NAME_SIZE, slot);
 		hotplug_slot->ops = &cpqphp_hotplug_slot_ops;
+
+		scnprintf(name, SLOT_NAME_SIZE, "%d", slot->number);
 		
 		hotplug_slot_info->power_status = get_slot_enabled(ctrl, slot);
 		hotplug_slot_info->attention_status =
@@ -437,10 +436,10 @@ static int ctrl_slot_setup(struct controller *ctrl,
 		result = pci_hp_register(hotplug_slot,
 					 ctrl->pci_dev->subordinate,
 					 slot->device,
-					 hotplug_slot->name);
+					 name);
 		if (result) {
 			err("pci_hp_register failed with error %d\n", result);
-			goto error_name;
+			goto error_info;
 		}
 		
 		slot->next = ctrl->slot;
@@ -452,8 +451,6 @@ static int ctrl_slot_setup(struct controller *ctrl,
 	}
 
 	return 0;
-error_name:
-	kfree(hotplug_slot->name);
 error_info:
 	kfree(hotplug_slot_info);
 error_hpslot:
@@ -639,7 +636,7 @@ static int set_attention_status (struct hotplug_slot *hotplug_slot, u8 status)
 	u8 device;
 	u8 function;
 
-	dbg("%s - physical_slot = %s\n", __func__, hotplug_slot->name);
+	dbg("%s - physical_slot = %s\n", __func__, slot_name(slot));
 
 	if (cpqhp_get_bus_dev(ctrl, &bus, &devfn, slot->number) == -1)
 		return -ENODEV;
@@ -666,7 +663,7 @@ static int process_SI(struct hotplug_slot *hotplug_slot)
 	u8 device;
 	u8 function;
 
-	dbg("%s - physical_slot = %s\n", __func__, hotplug_slot->name);
+	dbg("%s - physical_slot = %s\n", __func__, slot_name(slot));
 
 	if (cpqhp_get_bus_dev(ctrl, &bus, &devfn, slot->number) == -1)
 		return -ENODEV;
@@ -698,7 +695,7 @@ static int process_SS(struct hotplug_slot *hotplug_slot)
 	u8 device;
 	u8 function;
 
-	dbg("%s - physical_slot = %s\n", __func__, hotplug_slot->name);
+	dbg("%s - physical_slot = %s\n", __func__, slot_name(slot));
 
 	if (cpqhp_get_bus_dev(ctrl, &bus, &devfn, slot->number) == -1)
 		return -ENODEV;
@@ -721,7 +718,7 @@ static int hardware_test(struct hotplug_slot *hotplug_slot, u32 value)
 	struct slot *slot = hotplug_slot->private;
 	struct controller *ctrl = slot->ctrl;
 
-	dbg("%s - physical_slot = %s\n", __func__, hotplug_slot->name);
+	dbg("%s - physical_slot = %s\n", __func__, slot_name(slot));
 
 	return cpqhp_hardware_test(ctrl, value);	
 }
@@ -732,7 +729,7 @@ static int get_power_status(struct hotplug_slot *hotplug_slot, u8 *value)
 	struct slot *slot = hotplug_slot->private;
 	struct controller *ctrl = slot->ctrl;
 
-	dbg("%s - physical_slot = %s\n", __func__, hotplug_slot->name);
+	dbg("%s - physical_slot = %s\n", __func__, slot_name(slot));
 
 	*value = get_slot_enabled(ctrl, slot);
 	return 0;
@@ -743,7 +740,7 @@ static int get_attention_status(struct hotplug_slot *hotplug_slot, u8 *value)
 	struct slot *slot = hotplug_slot->private;
 	struct controller *ctrl = slot->ctrl;
 	
-	dbg("%s - physical_slot = %s\n", __func__, hotplug_slot->name);
+	dbg("%s - physical_slot = %s\n", __func__, slot_name(slot));
 
 	*value = cpq_get_attention_status(ctrl, slot);
 	return 0;
@@ -754,7 +751,7 @@ static int get_latch_status(struct hotplug_slot *hotplug_slot, u8 *value)
 	struct slot *slot = hotplug_slot->private;
 	struct controller *ctrl = slot->ctrl;
 
-	dbg("%s - physical_slot = %s\n", __func__, hotplug_slot->name);
+	dbg("%s - physical_slot = %s\n", __func__, slot_name(slot));
 
 	*value = cpq_get_latch_status(ctrl, slot);
 
@@ -766,7 +763,7 @@ static int get_adapter_status(struct hotplug_slot *hotplug_slot, u8 *value)
 	struct slot *slot = hotplug_slot->private;
 	struct controller *ctrl = slot->ctrl;
 
-	dbg("%s - physical_slot = %s\n", __func__, hotplug_slot->name);
+	dbg("%s - physical_slot = %s\n", __func__, slot_name(slot));
 
 	*value = get_presence_status(ctrl, slot);
 
@@ -778,7 +775,7 @@ static int get_max_bus_speed (struct hotplug_slot *hotplug_slot, enum pci_bus_sp
 	struct slot *slot = hotplug_slot->private;
 	struct controller *ctrl = slot->ctrl;
 
-	dbg("%s - physical_slot = %s\n", __func__, hotplug_slot->name);
+	dbg("%s - physical_slot = %s\n", __func__, slot_name(slot));
 
 	*value = ctrl->speed_capability;
 
@@ -790,7 +787,7 @@ static int get_cur_bus_speed (struct hotplug_slot *hotplug_slot, enum pci_bus_sp
 	struct slot *slot = hotplug_slot->private;
 	struct controller *ctrl = slot->ctrl;
 
-	dbg("%s - physical_slot = %s\n", __func__, hotplug_slot->name);
+	dbg("%s - physical_slot = %s\n", __func__, slot_name(slot));
 
 	*value = ctrl->speed;
 

