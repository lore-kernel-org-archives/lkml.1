Return-Path: <linux-kernel-owner+w=401wt.eu-S1760935AbYG3Ct7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760935AbYG3Ct7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 22:49:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755350AbYG3CpG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 22:45:06 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:43270 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754034AbYG3Cov (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 22:44:51 -0400
Date: Tue, 29 Jul 2008 20:44:50 -0600
From: Alex Chiang <achiang@hp.com>
To: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Matthew Wilcox <matthew@wil.cx>, Pierre Ossman <drzeus-list@drzeus.cx>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org
Subject: [PATCH 2/2] shpchp: Rename duplicate slot name N as N-1, N-2,
	N-M...
Message-ID: <20080730024450.GC4269@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>,
	Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
	Matthew Wilcox <matthew@wil.cx>,
	Pierre Ossman <drzeus-list@drzeus.cx>,
	Jesse Barnes <jbarnes@virtuousgeek.org>,
	LKML <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org
References: <200807241407.18543.jbarnes@virtuousgeek.org> <20080724235127.40bd0ac9@mjolnir.drzeus.cx> <200807241506.58973.jbarnes@virtuousgeek.org> <20080724222914.GG5307@ldl.fc.hp.com> <20080725004926.5f201c70@mjolnir.drzeus.cx> <20080724230827.GA30302@ldl.fc.hp.com> <20080725012916.06679a6d@mjolnir.drzeus.cx> <20080725032909.GA6701@parisc-linux.org> <48895D3C.7040100@jp.fujitsu.com> <20080730023842.GA4269@ldl.fc.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080730023842.GA4269@ldl.fc.hp.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit ef0ff95f136f0f2d035667af5d18b824609de320 introduces the
shpchp_slot_with_bus module parameter, which was intended to help
work around broken firmware that assigns the same name to multiple
slots.

Commit b3bd307c628af2f0a581c42d5d7e4bcdbbf64b6a tells the user to
use the above parameter in the event of a name collision.

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

Signed-off-by: Alex Chiang <achiang@hp.com>
---
 drivers/pci/hotplug/shpchp_core.c |   34 +++++++++++++++-------------------
 1 files changed, 15 insertions(+), 19 deletions(-)

diff --git a/drivers/pci/hotplug/shpchp_core.c b/drivers/pci/hotplug/shpchp_core.c
index a8cbd03..cc38615 100644
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
 
@@ -99,23 +96,13 @@ static void release_slot(struct hotplug_slot *hotplug_slot)
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
 	struct hotplug_slot *hotplug_slot;
 	struct hotplug_slot_info *info;
 	int retval = -ENOMEM;
-	int i;
+	int i, len, dup = 1;
 
 	for (i = 0; i < ctrl->num_slots; i++) {
 		slot = kzalloc(sizeof(*slot), GFP_KERNEL);
@@ -146,7 +133,7 @@ static int init_slots(struct controller *ctrl)
 		/* register this slot with the hotplug pci core */
 		hotplug_slot->private = slot;
 		hotplug_slot->release = &release_slot;
-		make_slot_name(slot);
+		snprintf(slot->name, SLOT_NAME_SIZE, "%d", slot->number);
 		hotplug_slot->ops = &shpchp_hotplug_slot_ops;
 
 		get_power_status(hotplug_slot, &info->power_status);
@@ -157,14 +144,23 @@ static int init_slots(struct controller *ctrl)
 		dbg("Registering bus=%x dev=%x hp_slot=%x sun=%x "
 		    "slot_device_offset=%x\n", slot->bus, slot->device,
 		    slot->hp_slot, slot->number, ctrl->slot_device_offset);
+duplicate_name:
 		retval = pci_hp_register(slot->hotplug_slot,
 				ctrl->pci_dev->subordinate, slot->device);
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
-                                    "collision. Try \'shpchp_slot_with_bus\' "
-				    "module option.\n");
 			goto error_info;
 		}
 
-- 
1.6.0.rc0.g95f8

