Return-Path: <linux-kernel-owner+w=401wt.eu-S1760649AbYHUVNq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760649AbYHUVNq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 17:13:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755353AbYHUVNc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 17:13:32 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:28882 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752053AbYHUVNb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 17:13:31 -0400
Date: Thu, 21 Aug 2008 15:13:29 -0600
From: Alex Chiang <achiang@hp.com>
To: jbarnes@virtuousgeek.org, kaneshige.kenji@jp.fujitsu.com,
       linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] pciehp: Rename duplicate slot name N as N-1, N-2,
	N-M...
Message-ID: <20080821211329.GA20014@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>, jbarnes@virtuousgeek.org,
	kaneshige.kenji@jp.fujitsu.com, linux-pci@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <20080821211137.GB24411@ldl.fc.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080821211137.GB24411@ldl.fc.hp.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 3800345f723fd130d50434d4717b99d4a9f383c8 (pciehp: fix slot name)
introduces the pciehp_slot_with_bus module parameter, which was intended
to help work around broken firmware that assigns the same name to multiple
slots.

Commit 9e4f2e8d4ddb04ad16a3828cd9a369a5a5287009 (pciehp: add message about
pciehp_slot_with_bus option) tells the user to use the above parameter
in the event of a name collision.

This approach is sub-optimal because it requires too much work from
the user.

Instead, let's rename the slot on behalf of the user. If firmware
assigns the name N to multiple slots, then:

	The first registered slot is assigned N
	The second registered slot is assigned N-1
	The third registered slot is assigned N-2
	The Mth registered slot becomes N-M

In the event we overflow the slot->name parameter, we report an
error to the user.

This is a temporary fix until the entire PCI core can be reworked
such that individual drivers no longer have to manage their own
slot names.

Signed-off-by: Alex Chiang <achiang@hp.com>
---
 drivers/pci/hotplug/pciehp.h      |    1 -
 drivers/pci/hotplug/pciehp_core.c |   21 ++++++++++++++-------
 drivers/pci/hotplug/pciehp_hpc.c  |   11 +----------
 3 files changed, 15 insertions(+), 18 deletions(-)

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
index 3677495..4fd5355 100644
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
 
@@ -194,6 +191,7 @@ static int init_slots(struct controller *ctrl)
 	struct slot *slot;
 	struct hotplug_slot *hotplug_slot;
 	struct hotplug_slot_info *info;
+	int len, dup = 1;
 	int retval = -ENOMEM;
 
 	list_for_each_entry(slot, &ctrl->slot_list, slot_list) {
@@ -220,15 +218,24 @@ static int init_slots(struct controller *ctrl)
 		dbg("Registering bus=%x dev=%x hp_slot=%x sun=%x "
 		    "slot_device_offset=%x\n", slot->bus, slot->device,
 		    slot->hp_slot, slot->number, ctrl->slot_device_offset);
+duplicate_name:
 		retval = pci_hp_register(hotplug_slot,
 					 ctrl->pci_dev->subordinate,
 					 slot->device);
 		if (retval) {
+			/*
+			 * If slot N already exists, we'll try to create
+			 * slot N-1, N-2 ... N-M, until we overflow.
+			 */
+			if (retval == -EEXIST) {
+				len = snprintf(slot->name, SLOT_NAME_SIZE,
+					       "%d-%d", slot->number, dup++);
+				if (len < SLOT_NAME_SIZE)
+					goto duplicate_name;
+				else
+					err("duplicate slot name overflow\n");
+			}
 			err("pci_hp_register failed with error %d\n", retval);
-			if (retval == -EEXIST)
-				err("Failed to register slot because of name "
-				    "collision. Try \'pciehp_slot_with_bus\' "
-				    "module option.\n");
 			goto error_info;
 		}
 		/* create additional sysfs entries */
diff --git a/drivers/pci/hotplug/pciehp_hpc.c b/drivers/pci/hotplug/pciehp_hpc.c
index ad27e9e..ab31f5b 100644
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
@@ -1053,7 +1044,7 @@ static int pcie_init_slot(struct controller *ctrl)
 	slot->device = ctrl->slot_device_offset + slot->hp_slot;
 	slot->hpc_ops = ctrl->hpc_ops;
 	slot->number = ctrl->first_slot;
-	make_slot_name(slot);
+	snprintf(slot->name, SLOT_NAME_SIZE, "%d", slot->number);
 	mutex_init(&slot->lock);
 	INIT_DELAYED_WORK(&slot->work, pciehp_queue_pushbutton_work);
 	list_add(&slot->slot_list, &ctrl->slot_list);
-- 
1.6.0.rc0.g95f8

