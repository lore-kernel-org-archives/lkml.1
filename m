Return-Path: <linux-kernel-owner+w=401wt.eu-S1763303AbYHFFLg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763303AbYHFFLg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 01:11:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757501AbYHFFLO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 01:11:14 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:11737 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756917AbYHFFLM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 01:11:12 -0400
Date: Tue, 5 Aug 2008 23:11:11 -0600
From: Alex Chiang <achiang@hp.com>
To: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Matthew Wilcox <matthew@wil.cx>, Pierre Ossman <drzeus-list@drzeus.cx>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org
Subject: [PATCH 2/7] fakephp: convert to a kmalloc'ed slot name
Message-ID: <20080806051111.GC31319@ldl.fc.hp.com>
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

Signed-off-by: Alex Chiang <achiang@hp.com>
---
 drivers/pci/hotplug/fakephp.c |   15 ++++++++++++---
 1 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/pci/hotplug/fakephp.c b/drivers/pci/hotplug/fakephp.c
index 40337a0..af8a1bf 100644
--- a/drivers/pci/hotplug/fakephp.c
+++ b/drivers/pci/hotplug/fakephp.c
@@ -60,13 +60,15 @@
 #define DRIVER_AUTHOR	"Greg Kroah-Hartman <greg@kroah.com>"
 #define DRIVER_DESC	"Fake PCI Hot Plug Controller Driver"
 
+#define SLOT_NAME_SIZE	8
+
 struct dummy_slot {
 	struct list_head node;
 	struct hotplug_slot *slot;
 	struct pci_dev *dev;
 	struct work_struct remove_work;
 	unsigned long removed;
-	char name[8];
+	char *name;
 };
 
 static int debug;
@@ -91,6 +93,7 @@ static void dummy_release(struct hotplug_slot *slot)
 
 	list_del(&dslot->node);
 	kfree(dslot->slot->info);
+	kfree(dslot->name);
 	kfree(dslot->slot);
 	pci_dev_put(dslot->dev);
 	kfree(dslot);
@@ -119,8 +122,12 @@ static int add_slot(struct pci_dev *dev)
 	if (!dslot)
 		goto error_info;
 
+	dslot->name = kzalloc(SLOT_NAME_SIZE, GFP_KERNEL);
+	if (!dslot->name)
+		goto error_dslot;
+
 	slot->name = dslot->name;
-	snprintf(slot->name, sizeof(dslot->name), "fake%d", count++);
+	snprintf(slot->name, SLOT_NAME_SIZE, "fake%d", count++);
 	dbg("slot->name = %s\n", slot->name);
 	slot->ops = &dummy_hotplug_slot_ops;
 	slot->release = &dummy_release;
@@ -129,7 +136,7 @@ static int add_slot(struct pci_dev *dev)
 	retval = pci_hp_register(slot, dev->bus, PCI_SLOT(dev->devfn));
 	if (retval) {
 		err("pci_hp_register failed with error %d\n", retval);
-		goto error_dslot;
+		goto error_name;
 	}
 
 	dslot->slot = slot;
@@ -137,6 +144,8 @@ static int add_slot(struct pci_dev *dev)
 	list_add (&dslot->node, &slot_list);
 	return retval;
 
+error_name:
+	kfree(dslot->name);
 error_dslot:
 	kfree(dslot);
 error_info:
-- 
1.6.0.rc0.g95f8

