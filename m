Return-Path: <linux-kernel-owner+w=401wt.eu-S1762743AbYHFFMo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762743AbYHFFMo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 01:12:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755005AbYHFFMD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 01:12:03 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:20981 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763798AbYHFFMA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 01:12:00 -0400
Date: Tue, 5 Aug 2008 23:11:59 -0600
From: Alex Chiang <achiang@hp.com>
To: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Matthew Wilcox <matthew@wil.cx>, Pierre Ossman <drzeus-list@drzeus.cx>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org
Subject: [PATCH 5/7] shpchp: convert to a kmalloc'ed slot name
Message-ID: <20080806051159.GF31319@ldl.fc.hp.com>
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

This change also removes the unused struct task_event from the
slot structure.

We also remove the shpchp_slot_with_bus module parameter, which
essentially reverts commits:

	shpchp: fix slot name
	ef0ff95f136f0f2d035667af5d18b824609de320

	shpchp: add message about shpchp_slot_with_bus option
	b3bd307c628af2f0a581c42d5d7e4bcdbbf64b6a

Signed-off-by: Alex Chiang <achiang@hp.com>
---
 drivers/pci/hotplug/shpchp.h      |    5 ++---
 drivers/pci/hotplug/shpchp_core.c |   28 +++++++++-------------------
 2 files changed, 11 insertions(+), 22 deletions(-)

diff --git a/drivers/pci/hotplug/shpchp.h b/drivers/pci/hotplug/shpchp.h
index 8a026f7..8da1044 100644
--- a/drivers/pci/hotplug/shpchp.h
+++ b/drivers/pci/hotplug/shpchp.h
@@ -69,15 +69,14 @@ struct slot {
 	u8 state;
 	u8 presence_save;
 	u8 pwr_save;
-	struct timer_list task_event;
-	u8 hp_slot;
+	char *name;
 	struct controller *ctrl;
 	struct hpc_ops *hpc_ops;
 	struct hotplug_slot *hotplug_slot;
 	struct list_head	slot_list;
-	char name[SLOT_NAME_SIZE];
 	struct delayed_work work;	/* work for button event */
 	struct mutex lock;
+	u8 hp_slot;
 };
 
 struct event_info {
diff --git a/drivers/pci/hotplug/shpchp_core.c b/drivers/pci/hotplug/shpchp_core.c
index a8cbd03..c490380 100644
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
 
@@ -96,19 +93,10 @@ static void release_slot(struct hotplug_slot *hotplug_slot)
 
 	kfree(slot->hotplug_slot->info);
 	kfree(slot->hotplug_slot);
+	kfree(slot->name);
 	kfree(slot);
 }
 
-static void make_slot_name(struct slot *slot)
-{
-	if (shpchp_slot_with_bus)
-		snprintf(slot->hotplug_slot->name, SLOT_NAME_SIZE, "%04d_%04d",
-			 slot->bus, slot->number);
-	else
-		snprintf(slot->hotplug_slot->name, SLOT_NAME_SIZE, "%d",
-			 slot->number);
-}
-
 static int init_slots(struct controller *ctrl)
 {
 	struct slot *slot;
@@ -122,9 +110,13 @@ static int init_slots(struct controller *ctrl)
 		if (!slot)
 			goto error;
 
+		slot->name = kzalloc(SLOT_NAME_SIZE, GFP_KERNEL);
+		if (!slot->name)
+			goto error_slot;
+
 		hotplug_slot = kzalloc(sizeof(*hotplug_slot), GFP_KERNEL);
 		if (!hotplug_slot)
-			goto error_slot;
+			goto error_name;
 		slot->hotplug_slot = hotplug_slot;
 
 		info = kzalloc(sizeof(*info), GFP_KERNEL);
@@ -146,7 +138,7 @@ static int init_slots(struct controller *ctrl)
 		/* register this slot with the hotplug pci core */
 		hotplug_slot->private = slot;
 		hotplug_slot->release = &release_slot;
-		make_slot_name(slot);
+		snprintf(slot->name, SLOT_NAME_SIZE, "%d", slot->number);
 		hotplug_slot->ops = &shpchp_hotplug_slot_ops;
 
 		get_power_status(hotplug_slot, &info->power_status);
@@ -161,10 +153,6 @@ static int init_slots(struct controller *ctrl)
 				ctrl->pci_dev->subordinate, slot->device);
 		if (retval) {
 			err("pci_hp_register failed with error %d\n", retval);
-			if (retval == -EEXIST)
-				err("Failed to register slot because of name "
-                                    "collision. Try \'shpchp_slot_with_bus\' "
-				    "module option.\n");
 			goto error_info;
 		}
 
@@ -176,6 +164,8 @@ error_info:
 	kfree(info);
 error_hpslot:
 	kfree(hotplug_slot);
+error_name:
+	kfree(slot->name);
 error_slot:
 	kfree(slot);
 error:
-- 
1.6.0.rc0.g95f8

