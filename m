Return-Path: <linux-kernel-owner+w=401wt.eu-S1756273AbYHFFMY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756273AbYHFFMY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 01:12:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755783AbYHFFLr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 01:11:47 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:20919 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762184AbYHFFLq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 01:11:46 -0400
Date: Tue, 5 Aug 2008 23:11:44 -0600
From: Alex Chiang <achiang@hp.com>
To: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Matthew Wilcox <matthew@wil.cx>, Pierre Ossman <drzeus-list@drzeus.cx>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org
Subject: [PATCH 4/7] PCI hotplug: convert skeleton code to a kmalloc'ed
	slot name
Message-ID: <20080806051144.GE31319@ldl.fc.hp.com>
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

Let's give future implementors a good example to copy from.

Signed-off-by: Alex Chiang <achiang@hp.com>
---
 drivers/pci/hotplug/pcihp_skeleton.c |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/hotplug/pcihp_skeleton.c b/drivers/pci/hotplug/pcihp_skeleton.c
index e3dd6cf..3e53026 100644
--- a/drivers/pci/hotplug/pcihp_skeleton.c
+++ b/drivers/pci/hotplug/pcihp_skeleton.c
@@ -41,7 +41,7 @@ struct slot {
 	u8 number;
 	struct hotplug_slot *hotplug_slot;
 	struct list_head slot_list;
-	char name[SLOT_NAME_SIZE];
+	char *name;
 };
 
 static LIST_HEAD(slot_list);
@@ -232,6 +232,7 @@ static void release_slot(struct hotplug_slot *hotplug_slot)
 	dbg("%s - physical_slot = %s\n", __func__, hotplug_slot->name);
 	kfree(slot->hotplug_slot->info);
 	kfree(slot->hotplug_slot);
+	kfree(slot->name);
 	kfree(slot);
 }
 
@@ -265,9 +266,13 @@ static int __init init_slots(void)
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
@@ -308,6 +313,8 @@ error_info:
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

