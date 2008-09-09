Return-Path: <linux-kernel-owner+w=401wt.eu-S1757342AbYIIKD7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757342AbYIIKD7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 06:03:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755850AbYIIKBA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 06:01:00 -0400
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:40359 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755768AbYIIKA6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 06:00:58 -0400
From: Alex Chiang <achiang@hp.com>
Subject: [PATCH v2 11/13] PCI: SGI Hotplug: stop managing
	bss_hotplug_slot->name
To: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: jbarnes@virtuousgeek.org, kristen.c.accardi@intel.com, jpk@sgi.com,
       Alex Chiang <achiang@hp.com>
Date: Tue, 09 Sep 2008 04:00:57 -0600
Message-ID: <20080909100057.29542.35147.stgit@bob.kio>
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

Update the sn_hp_slot_private_alloc() interface to fill in
the correct name for us, as that function already has all
the parameters needed to determine the name.

Cc: jbarnes@virtuousgeek.org
Cc: kristen.c.accardi@intel.com
Cc: jpk@sgi.com
Signed-off-by: Alex Chiang <achiang@hp.com>
---

 drivers/pci/hotplug/sgi_hotplug.c |   19 ++++++-------------
 1 files changed, 6 insertions(+), 13 deletions(-)

diff --git a/drivers/pci/hotplug/sgi_hotplug.c b/drivers/pci/hotplug/sgi_hotplug.c
index 6d20bbd..d748698 100644
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
@@ -645,16 +640,14 @@ static int sn_hotplug_slot_register(struct pci_bus *pci_bus)
 		}
 
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
 

