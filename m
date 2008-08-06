Return-Path: <linux-kernel-owner+w=401wt.eu-S1763599AbYHFFLw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763599AbYHFFLw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 01:11:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761978AbYHFFLf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 01:11:35 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:31384 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761782AbYHFFLc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 01:11:32 -0400
Date: Tue, 5 Aug 2008 23:11:31 -0600
From: Alex Chiang <achiang@hp.com>
To: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Matthew Wilcox <matthew@wil.cx>, Pierre Ossman <drzeus-list@drzeus.cx>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org
Subject: [PATCH 3/7] pciehp: convert to a kmalloc'ed slot name
Message-ID: <20080806051131.GD31319@ldl.fc.hp.com>
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

Callers of pci_hp_register() need to be converted from a
char name[] to a char *name.

This change allows pci_create_slot() to dynamically rename the
sysfs name of the slot in the event of a name collision.

This change also cleans up pciehp's struct slot, removing the unused
struct task_list and moving the number member so that it is naturally
aligned, reducing the size from 180 bytes down to 116 bytes.

We also remove the pciehp_slot_with_bus module parameter which
essentially reverts commits:

	pciehp: fix slot name
	3800345f723fd130d50434d4717b99d4a9f383c8

	pciehp: add message about pciehp_slot_with_bus option
	9e4f2e8d4ddb04ad16a3828cd9a369a5a5287009

Signed-off-by: Alex Chiang <achiang@hp.com>
---
 drivers/pci/hotplug/pciehp.h      |    6 ++----
 drivers/pci/hotplug/pciehp_core.c |    7 -------
 drivers/pci/hotplug/pciehp_hpc.c  |   18 ++++++++----------
 3 files changed, 10 insertions(+), 21 deletions(-)

diff --git a/drivers/pci/hotplug/pciehp.h b/drivers/pci/hotplug/pciehp.h
index e3a1e7e..27dda64 100644
--- a/drivers/pci/hotplug/pciehp.h
+++ b/drivers/pci/hotplug/pciehp.h
@@ -43,7 +43,6 @@ extern int pciehp_poll_mode;
 extern int pciehp_poll_time;
 extern int pciehp_debug;
 extern int pciehp_force;
-extern int pciehp_slot_with_bus;
 extern struct workqueue_struct *pciehp_wq;
 
 #define dbg(format, arg...)						\
@@ -62,15 +61,14 @@ extern struct workqueue_struct *pciehp_wq;
 struct slot {
 	u8 bus;
 	u8 device;
-	u32 number;
 	u8 state;
-	struct timer_list task_event;
 	u8 hp_slot;
+	u32 number;
 	struct controller *ctrl;
 	struct hpc_ops *hpc_ops;
 	struct hotplug_slot *hotplug_slot;
 	struct list_head	slot_list;
-	char name[SLOT_NAME_SIZE];
+	char *name;
 	unsigned long last_emi_toggle;
 	struct delayed_work work;	/* work for button event */
 	struct mutex lock;
diff --git a/drivers/pci/hotplug/pciehp_core.c b/drivers/pci/hotplug/pciehp_core.c
index 3677495..6c1df8d 100644
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
 
@@ -225,10 +222,6 @@ static int init_slots(struct controller *ctrl)
 					 slot->device);
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
index ad27e9e..4ae7d58 100644
--- a/drivers/pci/hotplug/pciehp_hpc.c
+++ b/drivers/pci/hotplug/pciehp_hpc.c
@@ -1030,15 +1030,6 @@ static void pcie_shutdown_notification(struct controller *ctrl)
 	pciehp_free_irq(ctrl);
 }
 
-static void make_slot_name(struct slot *slot)
-{
-	if (pciehp_slot_with_bus)
-		snprintf(slot->name, SLOT_NAME_SIZE, "%04d_%04d",
-			 slot->bus, slot->number);
-	else
-		snprintf(slot->name, SLOT_NAME_SIZE, "%d", slot->number);
-}
-
 static int pcie_init_slot(struct controller *ctrl)
 {
 	struct slot *slot;
@@ -1047,13 +1038,19 @@ static int pcie_init_slot(struct controller *ctrl)
 	if (!slot)
 		return -ENOMEM;
 
+	slot->name = kzalloc(SLOT_NAME_SIZE, GFP_KERNEL);
+	if (!slot->name) {
+		kfree(slot);
+		return -ENOMEM;
+	}
+
 	slot->hp_slot = 0;
 	slot->ctrl = ctrl;
 	slot->bus = ctrl->pci_dev->subordinate->number;
 	slot->device = ctrl->slot_device_offset + slot->hp_slot;
 	slot->hpc_ops = ctrl->hpc_ops;
 	slot->number = ctrl->first_slot;
-	make_slot_name(slot);
+	snprintf(slot->name, SLOT_NAME_SIZE, "%d", slot->number);
 	mutex_init(&slot->lock);
 	INIT_DELAYED_WORK(&slot->work, pciehp_queue_pushbutton_work);
 	list_add(&slot->slot_list, &ctrl->slot_list);
@@ -1068,6 +1065,7 @@ static void pcie_cleanup_slot(struct controller *ctrl)
 	cancel_delayed_work(&slot->work);
 	flush_scheduled_work();
 	flush_workqueue(pciehp_wq);
+	kfree(slot->name);
 	kfree(slot);
 }
 
-- 
1.6.0.rc0.g95f8

