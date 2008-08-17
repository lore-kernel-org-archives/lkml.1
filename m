Return-Path: <linux-kernel-owner+w=401wt.eu-S1755217AbYHQARw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755217AbYHQARw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2008 20:17:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752901AbYHQARO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Aug 2008 20:17:14 -0400
Received: from g4t0017.houston.hp.com ([15.201.24.20]:13102 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755179AbYHQARM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2008 20:17:12 -0400
From: Alex Chiang <achiang@hp.com>
Subject: [PATCH 07/13] PCI: fakephp: remove 'name' parameter
To: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Cc: jbarnes@virtuousgeek.org, kristen.c.accardi@intel.com,
       Alex Chiang <achiang@hp.com>
Date: Sat, 16 Aug 2008 18:17:11 -0600
Message-ID: <20080817001657.5461.79197.stgit@blender.achiang>
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

Remove 'name' from fakephp's struct dummy_slot, as the PCI core
will now manage our slot name for us.

Cc: jbarnes@virtuousgeek.org
Cc: kristen.c.accardi@intel.com
Signed-off-by: Alex Chiang <achiang@hp.com>
---

 drivers/pci/hotplug/fakephp.c |   20 +++++++++++---------
 1 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/pci/hotplug/fakephp.c b/drivers/pci/hotplug/fakephp.c
index f1c1817..3a02016 100644
--- a/drivers/pci/hotplug/fakephp.c
+++ b/drivers/pci/hotplug/fakephp.c
@@ -66,7 +66,6 @@ struct dummy_slot {
 	struct pci_dev *dev;
 	struct work_struct remove_work;
 	unsigned long removed;
-	char name[8];
 };
 
 static int debug;
@@ -96,10 +95,13 @@ static void dummy_release(struct hotplug_slot *slot)
 	kfree(dslot);
 }
 
+#define SLOT_NAME_SIZE	8
+
 static int add_slot(struct pci_dev *dev)
 {
 	struct dummy_slot *dslot;
 	struct hotplug_slot *slot;
+	char name[SLOT_NAME_SIZE];
 	int retval = -ENOMEM;
 	static int count = 1;
 
@@ -119,15 +121,14 @@ static int add_slot(struct pci_dev *dev)
 	if (!dslot)
 		goto error_info;
 
-	slot->name = dslot->name;
-	snprintf(slot->name, sizeof(dslot->name), "fake%d", count++);
-	dbg("slot->name = %s\n", slot->name);
+	memset(name, 0, SLOT_NAME_SIZE);
+	snprintf(name, SLOT_NAME_SIZE, "fake%d", count++);
+	dbg("slot->name = %s\n", name);
 	slot->ops = &dummy_hotplug_slot_ops;
 	slot->release = &dummy_release;
 	slot->private = dslot;
 
-	retval = pci_hp_register(slot, dev->bus, PCI_SLOT(dev->devfn),
-				 slot->name);
+	retval = pci_hp_register(slot, dev->bus, PCI_SLOT(dev->devfn), name);
 	if (retval) {
 		err("pci_hp_register failed with error %d\n", retval);
 		goto error_dslot;
@@ -168,10 +169,11 @@ static void remove_slot(struct dummy_slot *dslot)
 {
 	int retval;
 
-	dbg("removing slot %s\n", dslot->slot->name);
+	dbg("removing slot %s\n", hotplug_slot_name(dslot->slot));
 	retval = pci_hp_deregister(dslot->slot);
 	if (retval)
-		err("Problem unregistering a slot %s\n", dslot->slot->name);
+		err("Problem unregistering a slot %s\n",
+			hotplug_slot_name(dslot->slot));
 }
 
 /* called from the single-threaded workqueue handler to remove a slot */
@@ -309,7 +311,7 @@ static int disable_slot(struct hotplug_slot *slot)
 		return -ENODEV;
 	dslot = slot->private;
 
-	dbg("%s - physical_slot = %s\n", __func__, slot->name);
+	dbg("%s - physical_slot = %s\n", __func__, hotplug_slot_name(slot));
 
 	for (func = 7; func >= 0; func--) {
 		dev = pci_get_slot(dslot->dev->bus, dslot->dev->devfn + func);

