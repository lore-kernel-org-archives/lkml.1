Return-Path: <linux-kernel-owner+w=401wt.eu-S1756523AbYHQATi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756523AbYHQATi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2008 20:19:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755781AbYHQARl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Aug 2008 20:17:41 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:47088 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755337AbYHQARk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2008 20:17:40 -0400
From: Alex Chiang <achiang@hp.com>
Subject: [PATCH 11/13] PCI: SGI Hotplug: stop managing bss_hotplug_slot->name
To: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Cc: jbarnes@virtuousgeek.org, kristen.c.accardi@intel.com, jpk@sgi.com,
       Alex Chiang <achiang@hp.com>
Date: Sat, 16 Aug 2008 18:17:38 -0600
Message-ID: <20080817001736.5461.64676.stgit@blender.achiang>
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

We no longer need to manage our version of hotplug_slot->name
since the PCI and hotplug core manage it on our behalf.

Update the sn_hp_slot_private_alloc() interface to fill in
the correct name for us, as that function already has all
the parameters needed to determine the name.

Cc: jbarnes@virtuousgeek.org
Cc: kristen.c.accardi@intel.com
Cc: jpk@sgi.com
Signed-off-by: Alex Chiang <achiang@hp.com>
---

 drivers/pci/hotplug/sgi_hotplug.c |   20 +++++++-------------
 1 files changed, 7 insertions(+), 13 deletions(-)

diff --git a/drivers/pci/hotplug/sgi_hotplug.c b/drivers/pci/hotplug/sgi_hotplug.c
index 6d20bbd..beee578 100644
--- a/drivers/pci/hotplug/sgi_hotplug.c
+++ b/drivers/pci/hotplug/sgi_hotplug.c
@@ -161,7 +161,8 @@ static int sn_pci_bus_valid(struct pci_bus *pci_bus)
 }
 
 static int sn_hp_slot_private_alloc(struct hotplug_slot *bss_hotplug_slot,
-				    struct pci_bus *pci_bus, int device)
+				    struct pci_bus *pci_bus, int device,
+				    char *name)
 {
 	struct pcibus_info *pcibus_info;
 	struct slot *slot;
@@ -173,15 +174,9 @@ static int sn_hp_slot_private_alloc(struct hotplug_slot *bss_hotplug_slot,
 		return -ENOMEM;
 	bss_hotplug_slot->private = slot;
 
-	bss_hotplug_slot->name = kmalloc(SN_SLOT_NAME_SIZE, GFP_KERNEL);
-	if (!bss_hotplug_slot->name) {
-		kfree(bss_hotplug_slot->private);
-		return -ENOMEM;
-	}
-
 	slot->device_num = device;
 	slot->pci_bus = pci_bus;
-	sprintf(bss_hotplug_slot->name, "%04x:%02x:%02x",
+	sprintf(name, "%04x:%02x:%02x",
 		pci_domain_nr(pci_bus),
 		((u16)pcibus_info->pbi_buscommon.bs_persist_busnum),
 		device + 1);
@@ -608,7 +603,6 @@ static inline int get_power_status(struct hotplug_slot *bss_hotplug_slot,
 static void sn_release_slot(struct hotplug_slot *bss_hotplug_slot)
 {
 	kfree(bss_hotplug_slot->info);
-	kfree(bss_hotplug_slot->name);
 	kfree(bss_hotplug_slot->private);
 	kfree(bss_hotplug_slot);
 }
@@ -618,6 +612,7 @@ static int sn_hotplug_slot_register(struct pci_bus *pci_bus)
 	int device;
 	struct pci_slot *pci_slot;
 	struct hotplug_slot *bss_hotplug_slot;
+	char name[SN_SLOT_NAME_SIZE];
 	int rc = 0;
 
 	/*
@@ -644,17 +639,16 @@ static int sn_hotplug_slot_register(struct pci_bus *pci_bus)
 			goto alloc_err;
 		}
 
+		memset(name, 0, SN_SLOT_NAME_SIZE);
 		if (sn_hp_slot_private_alloc(bss_hotplug_slot,
-					     pci_bus, device)) {
+					     pci_bus, device, name)) {
 			rc = -ENOMEM;
 			goto alloc_err;
 		}
-
 		bss_hotplug_slot->ops = &sn_hotplug_slot_ops;
 		bss_hotplug_slot->release = &sn_release_slot;
 
-		rc = pci_hp_register(bss_hotplug_slot, pci_bus, device,
-				     bss_hotplug_slot->name);
+		rc = pci_hp_register(bss_hotplug_slot, pci_bus, device, name);
 		if (rc)
 			goto register_err;
 

